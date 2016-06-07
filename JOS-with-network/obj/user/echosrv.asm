
obj/user/echosrv.debug:     file format elf64-x86-64


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
  80003c:	e8 f7 02 00 00       	callq  800338 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <die>:
#define BUFFSIZE 32
#define MAXPENDING 5    // Max connection requests

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
  800056:	48 bf 00 46 80 00 00 	movabs $0x804600,%rdi
  80005d:	00 00 00 
  800060:	b8 00 00 00 00       	mov    $0x0,%eax
  800065:	48 ba 0b 05 80 00 00 	movabs $0x80050b,%rdx
  80006c:	00 00 00 
  80006f:	ff d2                	callq  *%rdx
	exit();
  800071:	48 b8 c3 03 80 00 00 	movabs $0x8003c3,%rax
  800078:	00 00 00 
  80007b:	ff d0                	callq  *%rax
}
  80007d:	c9                   	leaveq 
  80007e:	c3                   	retq   

000000000080007f <handle_client>:

void
handle_client(int sock)
{
  80007f:	55                   	push   %rbp
  800080:	48 89 e5             	mov    %rsp,%rbp
  800083:	48 83 ec 40          	sub    $0x40,%rsp
  800087:	89 7d cc             	mov    %edi,-0x34(%rbp)
	char buffer[BUFFSIZE];
	int received = -1;
  80008a:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  800091:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  800095:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800098:	ba 20 00 00 00       	mov    $0x20,%edx
  80009d:	48 89 ce             	mov    %rcx,%rsi
  8000a0:	89 c7                	mov    %eax,%edi
  8000a2:	48 b8 3e 22 80 00 00 	movabs $0x80223e,%rax
  8000a9:	00 00 00 
  8000ac:	ff d0                	callq  *%rax
  8000ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b5:	79 18                	jns    8000cf <handle_client+0x50>
		die("Failed to receive initial bytes from client");
  8000b7:	48 bf 08 46 80 00 00 	movabs $0x804608,%rdi
  8000be:	00 00 00 
  8000c1:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000c8:	00 00 00 
  8000cb:	ff d0                	callq  *%rax

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
  8000cd:	eb 77                	jmp    800146 <handle_client+0xc7>
  8000cf:	eb 75                	jmp    800146 <handle_client+0xc7>
		// Send back received data
		if (write(sock, buffer, received) != received)
  8000d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d4:	48 63 d0             	movslq %eax,%rdx
  8000d7:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  8000db:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8000de:	48 89 ce             	mov    %rcx,%rsi
  8000e1:	89 c7                	mov    %eax,%edi
  8000e3:	48 b8 88 23 80 00 00 	movabs $0x802388,%rax
  8000ea:	00 00 00 
  8000ed:	ff d0                	callq  *%rax
  8000ef:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8000f2:	74 16                	je     80010a <handle_client+0x8b>
			die("Failed to send bytes to client");
  8000f4:	48 bf 38 46 80 00 00 	movabs $0x804638,%rdi
  8000fb:	00 00 00 
  8000fe:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800105:	00 00 00 
  800108:	ff d0                	callq  *%rax

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80010a:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  80010e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800111:	ba 20 00 00 00       	mov    $0x20,%edx
  800116:	48 89 ce             	mov    %rcx,%rsi
  800119:	89 c7                	mov    %eax,%edi
  80011b:	48 b8 3e 22 80 00 00 	movabs $0x80223e,%rax
  800122:	00 00 00 
  800125:	ff d0                	callq  *%rax
  800127:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80012a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80012e:	79 16                	jns    800146 <handle_client+0xc7>
			die("Failed to receive additional bytes from client");
  800130:	48 bf 58 46 80 00 00 	movabs $0x804658,%rdi
  800137:	00 00 00 
  80013a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800141:	00 00 00 
  800144:	ff d0                	callq  *%rax
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
  800146:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80014a:	7f 85                	jg     8000d1 <handle_client+0x52>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
			die("Failed to receive additional bytes from client");
	}
	close(sock);
  80014c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80014f:	89 c7                	mov    %eax,%edi
  800151:	48 b8 1c 20 80 00 00 	movabs $0x80201c,%rax
  800158:	00 00 00 
  80015b:	ff d0                	callq  *%rax
}
  80015d:	c9                   	leaveq 
  80015e:	c3                   	retq   

000000000080015f <umain>:

void
umain(int argc, char **argv)
{
  80015f:	55                   	push   %rbp
  800160:	48 89 e5             	mov    %rsp,%rbp
  800163:	48 83 ec 70          	sub    $0x70,%rsp
  800167:	89 7d 9c             	mov    %edi,-0x64(%rbp)
  80016a:	48 89 75 90          	mov    %rsi,-0x70(%rbp)
	int serversock, clientsock;
	struct sockaddr_in echoserver, echoclient;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;
  80016e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800175:	ba 06 00 00 00       	mov    $0x6,%edx
  80017a:	be 01 00 00 00       	mov    $0x1,%esi
  80017f:	bf 02 00 00 00       	mov    $0x2,%edi
  800184:	48 b8 9f 30 80 00 00 	movabs $0x80309f,%rax
  80018b:	00 00 00 
  80018e:	ff d0                	callq  *%rax
  800190:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800193:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800197:	79 16                	jns    8001af <umain+0x50>
		die("Failed to create socket");
  800199:	48 bf 87 46 80 00 00 	movabs $0x804687,%rdi
  8001a0:	00 00 00 
  8001a3:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001aa:	00 00 00 
  8001ad:	ff d0                	callq  *%rax

	cprintf("opened socket\n");
  8001af:	48 bf 9f 46 80 00 00 	movabs $0x80469f,%rdi
  8001b6:	00 00 00 
  8001b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001be:	48 ba 0b 05 80 00 00 	movabs $0x80050b,%rdx
  8001c5:	00 00 00 
  8001c8:	ff d2                	callq  *%rdx

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  8001ca:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8001ce:	ba 10 00 00 00       	mov    $0x10,%edx
  8001d3:	be 00 00 00 00       	mov    $0x0,%esi
  8001d8:	48 89 c7             	mov    %rax,%rdi
  8001db:	48 b8 59 13 80 00 00 	movabs $0x801359,%rax
  8001e2:	00 00 00 
  8001e5:	ff d0                	callq  *%rax
	echoserver.sin_family = AF_INET;                  // Internet/IP
  8001e7:	c6 45 e1 02          	movb   $0x2,-0x1f(%rbp)
	echoserver.sin_addr.s_addr = htonl(INADDR_ANY);   // IP address
  8001eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f0:	48 b8 8d 45 80 00 00 	movabs $0x80458d,%rax
  8001f7:	00 00 00 
  8001fa:	ff d0                	callq  *%rax
  8001fc:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	echoserver.sin_port = htons(PORT);		  // server port
  8001ff:	bf 07 00 00 00       	mov    $0x7,%edi
  800204:	48 b8 48 45 80 00 00 	movabs $0x804548,%rax
  80020b:	00 00 00 
  80020e:	ff d0                	callq  *%rax
  800210:	66 89 45 e2          	mov    %ax,-0x1e(%rbp)

	cprintf("trying to bind\n");
  800214:	48 bf ae 46 80 00 00 	movabs $0x8046ae,%rdi
  80021b:	00 00 00 
  80021e:	b8 00 00 00 00       	mov    $0x0,%eax
  800223:	48 ba 0b 05 80 00 00 	movabs $0x80050b,%rdx
  80022a:	00 00 00 
  80022d:	ff d2                	callq  *%rdx

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  80022f:	48 8d 4d e0          	lea    -0x20(%rbp),%rcx
  800233:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800236:	ba 10 00 00 00       	mov    $0x10,%edx
  80023b:	48 89 ce             	mov    %rcx,%rsi
  80023e:	89 c7                	mov    %eax,%edi
  800240:	48 b8 8f 2e 80 00 00 	movabs $0x802e8f,%rax
  800247:	00 00 00 
  80024a:	ff d0                	callq  *%rax
  80024c:	85 c0                	test   %eax,%eax
  80024e:	79 16                	jns    800266 <umain+0x107>
		 sizeof(echoserver)) < 0) {
		die("Failed to bind the server socket");
  800250:	48 bf c0 46 80 00 00 	movabs $0x8046c0,%rdi
  800257:	00 00 00 
  80025a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800261:	00 00 00 
  800264:	ff d0                	callq  *%rax
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800266:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800269:	be 05 00 00 00       	mov    $0x5,%esi
  80026e:	89 c7                	mov    %eax,%edi
  800270:	48 b8 b2 2f 80 00 00 	movabs $0x802fb2,%rax
  800277:	00 00 00 
  80027a:	ff d0                	callq  *%rax
  80027c:	85 c0                	test   %eax,%eax
  80027e:	79 16                	jns    800296 <umain+0x137>
		die("Failed to listen on server socket");
  800280:	48 bf e8 46 80 00 00 	movabs $0x8046e8,%rdi
  800287:	00 00 00 
  80028a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800291:	00 00 00 
  800294:	ff d0                	callq  *%rax

	cprintf("bound\n");
  800296:	48 bf 0a 47 80 00 00 	movabs $0x80470a,%rdi
  80029d:	00 00 00 
  8002a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a5:	48 ba 0b 05 80 00 00 	movabs $0x80050b,%rdx
  8002ac:	00 00 00 
  8002af:	ff d2                	callq  *%rdx

	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
  8002b1:	c7 45 ac 10 00 00 00 	movl   $0x10,-0x54(%rbp)
		// Wait for client connection
		if ((clientsock =
  8002b8:	48 8d 55 ac          	lea    -0x54(%rbp),%rdx
  8002bc:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  8002c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002c3:	48 89 ce             	mov    %rcx,%rsi
  8002c6:	89 c7                	mov    %eax,%edi
  8002c8:	48 b8 20 2e 80 00 00 	movabs $0x802e20,%rax
  8002cf:	00 00 00 
  8002d2:	ff d0                	callq  *%rax
  8002d4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8002d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8002db:	79 16                	jns    8002f3 <umain+0x194>
		     accept(serversock, (struct sockaddr *) &echoclient,
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
  8002dd:	48 bf 18 47 80 00 00 	movabs $0x804718,%rdi
  8002e4:	00 00 00 
  8002e7:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002ee:	00 00 00 
  8002f1:	ff d0                	callq  *%rax
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  8002f3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8002f6:	89 c7                	mov    %eax,%edi
  8002f8:	48 b8 16 44 80 00 00 	movabs $0x804416,%rax
  8002ff:	00 00 00 
  800302:	ff d0                	callq  *%rax
  800304:	48 89 c6             	mov    %rax,%rsi
  800307:	48 bf 3b 47 80 00 00 	movabs $0x80473b,%rdi
  80030e:	00 00 00 
  800311:	b8 00 00 00 00       	mov    $0x0,%eax
  800316:	48 ba 0b 05 80 00 00 	movabs $0x80050b,%rdx
  80031d:	00 00 00 
  800320:	ff d2                	callq  *%rdx
		handle_client(clientsock);
  800322:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800325:	89 c7                	mov    %eax,%edi
  800327:	48 b8 7f 00 80 00 00 	movabs $0x80007f,%rax
  80032e:	00 00 00 
  800331:	ff d0                	callq  *%rax
	}
  800333:	e9 79 ff ff ff       	jmpq   8002b1 <umain+0x152>

0000000000800338 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800338:	55                   	push   %rbp
  800339:	48 89 e5             	mov    %rsp,%rbp
  80033c:	48 83 ec 10          	sub    $0x10,%rsp
  800340:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800343:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800347:	48 b8 73 19 80 00 00 	movabs $0x801973,%rax
  80034e:	00 00 00 
  800351:	ff d0                	callq  *%rax
  800353:	25 ff 03 00 00       	and    $0x3ff,%eax
  800358:	48 63 d0             	movslq %eax,%rdx
  80035b:	48 89 d0             	mov    %rdx,%rax
  80035e:	48 c1 e0 03          	shl    $0x3,%rax
  800362:	48 01 d0             	add    %rdx,%rax
  800365:	48 c1 e0 05          	shl    $0x5,%rax
  800369:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800370:	00 00 00 
  800373:	48 01 c2             	add    %rax,%rdx
  800376:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80037d:	00 00 00 
  800380:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800383:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800387:	7e 14                	jle    80039d <libmain+0x65>
		binaryname = argv[0];
  800389:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80038d:	48 8b 10             	mov    (%rax),%rdx
  800390:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800397:	00 00 00 
  80039a:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80039d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a4:	48 89 d6             	mov    %rdx,%rsi
  8003a7:	89 c7                	mov    %eax,%edi
  8003a9:	48 b8 5f 01 80 00 00 	movabs $0x80015f,%rax
  8003b0:	00 00 00 
  8003b3:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8003b5:	48 b8 c3 03 80 00 00 	movabs $0x8003c3,%rax
  8003bc:	00 00 00 
  8003bf:	ff d0                	callq  *%rax
}
  8003c1:	c9                   	leaveq 
  8003c2:	c3                   	retq   

00000000008003c3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003c3:	55                   	push   %rbp
  8003c4:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003c7:	48 b8 67 20 80 00 00 	movabs $0x802067,%rax
  8003ce:	00 00 00 
  8003d1:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8003d8:	48 b8 2f 19 80 00 00 	movabs $0x80192f,%rax
  8003df:	00 00 00 
  8003e2:	ff d0                	callq  *%rax

}
  8003e4:	5d                   	pop    %rbp
  8003e5:	c3                   	retq   

00000000008003e6 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8003e6:	55                   	push   %rbp
  8003e7:	48 89 e5             	mov    %rsp,%rbp
  8003ea:	48 83 ec 10          	sub    $0x10,%rsp
  8003ee:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003f1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f9:	8b 00                	mov    (%rax),%eax
  8003fb:	8d 48 01             	lea    0x1(%rax),%ecx
  8003fe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800402:	89 0a                	mov    %ecx,(%rdx)
  800404:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800407:	89 d1                	mov    %edx,%ecx
  800409:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80040d:	48 98                	cltq   
  80040f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800413:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800417:	8b 00                	mov    (%rax),%eax
  800419:	3d ff 00 00 00       	cmp    $0xff,%eax
  80041e:	75 2c                	jne    80044c <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800420:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800424:	8b 00                	mov    (%rax),%eax
  800426:	48 98                	cltq   
  800428:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80042c:	48 83 c2 08          	add    $0x8,%rdx
  800430:	48 89 c6             	mov    %rax,%rsi
  800433:	48 89 d7             	mov    %rdx,%rdi
  800436:	48 b8 a7 18 80 00 00 	movabs $0x8018a7,%rax
  80043d:	00 00 00 
  800440:	ff d0                	callq  *%rax
        b->idx = 0;
  800442:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800446:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80044c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800450:	8b 40 04             	mov    0x4(%rax),%eax
  800453:	8d 50 01             	lea    0x1(%rax),%edx
  800456:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80045a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80045d:	c9                   	leaveq 
  80045e:	c3                   	retq   

000000000080045f <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80045f:	55                   	push   %rbp
  800460:	48 89 e5             	mov    %rsp,%rbp
  800463:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80046a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800471:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800478:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80047f:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800486:	48 8b 0a             	mov    (%rdx),%rcx
  800489:	48 89 08             	mov    %rcx,(%rax)
  80048c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800490:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800494:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800498:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80049c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004a3:	00 00 00 
    b.cnt = 0;
  8004a6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004ad:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8004b0:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004b7:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004be:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004c5:	48 89 c6             	mov    %rax,%rsi
  8004c8:	48 bf e6 03 80 00 00 	movabs $0x8003e6,%rdi
  8004cf:	00 00 00 
  8004d2:	48 b8 be 08 80 00 00 	movabs $0x8008be,%rax
  8004d9:	00 00 00 
  8004dc:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8004de:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8004e4:	48 98                	cltq   
  8004e6:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004ed:	48 83 c2 08          	add    $0x8,%rdx
  8004f1:	48 89 c6             	mov    %rax,%rsi
  8004f4:	48 89 d7             	mov    %rdx,%rdi
  8004f7:	48 b8 a7 18 80 00 00 	movabs $0x8018a7,%rax
  8004fe:	00 00 00 
  800501:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800503:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800509:	c9                   	leaveq 
  80050a:	c3                   	retq   

000000000080050b <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80050b:	55                   	push   %rbp
  80050c:	48 89 e5             	mov    %rsp,%rbp
  80050f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800516:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80051d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800524:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80052b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800532:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800539:	84 c0                	test   %al,%al
  80053b:	74 20                	je     80055d <cprintf+0x52>
  80053d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800541:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800545:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800549:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80054d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800551:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800555:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800559:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80055d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800564:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80056b:	00 00 00 
  80056e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800575:	00 00 00 
  800578:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80057c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800583:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80058a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800591:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800598:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80059f:	48 8b 0a             	mov    (%rdx),%rcx
  8005a2:	48 89 08             	mov    %rcx,(%rax)
  8005a5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005a9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005ad:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005b1:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8005b5:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005bc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005c3:	48 89 d6             	mov    %rdx,%rsi
  8005c6:	48 89 c7             	mov    %rax,%rdi
  8005c9:	48 b8 5f 04 80 00 00 	movabs $0x80045f,%rax
  8005d0:	00 00 00 
  8005d3:	ff d0                	callq  *%rax
  8005d5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8005db:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005e1:	c9                   	leaveq 
  8005e2:	c3                   	retq   

00000000008005e3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005e3:	55                   	push   %rbp
  8005e4:	48 89 e5             	mov    %rsp,%rbp
  8005e7:	53                   	push   %rbx
  8005e8:	48 83 ec 38          	sub    $0x38,%rsp
  8005ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005f0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005f4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8005f8:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8005fb:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005ff:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800603:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800606:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80060a:	77 3b                	ja     800647 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80060c:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80060f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800613:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800616:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80061a:	ba 00 00 00 00       	mov    $0x0,%edx
  80061f:	48 f7 f3             	div    %rbx
  800622:	48 89 c2             	mov    %rax,%rdx
  800625:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800628:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80062b:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80062f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800633:	41 89 f9             	mov    %edi,%r9d
  800636:	48 89 c7             	mov    %rax,%rdi
  800639:	48 b8 e3 05 80 00 00 	movabs $0x8005e3,%rax
  800640:	00 00 00 
  800643:	ff d0                	callq  *%rax
  800645:	eb 1e                	jmp    800665 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800647:	eb 12                	jmp    80065b <printnum+0x78>
			putch(padc, putdat);
  800649:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80064d:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800650:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800654:	48 89 ce             	mov    %rcx,%rsi
  800657:	89 d7                	mov    %edx,%edi
  800659:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80065b:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80065f:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800663:	7f e4                	jg     800649 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800665:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800668:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80066c:	ba 00 00 00 00       	mov    $0x0,%edx
  800671:	48 f7 f1             	div    %rcx
  800674:	48 89 d0             	mov    %rdx,%rax
  800677:	48 ba 50 49 80 00 00 	movabs $0x804950,%rdx
  80067e:	00 00 00 
  800681:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800685:	0f be d0             	movsbl %al,%edx
  800688:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80068c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800690:	48 89 ce             	mov    %rcx,%rsi
  800693:	89 d7                	mov    %edx,%edi
  800695:	ff d0                	callq  *%rax
}
  800697:	48 83 c4 38          	add    $0x38,%rsp
  80069b:	5b                   	pop    %rbx
  80069c:	5d                   	pop    %rbp
  80069d:	c3                   	retq   

000000000080069e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80069e:	55                   	push   %rbp
  80069f:	48 89 e5             	mov    %rsp,%rbp
  8006a2:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006aa:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006ad:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006b1:	7e 52                	jle    800705 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b7:	8b 00                	mov    (%rax),%eax
  8006b9:	83 f8 30             	cmp    $0x30,%eax
  8006bc:	73 24                	jae    8006e2 <getuint+0x44>
  8006be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ca:	8b 00                	mov    (%rax),%eax
  8006cc:	89 c0                	mov    %eax,%eax
  8006ce:	48 01 d0             	add    %rdx,%rax
  8006d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d5:	8b 12                	mov    (%rdx),%edx
  8006d7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006de:	89 0a                	mov    %ecx,(%rdx)
  8006e0:	eb 17                	jmp    8006f9 <getuint+0x5b>
  8006e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006ea:	48 89 d0             	mov    %rdx,%rax
  8006ed:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006f9:	48 8b 00             	mov    (%rax),%rax
  8006fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800700:	e9 a3 00 00 00       	jmpq   8007a8 <getuint+0x10a>
	else if (lflag)
  800705:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800709:	74 4f                	je     80075a <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80070b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070f:	8b 00                	mov    (%rax),%eax
  800711:	83 f8 30             	cmp    $0x30,%eax
  800714:	73 24                	jae    80073a <getuint+0x9c>
  800716:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80071e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800722:	8b 00                	mov    (%rax),%eax
  800724:	89 c0                	mov    %eax,%eax
  800726:	48 01 d0             	add    %rdx,%rax
  800729:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072d:	8b 12                	mov    (%rdx),%edx
  80072f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800732:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800736:	89 0a                	mov    %ecx,(%rdx)
  800738:	eb 17                	jmp    800751 <getuint+0xb3>
  80073a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800742:	48 89 d0             	mov    %rdx,%rax
  800745:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800749:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800751:	48 8b 00             	mov    (%rax),%rax
  800754:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800758:	eb 4e                	jmp    8007a8 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80075a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075e:	8b 00                	mov    (%rax),%eax
  800760:	83 f8 30             	cmp    $0x30,%eax
  800763:	73 24                	jae    800789 <getuint+0xeb>
  800765:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800769:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80076d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800771:	8b 00                	mov    (%rax),%eax
  800773:	89 c0                	mov    %eax,%eax
  800775:	48 01 d0             	add    %rdx,%rax
  800778:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077c:	8b 12                	mov    (%rdx),%edx
  80077e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800781:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800785:	89 0a                	mov    %ecx,(%rdx)
  800787:	eb 17                	jmp    8007a0 <getuint+0x102>
  800789:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800791:	48 89 d0             	mov    %rdx,%rax
  800794:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800798:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007a0:	8b 00                	mov    (%rax),%eax
  8007a2:	89 c0                	mov    %eax,%eax
  8007a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007ac:	c9                   	leaveq 
  8007ad:	c3                   	retq   

00000000008007ae <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007ae:	55                   	push   %rbp
  8007af:	48 89 e5             	mov    %rsp,%rbp
  8007b2:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007ba:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007bd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007c1:	7e 52                	jle    800815 <getint+0x67>
		x=va_arg(*ap, long long);
  8007c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c7:	8b 00                	mov    (%rax),%eax
  8007c9:	83 f8 30             	cmp    $0x30,%eax
  8007cc:	73 24                	jae    8007f2 <getint+0x44>
  8007ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007da:	8b 00                	mov    (%rax),%eax
  8007dc:	89 c0                	mov    %eax,%eax
  8007de:	48 01 d0             	add    %rdx,%rax
  8007e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e5:	8b 12                	mov    (%rdx),%edx
  8007e7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ee:	89 0a                	mov    %ecx,(%rdx)
  8007f0:	eb 17                	jmp    800809 <getint+0x5b>
  8007f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007fa:	48 89 d0             	mov    %rdx,%rax
  8007fd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800801:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800805:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800809:	48 8b 00             	mov    (%rax),%rax
  80080c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800810:	e9 a3 00 00 00       	jmpq   8008b8 <getint+0x10a>
	else if (lflag)
  800815:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800819:	74 4f                	je     80086a <getint+0xbc>
		x=va_arg(*ap, long);
  80081b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081f:	8b 00                	mov    (%rax),%eax
  800821:	83 f8 30             	cmp    $0x30,%eax
  800824:	73 24                	jae    80084a <getint+0x9c>
  800826:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80082e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800832:	8b 00                	mov    (%rax),%eax
  800834:	89 c0                	mov    %eax,%eax
  800836:	48 01 d0             	add    %rdx,%rax
  800839:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083d:	8b 12                	mov    (%rdx),%edx
  80083f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800842:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800846:	89 0a                	mov    %ecx,(%rdx)
  800848:	eb 17                	jmp    800861 <getint+0xb3>
  80084a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800852:	48 89 d0             	mov    %rdx,%rax
  800855:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800859:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800861:	48 8b 00             	mov    (%rax),%rax
  800864:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800868:	eb 4e                	jmp    8008b8 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80086a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086e:	8b 00                	mov    (%rax),%eax
  800870:	83 f8 30             	cmp    $0x30,%eax
  800873:	73 24                	jae    800899 <getint+0xeb>
  800875:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800879:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80087d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800881:	8b 00                	mov    (%rax),%eax
  800883:	89 c0                	mov    %eax,%eax
  800885:	48 01 d0             	add    %rdx,%rax
  800888:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088c:	8b 12                	mov    (%rdx),%edx
  80088e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800891:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800895:	89 0a                	mov    %ecx,(%rdx)
  800897:	eb 17                	jmp    8008b0 <getint+0x102>
  800899:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008a1:	48 89 d0             	mov    %rdx,%rax
  8008a4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ac:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008b0:	8b 00                	mov    (%rax),%eax
  8008b2:	48 98                	cltq   
  8008b4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008bc:	c9                   	leaveq 
  8008bd:	c3                   	retq   

