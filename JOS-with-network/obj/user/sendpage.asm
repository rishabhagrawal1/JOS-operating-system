
obj/user/sendpage.debug:     file format elf64-x86-64


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
  80003c:	e8 66 02 00 00       	callq  8002a7 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	envid_t who;

	if ((who = fork()) == 0) {
  800052:	48 b8 7e 20 80 00 00 	movabs $0x80207e,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800061:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800064:	85 c0                	test   %eax,%eax
  800066:	0f 85 09 01 00 00    	jne    800175 <umain+0x132>
		// Child
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  80006c:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
  800070:	ba 00 00 00 00       	mov    $0x0,%edx
  800075:	be 00 00 b0 00       	mov    $0xb00000,%esi
  80007a:	48 89 c7             	mov    %rax,%rdi
  80007d:	48 b8 2f 23 80 00 00 	movabs $0x80232f,%rax
  800084:	00 00 00 
  800087:	ff d0                	callq  *%rax
		cprintf("%x got message : %s\n", who, TEMP_ADDR_CHILD);
  800089:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008c:	ba 00 00 b0 00       	mov    $0xb00000,%edx
  800091:	89 c6                	mov    %eax,%esi
  800093:	48 bf ec 48 80 00 00 	movabs $0x8048ec,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	48 b9 7a 04 80 00 00 	movabs $0x80047a,%rcx
  8000a9:	00 00 00 
  8000ac:	ff d1                	callq  *%rcx
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  8000ae:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8000b5:	00 00 00 
  8000b8:	48 8b 00             	mov    (%rax),%rax
  8000bb:	48 89 c7             	mov    %rax,%rdi
  8000be:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	48 63 d0             	movslq %eax,%rdx
  8000cd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8000d4:	00 00 00 
  8000d7:	48 8b 00             	mov    (%rax),%rax
  8000da:	48 89 c6             	mov    %rax,%rsi
  8000dd:	bf 00 00 b0 00       	mov    $0xb00000,%edi
  8000e2:	48 b8 e4 11 80 00 00 	movabs $0x8011e4,%rax
  8000e9:	00 00 00 
  8000ec:	ff d0                	callq  *%rax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	75 1b                	jne    80010d <umain+0xca>
			cprintf("child received correct message\n");
  8000f2:	48 bf 08 49 80 00 00 	movabs $0x804908,%rdi
  8000f9:	00 00 00 
  8000fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800101:	48 ba 7a 04 80 00 00 	movabs $0x80047a,%rdx
  800108:	00 00 00 
  80010b:	ff d2                	callq  *%rdx

		memcpy(TEMP_ADDR_CHILD, str2, strlen(str1) + 1);
  80010d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800114:	00 00 00 
  800117:	48 8b 00             	mov    (%rax),%rax
  80011a:	48 89 c7             	mov    %rax,%rdi
  80011d:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  800124:	00 00 00 
  800127:	ff d0                	callq  *%rax
  800129:	83 c0 01             	add    $0x1,%eax
  80012c:	48 63 d0             	movslq %eax,%rdx
  80012f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800136:	00 00 00 
  800139:	48 8b 00             	mov    (%rax),%rax
  80013c:	48 89 c6             	mov    %rax,%rsi
  80013f:	bf 00 00 b0 00       	mov    $0xb00000,%edi
  800144:	48 b8 6a 14 80 00 00 	movabs $0x80146a,%rax
  80014b:	00 00 00 
  80014e:	ff d0                	callq  *%rax
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800150:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800153:	b9 07 00 00 00       	mov    $0x7,%ecx
  800158:	ba 00 00 b0 00       	mov    $0xb00000,%edx
  80015d:	be 00 00 00 00       	mov    $0x0,%esi
  800162:	89 c7                	mov    %eax,%edi
  800164:	48 b8 35 24 80 00 00 	movabs $0x802435,%rax
  80016b:	00 00 00 
  80016e:	ff d0                	callq  *%rax
		return;
  800170:	e9 30 01 00 00       	jmpq   8002a5 <umain+0x262>
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800175:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80017c:	00 00 00 
  80017f:	48 8b 00             	mov    (%rax),%rax
  800182:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800188:	ba 07 00 00 00       	mov    $0x7,%edx
  80018d:	be 00 00 a0 00       	mov    $0xa00000,%esi
  800192:	89 c7                	mov    %eax,%edi
  800194:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  80019b:	00 00 00 
  80019e:	ff d0                	callq  *%rax
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  8001a0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8001a7:	00 00 00 
  8001aa:	48 8b 00             	mov    (%rax),%rax
  8001ad:	48 89 c7             	mov    %rax,%rdi
  8001b0:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  8001b7:	00 00 00 
  8001ba:	ff d0                	callq  *%rax
  8001bc:	83 c0 01             	add    $0x1,%eax
  8001bf:	48 63 d0             	movslq %eax,%rdx
  8001c2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8001c9:	00 00 00 
  8001cc:	48 8b 00             	mov    (%rax),%rax
  8001cf:	48 89 c6             	mov    %rax,%rsi
  8001d2:	bf 00 00 a0 00       	mov    $0xa00000,%edi
  8001d7:	48 b8 6a 14 80 00 00 	movabs $0x80146a,%rax
  8001de:	00 00 00 
  8001e1:	ff d0                	callq  *%rax
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  8001e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001e6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8001eb:	ba 00 00 a0 00       	mov    $0xa00000,%edx
  8001f0:	be 00 00 00 00       	mov    $0x0,%esi
  8001f5:	89 c7                	mov    %eax,%edi
  8001f7:	48 b8 35 24 80 00 00 	movabs $0x802435,%rax
  8001fe:	00 00 00 
  800201:	ff d0                	callq  *%rax

	ipc_recv(&who, TEMP_ADDR, 0);
  800203:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
  800207:	ba 00 00 00 00       	mov    $0x0,%edx
  80020c:	be 00 00 a0 00       	mov    $0xa00000,%esi
  800211:	48 89 c7             	mov    %rax,%rdi
  800214:	48 b8 2f 23 80 00 00 	movabs $0x80232f,%rax
  80021b:	00 00 00 
  80021e:	ff d0                	callq  *%rax
	cprintf("%x got message : %s\n", who, TEMP_ADDR);
  800220:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800223:	ba 00 00 a0 00       	mov    $0xa00000,%edx
  800228:	89 c6                	mov    %eax,%esi
  80022a:	48 bf ec 48 80 00 00 	movabs $0x8048ec,%rdi
  800231:	00 00 00 
  800234:	b8 00 00 00 00       	mov    $0x0,%eax
  800239:	48 b9 7a 04 80 00 00 	movabs $0x80047a,%rcx
  800240:	00 00 00 
  800243:	ff d1                	callq  *%rcx
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  800245:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80024c:	00 00 00 
  80024f:	48 8b 00             	mov    (%rax),%rax
  800252:	48 89 c7             	mov    %rax,%rdi
  800255:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  80025c:	00 00 00 
  80025f:	ff d0                	callq  *%rax
  800261:	48 63 d0             	movslq %eax,%rdx
  800264:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80026b:	00 00 00 
  80026e:	48 8b 00             	mov    (%rax),%rax
  800271:	48 89 c6             	mov    %rax,%rsi
  800274:	bf 00 00 a0 00       	mov    $0xa00000,%edi
  800279:	48 b8 e4 11 80 00 00 	movabs $0x8011e4,%rax
  800280:	00 00 00 
  800283:	ff d0                	callq  *%rax
  800285:	85 c0                	test   %eax,%eax
  800287:	75 1b                	jne    8002a4 <umain+0x261>
		cprintf("parent received correct message\n");
  800289:	48 bf 28 49 80 00 00 	movabs $0x804928,%rdi
  800290:	00 00 00 
  800293:	b8 00 00 00 00       	mov    $0x0,%eax
  800298:	48 ba 7a 04 80 00 00 	movabs $0x80047a,%rdx
  80029f:	00 00 00 
  8002a2:	ff d2                	callq  *%rdx
	return;
  8002a4:	90                   	nop
}
  8002a5:	c9                   	leaveq 
  8002a6:	c3                   	retq   

00000000008002a7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002a7:	55                   	push   %rbp
  8002a8:	48 89 e5             	mov    %rsp,%rbp
  8002ab:	48 83 ec 10          	sub    $0x10,%rsp
  8002af:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002b6:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  8002bd:	00 00 00 
  8002c0:	ff d0                	callq  *%rax
  8002c2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002c7:	48 63 d0             	movslq %eax,%rdx
  8002ca:	48 89 d0             	mov    %rdx,%rax
  8002cd:	48 c1 e0 03          	shl    $0x3,%rax
  8002d1:	48 01 d0             	add    %rdx,%rax
  8002d4:	48 c1 e0 05          	shl    $0x5,%rax
  8002d8:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8002df:	00 00 00 
  8002e2:	48 01 c2             	add    %rax,%rdx
  8002e5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8002ec:	00 00 00 
  8002ef:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002f6:	7e 14                	jle    80030c <libmain+0x65>
		binaryname = argv[0];
  8002f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002fc:	48 8b 10             	mov    (%rax),%rdx
  8002ff:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800306:	00 00 00 
  800309:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80030c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800310:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800313:	48 89 d6             	mov    %rdx,%rsi
  800316:	89 c7                	mov    %eax,%edi
  800318:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80031f:	00 00 00 
  800322:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800324:	48 b8 32 03 80 00 00 	movabs $0x800332,%rax
  80032b:	00 00 00 
  80032e:	ff d0                	callq  *%rax
}
  800330:	c9                   	leaveq 
  800331:	c3                   	retq   

0000000000800332 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800332:	55                   	push   %rbp
  800333:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800336:	48 b8 5a 28 80 00 00 	movabs $0x80285a,%rax
  80033d:	00 00 00 
  800340:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800342:	bf 00 00 00 00       	mov    $0x0,%edi
  800347:	48 b8 9e 18 80 00 00 	movabs $0x80189e,%rax
  80034e:	00 00 00 
  800351:	ff d0                	callq  *%rax

}
  800353:	5d                   	pop    %rbp
  800354:	c3                   	retq   

0000000000800355 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800355:	55                   	push   %rbp
  800356:	48 89 e5             	mov    %rsp,%rbp
  800359:	48 83 ec 10          	sub    $0x10,%rsp
  80035d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800360:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800364:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800368:	8b 00                	mov    (%rax),%eax
  80036a:	8d 48 01             	lea    0x1(%rax),%ecx
  80036d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800371:	89 0a                	mov    %ecx,(%rdx)
  800373:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800376:	89 d1                	mov    %edx,%ecx
  800378:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80037c:	48 98                	cltq   
  80037e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800382:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800386:	8b 00                	mov    (%rax),%eax
  800388:	3d ff 00 00 00       	cmp    $0xff,%eax
  80038d:	75 2c                	jne    8003bb <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80038f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800393:	8b 00                	mov    (%rax),%eax
  800395:	48 98                	cltq   
  800397:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80039b:	48 83 c2 08          	add    $0x8,%rdx
  80039f:	48 89 c6             	mov    %rax,%rsi
  8003a2:	48 89 d7             	mov    %rdx,%rdi
  8003a5:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  8003ac:	00 00 00 
  8003af:	ff d0                	callq  *%rax
        b->idx = 0;
  8003b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003bf:	8b 40 04             	mov    0x4(%rax),%eax
  8003c2:	8d 50 01             	lea    0x1(%rax),%edx
  8003c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c9:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003cc:	c9                   	leaveq 
  8003cd:	c3                   	retq   

00000000008003ce <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003ce:	55                   	push   %rbp
  8003cf:	48 89 e5             	mov    %rsp,%rbp
  8003d2:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003d9:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003e0:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003e7:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003ee:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003f5:	48 8b 0a             	mov    (%rdx),%rcx
  8003f8:	48 89 08             	mov    %rcx,(%rax)
  8003fb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003ff:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800403:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800407:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80040b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800412:	00 00 00 
    b.cnt = 0;
  800415:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80041c:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80041f:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800426:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80042d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800434:	48 89 c6             	mov    %rax,%rsi
  800437:	48 bf 55 03 80 00 00 	movabs $0x800355,%rdi
  80043e:	00 00 00 
  800441:	48 b8 2d 08 80 00 00 	movabs $0x80082d,%rax
  800448:	00 00 00 
  80044b:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80044d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800453:	48 98                	cltq   
  800455:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80045c:	48 83 c2 08          	add    $0x8,%rdx
  800460:	48 89 c6             	mov    %rax,%rsi
  800463:	48 89 d7             	mov    %rdx,%rdi
  800466:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  80046d:	00 00 00 
  800470:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800472:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800478:	c9                   	leaveq 
  800479:	c3                   	retq   

000000000080047a <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80047a:	55                   	push   %rbp
  80047b:	48 89 e5             	mov    %rsp,%rbp
  80047e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800485:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80048c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800493:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80049a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004a1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004a8:	84 c0                	test   %al,%al
  8004aa:	74 20                	je     8004cc <cprintf+0x52>
  8004ac:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004b0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004b4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004b8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004bc:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004c0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004c4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004c8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004cc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004d3:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004da:	00 00 00 
  8004dd:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004e4:	00 00 00 
  8004e7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004eb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004f2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004f9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800500:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800507:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80050e:	48 8b 0a             	mov    (%rdx),%rcx
  800511:	48 89 08             	mov    %rcx,(%rax)
  800514:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800518:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80051c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800520:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800524:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80052b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800532:	48 89 d6             	mov    %rdx,%rsi
  800535:	48 89 c7             	mov    %rax,%rdi
  800538:	48 b8 ce 03 80 00 00 	movabs $0x8003ce,%rax
  80053f:	00 00 00 
  800542:	ff d0                	callq  *%rax
  800544:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80054a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800550:	c9                   	leaveq 
  800551:	c3                   	retq   

0000000000800552 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800552:	55                   	push   %rbp
  800553:	48 89 e5             	mov    %rsp,%rbp
  800556:	53                   	push   %rbx
  800557:	48 83 ec 38          	sub    $0x38,%rsp
  80055b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80055f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800563:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800567:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80056a:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80056e:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800572:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800575:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800579:	77 3b                	ja     8005b6 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80057b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80057e:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800582:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800585:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800589:	ba 00 00 00 00       	mov    $0x0,%edx
  80058e:	48 f7 f3             	div    %rbx
  800591:	48 89 c2             	mov    %rax,%rdx
  800594:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800597:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80059a:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80059e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a2:	41 89 f9             	mov    %edi,%r9d
  8005a5:	48 89 c7             	mov    %rax,%rdi
  8005a8:	48 b8 52 05 80 00 00 	movabs $0x800552,%rax
  8005af:	00 00 00 
  8005b2:	ff d0                	callq  *%rax
  8005b4:	eb 1e                	jmp    8005d4 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005b6:	eb 12                	jmp    8005ca <printnum+0x78>
			putch(padc, putdat);
  8005b8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005bc:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c3:	48 89 ce             	mov    %rcx,%rsi
  8005c6:	89 d7                	mov    %edx,%edi
  8005c8:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005ca:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005ce:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005d2:	7f e4                	jg     8005b8 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005d4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005db:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e0:	48 f7 f1             	div    %rcx
  8005e3:	48 89 d0             	mov    %rdx,%rax
  8005e6:	48 ba 50 4b 80 00 00 	movabs $0x804b50,%rdx
  8005ed:	00 00 00 
  8005f0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8005f4:	0f be d0             	movsbl %al,%edx
  8005f7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ff:	48 89 ce             	mov    %rcx,%rsi
  800602:	89 d7                	mov    %edx,%edi
  800604:	ff d0                	callq  *%rax
}
  800606:	48 83 c4 38          	add    $0x38,%rsp
  80060a:	5b                   	pop    %rbx
  80060b:	5d                   	pop    %rbp
  80060c:	c3                   	retq   

000000000080060d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80060d:	55                   	push   %rbp
  80060e:	48 89 e5             	mov    %rsp,%rbp
  800611:	48 83 ec 1c          	sub    $0x1c,%rsp
  800615:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800619:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80061c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800620:	7e 52                	jle    800674 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800622:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800626:	8b 00                	mov    (%rax),%eax
  800628:	83 f8 30             	cmp    $0x30,%eax
  80062b:	73 24                	jae    800651 <getuint+0x44>
  80062d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800631:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800635:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800639:	8b 00                	mov    (%rax),%eax
  80063b:	89 c0                	mov    %eax,%eax
  80063d:	48 01 d0             	add    %rdx,%rax
  800640:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800644:	8b 12                	mov    (%rdx),%edx
  800646:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800649:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80064d:	89 0a                	mov    %ecx,(%rdx)
  80064f:	eb 17                	jmp    800668 <getuint+0x5b>
  800651:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800655:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800659:	48 89 d0             	mov    %rdx,%rax
  80065c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800660:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800664:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800668:	48 8b 00             	mov    (%rax),%rax
  80066b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80066f:	e9 a3 00 00 00       	jmpq   800717 <getuint+0x10a>
	else if (lflag)
  800674:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800678:	74 4f                	je     8006c9 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80067a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067e:	8b 00                	mov    (%rax),%eax
  800680:	83 f8 30             	cmp    $0x30,%eax
  800683:	73 24                	jae    8006a9 <getuint+0x9c>
  800685:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800689:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80068d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800691:	8b 00                	mov    (%rax),%eax
  800693:	89 c0                	mov    %eax,%eax
  800695:	48 01 d0             	add    %rdx,%rax
  800698:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80069c:	8b 12                	mov    (%rdx),%edx
  80069e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a5:	89 0a                	mov    %ecx,(%rdx)
  8006a7:	eb 17                	jmp    8006c0 <getuint+0xb3>
  8006a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ad:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b1:	48 89 d0             	mov    %rdx,%rax
  8006b4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006bc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c0:	48 8b 00             	mov    (%rax),%rax
  8006c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006c7:	eb 4e                	jmp    800717 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cd:	8b 00                	mov    (%rax),%eax
  8006cf:	83 f8 30             	cmp    $0x30,%eax
  8006d2:	73 24                	jae    8006f8 <getuint+0xeb>
  8006d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e0:	8b 00                	mov    (%rax),%eax
  8006e2:	89 c0                	mov    %eax,%eax
  8006e4:	48 01 d0             	add    %rdx,%rax
  8006e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006eb:	8b 12                	mov    (%rdx),%edx
  8006ed:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f4:	89 0a                	mov    %ecx,(%rdx)
  8006f6:	eb 17                	jmp    80070f <getuint+0x102>
  8006f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800700:	48 89 d0             	mov    %rdx,%rax
  800703:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800707:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80070f:	8b 00                	mov    (%rax),%eax
  800711:	89 c0                	mov    %eax,%eax
  800713:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800717:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80071b:	c9                   	leaveq 
  80071c:	c3                   	retq   

000000000080071d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80071d:	55                   	push   %rbp
  80071e:	48 89 e5             	mov    %rsp,%rbp
  800721:	48 83 ec 1c          	sub    $0x1c,%rsp
  800725:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800729:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80072c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800730:	7e 52                	jle    800784 <getint+0x67>
		x=va_arg(*ap, long long);
  800732:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800736:	8b 00                	mov    (%rax),%eax
  800738:	83 f8 30             	cmp    $0x30,%eax
  80073b:	73 24                	jae    800761 <getint+0x44>
  80073d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800741:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800745:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800749:	8b 00                	mov    (%rax),%eax
  80074b:	89 c0                	mov    %eax,%eax
  80074d:	48 01 d0             	add    %rdx,%rax
  800750:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800754:	8b 12                	mov    (%rdx),%edx
  800756:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800759:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075d:	89 0a                	mov    %ecx,(%rdx)
  80075f:	eb 17                	jmp    800778 <getint+0x5b>
  800761:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800765:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800769:	48 89 d0             	mov    %rdx,%rax
  80076c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800770:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800774:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800778:	48 8b 00             	mov    (%rax),%rax
  80077b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80077f:	e9 a3 00 00 00       	jmpq   800827 <getint+0x10a>
	else if (lflag)
  800784:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800788:	74 4f                	je     8007d9 <getint+0xbc>
		x=va_arg(*ap, long);
  80078a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078e:	8b 00                	mov    (%rax),%eax
  800790:	83 f8 30             	cmp    $0x30,%eax
  800793:	73 24                	jae    8007b9 <getint+0x9c>
  800795:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800799:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80079d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a1:	8b 00                	mov    (%rax),%eax
  8007a3:	89 c0                	mov    %eax,%eax
  8007a5:	48 01 d0             	add    %rdx,%rax
  8007a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ac:	8b 12                	mov    (%rdx),%edx
  8007ae:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b5:	89 0a                	mov    %ecx,(%rdx)
  8007b7:	eb 17                	jmp    8007d0 <getint+0xb3>
  8007b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007c1:	48 89 d0             	mov    %rdx,%rax
  8007c4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007cc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007d0:	48 8b 00             	mov    (%rax),%rax
  8007d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007d7:	eb 4e                	jmp    800827 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007dd:	8b 00                	mov    (%rax),%eax
  8007df:	83 f8 30             	cmp    $0x30,%eax
  8007e2:	73 24                	jae    800808 <getint+0xeb>
  8007e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f0:	8b 00                	mov    (%rax),%eax
  8007f2:	89 c0                	mov    %eax,%eax
  8007f4:	48 01 d0             	add    %rdx,%rax
  8007f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007fb:	8b 12                	mov    (%rdx),%edx
  8007fd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800800:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800804:	89 0a                	mov    %ecx,(%rdx)
  800806:	eb 17                	jmp    80081f <getint+0x102>
  800808:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800810:	48 89 d0             	mov    %rdx,%rax
  800813:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800817:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80081f:	8b 00                	mov    (%rax),%eax
  800821:	48 98                	cltq   
  800823:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800827:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80082b:	c9                   	leaveq 
  80082c:	c3                   	retq   

