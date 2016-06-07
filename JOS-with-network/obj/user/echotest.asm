
obj/user/echotest.debug:     file format elf64-x86-64


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
  80003c:	e8 d9 02 00 00       	callq  80031a <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <die>:

const char *msg = "Hello world!\n";

static void
die(char *m)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	cprintf("%s\n", m);
  80004f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800053:	48 89 c6             	mov    %rax,%rsi
  800056:	48 bf ee 45 80 00 00 	movabs $0x8045ee,%rdi
  80005d:	00 00 00 
  800060:	b8 00 00 00 00       	mov    $0x0,%eax
  800065:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  80006c:	00 00 00 
  80006f:	ff d2                	callq  *%rdx
	exit();
  800071:	48 b8 a5 03 80 00 00 	movabs $0x8003a5,%rax
  800078:	00 00 00 
  80007b:	ff d0                	callq  *%rax
}
  80007d:	c9                   	leaveq 
  80007e:	c3                   	retq   

000000000080007f <umain>:

void umain(int argc, char **argv)
{
  80007f:	55                   	push   %rbp
  800080:	48 89 e5             	mov    %rsp,%rbp
  800083:	48 83 ec 50          	sub    $0x50,%rsp
  800087:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80008a:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int sock;
	struct sockaddr_in echoserver;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;
  80008e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	cprintf("Connecting to:\n");
  800095:	48 bf f2 45 80 00 00 	movabs $0x8045f2,%rdi
  80009c:	00 00 00 
  80009f:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a4:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  8000ab:	00 00 00 
  8000ae:	ff d2                	callq  *%rdx
	cprintf("\tip address %s = %x\n", IPADDR, inet_addr(IPADDR));
  8000b0:	48 bf 02 46 80 00 00 	movabs $0x804602,%rdi
  8000b7:	00 00 00 
  8000ba:	48 b8 1b 41 80 00 00 	movabs $0x80411b,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
  8000c6:	89 c2                	mov    %eax,%edx
  8000c8:	48 be 02 46 80 00 00 	movabs $0x804602,%rsi
  8000cf:	00 00 00 
  8000d2:	48 bf 0c 46 80 00 00 	movabs $0x80460c,%rdi
  8000d9:	00 00 00 
  8000dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e1:	48 b9 ed 04 80 00 00 	movabs $0x8004ed,%rcx
  8000e8:	00 00 00 
  8000eb:	ff d1                	callq  *%rcx

	// Create the TCP socket
	if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8000ed:	ba 06 00 00 00       	mov    $0x6,%edx
  8000f2:	be 01 00 00 00       	mov    $0x1,%esi
  8000f7:	bf 02 00 00 00       	mov    $0x2,%edi
  8000fc:	48 b8 81 30 80 00 00 	movabs $0x803081,%rax
  800103:	00 00 00 
  800106:	ff d0                	callq  *%rax
  800108:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80010b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80010f:	79 16                	jns    800127 <umain+0xa8>
		die("Failed to create socket");
  800111:	48 bf 21 46 80 00 00 	movabs $0x804621,%rdi
  800118:	00 00 00 
  80011b:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800122:	00 00 00 
  800125:	ff d0                	callq  *%rax

	cprintf("opened socket\n");
  800127:	48 bf 39 46 80 00 00 	movabs $0x804639,%rdi
  80012e:	00 00 00 
  800131:	b8 00 00 00 00       	mov    $0x0,%eax
  800136:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  80013d:	00 00 00 
  800140:	ff d2                	callq  *%rdx

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  800142:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800146:	ba 10 00 00 00       	mov    $0x10,%edx
  80014b:	be 00 00 00 00       	mov    $0x0,%esi
  800150:	48 89 c7             	mov    %rax,%rdi
  800153:	48 b8 3b 13 80 00 00 	movabs $0x80133b,%rax
  80015a:	00 00 00 
  80015d:	ff d0                	callq  *%rax
	echoserver.sin_family = AF_INET;                  // Internet/IP
  80015f:	c6 45 e1 02          	movb   $0x2,-0x1f(%rbp)
	echoserver.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
  800163:	48 bf 02 46 80 00 00 	movabs $0x804602,%rdi
  80016a:	00 00 00 
  80016d:	48 b8 1b 41 80 00 00 	movabs $0x80411b,%rax
  800174:	00 00 00 
  800177:	ff d0                	callq  *%rax
  800179:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	echoserver.sin_port = htons(PORT);		  // server port
  80017c:	bf 10 27 00 00       	mov    $0x2710,%edi
  800181:	48 b8 2a 45 80 00 00 	movabs $0x80452a,%rax
  800188:	00 00 00 
  80018b:	ff d0                	callq  *%rax
  80018d:	66 89 45 e2          	mov    %ax,-0x1e(%rbp)

	cprintf("trying to connect to server\n");
  800191:	48 bf 48 46 80 00 00 	movabs $0x804648,%rdi
  800198:	00 00 00 
  80019b:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a0:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  8001a7:	00 00 00 
  8001aa:	ff d2                	callq  *%rdx

	// Establish connection
	if (connect(sock, (struct sockaddr *) &echoserver, sizeof(echoserver)) < 0)
  8001ac:	48 8d 4d e0          	lea    -0x20(%rbp),%rcx
  8001b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001b3:	ba 10 00 00 00       	mov    $0x10,%edx
  8001b8:	48 89 ce             	mov    %rcx,%rsi
  8001bb:	89 c7                	mov    %eax,%edi
  8001bd:	48 b8 46 2f 80 00 00 	movabs $0x802f46,%rax
  8001c4:	00 00 00 
  8001c7:	ff d0                	callq  *%rax
  8001c9:	85 c0                	test   %eax,%eax
  8001cb:	79 16                	jns    8001e3 <umain+0x164>
		die("Failed to connect with server");
  8001cd:	48 bf 65 46 80 00 00 	movabs $0x804665,%rdi
  8001d4:	00 00 00 
  8001d7:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001de:	00 00 00 
  8001e1:	ff d0                	callq  *%rax

	cprintf("connected to server\n");
  8001e3:	48 bf 83 46 80 00 00 	movabs $0x804683,%rdi
  8001ea:	00 00 00 
  8001ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f2:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  8001f9:	00 00 00 
  8001fc:	ff d2                	callq  *%rdx

	// Send the word to the server
	echolen = strlen(msg);
  8001fe:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800205:	00 00 00 
  800208:	48 8b 00             	mov    (%rax),%rax
  80020b:	48 89 c7             	mov    %rax,%rdi
  80020e:	48 b8 36 10 80 00 00 	movabs $0x801036,%rax
  800215:	00 00 00 
  800218:	ff d0                	callq  *%rax
  80021a:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (write(sock, msg, echolen) != echolen)
  80021d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800220:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800227:	00 00 00 
  80022a:	48 8b 08             	mov    (%rax),%rcx
  80022d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800230:	48 89 ce             	mov    %rcx,%rsi
  800233:	89 c7                	mov    %eax,%edi
  800235:	48 b8 6a 23 80 00 00 	movabs $0x80236a,%rax
  80023c:	00 00 00 
  80023f:	ff d0                	callq  *%rax
  800241:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  800244:	74 16                	je     80025c <umain+0x1dd>
		die("Mismatch in number of sent bytes");
  800246:	48 bf 98 46 80 00 00 	movabs $0x804698,%rdi
  80024d:	00 00 00 
  800250:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800257:	00 00 00 
  80025a:	ff d0                	callq  *%rax

	// Receive the word back from the server
	cprintf("Received: \n");
  80025c:	48 bf b9 46 80 00 00 	movabs $0x8046b9,%rdi
  800263:	00 00 00 
  800266:	b8 00 00 00 00       	mov    $0x0,%eax
  80026b:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  800272:	00 00 00 
  800275:	ff d2                	callq  *%rdx
	while (received < echolen) {
  800277:	eb 6b                	jmp    8002e4 <umain+0x265>
		int bytes = 0;
  800279:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  800280:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
  800284:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800287:	ba 1f 00 00 00       	mov    $0x1f,%edx
  80028c:	48 89 ce             	mov    %rcx,%rsi
  80028f:	89 c7                	mov    %eax,%edi
  800291:	48 b8 20 22 80 00 00 	movabs $0x802220,%rax
  800298:	00 00 00 
  80029b:	ff d0                	callq  *%rax
  80029d:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8002a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002a4:	7f 16                	jg     8002bc <umain+0x23d>
			die("Failed to receive bytes from server");
  8002a6:	48 bf c8 46 80 00 00 	movabs $0x8046c8,%rdi
  8002ad:	00 00 00 
  8002b0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002b7:	00 00 00 
  8002ba:	ff d0                	callq  *%rax
		}
		received += bytes;
  8002bc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002bf:	01 45 fc             	add    %eax,-0x4(%rbp)
		buffer[bytes] = '\0';        // Assure null terminated string
  8002c2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002c5:	48 98                	cltq   
  8002c7:	c6 44 05 c0 00       	movb   $0x0,-0x40(%rbp,%rax,1)
		cprintf(buffer);
  8002cc:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  8002d0:	48 89 c7             	mov    %rax,%rdi
  8002d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d8:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  8002df:	00 00 00 
  8002e2:	ff d2                	callq  *%rdx
	if (write(sock, msg, echolen) != echolen)
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
	while (received < echolen) {
  8002e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002e7:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8002ea:	72 8d                	jb     800279 <umain+0x1fa>
		}
		received += bytes;
		buffer[bytes] = '\0';        // Assure null terminated string
		cprintf(buffer);
	}
	cprintf("\n");
  8002ec:	48 bf ec 46 80 00 00 	movabs $0x8046ec,%rdi
  8002f3:	00 00 00 
  8002f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fb:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  800302:	00 00 00 
  800305:	ff d2                	callq  *%rdx

	close(sock);
  800307:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80030a:	89 c7                	mov    %eax,%edi
  80030c:	48 b8 fe 1f 80 00 00 	movabs $0x801ffe,%rax
  800313:	00 00 00 
  800316:	ff d0                	callq  *%rax
}
  800318:	c9                   	leaveq 
  800319:	c3                   	retq   

000000000080031a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80031a:	55                   	push   %rbp
  80031b:	48 89 e5             	mov    %rsp,%rbp
  80031e:	48 83 ec 10          	sub    $0x10,%rsp
  800322:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800325:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800329:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  800330:	00 00 00 
  800333:	ff d0                	callq  *%rax
  800335:	25 ff 03 00 00       	and    $0x3ff,%eax
  80033a:	48 63 d0             	movslq %eax,%rdx
  80033d:	48 89 d0             	mov    %rdx,%rax
  800340:	48 c1 e0 03          	shl    $0x3,%rax
  800344:	48 01 d0             	add    %rdx,%rax
  800347:	48 c1 e0 05          	shl    $0x5,%rax
  80034b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800352:	00 00 00 
  800355:	48 01 c2             	add    %rax,%rdx
  800358:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80035f:	00 00 00 
  800362:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800365:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800369:	7e 14                	jle    80037f <libmain+0x65>
		binaryname = argv[0];
  80036b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80036f:	48 8b 10             	mov    (%rax),%rdx
  800372:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800379:	00 00 00 
  80037c:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80037f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800383:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800386:	48 89 d6             	mov    %rdx,%rsi
  800389:	89 c7                	mov    %eax,%edi
  80038b:	48 b8 7f 00 80 00 00 	movabs $0x80007f,%rax
  800392:	00 00 00 
  800395:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800397:	48 b8 a5 03 80 00 00 	movabs $0x8003a5,%rax
  80039e:	00 00 00 
  8003a1:	ff d0                	callq  *%rax
}
  8003a3:	c9                   	leaveq 
  8003a4:	c3                   	retq   

00000000008003a5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003a5:	55                   	push   %rbp
  8003a6:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003a9:	48 b8 49 20 80 00 00 	movabs $0x802049,%rax
  8003b0:	00 00 00 
  8003b3:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8003ba:	48 b8 11 19 80 00 00 	movabs $0x801911,%rax
  8003c1:	00 00 00 
  8003c4:	ff d0                	callq  *%rax

}
  8003c6:	5d                   	pop    %rbp
  8003c7:	c3                   	retq   

00000000008003c8 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8003c8:	55                   	push   %rbp
  8003c9:	48 89 e5             	mov    %rsp,%rbp
  8003cc:	48 83 ec 10          	sub    $0x10,%rsp
  8003d0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003db:	8b 00                	mov    (%rax),%eax
  8003dd:	8d 48 01             	lea    0x1(%rax),%ecx
  8003e0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003e4:	89 0a                	mov    %ecx,(%rdx)
  8003e6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003e9:	89 d1                	mov    %edx,%ecx
  8003eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ef:	48 98                	cltq   
  8003f1:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f9:	8b 00                	mov    (%rax),%eax
  8003fb:	3d ff 00 00 00       	cmp    $0xff,%eax
  800400:	75 2c                	jne    80042e <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800402:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800406:	8b 00                	mov    (%rax),%eax
  800408:	48 98                	cltq   
  80040a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80040e:	48 83 c2 08          	add    $0x8,%rdx
  800412:	48 89 c6             	mov    %rax,%rsi
  800415:	48 89 d7             	mov    %rdx,%rdi
  800418:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  80041f:	00 00 00 
  800422:	ff d0                	callq  *%rax
        b->idx = 0;
  800424:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800428:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80042e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800432:	8b 40 04             	mov    0x4(%rax),%eax
  800435:	8d 50 01             	lea    0x1(%rax),%edx
  800438:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80043c:	89 50 04             	mov    %edx,0x4(%rax)
}
  80043f:	c9                   	leaveq 
  800440:	c3                   	retq   

0000000000800441 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800441:	55                   	push   %rbp
  800442:	48 89 e5             	mov    %rsp,%rbp
  800445:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80044c:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800453:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80045a:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800461:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800468:	48 8b 0a             	mov    (%rdx),%rcx
  80046b:	48 89 08             	mov    %rcx,(%rax)
  80046e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800472:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800476:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80047a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80047e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800485:	00 00 00 
    b.cnt = 0;
  800488:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80048f:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800492:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800499:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004a0:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004a7:	48 89 c6             	mov    %rax,%rsi
  8004aa:	48 bf c8 03 80 00 00 	movabs $0x8003c8,%rdi
  8004b1:	00 00 00 
  8004b4:	48 b8 a0 08 80 00 00 	movabs $0x8008a0,%rax
  8004bb:	00 00 00 
  8004be:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8004c0:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8004c6:	48 98                	cltq   
  8004c8:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004cf:	48 83 c2 08          	add    $0x8,%rdx
  8004d3:	48 89 c6             	mov    %rax,%rsi
  8004d6:	48 89 d7             	mov    %rdx,%rdi
  8004d9:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  8004e0:	00 00 00 
  8004e3:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004e5:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004eb:	c9                   	leaveq 
  8004ec:	c3                   	retq   

00000000008004ed <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004ed:	55                   	push   %rbp
  8004ee:	48 89 e5             	mov    %rsp,%rbp
  8004f1:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004f8:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004ff:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800506:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80050d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800514:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80051b:	84 c0                	test   %al,%al
  80051d:	74 20                	je     80053f <cprintf+0x52>
  80051f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800523:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800527:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80052b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80052f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800533:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800537:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80053b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80053f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800546:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80054d:	00 00 00 
  800550:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800557:	00 00 00 
  80055a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80055e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800565:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80056c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800573:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80057a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800581:	48 8b 0a             	mov    (%rdx),%rcx
  800584:	48 89 08             	mov    %rcx,(%rax)
  800587:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80058b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80058f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800593:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800597:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80059e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005a5:	48 89 d6             	mov    %rdx,%rsi
  8005a8:	48 89 c7             	mov    %rax,%rdi
  8005ab:	48 b8 41 04 80 00 00 	movabs $0x800441,%rax
  8005b2:	00 00 00 
  8005b5:	ff d0                	callq  *%rax
  8005b7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8005bd:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005c3:	c9                   	leaveq 
  8005c4:	c3                   	retq   

00000000008005c5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c5:	55                   	push   %rbp
  8005c6:	48 89 e5             	mov    %rsp,%rbp
  8005c9:	53                   	push   %rbx
  8005ca:	48 83 ec 38          	sub    $0x38,%rsp
  8005ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005d6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8005da:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8005dd:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005e1:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005e5:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005e8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005ec:	77 3b                	ja     800629 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ee:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005f1:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005f5:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800601:	48 f7 f3             	div    %rbx
  800604:	48 89 c2             	mov    %rax,%rdx
  800607:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80060a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80060d:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800611:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800615:	41 89 f9             	mov    %edi,%r9d
  800618:	48 89 c7             	mov    %rax,%rdi
  80061b:	48 b8 c5 05 80 00 00 	movabs $0x8005c5,%rax
  800622:	00 00 00 
  800625:	ff d0                	callq  *%rax
  800627:	eb 1e                	jmp    800647 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800629:	eb 12                	jmp    80063d <printnum+0x78>
			putch(padc, putdat);
  80062b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80062f:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800632:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800636:	48 89 ce             	mov    %rcx,%rsi
  800639:	89 d7                	mov    %edx,%edi
  80063b:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063d:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800641:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800645:	7f e4                	jg     80062b <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800647:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80064a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80064e:	ba 00 00 00 00       	mov    $0x0,%edx
  800653:	48 f7 f1             	div    %rcx
  800656:	48 89 d0             	mov    %rdx,%rax
  800659:	48 ba f0 48 80 00 00 	movabs $0x8048f0,%rdx
  800660:	00 00 00 
  800663:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800667:	0f be d0             	movsbl %al,%edx
  80066a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80066e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800672:	48 89 ce             	mov    %rcx,%rsi
  800675:	89 d7                	mov    %edx,%edi
  800677:	ff d0                	callq  *%rax
}
  800679:	48 83 c4 38          	add    $0x38,%rsp
  80067d:	5b                   	pop    %rbx
  80067e:	5d                   	pop    %rbp
  80067f:	c3                   	retq   

0000000000800680 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800680:	55                   	push   %rbp
  800681:	48 89 e5             	mov    %rsp,%rbp
  800684:	48 83 ec 1c          	sub    $0x1c,%rsp
  800688:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80068c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80068f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800693:	7e 52                	jle    8006e7 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800695:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800699:	8b 00                	mov    (%rax),%eax
  80069b:	83 f8 30             	cmp    $0x30,%eax
  80069e:	73 24                	jae    8006c4 <getuint+0x44>
  8006a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ac:	8b 00                	mov    (%rax),%eax
  8006ae:	89 c0                	mov    %eax,%eax
  8006b0:	48 01 d0             	add    %rdx,%rax
  8006b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b7:	8b 12                	mov    (%rdx),%edx
  8006b9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c0:	89 0a                	mov    %ecx,(%rdx)
  8006c2:	eb 17                	jmp    8006db <getuint+0x5b>
  8006c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006cc:	48 89 d0             	mov    %rdx,%rax
  8006cf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006db:	48 8b 00             	mov    (%rax),%rax
  8006de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006e2:	e9 a3 00 00 00       	jmpq   80078a <getuint+0x10a>
	else if (lflag)
  8006e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006eb:	74 4f                	je     80073c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f1:	8b 00                	mov    (%rax),%eax
  8006f3:	83 f8 30             	cmp    $0x30,%eax
  8006f6:	73 24                	jae    80071c <getuint+0x9c>
  8006f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800700:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800704:	8b 00                	mov    (%rax),%eax
  800706:	89 c0                	mov    %eax,%eax
  800708:	48 01 d0             	add    %rdx,%rax
  80070b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070f:	8b 12                	mov    (%rdx),%edx
  800711:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800714:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800718:	89 0a                	mov    %ecx,(%rdx)
  80071a:	eb 17                	jmp    800733 <getuint+0xb3>
  80071c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800720:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800724:	48 89 d0             	mov    %rdx,%rax
  800727:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80072b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800733:	48 8b 00             	mov    (%rax),%rax
  800736:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80073a:	eb 4e                	jmp    80078a <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80073c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800740:	8b 00                	mov    (%rax),%eax
  800742:	83 f8 30             	cmp    $0x30,%eax
  800745:	73 24                	jae    80076b <getuint+0xeb>
  800747:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80074f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800753:	8b 00                	mov    (%rax),%eax
  800755:	89 c0                	mov    %eax,%eax
  800757:	48 01 d0             	add    %rdx,%rax
  80075a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075e:	8b 12                	mov    (%rdx),%edx
  800760:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800763:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800767:	89 0a                	mov    %ecx,(%rdx)
  800769:	eb 17                	jmp    800782 <getuint+0x102>
  80076b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800773:	48 89 d0             	mov    %rdx,%rax
  800776:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80077a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800782:	8b 00                	mov    (%rax),%eax
  800784:	89 c0                	mov    %eax,%eax
  800786:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80078a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80078e:	c9                   	leaveq 
  80078f:	c3                   	retq   

0000000000800790 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800790:	55                   	push   %rbp
  800791:	48 89 e5             	mov    %rsp,%rbp
  800794:	48 83 ec 1c          	sub    $0x1c,%rsp
  800798:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80079c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80079f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007a3:	7e 52                	jle    8007f7 <getint+0x67>
		x=va_arg(*ap, long long);
  8007a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a9:	8b 00                	mov    (%rax),%eax
  8007ab:	83 f8 30             	cmp    $0x30,%eax
  8007ae:	73 24                	jae    8007d4 <getint+0x44>
  8007b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bc:	8b 00                	mov    (%rax),%eax
  8007be:	89 c0                	mov    %eax,%eax
  8007c0:	48 01 d0             	add    %rdx,%rax
  8007c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c7:	8b 12                	mov    (%rdx),%edx
  8007c9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d0:	89 0a                	mov    %ecx,(%rdx)
  8007d2:	eb 17                	jmp    8007eb <getint+0x5b>
  8007d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007dc:	48 89 d0             	mov    %rdx,%rax
  8007df:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007eb:	48 8b 00             	mov    (%rax),%rax
  8007ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007f2:	e9 a3 00 00 00       	jmpq   80089a <getint+0x10a>
	else if (lflag)
  8007f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007fb:	74 4f                	je     80084c <getint+0xbc>
		x=va_arg(*ap, long);
  8007fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800801:	8b 00                	mov    (%rax),%eax
  800803:	83 f8 30             	cmp    $0x30,%eax
  800806:	73 24                	jae    80082c <getint+0x9c>
  800808:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800810:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800814:	8b 00                	mov    (%rax),%eax
  800816:	89 c0                	mov    %eax,%eax
  800818:	48 01 d0             	add    %rdx,%rax
  80081b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081f:	8b 12                	mov    (%rdx),%edx
  800821:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800824:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800828:	89 0a                	mov    %ecx,(%rdx)
  80082a:	eb 17                	jmp    800843 <getint+0xb3>
  80082c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800830:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800834:	48 89 d0             	mov    %rdx,%rax
  800837:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80083b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800843:	48 8b 00             	mov    (%rax),%rax
  800846:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80084a:	eb 4e                	jmp    80089a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80084c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800850:	8b 00                	mov    (%rax),%eax
  800852:	83 f8 30             	cmp    $0x30,%eax
  800855:	73 24                	jae    80087b <getint+0xeb>
  800857:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80085f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800863:	8b 00                	mov    (%rax),%eax
  800865:	89 c0                	mov    %eax,%eax
  800867:	48 01 d0             	add    %rdx,%rax
  80086a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086e:	8b 12                	mov    (%rdx),%edx
  800870:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800873:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800877:	89 0a                	mov    %ecx,(%rdx)
  800879:	eb 17                	jmp    800892 <getint+0x102>
  80087b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800883:	48 89 d0             	mov    %rdx,%rax
  800886:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80088a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800892:	8b 00                	mov    (%rax),%eax
  800894:	48 98                	cltq   
  800896:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80089a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80089e:	c9                   	leaveq 
  80089f:	c3                   	retq   