00000000008008be <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008be:	55                   	push   %rbp
  8008bf:	48 89 e5             	mov    %rsp,%rbp
  8008c2:	41 54                	push   %r12
  8008c4:	53                   	push   %rbx
  8008c5:	48 83 ec 60          	sub    $0x60,%rsp
  8008c9:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008cd:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008d1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008d5:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008d9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008dd:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008e1:	48 8b 0a             	mov    (%rdx),%rcx
  8008e4:	48 89 08             	mov    %rcx,(%rax)
  8008e7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008eb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008ef:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008f3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008f7:	eb 17                	jmp    800910 <vprintfmt+0x52>
			if (ch == '\0')
  8008f9:	85 db                	test   %ebx,%ebx
  8008fb:	0f 84 cc 04 00 00    	je     800dcd <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800901:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800905:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800909:	48 89 d6             	mov    %rdx,%rsi
  80090c:	89 df                	mov    %ebx,%edi
  80090e:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800910:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800914:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800918:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80091c:	0f b6 00             	movzbl (%rax),%eax
  80091f:	0f b6 d8             	movzbl %al,%ebx
  800922:	83 fb 25             	cmp    $0x25,%ebx
  800925:	75 d2                	jne    8008f9 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800927:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80092b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800932:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800939:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800940:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800947:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80094b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80094f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800953:	0f b6 00             	movzbl (%rax),%eax
  800956:	0f b6 d8             	movzbl %al,%ebx
  800959:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80095c:	83 f8 55             	cmp    $0x55,%eax
  80095f:	0f 87 34 04 00 00    	ja     800d99 <vprintfmt+0x4db>
  800965:	89 c0                	mov    %eax,%eax
  800967:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80096e:	00 
  80096f:	48 b8 78 49 80 00 00 	movabs $0x804978,%rax
  800976:	00 00 00 
  800979:	48 01 d0             	add    %rdx,%rax
  80097c:	48 8b 00             	mov    (%rax),%rax
  80097f:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800981:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800985:	eb c0                	jmp    800947 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800987:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80098b:	eb ba                	jmp    800947 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80098d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800994:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800997:	89 d0                	mov    %edx,%eax
  800999:	c1 e0 02             	shl    $0x2,%eax
  80099c:	01 d0                	add    %edx,%eax
  80099e:	01 c0                	add    %eax,%eax
  8009a0:	01 d8                	add    %ebx,%eax
  8009a2:	83 e8 30             	sub    $0x30,%eax
  8009a5:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009a8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009ac:	0f b6 00             	movzbl (%rax),%eax
  8009af:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009b2:	83 fb 2f             	cmp    $0x2f,%ebx
  8009b5:	7e 0c                	jle    8009c3 <vprintfmt+0x105>
  8009b7:	83 fb 39             	cmp    $0x39,%ebx
  8009ba:	7f 07                	jg     8009c3 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009bc:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009c1:	eb d1                	jmp    800994 <vprintfmt+0xd6>
			goto process_precision;
  8009c3:	eb 58                	jmp    800a1d <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8009c5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c8:	83 f8 30             	cmp    $0x30,%eax
  8009cb:	73 17                	jae    8009e4 <vprintfmt+0x126>
  8009cd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009d1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d4:	89 c0                	mov    %eax,%eax
  8009d6:	48 01 d0             	add    %rdx,%rax
  8009d9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009dc:	83 c2 08             	add    $0x8,%edx
  8009df:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009e2:	eb 0f                	jmp    8009f3 <vprintfmt+0x135>
  8009e4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009e8:	48 89 d0             	mov    %rdx,%rax
  8009eb:	48 83 c2 08          	add    $0x8,%rdx
  8009ef:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009f3:	8b 00                	mov    (%rax),%eax
  8009f5:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009f8:	eb 23                	jmp    800a1d <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8009fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009fe:	79 0c                	jns    800a0c <vprintfmt+0x14e>
				width = 0;
  800a00:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a07:	e9 3b ff ff ff       	jmpq   800947 <vprintfmt+0x89>
  800a0c:	e9 36 ff ff ff       	jmpq   800947 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a11:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a18:	e9 2a ff ff ff       	jmpq   800947 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800a1d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a21:	79 12                	jns    800a35 <vprintfmt+0x177>
				width = precision, precision = -1;
  800a23:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a26:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a29:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a30:	e9 12 ff ff ff       	jmpq   800947 <vprintfmt+0x89>
  800a35:	e9 0d ff ff ff       	jmpq   800947 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a3a:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a3e:	e9 04 ff ff ff       	jmpq   800947 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a43:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a46:	83 f8 30             	cmp    $0x30,%eax
  800a49:	73 17                	jae    800a62 <vprintfmt+0x1a4>
  800a4b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a4f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a52:	89 c0                	mov    %eax,%eax
  800a54:	48 01 d0             	add    %rdx,%rax
  800a57:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a5a:	83 c2 08             	add    $0x8,%edx
  800a5d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a60:	eb 0f                	jmp    800a71 <vprintfmt+0x1b3>
  800a62:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a66:	48 89 d0             	mov    %rdx,%rax
  800a69:	48 83 c2 08          	add    $0x8,%rdx
  800a6d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a71:	8b 10                	mov    (%rax),%edx
  800a73:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a77:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a7b:	48 89 ce             	mov    %rcx,%rsi
  800a7e:	89 d7                	mov    %edx,%edi
  800a80:	ff d0                	callq  *%rax
			break;
  800a82:	e9 40 03 00 00       	jmpq   800dc7 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a87:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a8a:	83 f8 30             	cmp    $0x30,%eax
  800a8d:	73 17                	jae    800aa6 <vprintfmt+0x1e8>
  800a8f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a93:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a96:	89 c0                	mov    %eax,%eax
  800a98:	48 01 d0             	add    %rdx,%rax
  800a9b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a9e:	83 c2 08             	add    $0x8,%edx
  800aa1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aa4:	eb 0f                	jmp    800ab5 <vprintfmt+0x1f7>
  800aa6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aaa:	48 89 d0             	mov    %rdx,%rax
  800aad:	48 83 c2 08          	add    $0x8,%rdx
  800ab1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ab5:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ab7:	85 db                	test   %ebx,%ebx
  800ab9:	79 02                	jns    800abd <vprintfmt+0x1ff>
				err = -err;
  800abb:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800abd:	83 fb 15             	cmp    $0x15,%ebx
  800ac0:	7f 16                	jg     800ad8 <vprintfmt+0x21a>
  800ac2:	48 b8 a0 48 80 00 00 	movabs $0x8048a0,%rax
  800ac9:	00 00 00 
  800acc:	48 63 d3             	movslq %ebx,%rdx
  800acf:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ad3:	4d 85 e4             	test   %r12,%r12
  800ad6:	75 2e                	jne    800b06 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800ad8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800adc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae0:	89 d9                	mov    %ebx,%ecx
  800ae2:	48 ba 61 49 80 00 00 	movabs $0x804961,%rdx
  800ae9:	00 00 00 
  800aec:	48 89 c7             	mov    %rax,%rdi
  800aef:	b8 00 00 00 00       	mov    $0x0,%eax
  800af4:	49 b8 d6 0d 80 00 00 	movabs $0x800dd6,%r8
  800afb:	00 00 00 
  800afe:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b01:	e9 c1 02 00 00       	jmpq   800dc7 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b06:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0e:	4c 89 e1             	mov    %r12,%rcx
  800b11:	48 ba 6a 49 80 00 00 	movabs $0x80496a,%rdx
  800b18:	00 00 00 
  800b1b:	48 89 c7             	mov    %rax,%rdi
  800b1e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b23:	49 b8 d6 0d 80 00 00 	movabs $0x800dd6,%r8
  800b2a:	00 00 00 
  800b2d:	41 ff d0             	callq  *%r8
			break;
  800b30:	e9 92 02 00 00       	jmpq   800dc7 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b35:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b38:	83 f8 30             	cmp    $0x30,%eax
  800b3b:	73 17                	jae    800b54 <vprintfmt+0x296>
  800b3d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b41:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b44:	89 c0                	mov    %eax,%eax
  800b46:	48 01 d0             	add    %rdx,%rax
  800b49:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b4c:	83 c2 08             	add    $0x8,%edx
  800b4f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b52:	eb 0f                	jmp    800b63 <vprintfmt+0x2a5>
  800b54:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b58:	48 89 d0             	mov    %rdx,%rax
  800b5b:	48 83 c2 08          	add    $0x8,%rdx
  800b5f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b63:	4c 8b 20             	mov    (%rax),%r12
  800b66:	4d 85 e4             	test   %r12,%r12
  800b69:	75 0a                	jne    800b75 <vprintfmt+0x2b7>
				p = "(null)";
  800b6b:	49 bc 6d 49 80 00 00 	movabs $0x80496d,%r12
  800b72:	00 00 00 
			if (width > 0 && padc != '-')
  800b75:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b79:	7e 3f                	jle    800bba <vprintfmt+0x2fc>
  800b7b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b7f:	74 39                	je     800bba <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b81:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b84:	48 98                	cltq   
  800b86:	48 89 c6             	mov    %rax,%rsi
  800b89:	4c 89 e7             	mov    %r12,%rdi
  800b8c:	48 b8 82 10 80 00 00 	movabs $0x801082,%rax
  800b93:	00 00 00 
  800b96:	ff d0                	callq  *%rax
  800b98:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b9b:	eb 17                	jmp    800bb4 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b9d:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ba1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ba5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba9:	48 89 ce             	mov    %rcx,%rsi
  800bac:	89 d7                	mov    %edx,%edi
  800bae:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bb0:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bb4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bb8:	7f e3                	jg     800b9d <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bba:	eb 37                	jmp    800bf3 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800bbc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800bc0:	74 1e                	je     800be0 <vprintfmt+0x322>
  800bc2:	83 fb 1f             	cmp    $0x1f,%ebx
  800bc5:	7e 05                	jle    800bcc <vprintfmt+0x30e>
  800bc7:	83 fb 7e             	cmp    $0x7e,%ebx
  800bca:	7e 14                	jle    800be0 <vprintfmt+0x322>
					putch('?', putdat);
  800bcc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bd0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd4:	48 89 d6             	mov    %rdx,%rsi
  800bd7:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800bdc:	ff d0                	callq  *%rax
  800bde:	eb 0f                	jmp    800bef <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800be0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800be4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be8:	48 89 d6             	mov    %rdx,%rsi
  800beb:	89 df                	mov    %ebx,%edi
  800bed:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bef:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bf3:	4c 89 e0             	mov    %r12,%rax
  800bf6:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bfa:	0f b6 00             	movzbl (%rax),%eax
  800bfd:	0f be d8             	movsbl %al,%ebx
  800c00:	85 db                	test   %ebx,%ebx
  800c02:	74 10                	je     800c14 <vprintfmt+0x356>
  800c04:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c08:	78 b2                	js     800bbc <vprintfmt+0x2fe>
  800c0a:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c0e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c12:	79 a8                	jns    800bbc <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c14:	eb 16                	jmp    800c2c <vprintfmt+0x36e>
				putch(' ', putdat);
  800c16:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1e:	48 89 d6             	mov    %rdx,%rsi
  800c21:	bf 20 00 00 00       	mov    $0x20,%edi
  800c26:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c28:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c2c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c30:	7f e4                	jg     800c16 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800c32:	e9 90 01 00 00       	jmpq   800dc7 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c37:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c3b:	be 03 00 00 00       	mov    $0x3,%esi
  800c40:	48 89 c7             	mov    %rax,%rdi
  800c43:	48 b8 ae 07 80 00 00 	movabs $0x8007ae,%rax
  800c4a:	00 00 00 
  800c4d:	ff d0                	callq  *%rax
  800c4f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c57:	48 85 c0             	test   %rax,%rax
  800c5a:	79 1d                	jns    800c79 <vprintfmt+0x3bb>
				putch('-', putdat);
  800c5c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c64:	48 89 d6             	mov    %rdx,%rsi
  800c67:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c6c:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c72:	48 f7 d8             	neg    %rax
  800c75:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c79:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c80:	e9 d5 00 00 00       	jmpq   800d5a <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c85:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c89:	be 03 00 00 00       	mov    $0x3,%esi
  800c8e:	48 89 c7             	mov    %rax,%rdi
  800c91:	48 b8 9e 06 80 00 00 	movabs $0x80069e,%rax
  800c98:	00 00 00 
  800c9b:	ff d0                	callq  *%rax
  800c9d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ca1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ca8:	e9 ad 00 00 00       	jmpq   800d5a <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800cad:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800cb0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cb4:	89 d6                	mov    %edx,%esi
  800cb6:	48 89 c7             	mov    %rax,%rdi
  800cb9:	48 b8 ae 07 80 00 00 	movabs $0x8007ae,%rax
  800cc0:	00 00 00 
  800cc3:	ff d0                	callq  *%rax
  800cc5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800cc9:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800cd0:	e9 85 00 00 00       	jmpq   800d5a <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800cd5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cd9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cdd:	48 89 d6             	mov    %rdx,%rsi
  800ce0:	bf 30 00 00 00       	mov    $0x30,%edi
  800ce5:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ce7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ceb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cef:	48 89 d6             	mov    %rdx,%rsi
  800cf2:	bf 78 00 00 00       	mov    $0x78,%edi
  800cf7:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cf9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cfc:	83 f8 30             	cmp    $0x30,%eax
  800cff:	73 17                	jae    800d18 <vprintfmt+0x45a>
  800d01:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d05:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d08:	89 c0                	mov    %eax,%eax
  800d0a:	48 01 d0             	add    %rdx,%rax
  800d0d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d10:	83 c2 08             	add    $0x8,%edx
  800d13:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d16:	eb 0f                	jmp    800d27 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800d18:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d1c:	48 89 d0             	mov    %rdx,%rax
  800d1f:	48 83 c2 08          	add    $0x8,%rdx
  800d23:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d27:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d2a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d2e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d35:	eb 23                	jmp    800d5a <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d37:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d3b:	be 03 00 00 00       	mov    $0x3,%esi
  800d40:	48 89 c7             	mov    %rax,%rdi
  800d43:	48 b8 9e 06 80 00 00 	movabs $0x80069e,%rax
  800d4a:	00 00 00 
  800d4d:	ff d0                	callq  *%rax
  800d4f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d53:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d5a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d5f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d62:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d65:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d69:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d71:	45 89 c1             	mov    %r8d,%r9d
  800d74:	41 89 f8             	mov    %edi,%r8d
  800d77:	48 89 c7             	mov    %rax,%rdi
  800d7a:	48 b8 e3 05 80 00 00 	movabs $0x8005e3,%rax
  800d81:	00 00 00 
  800d84:	ff d0                	callq  *%rax
			break;
  800d86:	eb 3f                	jmp    800dc7 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d88:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d8c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d90:	48 89 d6             	mov    %rdx,%rsi
  800d93:	89 df                	mov    %ebx,%edi
  800d95:	ff d0                	callq  *%rax
			break;
  800d97:	eb 2e                	jmp    800dc7 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d99:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d9d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800da1:	48 89 d6             	mov    %rdx,%rsi
  800da4:	bf 25 00 00 00       	mov    $0x25,%edi
  800da9:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dab:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800db0:	eb 05                	jmp    800db7 <vprintfmt+0x4f9>
  800db2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800db7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dbb:	48 83 e8 01          	sub    $0x1,%rax
  800dbf:	0f b6 00             	movzbl (%rax),%eax
  800dc2:	3c 25                	cmp    $0x25,%al
  800dc4:	75 ec                	jne    800db2 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800dc6:	90                   	nop
		}
	}
  800dc7:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dc8:	e9 43 fb ff ff       	jmpq   800910 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800dcd:	48 83 c4 60          	add    $0x60,%rsp
  800dd1:	5b                   	pop    %rbx
  800dd2:	41 5c                	pop    %r12
  800dd4:	5d                   	pop    %rbp
  800dd5:	c3                   	retq   

0000000000800dd6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dd6:	55                   	push   %rbp
  800dd7:	48 89 e5             	mov    %rsp,%rbp
  800dda:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800de1:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800de8:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800def:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800df6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dfd:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e04:	84 c0                	test   %al,%al
  800e06:	74 20                	je     800e28 <printfmt+0x52>
  800e08:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e0c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e10:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e14:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e18:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e1c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e20:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e24:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e28:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e2f:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e36:	00 00 00 
  800e39:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e40:	00 00 00 
  800e43:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e47:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e4e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e55:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e5c:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e63:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e6a:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e71:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e78:	48 89 c7             	mov    %rax,%rdi
  800e7b:	48 b8 be 08 80 00 00 	movabs $0x8008be,%rax
  800e82:	00 00 00 
  800e85:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e87:	c9                   	leaveq 
  800e88:	c3                   	retq   

0000000000800e89 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e89:	55                   	push   %rbp
  800e8a:	48 89 e5             	mov    %rsp,%rbp
  800e8d:	48 83 ec 10          	sub    $0x10,%rsp
  800e91:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e94:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9c:	8b 40 10             	mov    0x10(%rax),%eax
  800e9f:	8d 50 01             	lea    0x1(%rax),%edx
  800ea2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea6:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ea9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ead:	48 8b 10             	mov    (%rax),%rdx
  800eb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eb4:	48 8b 40 08          	mov    0x8(%rax),%rax
  800eb8:	48 39 c2             	cmp    %rax,%rdx
  800ebb:	73 17                	jae    800ed4 <sprintputch+0x4b>
		*b->buf++ = ch;
  800ebd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ec1:	48 8b 00             	mov    (%rax),%rax
  800ec4:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ec8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ecc:	48 89 0a             	mov    %rcx,(%rdx)
  800ecf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ed2:	88 10                	mov    %dl,(%rax)
}
  800ed4:	c9                   	leaveq 
  800ed5:	c3                   	retq   

0000000000800ed6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ed6:	55                   	push   %rbp
  800ed7:	48 89 e5             	mov    %rsp,%rbp
  800eda:	48 83 ec 50          	sub    $0x50,%rsp
  800ede:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ee2:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ee5:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ee9:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800eed:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ef1:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ef5:	48 8b 0a             	mov    (%rdx),%rcx
  800ef8:	48 89 08             	mov    %rcx,(%rax)
  800efb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800eff:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f03:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f07:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f0b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f0f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f13:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f16:	48 98                	cltq   
  800f18:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f1c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f20:	48 01 d0             	add    %rdx,%rax
  800f23:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f27:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f2e:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f33:	74 06                	je     800f3b <vsnprintf+0x65>
  800f35:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f39:	7f 07                	jg     800f42 <vsnprintf+0x6c>
		return -E_INVAL;
  800f3b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f40:	eb 2f                	jmp    800f71 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f42:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f46:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f4a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f4e:	48 89 c6             	mov    %rax,%rsi
  800f51:	48 bf 89 0e 80 00 00 	movabs $0x800e89,%rdi
  800f58:	00 00 00 
  800f5b:	48 b8 be 08 80 00 00 	movabs $0x8008be,%rax
  800f62:	00 00 00 
  800f65:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f67:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f6b:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f6e:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f71:	c9                   	leaveq 
  800f72:	c3                   	retq   

0000000000800f73 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f73:	55                   	push   %rbp
  800f74:	48 89 e5             	mov    %rsp,%rbp
  800f77:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f7e:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f85:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f8b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f92:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f99:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fa0:	84 c0                	test   %al,%al
  800fa2:	74 20                	je     800fc4 <snprintf+0x51>
  800fa4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fa8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fac:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fb0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fb4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fb8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fbc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fc0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fc4:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fcb:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fd2:	00 00 00 
  800fd5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fdc:	00 00 00 
  800fdf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fe3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fea:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ff1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800ff8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fff:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801006:	48 8b 0a             	mov    (%rdx),%rcx
  801009:	48 89 08             	mov    %rcx,(%rax)
  80100c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801010:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801014:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801018:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80101c:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801023:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80102a:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801030:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801037:	48 89 c7             	mov    %rax,%rdi
  80103a:	48 b8 d6 0e 80 00 00 	movabs $0x800ed6,%rax
  801041:	00 00 00 
  801044:	ff d0                	callq  *%rax
  801046:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80104c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801052:	c9                   	leaveq 
  801053:	c3                   	retq   

0000000000801054 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801054:	55                   	push   %rbp
  801055:	48 89 e5             	mov    %rsp,%rbp
  801058:	48 83 ec 18          	sub    $0x18,%rsp
  80105c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801060:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801067:	eb 09                	jmp    801072 <strlen+0x1e>
		n++;
  801069:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80106d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801072:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801076:	0f b6 00             	movzbl (%rax),%eax
  801079:	84 c0                	test   %al,%al
  80107b:	75 ec                	jne    801069 <strlen+0x15>
		n++;
	return n;
  80107d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801080:	c9                   	leaveq 
  801081:	c3                   	retq   

0000000000801082 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801082:	55                   	push   %rbp
  801083:	48 89 e5             	mov    %rsp,%rbp
  801086:	48 83 ec 20          	sub    $0x20,%rsp
  80108a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80108e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801092:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801099:	eb 0e                	jmp    8010a9 <strnlen+0x27>
		n++;
  80109b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80109f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010a4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010a9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010ae:	74 0b                	je     8010bb <strnlen+0x39>
  8010b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b4:	0f b6 00             	movzbl (%rax),%eax
  8010b7:	84 c0                	test   %al,%al
  8010b9:	75 e0                	jne    80109b <strnlen+0x19>
		n++;
	return n;
  8010bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010be:	c9                   	leaveq 
  8010bf:	c3                   	retq   

00000000008010c0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010c0:	55                   	push   %rbp
  8010c1:	48 89 e5             	mov    %rsp,%rbp
  8010c4:	48 83 ec 20          	sub    $0x20,%rsp
  8010c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010d8:	90                   	nop
  8010d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010dd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010e1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010e5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010e9:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010ed:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010f1:	0f b6 12             	movzbl (%rdx),%edx
  8010f4:	88 10                	mov    %dl,(%rax)
  8010f6:	0f b6 00             	movzbl (%rax),%eax
  8010f9:	84 c0                	test   %al,%al
  8010fb:	75 dc                	jne    8010d9 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801101:	c9                   	leaveq 
  801102:	c3                   	retq   

0000000000801103 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801103:	55                   	push   %rbp
  801104:	48 89 e5             	mov    %rsp,%rbp
  801107:	48 83 ec 20          	sub    $0x20,%rsp
  80110b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80110f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801113:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801117:	48 89 c7             	mov    %rax,%rdi
  80111a:	48 b8 54 10 80 00 00 	movabs $0x801054,%rax
  801121:	00 00 00 
  801124:	ff d0                	callq  *%rax
  801126:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801129:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80112c:	48 63 d0             	movslq %eax,%rdx
  80112f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801133:	48 01 c2             	add    %rax,%rdx
  801136:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80113a:	48 89 c6             	mov    %rax,%rsi
  80113d:	48 89 d7             	mov    %rdx,%rdi
  801140:	48 b8 c0 10 80 00 00 	movabs $0x8010c0,%rax
  801147:	00 00 00 
  80114a:	ff d0                	callq  *%rax
	return dst;
  80114c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801150:	c9                   	leaveq 
  801151:	c3                   	retq   

0000000000801152 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801152:	55                   	push   %rbp
  801153:	48 89 e5             	mov    %rsp,%rbp
  801156:	48 83 ec 28          	sub    $0x28,%rsp
  80115a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80115e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801162:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801166:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80116e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801175:	00 
  801176:	eb 2a                	jmp    8011a2 <strncpy+0x50>
		*dst++ = *src;
  801178:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801180:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801184:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801188:	0f b6 12             	movzbl (%rdx),%edx
  80118b:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80118d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801191:	0f b6 00             	movzbl (%rax),%eax
  801194:	84 c0                	test   %al,%al
  801196:	74 05                	je     80119d <strncpy+0x4b>
			src++;
  801198:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80119d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011aa:	72 cc                	jb     801178 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011b0:	c9                   	leaveq 
  8011b1:	c3                   	retq   

00000000008011b2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011b2:	55                   	push   %rbp
  8011b3:	48 89 e5             	mov    %rsp,%rbp
  8011b6:	48 83 ec 28          	sub    $0x28,%rsp
  8011ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011ce:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011d3:	74 3d                	je     801212 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011d5:	eb 1d                	jmp    8011f4 <strlcpy+0x42>
			*dst++ = *src++;
  8011d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011db:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011df:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011e3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011e7:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011eb:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011ef:	0f b6 12             	movzbl (%rdx),%edx
  8011f2:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011f4:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011f9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011fe:	74 0b                	je     80120b <strlcpy+0x59>
  801200:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801204:	0f b6 00             	movzbl (%rax),%eax
  801207:	84 c0                	test   %al,%al
  801209:	75 cc                	jne    8011d7 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80120b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120f:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801212:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801216:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121a:	48 29 c2             	sub    %rax,%rdx
  80121d:	48 89 d0             	mov    %rdx,%rax
}
  801220:	c9                   	leaveq 
  801221:	c3                   	retq   

0000000000801222 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801222:	55                   	push   %rbp
  801223:	48 89 e5             	mov    %rsp,%rbp
  801226:	48 83 ec 10          	sub    $0x10,%rsp
  80122a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80122e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801232:	eb 0a                	jmp    80123e <strcmp+0x1c>
		p++, q++;
  801234:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801239:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80123e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801242:	0f b6 00             	movzbl (%rax),%eax
  801245:	84 c0                	test   %al,%al
  801247:	74 12                	je     80125b <strcmp+0x39>
  801249:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124d:	0f b6 10             	movzbl (%rax),%edx
  801250:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801254:	0f b6 00             	movzbl (%rax),%eax
  801257:	38 c2                	cmp    %al,%dl
  801259:	74 d9                	je     801234 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80125b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125f:	0f b6 00             	movzbl (%rax),%eax
  801262:	0f b6 d0             	movzbl %al,%edx
  801265:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801269:	0f b6 00             	movzbl (%rax),%eax
  80126c:	0f b6 c0             	movzbl %al,%eax
  80126f:	29 c2                	sub    %eax,%edx
  801271:	89 d0                	mov    %edx,%eax
}
  801273:	c9                   	leaveq 
  801274:	c3                   	retq   