000000000080082d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80082d:	55                   	push   %rbp
  80082e:	48 89 e5             	mov    %rsp,%rbp
  800831:	41 54                	push   %r12
  800833:	53                   	push   %rbx
  800834:	48 83 ec 60          	sub    $0x60,%rsp
  800838:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80083c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800840:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800844:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800848:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80084c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800850:	48 8b 0a             	mov    (%rdx),%rcx
  800853:	48 89 08             	mov    %rcx,(%rax)
  800856:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80085a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80085e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800862:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800866:	eb 17                	jmp    80087f <vprintfmt+0x52>
			if (ch == '\0')
  800868:	85 db                	test   %ebx,%ebx
  80086a:	0f 84 cc 04 00 00    	je     800d3c <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800870:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800874:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800878:	48 89 d6             	mov    %rdx,%rsi
  80087b:	89 df                	mov    %ebx,%edi
  80087d:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80087f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800883:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800887:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80088b:	0f b6 00             	movzbl (%rax),%eax
  80088e:	0f b6 d8             	movzbl %al,%ebx
  800891:	83 fb 25             	cmp    $0x25,%ebx
  800894:	75 d2                	jne    800868 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800896:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80089a:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008a1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008a8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008af:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008b6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008ba:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008be:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008c2:	0f b6 00             	movzbl (%rax),%eax
  8008c5:	0f b6 d8             	movzbl %al,%ebx
  8008c8:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008cb:	83 f8 55             	cmp    $0x55,%eax
  8008ce:	0f 87 34 04 00 00    	ja     800d08 <vprintfmt+0x4db>
  8008d4:	89 c0                	mov    %eax,%eax
  8008d6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008dd:	00 
  8008de:	48 b8 78 4b 80 00 00 	movabs $0x804b78,%rax
  8008e5:	00 00 00 
  8008e8:	48 01 d0             	add    %rdx,%rax
  8008eb:	48 8b 00             	mov    (%rax),%rax
  8008ee:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8008f0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008f4:	eb c0                	jmp    8008b6 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008f6:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008fa:	eb ba                	jmp    8008b6 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008fc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800903:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800906:	89 d0                	mov    %edx,%eax
  800908:	c1 e0 02             	shl    $0x2,%eax
  80090b:	01 d0                	add    %edx,%eax
  80090d:	01 c0                	add    %eax,%eax
  80090f:	01 d8                	add    %ebx,%eax
  800911:	83 e8 30             	sub    $0x30,%eax
  800914:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800917:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80091b:	0f b6 00             	movzbl (%rax),%eax
  80091e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800921:	83 fb 2f             	cmp    $0x2f,%ebx
  800924:	7e 0c                	jle    800932 <vprintfmt+0x105>
  800926:	83 fb 39             	cmp    $0x39,%ebx
  800929:	7f 07                	jg     800932 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80092b:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800930:	eb d1                	jmp    800903 <vprintfmt+0xd6>
			goto process_precision;
  800932:	eb 58                	jmp    80098c <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800934:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800937:	83 f8 30             	cmp    $0x30,%eax
  80093a:	73 17                	jae    800953 <vprintfmt+0x126>
  80093c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800940:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800943:	89 c0                	mov    %eax,%eax
  800945:	48 01 d0             	add    %rdx,%rax
  800948:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80094b:	83 c2 08             	add    $0x8,%edx
  80094e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800951:	eb 0f                	jmp    800962 <vprintfmt+0x135>
  800953:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800957:	48 89 d0             	mov    %rdx,%rax
  80095a:	48 83 c2 08          	add    $0x8,%rdx
  80095e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800962:	8b 00                	mov    (%rax),%eax
  800964:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800967:	eb 23                	jmp    80098c <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800969:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80096d:	79 0c                	jns    80097b <vprintfmt+0x14e>
				width = 0;
  80096f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800976:	e9 3b ff ff ff       	jmpq   8008b6 <vprintfmt+0x89>
  80097b:	e9 36 ff ff ff       	jmpq   8008b6 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800980:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800987:	e9 2a ff ff ff       	jmpq   8008b6 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80098c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800990:	79 12                	jns    8009a4 <vprintfmt+0x177>
				width = precision, precision = -1;
  800992:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800995:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800998:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80099f:	e9 12 ff ff ff       	jmpq   8008b6 <vprintfmt+0x89>
  8009a4:	e9 0d ff ff ff       	jmpq   8008b6 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009a9:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009ad:	e9 04 ff ff ff       	jmpq   8008b6 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009b2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b5:	83 f8 30             	cmp    $0x30,%eax
  8009b8:	73 17                	jae    8009d1 <vprintfmt+0x1a4>
  8009ba:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009be:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c1:	89 c0                	mov    %eax,%eax
  8009c3:	48 01 d0             	add    %rdx,%rax
  8009c6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009c9:	83 c2 08             	add    $0x8,%edx
  8009cc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009cf:	eb 0f                	jmp    8009e0 <vprintfmt+0x1b3>
  8009d1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009d5:	48 89 d0             	mov    %rdx,%rax
  8009d8:	48 83 c2 08          	add    $0x8,%rdx
  8009dc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009e0:	8b 10                	mov    (%rax),%edx
  8009e2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009e6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ea:	48 89 ce             	mov    %rcx,%rsi
  8009ed:	89 d7                	mov    %edx,%edi
  8009ef:	ff d0                	callq  *%rax
			break;
  8009f1:	e9 40 03 00 00       	jmpq   800d36 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8009f6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f9:	83 f8 30             	cmp    $0x30,%eax
  8009fc:	73 17                	jae    800a15 <vprintfmt+0x1e8>
  8009fe:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a02:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a05:	89 c0                	mov    %eax,%eax
  800a07:	48 01 d0             	add    %rdx,%rax
  800a0a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a0d:	83 c2 08             	add    $0x8,%edx
  800a10:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a13:	eb 0f                	jmp    800a24 <vprintfmt+0x1f7>
  800a15:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a19:	48 89 d0             	mov    %rdx,%rax
  800a1c:	48 83 c2 08          	add    $0x8,%rdx
  800a20:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a24:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a26:	85 db                	test   %ebx,%ebx
  800a28:	79 02                	jns    800a2c <vprintfmt+0x1ff>
				err = -err;
  800a2a:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a2c:	83 fb 15             	cmp    $0x15,%ebx
  800a2f:	7f 16                	jg     800a47 <vprintfmt+0x21a>
  800a31:	48 b8 a0 4a 80 00 00 	movabs $0x804aa0,%rax
  800a38:	00 00 00 
  800a3b:	48 63 d3             	movslq %ebx,%rdx
  800a3e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a42:	4d 85 e4             	test   %r12,%r12
  800a45:	75 2e                	jne    800a75 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a47:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a4b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a4f:	89 d9                	mov    %ebx,%ecx
  800a51:	48 ba 61 4b 80 00 00 	movabs $0x804b61,%rdx
  800a58:	00 00 00 
  800a5b:	48 89 c7             	mov    %rax,%rdi
  800a5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a63:	49 b8 45 0d 80 00 00 	movabs $0x800d45,%r8
  800a6a:	00 00 00 
  800a6d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a70:	e9 c1 02 00 00       	jmpq   800d36 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a75:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a79:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a7d:	4c 89 e1             	mov    %r12,%rcx
  800a80:	48 ba 6a 4b 80 00 00 	movabs $0x804b6a,%rdx
  800a87:	00 00 00 
  800a8a:	48 89 c7             	mov    %rax,%rdi
  800a8d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a92:	49 b8 45 0d 80 00 00 	movabs $0x800d45,%r8
  800a99:	00 00 00 
  800a9c:	41 ff d0             	callq  *%r8
			break;
  800a9f:	e9 92 02 00 00       	jmpq   800d36 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800aa4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa7:	83 f8 30             	cmp    $0x30,%eax
  800aaa:	73 17                	jae    800ac3 <vprintfmt+0x296>
  800aac:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ab0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab3:	89 c0                	mov    %eax,%eax
  800ab5:	48 01 d0             	add    %rdx,%rax
  800ab8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800abb:	83 c2 08             	add    $0x8,%edx
  800abe:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ac1:	eb 0f                	jmp    800ad2 <vprintfmt+0x2a5>
  800ac3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ac7:	48 89 d0             	mov    %rdx,%rax
  800aca:	48 83 c2 08          	add    $0x8,%rdx
  800ace:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ad2:	4c 8b 20             	mov    (%rax),%r12
  800ad5:	4d 85 e4             	test   %r12,%r12
  800ad8:	75 0a                	jne    800ae4 <vprintfmt+0x2b7>
				p = "(null)";
  800ada:	49 bc 6d 4b 80 00 00 	movabs $0x804b6d,%r12
  800ae1:	00 00 00 
			if (width > 0 && padc != '-')
  800ae4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ae8:	7e 3f                	jle    800b29 <vprintfmt+0x2fc>
  800aea:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800aee:	74 39                	je     800b29 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800af0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800af3:	48 98                	cltq   
  800af5:	48 89 c6             	mov    %rax,%rsi
  800af8:	4c 89 e7             	mov    %r12,%rdi
  800afb:	48 b8 f1 0f 80 00 00 	movabs $0x800ff1,%rax
  800b02:	00 00 00 
  800b05:	ff d0                	callq  *%rax
  800b07:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b0a:	eb 17                	jmp    800b23 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b0c:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b10:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b14:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b18:	48 89 ce             	mov    %rcx,%rsi
  800b1b:	89 d7                	mov    %edx,%edi
  800b1d:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b1f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b23:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b27:	7f e3                	jg     800b0c <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b29:	eb 37                	jmp    800b62 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b2b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b2f:	74 1e                	je     800b4f <vprintfmt+0x322>
  800b31:	83 fb 1f             	cmp    $0x1f,%ebx
  800b34:	7e 05                	jle    800b3b <vprintfmt+0x30e>
  800b36:	83 fb 7e             	cmp    $0x7e,%ebx
  800b39:	7e 14                	jle    800b4f <vprintfmt+0x322>
					putch('?', putdat);
  800b3b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b3f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b43:	48 89 d6             	mov    %rdx,%rsi
  800b46:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b4b:	ff d0                	callq  *%rax
  800b4d:	eb 0f                	jmp    800b5e <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b4f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b53:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b57:	48 89 d6             	mov    %rdx,%rsi
  800b5a:	89 df                	mov    %ebx,%edi
  800b5c:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b5e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b62:	4c 89 e0             	mov    %r12,%rax
  800b65:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b69:	0f b6 00             	movzbl (%rax),%eax
  800b6c:	0f be d8             	movsbl %al,%ebx
  800b6f:	85 db                	test   %ebx,%ebx
  800b71:	74 10                	je     800b83 <vprintfmt+0x356>
  800b73:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b77:	78 b2                	js     800b2b <vprintfmt+0x2fe>
  800b79:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b7d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b81:	79 a8                	jns    800b2b <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b83:	eb 16                	jmp    800b9b <vprintfmt+0x36e>
				putch(' ', putdat);
  800b85:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b89:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8d:	48 89 d6             	mov    %rdx,%rsi
  800b90:	bf 20 00 00 00       	mov    $0x20,%edi
  800b95:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b97:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b9b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b9f:	7f e4                	jg     800b85 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800ba1:	e9 90 01 00 00       	jmpq   800d36 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ba6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800baa:	be 03 00 00 00       	mov    $0x3,%esi
  800baf:	48 89 c7             	mov    %rax,%rdi
  800bb2:	48 b8 1d 07 80 00 00 	movabs $0x80071d,%rax
  800bb9:	00 00 00 
  800bbc:	ff d0                	callq  *%rax
  800bbe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bc6:	48 85 c0             	test   %rax,%rax
  800bc9:	79 1d                	jns    800be8 <vprintfmt+0x3bb>
				putch('-', putdat);
  800bcb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bcf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd3:	48 89 d6             	mov    %rdx,%rsi
  800bd6:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bdb:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be1:	48 f7 d8             	neg    %rax
  800be4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800be8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bef:	e9 d5 00 00 00       	jmpq   800cc9 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800bf4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bf8:	be 03 00 00 00       	mov    $0x3,%esi
  800bfd:	48 89 c7             	mov    %rax,%rdi
  800c00:	48 b8 0d 06 80 00 00 	movabs $0x80060d,%rax
  800c07:	00 00 00 
  800c0a:	ff d0                	callq  *%rax
  800c0c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c10:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c17:	e9 ad 00 00 00       	jmpq   800cc9 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800c1c:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800c1f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c23:	89 d6                	mov    %edx,%esi
  800c25:	48 89 c7             	mov    %rax,%rdi
  800c28:	48 b8 1d 07 80 00 00 	movabs $0x80071d,%rax
  800c2f:	00 00 00 
  800c32:	ff d0                	callq  *%rax
  800c34:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800c38:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c3f:	e9 85 00 00 00       	jmpq   800cc9 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800c44:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c48:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4c:	48 89 d6             	mov    %rdx,%rsi
  800c4f:	bf 30 00 00 00       	mov    $0x30,%edi
  800c54:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c56:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c5a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5e:	48 89 d6             	mov    %rdx,%rsi
  800c61:	bf 78 00 00 00       	mov    $0x78,%edi
  800c66:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c68:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c6b:	83 f8 30             	cmp    $0x30,%eax
  800c6e:	73 17                	jae    800c87 <vprintfmt+0x45a>
  800c70:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c74:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c77:	89 c0                	mov    %eax,%eax
  800c79:	48 01 d0             	add    %rdx,%rax
  800c7c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c7f:	83 c2 08             	add    $0x8,%edx
  800c82:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c85:	eb 0f                	jmp    800c96 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800c87:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c8b:	48 89 d0             	mov    %rdx,%rax
  800c8e:	48 83 c2 08          	add    $0x8,%rdx
  800c92:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c96:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c99:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c9d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ca4:	eb 23                	jmp    800cc9 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ca6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800caa:	be 03 00 00 00       	mov    $0x3,%esi
  800caf:	48 89 c7             	mov    %rax,%rdi
  800cb2:	48 b8 0d 06 80 00 00 	movabs $0x80060d,%rax
  800cb9:	00 00 00 
  800cbc:	ff d0                	callq  *%rax
  800cbe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cc2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cc9:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cce:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cd1:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cd4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cd8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cdc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce0:	45 89 c1             	mov    %r8d,%r9d
  800ce3:	41 89 f8             	mov    %edi,%r8d
  800ce6:	48 89 c7             	mov    %rax,%rdi
  800ce9:	48 b8 52 05 80 00 00 	movabs $0x800552,%rax
  800cf0:	00 00 00 
  800cf3:	ff d0                	callq  *%rax
			break;
  800cf5:	eb 3f                	jmp    800d36 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cf7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cfb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cff:	48 89 d6             	mov    %rdx,%rsi
  800d02:	89 df                	mov    %ebx,%edi
  800d04:	ff d0                	callq  *%rax
			break;
  800d06:	eb 2e                	jmp    800d36 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d08:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d0c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d10:	48 89 d6             	mov    %rdx,%rsi
  800d13:	bf 25 00 00 00       	mov    $0x25,%edi
  800d18:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d1a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d1f:	eb 05                	jmp    800d26 <vprintfmt+0x4f9>
  800d21:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d26:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d2a:	48 83 e8 01          	sub    $0x1,%rax
  800d2e:	0f b6 00             	movzbl (%rax),%eax
  800d31:	3c 25                	cmp    $0x25,%al
  800d33:	75 ec                	jne    800d21 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800d35:	90                   	nop
		}
	}
  800d36:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d37:	e9 43 fb ff ff       	jmpq   80087f <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d3c:	48 83 c4 60          	add    $0x60,%rsp
  800d40:	5b                   	pop    %rbx
  800d41:	41 5c                	pop    %r12
  800d43:	5d                   	pop    %rbp
  800d44:	c3                   	retq   

0000000000800d45 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d45:	55                   	push   %rbp
  800d46:	48 89 e5             	mov    %rsp,%rbp
  800d49:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d50:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d57:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d5e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d65:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d6c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d73:	84 c0                	test   %al,%al
  800d75:	74 20                	je     800d97 <printfmt+0x52>
  800d77:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d7b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d7f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d83:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d87:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d8b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d8f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d93:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d97:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d9e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800da5:	00 00 00 
  800da8:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800daf:	00 00 00 
  800db2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800db6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800dbd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dc4:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800dcb:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800dd2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800dd9:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800de0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800de7:	48 89 c7             	mov    %rax,%rdi
  800dea:	48 b8 2d 08 80 00 00 	movabs $0x80082d,%rax
  800df1:	00 00 00 
  800df4:	ff d0                	callq  *%rax
	va_end(ap);
}
  800df6:	c9                   	leaveq 
  800df7:	c3                   	retq   

0000000000800df8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800df8:	55                   	push   %rbp
  800df9:	48 89 e5             	mov    %rsp,%rbp
  800dfc:	48 83 ec 10          	sub    $0x10,%rsp
  800e00:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e03:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e0b:	8b 40 10             	mov    0x10(%rax),%eax
  800e0e:	8d 50 01             	lea    0x1(%rax),%edx
  800e11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e15:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e1c:	48 8b 10             	mov    (%rax),%rdx
  800e1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e23:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e27:	48 39 c2             	cmp    %rax,%rdx
  800e2a:	73 17                	jae    800e43 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e30:	48 8b 00             	mov    (%rax),%rax
  800e33:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e3b:	48 89 0a             	mov    %rcx,(%rdx)
  800e3e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e41:	88 10                	mov    %dl,(%rax)
}
  800e43:	c9                   	leaveq 
  800e44:	c3                   	retq   

0000000000800e45 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e45:	55                   	push   %rbp
  800e46:	48 89 e5             	mov    %rsp,%rbp
  800e49:	48 83 ec 50          	sub    $0x50,%rsp
  800e4d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e51:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e54:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e58:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e5c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e60:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e64:	48 8b 0a             	mov    (%rdx),%rcx
  800e67:	48 89 08             	mov    %rcx,(%rax)
  800e6a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e6e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e72:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e76:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e7a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e7e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e82:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e85:	48 98                	cltq   
  800e87:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e8b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e8f:	48 01 d0             	add    %rdx,%rax
  800e92:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e96:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e9d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ea2:	74 06                	je     800eaa <vsnprintf+0x65>
  800ea4:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ea8:	7f 07                	jg     800eb1 <vsnprintf+0x6c>
		return -E_INVAL;
  800eaa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eaf:	eb 2f                	jmp    800ee0 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800eb1:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800eb5:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800eb9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ebd:	48 89 c6             	mov    %rax,%rsi
  800ec0:	48 bf f8 0d 80 00 00 	movabs $0x800df8,%rdi
  800ec7:	00 00 00 
  800eca:	48 b8 2d 08 80 00 00 	movabs $0x80082d,%rax
  800ed1:	00 00 00 
  800ed4:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ed6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800eda:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800edd:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ee0:	c9                   	leaveq 
  800ee1:	c3                   	retq   

0000000000800ee2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ee2:	55                   	push   %rbp
  800ee3:	48 89 e5             	mov    %rsp,%rbp
  800ee6:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800eed:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ef4:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800efa:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f01:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f08:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f0f:	84 c0                	test   %al,%al
  800f11:	74 20                	je     800f33 <snprintf+0x51>
  800f13:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f17:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f1b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f1f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f23:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f27:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f2b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f2f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f33:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f3a:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f41:	00 00 00 
  800f44:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f4b:	00 00 00 
  800f4e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f52:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f59:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f60:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f67:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f6e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f75:	48 8b 0a             	mov    (%rdx),%rcx
  800f78:	48 89 08             	mov    %rcx,(%rax)
  800f7b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f7f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f83:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f87:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f8b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f92:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f99:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f9f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fa6:	48 89 c7             	mov    %rax,%rdi
  800fa9:	48 b8 45 0e 80 00 00 	movabs $0x800e45,%rax
  800fb0:	00 00 00 
  800fb3:	ff d0                	callq  *%rax
  800fb5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fbb:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fc1:	c9                   	leaveq 
  800fc2:	c3                   	retq   

0000000000800fc3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fc3:	55                   	push   %rbp
  800fc4:	48 89 e5             	mov    %rsp,%rbp
  800fc7:	48 83 ec 18          	sub    $0x18,%rsp
  800fcb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fcf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fd6:	eb 09                	jmp    800fe1 <strlen+0x1e>
		n++;
  800fd8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fdc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fe1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe5:	0f b6 00             	movzbl (%rax),%eax
  800fe8:	84 c0                	test   %al,%al
  800fea:	75 ec                	jne    800fd8 <strlen+0x15>
		n++;
	return n;
  800fec:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fef:	c9                   	leaveq 
  800ff0:	c3                   	retq   

0000000000800ff1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ff1:	55                   	push   %rbp
  800ff2:	48 89 e5             	mov    %rsp,%rbp
  800ff5:	48 83 ec 20          	sub    $0x20,%rsp
  800ff9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ffd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801001:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801008:	eb 0e                	jmp    801018 <strnlen+0x27>
		n++;
  80100a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80100e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801013:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801018:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80101d:	74 0b                	je     80102a <strnlen+0x39>
  80101f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801023:	0f b6 00             	movzbl (%rax),%eax
  801026:	84 c0                	test   %al,%al
  801028:	75 e0                	jne    80100a <strnlen+0x19>
		n++;
	return n;
  80102a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80102d:	c9                   	leaveq 
  80102e:	c3                   	retq   

000000000080102f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80102f:	55                   	push   %rbp
  801030:	48 89 e5             	mov    %rsp,%rbp
  801033:	48 83 ec 20          	sub    $0x20,%rsp
  801037:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80103b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80103f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801043:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801047:	90                   	nop
  801048:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80104c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801050:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801054:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801058:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80105c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801060:	0f b6 12             	movzbl (%rdx),%edx
  801063:	88 10                	mov    %dl,(%rax)
  801065:	0f b6 00             	movzbl (%rax),%eax
  801068:	84 c0                	test   %al,%al
  80106a:	75 dc                	jne    801048 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80106c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801070:	c9                   	leaveq 
  801071:	c3                   	retq   

0000000000801072 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801072:	55                   	push   %rbp
  801073:	48 89 e5             	mov    %rsp,%rbp
  801076:	48 83 ec 20          	sub    $0x20,%rsp
  80107a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80107e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801082:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801086:	48 89 c7             	mov    %rax,%rdi
  801089:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  801090:	00 00 00 
  801093:	ff d0                	callq  *%rax
  801095:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801098:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80109b:	48 63 d0             	movslq %eax,%rdx
  80109e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a2:	48 01 c2             	add    %rax,%rdx
  8010a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010a9:	48 89 c6             	mov    %rax,%rsi
  8010ac:	48 89 d7             	mov    %rdx,%rdi
  8010af:	48 b8 2f 10 80 00 00 	movabs $0x80102f,%rax
  8010b6:	00 00 00 
  8010b9:	ff d0                	callq  *%rax
	return dst;
  8010bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010bf:	c9                   	leaveq 
  8010c0:	c3                   	retq   

00000000008010c1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010c1:	55                   	push   %rbp
  8010c2:	48 89 e5             	mov    %rsp,%rbp
  8010c5:	48 83 ec 28          	sub    $0x28,%rsp
  8010c9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010cd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010d1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010dd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010e4:	00 
  8010e5:	eb 2a                	jmp    801111 <strncpy+0x50>
		*dst++ = *src;
  8010e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010eb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010ef:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010f3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010f7:	0f b6 12             	movzbl (%rdx),%edx
  8010fa:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801100:	0f b6 00             	movzbl (%rax),%eax
  801103:	84 c0                	test   %al,%al
  801105:	74 05                	je     80110c <strncpy+0x4b>
			src++;
  801107:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80110c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801111:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801115:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801119:	72 cc                	jb     8010e7 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80111b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80111f:	c9                   	leaveq 
  801120:	c3                   	retq   

0000000000801121 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801121:	55                   	push   %rbp
  801122:	48 89 e5             	mov    %rsp,%rbp
  801125:	48 83 ec 28          	sub    $0x28,%rsp
  801129:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80112d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801131:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801135:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801139:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80113d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801142:	74 3d                	je     801181 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801144:	eb 1d                	jmp    801163 <strlcpy+0x42>
			*dst++ = *src++;
  801146:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80114e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801152:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801156:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80115a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80115e:	0f b6 12             	movzbl (%rdx),%edx
  801161:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801163:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801168:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80116d:	74 0b                	je     80117a <strlcpy+0x59>
  80116f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801173:	0f b6 00             	movzbl (%rax),%eax
  801176:	84 c0                	test   %al,%al
  801178:	75 cc                	jne    801146 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80117a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117e:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801181:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801185:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801189:	48 29 c2             	sub    %rax,%rdx
  80118c:	48 89 d0             	mov    %rdx,%rax
}
  80118f:	c9                   	leaveq 
  801190:	c3                   	retq   

0000000000801191 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801191:	55                   	push   %rbp
  801192:	48 89 e5             	mov    %rsp,%rbp
  801195:	48 83 ec 10          	sub    $0x10,%rsp
  801199:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80119d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011a1:	eb 0a                	jmp    8011ad <strcmp+0x1c>
		p++, q++;
  8011a3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011a8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b1:	0f b6 00             	movzbl (%rax),%eax
  8011b4:	84 c0                	test   %al,%al
  8011b6:	74 12                	je     8011ca <strcmp+0x39>
  8011b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011bc:	0f b6 10             	movzbl (%rax),%edx
  8011bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c3:	0f b6 00             	movzbl (%rax),%eax
  8011c6:	38 c2                	cmp    %al,%dl
  8011c8:	74 d9                	je     8011a3 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ce:	0f b6 00             	movzbl (%rax),%eax
  8011d1:	0f b6 d0             	movzbl %al,%edx
  8011d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d8:	0f b6 00             	movzbl (%rax),%eax
  8011db:	0f b6 c0             	movzbl %al,%eax
  8011de:	29 c2                	sub    %eax,%edx
  8011e0:	89 d0                	mov    %edx,%eax
}
  8011e2:	c9                   	leaveq 
  8011e3:	c3                   	retq   

00000000008011e4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011e4:	55                   	push   %rbp
  8011e5:	48 89 e5             	mov    %rsp,%rbp
  8011e8:	48 83 ec 18          	sub    $0x18,%rsp
  8011ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011f4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011f8:	eb 0f                	jmp    801209 <strncmp+0x25>
		n--, p++, q++;
  8011fa:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8011ff:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801204:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801209:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80120e:	74 1d                	je     80122d <strncmp+0x49>
  801210:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801214:	0f b6 00             	movzbl (%rax),%eax
  801217:	84 c0                	test   %al,%al
  801219:	74 12                	je     80122d <strncmp+0x49>
  80121b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121f:	0f b6 10             	movzbl (%rax),%edx
  801222:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801226:	0f b6 00             	movzbl (%rax),%eax
  801229:	38 c2                	cmp    %al,%dl
  80122b:	74 cd                	je     8011fa <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80122d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801232:	75 07                	jne    80123b <strncmp+0x57>
		return 0;
  801234:	b8 00 00 00 00       	mov    $0x0,%eax
  801239:	eb 18                	jmp    801253 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80123b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123f:	0f b6 00             	movzbl (%rax),%eax
  801242:	0f b6 d0             	movzbl %al,%edx
  801245:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801249:	0f b6 00             	movzbl (%rax),%eax
  80124c:	0f b6 c0             	movzbl %al,%eax
  80124f:	29 c2                	sub    %eax,%edx
  801251:	89 d0                	mov    %edx,%eax
}
  801253:	c9                   	leaveq 
  801254:	c3                   	retq   

0000000000801255 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801255:	55                   	push   %rbp
  801256:	48 89 e5             	mov    %rsp,%rbp
  801259:	48 83 ec 0c          	sub    $0xc,%rsp
  80125d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801261:	89 f0                	mov    %esi,%eax
  801263:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801266:	eb 17                	jmp    80127f <strchr+0x2a>
		if (*s == c)
  801268:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126c:	0f b6 00             	movzbl (%rax),%eax
  80126f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801272:	75 06                	jne    80127a <strchr+0x25>
			return (char *) s;
  801274:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801278:	eb 15                	jmp    80128f <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80127a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80127f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801283:	0f b6 00             	movzbl (%rax),%eax
  801286:	84 c0                	test   %al,%al
  801288:	75 de                	jne    801268 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80128a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80128f:	c9                   	leaveq 
  801290:	c3                   	retq   

0000000000801291 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801291:	55                   	push   %rbp
  801292:	48 89 e5             	mov    %rsp,%rbp
  801295:	48 83 ec 0c          	sub    $0xc,%rsp
  801299:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80129d:	89 f0                	mov    %esi,%eax
  80129f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012a2:	eb 13                	jmp    8012b7 <strfind+0x26>
		if (*s == c)
  8012a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a8:	0f b6 00             	movzbl (%rax),%eax
  8012ab:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012ae:	75 02                	jne    8012b2 <strfind+0x21>
			break;
  8012b0:	eb 10                	jmp    8012c2 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012b2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bb:	0f b6 00             	movzbl (%rax),%eax
  8012be:	84 c0                	test   %al,%al
  8012c0:	75 e2                	jne    8012a4 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012c6:	c9                   	leaveq 
  8012c7:	c3                   	retq   