00000000008008a0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008a0:	55                   	push   %rbp
  8008a1:	48 89 e5             	mov    %rsp,%rbp
  8008a4:	41 54                	push   %r12
  8008a6:	53                   	push   %rbx
  8008a7:	48 83 ec 60          	sub    $0x60,%rsp
  8008ab:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008af:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008b3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008b7:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008bb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008bf:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008c3:	48 8b 0a             	mov    (%rdx),%rcx
  8008c6:	48 89 08             	mov    %rcx,(%rax)
  8008c9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008cd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008d1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008d5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008d9:	eb 17                	jmp    8008f2 <vprintfmt+0x52>
			if (ch == '\0')
  8008db:	85 db                	test   %ebx,%ebx
  8008dd:	0f 84 cc 04 00 00    	je     800daf <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8008e3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008e7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008eb:	48 89 d6             	mov    %rdx,%rsi
  8008ee:	89 df                	mov    %ebx,%edi
  8008f0:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008f2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008f6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008fa:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008fe:	0f b6 00             	movzbl (%rax),%eax
  800901:	0f b6 d8             	movzbl %al,%ebx
  800904:	83 fb 25             	cmp    $0x25,%ebx
  800907:	75 d2                	jne    8008db <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800909:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80090d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800914:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80091b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800922:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800929:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80092d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800931:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800935:	0f b6 00             	movzbl (%rax),%eax
  800938:	0f b6 d8             	movzbl %al,%ebx
  80093b:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80093e:	83 f8 55             	cmp    $0x55,%eax
  800941:	0f 87 34 04 00 00    	ja     800d7b <vprintfmt+0x4db>
  800947:	89 c0                	mov    %eax,%eax
  800949:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800950:	00 
  800951:	48 b8 18 49 80 00 00 	movabs $0x804918,%rax
  800958:	00 00 00 
  80095b:	48 01 d0             	add    %rdx,%rax
  80095e:	48 8b 00             	mov    (%rax),%rax
  800961:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800963:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800967:	eb c0                	jmp    800929 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800969:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80096d:	eb ba                	jmp    800929 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80096f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800976:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800979:	89 d0                	mov    %edx,%eax
  80097b:	c1 e0 02             	shl    $0x2,%eax
  80097e:	01 d0                	add    %edx,%eax
  800980:	01 c0                	add    %eax,%eax
  800982:	01 d8                	add    %ebx,%eax
  800984:	83 e8 30             	sub    $0x30,%eax
  800987:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80098a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80098e:	0f b6 00             	movzbl (%rax),%eax
  800991:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800994:	83 fb 2f             	cmp    $0x2f,%ebx
  800997:	7e 0c                	jle    8009a5 <vprintfmt+0x105>
  800999:	83 fb 39             	cmp    $0x39,%ebx
  80099c:	7f 07                	jg     8009a5 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80099e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009a3:	eb d1                	jmp    800976 <vprintfmt+0xd6>
			goto process_precision;
  8009a5:	eb 58                	jmp    8009ff <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8009a7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009aa:	83 f8 30             	cmp    $0x30,%eax
  8009ad:	73 17                	jae    8009c6 <vprintfmt+0x126>
  8009af:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009b3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b6:	89 c0                	mov    %eax,%eax
  8009b8:	48 01 d0             	add    %rdx,%rax
  8009bb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009be:	83 c2 08             	add    $0x8,%edx
  8009c1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009c4:	eb 0f                	jmp    8009d5 <vprintfmt+0x135>
  8009c6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009ca:	48 89 d0             	mov    %rdx,%rax
  8009cd:	48 83 c2 08          	add    $0x8,%rdx
  8009d1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009d5:	8b 00                	mov    (%rax),%eax
  8009d7:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009da:	eb 23                	jmp    8009ff <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8009dc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009e0:	79 0c                	jns    8009ee <vprintfmt+0x14e>
				width = 0;
  8009e2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009e9:	e9 3b ff ff ff       	jmpq   800929 <vprintfmt+0x89>
  8009ee:	e9 36 ff ff ff       	jmpq   800929 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009f3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009fa:	e9 2a ff ff ff       	jmpq   800929 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009ff:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a03:	79 12                	jns    800a17 <vprintfmt+0x177>
				width = precision, precision = -1;
  800a05:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a08:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a0b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a12:	e9 12 ff ff ff       	jmpq   800929 <vprintfmt+0x89>
  800a17:	e9 0d ff ff ff       	jmpq   800929 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a1c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a20:	e9 04 ff ff ff       	jmpq   800929 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a28:	83 f8 30             	cmp    $0x30,%eax
  800a2b:	73 17                	jae    800a44 <vprintfmt+0x1a4>
  800a2d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a31:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a34:	89 c0                	mov    %eax,%eax
  800a36:	48 01 d0             	add    %rdx,%rax
  800a39:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a3c:	83 c2 08             	add    $0x8,%edx
  800a3f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a42:	eb 0f                	jmp    800a53 <vprintfmt+0x1b3>
  800a44:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a48:	48 89 d0             	mov    %rdx,%rax
  800a4b:	48 83 c2 08          	add    $0x8,%rdx
  800a4f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a53:	8b 10                	mov    (%rax),%edx
  800a55:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a59:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a5d:	48 89 ce             	mov    %rcx,%rsi
  800a60:	89 d7                	mov    %edx,%edi
  800a62:	ff d0                	callq  *%rax
			break;
  800a64:	e9 40 03 00 00       	jmpq   800da9 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a69:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6c:	83 f8 30             	cmp    $0x30,%eax
  800a6f:	73 17                	jae    800a88 <vprintfmt+0x1e8>
  800a71:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a75:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a78:	89 c0                	mov    %eax,%eax
  800a7a:	48 01 d0             	add    %rdx,%rax
  800a7d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a80:	83 c2 08             	add    $0x8,%edx
  800a83:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a86:	eb 0f                	jmp    800a97 <vprintfmt+0x1f7>
  800a88:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a8c:	48 89 d0             	mov    %rdx,%rax
  800a8f:	48 83 c2 08          	add    $0x8,%rdx
  800a93:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a97:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a99:	85 db                	test   %ebx,%ebx
  800a9b:	79 02                	jns    800a9f <vprintfmt+0x1ff>
				err = -err;
  800a9d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a9f:	83 fb 15             	cmp    $0x15,%ebx
  800aa2:	7f 16                	jg     800aba <vprintfmt+0x21a>
  800aa4:	48 b8 40 48 80 00 00 	movabs $0x804840,%rax
  800aab:	00 00 00 
  800aae:	48 63 d3             	movslq %ebx,%rdx
  800ab1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ab5:	4d 85 e4             	test   %r12,%r12
  800ab8:	75 2e                	jne    800ae8 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800aba:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800abe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac2:	89 d9                	mov    %ebx,%ecx
  800ac4:	48 ba 01 49 80 00 00 	movabs $0x804901,%rdx
  800acb:	00 00 00 
  800ace:	48 89 c7             	mov    %rax,%rdi
  800ad1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad6:	49 b8 b8 0d 80 00 00 	movabs $0x800db8,%r8
  800add:	00 00 00 
  800ae0:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ae3:	e9 c1 02 00 00       	jmpq   800da9 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ae8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af0:	4c 89 e1             	mov    %r12,%rcx
  800af3:	48 ba 0a 49 80 00 00 	movabs $0x80490a,%rdx
  800afa:	00 00 00 
  800afd:	48 89 c7             	mov    %rax,%rdi
  800b00:	b8 00 00 00 00       	mov    $0x0,%eax
  800b05:	49 b8 b8 0d 80 00 00 	movabs $0x800db8,%r8
  800b0c:	00 00 00 
  800b0f:	41 ff d0             	callq  *%r8
			break;
  800b12:	e9 92 02 00 00       	jmpq   800da9 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b17:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b1a:	83 f8 30             	cmp    $0x30,%eax
  800b1d:	73 17                	jae    800b36 <vprintfmt+0x296>
  800b1f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b23:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b26:	89 c0                	mov    %eax,%eax
  800b28:	48 01 d0             	add    %rdx,%rax
  800b2b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b2e:	83 c2 08             	add    $0x8,%edx
  800b31:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b34:	eb 0f                	jmp    800b45 <vprintfmt+0x2a5>
  800b36:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b3a:	48 89 d0             	mov    %rdx,%rax
  800b3d:	48 83 c2 08          	add    $0x8,%rdx
  800b41:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b45:	4c 8b 20             	mov    (%rax),%r12
  800b48:	4d 85 e4             	test   %r12,%r12
  800b4b:	75 0a                	jne    800b57 <vprintfmt+0x2b7>
				p = "(null)";
  800b4d:	49 bc 0d 49 80 00 00 	movabs $0x80490d,%r12
  800b54:	00 00 00 
			if (width > 0 && padc != '-')
  800b57:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b5b:	7e 3f                	jle    800b9c <vprintfmt+0x2fc>
  800b5d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b61:	74 39                	je     800b9c <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b63:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b66:	48 98                	cltq   
  800b68:	48 89 c6             	mov    %rax,%rsi
  800b6b:	4c 89 e7             	mov    %r12,%rdi
  800b6e:	48 b8 64 10 80 00 00 	movabs $0x801064,%rax
  800b75:	00 00 00 
  800b78:	ff d0                	callq  *%rax
  800b7a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b7d:	eb 17                	jmp    800b96 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b7f:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b83:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b87:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8b:	48 89 ce             	mov    %rcx,%rsi
  800b8e:	89 d7                	mov    %edx,%edi
  800b90:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b92:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b96:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b9a:	7f e3                	jg     800b7f <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b9c:	eb 37                	jmp    800bd5 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b9e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ba2:	74 1e                	je     800bc2 <vprintfmt+0x322>
  800ba4:	83 fb 1f             	cmp    $0x1f,%ebx
  800ba7:	7e 05                	jle    800bae <vprintfmt+0x30e>
  800ba9:	83 fb 7e             	cmp    $0x7e,%ebx
  800bac:	7e 14                	jle    800bc2 <vprintfmt+0x322>
					putch('?', putdat);
  800bae:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb6:	48 89 d6             	mov    %rdx,%rsi
  800bb9:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800bbe:	ff d0                	callq  *%rax
  800bc0:	eb 0f                	jmp    800bd1 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800bc2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bca:	48 89 d6             	mov    %rdx,%rsi
  800bcd:	89 df                	mov    %ebx,%edi
  800bcf:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bd1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bd5:	4c 89 e0             	mov    %r12,%rax
  800bd8:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bdc:	0f b6 00             	movzbl (%rax),%eax
  800bdf:	0f be d8             	movsbl %al,%ebx
  800be2:	85 db                	test   %ebx,%ebx
  800be4:	74 10                	je     800bf6 <vprintfmt+0x356>
  800be6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bea:	78 b2                	js     800b9e <vprintfmt+0x2fe>
  800bec:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bf0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bf4:	79 a8                	jns    800b9e <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bf6:	eb 16                	jmp    800c0e <vprintfmt+0x36e>
				putch(' ', putdat);
  800bf8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bfc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c00:	48 89 d6             	mov    %rdx,%rsi
  800c03:	bf 20 00 00 00       	mov    $0x20,%edi
  800c08:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c0a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c0e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c12:	7f e4                	jg     800bf8 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800c14:	e9 90 01 00 00       	jmpq   800da9 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c19:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c1d:	be 03 00 00 00       	mov    $0x3,%esi
  800c22:	48 89 c7             	mov    %rax,%rdi
  800c25:	48 b8 90 07 80 00 00 	movabs $0x800790,%rax
  800c2c:	00 00 00 
  800c2f:	ff d0                	callq  *%rax
  800c31:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c39:	48 85 c0             	test   %rax,%rax
  800c3c:	79 1d                	jns    800c5b <vprintfmt+0x3bb>
				putch('-', putdat);
  800c3e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c42:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c46:	48 89 d6             	mov    %rdx,%rsi
  800c49:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c4e:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c54:	48 f7 d8             	neg    %rax
  800c57:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c5b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c62:	e9 d5 00 00 00       	jmpq   800d3c <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c67:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c6b:	be 03 00 00 00       	mov    $0x3,%esi
  800c70:	48 89 c7             	mov    %rax,%rdi
  800c73:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  800c7a:	00 00 00 
  800c7d:	ff d0                	callq  *%rax
  800c7f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c83:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c8a:	e9 ad 00 00 00       	jmpq   800d3c <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800c8f:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800c92:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c96:	89 d6                	mov    %edx,%esi
  800c98:	48 89 c7             	mov    %rax,%rdi
  800c9b:	48 b8 90 07 80 00 00 	movabs $0x800790,%rax
  800ca2:	00 00 00 
  800ca5:	ff d0                	callq  *%rax
  800ca7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800cab:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800cb2:	e9 85 00 00 00       	jmpq   800d3c <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800cb7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cbb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cbf:	48 89 d6             	mov    %rdx,%rsi
  800cc2:	bf 30 00 00 00       	mov    $0x30,%edi
  800cc7:	ff d0                	callq  *%rax
			putch('x', putdat);
  800cc9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ccd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd1:	48 89 d6             	mov    %rdx,%rsi
  800cd4:	bf 78 00 00 00       	mov    $0x78,%edi
  800cd9:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cdb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cde:	83 f8 30             	cmp    $0x30,%eax
  800ce1:	73 17                	jae    800cfa <vprintfmt+0x45a>
  800ce3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ce7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cea:	89 c0                	mov    %eax,%eax
  800cec:	48 01 d0             	add    %rdx,%rax
  800cef:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cf2:	83 c2 08             	add    $0x8,%edx
  800cf5:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cf8:	eb 0f                	jmp    800d09 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800cfa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cfe:	48 89 d0             	mov    %rdx,%rax
  800d01:	48 83 c2 08          	add    $0x8,%rdx
  800d05:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d09:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d0c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d10:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d17:	eb 23                	jmp    800d3c <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d19:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d1d:	be 03 00 00 00       	mov    $0x3,%esi
  800d22:	48 89 c7             	mov    %rax,%rdi
  800d25:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  800d2c:	00 00 00 
  800d2f:	ff d0                	callq  *%rax
  800d31:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d35:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d3c:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d41:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d44:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d47:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d4b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d4f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d53:	45 89 c1             	mov    %r8d,%r9d
  800d56:	41 89 f8             	mov    %edi,%r8d
  800d59:	48 89 c7             	mov    %rax,%rdi
  800d5c:	48 b8 c5 05 80 00 00 	movabs $0x8005c5,%rax
  800d63:	00 00 00 
  800d66:	ff d0                	callq  *%rax
			break;
  800d68:	eb 3f                	jmp    800da9 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d6a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d6e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d72:	48 89 d6             	mov    %rdx,%rsi
  800d75:	89 df                	mov    %ebx,%edi
  800d77:	ff d0                	callq  *%rax
			break;
  800d79:	eb 2e                	jmp    800da9 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d7b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d7f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d83:	48 89 d6             	mov    %rdx,%rsi
  800d86:	bf 25 00 00 00       	mov    $0x25,%edi
  800d8b:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d8d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d92:	eb 05                	jmp    800d99 <vprintfmt+0x4f9>
  800d94:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d99:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d9d:	48 83 e8 01          	sub    $0x1,%rax
  800da1:	0f b6 00             	movzbl (%rax),%eax
  800da4:	3c 25                	cmp    $0x25,%al
  800da6:	75 ec                	jne    800d94 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800da8:	90                   	nop
		}
	}
  800da9:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800daa:	e9 43 fb ff ff       	jmpq   8008f2 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800daf:	48 83 c4 60          	add    $0x60,%rsp
  800db3:	5b                   	pop    %rbx
  800db4:	41 5c                	pop    %r12
  800db6:	5d                   	pop    %rbp
  800db7:	c3                   	retq   

0000000000800db8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800db8:	55                   	push   %rbp
  800db9:	48 89 e5             	mov    %rsp,%rbp
  800dbc:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800dc3:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800dca:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800dd1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dd8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ddf:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800de6:	84 c0                	test   %al,%al
  800de8:	74 20                	je     800e0a <printfmt+0x52>
  800dea:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dee:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800df2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800df6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dfa:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dfe:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e02:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e06:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e0a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e11:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e18:	00 00 00 
  800e1b:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e22:	00 00 00 
  800e25:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e29:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e30:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e37:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e3e:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e45:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e4c:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e53:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e5a:	48 89 c7             	mov    %rax,%rdi
  800e5d:	48 b8 a0 08 80 00 00 	movabs $0x8008a0,%rax
  800e64:	00 00 00 
  800e67:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e69:	c9                   	leaveq 
  800e6a:	c3                   	retq   

0000000000800e6b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e6b:	55                   	push   %rbp
  800e6c:	48 89 e5             	mov    %rsp,%rbp
  800e6f:	48 83 ec 10          	sub    $0x10,%rsp
  800e73:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e76:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e7e:	8b 40 10             	mov    0x10(%rax),%eax
  800e81:	8d 50 01             	lea    0x1(%rax),%edx
  800e84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e88:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e8f:	48 8b 10             	mov    (%rax),%rdx
  800e92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e96:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e9a:	48 39 c2             	cmp    %rax,%rdx
  800e9d:	73 17                	jae    800eb6 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea3:	48 8b 00             	mov    (%rax),%rax
  800ea6:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800eaa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800eae:	48 89 0a             	mov    %rcx,(%rdx)
  800eb1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800eb4:	88 10                	mov    %dl,(%rax)
}
  800eb6:	c9                   	leaveq 
  800eb7:	c3                   	retq   

0000000000800eb8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800eb8:	55                   	push   %rbp
  800eb9:	48 89 e5             	mov    %rsp,%rbp
  800ebc:	48 83 ec 50          	sub    $0x50,%rsp
  800ec0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ec4:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ec7:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ecb:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ecf:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ed3:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ed7:	48 8b 0a             	mov    (%rdx),%rcx
  800eda:	48 89 08             	mov    %rcx,(%rax)
  800edd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ee1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ee5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ee9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800eed:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ef1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ef5:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ef8:	48 98                	cltq   
  800efa:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800efe:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f02:	48 01 d0             	add    %rdx,%rax
  800f05:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f09:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f10:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f15:	74 06                	je     800f1d <vsnprintf+0x65>
  800f17:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f1b:	7f 07                	jg     800f24 <vsnprintf+0x6c>
		return -E_INVAL;
  800f1d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f22:	eb 2f                	jmp    800f53 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f24:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f28:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f2c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f30:	48 89 c6             	mov    %rax,%rsi
  800f33:	48 bf 6b 0e 80 00 00 	movabs $0x800e6b,%rdi
  800f3a:	00 00 00 
  800f3d:	48 b8 a0 08 80 00 00 	movabs $0x8008a0,%rax
  800f44:	00 00 00 
  800f47:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f49:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f4d:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f50:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f53:	c9                   	leaveq 
  800f54:	c3                   	retq   

0000000000800f55 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f55:	55                   	push   %rbp
  800f56:	48 89 e5             	mov    %rsp,%rbp
  800f59:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f60:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f67:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f6d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f74:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f7b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f82:	84 c0                	test   %al,%al
  800f84:	74 20                	je     800fa6 <snprintf+0x51>
  800f86:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f8a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f8e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f92:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f96:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f9a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f9e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fa2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fa6:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fad:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fb4:	00 00 00 
  800fb7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fbe:	00 00 00 
  800fc1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fc5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fcc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fd3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fda:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fe1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fe8:	48 8b 0a             	mov    (%rdx),%rcx
  800feb:	48 89 08             	mov    %rcx,(%rax)
  800fee:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ff2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ff6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ffa:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800ffe:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801005:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80100c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801012:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801019:	48 89 c7             	mov    %rax,%rdi
  80101c:	48 b8 b8 0e 80 00 00 	movabs $0x800eb8,%rax
  801023:	00 00 00 
  801026:	ff d0                	callq  *%rax
  801028:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80102e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801034:	c9                   	leaveq 
  801035:	c3                   	retq   

0000000000801036 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801036:	55                   	push   %rbp
  801037:	48 89 e5             	mov    %rsp,%rbp
  80103a:	48 83 ec 18          	sub    $0x18,%rsp
  80103e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801042:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801049:	eb 09                	jmp    801054 <strlen+0x1e>
		n++;
  80104b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80104f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801054:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801058:	0f b6 00             	movzbl (%rax),%eax
  80105b:	84 c0                	test   %al,%al
  80105d:	75 ec                	jne    80104b <strlen+0x15>
		n++;
	return n;
  80105f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801062:	c9                   	leaveq 
  801063:	c3                   	retq   

0000000000801064 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801064:	55                   	push   %rbp
  801065:	48 89 e5             	mov    %rsp,%rbp
  801068:	48 83 ec 20          	sub    $0x20,%rsp
  80106c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801070:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801074:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80107b:	eb 0e                	jmp    80108b <strnlen+0x27>
		n++;
  80107d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801081:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801086:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80108b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801090:	74 0b                	je     80109d <strnlen+0x39>
  801092:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801096:	0f b6 00             	movzbl (%rax),%eax
  801099:	84 c0                	test   %al,%al
  80109b:	75 e0                	jne    80107d <strnlen+0x19>
		n++;
	return n;
  80109d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010a0:	c9                   	leaveq 
  8010a1:	c3                   	retq   

00000000008010a2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010a2:	55                   	push   %rbp
  8010a3:	48 89 e5             	mov    %rsp,%rbp
  8010a6:	48 83 ec 20          	sub    $0x20,%rsp
  8010aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010ba:	90                   	nop
  8010bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010c3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010c7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010cb:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010cf:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010d3:	0f b6 12             	movzbl (%rdx),%edx
  8010d6:	88 10                	mov    %dl,(%rax)
  8010d8:	0f b6 00             	movzbl (%rax),%eax
  8010db:	84 c0                	test   %al,%al
  8010dd:	75 dc                	jne    8010bb <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010e3:	c9                   	leaveq 
  8010e4:	c3                   	retq   

00000000008010e5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010e5:	55                   	push   %rbp
  8010e6:	48 89 e5             	mov    %rsp,%rbp
  8010e9:	48 83 ec 20          	sub    $0x20,%rsp
  8010ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f9:	48 89 c7             	mov    %rax,%rdi
  8010fc:	48 b8 36 10 80 00 00 	movabs $0x801036,%rax
  801103:	00 00 00 
  801106:	ff d0                	callq  *%rax
  801108:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80110b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80110e:	48 63 d0             	movslq %eax,%rdx
  801111:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801115:	48 01 c2             	add    %rax,%rdx
  801118:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80111c:	48 89 c6             	mov    %rax,%rsi
  80111f:	48 89 d7             	mov    %rdx,%rdi
  801122:	48 b8 a2 10 80 00 00 	movabs $0x8010a2,%rax
  801129:	00 00 00 
  80112c:	ff d0                	callq  *%rax
	return dst;
  80112e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801132:	c9                   	leaveq 
  801133:	c3                   	retq   

0000000000801134 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801134:	55                   	push   %rbp
  801135:	48 89 e5             	mov    %rsp,%rbp
  801138:	48 83 ec 28          	sub    $0x28,%rsp
  80113c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801140:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801144:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801148:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801150:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801157:	00 
  801158:	eb 2a                	jmp    801184 <strncpy+0x50>
		*dst++ = *src;
  80115a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801162:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801166:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80116a:	0f b6 12             	movzbl (%rdx),%edx
  80116d:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80116f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801173:	0f b6 00             	movzbl (%rax),%eax
  801176:	84 c0                	test   %al,%al
  801178:	74 05                	je     80117f <strncpy+0x4b>
			src++;
  80117a:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80117f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801184:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801188:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80118c:	72 cc                	jb     80115a <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80118e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801192:	c9                   	leaveq 
  801193:	c3                   	retq   

0000000000801194 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801194:	55                   	push   %rbp
  801195:	48 89 e5             	mov    %rsp,%rbp
  801198:	48 83 ec 28          	sub    $0x28,%rsp
  80119c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011a4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011b0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011b5:	74 3d                	je     8011f4 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011b7:	eb 1d                	jmp    8011d6 <strlcpy+0x42>
			*dst++ = *src++;
  8011b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011bd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011c1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011c5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011c9:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011cd:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011d1:	0f b6 12             	movzbl (%rdx),%edx
  8011d4:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011d6:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011db:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011e0:	74 0b                	je     8011ed <strlcpy+0x59>
  8011e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011e6:	0f b6 00             	movzbl (%rax),%eax
  8011e9:	84 c0                	test   %al,%al
  8011eb:	75 cc                	jne    8011b9 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f1:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fc:	48 29 c2             	sub    %rax,%rdx
  8011ff:	48 89 d0             	mov    %rdx,%rax
}
  801202:	c9                   	leaveq 
  801203:	c3                   	retq   

0000000000801204 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801204:	55                   	push   %rbp
  801205:	48 89 e5             	mov    %rsp,%rbp
  801208:	48 83 ec 10          	sub    $0x10,%rsp
  80120c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801210:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801214:	eb 0a                	jmp    801220 <strcmp+0x1c>
		p++, q++;
  801216:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80121b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801220:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801224:	0f b6 00             	movzbl (%rax),%eax
  801227:	84 c0                	test   %al,%al
  801229:	74 12                	je     80123d <strcmp+0x39>
  80122b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122f:	0f b6 10             	movzbl (%rax),%edx
  801232:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801236:	0f b6 00             	movzbl (%rax),%eax
  801239:	38 c2                	cmp    %al,%dl
  80123b:	74 d9                	je     801216 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80123d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801241:	0f b6 00             	movzbl (%rax),%eax
  801244:	0f b6 d0             	movzbl %al,%edx
  801247:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80124b:	0f b6 00             	movzbl (%rax),%eax
  80124e:	0f b6 c0             	movzbl %al,%eax
  801251:	29 c2                	sub    %eax,%edx
  801253:	89 d0                	mov    %edx,%eax
}
  801255:	c9                   	leaveq 
  801256:	c3                   	retq   

