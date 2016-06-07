
obj/user/primespipe.debug:     file format elf64-x86-64


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
  80003c:	e8 d3 03 00 00       	callq  800414 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 30          	sub    $0x30,%rsp
  80004b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80004e:	48 8d 4d ec          	lea    -0x14(%rbp),%rcx
  800052:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800055:	ba 04 00 00 00       	mov    $0x4,%edx
  80005a:	48 89 ce             	mov    %rcx,%rsi
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	48 b8 9d 2b 80 00 00 	movabs $0x802b9d,%rax
  800066:	00 00 00 
  800069:	ff d0                	callq  *%rax
  80006b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80006e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800072:	74 42                	je     8000b6 <primeproc+0x73>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  800074:	b8 00 00 00 00       	mov    $0x0,%eax
  800079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007d:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  800081:	89 c2                	mov    %eax,%edx
  800083:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800086:	41 89 d0             	mov    %edx,%r8d
  800089:	89 c1                	mov    %eax,%ecx
  80008b:	48 ba 00 4a 80 00 00 	movabs $0x804a00,%rdx
  800092:	00 00 00 
  800095:	be 15 00 00 00       	mov    $0x15,%esi
  80009a:	48 bf 2f 4a 80 00 00 	movabs $0x804a2f,%rdi
  8000a1:	00 00 00 
  8000a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a9:	49 b9 c2 04 80 00 00 	movabs $0x8004c2,%r9
  8000b0:	00 00 00 
  8000b3:	41 ff d1             	callq  *%r9

	cprintf("%d\n", p);
  8000b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000b9:	89 c6                	mov    %eax,%esi
  8000bb:	48 bf 41 4a 80 00 00 	movabs $0x804a41,%rdi
  8000c2:	00 00 00 
  8000c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ca:	48 ba fb 06 80 00 00 	movabs $0x8006fb,%rdx
  8000d1:	00 00 00 
  8000d4:	ff d2                	callq  *%rdx

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  8000d6:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8000da:	48 89 c7             	mov    %rax,%rdi
  8000dd:	48 b8 c0 3d 80 00 00 	movabs $0x803dc0,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
  8000e9:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000ec:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ef:	85 c0                	test   %eax,%eax
  8000f1:	79 30                	jns    800123 <primeproc+0xe0>
		panic("pipe: %e", i);
  8000f3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000f6:	89 c1                	mov    %eax,%ecx
  8000f8:	48 ba 45 4a 80 00 00 	movabs $0x804a45,%rdx
  8000ff:	00 00 00 
  800102:	be 1b 00 00 00       	mov    $0x1b,%esi
  800107:	48 bf 2f 4a 80 00 00 	movabs $0x804a2f,%rdi
  80010e:	00 00 00 
  800111:	b8 00 00 00 00       	mov    $0x0,%eax
  800116:	49 b8 c2 04 80 00 00 	movabs $0x8004c2,%r8
  80011d:	00 00 00 
  800120:	41 ff d0             	callq  *%r8
	if ((id = fork()) < 0)
  800123:	48 b8 ff 22 80 00 00 	movabs $0x8022ff,%rax
  80012a:	00 00 00 
  80012d:	ff d0                	callq  *%rax
  80012f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800132:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800136:	79 30                	jns    800168 <primeproc+0x125>
		panic("fork: %e", id);
  800138:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80013b:	89 c1                	mov    %eax,%ecx
  80013d:	48 ba 4e 4a 80 00 00 	movabs $0x804a4e,%rdx
  800144:	00 00 00 
  800147:	be 1d 00 00 00       	mov    $0x1d,%esi
  80014c:	48 bf 2f 4a 80 00 00 	movabs $0x804a2f,%rdi
  800153:	00 00 00 
  800156:	b8 00 00 00 00       	mov    $0x0,%eax
  80015b:	49 b8 c2 04 80 00 00 	movabs $0x8004c2,%r8
  800162:	00 00 00 
  800165:	41 ff d0             	callq  *%r8
	if (id == 0) {
  800168:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80016c:	75 2d                	jne    80019b <primeproc+0x158>
		close(fd);
  80016e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800171:	89 c7                	mov    %eax,%edi
  800173:	48 b8 a6 28 80 00 00 	movabs $0x8028a6,%rax
  80017a:	00 00 00 
  80017d:	ff d0                	callq  *%rax
		close(pfd[1]);
  80017f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800182:	89 c7                	mov    %eax,%edi
  800184:	48 b8 a6 28 80 00 00 	movabs $0x8028a6,%rax
  80018b:	00 00 00 
  80018e:	ff d0                	callq  *%rax
		fd = pfd[0];
  800190:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800193:	89 45 dc             	mov    %eax,-0x24(%rbp)
		goto top;
  800196:	e9 b3 fe ff ff       	jmpq   80004e <primeproc+0xb>
	}

	close(pfd[0]);
  80019b:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80019e:	89 c7                	mov    %eax,%edi
  8001a0:	48 b8 a6 28 80 00 00 	movabs $0x8028a6,%rax
  8001a7:	00 00 00 
  8001aa:	ff d0                	callq  *%rax
	wfd = pfd[1];
  8001ac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8001af:	89 45 f4             	mov    %eax,-0xc(%rbp)

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8001b2:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  8001b6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8001b9:	ba 04 00 00 00       	mov    $0x4,%edx
  8001be:	48 89 ce             	mov    %rcx,%rsi
  8001c1:	89 c7                	mov    %eax,%edi
  8001c3:	48 b8 9d 2b 80 00 00 	movabs $0x802b9d,%rax
  8001ca:	00 00 00 
  8001cd:	ff d0                	callq  *%rax
  8001cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d2:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8001d6:	74 4e                	je     800226 <primeproc+0x1e3>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  8001d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001e1:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  8001e5:	89 c2                	mov    %eax,%edx
  8001e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ea:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8001ed:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8001f0:	89 14 24             	mov    %edx,(%rsp)
  8001f3:	41 89 f1             	mov    %esi,%r9d
  8001f6:	41 89 c8             	mov    %ecx,%r8d
  8001f9:	89 c1                	mov    %eax,%ecx
  8001fb:	48 ba 57 4a 80 00 00 	movabs $0x804a57,%rdx
  800202:	00 00 00 
  800205:	be 2b 00 00 00       	mov    $0x2b,%esi
  80020a:	48 bf 2f 4a 80 00 00 	movabs $0x804a2f,%rdi
  800211:	00 00 00 
  800214:	b8 00 00 00 00       	mov    $0x0,%eax
  800219:	49 ba c2 04 80 00 00 	movabs $0x8004c2,%r10
  800220:	00 00 00 
  800223:	41 ff d2             	callq  *%r10
		if (i%p)
  800226:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800229:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  80022c:	99                   	cltd   
  80022d:	f7 f9                	idiv   %ecx
  80022f:	89 d0                	mov    %edx,%eax
  800231:	85 c0                	test   %eax,%eax
  800233:	74 6e                	je     8002a3 <primeproc+0x260>
			if ((r=write(wfd, &i, 4)) != 4)
  800235:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  800239:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80023c:	ba 04 00 00 00       	mov    $0x4,%edx
  800241:	48 89 ce             	mov    %rcx,%rsi
  800244:	89 c7                	mov    %eax,%edi
  800246:	48 b8 12 2c 80 00 00 	movabs $0x802c12,%rax
  80024d:	00 00 00 
  800250:	ff d0                	callq  *%rax
  800252:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800255:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800259:	74 48                	je     8002a3 <primeproc+0x260>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80025b:	b8 00 00 00 00       	mov    $0x0,%eax
  800260:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800264:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  800268:	89 c1                	mov    %eax,%ecx
  80026a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80026d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800270:	41 89 c9             	mov    %ecx,%r9d
  800273:	41 89 d0             	mov    %edx,%r8d
  800276:	89 c1                	mov    %eax,%ecx
  800278:	48 ba 73 4a 80 00 00 	movabs $0x804a73,%rdx
  80027f:	00 00 00 
  800282:	be 2e 00 00 00       	mov    $0x2e,%esi
  800287:	48 bf 2f 4a 80 00 00 	movabs $0x804a2f,%rdi
  80028e:	00 00 00 
  800291:	b8 00 00 00 00       	mov    $0x0,%eax
  800296:	49 ba c2 04 80 00 00 	movabs $0x8004c2,%r10
  80029d:	00 00 00 
  8002a0:	41 ff d2             	callq  *%r10
	}
  8002a3:	e9 0a ff ff ff       	jmpq   8001b2 <primeproc+0x16f>

00000000008002a8 <umain>:
}

void
umain(int argc, char **argv)
{
  8002a8:	55                   	push   %rbp
  8002a9:	48 89 e5             	mov    %rsp,%rbp
  8002ac:	53                   	push   %rbx
  8002ad:	48 83 ec 38          	sub    $0x38,%rsp
  8002b1:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8002b4:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int i, id, p[2], r;

	binaryname = "primespipe";
  8002b8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002bf:	00 00 00 
  8002c2:	48 bb 8d 4a 80 00 00 	movabs $0x804a8d,%rbx
  8002c9:	00 00 00 
  8002cc:	48 89 18             	mov    %rbx,(%rax)

	if ((i=pipe(p)) < 0)
  8002cf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8002d3:	48 89 c7             	mov    %rax,%rdi
  8002d6:	48 b8 c0 3d 80 00 00 	movabs $0x803dc0,%rax
  8002dd:	00 00 00 
  8002e0:	ff d0                	callq  *%rax
  8002e2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8002e5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8002e8:	85 c0                	test   %eax,%eax
  8002ea:	79 30                	jns    80031c <umain+0x74>
		panic("pipe: %e", i);
  8002ec:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8002ef:	89 c1                	mov    %eax,%ecx
  8002f1:	48 ba 45 4a 80 00 00 	movabs $0x804a45,%rdx
  8002f8:	00 00 00 
  8002fb:	be 3a 00 00 00       	mov    $0x3a,%esi
  800300:	48 bf 2f 4a 80 00 00 	movabs $0x804a2f,%rdi
  800307:	00 00 00 
  80030a:	b8 00 00 00 00       	mov    $0x0,%eax
  80030f:	49 b8 c2 04 80 00 00 	movabs $0x8004c2,%r8
  800316:	00 00 00 
  800319:	41 ff d0             	callq  *%r8

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  80031c:	48 b8 ff 22 80 00 00 	movabs $0x8022ff,%rax
  800323:	00 00 00 
  800326:	ff d0                	callq  *%rax
  800328:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80032b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80032f:	79 30                	jns    800361 <umain+0xb9>
		panic("fork: %e", id);
  800331:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800334:	89 c1                	mov    %eax,%ecx
  800336:	48 ba 4e 4a 80 00 00 	movabs $0x804a4e,%rdx
  80033d:	00 00 00 
  800340:	be 3e 00 00 00       	mov    $0x3e,%esi
  800345:	48 bf 2f 4a 80 00 00 	movabs $0x804a2f,%rdi
  80034c:	00 00 00 
  80034f:	b8 00 00 00 00       	mov    $0x0,%eax
  800354:	49 b8 c2 04 80 00 00 	movabs $0x8004c2,%r8
  80035b:	00 00 00 
  80035e:	41 ff d0             	callq  *%r8

	if (id == 0) {
  800361:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800365:	75 22                	jne    800389 <umain+0xe1>
		close(p[1]);
  800367:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80036a:	89 c7                	mov    %eax,%edi
  80036c:	48 b8 a6 28 80 00 00 	movabs $0x8028a6,%rax
  800373:	00 00 00 
  800376:	ff d0                	callq  *%rax
		primeproc(p[0]);
  800378:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80037b:	89 c7                	mov    %eax,%edi
  80037d:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800384:	00 00 00 
  800387:	ff d0                	callq  *%rax
	}

	close(p[0]);
  800389:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80038c:	89 c7                	mov    %eax,%edi
  80038e:	48 b8 a6 28 80 00 00 	movabs $0x8028a6,%rax
  800395:	00 00 00 
  800398:	ff d0                	callq  *%rax

	// feed all the integers through
	for (i=2;; i++)
  80039a:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%rbp)
		if ((r=write(p[1], &i, 4)) != 4)
  8003a1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003a4:	48 8d 4d e4          	lea    -0x1c(%rbp),%rcx
  8003a8:	ba 04 00 00 00       	mov    $0x4,%edx
  8003ad:	48 89 ce             	mov    %rcx,%rsi
  8003b0:	89 c7                	mov    %eax,%edi
  8003b2:	48 b8 12 2c 80 00 00 	movabs $0x802c12,%rax
  8003b9:	00 00 00 
  8003bc:	ff d0                	callq  *%rax
  8003be:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8003c1:	83 7d e8 04          	cmpl   $0x4,-0x18(%rbp)
  8003c5:	74 42                	je     800409 <umain+0x161>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  8003c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8003d0:	0f 4e 45 e8          	cmovle -0x18(%rbp),%eax
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8003d9:	41 89 d0             	mov    %edx,%r8d
  8003dc:	89 c1                	mov    %eax,%ecx
  8003de:	48 ba 98 4a 80 00 00 	movabs $0x804a98,%rdx
  8003e5:	00 00 00 
  8003e8:	be 4a 00 00 00       	mov    $0x4a,%esi
  8003ed:	48 bf 2f 4a 80 00 00 	movabs $0x804a2f,%rdi
  8003f4:	00 00 00 
  8003f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fc:	49 b9 c2 04 80 00 00 	movabs $0x8004c2,%r9
  800403:	00 00 00 
  800406:	41 ff d1             	callq  *%r9
	}

	close(p[0]);

	// feed all the integers through
	for (i=2;; i++)
  800409:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80040c:	83 c0 01             	add    $0x1,%eax
  80040f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if ((r=write(p[1], &i, 4)) != 4)
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
}
  800412:	eb 8d                	jmp    8003a1 <umain+0xf9>

0000000000800414 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800414:	55                   	push   %rbp
  800415:	48 89 e5             	mov    %rsp,%rbp
  800418:	48 83 ec 10          	sub    $0x10,%rsp
  80041c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80041f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800423:	48 b8 63 1b 80 00 00 	movabs $0x801b63,%rax
  80042a:	00 00 00 
  80042d:	ff d0                	callq  *%rax
  80042f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800434:	48 63 d0             	movslq %eax,%rdx
  800437:	48 89 d0             	mov    %rdx,%rax
  80043a:	48 c1 e0 03          	shl    $0x3,%rax
  80043e:	48 01 d0             	add    %rdx,%rax
  800441:	48 c1 e0 05          	shl    $0x5,%rax
  800445:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80044c:	00 00 00 
  80044f:	48 01 c2             	add    %rax,%rdx
  800452:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800459:	00 00 00 
  80045c:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80045f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800463:	7e 14                	jle    800479 <libmain+0x65>
		binaryname = argv[0];
  800465:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800469:	48 8b 10             	mov    (%rax),%rdx
  80046c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800473:	00 00 00 
  800476:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800479:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80047d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800480:	48 89 d6             	mov    %rdx,%rsi
  800483:	89 c7                	mov    %eax,%edi
  800485:	48 b8 a8 02 80 00 00 	movabs $0x8002a8,%rax
  80048c:	00 00 00 
  80048f:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800491:	48 b8 9f 04 80 00 00 	movabs $0x80049f,%rax
  800498:	00 00 00 
  80049b:	ff d0                	callq  *%rax
}
  80049d:	c9                   	leaveq 
  80049e:	c3                   	retq   

000000000080049f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80049f:	55                   	push   %rbp
  8004a0:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8004a3:	48 b8 f1 28 80 00 00 	movabs $0x8028f1,%rax
  8004aa:	00 00 00 
  8004ad:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8004af:	bf 00 00 00 00       	mov    $0x0,%edi
  8004b4:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  8004bb:	00 00 00 
  8004be:	ff d0                	callq  *%rax

}
  8004c0:	5d                   	pop    %rbp
  8004c1:	c3                   	retq   

00000000008004c2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004c2:	55                   	push   %rbp
  8004c3:	48 89 e5             	mov    %rsp,%rbp
  8004c6:	53                   	push   %rbx
  8004c7:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8004ce:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8004d5:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8004db:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8004e2:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8004e9:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8004f0:	84 c0                	test   %al,%al
  8004f2:	74 23                	je     800517 <_panic+0x55>
  8004f4:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8004fb:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8004ff:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800503:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800507:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80050b:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80050f:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800513:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800517:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80051e:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800525:	00 00 00 
  800528:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80052f:	00 00 00 
  800532:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800536:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80053d:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800544:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80054b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800552:	00 00 00 
  800555:	48 8b 18             	mov    (%rax),%rbx
  800558:	48 b8 63 1b 80 00 00 	movabs $0x801b63,%rax
  80055f:	00 00 00 
  800562:	ff d0                	callq  *%rax
  800564:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80056a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800571:	41 89 c8             	mov    %ecx,%r8d
  800574:	48 89 d1             	mov    %rdx,%rcx
  800577:	48 89 da             	mov    %rbx,%rdx
  80057a:	89 c6                	mov    %eax,%esi
  80057c:	48 bf c0 4a 80 00 00 	movabs $0x804ac0,%rdi
  800583:	00 00 00 
  800586:	b8 00 00 00 00       	mov    $0x0,%eax
  80058b:	49 b9 fb 06 80 00 00 	movabs $0x8006fb,%r9
  800592:	00 00 00 
  800595:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800598:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80059f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005a6:	48 89 d6             	mov    %rdx,%rsi
  8005a9:	48 89 c7             	mov    %rax,%rdi
  8005ac:	48 b8 4f 06 80 00 00 	movabs $0x80064f,%rax
  8005b3:	00 00 00 
  8005b6:	ff d0                	callq  *%rax
	cprintf("\n");
  8005b8:	48 bf e3 4a 80 00 00 	movabs $0x804ae3,%rdi
  8005bf:	00 00 00 
  8005c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c7:	48 ba fb 06 80 00 00 	movabs $0x8006fb,%rdx
  8005ce:	00 00 00 
  8005d1:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005d3:	cc                   	int3   
  8005d4:	eb fd                	jmp    8005d3 <_panic+0x111>

00000000008005d6 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8005d6:	55                   	push   %rbp
  8005d7:	48 89 e5             	mov    %rsp,%rbp
  8005da:	48 83 ec 10          	sub    $0x10,%rsp
  8005de:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8005e1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8005e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005e9:	8b 00                	mov    (%rax),%eax
  8005eb:	8d 48 01             	lea    0x1(%rax),%ecx
  8005ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005f2:	89 0a                	mov    %ecx,(%rdx)
  8005f4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8005f7:	89 d1                	mov    %edx,%ecx
  8005f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005fd:	48 98                	cltq   
  8005ff:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800603:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800607:	8b 00                	mov    (%rax),%eax
  800609:	3d ff 00 00 00       	cmp    $0xff,%eax
  80060e:	75 2c                	jne    80063c <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800610:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800614:	8b 00                	mov    (%rax),%eax
  800616:	48 98                	cltq   
  800618:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80061c:	48 83 c2 08          	add    $0x8,%rdx
  800620:	48 89 c6             	mov    %rax,%rsi
  800623:	48 89 d7             	mov    %rdx,%rdi
  800626:	48 b8 97 1a 80 00 00 	movabs $0x801a97,%rax
  80062d:	00 00 00 
  800630:	ff d0                	callq  *%rax
        b->idx = 0;
  800632:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800636:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80063c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800640:	8b 40 04             	mov    0x4(%rax),%eax
  800643:	8d 50 01             	lea    0x1(%rax),%edx
  800646:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80064a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80064d:	c9                   	leaveq 
  80064e:	c3                   	retq   

000000000080064f <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80064f:	55                   	push   %rbp
  800650:	48 89 e5             	mov    %rsp,%rbp
  800653:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80065a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800661:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800668:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80066f:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800676:	48 8b 0a             	mov    (%rdx),%rcx
  800679:	48 89 08             	mov    %rcx,(%rax)
  80067c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800680:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800684:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800688:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80068c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800693:	00 00 00 
    b.cnt = 0;
  800696:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80069d:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006a0:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006a7:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006ae:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8006b5:	48 89 c6             	mov    %rax,%rsi
  8006b8:	48 bf d6 05 80 00 00 	movabs $0x8005d6,%rdi
  8006bf:	00 00 00 
  8006c2:	48 b8 ae 0a 80 00 00 	movabs $0x800aae,%rax
  8006c9:	00 00 00 
  8006cc:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8006ce:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8006d4:	48 98                	cltq   
  8006d6:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8006dd:	48 83 c2 08          	add    $0x8,%rdx
  8006e1:	48 89 c6             	mov    %rax,%rsi
  8006e4:	48 89 d7             	mov    %rdx,%rdi
  8006e7:	48 b8 97 1a 80 00 00 	movabs $0x801a97,%rax
  8006ee:	00 00 00 
  8006f1:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8006f3:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8006f9:	c9                   	leaveq 
  8006fa:	c3                   	retq   

00000000008006fb <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8006fb:	55                   	push   %rbp
  8006fc:	48 89 e5             	mov    %rsp,%rbp
  8006ff:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800706:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80070d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800714:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80071b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800722:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800729:	84 c0                	test   %al,%al
  80072b:	74 20                	je     80074d <cprintf+0x52>
  80072d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800731:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800735:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800739:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80073d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800741:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800745:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800749:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80074d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800754:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80075b:	00 00 00 
  80075e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800765:	00 00 00 
  800768:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80076c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800773:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80077a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800781:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800788:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80078f:	48 8b 0a             	mov    (%rdx),%rcx
  800792:	48 89 08             	mov    %rcx,(%rax)
  800795:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800799:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80079d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007a1:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007a5:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007ac:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8007b3:	48 89 d6             	mov    %rdx,%rsi
  8007b6:	48 89 c7             	mov    %rax,%rdi
  8007b9:	48 b8 4f 06 80 00 00 	movabs $0x80064f,%rax
  8007c0:	00 00 00 
  8007c3:	ff d0                	callq  *%rax
  8007c5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8007cb:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8007d1:	c9                   	leaveq 
  8007d2:	c3                   	retq   

00000000008007d3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007d3:	55                   	push   %rbp
  8007d4:	48 89 e5             	mov    %rsp,%rbp
  8007d7:	53                   	push   %rbx
  8007d8:	48 83 ec 38          	sub    $0x38,%rsp
  8007dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8007e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8007e8:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8007eb:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8007ef:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007f3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8007f6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8007fa:	77 3b                	ja     800837 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007fc:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8007ff:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800803:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800806:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80080a:	ba 00 00 00 00       	mov    $0x0,%edx
  80080f:	48 f7 f3             	div    %rbx
  800812:	48 89 c2             	mov    %rax,%rdx
  800815:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800818:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80081b:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80081f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800823:	41 89 f9             	mov    %edi,%r9d
  800826:	48 89 c7             	mov    %rax,%rdi
  800829:	48 b8 d3 07 80 00 00 	movabs $0x8007d3,%rax
  800830:	00 00 00 
  800833:	ff d0                	callq  *%rax
  800835:	eb 1e                	jmp    800855 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800837:	eb 12                	jmp    80084b <printnum+0x78>
			putch(padc, putdat);
  800839:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80083d:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800840:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800844:	48 89 ce             	mov    %rcx,%rsi
  800847:	89 d7                	mov    %edx,%edi
  800849:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80084b:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80084f:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800853:	7f e4                	jg     800839 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800855:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800858:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80085c:	ba 00 00 00 00       	mov    $0x0,%edx
  800861:	48 f7 f1             	div    %rcx
  800864:	48 89 d0             	mov    %rdx,%rax
  800867:	48 ba f0 4c 80 00 00 	movabs $0x804cf0,%rdx
  80086e:	00 00 00 
  800871:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800875:	0f be d0             	movsbl %al,%edx
  800878:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80087c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800880:	48 89 ce             	mov    %rcx,%rsi
  800883:	89 d7                	mov    %edx,%edi
  800885:	ff d0                	callq  *%rax
}
  800887:	48 83 c4 38          	add    $0x38,%rsp
  80088b:	5b                   	pop    %rbx
  80088c:	5d                   	pop    %rbp
  80088d:	c3                   	retq   

000000000080088e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80088e:	55                   	push   %rbp
  80088f:	48 89 e5             	mov    %rsp,%rbp
  800892:	48 83 ec 1c          	sub    $0x1c,%rsp
  800896:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80089a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80089d:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008a1:	7e 52                	jle    8008f5 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a7:	8b 00                	mov    (%rax),%eax
  8008a9:	83 f8 30             	cmp    $0x30,%eax
  8008ac:	73 24                	jae    8008d2 <getuint+0x44>
  8008ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ba:	8b 00                	mov    (%rax),%eax
  8008bc:	89 c0                	mov    %eax,%eax
  8008be:	48 01 d0             	add    %rdx,%rax
  8008c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c5:	8b 12                	mov    (%rdx),%edx
  8008c7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ce:	89 0a                	mov    %ecx,(%rdx)
  8008d0:	eb 17                	jmp    8008e9 <getuint+0x5b>
  8008d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008da:	48 89 d0             	mov    %rdx,%rax
  8008dd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008e9:	48 8b 00             	mov    (%rax),%rax
  8008ec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008f0:	e9 a3 00 00 00       	jmpq   800998 <getuint+0x10a>
	else if (lflag)
  8008f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008f9:	74 4f                	je     80094a <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8008fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ff:	8b 00                	mov    (%rax),%eax
  800901:	83 f8 30             	cmp    $0x30,%eax
  800904:	73 24                	jae    80092a <getuint+0x9c>
  800906:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80090e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800912:	8b 00                	mov    (%rax),%eax
  800914:	89 c0                	mov    %eax,%eax
  800916:	48 01 d0             	add    %rdx,%rax
  800919:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091d:	8b 12                	mov    (%rdx),%edx
  80091f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800922:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800926:	89 0a                	mov    %ecx,(%rdx)
  800928:	eb 17                	jmp    800941 <getuint+0xb3>
  80092a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800932:	48 89 d0             	mov    %rdx,%rax
  800935:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800939:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800941:	48 8b 00             	mov    (%rax),%rax
  800944:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800948:	eb 4e                	jmp    800998 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80094a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094e:	8b 00                	mov    (%rax),%eax
  800950:	83 f8 30             	cmp    $0x30,%eax
  800953:	73 24                	jae    800979 <getuint+0xeb>
  800955:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800959:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80095d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800961:	8b 00                	mov    (%rax),%eax
  800963:	89 c0                	mov    %eax,%eax
  800965:	48 01 d0             	add    %rdx,%rax
  800968:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096c:	8b 12                	mov    (%rdx),%edx
  80096e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800971:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800975:	89 0a                	mov    %ecx,(%rdx)
  800977:	eb 17                	jmp    800990 <getuint+0x102>
  800979:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800981:	48 89 d0             	mov    %rdx,%rax
  800984:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800988:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80098c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800990:	8b 00                	mov    (%rax),%eax
  800992:	89 c0                	mov    %eax,%eax
  800994:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800998:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80099c:	c9                   	leaveq 
  80099d:	c3                   	retq   

