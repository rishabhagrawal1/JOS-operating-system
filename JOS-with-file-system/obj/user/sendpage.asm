
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
  800052:	48 b8 b4 1f 80 00 00 	movabs $0x801fb4,%rax
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
  80007d:	48 b8 65 22 80 00 00 	movabs $0x802265,%rax
  800084:	00 00 00 
  800087:	ff d0                	callq  *%rax
		cprintf("%x got message : %s\n", who, TEMP_ADDR_CHILD);
  800089:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008c:	ba 00 00 b0 00       	mov    $0xb00000,%edx
  800091:	89 c6                	mov    %eax,%esi
  800093:	48 bf 2c 3e 80 00 00 	movabs $0x803e2c,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	48 b9 7a 04 80 00 00 	movabs $0x80047a,%rcx
  8000a9:	00 00 00 
  8000ac:	ff d1                	callq  *%rcx
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  8000ae:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000b5:	00 00 00 
  8000b8:	48 8b 00             	mov    (%rax),%rax
  8000bb:	48 89 c7             	mov    %rax,%rdi
  8000be:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	48 63 d0             	movslq %eax,%rdx
  8000cd:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
  8000f2:	48 bf 48 3e 80 00 00 	movabs $0x803e48,%rdi
  8000f9:	00 00 00 
  8000fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800101:	48 ba 7a 04 80 00 00 	movabs $0x80047a,%rdx
  800108:	00 00 00 
  80010b:	ff d2                	callq  *%rdx

		memcpy(TEMP_ADDR_CHILD, str2, strlen(str1) + 1);
  80010d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800114:	00 00 00 
  800117:	48 8b 00             	mov    (%rax),%rax
  80011a:	48 89 c7             	mov    %rax,%rdi
  80011d:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  800124:	00 00 00 
  800127:	ff d0                	callq  *%rax
  800129:	83 c0 01             	add    $0x1,%eax
  80012c:	48 63 d0             	movslq %eax,%rdx
  80012f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
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
  800164:	48 b8 6b 23 80 00 00 	movabs $0x80236b,%rax
  80016b:	00 00 00 
  80016e:	ff d0                	callq  *%rax
		return;
  800170:	e9 30 01 00 00       	jmpq   8002a5 <umain+0x262>
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800175:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
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
  8001a0:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001a7:	00 00 00 
  8001aa:	48 8b 00             	mov    (%rax),%rax
  8001ad:	48 89 c7             	mov    %rax,%rdi
  8001b0:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  8001b7:	00 00 00 
  8001ba:	ff d0                	callq  *%rax
  8001bc:	83 c0 01             	add    $0x1,%eax
  8001bf:	48 63 d0             	movslq %eax,%rdx
  8001c2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
  8001f7:	48 b8 6b 23 80 00 00 	movabs $0x80236b,%rax
  8001fe:	00 00 00 
  800201:	ff d0                	callq  *%rax

	ipc_recv(&who, TEMP_ADDR, 0);
  800203:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
  800207:	ba 00 00 00 00       	mov    $0x0,%edx
  80020c:	be 00 00 a0 00       	mov    $0xa00000,%esi
  800211:	48 89 c7             	mov    %rax,%rdi
  800214:	48 b8 65 22 80 00 00 	movabs $0x802265,%rax
  80021b:	00 00 00 
  80021e:	ff d0                	callq  *%rax
	cprintf("%x got message : %s\n", who, TEMP_ADDR);
  800220:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800223:	ba 00 00 a0 00       	mov    $0xa00000,%edx
  800228:	89 c6                	mov    %eax,%esi
  80022a:	48 bf 2c 3e 80 00 00 	movabs $0x803e2c,%rdi
  800231:	00 00 00 
  800234:	b8 00 00 00 00       	mov    $0x0,%eax
  800239:	48 b9 7a 04 80 00 00 	movabs $0x80047a,%rcx
  800240:	00 00 00 
  800243:	ff d1                	callq  *%rcx
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  800245:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80024c:	00 00 00 
  80024f:	48 8b 00             	mov    (%rax),%rax
  800252:	48 89 c7             	mov    %rax,%rdi
  800255:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  80025c:	00 00 00 
  80025f:	ff d0                	callq  *%rax
  800261:	48 63 d0             	movslq %eax,%rdx
  800264:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
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
  800289:	48 bf 68 3e 80 00 00 	movabs $0x803e68,%rdi
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
  8002e5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
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
  8002ff:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
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
  800336:	48 b8 90 27 80 00 00 	movabs $0x802790,%rax
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
  8005e6:	48 ba 68 40 80 00 00 	movabs $0x804068,%rdx
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
  8008de:	48 b8 90 40 80 00 00 	movabs $0x804090,%rax
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
  800a2c:	83 fb 10             	cmp    $0x10,%ebx
  800a2f:	7f 16                	jg     800a47 <vprintfmt+0x21a>
  800a31:	48 b8 e0 3f 80 00 00 	movabs $0x803fe0,%rax
  800a38:	00 00 00 
  800a3b:	48 63 d3             	movslq %ebx,%rdx
  800a3e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a42:	4d 85 e4             	test   %r12,%r12
  800a45:	75 2e                	jne    800a75 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a47:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a4b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a4f:	89 d9                	mov    %ebx,%ecx
  800a51:	48 ba 79 40 80 00 00 	movabs $0x804079,%rdx
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
  800a80:	48 ba 82 40 80 00 00 	movabs $0x804082,%rdx
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
  800ada:	49 bc 85 40 80 00 00 	movabs $0x804085,%r12
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
  8017e0:	48 ba 40 43 80 00 00 	movabs $0x804340,%rdx
  8017e7:	00 00 00 
  8017ea:	be 23 00 00 00       	mov    $0x23,%esi
  8017ef:	48 bf 5d 43 80 00 00 	movabs $0x80435d,%rdi
  8017f6:	00 00 00 
  8017f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fe:	49 b9 f4 3a 80 00 00 	movabs $0x803af4,%r9
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

0000000000801bcb <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801bcb:	55                   	push   %rbp
  801bcc:	48 89 e5             	mov    %rsp,%rbp
  801bcf:	48 83 ec 30          	sub    $0x30,%rsp
  801bd3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801bd7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bdb:	48 8b 00             	mov    (%rax),%rax
  801bde:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801be2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801be6:	48 8b 40 08          	mov    0x8(%rax),%rax
  801bea:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801bed:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bf0:	83 e0 02             	and    $0x2,%eax
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	75 4d                	jne    801c44 <pgfault+0x79>
  801bf7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bfb:	48 c1 e8 0c          	shr    $0xc,%rax
  801bff:	48 89 c2             	mov    %rax,%rdx
  801c02:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c09:	01 00 00 
  801c0c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c10:	25 00 08 00 00       	and    $0x800,%eax
  801c15:	48 85 c0             	test   %rax,%rax
  801c18:	74 2a                	je     801c44 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801c1a:	48 ba 70 43 80 00 00 	movabs $0x804370,%rdx
  801c21:	00 00 00 
  801c24:	be 23 00 00 00       	mov    $0x23,%esi
  801c29:	48 bf a5 43 80 00 00 	movabs $0x8043a5,%rdi
  801c30:	00 00 00 
  801c33:	b8 00 00 00 00       	mov    $0x0,%eax
  801c38:	48 b9 f4 3a 80 00 00 	movabs $0x803af4,%rcx
  801c3f:	00 00 00 
  801c42:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801c44:	ba 07 00 00 00       	mov    $0x7,%edx
  801c49:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c4e:	bf 00 00 00 00       	mov    $0x0,%edi
  801c53:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  801c5a:	00 00 00 
  801c5d:	ff d0                	callq  *%rax
  801c5f:	85 c0                	test   %eax,%eax
  801c61:	0f 85 cd 00 00 00    	jne    801d34 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801c67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c6b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801c6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c73:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801c79:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801c7d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c81:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c86:	48 89 c6             	mov    %rax,%rsi
  801c89:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801c8e:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  801c95:	00 00 00 
  801c98:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801c9a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c9e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801ca4:	48 89 c1             	mov    %rax,%rcx
  801ca7:	ba 00 00 00 00       	mov    $0x0,%edx
  801cac:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801cb1:	bf 00 00 00 00       	mov    $0x0,%edi
  801cb6:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  801cbd:	00 00 00 
  801cc0:	ff d0                	callq  *%rax
  801cc2:	85 c0                	test   %eax,%eax
  801cc4:	79 2a                	jns    801cf0 <pgfault+0x125>
				panic("Page map at temp address failed");
  801cc6:	48 ba b0 43 80 00 00 	movabs $0x8043b0,%rdx
  801ccd:	00 00 00 
  801cd0:	be 30 00 00 00       	mov    $0x30,%esi
  801cd5:	48 bf a5 43 80 00 00 	movabs $0x8043a5,%rdi
  801cdc:	00 00 00 
  801cdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce4:	48 b9 f4 3a 80 00 00 	movabs $0x803af4,%rcx
  801ceb:	00 00 00 
  801cee:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801cf0:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801cf5:	bf 00 00 00 00       	mov    $0x0,%edi
  801cfa:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801d01:	00 00 00 
  801d04:	ff d0                	callq  *%rax
  801d06:	85 c0                	test   %eax,%eax
  801d08:	79 54                	jns    801d5e <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801d0a:	48 ba d0 43 80 00 00 	movabs $0x8043d0,%rdx
  801d11:	00 00 00 
  801d14:	be 32 00 00 00       	mov    $0x32,%esi
  801d19:	48 bf a5 43 80 00 00 	movabs $0x8043a5,%rdi
  801d20:	00 00 00 
  801d23:	b8 00 00 00 00       	mov    $0x0,%eax
  801d28:	48 b9 f4 3a 80 00 00 	movabs $0x803af4,%rcx
  801d2f:	00 00 00 
  801d32:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801d34:	48 ba f8 43 80 00 00 	movabs $0x8043f8,%rdx
  801d3b:	00 00 00 
  801d3e:	be 34 00 00 00       	mov    $0x34,%esi
  801d43:	48 bf a5 43 80 00 00 	movabs $0x8043a5,%rdi
  801d4a:	00 00 00 
  801d4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d52:	48 b9 f4 3a 80 00 00 	movabs $0x803af4,%rcx
  801d59:	00 00 00 
  801d5c:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801d5e:	c9                   	leaveq 
  801d5f:	c3                   	retq   