0000000000801257 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801257:	55                   	push   %rbp
  801258:	48 89 e5             	mov    %rsp,%rbp
  80125b:	48 83 ec 18          	sub    $0x18,%rsp
  80125f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801263:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801267:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80126b:	eb 0f                	jmp    80127c <strncmp+0x25>
		n--, p++, q++;
  80126d:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801272:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801277:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80127c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801281:	74 1d                	je     8012a0 <strncmp+0x49>
  801283:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801287:	0f b6 00             	movzbl (%rax),%eax
  80128a:	84 c0                	test   %al,%al
  80128c:	74 12                	je     8012a0 <strncmp+0x49>
  80128e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801292:	0f b6 10             	movzbl (%rax),%edx
  801295:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801299:	0f b6 00             	movzbl (%rax),%eax
  80129c:	38 c2                	cmp    %al,%dl
  80129e:	74 cd                	je     80126d <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012a0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012a5:	75 07                	jne    8012ae <strncmp+0x57>
		return 0;
  8012a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ac:	eb 18                	jmp    8012c6 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b2:	0f b6 00             	movzbl (%rax),%eax
  8012b5:	0f b6 d0             	movzbl %al,%edx
  8012b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012bc:	0f b6 00             	movzbl (%rax),%eax
  8012bf:	0f b6 c0             	movzbl %al,%eax
  8012c2:	29 c2                	sub    %eax,%edx
  8012c4:	89 d0                	mov    %edx,%eax
}
  8012c6:	c9                   	leaveq 
  8012c7:	c3                   	retq   

00000000008012c8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012c8:	55                   	push   %rbp
  8012c9:	48 89 e5             	mov    %rsp,%rbp
  8012cc:	48 83 ec 0c          	sub    $0xc,%rsp
  8012d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012d4:	89 f0                	mov    %esi,%eax
  8012d6:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012d9:	eb 17                	jmp    8012f2 <strchr+0x2a>
		if (*s == c)
  8012db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012df:	0f b6 00             	movzbl (%rax),%eax
  8012e2:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012e5:	75 06                	jne    8012ed <strchr+0x25>
			return (char *) s;
  8012e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012eb:	eb 15                	jmp    801302 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012ed:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f6:	0f b6 00             	movzbl (%rax),%eax
  8012f9:	84 c0                	test   %al,%al
  8012fb:	75 de                	jne    8012db <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801302:	c9                   	leaveq 
  801303:	c3                   	retq   

0000000000801304 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801304:	55                   	push   %rbp
  801305:	48 89 e5             	mov    %rsp,%rbp
  801308:	48 83 ec 0c          	sub    $0xc,%rsp
  80130c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801310:	89 f0                	mov    %esi,%eax
  801312:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801315:	eb 13                	jmp    80132a <strfind+0x26>
		if (*s == c)
  801317:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131b:	0f b6 00             	movzbl (%rax),%eax
  80131e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801321:	75 02                	jne    801325 <strfind+0x21>
			break;
  801323:	eb 10                	jmp    801335 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801325:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80132a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132e:	0f b6 00             	movzbl (%rax),%eax
  801331:	84 c0                	test   %al,%al
  801333:	75 e2                	jne    801317 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801335:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801339:	c9                   	leaveq 
  80133a:	c3                   	retq   

000000000080133b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80133b:	55                   	push   %rbp
  80133c:	48 89 e5             	mov    %rsp,%rbp
  80133f:	48 83 ec 18          	sub    $0x18,%rsp
  801343:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801347:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80134a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80134e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801353:	75 06                	jne    80135b <memset+0x20>
		return v;
  801355:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801359:	eb 69                	jmp    8013c4 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80135b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135f:	83 e0 03             	and    $0x3,%eax
  801362:	48 85 c0             	test   %rax,%rax
  801365:	75 48                	jne    8013af <memset+0x74>
  801367:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136b:	83 e0 03             	and    $0x3,%eax
  80136e:	48 85 c0             	test   %rax,%rax
  801371:	75 3c                	jne    8013af <memset+0x74>
		c &= 0xFF;
  801373:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80137a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80137d:	c1 e0 18             	shl    $0x18,%eax
  801380:	89 c2                	mov    %eax,%edx
  801382:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801385:	c1 e0 10             	shl    $0x10,%eax
  801388:	09 c2                	or     %eax,%edx
  80138a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80138d:	c1 e0 08             	shl    $0x8,%eax
  801390:	09 d0                	or     %edx,%eax
  801392:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801395:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801399:	48 c1 e8 02          	shr    $0x2,%rax
  80139d:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013a0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013a4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013a7:	48 89 d7             	mov    %rdx,%rdi
  8013aa:	fc                   	cld    
  8013ab:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013ad:	eb 11                	jmp    8013c0 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013af:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013b3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013b6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013ba:	48 89 d7             	mov    %rdx,%rdi
  8013bd:	fc                   	cld    
  8013be:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013c4:	c9                   	leaveq 
  8013c5:	c3                   	retq   

00000000008013c6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013c6:	55                   	push   %rbp
  8013c7:	48 89 e5             	mov    %rsp,%rbp
  8013ca:	48 83 ec 28          	sub    $0x28,%rsp
  8013ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013d6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ee:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013f2:	0f 83 88 00 00 00    	jae    801480 <memmove+0xba>
  8013f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801400:	48 01 d0             	add    %rdx,%rax
  801403:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801407:	76 77                	jbe    801480 <memmove+0xba>
		s += n;
  801409:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801411:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801415:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801419:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141d:	83 e0 03             	and    $0x3,%eax
  801420:	48 85 c0             	test   %rax,%rax
  801423:	75 3b                	jne    801460 <memmove+0x9a>
  801425:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801429:	83 e0 03             	and    $0x3,%eax
  80142c:	48 85 c0             	test   %rax,%rax
  80142f:	75 2f                	jne    801460 <memmove+0x9a>
  801431:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801435:	83 e0 03             	and    $0x3,%eax
  801438:	48 85 c0             	test   %rax,%rax
  80143b:	75 23                	jne    801460 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80143d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801441:	48 83 e8 04          	sub    $0x4,%rax
  801445:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801449:	48 83 ea 04          	sub    $0x4,%rdx
  80144d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801451:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801455:	48 89 c7             	mov    %rax,%rdi
  801458:	48 89 d6             	mov    %rdx,%rsi
  80145b:	fd                   	std    
  80145c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80145e:	eb 1d                	jmp    80147d <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801460:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801464:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801468:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801470:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801474:	48 89 d7             	mov    %rdx,%rdi
  801477:	48 89 c1             	mov    %rax,%rcx
  80147a:	fd                   	std    
  80147b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80147d:	fc                   	cld    
  80147e:	eb 57                	jmp    8014d7 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801480:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801484:	83 e0 03             	and    $0x3,%eax
  801487:	48 85 c0             	test   %rax,%rax
  80148a:	75 36                	jne    8014c2 <memmove+0xfc>
  80148c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801490:	83 e0 03             	and    $0x3,%eax
  801493:	48 85 c0             	test   %rax,%rax
  801496:	75 2a                	jne    8014c2 <memmove+0xfc>
  801498:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149c:	83 e0 03             	and    $0x3,%eax
  80149f:	48 85 c0             	test   %rax,%rax
  8014a2:	75 1e                	jne    8014c2 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a8:	48 c1 e8 02          	shr    $0x2,%rax
  8014ac:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014b7:	48 89 c7             	mov    %rax,%rdi
  8014ba:	48 89 d6             	mov    %rdx,%rsi
  8014bd:	fc                   	cld    
  8014be:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014c0:	eb 15                	jmp    8014d7 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014ca:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014ce:	48 89 c7             	mov    %rax,%rdi
  8014d1:	48 89 d6             	mov    %rdx,%rsi
  8014d4:	fc                   	cld    
  8014d5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014db:	c9                   	leaveq 
  8014dc:	c3                   	retq   

00000000008014dd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014dd:	55                   	push   %rbp
  8014de:	48 89 e5             	mov    %rsp,%rbp
  8014e1:	48 83 ec 18          	sub    $0x18,%rsp
  8014e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014ed:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014f5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fd:	48 89 ce             	mov    %rcx,%rsi
  801500:	48 89 c7             	mov    %rax,%rdi
  801503:	48 b8 c6 13 80 00 00 	movabs $0x8013c6,%rax
  80150a:	00 00 00 
  80150d:	ff d0                	callq  *%rax
}
  80150f:	c9                   	leaveq 
  801510:	c3                   	retq   

0000000000801511 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801511:	55                   	push   %rbp
  801512:	48 89 e5             	mov    %rsp,%rbp
  801515:	48 83 ec 28          	sub    $0x28,%rsp
  801519:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80151d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801521:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801529:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80152d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801531:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801535:	eb 36                	jmp    80156d <memcmp+0x5c>
		if (*s1 != *s2)
  801537:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153b:	0f b6 10             	movzbl (%rax),%edx
  80153e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801542:	0f b6 00             	movzbl (%rax),%eax
  801545:	38 c2                	cmp    %al,%dl
  801547:	74 1a                	je     801563 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801549:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154d:	0f b6 00             	movzbl (%rax),%eax
  801550:	0f b6 d0             	movzbl %al,%edx
  801553:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801557:	0f b6 00             	movzbl (%rax),%eax
  80155a:	0f b6 c0             	movzbl %al,%eax
  80155d:	29 c2                	sub    %eax,%edx
  80155f:	89 d0                	mov    %edx,%eax
  801561:	eb 20                	jmp    801583 <memcmp+0x72>
		s1++, s2++;
  801563:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801568:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80156d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801571:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801575:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801579:	48 85 c0             	test   %rax,%rax
  80157c:	75 b9                	jne    801537 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80157e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801583:	c9                   	leaveq 
  801584:	c3                   	retq   

0000000000801585 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801585:	55                   	push   %rbp
  801586:	48 89 e5             	mov    %rsp,%rbp
  801589:	48 83 ec 28          	sub    $0x28,%rsp
  80158d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801591:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801594:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801598:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015a0:	48 01 d0             	add    %rdx,%rax
  8015a3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015a7:	eb 15                	jmp    8015be <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ad:	0f b6 10             	movzbl (%rax),%edx
  8015b0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015b3:	38 c2                	cmp    %al,%dl
  8015b5:	75 02                	jne    8015b9 <memfind+0x34>
			break;
  8015b7:	eb 0f                	jmp    8015c8 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015b9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c2:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015c6:	72 e1                	jb     8015a9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8015c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015cc:	c9                   	leaveq 
  8015cd:	c3                   	retq   

00000000008015ce <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015ce:	55                   	push   %rbp
  8015cf:	48 89 e5             	mov    %rsp,%rbp
  8015d2:	48 83 ec 34          	sub    $0x34,%rsp
  8015d6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015da:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015de:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015e8:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015ef:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015f0:	eb 05                	jmp    8015f7 <strtol+0x29>
		s++;
  8015f2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fb:	0f b6 00             	movzbl (%rax),%eax
  8015fe:	3c 20                	cmp    $0x20,%al
  801600:	74 f0                	je     8015f2 <strtol+0x24>
  801602:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801606:	0f b6 00             	movzbl (%rax),%eax
  801609:	3c 09                	cmp    $0x9,%al
  80160b:	74 e5                	je     8015f2 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80160d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801611:	0f b6 00             	movzbl (%rax),%eax
  801614:	3c 2b                	cmp    $0x2b,%al
  801616:	75 07                	jne    80161f <strtol+0x51>
		s++;
  801618:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80161d:	eb 17                	jmp    801636 <strtol+0x68>
	else if (*s == '-')
  80161f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801623:	0f b6 00             	movzbl (%rax),%eax
  801626:	3c 2d                	cmp    $0x2d,%al
  801628:	75 0c                	jne    801636 <strtol+0x68>
		s++, neg = 1;
  80162a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80162f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801636:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80163a:	74 06                	je     801642 <strtol+0x74>
  80163c:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801640:	75 28                	jne    80166a <strtol+0x9c>
  801642:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801646:	0f b6 00             	movzbl (%rax),%eax
  801649:	3c 30                	cmp    $0x30,%al
  80164b:	75 1d                	jne    80166a <strtol+0x9c>
  80164d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801651:	48 83 c0 01          	add    $0x1,%rax
  801655:	0f b6 00             	movzbl (%rax),%eax
  801658:	3c 78                	cmp    $0x78,%al
  80165a:	75 0e                	jne    80166a <strtol+0x9c>
		s += 2, base = 16;
  80165c:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801661:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801668:	eb 2c                	jmp    801696 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80166a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80166e:	75 19                	jne    801689 <strtol+0xbb>
  801670:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801674:	0f b6 00             	movzbl (%rax),%eax
  801677:	3c 30                	cmp    $0x30,%al
  801679:	75 0e                	jne    801689 <strtol+0xbb>
		s++, base = 8;
  80167b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801680:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801687:	eb 0d                	jmp    801696 <strtol+0xc8>
	else if (base == 0)
  801689:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80168d:	75 07                	jne    801696 <strtol+0xc8>
		base = 10;
  80168f:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801696:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169a:	0f b6 00             	movzbl (%rax),%eax
  80169d:	3c 2f                	cmp    $0x2f,%al
  80169f:	7e 1d                	jle    8016be <strtol+0xf0>
  8016a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a5:	0f b6 00             	movzbl (%rax),%eax
  8016a8:	3c 39                	cmp    $0x39,%al
  8016aa:	7f 12                	jg     8016be <strtol+0xf0>
			dig = *s - '0';
  8016ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b0:	0f b6 00             	movzbl (%rax),%eax
  8016b3:	0f be c0             	movsbl %al,%eax
  8016b6:	83 e8 30             	sub    $0x30,%eax
  8016b9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016bc:	eb 4e                	jmp    80170c <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c2:	0f b6 00             	movzbl (%rax),%eax
  8016c5:	3c 60                	cmp    $0x60,%al
  8016c7:	7e 1d                	jle    8016e6 <strtol+0x118>
  8016c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cd:	0f b6 00             	movzbl (%rax),%eax
  8016d0:	3c 7a                	cmp    $0x7a,%al
  8016d2:	7f 12                	jg     8016e6 <strtol+0x118>
			dig = *s - 'a' + 10;
  8016d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d8:	0f b6 00             	movzbl (%rax),%eax
  8016db:	0f be c0             	movsbl %al,%eax
  8016de:	83 e8 57             	sub    $0x57,%eax
  8016e1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016e4:	eb 26                	jmp    80170c <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ea:	0f b6 00             	movzbl (%rax),%eax
  8016ed:	3c 40                	cmp    $0x40,%al
  8016ef:	7e 48                	jle    801739 <strtol+0x16b>
  8016f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f5:	0f b6 00             	movzbl (%rax),%eax
  8016f8:	3c 5a                	cmp    $0x5a,%al
  8016fa:	7f 3d                	jg     801739 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801700:	0f b6 00             	movzbl (%rax),%eax
  801703:	0f be c0             	movsbl %al,%eax
  801706:	83 e8 37             	sub    $0x37,%eax
  801709:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80170c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80170f:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801712:	7c 02                	jl     801716 <strtol+0x148>
			break;
  801714:	eb 23                	jmp    801739 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801716:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80171b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80171e:	48 98                	cltq   
  801720:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801725:	48 89 c2             	mov    %rax,%rdx
  801728:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80172b:	48 98                	cltq   
  80172d:	48 01 d0             	add    %rdx,%rax
  801730:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801734:	e9 5d ff ff ff       	jmpq   801696 <strtol+0xc8>

	if (endptr)
  801739:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80173e:	74 0b                	je     80174b <strtol+0x17d>
		*endptr = (char *) s;
  801740:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801744:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801748:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80174b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80174f:	74 09                	je     80175a <strtol+0x18c>
  801751:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801755:	48 f7 d8             	neg    %rax
  801758:	eb 04                	jmp    80175e <strtol+0x190>
  80175a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80175e:	c9                   	leaveq 
  80175f:	c3                   	retq   

0000000000801760 <strstr>:

char * strstr(const char *in, const char *str)
{
  801760:	55                   	push   %rbp
  801761:	48 89 e5             	mov    %rsp,%rbp
  801764:	48 83 ec 30          	sub    $0x30,%rsp
  801768:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80176c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801770:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801774:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801778:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80177c:	0f b6 00             	movzbl (%rax),%eax
  80177f:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801782:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801786:	75 06                	jne    80178e <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801788:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178c:	eb 6b                	jmp    8017f9 <strstr+0x99>

	len = strlen(str);
  80178e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801792:	48 89 c7             	mov    %rax,%rdi
  801795:	48 b8 36 10 80 00 00 	movabs $0x801036,%rax
  80179c:	00 00 00 
  80179f:	ff d0                	callq  *%rax
  8017a1:	48 98                	cltq   
  8017a3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8017a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ab:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017af:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017b3:	0f b6 00             	movzbl (%rax),%eax
  8017b6:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8017b9:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017bd:	75 07                	jne    8017c6 <strstr+0x66>
				return (char *) 0;
  8017bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c4:	eb 33                	jmp    8017f9 <strstr+0x99>
		} while (sc != c);
  8017c6:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017ca:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017cd:	75 d8                	jne    8017a7 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017d3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017db:	48 89 ce             	mov    %rcx,%rsi
  8017de:	48 89 c7             	mov    %rax,%rdi
  8017e1:	48 b8 57 12 80 00 00 	movabs $0x801257,%rax
  8017e8:	00 00 00 
  8017eb:	ff d0                	callq  *%rax
  8017ed:	85 c0                	test   %eax,%eax
  8017ef:	75 b6                	jne    8017a7 <strstr+0x47>

	return (char *) (in - 1);
  8017f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f5:	48 83 e8 01          	sub    $0x1,%rax
}
  8017f9:	c9                   	leaveq 
  8017fa:	c3                   	retq   

00000000008017fb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017fb:	55                   	push   %rbp
  8017fc:	48 89 e5             	mov    %rsp,%rbp
  8017ff:	53                   	push   %rbx
  801800:	48 83 ec 48          	sub    $0x48,%rsp
  801804:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801807:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80180a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80180e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801812:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801816:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80181a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80181d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801821:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801825:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801829:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80182d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801831:	4c 89 c3             	mov    %r8,%rbx
  801834:	cd 30                	int    $0x30
  801836:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80183a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80183e:	74 3e                	je     80187e <syscall+0x83>
  801840:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801845:	7e 37                	jle    80187e <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801847:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80184b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80184e:	49 89 d0             	mov    %rdx,%r8
  801851:	89 c1                	mov    %eax,%ecx
  801853:	48 ba c8 4b 80 00 00 	movabs $0x804bc8,%rdx
  80185a:	00 00 00 
  80185d:	be 23 00 00 00       	mov    $0x23,%esi
  801862:	48 bf e5 4b 80 00 00 	movabs $0x804be5,%rdi
  801869:	00 00 00 
  80186c:	b8 00 00 00 00       	mov    $0x0,%eax
  801871:	49 b9 94 3d 80 00 00 	movabs $0x803d94,%r9
  801878:	00 00 00 
  80187b:	41 ff d1             	callq  *%r9

	return ret;
  80187e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801882:	48 83 c4 48          	add    $0x48,%rsp
  801886:	5b                   	pop    %rbx
  801887:	5d                   	pop    %rbp
  801888:	c3                   	retq   

0000000000801889 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801889:	55                   	push   %rbp
  80188a:	48 89 e5             	mov    %rsp,%rbp
  80188d:	48 83 ec 20          	sub    $0x20,%rsp
  801891:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801895:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801899:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80189d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018a1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018a8:	00 
  8018a9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018af:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b5:	48 89 d1             	mov    %rdx,%rcx
  8018b8:	48 89 c2             	mov    %rax,%rdx
  8018bb:	be 00 00 00 00       	mov    $0x0,%esi
  8018c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8018c5:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  8018cc:	00 00 00 
  8018cf:	ff d0                	callq  *%rax
}
  8018d1:	c9                   	leaveq 
  8018d2:	c3                   	retq   

00000000008018d3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018d3:	55                   	push   %rbp
  8018d4:	48 89 e5             	mov    %rsp,%rbp
  8018d7:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018db:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e2:	00 
  8018e3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f9:	be 00 00 00 00       	mov    $0x0,%esi
  8018fe:	bf 01 00 00 00       	mov    $0x1,%edi
  801903:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  80190a:	00 00 00 
  80190d:	ff d0                	callq  *%rax
}
  80190f:	c9                   	leaveq 
  801910:	c3                   	retq   

0000000000801911 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801911:	55                   	push   %rbp
  801912:	48 89 e5             	mov    %rsp,%rbp
  801915:	48 83 ec 10          	sub    $0x10,%rsp
  801919:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80191c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80191f:	48 98                	cltq   
  801921:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801928:	00 
  801929:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80192f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801935:	b9 00 00 00 00       	mov    $0x0,%ecx
  80193a:	48 89 c2             	mov    %rax,%rdx
  80193d:	be 01 00 00 00       	mov    $0x1,%esi
  801942:	bf 03 00 00 00       	mov    $0x3,%edi
  801947:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  80194e:	00 00 00 
  801951:	ff d0                	callq  *%rax
}
  801953:	c9                   	leaveq 
  801954:	c3                   	retq   

0000000000801955 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801955:	55                   	push   %rbp
  801956:	48 89 e5             	mov    %rsp,%rbp
  801959:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80195d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801964:	00 
  801965:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80196b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801971:	b9 00 00 00 00       	mov    $0x0,%ecx
  801976:	ba 00 00 00 00       	mov    $0x0,%edx
  80197b:	be 00 00 00 00       	mov    $0x0,%esi
  801980:	bf 02 00 00 00       	mov    $0x2,%edi
  801985:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  80198c:	00 00 00 
  80198f:	ff d0                	callq  *%rax
}
  801991:	c9                   	leaveq 
  801992:	c3                   	retq   

0000000000801993 <sys_yield>:

void
sys_yield(void)
{
  801993:	55                   	push   %rbp
  801994:	48 89 e5             	mov    %rsp,%rbp
  801997:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80199b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019a2:	00 
  8019a3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b9:	be 00 00 00 00       	mov    $0x0,%esi
  8019be:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019c3:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  8019ca:	00 00 00 
  8019cd:	ff d0                	callq  *%rax
}
  8019cf:	c9                   	leaveq 
  8019d0:	c3                   	retq   

00000000008019d1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019d1:	55                   	push   %rbp
  8019d2:	48 89 e5             	mov    %rsp,%rbp
  8019d5:	48 83 ec 20          	sub    $0x20,%rsp
  8019d9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019dc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019e0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019e6:	48 63 c8             	movslq %eax,%rcx
  8019e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f0:	48 98                	cltq   
  8019f2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019f9:	00 
  8019fa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a00:	49 89 c8             	mov    %rcx,%r8
  801a03:	48 89 d1             	mov    %rdx,%rcx
  801a06:	48 89 c2             	mov    %rax,%rdx
  801a09:	be 01 00 00 00       	mov    $0x1,%esi
  801a0e:	bf 04 00 00 00       	mov    $0x4,%edi
  801a13:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801a1a:	00 00 00 
  801a1d:	ff d0                	callq  *%rax
}
  801a1f:	c9                   	leaveq 
  801a20:	c3                   	retq   

0000000000801a21 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a21:	55                   	push   %rbp
  801a22:	48 89 e5             	mov    %rsp,%rbp
  801a25:	48 83 ec 30          	sub    $0x30,%rsp
  801a29:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a2c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a30:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a33:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a37:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a3b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a3e:	48 63 c8             	movslq %eax,%rcx
  801a41:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a45:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a48:	48 63 f0             	movslq %eax,%rsi
  801a4b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a52:	48 98                	cltq   
  801a54:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a58:	49 89 f9             	mov    %rdi,%r9
  801a5b:	49 89 f0             	mov    %rsi,%r8
  801a5e:	48 89 d1             	mov    %rdx,%rcx
  801a61:	48 89 c2             	mov    %rax,%rdx
  801a64:	be 01 00 00 00       	mov    $0x1,%esi
  801a69:	bf 05 00 00 00       	mov    $0x5,%edi
  801a6e:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801a75:	00 00 00 
  801a78:	ff d0                	callq  *%rax
}
  801a7a:	c9                   	leaveq 
  801a7b:	c3                   	retq   

0000000000801a7c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a7c:	55                   	push   %rbp
  801a7d:	48 89 e5             	mov    %rsp,%rbp
  801a80:	48 83 ec 20          	sub    $0x20,%rsp
  801a84:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a87:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a8b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a92:	48 98                	cltq   
  801a94:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a9b:	00 
  801a9c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa8:	48 89 d1             	mov    %rdx,%rcx
  801aab:	48 89 c2             	mov    %rax,%rdx
  801aae:	be 01 00 00 00       	mov    $0x1,%esi
  801ab3:	bf 06 00 00 00       	mov    $0x6,%edi
  801ab8:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801abf:	00 00 00 
  801ac2:	ff d0                	callq  *%rax
}
  801ac4:	c9                   	leaveq 
  801ac5:	c3                   	retq   

0000000000801ac6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ac6:	55                   	push   %rbp
  801ac7:	48 89 e5             	mov    %rsp,%rbp
  801aca:	48 83 ec 10          	sub    $0x10,%rsp
  801ace:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ad1:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ad4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ad7:	48 63 d0             	movslq %eax,%rdx
  801ada:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801add:	48 98                	cltq   
  801adf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae6:	00 
  801ae7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af3:	48 89 d1             	mov    %rdx,%rcx
  801af6:	48 89 c2             	mov    %rax,%rdx
  801af9:	be 01 00 00 00       	mov    $0x1,%esi
  801afe:	bf 08 00 00 00       	mov    $0x8,%edi
  801b03:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801b0a:	00 00 00 
  801b0d:	ff d0                	callq  *%rax
}
  801b0f:	c9                   	leaveq 
  801b10:	c3                   	retq   