0000000000801275 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801275:	55                   	push   %rbp
  801276:	48 89 e5             	mov    %rsp,%rbp
  801279:	48 83 ec 18          	sub    $0x18,%rsp
  80127d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801281:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801285:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801289:	eb 0f                	jmp    80129a <strncmp+0x25>
		n--, p++, q++;
  80128b:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801290:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801295:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80129a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80129f:	74 1d                	je     8012be <strncmp+0x49>
  8012a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a5:	0f b6 00             	movzbl (%rax),%eax
  8012a8:	84 c0                	test   %al,%al
  8012aa:	74 12                	je     8012be <strncmp+0x49>
  8012ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b0:	0f b6 10             	movzbl (%rax),%edx
  8012b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b7:	0f b6 00             	movzbl (%rax),%eax
  8012ba:	38 c2                	cmp    %al,%dl
  8012bc:	74 cd                	je     80128b <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012be:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012c3:	75 07                	jne    8012cc <strncmp+0x57>
		return 0;
  8012c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ca:	eb 18                	jmp    8012e4 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d0:	0f b6 00             	movzbl (%rax),%eax
  8012d3:	0f b6 d0             	movzbl %al,%edx
  8012d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012da:	0f b6 00             	movzbl (%rax),%eax
  8012dd:	0f b6 c0             	movzbl %al,%eax
  8012e0:	29 c2                	sub    %eax,%edx
  8012e2:	89 d0                	mov    %edx,%eax
}
  8012e4:	c9                   	leaveq 
  8012e5:	c3                   	retq   

00000000008012e6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012e6:	55                   	push   %rbp
  8012e7:	48 89 e5             	mov    %rsp,%rbp
  8012ea:	48 83 ec 0c          	sub    $0xc,%rsp
  8012ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012f2:	89 f0                	mov    %esi,%eax
  8012f4:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012f7:	eb 17                	jmp    801310 <strchr+0x2a>
		if (*s == c)
  8012f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fd:	0f b6 00             	movzbl (%rax),%eax
  801300:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801303:	75 06                	jne    80130b <strchr+0x25>
			return (char *) s;
  801305:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801309:	eb 15                	jmp    801320 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80130b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801310:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801314:	0f b6 00             	movzbl (%rax),%eax
  801317:	84 c0                	test   %al,%al
  801319:	75 de                	jne    8012f9 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80131b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801320:	c9                   	leaveq 
  801321:	c3                   	retq   

0000000000801322 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801322:	55                   	push   %rbp
  801323:	48 89 e5             	mov    %rsp,%rbp
  801326:	48 83 ec 0c          	sub    $0xc,%rsp
  80132a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80132e:	89 f0                	mov    %esi,%eax
  801330:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801333:	eb 13                	jmp    801348 <strfind+0x26>
		if (*s == c)
  801335:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801339:	0f b6 00             	movzbl (%rax),%eax
  80133c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80133f:	75 02                	jne    801343 <strfind+0x21>
			break;
  801341:	eb 10                	jmp    801353 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801343:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801348:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134c:	0f b6 00             	movzbl (%rax),%eax
  80134f:	84 c0                	test   %al,%al
  801351:	75 e2                	jne    801335 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801353:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801357:	c9                   	leaveq 
  801358:	c3                   	retq   

0000000000801359 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801359:	55                   	push   %rbp
  80135a:	48 89 e5             	mov    %rsp,%rbp
  80135d:	48 83 ec 18          	sub    $0x18,%rsp
  801361:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801365:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801368:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80136c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801371:	75 06                	jne    801379 <memset+0x20>
		return v;
  801373:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801377:	eb 69                	jmp    8013e2 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801379:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137d:	83 e0 03             	and    $0x3,%eax
  801380:	48 85 c0             	test   %rax,%rax
  801383:	75 48                	jne    8013cd <memset+0x74>
  801385:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801389:	83 e0 03             	and    $0x3,%eax
  80138c:	48 85 c0             	test   %rax,%rax
  80138f:	75 3c                	jne    8013cd <memset+0x74>
		c &= 0xFF;
  801391:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801398:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80139b:	c1 e0 18             	shl    $0x18,%eax
  80139e:	89 c2                	mov    %eax,%edx
  8013a0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013a3:	c1 e0 10             	shl    $0x10,%eax
  8013a6:	09 c2                	or     %eax,%edx
  8013a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013ab:	c1 e0 08             	shl    $0x8,%eax
  8013ae:	09 d0                	or     %edx,%eax
  8013b0:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8013b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b7:	48 c1 e8 02          	shr    $0x2,%rax
  8013bb:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013be:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c5:	48 89 d7             	mov    %rdx,%rdi
  8013c8:	fc                   	cld    
  8013c9:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013cb:	eb 11                	jmp    8013de <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013cd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013d4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013d8:	48 89 d7             	mov    %rdx,%rdi
  8013db:	fc                   	cld    
  8013dc:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013e2:	c9                   	leaveq 
  8013e3:	c3                   	retq   

00000000008013e4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013e4:	55                   	push   %rbp
  8013e5:	48 89 e5             	mov    %rsp,%rbp
  8013e8:	48 83 ec 28          	sub    $0x28,%rsp
  8013ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013f0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013f4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801400:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801404:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801408:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801410:	0f 83 88 00 00 00    	jae    80149e <memmove+0xba>
  801416:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80141e:	48 01 d0             	add    %rdx,%rax
  801421:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801425:	76 77                	jbe    80149e <memmove+0xba>
		s += n;
  801427:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80142f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801433:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801437:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143b:	83 e0 03             	and    $0x3,%eax
  80143e:	48 85 c0             	test   %rax,%rax
  801441:	75 3b                	jne    80147e <memmove+0x9a>
  801443:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801447:	83 e0 03             	and    $0x3,%eax
  80144a:	48 85 c0             	test   %rax,%rax
  80144d:	75 2f                	jne    80147e <memmove+0x9a>
  80144f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801453:	83 e0 03             	and    $0x3,%eax
  801456:	48 85 c0             	test   %rax,%rax
  801459:	75 23                	jne    80147e <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80145b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80145f:	48 83 e8 04          	sub    $0x4,%rax
  801463:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801467:	48 83 ea 04          	sub    $0x4,%rdx
  80146b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80146f:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801473:	48 89 c7             	mov    %rax,%rdi
  801476:	48 89 d6             	mov    %rdx,%rsi
  801479:	fd                   	std    
  80147a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80147c:	eb 1d                	jmp    80149b <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80147e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801482:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801486:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148a:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80148e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801492:	48 89 d7             	mov    %rdx,%rdi
  801495:	48 89 c1             	mov    %rax,%rcx
  801498:	fd                   	std    
  801499:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80149b:	fc                   	cld    
  80149c:	eb 57                	jmp    8014f5 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80149e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a2:	83 e0 03             	and    $0x3,%eax
  8014a5:	48 85 c0             	test   %rax,%rax
  8014a8:	75 36                	jne    8014e0 <memmove+0xfc>
  8014aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ae:	83 e0 03             	and    $0x3,%eax
  8014b1:	48 85 c0             	test   %rax,%rax
  8014b4:	75 2a                	jne    8014e0 <memmove+0xfc>
  8014b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ba:	83 e0 03             	and    $0x3,%eax
  8014bd:	48 85 c0             	test   %rax,%rax
  8014c0:	75 1e                	jne    8014e0 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c6:	48 c1 e8 02          	shr    $0x2,%rax
  8014ca:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014d5:	48 89 c7             	mov    %rax,%rdi
  8014d8:	48 89 d6             	mov    %rdx,%rsi
  8014db:	fc                   	cld    
  8014dc:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014de:	eb 15                	jmp    8014f5 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014e8:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014ec:	48 89 c7             	mov    %rax,%rdi
  8014ef:	48 89 d6             	mov    %rdx,%rsi
  8014f2:	fc                   	cld    
  8014f3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014f9:	c9                   	leaveq 
  8014fa:	c3                   	retq   

00000000008014fb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014fb:	55                   	push   %rbp
  8014fc:	48 89 e5             	mov    %rsp,%rbp
  8014ff:	48 83 ec 18          	sub    $0x18,%rsp
  801503:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801507:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80150b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80150f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801513:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801517:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151b:	48 89 ce             	mov    %rcx,%rsi
  80151e:	48 89 c7             	mov    %rax,%rdi
  801521:	48 b8 e4 13 80 00 00 	movabs $0x8013e4,%rax
  801528:	00 00 00 
  80152b:	ff d0                	callq  *%rax
}
  80152d:	c9                   	leaveq 
  80152e:	c3                   	retq   

000000000080152f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80152f:	55                   	push   %rbp
  801530:	48 89 e5             	mov    %rsp,%rbp
  801533:	48 83 ec 28          	sub    $0x28,%rsp
  801537:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80153b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80153f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801543:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801547:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80154b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80154f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801553:	eb 36                	jmp    80158b <memcmp+0x5c>
		if (*s1 != *s2)
  801555:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801559:	0f b6 10             	movzbl (%rax),%edx
  80155c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801560:	0f b6 00             	movzbl (%rax),%eax
  801563:	38 c2                	cmp    %al,%dl
  801565:	74 1a                	je     801581 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801567:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80156b:	0f b6 00             	movzbl (%rax),%eax
  80156e:	0f b6 d0             	movzbl %al,%edx
  801571:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801575:	0f b6 00             	movzbl (%rax),%eax
  801578:	0f b6 c0             	movzbl %al,%eax
  80157b:	29 c2                	sub    %eax,%edx
  80157d:	89 d0                	mov    %edx,%eax
  80157f:	eb 20                	jmp    8015a1 <memcmp+0x72>
		s1++, s2++;
  801581:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801586:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80158b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801593:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801597:	48 85 c0             	test   %rax,%rax
  80159a:	75 b9                	jne    801555 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80159c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a1:	c9                   	leaveq 
  8015a2:	c3                   	retq   

00000000008015a3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015a3:	55                   	push   %rbp
  8015a4:	48 89 e5             	mov    %rsp,%rbp
  8015a7:	48 83 ec 28          	sub    $0x28,%rsp
  8015ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015af:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015b2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015be:	48 01 d0             	add    %rdx,%rax
  8015c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015c5:	eb 15                	jmp    8015dc <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015cb:	0f b6 10             	movzbl (%rax),%edx
  8015ce:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015d1:	38 c2                	cmp    %al,%dl
  8015d3:	75 02                	jne    8015d7 <memfind+0x34>
			break;
  8015d5:	eb 0f                	jmp    8015e6 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015d7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e0:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015e4:	72 e1                	jb     8015c7 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8015e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015ea:	c9                   	leaveq 
  8015eb:	c3                   	retq   

00000000008015ec <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015ec:	55                   	push   %rbp
  8015ed:	48 89 e5             	mov    %rsp,%rbp
  8015f0:	48 83 ec 34          	sub    $0x34,%rsp
  8015f4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015f8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015fc:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801606:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80160d:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80160e:	eb 05                	jmp    801615 <strtol+0x29>
		s++;
  801610:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801615:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801619:	0f b6 00             	movzbl (%rax),%eax
  80161c:	3c 20                	cmp    $0x20,%al
  80161e:	74 f0                	je     801610 <strtol+0x24>
  801620:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801624:	0f b6 00             	movzbl (%rax),%eax
  801627:	3c 09                	cmp    $0x9,%al
  801629:	74 e5                	je     801610 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80162b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162f:	0f b6 00             	movzbl (%rax),%eax
  801632:	3c 2b                	cmp    $0x2b,%al
  801634:	75 07                	jne    80163d <strtol+0x51>
		s++;
  801636:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80163b:	eb 17                	jmp    801654 <strtol+0x68>
	else if (*s == '-')
  80163d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801641:	0f b6 00             	movzbl (%rax),%eax
  801644:	3c 2d                	cmp    $0x2d,%al
  801646:	75 0c                	jne    801654 <strtol+0x68>
		s++, neg = 1;
  801648:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80164d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801654:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801658:	74 06                	je     801660 <strtol+0x74>
  80165a:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80165e:	75 28                	jne    801688 <strtol+0x9c>
  801660:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801664:	0f b6 00             	movzbl (%rax),%eax
  801667:	3c 30                	cmp    $0x30,%al
  801669:	75 1d                	jne    801688 <strtol+0x9c>
  80166b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166f:	48 83 c0 01          	add    $0x1,%rax
  801673:	0f b6 00             	movzbl (%rax),%eax
  801676:	3c 78                	cmp    $0x78,%al
  801678:	75 0e                	jne    801688 <strtol+0x9c>
		s += 2, base = 16;
  80167a:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80167f:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801686:	eb 2c                	jmp    8016b4 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801688:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80168c:	75 19                	jne    8016a7 <strtol+0xbb>
  80168e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801692:	0f b6 00             	movzbl (%rax),%eax
  801695:	3c 30                	cmp    $0x30,%al
  801697:	75 0e                	jne    8016a7 <strtol+0xbb>
		s++, base = 8;
  801699:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80169e:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016a5:	eb 0d                	jmp    8016b4 <strtol+0xc8>
	else if (base == 0)
  8016a7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016ab:	75 07                	jne    8016b4 <strtol+0xc8>
		base = 10;
  8016ad:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b8:	0f b6 00             	movzbl (%rax),%eax
  8016bb:	3c 2f                	cmp    $0x2f,%al
  8016bd:	7e 1d                	jle    8016dc <strtol+0xf0>
  8016bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c3:	0f b6 00             	movzbl (%rax),%eax
  8016c6:	3c 39                	cmp    $0x39,%al
  8016c8:	7f 12                	jg     8016dc <strtol+0xf0>
			dig = *s - '0';
  8016ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ce:	0f b6 00             	movzbl (%rax),%eax
  8016d1:	0f be c0             	movsbl %al,%eax
  8016d4:	83 e8 30             	sub    $0x30,%eax
  8016d7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016da:	eb 4e                	jmp    80172a <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e0:	0f b6 00             	movzbl (%rax),%eax
  8016e3:	3c 60                	cmp    $0x60,%al
  8016e5:	7e 1d                	jle    801704 <strtol+0x118>
  8016e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016eb:	0f b6 00             	movzbl (%rax),%eax
  8016ee:	3c 7a                	cmp    $0x7a,%al
  8016f0:	7f 12                	jg     801704 <strtol+0x118>
			dig = *s - 'a' + 10;
  8016f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f6:	0f b6 00             	movzbl (%rax),%eax
  8016f9:	0f be c0             	movsbl %al,%eax
  8016fc:	83 e8 57             	sub    $0x57,%eax
  8016ff:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801702:	eb 26                	jmp    80172a <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801704:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801708:	0f b6 00             	movzbl (%rax),%eax
  80170b:	3c 40                	cmp    $0x40,%al
  80170d:	7e 48                	jle    801757 <strtol+0x16b>
  80170f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801713:	0f b6 00             	movzbl (%rax),%eax
  801716:	3c 5a                	cmp    $0x5a,%al
  801718:	7f 3d                	jg     801757 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80171a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171e:	0f b6 00             	movzbl (%rax),%eax
  801721:	0f be c0             	movsbl %al,%eax
  801724:	83 e8 37             	sub    $0x37,%eax
  801727:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80172a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80172d:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801730:	7c 02                	jl     801734 <strtol+0x148>
			break;
  801732:	eb 23                	jmp    801757 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801734:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801739:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80173c:	48 98                	cltq   
  80173e:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801743:	48 89 c2             	mov    %rax,%rdx
  801746:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801749:	48 98                	cltq   
  80174b:	48 01 d0             	add    %rdx,%rax
  80174e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801752:	e9 5d ff ff ff       	jmpq   8016b4 <strtol+0xc8>

	if (endptr)
  801757:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80175c:	74 0b                	je     801769 <strtol+0x17d>
		*endptr = (char *) s;
  80175e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801762:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801766:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801769:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80176d:	74 09                	je     801778 <strtol+0x18c>
  80176f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801773:	48 f7 d8             	neg    %rax
  801776:	eb 04                	jmp    80177c <strtol+0x190>
  801778:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80177c:	c9                   	leaveq 
  80177d:	c3                   	retq   

000000000080177e <strstr>:

char * strstr(const char *in, const char *str)
{
  80177e:	55                   	push   %rbp
  80177f:	48 89 e5             	mov    %rsp,%rbp
  801782:	48 83 ec 30          	sub    $0x30,%rsp
  801786:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80178a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80178e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801792:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801796:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80179a:	0f b6 00             	movzbl (%rax),%eax
  80179d:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8017a0:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017a4:	75 06                	jne    8017ac <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8017a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017aa:	eb 6b                	jmp    801817 <strstr+0x99>

	len = strlen(str);
  8017ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017b0:	48 89 c7             	mov    %rax,%rdi
  8017b3:	48 b8 54 10 80 00 00 	movabs $0x801054,%rax
  8017ba:	00 00 00 
  8017bd:	ff d0                	callq  *%rax
  8017bf:	48 98                	cltq   
  8017c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8017c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017cd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017d1:	0f b6 00             	movzbl (%rax),%eax
  8017d4:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8017d7:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017db:	75 07                	jne    8017e4 <strstr+0x66>
				return (char *) 0;
  8017dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e2:	eb 33                	jmp    801817 <strstr+0x99>
		} while (sc != c);
  8017e4:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017e8:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017eb:	75 d8                	jne    8017c5 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017f1:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f9:	48 89 ce             	mov    %rcx,%rsi
  8017fc:	48 89 c7             	mov    %rax,%rdi
  8017ff:	48 b8 75 12 80 00 00 	movabs $0x801275,%rax
  801806:	00 00 00 
  801809:	ff d0                	callq  *%rax
  80180b:	85 c0                	test   %eax,%eax
  80180d:	75 b6                	jne    8017c5 <strstr+0x47>

	return (char *) (in - 1);
  80180f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801813:	48 83 e8 01          	sub    $0x1,%rax
}
  801817:	c9                   	leaveq 
  801818:	c3                   	retq   

0000000000801819 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801819:	55                   	push   %rbp
  80181a:	48 89 e5             	mov    %rsp,%rbp
  80181d:	53                   	push   %rbx
  80181e:	48 83 ec 48          	sub    $0x48,%rsp
  801822:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801825:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801828:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80182c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801830:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801834:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801838:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80183b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80183f:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801843:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801847:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80184b:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80184f:	4c 89 c3             	mov    %r8,%rbx
  801852:	cd 30                	int    $0x30
  801854:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801858:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80185c:	74 3e                	je     80189c <syscall+0x83>
  80185e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801863:	7e 37                	jle    80189c <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801865:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801869:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80186c:	49 89 d0             	mov    %rdx,%r8
  80186f:	89 c1                	mov    %eax,%ecx
  801871:	48 ba 28 4c 80 00 00 	movabs $0x804c28,%rdx
  801878:	00 00 00 
  80187b:	be 23 00 00 00       	mov    $0x23,%esi
  801880:	48 bf 45 4c 80 00 00 	movabs $0x804c45,%rdi
  801887:	00 00 00 
  80188a:	b8 00 00 00 00       	mov    $0x0,%eax
  80188f:	49 b9 b2 3d 80 00 00 	movabs $0x803db2,%r9
  801896:	00 00 00 
  801899:	41 ff d1             	callq  *%r9

	return ret;
  80189c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018a0:	48 83 c4 48          	add    $0x48,%rsp
  8018a4:	5b                   	pop    %rbx
  8018a5:	5d                   	pop    %rbp
  8018a6:	c3                   	retq   

00000000008018a7 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018a7:	55                   	push   %rbp
  8018a8:	48 89 e5             	mov    %rsp,%rbp
  8018ab:	48 83 ec 20          	sub    $0x20,%rsp
  8018af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018bf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018c6:	00 
  8018c7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018cd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018d3:	48 89 d1             	mov    %rdx,%rcx
  8018d6:	48 89 c2             	mov    %rax,%rdx
  8018d9:	be 00 00 00 00       	mov    $0x0,%esi
  8018de:	bf 00 00 00 00       	mov    $0x0,%edi
  8018e3:	48 b8 19 18 80 00 00 	movabs $0x801819,%rax
  8018ea:	00 00 00 
  8018ed:	ff d0                	callq  *%rax
}
  8018ef:	c9                   	leaveq 
  8018f0:	c3                   	retq   

00000000008018f1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018f1:	55                   	push   %rbp
  8018f2:	48 89 e5             	mov    %rsp,%rbp
  8018f5:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018f9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801900:	00 
  801901:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801907:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80190d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801912:	ba 00 00 00 00       	mov    $0x0,%edx
  801917:	be 00 00 00 00       	mov    $0x0,%esi
  80191c:	bf 01 00 00 00       	mov    $0x1,%edi
  801921:	48 b8 19 18 80 00 00 	movabs $0x801819,%rax
  801928:	00 00 00 
  80192b:	ff d0                	callq  *%rax
}
  80192d:	c9                   	leaveq 
  80192e:	c3                   	retq   

000000000080192f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80192f:	55                   	push   %rbp
  801930:	48 89 e5             	mov    %rsp,%rbp
  801933:	48 83 ec 10          	sub    $0x10,%rsp
  801937:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80193a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80193d:	48 98                	cltq   
  80193f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801946:	00 
  801947:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80194d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801953:	b9 00 00 00 00       	mov    $0x0,%ecx
  801958:	48 89 c2             	mov    %rax,%rdx
  80195b:	be 01 00 00 00       	mov    $0x1,%esi
  801960:	bf 03 00 00 00       	mov    $0x3,%edi
  801965:	48 b8 19 18 80 00 00 	movabs $0x801819,%rax
  80196c:	00 00 00 
  80196f:	ff d0                	callq  *%rax
}
  801971:	c9                   	leaveq 
  801972:	c3                   	retq   

0000000000801973 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801973:	55                   	push   %rbp
  801974:	48 89 e5             	mov    %rsp,%rbp
  801977:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80197b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801982:	00 
  801983:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801989:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80198f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801994:	ba 00 00 00 00       	mov    $0x0,%edx
  801999:	be 00 00 00 00       	mov    $0x0,%esi
  80199e:	bf 02 00 00 00       	mov    $0x2,%edi
  8019a3:	48 b8 19 18 80 00 00 	movabs $0x801819,%rax
  8019aa:	00 00 00 
  8019ad:	ff d0                	callq  *%rax
}
  8019af:	c9                   	leaveq 
  8019b0:	c3                   	retq   

00000000008019b1 <sys_yield>:

void
sys_yield(void)
{
  8019b1:	55                   	push   %rbp
  8019b2:	48 89 e5             	mov    %rsp,%rbp
  8019b5:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019b9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c0:	00 
  8019c1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d7:	be 00 00 00 00       	mov    $0x0,%esi
  8019dc:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019e1:	48 b8 19 18 80 00 00 	movabs $0x801819,%rax
  8019e8:	00 00 00 
  8019eb:	ff d0                	callq  *%rax
}
  8019ed:	c9                   	leaveq 
  8019ee:	c3                   	retq   

00000000008019ef <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019ef:	55                   	push   %rbp
  8019f0:	48 89 e5             	mov    %rsp,%rbp
  8019f3:	48 83 ec 20          	sub    $0x20,%rsp
  8019f7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019fa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019fe:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a01:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a04:	48 63 c8             	movslq %eax,%rcx
  801a07:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a0e:	48 98                	cltq   
  801a10:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a17:	00 
  801a18:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a1e:	49 89 c8             	mov    %rcx,%r8
  801a21:	48 89 d1             	mov    %rdx,%rcx
  801a24:	48 89 c2             	mov    %rax,%rdx
  801a27:	be 01 00 00 00       	mov    $0x1,%esi
  801a2c:	bf 04 00 00 00       	mov    $0x4,%edi
  801a31:	48 b8 19 18 80 00 00 	movabs $0x801819,%rax
  801a38:	00 00 00 
  801a3b:	ff d0                	callq  *%rax
}
  801a3d:	c9                   	leaveq 
  801a3e:	c3                   	retq   

0000000000801a3f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a3f:	55                   	push   %rbp
  801a40:	48 89 e5             	mov    %rsp,%rbp
  801a43:	48 83 ec 30          	sub    $0x30,%rsp
  801a47:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a4a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a4e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a51:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a55:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a59:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a5c:	48 63 c8             	movslq %eax,%rcx
  801a5f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a63:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a66:	48 63 f0             	movslq %eax,%rsi
  801a69:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a70:	48 98                	cltq   
  801a72:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a76:	49 89 f9             	mov    %rdi,%r9
  801a79:	49 89 f0             	mov    %rsi,%r8
  801a7c:	48 89 d1             	mov    %rdx,%rcx
  801a7f:	48 89 c2             	mov    %rax,%rdx
  801a82:	be 01 00 00 00       	mov    $0x1,%esi
  801a87:	bf 05 00 00 00       	mov    $0x5,%edi
  801a8c:	48 b8 19 18 80 00 00 	movabs $0x801819,%rax
  801a93:	00 00 00 
  801a96:	ff d0                	callq  *%rax
}
  801a98:	c9                   	leaveq 
  801a99:	c3                   	retq   

0000000000801a9a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a9a:	55                   	push   %rbp
  801a9b:	48 89 e5             	mov    %rsp,%rbp
  801a9e:	48 83 ec 20          	sub    $0x20,%rsp
  801aa2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aa5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801aa9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab0:	48 98                	cltq   
  801ab2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab9:	00 
  801aba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac6:	48 89 d1             	mov    %rdx,%rcx
  801ac9:	48 89 c2             	mov    %rax,%rdx
  801acc:	be 01 00 00 00       	mov    $0x1,%esi
  801ad1:	bf 06 00 00 00       	mov    $0x6,%edi
  801ad6:	48 b8 19 18 80 00 00 	movabs $0x801819,%rax
  801add:	00 00 00 
  801ae0:	ff d0                	callq  *%rax
}
  801ae2:	c9                   	leaveq 
  801ae3:	c3                   	retq   

0000000000801ae4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ae4:	55                   	push   %rbp
  801ae5:	48 89 e5             	mov    %rsp,%rbp
  801ae8:	48 83 ec 10          	sub    $0x10,%rsp
  801aec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aef:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801af2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801af5:	48 63 d0             	movslq %eax,%rdx
  801af8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801afb:	48 98                	cltq   
  801afd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b04:	00 
  801b05:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b0b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b11:	48 89 d1             	mov    %rdx,%rcx
  801b14:	48 89 c2             	mov    %rax,%rdx
  801b17:	be 01 00 00 00       	mov    $0x1,%esi
  801b1c:	bf 08 00 00 00       	mov    $0x8,%edi
  801b21:	48 b8 19 18 80 00 00 	movabs $0x801819,%rax
  801b28:	00 00 00 
  801b2b:	ff d0                	callq  *%rax
}
  801b2d:	c9                   	leaveq 
  801b2e:	c3                   	retq   