00000000008012c8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012c8:	55                   	push   %rbp
  8012c9:	48 89 e5             	mov    %rsp,%rbp
  8012cc:	48 83 ec 18          	sub    $0x18,%rsp
  8012d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012d4:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012d7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012db:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012e0:	75 06                	jne    8012e8 <memset+0x20>
		return v;
  8012e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e6:	eb 69                	jmp    801351 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ec:	83 e0 03             	and    $0x3,%eax
  8012ef:	48 85 c0             	test   %rax,%rax
  8012f2:	75 48                	jne    80133c <memset+0x74>
  8012f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f8:	83 e0 03             	and    $0x3,%eax
  8012fb:	48 85 c0             	test   %rax,%rax
  8012fe:	75 3c                	jne    80133c <memset+0x74>
		c &= 0xFF;
  801300:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801307:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80130a:	c1 e0 18             	shl    $0x18,%eax
  80130d:	89 c2                	mov    %eax,%edx
  80130f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801312:	c1 e0 10             	shl    $0x10,%eax
  801315:	09 c2                	or     %eax,%edx
  801317:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80131a:	c1 e0 08             	shl    $0x8,%eax
  80131d:	09 d0                	or     %edx,%eax
  80131f:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801326:	48 c1 e8 02          	shr    $0x2,%rax
  80132a:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80132d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801331:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801334:	48 89 d7             	mov    %rdx,%rdi
  801337:	fc                   	cld    
  801338:	f3 ab                	rep stos %eax,%es:(%rdi)
  80133a:	eb 11                	jmp    80134d <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80133c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801340:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801343:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801347:	48 89 d7             	mov    %rdx,%rdi
  80134a:	fc                   	cld    
  80134b:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80134d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801351:	c9                   	leaveq 
  801352:	c3                   	retq   

0000000000801353 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801353:	55                   	push   %rbp
  801354:	48 89 e5             	mov    %rsp,%rbp
  801357:	48 83 ec 28          	sub    $0x28,%rsp
  80135b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80135f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801363:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801367:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80136b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80136f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801373:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801377:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80137f:	0f 83 88 00 00 00    	jae    80140d <memmove+0xba>
  801385:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801389:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80138d:	48 01 d0             	add    %rdx,%rax
  801390:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801394:	76 77                	jbe    80140d <memmove+0xba>
		s += n;
  801396:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80139e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a2:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013aa:	83 e0 03             	and    $0x3,%eax
  8013ad:	48 85 c0             	test   %rax,%rax
  8013b0:	75 3b                	jne    8013ed <memmove+0x9a>
  8013b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b6:	83 e0 03             	and    $0x3,%eax
  8013b9:	48 85 c0             	test   %rax,%rax
  8013bc:	75 2f                	jne    8013ed <memmove+0x9a>
  8013be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c2:	83 e0 03             	and    $0x3,%eax
  8013c5:	48 85 c0             	test   %rax,%rax
  8013c8:	75 23                	jne    8013ed <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ce:	48 83 e8 04          	sub    $0x4,%rax
  8013d2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013d6:	48 83 ea 04          	sub    $0x4,%rdx
  8013da:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013de:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013e2:	48 89 c7             	mov    %rax,%rdi
  8013e5:	48 89 d6             	mov    %rdx,%rsi
  8013e8:	fd                   	std    
  8013e9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013eb:	eb 1d                	jmp    80140a <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f9:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8013fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801401:	48 89 d7             	mov    %rdx,%rdi
  801404:	48 89 c1             	mov    %rax,%rcx
  801407:	fd                   	std    
  801408:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80140a:	fc                   	cld    
  80140b:	eb 57                	jmp    801464 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80140d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801411:	83 e0 03             	and    $0x3,%eax
  801414:	48 85 c0             	test   %rax,%rax
  801417:	75 36                	jne    80144f <memmove+0xfc>
  801419:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80141d:	83 e0 03             	and    $0x3,%eax
  801420:	48 85 c0             	test   %rax,%rax
  801423:	75 2a                	jne    80144f <memmove+0xfc>
  801425:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801429:	83 e0 03             	and    $0x3,%eax
  80142c:	48 85 c0             	test   %rax,%rax
  80142f:	75 1e                	jne    80144f <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801431:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801435:	48 c1 e8 02          	shr    $0x2,%rax
  801439:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80143c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801440:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801444:	48 89 c7             	mov    %rax,%rdi
  801447:	48 89 d6             	mov    %rdx,%rsi
  80144a:	fc                   	cld    
  80144b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80144d:	eb 15                	jmp    801464 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80144f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801453:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801457:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80145b:	48 89 c7             	mov    %rax,%rdi
  80145e:	48 89 d6             	mov    %rdx,%rsi
  801461:	fc                   	cld    
  801462:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801464:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801468:	c9                   	leaveq 
  801469:	c3                   	retq   

000000000080146a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80146a:	55                   	push   %rbp
  80146b:	48 89 e5             	mov    %rsp,%rbp
  80146e:	48 83 ec 18          	sub    $0x18,%rsp
  801472:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801476:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80147a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80147e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801482:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801486:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148a:	48 89 ce             	mov    %rcx,%rsi
  80148d:	48 89 c7             	mov    %rax,%rdi
  801490:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  801497:	00 00 00 
  80149a:	ff d0                	callq  *%rax
}
  80149c:	c9                   	leaveq 
  80149d:	c3                   	retq   

000000000080149e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80149e:	55                   	push   %rbp
  80149f:	48 89 e5             	mov    %rsp,%rbp
  8014a2:	48 83 ec 28          	sub    $0x28,%rsp
  8014a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014be:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014c2:	eb 36                	jmp    8014fa <memcmp+0x5c>
		if (*s1 != *s2)
  8014c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c8:	0f b6 10             	movzbl (%rax),%edx
  8014cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014cf:	0f b6 00             	movzbl (%rax),%eax
  8014d2:	38 c2                	cmp    %al,%dl
  8014d4:	74 1a                	je     8014f0 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014da:	0f b6 00             	movzbl (%rax),%eax
  8014dd:	0f b6 d0             	movzbl %al,%edx
  8014e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e4:	0f b6 00             	movzbl (%rax),%eax
  8014e7:	0f b6 c0             	movzbl %al,%eax
  8014ea:	29 c2                	sub    %eax,%edx
  8014ec:	89 d0                	mov    %edx,%eax
  8014ee:	eb 20                	jmp    801510 <memcmp+0x72>
		s1++, s2++;
  8014f0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014f5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fe:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801502:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801506:	48 85 c0             	test   %rax,%rax
  801509:	75 b9                	jne    8014c4 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80150b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801510:	c9                   	leaveq 
  801511:	c3                   	retq   

0000000000801512 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801512:	55                   	push   %rbp
  801513:	48 89 e5             	mov    %rsp,%rbp
  801516:	48 83 ec 28          	sub    $0x28,%rsp
  80151a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80151e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801521:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801525:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801529:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80152d:	48 01 d0             	add    %rdx,%rax
  801530:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801534:	eb 15                	jmp    80154b <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801536:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80153a:	0f b6 10             	movzbl (%rax),%edx
  80153d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801540:	38 c2                	cmp    %al,%dl
  801542:	75 02                	jne    801546 <memfind+0x34>
			break;
  801544:	eb 0f                	jmp    801555 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801546:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80154b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80154f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801553:	72 e1                	jb     801536 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801555:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801559:	c9                   	leaveq 
  80155a:	c3                   	retq   

000000000080155b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80155b:	55                   	push   %rbp
  80155c:	48 89 e5             	mov    %rsp,%rbp
  80155f:	48 83 ec 34          	sub    $0x34,%rsp
  801563:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801567:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80156b:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80156e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801575:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80157c:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80157d:	eb 05                	jmp    801584 <strtol+0x29>
		s++;
  80157f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801584:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801588:	0f b6 00             	movzbl (%rax),%eax
  80158b:	3c 20                	cmp    $0x20,%al
  80158d:	74 f0                	je     80157f <strtol+0x24>
  80158f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801593:	0f b6 00             	movzbl (%rax),%eax
  801596:	3c 09                	cmp    $0x9,%al
  801598:	74 e5                	je     80157f <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80159a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159e:	0f b6 00             	movzbl (%rax),%eax
  8015a1:	3c 2b                	cmp    $0x2b,%al
  8015a3:	75 07                	jne    8015ac <strtol+0x51>
		s++;
  8015a5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015aa:	eb 17                	jmp    8015c3 <strtol+0x68>
	else if (*s == '-')
  8015ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b0:	0f b6 00             	movzbl (%rax),%eax
  8015b3:	3c 2d                	cmp    $0x2d,%al
  8015b5:	75 0c                	jne    8015c3 <strtol+0x68>
		s++, neg = 1;
  8015b7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015bc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015c3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015c7:	74 06                	je     8015cf <strtol+0x74>
  8015c9:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015cd:	75 28                	jne    8015f7 <strtol+0x9c>
  8015cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d3:	0f b6 00             	movzbl (%rax),%eax
  8015d6:	3c 30                	cmp    $0x30,%al
  8015d8:	75 1d                	jne    8015f7 <strtol+0x9c>
  8015da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015de:	48 83 c0 01          	add    $0x1,%rax
  8015e2:	0f b6 00             	movzbl (%rax),%eax
  8015e5:	3c 78                	cmp    $0x78,%al
  8015e7:	75 0e                	jne    8015f7 <strtol+0x9c>
		s += 2, base = 16;
  8015e9:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015ee:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015f5:	eb 2c                	jmp    801623 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015f7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015fb:	75 19                	jne    801616 <strtol+0xbb>
  8015fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801601:	0f b6 00             	movzbl (%rax),%eax
  801604:	3c 30                	cmp    $0x30,%al
  801606:	75 0e                	jne    801616 <strtol+0xbb>
		s++, base = 8;
  801608:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80160d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801614:	eb 0d                	jmp    801623 <strtol+0xc8>
	else if (base == 0)
  801616:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80161a:	75 07                	jne    801623 <strtol+0xc8>
		base = 10;
  80161c:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801623:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801627:	0f b6 00             	movzbl (%rax),%eax
  80162a:	3c 2f                	cmp    $0x2f,%al
  80162c:	7e 1d                	jle    80164b <strtol+0xf0>
  80162e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801632:	0f b6 00             	movzbl (%rax),%eax
  801635:	3c 39                	cmp    $0x39,%al
  801637:	7f 12                	jg     80164b <strtol+0xf0>
			dig = *s - '0';
  801639:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163d:	0f b6 00             	movzbl (%rax),%eax
  801640:	0f be c0             	movsbl %al,%eax
  801643:	83 e8 30             	sub    $0x30,%eax
  801646:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801649:	eb 4e                	jmp    801699 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80164b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164f:	0f b6 00             	movzbl (%rax),%eax
  801652:	3c 60                	cmp    $0x60,%al
  801654:	7e 1d                	jle    801673 <strtol+0x118>
  801656:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165a:	0f b6 00             	movzbl (%rax),%eax
  80165d:	3c 7a                	cmp    $0x7a,%al
  80165f:	7f 12                	jg     801673 <strtol+0x118>
			dig = *s - 'a' + 10;
  801661:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801665:	0f b6 00             	movzbl (%rax),%eax
  801668:	0f be c0             	movsbl %al,%eax
  80166b:	83 e8 57             	sub    $0x57,%eax
  80166e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801671:	eb 26                	jmp    801699 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801673:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801677:	0f b6 00             	movzbl (%rax),%eax
  80167a:	3c 40                	cmp    $0x40,%al
  80167c:	7e 48                	jle    8016c6 <strtol+0x16b>
  80167e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801682:	0f b6 00             	movzbl (%rax),%eax
  801685:	3c 5a                	cmp    $0x5a,%al
  801687:	7f 3d                	jg     8016c6 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801689:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168d:	0f b6 00             	movzbl (%rax),%eax
  801690:	0f be c0             	movsbl %al,%eax
  801693:	83 e8 37             	sub    $0x37,%eax
  801696:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801699:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80169c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80169f:	7c 02                	jl     8016a3 <strtol+0x148>
			break;
  8016a1:	eb 23                	jmp    8016c6 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016a3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016a8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016ab:	48 98                	cltq   
  8016ad:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016b2:	48 89 c2             	mov    %rax,%rdx
  8016b5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016b8:	48 98                	cltq   
  8016ba:	48 01 d0             	add    %rdx,%rax
  8016bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016c1:	e9 5d ff ff ff       	jmpq   801623 <strtol+0xc8>

	if (endptr)
  8016c6:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016cb:	74 0b                	je     8016d8 <strtol+0x17d>
		*endptr = (char *) s;
  8016cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016d1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016d5:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016dc:	74 09                	je     8016e7 <strtol+0x18c>
  8016de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e2:	48 f7 d8             	neg    %rax
  8016e5:	eb 04                	jmp    8016eb <strtol+0x190>
  8016e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016eb:	c9                   	leaveq 
  8016ec:	c3                   	retq   

00000000008016ed <strstr>:

char * strstr(const char *in, const char *str)
{
  8016ed:	55                   	push   %rbp
  8016ee:	48 89 e5             	mov    %rsp,%rbp
  8016f1:	48 83 ec 30          	sub    $0x30,%rsp
  8016f5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016f9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8016fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801701:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801705:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801709:	0f b6 00             	movzbl (%rax),%eax
  80170c:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80170f:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801713:	75 06                	jne    80171b <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801715:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801719:	eb 6b                	jmp    801786 <strstr+0x99>

	len = strlen(str);
  80171b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80171f:	48 89 c7             	mov    %rax,%rdi
  801722:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  801729:	00 00 00 
  80172c:	ff d0                	callq  *%rax
  80172e:	48 98                	cltq   
  801730:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801734:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801738:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80173c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801740:	0f b6 00             	movzbl (%rax),%eax
  801743:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801746:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80174a:	75 07                	jne    801753 <strstr+0x66>
				return (char *) 0;
  80174c:	b8 00 00 00 00       	mov    $0x0,%eax
  801751:	eb 33                	jmp    801786 <strstr+0x99>
		} while (sc != c);
  801753:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801757:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80175a:	75 d8                	jne    801734 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80175c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801760:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801764:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801768:	48 89 ce             	mov    %rcx,%rsi
  80176b:	48 89 c7             	mov    %rax,%rdi
  80176e:	48 b8 e4 11 80 00 00 	movabs $0x8011e4,%rax
  801775:	00 00 00 
  801778:	ff d0                	callq  *%rax
  80177a:	85 c0                	test   %eax,%eax
  80177c:	75 b6                	jne    801734 <strstr+0x47>

	return (char *) (in - 1);
  80177e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801782:	48 83 e8 01          	sub    $0x1,%rax
}
  801786:	c9                   	leaveq 
  801787:	c3                   	retq   

0000000000801788 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801788:	55                   	push   %rbp
  801789:	48 89 e5             	mov    %rsp,%rbp
  80178c:	53                   	push   %rbx
  80178d:	48 83 ec 48          	sub    $0x48,%rsp
  801791:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801794:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801797:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80179b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80179f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017a3:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017a7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017aa:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017ae:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017b2:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017b6:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017ba:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017be:	4c 89 c3             	mov    %r8,%rbx
  8017c1:	cd 30                	int    $0x30
  8017c3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017c7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017cb:	74 3e                	je     80180b <syscall+0x83>
  8017cd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017d2:	7e 37                	jle    80180b <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017d8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017db:	49 89 d0             	mov    %rdx,%r8
  8017de:	89 c1                	mov    %eax,%ecx
  8017e0:	48 ba 28 4e 80 00 00 	movabs $0x804e28,%rdx
  8017e7:	00 00 00 
  8017ea:	be 23 00 00 00       	mov    $0x23,%esi
  8017ef:	48 bf 45 4e 80 00 00 	movabs $0x804e45,%rdi
  8017f6:	00 00 00 
  8017f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fe:	49 b9 a5 45 80 00 00 	movabs $0x8045a5,%r9
  801805:	00 00 00 
  801808:	41 ff d1             	callq  *%r9

	return ret;
  80180b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80180f:	48 83 c4 48          	add    $0x48,%rsp
  801813:	5b                   	pop    %rbx
  801814:	5d                   	pop    %rbp
  801815:	c3                   	retq   

0000000000801816 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801816:	55                   	push   %rbp
  801817:	48 89 e5             	mov    %rsp,%rbp
  80181a:	48 83 ec 20          	sub    $0x20,%rsp
  80181e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801822:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801826:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80182a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80182e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801835:	00 
  801836:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80183c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801842:	48 89 d1             	mov    %rdx,%rcx
  801845:	48 89 c2             	mov    %rax,%rdx
  801848:	be 00 00 00 00       	mov    $0x0,%esi
  80184d:	bf 00 00 00 00       	mov    $0x0,%edi
  801852:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801859:	00 00 00 
  80185c:	ff d0                	callq  *%rax
}
  80185e:	c9                   	leaveq 
  80185f:	c3                   	retq   

0000000000801860 <sys_cgetc>:

int
sys_cgetc(void)
{
  801860:	55                   	push   %rbp
  801861:	48 89 e5             	mov    %rsp,%rbp
  801864:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801868:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80186f:	00 
  801870:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801876:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80187c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801881:	ba 00 00 00 00       	mov    $0x0,%edx
  801886:	be 00 00 00 00       	mov    $0x0,%esi
  80188b:	bf 01 00 00 00       	mov    $0x1,%edi
  801890:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801897:	00 00 00 
  80189a:	ff d0                	callq  *%rax
}
  80189c:	c9                   	leaveq 
  80189d:	c3                   	retq   

000000000080189e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80189e:	55                   	push   %rbp
  80189f:	48 89 e5             	mov    %rsp,%rbp
  8018a2:	48 83 ec 10          	sub    $0x10,%rsp
  8018a6:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ac:	48 98                	cltq   
  8018ae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018b5:	00 
  8018b6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018c7:	48 89 c2             	mov    %rax,%rdx
  8018ca:	be 01 00 00 00       	mov    $0x1,%esi
  8018cf:	bf 03 00 00 00       	mov    $0x3,%edi
  8018d4:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  8018db:	00 00 00 
  8018de:	ff d0                	callq  *%rax
}
  8018e0:	c9                   	leaveq 
  8018e1:	c3                   	retq   

00000000008018e2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018e2:	55                   	push   %rbp
  8018e3:	48 89 e5             	mov    %rsp,%rbp
  8018e6:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018ea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f1:	00 
  8018f2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801903:	ba 00 00 00 00       	mov    $0x0,%edx
  801908:	be 00 00 00 00       	mov    $0x0,%esi
  80190d:	bf 02 00 00 00       	mov    $0x2,%edi
  801912:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801919:	00 00 00 
  80191c:	ff d0                	callq  *%rax
}
  80191e:	c9                   	leaveq 
  80191f:	c3                   	retq   

0000000000801920 <sys_yield>:

void
sys_yield(void)
{
  801920:	55                   	push   %rbp
  801921:	48 89 e5             	mov    %rsp,%rbp
  801924:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801928:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80192f:	00 
  801930:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801936:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80193c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801941:	ba 00 00 00 00       	mov    $0x0,%edx
  801946:	be 00 00 00 00       	mov    $0x0,%esi
  80194b:	bf 0b 00 00 00       	mov    $0xb,%edi
  801950:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801957:	00 00 00 
  80195a:	ff d0                	callq  *%rax
}
  80195c:	c9                   	leaveq 
  80195d:	c3                   	retq   

000000000080195e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80195e:	55                   	push   %rbp
  80195f:	48 89 e5             	mov    %rsp,%rbp
  801962:	48 83 ec 20          	sub    $0x20,%rsp
  801966:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801969:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80196d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801970:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801973:	48 63 c8             	movslq %eax,%rcx
  801976:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80197a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80197d:	48 98                	cltq   
  80197f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801986:	00 
  801987:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80198d:	49 89 c8             	mov    %rcx,%r8
  801990:	48 89 d1             	mov    %rdx,%rcx
  801993:	48 89 c2             	mov    %rax,%rdx
  801996:	be 01 00 00 00       	mov    $0x1,%esi
  80199b:	bf 04 00 00 00       	mov    $0x4,%edi
  8019a0:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  8019a7:	00 00 00 
  8019aa:	ff d0                	callq  *%rax
}
  8019ac:	c9                   	leaveq 
  8019ad:	c3                   	retq   

00000000008019ae <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019ae:	55                   	push   %rbp
  8019af:	48 89 e5             	mov    %rsp,%rbp
  8019b2:	48 83 ec 30          	sub    $0x30,%rsp
  8019b6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019bd:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019c0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019c4:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019c8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019cb:	48 63 c8             	movslq %eax,%rcx
  8019ce:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019d5:	48 63 f0             	movslq %eax,%rsi
  8019d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019df:	48 98                	cltq   
  8019e1:	48 89 0c 24          	mov    %rcx,(%rsp)
  8019e5:	49 89 f9             	mov    %rdi,%r9
  8019e8:	49 89 f0             	mov    %rsi,%r8
  8019eb:	48 89 d1             	mov    %rdx,%rcx
  8019ee:	48 89 c2             	mov    %rax,%rdx
  8019f1:	be 01 00 00 00       	mov    $0x1,%esi
  8019f6:	bf 05 00 00 00       	mov    $0x5,%edi
  8019fb:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801a02:	00 00 00 
  801a05:	ff d0                	callq  *%rax
}
  801a07:	c9                   	leaveq 
  801a08:	c3                   	retq   

0000000000801a09 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a09:	55                   	push   %rbp
  801a0a:	48 89 e5             	mov    %rsp,%rbp
  801a0d:	48 83 ec 20          	sub    $0x20,%rsp
  801a11:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a14:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a1f:	48 98                	cltq   
  801a21:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a28:	00 
  801a29:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a2f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a35:	48 89 d1             	mov    %rdx,%rcx
  801a38:	48 89 c2             	mov    %rax,%rdx
  801a3b:	be 01 00 00 00       	mov    $0x1,%esi
  801a40:	bf 06 00 00 00       	mov    $0x6,%edi
  801a45:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801a4c:	00 00 00 
  801a4f:	ff d0                	callq  *%rax
}
  801a51:	c9                   	leaveq 
  801a52:	c3                   	retq   

0000000000801a53 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a53:	55                   	push   %rbp
  801a54:	48 89 e5             	mov    %rsp,%rbp
  801a57:	48 83 ec 10          	sub    $0x10,%rsp
  801a5b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a5e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a61:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a64:	48 63 d0             	movslq %eax,%rdx
  801a67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a6a:	48 98                	cltq   
  801a6c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a73:	00 
  801a74:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a7a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a80:	48 89 d1             	mov    %rdx,%rcx
  801a83:	48 89 c2             	mov    %rax,%rdx
  801a86:	be 01 00 00 00       	mov    $0x1,%esi
  801a8b:	bf 08 00 00 00       	mov    $0x8,%edi
  801a90:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801a97:	00 00 00 
  801a9a:	ff d0                	callq  *%rax
}
  801a9c:	c9                   	leaveq 
  801a9d:	c3                   	retq   

0000000000801a9e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801a9e:	55                   	push   %rbp
  801a9f:	48 89 e5             	mov    %rsp,%rbp
  801aa2:	48 83 ec 20          	sub    $0x20,%rsp
  801aa6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aa9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801aad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab4:	48 98                	cltq   
  801ab6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801abd:	00 
  801abe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aca:	48 89 d1             	mov    %rdx,%rcx
  801acd:	48 89 c2             	mov    %rax,%rdx
  801ad0:	be 01 00 00 00       	mov    $0x1,%esi
  801ad5:	bf 09 00 00 00       	mov    $0x9,%edi
  801ada:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801ae1:	00 00 00 
  801ae4:	ff d0                	callq  *%rax
}
  801ae6:	c9                   	leaveq 
  801ae7:	c3                   	retq   

0000000000801ae8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ae8:	55                   	push   %rbp
  801ae9:	48 89 e5             	mov    %rsp,%rbp
  801aec:	48 83 ec 20          	sub    $0x20,%rsp
  801af0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801af3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801af7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801afb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801afe:	48 98                	cltq   
  801b00:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b07:	00 
  801b08:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b0e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b14:	48 89 d1             	mov    %rdx,%rcx
  801b17:	48 89 c2             	mov    %rax,%rdx
  801b1a:	be 01 00 00 00       	mov    $0x1,%esi
  801b1f:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b24:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801b2b:	00 00 00 
  801b2e:	ff d0                	callq  *%rax
}
  801b30:	c9                   	leaveq 
  801b31:	c3                   	retq   

0000000000801b32 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b32:	55                   	push   %rbp
  801b33:	48 89 e5             	mov    %rsp,%rbp
  801b36:	48 83 ec 20          	sub    $0x20,%rsp
  801b3a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b3d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b41:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b45:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b48:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b4b:	48 63 f0             	movslq %eax,%rsi
  801b4e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b55:	48 98                	cltq   
  801b57:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b5b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b62:	00 
  801b63:	49 89 f1             	mov    %rsi,%r9
  801b66:	49 89 c8             	mov    %rcx,%r8
  801b69:	48 89 d1             	mov    %rdx,%rcx
  801b6c:	48 89 c2             	mov    %rax,%rdx
  801b6f:	be 00 00 00 00       	mov    $0x0,%esi
  801b74:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b79:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801b80:	00 00 00 
  801b83:	ff d0                	callq  *%rax
}
  801b85:	c9                   	leaveq 
  801b86:	c3                   	retq   