0000000000801b11 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b11:	55                   	push   %rbp
  801b12:	48 89 e5             	mov    %rsp,%rbp
  801b15:	48 83 ec 20          	sub    $0x20,%rsp
  801b19:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b1c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b20:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b27:	48 98                	cltq   
  801b29:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b30:	00 
  801b31:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b37:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b3d:	48 89 d1             	mov    %rdx,%rcx
  801b40:	48 89 c2             	mov    %rax,%rdx
  801b43:	be 01 00 00 00       	mov    $0x1,%esi
  801b48:	bf 09 00 00 00       	mov    $0x9,%edi
  801b4d:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801b54:	00 00 00 
  801b57:	ff d0                	callq  *%rax
}
  801b59:	c9                   	leaveq 
  801b5a:	c3                   	retq   

0000000000801b5b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b5b:	55                   	push   %rbp
  801b5c:	48 89 e5             	mov    %rsp,%rbp
  801b5f:	48 83 ec 20          	sub    $0x20,%rsp
  801b63:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b66:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b71:	48 98                	cltq   
  801b73:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b7a:	00 
  801b7b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b81:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b87:	48 89 d1             	mov    %rdx,%rcx
  801b8a:	48 89 c2             	mov    %rax,%rdx
  801b8d:	be 01 00 00 00       	mov    $0x1,%esi
  801b92:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b97:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801b9e:	00 00 00 
  801ba1:	ff d0                	callq  *%rax
}
  801ba3:	c9                   	leaveq 
  801ba4:	c3                   	retq   

0000000000801ba5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ba5:	55                   	push   %rbp
  801ba6:	48 89 e5             	mov    %rsp,%rbp
  801ba9:	48 83 ec 20          	sub    $0x20,%rsp
  801bad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bb0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bb4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bb8:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801bbb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bbe:	48 63 f0             	movslq %eax,%rsi
  801bc1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801bc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc8:	48 98                	cltq   
  801bca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd5:	00 
  801bd6:	49 89 f1             	mov    %rsi,%r9
  801bd9:	49 89 c8             	mov    %rcx,%r8
  801bdc:	48 89 d1             	mov    %rdx,%rcx
  801bdf:	48 89 c2             	mov    %rax,%rdx
  801be2:	be 00 00 00 00       	mov    $0x0,%esi
  801be7:	bf 0c 00 00 00       	mov    $0xc,%edi
  801bec:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801bf3:	00 00 00 
  801bf6:	ff d0                	callq  *%rax
}
  801bf8:	c9                   	leaveq 
  801bf9:	c3                   	retq   

0000000000801bfa <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801bfa:	55                   	push   %rbp
  801bfb:	48 89 e5             	mov    %rsp,%rbp
  801bfe:	48 83 ec 10          	sub    $0x10,%rsp
  801c02:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c0a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c11:	00 
  801c12:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c18:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c1e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c23:	48 89 c2             	mov    %rax,%rdx
  801c26:	be 01 00 00 00       	mov    $0x1,%esi
  801c2b:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c30:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801c37:	00 00 00 
  801c3a:	ff d0                	callq  *%rax
}
  801c3c:	c9                   	leaveq 
  801c3d:	c3                   	retq   

0000000000801c3e <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801c3e:	55                   	push   %rbp
  801c3f:	48 89 e5             	mov    %rsp,%rbp
  801c42:	48 83 ec 20          	sub    $0x20,%rsp
  801c46:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c4a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801c4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c52:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c5d:	00 
  801c5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c6a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c6f:	89 c6                	mov    %eax,%esi
  801c71:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c76:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801c7d:	00 00 00 
  801c80:	ff d0                	callq  *%rax
}
  801c82:	c9                   	leaveq 
  801c83:	c3                   	retq   

0000000000801c84 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801c84:	55                   	push   %rbp
  801c85:	48 89 e5             	mov    %rsp,%rbp
  801c88:	48 83 ec 20          	sub    $0x20,%rsp
  801c8c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c90:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801c94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c98:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c9c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca3:	00 
  801ca4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801caa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cb0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cb5:	89 c6                	mov    %eax,%esi
  801cb7:	bf 10 00 00 00       	mov    $0x10,%edi
  801cbc:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801cc3:	00 00 00 
  801cc6:	ff d0                	callq  *%rax
}
  801cc8:	c9                   	leaveq 
  801cc9:	c3                   	retq   

0000000000801cca <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801cca:	55                   	push   %rbp
  801ccb:	48 89 e5             	mov    %rsp,%rbp
  801cce:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801cd2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cd9:	00 
  801cda:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ceb:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf0:	be 00 00 00 00       	mov    $0x0,%esi
  801cf5:	bf 0e 00 00 00       	mov    $0xe,%edi
  801cfa:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801d01:	00 00 00 
  801d04:	ff d0                	callq  *%rax
}
  801d06:	c9                   	leaveq 
  801d07:	c3                   	retq   

0000000000801d08 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d08:	55                   	push   %rbp
  801d09:	48 89 e5             	mov    %rsp,%rbp
  801d0c:	48 83 ec 08          	sub    $0x8,%rsp
  801d10:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d14:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d18:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d1f:	ff ff ff 
  801d22:	48 01 d0             	add    %rdx,%rax
  801d25:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d29:	c9                   	leaveq 
  801d2a:	c3                   	retq   

0000000000801d2b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d2b:	55                   	push   %rbp
  801d2c:	48 89 e5             	mov    %rsp,%rbp
  801d2f:	48 83 ec 08          	sub    $0x8,%rsp
  801d33:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d3b:	48 89 c7             	mov    %rax,%rdi
  801d3e:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  801d45:	00 00 00 
  801d48:	ff d0                	callq  *%rax
  801d4a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d50:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d54:	c9                   	leaveq 
  801d55:	c3                   	retq   

0000000000801d56 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d56:	55                   	push   %rbp
  801d57:	48 89 e5             	mov    %rsp,%rbp
  801d5a:	48 83 ec 18          	sub    $0x18,%rsp
  801d5e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d69:	eb 6b                	jmp    801dd6 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d6e:	48 98                	cltq   
  801d70:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d76:	48 c1 e0 0c          	shl    $0xc,%rax
  801d7a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d82:	48 c1 e8 15          	shr    $0x15,%rax
  801d86:	48 89 c2             	mov    %rax,%rdx
  801d89:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d90:	01 00 00 
  801d93:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d97:	83 e0 01             	and    $0x1,%eax
  801d9a:	48 85 c0             	test   %rax,%rax
  801d9d:	74 21                	je     801dc0 <fd_alloc+0x6a>
  801d9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801da3:	48 c1 e8 0c          	shr    $0xc,%rax
  801da7:	48 89 c2             	mov    %rax,%rdx
  801daa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801db1:	01 00 00 
  801db4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801db8:	83 e0 01             	and    $0x1,%eax
  801dbb:	48 85 c0             	test   %rax,%rax
  801dbe:	75 12                	jne    801dd2 <fd_alloc+0x7c>
			*fd_store = fd;
  801dc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dc4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dc8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801dcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd0:	eb 1a                	jmp    801dec <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801dd2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dd6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801dda:	7e 8f                	jle    801d6b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801ddc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801de7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801dec:	c9                   	leaveq 
  801ded:	c3                   	retq   

0000000000801dee <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801dee:	55                   	push   %rbp
  801def:	48 89 e5             	mov    %rsp,%rbp
  801df2:	48 83 ec 20          	sub    $0x20,%rsp
  801df6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801df9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801dfd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e01:	78 06                	js     801e09 <fd_lookup+0x1b>
  801e03:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e07:	7e 07                	jle    801e10 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e09:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e0e:	eb 6c                	jmp    801e7c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e10:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e13:	48 98                	cltq   
  801e15:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e1b:	48 c1 e0 0c          	shl    $0xc,%rax
  801e1f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e27:	48 c1 e8 15          	shr    $0x15,%rax
  801e2b:	48 89 c2             	mov    %rax,%rdx
  801e2e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e35:	01 00 00 
  801e38:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e3c:	83 e0 01             	and    $0x1,%eax
  801e3f:	48 85 c0             	test   %rax,%rax
  801e42:	74 21                	je     801e65 <fd_lookup+0x77>
  801e44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e48:	48 c1 e8 0c          	shr    $0xc,%rax
  801e4c:	48 89 c2             	mov    %rax,%rdx
  801e4f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e56:	01 00 00 
  801e59:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e5d:	83 e0 01             	and    $0x1,%eax
  801e60:	48 85 c0             	test   %rax,%rax
  801e63:	75 07                	jne    801e6c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e65:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e6a:	eb 10                	jmp    801e7c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e70:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e74:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7c:	c9                   	leaveq 
  801e7d:	c3                   	retq   

0000000000801e7e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e7e:	55                   	push   %rbp
  801e7f:	48 89 e5             	mov    %rsp,%rbp
  801e82:	48 83 ec 30          	sub    $0x30,%rsp
  801e86:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e8a:	89 f0                	mov    %esi,%eax
  801e8c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e8f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e93:	48 89 c7             	mov    %rax,%rdi
  801e96:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  801e9d:	00 00 00 
  801ea0:	ff d0                	callq  *%rax
  801ea2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ea6:	48 89 d6             	mov    %rdx,%rsi
  801ea9:	89 c7                	mov    %eax,%edi
  801eab:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  801eb2:	00 00 00 
  801eb5:	ff d0                	callq  *%rax
  801eb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801eba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ebe:	78 0a                	js     801eca <fd_close+0x4c>
	    || fd != fd2)
  801ec0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ec4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801ec8:	74 12                	je     801edc <fd_close+0x5e>
		return (must_exist ? r : 0);
  801eca:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801ece:	74 05                	je     801ed5 <fd_close+0x57>
  801ed0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ed3:	eb 05                	jmp    801eda <fd_close+0x5c>
  801ed5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eda:	eb 69                	jmp    801f45 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801edc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee0:	8b 00                	mov    (%rax),%eax
  801ee2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ee6:	48 89 d6             	mov    %rdx,%rsi
  801ee9:	89 c7                	mov    %eax,%edi
  801eeb:	48 b8 47 1f 80 00 00 	movabs $0x801f47,%rax
  801ef2:	00 00 00 
  801ef5:	ff d0                	callq  *%rax
  801ef7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801efa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801efe:	78 2a                	js     801f2a <fd_close+0xac>
		if (dev->dev_close)
  801f00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f04:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f08:	48 85 c0             	test   %rax,%rax
  801f0b:	74 16                	je     801f23 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f11:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f15:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f19:	48 89 d7             	mov    %rdx,%rdi
  801f1c:	ff d0                	callq  *%rax
  801f1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f21:	eb 07                	jmp    801f2a <fd_close+0xac>
		else
			r = 0;
  801f23:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f2e:	48 89 c6             	mov    %rax,%rsi
  801f31:	bf 00 00 00 00       	mov    $0x0,%edi
  801f36:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  801f3d:	00 00 00 
  801f40:	ff d0                	callq  *%rax
	return r;
  801f42:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f45:	c9                   	leaveq 
  801f46:	c3                   	retq   

0000000000801f47 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f47:	55                   	push   %rbp
  801f48:	48 89 e5             	mov    %rsp,%rbp
  801f4b:	48 83 ec 20          	sub    $0x20,%rsp
  801f4f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f52:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f5d:	eb 41                	jmp    801fa0 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f5f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f66:	00 00 00 
  801f69:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f6c:	48 63 d2             	movslq %edx,%rdx
  801f6f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f73:	8b 00                	mov    (%rax),%eax
  801f75:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f78:	75 22                	jne    801f9c <dev_lookup+0x55>
			*dev = devtab[i];
  801f7a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f81:	00 00 00 
  801f84:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f87:	48 63 d2             	movslq %edx,%rdx
  801f8a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f8e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f92:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f95:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9a:	eb 60                	jmp    801ffc <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801f9c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fa0:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fa7:	00 00 00 
  801faa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fad:	48 63 d2             	movslq %edx,%rdx
  801fb0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fb4:	48 85 c0             	test   %rax,%rax
  801fb7:	75 a6                	jne    801f5f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801fb9:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801fc0:	00 00 00 
  801fc3:	48 8b 00             	mov    (%rax),%rax
  801fc6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801fcc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fcf:	89 c6                	mov    %eax,%esi
  801fd1:	48 bf f8 4b 80 00 00 	movabs $0x804bf8,%rdi
  801fd8:	00 00 00 
  801fdb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe0:	48 b9 ed 04 80 00 00 	movabs $0x8004ed,%rcx
  801fe7:	00 00 00 
  801fea:	ff d1                	callq  *%rcx
	*dev = 0;
  801fec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ff0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801ff7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801ffc:	c9                   	leaveq 
  801ffd:	c3                   	retq   

0000000000801ffe <close>:

int
close(int fdnum)
{
  801ffe:	55                   	push   %rbp
  801fff:	48 89 e5             	mov    %rsp,%rbp
  802002:	48 83 ec 20          	sub    $0x20,%rsp
  802006:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802009:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80200d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802010:	48 89 d6             	mov    %rdx,%rsi
  802013:	89 c7                	mov    %eax,%edi
  802015:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  80201c:	00 00 00 
  80201f:	ff d0                	callq  *%rax
  802021:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802024:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802028:	79 05                	jns    80202f <close+0x31>
		return r;
  80202a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80202d:	eb 18                	jmp    802047 <close+0x49>
	else
		return fd_close(fd, 1);
  80202f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802033:	be 01 00 00 00       	mov    $0x1,%esi
  802038:	48 89 c7             	mov    %rax,%rdi
  80203b:	48 b8 7e 1e 80 00 00 	movabs $0x801e7e,%rax
  802042:	00 00 00 
  802045:	ff d0                	callq  *%rax
}
  802047:	c9                   	leaveq 
  802048:	c3                   	retq   

0000000000802049 <close_all>:

void
close_all(void)
{
  802049:	55                   	push   %rbp
  80204a:	48 89 e5             	mov    %rsp,%rbp
  80204d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802051:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802058:	eb 15                	jmp    80206f <close_all+0x26>
		close(i);
  80205a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80205d:	89 c7                	mov    %eax,%edi
  80205f:	48 b8 fe 1f 80 00 00 	movabs $0x801ffe,%rax
  802066:	00 00 00 
  802069:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80206b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80206f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802073:	7e e5                	jle    80205a <close_all+0x11>
		close(i);
}
  802075:	c9                   	leaveq 
  802076:	c3                   	retq   

0000000000802077 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802077:	55                   	push   %rbp
  802078:	48 89 e5             	mov    %rsp,%rbp
  80207b:	48 83 ec 40          	sub    $0x40,%rsp
  80207f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802082:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802085:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802089:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80208c:	48 89 d6             	mov    %rdx,%rsi
  80208f:	89 c7                	mov    %eax,%edi
  802091:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  802098:	00 00 00 
  80209b:	ff d0                	callq  *%rax
  80209d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020a4:	79 08                	jns    8020ae <dup+0x37>
		return r;
  8020a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020a9:	e9 70 01 00 00       	jmpq   80221e <dup+0x1a7>
	close(newfdnum);
  8020ae:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020b1:	89 c7                	mov    %eax,%edi
  8020b3:	48 b8 fe 1f 80 00 00 	movabs $0x801ffe,%rax
  8020ba:	00 00 00 
  8020bd:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8020bf:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020c2:	48 98                	cltq   
  8020c4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020ca:	48 c1 e0 0c          	shl    $0xc,%rax
  8020ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8020d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020d6:	48 89 c7             	mov    %rax,%rdi
  8020d9:	48 b8 2b 1d 80 00 00 	movabs $0x801d2b,%rax
  8020e0:	00 00 00 
  8020e3:	ff d0                	callq  *%rax
  8020e5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8020e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020ed:	48 89 c7             	mov    %rax,%rdi
  8020f0:	48 b8 2b 1d 80 00 00 	movabs $0x801d2b,%rax
  8020f7:	00 00 00 
  8020fa:	ff d0                	callq  *%rax
  8020fc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802100:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802104:	48 c1 e8 15          	shr    $0x15,%rax
  802108:	48 89 c2             	mov    %rax,%rdx
  80210b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802112:	01 00 00 
  802115:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802119:	83 e0 01             	and    $0x1,%eax
  80211c:	48 85 c0             	test   %rax,%rax
  80211f:	74 73                	je     802194 <dup+0x11d>
  802121:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802125:	48 c1 e8 0c          	shr    $0xc,%rax
  802129:	48 89 c2             	mov    %rax,%rdx
  80212c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802133:	01 00 00 
  802136:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80213a:	83 e0 01             	and    $0x1,%eax
  80213d:	48 85 c0             	test   %rax,%rax
  802140:	74 52                	je     802194 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802142:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802146:	48 c1 e8 0c          	shr    $0xc,%rax
  80214a:	48 89 c2             	mov    %rax,%rdx
  80214d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802154:	01 00 00 
  802157:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80215b:	25 07 0e 00 00       	and    $0xe07,%eax
  802160:	89 c1                	mov    %eax,%ecx
  802162:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802166:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80216a:	41 89 c8             	mov    %ecx,%r8d
  80216d:	48 89 d1             	mov    %rdx,%rcx
  802170:	ba 00 00 00 00       	mov    $0x0,%edx
  802175:	48 89 c6             	mov    %rax,%rsi
  802178:	bf 00 00 00 00       	mov    $0x0,%edi
  80217d:	48 b8 21 1a 80 00 00 	movabs $0x801a21,%rax
  802184:	00 00 00 
  802187:	ff d0                	callq  *%rax
  802189:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80218c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802190:	79 02                	jns    802194 <dup+0x11d>
			goto err;
  802192:	eb 57                	jmp    8021eb <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802194:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802198:	48 c1 e8 0c          	shr    $0xc,%rax
  80219c:	48 89 c2             	mov    %rax,%rdx
  80219f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021a6:	01 00 00 
  8021a9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021ad:	25 07 0e 00 00       	and    $0xe07,%eax
  8021b2:	89 c1                	mov    %eax,%ecx
  8021b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021bc:	41 89 c8             	mov    %ecx,%r8d
  8021bf:	48 89 d1             	mov    %rdx,%rcx
  8021c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8021c7:	48 89 c6             	mov    %rax,%rsi
  8021ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8021cf:	48 b8 21 1a 80 00 00 	movabs $0x801a21,%rax
  8021d6:	00 00 00 
  8021d9:	ff d0                	callq  *%rax
  8021db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021e2:	79 02                	jns    8021e6 <dup+0x16f>
		goto err;
  8021e4:	eb 05                	jmp    8021eb <dup+0x174>

	return newfdnum;
  8021e6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021e9:	eb 33                	jmp    80221e <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8021eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021ef:	48 89 c6             	mov    %rax,%rsi
  8021f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8021f7:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  8021fe:	00 00 00 
  802201:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802203:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802207:	48 89 c6             	mov    %rax,%rsi
  80220a:	bf 00 00 00 00       	mov    $0x0,%edi
  80220f:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  802216:	00 00 00 
  802219:	ff d0                	callq  *%rax
	return r;
  80221b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80221e:	c9                   	leaveq 
  80221f:	c3                   	retq   

0000000000802220 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802220:	55                   	push   %rbp
  802221:	48 89 e5             	mov    %rsp,%rbp
  802224:	48 83 ec 40          	sub    $0x40,%rsp
  802228:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80222b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80222f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802233:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802237:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80223a:	48 89 d6             	mov    %rdx,%rsi
  80223d:	89 c7                	mov    %eax,%edi
  80223f:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  802246:	00 00 00 
  802249:	ff d0                	callq  *%rax
  80224b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80224e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802252:	78 24                	js     802278 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802254:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802258:	8b 00                	mov    (%rax),%eax
  80225a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80225e:	48 89 d6             	mov    %rdx,%rsi
  802261:	89 c7                	mov    %eax,%edi
  802263:	48 b8 47 1f 80 00 00 	movabs $0x801f47,%rax
  80226a:	00 00 00 
  80226d:	ff d0                	callq  *%rax
  80226f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802272:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802276:	79 05                	jns    80227d <read+0x5d>
		return r;
  802278:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80227b:	eb 76                	jmp    8022f3 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80227d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802281:	8b 40 08             	mov    0x8(%rax),%eax
  802284:	83 e0 03             	and    $0x3,%eax
  802287:	83 f8 01             	cmp    $0x1,%eax
  80228a:	75 3a                	jne    8022c6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80228c:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802293:	00 00 00 
  802296:	48 8b 00             	mov    (%rax),%rax
  802299:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80229f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022a2:	89 c6                	mov    %eax,%esi
  8022a4:	48 bf 17 4c 80 00 00 	movabs $0x804c17,%rdi
  8022ab:	00 00 00 
  8022ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b3:	48 b9 ed 04 80 00 00 	movabs $0x8004ed,%rcx
  8022ba:	00 00 00 
  8022bd:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022c4:	eb 2d                	jmp    8022f3 <read+0xd3>
	}
	if (!dev->dev_read)
  8022c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ca:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022ce:	48 85 c0             	test   %rax,%rax
  8022d1:	75 07                	jne    8022da <read+0xba>
		return -E_NOT_SUPP;
  8022d3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022d8:	eb 19                	jmp    8022f3 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8022da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022de:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022e2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022e6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8022ea:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022ee:	48 89 cf             	mov    %rcx,%rdi
  8022f1:	ff d0                	callq  *%rax
}
  8022f3:	c9                   	leaveq 
  8022f4:	c3                   	retq   

00000000008022f5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8022f5:	55                   	push   %rbp
  8022f6:	48 89 e5             	mov    %rsp,%rbp
  8022f9:	48 83 ec 30          	sub    $0x30,%rsp
  8022fd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802300:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802304:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802308:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80230f:	eb 49                	jmp    80235a <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802311:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802314:	48 98                	cltq   
  802316:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80231a:	48 29 c2             	sub    %rax,%rdx
  80231d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802320:	48 63 c8             	movslq %eax,%rcx
  802323:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802327:	48 01 c1             	add    %rax,%rcx
  80232a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80232d:	48 89 ce             	mov    %rcx,%rsi
  802330:	89 c7                	mov    %eax,%edi
  802332:	48 b8 20 22 80 00 00 	movabs $0x802220,%rax
  802339:	00 00 00 
  80233c:	ff d0                	callq  *%rax
  80233e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802341:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802345:	79 05                	jns    80234c <readn+0x57>
			return m;
  802347:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80234a:	eb 1c                	jmp    802368 <readn+0x73>
		if (m == 0)
  80234c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802350:	75 02                	jne    802354 <readn+0x5f>
			break;
  802352:	eb 11                	jmp    802365 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802354:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802357:	01 45 fc             	add    %eax,-0x4(%rbp)
  80235a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80235d:	48 98                	cltq   
  80235f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802363:	72 ac                	jb     802311 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802365:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802368:	c9                   	leaveq 
  802369:	c3                   	retq   

000000000080236a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80236a:	55                   	push   %rbp
  80236b:	48 89 e5             	mov    %rsp,%rbp
  80236e:	48 83 ec 40          	sub    $0x40,%rsp
  802372:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802375:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802379:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80237d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802381:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802384:	48 89 d6             	mov    %rdx,%rsi
  802387:	89 c7                	mov    %eax,%edi
  802389:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  802390:	00 00 00 
  802393:	ff d0                	callq  *%rax
  802395:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802398:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80239c:	78 24                	js     8023c2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80239e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023a2:	8b 00                	mov    (%rax),%eax
  8023a4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023a8:	48 89 d6             	mov    %rdx,%rsi
  8023ab:	89 c7                	mov    %eax,%edi
  8023ad:	48 b8 47 1f 80 00 00 	movabs $0x801f47,%rax
  8023b4:	00 00 00 
  8023b7:	ff d0                	callq  *%rax
  8023b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c0:	79 05                	jns    8023c7 <write+0x5d>
		return r;
  8023c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023c5:	eb 75                	jmp    80243c <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023cb:	8b 40 08             	mov    0x8(%rax),%eax
  8023ce:	83 e0 03             	and    $0x3,%eax
  8023d1:	85 c0                	test   %eax,%eax
  8023d3:	75 3a                	jne    80240f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8023d5:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8023dc:	00 00 00 
  8023df:	48 8b 00             	mov    (%rax),%rax
  8023e2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023e8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023eb:	89 c6                	mov    %eax,%esi
  8023ed:	48 bf 33 4c 80 00 00 	movabs $0x804c33,%rdi
  8023f4:	00 00 00 
  8023f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fc:	48 b9 ed 04 80 00 00 	movabs $0x8004ed,%rcx
  802403:	00 00 00 
  802406:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802408:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80240d:	eb 2d                	jmp    80243c <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  80240f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802413:	48 8b 40 18          	mov    0x18(%rax),%rax
  802417:	48 85 c0             	test   %rax,%rax
  80241a:	75 07                	jne    802423 <write+0xb9>
		return -E_NOT_SUPP;
  80241c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802421:	eb 19                	jmp    80243c <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802423:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802427:	48 8b 40 18          	mov    0x18(%rax),%rax
  80242b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80242f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802433:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802437:	48 89 cf             	mov    %rcx,%rdi
  80243a:	ff d0                	callq  *%rax
}
  80243c:	c9                   	leaveq 
  80243d:	c3                   	retq   