0000000000801b2f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b2f:	55                   	push   %rbp
  801b30:	48 89 e5             	mov    %rsp,%rbp
  801b33:	48 83 ec 20          	sub    $0x20,%rsp
  801b37:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b3a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b3e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b45:	48 98                	cltq   
  801b47:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b4e:	00 
  801b4f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b55:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b5b:	48 89 d1             	mov    %rdx,%rcx
  801b5e:	48 89 c2             	mov    %rax,%rdx
  801b61:	be 01 00 00 00       	mov    $0x1,%esi
  801b66:	bf 09 00 00 00       	mov    $0x9,%edi
  801b6b:	48 b8 19 18 80 00 00 	movabs $0x801819,%rax
  801b72:	00 00 00 
  801b75:	ff d0                	callq  *%rax
}
  801b77:	c9                   	leaveq 
  801b78:	c3                   	retq   

0000000000801b79 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b79:	55                   	push   %rbp
  801b7a:	48 89 e5             	mov    %rsp,%rbp
  801b7d:	48 83 ec 20          	sub    $0x20,%rsp
  801b81:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b84:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b88:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b8f:	48 98                	cltq   
  801b91:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b98:	00 
  801b99:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b9f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ba5:	48 89 d1             	mov    %rdx,%rcx
  801ba8:	48 89 c2             	mov    %rax,%rdx
  801bab:	be 01 00 00 00       	mov    $0x1,%esi
  801bb0:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bb5:	48 b8 19 18 80 00 00 	movabs $0x801819,%rax
  801bbc:	00 00 00 
  801bbf:	ff d0                	callq  *%rax
}
  801bc1:	c9                   	leaveq 
  801bc2:	c3                   	retq   

0000000000801bc3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801bc3:	55                   	push   %rbp
  801bc4:	48 89 e5             	mov    %rsp,%rbp
  801bc7:	48 83 ec 20          	sub    $0x20,%rsp
  801bcb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bd2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bd6:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801bd9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bdc:	48 63 f0             	movslq %eax,%rsi
  801bdf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801be3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801be6:	48 98                	cltq   
  801be8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bec:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bf3:	00 
  801bf4:	49 89 f1             	mov    %rsi,%r9
  801bf7:	49 89 c8             	mov    %rcx,%r8
  801bfa:	48 89 d1             	mov    %rdx,%rcx
  801bfd:	48 89 c2             	mov    %rax,%rdx
  801c00:	be 00 00 00 00       	mov    $0x0,%esi
  801c05:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c0a:	48 b8 19 18 80 00 00 	movabs $0x801819,%rax
  801c11:	00 00 00 
  801c14:	ff d0                	callq  *%rax
}
  801c16:	c9                   	leaveq 
  801c17:	c3                   	retq   

0000000000801c18 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c18:	55                   	push   %rbp
  801c19:	48 89 e5             	mov    %rsp,%rbp
  801c1c:	48 83 ec 10          	sub    $0x10,%rsp
  801c20:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c28:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c2f:	00 
  801c30:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c36:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c3c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c41:	48 89 c2             	mov    %rax,%rdx
  801c44:	be 01 00 00 00       	mov    $0x1,%esi
  801c49:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c4e:	48 b8 19 18 80 00 00 	movabs $0x801819,%rax
  801c55:	00 00 00 
  801c58:	ff d0                	callq  *%rax
}
  801c5a:	c9                   	leaveq 
  801c5b:	c3                   	retq   

0000000000801c5c <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801c5c:	55                   	push   %rbp
  801c5d:	48 89 e5             	mov    %rsp,%rbp
  801c60:	48 83 ec 20          	sub    $0x20,%rsp
  801c64:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c68:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801c6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c74:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c7b:	00 
  801c7c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c82:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c88:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c8d:	89 c6                	mov    %eax,%esi
  801c8f:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c94:	48 b8 19 18 80 00 00 	movabs $0x801819,%rax
  801c9b:	00 00 00 
  801c9e:	ff d0                	callq  *%rax
}
  801ca0:	c9                   	leaveq 
  801ca1:	c3                   	retq   

0000000000801ca2 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801ca2:	55                   	push   %rbp
  801ca3:	48 89 e5             	mov    %rsp,%rbp
  801ca6:	48 83 ec 20          	sub    $0x20,%rsp
  801caa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801cb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cc1:	00 
  801cc2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cc8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cce:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cd3:	89 c6                	mov    %eax,%esi
  801cd5:	bf 10 00 00 00       	mov    $0x10,%edi
  801cda:	48 b8 19 18 80 00 00 	movabs $0x801819,%rax
  801ce1:	00 00 00 
  801ce4:	ff d0                	callq  *%rax
}
  801ce6:	c9                   	leaveq 
  801ce7:	c3                   	retq   

0000000000801ce8 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801ce8:	55                   	push   %rbp
  801ce9:	48 89 e5             	mov    %rsp,%rbp
  801cec:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801cf0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cf7:	00 
  801cf8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cfe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d04:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d09:	ba 00 00 00 00       	mov    $0x0,%edx
  801d0e:	be 00 00 00 00       	mov    $0x0,%esi
  801d13:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d18:	48 b8 19 18 80 00 00 	movabs $0x801819,%rax
  801d1f:	00 00 00 
  801d22:	ff d0                	callq  *%rax
}
  801d24:	c9                   	leaveq 
  801d25:	c3                   	retq   

0000000000801d26 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d26:	55                   	push   %rbp
  801d27:	48 89 e5             	mov    %rsp,%rbp
  801d2a:	48 83 ec 08          	sub    $0x8,%rsp
  801d2e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d32:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d36:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d3d:	ff ff ff 
  801d40:	48 01 d0             	add    %rdx,%rax
  801d43:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d47:	c9                   	leaveq 
  801d48:	c3                   	retq   

0000000000801d49 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d49:	55                   	push   %rbp
  801d4a:	48 89 e5             	mov    %rsp,%rbp
  801d4d:	48 83 ec 08          	sub    $0x8,%rsp
  801d51:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d59:	48 89 c7             	mov    %rax,%rdi
  801d5c:	48 b8 26 1d 80 00 00 	movabs $0x801d26,%rax
  801d63:	00 00 00 
  801d66:	ff d0                	callq  *%rax
  801d68:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d6e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d72:	c9                   	leaveq 
  801d73:	c3                   	retq   

0000000000801d74 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d74:	55                   	push   %rbp
  801d75:	48 89 e5             	mov    %rsp,%rbp
  801d78:	48 83 ec 18          	sub    $0x18,%rsp
  801d7c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d87:	eb 6b                	jmp    801df4 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d8c:	48 98                	cltq   
  801d8e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d94:	48 c1 e0 0c          	shl    $0xc,%rax
  801d98:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801da0:	48 c1 e8 15          	shr    $0x15,%rax
  801da4:	48 89 c2             	mov    %rax,%rdx
  801da7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801dae:	01 00 00 
  801db1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801db5:	83 e0 01             	and    $0x1,%eax
  801db8:	48 85 c0             	test   %rax,%rax
  801dbb:	74 21                	je     801dde <fd_alloc+0x6a>
  801dbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dc1:	48 c1 e8 0c          	shr    $0xc,%rax
  801dc5:	48 89 c2             	mov    %rax,%rdx
  801dc8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dcf:	01 00 00 
  801dd2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dd6:	83 e0 01             	and    $0x1,%eax
  801dd9:	48 85 c0             	test   %rax,%rax
  801ddc:	75 12                	jne    801df0 <fd_alloc+0x7c>
			*fd_store = fd;
  801dde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801de6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801de9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dee:	eb 1a                	jmp    801e0a <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801df0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801df4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801df8:	7e 8f                	jle    801d89 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801dfa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dfe:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e05:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e0a:	c9                   	leaveq 
  801e0b:	c3                   	retq   

0000000000801e0c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e0c:	55                   	push   %rbp
  801e0d:	48 89 e5             	mov    %rsp,%rbp
  801e10:	48 83 ec 20          	sub    $0x20,%rsp
  801e14:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e17:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e1b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e1f:	78 06                	js     801e27 <fd_lookup+0x1b>
  801e21:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e25:	7e 07                	jle    801e2e <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e27:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e2c:	eb 6c                	jmp    801e9a <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e2e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e31:	48 98                	cltq   
  801e33:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e39:	48 c1 e0 0c          	shl    $0xc,%rax
  801e3d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e45:	48 c1 e8 15          	shr    $0x15,%rax
  801e49:	48 89 c2             	mov    %rax,%rdx
  801e4c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e53:	01 00 00 
  801e56:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e5a:	83 e0 01             	and    $0x1,%eax
  801e5d:	48 85 c0             	test   %rax,%rax
  801e60:	74 21                	je     801e83 <fd_lookup+0x77>
  801e62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e66:	48 c1 e8 0c          	shr    $0xc,%rax
  801e6a:	48 89 c2             	mov    %rax,%rdx
  801e6d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e74:	01 00 00 
  801e77:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e7b:	83 e0 01             	and    $0x1,%eax
  801e7e:	48 85 c0             	test   %rax,%rax
  801e81:	75 07                	jne    801e8a <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e83:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e88:	eb 10                	jmp    801e9a <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e8a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e8e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e92:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e9a:	c9                   	leaveq 
  801e9b:	c3                   	retq   

0000000000801e9c <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e9c:	55                   	push   %rbp
  801e9d:	48 89 e5             	mov    %rsp,%rbp
  801ea0:	48 83 ec 30          	sub    $0x30,%rsp
  801ea4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ea8:	89 f0                	mov    %esi,%eax
  801eaa:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ead:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eb1:	48 89 c7             	mov    %rax,%rdi
  801eb4:	48 b8 26 1d 80 00 00 	movabs $0x801d26,%rax
  801ebb:	00 00 00 
  801ebe:	ff d0                	callq  *%rax
  801ec0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ec4:	48 89 d6             	mov    %rdx,%rsi
  801ec7:	89 c7                	mov    %eax,%edi
  801ec9:	48 b8 0c 1e 80 00 00 	movabs $0x801e0c,%rax
  801ed0:	00 00 00 
  801ed3:	ff d0                	callq  *%rax
  801ed5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ed8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801edc:	78 0a                	js     801ee8 <fd_close+0x4c>
	    || fd != fd2)
  801ede:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ee2:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801ee6:	74 12                	je     801efa <fd_close+0x5e>
		return (must_exist ? r : 0);
  801ee8:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801eec:	74 05                	je     801ef3 <fd_close+0x57>
  801eee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ef1:	eb 05                	jmp    801ef8 <fd_close+0x5c>
  801ef3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef8:	eb 69                	jmp    801f63 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801efa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801efe:	8b 00                	mov    (%rax),%eax
  801f00:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f04:	48 89 d6             	mov    %rdx,%rsi
  801f07:	89 c7                	mov    %eax,%edi
  801f09:	48 b8 65 1f 80 00 00 	movabs $0x801f65,%rax
  801f10:	00 00 00 
  801f13:	ff d0                	callq  *%rax
  801f15:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f18:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f1c:	78 2a                	js     801f48 <fd_close+0xac>
		if (dev->dev_close)
  801f1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f22:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f26:	48 85 c0             	test   %rax,%rax
  801f29:	74 16                	je     801f41 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f2f:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f33:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f37:	48 89 d7             	mov    %rdx,%rdi
  801f3a:	ff d0                	callq  *%rax
  801f3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f3f:	eb 07                	jmp    801f48 <fd_close+0xac>
		else
			r = 0;
  801f41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f4c:	48 89 c6             	mov    %rax,%rsi
  801f4f:	bf 00 00 00 00       	mov    $0x0,%edi
  801f54:	48 b8 9a 1a 80 00 00 	movabs $0x801a9a,%rax
  801f5b:	00 00 00 
  801f5e:	ff d0                	callq  *%rax
	return r;
  801f60:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f63:	c9                   	leaveq 
  801f64:	c3                   	retq   

0000000000801f65 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f65:	55                   	push   %rbp
  801f66:	48 89 e5             	mov    %rsp,%rbp
  801f69:	48 83 ec 20          	sub    $0x20,%rsp
  801f6d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f70:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f7b:	eb 41                	jmp    801fbe <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f7d:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f84:	00 00 00 
  801f87:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f8a:	48 63 d2             	movslq %edx,%rdx
  801f8d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f91:	8b 00                	mov    (%rax),%eax
  801f93:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f96:	75 22                	jne    801fba <dev_lookup+0x55>
			*dev = devtab[i];
  801f98:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f9f:	00 00 00 
  801fa2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fa5:	48 63 d2             	movslq %edx,%rdx
  801fa8:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801fac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fb0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801fb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb8:	eb 60                	jmp    80201a <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801fba:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fbe:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fc5:	00 00 00 
  801fc8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fcb:	48 63 d2             	movslq %edx,%rdx
  801fce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fd2:	48 85 c0             	test   %rax,%rax
  801fd5:	75 a6                	jne    801f7d <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801fd7:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801fde:	00 00 00 
  801fe1:	48 8b 00             	mov    (%rax),%rax
  801fe4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801fea:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fed:	89 c6                	mov    %eax,%esi
  801fef:	48 bf 58 4c 80 00 00 	movabs $0x804c58,%rdi
  801ff6:	00 00 00 
  801ff9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffe:	48 b9 0b 05 80 00 00 	movabs $0x80050b,%rcx
  802005:	00 00 00 
  802008:	ff d1                	callq  *%rcx
	*dev = 0;
  80200a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80200e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802015:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80201a:	c9                   	leaveq 
  80201b:	c3                   	retq   

000000000080201c <close>:

int
close(int fdnum)
{
  80201c:	55                   	push   %rbp
  80201d:	48 89 e5             	mov    %rsp,%rbp
  802020:	48 83 ec 20          	sub    $0x20,%rsp
  802024:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802027:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80202b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80202e:	48 89 d6             	mov    %rdx,%rsi
  802031:	89 c7                	mov    %eax,%edi
  802033:	48 b8 0c 1e 80 00 00 	movabs $0x801e0c,%rax
  80203a:	00 00 00 
  80203d:	ff d0                	callq  *%rax
  80203f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802042:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802046:	79 05                	jns    80204d <close+0x31>
		return r;
  802048:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80204b:	eb 18                	jmp    802065 <close+0x49>
	else
		return fd_close(fd, 1);
  80204d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802051:	be 01 00 00 00       	mov    $0x1,%esi
  802056:	48 89 c7             	mov    %rax,%rdi
  802059:	48 b8 9c 1e 80 00 00 	movabs $0x801e9c,%rax
  802060:	00 00 00 
  802063:	ff d0                	callq  *%rax
}
  802065:	c9                   	leaveq 
  802066:	c3                   	retq   

0000000000802067 <close_all>:

void
close_all(void)
{
  802067:	55                   	push   %rbp
  802068:	48 89 e5             	mov    %rsp,%rbp
  80206b:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80206f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802076:	eb 15                	jmp    80208d <close_all+0x26>
		close(i);
  802078:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80207b:	89 c7                	mov    %eax,%edi
  80207d:	48 b8 1c 20 80 00 00 	movabs $0x80201c,%rax
  802084:	00 00 00 
  802087:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802089:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80208d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802091:	7e e5                	jle    802078 <close_all+0x11>
		close(i);
}
  802093:	c9                   	leaveq 
  802094:	c3                   	retq   

0000000000802095 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802095:	55                   	push   %rbp
  802096:	48 89 e5             	mov    %rsp,%rbp
  802099:	48 83 ec 40          	sub    $0x40,%rsp
  80209d:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8020a0:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8020a3:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8020a7:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020aa:	48 89 d6             	mov    %rdx,%rsi
  8020ad:	89 c7                	mov    %eax,%edi
  8020af:	48 b8 0c 1e 80 00 00 	movabs $0x801e0c,%rax
  8020b6:	00 00 00 
  8020b9:	ff d0                	callq  *%rax
  8020bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020c2:	79 08                	jns    8020cc <dup+0x37>
		return r;
  8020c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020c7:	e9 70 01 00 00       	jmpq   80223c <dup+0x1a7>
	close(newfdnum);
  8020cc:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020cf:	89 c7                	mov    %eax,%edi
  8020d1:	48 b8 1c 20 80 00 00 	movabs $0x80201c,%rax
  8020d8:	00 00 00 
  8020db:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8020dd:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020e0:	48 98                	cltq   
  8020e2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020e8:	48 c1 e0 0c          	shl    $0xc,%rax
  8020ec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8020f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020f4:	48 89 c7             	mov    %rax,%rdi
  8020f7:	48 b8 49 1d 80 00 00 	movabs $0x801d49,%rax
  8020fe:	00 00 00 
  802101:	ff d0                	callq  *%rax
  802103:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802107:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80210b:	48 89 c7             	mov    %rax,%rdi
  80210e:	48 b8 49 1d 80 00 00 	movabs $0x801d49,%rax
  802115:	00 00 00 
  802118:	ff d0                	callq  *%rax
  80211a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80211e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802122:	48 c1 e8 15          	shr    $0x15,%rax
  802126:	48 89 c2             	mov    %rax,%rdx
  802129:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802130:	01 00 00 
  802133:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802137:	83 e0 01             	and    $0x1,%eax
  80213a:	48 85 c0             	test   %rax,%rax
  80213d:	74 73                	je     8021b2 <dup+0x11d>
  80213f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802143:	48 c1 e8 0c          	shr    $0xc,%rax
  802147:	48 89 c2             	mov    %rax,%rdx
  80214a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802151:	01 00 00 
  802154:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802158:	83 e0 01             	and    $0x1,%eax
  80215b:	48 85 c0             	test   %rax,%rax
  80215e:	74 52                	je     8021b2 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802160:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802164:	48 c1 e8 0c          	shr    $0xc,%rax
  802168:	48 89 c2             	mov    %rax,%rdx
  80216b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802172:	01 00 00 
  802175:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802179:	25 07 0e 00 00       	and    $0xe07,%eax
  80217e:	89 c1                	mov    %eax,%ecx
  802180:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802184:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802188:	41 89 c8             	mov    %ecx,%r8d
  80218b:	48 89 d1             	mov    %rdx,%rcx
  80218e:	ba 00 00 00 00       	mov    $0x0,%edx
  802193:	48 89 c6             	mov    %rax,%rsi
  802196:	bf 00 00 00 00       	mov    $0x0,%edi
  80219b:	48 b8 3f 1a 80 00 00 	movabs $0x801a3f,%rax
  8021a2:	00 00 00 
  8021a5:	ff d0                	callq  *%rax
  8021a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021ae:	79 02                	jns    8021b2 <dup+0x11d>
			goto err;
  8021b0:	eb 57                	jmp    802209 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021b6:	48 c1 e8 0c          	shr    $0xc,%rax
  8021ba:	48 89 c2             	mov    %rax,%rdx
  8021bd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021c4:	01 00 00 
  8021c7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021cb:	25 07 0e 00 00       	and    $0xe07,%eax
  8021d0:	89 c1                	mov    %eax,%ecx
  8021d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021d6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021da:	41 89 c8             	mov    %ecx,%r8d
  8021dd:	48 89 d1             	mov    %rdx,%rcx
  8021e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8021e5:	48 89 c6             	mov    %rax,%rsi
  8021e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ed:	48 b8 3f 1a 80 00 00 	movabs $0x801a3f,%rax
  8021f4:	00 00 00 
  8021f7:	ff d0                	callq  *%rax
  8021f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802200:	79 02                	jns    802204 <dup+0x16f>
		goto err;
  802202:	eb 05                	jmp    802209 <dup+0x174>

	return newfdnum;
  802204:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802207:	eb 33                	jmp    80223c <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802209:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80220d:	48 89 c6             	mov    %rax,%rsi
  802210:	bf 00 00 00 00       	mov    $0x0,%edi
  802215:	48 b8 9a 1a 80 00 00 	movabs $0x801a9a,%rax
  80221c:	00 00 00 
  80221f:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802221:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802225:	48 89 c6             	mov    %rax,%rsi
  802228:	bf 00 00 00 00       	mov    $0x0,%edi
  80222d:	48 b8 9a 1a 80 00 00 	movabs $0x801a9a,%rax
  802234:	00 00 00 
  802237:	ff d0                	callq  *%rax
	return r;
  802239:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80223c:	c9                   	leaveq 
  80223d:	c3                   	retq   

000000000080223e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80223e:	55                   	push   %rbp
  80223f:	48 89 e5             	mov    %rsp,%rbp
  802242:	48 83 ec 40          	sub    $0x40,%rsp
  802246:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802249:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80224d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802251:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802255:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802258:	48 89 d6             	mov    %rdx,%rsi
  80225b:	89 c7                	mov    %eax,%edi
  80225d:	48 b8 0c 1e 80 00 00 	movabs $0x801e0c,%rax
  802264:	00 00 00 
  802267:	ff d0                	callq  *%rax
  802269:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80226c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802270:	78 24                	js     802296 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802272:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802276:	8b 00                	mov    (%rax),%eax
  802278:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80227c:	48 89 d6             	mov    %rdx,%rsi
  80227f:	89 c7                	mov    %eax,%edi
  802281:	48 b8 65 1f 80 00 00 	movabs $0x801f65,%rax
  802288:	00 00 00 
  80228b:	ff d0                	callq  *%rax
  80228d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802290:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802294:	79 05                	jns    80229b <read+0x5d>
		return r;
  802296:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802299:	eb 76                	jmp    802311 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80229b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80229f:	8b 40 08             	mov    0x8(%rax),%eax
  8022a2:	83 e0 03             	and    $0x3,%eax
  8022a5:	83 f8 01             	cmp    $0x1,%eax
  8022a8:	75 3a                	jne    8022e4 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8022aa:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8022b1:	00 00 00 
  8022b4:	48 8b 00             	mov    (%rax),%rax
  8022b7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022bd:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022c0:	89 c6                	mov    %eax,%esi
  8022c2:	48 bf 77 4c 80 00 00 	movabs $0x804c77,%rdi
  8022c9:	00 00 00 
  8022cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d1:	48 b9 0b 05 80 00 00 	movabs $0x80050b,%rcx
  8022d8:	00 00 00 
  8022db:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022e2:	eb 2d                	jmp    802311 <read+0xd3>
	}
	if (!dev->dev_read)
  8022e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022ec:	48 85 c0             	test   %rax,%rax
  8022ef:	75 07                	jne    8022f8 <read+0xba>
		return -E_NOT_SUPP;
  8022f1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022f6:	eb 19                	jmp    802311 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8022f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022fc:	48 8b 40 10          	mov    0x10(%rax),%rax
  802300:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802304:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802308:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80230c:	48 89 cf             	mov    %rcx,%rdi
  80230f:	ff d0                	callq  *%rax
}
  802311:	c9                   	leaveq 
  802312:	c3                   	retq   

0000000000802313 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802313:	55                   	push   %rbp
  802314:	48 89 e5             	mov    %rsp,%rbp
  802317:	48 83 ec 30          	sub    $0x30,%rsp
  80231b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80231e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802322:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802326:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80232d:	eb 49                	jmp    802378 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80232f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802332:	48 98                	cltq   
  802334:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802338:	48 29 c2             	sub    %rax,%rdx
  80233b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80233e:	48 63 c8             	movslq %eax,%rcx
  802341:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802345:	48 01 c1             	add    %rax,%rcx
  802348:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80234b:	48 89 ce             	mov    %rcx,%rsi
  80234e:	89 c7                	mov    %eax,%edi
  802350:	48 b8 3e 22 80 00 00 	movabs $0x80223e,%rax
  802357:	00 00 00 
  80235a:	ff d0                	callq  *%rax
  80235c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80235f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802363:	79 05                	jns    80236a <readn+0x57>
			return m;
  802365:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802368:	eb 1c                	jmp    802386 <readn+0x73>
		if (m == 0)
  80236a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80236e:	75 02                	jne    802372 <readn+0x5f>
			break;
  802370:	eb 11                	jmp    802383 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802372:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802375:	01 45 fc             	add    %eax,-0x4(%rbp)
  802378:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80237b:	48 98                	cltq   
  80237d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802381:	72 ac                	jb     80232f <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802383:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802386:	c9                   	leaveq 
  802387:	c3                   	retq   

0000000000802388 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802388:	55                   	push   %rbp
  802389:	48 89 e5             	mov    %rsp,%rbp
  80238c:	48 83 ec 40          	sub    $0x40,%rsp
  802390:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802393:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802397:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80239b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80239f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023a2:	48 89 d6             	mov    %rdx,%rsi
  8023a5:	89 c7                	mov    %eax,%edi
  8023a7:	48 b8 0c 1e 80 00 00 	movabs $0x801e0c,%rax
  8023ae:	00 00 00 
  8023b1:	ff d0                	callq  *%rax
  8023b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ba:	78 24                	js     8023e0 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c0:	8b 00                	mov    (%rax),%eax
  8023c2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023c6:	48 89 d6             	mov    %rdx,%rsi
  8023c9:	89 c7                	mov    %eax,%edi
  8023cb:	48 b8 65 1f 80 00 00 	movabs $0x801f65,%rax
  8023d2:	00 00 00 
  8023d5:	ff d0                	callq  *%rax
  8023d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023de:	79 05                	jns    8023e5 <write+0x5d>
		return r;
  8023e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023e3:	eb 75                	jmp    80245a <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e9:	8b 40 08             	mov    0x8(%rax),%eax
  8023ec:	83 e0 03             	and    $0x3,%eax
  8023ef:	85 c0                	test   %eax,%eax
  8023f1:	75 3a                	jne    80242d <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8023f3:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8023fa:	00 00 00 
  8023fd:	48 8b 00             	mov    (%rax),%rax
  802400:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802406:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802409:	89 c6                	mov    %eax,%esi
  80240b:	48 bf 93 4c 80 00 00 	movabs $0x804c93,%rdi
  802412:	00 00 00 
  802415:	b8 00 00 00 00       	mov    $0x0,%eax
  80241a:	48 b9 0b 05 80 00 00 	movabs $0x80050b,%rcx
  802421:	00 00 00 
  802424:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802426:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80242b:	eb 2d                	jmp    80245a <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  80242d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802431:	48 8b 40 18          	mov    0x18(%rax),%rax
  802435:	48 85 c0             	test   %rax,%rax
  802438:	75 07                	jne    802441 <write+0xb9>
		return -E_NOT_SUPP;
  80243a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80243f:	eb 19                	jmp    80245a <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802441:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802445:	48 8b 40 18          	mov    0x18(%rax),%rax
  802449:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80244d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802451:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802455:	48 89 cf             	mov    %rcx,%rdi
  802458:	ff d0                	callq  *%rax
}
  80245a:	c9                   	leaveq 
  80245b:	c3                   	retq   