000000000080099e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80099e:	55                   	push   %rbp
  80099f:	48 89 e5             	mov    %rsp,%rbp
  8009a2:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009aa:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009ad:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009b1:	7e 52                	jle    800a05 <getint+0x67>
		x=va_arg(*ap, long long);
  8009b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b7:	8b 00                	mov    (%rax),%eax
  8009b9:	83 f8 30             	cmp    $0x30,%eax
  8009bc:	73 24                	jae    8009e2 <getint+0x44>
  8009be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ca:	8b 00                	mov    (%rax),%eax
  8009cc:	89 c0                	mov    %eax,%eax
  8009ce:	48 01 d0             	add    %rdx,%rax
  8009d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d5:	8b 12                	mov    (%rdx),%edx
  8009d7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009de:	89 0a                	mov    %ecx,(%rdx)
  8009e0:	eb 17                	jmp    8009f9 <getint+0x5b>
  8009e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009ea:	48 89 d0             	mov    %rdx,%rax
  8009ed:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009f9:	48 8b 00             	mov    (%rax),%rax
  8009fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a00:	e9 a3 00 00 00       	jmpq   800aa8 <getint+0x10a>
	else if (lflag)
  800a05:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a09:	74 4f                	je     800a5a <getint+0xbc>
		x=va_arg(*ap, long);
  800a0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0f:	8b 00                	mov    (%rax),%eax
  800a11:	83 f8 30             	cmp    $0x30,%eax
  800a14:	73 24                	jae    800a3a <getint+0x9c>
  800a16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a22:	8b 00                	mov    (%rax),%eax
  800a24:	89 c0                	mov    %eax,%eax
  800a26:	48 01 d0             	add    %rdx,%rax
  800a29:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2d:	8b 12                	mov    (%rdx),%edx
  800a2f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a32:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a36:	89 0a                	mov    %ecx,(%rdx)
  800a38:	eb 17                	jmp    800a51 <getint+0xb3>
  800a3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a42:	48 89 d0             	mov    %rdx,%rax
  800a45:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a49:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a51:	48 8b 00             	mov    (%rax),%rax
  800a54:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a58:	eb 4e                	jmp    800aa8 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800a5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5e:	8b 00                	mov    (%rax),%eax
  800a60:	83 f8 30             	cmp    $0x30,%eax
  800a63:	73 24                	jae    800a89 <getint+0xeb>
  800a65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a69:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a71:	8b 00                	mov    (%rax),%eax
  800a73:	89 c0                	mov    %eax,%eax
  800a75:	48 01 d0             	add    %rdx,%rax
  800a78:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a7c:	8b 12                	mov    (%rdx),%edx
  800a7e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a81:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a85:	89 0a                	mov    %ecx,(%rdx)
  800a87:	eb 17                	jmp    800aa0 <getint+0x102>
  800a89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a91:	48 89 d0             	mov    %rdx,%rax
  800a94:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a98:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a9c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aa0:	8b 00                	mov    (%rax),%eax
  800aa2:	48 98                	cltq   
  800aa4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800aa8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800aac:	c9                   	leaveq 
  800aad:	c3                   	retq   

0000000000800aae <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800aae:	55                   	push   %rbp
  800aaf:	48 89 e5             	mov    %rsp,%rbp
  800ab2:	41 54                	push   %r12
  800ab4:	53                   	push   %rbx
  800ab5:	48 83 ec 60          	sub    $0x60,%rsp
  800ab9:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800abd:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800ac1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ac5:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800ac9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800acd:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800ad1:	48 8b 0a             	mov    (%rdx),%rcx
  800ad4:	48 89 08             	mov    %rcx,(%rax)
  800ad7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800adb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800adf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ae3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ae7:	eb 17                	jmp    800b00 <vprintfmt+0x52>
			if (ch == '\0')
  800ae9:	85 db                	test   %ebx,%ebx
  800aeb:	0f 84 cc 04 00 00    	je     800fbd <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800af1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800af5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af9:	48 89 d6             	mov    %rdx,%rsi
  800afc:	89 df                	mov    %ebx,%edi
  800afe:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b00:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b04:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b08:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b0c:	0f b6 00             	movzbl (%rax),%eax
  800b0f:	0f b6 d8             	movzbl %al,%ebx
  800b12:	83 fb 25             	cmp    $0x25,%ebx
  800b15:	75 d2                	jne    800ae9 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b17:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b1b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b22:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b29:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b30:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b37:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b3b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b3f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b43:	0f b6 00             	movzbl (%rax),%eax
  800b46:	0f b6 d8             	movzbl %al,%ebx
  800b49:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b4c:	83 f8 55             	cmp    $0x55,%eax
  800b4f:	0f 87 34 04 00 00    	ja     800f89 <vprintfmt+0x4db>
  800b55:	89 c0                	mov    %eax,%eax
  800b57:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b5e:	00 
  800b5f:	48 b8 18 4d 80 00 00 	movabs $0x804d18,%rax
  800b66:	00 00 00 
  800b69:	48 01 d0             	add    %rdx,%rax
  800b6c:	48 8b 00             	mov    (%rax),%rax
  800b6f:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800b71:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800b75:	eb c0                	jmp    800b37 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b77:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800b7b:	eb ba                	jmp    800b37 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b7d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800b84:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800b87:	89 d0                	mov    %edx,%eax
  800b89:	c1 e0 02             	shl    $0x2,%eax
  800b8c:	01 d0                	add    %edx,%eax
  800b8e:	01 c0                	add    %eax,%eax
  800b90:	01 d8                	add    %ebx,%eax
  800b92:	83 e8 30             	sub    $0x30,%eax
  800b95:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b98:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b9c:	0f b6 00             	movzbl (%rax),%eax
  800b9f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ba2:	83 fb 2f             	cmp    $0x2f,%ebx
  800ba5:	7e 0c                	jle    800bb3 <vprintfmt+0x105>
  800ba7:	83 fb 39             	cmp    $0x39,%ebx
  800baa:	7f 07                	jg     800bb3 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bac:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bb1:	eb d1                	jmp    800b84 <vprintfmt+0xd6>
			goto process_precision;
  800bb3:	eb 58                	jmp    800c0d <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800bb5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bb8:	83 f8 30             	cmp    $0x30,%eax
  800bbb:	73 17                	jae    800bd4 <vprintfmt+0x126>
  800bbd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bc1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc4:	89 c0                	mov    %eax,%eax
  800bc6:	48 01 d0             	add    %rdx,%rax
  800bc9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bcc:	83 c2 08             	add    $0x8,%edx
  800bcf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bd2:	eb 0f                	jmp    800be3 <vprintfmt+0x135>
  800bd4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bd8:	48 89 d0             	mov    %rdx,%rax
  800bdb:	48 83 c2 08          	add    $0x8,%rdx
  800bdf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800be3:	8b 00                	mov    (%rax),%eax
  800be5:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800be8:	eb 23                	jmp    800c0d <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800bea:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bee:	79 0c                	jns    800bfc <vprintfmt+0x14e>
				width = 0;
  800bf0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800bf7:	e9 3b ff ff ff       	jmpq   800b37 <vprintfmt+0x89>
  800bfc:	e9 36 ff ff ff       	jmpq   800b37 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c01:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c08:	e9 2a ff ff ff       	jmpq   800b37 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c0d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c11:	79 12                	jns    800c25 <vprintfmt+0x177>
				width = precision, precision = -1;
  800c13:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c16:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c19:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c20:	e9 12 ff ff ff       	jmpq   800b37 <vprintfmt+0x89>
  800c25:	e9 0d ff ff ff       	jmpq   800b37 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c2a:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c2e:	e9 04 ff ff ff       	jmpq   800b37 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c33:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c36:	83 f8 30             	cmp    $0x30,%eax
  800c39:	73 17                	jae    800c52 <vprintfmt+0x1a4>
  800c3b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c3f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c42:	89 c0                	mov    %eax,%eax
  800c44:	48 01 d0             	add    %rdx,%rax
  800c47:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c4a:	83 c2 08             	add    $0x8,%edx
  800c4d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c50:	eb 0f                	jmp    800c61 <vprintfmt+0x1b3>
  800c52:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c56:	48 89 d0             	mov    %rdx,%rax
  800c59:	48 83 c2 08          	add    $0x8,%rdx
  800c5d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c61:	8b 10                	mov    (%rax),%edx
  800c63:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c67:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6b:	48 89 ce             	mov    %rcx,%rsi
  800c6e:	89 d7                	mov    %edx,%edi
  800c70:	ff d0                	callq  *%rax
			break;
  800c72:	e9 40 03 00 00       	jmpq   800fb7 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800c77:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7a:	83 f8 30             	cmp    $0x30,%eax
  800c7d:	73 17                	jae    800c96 <vprintfmt+0x1e8>
  800c7f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c83:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c86:	89 c0                	mov    %eax,%eax
  800c88:	48 01 d0             	add    %rdx,%rax
  800c8b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c8e:	83 c2 08             	add    $0x8,%edx
  800c91:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c94:	eb 0f                	jmp    800ca5 <vprintfmt+0x1f7>
  800c96:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c9a:	48 89 d0             	mov    %rdx,%rax
  800c9d:	48 83 c2 08          	add    $0x8,%rdx
  800ca1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ca5:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ca7:	85 db                	test   %ebx,%ebx
  800ca9:	79 02                	jns    800cad <vprintfmt+0x1ff>
				err = -err;
  800cab:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cad:	83 fb 15             	cmp    $0x15,%ebx
  800cb0:	7f 16                	jg     800cc8 <vprintfmt+0x21a>
  800cb2:	48 b8 40 4c 80 00 00 	movabs $0x804c40,%rax
  800cb9:	00 00 00 
  800cbc:	48 63 d3             	movslq %ebx,%rdx
  800cbf:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800cc3:	4d 85 e4             	test   %r12,%r12
  800cc6:	75 2e                	jne    800cf6 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800cc8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ccc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd0:	89 d9                	mov    %ebx,%ecx
  800cd2:	48 ba 01 4d 80 00 00 	movabs $0x804d01,%rdx
  800cd9:	00 00 00 
  800cdc:	48 89 c7             	mov    %rax,%rdi
  800cdf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce4:	49 b8 c6 0f 80 00 00 	movabs $0x800fc6,%r8
  800ceb:	00 00 00 
  800cee:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cf1:	e9 c1 02 00 00       	jmpq   800fb7 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cf6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cfa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cfe:	4c 89 e1             	mov    %r12,%rcx
  800d01:	48 ba 0a 4d 80 00 00 	movabs $0x804d0a,%rdx
  800d08:	00 00 00 
  800d0b:	48 89 c7             	mov    %rax,%rdi
  800d0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d13:	49 b8 c6 0f 80 00 00 	movabs $0x800fc6,%r8
  800d1a:	00 00 00 
  800d1d:	41 ff d0             	callq  *%r8
			break;
  800d20:	e9 92 02 00 00       	jmpq   800fb7 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d28:	83 f8 30             	cmp    $0x30,%eax
  800d2b:	73 17                	jae    800d44 <vprintfmt+0x296>
  800d2d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d31:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d34:	89 c0                	mov    %eax,%eax
  800d36:	48 01 d0             	add    %rdx,%rax
  800d39:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d3c:	83 c2 08             	add    $0x8,%edx
  800d3f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d42:	eb 0f                	jmp    800d53 <vprintfmt+0x2a5>
  800d44:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d48:	48 89 d0             	mov    %rdx,%rax
  800d4b:	48 83 c2 08          	add    $0x8,%rdx
  800d4f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d53:	4c 8b 20             	mov    (%rax),%r12
  800d56:	4d 85 e4             	test   %r12,%r12
  800d59:	75 0a                	jne    800d65 <vprintfmt+0x2b7>
				p = "(null)";
  800d5b:	49 bc 0d 4d 80 00 00 	movabs $0x804d0d,%r12
  800d62:	00 00 00 
			if (width > 0 && padc != '-')
  800d65:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d69:	7e 3f                	jle    800daa <vprintfmt+0x2fc>
  800d6b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d6f:	74 39                	je     800daa <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d71:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d74:	48 98                	cltq   
  800d76:	48 89 c6             	mov    %rax,%rsi
  800d79:	4c 89 e7             	mov    %r12,%rdi
  800d7c:	48 b8 72 12 80 00 00 	movabs $0x801272,%rax
  800d83:	00 00 00 
  800d86:	ff d0                	callq  *%rax
  800d88:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800d8b:	eb 17                	jmp    800da4 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800d8d:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800d91:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d95:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d99:	48 89 ce             	mov    %rcx,%rsi
  800d9c:	89 d7                	mov    %edx,%edi
  800d9e:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800da0:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800da4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800da8:	7f e3                	jg     800d8d <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800daa:	eb 37                	jmp    800de3 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800dac:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800db0:	74 1e                	je     800dd0 <vprintfmt+0x322>
  800db2:	83 fb 1f             	cmp    $0x1f,%ebx
  800db5:	7e 05                	jle    800dbc <vprintfmt+0x30e>
  800db7:	83 fb 7e             	cmp    $0x7e,%ebx
  800dba:	7e 14                	jle    800dd0 <vprintfmt+0x322>
					putch('?', putdat);
  800dbc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc4:	48 89 d6             	mov    %rdx,%rsi
  800dc7:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800dcc:	ff d0                	callq  *%rax
  800dce:	eb 0f                	jmp    800ddf <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800dd0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dd4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dd8:	48 89 d6             	mov    %rdx,%rsi
  800ddb:	89 df                	mov    %ebx,%edi
  800ddd:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ddf:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800de3:	4c 89 e0             	mov    %r12,%rax
  800de6:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800dea:	0f b6 00             	movzbl (%rax),%eax
  800ded:	0f be d8             	movsbl %al,%ebx
  800df0:	85 db                	test   %ebx,%ebx
  800df2:	74 10                	je     800e04 <vprintfmt+0x356>
  800df4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800df8:	78 b2                	js     800dac <vprintfmt+0x2fe>
  800dfa:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800dfe:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e02:	79 a8                	jns    800dac <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e04:	eb 16                	jmp    800e1c <vprintfmt+0x36e>
				putch(' ', putdat);
  800e06:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0e:	48 89 d6             	mov    %rdx,%rsi
  800e11:	bf 20 00 00 00       	mov    $0x20,%edi
  800e16:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e18:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e1c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e20:	7f e4                	jg     800e06 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800e22:	e9 90 01 00 00       	jmpq   800fb7 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e27:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e2b:	be 03 00 00 00       	mov    $0x3,%esi
  800e30:	48 89 c7             	mov    %rax,%rdi
  800e33:	48 b8 9e 09 80 00 00 	movabs $0x80099e,%rax
  800e3a:	00 00 00 
  800e3d:	ff d0                	callq  *%rax
  800e3f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e47:	48 85 c0             	test   %rax,%rax
  800e4a:	79 1d                	jns    800e69 <vprintfmt+0x3bb>
				putch('-', putdat);
  800e4c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e50:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e54:	48 89 d6             	mov    %rdx,%rsi
  800e57:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e5c:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e62:	48 f7 d8             	neg    %rax
  800e65:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e69:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e70:	e9 d5 00 00 00       	jmpq   800f4a <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800e75:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e79:	be 03 00 00 00       	mov    $0x3,%esi
  800e7e:	48 89 c7             	mov    %rax,%rdi
  800e81:	48 b8 8e 08 80 00 00 	movabs $0x80088e,%rax
  800e88:	00 00 00 
  800e8b:	ff d0                	callq  *%rax
  800e8d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e91:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e98:	e9 ad 00 00 00       	jmpq   800f4a <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800e9d:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800ea0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ea4:	89 d6                	mov    %edx,%esi
  800ea6:	48 89 c7             	mov    %rax,%rdi
  800ea9:	48 b8 9e 09 80 00 00 	movabs $0x80099e,%rax
  800eb0:	00 00 00 
  800eb3:	ff d0                	callq  *%rax
  800eb5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800eb9:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ec0:	e9 85 00 00 00       	jmpq   800f4a <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800ec5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ec9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ecd:	48 89 d6             	mov    %rdx,%rsi
  800ed0:	bf 30 00 00 00       	mov    $0x30,%edi
  800ed5:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ed7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800edb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800edf:	48 89 d6             	mov    %rdx,%rsi
  800ee2:	bf 78 00 00 00       	mov    $0x78,%edi
  800ee7:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ee9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800eec:	83 f8 30             	cmp    $0x30,%eax
  800eef:	73 17                	jae    800f08 <vprintfmt+0x45a>
  800ef1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ef5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ef8:	89 c0                	mov    %eax,%eax
  800efa:	48 01 d0             	add    %rdx,%rax
  800efd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f00:	83 c2 08             	add    $0x8,%edx
  800f03:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f06:	eb 0f                	jmp    800f17 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800f08:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f0c:	48 89 d0             	mov    %rdx,%rax
  800f0f:	48 83 c2 08          	add    $0x8,%rdx
  800f13:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f17:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f1a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f1e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f25:	eb 23                	jmp    800f4a <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f27:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f2b:	be 03 00 00 00       	mov    $0x3,%esi
  800f30:	48 89 c7             	mov    %rax,%rdi
  800f33:	48 b8 8e 08 80 00 00 	movabs $0x80088e,%rax
  800f3a:	00 00 00 
  800f3d:	ff d0                	callq  *%rax
  800f3f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f43:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f4a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f4f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f52:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f55:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f59:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f61:	45 89 c1             	mov    %r8d,%r9d
  800f64:	41 89 f8             	mov    %edi,%r8d
  800f67:	48 89 c7             	mov    %rax,%rdi
  800f6a:	48 b8 d3 07 80 00 00 	movabs $0x8007d3,%rax
  800f71:	00 00 00 
  800f74:	ff d0                	callq  *%rax
			break;
  800f76:	eb 3f                	jmp    800fb7 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f78:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f80:	48 89 d6             	mov    %rdx,%rsi
  800f83:	89 df                	mov    %ebx,%edi
  800f85:	ff d0                	callq  *%rax
			break;
  800f87:	eb 2e                	jmp    800fb7 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f89:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f8d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f91:	48 89 d6             	mov    %rdx,%rsi
  800f94:	bf 25 00 00 00       	mov    $0x25,%edi
  800f99:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f9b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fa0:	eb 05                	jmp    800fa7 <vprintfmt+0x4f9>
  800fa2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fa7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fab:	48 83 e8 01          	sub    $0x1,%rax
  800faf:	0f b6 00             	movzbl (%rax),%eax
  800fb2:	3c 25                	cmp    $0x25,%al
  800fb4:	75 ec                	jne    800fa2 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800fb6:	90                   	nop
		}
	}
  800fb7:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800fb8:	e9 43 fb ff ff       	jmpq   800b00 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800fbd:	48 83 c4 60          	add    $0x60,%rsp
  800fc1:	5b                   	pop    %rbx
  800fc2:	41 5c                	pop    %r12
  800fc4:	5d                   	pop    %rbp
  800fc5:	c3                   	retq   

0000000000800fc6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fc6:	55                   	push   %rbp
  800fc7:	48 89 e5             	mov    %rsp,%rbp
  800fca:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800fd1:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800fd8:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800fdf:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fe6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fed:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ff4:	84 c0                	test   %al,%al
  800ff6:	74 20                	je     801018 <printfmt+0x52>
  800ff8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ffc:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801000:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801004:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801008:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80100c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801010:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801014:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801018:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80101f:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801026:	00 00 00 
  801029:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801030:	00 00 00 
  801033:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801037:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80103e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801045:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80104c:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801053:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80105a:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801061:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801068:	48 89 c7             	mov    %rax,%rdi
  80106b:	48 b8 ae 0a 80 00 00 	movabs $0x800aae,%rax
  801072:	00 00 00 
  801075:	ff d0                	callq  *%rax
	va_end(ap);
}
  801077:	c9                   	leaveq 
  801078:	c3                   	retq   

0000000000801079 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801079:	55                   	push   %rbp
  80107a:	48 89 e5             	mov    %rsp,%rbp
  80107d:	48 83 ec 10          	sub    $0x10,%rsp
  801081:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801084:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801088:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80108c:	8b 40 10             	mov    0x10(%rax),%eax
  80108f:	8d 50 01             	lea    0x1(%rax),%edx
  801092:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801096:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801099:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80109d:	48 8b 10             	mov    (%rax),%rdx
  8010a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010a4:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010a8:	48 39 c2             	cmp    %rax,%rdx
  8010ab:	73 17                	jae    8010c4 <sprintputch+0x4b>
		*b->buf++ = ch;
  8010ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010b1:	48 8b 00             	mov    (%rax),%rax
  8010b4:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8010b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010bc:	48 89 0a             	mov    %rcx,(%rdx)
  8010bf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010c2:	88 10                	mov    %dl,(%rax)
}
  8010c4:	c9                   	leaveq 
  8010c5:	c3                   	retq   

00000000008010c6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010c6:	55                   	push   %rbp
  8010c7:	48 89 e5             	mov    %rsp,%rbp
  8010ca:	48 83 ec 50          	sub    $0x50,%rsp
  8010ce:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8010d2:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8010d5:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8010d9:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8010dd:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8010e1:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8010e5:	48 8b 0a             	mov    (%rdx),%rcx
  8010e8:	48 89 08             	mov    %rcx,(%rax)
  8010eb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010ef:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010f3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010f7:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010fb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8010ff:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801103:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801106:	48 98                	cltq   
  801108:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80110c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801110:	48 01 d0             	add    %rdx,%rax
  801113:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801117:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80111e:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801123:	74 06                	je     80112b <vsnprintf+0x65>
  801125:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801129:	7f 07                	jg     801132 <vsnprintf+0x6c>
		return -E_INVAL;
  80112b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801130:	eb 2f                	jmp    801161 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801132:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801136:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80113a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80113e:	48 89 c6             	mov    %rax,%rsi
  801141:	48 bf 79 10 80 00 00 	movabs $0x801079,%rdi
  801148:	00 00 00 
  80114b:	48 b8 ae 0a 80 00 00 	movabs $0x800aae,%rax
  801152:	00 00 00 
  801155:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801157:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80115b:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80115e:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801161:	c9                   	leaveq 
  801162:	c3                   	retq   

0000000000801163 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801163:	55                   	push   %rbp
  801164:	48 89 e5             	mov    %rsp,%rbp
  801167:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80116e:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801175:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80117b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801182:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801189:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801190:	84 c0                	test   %al,%al
  801192:	74 20                	je     8011b4 <snprintf+0x51>
  801194:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801198:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80119c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011a0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011a4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011a8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011ac:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011b0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8011b4:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8011bb:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8011c2:	00 00 00 
  8011c5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8011cc:	00 00 00 
  8011cf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8011d3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8011da:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8011e1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8011e8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8011ef:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8011f6:	48 8b 0a             	mov    (%rdx),%rcx
  8011f9:	48 89 08             	mov    %rcx,(%rax)
  8011fc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801200:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801204:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801208:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80120c:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801213:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80121a:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801220:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801227:	48 89 c7             	mov    %rax,%rdi
  80122a:	48 b8 c6 10 80 00 00 	movabs $0x8010c6,%rax
  801231:	00 00 00 
  801234:	ff d0                	callq  *%rax
  801236:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80123c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801242:	c9                   	leaveq 
  801243:	c3                   	retq   

0000000000801244 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801244:	55                   	push   %rbp
  801245:	48 89 e5             	mov    %rsp,%rbp
  801248:	48 83 ec 18          	sub    $0x18,%rsp
  80124c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801250:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801257:	eb 09                	jmp    801262 <strlen+0x1e>
		n++;
  801259:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80125d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801262:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801266:	0f b6 00             	movzbl (%rax),%eax
  801269:	84 c0                	test   %al,%al
  80126b:	75 ec                	jne    801259 <strlen+0x15>
		n++;
	return n;
  80126d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801270:	c9                   	leaveq 
  801271:	c3                   	retq   

0000000000801272 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801272:	55                   	push   %rbp
  801273:	48 89 e5             	mov    %rsp,%rbp
  801276:	48 83 ec 20          	sub    $0x20,%rsp
  80127a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80127e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801282:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801289:	eb 0e                	jmp    801299 <strnlen+0x27>
		n++;
  80128b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80128f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801294:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801299:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80129e:	74 0b                	je     8012ab <strnlen+0x39>
  8012a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a4:	0f b6 00             	movzbl (%rax),%eax
  8012a7:	84 c0                	test   %al,%al
  8012a9:	75 e0                	jne    80128b <strnlen+0x19>
		n++;
	return n;
  8012ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012ae:	c9                   	leaveq 
  8012af:	c3                   	retq   

00000000008012b0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012b0:	55                   	push   %rbp
  8012b1:	48 89 e5             	mov    %rsp,%rbp
  8012b4:	48 83 ec 20          	sub    $0x20,%rsp
  8012b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8012c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8012c8:	90                   	nop
  8012c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012cd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012d1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012d5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012d9:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012dd:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012e1:	0f b6 12             	movzbl (%rdx),%edx
  8012e4:	88 10                	mov    %dl,(%rax)
  8012e6:	0f b6 00             	movzbl (%rax),%eax
  8012e9:	84 c0                	test   %al,%al
  8012eb:	75 dc                	jne    8012c9 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8012ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012f1:	c9                   	leaveq 
  8012f2:	c3                   	retq   