000000000080243e <seek>:

int
seek(int fdnum, off_t offset)
{
  80243e:	55                   	push   %rbp
  80243f:	48 89 e5             	mov    %rsp,%rbp
  802442:	48 83 ec 18          	sub    $0x18,%rsp
  802446:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802449:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80244c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802450:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802453:	48 89 d6             	mov    %rdx,%rsi
  802456:	89 c7                	mov    %eax,%edi
  802458:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  80245f:	00 00 00 
  802462:	ff d0                	callq  *%rax
  802464:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802467:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80246b:	79 05                	jns    802472 <seek+0x34>
		return r;
  80246d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802470:	eb 0f                	jmp    802481 <seek+0x43>
	fd->fd_offset = offset;
  802472:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802476:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802479:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80247c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802481:	c9                   	leaveq 
  802482:	c3                   	retq   

0000000000802483 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802483:	55                   	push   %rbp
  802484:	48 89 e5             	mov    %rsp,%rbp
  802487:	48 83 ec 30          	sub    $0x30,%rsp
  80248b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80248e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802491:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802495:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802498:	48 89 d6             	mov    %rdx,%rsi
  80249b:	89 c7                	mov    %eax,%edi
  80249d:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  8024a4:	00 00 00 
  8024a7:	ff d0                	callq  *%rax
  8024a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b0:	78 24                	js     8024d6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024b6:	8b 00                	mov    (%rax),%eax
  8024b8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024bc:	48 89 d6             	mov    %rdx,%rsi
  8024bf:	89 c7                	mov    %eax,%edi
  8024c1:	48 b8 47 1f 80 00 00 	movabs $0x801f47,%rax
  8024c8:	00 00 00 
  8024cb:	ff d0                	callq  *%rax
  8024cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024d4:	79 05                	jns    8024db <ftruncate+0x58>
		return r;
  8024d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024d9:	eb 72                	jmp    80254d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024df:	8b 40 08             	mov    0x8(%rax),%eax
  8024e2:	83 e0 03             	and    $0x3,%eax
  8024e5:	85 c0                	test   %eax,%eax
  8024e7:	75 3a                	jne    802523 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8024e9:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8024f0:	00 00 00 
  8024f3:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8024f6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024fc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024ff:	89 c6                	mov    %eax,%esi
  802501:	48 bf 50 4c 80 00 00 	movabs $0x804c50,%rdi
  802508:	00 00 00 
  80250b:	b8 00 00 00 00       	mov    $0x0,%eax
  802510:	48 b9 ed 04 80 00 00 	movabs $0x8004ed,%rcx
  802517:	00 00 00 
  80251a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80251c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802521:	eb 2a                	jmp    80254d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802523:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802527:	48 8b 40 30          	mov    0x30(%rax),%rax
  80252b:	48 85 c0             	test   %rax,%rax
  80252e:	75 07                	jne    802537 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802530:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802535:	eb 16                	jmp    80254d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802537:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80253b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80253f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802543:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802546:	89 ce                	mov    %ecx,%esi
  802548:	48 89 d7             	mov    %rdx,%rdi
  80254b:	ff d0                	callq  *%rax
}
  80254d:	c9                   	leaveq 
  80254e:	c3                   	retq   

000000000080254f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80254f:	55                   	push   %rbp
  802550:	48 89 e5             	mov    %rsp,%rbp
  802553:	48 83 ec 30          	sub    $0x30,%rsp
  802557:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80255a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80255e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802562:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802565:	48 89 d6             	mov    %rdx,%rsi
  802568:	89 c7                	mov    %eax,%edi
  80256a:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  802571:	00 00 00 
  802574:	ff d0                	callq  *%rax
  802576:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802579:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80257d:	78 24                	js     8025a3 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80257f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802583:	8b 00                	mov    (%rax),%eax
  802585:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802589:	48 89 d6             	mov    %rdx,%rsi
  80258c:	89 c7                	mov    %eax,%edi
  80258e:	48 b8 47 1f 80 00 00 	movabs $0x801f47,%rax
  802595:	00 00 00 
  802598:	ff d0                	callq  *%rax
  80259a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80259d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a1:	79 05                	jns    8025a8 <fstat+0x59>
		return r;
  8025a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a6:	eb 5e                	jmp    802606 <fstat+0xb7>
	if (!dev->dev_stat)
  8025a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ac:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025b0:	48 85 c0             	test   %rax,%rax
  8025b3:	75 07                	jne    8025bc <fstat+0x6d>
		return -E_NOT_SUPP;
  8025b5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025ba:	eb 4a                	jmp    802606 <fstat+0xb7>
	stat->st_name[0] = 0;
  8025bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025c0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8025c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025c7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8025ce:	00 00 00 
	stat->st_isdir = 0;
  8025d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025d5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8025dc:	00 00 00 
	stat->st_dev = dev;
  8025df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025e7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8025ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f2:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025fa:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8025fe:	48 89 ce             	mov    %rcx,%rsi
  802601:	48 89 d7             	mov    %rdx,%rdi
  802604:	ff d0                	callq  *%rax
}
  802606:	c9                   	leaveq 
  802607:	c3                   	retq   

0000000000802608 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802608:	55                   	push   %rbp
  802609:	48 89 e5             	mov    %rsp,%rbp
  80260c:	48 83 ec 20          	sub    $0x20,%rsp
  802610:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802614:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802618:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80261c:	be 00 00 00 00       	mov    $0x0,%esi
  802621:	48 89 c7             	mov    %rax,%rdi
  802624:	48 b8 f6 26 80 00 00 	movabs $0x8026f6,%rax
  80262b:	00 00 00 
  80262e:	ff d0                	callq  *%rax
  802630:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802633:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802637:	79 05                	jns    80263e <stat+0x36>
		return fd;
  802639:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80263c:	eb 2f                	jmp    80266d <stat+0x65>
	r = fstat(fd, stat);
  80263e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802642:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802645:	48 89 d6             	mov    %rdx,%rsi
  802648:	89 c7                	mov    %eax,%edi
  80264a:	48 b8 4f 25 80 00 00 	movabs $0x80254f,%rax
  802651:	00 00 00 
  802654:	ff d0                	callq  *%rax
  802656:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802659:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80265c:	89 c7                	mov    %eax,%edi
  80265e:	48 b8 fe 1f 80 00 00 	movabs $0x801ffe,%rax
  802665:	00 00 00 
  802668:	ff d0                	callq  *%rax
	return r;
  80266a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80266d:	c9                   	leaveq 
  80266e:	c3                   	retq   

000000000080266f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80266f:	55                   	push   %rbp
  802670:	48 89 e5             	mov    %rsp,%rbp
  802673:	48 83 ec 10          	sub    $0x10,%rsp
  802677:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80267a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80267e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802685:	00 00 00 
  802688:	8b 00                	mov    (%rax),%eax
  80268a:	85 c0                	test   %eax,%eax
  80268c:	75 1d                	jne    8026ab <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80268e:	bf 01 00 00 00       	mov    $0x1,%edi
  802693:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  80269a:	00 00 00 
  80269d:	ff d0                	callq  *%rax
  80269f:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8026a6:	00 00 00 
  8026a9:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8026ab:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026b2:	00 00 00 
  8026b5:	8b 00                	mov    (%rax),%eax
  8026b7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026ba:	b9 07 00 00 00       	mov    $0x7,%ecx
  8026bf:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8026c6:	00 00 00 
  8026c9:	89 c7                	mov    %eax,%edi
  8026cb:	48 b8 ae 3f 80 00 00 	movabs $0x803fae,%rax
  8026d2:	00 00 00 
  8026d5:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8026d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026db:	ba 00 00 00 00       	mov    $0x0,%edx
  8026e0:	48 89 c6             	mov    %rax,%rsi
  8026e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8026e8:	48 b8 a8 3e 80 00 00 	movabs $0x803ea8,%rax
  8026ef:	00 00 00 
  8026f2:	ff d0                	callq  *%rax
}
  8026f4:	c9                   	leaveq 
  8026f5:	c3                   	retq   

00000000008026f6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8026f6:	55                   	push   %rbp
  8026f7:	48 89 e5             	mov    %rsp,%rbp
  8026fa:	48 83 ec 30          	sub    $0x30,%rsp
  8026fe:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802702:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802705:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80270c:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802713:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80271a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80271f:	75 08                	jne    802729 <open+0x33>
	{
		return r;
  802721:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802724:	e9 f2 00 00 00       	jmpq   80281b <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802729:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80272d:	48 89 c7             	mov    %rax,%rdi
  802730:	48 b8 36 10 80 00 00 	movabs $0x801036,%rax
  802737:	00 00 00 
  80273a:	ff d0                	callq  *%rax
  80273c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80273f:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802746:	7e 0a                	jle    802752 <open+0x5c>
	{
		return -E_BAD_PATH;
  802748:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80274d:	e9 c9 00 00 00       	jmpq   80281b <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802752:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802759:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80275a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80275e:	48 89 c7             	mov    %rax,%rdi
  802761:	48 b8 56 1d 80 00 00 	movabs $0x801d56,%rax
  802768:	00 00 00 
  80276b:	ff d0                	callq  *%rax
  80276d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802770:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802774:	78 09                	js     80277f <open+0x89>
  802776:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80277a:	48 85 c0             	test   %rax,%rax
  80277d:	75 08                	jne    802787 <open+0x91>
		{
			return r;
  80277f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802782:	e9 94 00 00 00       	jmpq   80281b <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802787:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80278b:	ba 00 04 00 00       	mov    $0x400,%edx
  802790:	48 89 c6             	mov    %rax,%rsi
  802793:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80279a:	00 00 00 
  80279d:	48 b8 34 11 80 00 00 	movabs $0x801134,%rax
  8027a4:	00 00 00 
  8027a7:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8027a9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027b0:	00 00 00 
  8027b3:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8027b6:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8027bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c0:	48 89 c6             	mov    %rax,%rsi
  8027c3:	bf 01 00 00 00       	mov    $0x1,%edi
  8027c8:	48 b8 6f 26 80 00 00 	movabs $0x80266f,%rax
  8027cf:	00 00 00 
  8027d2:	ff d0                	callq  *%rax
  8027d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027db:	79 2b                	jns    802808 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8027dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e1:	be 00 00 00 00       	mov    $0x0,%esi
  8027e6:	48 89 c7             	mov    %rax,%rdi
  8027e9:	48 b8 7e 1e 80 00 00 	movabs $0x801e7e,%rax
  8027f0:	00 00 00 
  8027f3:	ff d0                	callq  *%rax
  8027f5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8027f8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027fc:	79 05                	jns    802803 <open+0x10d>
			{
				return d;
  8027fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802801:	eb 18                	jmp    80281b <open+0x125>
			}
			return r;
  802803:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802806:	eb 13                	jmp    80281b <open+0x125>
		}	
		return fd2num(fd_store);
  802808:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80280c:	48 89 c7             	mov    %rax,%rdi
  80280f:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  802816:	00 00 00 
  802819:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80281b:	c9                   	leaveq 
  80281c:	c3                   	retq   

000000000080281d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80281d:	55                   	push   %rbp
  80281e:	48 89 e5             	mov    %rsp,%rbp
  802821:	48 83 ec 10          	sub    $0x10,%rsp
  802825:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802829:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80282d:	8b 50 0c             	mov    0xc(%rax),%edx
  802830:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802837:	00 00 00 
  80283a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80283c:	be 00 00 00 00       	mov    $0x0,%esi
  802841:	bf 06 00 00 00       	mov    $0x6,%edi
  802846:	48 b8 6f 26 80 00 00 	movabs $0x80266f,%rax
  80284d:	00 00 00 
  802850:	ff d0                	callq  *%rax
}
  802852:	c9                   	leaveq 
  802853:	c3                   	retq   

0000000000802854 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802854:	55                   	push   %rbp
  802855:	48 89 e5             	mov    %rsp,%rbp
  802858:	48 83 ec 30          	sub    $0x30,%rsp
  80285c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802860:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802864:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802868:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80286f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802874:	74 07                	je     80287d <devfile_read+0x29>
  802876:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80287b:	75 07                	jne    802884 <devfile_read+0x30>
		return -E_INVAL;
  80287d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802882:	eb 77                	jmp    8028fb <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802884:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802888:	8b 50 0c             	mov    0xc(%rax),%edx
  80288b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802892:	00 00 00 
  802895:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802897:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80289e:	00 00 00 
  8028a1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028a5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8028a9:	be 00 00 00 00       	mov    $0x0,%esi
  8028ae:	bf 03 00 00 00       	mov    $0x3,%edi
  8028b3:	48 b8 6f 26 80 00 00 	movabs $0x80266f,%rax
  8028ba:	00 00 00 
  8028bd:	ff d0                	callq  *%rax
  8028bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028c6:	7f 05                	jg     8028cd <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8028c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028cb:	eb 2e                	jmp    8028fb <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8028cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d0:	48 63 d0             	movslq %eax,%rdx
  8028d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028d7:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8028de:	00 00 00 
  8028e1:	48 89 c7             	mov    %rax,%rdi
  8028e4:	48 b8 c6 13 80 00 00 	movabs $0x8013c6,%rax
  8028eb:	00 00 00 
  8028ee:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8028f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028f4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8028f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8028fb:	c9                   	leaveq 
  8028fc:	c3                   	retq   

00000000008028fd <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8028fd:	55                   	push   %rbp
  8028fe:	48 89 e5             	mov    %rsp,%rbp
  802901:	48 83 ec 30          	sub    $0x30,%rsp
  802905:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802909:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80290d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802911:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802918:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80291d:	74 07                	je     802926 <devfile_write+0x29>
  80291f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802924:	75 08                	jne    80292e <devfile_write+0x31>
		return r;
  802926:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802929:	e9 9a 00 00 00       	jmpq   8029c8 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80292e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802932:	8b 50 0c             	mov    0xc(%rax),%edx
  802935:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80293c:	00 00 00 
  80293f:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802941:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802948:	00 
  802949:	76 08                	jbe    802953 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80294b:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802952:	00 
	}
	fsipcbuf.write.req_n = n;
  802953:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80295a:	00 00 00 
  80295d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802961:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802965:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802969:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80296d:	48 89 c6             	mov    %rax,%rsi
  802970:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802977:	00 00 00 
  80297a:	48 b8 c6 13 80 00 00 	movabs $0x8013c6,%rax
  802981:	00 00 00 
  802984:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802986:	be 00 00 00 00       	mov    $0x0,%esi
  80298b:	bf 04 00 00 00       	mov    $0x4,%edi
  802990:	48 b8 6f 26 80 00 00 	movabs $0x80266f,%rax
  802997:	00 00 00 
  80299a:	ff d0                	callq  *%rax
  80299c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80299f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029a3:	7f 20                	jg     8029c5 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8029a5:	48 bf 76 4c 80 00 00 	movabs $0x804c76,%rdi
  8029ac:	00 00 00 
  8029af:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b4:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  8029bb:	00 00 00 
  8029be:	ff d2                	callq  *%rdx
		return r;
  8029c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c3:	eb 03                	jmp    8029c8 <devfile_write+0xcb>
	}
	return r;
  8029c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8029c8:	c9                   	leaveq 
  8029c9:	c3                   	retq   

00000000008029ca <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8029ca:	55                   	push   %rbp
  8029cb:	48 89 e5             	mov    %rsp,%rbp
  8029ce:	48 83 ec 20          	sub    $0x20,%rsp
  8029d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8029da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029de:	8b 50 0c             	mov    0xc(%rax),%edx
  8029e1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029e8:	00 00 00 
  8029eb:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8029ed:	be 00 00 00 00       	mov    $0x0,%esi
  8029f2:	bf 05 00 00 00       	mov    $0x5,%edi
  8029f7:	48 b8 6f 26 80 00 00 	movabs $0x80266f,%rax
  8029fe:	00 00 00 
  802a01:	ff d0                	callq  *%rax
  802a03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a0a:	79 05                	jns    802a11 <devfile_stat+0x47>
		return r;
  802a0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a0f:	eb 56                	jmp    802a67 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a11:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a15:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a1c:	00 00 00 
  802a1f:	48 89 c7             	mov    %rax,%rdi
  802a22:	48 b8 a2 10 80 00 00 	movabs $0x8010a2,%rax
  802a29:	00 00 00 
  802a2c:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a2e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a35:	00 00 00 
  802a38:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a3e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a42:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a48:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a4f:	00 00 00 
  802a52:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a58:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a5c:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a67:	c9                   	leaveq 
  802a68:	c3                   	retq   

0000000000802a69 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802a69:	55                   	push   %rbp
  802a6a:	48 89 e5             	mov    %rsp,%rbp
  802a6d:	48 83 ec 10          	sub    $0x10,%rsp
  802a71:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a75:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a7c:	8b 50 0c             	mov    0xc(%rax),%edx
  802a7f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a86:	00 00 00 
  802a89:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802a8b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a92:	00 00 00 
  802a95:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a98:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a9b:	be 00 00 00 00       	mov    $0x0,%esi
  802aa0:	bf 02 00 00 00       	mov    $0x2,%edi
  802aa5:	48 b8 6f 26 80 00 00 	movabs $0x80266f,%rax
  802aac:	00 00 00 
  802aaf:	ff d0                	callq  *%rax
}
  802ab1:	c9                   	leaveq 
  802ab2:	c3                   	retq   

0000000000802ab3 <remove>:

// Delete a file
int
remove(const char *path)
{
  802ab3:	55                   	push   %rbp
  802ab4:	48 89 e5             	mov    %rsp,%rbp
  802ab7:	48 83 ec 10          	sub    $0x10,%rsp
  802abb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802abf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ac3:	48 89 c7             	mov    %rax,%rdi
  802ac6:	48 b8 36 10 80 00 00 	movabs $0x801036,%rax
  802acd:	00 00 00 
  802ad0:	ff d0                	callq  *%rax
  802ad2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ad7:	7e 07                	jle    802ae0 <remove+0x2d>
		return -E_BAD_PATH;
  802ad9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ade:	eb 33                	jmp    802b13 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ae0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ae4:	48 89 c6             	mov    %rax,%rsi
  802ae7:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802aee:	00 00 00 
  802af1:	48 b8 a2 10 80 00 00 	movabs $0x8010a2,%rax
  802af8:	00 00 00 
  802afb:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802afd:	be 00 00 00 00       	mov    $0x0,%esi
  802b02:	bf 07 00 00 00       	mov    $0x7,%edi
  802b07:	48 b8 6f 26 80 00 00 	movabs $0x80266f,%rax
  802b0e:	00 00 00 
  802b11:	ff d0                	callq  *%rax
}
  802b13:	c9                   	leaveq 
  802b14:	c3                   	retq   

0000000000802b15 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b15:	55                   	push   %rbp
  802b16:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b19:	be 00 00 00 00       	mov    $0x0,%esi
  802b1e:	bf 08 00 00 00       	mov    $0x8,%edi
  802b23:	48 b8 6f 26 80 00 00 	movabs $0x80266f,%rax
  802b2a:	00 00 00 
  802b2d:	ff d0                	callq  *%rax
}
  802b2f:	5d                   	pop    %rbp
  802b30:	c3                   	retq   

0000000000802b31 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802b31:	55                   	push   %rbp
  802b32:	48 89 e5             	mov    %rsp,%rbp
  802b35:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802b3c:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802b43:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802b4a:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802b51:	be 00 00 00 00       	mov    $0x0,%esi
  802b56:	48 89 c7             	mov    %rax,%rdi
  802b59:	48 b8 f6 26 80 00 00 	movabs $0x8026f6,%rax
  802b60:	00 00 00 
  802b63:	ff d0                	callq  *%rax
  802b65:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802b68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b6c:	79 28                	jns    802b96 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802b6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b71:	89 c6                	mov    %eax,%esi
  802b73:	48 bf 92 4c 80 00 00 	movabs $0x804c92,%rdi
  802b7a:	00 00 00 
  802b7d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b82:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  802b89:	00 00 00 
  802b8c:	ff d2                	callq  *%rdx
		return fd_src;
  802b8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b91:	e9 74 01 00 00       	jmpq   802d0a <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802b96:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802b9d:	be 01 01 00 00       	mov    $0x101,%esi
  802ba2:	48 89 c7             	mov    %rax,%rdi
  802ba5:	48 b8 f6 26 80 00 00 	movabs $0x8026f6,%rax
  802bac:	00 00 00 
  802baf:	ff d0                	callq  *%rax
  802bb1:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802bb4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bb8:	79 39                	jns    802bf3 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802bba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bbd:	89 c6                	mov    %eax,%esi
  802bbf:	48 bf a8 4c 80 00 00 	movabs $0x804ca8,%rdi
  802bc6:	00 00 00 
  802bc9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bce:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  802bd5:	00 00 00 
  802bd8:	ff d2                	callq  *%rdx
		close(fd_src);
  802bda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bdd:	89 c7                	mov    %eax,%edi
  802bdf:	48 b8 fe 1f 80 00 00 	movabs $0x801ffe,%rax
  802be6:	00 00 00 
  802be9:	ff d0                	callq  *%rax
		return fd_dest;
  802beb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bee:	e9 17 01 00 00       	jmpq   802d0a <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802bf3:	eb 74                	jmp    802c69 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802bf5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802bf8:	48 63 d0             	movslq %eax,%rdx
  802bfb:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c02:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c05:	48 89 ce             	mov    %rcx,%rsi
  802c08:	89 c7                	mov    %eax,%edi
  802c0a:	48 b8 6a 23 80 00 00 	movabs $0x80236a,%rax
  802c11:	00 00 00 
  802c14:	ff d0                	callq  *%rax
  802c16:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802c19:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c1d:	79 4a                	jns    802c69 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802c1f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c22:	89 c6                	mov    %eax,%esi
  802c24:	48 bf c2 4c 80 00 00 	movabs $0x804cc2,%rdi
  802c2b:	00 00 00 
  802c2e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c33:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  802c3a:	00 00 00 
  802c3d:	ff d2                	callq  *%rdx
			close(fd_src);
  802c3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c42:	89 c7                	mov    %eax,%edi
  802c44:	48 b8 fe 1f 80 00 00 	movabs $0x801ffe,%rax
  802c4b:	00 00 00 
  802c4e:	ff d0                	callq  *%rax
			close(fd_dest);
  802c50:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c53:	89 c7                	mov    %eax,%edi
  802c55:	48 b8 fe 1f 80 00 00 	movabs $0x801ffe,%rax
  802c5c:	00 00 00 
  802c5f:	ff d0                	callq  *%rax
			return write_size;
  802c61:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c64:	e9 a1 00 00 00       	jmpq   802d0a <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c69:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c73:	ba 00 02 00 00       	mov    $0x200,%edx
  802c78:	48 89 ce             	mov    %rcx,%rsi
  802c7b:	89 c7                	mov    %eax,%edi
  802c7d:	48 b8 20 22 80 00 00 	movabs $0x802220,%rax
  802c84:	00 00 00 
  802c87:	ff d0                	callq  *%rax
  802c89:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802c8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c90:	0f 8f 5f ff ff ff    	jg     802bf5 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802c96:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c9a:	79 47                	jns    802ce3 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802c9c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c9f:	89 c6                	mov    %eax,%esi
  802ca1:	48 bf d5 4c 80 00 00 	movabs $0x804cd5,%rdi
  802ca8:	00 00 00 
  802cab:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb0:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  802cb7:	00 00 00 
  802cba:	ff d2                	callq  *%rdx
		close(fd_src);
  802cbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cbf:	89 c7                	mov    %eax,%edi
  802cc1:	48 b8 fe 1f 80 00 00 	movabs $0x801ffe,%rax
  802cc8:	00 00 00 
  802ccb:	ff d0                	callq  *%rax
		close(fd_dest);
  802ccd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cd0:	89 c7                	mov    %eax,%edi
  802cd2:	48 b8 fe 1f 80 00 00 	movabs $0x801ffe,%rax
  802cd9:	00 00 00 
  802cdc:	ff d0                	callq  *%rax
		return read_size;
  802cde:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ce1:	eb 27                	jmp    802d0a <copy+0x1d9>
	}
	close(fd_src);
  802ce3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce6:	89 c7                	mov    %eax,%edi
  802ce8:	48 b8 fe 1f 80 00 00 	movabs $0x801ffe,%rax
  802cef:	00 00 00 
  802cf2:	ff d0                	callq  *%rax
	close(fd_dest);
  802cf4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cf7:	89 c7                	mov    %eax,%edi
  802cf9:	48 b8 fe 1f 80 00 00 	movabs $0x801ffe,%rax
  802d00:	00 00 00 
  802d03:	ff d0                	callq  *%rax
	return 0;
  802d05:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802d0a:	c9                   	leaveq 
  802d0b:	c3                   	retq   