000000000080245c <seek>:

int
seek(int fdnum, off_t offset)
{
  80245c:	55                   	push   %rbp
  80245d:	48 89 e5             	mov    %rsp,%rbp
  802460:	48 83 ec 18          	sub    $0x18,%rsp
  802464:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802467:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80246a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80246e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802471:	48 89 d6             	mov    %rdx,%rsi
  802474:	89 c7                	mov    %eax,%edi
  802476:	48 b8 0c 1e 80 00 00 	movabs $0x801e0c,%rax
  80247d:	00 00 00 
  802480:	ff d0                	callq  *%rax
  802482:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802485:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802489:	79 05                	jns    802490 <seek+0x34>
		return r;
  80248b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80248e:	eb 0f                	jmp    80249f <seek+0x43>
	fd->fd_offset = offset;
  802490:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802494:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802497:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80249a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80249f:	c9                   	leaveq 
  8024a0:	c3                   	retq   

00000000008024a1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8024a1:	55                   	push   %rbp
  8024a2:	48 89 e5             	mov    %rsp,%rbp
  8024a5:	48 83 ec 30          	sub    $0x30,%rsp
  8024a9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024ac:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024af:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024b3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024b6:	48 89 d6             	mov    %rdx,%rsi
  8024b9:	89 c7                	mov    %eax,%edi
  8024bb:	48 b8 0c 1e 80 00 00 	movabs $0x801e0c,%rax
  8024c2:	00 00 00 
  8024c5:	ff d0                	callq  *%rax
  8024c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024ce:	78 24                	js     8024f4 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024d4:	8b 00                	mov    (%rax),%eax
  8024d6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024da:	48 89 d6             	mov    %rdx,%rsi
  8024dd:	89 c7                	mov    %eax,%edi
  8024df:	48 b8 65 1f 80 00 00 	movabs $0x801f65,%rax
  8024e6:	00 00 00 
  8024e9:	ff d0                	callq  *%rax
  8024eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f2:	79 05                	jns    8024f9 <ftruncate+0x58>
		return r;
  8024f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f7:	eb 72                	jmp    80256b <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024fd:	8b 40 08             	mov    0x8(%rax),%eax
  802500:	83 e0 03             	and    $0x3,%eax
  802503:	85 c0                	test   %eax,%eax
  802505:	75 3a                	jne    802541 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802507:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80250e:	00 00 00 
  802511:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802514:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80251a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80251d:	89 c6                	mov    %eax,%esi
  80251f:	48 bf b0 4c 80 00 00 	movabs $0x804cb0,%rdi
  802526:	00 00 00 
  802529:	b8 00 00 00 00       	mov    $0x0,%eax
  80252e:	48 b9 0b 05 80 00 00 	movabs $0x80050b,%rcx
  802535:	00 00 00 
  802538:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80253a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80253f:	eb 2a                	jmp    80256b <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802541:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802545:	48 8b 40 30          	mov    0x30(%rax),%rax
  802549:	48 85 c0             	test   %rax,%rax
  80254c:	75 07                	jne    802555 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80254e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802553:	eb 16                	jmp    80256b <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802555:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802559:	48 8b 40 30          	mov    0x30(%rax),%rax
  80255d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802561:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802564:	89 ce                	mov    %ecx,%esi
  802566:	48 89 d7             	mov    %rdx,%rdi
  802569:	ff d0                	callq  *%rax
}
  80256b:	c9                   	leaveq 
  80256c:	c3                   	retq   

000000000080256d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80256d:	55                   	push   %rbp
  80256e:	48 89 e5             	mov    %rsp,%rbp
  802571:	48 83 ec 30          	sub    $0x30,%rsp
  802575:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802578:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80257c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802580:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802583:	48 89 d6             	mov    %rdx,%rsi
  802586:	89 c7                	mov    %eax,%edi
  802588:	48 b8 0c 1e 80 00 00 	movabs $0x801e0c,%rax
  80258f:	00 00 00 
  802592:	ff d0                	callq  *%rax
  802594:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802597:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80259b:	78 24                	js     8025c1 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80259d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025a1:	8b 00                	mov    (%rax),%eax
  8025a3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025a7:	48 89 d6             	mov    %rdx,%rsi
  8025aa:	89 c7                	mov    %eax,%edi
  8025ac:	48 b8 65 1f 80 00 00 	movabs $0x801f65,%rax
  8025b3:	00 00 00 
  8025b6:	ff d0                	callq  *%rax
  8025b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025bf:	79 05                	jns    8025c6 <fstat+0x59>
		return r;
  8025c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025c4:	eb 5e                	jmp    802624 <fstat+0xb7>
	if (!dev->dev_stat)
  8025c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ca:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025ce:	48 85 c0             	test   %rax,%rax
  8025d1:	75 07                	jne    8025da <fstat+0x6d>
		return -E_NOT_SUPP;
  8025d3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025d8:	eb 4a                	jmp    802624 <fstat+0xb7>
	stat->st_name[0] = 0;
  8025da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025de:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8025e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025e5:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8025ec:	00 00 00 
	stat->st_isdir = 0;
  8025ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025f3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8025fa:	00 00 00 
	stat->st_dev = dev;
  8025fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802601:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802605:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80260c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802610:	48 8b 40 28          	mov    0x28(%rax),%rax
  802614:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802618:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80261c:	48 89 ce             	mov    %rcx,%rsi
  80261f:	48 89 d7             	mov    %rdx,%rdi
  802622:	ff d0                	callq  *%rax
}
  802624:	c9                   	leaveq 
  802625:	c3                   	retq   

0000000000802626 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802626:	55                   	push   %rbp
  802627:	48 89 e5             	mov    %rsp,%rbp
  80262a:	48 83 ec 20          	sub    $0x20,%rsp
  80262e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802632:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802636:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80263a:	be 00 00 00 00       	mov    $0x0,%esi
  80263f:	48 89 c7             	mov    %rax,%rdi
  802642:	48 b8 14 27 80 00 00 	movabs $0x802714,%rax
  802649:	00 00 00 
  80264c:	ff d0                	callq  *%rax
  80264e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802651:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802655:	79 05                	jns    80265c <stat+0x36>
		return fd;
  802657:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80265a:	eb 2f                	jmp    80268b <stat+0x65>
	r = fstat(fd, stat);
  80265c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802660:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802663:	48 89 d6             	mov    %rdx,%rsi
  802666:	89 c7                	mov    %eax,%edi
  802668:	48 b8 6d 25 80 00 00 	movabs $0x80256d,%rax
  80266f:	00 00 00 
  802672:	ff d0                	callq  *%rax
  802674:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802677:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80267a:	89 c7                	mov    %eax,%edi
  80267c:	48 b8 1c 20 80 00 00 	movabs $0x80201c,%rax
  802683:	00 00 00 
  802686:	ff d0                	callq  *%rax
	return r;
  802688:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80268b:	c9                   	leaveq 
  80268c:	c3                   	retq   

000000000080268d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80268d:	55                   	push   %rbp
  80268e:	48 89 e5             	mov    %rsp,%rbp
  802691:	48 83 ec 10          	sub    $0x10,%rsp
  802695:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802698:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80269c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026a3:	00 00 00 
  8026a6:	8b 00                	mov    (%rax),%eax
  8026a8:	85 c0                	test   %eax,%eax
  8026aa:	75 1d                	jne    8026c9 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8026ac:	bf 01 00 00 00       	mov    $0x1,%edi
  8026b1:	48 b8 2e 40 80 00 00 	movabs $0x80402e,%rax
  8026b8:	00 00 00 
  8026bb:	ff d0                	callq  *%rax
  8026bd:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8026c4:	00 00 00 
  8026c7:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8026c9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026d0:	00 00 00 
  8026d3:	8b 00                	mov    (%rax),%eax
  8026d5:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026d8:	b9 07 00 00 00       	mov    $0x7,%ecx
  8026dd:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8026e4:	00 00 00 
  8026e7:	89 c7                	mov    %eax,%edi
  8026e9:	48 b8 cc 3f 80 00 00 	movabs $0x803fcc,%rax
  8026f0:	00 00 00 
  8026f3:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8026f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8026fe:	48 89 c6             	mov    %rax,%rsi
  802701:	bf 00 00 00 00       	mov    $0x0,%edi
  802706:	48 b8 c6 3e 80 00 00 	movabs $0x803ec6,%rax
  80270d:	00 00 00 
  802710:	ff d0                	callq  *%rax
}
  802712:	c9                   	leaveq 
  802713:	c3                   	retq   

0000000000802714 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802714:	55                   	push   %rbp
  802715:	48 89 e5             	mov    %rsp,%rbp
  802718:	48 83 ec 30          	sub    $0x30,%rsp
  80271c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802720:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802723:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80272a:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802731:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802738:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80273d:	75 08                	jne    802747 <open+0x33>
	{
		return r;
  80273f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802742:	e9 f2 00 00 00       	jmpq   802839 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802747:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80274b:	48 89 c7             	mov    %rax,%rdi
  80274e:	48 b8 54 10 80 00 00 	movabs $0x801054,%rax
  802755:	00 00 00 
  802758:	ff d0                	callq  *%rax
  80275a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80275d:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802764:	7e 0a                	jle    802770 <open+0x5c>
	{
		return -E_BAD_PATH;
  802766:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80276b:	e9 c9 00 00 00       	jmpq   802839 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802770:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802777:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802778:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80277c:	48 89 c7             	mov    %rax,%rdi
  80277f:	48 b8 74 1d 80 00 00 	movabs $0x801d74,%rax
  802786:	00 00 00 
  802789:	ff d0                	callq  *%rax
  80278b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80278e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802792:	78 09                	js     80279d <open+0x89>
  802794:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802798:	48 85 c0             	test   %rax,%rax
  80279b:	75 08                	jne    8027a5 <open+0x91>
		{
			return r;
  80279d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a0:	e9 94 00 00 00       	jmpq   802839 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8027a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027a9:	ba 00 04 00 00       	mov    $0x400,%edx
  8027ae:	48 89 c6             	mov    %rax,%rsi
  8027b1:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8027b8:	00 00 00 
  8027bb:	48 b8 52 11 80 00 00 	movabs $0x801152,%rax
  8027c2:	00 00 00 
  8027c5:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8027c7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027ce:	00 00 00 
  8027d1:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8027d4:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8027da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027de:	48 89 c6             	mov    %rax,%rsi
  8027e1:	bf 01 00 00 00       	mov    $0x1,%edi
  8027e6:	48 b8 8d 26 80 00 00 	movabs $0x80268d,%rax
  8027ed:	00 00 00 
  8027f0:	ff d0                	callq  *%rax
  8027f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027f9:	79 2b                	jns    802826 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8027fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ff:	be 00 00 00 00       	mov    $0x0,%esi
  802804:	48 89 c7             	mov    %rax,%rdi
  802807:	48 b8 9c 1e 80 00 00 	movabs $0x801e9c,%rax
  80280e:	00 00 00 
  802811:	ff d0                	callq  *%rax
  802813:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802816:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80281a:	79 05                	jns    802821 <open+0x10d>
			{
				return d;
  80281c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80281f:	eb 18                	jmp    802839 <open+0x125>
			}
			return r;
  802821:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802824:	eb 13                	jmp    802839 <open+0x125>
		}	
		return fd2num(fd_store);
  802826:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80282a:	48 89 c7             	mov    %rax,%rdi
  80282d:	48 b8 26 1d 80 00 00 	movabs $0x801d26,%rax
  802834:	00 00 00 
  802837:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802839:	c9                   	leaveq 
  80283a:	c3                   	retq   

000000000080283b <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80283b:	55                   	push   %rbp
  80283c:	48 89 e5             	mov    %rsp,%rbp
  80283f:	48 83 ec 10          	sub    $0x10,%rsp
  802843:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802847:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80284b:	8b 50 0c             	mov    0xc(%rax),%edx
  80284e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802855:	00 00 00 
  802858:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80285a:	be 00 00 00 00       	mov    $0x0,%esi
  80285f:	bf 06 00 00 00       	mov    $0x6,%edi
  802864:	48 b8 8d 26 80 00 00 	movabs $0x80268d,%rax
  80286b:	00 00 00 
  80286e:	ff d0                	callq  *%rax
}
  802870:	c9                   	leaveq 
  802871:	c3                   	retq   

0000000000802872 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802872:	55                   	push   %rbp
  802873:	48 89 e5             	mov    %rsp,%rbp
  802876:	48 83 ec 30          	sub    $0x30,%rsp
  80287a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80287e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802882:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802886:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80288d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802892:	74 07                	je     80289b <devfile_read+0x29>
  802894:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802899:	75 07                	jne    8028a2 <devfile_read+0x30>
		return -E_INVAL;
  80289b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028a0:	eb 77                	jmp    802919 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8028a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a6:	8b 50 0c             	mov    0xc(%rax),%edx
  8028a9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028b0:	00 00 00 
  8028b3:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8028b5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028bc:	00 00 00 
  8028bf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028c3:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8028c7:	be 00 00 00 00       	mov    $0x0,%esi
  8028cc:	bf 03 00 00 00       	mov    $0x3,%edi
  8028d1:	48 b8 8d 26 80 00 00 	movabs $0x80268d,%rax
  8028d8:	00 00 00 
  8028db:	ff d0                	callq  *%rax
  8028dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e4:	7f 05                	jg     8028eb <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8028e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028e9:	eb 2e                	jmp    802919 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8028eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ee:	48 63 d0             	movslq %eax,%rdx
  8028f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028f5:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8028fc:	00 00 00 
  8028ff:	48 89 c7             	mov    %rax,%rdi
  802902:	48 b8 e4 13 80 00 00 	movabs $0x8013e4,%rax
  802909:	00 00 00 
  80290c:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  80290e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802912:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802916:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802919:	c9                   	leaveq 
  80291a:	c3                   	retq   

000000000080291b <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80291b:	55                   	push   %rbp
  80291c:	48 89 e5             	mov    %rsp,%rbp
  80291f:	48 83 ec 30          	sub    $0x30,%rsp
  802923:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802927:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80292b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80292f:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802936:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80293b:	74 07                	je     802944 <devfile_write+0x29>
  80293d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802942:	75 08                	jne    80294c <devfile_write+0x31>
		return r;
  802944:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802947:	e9 9a 00 00 00       	jmpq   8029e6 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80294c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802950:	8b 50 0c             	mov    0xc(%rax),%edx
  802953:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80295a:	00 00 00 
  80295d:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80295f:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802966:	00 
  802967:	76 08                	jbe    802971 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802969:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802970:	00 
	}
	fsipcbuf.write.req_n = n;
  802971:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802978:	00 00 00 
  80297b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80297f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802983:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802987:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80298b:	48 89 c6             	mov    %rax,%rsi
  80298e:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802995:	00 00 00 
  802998:	48 b8 e4 13 80 00 00 	movabs $0x8013e4,%rax
  80299f:	00 00 00 
  8029a2:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8029a4:	be 00 00 00 00       	mov    $0x0,%esi
  8029a9:	bf 04 00 00 00       	mov    $0x4,%edi
  8029ae:	48 b8 8d 26 80 00 00 	movabs $0x80268d,%rax
  8029b5:	00 00 00 
  8029b8:	ff d0                	callq  *%rax
  8029ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029c1:	7f 20                	jg     8029e3 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8029c3:	48 bf d6 4c 80 00 00 	movabs $0x804cd6,%rdi
  8029ca:	00 00 00 
  8029cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d2:	48 ba 0b 05 80 00 00 	movabs $0x80050b,%rdx
  8029d9:	00 00 00 
  8029dc:	ff d2                	callq  *%rdx
		return r;
  8029de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e1:	eb 03                	jmp    8029e6 <devfile_write+0xcb>
	}
	return r;
  8029e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8029e6:	c9                   	leaveq 
  8029e7:	c3                   	retq   

00000000008029e8 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8029e8:	55                   	push   %rbp
  8029e9:	48 89 e5             	mov    %rsp,%rbp
  8029ec:	48 83 ec 20          	sub    $0x20,%rsp
  8029f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8029f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029fc:	8b 50 0c             	mov    0xc(%rax),%edx
  8029ff:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a06:	00 00 00 
  802a09:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a0b:	be 00 00 00 00       	mov    $0x0,%esi
  802a10:	bf 05 00 00 00       	mov    $0x5,%edi
  802a15:	48 b8 8d 26 80 00 00 	movabs $0x80268d,%rax
  802a1c:	00 00 00 
  802a1f:	ff d0                	callq  *%rax
  802a21:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a28:	79 05                	jns    802a2f <devfile_stat+0x47>
		return r;
  802a2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a2d:	eb 56                	jmp    802a85 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a33:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a3a:	00 00 00 
  802a3d:	48 89 c7             	mov    %rax,%rdi
  802a40:	48 b8 c0 10 80 00 00 	movabs $0x8010c0,%rax
  802a47:	00 00 00 
  802a4a:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a4c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a53:	00 00 00 
  802a56:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a5c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a60:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a66:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a6d:	00 00 00 
  802a70:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a76:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a7a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a85:	c9                   	leaveq 
  802a86:	c3                   	retq   

0000000000802a87 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802a87:	55                   	push   %rbp
  802a88:	48 89 e5             	mov    %rsp,%rbp
  802a8b:	48 83 ec 10          	sub    $0x10,%rsp
  802a8f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a93:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a9a:	8b 50 0c             	mov    0xc(%rax),%edx
  802a9d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802aa4:	00 00 00 
  802aa7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802aa9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ab0:	00 00 00 
  802ab3:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802ab6:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802ab9:	be 00 00 00 00       	mov    $0x0,%esi
  802abe:	bf 02 00 00 00       	mov    $0x2,%edi
  802ac3:	48 b8 8d 26 80 00 00 	movabs $0x80268d,%rax
  802aca:	00 00 00 
  802acd:	ff d0                	callq  *%rax
}
  802acf:	c9                   	leaveq 
  802ad0:	c3                   	retq   

0000000000802ad1 <remove>:

// Delete a file
int
remove(const char *path)
{
  802ad1:	55                   	push   %rbp
  802ad2:	48 89 e5             	mov    %rsp,%rbp
  802ad5:	48 83 ec 10          	sub    $0x10,%rsp
  802ad9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802add:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ae1:	48 89 c7             	mov    %rax,%rdi
  802ae4:	48 b8 54 10 80 00 00 	movabs $0x801054,%rax
  802aeb:	00 00 00 
  802aee:	ff d0                	callq  *%rax
  802af0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802af5:	7e 07                	jle    802afe <remove+0x2d>
		return -E_BAD_PATH;
  802af7:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802afc:	eb 33                	jmp    802b31 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802afe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b02:	48 89 c6             	mov    %rax,%rsi
  802b05:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802b0c:	00 00 00 
  802b0f:	48 b8 c0 10 80 00 00 	movabs $0x8010c0,%rax
  802b16:	00 00 00 
  802b19:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802b1b:	be 00 00 00 00       	mov    $0x0,%esi
  802b20:	bf 07 00 00 00       	mov    $0x7,%edi
  802b25:	48 b8 8d 26 80 00 00 	movabs $0x80268d,%rax
  802b2c:	00 00 00 
  802b2f:	ff d0                	callq  *%rax
}
  802b31:	c9                   	leaveq 
  802b32:	c3                   	retq   

0000000000802b33 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b33:	55                   	push   %rbp
  802b34:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b37:	be 00 00 00 00       	mov    $0x0,%esi
  802b3c:	bf 08 00 00 00       	mov    $0x8,%edi
  802b41:	48 b8 8d 26 80 00 00 	movabs $0x80268d,%rax
  802b48:	00 00 00 
  802b4b:	ff d0                	callq  *%rax
}
  802b4d:	5d                   	pop    %rbp
  802b4e:	c3                   	retq   

0000000000802b4f <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802b4f:	55                   	push   %rbp
  802b50:	48 89 e5             	mov    %rsp,%rbp
  802b53:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802b5a:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802b61:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802b68:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802b6f:	be 00 00 00 00       	mov    $0x0,%esi
  802b74:	48 89 c7             	mov    %rax,%rdi
  802b77:	48 b8 14 27 80 00 00 	movabs $0x802714,%rax
  802b7e:	00 00 00 
  802b81:	ff d0                	callq  *%rax
  802b83:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802b86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b8a:	79 28                	jns    802bb4 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802b8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b8f:	89 c6                	mov    %eax,%esi
  802b91:	48 bf f2 4c 80 00 00 	movabs $0x804cf2,%rdi
  802b98:	00 00 00 
  802b9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba0:	48 ba 0b 05 80 00 00 	movabs $0x80050b,%rdx
  802ba7:	00 00 00 
  802baa:	ff d2                	callq  *%rdx
		return fd_src;
  802bac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802baf:	e9 74 01 00 00       	jmpq   802d28 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802bb4:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802bbb:	be 01 01 00 00       	mov    $0x101,%esi
  802bc0:	48 89 c7             	mov    %rax,%rdi
  802bc3:	48 b8 14 27 80 00 00 	movabs $0x802714,%rax
  802bca:	00 00 00 
  802bcd:	ff d0                	callq  *%rax
  802bcf:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802bd2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bd6:	79 39                	jns    802c11 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802bd8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bdb:	89 c6                	mov    %eax,%esi
  802bdd:	48 bf 08 4d 80 00 00 	movabs $0x804d08,%rdi
  802be4:	00 00 00 
  802be7:	b8 00 00 00 00       	mov    $0x0,%eax
  802bec:	48 ba 0b 05 80 00 00 	movabs $0x80050b,%rdx
  802bf3:	00 00 00 
  802bf6:	ff d2                	callq  *%rdx
		close(fd_src);
  802bf8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bfb:	89 c7                	mov    %eax,%edi
  802bfd:	48 b8 1c 20 80 00 00 	movabs $0x80201c,%rax
  802c04:	00 00 00 
  802c07:	ff d0                	callq  *%rax
		return fd_dest;
  802c09:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c0c:	e9 17 01 00 00       	jmpq   802d28 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c11:	eb 74                	jmp    802c87 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802c13:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c16:	48 63 d0             	movslq %eax,%rdx
  802c19:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c20:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c23:	48 89 ce             	mov    %rcx,%rsi
  802c26:	89 c7                	mov    %eax,%edi
  802c28:	48 b8 88 23 80 00 00 	movabs $0x802388,%rax
  802c2f:	00 00 00 
  802c32:	ff d0                	callq  *%rax
  802c34:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802c37:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c3b:	79 4a                	jns    802c87 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802c3d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c40:	89 c6                	mov    %eax,%esi
  802c42:	48 bf 22 4d 80 00 00 	movabs $0x804d22,%rdi
  802c49:	00 00 00 
  802c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c51:	48 ba 0b 05 80 00 00 	movabs $0x80050b,%rdx
  802c58:	00 00 00 
  802c5b:	ff d2                	callq  *%rdx
			close(fd_src);
  802c5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c60:	89 c7                	mov    %eax,%edi
  802c62:	48 b8 1c 20 80 00 00 	movabs $0x80201c,%rax
  802c69:	00 00 00 
  802c6c:	ff d0                	callq  *%rax
			close(fd_dest);
  802c6e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c71:	89 c7                	mov    %eax,%edi
  802c73:	48 b8 1c 20 80 00 00 	movabs $0x80201c,%rax
  802c7a:	00 00 00 
  802c7d:	ff d0                	callq  *%rax
			return write_size;
  802c7f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c82:	e9 a1 00 00 00       	jmpq   802d28 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c87:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c91:	ba 00 02 00 00       	mov    $0x200,%edx
  802c96:	48 89 ce             	mov    %rcx,%rsi
  802c99:	89 c7                	mov    %eax,%edi
  802c9b:	48 b8 3e 22 80 00 00 	movabs $0x80223e,%rax
  802ca2:	00 00 00 
  802ca5:	ff d0                	callq  *%rax
  802ca7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802caa:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802cae:	0f 8f 5f ff ff ff    	jg     802c13 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802cb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802cb8:	79 47                	jns    802d01 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802cba:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cbd:	89 c6                	mov    %eax,%esi
  802cbf:	48 bf 35 4d 80 00 00 	movabs $0x804d35,%rdi
  802cc6:	00 00 00 
  802cc9:	b8 00 00 00 00       	mov    $0x0,%eax
  802cce:	48 ba 0b 05 80 00 00 	movabs $0x80050b,%rdx
  802cd5:	00 00 00 
  802cd8:	ff d2                	callq  *%rdx
		close(fd_src);
  802cda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cdd:	89 c7                	mov    %eax,%edi
  802cdf:	48 b8 1c 20 80 00 00 	movabs $0x80201c,%rax
  802ce6:	00 00 00 
  802ce9:	ff d0                	callq  *%rax
		close(fd_dest);
  802ceb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cee:	89 c7                	mov    %eax,%edi
  802cf0:	48 b8 1c 20 80 00 00 	movabs $0x80201c,%rax
  802cf7:	00 00 00 
  802cfa:	ff d0                	callq  *%rax
		return read_size;
  802cfc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cff:	eb 27                	jmp    802d28 <copy+0x1d9>
	}
	close(fd_src);
  802d01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d04:	89 c7                	mov    %eax,%edi
  802d06:	48 b8 1c 20 80 00 00 	movabs $0x80201c,%rax
  802d0d:	00 00 00 
  802d10:	ff d0                	callq  *%rax
	close(fd_dest);
  802d12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d15:	89 c7                	mov    %eax,%edi
  802d17:	48 b8 1c 20 80 00 00 	movabs $0x80201c,%rax
  802d1e:	00 00 00 
  802d21:	ff d0                	callq  *%rax
	return 0;
  802d23:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802d28:	c9                   	leaveq 
  802d29:	c3                   	retq   