0000000000801d60 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d60:	55                   	push   %rbp
  801d61:	48 89 e5             	mov    %rsp,%rbp
  801d64:	48 83 ec 20          	sub    $0x20,%rsp
  801d68:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d6b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801d6e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d75:	01 00 00 
  801d78:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801d7b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d7f:	25 07 0e 00 00       	and    $0xe07,%eax
  801d84:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801d87:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801d8a:	48 c1 e0 0c          	shl    $0xc,%rax
  801d8e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801d92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d95:	25 00 04 00 00       	and    $0x400,%eax
  801d9a:	85 c0                	test   %eax,%eax
  801d9c:	74 57                	je     801df5 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d9e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801da1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801da5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801da8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dac:	41 89 f0             	mov    %esi,%r8d
  801daf:	48 89 c6             	mov    %rax,%rsi
  801db2:	bf 00 00 00 00       	mov    $0x0,%edi
  801db7:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  801dbe:	00 00 00 
  801dc1:	ff d0                	callq  *%rax
  801dc3:	85 c0                	test   %eax,%eax
  801dc5:	0f 8e 52 01 00 00    	jle    801f1d <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801dcb:	48 ba 2a 44 80 00 00 	movabs $0x80442a,%rdx
  801dd2:	00 00 00 
  801dd5:	be 4e 00 00 00       	mov    $0x4e,%esi
  801dda:	48 bf a5 43 80 00 00 	movabs $0x8043a5,%rdi
  801de1:	00 00 00 
  801de4:	b8 00 00 00 00       	mov    $0x0,%eax
  801de9:	48 b9 f4 3a 80 00 00 	movabs $0x803af4,%rcx
  801df0:	00 00 00 
  801df3:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801df5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801df8:	83 e0 02             	and    $0x2,%eax
  801dfb:	85 c0                	test   %eax,%eax
  801dfd:	75 10                	jne    801e0f <duppage+0xaf>
  801dff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e02:	25 00 08 00 00       	and    $0x800,%eax
  801e07:	85 c0                	test   %eax,%eax
  801e09:	0f 84 bb 00 00 00    	je     801eca <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801e0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e12:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801e17:	80 cc 08             	or     $0x8,%ah
  801e1a:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e1d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e20:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e24:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e2b:	41 89 f0             	mov    %esi,%r8d
  801e2e:	48 89 c6             	mov    %rax,%rsi
  801e31:	bf 00 00 00 00       	mov    $0x0,%edi
  801e36:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  801e3d:	00 00 00 
  801e40:	ff d0                	callq  *%rax
  801e42:	85 c0                	test   %eax,%eax
  801e44:	7e 2a                	jle    801e70 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801e46:	48 ba 2a 44 80 00 00 	movabs $0x80442a,%rdx
  801e4d:	00 00 00 
  801e50:	be 55 00 00 00       	mov    $0x55,%esi
  801e55:	48 bf a5 43 80 00 00 	movabs $0x8043a5,%rdi
  801e5c:	00 00 00 
  801e5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e64:	48 b9 f4 3a 80 00 00 	movabs $0x803af4,%rcx
  801e6b:	00 00 00 
  801e6e:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801e70:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801e73:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e7b:	41 89 c8             	mov    %ecx,%r8d
  801e7e:	48 89 d1             	mov    %rdx,%rcx
  801e81:	ba 00 00 00 00       	mov    $0x0,%edx
  801e86:	48 89 c6             	mov    %rax,%rsi
  801e89:	bf 00 00 00 00       	mov    $0x0,%edi
  801e8e:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  801e95:	00 00 00 
  801e98:	ff d0                	callq  *%rax
  801e9a:	85 c0                	test   %eax,%eax
  801e9c:	7e 2a                	jle    801ec8 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  801e9e:	48 ba 2a 44 80 00 00 	movabs $0x80442a,%rdx
  801ea5:	00 00 00 
  801ea8:	be 57 00 00 00       	mov    $0x57,%esi
  801ead:	48 bf a5 43 80 00 00 	movabs $0x8043a5,%rdi
  801eb4:	00 00 00 
  801eb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebc:	48 b9 f4 3a 80 00 00 	movabs $0x803af4,%rcx
  801ec3:	00 00 00 
  801ec6:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801ec8:	eb 53                	jmp    801f1d <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801eca:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801ecd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801ed1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ed4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ed8:	41 89 f0             	mov    %esi,%r8d
  801edb:	48 89 c6             	mov    %rax,%rsi
  801ede:	bf 00 00 00 00       	mov    $0x0,%edi
  801ee3:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  801eea:	00 00 00 
  801eed:	ff d0                	callq  *%rax
  801eef:	85 c0                	test   %eax,%eax
  801ef1:	7e 2a                	jle    801f1d <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801ef3:	48 ba 2a 44 80 00 00 	movabs $0x80442a,%rdx
  801efa:	00 00 00 
  801efd:	be 5b 00 00 00       	mov    $0x5b,%esi
  801f02:	48 bf a5 43 80 00 00 	movabs $0x8043a5,%rdi
  801f09:	00 00 00 
  801f0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f11:	48 b9 f4 3a 80 00 00 	movabs $0x803af4,%rcx
  801f18:	00 00 00 
  801f1b:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  801f1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f22:	c9                   	leaveq 
  801f23:	c3                   	retq   

0000000000801f24 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  801f24:	55                   	push   %rbp
  801f25:	48 89 e5             	mov    %rsp,%rbp
  801f28:	48 83 ec 18          	sub    $0x18,%rsp
  801f2c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  801f30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f34:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  801f38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f3c:	48 c1 e8 27          	shr    $0x27,%rax
  801f40:	48 89 c2             	mov    %rax,%rdx
  801f43:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801f4a:	01 00 00 
  801f4d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f51:	83 e0 01             	and    $0x1,%eax
  801f54:	48 85 c0             	test   %rax,%rax
  801f57:	74 51                	je     801faa <pt_is_mapped+0x86>
  801f59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f5d:	48 c1 e0 0c          	shl    $0xc,%rax
  801f61:	48 c1 e8 1e          	shr    $0x1e,%rax
  801f65:	48 89 c2             	mov    %rax,%rdx
  801f68:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801f6f:	01 00 00 
  801f72:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f76:	83 e0 01             	and    $0x1,%eax
  801f79:	48 85 c0             	test   %rax,%rax
  801f7c:	74 2c                	je     801faa <pt_is_mapped+0x86>
  801f7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f82:	48 c1 e0 0c          	shl    $0xc,%rax
  801f86:	48 c1 e8 15          	shr    $0x15,%rax
  801f8a:	48 89 c2             	mov    %rax,%rdx
  801f8d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f94:	01 00 00 
  801f97:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f9b:	83 e0 01             	and    $0x1,%eax
  801f9e:	48 85 c0             	test   %rax,%rax
  801fa1:	74 07                	je     801faa <pt_is_mapped+0x86>
  801fa3:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa8:	eb 05                	jmp    801faf <pt_is_mapped+0x8b>
  801faa:	b8 00 00 00 00       	mov    $0x0,%eax
  801faf:	83 e0 01             	and    $0x1,%eax
}
  801fb2:	c9                   	leaveq 
  801fb3:	c3                   	retq   

0000000000801fb4 <fork>:

envid_t
fork(void)
{
  801fb4:	55                   	push   %rbp
  801fb5:	48 89 e5             	mov    %rsp,%rbp
  801fb8:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  801fbc:	48 bf cb 1b 80 00 00 	movabs $0x801bcb,%rdi
  801fc3:	00 00 00 
  801fc6:	48 b8 08 3c 80 00 00 	movabs $0x803c08,%rax
  801fcd:	00 00 00 
  801fd0:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801fd2:	b8 07 00 00 00       	mov    $0x7,%eax
  801fd7:	cd 30                	int    $0x30
  801fd9:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801fdc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801fdf:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  801fe2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801fe6:	79 30                	jns    802018 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801fe8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801feb:	89 c1                	mov    %eax,%ecx
  801fed:	48 ba 48 44 80 00 00 	movabs $0x804448,%rdx
  801ff4:	00 00 00 
  801ff7:	be 86 00 00 00       	mov    $0x86,%esi
  801ffc:	48 bf a5 43 80 00 00 	movabs $0x8043a5,%rdi
  802003:	00 00 00 
  802006:	b8 00 00 00 00       	mov    $0x0,%eax
  80200b:	49 b8 f4 3a 80 00 00 	movabs $0x803af4,%r8
  802012:	00 00 00 
  802015:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802018:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80201c:	75 46                	jne    802064 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80201e:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  802025:	00 00 00 
  802028:	ff d0                	callq  *%rax
  80202a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80202f:	48 63 d0             	movslq %eax,%rdx
  802032:	48 89 d0             	mov    %rdx,%rax
  802035:	48 c1 e0 03          	shl    $0x3,%rax
  802039:	48 01 d0             	add    %rdx,%rax
  80203c:	48 c1 e0 05          	shl    $0x5,%rax
  802040:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802047:	00 00 00 
  80204a:	48 01 c2             	add    %rax,%rdx
  80204d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802054:	00 00 00 
  802057:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80205a:	b8 00 00 00 00       	mov    $0x0,%eax
  80205f:	e9 d1 01 00 00       	jmpq   802235 <fork+0x281>
	}
	uint64_t ad = 0;
  802064:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80206b:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80206c:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  802071:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802075:	e9 df 00 00 00       	jmpq   802159 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  80207a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80207e:	48 c1 e8 27          	shr    $0x27,%rax
  802082:	48 89 c2             	mov    %rax,%rdx
  802085:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80208c:	01 00 00 
  80208f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802093:	83 e0 01             	and    $0x1,%eax
  802096:	48 85 c0             	test   %rax,%rax
  802099:	0f 84 9e 00 00 00    	je     80213d <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  80209f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020a3:	48 c1 e8 1e          	shr    $0x1e,%rax
  8020a7:	48 89 c2             	mov    %rax,%rdx
  8020aa:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8020b1:	01 00 00 
  8020b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020b8:	83 e0 01             	and    $0x1,%eax
  8020bb:	48 85 c0             	test   %rax,%rax
  8020be:	74 73                	je     802133 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  8020c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020c4:	48 c1 e8 15          	shr    $0x15,%rax
  8020c8:	48 89 c2             	mov    %rax,%rdx
  8020cb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020d2:	01 00 00 
  8020d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020d9:	83 e0 01             	and    $0x1,%eax
  8020dc:	48 85 c0             	test   %rax,%rax
  8020df:	74 48                	je     802129 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8020e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020e5:	48 c1 e8 0c          	shr    $0xc,%rax
  8020e9:	48 89 c2             	mov    %rax,%rdx
  8020ec:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020f3:	01 00 00 
  8020f6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020fa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8020fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802102:	83 e0 01             	and    $0x1,%eax
  802105:	48 85 c0             	test   %rax,%rax
  802108:	74 47                	je     802151 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  80210a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80210e:	48 c1 e8 0c          	shr    $0xc,%rax
  802112:	89 c2                	mov    %eax,%edx
  802114:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802117:	89 d6                	mov    %edx,%esi
  802119:	89 c7                	mov    %eax,%edi
  80211b:	48 b8 60 1d 80 00 00 	movabs $0x801d60,%rax
  802122:	00 00 00 
  802125:	ff d0                	callq  *%rax
  802127:	eb 28                	jmp    802151 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  802129:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802130:	00 
  802131:	eb 1e                	jmp    802151 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802133:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  80213a:	40 
  80213b:	eb 14                	jmp    802151 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  80213d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802141:	48 c1 e8 27          	shr    $0x27,%rax
  802145:	48 83 c0 01          	add    $0x1,%rax
  802149:	48 c1 e0 27          	shl    $0x27,%rax
  80214d:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802151:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802158:	00 
  802159:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802160:	00 
  802161:	0f 87 13 ff ff ff    	ja     80207a <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802167:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80216a:	ba 07 00 00 00       	mov    $0x7,%edx
  80216f:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802174:	89 c7                	mov    %eax,%edi
  802176:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  80217d:	00 00 00 
  802180:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802182:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802185:	ba 07 00 00 00       	mov    $0x7,%edx
  80218a:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80218f:	89 c7                	mov    %eax,%edi
  802191:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  802198:	00 00 00 
  80219b:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  80219d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021a0:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8021a6:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8021ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b0:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8021b5:	89 c7                	mov    %eax,%edi
  8021b7:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  8021be:	00 00 00 
  8021c1:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8021c3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8021c8:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8021cd:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8021d2:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  8021d9:	00 00 00 
  8021dc:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8021de:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8021e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8021e8:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  8021ef:	00 00 00 
  8021f2:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  8021f4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021fb:	00 00 00 
  8021fe:	48 8b 00             	mov    (%rax),%rax
  802201:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802208:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80220b:	48 89 d6             	mov    %rdx,%rsi
  80220e:	89 c7                	mov    %eax,%edi
  802210:	48 b8 e8 1a 80 00 00 	movabs $0x801ae8,%rax
  802217:	00 00 00 
  80221a:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  80221c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80221f:	be 02 00 00 00       	mov    $0x2,%esi
  802224:	89 c7                	mov    %eax,%edi
  802226:	48 b8 53 1a 80 00 00 	movabs $0x801a53,%rax
  80222d:	00 00 00 
  802230:	ff d0                	callq  *%rax

	return envid;
  802232:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802235:	c9                   	leaveq 
  802236:	c3                   	retq   

0000000000802237 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802237:	55                   	push   %rbp
  802238:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80223b:	48 ba 60 44 80 00 00 	movabs $0x804460,%rdx
  802242:	00 00 00 
  802245:	be bf 00 00 00       	mov    $0xbf,%esi
  80224a:	48 bf a5 43 80 00 00 	movabs $0x8043a5,%rdi
  802251:	00 00 00 
  802254:	b8 00 00 00 00       	mov    $0x0,%eax
  802259:	48 b9 f4 3a 80 00 00 	movabs $0x803af4,%rcx
  802260:	00 00 00 
  802263:	ff d1                	callq  *%rcx