0000000000802d0c <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802d0c:	55                   	push   %rbp
  802d0d:	48 89 e5             	mov    %rsp,%rbp
  802d10:	48 83 ec 20          	sub    $0x20,%rsp
  802d14:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802d17:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d1b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d1e:	48 89 d6             	mov    %rdx,%rsi
  802d21:	89 c7                	mov    %eax,%edi
  802d23:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  802d2a:	00 00 00 
  802d2d:	ff d0                	callq  *%rax
  802d2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d36:	79 05                	jns    802d3d <fd2sockid+0x31>
		return r;
  802d38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d3b:	eb 24                	jmp    802d61 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802d3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d41:	8b 10                	mov    (%rax),%edx
  802d43:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802d4a:	00 00 00 
  802d4d:	8b 00                	mov    (%rax),%eax
  802d4f:	39 c2                	cmp    %eax,%edx
  802d51:	74 07                	je     802d5a <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802d53:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d58:	eb 07                	jmp    802d61 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802d5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d5e:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802d61:	c9                   	leaveq 
  802d62:	c3                   	retq   

0000000000802d63 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802d63:	55                   	push   %rbp
  802d64:	48 89 e5             	mov    %rsp,%rbp
  802d67:	48 83 ec 20          	sub    $0x20,%rsp
  802d6b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802d6e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d72:	48 89 c7             	mov    %rax,%rdi
  802d75:	48 b8 56 1d 80 00 00 	movabs $0x801d56,%rax
  802d7c:	00 00 00 
  802d7f:	ff d0                	callq  *%rax
  802d81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d88:	78 26                	js     802db0 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802d8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d8e:	ba 07 04 00 00       	mov    $0x407,%edx
  802d93:	48 89 c6             	mov    %rax,%rsi
  802d96:	bf 00 00 00 00       	mov    $0x0,%edi
  802d9b:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  802da2:	00 00 00 
  802da5:	ff d0                	callq  *%rax
  802da7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802daa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dae:	79 16                	jns    802dc6 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802db0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802db3:	89 c7                	mov    %eax,%edi
  802db5:	48 b8 70 32 80 00 00 	movabs $0x803270,%rax
  802dbc:	00 00 00 
  802dbf:	ff d0                	callq  *%rax
		return r;
  802dc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc4:	eb 3a                	jmp    802e00 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802dc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dca:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802dd1:	00 00 00 
  802dd4:	8b 12                	mov    (%rdx),%edx
  802dd6:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802dd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ddc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802de3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802dea:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802ded:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df1:	48 89 c7             	mov    %rax,%rdi
  802df4:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  802dfb:	00 00 00 
  802dfe:	ff d0                	callq  *%rax
}
  802e00:	c9                   	leaveq 
  802e01:	c3                   	retq   

0000000000802e02 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802e02:	55                   	push   %rbp
  802e03:	48 89 e5             	mov    %rsp,%rbp
  802e06:	48 83 ec 30          	sub    $0x30,%rsp
  802e0a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e0d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e11:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e15:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e18:	89 c7                	mov    %eax,%edi
  802e1a:	48 b8 0c 2d 80 00 00 	movabs $0x802d0c,%rax
  802e21:	00 00 00 
  802e24:	ff d0                	callq  *%rax
  802e26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e2d:	79 05                	jns    802e34 <accept+0x32>
		return r;
  802e2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e32:	eb 3b                	jmp    802e6f <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802e34:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e38:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802e3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e3f:	48 89 ce             	mov    %rcx,%rsi
  802e42:	89 c7                	mov    %eax,%edi
  802e44:	48 b8 4d 31 80 00 00 	movabs $0x80314d,%rax
  802e4b:	00 00 00 
  802e4e:	ff d0                	callq  *%rax
  802e50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e57:	79 05                	jns    802e5e <accept+0x5c>
		return r;
  802e59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e5c:	eb 11                	jmp    802e6f <accept+0x6d>
	return alloc_sockfd(r);
  802e5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e61:	89 c7                	mov    %eax,%edi
  802e63:	48 b8 63 2d 80 00 00 	movabs $0x802d63,%rax
  802e6a:	00 00 00 
  802e6d:	ff d0                	callq  *%rax
}
  802e6f:	c9                   	leaveq 
  802e70:	c3                   	retq   

0000000000802e71 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802e71:	55                   	push   %rbp
  802e72:	48 89 e5             	mov    %rsp,%rbp
  802e75:	48 83 ec 20          	sub    $0x20,%rsp
  802e79:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e7c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e80:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e83:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e86:	89 c7                	mov    %eax,%edi
  802e88:	48 b8 0c 2d 80 00 00 	movabs $0x802d0c,%rax
  802e8f:	00 00 00 
  802e92:	ff d0                	callq  *%rax
  802e94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e9b:	79 05                	jns    802ea2 <bind+0x31>
		return r;
  802e9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea0:	eb 1b                	jmp    802ebd <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802ea2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ea5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802ea9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eac:	48 89 ce             	mov    %rcx,%rsi
  802eaf:	89 c7                	mov    %eax,%edi
  802eb1:	48 b8 cc 31 80 00 00 	movabs $0x8031cc,%rax
  802eb8:	00 00 00 
  802ebb:	ff d0                	callq  *%rax
}
  802ebd:	c9                   	leaveq 
  802ebe:	c3                   	retq   

0000000000802ebf <shutdown>:

int
shutdown(int s, int how)
{
  802ebf:	55                   	push   %rbp
  802ec0:	48 89 e5             	mov    %rsp,%rbp
  802ec3:	48 83 ec 20          	sub    $0x20,%rsp
  802ec7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802eca:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ecd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ed0:	89 c7                	mov    %eax,%edi
  802ed2:	48 b8 0c 2d 80 00 00 	movabs $0x802d0c,%rax
  802ed9:	00 00 00 
  802edc:	ff d0                	callq  *%rax
  802ede:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ee1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee5:	79 05                	jns    802eec <shutdown+0x2d>
		return r;
  802ee7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eea:	eb 16                	jmp    802f02 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802eec:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802eef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef2:	89 d6                	mov    %edx,%esi
  802ef4:	89 c7                	mov    %eax,%edi
  802ef6:	48 b8 30 32 80 00 00 	movabs $0x803230,%rax
  802efd:	00 00 00 
  802f00:	ff d0                	callq  *%rax
}
  802f02:	c9                   	leaveq 
  802f03:	c3                   	retq   

0000000000802f04 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802f04:	55                   	push   %rbp
  802f05:	48 89 e5             	mov    %rsp,%rbp
  802f08:	48 83 ec 10          	sub    $0x10,%rsp
  802f0c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802f10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f14:	48 89 c7             	mov    %rax,%rdi
  802f17:	48 b8 92 40 80 00 00 	movabs $0x804092,%rax
  802f1e:	00 00 00 
  802f21:	ff d0                	callq  *%rax
  802f23:	83 f8 01             	cmp    $0x1,%eax
  802f26:	75 17                	jne    802f3f <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802f28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f2c:	8b 40 0c             	mov    0xc(%rax),%eax
  802f2f:	89 c7                	mov    %eax,%edi
  802f31:	48 b8 70 32 80 00 00 	movabs $0x803270,%rax
  802f38:	00 00 00 
  802f3b:	ff d0                	callq  *%rax
  802f3d:	eb 05                	jmp    802f44 <devsock_close+0x40>
	else
		return 0;
  802f3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f44:	c9                   	leaveq 
  802f45:	c3                   	retq   

0000000000802f46 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802f46:	55                   	push   %rbp
  802f47:	48 89 e5             	mov    %rsp,%rbp
  802f4a:	48 83 ec 20          	sub    $0x20,%rsp
  802f4e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f51:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f55:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f58:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f5b:	89 c7                	mov    %eax,%edi
  802f5d:	48 b8 0c 2d 80 00 00 	movabs $0x802d0c,%rax
  802f64:	00 00 00 
  802f67:	ff d0                	callq  *%rax
  802f69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f70:	79 05                	jns    802f77 <connect+0x31>
		return r;
  802f72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f75:	eb 1b                	jmp    802f92 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802f77:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f7a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f81:	48 89 ce             	mov    %rcx,%rsi
  802f84:	89 c7                	mov    %eax,%edi
  802f86:	48 b8 9d 32 80 00 00 	movabs $0x80329d,%rax
  802f8d:	00 00 00 
  802f90:	ff d0                	callq  *%rax
}
  802f92:	c9                   	leaveq 
  802f93:	c3                   	retq   

0000000000802f94 <listen>:

int
listen(int s, int backlog)
{
  802f94:	55                   	push   %rbp
  802f95:	48 89 e5             	mov    %rsp,%rbp
  802f98:	48 83 ec 20          	sub    $0x20,%rsp
  802f9c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f9f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fa2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fa5:	89 c7                	mov    %eax,%edi
  802fa7:	48 b8 0c 2d 80 00 00 	movabs $0x802d0c,%rax
  802fae:	00 00 00 
  802fb1:	ff d0                	callq  *%rax
  802fb3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fb6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fba:	79 05                	jns    802fc1 <listen+0x2d>
		return r;
  802fbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fbf:	eb 16                	jmp    802fd7 <listen+0x43>
	return nsipc_listen(r, backlog);
  802fc1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc7:	89 d6                	mov    %edx,%esi
  802fc9:	89 c7                	mov    %eax,%edi
  802fcb:	48 b8 01 33 80 00 00 	movabs $0x803301,%rax
  802fd2:	00 00 00 
  802fd5:	ff d0                	callq  *%rax
}
  802fd7:	c9                   	leaveq 
  802fd8:	c3                   	retq   

0000000000802fd9 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802fd9:	55                   	push   %rbp
  802fda:	48 89 e5             	mov    %rsp,%rbp
  802fdd:	48 83 ec 20          	sub    $0x20,%rsp
  802fe1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802fe5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802fe9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802fed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ff1:	89 c2                	mov    %eax,%edx
  802ff3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ff7:	8b 40 0c             	mov    0xc(%rax),%eax
  802ffa:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802ffe:	b9 00 00 00 00       	mov    $0x0,%ecx
  803003:	89 c7                	mov    %eax,%edi
  803005:	48 b8 41 33 80 00 00 	movabs $0x803341,%rax
  80300c:	00 00 00 
  80300f:	ff d0                	callq  *%rax
}
  803011:	c9                   	leaveq 
  803012:	c3                   	retq   

0000000000803013 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803013:	55                   	push   %rbp
  803014:	48 89 e5             	mov    %rsp,%rbp
  803017:	48 83 ec 20          	sub    $0x20,%rsp
  80301b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80301f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803023:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803027:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80302b:	89 c2                	mov    %eax,%edx
  80302d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803031:	8b 40 0c             	mov    0xc(%rax),%eax
  803034:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803038:	b9 00 00 00 00       	mov    $0x0,%ecx
  80303d:	89 c7                	mov    %eax,%edi
  80303f:	48 b8 0d 34 80 00 00 	movabs $0x80340d,%rax
  803046:	00 00 00 
  803049:	ff d0                	callq  *%rax
}
  80304b:	c9                   	leaveq 
  80304c:	c3                   	retq   

000000000080304d <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80304d:	55                   	push   %rbp
  80304e:	48 89 e5             	mov    %rsp,%rbp
  803051:	48 83 ec 10          	sub    $0x10,%rsp
  803055:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803059:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80305d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803061:	48 be f0 4c 80 00 00 	movabs $0x804cf0,%rsi
  803068:	00 00 00 
  80306b:	48 89 c7             	mov    %rax,%rdi
  80306e:	48 b8 a2 10 80 00 00 	movabs $0x8010a2,%rax
  803075:	00 00 00 
  803078:	ff d0                	callq  *%rax
	return 0;
  80307a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80307f:	c9                   	leaveq 
  803080:	c3                   	retq   

0000000000803081 <socket>:

int
socket(int domain, int type, int protocol)
{
  803081:	55                   	push   %rbp
  803082:	48 89 e5             	mov    %rsp,%rbp
  803085:	48 83 ec 20          	sub    $0x20,%rsp
  803089:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80308c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80308f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803092:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803095:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803098:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80309b:	89 ce                	mov    %ecx,%esi
  80309d:	89 c7                	mov    %eax,%edi
  80309f:	48 b8 c5 34 80 00 00 	movabs $0x8034c5,%rax
  8030a6:	00 00 00 
  8030a9:	ff d0                	callq  *%rax
  8030ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030b2:	79 05                	jns    8030b9 <socket+0x38>
		return r;
  8030b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b7:	eb 11                	jmp    8030ca <socket+0x49>
	return alloc_sockfd(r);
  8030b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030bc:	89 c7                	mov    %eax,%edi
  8030be:	48 b8 63 2d 80 00 00 	movabs $0x802d63,%rax
  8030c5:	00 00 00 
  8030c8:	ff d0                	callq  *%rax
}
  8030ca:	c9                   	leaveq 
  8030cb:	c3                   	retq   

00000000008030cc <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8030cc:	55                   	push   %rbp
  8030cd:	48 89 e5             	mov    %rsp,%rbp
  8030d0:	48 83 ec 10          	sub    $0x10,%rsp
  8030d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8030d7:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8030de:	00 00 00 
  8030e1:	8b 00                	mov    (%rax),%eax
  8030e3:	85 c0                	test   %eax,%eax
  8030e5:	75 1d                	jne    803104 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8030e7:	bf 02 00 00 00       	mov    $0x2,%edi
  8030ec:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  8030f3:	00 00 00 
  8030f6:	ff d0                	callq  *%rax
  8030f8:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  8030ff:	00 00 00 
  803102:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803104:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80310b:	00 00 00 
  80310e:	8b 00                	mov    (%rax),%eax
  803110:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803113:	b9 07 00 00 00       	mov    $0x7,%ecx
  803118:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80311f:	00 00 00 
  803122:	89 c7                	mov    %eax,%edi
  803124:	48 b8 ae 3f 80 00 00 	movabs $0x803fae,%rax
  80312b:	00 00 00 
  80312e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803130:	ba 00 00 00 00       	mov    $0x0,%edx
  803135:	be 00 00 00 00       	mov    $0x0,%esi
  80313a:	bf 00 00 00 00       	mov    $0x0,%edi
  80313f:	48 b8 a8 3e 80 00 00 	movabs $0x803ea8,%rax
  803146:	00 00 00 
  803149:	ff d0                	callq  *%rax
}
  80314b:	c9                   	leaveq 
  80314c:	c3                   	retq   

000000000080314d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80314d:	55                   	push   %rbp
  80314e:	48 89 e5             	mov    %rsp,%rbp
  803151:	48 83 ec 30          	sub    $0x30,%rsp
  803155:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803158:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80315c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803160:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803167:	00 00 00 
  80316a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80316d:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80316f:	bf 01 00 00 00       	mov    $0x1,%edi
  803174:	48 b8 cc 30 80 00 00 	movabs $0x8030cc,%rax
  80317b:	00 00 00 
  80317e:	ff d0                	callq  *%rax
  803180:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803183:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803187:	78 3e                	js     8031c7 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803189:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803190:	00 00 00 
  803193:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803197:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80319b:	8b 40 10             	mov    0x10(%rax),%eax
  80319e:	89 c2                	mov    %eax,%edx
  8031a0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8031a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031a8:	48 89 ce             	mov    %rcx,%rsi
  8031ab:	48 89 c7             	mov    %rax,%rdi
  8031ae:	48 b8 c6 13 80 00 00 	movabs $0x8013c6,%rax
  8031b5:	00 00 00 
  8031b8:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8031ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031be:	8b 50 10             	mov    0x10(%rax),%edx
  8031c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031c5:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8031c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8031ca:	c9                   	leaveq 
  8031cb:	c3                   	retq   

00000000008031cc <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8031cc:	55                   	push   %rbp
  8031cd:	48 89 e5             	mov    %rsp,%rbp
  8031d0:	48 83 ec 10          	sub    $0x10,%rsp
  8031d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8031d7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031db:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8031de:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031e5:	00 00 00 
  8031e8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031eb:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8031ed:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8031f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031f4:	48 89 c6             	mov    %rax,%rsi
  8031f7:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8031fe:	00 00 00 
  803201:	48 b8 c6 13 80 00 00 	movabs $0x8013c6,%rax
  803208:	00 00 00 
  80320b:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80320d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803214:	00 00 00 
  803217:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80321a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80321d:	bf 02 00 00 00       	mov    $0x2,%edi
  803222:	48 b8 cc 30 80 00 00 	movabs $0x8030cc,%rax
  803229:	00 00 00 
  80322c:	ff d0                	callq  *%rax
}
  80322e:	c9                   	leaveq 
  80322f:	c3                   	retq   

0000000000803230 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803230:	55                   	push   %rbp
  803231:	48 89 e5             	mov    %rsp,%rbp
  803234:	48 83 ec 10          	sub    $0x10,%rsp
  803238:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80323b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80323e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803245:	00 00 00 
  803248:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80324b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80324d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803254:	00 00 00 
  803257:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80325a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80325d:	bf 03 00 00 00       	mov    $0x3,%edi
  803262:	48 b8 cc 30 80 00 00 	movabs $0x8030cc,%rax
  803269:	00 00 00 
  80326c:	ff d0                	callq  *%rax
}
  80326e:	c9                   	leaveq 
  80326f:	c3                   	retq   

0000000000803270 <nsipc_close>:

int
nsipc_close(int s)
{
  803270:	55                   	push   %rbp
  803271:	48 89 e5             	mov    %rsp,%rbp
  803274:	48 83 ec 10          	sub    $0x10,%rsp
  803278:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80327b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803282:	00 00 00 
  803285:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803288:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80328a:	bf 04 00 00 00       	mov    $0x4,%edi
  80328f:	48 b8 cc 30 80 00 00 	movabs $0x8030cc,%rax
  803296:	00 00 00 
  803299:	ff d0                	callq  *%rax
}
  80329b:	c9                   	leaveq 
  80329c:	c3                   	retq   

000000000080329d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80329d:	55                   	push   %rbp
  80329e:	48 89 e5             	mov    %rsp,%rbp
  8032a1:	48 83 ec 10          	sub    $0x10,%rsp
  8032a5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8032ac:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8032af:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032b6:	00 00 00 
  8032b9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032bc:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8032be:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c5:	48 89 c6             	mov    %rax,%rsi
  8032c8:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8032cf:	00 00 00 
  8032d2:	48 b8 c6 13 80 00 00 	movabs $0x8013c6,%rax
  8032d9:	00 00 00 
  8032dc:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8032de:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032e5:	00 00 00 
  8032e8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032eb:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8032ee:	bf 05 00 00 00       	mov    $0x5,%edi
  8032f3:	48 b8 cc 30 80 00 00 	movabs $0x8030cc,%rax
  8032fa:	00 00 00 
  8032fd:	ff d0                	callq  *%rax
}
  8032ff:	c9                   	leaveq 
  803300:	c3                   	retq   

0000000000803301 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803301:	55                   	push   %rbp
  803302:	48 89 e5             	mov    %rsp,%rbp
  803305:	48 83 ec 10          	sub    $0x10,%rsp
  803309:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80330c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80330f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803316:	00 00 00 
  803319:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80331c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80331e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803325:	00 00 00 
  803328:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80332b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80332e:	bf 06 00 00 00       	mov    $0x6,%edi
  803333:	48 b8 cc 30 80 00 00 	movabs $0x8030cc,%rax
  80333a:	00 00 00 
  80333d:	ff d0                	callq  *%rax
}
  80333f:	c9                   	leaveq 
  803340:	c3                   	retq   

0000000000803341 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803341:	55                   	push   %rbp
  803342:	48 89 e5             	mov    %rsp,%rbp
  803345:	48 83 ec 30          	sub    $0x30,%rsp
  803349:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80334c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803350:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803353:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803356:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80335d:	00 00 00 
  803360:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803363:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803365:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80336c:	00 00 00 
  80336f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803372:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803375:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80337c:	00 00 00 
  80337f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803382:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803385:	bf 07 00 00 00       	mov    $0x7,%edi
  80338a:	48 b8 cc 30 80 00 00 	movabs $0x8030cc,%rax
  803391:	00 00 00 
  803394:	ff d0                	callq  *%rax
  803396:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803399:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80339d:	78 69                	js     803408 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80339f:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8033a6:	7f 08                	jg     8033b0 <nsipc_recv+0x6f>
  8033a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ab:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8033ae:	7e 35                	jle    8033e5 <nsipc_recv+0xa4>
  8033b0:	48 b9 f7 4c 80 00 00 	movabs $0x804cf7,%rcx
  8033b7:	00 00 00 
  8033ba:	48 ba 0c 4d 80 00 00 	movabs $0x804d0c,%rdx
  8033c1:	00 00 00 
  8033c4:	be 61 00 00 00       	mov    $0x61,%esi
  8033c9:	48 bf 21 4d 80 00 00 	movabs $0x804d21,%rdi
  8033d0:	00 00 00 
  8033d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d8:	49 b8 94 3d 80 00 00 	movabs $0x803d94,%r8
  8033df:	00 00 00 
  8033e2:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8033e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e8:	48 63 d0             	movslq %eax,%rdx
  8033eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033ef:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8033f6:	00 00 00 
  8033f9:	48 89 c7             	mov    %rax,%rdi
  8033fc:	48 b8 c6 13 80 00 00 	movabs $0x8013c6,%rax
  803403:	00 00 00 
  803406:	ff d0                	callq  *%rax
	}

	return r;
  803408:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80340b:	c9                   	leaveq 
  80340c:	c3                   	retq   

000000000080340d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80340d:	55                   	push   %rbp
  80340e:	48 89 e5             	mov    %rsp,%rbp
  803411:	48 83 ec 20          	sub    $0x20,%rsp
  803415:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803418:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80341c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80341f:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803422:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803429:	00 00 00 
  80342c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80342f:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803431:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803438:	7e 35                	jle    80346f <nsipc_send+0x62>
  80343a:	48 b9 2d 4d 80 00 00 	movabs $0x804d2d,%rcx
  803441:	00 00 00 
  803444:	48 ba 0c 4d 80 00 00 	movabs $0x804d0c,%rdx
  80344b:	00 00 00 
  80344e:	be 6c 00 00 00       	mov    $0x6c,%esi
  803453:	48 bf 21 4d 80 00 00 	movabs $0x804d21,%rdi
  80345a:	00 00 00 
  80345d:	b8 00 00 00 00       	mov    $0x0,%eax
  803462:	49 b8 94 3d 80 00 00 	movabs $0x803d94,%r8
  803469:	00 00 00 
  80346c:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80346f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803472:	48 63 d0             	movslq %eax,%rdx
  803475:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803479:	48 89 c6             	mov    %rax,%rsi
  80347c:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803483:	00 00 00 
  803486:	48 b8 c6 13 80 00 00 	movabs $0x8013c6,%rax
  80348d:	00 00 00 
  803490:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803492:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803499:	00 00 00 
  80349c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80349f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8034a2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034a9:	00 00 00 
  8034ac:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034af:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8034b2:	bf 08 00 00 00       	mov    $0x8,%edi
  8034b7:	48 b8 cc 30 80 00 00 	movabs $0x8030cc,%rax
  8034be:	00 00 00 
  8034c1:	ff d0                	callq  *%rax
}
  8034c3:	c9                   	leaveq 
  8034c4:	c3                   	retq   

00000000008034c5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8034c5:	55                   	push   %rbp
  8034c6:	48 89 e5             	mov    %rsp,%rbp
  8034c9:	48 83 ec 10          	sub    $0x10,%rsp
  8034cd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034d0:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8034d3:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8034d6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034dd:	00 00 00 
  8034e0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034e3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8034e5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034ec:	00 00 00 
  8034ef:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034f2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8034f5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034fc:	00 00 00 
  8034ff:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803502:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803505:	bf 09 00 00 00       	mov    $0x9,%edi
  80350a:	48 b8 cc 30 80 00 00 	movabs $0x8030cc,%rax
  803511:	00 00 00 
  803514:	ff d0                	callq  *%rax
}
  803516:	c9                   	leaveq 
  803517:	c3                   	retq   