00000000008012f3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8012f3:	55                   	push   %rbp
  8012f4:	48 89 e5             	mov    %rsp,%rbp
  8012f7:	48 83 ec 20          	sub    $0x20,%rsp
  8012fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801303:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801307:	48 89 c7             	mov    %rax,%rdi
  80130a:	48 b8 44 12 80 00 00 	movabs $0x801244,%rax
  801311:	00 00 00 
  801314:	ff d0                	callq  *%rax
  801316:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801319:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80131c:	48 63 d0             	movslq %eax,%rdx
  80131f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801323:	48 01 c2             	add    %rax,%rdx
  801326:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80132a:	48 89 c6             	mov    %rax,%rsi
  80132d:	48 89 d7             	mov    %rdx,%rdi
  801330:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  801337:	00 00 00 
  80133a:	ff d0                	callq  *%rax
	return dst;
  80133c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801340:	c9                   	leaveq 
  801341:	c3                   	retq   

0000000000801342 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801342:	55                   	push   %rbp
  801343:	48 89 e5             	mov    %rsp,%rbp
  801346:	48 83 ec 28          	sub    $0x28,%rsp
  80134a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80134e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801352:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801356:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80135e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801365:	00 
  801366:	eb 2a                	jmp    801392 <strncpy+0x50>
		*dst++ = *src;
  801368:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801370:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801374:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801378:	0f b6 12             	movzbl (%rdx),%edx
  80137b:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80137d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801381:	0f b6 00             	movzbl (%rax),%eax
  801384:	84 c0                	test   %al,%al
  801386:	74 05                	je     80138d <strncpy+0x4b>
			src++;
  801388:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80138d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801392:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801396:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80139a:	72 cc                	jb     801368 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80139c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013a0:	c9                   	leaveq 
  8013a1:	c3                   	retq   

00000000008013a2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013a2:	55                   	push   %rbp
  8013a3:	48 89 e5             	mov    %rsp,%rbp
  8013a6:	48 83 ec 28          	sub    $0x28,%rsp
  8013aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013b2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8013b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8013be:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013c3:	74 3d                	je     801402 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8013c5:	eb 1d                	jmp    8013e4 <strlcpy+0x42>
			*dst++ = *src++;
  8013c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013cb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013cf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013d3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013d7:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013db:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8013df:	0f b6 12             	movzbl (%rdx),%edx
  8013e2:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013e4:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8013e9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013ee:	74 0b                	je     8013fb <strlcpy+0x59>
  8013f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013f4:	0f b6 00             	movzbl (%rax),%eax
  8013f7:	84 c0                	test   %al,%al
  8013f9:	75 cc                	jne    8013c7 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8013fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ff:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801402:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801406:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140a:	48 29 c2             	sub    %rax,%rdx
  80140d:	48 89 d0             	mov    %rdx,%rax
}
  801410:	c9                   	leaveq 
  801411:	c3                   	retq   

0000000000801412 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801412:	55                   	push   %rbp
  801413:	48 89 e5             	mov    %rsp,%rbp
  801416:	48 83 ec 10          	sub    $0x10,%rsp
  80141a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80141e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801422:	eb 0a                	jmp    80142e <strcmp+0x1c>
		p++, q++;
  801424:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801429:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80142e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801432:	0f b6 00             	movzbl (%rax),%eax
  801435:	84 c0                	test   %al,%al
  801437:	74 12                	je     80144b <strcmp+0x39>
  801439:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143d:	0f b6 10             	movzbl (%rax),%edx
  801440:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801444:	0f b6 00             	movzbl (%rax),%eax
  801447:	38 c2                	cmp    %al,%dl
  801449:	74 d9                	je     801424 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80144b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144f:	0f b6 00             	movzbl (%rax),%eax
  801452:	0f b6 d0             	movzbl %al,%edx
  801455:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801459:	0f b6 00             	movzbl (%rax),%eax
  80145c:	0f b6 c0             	movzbl %al,%eax
  80145f:	29 c2                	sub    %eax,%edx
  801461:	89 d0                	mov    %edx,%eax
}
  801463:	c9                   	leaveq 
  801464:	c3                   	retq   

0000000000801465 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801465:	55                   	push   %rbp
  801466:	48 89 e5             	mov    %rsp,%rbp
  801469:	48 83 ec 18          	sub    $0x18,%rsp
  80146d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801471:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801475:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801479:	eb 0f                	jmp    80148a <strncmp+0x25>
		n--, p++, q++;
  80147b:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801480:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801485:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80148a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80148f:	74 1d                	je     8014ae <strncmp+0x49>
  801491:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801495:	0f b6 00             	movzbl (%rax),%eax
  801498:	84 c0                	test   %al,%al
  80149a:	74 12                	je     8014ae <strncmp+0x49>
  80149c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a0:	0f b6 10             	movzbl (%rax),%edx
  8014a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a7:	0f b6 00             	movzbl (%rax),%eax
  8014aa:	38 c2                	cmp    %al,%dl
  8014ac:	74 cd                	je     80147b <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014ae:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014b3:	75 07                	jne    8014bc <strncmp+0x57>
		return 0;
  8014b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ba:	eb 18                	jmp    8014d4 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c0:	0f b6 00             	movzbl (%rax),%eax
  8014c3:	0f b6 d0             	movzbl %al,%edx
  8014c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ca:	0f b6 00             	movzbl (%rax),%eax
  8014cd:	0f b6 c0             	movzbl %al,%eax
  8014d0:	29 c2                	sub    %eax,%edx
  8014d2:	89 d0                	mov    %edx,%eax
}
  8014d4:	c9                   	leaveq 
  8014d5:	c3                   	retq   

00000000008014d6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014d6:	55                   	push   %rbp
  8014d7:	48 89 e5             	mov    %rsp,%rbp
  8014da:	48 83 ec 0c          	sub    $0xc,%rsp
  8014de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014e2:	89 f0                	mov    %esi,%eax
  8014e4:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8014e7:	eb 17                	jmp    801500 <strchr+0x2a>
		if (*s == c)
  8014e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ed:	0f b6 00             	movzbl (%rax),%eax
  8014f0:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014f3:	75 06                	jne    8014fb <strchr+0x25>
			return (char *) s;
  8014f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f9:	eb 15                	jmp    801510 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014fb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801500:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801504:	0f b6 00             	movzbl (%rax),%eax
  801507:	84 c0                	test   %al,%al
  801509:	75 de                	jne    8014e9 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80150b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801510:	c9                   	leaveq 
  801511:	c3                   	retq   

0000000000801512 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801512:	55                   	push   %rbp
  801513:	48 89 e5             	mov    %rsp,%rbp
  801516:	48 83 ec 0c          	sub    $0xc,%rsp
  80151a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80151e:	89 f0                	mov    %esi,%eax
  801520:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801523:	eb 13                	jmp    801538 <strfind+0x26>
		if (*s == c)
  801525:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801529:	0f b6 00             	movzbl (%rax),%eax
  80152c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80152f:	75 02                	jne    801533 <strfind+0x21>
			break;
  801531:	eb 10                	jmp    801543 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801533:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801538:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153c:	0f b6 00             	movzbl (%rax),%eax
  80153f:	84 c0                	test   %al,%al
  801541:	75 e2                	jne    801525 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801543:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801547:	c9                   	leaveq 
  801548:	c3                   	retq   

0000000000801549 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801549:	55                   	push   %rbp
  80154a:	48 89 e5             	mov    %rsp,%rbp
  80154d:	48 83 ec 18          	sub    $0x18,%rsp
  801551:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801555:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801558:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80155c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801561:	75 06                	jne    801569 <memset+0x20>
		return v;
  801563:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801567:	eb 69                	jmp    8015d2 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801569:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80156d:	83 e0 03             	and    $0x3,%eax
  801570:	48 85 c0             	test   %rax,%rax
  801573:	75 48                	jne    8015bd <memset+0x74>
  801575:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801579:	83 e0 03             	and    $0x3,%eax
  80157c:	48 85 c0             	test   %rax,%rax
  80157f:	75 3c                	jne    8015bd <memset+0x74>
		c &= 0xFF;
  801581:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801588:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80158b:	c1 e0 18             	shl    $0x18,%eax
  80158e:	89 c2                	mov    %eax,%edx
  801590:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801593:	c1 e0 10             	shl    $0x10,%eax
  801596:	09 c2                	or     %eax,%edx
  801598:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80159b:	c1 e0 08             	shl    $0x8,%eax
  80159e:	09 d0                	or     %edx,%eax
  8015a0:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8015a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a7:	48 c1 e8 02          	shr    $0x2,%rax
  8015ab:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015ae:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015b2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015b5:	48 89 d7             	mov    %rdx,%rdi
  8015b8:	fc                   	cld    
  8015b9:	f3 ab                	rep stos %eax,%es:(%rdi)
  8015bb:	eb 11                	jmp    8015ce <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8015bd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015c4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8015c8:	48 89 d7             	mov    %rdx,%rdi
  8015cb:	fc                   	cld    
  8015cc:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8015ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015d2:	c9                   	leaveq 
  8015d3:	c3                   	retq   

00000000008015d4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8015d4:	55                   	push   %rbp
  8015d5:	48 89 e5             	mov    %rsp,%rbp
  8015d8:	48 83 ec 28          	sub    $0x28,%rsp
  8015dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8015e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015ec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8015f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8015f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015fc:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801600:	0f 83 88 00 00 00    	jae    80168e <memmove+0xba>
  801606:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80160e:	48 01 d0             	add    %rdx,%rax
  801611:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801615:	76 77                	jbe    80168e <memmove+0xba>
		s += n;
  801617:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80161f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801623:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801627:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162b:	83 e0 03             	and    $0x3,%eax
  80162e:	48 85 c0             	test   %rax,%rax
  801631:	75 3b                	jne    80166e <memmove+0x9a>
  801633:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801637:	83 e0 03             	and    $0x3,%eax
  80163a:	48 85 c0             	test   %rax,%rax
  80163d:	75 2f                	jne    80166e <memmove+0x9a>
  80163f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801643:	83 e0 03             	and    $0x3,%eax
  801646:	48 85 c0             	test   %rax,%rax
  801649:	75 23                	jne    80166e <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80164b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80164f:	48 83 e8 04          	sub    $0x4,%rax
  801653:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801657:	48 83 ea 04          	sub    $0x4,%rdx
  80165b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80165f:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801663:	48 89 c7             	mov    %rax,%rdi
  801666:	48 89 d6             	mov    %rdx,%rsi
  801669:	fd                   	std    
  80166a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80166c:	eb 1d                	jmp    80168b <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80166e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801672:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801676:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80167a:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80167e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801682:	48 89 d7             	mov    %rdx,%rdi
  801685:	48 89 c1             	mov    %rax,%rcx
  801688:	fd                   	std    
  801689:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80168b:	fc                   	cld    
  80168c:	eb 57                	jmp    8016e5 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80168e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801692:	83 e0 03             	and    $0x3,%eax
  801695:	48 85 c0             	test   %rax,%rax
  801698:	75 36                	jne    8016d0 <memmove+0xfc>
  80169a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80169e:	83 e0 03             	and    $0x3,%eax
  8016a1:	48 85 c0             	test   %rax,%rax
  8016a4:	75 2a                	jne    8016d0 <memmove+0xfc>
  8016a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016aa:	83 e0 03             	and    $0x3,%eax
  8016ad:	48 85 c0             	test   %rax,%rax
  8016b0:	75 1e                	jne    8016d0 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b6:	48 c1 e8 02          	shr    $0x2,%rax
  8016ba:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8016bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016c5:	48 89 c7             	mov    %rax,%rdi
  8016c8:	48 89 d6             	mov    %rdx,%rsi
  8016cb:	fc                   	cld    
  8016cc:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016ce:	eb 15                	jmp    8016e5 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8016d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016d8:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016dc:	48 89 c7             	mov    %rax,%rdi
  8016df:	48 89 d6             	mov    %rdx,%rsi
  8016e2:	fc                   	cld    
  8016e3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8016e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016e9:	c9                   	leaveq 
  8016ea:	c3                   	retq   

00000000008016eb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8016eb:	55                   	push   %rbp
  8016ec:	48 89 e5             	mov    %rsp,%rbp
  8016ef:	48 83 ec 18          	sub    $0x18,%rsp
  8016f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8016fb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8016ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801703:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801707:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80170b:	48 89 ce             	mov    %rcx,%rsi
  80170e:	48 89 c7             	mov    %rax,%rdi
  801711:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  801718:	00 00 00 
  80171b:	ff d0                	callq  *%rax
}
  80171d:	c9                   	leaveq 
  80171e:	c3                   	retq   

000000000080171f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80171f:	55                   	push   %rbp
  801720:	48 89 e5             	mov    %rsp,%rbp
  801723:	48 83 ec 28          	sub    $0x28,%rsp
  801727:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80172b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80172f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801733:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801737:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80173b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80173f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801743:	eb 36                	jmp    80177b <memcmp+0x5c>
		if (*s1 != *s2)
  801745:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801749:	0f b6 10             	movzbl (%rax),%edx
  80174c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801750:	0f b6 00             	movzbl (%rax),%eax
  801753:	38 c2                	cmp    %al,%dl
  801755:	74 1a                	je     801771 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801757:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80175b:	0f b6 00             	movzbl (%rax),%eax
  80175e:	0f b6 d0             	movzbl %al,%edx
  801761:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801765:	0f b6 00             	movzbl (%rax),%eax
  801768:	0f b6 c0             	movzbl %al,%eax
  80176b:	29 c2                	sub    %eax,%edx
  80176d:	89 d0                	mov    %edx,%eax
  80176f:	eb 20                	jmp    801791 <memcmp+0x72>
		s1++, s2++;
  801771:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801776:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80177b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801783:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801787:	48 85 c0             	test   %rax,%rax
  80178a:	75 b9                	jne    801745 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80178c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801791:	c9                   	leaveq 
  801792:	c3                   	retq   

0000000000801793 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801793:	55                   	push   %rbp
  801794:	48 89 e5             	mov    %rsp,%rbp
  801797:	48 83 ec 28          	sub    $0x28,%rsp
  80179b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80179f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017a2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ae:	48 01 d0             	add    %rdx,%rax
  8017b1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8017b5:	eb 15                	jmp    8017cc <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017bb:	0f b6 10             	movzbl (%rax),%edx
  8017be:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017c1:	38 c2                	cmp    %al,%dl
  8017c3:	75 02                	jne    8017c7 <memfind+0x34>
			break;
  8017c5:	eb 0f                	jmp    8017d6 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017c7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8017cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d0:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8017d4:	72 e1                	jb     8017b7 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8017d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017da:	c9                   	leaveq 
  8017db:	c3                   	retq   

00000000008017dc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8017dc:	55                   	push   %rbp
  8017dd:	48 89 e5             	mov    %rsp,%rbp
  8017e0:	48 83 ec 34          	sub    $0x34,%rsp
  8017e4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017e8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8017ec:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8017ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8017f6:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8017fd:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017fe:	eb 05                	jmp    801805 <strtol+0x29>
		s++;
  801800:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801805:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801809:	0f b6 00             	movzbl (%rax),%eax
  80180c:	3c 20                	cmp    $0x20,%al
  80180e:	74 f0                	je     801800 <strtol+0x24>
  801810:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801814:	0f b6 00             	movzbl (%rax),%eax
  801817:	3c 09                	cmp    $0x9,%al
  801819:	74 e5                	je     801800 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80181b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181f:	0f b6 00             	movzbl (%rax),%eax
  801822:	3c 2b                	cmp    $0x2b,%al
  801824:	75 07                	jne    80182d <strtol+0x51>
		s++;
  801826:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80182b:	eb 17                	jmp    801844 <strtol+0x68>
	else if (*s == '-')
  80182d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801831:	0f b6 00             	movzbl (%rax),%eax
  801834:	3c 2d                	cmp    $0x2d,%al
  801836:	75 0c                	jne    801844 <strtol+0x68>
		s++, neg = 1;
  801838:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80183d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801844:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801848:	74 06                	je     801850 <strtol+0x74>
  80184a:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80184e:	75 28                	jne    801878 <strtol+0x9c>
  801850:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801854:	0f b6 00             	movzbl (%rax),%eax
  801857:	3c 30                	cmp    $0x30,%al
  801859:	75 1d                	jne    801878 <strtol+0x9c>
  80185b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185f:	48 83 c0 01          	add    $0x1,%rax
  801863:	0f b6 00             	movzbl (%rax),%eax
  801866:	3c 78                	cmp    $0x78,%al
  801868:	75 0e                	jne    801878 <strtol+0x9c>
		s += 2, base = 16;
  80186a:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80186f:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801876:	eb 2c                	jmp    8018a4 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801878:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80187c:	75 19                	jne    801897 <strtol+0xbb>
  80187e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801882:	0f b6 00             	movzbl (%rax),%eax
  801885:	3c 30                	cmp    $0x30,%al
  801887:	75 0e                	jne    801897 <strtol+0xbb>
		s++, base = 8;
  801889:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80188e:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801895:	eb 0d                	jmp    8018a4 <strtol+0xc8>
	else if (base == 0)
  801897:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80189b:	75 07                	jne    8018a4 <strtol+0xc8>
		base = 10;
  80189d:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a8:	0f b6 00             	movzbl (%rax),%eax
  8018ab:	3c 2f                	cmp    $0x2f,%al
  8018ad:	7e 1d                	jle    8018cc <strtol+0xf0>
  8018af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b3:	0f b6 00             	movzbl (%rax),%eax
  8018b6:	3c 39                	cmp    $0x39,%al
  8018b8:	7f 12                	jg     8018cc <strtol+0xf0>
			dig = *s - '0';
  8018ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018be:	0f b6 00             	movzbl (%rax),%eax
  8018c1:	0f be c0             	movsbl %al,%eax
  8018c4:	83 e8 30             	sub    $0x30,%eax
  8018c7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018ca:	eb 4e                	jmp    80191a <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8018cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d0:	0f b6 00             	movzbl (%rax),%eax
  8018d3:	3c 60                	cmp    $0x60,%al
  8018d5:	7e 1d                	jle    8018f4 <strtol+0x118>
  8018d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018db:	0f b6 00             	movzbl (%rax),%eax
  8018de:	3c 7a                	cmp    $0x7a,%al
  8018e0:	7f 12                	jg     8018f4 <strtol+0x118>
			dig = *s - 'a' + 10;
  8018e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e6:	0f b6 00             	movzbl (%rax),%eax
  8018e9:	0f be c0             	movsbl %al,%eax
  8018ec:	83 e8 57             	sub    $0x57,%eax
  8018ef:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018f2:	eb 26                	jmp    80191a <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8018f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f8:	0f b6 00             	movzbl (%rax),%eax
  8018fb:	3c 40                	cmp    $0x40,%al
  8018fd:	7e 48                	jle    801947 <strtol+0x16b>
  8018ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801903:	0f b6 00             	movzbl (%rax),%eax
  801906:	3c 5a                	cmp    $0x5a,%al
  801908:	7f 3d                	jg     801947 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80190a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190e:	0f b6 00             	movzbl (%rax),%eax
  801911:	0f be c0             	movsbl %al,%eax
  801914:	83 e8 37             	sub    $0x37,%eax
  801917:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80191a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80191d:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801920:	7c 02                	jl     801924 <strtol+0x148>
			break;
  801922:	eb 23                	jmp    801947 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801924:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801929:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80192c:	48 98                	cltq   
  80192e:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801933:	48 89 c2             	mov    %rax,%rdx
  801936:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801939:	48 98                	cltq   
  80193b:	48 01 d0             	add    %rdx,%rax
  80193e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801942:	e9 5d ff ff ff       	jmpq   8018a4 <strtol+0xc8>

	if (endptr)
  801947:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80194c:	74 0b                	je     801959 <strtol+0x17d>
		*endptr = (char *) s;
  80194e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801952:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801956:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801959:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80195d:	74 09                	je     801968 <strtol+0x18c>
  80195f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801963:	48 f7 d8             	neg    %rax
  801966:	eb 04                	jmp    80196c <strtol+0x190>
  801968:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80196c:	c9                   	leaveq 
  80196d:	c3                   	retq   

000000000080196e <strstr>:

char * strstr(const char *in, const char *str)
{
  80196e:	55                   	push   %rbp
  80196f:	48 89 e5             	mov    %rsp,%rbp
  801972:	48 83 ec 30          	sub    $0x30,%rsp
  801976:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80197a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80197e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801982:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801986:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80198a:	0f b6 00             	movzbl (%rax),%eax
  80198d:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801990:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801994:	75 06                	jne    80199c <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801996:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199a:	eb 6b                	jmp    801a07 <strstr+0x99>

	len = strlen(str);
  80199c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019a0:	48 89 c7             	mov    %rax,%rdi
  8019a3:	48 b8 44 12 80 00 00 	movabs $0x801244,%rax
  8019aa:	00 00 00 
  8019ad:	ff d0                	callq  *%rax
  8019af:	48 98                	cltq   
  8019b1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8019b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019bd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8019c1:	0f b6 00             	movzbl (%rax),%eax
  8019c4:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8019c7:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8019cb:	75 07                	jne    8019d4 <strstr+0x66>
				return (char *) 0;
  8019cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d2:	eb 33                	jmp    801a07 <strstr+0x99>
		} while (sc != c);
  8019d4:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8019d8:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8019db:	75 d8                	jne    8019b5 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8019dd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019e1:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8019e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e9:	48 89 ce             	mov    %rcx,%rsi
  8019ec:	48 89 c7             	mov    %rax,%rdi
  8019ef:	48 b8 65 14 80 00 00 	movabs $0x801465,%rax
  8019f6:	00 00 00 
  8019f9:	ff d0                	callq  *%rax
  8019fb:	85 c0                	test   %eax,%eax
  8019fd:	75 b6                	jne    8019b5 <strstr+0x47>

	return (char *) (in - 1);
  8019ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a03:	48 83 e8 01          	sub    $0x1,%rax
}
  801a07:	c9                   	leaveq 
  801a08:	c3                   	retq   

0000000000801a09 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801a09:	55                   	push   %rbp
  801a0a:	48 89 e5             	mov    %rsp,%rbp
  801a0d:	53                   	push   %rbx
  801a0e:	48 83 ec 48          	sub    $0x48,%rsp
  801a12:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801a15:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801a18:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a1c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801a20:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801a24:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a28:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a2b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801a2f:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801a33:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801a37:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801a3b:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801a3f:	4c 89 c3             	mov    %r8,%rbx
  801a42:	cd 30                	int    $0x30
  801a44:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801a48:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801a4c:	74 3e                	je     801a8c <syscall+0x83>
  801a4e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a53:	7e 37                	jle    801a8c <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a55:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a59:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a5c:	49 89 d0             	mov    %rdx,%r8
  801a5f:	89 c1                	mov    %eax,%ecx
  801a61:	48 ba c8 4f 80 00 00 	movabs $0x804fc8,%rdx
  801a68:	00 00 00 
  801a6b:	be 23 00 00 00       	mov    $0x23,%esi
  801a70:	48 bf e5 4f 80 00 00 	movabs $0x804fe5,%rdi
  801a77:	00 00 00 
  801a7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a7f:	49 b9 c2 04 80 00 00 	movabs $0x8004c2,%r9
  801a86:	00 00 00 
  801a89:	41 ff d1             	callq  *%r9

	return ret;
  801a8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a90:	48 83 c4 48          	add    $0x48,%rsp
  801a94:	5b                   	pop    %rbx
  801a95:	5d                   	pop    %rbp
  801a96:	c3                   	retq   

0000000000801a97 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a97:	55                   	push   %rbp
  801a98:	48 89 e5             	mov    %rsp,%rbp
  801a9b:	48 83 ec 20          	sub    $0x20,%rsp
  801a9f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801aa3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801aa7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aaf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab6:	00 
  801ab7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801abd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac3:	48 89 d1             	mov    %rdx,%rcx
  801ac6:	48 89 c2             	mov    %rax,%rdx
  801ac9:	be 00 00 00 00       	mov    $0x0,%esi
  801ace:	bf 00 00 00 00       	mov    $0x0,%edi
  801ad3:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801ada:	00 00 00 
  801add:	ff d0                	callq  *%rax
}
  801adf:	c9                   	leaveq 
  801ae0:	c3                   	retq   

0000000000801ae1 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ae1:	55                   	push   %rbp
  801ae2:	48 89 e5             	mov    %rsp,%rbp
  801ae5:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801ae9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af0:	00 
  801af1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801afd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b02:	ba 00 00 00 00       	mov    $0x0,%edx
  801b07:	be 00 00 00 00       	mov    $0x0,%esi
  801b0c:	bf 01 00 00 00       	mov    $0x1,%edi
  801b11:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801b18:	00 00 00 
  801b1b:	ff d0                	callq  *%rax
}
  801b1d:	c9                   	leaveq 
  801b1e:	c3                   	retq   

0000000000801b1f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801b1f:	55                   	push   %rbp
  801b20:	48 89 e5             	mov    %rsp,%rbp
  801b23:	48 83 ec 10          	sub    $0x10,%rsp
  801b27:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801b2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b2d:	48 98                	cltq   
  801b2f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b36:	00 
  801b37:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b3d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b43:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b48:	48 89 c2             	mov    %rax,%rdx
  801b4b:	be 01 00 00 00       	mov    $0x1,%esi
  801b50:	bf 03 00 00 00       	mov    $0x3,%edi
  801b55:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801b5c:	00 00 00 
  801b5f:	ff d0                	callq  *%rax
}
  801b61:	c9                   	leaveq 
  801b62:	c3                   	retq   

0000000000801b63 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801b63:	55                   	push   %rbp
  801b64:	48 89 e5             	mov    %rsp,%rbp
  801b67:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801b6b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b72:	00 
  801b73:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b79:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b7f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b84:	ba 00 00 00 00       	mov    $0x0,%edx
  801b89:	be 00 00 00 00       	mov    $0x0,%esi
  801b8e:	bf 02 00 00 00       	mov    $0x2,%edi
  801b93:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801b9a:	00 00 00 
  801b9d:	ff d0                	callq  *%rax
}
  801b9f:	c9                   	leaveq 
  801ba0:	c3                   	retq   