0000000000801b87 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b87:	55                   	push   %rbp
  801b88:	48 89 e5             	mov    %rsp,%rbp
  801b8b:	48 83 ec 10          	sub    $0x10,%rsp
  801b8f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b97:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b9e:	00 
  801b9f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ba5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bab:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bb0:	48 89 c2             	mov    %rax,%rdx
  801bb3:	be 01 00 00 00       	mov    $0x1,%esi
  801bb8:	bf 0d 00 00 00       	mov    $0xd,%edi
  801bbd:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801bc4:	00 00 00 
  801bc7:	ff d0                	callq  *%rax
}
  801bc9:	c9                   	leaveq 
  801bca:	c3                   	retq   

0000000000801bcb <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801bcb:	55                   	push   %rbp
  801bcc:	48 89 e5             	mov    %rsp,%rbp
  801bcf:	48 83 ec 20          	sub    $0x20,%rsp
  801bd3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bd7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801bdb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bdf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801be3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bea:	00 
  801beb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bf1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bf7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bfc:	89 c6                	mov    %eax,%esi
  801bfe:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c03:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801c0a:	00 00 00 
  801c0d:	ff d0                	callq  *%rax
}
  801c0f:	c9                   	leaveq 
  801c10:	c3                   	retq   

0000000000801c11 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801c11:	55                   	push   %rbp
  801c12:	48 89 e5             	mov    %rsp,%rbp
  801c15:	48 83 ec 20          	sub    $0x20,%rsp
  801c19:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c1d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801c21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c25:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c29:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c30:	00 
  801c31:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c37:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c42:	89 c6                	mov    %eax,%esi
  801c44:	bf 10 00 00 00       	mov    $0x10,%edi
  801c49:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801c50:	00 00 00 
  801c53:	ff d0                	callq  *%rax
}
  801c55:	c9                   	leaveq 
  801c56:	c3                   	retq   

0000000000801c57 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801c57:	55                   	push   %rbp
  801c58:	48 89 e5             	mov    %rsp,%rbp
  801c5b:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c5f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c66:	00 
  801c67:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c6d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c73:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c78:	ba 00 00 00 00       	mov    $0x0,%edx
  801c7d:	be 00 00 00 00       	mov    $0x0,%esi
  801c82:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c87:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801c8e:	00 00 00 
  801c91:	ff d0                	callq  *%rax
}
  801c93:	c9                   	leaveq 
  801c94:	c3                   	retq   

0000000000801c95 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801c95:	55                   	push   %rbp
  801c96:	48 89 e5             	mov    %rsp,%rbp
  801c99:	48 83 ec 30          	sub    $0x30,%rsp
  801c9d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801ca1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ca5:	48 8b 00             	mov    (%rax),%rax
  801ca8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801cac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cb0:	48 8b 40 08          	mov    0x8(%rax),%rax
  801cb4:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801cb7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801cba:	83 e0 02             	and    $0x2,%eax
  801cbd:	85 c0                	test   %eax,%eax
  801cbf:	75 4d                	jne    801d0e <pgfault+0x79>
  801cc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cc5:	48 c1 e8 0c          	shr    $0xc,%rax
  801cc9:	48 89 c2             	mov    %rax,%rdx
  801ccc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801cd3:	01 00 00 
  801cd6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cda:	25 00 08 00 00       	and    $0x800,%eax
  801cdf:	48 85 c0             	test   %rax,%rax
  801ce2:	74 2a                	je     801d0e <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801ce4:	48 ba 58 4e 80 00 00 	movabs $0x804e58,%rdx
  801ceb:	00 00 00 
  801cee:	be 23 00 00 00       	mov    $0x23,%esi
  801cf3:	48 bf 8d 4e 80 00 00 	movabs $0x804e8d,%rdi
  801cfa:	00 00 00 
  801cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  801d02:	48 b9 a5 45 80 00 00 	movabs $0x8045a5,%rcx
  801d09:	00 00 00 
  801d0c:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801d0e:	ba 07 00 00 00       	mov    $0x7,%edx
  801d13:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d18:	bf 00 00 00 00       	mov    $0x0,%edi
  801d1d:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  801d24:	00 00 00 
  801d27:	ff d0                	callq  *%rax
  801d29:	85 c0                	test   %eax,%eax
  801d2b:	0f 85 cd 00 00 00    	jne    801dfe <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801d31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d35:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801d39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d3d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801d43:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801d47:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d4b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d50:	48 89 c6             	mov    %rax,%rsi
  801d53:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801d58:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  801d5f:	00 00 00 
  801d62:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801d64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d68:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801d6e:	48 89 c1             	mov    %rax,%rcx
  801d71:	ba 00 00 00 00       	mov    $0x0,%edx
  801d76:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d7b:	bf 00 00 00 00       	mov    $0x0,%edi
  801d80:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  801d87:	00 00 00 
  801d8a:	ff d0                	callq  *%rax
  801d8c:	85 c0                	test   %eax,%eax
  801d8e:	79 2a                	jns    801dba <pgfault+0x125>
				panic("Page map at temp address failed");
  801d90:	48 ba 98 4e 80 00 00 	movabs $0x804e98,%rdx
  801d97:	00 00 00 
  801d9a:	be 30 00 00 00       	mov    $0x30,%esi
  801d9f:	48 bf 8d 4e 80 00 00 	movabs $0x804e8d,%rdi
  801da6:	00 00 00 
  801da9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dae:	48 b9 a5 45 80 00 00 	movabs $0x8045a5,%rcx
  801db5:	00 00 00 
  801db8:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801dba:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801dbf:	bf 00 00 00 00       	mov    $0x0,%edi
  801dc4:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801dcb:	00 00 00 
  801dce:	ff d0                	callq  *%rax
  801dd0:	85 c0                	test   %eax,%eax
  801dd2:	79 54                	jns    801e28 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801dd4:	48 ba b8 4e 80 00 00 	movabs $0x804eb8,%rdx
  801ddb:	00 00 00 
  801dde:	be 32 00 00 00       	mov    $0x32,%esi
  801de3:	48 bf 8d 4e 80 00 00 	movabs $0x804e8d,%rdi
  801dea:	00 00 00 
  801ded:	b8 00 00 00 00       	mov    $0x0,%eax
  801df2:	48 b9 a5 45 80 00 00 	movabs $0x8045a5,%rcx
  801df9:	00 00 00 
  801dfc:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801dfe:	48 ba e0 4e 80 00 00 	movabs $0x804ee0,%rdx
  801e05:	00 00 00 
  801e08:	be 34 00 00 00       	mov    $0x34,%esi
  801e0d:	48 bf 8d 4e 80 00 00 	movabs $0x804e8d,%rdi
  801e14:	00 00 00 
  801e17:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1c:	48 b9 a5 45 80 00 00 	movabs $0x8045a5,%rcx
  801e23:	00 00 00 
  801e26:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801e28:	c9                   	leaveq 
  801e29:	c3                   	retq   

0000000000801e2a <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801e2a:	55                   	push   %rbp
  801e2b:	48 89 e5             	mov    %rsp,%rbp
  801e2e:	48 83 ec 20          	sub    $0x20,%rsp
  801e32:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e35:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801e38:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e3f:	01 00 00 
  801e42:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e45:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e49:	25 07 0e 00 00       	and    $0xe07,%eax
  801e4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801e51:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801e54:	48 c1 e0 0c          	shl    $0xc,%rax
  801e58:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801e5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e5f:	25 00 04 00 00       	and    $0x400,%eax
  801e64:	85 c0                	test   %eax,%eax
  801e66:	74 57                	je     801ebf <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e68:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e6b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e6f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e76:	41 89 f0             	mov    %esi,%r8d
  801e79:	48 89 c6             	mov    %rax,%rsi
  801e7c:	bf 00 00 00 00       	mov    $0x0,%edi
  801e81:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  801e88:	00 00 00 
  801e8b:	ff d0                	callq  *%rax
  801e8d:	85 c0                	test   %eax,%eax
  801e8f:	0f 8e 52 01 00 00    	jle    801fe7 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801e95:	48 ba 12 4f 80 00 00 	movabs $0x804f12,%rdx
  801e9c:	00 00 00 
  801e9f:	be 4e 00 00 00       	mov    $0x4e,%esi
  801ea4:	48 bf 8d 4e 80 00 00 	movabs $0x804e8d,%rdi
  801eab:	00 00 00 
  801eae:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb3:	48 b9 a5 45 80 00 00 	movabs $0x8045a5,%rcx
  801eba:	00 00 00 
  801ebd:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801ebf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ec2:	83 e0 02             	and    $0x2,%eax
  801ec5:	85 c0                	test   %eax,%eax
  801ec7:	75 10                	jne    801ed9 <duppage+0xaf>
  801ec9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ecc:	25 00 08 00 00       	and    $0x800,%eax
  801ed1:	85 c0                	test   %eax,%eax
  801ed3:	0f 84 bb 00 00 00    	je     801f94 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801ed9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801edc:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801ee1:	80 cc 08             	or     $0x8,%ah
  801ee4:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801ee7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801eea:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801eee:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ef1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ef5:	41 89 f0             	mov    %esi,%r8d
  801ef8:	48 89 c6             	mov    %rax,%rsi
  801efb:	bf 00 00 00 00       	mov    $0x0,%edi
  801f00:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  801f07:	00 00 00 
  801f0a:	ff d0                	callq  *%rax
  801f0c:	85 c0                	test   %eax,%eax
  801f0e:	7e 2a                	jle    801f3a <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801f10:	48 ba 12 4f 80 00 00 	movabs $0x804f12,%rdx
  801f17:	00 00 00 
  801f1a:	be 55 00 00 00       	mov    $0x55,%esi
  801f1f:	48 bf 8d 4e 80 00 00 	movabs $0x804e8d,%rdi
  801f26:	00 00 00 
  801f29:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2e:	48 b9 a5 45 80 00 00 	movabs $0x8045a5,%rcx
  801f35:	00 00 00 
  801f38:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801f3a:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801f3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f45:	41 89 c8             	mov    %ecx,%r8d
  801f48:	48 89 d1             	mov    %rdx,%rcx
  801f4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801f50:	48 89 c6             	mov    %rax,%rsi
  801f53:	bf 00 00 00 00       	mov    $0x0,%edi
  801f58:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  801f5f:	00 00 00 
  801f62:	ff d0                	callq  *%rax
  801f64:	85 c0                	test   %eax,%eax
  801f66:	7e 2a                	jle    801f92 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  801f68:	48 ba 12 4f 80 00 00 	movabs $0x804f12,%rdx
  801f6f:	00 00 00 
  801f72:	be 57 00 00 00       	mov    $0x57,%esi
  801f77:	48 bf 8d 4e 80 00 00 	movabs $0x804e8d,%rdi
  801f7e:	00 00 00 
  801f81:	b8 00 00 00 00       	mov    $0x0,%eax
  801f86:	48 b9 a5 45 80 00 00 	movabs $0x8045a5,%rcx
  801f8d:	00 00 00 
  801f90:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801f92:	eb 53                	jmp    801fe7 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801f94:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801f97:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f9b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fa2:	41 89 f0             	mov    %esi,%r8d
  801fa5:	48 89 c6             	mov    %rax,%rsi
  801fa8:	bf 00 00 00 00       	mov    $0x0,%edi
  801fad:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  801fb4:	00 00 00 
  801fb7:	ff d0                	callq  *%rax
  801fb9:	85 c0                	test   %eax,%eax
  801fbb:	7e 2a                	jle    801fe7 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801fbd:	48 ba 12 4f 80 00 00 	movabs $0x804f12,%rdx
  801fc4:	00 00 00 
  801fc7:	be 5b 00 00 00       	mov    $0x5b,%esi
  801fcc:	48 bf 8d 4e 80 00 00 	movabs $0x804e8d,%rdi
  801fd3:	00 00 00 
  801fd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdb:	48 b9 a5 45 80 00 00 	movabs $0x8045a5,%rcx
  801fe2:	00 00 00 
  801fe5:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  801fe7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fec:	c9                   	leaveq 
  801fed:	c3                   	retq   

0000000000801fee <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  801fee:	55                   	push   %rbp
  801fef:	48 89 e5             	mov    %rsp,%rbp
  801ff2:	48 83 ec 18          	sub    $0x18,%rsp
  801ff6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  801ffa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ffe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  802002:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802006:	48 c1 e8 27          	shr    $0x27,%rax
  80200a:	48 89 c2             	mov    %rax,%rdx
  80200d:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802014:	01 00 00 
  802017:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80201b:	83 e0 01             	and    $0x1,%eax
  80201e:	48 85 c0             	test   %rax,%rax
  802021:	74 51                	je     802074 <pt_is_mapped+0x86>
  802023:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802027:	48 c1 e0 0c          	shl    $0xc,%rax
  80202b:	48 c1 e8 1e          	shr    $0x1e,%rax
  80202f:	48 89 c2             	mov    %rax,%rdx
  802032:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802039:	01 00 00 
  80203c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802040:	83 e0 01             	and    $0x1,%eax
  802043:	48 85 c0             	test   %rax,%rax
  802046:	74 2c                	je     802074 <pt_is_mapped+0x86>
  802048:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80204c:	48 c1 e0 0c          	shl    $0xc,%rax
  802050:	48 c1 e8 15          	shr    $0x15,%rax
  802054:	48 89 c2             	mov    %rax,%rdx
  802057:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80205e:	01 00 00 
  802061:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802065:	83 e0 01             	and    $0x1,%eax
  802068:	48 85 c0             	test   %rax,%rax
  80206b:	74 07                	je     802074 <pt_is_mapped+0x86>
  80206d:	b8 01 00 00 00       	mov    $0x1,%eax
  802072:	eb 05                	jmp    802079 <pt_is_mapped+0x8b>
  802074:	b8 00 00 00 00       	mov    $0x0,%eax
  802079:	83 e0 01             	and    $0x1,%eax
}
  80207c:	c9                   	leaveq 
  80207d:	c3                   	retq   

000000000080207e <fork>:

envid_t
fork(void)
{
  80207e:	55                   	push   %rbp
  80207f:	48 89 e5             	mov    %rsp,%rbp
  802082:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802086:	48 bf 95 1c 80 00 00 	movabs $0x801c95,%rdi
  80208d:	00 00 00 
  802090:	48 b8 b9 46 80 00 00 	movabs $0x8046b9,%rax
  802097:	00 00 00 
  80209a:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80209c:	b8 07 00 00 00       	mov    $0x7,%eax
  8020a1:	cd 30                	int    $0x30
  8020a3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8020a6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8020a9:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  8020ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8020b0:	79 30                	jns    8020e2 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8020b2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020b5:	89 c1                	mov    %eax,%ecx
  8020b7:	48 ba 30 4f 80 00 00 	movabs $0x804f30,%rdx
  8020be:	00 00 00 
  8020c1:	be 86 00 00 00       	mov    $0x86,%esi
  8020c6:	48 bf 8d 4e 80 00 00 	movabs $0x804e8d,%rdi
  8020cd:	00 00 00 
  8020d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d5:	49 b8 a5 45 80 00 00 	movabs $0x8045a5,%r8
  8020dc:	00 00 00 
  8020df:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  8020e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8020e6:	75 46                	jne    80212e <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8020e8:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  8020ef:	00 00 00 
  8020f2:	ff d0                	callq  *%rax
  8020f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8020f9:	48 63 d0             	movslq %eax,%rdx
  8020fc:	48 89 d0             	mov    %rdx,%rax
  8020ff:	48 c1 e0 03          	shl    $0x3,%rax
  802103:	48 01 d0             	add    %rdx,%rax
  802106:	48 c1 e0 05          	shl    $0x5,%rax
  80210a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802111:	00 00 00 
  802114:	48 01 c2             	add    %rax,%rdx
  802117:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80211e:	00 00 00 
  802121:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802124:	b8 00 00 00 00       	mov    $0x0,%eax
  802129:	e9 d1 01 00 00       	jmpq   8022ff <fork+0x281>
	}
	uint64_t ad = 0;
  80212e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802135:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802136:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  80213b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80213f:	e9 df 00 00 00       	jmpq   802223 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802144:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802148:	48 c1 e8 27          	shr    $0x27,%rax
  80214c:	48 89 c2             	mov    %rax,%rdx
  80214f:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802156:	01 00 00 
  802159:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80215d:	83 e0 01             	and    $0x1,%eax
  802160:	48 85 c0             	test   %rax,%rax
  802163:	0f 84 9e 00 00 00    	je     802207 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802169:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80216d:	48 c1 e8 1e          	shr    $0x1e,%rax
  802171:	48 89 c2             	mov    %rax,%rdx
  802174:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80217b:	01 00 00 
  80217e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802182:	83 e0 01             	and    $0x1,%eax
  802185:	48 85 c0             	test   %rax,%rax
  802188:	74 73                	je     8021fd <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  80218a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80218e:	48 c1 e8 15          	shr    $0x15,%rax
  802192:	48 89 c2             	mov    %rax,%rdx
  802195:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80219c:	01 00 00 
  80219f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021a3:	83 e0 01             	and    $0x1,%eax
  8021a6:	48 85 c0             	test   %rax,%rax
  8021a9:	74 48                	je     8021f3 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8021ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021af:	48 c1 e8 0c          	shr    $0xc,%rax
  8021b3:	48 89 c2             	mov    %rax,%rdx
  8021b6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021bd:	01 00 00 
  8021c0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8021c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021cc:	83 e0 01             	and    $0x1,%eax
  8021cf:	48 85 c0             	test   %rax,%rax
  8021d2:	74 47                	je     80221b <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  8021d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021d8:	48 c1 e8 0c          	shr    $0xc,%rax
  8021dc:	89 c2                	mov    %eax,%edx
  8021de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021e1:	89 d6                	mov    %edx,%esi
  8021e3:	89 c7                	mov    %eax,%edi
  8021e5:	48 b8 2a 1e 80 00 00 	movabs $0x801e2a,%rax
  8021ec:	00 00 00 
  8021ef:	ff d0                	callq  *%rax
  8021f1:	eb 28                	jmp    80221b <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  8021f3:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8021fa:	00 
  8021fb:	eb 1e                	jmp    80221b <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8021fd:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  802204:	40 
  802205:	eb 14                	jmp    80221b <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  802207:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80220b:	48 c1 e8 27          	shr    $0x27,%rax
  80220f:	48 83 c0 01          	add    $0x1,%rax
  802213:	48 c1 e0 27          	shl    $0x27,%rax
  802217:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80221b:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802222:	00 
  802223:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  80222a:	00 
  80222b:	0f 87 13 ff ff ff    	ja     802144 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802231:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802234:	ba 07 00 00 00       	mov    $0x7,%edx
  802239:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80223e:	89 c7                	mov    %eax,%edi
  802240:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  802247:	00 00 00 
  80224a:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80224c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80224f:	ba 07 00 00 00       	mov    $0x7,%edx
  802254:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802259:	89 c7                	mov    %eax,%edi
  80225b:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  802262:	00 00 00 
  802265:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802267:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80226a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802270:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802275:	ba 00 00 00 00       	mov    $0x0,%edx
  80227a:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80227f:	89 c7                	mov    %eax,%edi
  802281:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  802288:	00 00 00 
  80228b:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  80228d:	ba 00 10 00 00       	mov    $0x1000,%edx
  802292:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802297:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80229c:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  8022a3:	00 00 00 
  8022a6:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8022a8:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8022ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b2:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  8022b9:	00 00 00 
  8022bc:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  8022be:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8022c5:	00 00 00 
  8022c8:	48 8b 00             	mov    (%rax),%rax
  8022cb:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8022d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022d5:	48 89 d6             	mov    %rdx,%rsi
  8022d8:	89 c7                	mov    %eax,%edi
  8022da:	48 b8 e8 1a 80 00 00 	movabs $0x801ae8,%rax
  8022e1:	00 00 00 
  8022e4:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  8022e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022e9:	be 02 00 00 00       	mov    $0x2,%esi
  8022ee:	89 c7                	mov    %eax,%edi
  8022f0:	48 b8 53 1a 80 00 00 	movabs $0x801a53,%rax
  8022f7:	00 00 00 
  8022fa:	ff d0                	callq  *%rax

	return envid;
  8022fc:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8022ff:	c9                   	leaveq 
  802300:	c3                   	retq   

0000000000802301 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802301:	55                   	push   %rbp
  802302:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802305:	48 ba 48 4f 80 00 00 	movabs $0x804f48,%rdx
  80230c:	00 00 00 
  80230f:	be bf 00 00 00       	mov    $0xbf,%esi
  802314:	48 bf 8d 4e 80 00 00 	movabs $0x804e8d,%rdi
  80231b:	00 00 00 
  80231e:	b8 00 00 00 00       	mov    $0x0,%eax
  802323:	48 b9 a5 45 80 00 00 	movabs $0x8045a5,%rcx
  80232a:	00 00 00 
  80232d:	ff d1                	callq  *%rcx

000000000080232f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80232f:	55                   	push   %rbp
  802330:	48 89 e5             	mov    %rsp,%rbp
  802333:	48 83 ec 30          	sub    $0x30,%rsp
  802337:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80233b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80233f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  802343:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80234a:	00 00 00 
  80234d:	48 8b 00             	mov    (%rax),%rax
  802350:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  802356:	85 c0                	test   %eax,%eax
  802358:	75 3c                	jne    802396 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  80235a:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  802361:	00 00 00 
  802364:	ff d0                	callq  *%rax
  802366:	25 ff 03 00 00       	and    $0x3ff,%eax
  80236b:	48 63 d0             	movslq %eax,%rdx
  80236e:	48 89 d0             	mov    %rdx,%rax
  802371:	48 c1 e0 03          	shl    $0x3,%rax
  802375:	48 01 d0             	add    %rdx,%rax
  802378:	48 c1 e0 05          	shl    $0x5,%rax
  80237c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802383:	00 00 00 
  802386:	48 01 c2             	add    %rax,%rdx
  802389:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802390:	00 00 00 
  802393:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  802396:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80239b:	75 0e                	jne    8023ab <ipc_recv+0x7c>
		pg = (void*) UTOP;
  80239d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8023a4:	00 00 00 
  8023a7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8023ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023af:	48 89 c7             	mov    %rax,%rdi
  8023b2:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  8023b9:	00 00 00 
  8023bc:	ff d0                	callq  *%rax
  8023be:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8023c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c5:	79 19                	jns    8023e0 <ipc_recv+0xb1>
		*from_env_store = 0;
  8023c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023cb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8023d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023d5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8023db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023de:	eb 53                	jmp    802433 <ipc_recv+0x104>
	}
	if(from_env_store)
  8023e0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8023e5:	74 19                	je     802400 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  8023e7:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8023ee:	00 00 00 
  8023f1:	48 8b 00             	mov    (%rax),%rax
  8023f4:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8023fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023fe:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  802400:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802405:	74 19                	je     802420 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  802407:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80240e:	00 00 00 
  802411:	48 8b 00             	mov    (%rax),%rax
  802414:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80241a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80241e:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  802420:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802427:	00 00 00 
  80242a:	48 8b 00             	mov    (%rax),%rax
  80242d:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  802433:	c9                   	leaveq 
  802434:	c3                   	retq   

0000000000802435 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802435:	55                   	push   %rbp
  802436:	48 89 e5             	mov    %rsp,%rbp
  802439:	48 83 ec 30          	sub    $0x30,%rsp
  80243d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802440:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802443:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802447:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80244a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80244f:	75 0e                	jne    80245f <ipc_send+0x2a>
		pg = (void*)UTOP;
  802451:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802458:	00 00 00 
  80245b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80245f:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802462:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802465:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802469:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80246c:	89 c7                	mov    %eax,%edi
  80246e:	48 b8 32 1b 80 00 00 	movabs $0x801b32,%rax
  802475:	00 00 00 
  802478:	ff d0                	callq  *%rax
  80247a:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80247d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802481:	75 0c                	jne    80248f <ipc_send+0x5a>
			sys_yield();
  802483:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  80248a:	00 00 00 
  80248d:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80248f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802493:	74 ca                	je     80245f <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  802495:	c9                   	leaveq 
  802496:	c3                   	retq   

0000000000802497 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802497:	55                   	push   %rbp
  802498:	48 89 e5             	mov    %rsp,%rbp
  80249b:	48 83 ec 14          	sub    $0x14,%rsp
  80249f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8024a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024a9:	eb 5e                	jmp    802509 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8024ab:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8024b2:	00 00 00 
  8024b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b8:	48 63 d0             	movslq %eax,%rdx
  8024bb:	48 89 d0             	mov    %rdx,%rax
  8024be:	48 c1 e0 03          	shl    $0x3,%rax
  8024c2:	48 01 d0             	add    %rdx,%rax
  8024c5:	48 c1 e0 05          	shl    $0x5,%rax
  8024c9:	48 01 c8             	add    %rcx,%rax
  8024cc:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8024d2:	8b 00                	mov    (%rax),%eax
  8024d4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8024d7:	75 2c                	jne    802505 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8024d9:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8024e0:	00 00 00 
  8024e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e6:	48 63 d0             	movslq %eax,%rdx
  8024e9:	48 89 d0             	mov    %rdx,%rax
  8024ec:	48 c1 e0 03          	shl    $0x3,%rax
  8024f0:	48 01 d0             	add    %rdx,%rax
  8024f3:	48 c1 e0 05          	shl    $0x5,%rax
  8024f7:	48 01 c8             	add    %rcx,%rax
  8024fa:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802500:	8b 40 08             	mov    0x8(%rax),%eax
  802503:	eb 12                	jmp    802517 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802505:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802509:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802510:	7e 99                	jle    8024ab <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802512:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802517:	c9                   	leaveq 
  802518:	c3                   	retq   