0000000000803518 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803518:	55                   	push   %rbp
  803519:	48 89 e5             	mov    %rsp,%rbp
  80351c:	53                   	push   %rbx
  80351d:	48 83 ec 38          	sub    $0x38,%rsp
  803521:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803525:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803529:	48 89 c7             	mov    %rax,%rdi
  80352c:	48 b8 56 1d 80 00 00 	movabs $0x801d56,%rax
  803533:	00 00 00 
  803536:	ff d0                	callq  *%rax
  803538:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80353b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80353f:	0f 88 bf 01 00 00    	js     803704 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803545:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803549:	ba 07 04 00 00       	mov    $0x407,%edx
  80354e:	48 89 c6             	mov    %rax,%rsi
  803551:	bf 00 00 00 00       	mov    $0x0,%edi
  803556:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  80355d:	00 00 00 
  803560:	ff d0                	callq  *%rax
  803562:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803565:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803569:	0f 88 95 01 00 00    	js     803704 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80356f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803573:	48 89 c7             	mov    %rax,%rdi
  803576:	48 b8 56 1d 80 00 00 	movabs $0x801d56,%rax
  80357d:	00 00 00 
  803580:	ff d0                	callq  *%rax
  803582:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803585:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803589:	0f 88 5d 01 00 00    	js     8036ec <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80358f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803593:	ba 07 04 00 00       	mov    $0x407,%edx
  803598:	48 89 c6             	mov    %rax,%rsi
  80359b:	bf 00 00 00 00       	mov    $0x0,%edi
  8035a0:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  8035a7:	00 00 00 
  8035aa:	ff d0                	callq  *%rax
  8035ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035af:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035b3:	0f 88 33 01 00 00    	js     8036ec <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8035b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035bd:	48 89 c7             	mov    %rax,%rdi
  8035c0:	48 b8 2b 1d 80 00 00 	movabs $0x801d2b,%rax
  8035c7:	00 00 00 
  8035ca:	ff d0                	callq  *%rax
  8035cc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035d4:	ba 07 04 00 00       	mov    $0x407,%edx
  8035d9:	48 89 c6             	mov    %rax,%rsi
  8035dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8035e1:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  8035e8:	00 00 00 
  8035eb:	ff d0                	callq  *%rax
  8035ed:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035f4:	79 05                	jns    8035fb <pipe+0xe3>
		goto err2;
  8035f6:	e9 d9 00 00 00       	jmpq   8036d4 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035ff:	48 89 c7             	mov    %rax,%rdi
  803602:	48 b8 2b 1d 80 00 00 	movabs $0x801d2b,%rax
  803609:	00 00 00 
  80360c:	ff d0                	callq  *%rax
  80360e:	48 89 c2             	mov    %rax,%rdx
  803611:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803615:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80361b:	48 89 d1             	mov    %rdx,%rcx
  80361e:	ba 00 00 00 00       	mov    $0x0,%edx
  803623:	48 89 c6             	mov    %rax,%rsi
  803626:	bf 00 00 00 00       	mov    $0x0,%edi
  80362b:	48 b8 21 1a 80 00 00 	movabs $0x801a21,%rax
  803632:	00 00 00 
  803635:	ff d0                	callq  *%rax
  803637:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80363a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80363e:	79 1b                	jns    80365b <pipe+0x143>
		goto err3;
  803640:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803641:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803645:	48 89 c6             	mov    %rax,%rsi
  803648:	bf 00 00 00 00       	mov    $0x0,%edi
  80364d:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  803654:	00 00 00 
  803657:	ff d0                	callq  *%rax
  803659:	eb 79                	jmp    8036d4 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80365b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80365f:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803666:	00 00 00 
  803669:	8b 12                	mov    (%rdx),%edx
  80366b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80366d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803671:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803678:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80367c:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803683:	00 00 00 
  803686:	8b 12                	mov    (%rdx),%edx
  803688:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80368a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80368e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803695:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803699:	48 89 c7             	mov    %rax,%rdi
  80369c:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  8036a3:	00 00 00 
  8036a6:	ff d0                	callq  *%rax
  8036a8:	89 c2                	mov    %eax,%edx
  8036aa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036ae:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8036b0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036b4:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8036b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036bc:	48 89 c7             	mov    %rax,%rdi
  8036bf:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  8036c6:	00 00 00 
  8036c9:	ff d0                	callq  *%rax
  8036cb:	89 03                	mov    %eax,(%rbx)
	return 0;
  8036cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8036d2:	eb 33                	jmp    803707 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8036d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036d8:	48 89 c6             	mov    %rax,%rsi
  8036db:	bf 00 00 00 00       	mov    $0x0,%edi
  8036e0:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  8036e7:	00 00 00 
  8036ea:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8036ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036f0:	48 89 c6             	mov    %rax,%rsi
  8036f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8036f8:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  8036ff:	00 00 00 
  803702:	ff d0                	callq  *%rax
err:
	return r;
  803704:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803707:	48 83 c4 38          	add    $0x38,%rsp
  80370b:	5b                   	pop    %rbx
  80370c:	5d                   	pop    %rbp
  80370d:	c3                   	retq   

000000000080370e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80370e:	55                   	push   %rbp
  80370f:	48 89 e5             	mov    %rsp,%rbp
  803712:	53                   	push   %rbx
  803713:	48 83 ec 28          	sub    $0x28,%rsp
  803717:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80371b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80371f:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803726:	00 00 00 
  803729:	48 8b 00             	mov    (%rax),%rax
  80372c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803732:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803735:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803739:	48 89 c7             	mov    %rax,%rdi
  80373c:	48 b8 92 40 80 00 00 	movabs $0x804092,%rax
  803743:	00 00 00 
  803746:	ff d0                	callq  *%rax
  803748:	89 c3                	mov    %eax,%ebx
  80374a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80374e:	48 89 c7             	mov    %rax,%rdi
  803751:	48 b8 92 40 80 00 00 	movabs $0x804092,%rax
  803758:	00 00 00 
  80375b:	ff d0                	callq  *%rax
  80375d:	39 c3                	cmp    %eax,%ebx
  80375f:	0f 94 c0             	sete   %al
  803762:	0f b6 c0             	movzbl %al,%eax
  803765:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803768:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80376f:	00 00 00 
  803772:	48 8b 00             	mov    (%rax),%rax
  803775:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80377b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80377e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803781:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803784:	75 05                	jne    80378b <_pipeisclosed+0x7d>
			return ret;
  803786:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803789:	eb 4f                	jmp    8037da <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80378b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80378e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803791:	74 42                	je     8037d5 <_pipeisclosed+0xc7>
  803793:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803797:	75 3c                	jne    8037d5 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803799:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8037a0:	00 00 00 
  8037a3:	48 8b 00             	mov    (%rax),%rax
  8037a6:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8037ac:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8037af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037b2:	89 c6                	mov    %eax,%esi
  8037b4:	48 bf 3e 4d 80 00 00 	movabs $0x804d3e,%rdi
  8037bb:	00 00 00 
  8037be:	b8 00 00 00 00       	mov    $0x0,%eax
  8037c3:	49 b8 ed 04 80 00 00 	movabs $0x8004ed,%r8
  8037ca:	00 00 00 
  8037cd:	41 ff d0             	callq  *%r8
	}
  8037d0:	e9 4a ff ff ff       	jmpq   80371f <_pipeisclosed+0x11>
  8037d5:	e9 45 ff ff ff       	jmpq   80371f <_pipeisclosed+0x11>
}
  8037da:	48 83 c4 28          	add    $0x28,%rsp
  8037de:	5b                   	pop    %rbx
  8037df:	5d                   	pop    %rbp
  8037e0:	c3                   	retq   

00000000008037e1 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8037e1:	55                   	push   %rbp
  8037e2:	48 89 e5             	mov    %rsp,%rbp
  8037e5:	48 83 ec 30          	sub    $0x30,%rsp
  8037e9:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8037ec:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8037f0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8037f3:	48 89 d6             	mov    %rdx,%rsi
  8037f6:	89 c7                	mov    %eax,%edi
  8037f8:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  8037ff:	00 00 00 
  803802:	ff d0                	callq  *%rax
  803804:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803807:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80380b:	79 05                	jns    803812 <pipeisclosed+0x31>
		return r;
  80380d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803810:	eb 31                	jmp    803843 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803812:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803816:	48 89 c7             	mov    %rax,%rdi
  803819:	48 b8 2b 1d 80 00 00 	movabs $0x801d2b,%rax
  803820:	00 00 00 
  803823:	ff d0                	callq  *%rax
  803825:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803829:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80382d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803831:	48 89 d6             	mov    %rdx,%rsi
  803834:	48 89 c7             	mov    %rax,%rdi
  803837:	48 b8 0e 37 80 00 00 	movabs $0x80370e,%rax
  80383e:	00 00 00 
  803841:	ff d0                	callq  *%rax
}
  803843:	c9                   	leaveq 
  803844:	c3                   	retq   

0000000000803845 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803845:	55                   	push   %rbp
  803846:	48 89 e5             	mov    %rsp,%rbp
  803849:	48 83 ec 40          	sub    $0x40,%rsp
  80384d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803851:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803855:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803859:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80385d:	48 89 c7             	mov    %rax,%rdi
  803860:	48 b8 2b 1d 80 00 00 	movabs $0x801d2b,%rax
  803867:	00 00 00 
  80386a:	ff d0                	callq  *%rax
  80386c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803870:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803874:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803878:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80387f:	00 
  803880:	e9 92 00 00 00       	jmpq   803917 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803885:	eb 41                	jmp    8038c8 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803887:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80388c:	74 09                	je     803897 <devpipe_read+0x52>
				return i;
  80388e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803892:	e9 92 00 00 00       	jmpq   803929 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803897:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80389b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80389f:	48 89 d6             	mov    %rdx,%rsi
  8038a2:	48 89 c7             	mov    %rax,%rdi
  8038a5:	48 b8 0e 37 80 00 00 	movabs $0x80370e,%rax
  8038ac:	00 00 00 
  8038af:	ff d0                	callq  *%rax
  8038b1:	85 c0                	test   %eax,%eax
  8038b3:	74 07                	je     8038bc <devpipe_read+0x77>
				return 0;
  8038b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ba:	eb 6d                	jmp    803929 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8038bc:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  8038c3:	00 00 00 
  8038c6:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8038c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038cc:	8b 10                	mov    (%rax),%edx
  8038ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038d2:	8b 40 04             	mov    0x4(%rax),%eax
  8038d5:	39 c2                	cmp    %eax,%edx
  8038d7:	74 ae                	je     803887 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8038d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8038e1:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8038e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038e9:	8b 00                	mov    (%rax),%eax
  8038eb:	99                   	cltd   
  8038ec:	c1 ea 1b             	shr    $0x1b,%edx
  8038ef:	01 d0                	add    %edx,%eax
  8038f1:	83 e0 1f             	and    $0x1f,%eax
  8038f4:	29 d0                	sub    %edx,%eax
  8038f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038fa:	48 98                	cltq   
  8038fc:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803901:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803903:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803907:	8b 00                	mov    (%rax),%eax
  803909:	8d 50 01             	lea    0x1(%rax),%edx
  80390c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803910:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803912:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803917:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80391b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80391f:	0f 82 60 ff ff ff    	jb     803885 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803925:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803929:	c9                   	leaveq 
  80392a:	c3                   	retq   

000000000080392b <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80392b:	55                   	push   %rbp
  80392c:	48 89 e5             	mov    %rsp,%rbp
  80392f:	48 83 ec 40          	sub    $0x40,%rsp
  803933:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803937:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80393b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80393f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803943:	48 89 c7             	mov    %rax,%rdi
  803946:	48 b8 2b 1d 80 00 00 	movabs $0x801d2b,%rax
  80394d:	00 00 00 
  803950:	ff d0                	callq  *%rax
  803952:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803956:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80395a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80395e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803965:	00 
  803966:	e9 8e 00 00 00       	jmpq   8039f9 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80396b:	eb 31                	jmp    80399e <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80396d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803971:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803975:	48 89 d6             	mov    %rdx,%rsi
  803978:	48 89 c7             	mov    %rax,%rdi
  80397b:	48 b8 0e 37 80 00 00 	movabs $0x80370e,%rax
  803982:	00 00 00 
  803985:	ff d0                	callq  *%rax
  803987:	85 c0                	test   %eax,%eax
  803989:	74 07                	je     803992 <devpipe_write+0x67>
				return 0;
  80398b:	b8 00 00 00 00       	mov    $0x0,%eax
  803990:	eb 79                	jmp    803a0b <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803992:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  803999:	00 00 00 
  80399c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80399e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a2:	8b 40 04             	mov    0x4(%rax),%eax
  8039a5:	48 63 d0             	movslq %eax,%rdx
  8039a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ac:	8b 00                	mov    (%rax),%eax
  8039ae:	48 98                	cltq   
  8039b0:	48 83 c0 20          	add    $0x20,%rax
  8039b4:	48 39 c2             	cmp    %rax,%rdx
  8039b7:	73 b4                	jae    80396d <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8039b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039bd:	8b 40 04             	mov    0x4(%rax),%eax
  8039c0:	99                   	cltd   
  8039c1:	c1 ea 1b             	shr    $0x1b,%edx
  8039c4:	01 d0                	add    %edx,%eax
  8039c6:	83 e0 1f             	and    $0x1f,%eax
  8039c9:	29 d0                	sub    %edx,%eax
  8039cb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8039cf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8039d3:	48 01 ca             	add    %rcx,%rdx
  8039d6:	0f b6 0a             	movzbl (%rdx),%ecx
  8039d9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039dd:	48 98                	cltq   
  8039df:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8039e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039e7:	8b 40 04             	mov    0x4(%rax),%eax
  8039ea:	8d 50 01             	lea    0x1(%rax),%edx
  8039ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f1:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8039f4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039fd:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a01:	0f 82 64 ff ff ff    	jb     80396b <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803a07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a0b:	c9                   	leaveq 
  803a0c:	c3                   	retq   

0000000000803a0d <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803a0d:	55                   	push   %rbp
  803a0e:	48 89 e5             	mov    %rsp,%rbp
  803a11:	48 83 ec 20          	sub    $0x20,%rsp
  803a15:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a19:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803a1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a21:	48 89 c7             	mov    %rax,%rdi
  803a24:	48 b8 2b 1d 80 00 00 	movabs $0x801d2b,%rax
  803a2b:	00 00 00 
  803a2e:	ff d0                	callq  *%rax
  803a30:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803a34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a38:	48 be 51 4d 80 00 00 	movabs $0x804d51,%rsi
  803a3f:	00 00 00 
  803a42:	48 89 c7             	mov    %rax,%rdi
  803a45:	48 b8 a2 10 80 00 00 	movabs $0x8010a2,%rax
  803a4c:	00 00 00 
  803a4f:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803a51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a55:	8b 50 04             	mov    0x4(%rax),%edx
  803a58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a5c:	8b 00                	mov    (%rax),%eax
  803a5e:	29 c2                	sub    %eax,%edx
  803a60:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a64:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803a6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a6e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803a75:	00 00 00 
	stat->st_dev = &devpipe;
  803a78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a7c:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803a83:	00 00 00 
  803a86:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803a8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a92:	c9                   	leaveq 
  803a93:	c3                   	retq   

0000000000803a94 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803a94:	55                   	push   %rbp
  803a95:	48 89 e5             	mov    %rsp,%rbp
  803a98:	48 83 ec 10          	sub    $0x10,%rsp
  803a9c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803aa0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aa4:	48 89 c6             	mov    %rax,%rsi
  803aa7:	bf 00 00 00 00       	mov    $0x0,%edi
  803aac:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  803ab3:	00 00 00 
  803ab6:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803ab8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803abc:	48 89 c7             	mov    %rax,%rdi
  803abf:	48 b8 2b 1d 80 00 00 	movabs $0x801d2b,%rax
  803ac6:	00 00 00 
  803ac9:	ff d0                	callq  *%rax
  803acb:	48 89 c6             	mov    %rax,%rsi
  803ace:	bf 00 00 00 00       	mov    $0x0,%edi
  803ad3:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  803ada:	00 00 00 
  803add:	ff d0                	callq  *%rax
}
  803adf:	c9                   	leaveq 
  803ae0:	c3                   	retq   

0000000000803ae1 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803ae1:	55                   	push   %rbp
  803ae2:	48 89 e5             	mov    %rsp,%rbp
  803ae5:	48 83 ec 20          	sub    $0x20,%rsp
  803ae9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803aec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aef:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803af2:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803af6:	be 01 00 00 00       	mov    $0x1,%esi
  803afb:	48 89 c7             	mov    %rax,%rdi
  803afe:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  803b05:	00 00 00 
  803b08:	ff d0                	callq  *%rax
}
  803b0a:	c9                   	leaveq 
  803b0b:	c3                   	retq   

0000000000803b0c <getchar>:

int
getchar(void)
{
  803b0c:	55                   	push   %rbp
  803b0d:	48 89 e5             	mov    %rsp,%rbp
  803b10:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803b14:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803b18:	ba 01 00 00 00       	mov    $0x1,%edx
  803b1d:	48 89 c6             	mov    %rax,%rsi
  803b20:	bf 00 00 00 00       	mov    $0x0,%edi
  803b25:	48 b8 20 22 80 00 00 	movabs $0x802220,%rax
  803b2c:	00 00 00 
  803b2f:	ff d0                	callq  *%rax
  803b31:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803b34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b38:	79 05                	jns    803b3f <getchar+0x33>
		return r;
  803b3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b3d:	eb 14                	jmp    803b53 <getchar+0x47>
	if (r < 1)
  803b3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b43:	7f 07                	jg     803b4c <getchar+0x40>
		return -E_EOF;
  803b45:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803b4a:	eb 07                	jmp    803b53 <getchar+0x47>
	return c;
  803b4c:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803b50:	0f b6 c0             	movzbl %al,%eax
}
  803b53:	c9                   	leaveq 
  803b54:	c3                   	retq   

0000000000803b55 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803b55:	55                   	push   %rbp
  803b56:	48 89 e5             	mov    %rsp,%rbp
  803b59:	48 83 ec 20          	sub    $0x20,%rsp
  803b5d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b60:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b64:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b67:	48 89 d6             	mov    %rdx,%rsi
  803b6a:	89 c7                	mov    %eax,%edi
  803b6c:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  803b73:	00 00 00 
  803b76:	ff d0                	callq  *%rax
  803b78:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b7f:	79 05                	jns    803b86 <iscons+0x31>
		return r;
  803b81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b84:	eb 1a                	jmp    803ba0 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803b86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b8a:	8b 10                	mov    (%rax),%edx
  803b8c:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803b93:	00 00 00 
  803b96:	8b 00                	mov    (%rax),%eax
  803b98:	39 c2                	cmp    %eax,%edx
  803b9a:	0f 94 c0             	sete   %al
  803b9d:	0f b6 c0             	movzbl %al,%eax
}
  803ba0:	c9                   	leaveq 
  803ba1:	c3                   	retq   

0000000000803ba2 <opencons>:

int
opencons(void)
{
  803ba2:	55                   	push   %rbp
  803ba3:	48 89 e5             	mov    %rsp,%rbp
  803ba6:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803baa:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803bae:	48 89 c7             	mov    %rax,%rdi
  803bb1:	48 b8 56 1d 80 00 00 	movabs $0x801d56,%rax
  803bb8:	00 00 00 
  803bbb:	ff d0                	callq  *%rax
  803bbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bc4:	79 05                	jns    803bcb <opencons+0x29>
		return r;
  803bc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bc9:	eb 5b                	jmp    803c26 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803bcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bcf:	ba 07 04 00 00       	mov    $0x407,%edx
  803bd4:	48 89 c6             	mov    %rax,%rsi
  803bd7:	bf 00 00 00 00       	mov    $0x0,%edi
  803bdc:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  803be3:	00 00 00 
  803be6:	ff d0                	callq  *%rax
  803be8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803beb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bef:	79 05                	jns    803bf6 <opencons+0x54>
		return r;
  803bf1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf4:	eb 30                	jmp    803c26 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803bf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bfa:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803c01:	00 00 00 
  803c04:	8b 12                	mov    (%rdx),%edx
  803c06:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803c08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c0c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803c13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c17:	48 89 c7             	mov    %rax,%rdi
  803c1a:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  803c21:	00 00 00 
  803c24:	ff d0                	callq  *%rax
}
  803c26:	c9                   	leaveq 
  803c27:	c3                   	retq   

0000000000803c28 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803c28:	55                   	push   %rbp
  803c29:	48 89 e5             	mov    %rsp,%rbp
  803c2c:	48 83 ec 30          	sub    $0x30,%rsp
  803c30:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c34:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c38:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803c3c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c41:	75 07                	jne    803c4a <devcons_read+0x22>
		return 0;
  803c43:	b8 00 00 00 00       	mov    $0x0,%eax
  803c48:	eb 4b                	jmp    803c95 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803c4a:	eb 0c                	jmp    803c58 <devcons_read+0x30>
		sys_yield();
  803c4c:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  803c53:	00 00 00 
  803c56:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803c58:	48 b8 d3 18 80 00 00 	movabs $0x8018d3,%rax
  803c5f:	00 00 00 
  803c62:	ff d0                	callq  *%rax
  803c64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c6b:	74 df                	je     803c4c <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803c6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c71:	79 05                	jns    803c78 <devcons_read+0x50>
		return c;
  803c73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c76:	eb 1d                	jmp    803c95 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803c78:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803c7c:	75 07                	jne    803c85 <devcons_read+0x5d>
		return 0;
  803c7e:	b8 00 00 00 00       	mov    $0x0,%eax
  803c83:	eb 10                	jmp    803c95 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803c85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c88:	89 c2                	mov    %eax,%edx
  803c8a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c8e:	88 10                	mov    %dl,(%rax)
	return 1;
  803c90:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c95:	c9                   	leaveq 
  803c96:	c3                   	retq   

0000000000803c97 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c97:	55                   	push   %rbp
  803c98:	48 89 e5             	mov    %rsp,%rbp
  803c9b:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803ca2:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803ca9:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803cb0:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803cb7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803cbe:	eb 76                	jmp    803d36 <devcons_write+0x9f>
		m = n - tot;
  803cc0:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803cc7:	89 c2                	mov    %eax,%edx
  803cc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ccc:	29 c2                	sub    %eax,%edx
  803cce:	89 d0                	mov    %edx,%eax
  803cd0:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803cd3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cd6:	83 f8 7f             	cmp    $0x7f,%eax
  803cd9:	76 07                	jbe    803ce2 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803cdb:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803ce2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ce5:	48 63 d0             	movslq %eax,%rdx
  803ce8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ceb:	48 63 c8             	movslq %eax,%rcx
  803cee:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803cf5:	48 01 c1             	add    %rax,%rcx
  803cf8:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803cff:	48 89 ce             	mov    %rcx,%rsi
  803d02:	48 89 c7             	mov    %rax,%rdi
  803d05:	48 b8 c6 13 80 00 00 	movabs $0x8013c6,%rax
  803d0c:	00 00 00 
  803d0f:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803d11:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d14:	48 63 d0             	movslq %eax,%rdx
  803d17:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d1e:	48 89 d6             	mov    %rdx,%rsi
  803d21:	48 89 c7             	mov    %rax,%rdi
  803d24:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  803d2b:	00 00 00 
  803d2e:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d30:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d33:	01 45 fc             	add    %eax,-0x4(%rbp)
  803d36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d39:	48 98                	cltq   
  803d3b:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803d42:	0f 82 78 ff ff ff    	jb     803cc0 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803d48:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d4b:	c9                   	leaveq 
  803d4c:	c3                   	retq   

0000000000803d4d <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803d4d:	55                   	push   %rbp
  803d4e:	48 89 e5             	mov    %rsp,%rbp
  803d51:	48 83 ec 08          	sub    $0x8,%rsp
  803d55:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803d59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d5e:	c9                   	leaveq 
  803d5f:	c3                   	retq   

0000000000803d60 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803d60:	55                   	push   %rbp
  803d61:	48 89 e5             	mov    %rsp,%rbp
  803d64:	48 83 ec 10          	sub    $0x10,%rsp
  803d68:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d6c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803d70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d74:	48 be 5d 4d 80 00 00 	movabs $0x804d5d,%rsi
  803d7b:	00 00 00 
  803d7e:	48 89 c7             	mov    %rax,%rdi
  803d81:	48 b8 a2 10 80 00 00 	movabs $0x8010a2,%rax
  803d88:	00 00 00 
  803d8b:	ff d0                	callq  *%rax
	return 0;
  803d8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d92:	c9                   	leaveq 
  803d93:	c3                   	retq   

0000000000803d94 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803d94:	55                   	push   %rbp
  803d95:	48 89 e5             	mov    %rsp,%rbp
  803d98:	53                   	push   %rbx
  803d99:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803da0:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803da7:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803dad:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803db4:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803dbb:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803dc2:	84 c0                	test   %al,%al
  803dc4:	74 23                	je     803de9 <_panic+0x55>
  803dc6:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803dcd:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803dd1:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803dd5:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803dd9:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803ddd:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803de1:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803de5:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803de9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803df0:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803df7:	00 00 00 
  803dfa:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803e01:	00 00 00 
  803e04:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803e08:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803e0f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803e16:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803e1d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803e24:	00 00 00 
  803e27:	48 8b 18             	mov    (%rax),%rbx
  803e2a:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  803e31:	00 00 00 
  803e34:	ff d0                	callq  *%rax
  803e36:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803e3c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803e43:	41 89 c8             	mov    %ecx,%r8d
  803e46:	48 89 d1             	mov    %rdx,%rcx
  803e49:	48 89 da             	mov    %rbx,%rdx
  803e4c:	89 c6                	mov    %eax,%esi
  803e4e:	48 bf 68 4d 80 00 00 	movabs $0x804d68,%rdi
  803e55:	00 00 00 
  803e58:	b8 00 00 00 00       	mov    $0x0,%eax
  803e5d:	49 b9 ed 04 80 00 00 	movabs $0x8004ed,%r9
  803e64:	00 00 00 
  803e67:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803e6a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803e71:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803e78:	48 89 d6             	mov    %rdx,%rsi
  803e7b:	48 89 c7             	mov    %rax,%rdi
  803e7e:	48 b8 41 04 80 00 00 	movabs $0x800441,%rax
  803e85:	00 00 00 
  803e88:	ff d0                	callq  *%rax
	cprintf("\n");
  803e8a:	48 bf 8b 4d 80 00 00 	movabs $0x804d8b,%rdi
  803e91:	00 00 00 
  803e94:	b8 00 00 00 00       	mov    $0x0,%eax
  803e99:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  803ea0:	00 00 00 
  803ea3:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803ea5:	cc                   	int3   
  803ea6:	eb fd                	jmp    803ea5 <_panic+0x111>