0000000000801ba1 <sys_yield>:

void
sys_yield(void)
{
  801ba1:	55                   	push   %rbp
  801ba2:	48 89 e5             	mov    %rsp,%rbp
  801ba5:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ba9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb0:	00 
  801bb1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bb7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bbd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bc2:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc7:	be 00 00 00 00       	mov    $0x0,%esi
  801bcc:	bf 0b 00 00 00       	mov    $0xb,%edi
  801bd1:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801bd8:	00 00 00 
  801bdb:	ff d0                	callq  *%rax
}
  801bdd:	c9                   	leaveq 
  801bde:	c3                   	retq   

0000000000801bdf <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801bdf:	55                   	push   %rbp
  801be0:	48 89 e5             	mov    %rsp,%rbp
  801be3:	48 83 ec 20          	sub    $0x20,%rsp
  801be7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bee:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801bf1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bf4:	48 63 c8             	movslq %eax,%rcx
  801bf7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bfe:	48 98                	cltq   
  801c00:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c07:	00 
  801c08:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c0e:	49 89 c8             	mov    %rcx,%r8
  801c11:	48 89 d1             	mov    %rdx,%rcx
  801c14:	48 89 c2             	mov    %rax,%rdx
  801c17:	be 01 00 00 00       	mov    $0x1,%esi
  801c1c:	bf 04 00 00 00       	mov    $0x4,%edi
  801c21:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801c28:	00 00 00 
  801c2b:	ff d0                	callq  *%rax
}
  801c2d:	c9                   	leaveq 
  801c2e:	c3                   	retq   

0000000000801c2f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801c2f:	55                   	push   %rbp
  801c30:	48 89 e5             	mov    %rsp,%rbp
  801c33:	48 83 ec 30          	sub    $0x30,%rsp
  801c37:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c3a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c3e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801c41:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c45:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801c49:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c4c:	48 63 c8             	movslq %eax,%rcx
  801c4f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c53:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c56:	48 63 f0             	movslq %eax,%rsi
  801c59:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c60:	48 98                	cltq   
  801c62:	48 89 0c 24          	mov    %rcx,(%rsp)
  801c66:	49 89 f9             	mov    %rdi,%r9
  801c69:	49 89 f0             	mov    %rsi,%r8
  801c6c:	48 89 d1             	mov    %rdx,%rcx
  801c6f:	48 89 c2             	mov    %rax,%rdx
  801c72:	be 01 00 00 00       	mov    $0x1,%esi
  801c77:	bf 05 00 00 00       	mov    $0x5,%edi
  801c7c:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801c83:	00 00 00 
  801c86:	ff d0                	callq  *%rax
}
  801c88:	c9                   	leaveq 
  801c89:	c3                   	retq   

0000000000801c8a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801c8a:	55                   	push   %rbp
  801c8b:	48 89 e5             	mov    %rsp,%rbp
  801c8e:	48 83 ec 20          	sub    $0x20,%rsp
  801c92:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c95:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c99:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ca0:	48 98                	cltq   
  801ca2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca9:	00 
  801caa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cb0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cb6:	48 89 d1             	mov    %rdx,%rcx
  801cb9:	48 89 c2             	mov    %rax,%rdx
  801cbc:	be 01 00 00 00       	mov    $0x1,%esi
  801cc1:	bf 06 00 00 00       	mov    $0x6,%edi
  801cc6:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801ccd:	00 00 00 
  801cd0:	ff d0                	callq  *%rax
}
  801cd2:	c9                   	leaveq 
  801cd3:	c3                   	retq   

0000000000801cd4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801cd4:	55                   	push   %rbp
  801cd5:	48 89 e5             	mov    %rsp,%rbp
  801cd8:	48 83 ec 10          	sub    $0x10,%rsp
  801cdc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cdf:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ce2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ce5:	48 63 d0             	movslq %eax,%rdx
  801ce8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ceb:	48 98                	cltq   
  801ced:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cf4:	00 
  801cf5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cfb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d01:	48 89 d1             	mov    %rdx,%rcx
  801d04:	48 89 c2             	mov    %rax,%rdx
  801d07:	be 01 00 00 00       	mov    $0x1,%esi
  801d0c:	bf 08 00 00 00       	mov    $0x8,%edi
  801d11:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801d18:	00 00 00 
  801d1b:	ff d0                	callq  *%rax
}
  801d1d:	c9                   	leaveq 
  801d1e:	c3                   	retq   

0000000000801d1f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801d1f:	55                   	push   %rbp
  801d20:	48 89 e5             	mov    %rsp,%rbp
  801d23:	48 83 ec 20          	sub    $0x20,%rsp
  801d27:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d2a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801d2e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d35:	48 98                	cltq   
  801d37:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d3e:	00 
  801d3f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d45:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d4b:	48 89 d1             	mov    %rdx,%rcx
  801d4e:	48 89 c2             	mov    %rax,%rdx
  801d51:	be 01 00 00 00       	mov    $0x1,%esi
  801d56:	bf 09 00 00 00       	mov    $0x9,%edi
  801d5b:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801d62:	00 00 00 
  801d65:	ff d0                	callq  *%rax
}
  801d67:	c9                   	leaveq 
  801d68:	c3                   	retq   

0000000000801d69 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801d69:	55                   	push   %rbp
  801d6a:	48 89 e5             	mov    %rsp,%rbp
  801d6d:	48 83 ec 20          	sub    $0x20,%rsp
  801d71:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d74:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801d78:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d7f:	48 98                	cltq   
  801d81:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d88:	00 
  801d89:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d8f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d95:	48 89 d1             	mov    %rdx,%rcx
  801d98:	48 89 c2             	mov    %rax,%rdx
  801d9b:	be 01 00 00 00       	mov    $0x1,%esi
  801da0:	bf 0a 00 00 00       	mov    $0xa,%edi
  801da5:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801dac:	00 00 00 
  801daf:	ff d0                	callq  *%rax
}
  801db1:	c9                   	leaveq 
  801db2:	c3                   	retq   

0000000000801db3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801db3:	55                   	push   %rbp
  801db4:	48 89 e5             	mov    %rsp,%rbp
  801db7:	48 83 ec 20          	sub    $0x20,%rsp
  801dbb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dbe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801dc2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801dc6:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801dc9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dcc:	48 63 f0             	movslq %eax,%rsi
  801dcf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801dd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dd6:	48 98                	cltq   
  801dd8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ddc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801de3:	00 
  801de4:	49 89 f1             	mov    %rsi,%r9
  801de7:	49 89 c8             	mov    %rcx,%r8
  801dea:	48 89 d1             	mov    %rdx,%rcx
  801ded:	48 89 c2             	mov    %rax,%rdx
  801df0:	be 00 00 00 00       	mov    $0x0,%esi
  801df5:	bf 0c 00 00 00       	mov    $0xc,%edi
  801dfa:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801e01:	00 00 00 
  801e04:	ff d0                	callq  *%rax
}
  801e06:	c9                   	leaveq 
  801e07:	c3                   	retq   

0000000000801e08 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801e08:	55                   	push   %rbp
  801e09:	48 89 e5             	mov    %rsp,%rbp
  801e0c:	48 83 ec 10          	sub    $0x10,%rsp
  801e10:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801e14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e18:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e1f:	00 
  801e20:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e26:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e31:	48 89 c2             	mov    %rax,%rdx
  801e34:	be 01 00 00 00       	mov    $0x1,%esi
  801e39:	bf 0d 00 00 00       	mov    $0xd,%edi
  801e3e:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801e45:	00 00 00 
  801e48:	ff d0                	callq  *%rax
}
  801e4a:	c9                   	leaveq 
  801e4b:	c3                   	retq   

0000000000801e4c <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801e4c:	55                   	push   %rbp
  801e4d:	48 89 e5             	mov    %rsp,%rbp
  801e50:	48 83 ec 20          	sub    $0x20,%rsp
  801e54:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e58:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801e5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e60:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e64:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e6b:	00 
  801e6c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e72:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e78:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e7d:	89 c6                	mov    %eax,%esi
  801e7f:	bf 0f 00 00 00       	mov    $0xf,%edi
  801e84:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801e8b:	00 00 00 
  801e8e:	ff d0                	callq  *%rax
}
  801e90:	c9                   	leaveq 
  801e91:	c3                   	retq   

0000000000801e92 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801e92:	55                   	push   %rbp
  801e93:	48 89 e5             	mov    %rsp,%rbp
  801e96:	48 83 ec 20          	sub    $0x20,%rsp
  801e9a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e9e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801ea2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eaa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eb1:	00 
  801eb2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eb8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ebe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ec3:	89 c6                	mov    %eax,%esi
  801ec5:	bf 10 00 00 00       	mov    $0x10,%edi
  801eca:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801ed1:	00 00 00 
  801ed4:	ff d0                	callq  *%rax
}
  801ed6:	c9                   	leaveq 
  801ed7:	c3                   	retq   

0000000000801ed8 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801ed8:	55                   	push   %rbp
  801ed9:	48 89 e5             	mov    %rsp,%rbp
  801edc:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801ee0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ee7:	00 
  801ee8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ef4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ef9:	ba 00 00 00 00       	mov    $0x0,%edx
  801efe:	be 00 00 00 00       	mov    $0x0,%esi
  801f03:	bf 0e 00 00 00       	mov    $0xe,%edi
  801f08:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801f0f:	00 00 00 
  801f12:	ff d0                	callq  *%rax
}
  801f14:	c9                   	leaveq 
  801f15:	c3                   	retq   

0000000000801f16 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801f16:	55                   	push   %rbp
  801f17:	48 89 e5             	mov    %rsp,%rbp
  801f1a:	48 83 ec 30          	sub    $0x30,%rsp
  801f1e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801f22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f26:	48 8b 00             	mov    (%rax),%rax
  801f29:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801f2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f31:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f35:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801f38:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f3b:	83 e0 02             	and    $0x2,%eax
  801f3e:	85 c0                	test   %eax,%eax
  801f40:	75 4d                	jne    801f8f <pgfault+0x79>
  801f42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f46:	48 c1 e8 0c          	shr    $0xc,%rax
  801f4a:	48 89 c2             	mov    %rax,%rdx
  801f4d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f54:	01 00 00 
  801f57:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f5b:	25 00 08 00 00       	and    $0x800,%eax
  801f60:	48 85 c0             	test   %rax,%rax
  801f63:	74 2a                	je     801f8f <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801f65:	48 ba f8 4f 80 00 00 	movabs $0x804ff8,%rdx
  801f6c:	00 00 00 
  801f6f:	be 23 00 00 00       	mov    $0x23,%esi
  801f74:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  801f7b:	00 00 00 
  801f7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f83:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  801f8a:	00 00 00 
  801f8d:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801f8f:	ba 07 00 00 00       	mov    $0x7,%edx
  801f94:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f99:	bf 00 00 00 00       	mov    $0x0,%edi
  801f9e:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  801fa5:	00 00 00 
  801fa8:	ff d0                	callq  *%rax
  801faa:	85 c0                	test   %eax,%eax
  801fac:	0f 85 cd 00 00 00    	jne    80207f <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801fb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fb6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801fba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fbe:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801fc4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801fc8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fcc:	ba 00 10 00 00       	mov    $0x1000,%edx
  801fd1:	48 89 c6             	mov    %rax,%rsi
  801fd4:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801fd9:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  801fe0:	00 00 00 
  801fe3:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801fe5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fe9:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801fef:	48 89 c1             	mov    %rax,%rcx
  801ff2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff7:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ffc:	bf 00 00 00 00       	mov    $0x0,%edi
  802001:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  802008:	00 00 00 
  80200b:	ff d0                	callq  *%rax
  80200d:	85 c0                	test   %eax,%eax
  80200f:	79 2a                	jns    80203b <pgfault+0x125>
				panic("Page map at temp address failed");
  802011:	48 ba 38 50 80 00 00 	movabs $0x805038,%rdx
  802018:	00 00 00 
  80201b:	be 30 00 00 00       	mov    $0x30,%esi
  802020:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  802027:	00 00 00 
  80202a:	b8 00 00 00 00       	mov    $0x0,%eax
  80202f:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  802036:	00 00 00 
  802039:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  80203b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802040:	bf 00 00 00 00       	mov    $0x0,%edi
  802045:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  80204c:	00 00 00 
  80204f:	ff d0                	callq  *%rax
  802051:	85 c0                	test   %eax,%eax
  802053:	79 54                	jns    8020a9 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  802055:	48 ba 58 50 80 00 00 	movabs $0x805058,%rdx
  80205c:	00 00 00 
  80205f:	be 32 00 00 00       	mov    $0x32,%esi
  802064:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  80206b:	00 00 00 
  80206e:	b8 00 00 00 00       	mov    $0x0,%eax
  802073:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  80207a:	00 00 00 
  80207d:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  80207f:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802086:	00 00 00 
  802089:	be 34 00 00 00       	mov    $0x34,%esi
  80208e:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  802095:	00 00 00 
  802098:	b8 00 00 00 00       	mov    $0x0,%eax
  80209d:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  8020a4:	00 00 00 
  8020a7:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  8020a9:	c9                   	leaveq 
  8020aa:	c3                   	retq   

00000000008020ab <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8020ab:	55                   	push   %rbp
  8020ac:	48 89 e5             	mov    %rsp,%rbp
  8020af:	48 83 ec 20          	sub    $0x20,%rsp
  8020b3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020b6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  8020b9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020c0:	01 00 00 
  8020c3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8020c6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ca:	25 07 0e 00 00       	and    $0xe07,%eax
  8020cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  8020d2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020d5:	48 c1 e0 0c          	shl    $0xc,%rax
  8020d9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  8020dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020e0:	25 00 04 00 00       	and    $0x400,%eax
  8020e5:	85 c0                	test   %eax,%eax
  8020e7:	74 57                	je     802140 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8020e9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8020ec:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8020f0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020f7:	41 89 f0             	mov    %esi,%r8d
  8020fa:	48 89 c6             	mov    %rax,%rsi
  8020fd:	bf 00 00 00 00       	mov    $0x0,%edi
  802102:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  802109:	00 00 00 
  80210c:	ff d0                	callq  *%rax
  80210e:	85 c0                	test   %eax,%eax
  802110:	0f 8e 52 01 00 00    	jle    802268 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802116:	48 ba b2 50 80 00 00 	movabs $0x8050b2,%rdx
  80211d:	00 00 00 
  802120:	be 4e 00 00 00       	mov    $0x4e,%esi
  802125:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  80212c:	00 00 00 
  80212f:	b8 00 00 00 00       	mov    $0x0,%eax
  802134:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  80213b:	00 00 00 
  80213e:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  802140:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802143:	83 e0 02             	and    $0x2,%eax
  802146:	85 c0                	test   %eax,%eax
  802148:	75 10                	jne    80215a <duppage+0xaf>
  80214a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80214d:	25 00 08 00 00       	and    $0x800,%eax
  802152:	85 c0                	test   %eax,%eax
  802154:	0f 84 bb 00 00 00    	je     802215 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  80215a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80215d:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  802162:	80 cc 08             	or     $0x8,%ah
  802165:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802168:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80216b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80216f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802172:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802176:	41 89 f0             	mov    %esi,%r8d
  802179:	48 89 c6             	mov    %rax,%rsi
  80217c:	bf 00 00 00 00       	mov    $0x0,%edi
  802181:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  802188:	00 00 00 
  80218b:	ff d0                	callq  *%rax
  80218d:	85 c0                	test   %eax,%eax
  80218f:	7e 2a                	jle    8021bb <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  802191:	48 ba b2 50 80 00 00 	movabs $0x8050b2,%rdx
  802198:	00 00 00 
  80219b:	be 55 00 00 00       	mov    $0x55,%esi
  8021a0:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  8021a7:	00 00 00 
  8021aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8021af:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  8021b6:	00 00 00 
  8021b9:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8021bb:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8021be:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021c6:	41 89 c8             	mov    %ecx,%r8d
  8021c9:	48 89 d1             	mov    %rdx,%rcx
  8021cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8021d1:	48 89 c6             	mov    %rax,%rsi
  8021d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d9:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  8021e0:	00 00 00 
  8021e3:	ff d0                	callq  *%rax
  8021e5:	85 c0                	test   %eax,%eax
  8021e7:	7e 2a                	jle    802213 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  8021e9:	48 ba b2 50 80 00 00 	movabs $0x8050b2,%rdx
  8021f0:	00 00 00 
  8021f3:	be 57 00 00 00       	mov    $0x57,%esi
  8021f8:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  8021ff:	00 00 00 
  802202:	b8 00 00 00 00       	mov    $0x0,%eax
  802207:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  80220e:	00 00 00 
  802211:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802213:	eb 53                	jmp    802268 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802215:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802218:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80221c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80221f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802223:	41 89 f0             	mov    %esi,%r8d
  802226:	48 89 c6             	mov    %rax,%rsi
  802229:	bf 00 00 00 00       	mov    $0x0,%edi
  80222e:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  802235:	00 00 00 
  802238:	ff d0                	callq  *%rax
  80223a:	85 c0                	test   %eax,%eax
  80223c:	7e 2a                	jle    802268 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  80223e:	48 ba b2 50 80 00 00 	movabs $0x8050b2,%rdx
  802245:	00 00 00 
  802248:	be 5b 00 00 00       	mov    $0x5b,%esi
  80224d:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  802254:	00 00 00 
  802257:	b8 00 00 00 00       	mov    $0x0,%eax
  80225c:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  802263:	00 00 00 
  802266:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  802268:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80226d:	c9                   	leaveq 
  80226e:	c3                   	retq   

000000000080226f <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  80226f:	55                   	push   %rbp
  802270:	48 89 e5             	mov    %rsp,%rbp
  802273:	48 83 ec 18          	sub    $0x18,%rsp
  802277:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  80227b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80227f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  802283:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802287:	48 c1 e8 27          	shr    $0x27,%rax
  80228b:	48 89 c2             	mov    %rax,%rdx
  80228e:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802295:	01 00 00 
  802298:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80229c:	83 e0 01             	and    $0x1,%eax
  80229f:	48 85 c0             	test   %rax,%rax
  8022a2:	74 51                	je     8022f5 <pt_is_mapped+0x86>
  8022a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022a8:	48 c1 e0 0c          	shl    $0xc,%rax
  8022ac:	48 c1 e8 1e          	shr    $0x1e,%rax
  8022b0:	48 89 c2             	mov    %rax,%rdx
  8022b3:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8022ba:	01 00 00 
  8022bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022c1:	83 e0 01             	and    $0x1,%eax
  8022c4:	48 85 c0             	test   %rax,%rax
  8022c7:	74 2c                	je     8022f5 <pt_is_mapped+0x86>
  8022c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022cd:	48 c1 e0 0c          	shl    $0xc,%rax
  8022d1:	48 c1 e8 15          	shr    $0x15,%rax
  8022d5:	48 89 c2             	mov    %rax,%rdx
  8022d8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022df:	01 00 00 
  8022e2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022e6:	83 e0 01             	and    $0x1,%eax
  8022e9:	48 85 c0             	test   %rax,%rax
  8022ec:	74 07                	je     8022f5 <pt_is_mapped+0x86>
  8022ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f3:	eb 05                	jmp    8022fa <pt_is_mapped+0x8b>
  8022f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fa:	83 e0 01             	and    $0x1,%eax
}
  8022fd:	c9                   	leaveq 
  8022fe:	c3                   	retq   

00000000008022ff <fork>:

envid_t
fork(void)
{
  8022ff:	55                   	push   %rbp
  802300:	48 89 e5             	mov    %rsp,%rbp
  802303:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802307:	48 bf 16 1f 80 00 00 	movabs $0x801f16,%rdi
  80230e:	00 00 00 
  802311:	48 b8 3c 46 80 00 00 	movabs $0x80463c,%rax
  802318:	00 00 00 
  80231b:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80231d:	b8 07 00 00 00       	mov    $0x7,%eax
  802322:	cd 30                	int    $0x30
  802324:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802327:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  80232a:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  80232d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802331:	79 30                	jns    802363 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802333:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802336:	89 c1                	mov    %eax,%ecx
  802338:	48 ba d0 50 80 00 00 	movabs $0x8050d0,%rdx
  80233f:	00 00 00 
  802342:	be 86 00 00 00       	mov    $0x86,%esi
  802347:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  80234e:	00 00 00 
  802351:	b8 00 00 00 00       	mov    $0x0,%eax
  802356:	49 b8 c2 04 80 00 00 	movabs $0x8004c2,%r8
  80235d:	00 00 00 
  802360:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802363:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802367:	75 46                	jne    8023af <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  802369:	48 b8 63 1b 80 00 00 	movabs $0x801b63,%rax
  802370:	00 00 00 
  802373:	ff d0                	callq  *%rax
  802375:	25 ff 03 00 00       	and    $0x3ff,%eax
  80237a:	48 63 d0             	movslq %eax,%rdx
  80237d:	48 89 d0             	mov    %rdx,%rax
  802380:	48 c1 e0 03          	shl    $0x3,%rax
  802384:	48 01 d0             	add    %rdx,%rax
  802387:	48 c1 e0 05          	shl    $0x5,%rax
  80238b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802392:	00 00 00 
  802395:	48 01 c2             	add    %rax,%rdx
  802398:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80239f:	00 00 00 
  8023a2:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8023a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023aa:	e9 d1 01 00 00       	jmpq   802580 <fork+0x281>
	}
	uint64_t ad = 0;
  8023af:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8023b6:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8023b7:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8023bc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8023c0:	e9 df 00 00 00       	jmpq   8024a4 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8023c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023c9:	48 c1 e8 27          	shr    $0x27,%rax
  8023cd:	48 89 c2             	mov    %rax,%rdx
  8023d0:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8023d7:	01 00 00 
  8023da:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023de:	83 e0 01             	and    $0x1,%eax
  8023e1:	48 85 c0             	test   %rax,%rax
  8023e4:	0f 84 9e 00 00 00    	je     802488 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8023ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023ee:	48 c1 e8 1e          	shr    $0x1e,%rax
  8023f2:	48 89 c2             	mov    %rax,%rdx
  8023f5:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8023fc:	01 00 00 
  8023ff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802403:	83 e0 01             	and    $0x1,%eax
  802406:	48 85 c0             	test   %rax,%rax
  802409:	74 73                	je     80247e <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  80240b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80240f:	48 c1 e8 15          	shr    $0x15,%rax
  802413:	48 89 c2             	mov    %rax,%rdx
  802416:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80241d:	01 00 00 
  802420:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802424:	83 e0 01             	and    $0x1,%eax
  802427:	48 85 c0             	test   %rax,%rax
  80242a:	74 48                	je     802474 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  80242c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802430:	48 c1 e8 0c          	shr    $0xc,%rax
  802434:	48 89 c2             	mov    %rax,%rdx
  802437:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80243e:	01 00 00 
  802441:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802445:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802449:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80244d:	83 e0 01             	and    $0x1,%eax
  802450:	48 85 c0             	test   %rax,%rax
  802453:	74 47                	je     80249c <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802455:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802459:	48 c1 e8 0c          	shr    $0xc,%rax
  80245d:	89 c2                	mov    %eax,%edx
  80245f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802462:	89 d6                	mov    %edx,%esi
  802464:	89 c7                	mov    %eax,%edi
  802466:	48 b8 ab 20 80 00 00 	movabs $0x8020ab,%rax
  80246d:	00 00 00 
  802470:	ff d0                	callq  *%rax
  802472:	eb 28                	jmp    80249c <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  802474:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  80247b:	00 
  80247c:	eb 1e                	jmp    80249c <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  80247e:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  802485:	40 
  802486:	eb 14                	jmp    80249c <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  802488:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80248c:	48 c1 e8 27          	shr    $0x27,%rax
  802490:	48 83 c0 01          	add    $0x1,%rax
  802494:	48 c1 e0 27          	shl    $0x27,%rax
  802498:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80249c:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8024a3:	00 
  8024a4:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8024ab:	00 
  8024ac:	0f 87 13 ff ff ff    	ja     8023c5 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8024b2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024b5:	ba 07 00 00 00       	mov    $0x7,%edx
  8024ba:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8024bf:	89 c7                	mov    %eax,%edi
  8024c1:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  8024c8:	00 00 00 
  8024cb:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8024cd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024d0:	ba 07 00 00 00       	mov    $0x7,%edx
  8024d5:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8024da:	89 c7                	mov    %eax,%edi
  8024dc:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  8024e3:	00 00 00 
  8024e6:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8024e8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024eb:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8024f1:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8024f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8024fb:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802500:	89 c7                	mov    %eax,%edi
  802502:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  802509:	00 00 00 
  80250c:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  80250e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802513:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802518:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80251d:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  802524:	00 00 00 
  802527:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802529:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80252e:	bf 00 00 00 00       	mov    $0x0,%edi
  802533:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  80253a:	00 00 00 
  80253d:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  80253f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802546:	00 00 00 
  802549:	48 8b 00             	mov    (%rax),%rax
  80254c:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802553:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802556:	48 89 d6             	mov    %rdx,%rsi
  802559:	89 c7                	mov    %eax,%edi
  80255b:	48 b8 69 1d 80 00 00 	movabs $0x801d69,%rax
  802562:	00 00 00 
  802565:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802567:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80256a:	be 02 00 00 00       	mov    $0x2,%esi
  80256f:	89 c7                	mov    %eax,%edi
  802571:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  802578:	00 00 00 
  80257b:	ff d0                	callq  *%rax

	return envid;
  80257d:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802580:	c9                   	leaveq 
  802581:	c3                   	retq   

0000000000802582 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802582:	55                   	push   %rbp
  802583:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802586:	48 ba e8 50 80 00 00 	movabs $0x8050e8,%rdx
  80258d:	00 00 00 
  802590:	be bf 00 00 00       	mov    $0xbf,%esi
  802595:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  80259c:	00 00 00 
  80259f:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a4:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  8025ab:	00 00 00 
  8025ae:	ff d1                	callq  *%rcx