0000000000802519 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802519:	55                   	push   %rbp
  80251a:	48 89 e5             	mov    %rsp,%rbp
  80251d:	48 83 ec 08          	sub    $0x8,%rsp
  802521:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802525:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802529:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802530:	ff ff ff 
  802533:	48 01 d0             	add    %rdx,%rax
  802536:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80253a:	c9                   	leaveq 
  80253b:	c3                   	retq   

000000000080253c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80253c:	55                   	push   %rbp
  80253d:	48 89 e5             	mov    %rsp,%rbp
  802540:	48 83 ec 08          	sub    $0x8,%rsp
  802544:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802548:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80254c:	48 89 c7             	mov    %rax,%rdi
  80254f:	48 b8 19 25 80 00 00 	movabs $0x802519,%rax
  802556:	00 00 00 
  802559:	ff d0                	callq  *%rax
  80255b:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802561:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802565:	c9                   	leaveq 
  802566:	c3                   	retq   

0000000000802567 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802567:	55                   	push   %rbp
  802568:	48 89 e5             	mov    %rsp,%rbp
  80256b:	48 83 ec 18          	sub    $0x18,%rsp
  80256f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802573:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80257a:	eb 6b                	jmp    8025e7 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80257c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80257f:	48 98                	cltq   
  802581:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802587:	48 c1 e0 0c          	shl    $0xc,%rax
  80258b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80258f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802593:	48 c1 e8 15          	shr    $0x15,%rax
  802597:	48 89 c2             	mov    %rax,%rdx
  80259a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025a1:	01 00 00 
  8025a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025a8:	83 e0 01             	and    $0x1,%eax
  8025ab:	48 85 c0             	test   %rax,%rax
  8025ae:	74 21                	je     8025d1 <fd_alloc+0x6a>
  8025b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b4:	48 c1 e8 0c          	shr    $0xc,%rax
  8025b8:	48 89 c2             	mov    %rax,%rdx
  8025bb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025c2:	01 00 00 
  8025c5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025c9:	83 e0 01             	and    $0x1,%eax
  8025cc:	48 85 c0             	test   %rax,%rax
  8025cf:	75 12                	jne    8025e3 <fd_alloc+0x7c>
			*fd_store = fd;
  8025d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025d9:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e1:	eb 1a                	jmp    8025fd <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8025e3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025e7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8025eb:	7e 8f                	jle    80257c <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8025ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8025f8:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8025fd:	c9                   	leaveq 
  8025fe:	c3                   	retq   

00000000008025ff <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8025ff:	55                   	push   %rbp
  802600:	48 89 e5             	mov    %rsp,%rbp
  802603:	48 83 ec 20          	sub    $0x20,%rsp
  802607:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80260a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80260e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802612:	78 06                	js     80261a <fd_lookup+0x1b>
  802614:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802618:	7e 07                	jle    802621 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80261a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80261f:	eb 6c                	jmp    80268d <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802621:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802624:	48 98                	cltq   
  802626:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80262c:	48 c1 e0 0c          	shl    $0xc,%rax
  802630:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802634:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802638:	48 c1 e8 15          	shr    $0x15,%rax
  80263c:	48 89 c2             	mov    %rax,%rdx
  80263f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802646:	01 00 00 
  802649:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80264d:	83 e0 01             	and    $0x1,%eax
  802650:	48 85 c0             	test   %rax,%rax
  802653:	74 21                	je     802676 <fd_lookup+0x77>
  802655:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802659:	48 c1 e8 0c          	shr    $0xc,%rax
  80265d:	48 89 c2             	mov    %rax,%rdx
  802660:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802667:	01 00 00 
  80266a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80266e:	83 e0 01             	and    $0x1,%eax
  802671:	48 85 c0             	test   %rax,%rax
  802674:	75 07                	jne    80267d <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802676:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80267b:	eb 10                	jmp    80268d <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80267d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802681:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802685:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802688:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80268d:	c9                   	leaveq 
  80268e:	c3                   	retq   

000000000080268f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80268f:	55                   	push   %rbp
  802690:	48 89 e5             	mov    %rsp,%rbp
  802693:	48 83 ec 30          	sub    $0x30,%rsp
  802697:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80269b:	89 f0                	mov    %esi,%eax
  80269d:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8026a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026a4:	48 89 c7             	mov    %rax,%rdi
  8026a7:	48 b8 19 25 80 00 00 	movabs $0x802519,%rax
  8026ae:	00 00 00 
  8026b1:	ff d0                	callq  *%rax
  8026b3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026b7:	48 89 d6             	mov    %rdx,%rsi
  8026ba:	89 c7                	mov    %eax,%edi
  8026bc:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  8026c3:	00 00 00 
  8026c6:	ff d0                	callq  *%rax
  8026c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026cf:	78 0a                	js     8026db <fd_close+0x4c>
	    || fd != fd2)
  8026d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026d5:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8026d9:	74 12                	je     8026ed <fd_close+0x5e>
		return (must_exist ? r : 0);
  8026db:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8026df:	74 05                	je     8026e6 <fd_close+0x57>
  8026e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e4:	eb 05                	jmp    8026eb <fd_close+0x5c>
  8026e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026eb:	eb 69                	jmp    802756 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8026ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026f1:	8b 00                	mov    (%rax),%eax
  8026f3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026f7:	48 89 d6             	mov    %rdx,%rsi
  8026fa:	89 c7                	mov    %eax,%edi
  8026fc:	48 b8 58 27 80 00 00 	movabs $0x802758,%rax
  802703:	00 00 00 
  802706:	ff d0                	callq  *%rax
  802708:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80270b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80270f:	78 2a                	js     80273b <fd_close+0xac>
		if (dev->dev_close)
  802711:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802715:	48 8b 40 20          	mov    0x20(%rax),%rax
  802719:	48 85 c0             	test   %rax,%rax
  80271c:	74 16                	je     802734 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80271e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802722:	48 8b 40 20          	mov    0x20(%rax),%rax
  802726:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80272a:	48 89 d7             	mov    %rdx,%rdi
  80272d:	ff d0                	callq  *%rax
  80272f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802732:	eb 07                	jmp    80273b <fd_close+0xac>
		else
			r = 0;
  802734:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80273b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80273f:	48 89 c6             	mov    %rax,%rsi
  802742:	bf 00 00 00 00       	mov    $0x0,%edi
  802747:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  80274e:	00 00 00 
  802751:	ff d0                	callq  *%rax
	return r;
  802753:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802756:	c9                   	leaveq 
  802757:	c3                   	retq   

0000000000802758 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802758:	55                   	push   %rbp
  802759:	48 89 e5             	mov    %rsp,%rbp
  80275c:	48 83 ec 20          	sub    $0x20,%rsp
  802760:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802763:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802767:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80276e:	eb 41                	jmp    8027b1 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802770:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802777:	00 00 00 
  80277a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80277d:	48 63 d2             	movslq %edx,%rdx
  802780:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802784:	8b 00                	mov    (%rax),%eax
  802786:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802789:	75 22                	jne    8027ad <dev_lookup+0x55>
			*dev = devtab[i];
  80278b:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802792:	00 00 00 
  802795:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802798:	48 63 d2             	movslq %edx,%rdx
  80279b:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80279f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027a3:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8027a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ab:	eb 60                	jmp    80280d <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8027ad:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027b1:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8027b8:	00 00 00 
  8027bb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027be:	48 63 d2             	movslq %edx,%rdx
  8027c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027c5:	48 85 c0             	test   %rax,%rax
  8027c8:	75 a6                	jne    802770 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8027ca:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8027d1:	00 00 00 
  8027d4:	48 8b 00             	mov    (%rax),%rax
  8027d7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027dd:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8027e0:	89 c6                	mov    %eax,%esi
  8027e2:	48 bf 60 4f 80 00 00 	movabs $0x804f60,%rdi
  8027e9:	00 00 00 
  8027ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f1:	48 b9 7a 04 80 00 00 	movabs $0x80047a,%rcx
  8027f8:	00 00 00 
  8027fb:	ff d1                	callq  *%rcx
	*dev = 0;
  8027fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802801:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802808:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80280d:	c9                   	leaveq 
  80280e:	c3                   	retq   

000000000080280f <close>:

int
close(int fdnum)
{
  80280f:	55                   	push   %rbp
  802810:	48 89 e5             	mov    %rsp,%rbp
  802813:	48 83 ec 20          	sub    $0x20,%rsp
  802817:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80281a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80281e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802821:	48 89 d6             	mov    %rdx,%rsi
  802824:	89 c7                	mov    %eax,%edi
  802826:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  80282d:	00 00 00 
  802830:	ff d0                	callq  *%rax
  802832:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802835:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802839:	79 05                	jns    802840 <close+0x31>
		return r;
  80283b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80283e:	eb 18                	jmp    802858 <close+0x49>
	else
		return fd_close(fd, 1);
  802840:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802844:	be 01 00 00 00       	mov    $0x1,%esi
  802849:	48 89 c7             	mov    %rax,%rdi
  80284c:	48 b8 8f 26 80 00 00 	movabs $0x80268f,%rax
  802853:	00 00 00 
  802856:	ff d0                	callq  *%rax
}
  802858:	c9                   	leaveq 
  802859:	c3                   	retq   

000000000080285a <close_all>:

void
close_all(void)
{
  80285a:	55                   	push   %rbp
  80285b:	48 89 e5             	mov    %rsp,%rbp
  80285e:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802862:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802869:	eb 15                	jmp    802880 <close_all+0x26>
		close(i);
  80286b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80286e:	89 c7                	mov    %eax,%edi
  802870:	48 b8 0f 28 80 00 00 	movabs $0x80280f,%rax
  802877:	00 00 00 
  80287a:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80287c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802880:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802884:	7e e5                	jle    80286b <close_all+0x11>
		close(i);
}
  802886:	c9                   	leaveq 
  802887:	c3                   	retq   

0000000000802888 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802888:	55                   	push   %rbp
  802889:	48 89 e5             	mov    %rsp,%rbp
  80288c:	48 83 ec 40          	sub    $0x40,%rsp
  802890:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802893:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802896:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80289a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80289d:	48 89 d6             	mov    %rdx,%rsi
  8028a0:	89 c7                	mov    %eax,%edi
  8028a2:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  8028a9:	00 00 00 
  8028ac:	ff d0                	callq  *%rax
  8028ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b5:	79 08                	jns    8028bf <dup+0x37>
		return r;
  8028b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ba:	e9 70 01 00 00       	jmpq   802a2f <dup+0x1a7>
	close(newfdnum);
  8028bf:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028c2:	89 c7                	mov    %eax,%edi
  8028c4:	48 b8 0f 28 80 00 00 	movabs $0x80280f,%rax
  8028cb:	00 00 00 
  8028ce:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8028d0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028d3:	48 98                	cltq   
  8028d5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028db:	48 c1 e0 0c          	shl    $0xc,%rax
  8028df:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8028e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028e7:	48 89 c7             	mov    %rax,%rdi
  8028ea:	48 b8 3c 25 80 00 00 	movabs $0x80253c,%rax
  8028f1:	00 00 00 
  8028f4:	ff d0                	callq  *%rax
  8028f6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8028fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028fe:	48 89 c7             	mov    %rax,%rdi
  802901:	48 b8 3c 25 80 00 00 	movabs $0x80253c,%rax
  802908:	00 00 00 
  80290b:	ff d0                	callq  *%rax
  80290d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802911:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802915:	48 c1 e8 15          	shr    $0x15,%rax
  802919:	48 89 c2             	mov    %rax,%rdx
  80291c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802923:	01 00 00 
  802926:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80292a:	83 e0 01             	and    $0x1,%eax
  80292d:	48 85 c0             	test   %rax,%rax
  802930:	74 73                	je     8029a5 <dup+0x11d>
  802932:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802936:	48 c1 e8 0c          	shr    $0xc,%rax
  80293a:	48 89 c2             	mov    %rax,%rdx
  80293d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802944:	01 00 00 
  802947:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80294b:	83 e0 01             	and    $0x1,%eax
  80294e:	48 85 c0             	test   %rax,%rax
  802951:	74 52                	je     8029a5 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802953:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802957:	48 c1 e8 0c          	shr    $0xc,%rax
  80295b:	48 89 c2             	mov    %rax,%rdx
  80295e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802965:	01 00 00 
  802968:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80296c:	25 07 0e 00 00       	and    $0xe07,%eax
  802971:	89 c1                	mov    %eax,%ecx
  802973:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802977:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80297b:	41 89 c8             	mov    %ecx,%r8d
  80297e:	48 89 d1             	mov    %rdx,%rcx
  802981:	ba 00 00 00 00       	mov    $0x0,%edx
  802986:	48 89 c6             	mov    %rax,%rsi
  802989:	bf 00 00 00 00       	mov    $0x0,%edi
  80298e:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  802995:	00 00 00 
  802998:	ff d0                	callq  *%rax
  80299a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80299d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029a1:	79 02                	jns    8029a5 <dup+0x11d>
			goto err;
  8029a3:	eb 57                	jmp    8029fc <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8029a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029a9:	48 c1 e8 0c          	shr    $0xc,%rax
  8029ad:	48 89 c2             	mov    %rax,%rdx
  8029b0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029b7:	01 00 00 
  8029ba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029be:	25 07 0e 00 00       	and    $0xe07,%eax
  8029c3:	89 c1                	mov    %eax,%ecx
  8029c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029cd:	41 89 c8             	mov    %ecx,%r8d
  8029d0:	48 89 d1             	mov    %rdx,%rcx
  8029d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8029d8:	48 89 c6             	mov    %rax,%rsi
  8029db:	bf 00 00 00 00       	mov    $0x0,%edi
  8029e0:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  8029e7:	00 00 00 
  8029ea:	ff d0                	callq  *%rax
  8029ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f3:	79 02                	jns    8029f7 <dup+0x16f>
		goto err;
  8029f5:	eb 05                	jmp    8029fc <dup+0x174>

	return newfdnum;
  8029f7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029fa:	eb 33                	jmp    802a2f <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8029fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a00:	48 89 c6             	mov    %rax,%rsi
  802a03:	bf 00 00 00 00       	mov    $0x0,%edi
  802a08:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  802a0f:	00 00 00 
  802a12:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802a14:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a18:	48 89 c6             	mov    %rax,%rsi
  802a1b:	bf 00 00 00 00       	mov    $0x0,%edi
  802a20:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  802a27:	00 00 00 
  802a2a:	ff d0                	callq  *%rax
	return r;
  802a2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a2f:	c9                   	leaveq 
  802a30:	c3                   	retq   

0000000000802a31 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802a31:	55                   	push   %rbp
  802a32:	48 89 e5             	mov    %rsp,%rbp
  802a35:	48 83 ec 40          	sub    $0x40,%rsp
  802a39:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a3c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a40:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a44:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a48:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a4b:	48 89 d6             	mov    %rdx,%rsi
  802a4e:	89 c7                	mov    %eax,%edi
  802a50:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  802a57:	00 00 00 
  802a5a:	ff d0                	callq  *%rax
  802a5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a63:	78 24                	js     802a89 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a69:	8b 00                	mov    (%rax),%eax
  802a6b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a6f:	48 89 d6             	mov    %rdx,%rsi
  802a72:	89 c7                	mov    %eax,%edi
  802a74:	48 b8 58 27 80 00 00 	movabs $0x802758,%rax
  802a7b:	00 00 00 
  802a7e:	ff d0                	callq  *%rax
  802a80:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a87:	79 05                	jns    802a8e <read+0x5d>
		return r;
  802a89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a8c:	eb 76                	jmp    802b04 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802a8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a92:	8b 40 08             	mov    0x8(%rax),%eax
  802a95:	83 e0 03             	and    $0x3,%eax
  802a98:	83 f8 01             	cmp    $0x1,%eax
  802a9b:	75 3a                	jne    802ad7 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802a9d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802aa4:	00 00 00 
  802aa7:	48 8b 00             	mov    (%rax),%rax
  802aaa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ab0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ab3:	89 c6                	mov    %eax,%esi
  802ab5:	48 bf 7f 4f 80 00 00 	movabs $0x804f7f,%rdi
  802abc:	00 00 00 
  802abf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac4:	48 b9 7a 04 80 00 00 	movabs $0x80047a,%rcx
  802acb:	00 00 00 
  802ace:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ad0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ad5:	eb 2d                	jmp    802b04 <read+0xd3>
	}
	if (!dev->dev_read)
  802ad7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802adb:	48 8b 40 10          	mov    0x10(%rax),%rax
  802adf:	48 85 c0             	test   %rax,%rax
  802ae2:	75 07                	jne    802aeb <read+0xba>
		return -E_NOT_SUPP;
  802ae4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ae9:	eb 19                	jmp    802b04 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802aeb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aef:	48 8b 40 10          	mov    0x10(%rax),%rax
  802af3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802af7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802afb:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802aff:	48 89 cf             	mov    %rcx,%rdi
  802b02:	ff d0                	callq  *%rax
}
  802b04:	c9                   	leaveq 
  802b05:	c3                   	retq   

0000000000802b06 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802b06:	55                   	push   %rbp
  802b07:	48 89 e5             	mov    %rsp,%rbp
  802b0a:	48 83 ec 30          	sub    $0x30,%rsp
  802b0e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b11:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b15:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b19:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b20:	eb 49                	jmp    802b6b <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802b22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b25:	48 98                	cltq   
  802b27:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b2b:	48 29 c2             	sub    %rax,%rdx
  802b2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b31:	48 63 c8             	movslq %eax,%rcx
  802b34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b38:	48 01 c1             	add    %rax,%rcx
  802b3b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b3e:	48 89 ce             	mov    %rcx,%rsi
  802b41:	89 c7                	mov    %eax,%edi
  802b43:	48 b8 31 2a 80 00 00 	movabs $0x802a31,%rax
  802b4a:	00 00 00 
  802b4d:	ff d0                	callq  *%rax
  802b4f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802b52:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b56:	79 05                	jns    802b5d <readn+0x57>
			return m;
  802b58:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b5b:	eb 1c                	jmp    802b79 <readn+0x73>
		if (m == 0)
  802b5d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b61:	75 02                	jne    802b65 <readn+0x5f>
			break;
  802b63:	eb 11                	jmp    802b76 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b65:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b68:	01 45 fc             	add    %eax,-0x4(%rbp)
  802b6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b6e:	48 98                	cltq   
  802b70:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b74:	72 ac                	jb     802b22 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802b76:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b79:	c9                   	leaveq 
  802b7a:	c3                   	retq   

0000000000802b7b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802b7b:	55                   	push   %rbp
  802b7c:	48 89 e5             	mov    %rsp,%rbp
  802b7f:	48 83 ec 40          	sub    $0x40,%rsp
  802b83:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b86:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b8a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b8e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b92:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b95:	48 89 d6             	mov    %rdx,%rsi
  802b98:	89 c7                	mov    %eax,%edi
  802b9a:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  802ba1:	00 00 00 
  802ba4:	ff d0                	callq  *%rax
  802ba6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ba9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bad:	78 24                	js     802bd3 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802baf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb3:	8b 00                	mov    (%rax),%eax
  802bb5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bb9:	48 89 d6             	mov    %rdx,%rsi
  802bbc:	89 c7                	mov    %eax,%edi
  802bbe:	48 b8 58 27 80 00 00 	movabs $0x802758,%rax
  802bc5:	00 00 00 
  802bc8:	ff d0                	callq  *%rax
  802bca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd1:	79 05                	jns    802bd8 <write+0x5d>
		return r;
  802bd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd6:	eb 75                	jmp    802c4d <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802bd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bdc:	8b 40 08             	mov    0x8(%rax),%eax
  802bdf:	83 e0 03             	and    $0x3,%eax
  802be2:	85 c0                	test   %eax,%eax
  802be4:	75 3a                	jne    802c20 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802be6:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802bed:	00 00 00 
  802bf0:	48 8b 00             	mov    (%rax),%rax
  802bf3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802bf9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802bfc:	89 c6                	mov    %eax,%esi
  802bfe:	48 bf 9b 4f 80 00 00 	movabs $0x804f9b,%rdi
  802c05:	00 00 00 
  802c08:	b8 00 00 00 00       	mov    $0x0,%eax
  802c0d:	48 b9 7a 04 80 00 00 	movabs $0x80047a,%rcx
  802c14:	00 00 00 
  802c17:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c19:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c1e:	eb 2d                	jmp    802c4d <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802c20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c24:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c28:	48 85 c0             	test   %rax,%rax
  802c2b:	75 07                	jne    802c34 <write+0xb9>
		return -E_NOT_SUPP;
  802c2d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c32:	eb 19                	jmp    802c4d <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802c34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c38:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c3c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c40:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c44:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c48:	48 89 cf             	mov    %rcx,%rdi
  802c4b:	ff d0                	callq  *%rax
}
  802c4d:	c9                   	leaveq 
  802c4e:	c3                   	retq   

0000000000802c4f <seek>:

int
seek(int fdnum, off_t offset)
{
  802c4f:	55                   	push   %rbp
  802c50:	48 89 e5             	mov    %rsp,%rbp
  802c53:	48 83 ec 18          	sub    $0x18,%rsp
  802c57:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c5a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c5d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c61:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c64:	48 89 d6             	mov    %rdx,%rsi
  802c67:	89 c7                	mov    %eax,%edi
  802c69:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  802c70:	00 00 00 
  802c73:	ff d0                	callq  *%rax
  802c75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c7c:	79 05                	jns    802c83 <seek+0x34>
		return r;
  802c7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c81:	eb 0f                	jmp    802c92 <seek+0x43>
	fd->fd_offset = offset;
  802c83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c87:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c8a:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802c8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c92:	c9                   	leaveq 
  802c93:	c3                   	retq   

0000000000802c94 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802c94:	55                   	push   %rbp
  802c95:	48 89 e5             	mov    %rsp,%rbp
  802c98:	48 83 ec 30          	sub    $0x30,%rsp
  802c9c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c9f:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ca2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ca6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ca9:	48 89 d6             	mov    %rdx,%rsi
  802cac:	89 c7                	mov    %eax,%edi
  802cae:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  802cb5:	00 00 00 
  802cb8:	ff d0                	callq  *%rax
  802cba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cc1:	78 24                	js     802ce7 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802cc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc7:	8b 00                	mov    (%rax),%eax
  802cc9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ccd:	48 89 d6             	mov    %rdx,%rsi
  802cd0:	89 c7                	mov    %eax,%edi
  802cd2:	48 b8 58 27 80 00 00 	movabs $0x802758,%rax
  802cd9:	00 00 00 
  802cdc:	ff d0                	callq  *%rax
  802cde:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ce1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ce5:	79 05                	jns    802cec <ftruncate+0x58>
		return r;
  802ce7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cea:	eb 72                	jmp    802d5e <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802cec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf0:	8b 40 08             	mov    0x8(%rax),%eax
  802cf3:	83 e0 03             	and    $0x3,%eax
  802cf6:	85 c0                	test   %eax,%eax
  802cf8:	75 3a                	jne    802d34 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802cfa:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802d01:	00 00 00 
  802d04:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802d07:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d0d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d10:	89 c6                	mov    %eax,%esi
  802d12:	48 bf b8 4f 80 00 00 	movabs $0x804fb8,%rdi
  802d19:	00 00 00 
  802d1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d21:	48 b9 7a 04 80 00 00 	movabs $0x80047a,%rcx
  802d28:	00 00 00 
  802d2b:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802d2d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d32:	eb 2a                	jmp    802d5e <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802d34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d38:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d3c:	48 85 c0             	test   %rax,%rax
  802d3f:	75 07                	jne    802d48 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802d41:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d46:	eb 16                	jmp    802d5e <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802d48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d4c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d50:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d54:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802d57:	89 ce                	mov    %ecx,%esi
  802d59:	48 89 d7             	mov    %rdx,%rdi
  802d5c:	ff d0                	callq  *%rax
}
  802d5e:	c9                   	leaveq 
  802d5f:	c3                   	retq   