0000000000803ea8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803ea8:	55                   	push   %rbp
  803ea9:	48 89 e5             	mov    %rsp,%rbp
  803eac:	48 83 ec 30          	sub    $0x30,%rsp
  803eb0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803eb4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803eb8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803ebc:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803ec3:	00 00 00 
  803ec6:	48 8b 00             	mov    (%rax),%rax
  803ec9:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803ecf:	85 c0                	test   %eax,%eax
  803ed1:	75 3c                	jne    803f0f <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803ed3:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  803eda:	00 00 00 
  803edd:	ff d0                	callq  *%rax
  803edf:	25 ff 03 00 00       	and    $0x3ff,%eax
  803ee4:	48 63 d0             	movslq %eax,%rdx
  803ee7:	48 89 d0             	mov    %rdx,%rax
  803eea:	48 c1 e0 03          	shl    $0x3,%rax
  803eee:	48 01 d0             	add    %rdx,%rax
  803ef1:	48 c1 e0 05          	shl    $0x5,%rax
  803ef5:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803efc:	00 00 00 
  803eff:	48 01 c2             	add    %rax,%rdx
  803f02:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803f09:	00 00 00 
  803f0c:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803f0f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f14:	75 0e                	jne    803f24 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803f16:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f1d:	00 00 00 
  803f20:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803f24:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f28:	48 89 c7             	mov    %rax,%rdi
  803f2b:	48 b8 fa 1b 80 00 00 	movabs $0x801bfa,%rax
  803f32:	00 00 00 
  803f35:	ff d0                	callq  *%rax
  803f37:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803f3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f3e:	79 19                	jns    803f59 <ipc_recv+0xb1>
		*from_env_store = 0;
  803f40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f44:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803f4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f4e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803f54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f57:	eb 53                	jmp    803fac <ipc_recv+0x104>
	}
	if(from_env_store)
  803f59:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803f5e:	74 19                	je     803f79 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803f60:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803f67:	00 00 00 
  803f6a:	48 8b 00             	mov    (%rax),%rax
  803f6d:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803f73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f77:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803f79:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f7e:	74 19                	je     803f99 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803f80:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803f87:	00 00 00 
  803f8a:	48 8b 00             	mov    (%rax),%rax
  803f8d:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803f93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f97:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803f99:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803fa0:	00 00 00 
  803fa3:	48 8b 00             	mov    (%rax),%rax
  803fa6:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803fac:	c9                   	leaveq 
  803fad:	c3                   	retq   

0000000000803fae <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803fae:	55                   	push   %rbp
  803faf:	48 89 e5             	mov    %rsp,%rbp
  803fb2:	48 83 ec 30          	sub    $0x30,%rsp
  803fb6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803fb9:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803fbc:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803fc0:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803fc3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803fc8:	75 0e                	jne    803fd8 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803fca:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803fd1:	00 00 00 
  803fd4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803fd8:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803fdb:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803fde:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803fe2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fe5:	89 c7                	mov    %eax,%edi
  803fe7:	48 b8 a5 1b 80 00 00 	movabs $0x801ba5,%rax
  803fee:	00 00 00 
  803ff1:	ff d0                	callq  *%rax
  803ff3:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803ff6:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803ffa:	75 0c                	jne    804008 <ipc_send+0x5a>
			sys_yield();
  803ffc:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  804003:	00 00 00 
  804006:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804008:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80400c:	74 ca                	je     803fd8 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  80400e:	c9                   	leaveq 
  80400f:	c3                   	retq   

0000000000804010 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804010:	55                   	push   %rbp
  804011:	48 89 e5             	mov    %rsp,%rbp
  804014:	48 83 ec 14          	sub    $0x14,%rsp
  804018:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80401b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804022:	eb 5e                	jmp    804082 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804024:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80402b:	00 00 00 
  80402e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804031:	48 63 d0             	movslq %eax,%rdx
  804034:	48 89 d0             	mov    %rdx,%rax
  804037:	48 c1 e0 03          	shl    $0x3,%rax
  80403b:	48 01 d0             	add    %rdx,%rax
  80403e:	48 c1 e0 05          	shl    $0x5,%rax
  804042:	48 01 c8             	add    %rcx,%rax
  804045:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80404b:	8b 00                	mov    (%rax),%eax
  80404d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804050:	75 2c                	jne    80407e <ipc_find_env+0x6e>
			return envs[i].env_id;
  804052:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804059:	00 00 00 
  80405c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80405f:	48 63 d0             	movslq %eax,%rdx
  804062:	48 89 d0             	mov    %rdx,%rax
  804065:	48 c1 e0 03          	shl    $0x3,%rax
  804069:	48 01 d0             	add    %rdx,%rax
  80406c:	48 c1 e0 05          	shl    $0x5,%rax
  804070:	48 01 c8             	add    %rcx,%rax
  804073:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804079:	8b 40 08             	mov    0x8(%rax),%eax
  80407c:	eb 12                	jmp    804090 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80407e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804082:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804089:	7e 99                	jle    804024 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80408b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804090:	c9                   	leaveq 
  804091:	c3                   	retq   

0000000000804092 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804092:	55                   	push   %rbp
  804093:	48 89 e5             	mov    %rsp,%rbp
  804096:	48 83 ec 18          	sub    $0x18,%rsp
  80409a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80409e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040a2:	48 c1 e8 15          	shr    $0x15,%rax
  8040a6:	48 89 c2             	mov    %rax,%rdx
  8040a9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8040b0:	01 00 00 
  8040b3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040b7:	83 e0 01             	and    $0x1,%eax
  8040ba:	48 85 c0             	test   %rax,%rax
  8040bd:	75 07                	jne    8040c6 <pageref+0x34>
		return 0;
  8040bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8040c4:	eb 53                	jmp    804119 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8040c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040ca:	48 c1 e8 0c          	shr    $0xc,%rax
  8040ce:	48 89 c2             	mov    %rax,%rdx
  8040d1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8040d8:	01 00 00 
  8040db:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8040e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040e7:	83 e0 01             	and    $0x1,%eax
  8040ea:	48 85 c0             	test   %rax,%rax
  8040ed:	75 07                	jne    8040f6 <pageref+0x64>
		return 0;
  8040ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8040f4:	eb 23                	jmp    804119 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8040f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040fa:	48 c1 e8 0c          	shr    $0xc,%rax
  8040fe:	48 89 c2             	mov    %rax,%rdx
  804101:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804108:	00 00 00 
  80410b:	48 c1 e2 04          	shl    $0x4,%rdx
  80410f:	48 01 d0             	add    %rdx,%rax
  804112:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804116:	0f b7 c0             	movzwl %ax,%eax
}
  804119:	c9                   	leaveq 
  80411a:	c3                   	retq   

000000000080411b <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  80411b:	55                   	push   %rbp
  80411c:	48 89 e5             	mov    %rsp,%rbp
  80411f:	48 83 ec 20          	sub    $0x20,%rsp
  804123:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  804127:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80412b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80412f:	48 89 d6             	mov    %rdx,%rsi
  804132:	48 89 c7             	mov    %rax,%rdi
  804135:	48 b8 51 41 80 00 00 	movabs $0x804151,%rax
  80413c:	00 00 00 
  80413f:	ff d0                	callq  *%rax
  804141:	85 c0                	test   %eax,%eax
  804143:	74 05                	je     80414a <inet_addr+0x2f>
    return (val.s_addr);
  804145:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804148:	eb 05                	jmp    80414f <inet_addr+0x34>
  }
  return (INADDR_NONE);
  80414a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  80414f:	c9                   	leaveq 
  804150:	c3                   	retq   

0000000000804151 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  804151:	55                   	push   %rbp
  804152:	48 89 e5             	mov    %rsp,%rbp
  804155:	48 83 ec 40          	sub    $0x40,%rsp
  804159:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80415d:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  804161:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804165:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  c = *cp;
  804169:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80416d:	0f b6 00             	movzbl (%rax),%eax
  804170:	0f be c0             	movsbl %al,%eax
  804173:	89 45 f4             	mov    %eax,-0xc(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  804176:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804179:	3c 2f                	cmp    $0x2f,%al
  80417b:	76 07                	jbe    804184 <inet_aton+0x33>
  80417d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804180:	3c 39                	cmp    $0x39,%al
  804182:	76 0a                	jbe    80418e <inet_aton+0x3d>
      return (0);
  804184:	b8 00 00 00 00       	mov    $0x0,%eax
  804189:	e9 68 02 00 00       	jmpq   8043f6 <inet_aton+0x2a5>
    val = 0;
  80418e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    base = 10;
  804195:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    if (c == '0') {
  80419c:	83 7d f4 30          	cmpl   $0x30,-0xc(%rbp)
  8041a0:	75 40                	jne    8041e2 <inet_aton+0x91>
      c = *++cp;
  8041a2:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8041a7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041ab:	0f b6 00             	movzbl (%rax),%eax
  8041ae:	0f be c0             	movsbl %al,%eax
  8041b1:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if (c == 'x' || c == 'X') {
  8041b4:	83 7d f4 78          	cmpl   $0x78,-0xc(%rbp)
  8041b8:	74 06                	je     8041c0 <inet_aton+0x6f>
  8041ba:	83 7d f4 58          	cmpl   $0x58,-0xc(%rbp)
  8041be:	75 1b                	jne    8041db <inet_aton+0x8a>
        base = 16;
  8041c0:	c7 45 f8 10 00 00 00 	movl   $0x10,-0x8(%rbp)
        c = *++cp;
  8041c7:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8041cc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041d0:	0f b6 00             	movzbl (%rax),%eax
  8041d3:	0f be c0             	movsbl %al,%eax
  8041d6:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8041d9:	eb 07                	jmp    8041e2 <inet_aton+0x91>
      } else
        base = 8;
  8041db:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  8041e2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8041e5:	3c 2f                	cmp    $0x2f,%al
  8041e7:	76 2f                	jbe    804218 <inet_aton+0xc7>
  8041e9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8041ec:	3c 39                	cmp    $0x39,%al
  8041ee:	77 28                	ja     804218 <inet_aton+0xc7>
        val = (val * base) + (int)(c - '0');
  8041f0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041f3:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  8041f7:	89 c2                	mov    %eax,%edx
  8041f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8041fc:	01 d0                	add    %edx,%eax
  8041fe:	83 e8 30             	sub    $0x30,%eax
  804201:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  804204:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804209:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80420d:	0f b6 00             	movzbl (%rax),%eax
  804210:	0f be c0             	movsbl %al,%eax
  804213:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else if (base == 16 && isxdigit(c)) {
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
  804216:	eb ca                	jmp    8041e2 <inet_aton+0x91>
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  804218:	83 7d f8 10          	cmpl   $0x10,-0x8(%rbp)
  80421c:	75 72                	jne    804290 <inet_aton+0x13f>
  80421e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804221:	3c 2f                	cmp    $0x2f,%al
  804223:	76 07                	jbe    80422c <inet_aton+0xdb>
  804225:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804228:	3c 39                	cmp    $0x39,%al
  80422a:	76 1c                	jbe    804248 <inet_aton+0xf7>
  80422c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80422f:	3c 60                	cmp    $0x60,%al
  804231:	76 07                	jbe    80423a <inet_aton+0xe9>
  804233:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804236:	3c 66                	cmp    $0x66,%al
  804238:	76 0e                	jbe    804248 <inet_aton+0xf7>
  80423a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80423d:	3c 40                	cmp    $0x40,%al
  80423f:	76 4f                	jbe    804290 <inet_aton+0x13f>
  804241:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804244:	3c 46                	cmp    $0x46,%al
  804246:	77 48                	ja     804290 <inet_aton+0x13f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  804248:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80424b:	c1 e0 04             	shl    $0x4,%eax
  80424e:	89 c2                	mov    %eax,%edx
  804250:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804253:	8d 48 0a             	lea    0xa(%rax),%ecx
  804256:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804259:	3c 60                	cmp    $0x60,%al
  80425b:	76 0e                	jbe    80426b <inet_aton+0x11a>
  80425d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804260:	3c 7a                	cmp    $0x7a,%al
  804262:	77 07                	ja     80426b <inet_aton+0x11a>
  804264:	b8 61 00 00 00       	mov    $0x61,%eax
  804269:	eb 05                	jmp    804270 <inet_aton+0x11f>
  80426b:	b8 41 00 00 00       	mov    $0x41,%eax
  804270:	29 c1                	sub    %eax,%ecx
  804272:	89 c8                	mov    %ecx,%eax
  804274:	09 d0                	or     %edx,%eax
  804276:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  804279:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  80427e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804282:	0f b6 00             	movzbl (%rax),%eax
  804285:	0f be c0             	movsbl %al,%eax
  804288:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else
        break;
    }
  80428b:	e9 52 ff ff ff       	jmpq   8041e2 <inet_aton+0x91>
    if (c == '.') {
  804290:	83 7d f4 2e          	cmpl   $0x2e,-0xc(%rbp)
  804294:	75 40                	jne    8042d6 <inet_aton+0x185>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  804296:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80429a:	48 83 c0 0c          	add    $0xc,%rax
  80429e:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  8042a2:	72 0a                	jb     8042ae <inet_aton+0x15d>
        return (0);
  8042a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8042a9:	e9 48 01 00 00       	jmpq   8043f6 <inet_aton+0x2a5>
      *pp++ = val;
  8042ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042b2:	48 8d 50 04          	lea    0x4(%rax),%rdx
  8042b6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8042ba:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8042bd:	89 10                	mov    %edx,(%rax)
      c = *++cp;
  8042bf:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8042c4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8042c8:	0f b6 00             	movzbl (%rax),%eax
  8042cb:	0f be c0             	movsbl %al,%eax
  8042ce:	89 45 f4             	mov    %eax,-0xc(%rbp)
    } else
      break;
  }
  8042d1:	e9 a0 fe ff ff       	jmpq   804176 <inet_aton+0x25>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  8042d6:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8042d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8042db:	74 3c                	je     804319 <inet_aton+0x1c8>
  8042dd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8042e0:	3c 1f                	cmp    $0x1f,%al
  8042e2:	76 2b                	jbe    80430f <inet_aton+0x1be>
  8042e4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8042e7:	84 c0                	test   %al,%al
  8042e9:	78 24                	js     80430f <inet_aton+0x1be>
  8042eb:	83 7d f4 20          	cmpl   $0x20,-0xc(%rbp)
  8042ef:	74 28                	je     804319 <inet_aton+0x1c8>
  8042f1:	83 7d f4 0c          	cmpl   $0xc,-0xc(%rbp)
  8042f5:	74 22                	je     804319 <inet_aton+0x1c8>
  8042f7:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8042fb:	74 1c                	je     804319 <inet_aton+0x1c8>
  8042fd:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  804301:	74 16                	je     804319 <inet_aton+0x1c8>
  804303:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  804307:	74 10                	je     804319 <inet_aton+0x1c8>
  804309:	83 7d f4 0b          	cmpl   $0xb,-0xc(%rbp)
  80430d:	74 0a                	je     804319 <inet_aton+0x1c8>
    return (0);
  80430f:	b8 00 00 00 00       	mov    $0x0,%eax
  804314:	e9 dd 00 00 00       	jmpq   8043f6 <inet_aton+0x2a5>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  804319:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80431d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804321:	48 29 c2             	sub    %rax,%rdx
  804324:	48 89 d0             	mov    %rdx,%rax
  804327:	48 c1 f8 02          	sar    $0x2,%rax
  80432b:	83 c0 01             	add    $0x1,%eax
  80432e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  switch (n) {
  804331:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  804335:	0f 87 98 00 00 00    	ja     8043d3 <inet_aton+0x282>
  80433b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80433e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804345:	00 
  804346:	48 b8 90 4d 80 00 00 	movabs $0x804d90,%rax
  80434d:	00 00 00 
  804350:	48 01 d0             	add    %rdx,%rax
  804353:	48 8b 00             	mov    (%rax),%rax
  804356:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  804358:	b8 00 00 00 00       	mov    $0x0,%eax
  80435d:	e9 94 00 00 00       	jmpq   8043f6 <inet_aton+0x2a5>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  804362:	81 7d fc ff ff ff 00 	cmpl   $0xffffff,-0x4(%rbp)
  804369:	76 0a                	jbe    804375 <inet_aton+0x224>
      return (0);
  80436b:	b8 00 00 00 00       	mov    $0x0,%eax
  804370:	e9 81 00 00 00       	jmpq   8043f6 <inet_aton+0x2a5>
    val |= parts[0] << 24;
  804375:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804378:	c1 e0 18             	shl    $0x18,%eax
  80437b:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80437e:	eb 53                	jmp    8043d3 <inet_aton+0x282>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  804380:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%rbp)
  804387:	76 07                	jbe    804390 <inet_aton+0x23f>
      return (0);
  804389:	b8 00 00 00 00       	mov    $0x0,%eax
  80438e:	eb 66                	jmp    8043f6 <inet_aton+0x2a5>
    val |= (parts[0] << 24) | (parts[1] << 16);
  804390:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804393:	c1 e0 18             	shl    $0x18,%eax
  804396:	89 c2                	mov    %eax,%edx
  804398:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80439b:	c1 e0 10             	shl    $0x10,%eax
  80439e:	09 d0                	or     %edx,%eax
  8043a0:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8043a3:	eb 2e                	jmp    8043d3 <inet_aton+0x282>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  8043a5:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
  8043ac:	76 07                	jbe    8043b5 <inet_aton+0x264>
      return (0);
  8043ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8043b3:	eb 41                	jmp    8043f6 <inet_aton+0x2a5>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8043b5:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8043b8:	c1 e0 18             	shl    $0x18,%eax
  8043bb:	89 c2                	mov    %eax,%edx
  8043bd:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8043c0:	c1 e0 10             	shl    $0x10,%eax
  8043c3:	09 c2                	or     %eax,%edx
  8043c5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8043c8:	c1 e0 08             	shl    $0x8,%eax
  8043cb:	09 d0                	or     %edx,%eax
  8043cd:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8043d0:	eb 01                	jmp    8043d3 <inet_aton+0x282>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  8043d2:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  8043d3:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  8043d8:	74 17                	je     8043f1 <inet_aton+0x2a0>
    addr->s_addr = htonl(val);
  8043da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043dd:	89 c7                	mov    %eax,%edi
  8043df:	48 b8 6f 45 80 00 00 	movabs $0x80456f,%rax
  8043e6:	00 00 00 
  8043e9:	ff d0                	callq  *%rax
  8043eb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8043ef:	89 02                	mov    %eax,(%rdx)
  return (1);
  8043f1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8043f6:	c9                   	leaveq 
  8043f7:	c3                   	retq   

00000000008043f8 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8043f8:	55                   	push   %rbp
  8043f9:	48 89 e5             	mov    %rsp,%rbp
  8043fc:	48 83 ec 30          	sub    $0x30,%rsp
  804400:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  804403:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804406:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  804409:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804410:	00 00 00 
  804413:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  804417:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80441b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  80441f:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  804423:	e9 e0 00 00 00       	jmpq   804508 <inet_ntoa+0x110>
    i = 0;
  804428:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  80442c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804430:	0f b6 08             	movzbl (%rax),%ecx
  804433:	0f b6 d1             	movzbl %cl,%edx
  804436:	89 d0                	mov    %edx,%eax
  804438:	c1 e0 02             	shl    $0x2,%eax
  80443b:	01 d0                	add    %edx,%eax
  80443d:	c1 e0 03             	shl    $0x3,%eax
  804440:	01 d0                	add    %edx,%eax
  804442:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  804449:	01 d0                	add    %edx,%eax
  80444b:	66 c1 e8 08          	shr    $0x8,%ax
  80444f:	c0 e8 03             	shr    $0x3,%al
  804452:	88 45 ed             	mov    %al,-0x13(%rbp)
  804455:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  804459:	89 d0                	mov    %edx,%eax
  80445b:	c1 e0 02             	shl    $0x2,%eax
  80445e:	01 d0                	add    %edx,%eax
  804460:	01 c0                	add    %eax,%eax
  804462:	29 c1                	sub    %eax,%ecx
  804464:	89 c8                	mov    %ecx,%eax
  804466:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  804469:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80446d:	0f b6 00             	movzbl (%rax),%eax
  804470:	0f b6 d0             	movzbl %al,%edx
  804473:	89 d0                	mov    %edx,%eax
  804475:	c1 e0 02             	shl    $0x2,%eax
  804478:	01 d0                	add    %edx,%eax
  80447a:	c1 e0 03             	shl    $0x3,%eax
  80447d:	01 d0                	add    %edx,%eax
  80447f:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  804486:	01 d0                	add    %edx,%eax
  804488:	66 c1 e8 08          	shr    $0x8,%ax
  80448c:	89 c2                	mov    %eax,%edx
  80448e:	c0 ea 03             	shr    $0x3,%dl
  804491:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804495:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  804497:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  80449b:	8d 50 01             	lea    0x1(%rax),%edx
  80449e:	88 55 ee             	mov    %dl,-0x12(%rbp)
  8044a1:	0f b6 c0             	movzbl %al,%eax
  8044a4:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  8044a8:	83 c2 30             	add    $0x30,%edx
  8044ab:	48 98                	cltq   
  8044ad:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    } while(*ap);
  8044b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044b5:	0f b6 00             	movzbl (%rax),%eax
  8044b8:	84 c0                	test   %al,%al
  8044ba:	0f 85 6c ff ff ff    	jne    80442c <inet_ntoa+0x34>
    while(i--)
  8044c0:	eb 1a                	jmp    8044dc <inet_ntoa+0xe4>
      *rp++ = inv[i];
  8044c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044c6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8044ca:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  8044ce:	0f b6 55 ee          	movzbl -0x12(%rbp),%edx
  8044d2:	48 63 d2             	movslq %edx,%rdx
  8044d5:	0f b6 54 15 e0       	movzbl -0x20(%rbp,%rdx,1),%edx
  8044da:	88 10                	mov    %dl,(%rax)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  8044dc:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  8044e0:	8d 50 ff             	lea    -0x1(%rax),%edx
  8044e3:	88 55 ee             	mov    %dl,-0x12(%rbp)
  8044e6:	84 c0                	test   %al,%al
  8044e8:	75 d8                	jne    8044c2 <inet_ntoa+0xca>
      *rp++ = inv[i];
    *rp++ = '.';
  8044ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044ee:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8044f2:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  8044f6:	c6 00 2e             	movb   $0x2e,(%rax)
    ap++;
  8044f9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8044fe:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  804502:	83 c0 01             	add    $0x1,%eax
  804505:	88 45 ef             	mov    %al,-0x11(%rbp)
  804508:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  80450c:	0f 86 16 ff ff ff    	jbe    804428 <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  804512:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  804517:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80451b:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  80451e:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804525:	00 00 00 
}
  804528:	c9                   	leaveq 
  804529:	c3                   	retq   

000000000080452a <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  80452a:	55                   	push   %rbp
  80452b:	48 89 e5             	mov    %rsp,%rbp
  80452e:	48 83 ec 04          	sub    $0x4,%rsp
  804532:	89 f8                	mov    %edi,%eax
  804534:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  804538:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  80453c:	c1 e0 08             	shl    $0x8,%eax
  80453f:	89 c2                	mov    %eax,%edx
  804541:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804545:	66 c1 e8 08          	shr    $0x8,%ax
  804549:	09 d0                	or     %edx,%eax
}
  80454b:	c9                   	leaveq 
  80454c:	c3                   	retq   

000000000080454d <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  80454d:	55                   	push   %rbp
  80454e:	48 89 e5             	mov    %rsp,%rbp
  804551:	48 83 ec 08          	sub    $0x8,%rsp
  804555:	89 f8                	mov    %edi,%eax
  804557:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  80455b:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  80455f:	89 c7                	mov    %eax,%edi
  804561:	48 b8 2a 45 80 00 00 	movabs $0x80452a,%rax
  804568:	00 00 00 
  80456b:	ff d0                	callq  *%rax
}
  80456d:	c9                   	leaveq 
  80456e:	c3                   	retq   

000000000080456f <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  80456f:	55                   	push   %rbp
  804570:	48 89 e5             	mov    %rsp,%rbp
  804573:	48 83 ec 04          	sub    $0x4,%rsp
  804577:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  80457a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80457d:	c1 e0 18             	shl    $0x18,%eax
  804580:	89 c2                	mov    %eax,%edx
    ((n & 0xff00) << 8) |
  804582:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804585:	25 00 ff 00 00       	and    $0xff00,%eax
  80458a:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80458d:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  80458f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804592:	25 00 00 ff 00       	and    $0xff0000,%eax
  804597:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80459b:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  80459d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045a0:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8045a3:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  8045a5:	c9                   	leaveq 
  8045a6:	c3                   	retq   

00000000008045a7 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8045a7:	55                   	push   %rbp
  8045a8:	48 89 e5             	mov    %rsp,%rbp
  8045ab:	48 83 ec 08          	sub    $0x8,%rsp
  8045af:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  8045b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045b5:	89 c7                	mov    %eax,%edi
  8045b7:	48 b8 6f 45 80 00 00 	movabs $0x80456f,%rax
  8045be:	00 00 00 
  8045c1:	ff d0                	callq  *%rax
}
  8045c3:	c9                   	leaveq 
  8045c4:	c3                   	retq   