00000000008025b0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8025b0:	55                   	push   %rbp
  8025b1:	48 89 e5             	mov    %rsp,%rbp
  8025b4:	48 83 ec 08          	sub    $0x8,%rsp
  8025b8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8025bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025c0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8025c7:	ff ff ff 
  8025ca:	48 01 d0             	add    %rdx,%rax
  8025cd:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8025d1:	c9                   	leaveq 
  8025d2:	c3                   	retq   

00000000008025d3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8025d3:	55                   	push   %rbp
  8025d4:	48 89 e5             	mov    %rsp,%rbp
  8025d7:	48 83 ec 08          	sub    $0x8,%rsp
  8025db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8025df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025e3:	48 89 c7             	mov    %rax,%rdi
  8025e6:	48 b8 b0 25 80 00 00 	movabs $0x8025b0,%rax
  8025ed:	00 00 00 
  8025f0:	ff d0                	callq  *%rax
  8025f2:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8025f8:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8025fc:	c9                   	leaveq 
  8025fd:	c3                   	retq   

00000000008025fe <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8025fe:	55                   	push   %rbp
  8025ff:	48 89 e5             	mov    %rsp,%rbp
  802602:	48 83 ec 18          	sub    $0x18,%rsp
  802606:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80260a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802611:	eb 6b                	jmp    80267e <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802613:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802616:	48 98                	cltq   
  802618:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80261e:	48 c1 e0 0c          	shl    $0xc,%rax
  802622:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802626:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80262a:	48 c1 e8 15          	shr    $0x15,%rax
  80262e:	48 89 c2             	mov    %rax,%rdx
  802631:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802638:	01 00 00 
  80263b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80263f:	83 e0 01             	and    $0x1,%eax
  802642:	48 85 c0             	test   %rax,%rax
  802645:	74 21                	je     802668 <fd_alloc+0x6a>
  802647:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80264b:	48 c1 e8 0c          	shr    $0xc,%rax
  80264f:	48 89 c2             	mov    %rax,%rdx
  802652:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802659:	01 00 00 
  80265c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802660:	83 e0 01             	and    $0x1,%eax
  802663:	48 85 c0             	test   %rax,%rax
  802666:	75 12                	jne    80267a <fd_alloc+0x7c>
			*fd_store = fd;
  802668:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80266c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802670:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802673:	b8 00 00 00 00       	mov    $0x0,%eax
  802678:	eb 1a                	jmp    802694 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80267a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80267e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802682:	7e 8f                	jle    802613 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802688:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80268f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802694:	c9                   	leaveq 
  802695:	c3                   	retq   

0000000000802696 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802696:	55                   	push   %rbp
  802697:	48 89 e5             	mov    %rsp,%rbp
  80269a:	48 83 ec 20          	sub    $0x20,%rsp
  80269e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8026a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8026a9:	78 06                	js     8026b1 <fd_lookup+0x1b>
  8026ab:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8026af:	7e 07                	jle    8026b8 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8026b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026b6:	eb 6c                	jmp    802724 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8026b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026bb:	48 98                	cltq   
  8026bd:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026c3:	48 c1 e0 0c          	shl    $0xc,%rax
  8026c7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8026cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026cf:	48 c1 e8 15          	shr    $0x15,%rax
  8026d3:	48 89 c2             	mov    %rax,%rdx
  8026d6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026dd:	01 00 00 
  8026e0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026e4:	83 e0 01             	and    $0x1,%eax
  8026e7:	48 85 c0             	test   %rax,%rax
  8026ea:	74 21                	je     80270d <fd_lookup+0x77>
  8026ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026f0:	48 c1 e8 0c          	shr    $0xc,%rax
  8026f4:	48 89 c2             	mov    %rax,%rdx
  8026f7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026fe:	01 00 00 
  802701:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802705:	83 e0 01             	and    $0x1,%eax
  802708:	48 85 c0             	test   %rax,%rax
  80270b:	75 07                	jne    802714 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80270d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802712:	eb 10                	jmp    802724 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802714:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802718:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80271c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80271f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802724:	c9                   	leaveq 
  802725:	c3                   	retq   

0000000000802726 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802726:	55                   	push   %rbp
  802727:	48 89 e5             	mov    %rsp,%rbp
  80272a:	48 83 ec 30          	sub    $0x30,%rsp
  80272e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802732:	89 f0                	mov    %esi,%eax
  802734:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802737:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80273b:	48 89 c7             	mov    %rax,%rdi
  80273e:	48 b8 b0 25 80 00 00 	movabs $0x8025b0,%rax
  802745:	00 00 00 
  802748:	ff d0                	callq  *%rax
  80274a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80274e:	48 89 d6             	mov    %rdx,%rsi
  802751:	89 c7                	mov    %eax,%edi
  802753:	48 b8 96 26 80 00 00 	movabs $0x802696,%rax
  80275a:	00 00 00 
  80275d:	ff d0                	callq  *%rax
  80275f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802762:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802766:	78 0a                	js     802772 <fd_close+0x4c>
	    || fd != fd2)
  802768:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80276c:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802770:	74 12                	je     802784 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802772:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802776:	74 05                	je     80277d <fd_close+0x57>
  802778:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80277b:	eb 05                	jmp    802782 <fd_close+0x5c>
  80277d:	b8 00 00 00 00       	mov    $0x0,%eax
  802782:	eb 69                	jmp    8027ed <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802788:	8b 00                	mov    (%rax),%eax
  80278a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80278e:	48 89 d6             	mov    %rdx,%rsi
  802791:	89 c7                	mov    %eax,%edi
  802793:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  80279a:	00 00 00 
  80279d:	ff d0                	callq  *%rax
  80279f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a6:	78 2a                	js     8027d2 <fd_close+0xac>
		if (dev->dev_close)
  8027a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ac:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027b0:	48 85 c0             	test   %rax,%rax
  8027b3:	74 16                	je     8027cb <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8027b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b9:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027bd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027c1:	48 89 d7             	mov    %rdx,%rdi
  8027c4:	ff d0                	callq  *%rax
  8027c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c9:	eb 07                	jmp    8027d2 <fd_close+0xac>
		else
			r = 0;
  8027cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8027d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027d6:	48 89 c6             	mov    %rax,%rsi
  8027d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8027de:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  8027e5:	00 00 00 
  8027e8:	ff d0                	callq  *%rax
	return r;
  8027ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027ed:	c9                   	leaveq 
  8027ee:	c3                   	retq   

00000000008027ef <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8027ef:	55                   	push   %rbp
  8027f0:	48 89 e5             	mov    %rsp,%rbp
  8027f3:	48 83 ec 20          	sub    $0x20,%rsp
  8027f7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8027fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802805:	eb 41                	jmp    802848 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802807:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80280e:	00 00 00 
  802811:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802814:	48 63 d2             	movslq %edx,%rdx
  802817:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80281b:	8b 00                	mov    (%rax),%eax
  80281d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802820:	75 22                	jne    802844 <dev_lookup+0x55>
			*dev = devtab[i];
  802822:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802829:	00 00 00 
  80282c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80282f:	48 63 d2             	movslq %edx,%rdx
  802832:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802836:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80283a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80283d:	b8 00 00 00 00       	mov    $0x0,%eax
  802842:	eb 60                	jmp    8028a4 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802844:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802848:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80284f:	00 00 00 
  802852:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802855:	48 63 d2             	movslq %edx,%rdx
  802858:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80285c:	48 85 c0             	test   %rax,%rax
  80285f:	75 a6                	jne    802807 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802861:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802868:	00 00 00 
  80286b:	48 8b 00             	mov    (%rax),%rax
  80286e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802874:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802877:	89 c6                	mov    %eax,%esi
  802879:	48 bf 00 51 80 00 00 	movabs $0x805100,%rdi
  802880:	00 00 00 
  802883:	b8 00 00 00 00       	mov    $0x0,%eax
  802888:	48 b9 fb 06 80 00 00 	movabs $0x8006fb,%rcx
  80288f:	00 00 00 
  802892:	ff d1                	callq  *%rcx
	*dev = 0;
  802894:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802898:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80289f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8028a4:	c9                   	leaveq 
  8028a5:	c3                   	retq   

00000000008028a6 <close>:

int
close(int fdnum)
{
  8028a6:	55                   	push   %rbp
  8028a7:	48 89 e5             	mov    %rsp,%rbp
  8028aa:	48 83 ec 20          	sub    $0x20,%rsp
  8028ae:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028b1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028b5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028b8:	48 89 d6             	mov    %rdx,%rsi
  8028bb:	89 c7                	mov    %eax,%edi
  8028bd:	48 b8 96 26 80 00 00 	movabs $0x802696,%rax
  8028c4:	00 00 00 
  8028c7:	ff d0                	callq  *%rax
  8028c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d0:	79 05                	jns    8028d7 <close+0x31>
		return r;
  8028d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d5:	eb 18                	jmp    8028ef <close+0x49>
	else
		return fd_close(fd, 1);
  8028d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028db:	be 01 00 00 00       	mov    $0x1,%esi
  8028e0:	48 89 c7             	mov    %rax,%rdi
  8028e3:	48 b8 26 27 80 00 00 	movabs $0x802726,%rax
  8028ea:	00 00 00 
  8028ed:	ff d0                	callq  *%rax
}
  8028ef:	c9                   	leaveq 
  8028f0:	c3                   	retq   

00000000008028f1 <close_all>:

void
close_all(void)
{
  8028f1:	55                   	push   %rbp
  8028f2:	48 89 e5             	mov    %rsp,%rbp
  8028f5:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8028f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802900:	eb 15                	jmp    802917 <close_all+0x26>
		close(i);
  802902:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802905:	89 c7                	mov    %eax,%edi
  802907:	48 b8 a6 28 80 00 00 	movabs $0x8028a6,%rax
  80290e:	00 00 00 
  802911:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802913:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802917:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80291b:	7e e5                	jle    802902 <close_all+0x11>
		close(i);
}
  80291d:	c9                   	leaveq 
  80291e:	c3                   	retq   

000000000080291f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80291f:	55                   	push   %rbp
  802920:	48 89 e5             	mov    %rsp,%rbp
  802923:	48 83 ec 40          	sub    $0x40,%rsp
  802927:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80292a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80292d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802931:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802934:	48 89 d6             	mov    %rdx,%rsi
  802937:	89 c7                	mov    %eax,%edi
  802939:	48 b8 96 26 80 00 00 	movabs $0x802696,%rax
  802940:	00 00 00 
  802943:	ff d0                	callq  *%rax
  802945:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802948:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80294c:	79 08                	jns    802956 <dup+0x37>
		return r;
  80294e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802951:	e9 70 01 00 00       	jmpq   802ac6 <dup+0x1a7>
	close(newfdnum);
  802956:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802959:	89 c7                	mov    %eax,%edi
  80295b:	48 b8 a6 28 80 00 00 	movabs $0x8028a6,%rax
  802962:	00 00 00 
  802965:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802967:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80296a:	48 98                	cltq   
  80296c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802972:	48 c1 e0 0c          	shl    $0xc,%rax
  802976:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80297a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80297e:	48 89 c7             	mov    %rax,%rdi
  802981:	48 b8 d3 25 80 00 00 	movabs $0x8025d3,%rax
  802988:	00 00 00 
  80298b:	ff d0                	callq  *%rax
  80298d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802991:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802995:	48 89 c7             	mov    %rax,%rdi
  802998:	48 b8 d3 25 80 00 00 	movabs $0x8025d3,%rax
  80299f:	00 00 00 
  8029a2:	ff d0                	callq  *%rax
  8029a4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8029a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ac:	48 c1 e8 15          	shr    $0x15,%rax
  8029b0:	48 89 c2             	mov    %rax,%rdx
  8029b3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029ba:	01 00 00 
  8029bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029c1:	83 e0 01             	and    $0x1,%eax
  8029c4:	48 85 c0             	test   %rax,%rax
  8029c7:	74 73                	je     802a3c <dup+0x11d>
  8029c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029cd:	48 c1 e8 0c          	shr    $0xc,%rax
  8029d1:	48 89 c2             	mov    %rax,%rdx
  8029d4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029db:	01 00 00 
  8029de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029e2:	83 e0 01             	and    $0x1,%eax
  8029e5:	48 85 c0             	test   %rax,%rax
  8029e8:	74 52                	je     802a3c <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8029ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ee:	48 c1 e8 0c          	shr    $0xc,%rax
  8029f2:	48 89 c2             	mov    %rax,%rdx
  8029f5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029fc:	01 00 00 
  8029ff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a03:	25 07 0e 00 00       	and    $0xe07,%eax
  802a08:	89 c1                	mov    %eax,%ecx
  802a0a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a12:	41 89 c8             	mov    %ecx,%r8d
  802a15:	48 89 d1             	mov    %rdx,%rcx
  802a18:	ba 00 00 00 00       	mov    $0x0,%edx
  802a1d:	48 89 c6             	mov    %rax,%rsi
  802a20:	bf 00 00 00 00       	mov    $0x0,%edi
  802a25:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  802a2c:	00 00 00 
  802a2f:	ff d0                	callq  *%rax
  802a31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a38:	79 02                	jns    802a3c <dup+0x11d>
			goto err;
  802a3a:	eb 57                	jmp    802a93 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802a3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a40:	48 c1 e8 0c          	shr    $0xc,%rax
  802a44:	48 89 c2             	mov    %rax,%rdx
  802a47:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a4e:	01 00 00 
  802a51:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a55:	25 07 0e 00 00       	and    $0xe07,%eax
  802a5a:	89 c1                	mov    %eax,%ecx
  802a5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a60:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a64:	41 89 c8             	mov    %ecx,%r8d
  802a67:	48 89 d1             	mov    %rdx,%rcx
  802a6a:	ba 00 00 00 00       	mov    $0x0,%edx
  802a6f:	48 89 c6             	mov    %rax,%rsi
  802a72:	bf 00 00 00 00       	mov    $0x0,%edi
  802a77:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  802a7e:	00 00 00 
  802a81:	ff d0                	callq  *%rax
  802a83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a8a:	79 02                	jns    802a8e <dup+0x16f>
		goto err;
  802a8c:	eb 05                	jmp    802a93 <dup+0x174>

	return newfdnum;
  802a8e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a91:	eb 33                	jmp    802ac6 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802a93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a97:	48 89 c6             	mov    %rax,%rsi
  802a9a:	bf 00 00 00 00       	mov    $0x0,%edi
  802a9f:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  802aa6:	00 00 00 
  802aa9:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802aab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aaf:	48 89 c6             	mov    %rax,%rsi
  802ab2:	bf 00 00 00 00       	mov    $0x0,%edi
  802ab7:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  802abe:	00 00 00 
  802ac1:	ff d0                	callq  *%rax
	return r;
  802ac3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ac6:	c9                   	leaveq 
  802ac7:	c3                   	retq   

0000000000802ac8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802ac8:	55                   	push   %rbp
  802ac9:	48 89 e5             	mov    %rsp,%rbp
  802acc:	48 83 ec 40          	sub    $0x40,%rsp
  802ad0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ad3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ad7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802adb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802adf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ae2:	48 89 d6             	mov    %rdx,%rsi
  802ae5:	89 c7                	mov    %eax,%edi
  802ae7:	48 b8 96 26 80 00 00 	movabs $0x802696,%rax
  802aee:	00 00 00 
  802af1:	ff d0                	callq  *%rax
  802af3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802afa:	78 24                	js     802b20 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802afc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b00:	8b 00                	mov    (%rax),%eax
  802b02:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b06:	48 89 d6             	mov    %rdx,%rsi
  802b09:	89 c7                	mov    %eax,%edi
  802b0b:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  802b12:	00 00 00 
  802b15:	ff d0                	callq  *%rax
  802b17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b1e:	79 05                	jns    802b25 <read+0x5d>
		return r;
  802b20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b23:	eb 76                	jmp    802b9b <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802b25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b29:	8b 40 08             	mov    0x8(%rax),%eax
  802b2c:	83 e0 03             	and    $0x3,%eax
  802b2f:	83 f8 01             	cmp    $0x1,%eax
  802b32:	75 3a                	jne    802b6e <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802b34:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802b3b:	00 00 00 
  802b3e:	48 8b 00             	mov    (%rax),%rax
  802b41:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b47:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b4a:	89 c6                	mov    %eax,%esi
  802b4c:	48 bf 1f 51 80 00 00 	movabs $0x80511f,%rdi
  802b53:	00 00 00 
  802b56:	b8 00 00 00 00       	mov    $0x0,%eax
  802b5b:	48 b9 fb 06 80 00 00 	movabs $0x8006fb,%rcx
  802b62:	00 00 00 
  802b65:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b67:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b6c:	eb 2d                	jmp    802b9b <read+0xd3>
	}
	if (!dev->dev_read)
  802b6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b72:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b76:	48 85 c0             	test   %rax,%rax
  802b79:	75 07                	jne    802b82 <read+0xba>
		return -E_NOT_SUPP;
  802b7b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b80:	eb 19                	jmp    802b9b <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802b82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b86:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b8a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b8e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b92:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b96:	48 89 cf             	mov    %rcx,%rdi
  802b99:	ff d0                	callq  *%rax
}
  802b9b:	c9                   	leaveq 
  802b9c:	c3                   	retq   

0000000000802b9d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802b9d:	55                   	push   %rbp
  802b9e:	48 89 e5             	mov    %rsp,%rbp
  802ba1:	48 83 ec 30          	sub    $0x30,%rsp
  802ba5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ba8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bac:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802bb0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bb7:	eb 49                	jmp    802c02 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802bb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bbc:	48 98                	cltq   
  802bbe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bc2:	48 29 c2             	sub    %rax,%rdx
  802bc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc8:	48 63 c8             	movslq %eax,%rcx
  802bcb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bcf:	48 01 c1             	add    %rax,%rcx
  802bd2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bd5:	48 89 ce             	mov    %rcx,%rsi
  802bd8:	89 c7                	mov    %eax,%edi
  802bda:	48 b8 c8 2a 80 00 00 	movabs $0x802ac8,%rax
  802be1:	00 00 00 
  802be4:	ff d0                	callq  *%rax
  802be6:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802be9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bed:	79 05                	jns    802bf4 <readn+0x57>
			return m;
  802bef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bf2:	eb 1c                	jmp    802c10 <readn+0x73>
		if (m == 0)
  802bf4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bf8:	75 02                	jne    802bfc <readn+0x5f>
			break;
  802bfa:	eb 11                	jmp    802c0d <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802bfc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bff:	01 45 fc             	add    %eax,-0x4(%rbp)
  802c02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c05:	48 98                	cltq   
  802c07:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c0b:	72 ac                	jb     802bb9 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802c0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c10:	c9                   	leaveq 
  802c11:	c3                   	retq   

0000000000802c12 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802c12:	55                   	push   %rbp
  802c13:	48 89 e5             	mov    %rsp,%rbp
  802c16:	48 83 ec 40          	sub    $0x40,%rsp
  802c1a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c1d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c21:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c25:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c29:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c2c:	48 89 d6             	mov    %rdx,%rsi
  802c2f:	89 c7                	mov    %eax,%edi
  802c31:	48 b8 96 26 80 00 00 	movabs $0x802696,%rax
  802c38:	00 00 00 
  802c3b:	ff d0                	callq  *%rax
  802c3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c44:	78 24                	js     802c6a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c4a:	8b 00                	mov    (%rax),%eax
  802c4c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c50:	48 89 d6             	mov    %rdx,%rsi
  802c53:	89 c7                	mov    %eax,%edi
  802c55:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  802c5c:	00 00 00 
  802c5f:	ff d0                	callq  *%rax
  802c61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c68:	79 05                	jns    802c6f <write+0x5d>
		return r;
  802c6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c6d:	eb 75                	jmp    802ce4 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c73:	8b 40 08             	mov    0x8(%rax),%eax
  802c76:	83 e0 03             	and    $0x3,%eax
  802c79:	85 c0                	test   %eax,%eax
  802c7b:	75 3a                	jne    802cb7 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802c7d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802c84:	00 00 00 
  802c87:	48 8b 00             	mov    (%rax),%rax
  802c8a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c90:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c93:	89 c6                	mov    %eax,%esi
  802c95:	48 bf 3b 51 80 00 00 	movabs $0x80513b,%rdi
  802c9c:	00 00 00 
  802c9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca4:	48 b9 fb 06 80 00 00 	movabs $0x8006fb,%rcx
  802cab:	00 00 00 
  802cae:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802cb0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cb5:	eb 2d                	jmp    802ce4 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802cb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cbb:	48 8b 40 18          	mov    0x18(%rax),%rax
  802cbf:	48 85 c0             	test   %rax,%rax
  802cc2:	75 07                	jne    802ccb <write+0xb9>
		return -E_NOT_SUPP;
  802cc4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cc9:	eb 19                	jmp    802ce4 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802ccb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ccf:	48 8b 40 18          	mov    0x18(%rax),%rax
  802cd3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802cd7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cdb:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802cdf:	48 89 cf             	mov    %rcx,%rdi
  802ce2:	ff d0                	callq  *%rax
}
  802ce4:	c9                   	leaveq 
  802ce5:	c3                   	retq   

0000000000802ce6 <seek>:

int
seek(int fdnum, off_t offset)
{
  802ce6:	55                   	push   %rbp
  802ce7:	48 89 e5             	mov    %rsp,%rbp
  802cea:	48 83 ec 18          	sub    $0x18,%rsp
  802cee:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cf1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cf4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cf8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cfb:	48 89 d6             	mov    %rdx,%rsi
  802cfe:	89 c7                	mov    %eax,%edi
  802d00:	48 b8 96 26 80 00 00 	movabs $0x802696,%rax
  802d07:	00 00 00 
  802d0a:	ff d0                	callq  *%rax
  802d0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d13:	79 05                	jns    802d1a <seek+0x34>
		return r;
  802d15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d18:	eb 0f                	jmp    802d29 <seek+0x43>
	fd->fd_offset = offset;
  802d1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d1e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d21:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802d24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d29:	c9                   	leaveq 
  802d2a:	c3                   	retq   

0000000000802d2b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802d2b:	55                   	push   %rbp
  802d2c:	48 89 e5             	mov    %rsp,%rbp
  802d2f:	48 83 ec 30          	sub    $0x30,%rsp
  802d33:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d36:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d39:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d3d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d40:	48 89 d6             	mov    %rdx,%rsi
  802d43:	89 c7                	mov    %eax,%edi
  802d45:	48 b8 96 26 80 00 00 	movabs $0x802696,%rax
  802d4c:	00 00 00 
  802d4f:	ff d0                	callq  *%rax
  802d51:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d54:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d58:	78 24                	js     802d7e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d5e:	8b 00                	mov    (%rax),%eax
  802d60:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d64:	48 89 d6             	mov    %rdx,%rsi
  802d67:	89 c7                	mov    %eax,%edi
  802d69:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  802d70:	00 00 00 
  802d73:	ff d0                	callq  *%rax
  802d75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d7c:	79 05                	jns    802d83 <ftruncate+0x58>
		return r;
  802d7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d81:	eb 72                	jmp    802df5 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d87:	8b 40 08             	mov    0x8(%rax),%eax
  802d8a:	83 e0 03             	and    $0x3,%eax
  802d8d:	85 c0                	test   %eax,%eax
  802d8f:	75 3a                	jne    802dcb <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802d91:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802d98:	00 00 00 
  802d9b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802d9e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802da4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802da7:	89 c6                	mov    %eax,%esi
  802da9:	48 bf 58 51 80 00 00 	movabs $0x805158,%rdi
  802db0:	00 00 00 
  802db3:	b8 00 00 00 00       	mov    $0x0,%eax
  802db8:	48 b9 fb 06 80 00 00 	movabs $0x8006fb,%rcx
  802dbf:	00 00 00 
  802dc2:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802dc4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802dc9:	eb 2a                	jmp    802df5 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802dcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dcf:	48 8b 40 30          	mov    0x30(%rax),%rax
  802dd3:	48 85 c0             	test   %rax,%rax
  802dd6:	75 07                	jne    802ddf <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802dd8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ddd:	eb 16                	jmp    802df5 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802ddf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de3:	48 8b 40 30          	mov    0x30(%rax),%rax
  802de7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802deb:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802dee:	89 ce                	mov    %ecx,%esi
  802df0:	48 89 d7             	mov    %rdx,%rdi
  802df3:	ff d0                	callq  *%rax
}
  802df5:	c9                   	leaveq 
  802df6:	c3                   	retq   

0000000000802df7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802df7:	55                   	push   %rbp
  802df8:	48 89 e5             	mov    %rsp,%rbp
  802dfb:	48 83 ec 30          	sub    $0x30,%rsp
  802dff:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e02:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e06:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e0a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e0d:	48 89 d6             	mov    %rdx,%rsi
  802e10:	89 c7                	mov    %eax,%edi
  802e12:	48 b8 96 26 80 00 00 	movabs $0x802696,%rax
  802e19:	00 00 00 
  802e1c:	ff d0                	callq  *%rax
  802e1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e25:	78 24                	js     802e4b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e2b:	8b 00                	mov    (%rax),%eax
  802e2d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e31:	48 89 d6             	mov    %rdx,%rsi
  802e34:	89 c7                	mov    %eax,%edi
  802e36:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  802e3d:	00 00 00 
  802e40:	ff d0                	callq  *%rax
  802e42:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e45:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e49:	79 05                	jns    802e50 <fstat+0x59>
		return r;
  802e4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4e:	eb 5e                	jmp    802eae <fstat+0xb7>
	if (!dev->dev_stat)
  802e50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e54:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e58:	48 85 c0             	test   %rax,%rax
  802e5b:	75 07                	jne    802e64 <fstat+0x6d>
		return -E_NOT_SUPP;
  802e5d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e62:	eb 4a                	jmp    802eae <fstat+0xb7>
	stat->st_name[0] = 0;
  802e64:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e68:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802e6b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e6f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802e76:	00 00 00 
	stat->st_isdir = 0;
  802e79:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e7d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802e84:	00 00 00 
	stat->st_dev = dev;
  802e87:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e8b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e8f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802e96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e9a:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e9e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ea2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ea6:	48 89 ce             	mov    %rcx,%rsi
  802ea9:	48 89 d7             	mov    %rdx,%rdi
  802eac:	ff d0                	callq  *%rax
}
  802eae:	c9                   	leaveq 
  802eaf:	c3                   	retq   