0000000000802265 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802265:	55                   	push   %rbp
  802266:	48 89 e5             	mov    %rsp,%rbp
  802269:	48 83 ec 30          	sub    $0x30,%rsp
  80226d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802271:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802275:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  802279:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802280:	00 00 00 
  802283:	48 8b 00             	mov    (%rax),%rax
  802286:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80228c:	85 c0                	test   %eax,%eax
  80228e:	75 3c                	jne    8022cc <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  802290:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  802297:	00 00 00 
  80229a:	ff d0                	callq  *%rax
  80229c:	25 ff 03 00 00       	and    $0x3ff,%eax
  8022a1:	48 63 d0             	movslq %eax,%rdx
  8022a4:	48 89 d0             	mov    %rdx,%rax
  8022a7:	48 c1 e0 03          	shl    $0x3,%rax
  8022ab:	48 01 d0             	add    %rdx,%rax
  8022ae:	48 c1 e0 05          	shl    $0x5,%rax
  8022b2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8022b9:	00 00 00 
  8022bc:	48 01 c2             	add    %rax,%rdx
  8022bf:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022c6:	00 00 00 
  8022c9:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8022cc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8022d1:	75 0e                	jne    8022e1 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  8022d3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8022da:	00 00 00 
  8022dd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8022e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022e5:	48 89 c7             	mov    %rax,%rdi
  8022e8:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  8022ef:	00 00 00 
  8022f2:	ff d0                	callq  *%rax
  8022f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8022f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022fb:	79 19                	jns    802316 <ipc_recv+0xb1>
		*from_env_store = 0;
  8022fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802301:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  802307:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80230b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  802311:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802314:	eb 53                	jmp    802369 <ipc_recv+0x104>
	}
	if(from_env_store)
  802316:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80231b:	74 19                	je     802336 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  80231d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802324:	00 00 00 
  802327:	48 8b 00             	mov    (%rax),%rax
  80232a:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802330:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802334:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  802336:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80233b:	74 19                	je     802356 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  80233d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802344:	00 00 00 
  802347:	48 8b 00             	mov    (%rax),%rax
  80234a:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802350:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802354:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  802356:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80235d:	00 00 00 
  802360:	48 8b 00             	mov    (%rax),%rax
  802363:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  802369:	c9                   	leaveq 
  80236a:	c3                   	retq   

000000000080236b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80236b:	55                   	push   %rbp
  80236c:	48 89 e5             	mov    %rsp,%rbp
  80236f:	48 83 ec 30          	sub    $0x30,%rsp
  802373:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802376:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802379:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80237d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  802380:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802385:	75 0e                	jne    802395 <ipc_send+0x2a>
		pg = (void*)UTOP;
  802387:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80238e:	00 00 00 
  802391:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  802395:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802398:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80239b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80239f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023a2:	89 c7                	mov    %eax,%edi
  8023a4:	48 b8 32 1b 80 00 00 	movabs $0x801b32,%rax
  8023ab:	00 00 00 
  8023ae:	ff d0                	callq  *%rax
  8023b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8023b3:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8023b7:	75 0c                	jne    8023c5 <ipc_send+0x5a>
			sys_yield();
  8023b9:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  8023c0:	00 00 00 
  8023c3:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8023c5:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8023c9:	74 ca                	je     802395 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8023cb:	c9                   	leaveq 
  8023cc:	c3                   	retq   

00000000008023cd <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023cd:	55                   	push   %rbp
  8023ce:	48 89 e5             	mov    %rsp,%rbp
  8023d1:	48 83 ec 14          	sub    $0x14,%rsp
  8023d5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8023d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023df:	eb 5e                	jmp    80243f <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8023e1:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8023e8:	00 00 00 
  8023eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ee:	48 63 d0             	movslq %eax,%rdx
  8023f1:	48 89 d0             	mov    %rdx,%rax
  8023f4:	48 c1 e0 03          	shl    $0x3,%rax
  8023f8:	48 01 d0             	add    %rdx,%rax
  8023fb:	48 c1 e0 05          	shl    $0x5,%rax
  8023ff:	48 01 c8             	add    %rcx,%rax
  802402:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802408:	8b 00                	mov    (%rax),%eax
  80240a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80240d:	75 2c                	jne    80243b <ipc_find_env+0x6e>
			return envs[i].env_id;
  80240f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802416:	00 00 00 
  802419:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241c:	48 63 d0             	movslq %eax,%rdx
  80241f:	48 89 d0             	mov    %rdx,%rax
  802422:	48 c1 e0 03          	shl    $0x3,%rax
  802426:	48 01 d0             	add    %rdx,%rax
  802429:	48 c1 e0 05          	shl    $0x5,%rax
  80242d:	48 01 c8             	add    %rcx,%rax
  802430:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802436:	8b 40 08             	mov    0x8(%rax),%eax
  802439:	eb 12                	jmp    80244d <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80243b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80243f:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802446:	7e 99                	jle    8023e1 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802448:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80244d:	c9                   	leaveq 
  80244e:	c3                   	retq   

000000000080244f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80244f:	55                   	push   %rbp
  802450:	48 89 e5             	mov    %rsp,%rbp
  802453:	48 83 ec 08          	sub    $0x8,%rsp
  802457:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80245b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80245f:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802466:	ff ff ff 
  802469:	48 01 d0             	add    %rdx,%rax
  80246c:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802470:	c9                   	leaveq 
  802471:	c3                   	retq   

0000000000802472 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802472:	55                   	push   %rbp
  802473:	48 89 e5             	mov    %rsp,%rbp
  802476:	48 83 ec 08          	sub    $0x8,%rsp
  80247a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80247e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802482:	48 89 c7             	mov    %rax,%rdi
  802485:	48 b8 4f 24 80 00 00 	movabs $0x80244f,%rax
  80248c:	00 00 00 
  80248f:	ff d0                	callq  *%rax
  802491:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802497:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80249b:	c9                   	leaveq 
  80249c:	c3                   	retq   

000000000080249d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80249d:	55                   	push   %rbp
  80249e:	48 89 e5             	mov    %rsp,%rbp
  8024a1:	48 83 ec 18          	sub    $0x18,%rsp
  8024a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8024a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024b0:	eb 6b                	jmp    80251d <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8024b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b5:	48 98                	cltq   
  8024b7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024bd:	48 c1 e0 0c          	shl    $0xc,%rax
  8024c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8024c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c9:	48 c1 e8 15          	shr    $0x15,%rax
  8024cd:	48 89 c2             	mov    %rax,%rdx
  8024d0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024d7:	01 00 00 
  8024da:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024de:	83 e0 01             	and    $0x1,%eax
  8024e1:	48 85 c0             	test   %rax,%rax
  8024e4:	74 21                	je     802507 <fd_alloc+0x6a>
  8024e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ea:	48 c1 e8 0c          	shr    $0xc,%rax
  8024ee:	48 89 c2             	mov    %rax,%rdx
  8024f1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024f8:	01 00 00 
  8024fb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024ff:	83 e0 01             	and    $0x1,%eax
  802502:	48 85 c0             	test   %rax,%rax
  802505:	75 12                	jne    802519 <fd_alloc+0x7c>
			*fd_store = fd;
  802507:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80250b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80250f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802512:	b8 00 00 00 00       	mov    $0x0,%eax
  802517:	eb 1a                	jmp    802533 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802519:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80251d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802521:	7e 8f                	jle    8024b2 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802523:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802527:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80252e:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802533:	c9                   	leaveq 
  802534:	c3                   	retq   

0000000000802535 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802535:	55                   	push   %rbp
  802536:	48 89 e5             	mov    %rsp,%rbp
  802539:	48 83 ec 20          	sub    $0x20,%rsp
  80253d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802540:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802544:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802548:	78 06                	js     802550 <fd_lookup+0x1b>
  80254a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80254e:	7e 07                	jle    802557 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802550:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802555:	eb 6c                	jmp    8025c3 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802557:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80255a:	48 98                	cltq   
  80255c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802562:	48 c1 e0 0c          	shl    $0xc,%rax
  802566:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80256a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80256e:	48 c1 e8 15          	shr    $0x15,%rax
  802572:	48 89 c2             	mov    %rax,%rdx
  802575:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80257c:	01 00 00 
  80257f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802583:	83 e0 01             	and    $0x1,%eax
  802586:	48 85 c0             	test   %rax,%rax
  802589:	74 21                	je     8025ac <fd_lookup+0x77>
  80258b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80258f:	48 c1 e8 0c          	shr    $0xc,%rax
  802593:	48 89 c2             	mov    %rax,%rdx
  802596:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80259d:	01 00 00 
  8025a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025a4:	83 e0 01             	and    $0x1,%eax
  8025a7:	48 85 c0             	test   %rax,%rax
  8025aa:	75 07                	jne    8025b3 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025b1:	eb 10                	jmp    8025c3 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8025b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025b7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025bb:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8025be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c3:	c9                   	leaveq 
  8025c4:	c3                   	retq   

00000000008025c5 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8025c5:	55                   	push   %rbp
  8025c6:	48 89 e5             	mov    %rsp,%rbp
  8025c9:	48 83 ec 30          	sub    $0x30,%rsp
  8025cd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8025d1:	89 f0                	mov    %esi,%eax
  8025d3:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8025d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025da:	48 89 c7             	mov    %rax,%rdi
  8025dd:	48 b8 4f 24 80 00 00 	movabs $0x80244f,%rax
  8025e4:	00 00 00 
  8025e7:	ff d0                	callq  *%rax
  8025e9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025ed:	48 89 d6             	mov    %rdx,%rsi
  8025f0:	89 c7                	mov    %eax,%edi
  8025f2:	48 b8 35 25 80 00 00 	movabs $0x802535,%rax
  8025f9:	00 00 00 
  8025fc:	ff d0                	callq  *%rax
  8025fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802601:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802605:	78 0a                	js     802611 <fd_close+0x4c>
	    || fd != fd2)
  802607:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80260b:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80260f:	74 12                	je     802623 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802611:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802615:	74 05                	je     80261c <fd_close+0x57>
  802617:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80261a:	eb 05                	jmp    802621 <fd_close+0x5c>
  80261c:	b8 00 00 00 00       	mov    $0x0,%eax
  802621:	eb 69                	jmp    80268c <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802623:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802627:	8b 00                	mov    (%rax),%eax
  802629:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80262d:	48 89 d6             	mov    %rdx,%rsi
  802630:	89 c7                	mov    %eax,%edi
  802632:	48 b8 8e 26 80 00 00 	movabs $0x80268e,%rax
  802639:	00 00 00 
  80263c:	ff d0                	callq  *%rax
  80263e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802641:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802645:	78 2a                	js     802671 <fd_close+0xac>
		if (dev->dev_close)
  802647:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264b:	48 8b 40 20          	mov    0x20(%rax),%rax
  80264f:	48 85 c0             	test   %rax,%rax
  802652:	74 16                	je     80266a <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802654:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802658:	48 8b 40 20          	mov    0x20(%rax),%rax
  80265c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802660:	48 89 d7             	mov    %rdx,%rdi
  802663:	ff d0                	callq  *%rax
  802665:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802668:	eb 07                	jmp    802671 <fd_close+0xac>
		else
			r = 0;
  80266a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802671:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802675:	48 89 c6             	mov    %rax,%rsi
  802678:	bf 00 00 00 00       	mov    $0x0,%edi
  80267d:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  802684:	00 00 00 
  802687:	ff d0                	callq  *%rax
	return r;
  802689:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80268c:	c9                   	leaveq 
  80268d:	c3                   	retq   

000000000080268e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80268e:	55                   	push   %rbp
  80268f:	48 89 e5             	mov    %rsp,%rbp
  802692:	48 83 ec 20          	sub    $0x20,%rsp
  802696:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802699:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80269d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026a4:	eb 41                	jmp    8026e7 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8026a6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8026ad:	00 00 00 
  8026b0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026b3:	48 63 d2             	movslq %edx,%rdx
  8026b6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026ba:	8b 00                	mov    (%rax),%eax
  8026bc:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8026bf:	75 22                	jne    8026e3 <dev_lookup+0x55>
			*dev = devtab[i];
  8026c1:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8026c8:	00 00 00 
  8026cb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026ce:	48 63 d2             	movslq %edx,%rdx
  8026d1:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8026d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026d9:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8026dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e1:	eb 60                	jmp    802743 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8026e3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026e7:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8026ee:	00 00 00 
  8026f1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026f4:	48 63 d2             	movslq %edx,%rdx
  8026f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026fb:	48 85 c0             	test   %rax,%rax
  8026fe:	75 a6                	jne    8026a6 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802700:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802707:	00 00 00 
  80270a:	48 8b 00             	mov    (%rax),%rax
  80270d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802713:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802716:	89 c6                	mov    %eax,%esi
  802718:	48 bf 78 44 80 00 00 	movabs $0x804478,%rdi
  80271f:	00 00 00 
  802722:	b8 00 00 00 00       	mov    $0x0,%eax
  802727:	48 b9 7a 04 80 00 00 	movabs $0x80047a,%rcx
  80272e:	00 00 00 
  802731:	ff d1                	callq  *%rcx
	*dev = 0;
  802733:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802737:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80273e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802743:	c9                   	leaveq 
  802744:	c3                   	retq   

0000000000802745 <close>:

int
close(int fdnum)
{
  802745:	55                   	push   %rbp
  802746:	48 89 e5             	mov    %rsp,%rbp
  802749:	48 83 ec 20          	sub    $0x20,%rsp
  80274d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802750:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802754:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802757:	48 89 d6             	mov    %rdx,%rsi
  80275a:	89 c7                	mov    %eax,%edi
  80275c:	48 b8 35 25 80 00 00 	movabs $0x802535,%rax
  802763:	00 00 00 
  802766:	ff d0                	callq  *%rax
  802768:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80276b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80276f:	79 05                	jns    802776 <close+0x31>
		return r;
  802771:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802774:	eb 18                	jmp    80278e <close+0x49>
	else
		return fd_close(fd, 1);
  802776:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80277a:	be 01 00 00 00       	mov    $0x1,%esi
  80277f:	48 89 c7             	mov    %rax,%rdi
  802782:	48 b8 c5 25 80 00 00 	movabs $0x8025c5,%rax
  802789:	00 00 00 
  80278c:	ff d0                	callq  *%rax
}
  80278e:	c9                   	leaveq 
  80278f:	c3                   	retq   

0000000000802790 <close_all>:

void
close_all(void)
{
  802790:	55                   	push   %rbp
  802791:	48 89 e5             	mov    %rsp,%rbp
  802794:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802798:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80279f:	eb 15                	jmp    8027b6 <close_all+0x26>
		close(i);
  8027a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a4:	89 c7                	mov    %eax,%edi
  8027a6:	48 b8 45 27 80 00 00 	movabs $0x802745,%rax
  8027ad:	00 00 00 
  8027b0:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8027b2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027b6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8027ba:	7e e5                	jle    8027a1 <close_all+0x11>
		close(i);
}
  8027bc:	c9                   	leaveq 
  8027bd:	c3                   	retq   

00000000008027be <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8027be:	55                   	push   %rbp
  8027bf:	48 89 e5             	mov    %rsp,%rbp
  8027c2:	48 83 ec 40          	sub    $0x40,%rsp
  8027c6:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8027c9:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8027cc:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8027d0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8027d3:	48 89 d6             	mov    %rdx,%rsi
  8027d6:	89 c7                	mov    %eax,%edi
  8027d8:	48 b8 35 25 80 00 00 	movabs $0x802535,%rax
  8027df:	00 00 00 
  8027e2:	ff d0                	callq  *%rax
  8027e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027eb:	79 08                	jns    8027f5 <dup+0x37>
		return r;
  8027ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f0:	e9 70 01 00 00       	jmpq   802965 <dup+0x1a7>
	close(newfdnum);
  8027f5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027f8:	89 c7                	mov    %eax,%edi
  8027fa:	48 b8 45 27 80 00 00 	movabs $0x802745,%rax
  802801:	00 00 00 
  802804:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802806:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802809:	48 98                	cltq   
  80280b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802811:	48 c1 e0 0c          	shl    $0xc,%rax
  802815:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802819:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80281d:	48 89 c7             	mov    %rax,%rdi
  802820:	48 b8 72 24 80 00 00 	movabs $0x802472,%rax
  802827:	00 00 00 
  80282a:	ff d0                	callq  *%rax
  80282c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802830:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802834:	48 89 c7             	mov    %rax,%rdi
  802837:	48 b8 72 24 80 00 00 	movabs $0x802472,%rax
  80283e:	00 00 00 
  802841:	ff d0                	callq  *%rax
  802843:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802847:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80284b:	48 c1 e8 15          	shr    $0x15,%rax
  80284f:	48 89 c2             	mov    %rax,%rdx
  802852:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802859:	01 00 00 
  80285c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802860:	83 e0 01             	and    $0x1,%eax
  802863:	48 85 c0             	test   %rax,%rax
  802866:	74 73                	je     8028db <dup+0x11d>
  802868:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80286c:	48 c1 e8 0c          	shr    $0xc,%rax
  802870:	48 89 c2             	mov    %rax,%rdx
  802873:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80287a:	01 00 00 
  80287d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802881:	83 e0 01             	and    $0x1,%eax
  802884:	48 85 c0             	test   %rax,%rax
  802887:	74 52                	je     8028db <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802889:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80288d:	48 c1 e8 0c          	shr    $0xc,%rax
  802891:	48 89 c2             	mov    %rax,%rdx
  802894:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80289b:	01 00 00 
  80289e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028a2:	25 07 0e 00 00       	and    $0xe07,%eax
  8028a7:	89 c1                	mov    %eax,%ecx
  8028a9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8028ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028b1:	41 89 c8             	mov    %ecx,%r8d
  8028b4:	48 89 d1             	mov    %rdx,%rcx
  8028b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8028bc:	48 89 c6             	mov    %rax,%rsi
  8028bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8028c4:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  8028cb:	00 00 00 
  8028ce:	ff d0                	callq  *%rax
  8028d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d7:	79 02                	jns    8028db <dup+0x11d>
			goto err;
  8028d9:	eb 57                	jmp    802932 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8028db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028df:	48 c1 e8 0c          	shr    $0xc,%rax
  8028e3:	48 89 c2             	mov    %rax,%rdx
  8028e6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028ed:	01 00 00 
  8028f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028f4:	25 07 0e 00 00       	and    $0xe07,%eax
  8028f9:	89 c1                	mov    %eax,%ecx
  8028fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802903:	41 89 c8             	mov    %ecx,%r8d
  802906:	48 89 d1             	mov    %rdx,%rcx
  802909:	ba 00 00 00 00       	mov    $0x0,%edx
  80290e:	48 89 c6             	mov    %rax,%rsi
  802911:	bf 00 00 00 00       	mov    $0x0,%edi
  802916:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  80291d:	00 00 00 
  802920:	ff d0                	callq  *%rax
  802922:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802925:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802929:	79 02                	jns    80292d <dup+0x16f>
		goto err;
  80292b:	eb 05                	jmp    802932 <dup+0x174>

	return newfdnum;
  80292d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802930:	eb 33                	jmp    802965 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802932:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802936:	48 89 c6             	mov    %rax,%rsi
  802939:	bf 00 00 00 00       	mov    $0x0,%edi
  80293e:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  802945:	00 00 00 
  802948:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80294a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80294e:	48 89 c6             	mov    %rax,%rsi
  802951:	bf 00 00 00 00       	mov    $0x0,%edi
  802956:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  80295d:	00 00 00 
  802960:	ff d0                	callq  *%rax
	return r;
  802962:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802965:	c9                   	leaveq 
  802966:	c3                   	retq   

0000000000802967 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802967:	55                   	push   %rbp
  802968:	48 89 e5             	mov    %rsp,%rbp
  80296b:	48 83 ec 40          	sub    $0x40,%rsp
  80296f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802972:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802976:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80297a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80297e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802981:	48 89 d6             	mov    %rdx,%rsi
  802984:	89 c7                	mov    %eax,%edi
  802986:	48 b8 35 25 80 00 00 	movabs $0x802535,%rax
  80298d:	00 00 00 
  802990:	ff d0                	callq  *%rax
  802992:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802995:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802999:	78 24                	js     8029bf <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80299b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80299f:	8b 00                	mov    (%rax),%eax
  8029a1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029a5:	48 89 d6             	mov    %rdx,%rsi
  8029a8:	89 c7                	mov    %eax,%edi
  8029aa:	48 b8 8e 26 80 00 00 	movabs $0x80268e,%rax
  8029b1:	00 00 00 
  8029b4:	ff d0                	callq  *%rax
  8029b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029bd:	79 05                	jns    8029c4 <read+0x5d>
		return r;
  8029bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c2:	eb 76                	jmp    802a3a <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8029c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c8:	8b 40 08             	mov    0x8(%rax),%eax
  8029cb:	83 e0 03             	and    $0x3,%eax
  8029ce:	83 f8 01             	cmp    $0x1,%eax
  8029d1:	75 3a                	jne    802a0d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8029d3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8029da:	00 00 00 
  8029dd:	48 8b 00             	mov    (%rax),%rax
  8029e0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029e6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029e9:	89 c6                	mov    %eax,%esi
  8029eb:	48 bf 97 44 80 00 00 	movabs $0x804497,%rdi
  8029f2:	00 00 00 
  8029f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8029fa:	48 b9 7a 04 80 00 00 	movabs $0x80047a,%rcx
  802a01:	00 00 00 
  802a04:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a06:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a0b:	eb 2d                	jmp    802a3a <read+0xd3>
	}
	if (!dev->dev_read)
  802a0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a11:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a15:	48 85 c0             	test   %rax,%rax
  802a18:	75 07                	jne    802a21 <read+0xba>
		return -E_NOT_SUPP;
  802a1a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a1f:	eb 19                	jmp    802a3a <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802a21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a25:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a29:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a2d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a31:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a35:	48 89 cf             	mov    %rcx,%rdi
  802a38:	ff d0                	callq  *%rax
}
  802a3a:	c9                   	leaveq 
  802a3b:	c3                   	retq   

0000000000802a3c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802a3c:	55                   	push   %rbp
  802a3d:	48 89 e5             	mov    %rsp,%rbp
  802a40:	48 83 ec 30          	sub    $0x30,%rsp
  802a44:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a47:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a4b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a56:	eb 49                	jmp    802aa1 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802a58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a5b:	48 98                	cltq   
  802a5d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a61:	48 29 c2             	sub    %rax,%rdx
  802a64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a67:	48 63 c8             	movslq %eax,%rcx
  802a6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a6e:	48 01 c1             	add    %rax,%rcx
  802a71:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a74:	48 89 ce             	mov    %rcx,%rsi
  802a77:	89 c7                	mov    %eax,%edi
  802a79:	48 b8 67 29 80 00 00 	movabs $0x802967,%rax
  802a80:	00 00 00 
  802a83:	ff d0                	callq  *%rax
  802a85:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802a88:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a8c:	79 05                	jns    802a93 <readn+0x57>
			return m;
  802a8e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a91:	eb 1c                	jmp    802aaf <readn+0x73>
		if (m == 0)
  802a93:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a97:	75 02                	jne    802a9b <readn+0x5f>
			break;
  802a99:	eb 11                	jmp    802aac <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a9b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a9e:	01 45 fc             	add    %eax,-0x4(%rbp)
  802aa1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aa4:	48 98                	cltq   
  802aa6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802aaa:	72 ac                	jb     802a58 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802aac:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802aaf:	c9                   	leaveq 
  802ab0:	c3                   	retq   

0000000000802ab1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802ab1:	55                   	push   %rbp
  802ab2:	48 89 e5             	mov    %rsp,%rbp
  802ab5:	48 83 ec 40          	sub    $0x40,%rsp
  802ab9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802abc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ac0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ac4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ac8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802acb:	48 89 d6             	mov    %rdx,%rsi
  802ace:	89 c7                	mov    %eax,%edi
  802ad0:	48 b8 35 25 80 00 00 	movabs $0x802535,%rax
  802ad7:	00 00 00 
  802ada:	ff d0                	callq  *%rax
  802adc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802adf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ae3:	78 24                	js     802b09 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ae5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae9:	8b 00                	mov    (%rax),%eax
  802aeb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802aef:	48 89 d6             	mov    %rdx,%rsi
  802af2:	89 c7                	mov    %eax,%edi
  802af4:	48 b8 8e 26 80 00 00 	movabs $0x80268e,%rax
  802afb:	00 00 00 
  802afe:	ff d0                	callq  *%rax
  802b00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b07:	79 05                	jns    802b0e <write+0x5d>
		return r;
  802b09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b0c:	eb 75                	jmp    802b83 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b12:	8b 40 08             	mov    0x8(%rax),%eax
  802b15:	83 e0 03             	and    $0x3,%eax
  802b18:	85 c0                	test   %eax,%eax
  802b1a:	75 3a                	jne    802b56 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802b1c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b23:	00 00 00 
  802b26:	48 8b 00             	mov    (%rax),%rax
  802b29:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b2f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b32:	89 c6                	mov    %eax,%esi
  802b34:	48 bf b3 44 80 00 00 	movabs $0x8044b3,%rdi
  802b3b:	00 00 00 
  802b3e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b43:	48 b9 7a 04 80 00 00 	movabs $0x80047a,%rcx
  802b4a:	00 00 00 
  802b4d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b4f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b54:	eb 2d                	jmp    802b83 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802b56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b5a:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b5e:	48 85 c0             	test   %rax,%rax
  802b61:	75 07                	jne    802b6a <write+0xb9>
		return -E_NOT_SUPP;
  802b63:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b68:	eb 19                	jmp    802b83 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802b6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b6e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b72:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b76:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b7a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b7e:	48 89 cf             	mov    %rcx,%rdi
  802b81:	ff d0                	callq  *%rax
}
  802b83:	c9                   	leaveq 
  802b84:	c3                   	retq   

0000000000802b85 <seek>:

int
seek(int fdnum, off_t offset)
{
  802b85:	55                   	push   %rbp
  802b86:	48 89 e5             	mov    %rsp,%rbp
  802b89:	48 83 ec 18          	sub    $0x18,%rsp
  802b8d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b90:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b93:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b97:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b9a:	48 89 d6             	mov    %rdx,%rsi
  802b9d:	89 c7                	mov    %eax,%edi
  802b9f:	48 b8 35 25 80 00 00 	movabs $0x802535,%rax
  802ba6:	00 00 00 
  802ba9:	ff d0                	callq  *%rax
  802bab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb2:	79 05                	jns    802bb9 <seek+0x34>
		return r;
  802bb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb7:	eb 0f                	jmp    802bc8 <seek+0x43>
	fd->fd_offset = offset;
  802bb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bbd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802bc0:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802bc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bc8:	c9                   	leaveq 
  802bc9:	c3                   	retq   

0000000000802bca <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802bca:	55                   	push   %rbp
  802bcb:	48 89 e5             	mov    %rsp,%rbp
  802bce:	48 83 ec 30          	sub    $0x30,%rsp
  802bd2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bd5:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bd8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bdc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bdf:	48 89 d6             	mov    %rdx,%rsi
  802be2:	89 c7                	mov    %eax,%edi
  802be4:	48 b8 35 25 80 00 00 	movabs $0x802535,%rax
  802beb:	00 00 00 
  802bee:	ff d0                	callq  *%rax
  802bf0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bf3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bf7:	78 24                	js     802c1d <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bf9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bfd:	8b 00                	mov    (%rax),%eax
  802bff:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c03:	48 89 d6             	mov    %rdx,%rsi
  802c06:	89 c7                	mov    %eax,%edi
  802c08:	48 b8 8e 26 80 00 00 	movabs $0x80268e,%rax
  802c0f:	00 00 00 
  802c12:	ff d0                	callq  *%rax
  802c14:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c1b:	79 05                	jns    802c22 <ftruncate+0x58>
		return r;
  802c1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c20:	eb 72                	jmp    802c94 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c26:	8b 40 08             	mov    0x8(%rax),%eax
  802c29:	83 e0 03             	and    $0x3,%eax
  802c2c:	85 c0                	test   %eax,%eax
  802c2e:	75 3a                	jne    802c6a <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802c30:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802c37:	00 00 00 
  802c3a:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c3d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c43:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c46:	89 c6                	mov    %eax,%esi
  802c48:	48 bf d0 44 80 00 00 	movabs $0x8044d0,%rdi
  802c4f:	00 00 00 
  802c52:	b8 00 00 00 00       	mov    $0x0,%eax
  802c57:	48 b9 7a 04 80 00 00 	movabs $0x80047a,%rcx
  802c5e:	00 00 00 
  802c61:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802c63:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c68:	eb 2a                	jmp    802c94 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802c6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c6e:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c72:	48 85 c0             	test   %rax,%rax
  802c75:	75 07                	jne    802c7e <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802c77:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c7c:	eb 16                	jmp    802c94 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802c7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c82:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c86:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c8a:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802c8d:	89 ce                	mov    %ecx,%esi
  802c8f:	48 89 d7             	mov    %rdx,%rdi
  802c92:	ff d0                	callq  *%rax
}
  802c94:	c9                   	leaveq 
  802c95:	c3                   	retq   

0000000000802c96 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802c96:	55                   	push   %rbp
  802c97:	48 89 e5             	mov    %rsp,%rbp
  802c9a:	48 83 ec 30          	sub    $0x30,%rsp
  802c9e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ca1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ca5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ca9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cac:	48 89 d6             	mov    %rdx,%rsi
  802caf:	89 c7                	mov    %eax,%edi
  802cb1:	48 b8 35 25 80 00 00 	movabs $0x802535,%rax
  802cb8:	00 00 00 
  802cbb:	ff d0                	callq  *%rax
  802cbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cc4:	78 24                	js     802cea <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802cc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cca:	8b 00                	mov    (%rax),%eax
  802ccc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cd0:	48 89 d6             	mov    %rdx,%rsi
  802cd3:	89 c7                	mov    %eax,%edi
  802cd5:	48 b8 8e 26 80 00 00 	movabs $0x80268e,%rax
  802cdc:	00 00 00 
  802cdf:	ff d0                	callq  *%rax
  802ce1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ce4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ce8:	79 05                	jns    802cef <fstat+0x59>
		return r;
  802cea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ced:	eb 5e                	jmp    802d4d <fstat+0xb7>
	if (!dev->dev_stat)
  802cef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cf3:	48 8b 40 28          	mov    0x28(%rax),%rax
  802cf7:	48 85 c0             	test   %rax,%rax
  802cfa:	75 07                	jne    802d03 <fstat+0x6d>
		return -E_NOT_SUPP;
  802cfc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d01:	eb 4a                	jmp    802d4d <fstat+0xb7>
	stat->st_name[0] = 0;
  802d03:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d07:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802d0a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d0e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802d15:	00 00 00 
	stat->st_isdir = 0;
  802d18:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d1c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d23:	00 00 00 
	stat->st_dev = dev;
  802d26:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d2a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d2e:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802d35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d39:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d3d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d41:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d45:	48 89 ce             	mov    %rcx,%rsi
  802d48:	48 89 d7             	mov    %rdx,%rdi
  802d4b:	ff d0                	callq  *%rax
}
  802d4d:	c9                   	leaveq 
  802d4e:	c3                   	retq   

0000000000802d4f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802d4f:	55                   	push   %rbp
  802d50:	48 89 e5             	mov    %rsp,%rbp
  802d53:	48 83 ec 20          	sub    $0x20,%rsp
  802d57:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d5b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802d5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d63:	be 00 00 00 00       	mov    $0x0,%esi
  802d68:	48 89 c7             	mov    %rax,%rdi
  802d6b:	48 b8 3d 2e 80 00 00 	movabs $0x802e3d,%rax
  802d72:	00 00 00 
  802d75:	ff d0                	callq  *%rax
  802d77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d7e:	79 05                	jns    802d85 <stat+0x36>
		return fd;
  802d80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d83:	eb 2f                	jmp    802db4 <stat+0x65>
	r = fstat(fd, stat);
  802d85:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d8c:	48 89 d6             	mov    %rdx,%rsi
  802d8f:	89 c7                	mov    %eax,%edi
  802d91:	48 b8 96 2c 80 00 00 	movabs $0x802c96,%rax
  802d98:	00 00 00 
  802d9b:	ff d0                	callq  *%rax
  802d9d:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802da0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da3:	89 c7                	mov    %eax,%edi
  802da5:	48 b8 45 27 80 00 00 	movabs $0x802745,%rax
  802dac:	00 00 00 
  802daf:	ff d0                	callq  *%rax
	return r;
  802db1:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802db4:	c9                   	leaveq 
  802db5:	c3                   	retq   

0000000000802db6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802db6:	55                   	push   %rbp
  802db7:	48 89 e5             	mov    %rsp,%rbp
  802dba:	48 83 ec 10          	sub    $0x10,%rsp
  802dbe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802dc1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802dc5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802dcc:	00 00 00 
  802dcf:	8b 00                	mov    (%rax),%eax
  802dd1:	85 c0                	test   %eax,%eax
  802dd3:	75 1d                	jne    802df2 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802dd5:	bf 01 00 00 00       	mov    $0x1,%edi
  802dda:	48 b8 cd 23 80 00 00 	movabs $0x8023cd,%rax
  802de1:	00 00 00 
  802de4:	ff d0                	callq  *%rax
  802de6:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802ded:	00 00 00 
  802df0:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802df2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802df9:	00 00 00 
  802dfc:	8b 00                	mov    (%rax),%eax
  802dfe:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e01:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e06:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802e0d:	00 00 00 
  802e10:	89 c7                	mov    %eax,%edi
  802e12:	48 b8 6b 23 80 00 00 	movabs $0x80236b,%rax
  802e19:	00 00 00 
  802e1c:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802e1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e22:	ba 00 00 00 00       	mov    $0x0,%edx
  802e27:	48 89 c6             	mov    %rax,%rsi
  802e2a:	bf 00 00 00 00       	mov    $0x0,%edi
  802e2f:	48 b8 65 22 80 00 00 	movabs $0x802265,%rax
  802e36:	00 00 00 
  802e39:	ff d0                	callq  *%rax
}
  802e3b:	c9                   	leaveq 
  802e3c:	c3                   	retq   

0000000000802e3d <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802e3d:	55                   	push   %rbp
  802e3e:	48 89 e5             	mov    %rsp,%rbp
  802e41:	48 83 ec 30          	sub    $0x30,%rsp
  802e45:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e49:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802e4c:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802e53:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802e5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802e61:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802e66:	75 08                	jne    802e70 <open+0x33>
	{
		return r;
  802e68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e6b:	e9 f2 00 00 00       	jmpq   802f62 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802e70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e74:	48 89 c7             	mov    %rax,%rdi
  802e77:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  802e7e:	00 00 00 
  802e81:	ff d0                	callq  *%rax
  802e83:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802e86:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802e8d:	7e 0a                	jle    802e99 <open+0x5c>
	{
		return -E_BAD_PATH;
  802e8f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e94:	e9 c9 00 00 00       	jmpq   802f62 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802e99:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802ea0:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802ea1:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802ea5:	48 89 c7             	mov    %rax,%rdi
  802ea8:	48 b8 9d 24 80 00 00 	movabs $0x80249d,%rax
  802eaf:	00 00 00 
  802eb2:	ff d0                	callq  *%rax
  802eb4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eb7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ebb:	78 09                	js     802ec6 <open+0x89>
  802ebd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec1:	48 85 c0             	test   %rax,%rax
  802ec4:	75 08                	jne    802ece <open+0x91>
		{
			return r;
  802ec6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec9:	e9 94 00 00 00       	jmpq   802f62 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802ece:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ed2:	ba 00 04 00 00       	mov    $0x400,%edx
  802ed7:	48 89 c6             	mov    %rax,%rsi
  802eda:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802ee1:	00 00 00 
  802ee4:	48 b8 c1 10 80 00 00 	movabs $0x8010c1,%rax
  802eeb:	00 00 00 
  802eee:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802ef0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ef7:	00 00 00 
  802efa:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802efd:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802f03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f07:	48 89 c6             	mov    %rax,%rsi
  802f0a:	bf 01 00 00 00       	mov    $0x1,%edi
  802f0f:	48 b8 b6 2d 80 00 00 	movabs $0x802db6,%rax
  802f16:	00 00 00 
  802f19:	ff d0                	callq  *%rax
  802f1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f22:	79 2b                	jns    802f4f <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802f24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f28:	be 00 00 00 00       	mov    $0x0,%esi
  802f2d:	48 89 c7             	mov    %rax,%rdi
  802f30:	48 b8 c5 25 80 00 00 	movabs $0x8025c5,%rax
  802f37:	00 00 00 
  802f3a:	ff d0                	callq  *%rax
  802f3c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802f3f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f43:	79 05                	jns    802f4a <open+0x10d>
			{
				return d;
  802f45:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f48:	eb 18                	jmp    802f62 <open+0x125>
			}
			return r;
  802f4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f4d:	eb 13                	jmp    802f62 <open+0x125>
		}	
		return fd2num(fd_store);
  802f4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f53:	48 89 c7             	mov    %rax,%rdi
  802f56:	48 b8 4f 24 80 00 00 	movabs $0x80244f,%rax
  802f5d:	00 00 00 
  802f60:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802f62:	c9                   	leaveq 
  802f63:	c3                   	retq   

0000000000802f64 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802f64:	55                   	push   %rbp
  802f65:	48 89 e5             	mov    %rsp,%rbp
  802f68:	48 83 ec 10          	sub    $0x10,%rsp
  802f6c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f74:	8b 50 0c             	mov    0xc(%rax),%edx
  802f77:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f7e:	00 00 00 
  802f81:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802f83:	be 00 00 00 00       	mov    $0x0,%esi
  802f88:	bf 06 00 00 00       	mov    $0x6,%edi
  802f8d:	48 b8 b6 2d 80 00 00 	movabs $0x802db6,%rax
  802f94:	00 00 00 
  802f97:	ff d0                	callq  *%rax
}
  802f99:	c9                   	leaveq 
  802f9a:	c3                   	retq   

0000000000802f9b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802f9b:	55                   	push   %rbp
  802f9c:	48 89 e5             	mov    %rsp,%rbp
  802f9f:	48 83 ec 30          	sub    $0x30,%rsp
  802fa3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fa7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802faf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802fb6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802fbb:	74 07                	je     802fc4 <devfile_read+0x29>
  802fbd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802fc2:	75 07                	jne    802fcb <devfile_read+0x30>
		return -E_INVAL;
  802fc4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fc9:	eb 77                	jmp    803042 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802fcb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fcf:	8b 50 0c             	mov    0xc(%rax),%edx
  802fd2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fd9:	00 00 00 
  802fdc:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802fde:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fe5:	00 00 00 
  802fe8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fec:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802ff0:	be 00 00 00 00       	mov    $0x0,%esi
  802ff5:	bf 03 00 00 00       	mov    $0x3,%edi
  802ffa:	48 b8 b6 2d 80 00 00 	movabs $0x802db6,%rax
  803001:	00 00 00 
  803004:	ff d0                	callq  *%rax
  803006:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803009:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80300d:	7f 05                	jg     803014 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80300f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803012:	eb 2e                	jmp    803042 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  803014:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803017:	48 63 d0             	movslq %eax,%rdx
  80301a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80301e:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803025:	00 00 00 
  803028:	48 89 c7             	mov    %rax,%rdi
  80302b:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  803032:	00 00 00 
  803035:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803037:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80303b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80303f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803042:	c9                   	leaveq 
  803043:	c3                   	retq   

0000000000803044 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803044:	55                   	push   %rbp
  803045:	48 89 e5             	mov    %rsp,%rbp
  803048:	48 83 ec 30          	sub    $0x30,%rsp
  80304c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803050:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803054:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  803058:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80305f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803064:	74 07                	je     80306d <devfile_write+0x29>
  803066:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80306b:	75 08                	jne    803075 <devfile_write+0x31>
		return r;
  80306d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803070:	e9 9a 00 00 00       	jmpq   80310f <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803075:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803079:	8b 50 0c             	mov    0xc(%rax),%edx
  80307c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803083:	00 00 00 
  803086:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  803088:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80308f:	00 
  803090:	76 08                	jbe    80309a <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  803092:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803099:	00 
	}
	fsipcbuf.write.req_n = n;
  80309a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030a1:	00 00 00 
  8030a4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030a8:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8030ac:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030b4:	48 89 c6             	mov    %rax,%rsi
  8030b7:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8030be:	00 00 00 
  8030c1:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  8030c8:	00 00 00 
  8030cb:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8030cd:	be 00 00 00 00       	mov    $0x0,%esi
  8030d2:	bf 04 00 00 00       	mov    $0x4,%edi
  8030d7:	48 b8 b6 2d 80 00 00 	movabs $0x802db6,%rax
  8030de:	00 00 00 
  8030e1:	ff d0                	callq  *%rax
  8030e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ea:	7f 20                	jg     80310c <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8030ec:	48 bf f6 44 80 00 00 	movabs $0x8044f6,%rdi
  8030f3:	00 00 00 
  8030f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8030fb:	48 ba 7a 04 80 00 00 	movabs $0x80047a,%rdx
  803102:	00 00 00 
  803105:	ff d2                	callq  *%rdx
		return r;
  803107:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80310a:	eb 03                	jmp    80310f <devfile_write+0xcb>
	}
	return r;
  80310c:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80310f:	c9                   	leaveq 
  803110:	c3                   	retq   