0000000000802d60 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802d60:	55                   	push   %rbp
  802d61:	48 89 e5             	mov    %rsp,%rbp
  802d64:	48 83 ec 30          	sub    $0x30,%rsp
  802d68:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d6b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d6f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d73:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d76:	48 89 d6             	mov    %rdx,%rsi
  802d79:	89 c7                	mov    %eax,%edi
  802d7b:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  802d82:	00 00 00 
  802d85:	ff d0                	callq  *%rax
  802d87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d8e:	78 24                	js     802db4 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d94:	8b 00                	mov    (%rax),%eax
  802d96:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d9a:	48 89 d6             	mov    %rdx,%rsi
  802d9d:	89 c7                	mov    %eax,%edi
  802d9f:	48 b8 58 27 80 00 00 	movabs $0x802758,%rax
  802da6:	00 00 00 
  802da9:	ff d0                	callq  *%rax
  802dab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db2:	79 05                	jns    802db9 <fstat+0x59>
		return r;
  802db4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db7:	eb 5e                	jmp    802e17 <fstat+0xb7>
	if (!dev->dev_stat)
  802db9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dbd:	48 8b 40 28          	mov    0x28(%rax),%rax
  802dc1:	48 85 c0             	test   %rax,%rax
  802dc4:	75 07                	jne    802dcd <fstat+0x6d>
		return -E_NOT_SUPP;
  802dc6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dcb:	eb 4a                	jmp    802e17 <fstat+0xb7>
	stat->st_name[0] = 0;
  802dcd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dd1:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802dd4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dd8:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802ddf:	00 00 00 
	stat->st_isdir = 0;
  802de2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802de6:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802ded:	00 00 00 
	stat->st_dev = dev;
  802df0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802df4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802df8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802dff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e03:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e07:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e0b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802e0f:	48 89 ce             	mov    %rcx,%rsi
  802e12:	48 89 d7             	mov    %rdx,%rdi
  802e15:	ff d0                	callq  *%rax
}
  802e17:	c9                   	leaveq 
  802e18:	c3                   	retq   

0000000000802e19 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802e19:	55                   	push   %rbp
  802e1a:	48 89 e5             	mov    %rsp,%rbp
  802e1d:	48 83 ec 20          	sub    $0x20,%rsp
  802e21:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e25:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802e29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e2d:	be 00 00 00 00       	mov    $0x0,%esi
  802e32:	48 89 c7             	mov    %rax,%rdi
  802e35:	48 b8 07 2f 80 00 00 	movabs $0x802f07,%rax
  802e3c:	00 00 00 
  802e3f:	ff d0                	callq  *%rax
  802e41:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e48:	79 05                	jns    802e4f <stat+0x36>
		return fd;
  802e4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4d:	eb 2f                	jmp    802e7e <stat+0x65>
	r = fstat(fd, stat);
  802e4f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e56:	48 89 d6             	mov    %rdx,%rsi
  802e59:	89 c7                	mov    %eax,%edi
  802e5b:	48 b8 60 2d 80 00 00 	movabs $0x802d60,%rax
  802e62:	00 00 00 
  802e65:	ff d0                	callq  *%rax
  802e67:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802e6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e6d:	89 c7                	mov    %eax,%edi
  802e6f:	48 b8 0f 28 80 00 00 	movabs $0x80280f,%rax
  802e76:	00 00 00 
  802e79:	ff d0                	callq  *%rax
	return r;
  802e7b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802e7e:	c9                   	leaveq 
  802e7f:	c3                   	retq   

0000000000802e80 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802e80:	55                   	push   %rbp
  802e81:	48 89 e5             	mov    %rsp,%rbp
  802e84:	48 83 ec 10          	sub    $0x10,%rsp
  802e88:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e8b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802e8f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e96:	00 00 00 
  802e99:	8b 00                	mov    (%rax),%eax
  802e9b:	85 c0                	test   %eax,%eax
  802e9d:	75 1d                	jne    802ebc <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802e9f:	bf 01 00 00 00       	mov    $0x1,%edi
  802ea4:	48 b8 97 24 80 00 00 	movabs $0x802497,%rax
  802eab:	00 00 00 
  802eae:	ff d0                	callq  *%rax
  802eb0:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802eb7:	00 00 00 
  802eba:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802ebc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ec3:	00 00 00 
  802ec6:	8b 00                	mov    (%rax),%eax
  802ec8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802ecb:	b9 07 00 00 00       	mov    $0x7,%ecx
  802ed0:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802ed7:	00 00 00 
  802eda:	89 c7                	mov    %eax,%edi
  802edc:	48 b8 35 24 80 00 00 	movabs $0x802435,%rax
  802ee3:	00 00 00 
  802ee6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802ee8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eec:	ba 00 00 00 00       	mov    $0x0,%edx
  802ef1:	48 89 c6             	mov    %rax,%rsi
  802ef4:	bf 00 00 00 00       	mov    $0x0,%edi
  802ef9:	48 b8 2f 23 80 00 00 	movabs $0x80232f,%rax
  802f00:	00 00 00 
  802f03:	ff d0                	callq  *%rax
}
  802f05:	c9                   	leaveq 
  802f06:	c3                   	retq   

0000000000802f07 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802f07:	55                   	push   %rbp
  802f08:	48 89 e5             	mov    %rsp,%rbp
  802f0b:	48 83 ec 30          	sub    $0x30,%rsp
  802f0f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802f13:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802f16:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802f1d:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802f24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802f2b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802f30:	75 08                	jne    802f3a <open+0x33>
	{
		return r;
  802f32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f35:	e9 f2 00 00 00       	jmpq   80302c <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802f3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f3e:	48 89 c7             	mov    %rax,%rdi
  802f41:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  802f48:	00 00 00 
  802f4b:	ff d0                	callq  *%rax
  802f4d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802f50:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802f57:	7e 0a                	jle    802f63 <open+0x5c>
	{
		return -E_BAD_PATH;
  802f59:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f5e:	e9 c9 00 00 00       	jmpq   80302c <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802f63:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802f6a:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802f6b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802f6f:	48 89 c7             	mov    %rax,%rdi
  802f72:	48 b8 67 25 80 00 00 	movabs $0x802567,%rax
  802f79:	00 00 00 
  802f7c:	ff d0                	callq  *%rax
  802f7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f85:	78 09                	js     802f90 <open+0x89>
  802f87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f8b:	48 85 c0             	test   %rax,%rax
  802f8e:	75 08                	jne    802f98 <open+0x91>
		{
			return r;
  802f90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f93:	e9 94 00 00 00       	jmpq   80302c <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802f98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f9c:	ba 00 04 00 00       	mov    $0x400,%edx
  802fa1:	48 89 c6             	mov    %rax,%rsi
  802fa4:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802fab:	00 00 00 
  802fae:	48 b8 c1 10 80 00 00 	movabs $0x8010c1,%rax
  802fb5:	00 00 00 
  802fb8:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802fba:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fc1:	00 00 00 
  802fc4:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802fc7:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802fcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd1:	48 89 c6             	mov    %rax,%rsi
  802fd4:	bf 01 00 00 00       	mov    $0x1,%edi
  802fd9:	48 b8 80 2e 80 00 00 	movabs $0x802e80,%rax
  802fe0:	00 00 00 
  802fe3:	ff d0                	callq  *%rax
  802fe5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fe8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fec:	79 2b                	jns    803019 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802fee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ff2:	be 00 00 00 00       	mov    $0x0,%esi
  802ff7:	48 89 c7             	mov    %rax,%rdi
  802ffa:	48 b8 8f 26 80 00 00 	movabs $0x80268f,%rax
  803001:	00 00 00 
  803004:	ff d0                	callq  *%rax
  803006:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803009:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80300d:	79 05                	jns    803014 <open+0x10d>
			{
				return d;
  80300f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803012:	eb 18                	jmp    80302c <open+0x125>
			}
			return r;
  803014:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803017:	eb 13                	jmp    80302c <open+0x125>
		}	
		return fd2num(fd_store);
  803019:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80301d:	48 89 c7             	mov    %rax,%rdi
  803020:	48 b8 19 25 80 00 00 	movabs $0x802519,%rax
  803027:	00 00 00 
  80302a:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80302c:	c9                   	leaveq 
  80302d:	c3                   	retq   

000000000080302e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80302e:	55                   	push   %rbp
  80302f:	48 89 e5             	mov    %rsp,%rbp
  803032:	48 83 ec 10          	sub    $0x10,%rsp
  803036:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80303a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80303e:	8b 50 0c             	mov    0xc(%rax),%edx
  803041:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803048:	00 00 00 
  80304b:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80304d:	be 00 00 00 00       	mov    $0x0,%esi
  803052:	bf 06 00 00 00       	mov    $0x6,%edi
  803057:	48 b8 80 2e 80 00 00 	movabs $0x802e80,%rax
  80305e:	00 00 00 
  803061:	ff d0                	callq  *%rax
}
  803063:	c9                   	leaveq 
  803064:	c3                   	retq   

0000000000803065 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803065:	55                   	push   %rbp
  803066:	48 89 e5             	mov    %rsp,%rbp
  803069:	48 83 ec 30          	sub    $0x30,%rsp
  80306d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803071:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803075:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  803079:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  803080:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803085:	74 07                	je     80308e <devfile_read+0x29>
  803087:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80308c:	75 07                	jne    803095 <devfile_read+0x30>
		return -E_INVAL;
  80308e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803093:	eb 77                	jmp    80310c <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803095:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803099:	8b 50 0c             	mov    0xc(%rax),%edx
  80309c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030a3:	00 00 00 
  8030a6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8030a8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030af:	00 00 00 
  8030b2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030b6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8030ba:	be 00 00 00 00       	mov    $0x0,%esi
  8030bf:	bf 03 00 00 00       	mov    $0x3,%edi
  8030c4:	48 b8 80 2e 80 00 00 	movabs $0x802e80,%rax
  8030cb:	00 00 00 
  8030ce:	ff d0                	callq  *%rax
  8030d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d7:	7f 05                	jg     8030de <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8030d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030dc:	eb 2e                	jmp    80310c <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8030de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e1:	48 63 d0             	movslq %eax,%rdx
  8030e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030e8:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8030ef:	00 00 00 
  8030f2:	48 89 c7             	mov    %rax,%rdi
  8030f5:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  8030fc:	00 00 00 
  8030ff:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803101:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803105:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803109:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80310c:	c9                   	leaveq 
  80310d:	c3                   	retq   

000000000080310e <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80310e:	55                   	push   %rbp
  80310f:	48 89 e5             	mov    %rsp,%rbp
  803112:	48 83 ec 30          	sub    $0x30,%rsp
  803116:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80311a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80311e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  803122:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  803129:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80312e:	74 07                	je     803137 <devfile_write+0x29>
  803130:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803135:	75 08                	jne    80313f <devfile_write+0x31>
		return r;
  803137:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313a:	e9 9a 00 00 00       	jmpq   8031d9 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80313f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803143:	8b 50 0c             	mov    0xc(%rax),%edx
  803146:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80314d:	00 00 00 
  803150:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  803152:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803159:	00 
  80315a:	76 08                	jbe    803164 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80315c:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803163:	00 
	}
	fsipcbuf.write.req_n = n;
  803164:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80316b:	00 00 00 
  80316e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803172:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  803176:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80317a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80317e:	48 89 c6             	mov    %rax,%rsi
  803181:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803188:	00 00 00 
  80318b:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  803192:	00 00 00 
  803195:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803197:	be 00 00 00 00       	mov    $0x0,%esi
  80319c:	bf 04 00 00 00       	mov    $0x4,%edi
  8031a1:	48 b8 80 2e 80 00 00 	movabs $0x802e80,%rax
  8031a8:	00 00 00 
  8031ab:	ff d0                	callq  *%rax
  8031ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031b4:	7f 20                	jg     8031d6 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8031b6:	48 bf de 4f 80 00 00 	movabs $0x804fde,%rdi
  8031bd:	00 00 00 
  8031c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c5:	48 ba 7a 04 80 00 00 	movabs $0x80047a,%rdx
  8031cc:	00 00 00 
  8031cf:	ff d2                	callq  *%rdx
		return r;
  8031d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d4:	eb 03                	jmp    8031d9 <devfile_write+0xcb>
	}
	return r;
  8031d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8031d9:	c9                   	leaveq 
  8031da:	c3                   	retq   

00000000008031db <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8031db:	55                   	push   %rbp
  8031dc:	48 89 e5             	mov    %rsp,%rbp
  8031df:	48 83 ec 20          	sub    $0x20,%rsp
  8031e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8031eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031ef:	8b 50 0c             	mov    0xc(%rax),%edx
  8031f2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031f9:	00 00 00 
  8031fc:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8031fe:	be 00 00 00 00       	mov    $0x0,%esi
  803203:	bf 05 00 00 00       	mov    $0x5,%edi
  803208:	48 b8 80 2e 80 00 00 	movabs $0x802e80,%rax
  80320f:	00 00 00 
  803212:	ff d0                	callq  *%rax
  803214:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803217:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80321b:	79 05                	jns    803222 <devfile_stat+0x47>
		return r;
  80321d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803220:	eb 56                	jmp    803278 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803222:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803226:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80322d:	00 00 00 
  803230:	48 89 c7             	mov    %rax,%rdi
  803233:	48 b8 2f 10 80 00 00 	movabs $0x80102f,%rax
  80323a:	00 00 00 
  80323d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80323f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803246:	00 00 00 
  803249:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80324f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803253:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803259:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803260:	00 00 00 
  803263:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803269:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80326d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803273:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803278:	c9                   	leaveq 
  803279:	c3                   	retq   

000000000080327a <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80327a:	55                   	push   %rbp
  80327b:	48 89 e5             	mov    %rsp,%rbp
  80327e:	48 83 ec 10          	sub    $0x10,%rsp
  803282:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803286:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803289:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80328d:	8b 50 0c             	mov    0xc(%rax),%edx
  803290:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803297:	00 00 00 
  80329a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80329c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032a3:	00 00 00 
  8032a6:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8032a9:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8032ac:	be 00 00 00 00       	mov    $0x0,%esi
  8032b1:	bf 02 00 00 00       	mov    $0x2,%edi
  8032b6:	48 b8 80 2e 80 00 00 	movabs $0x802e80,%rax
  8032bd:	00 00 00 
  8032c0:	ff d0                	callq  *%rax
}
  8032c2:	c9                   	leaveq 
  8032c3:	c3                   	retq   

00000000008032c4 <remove>:

// Delete a file
int
remove(const char *path)
{
  8032c4:	55                   	push   %rbp
  8032c5:	48 89 e5             	mov    %rsp,%rbp
  8032c8:	48 83 ec 10          	sub    $0x10,%rsp
  8032cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8032d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032d4:	48 89 c7             	mov    %rax,%rdi
  8032d7:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  8032de:	00 00 00 
  8032e1:	ff d0                	callq  *%rax
  8032e3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8032e8:	7e 07                	jle    8032f1 <remove+0x2d>
		return -E_BAD_PATH;
  8032ea:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8032ef:	eb 33                	jmp    803324 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8032f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032f5:	48 89 c6             	mov    %rax,%rsi
  8032f8:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8032ff:	00 00 00 
  803302:	48 b8 2f 10 80 00 00 	movabs $0x80102f,%rax
  803309:	00 00 00 
  80330c:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80330e:	be 00 00 00 00       	mov    $0x0,%esi
  803313:	bf 07 00 00 00       	mov    $0x7,%edi
  803318:	48 b8 80 2e 80 00 00 	movabs $0x802e80,%rax
  80331f:	00 00 00 
  803322:	ff d0                	callq  *%rax
}
  803324:	c9                   	leaveq 
  803325:	c3                   	retq   

0000000000803326 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803326:	55                   	push   %rbp
  803327:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80332a:	be 00 00 00 00       	mov    $0x0,%esi
  80332f:	bf 08 00 00 00       	mov    $0x8,%edi
  803334:	48 b8 80 2e 80 00 00 	movabs $0x802e80,%rax
  80333b:	00 00 00 
  80333e:	ff d0                	callq  *%rax
}
  803340:	5d                   	pop    %rbp
  803341:	c3                   	retq   

0000000000803342 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803342:	55                   	push   %rbp
  803343:	48 89 e5             	mov    %rsp,%rbp
  803346:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80334d:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803354:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80335b:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803362:	be 00 00 00 00       	mov    $0x0,%esi
  803367:	48 89 c7             	mov    %rax,%rdi
  80336a:	48 b8 07 2f 80 00 00 	movabs $0x802f07,%rax
  803371:	00 00 00 
  803374:	ff d0                	callq  *%rax
  803376:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803379:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80337d:	79 28                	jns    8033a7 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80337f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803382:	89 c6                	mov    %eax,%esi
  803384:	48 bf fa 4f 80 00 00 	movabs $0x804ffa,%rdi
  80338b:	00 00 00 
  80338e:	b8 00 00 00 00       	mov    $0x0,%eax
  803393:	48 ba 7a 04 80 00 00 	movabs $0x80047a,%rdx
  80339a:	00 00 00 
  80339d:	ff d2                	callq  *%rdx
		return fd_src;
  80339f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033a2:	e9 74 01 00 00       	jmpq   80351b <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8033a7:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8033ae:	be 01 01 00 00       	mov    $0x101,%esi
  8033b3:	48 89 c7             	mov    %rax,%rdi
  8033b6:	48 b8 07 2f 80 00 00 	movabs $0x802f07,%rax
  8033bd:	00 00 00 
  8033c0:	ff d0                	callq  *%rax
  8033c2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8033c5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8033c9:	79 39                	jns    803404 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8033cb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033ce:	89 c6                	mov    %eax,%esi
  8033d0:	48 bf 10 50 80 00 00 	movabs $0x805010,%rdi
  8033d7:	00 00 00 
  8033da:	b8 00 00 00 00       	mov    $0x0,%eax
  8033df:	48 ba 7a 04 80 00 00 	movabs $0x80047a,%rdx
  8033e6:	00 00 00 
  8033e9:	ff d2                	callq  *%rdx
		close(fd_src);
  8033eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ee:	89 c7                	mov    %eax,%edi
  8033f0:	48 b8 0f 28 80 00 00 	movabs $0x80280f,%rax
  8033f7:	00 00 00 
  8033fa:	ff d0                	callq  *%rax
		return fd_dest;
  8033fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033ff:	e9 17 01 00 00       	jmpq   80351b <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803404:	eb 74                	jmp    80347a <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803406:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803409:	48 63 d0             	movslq %eax,%rdx
  80340c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803413:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803416:	48 89 ce             	mov    %rcx,%rsi
  803419:	89 c7                	mov    %eax,%edi
  80341b:	48 b8 7b 2b 80 00 00 	movabs $0x802b7b,%rax
  803422:	00 00 00 
  803425:	ff d0                	callq  *%rax
  803427:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80342a:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80342e:	79 4a                	jns    80347a <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803430:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803433:	89 c6                	mov    %eax,%esi
  803435:	48 bf 2a 50 80 00 00 	movabs $0x80502a,%rdi
  80343c:	00 00 00 
  80343f:	b8 00 00 00 00       	mov    $0x0,%eax
  803444:	48 ba 7a 04 80 00 00 	movabs $0x80047a,%rdx
  80344b:	00 00 00 
  80344e:	ff d2                	callq  *%rdx
			close(fd_src);
  803450:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803453:	89 c7                	mov    %eax,%edi
  803455:	48 b8 0f 28 80 00 00 	movabs $0x80280f,%rax
  80345c:	00 00 00 
  80345f:	ff d0                	callq  *%rax
			close(fd_dest);
  803461:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803464:	89 c7                	mov    %eax,%edi
  803466:	48 b8 0f 28 80 00 00 	movabs $0x80280f,%rax
  80346d:	00 00 00 
  803470:	ff d0                	callq  *%rax
			return write_size;
  803472:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803475:	e9 a1 00 00 00       	jmpq   80351b <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80347a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803481:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803484:	ba 00 02 00 00       	mov    $0x200,%edx
  803489:	48 89 ce             	mov    %rcx,%rsi
  80348c:	89 c7                	mov    %eax,%edi
  80348e:	48 b8 31 2a 80 00 00 	movabs $0x802a31,%rax
  803495:	00 00 00 
  803498:	ff d0                	callq  *%rax
  80349a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80349d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8034a1:	0f 8f 5f ff ff ff    	jg     803406 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8034a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8034ab:	79 47                	jns    8034f4 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8034ad:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034b0:	89 c6                	mov    %eax,%esi
  8034b2:	48 bf 3d 50 80 00 00 	movabs $0x80503d,%rdi
  8034b9:	00 00 00 
  8034bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c1:	48 ba 7a 04 80 00 00 	movabs $0x80047a,%rdx
  8034c8:	00 00 00 
  8034cb:	ff d2                	callq  *%rdx
		close(fd_src);
  8034cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034d0:	89 c7                	mov    %eax,%edi
  8034d2:	48 b8 0f 28 80 00 00 	movabs $0x80280f,%rax
  8034d9:	00 00 00 
  8034dc:	ff d0                	callq  *%rax
		close(fd_dest);
  8034de:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034e1:	89 c7                	mov    %eax,%edi
  8034e3:	48 b8 0f 28 80 00 00 	movabs $0x80280f,%rax
  8034ea:	00 00 00 
  8034ed:	ff d0                	callq  *%rax
		return read_size;
  8034ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034f2:	eb 27                	jmp    80351b <copy+0x1d9>
	}
	close(fd_src);
  8034f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f7:	89 c7                	mov    %eax,%edi
  8034f9:	48 b8 0f 28 80 00 00 	movabs $0x80280f,%rax
  803500:	00 00 00 
  803503:	ff d0                	callq  *%rax
	close(fd_dest);
  803505:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803508:	89 c7                	mov    %eax,%edi
  80350a:	48 b8 0f 28 80 00 00 	movabs $0x80280f,%rax
  803511:	00 00 00 
  803514:	ff d0                	callq  *%rax
	return 0;
  803516:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80351b:	c9                   	leaveq 
  80351c:	c3                   	retq   

000000000080351d <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80351d:	55                   	push   %rbp
  80351e:	48 89 e5             	mov    %rsp,%rbp
  803521:	48 83 ec 20          	sub    $0x20,%rsp
  803525:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803528:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80352c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80352f:	48 89 d6             	mov    %rdx,%rsi
  803532:	89 c7                	mov    %eax,%edi
  803534:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  80353b:	00 00 00 
  80353e:	ff d0                	callq  *%rax
  803540:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803543:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803547:	79 05                	jns    80354e <fd2sockid+0x31>
		return r;
  803549:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80354c:	eb 24                	jmp    803572 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80354e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803552:	8b 10                	mov    (%rax),%edx
  803554:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  80355b:	00 00 00 
  80355e:	8b 00                	mov    (%rax),%eax
  803560:	39 c2                	cmp    %eax,%edx
  803562:	74 07                	je     80356b <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803564:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803569:	eb 07                	jmp    803572 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80356b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80356f:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803572:	c9                   	leaveq 
  803573:	c3                   	retq   

0000000000803574 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803574:	55                   	push   %rbp
  803575:	48 89 e5             	mov    %rsp,%rbp
  803578:	48 83 ec 20          	sub    $0x20,%rsp
  80357c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80357f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803583:	48 89 c7             	mov    %rax,%rdi
  803586:	48 b8 67 25 80 00 00 	movabs $0x802567,%rax
  80358d:	00 00 00 
  803590:	ff d0                	callq  *%rax
  803592:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803595:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803599:	78 26                	js     8035c1 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80359b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80359f:	ba 07 04 00 00       	mov    $0x407,%edx
  8035a4:	48 89 c6             	mov    %rax,%rsi
  8035a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8035ac:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  8035b3:	00 00 00 
  8035b6:	ff d0                	callq  *%rax
  8035b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035bf:	79 16                	jns    8035d7 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8035c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035c4:	89 c7                	mov    %eax,%edi
  8035c6:	48 b8 81 3a 80 00 00 	movabs $0x803a81,%rax
  8035cd:	00 00 00 
  8035d0:	ff d0                	callq  *%rax
		return r;
  8035d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d5:	eb 3a                	jmp    803611 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8035d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035db:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8035e2:	00 00 00 
  8035e5:	8b 12                	mov    (%rdx),%edx
  8035e7:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8035e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ed:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8035f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035f8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8035fb:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8035fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803602:	48 89 c7             	mov    %rax,%rdi
  803605:	48 b8 19 25 80 00 00 	movabs $0x802519,%rax
  80360c:	00 00 00 
  80360f:	ff d0                	callq  *%rax
}
  803611:	c9                   	leaveq 
  803612:	c3                   	retq   

0000000000803613 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803613:	55                   	push   %rbp
  803614:	48 89 e5             	mov    %rsp,%rbp
  803617:	48 83 ec 30          	sub    $0x30,%rsp
  80361b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80361e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803622:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803626:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803629:	89 c7                	mov    %eax,%edi
  80362b:	48 b8 1d 35 80 00 00 	movabs $0x80351d,%rax
  803632:	00 00 00 
  803635:	ff d0                	callq  *%rax
  803637:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80363a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80363e:	79 05                	jns    803645 <accept+0x32>
		return r;
  803640:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803643:	eb 3b                	jmp    803680 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803645:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803649:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80364d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803650:	48 89 ce             	mov    %rcx,%rsi
  803653:	89 c7                	mov    %eax,%edi
  803655:	48 b8 5e 39 80 00 00 	movabs $0x80395e,%rax
  80365c:	00 00 00 
  80365f:	ff d0                	callq  *%rax
  803661:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803664:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803668:	79 05                	jns    80366f <accept+0x5c>
		return r;
  80366a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80366d:	eb 11                	jmp    803680 <accept+0x6d>
	return alloc_sockfd(r);
  80366f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803672:	89 c7                	mov    %eax,%edi
  803674:	48 b8 74 35 80 00 00 	movabs $0x803574,%rax
  80367b:	00 00 00 
  80367e:	ff d0                	callq  *%rax
}
  803680:	c9                   	leaveq 
  803681:	c3                   	retq   