0000000000802eb0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802eb0:	55                   	push   %rbp
  802eb1:	48 89 e5             	mov    %rsp,%rbp
  802eb4:	48 83 ec 20          	sub    $0x20,%rsp
  802eb8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ebc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802ec0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec4:	be 00 00 00 00       	mov    $0x0,%esi
  802ec9:	48 89 c7             	mov    %rax,%rdi
  802ecc:	48 b8 9e 2f 80 00 00 	movabs $0x802f9e,%rax
  802ed3:	00 00 00 
  802ed6:	ff d0                	callq  *%rax
  802ed8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802edb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802edf:	79 05                	jns    802ee6 <stat+0x36>
		return fd;
  802ee1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee4:	eb 2f                	jmp    802f15 <stat+0x65>
	r = fstat(fd, stat);
  802ee6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802eea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eed:	48 89 d6             	mov    %rdx,%rsi
  802ef0:	89 c7                	mov    %eax,%edi
  802ef2:	48 b8 f7 2d 80 00 00 	movabs $0x802df7,%rax
  802ef9:	00 00 00 
  802efc:	ff d0                	callq  *%rax
  802efe:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802f01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f04:	89 c7                	mov    %eax,%edi
  802f06:	48 b8 a6 28 80 00 00 	movabs $0x8028a6,%rax
  802f0d:	00 00 00 
  802f10:	ff d0                	callq  *%rax
	return r;
  802f12:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802f15:	c9                   	leaveq 
  802f16:	c3                   	retq   

0000000000802f17 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802f17:	55                   	push   %rbp
  802f18:	48 89 e5             	mov    %rsp,%rbp
  802f1b:	48 83 ec 10          	sub    $0x10,%rsp
  802f1f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f22:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802f26:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f2d:	00 00 00 
  802f30:	8b 00                	mov    (%rax),%eax
  802f32:	85 c0                	test   %eax,%eax
  802f34:	75 1d                	jne    802f53 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802f36:	bf 01 00 00 00       	mov    $0x1,%edi
  802f3b:	48 b8 e4 48 80 00 00 	movabs $0x8048e4,%rax
  802f42:	00 00 00 
  802f45:	ff d0                	callq  *%rax
  802f47:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802f4e:	00 00 00 
  802f51:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802f53:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f5a:	00 00 00 
  802f5d:	8b 00                	mov    (%rax),%eax
  802f5f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f62:	b9 07 00 00 00       	mov    $0x7,%ecx
  802f67:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802f6e:	00 00 00 
  802f71:	89 c7                	mov    %eax,%edi
  802f73:	48 b8 82 48 80 00 00 	movabs $0x804882,%rax
  802f7a:	00 00 00 
  802f7d:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802f7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f83:	ba 00 00 00 00       	mov    $0x0,%edx
  802f88:	48 89 c6             	mov    %rax,%rsi
  802f8b:	bf 00 00 00 00       	mov    $0x0,%edi
  802f90:	48 b8 7c 47 80 00 00 	movabs $0x80477c,%rax
  802f97:	00 00 00 
  802f9a:	ff d0                	callq  *%rax
}
  802f9c:	c9                   	leaveq 
  802f9d:	c3                   	retq   

0000000000802f9e <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802f9e:	55                   	push   %rbp
  802f9f:	48 89 e5             	mov    %rsp,%rbp
  802fa2:	48 83 ec 30          	sub    $0x30,%rsp
  802fa6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802faa:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802fad:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802fb4:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802fbb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802fc2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802fc7:	75 08                	jne    802fd1 <open+0x33>
	{
		return r;
  802fc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fcc:	e9 f2 00 00 00       	jmpq   8030c3 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802fd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fd5:	48 89 c7             	mov    %rax,%rdi
  802fd8:	48 b8 44 12 80 00 00 	movabs $0x801244,%rax
  802fdf:	00 00 00 
  802fe2:	ff d0                	callq  *%rax
  802fe4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802fe7:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802fee:	7e 0a                	jle    802ffa <open+0x5c>
	{
		return -E_BAD_PATH;
  802ff0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ff5:	e9 c9 00 00 00       	jmpq   8030c3 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802ffa:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803001:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  803002:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803006:	48 89 c7             	mov    %rax,%rdi
  803009:	48 b8 fe 25 80 00 00 	movabs $0x8025fe,%rax
  803010:	00 00 00 
  803013:	ff d0                	callq  *%rax
  803015:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803018:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80301c:	78 09                	js     803027 <open+0x89>
  80301e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803022:	48 85 c0             	test   %rax,%rax
  803025:	75 08                	jne    80302f <open+0x91>
		{
			return r;
  803027:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80302a:	e9 94 00 00 00       	jmpq   8030c3 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80302f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803033:	ba 00 04 00 00       	mov    $0x400,%edx
  803038:	48 89 c6             	mov    %rax,%rsi
  80303b:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803042:	00 00 00 
  803045:	48 b8 42 13 80 00 00 	movabs $0x801342,%rax
  80304c:	00 00 00 
  80304f:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  803051:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803058:	00 00 00 
  80305b:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80305e:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  803064:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803068:	48 89 c6             	mov    %rax,%rsi
  80306b:	bf 01 00 00 00       	mov    $0x1,%edi
  803070:	48 b8 17 2f 80 00 00 	movabs $0x802f17,%rax
  803077:	00 00 00 
  80307a:	ff d0                	callq  *%rax
  80307c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80307f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803083:	79 2b                	jns    8030b0 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  803085:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803089:	be 00 00 00 00       	mov    $0x0,%esi
  80308e:	48 89 c7             	mov    %rax,%rdi
  803091:	48 b8 26 27 80 00 00 	movabs $0x802726,%rax
  803098:	00 00 00 
  80309b:	ff d0                	callq  *%rax
  80309d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8030a0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8030a4:	79 05                	jns    8030ab <open+0x10d>
			{
				return d;
  8030a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030a9:	eb 18                	jmp    8030c3 <open+0x125>
			}
			return r;
  8030ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ae:	eb 13                	jmp    8030c3 <open+0x125>
		}	
		return fd2num(fd_store);
  8030b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b4:	48 89 c7             	mov    %rax,%rdi
  8030b7:	48 b8 b0 25 80 00 00 	movabs $0x8025b0,%rax
  8030be:	00 00 00 
  8030c1:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8030c3:	c9                   	leaveq 
  8030c4:	c3                   	retq   

00000000008030c5 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8030c5:	55                   	push   %rbp
  8030c6:	48 89 e5             	mov    %rsp,%rbp
  8030c9:	48 83 ec 10          	sub    $0x10,%rsp
  8030cd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8030d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030d5:	8b 50 0c             	mov    0xc(%rax),%edx
  8030d8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030df:	00 00 00 
  8030e2:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8030e4:	be 00 00 00 00       	mov    $0x0,%esi
  8030e9:	bf 06 00 00 00       	mov    $0x6,%edi
  8030ee:	48 b8 17 2f 80 00 00 	movabs $0x802f17,%rax
  8030f5:	00 00 00 
  8030f8:	ff d0                	callq  *%rax
}
  8030fa:	c9                   	leaveq 
  8030fb:	c3                   	retq   

00000000008030fc <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8030fc:	55                   	push   %rbp
  8030fd:	48 89 e5             	mov    %rsp,%rbp
  803100:	48 83 ec 30          	sub    $0x30,%rsp
  803104:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803108:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80310c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  803110:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  803117:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80311c:	74 07                	je     803125 <devfile_read+0x29>
  80311e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803123:	75 07                	jne    80312c <devfile_read+0x30>
		return -E_INVAL;
  803125:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80312a:	eb 77                	jmp    8031a3 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80312c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803130:	8b 50 0c             	mov    0xc(%rax),%edx
  803133:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80313a:	00 00 00 
  80313d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80313f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803146:	00 00 00 
  803149:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80314d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  803151:	be 00 00 00 00       	mov    $0x0,%esi
  803156:	bf 03 00 00 00       	mov    $0x3,%edi
  80315b:	48 b8 17 2f 80 00 00 	movabs $0x802f17,%rax
  803162:	00 00 00 
  803165:	ff d0                	callq  *%rax
  803167:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80316a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80316e:	7f 05                	jg     803175 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  803170:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803173:	eb 2e                	jmp    8031a3 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  803175:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803178:	48 63 d0             	movslq %eax,%rdx
  80317b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80317f:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803186:	00 00 00 
  803189:	48 89 c7             	mov    %rax,%rdi
  80318c:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  803193:	00 00 00 
  803196:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803198:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80319c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8031a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8031a3:	c9                   	leaveq 
  8031a4:	c3                   	retq   

00000000008031a5 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8031a5:	55                   	push   %rbp
  8031a6:	48 89 e5             	mov    %rsp,%rbp
  8031a9:	48 83 ec 30          	sub    $0x30,%rsp
  8031ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031b5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8031b9:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8031c0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8031c5:	74 07                	je     8031ce <devfile_write+0x29>
  8031c7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8031cc:	75 08                	jne    8031d6 <devfile_write+0x31>
		return r;
  8031ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d1:	e9 9a 00 00 00       	jmpq   803270 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8031d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031da:	8b 50 0c             	mov    0xc(%rax),%edx
  8031dd:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031e4:	00 00 00 
  8031e7:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8031e9:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8031f0:	00 
  8031f1:	76 08                	jbe    8031fb <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8031f3:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8031fa:	00 
	}
	fsipcbuf.write.req_n = n;
  8031fb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803202:	00 00 00 
  803205:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803209:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80320d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803211:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803215:	48 89 c6             	mov    %rax,%rsi
  803218:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  80321f:	00 00 00 
  803222:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  803229:	00 00 00 
  80322c:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80322e:	be 00 00 00 00       	mov    $0x0,%esi
  803233:	bf 04 00 00 00       	mov    $0x4,%edi
  803238:	48 b8 17 2f 80 00 00 	movabs $0x802f17,%rax
  80323f:	00 00 00 
  803242:	ff d0                	callq  *%rax
  803244:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803247:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80324b:	7f 20                	jg     80326d <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80324d:	48 bf 7e 51 80 00 00 	movabs $0x80517e,%rdi
  803254:	00 00 00 
  803257:	b8 00 00 00 00       	mov    $0x0,%eax
  80325c:	48 ba fb 06 80 00 00 	movabs $0x8006fb,%rdx
  803263:	00 00 00 
  803266:	ff d2                	callq  *%rdx
		return r;
  803268:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80326b:	eb 03                	jmp    803270 <devfile_write+0xcb>
	}
	return r;
  80326d:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803270:	c9                   	leaveq 
  803271:	c3                   	retq   

0000000000803272 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803272:	55                   	push   %rbp
  803273:	48 89 e5             	mov    %rsp,%rbp
  803276:	48 83 ec 20          	sub    $0x20,%rsp
  80327a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80327e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803282:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803286:	8b 50 0c             	mov    0xc(%rax),%edx
  803289:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803290:	00 00 00 
  803293:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803295:	be 00 00 00 00       	mov    $0x0,%esi
  80329a:	bf 05 00 00 00       	mov    $0x5,%edi
  80329f:	48 b8 17 2f 80 00 00 	movabs $0x802f17,%rax
  8032a6:	00 00 00 
  8032a9:	ff d0                	callq  *%rax
  8032ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032b2:	79 05                	jns    8032b9 <devfile_stat+0x47>
		return r;
  8032b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b7:	eb 56                	jmp    80330f <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8032b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032bd:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8032c4:	00 00 00 
  8032c7:	48 89 c7             	mov    %rax,%rdi
  8032ca:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  8032d1:	00 00 00 
  8032d4:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8032d6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032dd:	00 00 00 
  8032e0:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8032e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032ea:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8032f0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032f7:	00 00 00 
  8032fa:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803300:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803304:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80330a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80330f:	c9                   	leaveq 
  803310:	c3                   	retq   

0000000000803311 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803311:	55                   	push   %rbp
  803312:	48 89 e5             	mov    %rsp,%rbp
  803315:	48 83 ec 10          	sub    $0x10,%rsp
  803319:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80331d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803320:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803324:	8b 50 0c             	mov    0xc(%rax),%edx
  803327:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80332e:	00 00 00 
  803331:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803333:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80333a:	00 00 00 
  80333d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803340:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803343:	be 00 00 00 00       	mov    $0x0,%esi
  803348:	bf 02 00 00 00       	mov    $0x2,%edi
  80334d:	48 b8 17 2f 80 00 00 	movabs $0x802f17,%rax
  803354:	00 00 00 
  803357:	ff d0                	callq  *%rax
}
  803359:	c9                   	leaveq 
  80335a:	c3                   	retq   

000000000080335b <remove>:

// Delete a file
int
remove(const char *path)
{
  80335b:	55                   	push   %rbp
  80335c:	48 89 e5             	mov    %rsp,%rbp
  80335f:	48 83 ec 10          	sub    $0x10,%rsp
  803363:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803367:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80336b:	48 89 c7             	mov    %rax,%rdi
  80336e:	48 b8 44 12 80 00 00 	movabs $0x801244,%rax
  803375:	00 00 00 
  803378:	ff d0                	callq  *%rax
  80337a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80337f:	7e 07                	jle    803388 <remove+0x2d>
		return -E_BAD_PATH;
  803381:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803386:	eb 33                	jmp    8033bb <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803388:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80338c:	48 89 c6             	mov    %rax,%rsi
  80338f:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803396:	00 00 00 
  803399:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  8033a0:	00 00 00 
  8033a3:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8033a5:	be 00 00 00 00       	mov    $0x0,%esi
  8033aa:	bf 07 00 00 00       	mov    $0x7,%edi
  8033af:	48 b8 17 2f 80 00 00 	movabs $0x802f17,%rax
  8033b6:	00 00 00 
  8033b9:	ff d0                	callq  *%rax
}
  8033bb:	c9                   	leaveq 
  8033bc:	c3                   	retq   

00000000008033bd <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8033bd:	55                   	push   %rbp
  8033be:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8033c1:	be 00 00 00 00       	mov    $0x0,%esi
  8033c6:	bf 08 00 00 00       	mov    $0x8,%edi
  8033cb:	48 b8 17 2f 80 00 00 	movabs $0x802f17,%rax
  8033d2:	00 00 00 
  8033d5:	ff d0                	callq  *%rax
}
  8033d7:	5d                   	pop    %rbp
  8033d8:	c3                   	retq   

00000000008033d9 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8033d9:	55                   	push   %rbp
  8033da:	48 89 e5             	mov    %rsp,%rbp
  8033dd:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8033e4:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8033eb:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8033f2:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8033f9:	be 00 00 00 00       	mov    $0x0,%esi
  8033fe:	48 89 c7             	mov    %rax,%rdi
  803401:	48 b8 9e 2f 80 00 00 	movabs $0x802f9e,%rax
  803408:	00 00 00 
  80340b:	ff d0                	callq  *%rax
  80340d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803410:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803414:	79 28                	jns    80343e <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803416:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803419:	89 c6                	mov    %eax,%esi
  80341b:	48 bf 9a 51 80 00 00 	movabs $0x80519a,%rdi
  803422:	00 00 00 
  803425:	b8 00 00 00 00       	mov    $0x0,%eax
  80342a:	48 ba fb 06 80 00 00 	movabs $0x8006fb,%rdx
  803431:	00 00 00 
  803434:	ff d2                	callq  *%rdx
		return fd_src;
  803436:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803439:	e9 74 01 00 00       	jmpq   8035b2 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80343e:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803445:	be 01 01 00 00       	mov    $0x101,%esi
  80344a:	48 89 c7             	mov    %rax,%rdi
  80344d:	48 b8 9e 2f 80 00 00 	movabs $0x802f9e,%rax
  803454:	00 00 00 
  803457:	ff d0                	callq  *%rax
  803459:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80345c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803460:	79 39                	jns    80349b <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803462:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803465:	89 c6                	mov    %eax,%esi
  803467:	48 bf b0 51 80 00 00 	movabs $0x8051b0,%rdi
  80346e:	00 00 00 
  803471:	b8 00 00 00 00       	mov    $0x0,%eax
  803476:	48 ba fb 06 80 00 00 	movabs $0x8006fb,%rdx
  80347d:	00 00 00 
  803480:	ff d2                	callq  *%rdx
		close(fd_src);
  803482:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803485:	89 c7                	mov    %eax,%edi
  803487:	48 b8 a6 28 80 00 00 	movabs $0x8028a6,%rax
  80348e:	00 00 00 
  803491:	ff d0                	callq  *%rax
		return fd_dest;
  803493:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803496:	e9 17 01 00 00       	jmpq   8035b2 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80349b:	eb 74                	jmp    803511 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80349d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034a0:	48 63 d0             	movslq %eax,%rdx
  8034a3:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8034aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034ad:	48 89 ce             	mov    %rcx,%rsi
  8034b0:	89 c7                	mov    %eax,%edi
  8034b2:	48 b8 12 2c 80 00 00 	movabs $0x802c12,%rax
  8034b9:	00 00 00 
  8034bc:	ff d0                	callq  *%rax
  8034be:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8034c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8034c5:	79 4a                	jns    803511 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8034c7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8034ca:	89 c6                	mov    %eax,%esi
  8034cc:	48 bf ca 51 80 00 00 	movabs $0x8051ca,%rdi
  8034d3:	00 00 00 
  8034d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8034db:	48 ba fb 06 80 00 00 	movabs $0x8006fb,%rdx
  8034e2:	00 00 00 
  8034e5:	ff d2                	callq  *%rdx
			close(fd_src);
  8034e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ea:	89 c7                	mov    %eax,%edi
  8034ec:	48 b8 a6 28 80 00 00 	movabs $0x8028a6,%rax
  8034f3:	00 00 00 
  8034f6:	ff d0                	callq  *%rax
			close(fd_dest);
  8034f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034fb:	89 c7                	mov    %eax,%edi
  8034fd:	48 b8 a6 28 80 00 00 	movabs $0x8028a6,%rax
  803504:	00 00 00 
  803507:	ff d0                	callq  *%rax
			return write_size;
  803509:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80350c:	e9 a1 00 00 00       	jmpq   8035b2 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803511:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803518:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80351b:	ba 00 02 00 00       	mov    $0x200,%edx
  803520:	48 89 ce             	mov    %rcx,%rsi
  803523:	89 c7                	mov    %eax,%edi
  803525:	48 b8 c8 2a 80 00 00 	movabs $0x802ac8,%rax
  80352c:	00 00 00 
  80352f:	ff d0                	callq  *%rax
  803531:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803534:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803538:	0f 8f 5f ff ff ff    	jg     80349d <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80353e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803542:	79 47                	jns    80358b <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803544:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803547:	89 c6                	mov    %eax,%esi
  803549:	48 bf dd 51 80 00 00 	movabs $0x8051dd,%rdi
  803550:	00 00 00 
  803553:	b8 00 00 00 00       	mov    $0x0,%eax
  803558:	48 ba fb 06 80 00 00 	movabs $0x8006fb,%rdx
  80355f:	00 00 00 
  803562:	ff d2                	callq  *%rdx
		close(fd_src);
  803564:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803567:	89 c7                	mov    %eax,%edi
  803569:	48 b8 a6 28 80 00 00 	movabs $0x8028a6,%rax
  803570:	00 00 00 
  803573:	ff d0                	callq  *%rax
		close(fd_dest);
  803575:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803578:	89 c7                	mov    %eax,%edi
  80357a:	48 b8 a6 28 80 00 00 	movabs $0x8028a6,%rax
  803581:	00 00 00 
  803584:	ff d0                	callq  *%rax
		return read_size;
  803586:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803589:	eb 27                	jmp    8035b2 <copy+0x1d9>
	}
	close(fd_src);
  80358b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80358e:	89 c7                	mov    %eax,%edi
  803590:	48 b8 a6 28 80 00 00 	movabs $0x8028a6,%rax
  803597:	00 00 00 
  80359a:	ff d0                	callq  *%rax
	close(fd_dest);
  80359c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80359f:	89 c7                	mov    %eax,%edi
  8035a1:	48 b8 a6 28 80 00 00 	movabs $0x8028a6,%rax
  8035a8:	00 00 00 
  8035ab:	ff d0                	callq  *%rax
	return 0;
  8035ad:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8035b2:	c9                   	leaveq 
  8035b3:	c3                   	retq   

00000000008035b4 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8035b4:	55                   	push   %rbp
  8035b5:	48 89 e5             	mov    %rsp,%rbp
  8035b8:	48 83 ec 20          	sub    $0x20,%rsp
  8035bc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8035bf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8035c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035c6:	48 89 d6             	mov    %rdx,%rsi
  8035c9:	89 c7                	mov    %eax,%edi
  8035cb:	48 b8 96 26 80 00 00 	movabs $0x802696,%rax
  8035d2:	00 00 00 
  8035d5:	ff d0                	callq  *%rax
  8035d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035de:	79 05                	jns    8035e5 <fd2sockid+0x31>
		return r;
  8035e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e3:	eb 24                	jmp    803609 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8035e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035e9:	8b 10                	mov    (%rax),%edx
  8035eb:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8035f2:	00 00 00 
  8035f5:	8b 00                	mov    (%rax),%eax
  8035f7:	39 c2                	cmp    %eax,%edx
  8035f9:	74 07                	je     803602 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8035fb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803600:	eb 07                	jmp    803609 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803602:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803606:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803609:	c9                   	leaveq 
  80360a:	c3                   	retq   

000000000080360b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80360b:	55                   	push   %rbp
  80360c:	48 89 e5             	mov    %rsp,%rbp
  80360f:	48 83 ec 20          	sub    $0x20,%rsp
  803613:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803616:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80361a:	48 89 c7             	mov    %rax,%rdi
  80361d:	48 b8 fe 25 80 00 00 	movabs $0x8025fe,%rax
  803624:	00 00 00 
  803627:	ff d0                	callq  *%rax
  803629:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80362c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803630:	78 26                	js     803658 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803632:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803636:	ba 07 04 00 00       	mov    $0x407,%edx
  80363b:	48 89 c6             	mov    %rax,%rsi
  80363e:	bf 00 00 00 00       	mov    $0x0,%edi
  803643:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  80364a:	00 00 00 
  80364d:	ff d0                	callq  *%rax
  80364f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803652:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803656:	79 16                	jns    80366e <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803658:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80365b:	89 c7                	mov    %eax,%edi
  80365d:	48 b8 18 3b 80 00 00 	movabs $0x803b18,%rax
  803664:	00 00 00 
  803667:	ff d0                	callq  *%rax
		return r;
  803669:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80366c:	eb 3a                	jmp    8036a8 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80366e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803672:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803679:	00 00 00 
  80367c:	8b 12                	mov    (%rdx),%edx
  80367e:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803680:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803684:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80368b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80368f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803692:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803695:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803699:	48 89 c7             	mov    %rax,%rdi
  80369c:	48 b8 b0 25 80 00 00 	movabs $0x8025b0,%rax
  8036a3:	00 00 00 
  8036a6:	ff d0                	callq  *%rax
}
  8036a8:	c9                   	leaveq 
  8036a9:	c3                   	retq   

00000000008036aa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8036aa:	55                   	push   %rbp
  8036ab:	48 89 e5             	mov    %rsp,%rbp
  8036ae:	48 83 ec 30          	sub    $0x30,%rsp
  8036b2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036c0:	89 c7                	mov    %eax,%edi
  8036c2:	48 b8 b4 35 80 00 00 	movabs $0x8035b4,%rax
  8036c9:	00 00 00 
  8036cc:	ff d0                	callq  *%rax
  8036ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036d5:	79 05                	jns    8036dc <accept+0x32>
		return r;
  8036d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036da:	eb 3b                	jmp    803717 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8036dc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8036e0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8036e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036e7:	48 89 ce             	mov    %rcx,%rsi
  8036ea:	89 c7                	mov    %eax,%edi
  8036ec:	48 b8 f5 39 80 00 00 	movabs $0x8039f5,%rax
  8036f3:	00 00 00 
  8036f6:	ff d0                	callq  *%rax
  8036f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ff:	79 05                	jns    803706 <accept+0x5c>
		return r;
  803701:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803704:	eb 11                	jmp    803717 <accept+0x6d>
	return alloc_sockfd(r);
  803706:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803709:	89 c7                	mov    %eax,%edi
  80370b:	48 b8 0b 36 80 00 00 	movabs $0x80360b,%rax
  803712:	00 00 00 
  803715:	ff d0                	callq  *%rax
}
  803717:	c9                   	leaveq 
  803718:	c3                   	retq   

0000000000803719 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803719:	55                   	push   %rbp
  80371a:	48 89 e5             	mov    %rsp,%rbp
  80371d:	48 83 ec 20          	sub    $0x20,%rsp
  803721:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803724:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803728:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80372b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80372e:	89 c7                	mov    %eax,%edi
  803730:	48 b8 b4 35 80 00 00 	movabs $0x8035b4,%rax
  803737:	00 00 00 
  80373a:	ff d0                	callq  *%rax
  80373c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80373f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803743:	79 05                	jns    80374a <bind+0x31>
		return r;
  803745:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803748:	eb 1b                	jmp    803765 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80374a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80374d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803751:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803754:	48 89 ce             	mov    %rcx,%rsi
  803757:	89 c7                	mov    %eax,%edi
  803759:	48 b8 74 3a 80 00 00 	movabs $0x803a74,%rax
  803760:	00 00 00 
  803763:	ff d0                	callq  *%rax
}
  803765:	c9                   	leaveq 
  803766:	c3                   	retq   

0000000000803767 <shutdown>:

int
shutdown(int s, int how)
{
  803767:	55                   	push   %rbp
  803768:	48 89 e5             	mov    %rsp,%rbp
  80376b:	48 83 ec 20          	sub    $0x20,%rsp
  80376f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803772:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803775:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803778:	89 c7                	mov    %eax,%edi
  80377a:	48 b8 b4 35 80 00 00 	movabs $0x8035b4,%rax
  803781:	00 00 00 
  803784:	ff d0                	callq  *%rax
  803786:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803789:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80378d:	79 05                	jns    803794 <shutdown+0x2d>
		return r;
  80378f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803792:	eb 16                	jmp    8037aa <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803794:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803797:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80379a:	89 d6                	mov    %edx,%esi
  80379c:	89 c7                	mov    %eax,%edi
  80379e:	48 b8 d8 3a 80 00 00 	movabs $0x803ad8,%rax
  8037a5:	00 00 00 
  8037a8:	ff d0                	callq  *%rax
}
  8037aa:	c9                   	leaveq 
  8037ab:	c3                   	retq   

00000000008037ac <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8037ac:	55                   	push   %rbp
  8037ad:	48 89 e5             	mov    %rsp,%rbp
  8037b0:	48 83 ec 10          	sub    $0x10,%rsp
  8037b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8037b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037bc:	48 89 c7             	mov    %rax,%rdi
  8037bf:	48 b8 66 49 80 00 00 	movabs $0x804966,%rax
  8037c6:	00 00 00 
  8037c9:	ff d0                	callq  *%rax
  8037cb:	83 f8 01             	cmp    $0x1,%eax
  8037ce:	75 17                	jne    8037e7 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8037d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037d4:	8b 40 0c             	mov    0xc(%rax),%eax
  8037d7:	89 c7                	mov    %eax,%edi
  8037d9:	48 b8 18 3b 80 00 00 	movabs $0x803b18,%rax
  8037e0:	00 00 00 
  8037e3:	ff d0                	callq  *%rax
  8037e5:	eb 05                	jmp    8037ec <devsock_close+0x40>
	else
		return 0;
  8037e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037ec:	c9                   	leaveq 
  8037ed:	c3                   	retq   

00000000008037ee <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8037ee:	55                   	push   %rbp
  8037ef:	48 89 e5             	mov    %rsp,%rbp
  8037f2:	48 83 ec 20          	sub    $0x20,%rsp
  8037f6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037fd:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803800:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803803:	89 c7                	mov    %eax,%edi
  803805:	48 b8 b4 35 80 00 00 	movabs $0x8035b4,%rax
  80380c:	00 00 00 
  80380f:	ff d0                	callq  *%rax
  803811:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803814:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803818:	79 05                	jns    80381f <connect+0x31>
		return r;
  80381a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80381d:	eb 1b                	jmp    80383a <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80381f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803822:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803826:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803829:	48 89 ce             	mov    %rcx,%rsi
  80382c:	89 c7                	mov    %eax,%edi
  80382e:	48 b8 45 3b 80 00 00 	movabs $0x803b45,%rax
  803835:	00 00 00 
  803838:	ff d0                	callq  *%rax
}
  80383a:	c9                   	leaveq 
  80383b:	c3                   	retq   

000000000080383c <listen>:

int
listen(int s, int backlog)
{
  80383c:	55                   	push   %rbp
  80383d:	48 89 e5             	mov    %rsp,%rbp
  803840:	48 83 ec 20          	sub    $0x20,%rsp
  803844:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803847:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80384a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80384d:	89 c7                	mov    %eax,%edi
  80384f:	48 b8 b4 35 80 00 00 	movabs $0x8035b4,%rax
  803856:	00 00 00 
  803859:	ff d0                	callq  *%rax
  80385b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80385e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803862:	79 05                	jns    803869 <listen+0x2d>
		return r;
  803864:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803867:	eb 16                	jmp    80387f <listen+0x43>
	return nsipc_listen(r, backlog);
  803869:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80386c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80386f:	89 d6                	mov    %edx,%esi
  803871:	89 c7                	mov    %eax,%edi
  803873:	48 b8 a9 3b 80 00 00 	movabs $0x803ba9,%rax
  80387a:	00 00 00 
  80387d:	ff d0                	callq  *%rax
}
  80387f:	c9                   	leaveq 
  803880:	c3                   	retq   

0000000000803881 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803881:	55                   	push   %rbp
  803882:	48 89 e5             	mov    %rsp,%rbp
  803885:	48 83 ec 20          	sub    $0x20,%rsp
  803889:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80388d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803891:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803895:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803899:	89 c2                	mov    %eax,%edx
  80389b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80389f:	8b 40 0c             	mov    0xc(%rax),%eax
  8038a2:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8038a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8038ab:	89 c7                	mov    %eax,%edi
  8038ad:	48 b8 e9 3b 80 00 00 	movabs $0x803be9,%rax
  8038b4:	00 00 00 
  8038b7:	ff d0                	callq  *%rax
}
  8038b9:	c9                   	leaveq 
  8038ba:	c3                   	retq   

00000000008038bb <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8038bb:	55                   	push   %rbp
  8038bc:	48 89 e5             	mov    %rsp,%rbp
  8038bf:	48 83 ec 20          	sub    $0x20,%rsp
  8038c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038cb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8038cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038d3:	89 c2                	mov    %eax,%edx
  8038d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038d9:	8b 40 0c             	mov    0xc(%rax),%eax
  8038dc:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8038e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8038e5:	89 c7                	mov    %eax,%edi
  8038e7:	48 b8 b5 3c 80 00 00 	movabs $0x803cb5,%rax
  8038ee:	00 00 00 
  8038f1:	ff d0                	callq  *%rax
}
  8038f3:	c9                   	leaveq 
  8038f4:	c3                   	retq   

00000000008038f5 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8038f5:	55                   	push   %rbp
  8038f6:	48 89 e5             	mov    %rsp,%rbp
  8038f9:	48 83 ec 10          	sub    $0x10,%rsp
  8038fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803901:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803905:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803909:	48 be f8 51 80 00 00 	movabs $0x8051f8,%rsi
  803910:	00 00 00 
  803913:	48 89 c7             	mov    %rax,%rdi
  803916:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  80391d:	00 00 00 
  803920:	ff d0                	callq  *%rax
	return 0;
  803922:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803927:	c9                   	leaveq 
  803928:	c3                   	retq   

0000000000803929 <socket>:

int
socket(int domain, int type, int protocol)
{
  803929:	55                   	push   %rbp
  80392a:	48 89 e5             	mov    %rsp,%rbp
  80392d:	48 83 ec 20          	sub    $0x20,%rsp
  803931:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803934:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803937:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80393a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80393d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803940:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803943:	89 ce                	mov    %ecx,%esi
  803945:	89 c7                	mov    %eax,%edi
  803947:	48 b8 6d 3d 80 00 00 	movabs $0x803d6d,%rax
  80394e:	00 00 00 
  803951:	ff d0                	callq  *%rax
  803953:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803956:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80395a:	79 05                	jns    803961 <socket+0x38>
		return r;
  80395c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80395f:	eb 11                	jmp    803972 <socket+0x49>
	return alloc_sockfd(r);
  803961:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803964:	89 c7                	mov    %eax,%edi
  803966:	48 b8 0b 36 80 00 00 	movabs $0x80360b,%rax
  80396d:	00 00 00 
  803970:	ff d0                	callq  *%rax
}
  803972:	c9                   	leaveq 
  803973:	c3                   	retq   

0000000000803974 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803974:	55                   	push   %rbp
  803975:	48 89 e5             	mov    %rsp,%rbp
  803978:	48 83 ec 10          	sub    $0x10,%rsp
  80397c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80397f:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803986:	00 00 00 
  803989:	8b 00                	mov    (%rax),%eax
  80398b:	85 c0                	test   %eax,%eax
  80398d:	75 1d                	jne    8039ac <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80398f:	bf 02 00 00 00       	mov    $0x2,%edi
  803994:	48 b8 e4 48 80 00 00 	movabs $0x8048e4,%rax
  80399b:	00 00 00 
  80399e:	ff d0                	callq  *%rax
  8039a0:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  8039a7:	00 00 00 
  8039aa:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8039ac:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8039b3:	00 00 00 
  8039b6:	8b 00                	mov    (%rax),%eax
  8039b8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8039bb:	b9 07 00 00 00       	mov    $0x7,%ecx
  8039c0:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  8039c7:	00 00 00 
  8039ca:	89 c7                	mov    %eax,%edi
  8039cc:	48 b8 82 48 80 00 00 	movabs $0x804882,%rax
  8039d3:	00 00 00 
  8039d6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8039d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8039dd:	be 00 00 00 00       	mov    $0x0,%esi
  8039e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8039e7:	48 b8 7c 47 80 00 00 	movabs $0x80477c,%rax
  8039ee:	00 00 00 
  8039f1:	ff d0                	callq  *%rax
}
  8039f3:	c9                   	leaveq 
  8039f4:	c3                   	retq   

00000000008039f5 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8039f5:	55                   	push   %rbp
  8039f6:	48 89 e5             	mov    %rsp,%rbp
  8039f9:	48 83 ec 30          	sub    $0x30,%rsp
  8039fd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a00:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a04:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803a08:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a0f:	00 00 00 
  803a12:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a15:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803a17:	bf 01 00 00 00       	mov    $0x1,%edi
  803a1c:	48 b8 74 39 80 00 00 	movabs $0x803974,%rax
  803a23:	00 00 00 
  803a26:	ff d0                	callq  *%rax
  803a28:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a2b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a2f:	78 3e                	js     803a6f <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803a31:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a38:	00 00 00 
  803a3b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803a3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a43:	8b 40 10             	mov    0x10(%rax),%eax
  803a46:	89 c2                	mov    %eax,%edx
  803a48:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803a4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a50:	48 89 ce             	mov    %rcx,%rsi
  803a53:	48 89 c7             	mov    %rax,%rdi
  803a56:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  803a5d:	00 00 00 
  803a60:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803a62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a66:	8b 50 10             	mov    0x10(%rax),%edx
  803a69:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a6d:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803a6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a72:	c9                   	leaveq 
  803a73:	c3                   	retq   

0000000000803a74 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803a74:	55                   	push   %rbp
  803a75:	48 89 e5             	mov    %rsp,%rbp
  803a78:	48 83 ec 10          	sub    $0x10,%rsp
  803a7c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a7f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a83:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803a86:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a8d:	00 00 00 
  803a90:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a93:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803a95:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a9c:	48 89 c6             	mov    %rax,%rsi
  803a9f:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803aa6:	00 00 00 
  803aa9:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  803ab0:	00 00 00 
  803ab3:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803ab5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803abc:	00 00 00 
  803abf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ac2:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803ac5:	bf 02 00 00 00       	mov    $0x2,%edi
  803aca:	48 b8 74 39 80 00 00 	movabs $0x803974,%rax
  803ad1:	00 00 00 
  803ad4:	ff d0                	callq  *%rax
}
  803ad6:	c9                   	leaveq 
  803ad7:	c3                   	retq   

0000000000803ad8 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803ad8:	55                   	push   %rbp
  803ad9:	48 89 e5             	mov    %rsp,%rbp
  803adc:	48 83 ec 10          	sub    $0x10,%rsp
  803ae0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ae3:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803ae6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803aed:	00 00 00 
  803af0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803af3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803af5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803afc:	00 00 00 
  803aff:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b02:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803b05:	bf 03 00 00 00       	mov    $0x3,%edi
  803b0a:	48 b8 74 39 80 00 00 	movabs $0x803974,%rax
  803b11:	00 00 00 
  803b14:	ff d0                	callq  *%rax
}
  803b16:	c9                   	leaveq 
  803b17:	c3                   	retq   

0000000000803b18 <nsipc_close>:

int
nsipc_close(int s)
{
  803b18:	55                   	push   %rbp
  803b19:	48 89 e5             	mov    %rsp,%rbp
  803b1c:	48 83 ec 10          	sub    $0x10,%rsp
  803b20:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803b23:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b2a:	00 00 00 
  803b2d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b30:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803b32:	bf 04 00 00 00       	mov    $0x4,%edi
  803b37:	48 b8 74 39 80 00 00 	movabs $0x803974,%rax
  803b3e:	00 00 00 
  803b41:	ff d0                	callq  *%rax
}
  803b43:	c9                   	leaveq 
  803b44:	c3                   	retq   

0000000000803b45 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803b45:	55                   	push   %rbp
  803b46:	48 89 e5             	mov    %rsp,%rbp
  803b49:	48 83 ec 10          	sub    $0x10,%rsp
  803b4d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b50:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b54:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803b57:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b5e:	00 00 00 
  803b61:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b64:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803b66:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b6d:	48 89 c6             	mov    %rax,%rsi
  803b70:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803b77:	00 00 00 
  803b7a:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  803b81:	00 00 00 
  803b84:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803b86:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b8d:	00 00 00 
  803b90:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b93:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803b96:	bf 05 00 00 00       	mov    $0x5,%edi
  803b9b:	48 b8 74 39 80 00 00 	movabs $0x803974,%rax
  803ba2:	00 00 00 
  803ba5:	ff d0                	callq  *%rax
}
  803ba7:	c9                   	leaveq 
  803ba8:	c3                   	retq   

0000000000803ba9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803ba9:	55                   	push   %rbp
  803baa:	48 89 e5             	mov    %rsp,%rbp
  803bad:	48 83 ec 10          	sub    $0x10,%rsp
  803bb1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bb4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803bb7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bbe:	00 00 00 
  803bc1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bc4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803bc6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bcd:	00 00 00 
  803bd0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bd3:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803bd6:	bf 06 00 00 00       	mov    $0x6,%edi
  803bdb:	48 b8 74 39 80 00 00 	movabs $0x803974,%rax
  803be2:	00 00 00 
  803be5:	ff d0                	callq  *%rax
}
  803be7:	c9                   	leaveq 
  803be8:	c3                   	retq   

0000000000803be9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803be9:	55                   	push   %rbp
  803bea:	48 89 e5             	mov    %rsp,%rbp
  803bed:	48 83 ec 30          	sub    $0x30,%rsp
  803bf1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803bf4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bf8:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803bfb:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803bfe:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c05:	00 00 00 
  803c08:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c0b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803c0d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c14:	00 00 00 
  803c17:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c1a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803c1d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c24:	00 00 00 
  803c27:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803c2a:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803c2d:	bf 07 00 00 00       	mov    $0x7,%edi
  803c32:	48 b8 74 39 80 00 00 	movabs $0x803974,%rax
  803c39:	00 00 00 
  803c3c:	ff d0                	callq  *%rax
  803c3e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c41:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c45:	78 69                	js     803cb0 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803c47:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803c4e:	7f 08                	jg     803c58 <nsipc_recv+0x6f>
  803c50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c53:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803c56:	7e 35                	jle    803c8d <nsipc_recv+0xa4>
  803c58:	48 b9 ff 51 80 00 00 	movabs $0x8051ff,%rcx
  803c5f:	00 00 00 
  803c62:	48 ba 14 52 80 00 00 	movabs $0x805214,%rdx
  803c69:	00 00 00 
  803c6c:	be 61 00 00 00       	mov    $0x61,%esi
  803c71:	48 bf 29 52 80 00 00 	movabs $0x805229,%rdi
  803c78:	00 00 00 
  803c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  803c80:	49 b8 c2 04 80 00 00 	movabs $0x8004c2,%r8
  803c87:	00 00 00 
  803c8a:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803c8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c90:	48 63 d0             	movslq %eax,%rdx
  803c93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c97:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803c9e:	00 00 00 
  803ca1:	48 89 c7             	mov    %rax,%rdi
  803ca4:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  803cab:	00 00 00 
  803cae:	ff d0                	callq  *%rax
	}

	return r;
  803cb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803cb3:	c9                   	leaveq 
  803cb4:	c3                   	retq   

0000000000803cb5 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803cb5:	55                   	push   %rbp
  803cb6:	48 89 e5             	mov    %rsp,%rbp
  803cb9:	48 83 ec 20          	sub    $0x20,%rsp
  803cbd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803cc0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803cc4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803cc7:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803cca:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cd1:	00 00 00 
  803cd4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803cd7:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803cd9:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803ce0:	7e 35                	jle    803d17 <nsipc_send+0x62>
  803ce2:	48 b9 35 52 80 00 00 	movabs $0x805235,%rcx
  803ce9:	00 00 00 
  803cec:	48 ba 14 52 80 00 00 	movabs $0x805214,%rdx
  803cf3:	00 00 00 
  803cf6:	be 6c 00 00 00       	mov    $0x6c,%esi
  803cfb:	48 bf 29 52 80 00 00 	movabs $0x805229,%rdi
  803d02:	00 00 00 
  803d05:	b8 00 00 00 00       	mov    $0x0,%eax
  803d0a:	49 b8 c2 04 80 00 00 	movabs $0x8004c2,%r8
  803d11:	00 00 00 
  803d14:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803d17:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d1a:	48 63 d0             	movslq %eax,%rdx
  803d1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d21:	48 89 c6             	mov    %rax,%rsi
  803d24:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803d2b:	00 00 00 
  803d2e:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  803d35:	00 00 00 
  803d38:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803d3a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d41:	00 00 00 
  803d44:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d47:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803d4a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d51:	00 00 00 
  803d54:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803d57:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803d5a:	bf 08 00 00 00       	mov    $0x8,%edi
  803d5f:	48 b8 74 39 80 00 00 	movabs $0x803974,%rax
  803d66:	00 00 00 
  803d69:	ff d0                	callq  *%rax
}
  803d6b:	c9                   	leaveq 
  803d6c:	c3                   	retq   

0000000000803d6d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803d6d:	55                   	push   %rbp
  803d6e:	48 89 e5             	mov    %rsp,%rbp
  803d71:	48 83 ec 10          	sub    $0x10,%rsp
  803d75:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d78:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803d7b:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803d7e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d85:	00 00 00 
  803d88:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d8b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803d8d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d94:	00 00 00 
  803d97:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d9a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803d9d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803da4:	00 00 00 
  803da7:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803daa:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803dad:	bf 09 00 00 00       	mov    $0x9,%edi
  803db2:	48 b8 74 39 80 00 00 	movabs $0x803974,%rax
  803db9:	00 00 00 
  803dbc:	ff d0                	callq  *%rax
}
  803dbe:	c9                   	leaveq 
  803dbf:	c3                   	retq   

0000000000803dc0 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803dc0:	55                   	push   %rbp
  803dc1:	48 89 e5             	mov    %rsp,%rbp
  803dc4:	53                   	push   %rbx
  803dc5:	48 83 ec 38          	sub    $0x38,%rsp
  803dc9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803dcd:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803dd1:	48 89 c7             	mov    %rax,%rdi
  803dd4:	48 b8 fe 25 80 00 00 	movabs $0x8025fe,%rax
  803ddb:	00 00 00 
  803dde:	ff d0                	callq  *%rax
  803de0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803de3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803de7:	0f 88 bf 01 00 00    	js     803fac <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ded:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803df1:	ba 07 04 00 00       	mov    $0x407,%edx
  803df6:	48 89 c6             	mov    %rax,%rsi
  803df9:	bf 00 00 00 00       	mov    $0x0,%edi
  803dfe:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  803e05:	00 00 00 
  803e08:	ff d0                	callq  *%rax
  803e0a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e0d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e11:	0f 88 95 01 00 00    	js     803fac <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803e17:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803e1b:	48 89 c7             	mov    %rax,%rdi
  803e1e:	48 b8 fe 25 80 00 00 	movabs $0x8025fe,%rax
  803e25:	00 00 00 
  803e28:	ff d0                	callq  *%rax
  803e2a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e2d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e31:	0f 88 5d 01 00 00    	js     803f94 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e37:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e3b:	ba 07 04 00 00       	mov    $0x407,%edx
  803e40:	48 89 c6             	mov    %rax,%rsi
  803e43:	bf 00 00 00 00       	mov    $0x0,%edi
  803e48:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  803e4f:	00 00 00 
  803e52:	ff d0                	callq  *%rax
  803e54:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e57:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e5b:	0f 88 33 01 00 00    	js     803f94 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803e61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e65:	48 89 c7             	mov    %rax,%rdi
  803e68:	48 b8 d3 25 80 00 00 	movabs $0x8025d3,%rax
  803e6f:	00 00 00 
  803e72:	ff d0                	callq  *%rax
  803e74:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e7c:	ba 07 04 00 00       	mov    $0x407,%edx
  803e81:	48 89 c6             	mov    %rax,%rsi
  803e84:	bf 00 00 00 00       	mov    $0x0,%edi
  803e89:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  803e90:	00 00 00 
  803e93:	ff d0                	callq  *%rax
  803e95:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e98:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e9c:	79 05                	jns    803ea3 <pipe+0xe3>
		goto err2;
  803e9e:	e9 d9 00 00 00       	jmpq   803f7c <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ea3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ea7:	48 89 c7             	mov    %rax,%rdi
  803eaa:	48 b8 d3 25 80 00 00 	movabs $0x8025d3,%rax
  803eb1:	00 00 00 
  803eb4:	ff d0                	callq  *%rax
  803eb6:	48 89 c2             	mov    %rax,%rdx
  803eb9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ebd:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803ec3:	48 89 d1             	mov    %rdx,%rcx
  803ec6:	ba 00 00 00 00       	mov    $0x0,%edx
  803ecb:	48 89 c6             	mov    %rax,%rsi
  803ece:	bf 00 00 00 00       	mov    $0x0,%edi
  803ed3:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  803eda:	00 00 00 
  803edd:	ff d0                	callq  *%rax
  803edf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ee2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ee6:	79 1b                	jns    803f03 <pipe+0x143>
		goto err3;
  803ee8:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803ee9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803eed:	48 89 c6             	mov    %rax,%rsi
  803ef0:	bf 00 00 00 00       	mov    $0x0,%edi
  803ef5:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  803efc:	00 00 00 
  803eff:	ff d0                	callq  *%rax
  803f01:	eb 79                	jmp    803f7c <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803f03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f07:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803f0e:	00 00 00 
  803f11:	8b 12                	mov    (%rdx),%edx
  803f13:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803f15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f19:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803f20:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f24:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803f2b:	00 00 00 
  803f2e:	8b 12                	mov    (%rdx),%edx
  803f30:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803f32:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f36:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803f3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f41:	48 89 c7             	mov    %rax,%rdi
  803f44:	48 b8 b0 25 80 00 00 	movabs $0x8025b0,%rax
  803f4b:	00 00 00 
  803f4e:	ff d0                	callq  *%rax
  803f50:	89 c2                	mov    %eax,%edx
  803f52:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f56:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803f58:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f5c:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803f60:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f64:	48 89 c7             	mov    %rax,%rdi
  803f67:	48 b8 b0 25 80 00 00 	movabs $0x8025b0,%rax
  803f6e:	00 00 00 
  803f71:	ff d0                	callq  *%rax
  803f73:	89 03                	mov    %eax,(%rbx)
	return 0;
  803f75:	b8 00 00 00 00       	mov    $0x0,%eax
  803f7a:	eb 33                	jmp    803faf <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803f7c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f80:	48 89 c6             	mov    %rax,%rsi
  803f83:	bf 00 00 00 00       	mov    $0x0,%edi
  803f88:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  803f8f:	00 00 00 
  803f92:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803f94:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f98:	48 89 c6             	mov    %rax,%rsi
  803f9b:	bf 00 00 00 00       	mov    $0x0,%edi
  803fa0:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  803fa7:	00 00 00 
  803faa:	ff d0                	callq  *%rax
err:
	return r;
  803fac:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803faf:	48 83 c4 38          	add    $0x38,%rsp
  803fb3:	5b                   	pop    %rbx
  803fb4:	5d                   	pop    %rbp
  803fb5:	c3                   	retq   

0000000000803fb6 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803fb6:	55                   	push   %rbp
  803fb7:	48 89 e5             	mov    %rsp,%rbp
  803fba:	53                   	push   %rbx
  803fbb:	48 83 ec 28          	sub    $0x28,%rsp
  803fbf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803fc3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803fc7:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803fce:	00 00 00 
  803fd1:	48 8b 00             	mov    (%rax),%rax
  803fd4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803fda:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803fdd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fe1:	48 89 c7             	mov    %rax,%rdi
  803fe4:	48 b8 66 49 80 00 00 	movabs $0x804966,%rax
  803feb:	00 00 00 
  803fee:	ff d0                	callq  *%rax
  803ff0:	89 c3                	mov    %eax,%ebx
  803ff2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ff6:	48 89 c7             	mov    %rax,%rdi
  803ff9:	48 b8 66 49 80 00 00 	movabs $0x804966,%rax
  804000:	00 00 00 
  804003:	ff d0                	callq  *%rax
  804005:	39 c3                	cmp    %eax,%ebx
  804007:	0f 94 c0             	sete   %al
  80400a:	0f b6 c0             	movzbl %al,%eax
  80400d:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804010:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804017:	00 00 00 
  80401a:	48 8b 00             	mov    (%rax),%rax
  80401d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804023:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804026:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804029:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80402c:	75 05                	jne    804033 <_pipeisclosed+0x7d>
			return ret;
  80402e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804031:	eb 4f                	jmp    804082 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  804033:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804036:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804039:	74 42                	je     80407d <_pipeisclosed+0xc7>
  80403b:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80403f:	75 3c                	jne    80407d <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804041:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804048:	00 00 00 
  80404b:	48 8b 00             	mov    (%rax),%rax
  80404e:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804054:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804057:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80405a:	89 c6                	mov    %eax,%esi
  80405c:	48 bf 46 52 80 00 00 	movabs $0x805246,%rdi
  804063:	00 00 00 
  804066:	b8 00 00 00 00       	mov    $0x0,%eax
  80406b:	49 b8 fb 06 80 00 00 	movabs $0x8006fb,%r8
  804072:	00 00 00 
  804075:	41 ff d0             	callq  *%r8
	}
  804078:	e9 4a ff ff ff       	jmpq   803fc7 <_pipeisclosed+0x11>
  80407d:	e9 45 ff ff ff       	jmpq   803fc7 <_pipeisclosed+0x11>
}
  804082:	48 83 c4 28          	add    $0x28,%rsp
  804086:	5b                   	pop    %rbx
  804087:	5d                   	pop    %rbp
  804088:	c3                   	retq   