0000000000803111 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803111:	55                   	push   %rbp
  803112:	48 89 e5             	mov    %rsp,%rbp
  803115:	48 83 ec 20          	sub    $0x20,%rsp
  803119:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80311d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803121:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803125:	8b 50 0c             	mov    0xc(%rax),%edx
  803128:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80312f:	00 00 00 
  803132:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803134:	be 00 00 00 00       	mov    $0x0,%esi
  803139:	bf 05 00 00 00       	mov    $0x5,%edi
  80313e:	48 b8 b6 2d 80 00 00 	movabs $0x802db6,%rax
  803145:	00 00 00 
  803148:	ff d0                	callq  *%rax
  80314a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80314d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803151:	79 05                	jns    803158 <devfile_stat+0x47>
		return r;
  803153:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803156:	eb 56                	jmp    8031ae <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803158:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80315c:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803163:	00 00 00 
  803166:	48 89 c7             	mov    %rax,%rdi
  803169:	48 b8 2f 10 80 00 00 	movabs $0x80102f,%rax
  803170:	00 00 00 
  803173:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803175:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80317c:	00 00 00 
  80317f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803185:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803189:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80318f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803196:	00 00 00 
  803199:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80319f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031a3:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8031a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031ae:	c9                   	leaveq 
  8031af:	c3                   	retq   

00000000008031b0 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8031b0:	55                   	push   %rbp
  8031b1:	48 89 e5             	mov    %rsp,%rbp
  8031b4:	48 83 ec 10          	sub    $0x10,%rsp
  8031b8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031bc:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8031bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031c3:	8b 50 0c             	mov    0xc(%rax),%edx
  8031c6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031cd:	00 00 00 
  8031d0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8031d2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031d9:	00 00 00 
  8031dc:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8031df:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8031e2:	be 00 00 00 00       	mov    $0x0,%esi
  8031e7:	bf 02 00 00 00       	mov    $0x2,%edi
  8031ec:	48 b8 b6 2d 80 00 00 	movabs $0x802db6,%rax
  8031f3:	00 00 00 
  8031f6:	ff d0                	callq  *%rax
}
  8031f8:	c9                   	leaveq 
  8031f9:	c3                   	retq   

00000000008031fa <remove>:

// Delete a file
int
remove(const char *path)
{
  8031fa:	55                   	push   %rbp
  8031fb:	48 89 e5             	mov    %rsp,%rbp
  8031fe:	48 83 ec 10          	sub    $0x10,%rsp
  803202:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803206:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80320a:	48 89 c7             	mov    %rax,%rdi
  80320d:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  803214:	00 00 00 
  803217:	ff d0                	callq  *%rax
  803219:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80321e:	7e 07                	jle    803227 <remove+0x2d>
		return -E_BAD_PATH;
  803220:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803225:	eb 33                	jmp    80325a <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803227:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80322b:	48 89 c6             	mov    %rax,%rsi
  80322e:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803235:	00 00 00 
  803238:	48 b8 2f 10 80 00 00 	movabs $0x80102f,%rax
  80323f:	00 00 00 
  803242:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803244:	be 00 00 00 00       	mov    $0x0,%esi
  803249:	bf 07 00 00 00       	mov    $0x7,%edi
  80324e:	48 b8 b6 2d 80 00 00 	movabs $0x802db6,%rax
  803255:	00 00 00 
  803258:	ff d0                	callq  *%rax
}
  80325a:	c9                   	leaveq 
  80325b:	c3                   	retq   

000000000080325c <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80325c:	55                   	push   %rbp
  80325d:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803260:	be 00 00 00 00       	mov    $0x0,%esi
  803265:	bf 08 00 00 00       	mov    $0x8,%edi
  80326a:	48 b8 b6 2d 80 00 00 	movabs $0x802db6,%rax
  803271:	00 00 00 
  803274:	ff d0                	callq  *%rax
}
  803276:	5d                   	pop    %rbp
  803277:	c3                   	retq   

0000000000803278 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803278:	55                   	push   %rbp
  803279:	48 89 e5             	mov    %rsp,%rbp
  80327c:	53                   	push   %rbx
  80327d:	48 83 ec 38          	sub    $0x38,%rsp
  803281:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803285:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803289:	48 89 c7             	mov    %rax,%rdi
  80328c:	48 b8 9d 24 80 00 00 	movabs $0x80249d,%rax
  803293:	00 00 00 
  803296:	ff d0                	callq  *%rax
  803298:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80329b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80329f:	0f 88 bf 01 00 00    	js     803464 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032a9:	ba 07 04 00 00       	mov    $0x407,%edx
  8032ae:	48 89 c6             	mov    %rax,%rsi
  8032b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8032b6:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  8032bd:	00 00 00 
  8032c0:	ff d0                	callq  *%rax
  8032c2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032c9:	0f 88 95 01 00 00    	js     803464 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8032cf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8032d3:	48 89 c7             	mov    %rax,%rdi
  8032d6:	48 b8 9d 24 80 00 00 	movabs $0x80249d,%rax
  8032dd:	00 00 00 
  8032e0:	ff d0                	callq  *%rax
  8032e2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032e9:	0f 88 5d 01 00 00    	js     80344c <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032f3:	ba 07 04 00 00       	mov    $0x407,%edx
  8032f8:	48 89 c6             	mov    %rax,%rsi
  8032fb:	bf 00 00 00 00       	mov    $0x0,%edi
  803300:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  803307:	00 00 00 
  80330a:	ff d0                	callq  *%rax
  80330c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80330f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803313:	0f 88 33 01 00 00    	js     80344c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803319:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80331d:	48 89 c7             	mov    %rax,%rdi
  803320:	48 b8 72 24 80 00 00 	movabs $0x802472,%rax
  803327:	00 00 00 
  80332a:	ff d0                	callq  *%rax
  80332c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803330:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803334:	ba 07 04 00 00       	mov    $0x407,%edx
  803339:	48 89 c6             	mov    %rax,%rsi
  80333c:	bf 00 00 00 00       	mov    $0x0,%edi
  803341:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  803348:	00 00 00 
  80334b:	ff d0                	callq  *%rax
  80334d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803350:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803354:	79 05                	jns    80335b <pipe+0xe3>
		goto err2;
  803356:	e9 d9 00 00 00       	jmpq   803434 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80335b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80335f:	48 89 c7             	mov    %rax,%rdi
  803362:	48 b8 72 24 80 00 00 	movabs $0x802472,%rax
  803369:	00 00 00 
  80336c:	ff d0                	callq  *%rax
  80336e:	48 89 c2             	mov    %rax,%rdx
  803371:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803375:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80337b:	48 89 d1             	mov    %rdx,%rcx
  80337e:	ba 00 00 00 00       	mov    $0x0,%edx
  803383:	48 89 c6             	mov    %rax,%rsi
  803386:	bf 00 00 00 00       	mov    $0x0,%edi
  80338b:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  803392:	00 00 00 
  803395:	ff d0                	callq  *%rax
  803397:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80339a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80339e:	79 1b                	jns    8033bb <pipe+0x143>
		goto err3;
  8033a0:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8033a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033a5:	48 89 c6             	mov    %rax,%rsi
  8033a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8033ad:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  8033b4:	00 00 00 
  8033b7:	ff d0                	callq  *%rax
  8033b9:	eb 79                	jmp    803434 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8033bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033bf:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8033c6:	00 00 00 
  8033c9:	8b 12                	mov    (%rdx),%edx
  8033cb:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8033cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033d1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8033d8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033dc:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8033e3:	00 00 00 
  8033e6:	8b 12                	mov    (%rdx),%edx
  8033e8:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8033ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ee:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8033f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033f9:	48 89 c7             	mov    %rax,%rdi
  8033fc:	48 b8 4f 24 80 00 00 	movabs $0x80244f,%rax
  803403:	00 00 00 
  803406:	ff d0                	callq  *%rax
  803408:	89 c2                	mov    %eax,%edx
  80340a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80340e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803410:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803414:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803418:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80341c:	48 89 c7             	mov    %rax,%rdi
  80341f:	48 b8 4f 24 80 00 00 	movabs $0x80244f,%rax
  803426:	00 00 00 
  803429:	ff d0                	callq  *%rax
  80342b:	89 03                	mov    %eax,(%rbx)
	return 0;
  80342d:	b8 00 00 00 00       	mov    $0x0,%eax
  803432:	eb 33                	jmp    803467 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803434:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803438:	48 89 c6             	mov    %rax,%rsi
  80343b:	bf 00 00 00 00       	mov    $0x0,%edi
  803440:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  803447:	00 00 00 
  80344a:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  80344c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803450:	48 89 c6             	mov    %rax,%rsi
  803453:	bf 00 00 00 00       	mov    $0x0,%edi
  803458:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  80345f:	00 00 00 
  803462:	ff d0                	callq  *%rax
    err:
	return r;
  803464:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803467:	48 83 c4 38          	add    $0x38,%rsp
  80346b:	5b                   	pop    %rbx
  80346c:	5d                   	pop    %rbp
  80346d:	c3                   	retq   