0000000000802d2a <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802d2a:	55                   	push   %rbp
  802d2b:	48 89 e5             	mov    %rsp,%rbp
  802d2e:	48 83 ec 20          	sub    $0x20,%rsp
  802d32:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802d35:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d39:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d3c:	48 89 d6             	mov    %rdx,%rsi
  802d3f:	89 c7                	mov    %eax,%edi
  802d41:	48 b8 0c 1e 80 00 00 	movabs $0x801e0c,%rax
  802d48:	00 00 00 
  802d4b:	ff d0                	callq  *%rax
  802d4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d54:	79 05                	jns    802d5b <fd2sockid+0x31>
		return r;
  802d56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d59:	eb 24                	jmp    802d7f <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802d5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d5f:	8b 10                	mov    (%rax),%edx
  802d61:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802d68:	00 00 00 
  802d6b:	8b 00                	mov    (%rax),%eax
  802d6d:	39 c2                	cmp    %eax,%edx
  802d6f:	74 07                	je     802d78 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802d71:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d76:	eb 07                	jmp    802d7f <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802d78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d7c:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802d7f:	c9                   	leaveq 
  802d80:	c3                   	retq   

0000000000802d81 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802d81:	55                   	push   %rbp
  802d82:	48 89 e5             	mov    %rsp,%rbp
  802d85:	48 83 ec 20          	sub    $0x20,%rsp
  802d89:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802d8c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d90:	48 89 c7             	mov    %rax,%rdi
  802d93:	48 b8 74 1d 80 00 00 	movabs $0x801d74,%rax
  802d9a:	00 00 00 
  802d9d:	ff d0                	callq  *%rax
  802d9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802da2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da6:	78 26                	js     802dce <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802da8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dac:	ba 07 04 00 00       	mov    $0x407,%edx
  802db1:	48 89 c6             	mov    %rax,%rsi
  802db4:	bf 00 00 00 00       	mov    $0x0,%edi
  802db9:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  802dc0:	00 00 00 
  802dc3:	ff d0                	callq  *%rax
  802dc5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dc8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dcc:	79 16                	jns    802de4 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802dce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dd1:	89 c7                	mov    %eax,%edi
  802dd3:	48 b8 8e 32 80 00 00 	movabs $0x80328e,%rax
  802dda:	00 00 00 
  802ddd:	ff d0                	callq  *%rax
		return r;
  802ddf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de2:	eb 3a                	jmp    802e1e <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802de4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de8:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802def:	00 00 00 
  802df2:	8b 12                	mov    (%rdx),%edx
  802df4:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802df6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dfa:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802e01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e05:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802e08:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802e0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e0f:	48 89 c7             	mov    %rax,%rdi
  802e12:	48 b8 26 1d 80 00 00 	movabs $0x801d26,%rax
  802e19:	00 00 00 
  802e1c:	ff d0                	callq  *%rax
}
  802e1e:	c9                   	leaveq 
  802e1f:	c3                   	retq   

0000000000802e20 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802e20:	55                   	push   %rbp
  802e21:	48 89 e5             	mov    %rsp,%rbp
  802e24:	48 83 ec 30          	sub    $0x30,%rsp
  802e28:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e2b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e2f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e33:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e36:	89 c7                	mov    %eax,%edi
  802e38:	48 b8 2a 2d 80 00 00 	movabs $0x802d2a,%rax
  802e3f:	00 00 00 
  802e42:	ff d0                	callq  *%rax
  802e44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e4b:	79 05                	jns    802e52 <accept+0x32>
		return r;
  802e4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e50:	eb 3b                	jmp    802e8d <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802e52:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e56:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802e5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e5d:	48 89 ce             	mov    %rcx,%rsi
  802e60:	89 c7                	mov    %eax,%edi
  802e62:	48 b8 6b 31 80 00 00 	movabs $0x80316b,%rax
  802e69:	00 00 00 
  802e6c:	ff d0                	callq  *%rax
  802e6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e75:	79 05                	jns    802e7c <accept+0x5c>
		return r;
  802e77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7a:	eb 11                	jmp    802e8d <accept+0x6d>
	return alloc_sockfd(r);
  802e7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7f:	89 c7                	mov    %eax,%edi
  802e81:	48 b8 81 2d 80 00 00 	movabs $0x802d81,%rax
  802e88:	00 00 00 
  802e8b:	ff d0                	callq  *%rax
}
  802e8d:	c9                   	leaveq 
  802e8e:	c3                   	retq   

0000000000802e8f <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802e8f:	55                   	push   %rbp
  802e90:	48 89 e5             	mov    %rsp,%rbp
  802e93:	48 83 ec 20          	sub    $0x20,%rsp
  802e97:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e9a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e9e:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ea1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ea4:	89 c7                	mov    %eax,%edi
  802ea6:	48 b8 2a 2d 80 00 00 	movabs $0x802d2a,%rax
  802ead:	00 00 00 
  802eb0:	ff d0                	callq  *%rax
  802eb2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eb5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eb9:	79 05                	jns    802ec0 <bind+0x31>
		return r;
  802ebb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ebe:	eb 1b                	jmp    802edb <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802ec0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ec3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802ec7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eca:	48 89 ce             	mov    %rcx,%rsi
  802ecd:	89 c7                	mov    %eax,%edi
  802ecf:	48 b8 ea 31 80 00 00 	movabs $0x8031ea,%rax
  802ed6:	00 00 00 
  802ed9:	ff d0                	callq  *%rax
}
  802edb:	c9                   	leaveq 
  802edc:	c3                   	retq   

0000000000802edd <shutdown>:

int
shutdown(int s, int how)
{
  802edd:	55                   	push   %rbp
  802ede:	48 89 e5             	mov    %rsp,%rbp
  802ee1:	48 83 ec 20          	sub    $0x20,%rsp
  802ee5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ee8:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802eeb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802eee:	89 c7                	mov    %eax,%edi
  802ef0:	48 b8 2a 2d 80 00 00 	movabs $0x802d2a,%rax
  802ef7:	00 00 00 
  802efa:	ff d0                	callq  *%rax
  802efc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f03:	79 05                	jns    802f0a <shutdown+0x2d>
		return r;
  802f05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f08:	eb 16                	jmp    802f20 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802f0a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f10:	89 d6                	mov    %edx,%esi
  802f12:	89 c7                	mov    %eax,%edi
  802f14:	48 b8 4e 32 80 00 00 	movabs $0x80324e,%rax
  802f1b:	00 00 00 
  802f1e:	ff d0                	callq  *%rax
}
  802f20:	c9                   	leaveq 
  802f21:	c3                   	retq   

0000000000802f22 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802f22:	55                   	push   %rbp
  802f23:	48 89 e5             	mov    %rsp,%rbp
  802f26:	48 83 ec 10          	sub    $0x10,%rsp
  802f2a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802f2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f32:	48 89 c7             	mov    %rax,%rdi
  802f35:	48 b8 b0 40 80 00 00 	movabs $0x8040b0,%rax
  802f3c:	00 00 00 
  802f3f:	ff d0                	callq  *%rax
  802f41:	83 f8 01             	cmp    $0x1,%eax
  802f44:	75 17                	jne    802f5d <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802f46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f4a:	8b 40 0c             	mov    0xc(%rax),%eax
  802f4d:	89 c7                	mov    %eax,%edi
  802f4f:	48 b8 8e 32 80 00 00 	movabs $0x80328e,%rax
  802f56:	00 00 00 
  802f59:	ff d0                	callq  *%rax
  802f5b:	eb 05                	jmp    802f62 <devsock_close+0x40>
	else
		return 0;
  802f5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f62:	c9                   	leaveq 
  802f63:	c3                   	retq   

0000000000802f64 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802f64:	55                   	push   %rbp
  802f65:	48 89 e5             	mov    %rsp,%rbp
  802f68:	48 83 ec 20          	sub    $0x20,%rsp
  802f6c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f6f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f73:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f76:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f79:	89 c7                	mov    %eax,%edi
  802f7b:	48 b8 2a 2d 80 00 00 	movabs $0x802d2a,%rax
  802f82:	00 00 00 
  802f85:	ff d0                	callq  *%rax
  802f87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f8e:	79 05                	jns    802f95 <connect+0x31>
		return r;
  802f90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f93:	eb 1b                	jmp    802fb0 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802f95:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f98:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f9f:	48 89 ce             	mov    %rcx,%rsi
  802fa2:	89 c7                	mov    %eax,%edi
  802fa4:	48 b8 bb 32 80 00 00 	movabs $0x8032bb,%rax
  802fab:	00 00 00 
  802fae:	ff d0                	callq  *%rax
}
  802fb0:	c9                   	leaveq 
  802fb1:	c3                   	retq   

0000000000802fb2 <listen>:

int
listen(int s, int backlog)
{
  802fb2:	55                   	push   %rbp
  802fb3:	48 89 e5             	mov    %rsp,%rbp
  802fb6:	48 83 ec 20          	sub    $0x20,%rsp
  802fba:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fbd:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fc0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fc3:	89 c7                	mov    %eax,%edi
  802fc5:	48 b8 2a 2d 80 00 00 	movabs $0x802d2a,%rax
  802fcc:	00 00 00 
  802fcf:	ff d0                	callq  *%rax
  802fd1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fd4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fd8:	79 05                	jns    802fdf <listen+0x2d>
		return r;
  802fda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fdd:	eb 16                	jmp    802ff5 <listen+0x43>
	return nsipc_listen(r, backlog);
  802fdf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fe2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe5:	89 d6                	mov    %edx,%esi
  802fe7:	89 c7                	mov    %eax,%edi
  802fe9:	48 b8 1f 33 80 00 00 	movabs $0x80331f,%rax
  802ff0:	00 00 00 
  802ff3:	ff d0                	callq  *%rax
}
  802ff5:	c9                   	leaveq 
  802ff6:	c3                   	retq   

0000000000802ff7 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802ff7:	55                   	push   %rbp
  802ff8:	48 89 e5             	mov    %rsp,%rbp
  802ffb:	48 83 ec 20          	sub    $0x20,%rsp
  802fff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803003:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803007:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80300b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80300f:	89 c2                	mov    %eax,%edx
  803011:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803015:	8b 40 0c             	mov    0xc(%rax),%eax
  803018:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80301c:	b9 00 00 00 00       	mov    $0x0,%ecx
  803021:	89 c7                	mov    %eax,%edi
  803023:	48 b8 5f 33 80 00 00 	movabs $0x80335f,%rax
  80302a:	00 00 00 
  80302d:	ff d0                	callq  *%rax
}
  80302f:	c9                   	leaveq 
  803030:	c3                   	retq   

0000000000803031 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803031:	55                   	push   %rbp
  803032:	48 89 e5             	mov    %rsp,%rbp
  803035:	48 83 ec 20          	sub    $0x20,%rsp
  803039:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80303d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803041:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803045:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803049:	89 c2                	mov    %eax,%edx
  80304b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80304f:	8b 40 0c             	mov    0xc(%rax),%eax
  803052:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803056:	b9 00 00 00 00       	mov    $0x0,%ecx
  80305b:	89 c7                	mov    %eax,%edi
  80305d:	48 b8 2b 34 80 00 00 	movabs $0x80342b,%rax
  803064:	00 00 00 
  803067:	ff d0                	callq  *%rax
}
  803069:	c9                   	leaveq 
  80306a:	c3                   	retq   

000000000080306b <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80306b:	55                   	push   %rbp
  80306c:	48 89 e5             	mov    %rsp,%rbp
  80306f:	48 83 ec 10          	sub    $0x10,%rsp
  803073:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803077:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80307b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80307f:	48 be 50 4d 80 00 00 	movabs $0x804d50,%rsi
  803086:	00 00 00 
  803089:	48 89 c7             	mov    %rax,%rdi
  80308c:	48 b8 c0 10 80 00 00 	movabs $0x8010c0,%rax
  803093:	00 00 00 
  803096:	ff d0                	callq  *%rax
	return 0;
  803098:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80309d:	c9                   	leaveq 
  80309e:	c3                   	retq   

000000000080309f <socket>:

int
socket(int domain, int type, int protocol)
{
  80309f:	55                   	push   %rbp
  8030a0:	48 89 e5             	mov    %rsp,%rbp
  8030a3:	48 83 ec 20          	sub    $0x20,%rsp
  8030a7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030aa:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8030ad:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8030b0:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8030b3:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8030b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030b9:	89 ce                	mov    %ecx,%esi
  8030bb:	89 c7                	mov    %eax,%edi
  8030bd:	48 b8 e3 34 80 00 00 	movabs $0x8034e3,%rax
  8030c4:	00 00 00 
  8030c7:	ff d0                	callq  *%rax
  8030c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d0:	79 05                	jns    8030d7 <socket+0x38>
		return r;
  8030d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d5:	eb 11                	jmp    8030e8 <socket+0x49>
	return alloc_sockfd(r);
  8030d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030da:	89 c7                	mov    %eax,%edi
  8030dc:	48 b8 81 2d 80 00 00 	movabs $0x802d81,%rax
  8030e3:	00 00 00 
  8030e6:	ff d0                	callq  *%rax
}
  8030e8:	c9                   	leaveq 
  8030e9:	c3                   	retq   

00000000008030ea <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8030ea:	55                   	push   %rbp
  8030eb:	48 89 e5             	mov    %rsp,%rbp
  8030ee:	48 83 ec 10          	sub    $0x10,%rsp
  8030f2:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8030f5:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8030fc:	00 00 00 
  8030ff:	8b 00                	mov    (%rax),%eax
  803101:	85 c0                	test   %eax,%eax
  803103:	75 1d                	jne    803122 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803105:	bf 02 00 00 00       	mov    $0x2,%edi
  80310a:	48 b8 2e 40 80 00 00 	movabs $0x80402e,%rax
  803111:	00 00 00 
  803114:	ff d0                	callq  *%rax
  803116:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  80311d:	00 00 00 
  803120:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803122:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803129:	00 00 00 
  80312c:	8b 00                	mov    (%rax),%eax
  80312e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803131:	b9 07 00 00 00       	mov    $0x7,%ecx
  803136:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80313d:	00 00 00 
  803140:	89 c7                	mov    %eax,%edi
  803142:	48 b8 cc 3f 80 00 00 	movabs $0x803fcc,%rax
  803149:	00 00 00 
  80314c:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80314e:	ba 00 00 00 00       	mov    $0x0,%edx
  803153:	be 00 00 00 00       	mov    $0x0,%esi
  803158:	bf 00 00 00 00       	mov    $0x0,%edi
  80315d:	48 b8 c6 3e 80 00 00 	movabs $0x803ec6,%rax
  803164:	00 00 00 
  803167:	ff d0                	callq  *%rax
}
  803169:	c9                   	leaveq 
  80316a:	c3                   	retq   

000000000080316b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80316b:	55                   	push   %rbp
  80316c:	48 89 e5             	mov    %rsp,%rbp
  80316f:	48 83 ec 30          	sub    $0x30,%rsp
  803173:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803176:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80317a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80317e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803185:	00 00 00 
  803188:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80318b:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80318d:	bf 01 00 00 00       	mov    $0x1,%edi
  803192:	48 b8 ea 30 80 00 00 	movabs $0x8030ea,%rax
  803199:	00 00 00 
  80319c:	ff d0                	callq  *%rax
  80319e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031a5:	78 3e                	js     8031e5 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8031a7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031ae:	00 00 00 
  8031b1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8031b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031b9:	8b 40 10             	mov    0x10(%rax),%eax
  8031bc:	89 c2                	mov    %eax,%edx
  8031be:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8031c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031c6:	48 89 ce             	mov    %rcx,%rsi
  8031c9:	48 89 c7             	mov    %rax,%rdi
  8031cc:	48 b8 e4 13 80 00 00 	movabs $0x8013e4,%rax
  8031d3:	00 00 00 
  8031d6:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8031d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031dc:	8b 50 10             	mov    0x10(%rax),%edx
  8031df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031e3:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8031e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8031e8:	c9                   	leaveq 
  8031e9:	c3                   	retq   

00000000008031ea <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8031ea:	55                   	push   %rbp
  8031eb:	48 89 e5             	mov    %rsp,%rbp
  8031ee:	48 83 ec 10          	sub    $0x10,%rsp
  8031f2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8031f5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031f9:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8031fc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803203:	00 00 00 
  803206:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803209:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80320b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80320e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803212:	48 89 c6             	mov    %rax,%rsi
  803215:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80321c:	00 00 00 
  80321f:	48 b8 e4 13 80 00 00 	movabs $0x8013e4,%rax
  803226:	00 00 00 
  803229:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80322b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803232:	00 00 00 
  803235:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803238:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80323b:	bf 02 00 00 00       	mov    $0x2,%edi
  803240:	48 b8 ea 30 80 00 00 	movabs $0x8030ea,%rax
  803247:	00 00 00 
  80324a:	ff d0                	callq  *%rax
}
  80324c:	c9                   	leaveq 
  80324d:	c3                   	retq   

000000000080324e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80324e:	55                   	push   %rbp
  80324f:	48 89 e5             	mov    %rsp,%rbp
  803252:	48 83 ec 10          	sub    $0x10,%rsp
  803256:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803259:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80325c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803263:	00 00 00 
  803266:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803269:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80326b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803272:	00 00 00 
  803275:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803278:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80327b:	bf 03 00 00 00       	mov    $0x3,%edi
  803280:	48 b8 ea 30 80 00 00 	movabs $0x8030ea,%rax
  803287:	00 00 00 
  80328a:	ff d0                	callq  *%rax
}
  80328c:	c9                   	leaveq 
  80328d:	c3                   	retq   

000000000080328e <nsipc_close>:

int
nsipc_close(int s)
{
  80328e:	55                   	push   %rbp
  80328f:	48 89 e5             	mov    %rsp,%rbp
  803292:	48 83 ec 10          	sub    $0x10,%rsp
  803296:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803299:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032a0:	00 00 00 
  8032a3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032a6:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8032a8:	bf 04 00 00 00       	mov    $0x4,%edi
  8032ad:	48 b8 ea 30 80 00 00 	movabs $0x8030ea,%rax
  8032b4:	00 00 00 
  8032b7:	ff d0                	callq  *%rax
}
  8032b9:	c9                   	leaveq 
  8032ba:	c3                   	retq   

00000000008032bb <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8032bb:	55                   	push   %rbp
  8032bc:	48 89 e5             	mov    %rsp,%rbp
  8032bf:	48 83 ec 10          	sub    $0x10,%rsp
  8032c3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032c6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8032ca:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8032cd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032d4:	00 00 00 
  8032d7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032da:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8032dc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e3:	48 89 c6             	mov    %rax,%rsi
  8032e6:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8032ed:	00 00 00 
  8032f0:	48 b8 e4 13 80 00 00 	movabs $0x8013e4,%rax
  8032f7:	00 00 00 
  8032fa:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8032fc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803303:	00 00 00 
  803306:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803309:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80330c:	bf 05 00 00 00       	mov    $0x5,%edi
  803311:	48 b8 ea 30 80 00 00 	movabs $0x8030ea,%rax
  803318:	00 00 00 
  80331b:	ff d0                	callq  *%rax
}
  80331d:	c9                   	leaveq 
  80331e:	c3                   	retq   

000000000080331f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80331f:	55                   	push   %rbp
  803320:	48 89 e5             	mov    %rsp,%rbp
  803323:	48 83 ec 10          	sub    $0x10,%rsp
  803327:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80332a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80332d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803334:	00 00 00 
  803337:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80333a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80333c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803343:	00 00 00 
  803346:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803349:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80334c:	bf 06 00 00 00       	mov    $0x6,%edi
  803351:	48 b8 ea 30 80 00 00 	movabs $0x8030ea,%rax
  803358:	00 00 00 
  80335b:	ff d0                	callq  *%rax
}
  80335d:	c9                   	leaveq 
  80335e:	c3                   	retq   

000000000080335f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80335f:	55                   	push   %rbp
  803360:	48 89 e5             	mov    %rsp,%rbp
  803363:	48 83 ec 30          	sub    $0x30,%rsp
  803367:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80336a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80336e:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803371:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803374:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80337b:	00 00 00 
  80337e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803381:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803383:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80338a:	00 00 00 
  80338d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803390:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803393:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80339a:	00 00 00 
  80339d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8033a0:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8033a3:	bf 07 00 00 00       	mov    $0x7,%edi
  8033a8:	48 b8 ea 30 80 00 00 	movabs $0x8030ea,%rax
  8033af:	00 00 00 
  8033b2:	ff d0                	callq  *%rax
  8033b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033bb:	78 69                	js     803426 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8033bd:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8033c4:	7f 08                	jg     8033ce <nsipc_recv+0x6f>
  8033c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033c9:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8033cc:	7e 35                	jle    803403 <nsipc_recv+0xa4>
  8033ce:	48 b9 57 4d 80 00 00 	movabs $0x804d57,%rcx
  8033d5:	00 00 00 
  8033d8:	48 ba 6c 4d 80 00 00 	movabs $0x804d6c,%rdx
  8033df:	00 00 00 
  8033e2:	be 61 00 00 00       	mov    $0x61,%esi
  8033e7:	48 bf 81 4d 80 00 00 	movabs $0x804d81,%rdi
  8033ee:	00 00 00 
  8033f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f6:	49 b8 b2 3d 80 00 00 	movabs $0x803db2,%r8
  8033fd:	00 00 00 
  803400:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803403:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803406:	48 63 d0             	movslq %eax,%rdx
  803409:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80340d:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803414:	00 00 00 
  803417:	48 89 c7             	mov    %rax,%rdi
  80341a:	48 b8 e4 13 80 00 00 	movabs $0x8013e4,%rax
  803421:	00 00 00 
  803424:	ff d0                	callq  *%rax
	}

	return r;
  803426:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803429:	c9                   	leaveq 
  80342a:	c3                   	retq   

000000000080342b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80342b:	55                   	push   %rbp
  80342c:	48 89 e5             	mov    %rsp,%rbp
  80342f:	48 83 ec 20          	sub    $0x20,%rsp
  803433:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803436:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80343a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80343d:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803440:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803447:	00 00 00 
  80344a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80344d:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80344f:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803456:	7e 35                	jle    80348d <nsipc_send+0x62>
  803458:	48 b9 8d 4d 80 00 00 	movabs $0x804d8d,%rcx
  80345f:	00 00 00 
  803462:	48 ba 6c 4d 80 00 00 	movabs $0x804d6c,%rdx
  803469:	00 00 00 
  80346c:	be 6c 00 00 00       	mov    $0x6c,%esi
  803471:	48 bf 81 4d 80 00 00 	movabs $0x804d81,%rdi
  803478:	00 00 00 
  80347b:	b8 00 00 00 00       	mov    $0x0,%eax
  803480:	49 b8 b2 3d 80 00 00 	movabs $0x803db2,%r8
  803487:	00 00 00 
  80348a:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80348d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803490:	48 63 d0             	movslq %eax,%rdx
  803493:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803497:	48 89 c6             	mov    %rax,%rsi
  80349a:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8034a1:	00 00 00 
  8034a4:	48 b8 e4 13 80 00 00 	movabs $0x8013e4,%rax
  8034ab:	00 00 00 
  8034ae:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8034b0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034b7:	00 00 00 
  8034ba:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034bd:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8034c0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034c7:	00 00 00 
  8034ca:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034cd:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8034d0:	bf 08 00 00 00       	mov    $0x8,%edi
  8034d5:	48 b8 ea 30 80 00 00 	movabs $0x8030ea,%rax
  8034dc:	00 00 00 
  8034df:	ff d0                	callq  *%rax
}
  8034e1:	c9                   	leaveq 
  8034e2:	c3                   	retq   

00000000008034e3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8034e3:	55                   	push   %rbp
  8034e4:	48 89 e5             	mov    %rsp,%rbp
  8034e7:	48 83 ec 10          	sub    $0x10,%rsp
  8034eb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034ee:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8034f1:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8034f4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034fb:	00 00 00 
  8034fe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803501:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803503:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80350a:	00 00 00 
  80350d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803510:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803513:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80351a:	00 00 00 
  80351d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803520:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803523:	bf 09 00 00 00       	mov    $0x9,%edi
  803528:	48 b8 ea 30 80 00 00 	movabs $0x8030ea,%rax
  80352f:	00 00 00 
  803532:	ff d0                	callq  *%rax
}
  803534:	c9                   	leaveq 
  803535:	c3                   	retq   