0000000000803682 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803682:	55                   	push   %rbp
  803683:	48 89 e5             	mov    %rsp,%rbp
  803686:	48 83 ec 20          	sub    $0x20,%rsp
  80368a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80368d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803691:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803694:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803697:	89 c7                	mov    %eax,%edi
  803699:	48 b8 1d 35 80 00 00 	movabs $0x80351d,%rax
  8036a0:	00 00 00 
  8036a3:	ff d0                	callq  *%rax
  8036a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ac:	79 05                	jns    8036b3 <bind+0x31>
		return r;
  8036ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b1:	eb 1b                	jmp    8036ce <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8036b3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036b6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8036ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036bd:	48 89 ce             	mov    %rcx,%rsi
  8036c0:	89 c7                	mov    %eax,%edi
  8036c2:	48 b8 dd 39 80 00 00 	movabs $0x8039dd,%rax
  8036c9:	00 00 00 
  8036cc:	ff d0                	callq  *%rax
}
  8036ce:	c9                   	leaveq 
  8036cf:	c3                   	retq   

00000000008036d0 <shutdown>:

int
shutdown(int s, int how)
{
  8036d0:	55                   	push   %rbp
  8036d1:	48 89 e5             	mov    %rsp,%rbp
  8036d4:	48 83 ec 20          	sub    $0x20,%rsp
  8036d8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036db:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036de:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036e1:	89 c7                	mov    %eax,%edi
  8036e3:	48 b8 1d 35 80 00 00 	movabs $0x80351d,%rax
  8036ea:	00 00 00 
  8036ed:	ff d0                	callq  *%rax
  8036ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036f6:	79 05                	jns    8036fd <shutdown+0x2d>
		return r;
  8036f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036fb:	eb 16                	jmp    803713 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8036fd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803700:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803703:	89 d6                	mov    %edx,%esi
  803705:	89 c7                	mov    %eax,%edi
  803707:	48 b8 41 3a 80 00 00 	movabs $0x803a41,%rax
  80370e:	00 00 00 
  803711:	ff d0                	callq  *%rax
}
  803713:	c9                   	leaveq 
  803714:	c3                   	retq   

0000000000803715 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803715:	55                   	push   %rbp
  803716:	48 89 e5             	mov    %rsp,%rbp
  803719:	48 83 ec 10          	sub    $0x10,%rsp
  80371d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803721:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803725:	48 89 c7             	mov    %rax,%rdi
  803728:	48 b8 f9 47 80 00 00 	movabs $0x8047f9,%rax
  80372f:	00 00 00 
  803732:	ff d0                	callq  *%rax
  803734:	83 f8 01             	cmp    $0x1,%eax
  803737:	75 17                	jne    803750 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803739:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80373d:	8b 40 0c             	mov    0xc(%rax),%eax
  803740:	89 c7                	mov    %eax,%edi
  803742:	48 b8 81 3a 80 00 00 	movabs $0x803a81,%rax
  803749:	00 00 00 
  80374c:	ff d0                	callq  *%rax
  80374e:	eb 05                	jmp    803755 <devsock_close+0x40>
	else
		return 0;
  803750:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803755:	c9                   	leaveq 
  803756:	c3                   	retq   

0000000000803757 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803757:	55                   	push   %rbp
  803758:	48 89 e5             	mov    %rsp,%rbp
  80375b:	48 83 ec 20          	sub    $0x20,%rsp
  80375f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803762:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803766:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803769:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80376c:	89 c7                	mov    %eax,%edi
  80376e:	48 b8 1d 35 80 00 00 	movabs $0x80351d,%rax
  803775:	00 00 00 
  803778:	ff d0                	callq  *%rax
  80377a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80377d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803781:	79 05                	jns    803788 <connect+0x31>
		return r;
  803783:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803786:	eb 1b                	jmp    8037a3 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803788:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80378b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80378f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803792:	48 89 ce             	mov    %rcx,%rsi
  803795:	89 c7                	mov    %eax,%edi
  803797:	48 b8 ae 3a 80 00 00 	movabs $0x803aae,%rax
  80379e:	00 00 00 
  8037a1:	ff d0                	callq  *%rax
}
  8037a3:	c9                   	leaveq 
  8037a4:	c3                   	retq   

00000000008037a5 <listen>:

int
listen(int s, int backlog)
{
  8037a5:	55                   	push   %rbp
  8037a6:	48 89 e5             	mov    %rsp,%rbp
  8037a9:	48 83 ec 20          	sub    $0x20,%rsp
  8037ad:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037b0:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037b6:	89 c7                	mov    %eax,%edi
  8037b8:	48 b8 1d 35 80 00 00 	movabs $0x80351d,%rax
  8037bf:	00 00 00 
  8037c2:	ff d0                	callq  *%rax
  8037c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037cb:	79 05                	jns    8037d2 <listen+0x2d>
		return r;
  8037cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037d0:	eb 16                	jmp    8037e8 <listen+0x43>
	return nsipc_listen(r, backlog);
  8037d2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037d8:	89 d6                	mov    %edx,%esi
  8037da:	89 c7                	mov    %eax,%edi
  8037dc:	48 b8 12 3b 80 00 00 	movabs $0x803b12,%rax
  8037e3:	00 00 00 
  8037e6:	ff d0                	callq  *%rax
}
  8037e8:	c9                   	leaveq 
  8037e9:	c3                   	retq   

00000000008037ea <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8037ea:	55                   	push   %rbp
  8037eb:	48 89 e5             	mov    %rsp,%rbp
  8037ee:	48 83 ec 20          	sub    $0x20,%rsp
  8037f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037fa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8037fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803802:	89 c2                	mov    %eax,%edx
  803804:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803808:	8b 40 0c             	mov    0xc(%rax),%eax
  80380b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80380f:	b9 00 00 00 00       	mov    $0x0,%ecx
  803814:	89 c7                	mov    %eax,%edi
  803816:	48 b8 52 3b 80 00 00 	movabs $0x803b52,%rax
  80381d:	00 00 00 
  803820:	ff d0                	callq  *%rax
}
  803822:	c9                   	leaveq 
  803823:	c3                   	retq   

0000000000803824 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803824:	55                   	push   %rbp
  803825:	48 89 e5             	mov    %rsp,%rbp
  803828:	48 83 ec 20          	sub    $0x20,%rsp
  80382c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803830:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803834:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803838:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80383c:	89 c2                	mov    %eax,%edx
  80383e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803842:	8b 40 0c             	mov    0xc(%rax),%eax
  803845:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803849:	b9 00 00 00 00       	mov    $0x0,%ecx
  80384e:	89 c7                	mov    %eax,%edi
  803850:	48 b8 1e 3c 80 00 00 	movabs $0x803c1e,%rax
  803857:	00 00 00 
  80385a:	ff d0                	callq  *%rax
}
  80385c:	c9                   	leaveq 
  80385d:	c3                   	retq   

000000000080385e <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80385e:	55                   	push   %rbp
  80385f:	48 89 e5             	mov    %rsp,%rbp
  803862:	48 83 ec 10          	sub    $0x10,%rsp
  803866:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80386a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80386e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803872:	48 be 58 50 80 00 00 	movabs $0x805058,%rsi
  803879:	00 00 00 
  80387c:	48 89 c7             	mov    %rax,%rdi
  80387f:	48 b8 2f 10 80 00 00 	movabs $0x80102f,%rax
  803886:	00 00 00 
  803889:	ff d0                	callq  *%rax
	return 0;
  80388b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803890:	c9                   	leaveq 
  803891:	c3                   	retq   

0000000000803892 <socket>:

int
socket(int domain, int type, int protocol)
{
  803892:	55                   	push   %rbp
  803893:	48 89 e5             	mov    %rsp,%rbp
  803896:	48 83 ec 20          	sub    $0x20,%rsp
  80389a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80389d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8038a0:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8038a3:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8038a6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8038a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038ac:	89 ce                	mov    %ecx,%esi
  8038ae:	89 c7                	mov    %eax,%edi
  8038b0:	48 b8 d6 3c 80 00 00 	movabs $0x803cd6,%rax
  8038b7:	00 00 00 
  8038ba:	ff d0                	callq  *%rax
  8038bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038c3:	79 05                	jns    8038ca <socket+0x38>
		return r;
  8038c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c8:	eb 11                	jmp    8038db <socket+0x49>
	return alloc_sockfd(r);
  8038ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038cd:	89 c7                	mov    %eax,%edi
  8038cf:	48 b8 74 35 80 00 00 	movabs $0x803574,%rax
  8038d6:	00 00 00 
  8038d9:	ff d0                	callq  *%rax
}
  8038db:	c9                   	leaveq 
  8038dc:	c3                   	retq   

00000000008038dd <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8038dd:	55                   	push   %rbp
  8038de:	48 89 e5             	mov    %rsp,%rbp
  8038e1:	48 83 ec 10          	sub    $0x10,%rsp
  8038e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8038e8:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8038ef:	00 00 00 
  8038f2:	8b 00                	mov    (%rax),%eax
  8038f4:	85 c0                	test   %eax,%eax
  8038f6:	75 1d                	jne    803915 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8038f8:	bf 02 00 00 00       	mov    $0x2,%edi
  8038fd:	48 b8 97 24 80 00 00 	movabs $0x802497,%rax
  803904:	00 00 00 
  803907:	ff d0                	callq  *%rax
  803909:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  803910:	00 00 00 
  803913:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803915:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80391c:	00 00 00 
  80391f:	8b 00                	mov    (%rax),%eax
  803921:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803924:	b9 07 00 00 00       	mov    $0x7,%ecx
  803929:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803930:	00 00 00 
  803933:	89 c7                	mov    %eax,%edi
  803935:	48 b8 35 24 80 00 00 	movabs $0x802435,%rax
  80393c:	00 00 00 
  80393f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803941:	ba 00 00 00 00       	mov    $0x0,%edx
  803946:	be 00 00 00 00       	mov    $0x0,%esi
  80394b:	bf 00 00 00 00       	mov    $0x0,%edi
  803950:	48 b8 2f 23 80 00 00 	movabs $0x80232f,%rax
  803957:	00 00 00 
  80395a:	ff d0                	callq  *%rax
}
  80395c:	c9                   	leaveq 
  80395d:	c3                   	retq   

000000000080395e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80395e:	55                   	push   %rbp
  80395f:	48 89 e5             	mov    %rsp,%rbp
  803962:	48 83 ec 30          	sub    $0x30,%rsp
  803966:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803969:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80396d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803971:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803978:	00 00 00 
  80397b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80397e:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803980:	bf 01 00 00 00       	mov    $0x1,%edi
  803985:	48 b8 dd 38 80 00 00 	movabs $0x8038dd,%rax
  80398c:	00 00 00 
  80398f:	ff d0                	callq  *%rax
  803991:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803994:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803998:	78 3e                	js     8039d8 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80399a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039a1:	00 00 00 
  8039a4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8039a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ac:	8b 40 10             	mov    0x10(%rax),%eax
  8039af:	89 c2                	mov    %eax,%edx
  8039b1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8039b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039b9:	48 89 ce             	mov    %rcx,%rsi
  8039bc:	48 89 c7             	mov    %rax,%rdi
  8039bf:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  8039c6:	00 00 00 
  8039c9:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8039cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039cf:	8b 50 10             	mov    0x10(%rax),%edx
  8039d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039d6:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8039d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8039db:	c9                   	leaveq 
  8039dc:	c3                   	retq   

00000000008039dd <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8039dd:	55                   	push   %rbp
  8039de:	48 89 e5             	mov    %rsp,%rbp
  8039e1:	48 83 ec 10          	sub    $0x10,%rsp
  8039e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039ec:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8039ef:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039f6:	00 00 00 
  8039f9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039fc:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8039fe:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a05:	48 89 c6             	mov    %rax,%rsi
  803a08:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803a0f:	00 00 00 
  803a12:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  803a19:	00 00 00 
  803a1c:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803a1e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a25:	00 00 00 
  803a28:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a2b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803a2e:	bf 02 00 00 00       	mov    $0x2,%edi
  803a33:	48 b8 dd 38 80 00 00 	movabs $0x8038dd,%rax
  803a3a:	00 00 00 
  803a3d:	ff d0                	callq  *%rax
}
  803a3f:	c9                   	leaveq 
  803a40:	c3                   	retq   

0000000000803a41 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803a41:	55                   	push   %rbp
  803a42:	48 89 e5             	mov    %rsp,%rbp
  803a45:	48 83 ec 10          	sub    $0x10,%rsp
  803a49:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a4c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803a4f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a56:	00 00 00 
  803a59:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a5c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803a5e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a65:	00 00 00 
  803a68:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a6b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803a6e:	bf 03 00 00 00       	mov    $0x3,%edi
  803a73:	48 b8 dd 38 80 00 00 	movabs $0x8038dd,%rax
  803a7a:	00 00 00 
  803a7d:	ff d0                	callq  *%rax
}
  803a7f:	c9                   	leaveq 
  803a80:	c3                   	retq   

0000000000803a81 <nsipc_close>:

int
nsipc_close(int s)
{
  803a81:	55                   	push   %rbp
  803a82:	48 89 e5             	mov    %rsp,%rbp
  803a85:	48 83 ec 10          	sub    $0x10,%rsp
  803a89:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803a8c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a93:	00 00 00 
  803a96:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a99:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803a9b:	bf 04 00 00 00       	mov    $0x4,%edi
  803aa0:	48 b8 dd 38 80 00 00 	movabs $0x8038dd,%rax
  803aa7:	00 00 00 
  803aaa:	ff d0                	callq  *%rax
}
  803aac:	c9                   	leaveq 
  803aad:	c3                   	retq   

0000000000803aae <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803aae:	55                   	push   %rbp
  803aaf:	48 89 e5             	mov    %rsp,%rbp
  803ab2:	48 83 ec 10          	sub    $0x10,%rsp
  803ab6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ab9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803abd:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803ac0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ac7:	00 00 00 
  803aca:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803acd:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803acf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ad2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ad6:	48 89 c6             	mov    %rax,%rsi
  803ad9:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803ae0:	00 00 00 
  803ae3:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  803aea:	00 00 00 
  803aed:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803aef:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803af6:	00 00 00 
  803af9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803afc:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803aff:	bf 05 00 00 00       	mov    $0x5,%edi
  803b04:	48 b8 dd 38 80 00 00 	movabs $0x8038dd,%rax
  803b0b:	00 00 00 
  803b0e:	ff d0                	callq  *%rax
}
  803b10:	c9                   	leaveq 
  803b11:	c3                   	retq   

0000000000803b12 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803b12:	55                   	push   %rbp
  803b13:	48 89 e5             	mov    %rsp,%rbp
  803b16:	48 83 ec 10          	sub    $0x10,%rsp
  803b1a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b1d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803b20:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b27:	00 00 00 
  803b2a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b2d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803b2f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b36:	00 00 00 
  803b39:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b3c:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803b3f:	bf 06 00 00 00       	mov    $0x6,%edi
  803b44:	48 b8 dd 38 80 00 00 	movabs $0x8038dd,%rax
  803b4b:	00 00 00 
  803b4e:	ff d0                	callq  *%rax
}
  803b50:	c9                   	leaveq 
  803b51:	c3                   	retq   

0000000000803b52 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803b52:	55                   	push   %rbp
  803b53:	48 89 e5             	mov    %rsp,%rbp
  803b56:	48 83 ec 30          	sub    $0x30,%rsp
  803b5a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b5d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b61:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803b64:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803b67:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b6e:	00 00 00 
  803b71:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b74:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803b76:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b7d:	00 00 00 
  803b80:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b83:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803b86:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b8d:	00 00 00 
  803b90:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803b93:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803b96:	bf 07 00 00 00       	mov    $0x7,%edi
  803b9b:	48 b8 dd 38 80 00 00 	movabs $0x8038dd,%rax
  803ba2:	00 00 00 
  803ba5:	ff d0                	callq  *%rax
  803ba7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803baa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bae:	78 69                	js     803c19 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803bb0:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803bb7:	7f 08                	jg     803bc1 <nsipc_recv+0x6f>
  803bb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bbc:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803bbf:	7e 35                	jle    803bf6 <nsipc_recv+0xa4>
  803bc1:	48 b9 5f 50 80 00 00 	movabs $0x80505f,%rcx
  803bc8:	00 00 00 
  803bcb:	48 ba 74 50 80 00 00 	movabs $0x805074,%rdx
  803bd2:	00 00 00 
  803bd5:	be 61 00 00 00       	mov    $0x61,%esi
  803bda:	48 bf 89 50 80 00 00 	movabs $0x805089,%rdi
  803be1:	00 00 00 
  803be4:	b8 00 00 00 00       	mov    $0x0,%eax
  803be9:	49 b8 a5 45 80 00 00 	movabs $0x8045a5,%r8
  803bf0:	00 00 00 
  803bf3:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803bf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf9:	48 63 d0             	movslq %eax,%rdx
  803bfc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c00:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803c07:	00 00 00 
  803c0a:	48 89 c7             	mov    %rax,%rdi
  803c0d:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  803c14:	00 00 00 
  803c17:	ff d0                	callq  *%rax
	}

	return r;
  803c19:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c1c:	c9                   	leaveq 
  803c1d:	c3                   	retq   

0000000000803c1e <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803c1e:	55                   	push   %rbp
  803c1f:	48 89 e5             	mov    %rsp,%rbp
  803c22:	48 83 ec 20          	sub    $0x20,%rsp
  803c26:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c29:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c2d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803c30:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803c33:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c3a:	00 00 00 
  803c3d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c40:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803c42:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803c49:	7e 35                	jle    803c80 <nsipc_send+0x62>
  803c4b:	48 b9 95 50 80 00 00 	movabs $0x805095,%rcx
  803c52:	00 00 00 
  803c55:	48 ba 74 50 80 00 00 	movabs $0x805074,%rdx
  803c5c:	00 00 00 
  803c5f:	be 6c 00 00 00       	mov    $0x6c,%esi
  803c64:	48 bf 89 50 80 00 00 	movabs $0x805089,%rdi
  803c6b:	00 00 00 
  803c6e:	b8 00 00 00 00       	mov    $0x0,%eax
  803c73:	49 b8 a5 45 80 00 00 	movabs $0x8045a5,%r8
  803c7a:	00 00 00 
  803c7d:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803c80:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c83:	48 63 d0             	movslq %eax,%rdx
  803c86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c8a:	48 89 c6             	mov    %rax,%rsi
  803c8d:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803c94:	00 00 00 
  803c97:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  803c9e:	00 00 00 
  803ca1:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803ca3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803caa:	00 00 00 
  803cad:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cb0:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803cb3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cba:	00 00 00 
  803cbd:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803cc0:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803cc3:	bf 08 00 00 00       	mov    $0x8,%edi
  803cc8:	48 b8 dd 38 80 00 00 	movabs $0x8038dd,%rax
  803ccf:	00 00 00 
  803cd2:	ff d0                	callq  *%rax
}
  803cd4:	c9                   	leaveq 
  803cd5:	c3                   	retq   

0000000000803cd6 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803cd6:	55                   	push   %rbp
  803cd7:	48 89 e5             	mov    %rsp,%rbp
  803cda:	48 83 ec 10          	sub    $0x10,%rsp
  803cde:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ce1:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803ce4:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803ce7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cee:	00 00 00 
  803cf1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803cf4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803cf6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cfd:	00 00 00 
  803d00:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d03:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803d06:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d0d:	00 00 00 
  803d10:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803d13:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803d16:	bf 09 00 00 00       	mov    $0x9,%edi
  803d1b:	48 b8 dd 38 80 00 00 	movabs $0x8038dd,%rax
  803d22:	00 00 00 
  803d25:	ff d0                	callq  *%rax
}
  803d27:	c9                   	leaveq 
  803d28:	c3                   	retq   

0000000000803d29 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803d29:	55                   	push   %rbp
  803d2a:	48 89 e5             	mov    %rsp,%rbp
  803d2d:	53                   	push   %rbx
  803d2e:	48 83 ec 38          	sub    $0x38,%rsp
  803d32:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803d36:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803d3a:	48 89 c7             	mov    %rax,%rdi
  803d3d:	48 b8 67 25 80 00 00 	movabs $0x802567,%rax
  803d44:	00 00 00 
  803d47:	ff d0                	callq  *%rax
  803d49:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d4c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d50:	0f 88 bf 01 00 00    	js     803f15 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d56:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d5a:	ba 07 04 00 00       	mov    $0x407,%edx
  803d5f:	48 89 c6             	mov    %rax,%rsi
  803d62:	bf 00 00 00 00       	mov    $0x0,%edi
  803d67:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  803d6e:	00 00 00 
  803d71:	ff d0                	callq  *%rax
  803d73:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d76:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d7a:	0f 88 95 01 00 00    	js     803f15 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803d80:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803d84:	48 89 c7             	mov    %rax,%rdi
  803d87:	48 b8 67 25 80 00 00 	movabs $0x802567,%rax
  803d8e:	00 00 00 
  803d91:	ff d0                	callq  *%rax
  803d93:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d96:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d9a:	0f 88 5d 01 00 00    	js     803efd <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803da0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803da4:	ba 07 04 00 00       	mov    $0x407,%edx
  803da9:	48 89 c6             	mov    %rax,%rsi
  803dac:	bf 00 00 00 00       	mov    $0x0,%edi
  803db1:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  803db8:	00 00 00 
  803dbb:	ff d0                	callq  *%rax
  803dbd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dc0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dc4:	0f 88 33 01 00 00    	js     803efd <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803dca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dce:	48 89 c7             	mov    %rax,%rdi
  803dd1:	48 b8 3c 25 80 00 00 	movabs $0x80253c,%rax
  803dd8:	00 00 00 
  803ddb:	ff d0                	callq  *%rax
  803ddd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803de1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803de5:	ba 07 04 00 00       	mov    $0x407,%edx
  803dea:	48 89 c6             	mov    %rax,%rsi
  803ded:	bf 00 00 00 00       	mov    $0x0,%edi
  803df2:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  803df9:	00 00 00 
  803dfc:	ff d0                	callq  *%rax
  803dfe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e01:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e05:	79 05                	jns    803e0c <pipe+0xe3>
		goto err2;
  803e07:	e9 d9 00 00 00       	jmpq   803ee5 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e0c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e10:	48 89 c7             	mov    %rax,%rdi
  803e13:	48 b8 3c 25 80 00 00 	movabs $0x80253c,%rax
  803e1a:	00 00 00 
  803e1d:	ff d0                	callq  *%rax
  803e1f:	48 89 c2             	mov    %rax,%rdx
  803e22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e26:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803e2c:	48 89 d1             	mov    %rdx,%rcx
  803e2f:	ba 00 00 00 00       	mov    $0x0,%edx
  803e34:	48 89 c6             	mov    %rax,%rsi
  803e37:	bf 00 00 00 00       	mov    $0x0,%edi
  803e3c:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  803e43:	00 00 00 
  803e46:	ff d0                	callq  *%rax
  803e48:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e4b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e4f:	79 1b                	jns    803e6c <pipe+0x143>
		goto err3;
  803e51:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803e52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e56:	48 89 c6             	mov    %rax,%rsi
  803e59:	bf 00 00 00 00       	mov    $0x0,%edi
  803e5e:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  803e65:	00 00 00 
  803e68:	ff d0                	callq  *%rax
  803e6a:	eb 79                	jmp    803ee5 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803e6c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e70:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803e77:	00 00 00 
  803e7a:	8b 12                	mov    (%rdx),%edx
  803e7c:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803e7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e82:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803e89:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e8d:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803e94:	00 00 00 
  803e97:	8b 12                	mov    (%rdx),%edx
  803e99:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803e9b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e9f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803ea6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803eaa:	48 89 c7             	mov    %rax,%rdi
  803ead:	48 b8 19 25 80 00 00 	movabs $0x802519,%rax
  803eb4:	00 00 00 
  803eb7:	ff d0                	callq  *%rax
  803eb9:	89 c2                	mov    %eax,%edx
  803ebb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803ebf:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803ec1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803ec5:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803ec9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ecd:	48 89 c7             	mov    %rax,%rdi
  803ed0:	48 b8 19 25 80 00 00 	movabs $0x802519,%rax
  803ed7:	00 00 00 
  803eda:	ff d0                	callq  *%rax
  803edc:	89 03                	mov    %eax,(%rbx)
	return 0;
  803ede:	b8 00 00 00 00       	mov    $0x0,%eax
  803ee3:	eb 33                	jmp    803f18 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803ee5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ee9:	48 89 c6             	mov    %rax,%rsi
  803eec:	bf 00 00 00 00       	mov    $0x0,%edi
  803ef1:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  803ef8:	00 00 00 
  803efb:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803efd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f01:	48 89 c6             	mov    %rax,%rsi
  803f04:	bf 00 00 00 00       	mov    $0x0,%edi
  803f09:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  803f10:	00 00 00 
  803f13:	ff d0                	callq  *%rax
err:
	return r;
  803f15:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803f18:	48 83 c4 38          	add    $0x38,%rsp
  803f1c:	5b                   	pop    %rbx
  803f1d:	5d                   	pop    %rbp
  803f1e:	c3                   	retq   