000000000080346e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80346e:	55                   	push   %rbp
  80346f:	48 89 e5             	mov    %rsp,%rbp
  803472:	53                   	push   %rbx
  803473:	48 83 ec 28          	sub    $0x28,%rsp
  803477:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80347b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80347f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803486:	00 00 00 
  803489:	48 8b 00             	mov    (%rax),%rax
  80348c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803492:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803495:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803499:	48 89 c7             	mov    %rax,%rdi
  80349c:	48 b8 48 3d 80 00 00 	movabs $0x803d48,%rax
  8034a3:	00 00 00 
  8034a6:	ff d0                	callq  *%rax
  8034a8:	89 c3                	mov    %eax,%ebx
  8034aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034ae:	48 89 c7             	mov    %rax,%rdi
  8034b1:	48 b8 48 3d 80 00 00 	movabs $0x803d48,%rax
  8034b8:	00 00 00 
  8034bb:	ff d0                	callq  *%rax
  8034bd:	39 c3                	cmp    %eax,%ebx
  8034bf:	0f 94 c0             	sete   %al
  8034c2:	0f b6 c0             	movzbl %al,%eax
  8034c5:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8034c8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034cf:	00 00 00 
  8034d2:	48 8b 00             	mov    (%rax),%rax
  8034d5:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8034db:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8034de:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034e1:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034e4:	75 05                	jne    8034eb <_pipeisclosed+0x7d>
			return ret;
  8034e6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034e9:	eb 4f                	jmp    80353a <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8034eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034ee:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034f1:	74 42                	je     803535 <_pipeisclosed+0xc7>
  8034f3:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8034f7:	75 3c                	jne    803535 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8034f9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803500:	00 00 00 
  803503:	48 8b 00             	mov    (%rax),%rax
  803506:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80350c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80350f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803512:	89 c6                	mov    %eax,%esi
  803514:	48 bf 17 45 80 00 00 	movabs $0x804517,%rdi
  80351b:	00 00 00 
  80351e:	b8 00 00 00 00       	mov    $0x0,%eax
  803523:	49 b8 7a 04 80 00 00 	movabs $0x80047a,%r8
  80352a:	00 00 00 
  80352d:	41 ff d0             	callq  *%r8
	}
  803530:	e9 4a ff ff ff       	jmpq   80347f <_pipeisclosed+0x11>
  803535:	e9 45 ff ff ff       	jmpq   80347f <_pipeisclosed+0x11>
}
  80353a:	48 83 c4 28          	add    $0x28,%rsp
  80353e:	5b                   	pop    %rbx
  80353f:	5d                   	pop    %rbp
  803540:	c3                   	retq   

0000000000803541 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803541:	55                   	push   %rbp
  803542:	48 89 e5             	mov    %rsp,%rbp
  803545:	48 83 ec 30          	sub    $0x30,%rsp
  803549:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80354c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803550:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803553:	48 89 d6             	mov    %rdx,%rsi
  803556:	89 c7                	mov    %eax,%edi
  803558:	48 b8 35 25 80 00 00 	movabs $0x802535,%rax
  80355f:	00 00 00 
  803562:	ff d0                	callq  *%rax
  803564:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803567:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80356b:	79 05                	jns    803572 <pipeisclosed+0x31>
		return r;
  80356d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803570:	eb 31                	jmp    8035a3 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803572:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803576:	48 89 c7             	mov    %rax,%rdi
  803579:	48 b8 72 24 80 00 00 	movabs $0x802472,%rax
  803580:	00 00 00 
  803583:	ff d0                	callq  *%rax
  803585:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803589:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80358d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803591:	48 89 d6             	mov    %rdx,%rsi
  803594:	48 89 c7             	mov    %rax,%rdi
  803597:	48 b8 6e 34 80 00 00 	movabs $0x80346e,%rax
  80359e:	00 00 00 
  8035a1:	ff d0                	callq  *%rax
}
  8035a3:	c9                   	leaveq 
  8035a4:	c3                   	retq   

00000000008035a5 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8035a5:	55                   	push   %rbp
  8035a6:	48 89 e5             	mov    %rsp,%rbp
  8035a9:	48 83 ec 40          	sub    $0x40,%rsp
  8035ad:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035b1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035b5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8035b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035bd:	48 89 c7             	mov    %rax,%rdi
  8035c0:	48 b8 72 24 80 00 00 	movabs $0x802472,%rax
  8035c7:	00 00 00 
  8035ca:	ff d0                	callq  *%rax
  8035cc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8035d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035d4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8035d8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8035df:	00 
  8035e0:	e9 92 00 00 00       	jmpq   803677 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8035e5:	eb 41                	jmp    803628 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8035e7:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8035ec:	74 09                	je     8035f7 <devpipe_read+0x52>
				return i;
  8035ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035f2:	e9 92 00 00 00       	jmpq   803689 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8035f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035ff:	48 89 d6             	mov    %rdx,%rsi
  803602:	48 89 c7             	mov    %rax,%rdi
  803605:	48 b8 6e 34 80 00 00 	movabs $0x80346e,%rax
  80360c:	00 00 00 
  80360f:	ff d0                	callq  *%rax
  803611:	85 c0                	test   %eax,%eax
  803613:	74 07                	je     80361c <devpipe_read+0x77>
				return 0;
  803615:	b8 00 00 00 00       	mov    $0x0,%eax
  80361a:	eb 6d                	jmp    803689 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80361c:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  803623:	00 00 00 
  803626:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803628:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80362c:	8b 10                	mov    (%rax),%edx
  80362e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803632:	8b 40 04             	mov    0x4(%rax),%eax
  803635:	39 c2                	cmp    %eax,%edx
  803637:	74 ae                	je     8035e7 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803639:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80363d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803641:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803645:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803649:	8b 00                	mov    (%rax),%eax
  80364b:	99                   	cltd   
  80364c:	c1 ea 1b             	shr    $0x1b,%edx
  80364f:	01 d0                	add    %edx,%eax
  803651:	83 e0 1f             	and    $0x1f,%eax
  803654:	29 d0                	sub    %edx,%eax
  803656:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80365a:	48 98                	cltq   
  80365c:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803661:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803663:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803667:	8b 00                	mov    (%rax),%eax
  803669:	8d 50 01             	lea    0x1(%rax),%edx
  80366c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803670:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803672:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803677:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80367b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80367f:	0f 82 60 ff ff ff    	jb     8035e5 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803685:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803689:	c9                   	leaveq 
  80368a:	c3                   	retq   

000000000080368b <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80368b:	55                   	push   %rbp
  80368c:	48 89 e5             	mov    %rsp,%rbp
  80368f:	48 83 ec 40          	sub    $0x40,%rsp
  803693:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803697:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80369b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80369f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036a3:	48 89 c7             	mov    %rax,%rdi
  8036a6:	48 b8 72 24 80 00 00 	movabs $0x802472,%rax
  8036ad:	00 00 00 
  8036b0:	ff d0                	callq  *%rax
  8036b2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8036b6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036ba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8036be:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8036c5:	00 
  8036c6:	e9 8e 00 00 00       	jmpq   803759 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036cb:	eb 31                	jmp    8036fe <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8036cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036d5:	48 89 d6             	mov    %rdx,%rsi
  8036d8:	48 89 c7             	mov    %rax,%rdi
  8036db:	48 b8 6e 34 80 00 00 	movabs $0x80346e,%rax
  8036e2:	00 00 00 
  8036e5:	ff d0                	callq  *%rax
  8036e7:	85 c0                	test   %eax,%eax
  8036e9:	74 07                	je     8036f2 <devpipe_write+0x67>
				return 0;
  8036eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f0:	eb 79                	jmp    80376b <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8036f2:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  8036f9:	00 00 00 
  8036fc:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803702:	8b 40 04             	mov    0x4(%rax),%eax
  803705:	48 63 d0             	movslq %eax,%rdx
  803708:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80370c:	8b 00                	mov    (%rax),%eax
  80370e:	48 98                	cltq   
  803710:	48 83 c0 20          	add    $0x20,%rax
  803714:	48 39 c2             	cmp    %rax,%rdx
  803717:	73 b4                	jae    8036cd <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803719:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80371d:	8b 40 04             	mov    0x4(%rax),%eax
  803720:	99                   	cltd   
  803721:	c1 ea 1b             	shr    $0x1b,%edx
  803724:	01 d0                	add    %edx,%eax
  803726:	83 e0 1f             	and    $0x1f,%eax
  803729:	29 d0                	sub    %edx,%eax
  80372b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80372f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803733:	48 01 ca             	add    %rcx,%rdx
  803736:	0f b6 0a             	movzbl (%rdx),%ecx
  803739:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80373d:	48 98                	cltq   
  80373f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803743:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803747:	8b 40 04             	mov    0x4(%rax),%eax
  80374a:	8d 50 01             	lea    0x1(%rax),%edx
  80374d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803751:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803754:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803759:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80375d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803761:	0f 82 64 ff ff ff    	jb     8036cb <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803767:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80376b:	c9                   	leaveq 
  80376c:	c3                   	retq   

000000000080376d <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80376d:	55                   	push   %rbp
  80376e:	48 89 e5             	mov    %rsp,%rbp
  803771:	48 83 ec 20          	sub    $0x20,%rsp
  803775:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803779:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80377d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803781:	48 89 c7             	mov    %rax,%rdi
  803784:	48 b8 72 24 80 00 00 	movabs $0x802472,%rax
  80378b:	00 00 00 
  80378e:	ff d0                	callq  *%rax
  803790:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803794:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803798:	48 be 2a 45 80 00 00 	movabs $0x80452a,%rsi
  80379f:	00 00 00 
  8037a2:	48 89 c7             	mov    %rax,%rdi
  8037a5:	48 b8 2f 10 80 00 00 	movabs $0x80102f,%rax
  8037ac:	00 00 00 
  8037af:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8037b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037b5:	8b 50 04             	mov    0x4(%rax),%edx
  8037b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037bc:	8b 00                	mov    (%rax),%eax
  8037be:	29 c2                	sub    %eax,%edx
  8037c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037c4:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8037ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037ce:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8037d5:	00 00 00 
	stat->st_dev = &devpipe;
  8037d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037dc:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  8037e3:	00 00 00 
  8037e6:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8037ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037f2:	c9                   	leaveq 
  8037f3:	c3                   	retq   

00000000008037f4 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8037f4:	55                   	push   %rbp
  8037f5:	48 89 e5             	mov    %rsp,%rbp
  8037f8:	48 83 ec 10          	sub    $0x10,%rsp
  8037fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803800:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803804:	48 89 c6             	mov    %rax,%rsi
  803807:	bf 00 00 00 00       	mov    $0x0,%edi
  80380c:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  803813:	00 00 00 
  803816:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803818:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80381c:	48 89 c7             	mov    %rax,%rdi
  80381f:	48 b8 72 24 80 00 00 	movabs $0x802472,%rax
  803826:	00 00 00 
  803829:	ff d0                	callq  *%rax
  80382b:	48 89 c6             	mov    %rax,%rsi
  80382e:	bf 00 00 00 00       	mov    $0x0,%edi
  803833:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  80383a:	00 00 00 
  80383d:	ff d0                	callq  *%rax
}
  80383f:	c9                   	leaveq 
  803840:	c3                   	retq   

0000000000803841 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803841:	55                   	push   %rbp
  803842:	48 89 e5             	mov    %rsp,%rbp
  803845:	48 83 ec 20          	sub    $0x20,%rsp
  803849:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80384c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80384f:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803852:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803856:	be 01 00 00 00       	mov    $0x1,%esi
  80385b:	48 89 c7             	mov    %rax,%rdi
  80385e:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  803865:	00 00 00 
  803868:	ff d0                	callq  *%rax
}
  80386a:	c9                   	leaveq 
  80386b:	c3                   	retq   

000000000080386c <getchar>:

int
getchar(void)
{
  80386c:	55                   	push   %rbp
  80386d:	48 89 e5             	mov    %rsp,%rbp
  803870:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803874:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803878:	ba 01 00 00 00       	mov    $0x1,%edx
  80387d:	48 89 c6             	mov    %rax,%rsi
  803880:	bf 00 00 00 00       	mov    $0x0,%edi
  803885:	48 b8 67 29 80 00 00 	movabs $0x802967,%rax
  80388c:	00 00 00 
  80388f:	ff d0                	callq  *%rax
  803891:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803894:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803898:	79 05                	jns    80389f <getchar+0x33>
		return r;
  80389a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80389d:	eb 14                	jmp    8038b3 <getchar+0x47>
	if (r < 1)
  80389f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038a3:	7f 07                	jg     8038ac <getchar+0x40>
		return -E_EOF;
  8038a5:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8038aa:	eb 07                	jmp    8038b3 <getchar+0x47>
	return c;
  8038ac:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8038b0:	0f b6 c0             	movzbl %al,%eax
}
  8038b3:	c9                   	leaveq 
  8038b4:	c3                   	retq   

00000000008038b5 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8038b5:	55                   	push   %rbp
  8038b6:	48 89 e5             	mov    %rsp,%rbp
  8038b9:	48 83 ec 20          	sub    $0x20,%rsp
  8038bd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038c0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8038c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038c7:	48 89 d6             	mov    %rdx,%rsi
  8038ca:	89 c7                	mov    %eax,%edi
  8038cc:	48 b8 35 25 80 00 00 	movabs $0x802535,%rax
  8038d3:	00 00 00 
  8038d6:	ff d0                	callq  *%rax
  8038d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038df:	79 05                	jns    8038e6 <iscons+0x31>
		return r;
  8038e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e4:	eb 1a                	jmp    803900 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8038e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ea:	8b 10                	mov    (%rax),%edx
  8038ec:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  8038f3:	00 00 00 
  8038f6:	8b 00                	mov    (%rax),%eax
  8038f8:	39 c2                	cmp    %eax,%edx
  8038fa:	0f 94 c0             	sete   %al
  8038fd:	0f b6 c0             	movzbl %al,%eax
}
  803900:	c9                   	leaveq 
  803901:	c3                   	retq   