0000000000803536 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803536:	55                   	push   %rbp
  803537:	48 89 e5             	mov    %rsp,%rbp
  80353a:	53                   	push   %rbx
  80353b:	48 83 ec 38          	sub    $0x38,%rsp
  80353f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803543:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803547:	48 89 c7             	mov    %rax,%rdi
  80354a:	48 b8 74 1d 80 00 00 	movabs $0x801d74,%rax
  803551:	00 00 00 
  803554:	ff d0                	callq  *%rax
  803556:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803559:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80355d:	0f 88 bf 01 00 00    	js     803722 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803563:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803567:	ba 07 04 00 00       	mov    $0x407,%edx
  80356c:	48 89 c6             	mov    %rax,%rsi
  80356f:	bf 00 00 00 00       	mov    $0x0,%edi
  803574:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  80357b:	00 00 00 
  80357e:	ff d0                	callq  *%rax
  803580:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803583:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803587:	0f 88 95 01 00 00    	js     803722 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80358d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803591:	48 89 c7             	mov    %rax,%rdi
  803594:	48 b8 74 1d 80 00 00 	movabs $0x801d74,%rax
  80359b:	00 00 00 
  80359e:	ff d0                	callq  *%rax
  8035a0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035a7:	0f 88 5d 01 00 00    	js     80370a <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035ad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035b1:	ba 07 04 00 00       	mov    $0x407,%edx
  8035b6:	48 89 c6             	mov    %rax,%rsi
  8035b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8035be:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  8035c5:	00 00 00 
  8035c8:	ff d0                	callq  *%rax
  8035ca:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035d1:	0f 88 33 01 00 00    	js     80370a <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8035d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035db:	48 89 c7             	mov    %rax,%rdi
  8035de:	48 b8 49 1d 80 00 00 	movabs $0x801d49,%rax
  8035e5:	00 00 00 
  8035e8:	ff d0                	callq  *%rax
  8035ea:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035f2:	ba 07 04 00 00       	mov    $0x407,%edx
  8035f7:	48 89 c6             	mov    %rax,%rsi
  8035fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8035ff:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  803606:	00 00 00 
  803609:	ff d0                	callq  *%rax
  80360b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80360e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803612:	79 05                	jns    803619 <pipe+0xe3>
		goto err2;
  803614:	e9 d9 00 00 00       	jmpq   8036f2 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803619:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80361d:	48 89 c7             	mov    %rax,%rdi
  803620:	48 b8 49 1d 80 00 00 	movabs $0x801d49,%rax
  803627:	00 00 00 
  80362a:	ff d0                	callq  *%rax
  80362c:	48 89 c2             	mov    %rax,%rdx
  80362f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803633:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803639:	48 89 d1             	mov    %rdx,%rcx
  80363c:	ba 00 00 00 00       	mov    $0x0,%edx
  803641:	48 89 c6             	mov    %rax,%rsi
  803644:	bf 00 00 00 00       	mov    $0x0,%edi
  803649:	48 b8 3f 1a 80 00 00 	movabs $0x801a3f,%rax
  803650:	00 00 00 
  803653:	ff d0                	callq  *%rax
  803655:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803658:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80365c:	79 1b                	jns    803679 <pipe+0x143>
		goto err3;
  80365e:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80365f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803663:	48 89 c6             	mov    %rax,%rsi
  803666:	bf 00 00 00 00       	mov    $0x0,%edi
  80366b:	48 b8 9a 1a 80 00 00 	movabs $0x801a9a,%rax
  803672:	00 00 00 
  803675:	ff d0                	callq  *%rax
  803677:	eb 79                	jmp    8036f2 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803679:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80367d:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803684:	00 00 00 
  803687:	8b 12                	mov    (%rdx),%edx
  803689:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80368b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80368f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803696:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80369a:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8036a1:	00 00 00 
  8036a4:	8b 12                	mov    (%rdx),%edx
  8036a6:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8036a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036ac:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8036b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036b7:	48 89 c7             	mov    %rax,%rdi
  8036ba:	48 b8 26 1d 80 00 00 	movabs $0x801d26,%rax
  8036c1:	00 00 00 
  8036c4:	ff d0                	callq  *%rax
  8036c6:	89 c2                	mov    %eax,%edx
  8036c8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036cc:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8036ce:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036d2:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8036d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036da:	48 89 c7             	mov    %rax,%rdi
  8036dd:	48 b8 26 1d 80 00 00 	movabs $0x801d26,%rax
  8036e4:	00 00 00 
  8036e7:	ff d0                	callq  *%rax
  8036e9:	89 03                	mov    %eax,(%rbx)
	return 0;
  8036eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f0:	eb 33                	jmp    803725 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8036f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036f6:	48 89 c6             	mov    %rax,%rsi
  8036f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8036fe:	48 b8 9a 1a 80 00 00 	movabs $0x801a9a,%rax
  803705:	00 00 00 
  803708:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80370a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80370e:	48 89 c6             	mov    %rax,%rsi
  803711:	bf 00 00 00 00       	mov    $0x0,%edi
  803716:	48 b8 9a 1a 80 00 00 	movabs $0x801a9a,%rax
  80371d:	00 00 00 
  803720:	ff d0                	callq  *%rax
err:
	return r;
  803722:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803725:	48 83 c4 38          	add    $0x38,%rsp
  803729:	5b                   	pop    %rbx
  80372a:	5d                   	pop    %rbp
  80372b:	c3                   	retq   

000000000080372c <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80372c:	55                   	push   %rbp
  80372d:	48 89 e5             	mov    %rsp,%rbp
  803730:	53                   	push   %rbx
  803731:	48 83 ec 28          	sub    $0x28,%rsp
  803735:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803739:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80373d:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803744:	00 00 00 
  803747:	48 8b 00             	mov    (%rax),%rax
  80374a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803750:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803753:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803757:	48 89 c7             	mov    %rax,%rdi
  80375a:	48 b8 b0 40 80 00 00 	movabs $0x8040b0,%rax
  803761:	00 00 00 
  803764:	ff d0                	callq  *%rax
  803766:	89 c3                	mov    %eax,%ebx
  803768:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80376c:	48 89 c7             	mov    %rax,%rdi
  80376f:	48 b8 b0 40 80 00 00 	movabs $0x8040b0,%rax
  803776:	00 00 00 
  803779:	ff d0                	callq  *%rax
  80377b:	39 c3                	cmp    %eax,%ebx
  80377d:	0f 94 c0             	sete   %al
  803780:	0f b6 c0             	movzbl %al,%eax
  803783:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803786:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80378d:	00 00 00 
  803790:	48 8b 00             	mov    (%rax),%rax
  803793:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803799:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80379c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80379f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8037a2:	75 05                	jne    8037a9 <_pipeisclosed+0x7d>
			return ret;
  8037a4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8037a7:	eb 4f                	jmp    8037f8 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8037a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037ac:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8037af:	74 42                	je     8037f3 <_pipeisclosed+0xc7>
  8037b1:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8037b5:	75 3c                	jne    8037f3 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8037b7:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8037be:	00 00 00 
  8037c1:	48 8b 00             	mov    (%rax),%rax
  8037c4:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8037ca:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8037cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037d0:	89 c6                	mov    %eax,%esi
  8037d2:	48 bf 9e 4d 80 00 00 	movabs $0x804d9e,%rdi
  8037d9:	00 00 00 
  8037dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8037e1:	49 b8 0b 05 80 00 00 	movabs $0x80050b,%r8
  8037e8:	00 00 00 
  8037eb:	41 ff d0             	callq  *%r8
	}
  8037ee:	e9 4a ff ff ff       	jmpq   80373d <_pipeisclosed+0x11>
  8037f3:	e9 45 ff ff ff       	jmpq   80373d <_pipeisclosed+0x11>
}
  8037f8:	48 83 c4 28          	add    $0x28,%rsp
  8037fc:	5b                   	pop    %rbx
  8037fd:	5d                   	pop    %rbp
  8037fe:	c3                   	retq   

00000000008037ff <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8037ff:	55                   	push   %rbp
  803800:	48 89 e5             	mov    %rsp,%rbp
  803803:	48 83 ec 30          	sub    $0x30,%rsp
  803807:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80380a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80380e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803811:	48 89 d6             	mov    %rdx,%rsi
  803814:	89 c7                	mov    %eax,%edi
  803816:	48 b8 0c 1e 80 00 00 	movabs $0x801e0c,%rax
  80381d:	00 00 00 
  803820:	ff d0                	callq  *%rax
  803822:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803825:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803829:	79 05                	jns    803830 <pipeisclosed+0x31>
		return r;
  80382b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80382e:	eb 31                	jmp    803861 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803830:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803834:	48 89 c7             	mov    %rax,%rdi
  803837:	48 b8 49 1d 80 00 00 	movabs $0x801d49,%rax
  80383e:	00 00 00 
  803841:	ff d0                	callq  *%rax
  803843:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803847:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80384b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80384f:	48 89 d6             	mov    %rdx,%rsi
  803852:	48 89 c7             	mov    %rax,%rdi
  803855:	48 b8 2c 37 80 00 00 	movabs $0x80372c,%rax
  80385c:	00 00 00 
  80385f:	ff d0                	callq  *%rax
}
  803861:	c9                   	leaveq 
  803862:	c3                   	retq   

0000000000803863 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803863:	55                   	push   %rbp
  803864:	48 89 e5             	mov    %rsp,%rbp
  803867:	48 83 ec 40          	sub    $0x40,%rsp
  80386b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80386f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803873:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803877:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80387b:	48 89 c7             	mov    %rax,%rdi
  80387e:	48 b8 49 1d 80 00 00 	movabs $0x801d49,%rax
  803885:	00 00 00 
  803888:	ff d0                	callq  *%rax
  80388a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80388e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803892:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803896:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80389d:	00 
  80389e:	e9 92 00 00 00       	jmpq   803935 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8038a3:	eb 41                	jmp    8038e6 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8038a5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8038aa:	74 09                	je     8038b5 <devpipe_read+0x52>
				return i;
  8038ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038b0:	e9 92 00 00 00       	jmpq   803947 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8038b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038bd:	48 89 d6             	mov    %rdx,%rsi
  8038c0:	48 89 c7             	mov    %rax,%rdi
  8038c3:	48 b8 2c 37 80 00 00 	movabs $0x80372c,%rax
  8038ca:	00 00 00 
  8038cd:	ff d0                	callq  *%rax
  8038cf:	85 c0                	test   %eax,%eax
  8038d1:	74 07                	je     8038da <devpipe_read+0x77>
				return 0;
  8038d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8038d8:	eb 6d                	jmp    803947 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8038da:	48 b8 b1 19 80 00 00 	movabs $0x8019b1,%rax
  8038e1:	00 00 00 
  8038e4:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8038e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ea:	8b 10                	mov    (%rax),%edx
  8038ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038f0:	8b 40 04             	mov    0x4(%rax),%eax
  8038f3:	39 c2                	cmp    %eax,%edx
  8038f5:	74 ae                	je     8038a5 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8038f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8038ff:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803903:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803907:	8b 00                	mov    (%rax),%eax
  803909:	99                   	cltd   
  80390a:	c1 ea 1b             	shr    $0x1b,%edx
  80390d:	01 d0                	add    %edx,%eax
  80390f:	83 e0 1f             	and    $0x1f,%eax
  803912:	29 d0                	sub    %edx,%eax
  803914:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803918:	48 98                	cltq   
  80391a:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80391f:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803921:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803925:	8b 00                	mov    (%rax),%eax
  803927:	8d 50 01             	lea    0x1(%rax),%edx
  80392a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80392e:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803930:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803935:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803939:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80393d:	0f 82 60 ff ff ff    	jb     8038a3 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803943:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803947:	c9                   	leaveq 
  803948:	c3                   	retq   

0000000000803949 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803949:	55                   	push   %rbp
  80394a:	48 89 e5             	mov    %rsp,%rbp
  80394d:	48 83 ec 40          	sub    $0x40,%rsp
  803951:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803955:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803959:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80395d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803961:	48 89 c7             	mov    %rax,%rdi
  803964:	48 b8 49 1d 80 00 00 	movabs $0x801d49,%rax
  80396b:	00 00 00 
  80396e:	ff d0                	callq  *%rax
  803970:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803974:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803978:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80397c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803983:	00 
  803984:	e9 8e 00 00 00       	jmpq   803a17 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803989:	eb 31                	jmp    8039bc <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80398b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80398f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803993:	48 89 d6             	mov    %rdx,%rsi
  803996:	48 89 c7             	mov    %rax,%rdi
  803999:	48 b8 2c 37 80 00 00 	movabs $0x80372c,%rax
  8039a0:	00 00 00 
  8039a3:	ff d0                	callq  *%rax
  8039a5:	85 c0                	test   %eax,%eax
  8039a7:	74 07                	je     8039b0 <devpipe_write+0x67>
				return 0;
  8039a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8039ae:	eb 79                	jmp    803a29 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8039b0:	48 b8 b1 19 80 00 00 	movabs $0x8019b1,%rax
  8039b7:	00 00 00 
  8039ba:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8039bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039c0:	8b 40 04             	mov    0x4(%rax),%eax
  8039c3:	48 63 d0             	movslq %eax,%rdx
  8039c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ca:	8b 00                	mov    (%rax),%eax
  8039cc:	48 98                	cltq   
  8039ce:	48 83 c0 20          	add    $0x20,%rax
  8039d2:	48 39 c2             	cmp    %rax,%rdx
  8039d5:	73 b4                	jae    80398b <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8039d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039db:	8b 40 04             	mov    0x4(%rax),%eax
  8039de:	99                   	cltd   
  8039df:	c1 ea 1b             	shr    $0x1b,%edx
  8039e2:	01 d0                	add    %edx,%eax
  8039e4:	83 e0 1f             	and    $0x1f,%eax
  8039e7:	29 d0                	sub    %edx,%eax
  8039e9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8039ed:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8039f1:	48 01 ca             	add    %rcx,%rdx
  8039f4:	0f b6 0a             	movzbl (%rdx),%ecx
  8039f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039fb:	48 98                	cltq   
  8039fd:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803a01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a05:	8b 40 04             	mov    0x4(%rax),%eax
  803a08:	8d 50 01             	lea    0x1(%rax),%edx
  803a0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a0f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a12:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a1b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a1f:	0f 82 64 ff ff ff    	jb     803989 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803a25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a29:	c9                   	leaveq 
  803a2a:	c3                   	retq   

0000000000803a2b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803a2b:	55                   	push   %rbp
  803a2c:	48 89 e5             	mov    %rsp,%rbp
  803a2f:	48 83 ec 20          	sub    $0x20,%rsp
  803a33:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a37:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803a3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a3f:	48 89 c7             	mov    %rax,%rdi
  803a42:	48 b8 49 1d 80 00 00 	movabs $0x801d49,%rax
  803a49:	00 00 00 
  803a4c:	ff d0                	callq  *%rax
  803a4e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803a52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a56:	48 be b1 4d 80 00 00 	movabs $0x804db1,%rsi
  803a5d:	00 00 00 
  803a60:	48 89 c7             	mov    %rax,%rdi
  803a63:	48 b8 c0 10 80 00 00 	movabs $0x8010c0,%rax
  803a6a:	00 00 00 
  803a6d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803a6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a73:	8b 50 04             	mov    0x4(%rax),%edx
  803a76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a7a:	8b 00                	mov    (%rax),%eax
  803a7c:	29 c2                	sub    %eax,%edx
  803a7e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a82:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803a88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a8c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803a93:	00 00 00 
	stat->st_dev = &devpipe;
  803a96:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a9a:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803aa1:	00 00 00 
  803aa4:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803aab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ab0:	c9                   	leaveq 
  803ab1:	c3                   	retq   

0000000000803ab2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803ab2:	55                   	push   %rbp
  803ab3:	48 89 e5             	mov    %rsp,%rbp
  803ab6:	48 83 ec 10          	sub    $0x10,%rsp
  803aba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803abe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ac2:	48 89 c6             	mov    %rax,%rsi
  803ac5:	bf 00 00 00 00       	mov    $0x0,%edi
  803aca:	48 b8 9a 1a 80 00 00 	movabs $0x801a9a,%rax
  803ad1:	00 00 00 
  803ad4:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803ad6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ada:	48 89 c7             	mov    %rax,%rdi
  803add:	48 b8 49 1d 80 00 00 	movabs $0x801d49,%rax
  803ae4:	00 00 00 
  803ae7:	ff d0                	callq  *%rax
  803ae9:	48 89 c6             	mov    %rax,%rsi
  803aec:	bf 00 00 00 00       	mov    $0x0,%edi
  803af1:	48 b8 9a 1a 80 00 00 	movabs $0x801a9a,%rax
  803af8:	00 00 00 
  803afb:	ff d0                	callq  *%rax
}
  803afd:	c9                   	leaveq 
  803afe:	c3                   	retq   

0000000000803aff <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803aff:	55                   	push   %rbp
  803b00:	48 89 e5             	mov    %rsp,%rbp
  803b03:	48 83 ec 20          	sub    $0x20,%rsp
  803b07:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803b0a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b0d:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803b10:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803b14:	be 01 00 00 00       	mov    $0x1,%esi
  803b19:	48 89 c7             	mov    %rax,%rdi
  803b1c:	48 b8 a7 18 80 00 00 	movabs $0x8018a7,%rax
  803b23:	00 00 00 
  803b26:	ff d0                	callq  *%rax
}
  803b28:	c9                   	leaveq 
  803b29:	c3                   	retq   

0000000000803b2a <getchar>:

int
getchar(void)
{
  803b2a:	55                   	push   %rbp
  803b2b:	48 89 e5             	mov    %rsp,%rbp
  803b2e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803b32:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803b36:	ba 01 00 00 00       	mov    $0x1,%edx
  803b3b:	48 89 c6             	mov    %rax,%rsi
  803b3e:	bf 00 00 00 00       	mov    $0x0,%edi
  803b43:	48 b8 3e 22 80 00 00 	movabs $0x80223e,%rax
  803b4a:	00 00 00 
  803b4d:	ff d0                	callq  *%rax
  803b4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803b52:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b56:	79 05                	jns    803b5d <getchar+0x33>
		return r;
  803b58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b5b:	eb 14                	jmp    803b71 <getchar+0x47>
	if (r < 1)
  803b5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b61:	7f 07                	jg     803b6a <getchar+0x40>
		return -E_EOF;
  803b63:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803b68:	eb 07                	jmp    803b71 <getchar+0x47>
	return c;
  803b6a:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803b6e:	0f b6 c0             	movzbl %al,%eax
}
  803b71:	c9                   	leaveq 
  803b72:	c3                   	retq   

0000000000803b73 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803b73:	55                   	push   %rbp
  803b74:	48 89 e5             	mov    %rsp,%rbp
  803b77:	48 83 ec 20          	sub    $0x20,%rsp
  803b7b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b7e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b82:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b85:	48 89 d6             	mov    %rdx,%rsi
  803b88:	89 c7                	mov    %eax,%edi
  803b8a:	48 b8 0c 1e 80 00 00 	movabs $0x801e0c,%rax
  803b91:	00 00 00 
  803b94:	ff d0                	callq  *%rax
  803b96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b9d:	79 05                	jns    803ba4 <iscons+0x31>
		return r;
  803b9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ba2:	eb 1a                	jmp    803bbe <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803ba4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba8:	8b 10                	mov    (%rax),%edx
  803baa:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803bb1:	00 00 00 
  803bb4:	8b 00                	mov    (%rax),%eax
  803bb6:	39 c2                	cmp    %eax,%edx
  803bb8:	0f 94 c0             	sete   %al
  803bbb:	0f b6 c0             	movzbl %al,%eax
}
  803bbe:	c9                   	leaveq 
  803bbf:	c3                   	retq   

0000000000803bc0 <opencons>:

int
opencons(void)
{
  803bc0:	55                   	push   %rbp
  803bc1:	48 89 e5             	mov    %rsp,%rbp
  803bc4:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803bc8:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803bcc:	48 89 c7             	mov    %rax,%rdi
  803bcf:	48 b8 74 1d 80 00 00 	movabs $0x801d74,%rax
  803bd6:	00 00 00 
  803bd9:	ff d0                	callq  *%rax
  803bdb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bde:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803be2:	79 05                	jns    803be9 <opencons+0x29>
		return r;
  803be4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803be7:	eb 5b                	jmp    803c44 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803be9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bed:	ba 07 04 00 00       	mov    $0x407,%edx
  803bf2:	48 89 c6             	mov    %rax,%rsi
  803bf5:	bf 00 00 00 00       	mov    $0x0,%edi
  803bfa:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  803c01:	00 00 00 
  803c04:	ff d0                	callq  *%rax
  803c06:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c0d:	79 05                	jns    803c14 <opencons+0x54>
		return r;
  803c0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c12:	eb 30                	jmp    803c44 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803c14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c18:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803c1f:	00 00 00 
  803c22:	8b 12                	mov    (%rdx),%edx
  803c24:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803c26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c2a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803c31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c35:	48 89 c7             	mov    %rax,%rdi
  803c38:	48 b8 26 1d 80 00 00 	movabs $0x801d26,%rax
  803c3f:	00 00 00 
  803c42:	ff d0                	callq  *%rax
}
  803c44:	c9                   	leaveq 
  803c45:	c3                   	retq   

0000000000803c46 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803c46:	55                   	push   %rbp
  803c47:	48 89 e5             	mov    %rsp,%rbp
  803c4a:	48 83 ec 30          	sub    $0x30,%rsp
  803c4e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c52:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c56:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803c5a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c5f:	75 07                	jne    803c68 <devcons_read+0x22>
		return 0;
  803c61:	b8 00 00 00 00       	mov    $0x0,%eax
  803c66:	eb 4b                	jmp    803cb3 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803c68:	eb 0c                	jmp    803c76 <devcons_read+0x30>
		sys_yield();
  803c6a:	48 b8 b1 19 80 00 00 	movabs $0x8019b1,%rax
  803c71:	00 00 00 
  803c74:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803c76:	48 b8 f1 18 80 00 00 	movabs $0x8018f1,%rax
  803c7d:	00 00 00 
  803c80:	ff d0                	callq  *%rax
  803c82:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c85:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c89:	74 df                	je     803c6a <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803c8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c8f:	79 05                	jns    803c96 <devcons_read+0x50>
		return c;
  803c91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c94:	eb 1d                	jmp    803cb3 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803c96:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803c9a:	75 07                	jne    803ca3 <devcons_read+0x5d>
		return 0;
  803c9c:	b8 00 00 00 00       	mov    $0x0,%eax
  803ca1:	eb 10                	jmp    803cb3 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803ca3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ca6:	89 c2                	mov    %eax,%edx
  803ca8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cac:	88 10                	mov    %dl,(%rax)
	return 1;
  803cae:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803cb3:	c9                   	leaveq 
  803cb4:	c3                   	retq   

0000000000803cb5 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803cb5:	55                   	push   %rbp
  803cb6:	48 89 e5             	mov    %rsp,%rbp
  803cb9:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803cc0:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803cc7:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803cce:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803cd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803cdc:	eb 76                	jmp    803d54 <devcons_write+0x9f>
		m = n - tot;
  803cde:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803ce5:	89 c2                	mov    %eax,%edx
  803ce7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cea:	29 c2                	sub    %eax,%edx
  803cec:	89 d0                	mov    %edx,%eax
  803cee:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803cf1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cf4:	83 f8 7f             	cmp    $0x7f,%eax
  803cf7:	76 07                	jbe    803d00 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803cf9:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803d00:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d03:	48 63 d0             	movslq %eax,%rdx
  803d06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d09:	48 63 c8             	movslq %eax,%rcx
  803d0c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803d13:	48 01 c1             	add    %rax,%rcx
  803d16:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d1d:	48 89 ce             	mov    %rcx,%rsi
  803d20:	48 89 c7             	mov    %rax,%rdi
  803d23:	48 b8 e4 13 80 00 00 	movabs $0x8013e4,%rax
  803d2a:	00 00 00 
  803d2d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803d2f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d32:	48 63 d0             	movslq %eax,%rdx
  803d35:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d3c:	48 89 d6             	mov    %rdx,%rsi
  803d3f:	48 89 c7             	mov    %rax,%rdi
  803d42:	48 b8 a7 18 80 00 00 	movabs $0x8018a7,%rax
  803d49:	00 00 00 
  803d4c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d4e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d51:	01 45 fc             	add    %eax,-0x4(%rbp)
  803d54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d57:	48 98                	cltq   
  803d59:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803d60:	0f 82 78 ff ff ff    	jb     803cde <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803d66:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d69:	c9                   	leaveq 
  803d6a:	c3                   	retq   

0000000000803d6b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803d6b:	55                   	push   %rbp
  803d6c:	48 89 e5             	mov    %rsp,%rbp
  803d6f:	48 83 ec 08          	sub    $0x8,%rsp
  803d73:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803d77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d7c:	c9                   	leaveq 
  803d7d:	c3                   	retq   

0000000000803d7e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803d7e:	55                   	push   %rbp
  803d7f:	48 89 e5             	mov    %rsp,%rbp
  803d82:	48 83 ec 10          	sub    $0x10,%rsp
  803d86:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d8a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803d8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d92:	48 be bd 4d 80 00 00 	movabs $0x804dbd,%rsi
  803d99:	00 00 00 
  803d9c:	48 89 c7             	mov    %rax,%rdi
  803d9f:	48 b8 c0 10 80 00 00 	movabs $0x8010c0,%rax
  803da6:	00 00 00 
  803da9:	ff d0                	callq  *%rax
	return 0;
  803dab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803db0:	c9                   	leaveq 
  803db1:	c3                   	retq   

0000000000803db2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803db2:	55                   	push   %rbp
  803db3:	48 89 e5             	mov    %rsp,%rbp
  803db6:	53                   	push   %rbx
  803db7:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803dbe:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803dc5:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803dcb:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803dd2:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803dd9:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803de0:	84 c0                	test   %al,%al
  803de2:	74 23                	je     803e07 <_panic+0x55>
  803de4:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803deb:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803def:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803df3:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803df7:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803dfb:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803dff:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803e03:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803e07:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803e0e:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803e15:	00 00 00 
  803e18:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803e1f:	00 00 00 
  803e22:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803e26:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803e2d:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803e34:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803e3b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803e42:	00 00 00 
  803e45:	48 8b 18             	mov    (%rax),%rbx
  803e48:	48 b8 73 19 80 00 00 	movabs $0x801973,%rax
  803e4f:	00 00 00 
  803e52:	ff d0                	callq  *%rax
  803e54:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803e5a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803e61:	41 89 c8             	mov    %ecx,%r8d
  803e64:	48 89 d1             	mov    %rdx,%rcx
  803e67:	48 89 da             	mov    %rbx,%rdx
  803e6a:	89 c6                	mov    %eax,%esi
  803e6c:	48 bf c8 4d 80 00 00 	movabs $0x804dc8,%rdi
  803e73:	00 00 00 
  803e76:	b8 00 00 00 00       	mov    $0x0,%eax
  803e7b:	49 b9 0b 05 80 00 00 	movabs $0x80050b,%r9
  803e82:	00 00 00 
  803e85:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803e88:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803e8f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803e96:	48 89 d6             	mov    %rdx,%rsi
  803e99:	48 89 c7             	mov    %rax,%rdi
  803e9c:	48 b8 5f 04 80 00 00 	movabs $0x80045f,%rax
  803ea3:	00 00 00 
  803ea6:	ff d0                	callq  *%rax
	cprintf("\n");
  803ea8:	48 bf eb 4d 80 00 00 	movabs $0x804deb,%rdi
  803eaf:	00 00 00 
  803eb2:	b8 00 00 00 00       	mov    $0x0,%eax
  803eb7:	48 ba 0b 05 80 00 00 	movabs $0x80050b,%rdx
  803ebe:	00 00 00 
  803ec1:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803ec3:	cc                   	int3   
  803ec4:	eb fd                	jmp    803ec3 <_panic+0x111>