0000000000804089 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804089:	55                   	push   %rbp
  80408a:	48 89 e5             	mov    %rsp,%rbp
  80408d:	48 83 ec 30          	sub    $0x30,%rsp
  804091:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804094:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804098:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80409b:	48 89 d6             	mov    %rdx,%rsi
  80409e:	89 c7                	mov    %eax,%edi
  8040a0:	48 b8 96 26 80 00 00 	movabs $0x802696,%rax
  8040a7:	00 00 00 
  8040aa:	ff d0                	callq  *%rax
  8040ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040b3:	79 05                	jns    8040ba <pipeisclosed+0x31>
		return r;
  8040b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040b8:	eb 31                	jmp    8040eb <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8040ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040be:	48 89 c7             	mov    %rax,%rdi
  8040c1:	48 b8 d3 25 80 00 00 	movabs $0x8025d3,%rax
  8040c8:	00 00 00 
  8040cb:	ff d0                	callq  *%rax
  8040cd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8040d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040d9:	48 89 d6             	mov    %rdx,%rsi
  8040dc:	48 89 c7             	mov    %rax,%rdi
  8040df:	48 b8 b6 3f 80 00 00 	movabs $0x803fb6,%rax
  8040e6:	00 00 00 
  8040e9:	ff d0                	callq  *%rax
}
  8040eb:	c9                   	leaveq 
  8040ec:	c3                   	retq   

00000000008040ed <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8040ed:	55                   	push   %rbp
  8040ee:	48 89 e5             	mov    %rsp,%rbp
  8040f1:	48 83 ec 40          	sub    $0x40,%rsp
  8040f5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8040f9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8040fd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804101:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804105:	48 89 c7             	mov    %rax,%rdi
  804108:	48 b8 d3 25 80 00 00 	movabs $0x8025d3,%rax
  80410f:	00 00 00 
  804112:	ff d0                	callq  *%rax
  804114:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804118:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80411c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804120:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804127:	00 
  804128:	e9 92 00 00 00       	jmpq   8041bf <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80412d:	eb 41                	jmp    804170 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80412f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804134:	74 09                	je     80413f <devpipe_read+0x52>
				return i;
  804136:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80413a:	e9 92 00 00 00       	jmpq   8041d1 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80413f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804143:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804147:	48 89 d6             	mov    %rdx,%rsi
  80414a:	48 89 c7             	mov    %rax,%rdi
  80414d:	48 b8 b6 3f 80 00 00 	movabs $0x803fb6,%rax
  804154:	00 00 00 
  804157:	ff d0                	callq  *%rax
  804159:	85 c0                	test   %eax,%eax
  80415b:	74 07                	je     804164 <devpipe_read+0x77>
				return 0;
  80415d:	b8 00 00 00 00       	mov    $0x0,%eax
  804162:	eb 6d                	jmp    8041d1 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804164:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  80416b:	00 00 00 
  80416e:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804170:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804174:	8b 10                	mov    (%rax),%edx
  804176:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80417a:	8b 40 04             	mov    0x4(%rax),%eax
  80417d:	39 c2                	cmp    %eax,%edx
  80417f:	74 ae                	je     80412f <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804181:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804185:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804189:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80418d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804191:	8b 00                	mov    (%rax),%eax
  804193:	99                   	cltd   
  804194:	c1 ea 1b             	shr    $0x1b,%edx
  804197:	01 d0                	add    %edx,%eax
  804199:	83 e0 1f             	and    $0x1f,%eax
  80419c:	29 d0                	sub    %edx,%eax
  80419e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041a2:	48 98                	cltq   
  8041a4:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8041a9:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8041ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041af:	8b 00                	mov    (%rax),%eax
  8041b1:	8d 50 01             	lea    0x1(%rax),%edx
  8041b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041b8:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8041ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8041bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041c3:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8041c7:	0f 82 60 ff ff ff    	jb     80412d <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8041cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8041d1:	c9                   	leaveq 
  8041d2:	c3                   	retq   

00000000008041d3 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8041d3:	55                   	push   %rbp
  8041d4:	48 89 e5             	mov    %rsp,%rbp
  8041d7:	48 83 ec 40          	sub    $0x40,%rsp
  8041db:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8041df:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8041e3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8041e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041eb:	48 89 c7             	mov    %rax,%rdi
  8041ee:	48 b8 d3 25 80 00 00 	movabs $0x8025d3,%rax
  8041f5:	00 00 00 
  8041f8:	ff d0                	callq  *%rax
  8041fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8041fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804202:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804206:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80420d:	00 
  80420e:	e9 8e 00 00 00       	jmpq   8042a1 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804213:	eb 31                	jmp    804246 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804215:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804219:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80421d:	48 89 d6             	mov    %rdx,%rsi
  804220:	48 89 c7             	mov    %rax,%rdi
  804223:	48 b8 b6 3f 80 00 00 	movabs $0x803fb6,%rax
  80422a:	00 00 00 
  80422d:	ff d0                	callq  *%rax
  80422f:	85 c0                	test   %eax,%eax
  804231:	74 07                	je     80423a <devpipe_write+0x67>
				return 0;
  804233:	b8 00 00 00 00       	mov    $0x0,%eax
  804238:	eb 79                	jmp    8042b3 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80423a:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  804241:	00 00 00 
  804244:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804246:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80424a:	8b 40 04             	mov    0x4(%rax),%eax
  80424d:	48 63 d0             	movslq %eax,%rdx
  804250:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804254:	8b 00                	mov    (%rax),%eax
  804256:	48 98                	cltq   
  804258:	48 83 c0 20          	add    $0x20,%rax
  80425c:	48 39 c2             	cmp    %rax,%rdx
  80425f:	73 b4                	jae    804215 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804261:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804265:	8b 40 04             	mov    0x4(%rax),%eax
  804268:	99                   	cltd   
  804269:	c1 ea 1b             	shr    $0x1b,%edx
  80426c:	01 d0                	add    %edx,%eax
  80426e:	83 e0 1f             	and    $0x1f,%eax
  804271:	29 d0                	sub    %edx,%eax
  804273:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804277:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80427b:	48 01 ca             	add    %rcx,%rdx
  80427e:	0f b6 0a             	movzbl (%rdx),%ecx
  804281:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804285:	48 98                	cltq   
  804287:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80428b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80428f:	8b 40 04             	mov    0x4(%rax),%eax
  804292:	8d 50 01             	lea    0x1(%rax),%edx
  804295:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804299:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80429c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8042a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042a5:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8042a9:	0f 82 64 ff ff ff    	jb     804213 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8042af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8042b3:	c9                   	leaveq 
  8042b4:	c3                   	retq   

00000000008042b5 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8042b5:	55                   	push   %rbp
  8042b6:	48 89 e5             	mov    %rsp,%rbp
  8042b9:	48 83 ec 20          	sub    $0x20,%rsp
  8042bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8042c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8042c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042c9:	48 89 c7             	mov    %rax,%rdi
  8042cc:	48 b8 d3 25 80 00 00 	movabs $0x8025d3,%rax
  8042d3:	00 00 00 
  8042d6:	ff d0                	callq  *%rax
  8042d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8042dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042e0:	48 be 59 52 80 00 00 	movabs $0x805259,%rsi
  8042e7:	00 00 00 
  8042ea:	48 89 c7             	mov    %rax,%rdi
  8042ed:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  8042f4:	00 00 00 
  8042f7:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8042f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042fd:	8b 50 04             	mov    0x4(%rax),%edx
  804300:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804304:	8b 00                	mov    (%rax),%eax
  804306:	29 c2                	sub    %eax,%edx
  804308:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80430c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804312:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804316:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80431d:	00 00 00 
	stat->st_dev = &devpipe;
  804320:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804324:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  80432b:	00 00 00 
  80432e:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804335:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80433a:	c9                   	leaveq 
  80433b:	c3                   	retq   

000000000080433c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80433c:	55                   	push   %rbp
  80433d:	48 89 e5             	mov    %rsp,%rbp
  804340:	48 83 ec 10          	sub    $0x10,%rsp
  804344:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804348:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80434c:	48 89 c6             	mov    %rax,%rsi
  80434f:	bf 00 00 00 00       	mov    $0x0,%edi
  804354:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  80435b:	00 00 00 
  80435e:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804360:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804364:	48 89 c7             	mov    %rax,%rdi
  804367:	48 b8 d3 25 80 00 00 	movabs $0x8025d3,%rax
  80436e:	00 00 00 
  804371:	ff d0                	callq  *%rax
  804373:	48 89 c6             	mov    %rax,%rsi
  804376:	bf 00 00 00 00       	mov    $0x0,%edi
  80437b:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  804382:	00 00 00 
  804385:	ff d0                	callq  *%rax
}
  804387:	c9                   	leaveq 
  804388:	c3                   	retq   

0000000000804389 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804389:	55                   	push   %rbp
  80438a:	48 89 e5             	mov    %rsp,%rbp
  80438d:	48 83 ec 20          	sub    $0x20,%rsp
  804391:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804394:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804397:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80439a:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80439e:	be 01 00 00 00       	mov    $0x1,%esi
  8043a3:	48 89 c7             	mov    %rax,%rdi
  8043a6:	48 b8 97 1a 80 00 00 	movabs $0x801a97,%rax
  8043ad:	00 00 00 
  8043b0:	ff d0                	callq  *%rax
}
  8043b2:	c9                   	leaveq 
  8043b3:	c3                   	retq   

00000000008043b4 <getchar>:

int
getchar(void)
{
  8043b4:	55                   	push   %rbp
  8043b5:	48 89 e5             	mov    %rsp,%rbp
  8043b8:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8043bc:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8043c0:	ba 01 00 00 00       	mov    $0x1,%edx
  8043c5:	48 89 c6             	mov    %rax,%rsi
  8043c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8043cd:	48 b8 c8 2a 80 00 00 	movabs $0x802ac8,%rax
  8043d4:	00 00 00 
  8043d7:	ff d0                	callq  *%rax
  8043d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8043dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043e0:	79 05                	jns    8043e7 <getchar+0x33>
		return r;
  8043e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043e5:	eb 14                	jmp    8043fb <getchar+0x47>
	if (r < 1)
  8043e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043eb:	7f 07                	jg     8043f4 <getchar+0x40>
		return -E_EOF;
  8043ed:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8043f2:	eb 07                	jmp    8043fb <getchar+0x47>
	return c;
  8043f4:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8043f8:	0f b6 c0             	movzbl %al,%eax
}
  8043fb:	c9                   	leaveq 
  8043fc:	c3                   	retq   

00000000008043fd <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8043fd:	55                   	push   %rbp
  8043fe:	48 89 e5             	mov    %rsp,%rbp
  804401:	48 83 ec 20          	sub    $0x20,%rsp
  804405:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804408:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80440c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80440f:	48 89 d6             	mov    %rdx,%rsi
  804412:	89 c7                	mov    %eax,%edi
  804414:	48 b8 96 26 80 00 00 	movabs $0x802696,%rax
  80441b:	00 00 00 
  80441e:	ff d0                	callq  *%rax
  804420:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804423:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804427:	79 05                	jns    80442e <iscons+0x31>
		return r;
  804429:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80442c:	eb 1a                	jmp    804448 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80442e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804432:	8b 10                	mov    (%rax),%edx
  804434:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  80443b:	00 00 00 
  80443e:	8b 00                	mov    (%rax),%eax
  804440:	39 c2                	cmp    %eax,%edx
  804442:	0f 94 c0             	sete   %al
  804445:	0f b6 c0             	movzbl %al,%eax
}
  804448:	c9                   	leaveq 
  804449:	c3                   	retq   

000000000080444a <opencons>:

int
opencons(void)
{
  80444a:	55                   	push   %rbp
  80444b:	48 89 e5             	mov    %rsp,%rbp
  80444e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804452:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804456:	48 89 c7             	mov    %rax,%rdi
  804459:	48 b8 fe 25 80 00 00 	movabs $0x8025fe,%rax
  804460:	00 00 00 
  804463:	ff d0                	callq  *%rax
  804465:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804468:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80446c:	79 05                	jns    804473 <opencons+0x29>
		return r;
  80446e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804471:	eb 5b                	jmp    8044ce <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804473:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804477:	ba 07 04 00 00       	mov    $0x407,%edx
  80447c:	48 89 c6             	mov    %rax,%rsi
  80447f:	bf 00 00 00 00       	mov    $0x0,%edi
  804484:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  80448b:	00 00 00 
  80448e:	ff d0                	callq  *%rax
  804490:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804493:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804497:	79 05                	jns    80449e <opencons+0x54>
		return r;
  804499:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80449c:	eb 30                	jmp    8044ce <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80449e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044a2:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8044a9:	00 00 00 
  8044ac:	8b 12                	mov    (%rdx),%edx
  8044ae:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8044b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044b4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8044bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044bf:	48 89 c7             	mov    %rax,%rdi
  8044c2:	48 b8 b0 25 80 00 00 	movabs $0x8025b0,%rax
  8044c9:	00 00 00 
  8044cc:	ff d0                	callq  *%rax
}
  8044ce:	c9                   	leaveq 
  8044cf:	c3                   	retq   

00000000008044d0 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8044d0:	55                   	push   %rbp
  8044d1:	48 89 e5             	mov    %rsp,%rbp
  8044d4:	48 83 ec 30          	sub    $0x30,%rsp
  8044d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8044e0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8044e4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8044e9:	75 07                	jne    8044f2 <devcons_read+0x22>
		return 0;
  8044eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8044f0:	eb 4b                	jmp    80453d <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8044f2:	eb 0c                	jmp    804500 <devcons_read+0x30>
		sys_yield();
  8044f4:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  8044fb:	00 00 00 
  8044fe:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804500:	48 b8 e1 1a 80 00 00 	movabs $0x801ae1,%rax
  804507:	00 00 00 
  80450a:	ff d0                	callq  *%rax
  80450c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80450f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804513:	74 df                	je     8044f4 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804515:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804519:	79 05                	jns    804520 <devcons_read+0x50>
		return c;
  80451b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80451e:	eb 1d                	jmp    80453d <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804520:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804524:	75 07                	jne    80452d <devcons_read+0x5d>
		return 0;
  804526:	b8 00 00 00 00       	mov    $0x0,%eax
  80452b:	eb 10                	jmp    80453d <devcons_read+0x6d>
	*(char*)vbuf = c;
  80452d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804530:	89 c2                	mov    %eax,%edx
  804532:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804536:	88 10                	mov    %dl,(%rax)
	return 1;
  804538:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80453d:	c9                   	leaveq 
  80453e:	c3                   	retq   

000000000080453f <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80453f:	55                   	push   %rbp
  804540:	48 89 e5             	mov    %rsp,%rbp
  804543:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80454a:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804551:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804558:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80455f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804566:	eb 76                	jmp    8045de <devcons_write+0x9f>
		m = n - tot;
  804568:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80456f:	89 c2                	mov    %eax,%edx
  804571:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804574:	29 c2                	sub    %eax,%edx
  804576:	89 d0                	mov    %edx,%eax
  804578:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80457b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80457e:	83 f8 7f             	cmp    $0x7f,%eax
  804581:	76 07                	jbe    80458a <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804583:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80458a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80458d:	48 63 d0             	movslq %eax,%rdx
  804590:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804593:	48 63 c8             	movslq %eax,%rcx
  804596:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80459d:	48 01 c1             	add    %rax,%rcx
  8045a0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8045a7:	48 89 ce             	mov    %rcx,%rsi
  8045aa:	48 89 c7             	mov    %rax,%rdi
  8045ad:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  8045b4:	00 00 00 
  8045b7:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8045b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045bc:	48 63 d0             	movslq %eax,%rdx
  8045bf:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8045c6:	48 89 d6             	mov    %rdx,%rsi
  8045c9:	48 89 c7             	mov    %rax,%rdi
  8045cc:	48 b8 97 1a 80 00 00 	movabs $0x801a97,%rax
  8045d3:	00 00 00 
  8045d6:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8045d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045db:	01 45 fc             	add    %eax,-0x4(%rbp)
  8045de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045e1:	48 98                	cltq   
  8045e3:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8045ea:	0f 82 78 ff ff ff    	jb     804568 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8045f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8045f3:	c9                   	leaveq 
  8045f4:	c3                   	retq   

00000000008045f5 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8045f5:	55                   	push   %rbp
  8045f6:	48 89 e5             	mov    %rsp,%rbp
  8045f9:	48 83 ec 08          	sub    $0x8,%rsp
  8045fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804601:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804606:	c9                   	leaveq 
  804607:	c3                   	retq   

0000000000804608 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804608:	55                   	push   %rbp
  804609:	48 89 e5             	mov    %rsp,%rbp
  80460c:	48 83 ec 10          	sub    $0x10,%rsp
  804610:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804614:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804618:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80461c:	48 be 65 52 80 00 00 	movabs $0x805265,%rsi
  804623:	00 00 00 
  804626:	48 89 c7             	mov    %rax,%rdi
  804629:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  804630:	00 00 00 
  804633:	ff d0                	callq  *%rax
	return 0;
  804635:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80463a:	c9                   	leaveq 
  80463b:	c3                   	retq   

000000000080463c <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80463c:	55                   	push   %rbp
  80463d:	48 89 e5             	mov    %rsp,%rbp
  804640:	48 83 ec 10          	sub    $0x10,%rsp
  804644:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804648:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80464f:	00 00 00 
  804652:	48 8b 00             	mov    (%rax),%rax
  804655:	48 85 c0             	test   %rax,%rax
  804658:	0f 85 84 00 00 00    	jne    8046e2 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  80465e:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804665:	00 00 00 
  804668:	48 8b 00             	mov    (%rax),%rax
  80466b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804671:	ba 07 00 00 00       	mov    $0x7,%edx
  804676:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80467b:	89 c7                	mov    %eax,%edi
  80467d:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  804684:	00 00 00 
  804687:	ff d0                	callq  *%rax
  804689:	85 c0                	test   %eax,%eax
  80468b:	79 2a                	jns    8046b7 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  80468d:	48 ba 70 52 80 00 00 	movabs $0x805270,%rdx
  804694:	00 00 00 
  804697:	be 23 00 00 00       	mov    $0x23,%esi
  80469c:	48 bf 97 52 80 00 00 	movabs $0x805297,%rdi
  8046a3:	00 00 00 
  8046a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8046ab:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  8046b2:	00 00 00 
  8046b5:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  8046b7:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8046be:	00 00 00 
  8046c1:	48 8b 00             	mov    (%rax),%rax
  8046c4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8046ca:	48 be f5 46 80 00 00 	movabs $0x8046f5,%rsi
  8046d1:	00 00 00 
  8046d4:	89 c7                	mov    %eax,%edi
  8046d6:	48 b8 69 1d 80 00 00 	movabs $0x801d69,%rax
  8046dd:	00 00 00 
  8046e0:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  8046e2:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8046e9:	00 00 00 
  8046ec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8046f0:	48 89 10             	mov    %rdx,(%rax)
}
  8046f3:	c9                   	leaveq 
  8046f4:	c3                   	retq   

00000000008046f5 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8046f5:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8046f8:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  8046ff:	00 00 00 
call *%rax
  804702:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  804704:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80470b:	00 
	movq 152(%rsp), %rcx  //Load RSP
  80470c:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804713:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  804714:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  804718:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  80471b:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804722:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  804723:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  804727:	4c 8b 3c 24          	mov    (%rsp),%r15
  80472b:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804730:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804735:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80473a:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80473f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804744:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804749:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80474e:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804753:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804758:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80475d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804762:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804767:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80476c:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804771:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  804775:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  804779:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  80477a:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80477b:	c3                   	retq   

000000000080477c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80477c:	55                   	push   %rbp
  80477d:	48 89 e5             	mov    %rsp,%rbp
  804780:	48 83 ec 30          	sub    $0x30,%rsp
  804784:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804788:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80478c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804790:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804797:	00 00 00 
  80479a:	48 8b 00             	mov    (%rax),%rax
  80479d:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8047a3:	85 c0                	test   %eax,%eax
  8047a5:	75 3c                	jne    8047e3 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8047a7:	48 b8 63 1b 80 00 00 	movabs $0x801b63,%rax
  8047ae:	00 00 00 
  8047b1:	ff d0                	callq  *%rax
  8047b3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8047b8:	48 63 d0             	movslq %eax,%rdx
  8047bb:	48 89 d0             	mov    %rdx,%rax
  8047be:	48 c1 e0 03          	shl    $0x3,%rax
  8047c2:	48 01 d0             	add    %rdx,%rax
  8047c5:	48 c1 e0 05          	shl    $0x5,%rax
  8047c9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8047d0:	00 00 00 
  8047d3:	48 01 c2             	add    %rax,%rdx
  8047d6:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8047dd:	00 00 00 
  8047e0:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8047e3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8047e8:	75 0e                	jne    8047f8 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  8047ea:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8047f1:	00 00 00 
  8047f4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8047f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047fc:	48 89 c7             	mov    %rax,%rdi
  8047ff:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  804806:	00 00 00 
  804809:	ff d0                	callq  *%rax
  80480b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  80480e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804812:	79 19                	jns    80482d <ipc_recv+0xb1>
		*from_env_store = 0;
  804814:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804818:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80481e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804822:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  804828:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80482b:	eb 53                	jmp    804880 <ipc_recv+0x104>
	}
	if(from_env_store)
  80482d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804832:	74 19                	je     80484d <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  804834:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80483b:	00 00 00 
  80483e:	48 8b 00             	mov    (%rax),%rax
  804841:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804847:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80484b:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80484d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804852:	74 19                	je     80486d <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  804854:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80485b:	00 00 00 
  80485e:	48 8b 00             	mov    (%rax),%rax
  804861:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804867:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80486b:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  80486d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804874:	00 00 00 
  804877:	48 8b 00             	mov    (%rax),%rax
  80487a:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804880:	c9                   	leaveq 
  804881:	c3                   	retq   

0000000000804882 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804882:	55                   	push   %rbp
  804883:	48 89 e5             	mov    %rsp,%rbp
  804886:	48 83 ec 30          	sub    $0x30,%rsp
  80488a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80488d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804890:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804894:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804897:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80489c:	75 0e                	jne    8048ac <ipc_send+0x2a>
		pg = (void*)UTOP;
  80489e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8048a5:	00 00 00 
  8048a8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8048ac:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8048af:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8048b2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8048b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8048b9:	89 c7                	mov    %eax,%edi
  8048bb:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  8048c2:	00 00 00 
  8048c5:	ff d0                	callq  *%rax
  8048c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8048ca:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8048ce:	75 0c                	jne    8048dc <ipc_send+0x5a>
			sys_yield();
  8048d0:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  8048d7:	00 00 00 
  8048da:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8048dc:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8048e0:	74 ca                	je     8048ac <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8048e2:	c9                   	leaveq 
  8048e3:	c3                   	retq   

00000000008048e4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8048e4:	55                   	push   %rbp
  8048e5:	48 89 e5             	mov    %rsp,%rbp
  8048e8:	48 83 ec 14          	sub    $0x14,%rsp
  8048ec:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8048ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8048f6:	eb 5e                	jmp    804956 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8048f8:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8048ff:	00 00 00 
  804902:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804905:	48 63 d0             	movslq %eax,%rdx
  804908:	48 89 d0             	mov    %rdx,%rax
  80490b:	48 c1 e0 03          	shl    $0x3,%rax
  80490f:	48 01 d0             	add    %rdx,%rax
  804912:	48 c1 e0 05          	shl    $0x5,%rax
  804916:	48 01 c8             	add    %rcx,%rax
  804919:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80491f:	8b 00                	mov    (%rax),%eax
  804921:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804924:	75 2c                	jne    804952 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804926:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80492d:	00 00 00 
  804930:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804933:	48 63 d0             	movslq %eax,%rdx
  804936:	48 89 d0             	mov    %rdx,%rax
  804939:	48 c1 e0 03          	shl    $0x3,%rax
  80493d:	48 01 d0             	add    %rdx,%rax
  804940:	48 c1 e0 05          	shl    $0x5,%rax
  804944:	48 01 c8             	add    %rcx,%rax
  804947:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80494d:	8b 40 08             	mov    0x8(%rax),%eax
  804950:	eb 12                	jmp    804964 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804952:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804956:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80495d:	7e 99                	jle    8048f8 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80495f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804964:	c9                   	leaveq 
  804965:	c3                   	retq   

0000000000804966 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804966:	55                   	push   %rbp
  804967:	48 89 e5             	mov    %rsp,%rbp
  80496a:	48 83 ec 18          	sub    $0x18,%rsp
  80496e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804972:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804976:	48 c1 e8 15          	shr    $0x15,%rax
  80497a:	48 89 c2             	mov    %rax,%rdx
  80497d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804984:	01 00 00 
  804987:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80498b:	83 e0 01             	and    $0x1,%eax
  80498e:	48 85 c0             	test   %rax,%rax
  804991:	75 07                	jne    80499a <pageref+0x34>
		return 0;
  804993:	b8 00 00 00 00       	mov    $0x0,%eax
  804998:	eb 53                	jmp    8049ed <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80499a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80499e:	48 c1 e8 0c          	shr    $0xc,%rax
  8049a2:	48 89 c2             	mov    %rax,%rdx
  8049a5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8049ac:	01 00 00 
  8049af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8049b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8049b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049bb:	83 e0 01             	and    $0x1,%eax
  8049be:	48 85 c0             	test   %rax,%rax
  8049c1:	75 07                	jne    8049ca <pageref+0x64>
		return 0;
  8049c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8049c8:	eb 23                	jmp    8049ed <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8049ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049ce:	48 c1 e8 0c          	shr    $0xc,%rax
  8049d2:	48 89 c2             	mov    %rax,%rdx
  8049d5:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8049dc:	00 00 00 
  8049df:	48 c1 e2 04          	shl    $0x4,%rdx
  8049e3:	48 01 d0             	add    %rdx,%rax
  8049e6:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8049ea:	0f b7 c0             	movzwl %ax,%eax
}
  8049ed:	c9                   	leaveq 
  8049ee:	c3                   	retq   