0000000000803902 <opencons>:

int
opencons(void)
{
  803902:	55                   	push   %rbp
  803903:	48 89 e5             	mov    %rsp,%rbp
  803906:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80390a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80390e:	48 89 c7             	mov    %rax,%rdi
  803911:	48 b8 9d 24 80 00 00 	movabs $0x80249d,%rax
  803918:	00 00 00 
  80391b:	ff d0                	callq  *%rax
  80391d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803920:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803924:	79 05                	jns    80392b <opencons+0x29>
		return r;
  803926:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803929:	eb 5b                	jmp    803986 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80392b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80392f:	ba 07 04 00 00       	mov    $0x407,%edx
  803934:	48 89 c6             	mov    %rax,%rsi
  803937:	bf 00 00 00 00       	mov    $0x0,%edi
  80393c:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  803943:	00 00 00 
  803946:	ff d0                	callq  *%rax
  803948:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80394b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80394f:	79 05                	jns    803956 <opencons+0x54>
		return r;
  803951:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803954:	eb 30                	jmp    803986 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803956:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80395a:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803961:	00 00 00 
  803964:	8b 12                	mov    (%rdx),%edx
  803966:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803968:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80396c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803973:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803977:	48 89 c7             	mov    %rax,%rdi
  80397a:	48 b8 4f 24 80 00 00 	movabs $0x80244f,%rax
  803981:	00 00 00 
  803984:	ff d0                	callq  *%rax
}
  803986:	c9                   	leaveq 
  803987:	c3                   	retq   

0000000000803988 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803988:	55                   	push   %rbp
  803989:	48 89 e5             	mov    %rsp,%rbp
  80398c:	48 83 ec 30          	sub    $0x30,%rsp
  803990:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803994:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803998:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80399c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8039a1:	75 07                	jne    8039aa <devcons_read+0x22>
		return 0;
  8039a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8039a8:	eb 4b                	jmp    8039f5 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8039aa:	eb 0c                	jmp    8039b8 <devcons_read+0x30>
		sys_yield();
  8039ac:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  8039b3:	00 00 00 
  8039b6:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8039b8:	48 b8 60 18 80 00 00 	movabs $0x801860,%rax
  8039bf:	00 00 00 
  8039c2:	ff d0                	callq  *%rax
  8039c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039cb:	74 df                	je     8039ac <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8039cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039d1:	79 05                	jns    8039d8 <devcons_read+0x50>
		return c;
  8039d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039d6:	eb 1d                	jmp    8039f5 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8039d8:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8039dc:	75 07                	jne    8039e5 <devcons_read+0x5d>
		return 0;
  8039de:	b8 00 00 00 00       	mov    $0x0,%eax
  8039e3:	eb 10                	jmp    8039f5 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8039e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039e8:	89 c2                	mov    %eax,%edx
  8039ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039ee:	88 10                	mov    %dl,(%rax)
	return 1;
  8039f0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8039f5:	c9                   	leaveq 
  8039f6:	c3                   	retq   

00000000008039f7 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039f7:	55                   	push   %rbp
  8039f8:	48 89 e5             	mov    %rsp,%rbp
  8039fb:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803a02:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803a09:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803a10:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a1e:	eb 76                	jmp    803a96 <devcons_write+0x9f>
		m = n - tot;
  803a20:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803a27:	89 c2                	mov    %eax,%edx
  803a29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a2c:	29 c2                	sub    %eax,%edx
  803a2e:	89 d0                	mov    %edx,%eax
  803a30:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803a33:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a36:	83 f8 7f             	cmp    $0x7f,%eax
  803a39:	76 07                	jbe    803a42 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803a3b:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803a42:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a45:	48 63 d0             	movslq %eax,%rdx
  803a48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a4b:	48 63 c8             	movslq %eax,%rcx
  803a4e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803a55:	48 01 c1             	add    %rax,%rcx
  803a58:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a5f:	48 89 ce             	mov    %rcx,%rsi
  803a62:	48 89 c7             	mov    %rax,%rdi
  803a65:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  803a6c:	00 00 00 
  803a6f:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803a71:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a74:	48 63 d0             	movslq %eax,%rdx
  803a77:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a7e:	48 89 d6             	mov    %rdx,%rsi
  803a81:	48 89 c7             	mov    %rax,%rdi
  803a84:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  803a8b:	00 00 00 
  803a8e:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a90:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a93:	01 45 fc             	add    %eax,-0x4(%rbp)
  803a96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a99:	48 98                	cltq   
  803a9b:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803aa2:	0f 82 78 ff ff ff    	jb     803a20 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803aa8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803aab:	c9                   	leaveq 
  803aac:	c3                   	retq   

0000000000803aad <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803aad:	55                   	push   %rbp
  803aae:	48 89 e5             	mov    %rsp,%rbp
  803ab1:	48 83 ec 08          	sub    $0x8,%rsp
  803ab5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803ab9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803abe:	c9                   	leaveq 
  803abf:	c3                   	retq   

0000000000803ac0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803ac0:	55                   	push   %rbp
  803ac1:	48 89 e5             	mov    %rsp,%rbp
  803ac4:	48 83 ec 10          	sub    $0x10,%rsp
  803ac8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803acc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803ad0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ad4:	48 be 36 45 80 00 00 	movabs $0x804536,%rsi
  803adb:	00 00 00 
  803ade:	48 89 c7             	mov    %rax,%rdi
  803ae1:	48 b8 2f 10 80 00 00 	movabs $0x80102f,%rax
  803ae8:	00 00 00 
  803aeb:	ff d0                	callq  *%rax
	return 0;
  803aed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803af2:	c9                   	leaveq 
  803af3:	c3                   	retq   

0000000000803af4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803af4:	55                   	push   %rbp
  803af5:	48 89 e5             	mov    %rsp,%rbp
  803af8:	53                   	push   %rbx
  803af9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803b00:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803b07:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803b0d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803b14:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803b1b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803b22:	84 c0                	test   %al,%al
  803b24:	74 23                	je     803b49 <_panic+0x55>
  803b26:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803b2d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803b31:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803b35:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803b39:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803b3d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803b41:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803b45:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803b49:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803b50:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803b57:	00 00 00 
  803b5a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803b61:	00 00 00 
  803b64:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803b68:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803b6f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803b76:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803b7d:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  803b84:	00 00 00 
  803b87:	48 8b 18             	mov    (%rax),%rbx
  803b8a:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  803b91:	00 00 00 
  803b94:	ff d0                	callq  *%rax
  803b96:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803b9c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803ba3:	41 89 c8             	mov    %ecx,%r8d
  803ba6:	48 89 d1             	mov    %rdx,%rcx
  803ba9:	48 89 da             	mov    %rbx,%rdx
  803bac:	89 c6                	mov    %eax,%esi
  803bae:	48 bf 40 45 80 00 00 	movabs $0x804540,%rdi
  803bb5:	00 00 00 
  803bb8:	b8 00 00 00 00       	mov    $0x0,%eax
  803bbd:	49 b9 7a 04 80 00 00 	movabs $0x80047a,%r9
  803bc4:	00 00 00 
  803bc7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803bca:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803bd1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803bd8:	48 89 d6             	mov    %rdx,%rsi
  803bdb:	48 89 c7             	mov    %rax,%rdi
  803bde:	48 b8 ce 03 80 00 00 	movabs $0x8003ce,%rax
  803be5:	00 00 00 
  803be8:	ff d0                	callq  *%rax
	cprintf("\n");
  803bea:	48 bf 63 45 80 00 00 	movabs $0x804563,%rdi
  803bf1:	00 00 00 
  803bf4:	b8 00 00 00 00       	mov    $0x0,%eax
  803bf9:	48 ba 7a 04 80 00 00 	movabs $0x80047a,%rdx
  803c00:	00 00 00 
  803c03:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803c05:	cc                   	int3   
  803c06:	eb fd                	jmp    803c05 <_panic+0x111>

0000000000803c08 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803c08:	55                   	push   %rbp
  803c09:	48 89 e5             	mov    %rsp,%rbp
  803c0c:	48 83 ec 10          	sub    $0x10,%rsp
  803c10:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  803c14:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803c1b:	00 00 00 
  803c1e:	48 8b 00             	mov    (%rax),%rax
  803c21:	48 85 c0             	test   %rax,%rax
  803c24:	0f 85 84 00 00 00    	jne    803cae <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  803c2a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c31:	00 00 00 
  803c34:	48 8b 00             	mov    (%rax),%rax
  803c37:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803c3d:	ba 07 00 00 00       	mov    $0x7,%edx
  803c42:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803c47:	89 c7                	mov    %eax,%edi
  803c49:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  803c50:	00 00 00 
  803c53:	ff d0                	callq  *%rax
  803c55:	85 c0                	test   %eax,%eax
  803c57:	79 2a                	jns    803c83 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  803c59:	48 ba 68 45 80 00 00 	movabs $0x804568,%rdx
  803c60:	00 00 00 
  803c63:	be 23 00 00 00       	mov    $0x23,%esi
  803c68:	48 bf 8f 45 80 00 00 	movabs $0x80458f,%rdi
  803c6f:	00 00 00 
  803c72:	b8 00 00 00 00       	mov    $0x0,%eax
  803c77:	48 b9 f4 3a 80 00 00 	movabs $0x803af4,%rcx
  803c7e:	00 00 00 
  803c81:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  803c83:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c8a:	00 00 00 
  803c8d:	48 8b 00             	mov    (%rax),%rax
  803c90:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803c96:	48 be c1 3c 80 00 00 	movabs $0x803cc1,%rsi
  803c9d:	00 00 00 
  803ca0:	89 c7                	mov    %eax,%edi
  803ca2:	48 b8 e8 1a 80 00 00 	movabs $0x801ae8,%rax
  803ca9:	00 00 00 
  803cac:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803cae:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803cb5:	00 00 00 
  803cb8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803cbc:	48 89 10             	mov    %rdx,(%rax)
}
  803cbf:	c9                   	leaveq 
  803cc0:	c3                   	retq   

0000000000803cc1 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  803cc1:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  803cc4:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803ccb:	00 00 00 
	call *%rax
  803cce:	ff d0                	callq  *%rax


	/*This code is to be removed*/

	// LAB 4: Your code here.
	movq 136(%rsp), %rbx  //Load RIP 
  803cd0:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803cd7:	00 
	movq 152(%rsp), %rcx  //Load RSP
  803cd8:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803cdf:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  803ce0:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  803ce4:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  803ce7:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803cee:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  803cef:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  803cf3:	4c 8b 3c 24          	mov    (%rsp),%r15
  803cf7:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803cfc:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803d01:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803d06:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803d0b:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803d10:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803d15:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803d1a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803d1f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803d24:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803d29:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803d2e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803d33:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803d38:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803d3d:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  803d41:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  803d45:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  803d46:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803d47:	c3                   	retq   

0000000000803d48 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803d48:	55                   	push   %rbp
  803d49:	48 89 e5             	mov    %rsp,%rbp
  803d4c:	48 83 ec 18          	sub    $0x18,%rsp
  803d50:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803d54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d58:	48 c1 e8 15          	shr    $0x15,%rax
  803d5c:	48 89 c2             	mov    %rax,%rdx
  803d5f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803d66:	01 00 00 
  803d69:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d6d:	83 e0 01             	and    $0x1,%eax
  803d70:	48 85 c0             	test   %rax,%rax
  803d73:	75 07                	jne    803d7c <pageref+0x34>
		return 0;
  803d75:	b8 00 00 00 00       	mov    $0x0,%eax
  803d7a:	eb 53                	jmp    803dcf <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803d7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d80:	48 c1 e8 0c          	shr    $0xc,%rax
  803d84:	48 89 c2             	mov    %rax,%rdx
  803d87:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803d8e:	01 00 00 
  803d91:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d95:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803d99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d9d:	83 e0 01             	and    $0x1,%eax
  803da0:	48 85 c0             	test   %rax,%rax
  803da3:	75 07                	jne    803dac <pageref+0x64>
		return 0;
  803da5:	b8 00 00 00 00       	mov    $0x0,%eax
  803daa:	eb 23                	jmp    803dcf <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803dac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803db0:	48 c1 e8 0c          	shr    $0xc,%rax
  803db4:	48 89 c2             	mov    %rax,%rdx
  803db7:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803dbe:	00 00 00 
  803dc1:	48 c1 e2 04          	shl    $0x4,%rdx
  803dc5:	48 01 d0             	add    %rdx,%rax
  803dc8:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803dcc:	0f b7 c0             	movzwl %ax,%eax
}
  803dcf:	c9                   	leaveq 
  803dd0:	c3                   	retq   