0000000000803ec6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803ec6:	55                   	push   %rbp
  803ec7:	48 89 e5             	mov    %rsp,%rbp
  803eca:	48 83 ec 30          	sub    $0x30,%rsp
  803ece:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ed2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ed6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803eda:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803ee1:	00 00 00 
  803ee4:	48 8b 00             	mov    (%rax),%rax
  803ee7:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803eed:	85 c0                	test   %eax,%eax
  803eef:	75 3c                	jne    803f2d <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803ef1:	48 b8 73 19 80 00 00 	movabs $0x801973,%rax
  803ef8:	00 00 00 
  803efb:	ff d0                	callq  *%rax
  803efd:	25 ff 03 00 00       	and    $0x3ff,%eax
  803f02:	48 63 d0             	movslq %eax,%rdx
  803f05:	48 89 d0             	mov    %rdx,%rax
  803f08:	48 c1 e0 03          	shl    $0x3,%rax
  803f0c:	48 01 d0             	add    %rdx,%rax
  803f0f:	48 c1 e0 05          	shl    $0x5,%rax
  803f13:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803f1a:	00 00 00 
  803f1d:	48 01 c2             	add    %rax,%rdx
  803f20:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803f27:	00 00 00 
  803f2a:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803f2d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f32:	75 0e                	jne    803f42 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803f34:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f3b:	00 00 00 
  803f3e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803f42:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f46:	48 89 c7             	mov    %rax,%rdi
  803f49:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  803f50:	00 00 00 
  803f53:	ff d0                	callq  *%rax
  803f55:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803f58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f5c:	79 19                	jns    803f77 <ipc_recv+0xb1>
		*from_env_store = 0;
  803f5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f62:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803f68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f6c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803f72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f75:	eb 53                	jmp    803fca <ipc_recv+0x104>
	}
	if(from_env_store)
  803f77:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803f7c:	74 19                	je     803f97 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803f7e:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803f85:	00 00 00 
  803f88:	48 8b 00             	mov    (%rax),%rax
  803f8b:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803f91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f95:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803f97:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f9c:	74 19                	je     803fb7 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803f9e:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803fa5:	00 00 00 
  803fa8:	48 8b 00             	mov    (%rax),%rax
  803fab:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803fb1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fb5:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803fb7:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803fbe:	00 00 00 
  803fc1:	48 8b 00             	mov    (%rax),%rax
  803fc4:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803fca:	c9                   	leaveq 
  803fcb:	c3                   	retq   

0000000000803fcc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803fcc:	55                   	push   %rbp
  803fcd:	48 89 e5             	mov    %rsp,%rbp
  803fd0:	48 83 ec 30          	sub    $0x30,%rsp
  803fd4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803fd7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803fda:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803fde:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803fe1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803fe6:	75 0e                	jne    803ff6 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803fe8:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803fef:	00 00 00 
  803ff2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803ff6:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803ff9:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803ffc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804000:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804003:	89 c7                	mov    %eax,%edi
  804005:	48 b8 c3 1b 80 00 00 	movabs $0x801bc3,%rax
  80400c:	00 00 00 
  80400f:	ff d0                	callq  *%rax
  804011:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804014:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804018:	75 0c                	jne    804026 <ipc_send+0x5a>
			sys_yield();
  80401a:	48 b8 b1 19 80 00 00 	movabs $0x8019b1,%rax
  804021:	00 00 00 
  804024:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804026:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80402a:	74 ca                	je     803ff6 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  80402c:	c9                   	leaveq 
  80402d:	c3                   	retq   

000000000080402e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80402e:	55                   	push   %rbp
  80402f:	48 89 e5             	mov    %rsp,%rbp
  804032:	48 83 ec 14          	sub    $0x14,%rsp
  804036:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804040:	eb 5e                	jmp    8040a0 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804042:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804049:	00 00 00 
  80404c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80404f:	48 63 d0             	movslq %eax,%rdx
  804052:	48 89 d0             	mov    %rdx,%rax
  804055:	48 c1 e0 03          	shl    $0x3,%rax
  804059:	48 01 d0             	add    %rdx,%rax
  80405c:	48 c1 e0 05          	shl    $0x5,%rax
  804060:	48 01 c8             	add    %rcx,%rax
  804063:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804069:	8b 00                	mov    (%rax),%eax
  80406b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80406e:	75 2c                	jne    80409c <ipc_find_env+0x6e>
			return envs[i].env_id;
  804070:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804077:	00 00 00 
  80407a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80407d:	48 63 d0             	movslq %eax,%rdx
  804080:	48 89 d0             	mov    %rdx,%rax
  804083:	48 c1 e0 03          	shl    $0x3,%rax
  804087:	48 01 d0             	add    %rdx,%rax
  80408a:	48 c1 e0 05          	shl    $0x5,%rax
  80408e:	48 01 c8             	add    %rcx,%rax
  804091:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804097:	8b 40 08             	mov    0x8(%rax),%eax
  80409a:	eb 12                	jmp    8040ae <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80409c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8040a0:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8040a7:	7e 99                	jle    804042 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8040a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040ae:	c9                   	leaveq 
  8040af:	c3                   	retq   

00000000008040b0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8040b0:	55                   	push   %rbp
  8040b1:	48 89 e5             	mov    %rsp,%rbp
  8040b4:	48 83 ec 18          	sub    $0x18,%rsp
  8040b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8040bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040c0:	48 c1 e8 15          	shr    $0x15,%rax
  8040c4:	48 89 c2             	mov    %rax,%rdx
  8040c7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8040ce:	01 00 00 
  8040d1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040d5:	83 e0 01             	and    $0x1,%eax
  8040d8:	48 85 c0             	test   %rax,%rax
  8040db:	75 07                	jne    8040e4 <pageref+0x34>
		return 0;
  8040dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8040e2:	eb 53                	jmp    804137 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8040e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040e8:	48 c1 e8 0c          	shr    $0xc,%rax
  8040ec:	48 89 c2             	mov    %rax,%rdx
  8040ef:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8040f6:	01 00 00 
  8040f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804101:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804105:	83 e0 01             	and    $0x1,%eax
  804108:	48 85 c0             	test   %rax,%rax
  80410b:	75 07                	jne    804114 <pageref+0x64>
		return 0;
  80410d:	b8 00 00 00 00       	mov    $0x0,%eax
  804112:	eb 23                	jmp    804137 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804114:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804118:	48 c1 e8 0c          	shr    $0xc,%rax
  80411c:	48 89 c2             	mov    %rax,%rdx
  80411f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804126:	00 00 00 
  804129:	48 c1 e2 04          	shl    $0x4,%rdx
  80412d:	48 01 d0             	add    %rdx,%rax
  804130:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804134:	0f b7 c0             	movzwl %ax,%eax
}
  804137:	c9                   	leaveq 
  804138:	c3                   	retq   

0000000000804139 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  804139:	55                   	push   %rbp
  80413a:	48 89 e5             	mov    %rsp,%rbp
  80413d:	48 83 ec 20          	sub    $0x20,%rsp
  804141:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  804145:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804149:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80414d:	48 89 d6             	mov    %rdx,%rsi
  804150:	48 89 c7             	mov    %rax,%rdi
  804153:	48 b8 6f 41 80 00 00 	movabs $0x80416f,%rax
  80415a:	00 00 00 
  80415d:	ff d0                	callq  *%rax
  80415f:	85 c0                	test   %eax,%eax
  804161:	74 05                	je     804168 <inet_addr+0x2f>
    return (val.s_addr);
  804163:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804166:	eb 05                	jmp    80416d <inet_addr+0x34>
  }
  return (INADDR_NONE);
  804168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  80416d:	c9                   	leaveq 
  80416e:	c3                   	retq   

000000000080416f <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  80416f:	55                   	push   %rbp
  804170:	48 89 e5             	mov    %rsp,%rbp
  804173:	48 83 ec 40          	sub    $0x40,%rsp
  804177:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80417b:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  80417f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804183:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  c = *cp;
  804187:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80418b:	0f b6 00             	movzbl (%rax),%eax
  80418e:	0f be c0             	movsbl %al,%eax
  804191:	89 45 f4             	mov    %eax,-0xc(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  804194:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804197:	3c 2f                	cmp    $0x2f,%al
  804199:	76 07                	jbe    8041a2 <inet_aton+0x33>
  80419b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80419e:	3c 39                	cmp    $0x39,%al
  8041a0:	76 0a                	jbe    8041ac <inet_aton+0x3d>
      return (0);
  8041a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8041a7:	e9 68 02 00 00       	jmpq   804414 <inet_aton+0x2a5>
    val = 0;
  8041ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    base = 10;
  8041b3:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    if (c == '0') {
  8041ba:	83 7d f4 30          	cmpl   $0x30,-0xc(%rbp)
  8041be:	75 40                	jne    804200 <inet_aton+0x91>
      c = *++cp;
  8041c0:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8041c5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041c9:	0f b6 00             	movzbl (%rax),%eax
  8041cc:	0f be c0             	movsbl %al,%eax
  8041cf:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if (c == 'x' || c == 'X') {
  8041d2:	83 7d f4 78          	cmpl   $0x78,-0xc(%rbp)
  8041d6:	74 06                	je     8041de <inet_aton+0x6f>
  8041d8:	83 7d f4 58          	cmpl   $0x58,-0xc(%rbp)
  8041dc:	75 1b                	jne    8041f9 <inet_aton+0x8a>
        base = 16;
  8041de:	c7 45 f8 10 00 00 00 	movl   $0x10,-0x8(%rbp)
        c = *++cp;
  8041e5:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8041ea:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041ee:	0f b6 00             	movzbl (%rax),%eax
  8041f1:	0f be c0             	movsbl %al,%eax
  8041f4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8041f7:	eb 07                	jmp    804200 <inet_aton+0x91>
      } else
        base = 8;
  8041f9:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  804200:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804203:	3c 2f                	cmp    $0x2f,%al
  804205:	76 2f                	jbe    804236 <inet_aton+0xc7>
  804207:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80420a:	3c 39                	cmp    $0x39,%al
  80420c:	77 28                	ja     804236 <inet_aton+0xc7>
        val = (val * base) + (int)(c - '0');
  80420e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804211:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  804215:	89 c2                	mov    %eax,%edx
  804217:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80421a:	01 d0                	add    %edx,%eax
  80421c:	83 e8 30             	sub    $0x30,%eax
  80421f:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  804222:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804227:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80422b:	0f b6 00             	movzbl (%rax),%eax
  80422e:	0f be c0             	movsbl %al,%eax
  804231:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else if (base == 16 && isxdigit(c)) {
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
  804234:	eb ca                	jmp    804200 <inet_aton+0x91>
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  804236:	83 7d f8 10          	cmpl   $0x10,-0x8(%rbp)
  80423a:	75 72                	jne    8042ae <inet_aton+0x13f>
  80423c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80423f:	3c 2f                	cmp    $0x2f,%al
  804241:	76 07                	jbe    80424a <inet_aton+0xdb>
  804243:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804246:	3c 39                	cmp    $0x39,%al
  804248:	76 1c                	jbe    804266 <inet_aton+0xf7>
  80424a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80424d:	3c 60                	cmp    $0x60,%al
  80424f:	76 07                	jbe    804258 <inet_aton+0xe9>
  804251:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804254:	3c 66                	cmp    $0x66,%al
  804256:	76 0e                	jbe    804266 <inet_aton+0xf7>
  804258:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80425b:	3c 40                	cmp    $0x40,%al
  80425d:	76 4f                	jbe    8042ae <inet_aton+0x13f>
  80425f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804262:	3c 46                	cmp    $0x46,%al
  804264:	77 48                	ja     8042ae <inet_aton+0x13f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  804266:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804269:	c1 e0 04             	shl    $0x4,%eax
  80426c:	89 c2                	mov    %eax,%edx
  80426e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804271:	8d 48 0a             	lea    0xa(%rax),%ecx
  804274:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804277:	3c 60                	cmp    $0x60,%al
  804279:	76 0e                	jbe    804289 <inet_aton+0x11a>
  80427b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80427e:	3c 7a                	cmp    $0x7a,%al
  804280:	77 07                	ja     804289 <inet_aton+0x11a>
  804282:	b8 61 00 00 00       	mov    $0x61,%eax
  804287:	eb 05                	jmp    80428e <inet_aton+0x11f>
  804289:	b8 41 00 00 00       	mov    $0x41,%eax
  80428e:	29 c1                	sub    %eax,%ecx
  804290:	89 c8                	mov    %ecx,%eax
  804292:	09 d0                	or     %edx,%eax
  804294:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  804297:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  80429c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8042a0:	0f b6 00             	movzbl (%rax),%eax
  8042a3:	0f be c0             	movsbl %al,%eax
  8042a6:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else
        break;
    }
  8042a9:	e9 52 ff ff ff       	jmpq   804200 <inet_aton+0x91>
    if (c == '.') {
  8042ae:	83 7d f4 2e          	cmpl   $0x2e,-0xc(%rbp)
  8042b2:	75 40                	jne    8042f4 <inet_aton+0x185>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  8042b4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8042b8:	48 83 c0 0c          	add    $0xc,%rax
  8042bc:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  8042c0:	72 0a                	jb     8042cc <inet_aton+0x15d>
        return (0);
  8042c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8042c7:	e9 48 01 00 00       	jmpq   804414 <inet_aton+0x2a5>
      *pp++ = val;
  8042cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042d0:	48 8d 50 04          	lea    0x4(%rax),%rdx
  8042d4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8042d8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8042db:	89 10                	mov    %edx,(%rax)
      c = *++cp;
  8042dd:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8042e2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8042e6:	0f b6 00             	movzbl (%rax),%eax
  8042e9:	0f be c0             	movsbl %al,%eax
  8042ec:	89 45 f4             	mov    %eax,-0xc(%rbp)
    } else
      break;
  }
  8042ef:	e9 a0 fe ff ff       	jmpq   804194 <inet_aton+0x25>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  8042f4:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8042f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8042f9:	74 3c                	je     804337 <inet_aton+0x1c8>
  8042fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8042fe:	3c 1f                	cmp    $0x1f,%al
  804300:	76 2b                	jbe    80432d <inet_aton+0x1be>
  804302:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804305:	84 c0                	test   %al,%al
  804307:	78 24                	js     80432d <inet_aton+0x1be>
  804309:	83 7d f4 20          	cmpl   $0x20,-0xc(%rbp)
  80430d:	74 28                	je     804337 <inet_aton+0x1c8>
  80430f:	83 7d f4 0c          	cmpl   $0xc,-0xc(%rbp)
  804313:	74 22                	je     804337 <inet_aton+0x1c8>
  804315:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  804319:	74 1c                	je     804337 <inet_aton+0x1c8>
  80431b:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  80431f:	74 16                	je     804337 <inet_aton+0x1c8>
  804321:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  804325:	74 10                	je     804337 <inet_aton+0x1c8>
  804327:	83 7d f4 0b          	cmpl   $0xb,-0xc(%rbp)
  80432b:	74 0a                	je     804337 <inet_aton+0x1c8>
    return (0);
  80432d:	b8 00 00 00 00       	mov    $0x0,%eax
  804332:	e9 dd 00 00 00       	jmpq   804414 <inet_aton+0x2a5>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  804337:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80433b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80433f:	48 29 c2             	sub    %rax,%rdx
  804342:	48 89 d0             	mov    %rdx,%rax
  804345:	48 c1 f8 02          	sar    $0x2,%rax
  804349:	83 c0 01             	add    $0x1,%eax
  80434c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  switch (n) {
  80434f:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  804353:	0f 87 98 00 00 00    	ja     8043f1 <inet_aton+0x282>
  804359:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80435c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804363:	00 
  804364:	48 b8 f0 4d 80 00 00 	movabs $0x804df0,%rax
  80436b:	00 00 00 
  80436e:	48 01 d0             	add    %rdx,%rax
  804371:	48 8b 00             	mov    (%rax),%rax
  804374:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  804376:	b8 00 00 00 00       	mov    $0x0,%eax
  80437b:	e9 94 00 00 00       	jmpq   804414 <inet_aton+0x2a5>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  804380:	81 7d fc ff ff ff 00 	cmpl   $0xffffff,-0x4(%rbp)
  804387:	76 0a                	jbe    804393 <inet_aton+0x224>
      return (0);
  804389:	b8 00 00 00 00       	mov    $0x0,%eax
  80438e:	e9 81 00 00 00       	jmpq   804414 <inet_aton+0x2a5>
    val |= parts[0] << 24;
  804393:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804396:	c1 e0 18             	shl    $0x18,%eax
  804399:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80439c:	eb 53                	jmp    8043f1 <inet_aton+0x282>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  80439e:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%rbp)
  8043a5:	76 07                	jbe    8043ae <inet_aton+0x23f>
      return (0);
  8043a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8043ac:	eb 66                	jmp    804414 <inet_aton+0x2a5>
    val |= (parts[0] << 24) | (parts[1] << 16);
  8043ae:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8043b1:	c1 e0 18             	shl    $0x18,%eax
  8043b4:	89 c2                	mov    %eax,%edx
  8043b6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8043b9:	c1 e0 10             	shl    $0x10,%eax
  8043bc:	09 d0                	or     %edx,%eax
  8043be:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8043c1:	eb 2e                	jmp    8043f1 <inet_aton+0x282>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  8043c3:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
  8043ca:	76 07                	jbe    8043d3 <inet_aton+0x264>
      return (0);
  8043cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8043d1:	eb 41                	jmp    804414 <inet_aton+0x2a5>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8043d3:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8043d6:	c1 e0 18             	shl    $0x18,%eax
  8043d9:	89 c2                	mov    %eax,%edx
  8043db:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8043de:	c1 e0 10             	shl    $0x10,%eax
  8043e1:	09 c2                	or     %eax,%edx
  8043e3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8043e6:	c1 e0 08             	shl    $0x8,%eax
  8043e9:	09 d0                	or     %edx,%eax
  8043eb:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8043ee:	eb 01                	jmp    8043f1 <inet_aton+0x282>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  8043f0:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  8043f1:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  8043f6:	74 17                	je     80440f <inet_aton+0x2a0>
    addr->s_addr = htonl(val);
  8043f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043fb:	89 c7                	mov    %eax,%edi
  8043fd:	48 b8 8d 45 80 00 00 	movabs $0x80458d,%rax
  804404:	00 00 00 
  804407:	ff d0                	callq  *%rax
  804409:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80440d:	89 02                	mov    %eax,(%rdx)
  return (1);
  80440f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804414:	c9                   	leaveq 
  804415:	c3                   	retq   

0000000000804416 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  804416:	55                   	push   %rbp
  804417:	48 89 e5             	mov    %rsp,%rbp
  80441a:	48 83 ec 30          	sub    $0x30,%rsp
  80441e:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  804421:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804424:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  804427:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80442e:	00 00 00 
  804431:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  804435:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  804439:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  80443d:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  804441:	e9 e0 00 00 00       	jmpq   804526 <inet_ntoa+0x110>
    i = 0;
  804446:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  80444a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80444e:	0f b6 08             	movzbl (%rax),%ecx
  804451:	0f b6 d1             	movzbl %cl,%edx
  804454:	89 d0                	mov    %edx,%eax
  804456:	c1 e0 02             	shl    $0x2,%eax
  804459:	01 d0                	add    %edx,%eax
  80445b:	c1 e0 03             	shl    $0x3,%eax
  80445e:	01 d0                	add    %edx,%eax
  804460:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  804467:	01 d0                	add    %edx,%eax
  804469:	66 c1 e8 08          	shr    $0x8,%ax
  80446d:	c0 e8 03             	shr    $0x3,%al
  804470:	88 45 ed             	mov    %al,-0x13(%rbp)
  804473:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  804477:	89 d0                	mov    %edx,%eax
  804479:	c1 e0 02             	shl    $0x2,%eax
  80447c:	01 d0                	add    %edx,%eax
  80447e:	01 c0                	add    %eax,%eax
  804480:	29 c1                	sub    %eax,%ecx
  804482:	89 c8                	mov    %ecx,%eax
  804484:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  804487:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80448b:	0f b6 00             	movzbl (%rax),%eax
  80448e:	0f b6 d0             	movzbl %al,%edx
  804491:	89 d0                	mov    %edx,%eax
  804493:	c1 e0 02             	shl    $0x2,%eax
  804496:	01 d0                	add    %edx,%eax
  804498:	c1 e0 03             	shl    $0x3,%eax
  80449b:	01 d0                	add    %edx,%eax
  80449d:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8044a4:	01 d0                	add    %edx,%eax
  8044a6:	66 c1 e8 08          	shr    $0x8,%ax
  8044aa:	89 c2                	mov    %eax,%edx
  8044ac:	c0 ea 03             	shr    $0x3,%dl
  8044af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044b3:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  8044b5:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  8044b9:	8d 50 01             	lea    0x1(%rax),%edx
  8044bc:	88 55 ee             	mov    %dl,-0x12(%rbp)
  8044bf:	0f b6 c0             	movzbl %al,%eax
  8044c2:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  8044c6:	83 c2 30             	add    $0x30,%edx
  8044c9:	48 98                	cltq   
  8044cb:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    } while(*ap);
  8044cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044d3:	0f b6 00             	movzbl (%rax),%eax
  8044d6:	84 c0                	test   %al,%al
  8044d8:	0f 85 6c ff ff ff    	jne    80444a <inet_ntoa+0x34>
    while(i--)
  8044de:	eb 1a                	jmp    8044fa <inet_ntoa+0xe4>
      *rp++ = inv[i];
  8044e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044e4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8044e8:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  8044ec:	0f b6 55 ee          	movzbl -0x12(%rbp),%edx
  8044f0:	48 63 d2             	movslq %edx,%rdx
  8044f3:	0f b6 54 15 e0       	movzbl -0x20(%rbp,%rdx,1),%edx
  8044f8:	88 10                	mov    %dl,(%rax)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  8044fa:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  8044fe:	8d 50 ff             	lea    -0x1(%rax),%edx
  804501:	88 55 ee             	mov    %dl,-0x12(%rbp)
  804504:	84 c0                	test   %al,%al
  804506:	75 d8                	jne    8044e0 <inet_ntoa+0xca>
      *rp++ = inv[i];
    *rp++ = '.';
  804508:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80450c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804510:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  804514:	c6 00 2e             	movb   $0x2e,(%rax)
    ap++;
  804517:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80451c:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  804520:	83 c0 01             	add    $0x1,%eax
  804523:	88 45 ef             	mov    %al,-0x11(%rbp)
  804526:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  80452a:	0f 86 16 ff ff ff    	jbe    804446 <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  804530:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  804535:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804539:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  80453c:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804543:	00 00 00 
}
  804546:	c9                   	leaveq 
  804547:	c3                   	retq   

0000000000804548 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  804548:	55                   	push   %rbp
  804549:	48 89 e5             	mov    %rsp,%rbp
  80454c:	48 83 ec 04          	sub    $0x4,%rsp
  804550:	89 f8                	mov    %edi,%eax
  804552:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  804556:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  80455a:	c1 e0 08             	shl    $0x8,%eax
  80455d:	89 c2                	mov    %eax,%edx
  80455f:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804563:	66 c1 e8 08          	shr    $0x8,%ax
  804567:	09 d0                	or     %edx,%eax
}
  804569:	c9                   	leaveq 
  80456a:	c3                   	retq   

000000000080456b <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  80456b:	55                   	push   %rbp
  80456c:	48 89 e5             	mov    %rsp,%rbp
  80456f:	48 83 ec 08          	sub    $0x8,%rsp
  804573:	89 f8                	mov    %edi,%eax
  804575:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  804579:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  80457d:	89 c7                	mov    %eax,%edi
  80457f:	48 b8 48 45 80 00 00 	movabs $0x804548,%rax
  804586:	00 00 00 
  804589:	ff d0                	callq  *%rax
}
  80458b:	c9                   	leaveq 
  80458c:	c3                   	retq   

000000000080458d <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  80458d:	55                   	push   %rbp
  80458e:	48 89 e5             	mov    %rsp,%rbp
  804591:	48 83 ec 04          	sub    $0x4,%rsp
  804595:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  804598:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80459b:	c1 e0 18             	shl    $0x18,%eax
  80459e:	89 c2                	mov    %eax,%edx
    ((n & 0xff00) << 8) |
  8045a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045a3:	25 00 ff 00 00       	and    $0xff00,%eax
  8045a8:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8045ab:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  8045ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045b0:	25 00 00 ff 00       	and    $0xff0000,%eax
  8045b5:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8045b9:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8045bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045be:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8045c1:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  8045c3:	c9                   	leaveq 
  8045c4:	c3                   	retq   

00000000008045c5 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8045c5:	55                   	push   %rbp
  8045c6:	48 89 e5             	mov    %rsp,%rbp
  8045c9:	48 83 ec 08          	sub    $0x8,%rsp
  8045cd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  8045d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045d3:	89 c7                	mov    %eax,%edi
  8045d5:	48 b8 8d 45 80 00 00 	movabs $0x80458d,%rax
  8045dc:	00 00 00 
  8045df:	ff d0                	callq  *%rax
}
  8045e1:	c9                   	leaveq 
  8045e2:	c3                   	retq   