0000000000803f1f <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803f1f:	55                   	push   %rbp
  803f20:	48 89 e5             	mov    %rsp,%rbp
  803f23:	53                   	push   %rbx
  803f24:	48 83 ec 28          	sub    $0x28,%rsp
  803f28:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f2c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803f30:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803f37:	00 00 00 
  803f3a:	48 8b 00             	mov    (%rax),%rax
  803f3d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f43:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803f46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f4a:	48 89 c7             	mov    %rax,%rdi
  803f4d:	48 b8 f9 47 80 00 00 	movabs $0x8047f9,%rax
  803f54:	00 00 00 
  803f57:	ff d0                	callq  *%rax
  803f59:	89 c3                	mov    %eax,%ebx
  803f5b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f5f:	48 89 c7             	mov    %rax,%rdi
  803f62:	48 b8 f9 47 80 00 00 	movabs $0x8047f9,%rax
  803f69:	00 00 00 
  803f6c:	ff d0                	callq  *%rax
  803f6e:	39 c3                	cmp    %eax,%ebx
  803f70:	0f 94 c0             	sete   %al
  803f73:	0f b6 c0             	movzbl %al,%eax
  803f76:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803f79:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803f80:	00 00 00 
  803f83:	48 8b 00             	mov    (%rax),%rax
  803f86:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f8c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803f8f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f92:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f95:	75 05                	jne    803f9c <_pipeisclosed+0x7d>
			return ret;
  803f97:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803f9a:	eb 4f                	jmp    803feb <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803f9c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f9f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803fa2:	74 42                	je     803fe6 <_pipeisclosed+0xc7>
  803fa4:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803fa8:	75 3c                	jne    803fe6 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803faa:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803fb1:	00 00 00 
  803fb4:	48 8b 00             	mov    (%rax),%rax
  803fb7:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803fbd:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803fc0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fc3:	89 c6                	mov    %eax,%esi
  803fc5:	48 bf a6 50 80 00 00 	movabs $0x8050a6,%rdi
  803fcc:	00 00 00 
  803fcf:	b8 00 00 00 00       	mov    $0x0,%eax
  803fd4:	49 b8 7a 04 80 00 00 	movabs $0x80047a,%r8
  803fdb:	00 00 00 
  803fde:	41 ff d0             	callq  *%r8
	}
  803fe1:	e9 4a ff ff ff       	jmpq   803f30 <_pipeisclosed+0x11>
  803fe6:	e9 45 ff ff ff       	jmpq   803f30 <_pipeisclosed+0x11>
}
  803feb:	48 83 c4 28          	add    $0x28,%rsp
  803fef:	5b                   	pop    %rbx
  803ff0:	5d                   	pop    %rbp
  803ff1:	c3                   	retq   

0000000000803ff2 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803ff2:	55                   	push   %rbp
  803ff3:	48 89 e5             	mov    %rsp,%rbp
  803ff6:	48 83 ec 30          	sub    $0x30,%rsp
  803ffa:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ffd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804001:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804004:	48 89 d6             	mov    %rdx,%rsi
  804007:	89 c7                	mov    %eax,%edi
  804009:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  804010:	00 00 00 
  804013:	ff d0                	callq  *%rax
  804015:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804018:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80401c:	79 05                	jns    804023 <pipeisclosed+0x31>
		return r;
  80401e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804021:	eb 31                	jmp    804054 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804023:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804027:	48 89 c7             	mov    %rax,%rdi
  80402a:	48 b8 3c 25 80 00 00 	movabs $0x80253c,%rax
  804031:	00 00 00 
  804034:	ff d0                	callq  *%rax
  804036:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80403a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80403e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804042:	48 89 d6             	mov    %rdx,%rsi
  804045:	48 89 c7             	mov    %rax,%rdi
  804048:	48 b8 1f 3f 80 00 00 	movabs $0x803f1f,%rax
  80404f:	00 00 00 
  804052:	ff d0                	callq  *%rax
}
  804054:	c9                   	leaveq 
  804055:	c3                   	retq   

0000000000804056 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804056:	55                   	push   %rbp
  804057:	48 89 e5             	mov    %rsp,%rbp
  80405a:	48 83 ec 40          	sub    $0x40,%rsp
  80405e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804062:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804066:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80406a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80406e:	48 89 c7             	mov    %rax,%rdi
  804071:	48 b8 3c 25 80 00 00 	movabs $0x80253c,%rax
  804078:	00 00 00 
  80407b:	ff d0                	callq  *%rax
  80407d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804081:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804085:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804089:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804090:	00 
  804091:	e9 92 00 00 00       	jmpq   804128 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804096:	eb 41                	jmp    8040d9 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804098:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80409d:	74 09                	je     8040a8 <devpipe_read+0x52>
				return i;
  80409f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040a3:	e9 92 00 00 00       	jmpq   80413a <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8040a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040b0:	48 89 d6             	mov    %rdx,%rsi
  8040b3:	48 89 c7             	mov    %rax,%rdi
  8040b6:	48 b8 1f 3f 80 00 00 	movabs $0x803f1f,%rax
  8040bd:	00 00 00 
  8040c0:	ff d0                	callq  *%rax
  8040c2:	85 c0                	test   %eax,%eax
  8040c4:	74 07                	je     8040cd <devpipe_read+0x77>
				return 0;
  8040c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8040cb:	eb 6d                	jmp    80413a <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8040cd:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  8040d4:	00 00 00 
  8040d7:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8040d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040dd:	8b 10                	mov    (%rax),%edx
  8040df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040e3:	8b 40 04             	mov    0x4(%rax),%eax
  8040e6:	39 c2                	cmp    %eax,%edx
  8040e8:	74 ae                	je     804098 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8040ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8040f2:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8040f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040fa:	8b 00                	mov    (%rax),%eax
  8040fc:	99                   	cltd   
  8040fd:	c1 ea 1b             	shr    $0x1b,%edx
  804100:	01 d0                	add    %edx,%eax
  804102:	83 e0 1f             	and    $0x1f,%eax
  804105:	29 d0                	sub    %edx,%eax
  804107:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80410b:	48 98                	cltq   
  80410d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804112:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804114:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804118:	8b 00                	mov    (%rax),%eax
  80411a:	8d 50 01             	lea    0x1(%rax),%edx
  80411d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804121:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804123:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804128:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80412c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804130:	0f 82 60 ff ff ff    	jb     804096 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804136:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80413a:	c9                   	leaveq 
  80413b:	c3                   	retq   

000000000080413c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80413c:	55                   	push   %rbp
  80413d:	48 89 e5             	mov    %rsp,%rbp
  804140:	48 83 ec 40          	sub    $0x40,%rsp
  804144:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804148:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80414c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804150:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804154:	48 89 c7             	mov    %rax,%rdi
  804157:	48 b8 3c 25 80 00 00 	movabs $0x80253c,%rax
  80415e:	00 00 00 
  804161:	ff d0                	callq  *%rax
  804163:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804167:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80416b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80416f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804176:	00 
  804177:	e9 8e 00 00 00       	jmpq   80420a <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80417c:	eb 31                	jmp    8041af <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80417e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804182:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804186:	48 89 d6             	mov    %rdx,%rsi
  804189:	48 89 c7             	mov    %rax,%rdi
  80418c:	48 b8 1f 3f 80 00 00 	movabs $0x803f1f,%rax
  804193:	00 00 00 
  804196:	ff d0                	callq  *%rax
  804198:	85 c0                	test   %eax,%eax
  80419a:	74 07                	je     8041a3 <devpipe_write+0x67>
				return 0;
  80419c:	b8 00 00 00 00       	mov    $0x0,%eax
  8041a1:	eb 79                	jmp    80421c <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8041a3:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  8041aa:	00 00 00 
  8041ad:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8041af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041b3:	8b 40 04             	mov    0x4(%rax),%eax
  8041b6:	48 63 d0             	movslq %eax,%rdx
  8041b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041bd:	8b 00                	mov    (%rax),%eax
  8041bf:	48 98                	cltq   
  8041c1:	48 83 c0 20          	add    $0x20,%rax
  8041c5:	48 39 c2             	cmp    %rax,%rdx
  8041c8:	73 b4                	jae    80417e <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8041ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041ce:	8b 40 04             	mov    0x4(%rax),%eax
  8041d1:	99                   	cltd   
  8041d2:	c1 ea 1b             	shr    $0x1b,%edx
  8041d5:	01 d0                	add    %edx,%eax
  8041d7:	83 e0 1f             	and    $0x1f,%eax
  8041da:	29 d0                	sub    %edx,%eax
  8041dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8041e0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8041e4:	48 01 ca             	add    %rcx,%rdx
  8041e7:	0f b6 0a             	movzbl (%rdx),%ecx
  8041ea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041ee:	48 98                	cltq   
  8041f0:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8041f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041f8:	8b 40 04             	mov    0x4(%rax),%eax
  8041fb:	8d 50 01             	lea    0x1(%rax),%edx
  8041fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804202:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804205:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80420a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80420e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804212:	0f 82 64 ff ff ff    	jb     80417c <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804218:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80421c:	c9                   	leaveq 
  80421d:	c3                   	retq   

000000000080421e <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80421e:	55                   	push   %rbp
  80421f:	48 89 e5             	mov    %rsp,%rbp
  804222:	48 83 ec 20          	sub    $0x20,%rsp
  804226:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80422a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80422e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804232:	48 89 c7             	mov    %rax,%rdi
  804235:	48 b8 3c 25 80 00 00 	movabs $0x80253c,%rax
  80423c:	00 00 00 
  80423f:	ff d0                	callq  *%rax
  804241:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804245:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804249:	48 be b9 50 80 00 00 	movabs $0x8050b9,%rsi
  804250:	00 00 00 
  804253:	48 89 c7             	mov    %rax,%rdi
  804256:	48 b8 2f 10 80 00 00 	movabs $0x80102f,%rax
  80425d:	00 00 00 
  804260:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804262:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804266:	8b 50 04             	mov    0x4(%rax),%edx
  804269:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80426d:	8b 00                	mov    (%rax),%eax
  80426f:	29 c2                	sub    %eax,%edx
  804271:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804275:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80427b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80427f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804286:	00 00 00 
	stat->st_dev = &devpipe;
  804289:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80428d:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804294:	00 00 00 
  804297:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80429e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042a3:	c9                   	leaveq 
  8042a4:	c3                   	retq   

00000000008042a5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8042a5:	55                   	push   %rbp
  8042a6:	48 89 e5             	mov    %rsp,%rbp
  8042a9:	48 83 ec 10          	sub    $0x10,%rsp
  8042ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8042b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042b5:	48 89 c6             	mov    %rax,%rsi
  8042b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8042bd:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  8042c4:	00 00 00 
  8042c7:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8042c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042cd:	48 89 c7             	mov    %rax,%rdi
  8042d0:	48 b8 3c 25 80 00 00 	movabs $0x80253c,%rax
  8042d7:	00 00 00 
  8042da:	ff d0                	callq  *%rax
  8042dc:	48 89 c6             	mov    %rax,%rsi
  8042df:	bf 00 00 00 00       	mov    $0x0,%edi
  8042e4:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  8042eb:	00 00 00 
  8042ee:	ff d0                	callq  *%rax
}
  8042f0:	c9                   	leaveq 
  8042f1:	c3                   	retq   

00000000008042f2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8042f2:	55                   	push   %rbp
  8042f3:	48 89 e5             	mov    %rsp,%rbp
  8042f6:	48 83 ec 20          	sub    $0x20,%rsp
  8042fa:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8042fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804300:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804303:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804307:	be 01 00 00 00       	mov    $0x1,%esi
  80430c:	48 89 c7             	mov    %rax,%rdi
  80430f:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  804316:	00 00 00 
  804319:	ff d0                	callq  *%rax
}
  80431b:	c9                   	leaveq 
  80431c:	c3                   	retq   

000000000080431d <getchar>:

int
getchar(void)
{
  80431d:	55                   	push   %rbp
  80431e:	48 89 e5             	mov    %rsp,%rbp
  804321:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804325:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804329:	ba 01 00 00 00       	mov    $0x1,%edx
  80432e:	48 89 c6             	mov    %rax,%rsi
  804331:	bf 00 00 00 00       	mov    $0x0,%edi
  804336:	48 b8 31 2a 80 00 00 	movabs $0x802a31,%rax
  80433d:	00 00 00 
  804340:	ff d0                	callq  *%rax
  804342:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804345:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804349:	79 05                	jns    804350 <getchar+0x33>
		return r;
  80434b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80434e:	eb 14                	jmp    804364 <getchar+0x47>
	if (r < 1)
  804350:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804354:	7f 07                	jg     80435d <getchar+0x40>
		return -E_EOF;
  804356:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80435b:	eb 07                	jmp    804364 <getchar+0x47>
	return c;
  80435d:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804361:	0f b6 c0             	movzbl %al,%eax
}
  804364:	c9                   	leaveq 
  804365:	c3                   	retq   

0000000000804366 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804366:	55                   	push   %rbp
  804367:	48 89 e5             	mov    %rsp,%rbp
  80436a:	48 83 ec 20          	sub    $0x20,%rsp
  80436e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804371:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804375:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804378:	48 89 d6             	mov    %rdx,%rsi
  80437b:	89 c7                	mov    %eax,%edi
  80437d:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  804384:	00 00 00 
  804387:	ff d0                	callq  *%rax
  804389:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80438c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804390:	79 05                	jns    804397 <iscons+0x31>
		return r;
  804392:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804395:	eb 1a                	jmp    8043b1 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804397:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80439b:	8b 10                	mov    (%rax),%edx
  80439d:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  8043a4:	00 00 00 
  8043a7:	8b 00                	mov    (%rax),%eax
  8043a9:	39 c2                	cmp    %eax,%edx
  8043ab:	0f 94 c0             	sete   %al
  8043ae:	0f b6 c0             	movzbl %al,%eax
}
  8043b1:	c9                   	leaveq 
  8043b2:	c3                   	retq   

00000000008043b3 <opencons>:

int
opencons(void)
{
  8043b3:	55                   	push   %rbp
  8043b4:	48 89 e5             	mov    %rsp,%rbp
  8043b7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8043bb:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8043bf:	48 89 c7             	mov    %rax,%rdi
  8043c2:	48 b8 67 25 80 00 00 	movabs $0x802567,%rax
  8043c9:	00 00 00 
  8043cc:	ff d0                	callq  *%rax
  8043ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043d5:	79 05                	jns    8043dc <opencons+0x29>
		return r;
  8043d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043da:	eb 5b                	jmp    804437 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8043dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043e0:	ba 07 04 00 00       	mov    $0x407,%edx
  8043e5:	48 89 c6             	mov    %rax,%rsi
  8043e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8043ed:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  8043f4:	00 00 00 
  8043f7:	ff d0                	callq  *%rax
  8043f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804400:	79 05                	jns    804407 <opencons+0x54>
		return r;
  804402:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804405:	eb 30                	jmp    804437 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804407:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80440b:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804412:	00 00 00 
  804415:	8b 12                	mov    (%rdx),%edx
  804417:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804419:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80441d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804424:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804428:	48 89 c7             	mov    %rax,%rdi
  80442b:	48 b8 19 25 80 00 00 	movabs $0x802519,%rax
  804432:	00 00 00 
  804435:	ff d0                	callq  *%rax
}
  804437:	c9                   	leaveq 
  804438:	c3                   	retq   

0000000000804439 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804439:	55                   	push   %rbp
  80443a:	48 89 e5             	mov    %rsp,%rbp
  80443d:	48 83 ec 30          	sub    $0x30,%rsp
  804441:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804445:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804449:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80444d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804452:	75 07                	jne    80445b <devcons_read+0x22>
		return 0;
  804454:	b8 00 00 00 00       	mov    $0x0,%eax
  804459:	eb 4b                	jmp    8044a6 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80445b:	eb 0c                	jmp    804469 <devcons_read+0x30>
		sys_yield();
  80445d:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  804464:	00 00 00 
  804467:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804469:	48 b8 60 18 80 00 00 	movabs $0x801860,%rax
  804470:	00 00 00 
  804473:	ff d0                	callq  *%rax
  804475:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804478:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80447c:	74 df                	je     80445d <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80447e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804482:	79 05                	jns    804489 <devcons_read+0x50>
		return c;
  804484:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804487:	eb 1d                	jmp    8044a6 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804489:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80448d:	75 07                	jne    804496 <devcons_read+0x5d>
		return 0;
  80448f:	b8 00 00 00 00       	mov    $0x0,%eax
  804494:	eb 10                	jmp    8044a6 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804496:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804499:	89 c2                	mov    %eax,%edx
  80449b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80449f:	88 10                	mov    %dl,(%rax)
	return 1;
  8044a1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8044a6:	c9                   	leaveq 
  8044a7:	c3                   	retq   

00000000008044a8 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8044a8:	55                   	push   %rbp
  8044a9:	48 89 e5             	mov    %rsp,%rbp
  8044ac:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8044b3:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8044ba:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8044c1:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8044c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8044cf:	eb 76                	jmp    804547 <devcons_write+0x9f>
		m = n - tot;
  8044d1:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8044d8:	89 c2                	mov    %eax,%edx
  8044da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044dd:	29 c2                	sub    %eax,%edx
  8044df:	89 d0                	mov    %edx,%eax
  8044e1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8044e4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044e7:	83 f8 7f             	cmp    $0x7f,%eax
  8044ea:	76 07                	jbe    8044f3 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8044ec:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8044f3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044f6:	48 63 d0             	movslq %eax,%rdx
  8044f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044fc:	48 63 c8             	movslq %eax,%rcx
  8044ff:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804506:	48 01 c1             	add    %rax,%rcx
  804509:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804510:	48 89 ce             	mov    %rcx,%rsi
  804513:	48 89 c7             	mov    %rax,%rdi
  804516:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  80451d:	00 00 00 
  804520:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804522:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804525:	48 63 d0             	movslq %eax,%rdx
  804528:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80452f:	48 89 d6             	mov    %rdx,%rsi
  804532:	48 89 c7             	mov    %rax,%rdi
  804535:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  80453c:	00 00 00 
  80453f:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804541:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804544:	01 45 fc             	add    %eax,-0x4(%rbp)
  804547:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80454a:	48 98                	cltq   
  80454c:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804553:	0f 82 78 ff ff ff    	jb     8044d1 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804559:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80455c:	c9                   	leaveq 
  80455d:	c3                   	retq   

000000000080455e <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80455e:	55                   	push   %rbp
  80455f:	48 89 e5             	mov    %rsp,%rbp
  804562:	48 83 ec 08          	sub    $0x8,%rsp
  804566:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80456a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80456f:	c9                   	leaveq 
  804570:	c3                   	retq   

0000000000804571 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804571:	55                   	push   %rbp
  804572:	48 89 e5             	mov    %rsp,%rbp
  804575:	48 83 ec 10          	sub    $0x10,%rsp
  804579:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80457d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804585:	48 be c5 50 80 00 00 	movabs $0x8050c5,%rsi
  80458c:	00 00 00 
  80458f:	48 89 c7             	mov    %rax,%rdi
  804592:	48 b8 2f 10 80 00 00 	movabs $0x80102f,%rax
  804599:	00 00 00 
  80459c:	ff d0                	callq  *%rax
	return 0;
  80459e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8045a3:	c9                   	leaveq 
  8045a4:	c3                   	retq   

00000000008045a5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8045a5:	55                   	push   %rbp
  8045a6:	48 89 e5             	mov    %rsp,%rbp
  8045a9:	53                   	push   %rbx
  8045aa:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8045b1:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8045b8:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8045be:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8045c5:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8045cc:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8045d3:	84 c0                	test   %al,%al
  8045d5:	74 23                	je     8045fa <_panic+0x55>
  8045d7:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8045de:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8045e2:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8045e6:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8045ea:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8045ee:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8045f2:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8045f6:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8045fa:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  804601:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  804608:	00 00 00 
  80460b:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  804612:	00 00 00 
  804615:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804619:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  804620:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  804627:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80462e:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804635:	00 00 00 
  804638:	48 8b 18             	mov    (%rax),%rbx
  80463b:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  804642:	00 00 00 
  804645:	ff d0                	callq  *%rax
  804647:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80464d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  804654:	41 89 c8             	mov    %ecx,%r8d
  804657:	48 89 d1             	mov    %rdx,%rcx
  80465a:	48 89 da             	mov    %rbx,%rdx
  80465d:	89 c6                	mov    %eax,%esi
  80465f:	48 bf d0 50 80 00 00 	movabs $0x8050d0,%rdi
  804666:	00 00 00 
  804669:	b8 00 00 00 00       	mov    $0x0,%eax
  80466e:	49 b9 7a 04 80 00 00 	movabs $0x80047a,%r9
  804675:	00 00 00 
  804678:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80467b:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  804682:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  804689:	48 89 d6             	mov    %rdx,%rsi
  80468c:	48 89 c7             	mov    %rax,%rdi
  80468f:	48 b8 ce 03 80 00 00 	movabs $0x8003ce,%rax
  804696:	00 00 00 
  804699:	ff d0                	callq  *%rax
	cprintf("\n");
  80469b:	48 bf f3 50 80 00 00 	movabs $0x8050f3,%rdi
  8046a2:	00 00 00 
  8046a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8046aa:	48 ba 7a 04 80 00 00 	movabs $0x80047a,%rdx
  8046b1:	00 00 00 
  8046b4:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8046b6:	cc                   	int3   
  8046b7:	eb fd                	jmp    8046b6 <_panic+0x111>

00000000008046b9 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8046b9:	55                   	push   %rbp
  8046ba:	48 89 e5             	mov    %rsp,%rbp
  8046bd:	48 83 ec 10          	sub    $0x10,%rsp
  8046c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  8046c5:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8046cc:	00 00 00 
  8046cf:	48 8b 00             	mov    (%rax),%rax
  8046d2:	48 85 c0             	test   %rax,%rax
  8046d5:	0f 85 84 00 00 00    	jne    80475f <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  8046db:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8046e2:	00 00 00 
  8046e5:	48 8b 00             	mov    (%rax),%rax
  8046e8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8046ee:	ba 07 00 00 00       	mov    $0x7,%edx
  8046f3:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8046f8:	89 c7                	mov    %eax,%edi
  8046fa:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  804701:	00 00 00 
  804704:	ff d0                	callq  *%rax
  804706:	85 c0                	test   %eax,%eax
  804708:	79 2a                	jns    804734 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  80470a:	48 ba f8 50 80 00 00 	movabs $0x8050f8,%rdx
  804711:	00 00 00 
  804714:	be 23 00 00 00       	mov    $0x23,%esi
  804719:	48 bf 1f 51 80 00 00 	movabs $0x80511f,%rdi
  804720:	00 00 00 
  804723:	b8 00 00 00 00       	mov    $0x0,%eax
  804728:	48 b9 a5 45 80 00 00 	movabs $0x8045a5,%rcx
  80472f:	00 00 00 
  804732:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  804734:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80473b:	00 00 00 
  80473e:	48 8b 00             	mov    (%rax),%rax
  804741:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804747:	48 be 72 47 80 00 00 	movabs $0x804772,%rsi
  80474e:	00 00 00 
  804751:	89 c7                	mov    %eax,%edi
  804753:	48 b8 e8 1a 80 00 00 	movabs $0x801ae8,%rax
  80475a:	00 00 00 
  80475d:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  80475f:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804766:	00 00 00 
  804769:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80476d:	48 89 10             	mov    %rdx,(%rax)
}
  804770:	c9                   	leaveq 
  804771:	c3                   	retq   

0000000000804772 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804772:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804775:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  80477c:	00 00 00 
call *%rax
  80477f:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  804781:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804788:	00 
	movq 152(%rsp), %rcx  //Load RSP
  804789:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804790:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  804791:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  804795:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  804798:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  80479f:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  8047a0:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  8047a4:	4c 8b 3c 24          	mov    (%rsp),%r15
  8047a8:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8047ad:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8047b2:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8047b7:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8047bc:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8047c1:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8047c6:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8047cb:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8047d0:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8047d5:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8047da:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8047df:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8047e4:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8047e9:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8047ee:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  8047f2:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8047f6:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  8047f7:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8047f8:	c3                   	retq   

00000000008047f9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8047f9:	55                   	push   %rbp
  8047fa:	48 89 e5             	mov    %rsp,%rbp
  8047fd:	48 83 ec 18          	sub    $0x18,%rsp
  804801:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804805:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804809:	48 c1 e8 15          	shr    $0x15,%rax
  80480d:	48 89 c2             	mov    %rax,%rdx
  804810:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804817:	01 00 00 
  80481a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80481e:	83 e0 01             	and    $0x1,%eax
  804821:	48 85 c0             	test   %rax,%rax
  804824:	75 07                	jne    80482d <pageref+0x34>
		return 0;
  804826:	b8 00 00 00 00       	mov    $0x0,%eax
  80482b:	eb 53                	jmp    804880 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80482d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804831:	48 c1 e8 0c          	shr    $0xc,%rax
  804835:	48 89 c2             	mov    %rax,%rdx
  804838:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80483f:	01 00 00 
  804842:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804846:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80484a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80484e:	83 e0 01             	and    $0x1,%eax
  804851:	48 85 c0             	test   %rax,%rax
  804854:	75 07                	jne    80485d <pageref+0x64>
		return 0;
  804856:	b8 00 00 00 00       	mov    $0x0,%eax
  80485b:	eb 23                	jmp    804880 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80485d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804861:	48 c1 e8 0c          	shr    $0xc,%rax
  804865:	48 89 c2             	mov    %rax,%rdx
  804868:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80486f:	00 00 00 
  804872:	48 c1 e2 04          	shl    $0x4,%rdx
  804876:	48 01 d0             	add    %rdx,%rax
  804879:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80487d:	0f b7 c0             	movzwl %ax,%eax
}
  804880:	c9                   	leaveq 
  804881:	c3                   	retq   
