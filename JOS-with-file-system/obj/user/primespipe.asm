
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
  80005f:	48 b8 d3 2a 80 00 00 	movabs $0x802ad3,%rax
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
  80008b:	48 ba 40 3f 80 00 00 	movabs $0x803f40,%rdx
  800092:	00 00 00 
  800095:	be 15 00 00 00       	mov    $0x15,%esi
  80009a:	48 bf 6f 3f 80 00 00 	movabs $0x803f6f,%rdi
  8000a1:	00 00 00 
  8000a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a9:	49 b9 c2 04 80 00 00 	movabs $0x8004c2,%r9
  8000b0:	00 00 00 
  8000b3:	41 ff d1             	callq  *%r9

	cprintf("%d\n", p);
  8000b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000b9:	89 c6                	mov    %eax,%esi
  8000bb:	48 bf 81 3f 80 00 00 	movabs $0x803f81,%rdi
  8000c2:	00 00 00 
  8000c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ca:	48 ba fb 06 80 00 00 	movabs $0x8006fb,%rdx
  8000d1:	00 00 00 
  8000d4:	ff d2                	callq  *%rdx

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  8000d6:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8000da:	48 89 c7             	mov    %rax,%rdi
  8000dd:	48 b8 0f 33 80 00 00 	movabs $0x80330f,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
  8000e9:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000ec:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ef:	85 c0                	test   %eax,%eax
  8000f1:	79 30                	jns    800123 <primeproc+0xe0>
		panic("pipe: %e", i);
  8000f3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000f6:	89 c1                	mov    %eax,%ecx
  8000f8:	48 ba 85 3f 80 00 00 	movabs $0x803f85,%rdx
  8000ff:	00 00 00 
  800102:	be 1b 00 00 00       	mov    $0x1b,%esi
  800107:	48 bf 6f 3f 80 00 00 	movabs $0x803f6f,%rdi
  80010e:	00 00 00 
  800111:	b8 00 00 00 00       	mov    $0x0,%eax
  800116:	49 b8 c2 04 80 00 00 	movabs $0x8004c2,%r8
  80011d:	00 00 00 
  800120:	41 ff d0             	callq  *%r8
	if ((id = fork()) < 0)
  800123:	48 b8 35 22 80 00 00 	movabs $0x802235,%rax
  80012a:	00 00 00 
  80012d:	ff d0                	callq  *%rax
  80012f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800132:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800136:	79 30                	jns    800168 <primeproc+0x125>
		panic("fork: %e", id);
  800138:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80013b:	89 c1                	mov    %eax,%ecx
  80013d:	48 ba 8e 3f 80 00 00 	movabs $0x803f8e,%rdx
  800144:	00 00 00 
  800147:	be 1d 00 00 00       	mov    $0x1d,%esi
  80014c:	48 bf 6f 3f 80 00 00 	movabs $0x803f6f,%rdi
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
  800173:	48 b8 dc 27 80 00 00 	movabs $0x8027dc,%rax
  80017a:	00 00 00 
  80017d:	ff d0                	callq  *%rax
		close(pfd[1]);
  80017f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800182:	89 c7                	mov    %eax,%edi
  800184:	48 b8 dc 27 80 00 00 	movabs $0x8027dc,%rax
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
  8001a0:	48 b8 dc 27 80 00 00 	movabs $0x8027dc,%rax
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
  8001c3:	48 b8 d3 2a 80 00 00 	movabs $0x802ad3,%rax
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
  8001fb:	48 ba 97 3f 80 00 00 	movabs $0x803f97,%rdx
  800202:	00 00 00 
  800205:	be 2b 00 00 00       	mov    $0x2b,%esi
  80020a:	48 bf 6f 3f 80 00 00 	movabs $0x803f6f,%rdi
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
  800246:	48 b8 48 2b 80 00 00 	movabs $0x802b48,%rax
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
  800278:	48 ba b3 3f 80 00 00 	movabs $0x803fb3,%rdx
  80027f:	00 00 00 
  800282:	be 2e 00 00 00       	mov    $0x2e,%esi
  800287:	48 bf 6f 3f 80 00 00 	movabs $0x803f6f,%rdi
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
  8002b8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002bf:	00 00 00 
  8002c2:	48 bb cd 3f 80 00 00 	movabs $0x803fcd,%rbx
  8002c9:	00 00 00 
  8002cc:	48 89 18             	mov    %rbx,(%rax)

	if ((i=pipe(p)) < 0)
  8002cf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8002d3:	48 89 c7             	mov    %rax,%rdi
  8002d6:	48 b8 0f 33 80 00 00 	movabs $0x80330f,%rax
  8002dd:	00 00 00 
  8002e0:	ff d0                	callq  *%rax
  8002e2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8002e5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8002e8:	85 c0                	test   %eax,%eax
  8002ea:	79 30                	jns    80031c <umain+0x74>
		panic("pipe: %e", i);
  8002ec:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8002ef:	89 c1                	mov    %eax,%ecx
  8002f1:	48 ba 85 3f 80 00 00 	movabs $0x803f85,%rdx
  8002f8:	00 00 00 
  8002fb:	be 3a 00 00 00       	mov    $0x3a,%esi
  800300:	48 bf 6f 3f 80 00 00 	movabs $0x803f6f,%rdi
  800307:	00 00 00 
  80030a:	b8 00 00 00 00       	mov    $0x0,%eax
  80030f:	49 b8 c2 04 80 00 00 	movabs $0x8004c2,%r8
  800316:	00 00 00 
  800319:	41 ff d0             	callq  *%r8

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  80031c:	48 b8 35 22 80 00 00 	movabs $0x802235,%rax
  800323:	00 00 00 
  800326:	ff d0                	callq  *%rax
  800328:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80032b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80032f:	79 30                	jns    800361 <umain+0xb9>
		panic("fork: %e", id);
  800331:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800334:	89 c1                	mov    %eax,%ecx
  800336:	48 ba 8e 3f 80 00 00 	movabs $0x803f8e,%rdx
  80033d:	00 00 00 
  800340:	be 3e 00 00 00       	mov    $0x3e,%esi
  800345:	48 bf 6f 3f 80 00 00 	movabs $0x803f6f,%rdi
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
  80036c:	48 b8 dc 27 80 00 00 	movabs $0x8027dc,%rax
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
  80038e:	48 b8 dc 27 80 00 00 	movabs $0x8027dc,%rax
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
  8003b2:	48 b8 48 2b 80 00 00 	movabs $0x802b48,%rax
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
  8003de:	48 ba d8 3f 80 00 00 	movabs $0x803fd8,%rdx
  8003e5:	00 00 00 
  8003e8:	be 4a 00 00 00       	mov    $0x4a,%esi
  8003ed:	48 bf 6f 3f 80 00 00 	movabs $0x803f6f,%rdi
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
  800452:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
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
  80046c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
  8004a3:	48 b8 27 28 80 00 00 	movabs $0x802827,%rax
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
  80054b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
  80057c:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
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
  8005b8:	48 bf 23 40 80 00 00 	movabs $0x804023,%rdi
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
  800867:	48 ba 08 42 80 00 00 	movabs $0x804208,%rdx
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
  800b5f:	48 b8 30 42 80 00 00 	movabs $0x804230,%rax
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
  800cad:	83 fb 10             	cmp    $0x10,%ebx
  800cb0:	7f 16                	jg     800cc8 <vprintfmt+0x21a>
  800cb2:	48 b8 80 41 80 00 00 	movabs $0x804180,%rax
  800cb9:	00 00 00 
  800cbc:	48 63 d3             	movslq %ebx,%rdx
  800cbf:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800cc3:	4d 85 e4             	test   %r12,%r12
  800cc6:	75 2e                	jne    800cf6 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800cc8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ccc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd0:	89 d9                	mov    %ebx,%ecx
  800cd2:	48 ba 19 42 80 00 00 	movabs $0x804219,%rdx
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
  800d01:	48 ba 22 42 80 00 00 	movabs $0x804222,%rdx
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
  800d5b:	49 bc 25 42 80 00 00 	movabs $0x804225,%r12
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
  801a61:	48 ba e0 44 80 00 00 	movabs $0x8044e0,%rdx
  801a68:	00 00 00 
  801a6b:	be 23 00 00 00       	mov    $0x23,%esi
  801a70:	48 bf fd 44 80 00 00 	movabs $0x8044fd,%rdi
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

0000000000801e4c <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801e4c:	55                   	push   %rbp
  801e4d:	48 89 e5             	mov    %rsp,%rbp
  801e50:	48 83 ec 30          	sub    $0x30,%rsp
  801e54:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801e58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e5c:	48 8b 00             	mov    (%rax),%rax
  801e5f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801e63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e67:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e6b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801e6e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e71:	83 e0 02             	and    $0x2,%eax
  801e74:	85 c0                	test   %eax,%eax
  801e76:	75 4d                	jne    801ec5 <pgfault+0x79>
  801e78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e7c:	48 c1 e8 0c          	shr    $0xc,%rax
  801e80:	48 89 c2             	mov    %rax,%rdx
  801e83:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e8a:	01 00 00 
  801e8d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e91:	25 00 08 00 00       	and    $0x800,%eax
  801e96:	48 85 c0             	test   %rax,%rax
  801e99:	74 2a                	je     801ec5 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801e9b:	48 ba 10 45 80 00 00 	movabs $0x804510,%rdx
  801ea2:	00 00 00 
  801ea5:	be 23 00 00 00       	mov    $0x23,%esi
  801eaa:	48 bf 45 45 80 00 00 	movabs $0x804545,%rdi
  801eb1:	00 00 00 
  801eb4:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb9:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  801ec0:	00 00 00 
  801ec3:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801ec5:	ba 07 00 00 00       	mov    $0x7,%edx
  801eca:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ecf:	bf 00 00 00 00       	mov    $0x0,%edi
  801ed4:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  801edb:	00 00 00 
  801ede:	ff d0                	callq  *%rax
  801ee0:	85 c0                	test   %eax,%eax
  801ee2:	0f 85 cd 00 00 00    	jne    801fb5 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801ee8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eec:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801ef0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ef4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801efa:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801efe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f02:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f07:	48 89 c6             	mov    %rax,%rsi
  801f0a:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801f0f:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  801f16:	00 00 00 
  801f19:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801f1b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f1f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801f25:	48 89 c1             	mov    %rax,%rcx
  801f28:	ba 00 00 00 00       	mov    $0x0,%edx
  801f2d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f32:	bf 00 00 00 00       	mov    $0x0,%edi
  801f37:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  801f3e:	00 00 00 
  801f41:	ff d0                	callq  *%rax
  801f43:	85 c0                	test   %eax,%eax
  801f45:	79 2a                	jns    801f71 <pgfault+0x125>
				panic("Page map at temp address failed");
  801f47:	48 ba 50 45 80 00 00 	movabs $0x804550,%rdx
  801f4e:	00 00 00 
  801f51:	be 30 00 00 00       	mov    $0x30,%esi
  801f56:	48 bf 45 45 80 00 00 	movabs $0x804545,%rdi
  801f5d:	00 00 00 
  801f60:	b8 00 00 00 00       	mov    $0x0,%eax
  801f65:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  801f6c:	00 00 00 
  801f6f:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801f71:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f76:	bf 00 00 00 00       	mov    $0x0,%edi
  801f7b:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  801f82:	00 00 00 
  801f85:	ff d0                	callq  *%rax
  801f87:	85 c0                	test   %eax,%eax
  801f89:	79 54                	jns    801fdf <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801f8b:	48 ba 70 45 80 00 00 	movabs $0x804570,%rdx
  801f92:	00 00 00 
  801f95:	be 32 00 00 00       	mov    $0x32,%esi
  801f9a:	48 bf 45 45 80 00 00 	movabs $0x804545,%rdi
  801fa1:	00 00 00 
  801fa4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa9:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  801fb0:	00 00 00 
  801fb3:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801fb5:	48 ba 98 45 80 00 00 	movabs $0x804598,%rdx
  801fbc:	00 00 00 
  801fbf:	be 34 00 00 00       	mov    $0x34,%esi
  801fc4:	48 bf 45 45 80 00 00 	movabs $0x804545,%rdi
  801fcb:	00 00 00 
  801fce:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd3:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  801fda:	00 00 00 
  801fdd:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801fdf:	c9                   	leaveq 
  801fe0:	c3                   	retq   

0000000000801fe1 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801fe1:	55                   	push   %rbp
  801fe2:	48 89 e5             	mov    %rsp,%rbp
  801fe5:	48 83 ec 20          	sub    $0x20,%rsp
  801fe9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fec:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801fef:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ff6:	01 00 00 
  801ff9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801ffc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802000:	25 07 0e 00 00       	and    $0xe07,%eax
  802005:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  802008:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80200b:	48 c1 e0 0c          	shl    $0xc,%rax
  80200f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  802013:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802016:	25 00 04 00 00       	and    $0x400,%eax
  80201b:	85 c0                	test   %eax,%eax
  80201d:	74 57                	je     802076 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80201f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802022:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802026:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802029:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80202d:	41 89 f0             	mov    %esi,%r8d
  802030:	48 89 c6             	mov    %rax,%rsi
  802033:	bf 00 00 00 00       	mov    $0x0,%edi
  802038:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  80203f:	00 00 00 
  802042:	ff d0                	callq  *%rax
  802044:	85 c0                	test   %eax,%eax
  802046:	0f 8e 52 01 00 00    	jle    80219e <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  80204c:	48 ba ca 45 80 00 00 	movabs $0x8045ca,%rdx
  802053:	00 00 00 
  802056:	be 4e 00 00 00       	mov    $0x4e,%esi
  80205b:	48 bf 45 45 80 00 00 	movabs $0x804545,%rdi
  802062:	00 00 00 
  802065:	b8 00 00 00 00       	mov    $0x0,%eax
  80206a:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  802071:	00 00 00 
  802074:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  802076:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802079:	83 e0 02             	and    $0x2,%eax
  80207c:	85 c0                	test   %eax,%eax
  80207e:	75 10                	jne    802090 <duppage+0xaf>
  802080:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802083:	25 00 08 00 00       	and    $0x800,%eax
  802088:	85 c0                	test   %eax,%eax
  80208a:	0f 84 bb 00 00 00    	je     80214b <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  802090:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802093:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  802098:	80 cc 08             	or     $0x8,%ah
  80209b:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80209e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8020a1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8020a5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020ac:	41 89 f0             	mov    %esi,%r8d
  8020af:	48 89 c6             	mov    %rax,%rsi
  8020b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8020b7:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  8020be:	00 00 00 
  8020c1:	ff d0                	callq  *%rax
  8020c3:	85 c0                	test   %eax,%eax
  8020c5:	7e 2a                	jle    8020f1 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  8020c7:	48 ba ca 45 80 00 00 	movabs $0x8045ca,%rdx
  8020ce:	00 00 00 
  8020d1:	be 55 00 00 00       	mov    $0x55,%esi
  8020d6:	48 bf 45 45 80 00 00 	movabs $0x804545,%rdi
  8020dd:	00 00 00 
  8020e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e5:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  8020ec:	00 00 00 
  8020ef:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8020f1:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8020f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020fc:	41 89 c8             	mov    %ecx,%r8d
  8020ff:	48 89 d1             	mov    %rdx,%rcx
  802102:	ba 00 00 00 00       	mov    $0x0,%edx
  802107:	48 89 c6             	mov    %rax,%rsi
  80210a:	bf 00 00 00 00       	mov    $0x0,%edi
  80210f:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  802116:	00 00 00 
  802119:	ff d0                	callq  *%rax
  80211b:	85 c0                	test   %eax,%eax
  80211d:	7e 2a                	jle    802149 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  80211f:	48 ba ca 45 80 00 00 	movabs $0x8045ca,%rdx
  802126:	00 00 00 
  802129:	be 57 00 00 00       	mov    $0x57,%esi
  80212e:	48 bf 45 45 80 00 00 	movabs $0x804545,%rdi
  802135:	00 00 00 
  802138:	b8 00 00 00 00       	mov    $0x0,%eax
  80213d:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  802144:	00 00 00 
  802147:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802149:	eb 53                	jmp    80219e <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80214b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80214e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802152:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802155:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802159:	41 89 f0             	mov    %esi,%r8d
  80215c:	48 89 c6             	mov    %rax,%rsi
  80215f:	bf 00 00 00 00       	mov    $0x0,%edi
  802164:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  80216b:	00 00 00 
  80216e:	ff d0                	callq  *%rax
  802170:	85 c0                	test   %eax,%eax
  802172:	7e 2a                	jle    80219e <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802174:	48 ba ca 45 80 00 00 	movabs $0x8045ca,%rdx
  80217b:	00 00 00 
  80217e:	be 5b 00 00 00       	mov    $0x5b,%esi
  802183:	48 bf 45 45 80 00 00 	movabs $0x804545,%rdi
  80218a:	00 00 00 
  80218d:	b8 00 00 00 00       	mov    $0x0,%eax
  802192:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  802199:	00 00 00 
  80219c:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  80219e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a3:	c9                   	leaveq 
  8021a4:	c3                   	retq   

00000000008021a5 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  8021a5:	55                   	push   %rbp
  8021a6:	48 89 e5             	mov    %rsp,%rbp
  8021a9:	48 83 ec 18          	sub    $0x18,%rsp
  8021ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  8021b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  8021b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021bd:	48 c1 e8 27          	shr    $0x27,%rax
  8021c1:	48 89 c2             	mov    %rax,%rdx
  8021c4:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8021cb:	01 00 00 
  8021ce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021d2:	83 e0 01             	and    $0x1,%eax
  8021d5:	48 85 c0             	test   %rax,%rax
  8021d8:	74 51                	je     80222b <pt_is_mapped+0x86>
  8021da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021de:	48 c1 e0 0c          	shl    $0xc,%rax
  8021e2:	48 c1 e8 1e          	shr    $0x1e,%rax
  8021e6:	48 89 c2             	mov    %rax,%rdx
  8021e9:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8021f0:	01 00 00 
  8021f3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021f7:	83 e0 01             	and    $0x1,%eax
  8021fa:	48 85 c0             	test   %rax,%rax
  8021fd:	74 2c                	je     80222b <pt_is_mapped+0x86>
  8021ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802203:	48 c1 e0 0c          	shl    $0xc,%rax
  802207:	48 c1 e8 15          	shr    $0x15,%rax
  80220b:	48 89 c2             	mov    %rax,%rdx
  80220e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802215:	01 00 00 
  802218:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80221c:	83 e0 01             	and    $0x1,%eax
  80221f:	48 85 c0             	test   %rax,%rax
  802222:	74 07                	je     80222b <pt_is_mapped+0x86>
  802224:	b8 01 00 00 00       	mov    $0x1,%eax
  802229:	eb 05                	jmp    802230 <pt_is_mapped+0x8b>
  80222b:	b8 00 00 00 00       	mov    $0x0,%eax
  802230:	83 e0 01             	and    $0x1,%eax
}
  802233:	c9                   	leaveq 
  802234:	c3                   	retq   

0000000000802235 <fork>:

envid_t
fork(void)
{
  802235:	55                   	push   %rbp
  802236:	48 89 e5             	mov    %rsp,%rbp
  802239:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  80223d:	48 bf 4c 1e 80 00 00 	movabs $0x801e4c,%rdi
  802244:	00 00 00 
  802247:	48 b8 8b 3b 80 00 00 	movabs $0x803b8b,%rax
  80224e:	00 00 00 
  802251:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802253:	b8 07 00 00 00       	mov    $0x7,%eax
  802258:	cd 30                	int    $0x30
  80225a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80225d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  802260:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  802263:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802267:	79 30                	jns    802299 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802269:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80226c:	89 c1                	mov    %eax,%ecx
  80226e:	48 ba e8 45 80 00 00 	movabs $0x8045e8,%rdx
  802275:	00 00 00 
  802278:	be 86 00 00 00       	mov    $0x86,%esi
  80227d:	48 bf 45 45 80 00 00 	movabs $0x804545,%rdi
  802284:	00 00 00 
  802287:	b8 00 00 00 00       	mov    $0x0,%eax
  80228c:	49 b8 c2 04 80 00 00 	movabs $0x8004c2,%r8
  802293:	00 00 00 
  802296:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802299:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80229d:	75 46                	jne    8022e5 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80229f:	48 b8 63 1b 80 00 00 	movabs $0x801b63,%rax
  8022a6:	00 00 00 
  8022a9:	ff d0                	callq  *%rax
  8022ab:	25 ff 03 00 00       	and    $0x3ff,%eax
  8022b0:	48 63 d0             	movslq %eax,%rdx
  8022b3:	48 89 d0             	mov    %rdx,%rax
  8022b6:	48 c1 e0 03          	shl    $0x3,%rax
  8022ba:	48 01 d0             	add    %rdx,%rax
  8022bd:	48 c1 e0 05          	shl    $0x5,%rax
  8022c1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8022c8:	00 00 00 
  8022cb:	48 01 c2             	add    %rax,%rdx
  8022ce:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022d5:	00 00 00 
  8022d8:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8022db:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e0:	e9 d1 01 00 00       	jmpq   8024b6 <fork+0x281>
	}
	uint64_t ad = 0;
  8022e5:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8022ec:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8022ed:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8022f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8022f6:	e9 df 00 00 00       	jmpq   8023da <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8022fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ff:	48 c1 e8 27          	shr    $0x27,%rax
  802303:	48 89 c2             	mov    %rax,%rdx
  802306:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80230d:	01 00 00 
  802310:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802314:	83 e0 01             	and    $0x1,%eax
  802317:	48 85 c0             	test   %rax,%rax
  80231a:	0f 84 9e 00 00 00    	je     8023be <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802320:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802324:	48 c1 e8 1e          	shr    $0x1e,%rax
  802328:	48 89 c2             	mov    %rax,%rdx
  80232b:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802332:	01 00 00 
  802335:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802339:	83 e0 01             	and    $0x1,%eax
  80233c:	48 85 c0             	test   %rax,%rax
  80233f:	74 73                	je     8023b4 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  802341:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802345:	48 c1 e8 15          	shr    $0x15,%rax
  802349:	48 89 c2             	mov    %rax,%rdx
  80234c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802353:	01 00 00 
  802356:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80235a:	83 e0 01             	and    $0x1,%eax
  80235d:	48 85 c0             	test   %rax,%rax
  802360:	74 48                	je     8023aa <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802362:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802366:	48 c1 e8 0c          	shr    $0xc,%rax
  80236a:	48 89 c2             	mov    %rax,%rdx
  80236d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802374:	01 00 00 
  802377:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80237b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80237f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802383:	83 e0 01             	and    $0x1,%eax
  802386:	48 85 c0             	test   %rax,%rax
  802389:	74 47                	je     8023d2 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  80238b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80238f:	48 c1 e8 0c          	shr    $0xc,%rax
  802393:	89 c2                	mov    %eax,%edx
  802395:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802398:	89 d6                	mov    %edx,%esi
  80239a:	89 c7                	mov    %eax,%edi
  80239c:	48 b8 e1 1f 80 00 00 	movabs $0x801fe1,%rax
  8023a3:	00 00 00 
  8023a6:	ff d0                	callq  *%rax
  8023a8:	eb 28                	jmp    8023d2 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  8023aa:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8023b1:	00 
  8023b2:	eb 1e                	jmp    8023d2 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8023b4:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8023bb:	40 
  8023bc:	eb 14                	jmp    8023d2 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8023be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023c2:	48 c1 e8 27          	shr    $0x27,%rax
  8023c6:	48 83 c0 01          	add    $0x1,%rax
  8023ca:	48 c1 e0 27          	shl    $0x27,%rax
  8023ce:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8023d2:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8023d9:	00 
  8023da:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8023e1:	00 
  8023e2:	0f 87 13 ff ff ff    	ja     8022fb <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8023e8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023eb:	ba 07 00 00 00       	mov    $0x7,%edx
  8023f0:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8023f5:	89 c7                	mov    %eax,%edi
  8023f7:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  8023fe:	00 00 00 
  802401:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802403:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802406:	ba 07 00 00 00       	mov    $0x7,%edx
  80240b:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802410:	89 c7                	mov    %eax,%edi
  802412:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  802419:	00 00 00 
  80241c:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  80241e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802421:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802427:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  80242c:	ba 00 00 00 00       	mov    $0x0,%edx
  802431:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802436:	89 c7                	mov    %eax,%edi
  802438:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  80243f:	00 00 00 
  802442:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802444:	ba 00 10 00 00       	mov    $0x1000,%edx
  802449:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80244e:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802453:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  80245a:	00 00 00 
  80245d:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  80245f:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802464:	bf 00 00 00 00       	mov    $0x0,%edi
  802469:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  802470:	00 00 00 
  802473:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802475:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80247c:	00 00 00 
  80247f:	48 8b 00             	mov    (%rax),%rax
  802482:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802489:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80248c:	48 89 d6             	mov    %rdx,%rsi
  80248f:	89 c7                	mov    %eax,%edi
  802491:	48 b8 69 1d 80 00 00 	movabs $0x801d69,%rax
  802498:	00 00 00 
  80249b:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  80249d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024a0:	be 02 00 00 00       	mov    $0x2,%esi
  8024a5:	89 c7                	mov    %eax,%edi
  8024a7:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  8024ae:	00 00 00 
  8024b1:	ff d0                	callq  *%rax

	return envid;
  8024b3:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8024b6:	c9                   	leaveq 
  8024b7:	c3                   	retq   

00000000008024b8 <sfork>:

	
// Challenge!
int
sfork(void)
{
  8024b8:	55                   	push   %rbp
  8024b9:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8024bc:	48 ba 00 46 80 00 00 	movabs $0x804600,%rdx
  8024c3:	00 00 00 
  8024c6:	be bf 00 00 00       	mov    $0xbf,%esi
  8024cb:	48 bf 45 45 80 00 00 	movabs $0x804545,%rdi
  8024d2:	00 00 00 
  8024d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024da:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  8024e1:	00 00 00 
  8024e4:	ff d1                	callq  *%rcx

00000000008024e6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8024e6:	55                   	push   %rbp
  8024e7:	48 89 e5             	mov    %rsp,%rbp
  8024ea:	48 83 ec 08          	sub    $0x8,%rsp
  8024ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8024f2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024f6:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8024fd:	ff ff ff 
  802500:	48 01 d0             	add    %rdx,%rax
  802503:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802507:	c9                   	leaveq 
  802508:	c3                   	retq   

0000000000802509 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802509:	55                   	push   %rbp
  80250a:	48 89 e5             	mov    %rsp,%rbp
  80250d:	48 83 ec 08          	sub    $0x8,%rsp
  802511:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802515:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802519:	48 89 c7             	mov    %rax,%rdi
  80251c:	48 b8 e6 24 80 00 00 	movabs $0x8024e6,%rax
  802523:	00 00 00 
  802526:	ff d0                	callq  *%rax
  802528:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80252e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802532:	c9                   	leaveq 
  802533:	c3                   	retq   

0000000000802534 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802534:	55                   	push   %rbp
  802535:	48 89 e5             	mov    %rsp,%rbp
  802538:	48 83 ec 18          	sub    $0x18,%rsp
  80253c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802540:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802547:	eb 6b                	jmp    8025b4 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802549:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80254c:	48 98                	cltq   
  80254e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802554:	48 c1 e0 0c          	shl    $0xc,%rax
  802558:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80255c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802560:	48 c1 e8 15          	shr    $0x15,%rax
  802564:	48 89 c2             	mov    %rax,%rdx
  802567:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80256e:	01 00 00 
  802571:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802575:	83 e0 01             	and    $0x1,%eax
  802578:	48 85 c0             	test   %rax,%rax
  80257b:	74 21                	je     80259e <fd_alloc+0x6a>
  80257d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802581:	48 c1 e8 0c          	shr    $0xc,%rax
  802585:	48 89 c2             	mov    %rax,%rdx
  802588:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80258f:	01 00 00 
  802592:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802596:	83 e0 01             	and    $0x1,%eax
  802599:	48 85 c0             	test   %rax,%rax
  80259c:	75 12                	jne    8025b0 <fd_alloc+0x7c>
			*fd_store = fd;
  80259e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025a6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ae:	eb 1a                	jmp    8025ca <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8025b0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025b4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8025b8:	7e 8f                	jle    802549 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8025ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025be:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8025c5:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8025ca:	c9                   	leaveq 
  8025cb:	c3                   	retq   

00000000008025cc <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8025cc:	55                   	push   %rbp
  8025cd:	48 89 e5             	mov    %rsp,%rbp
  8025d0:	48 83 ec 20          	sub    $0x20,%rsp
  8025d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8025db:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8025df:	78 06                	js     8025e7 <fd_lookup+0x1b>
  8025e1:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8025e5:	7e 07                	jle    8025ee <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025ec:	eb 6c                	jmp    80265a <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8025ee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025f1:	48 98                	cltq   
  8025f3:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025f9:	48 c1 e0 0c          	shl    $0xc,%rax
  8025fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802601:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802605:	48 c1 e8 15          	shr    $0x15,%rax
  802609:	48 89 c2             	mov    %rax,%rdx
  80260c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802613:	01 00 00 
  802616:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80261a:	83 e0 01             	and    $0x1,%eax
  80261d:	48 85 c0             	test   %rax,%rax
  802620:	74 21                	je     802643 <fd_lookup+0x77>
  802622:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802626:	48 c1 e8 0c          	shr    $0xc,%rax
  80262a:	48 89 c2             	mov    %rax,%rdx
  80262d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802634:	01 00 00 
  802637:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80263b:	83 e0 01             	and    $0x1,%eax
  80263e:	48 85 c0             	test   %rax,%rax
  802641:	75 07                	jne    80264a <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802643:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802648:	eb 10                	jmp    80265a <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80264a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80264e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802652:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802655:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80265a:	c9                   	leaveq 
  80265b:	c3                   	retq   

000000000080265c <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80265c:	55                   	push   %rbp
  80265d:	48 89 e5             	mov    %rsp,%rbp
  802660:	48 83 ec 30          	sub    $0x30,%rsp
  802664:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802668:	89 f0                	mov    %esi,%eax
  80266a:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80266d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802671:	48 89 c7             	mov    %rax,%rdi
  802674:	48 b8 e6 24 80 00 00 	movabs $0x8024e6,%rax
  80267b:	00 00 00 
  80267e:	ff d0                	callq  *%rax
  802680:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802684:	48 89 d6             	mov    %rdx,%rsi
  802687:	89 c7                	mov    %eax,%edi
  802689:	48 b8 cc 25 80 00 00 	movabs $0x8025cc,%rax
  802690:	00 00 00 
  802693:	ff d0                	callq  *%rax
  802695:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802698:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80269c:	78 0a                	js     8026a8 <fd_close+0x4c>
	    || fd != fd2)
  80269e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a2:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8026a6:	74 12                	je     8026ba <fd_close+0x5e>
		return (must_exist ? r : 0);
  8026a8:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8026ac:	74 05                	je     8026b3 <fd_close+0x57>
  8026ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026b1:	eb 05                	jmp    8026b8 <fd_close+0x5c>
  8026b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b8:	eb 69                	jmp    802723 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8026ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026be:	8b 00                	mov    (%rax),%eax
  8026c0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026c4:	48 89 d6             	mov    %rdx,%rsi
  8026c7:	89 c7                	mov    %eax,%edi
  8026c9:	48 b8 25 27 80 00 00 	movabs $0x802725,%rax
  8026d0:	00 00 00 
  8026d3:	ff d0                	callq  *%rax
  8026d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026dc:	78 2a                	js     802708 <fd_close+0xac>
		if (dev->dev_close)
  8026de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e2:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026e6:	48 85 c0             	test   %rax,%rax
  8026e9:	74 16                	je     802701 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8026eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ef:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026f3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026f7:	48 89 d7             	mov    %rdx,%rdi
  8026fa:	ff d0                	callq  *%rax
  8026fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ff:	eb 07                	jmp    802708 <fd_close+0xac>
		else
			r = 0;
  802701:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802708:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80270c:	48 89 c6             	mov    %rax,%rsi
  80270f:	bf 00 00 00 00       	mov    $0x0,%edi
  802714:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  80271b:	00 00 00 
  80271e:	ff d0                	callq  *%rax
	return r;
  802720:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802723:	c9                   	leaveq 
  802724:	c3                   	retq   

0000000000802725 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802725:	55                   	push   %rbp
  802726:	48 89 e5             	mov    %rsp,%rbp
  802729:	48 83 ec 20          	sub    $0x20,%rsp
  80272d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802730:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802734:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80273b:	eb 41                	jmp    80277e <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80273d:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802744:	00 00 00 
  802747:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80274a:	48 63 d2             	movslq %edx,%rdx
  80274d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802751:	8b 00                	mov    (%rax),%eax
  802753:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802756:	75 22                	jne    80277a <dev_lookup+0x55>
			*dev = devtab[i];
  802758:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80275f:	00 00 00 
  802762:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802765:	48 63 d2             	movslq %edx,%rdx
  802768:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80276c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802770:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802773:	b8 00 00 00 00       	mov    $0x0,%eax
  802778:	eb 60                	jmp    8027da <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80277a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80277e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802785:	00 00 00 
  802788:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80278b:	48 63 d2             	movslq %edx,%rdx
  80278e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802792:	48 85 c0             	test   %rax,%rax
  802795:	75 a6                	jne    80273d <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802797:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80279e:	00 00 00 
  8027a1:	48 8b 00             	mov    (%rax),%rax
  8027a4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027aa:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8027ad:	89 c6                	mov    %eax,%esi
  8027af:	48 bf 18 46 80 00 00 	movabs $0x804618,%rdi
  8027b6:	00 00 00 
  8027b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027be:	48 b9 fb 06 80 00 00 	movabs $0x8006fb,%rcx
  8027c5:	00 00 00 
  8027c8:	ff d1                	callq  *%rcx
	*dev = 0;
  8027ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027ce:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8027d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8027da:	c9                   	leaveq 
  8027db:	c3                   	retq   

00000000008027dc <close>:

int
close(int fdnum)
{
  8027dc:	55                   	push   %rbp
  8027dd:	48 89 e5             	mov    %rsp,%rbp
  8027e0:	48 83 ec 20          	sub    $0x20,%rsp
  8027e4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027e7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027ee:	48 89 d6             	mov    %rdx,%rsi
  8027f1:	89 c7                	mov    %eax,%edi
  8027f3:	48 b8 cc 25 80 00 00 	movabs $0x8025cc,%rax
  8027fa:	00 00 00 
  8027fd:	ff d0                	callq  *%rax
  8027ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802802:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802806:	79 05                	jns    80280d <close+0x31>
		return r;
  802808:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80280b:	eb 18                	jmp    802825 <close+0x49>
	else
		return fd_close(fd, 1);
  80280d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802811:	be 01 00 00 00       	mov    $0x1,%esi
  802816:	48 89 c7             	mov    %rax,%rdi
  802819:	48 b8 5c 26 80 00 00 	movabs $0x80265c,%rax
  802820:	00 00 00 
  802823:	ff d0                	callq  *%rax
}
  802825:	c9                   	leaveq 
  802826:	c3                   	retq   

0000000000802827 <close_all>:

void
close_all(void)
{
  802827:	55                   	push   %rbp
  802828:	48 89 e5             	mov    %rsp,%rbp
  80282b:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80282f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802836:	eb 15                	jmp    80284d <close_all+0x26>
		close(i);
  802838:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80283b:	89 c7                	mov    %eax,%edi
  80283d:	48 b8 dc 27 80 00 00 	movabs $0x8027dc,%rax
  802844:	00 00 00 
  802847:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802849:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80284d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802851:	7e e5                	jle    802838 <close_all+0x11>
		close(i);
}
  802853:	c9                   	leaveq 
  802854:	c3                   	retq   

0000000000802855 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802855:	55                   	push   %rbp
  802856:	48 89 e5             	mov    %rsp,%rbp
  802859:	48 83 ec 40          	sub    $0x40,%rsp
  80285d:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802860:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802863:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802867:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80286a:	48 89 d6             	mov    %rdx,%rsi
  80286d:	89 c7                	mov    %eax,%edi
  80286f:	48 b8 cc 25 80 00 00 	movabs $0x8025cc,%rax
  802876:	00 00 00 
  802879:	ff d0                	callq  *%rax
  80287b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80287e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802882:	79 08                	jns    80288c <dup+0x37>
		return r;
  802884:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802887:	e9 70 01 00 00       	jmpq   8029fc <dup+0x1a7>
	close(newfdnum);
  80288c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80288f:	89 c7                	mov    %eax,%edi
  802891:	48 b8 dc 27 80 00 00 	movabs $0x8027dc,%rax
  802898:	00 00 00 
  80289b:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80289d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028a0:	48 98                	cltq   
  8028a2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028a8:	48 c1 e0 0c          	shl    $0xc,%rax
  8028ac:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8028b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028b4:	48 89 c7             	mov    %rax,%rdi
  8028b7:	48 b8 09 25 80 00 00 	movabs $0x802509,%rax
  8028be:	00 00 00 
  8028c1:	ff d0                	callq  *%rax
  8028c3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8028c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028cb:	48 89 c7             	mov    %rax,%rdi
  8028ce:	48 b8 09 25 80 00 00 	movabs $0x802509,%rax
  8028d5:	00 00 00 
  8028d8:	ff d0                	callq  *%rax
  8028da:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8028de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e2:	48 c1 e8 15          	shr    $0x15,%rax
  8028e6:	48 89 c2             	mov    %rax,%rdx
  8028e9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028f0:	01 00 00 
  8028f3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028f7:	83 e0 01             	and    $0x1,%eax
  8028fa:	48 85 c0             	test   %rax,%rax
  8028fd:	74 73                	je     802972 <dup+0x11d>
  8028ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802903:	48 c1 e8 0c          	shr    $0xc,%rax
  802907:	48 89 c2             	mov    %rax,%rdx
  80290a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802911:	01 00 00 
  802914:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802918:	83 e0 01             	and    $0x1,%eax
  80291b:	48 85 c0             	test   %rax,%rax
  80291e:	74 52                	je     802972 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802920:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802924:	48 c1 e8 0c          	shr    $0xc,%rax
  802928:	48 89 c2             	mov    %rax,%rdx
  80292b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802932:	01 00 00 
  802935:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802939:	25 07 0e 00 00       	and    $0xe07,%eax
  80293e:	89 c1                	mov    %eax,%ecx
  802940:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802944:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802948:	41 89 c8             	mov    %ecx,%r8d
  80294b:	48 89 d1             	mov    %rdx,%rcx
  80294e:	ba 00 00 00 00       	mov    $0x0,%edx
  802953:	48 89 c6             	mov    %rax,%rsi
  802956:	bf 00 00 00 00       	mov    $0x0,%edi
  80295b:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  802962:	00 00 00 
  802965:	ff d0                	callq  *%rax
  802967:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80296a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80296e:	79 02                	jns    802972 <dup+0x11d>
			goto err;
  802970:	eb 57                	jmp    8029c9 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802972:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802976:	48 c1 e8 0c          	shr    $0xc,%rax
  80297a:	48 89 c2             	mov    %rax,%rdx
  80297d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802984:	01 00 00 
  802987:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80298b:	25 07 0e 00 00       	and    $0xe07,%eax
  802990:	89 c1                	mov    %eax,%ecx
  802992:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802996:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80299a:	41 89 c8             	mov    %ecx,%r8d
  80299d:	48 89 d1             	mov    %rdx,%rcx
  8029a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8029a5:	48 89 c6             	mov    %rax,%rsi
  8029a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8029ad:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  8029b4:	00 00 00 
  8029b7:	ff d0                	callq  *%rax
  8029b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029c0:	79 02                	jns    8029c4 <dup+0x16f>
		goto err;
  8029c2:	eb 05                	jmp    8029c9 <dup+0x174>

	return newfdnum;
  8029c4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029c7:	eb 33                	jmp    8029fc <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8029c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029cd:	48 89 c6             	mov    %rax,%rsi
  8029d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8029d5:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  8029dc:	00 00 00 
  8029df:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8029e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029e5:	48 89 c6             	mov    %rax,%rsi
  8029e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8029ed:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  8029f4:	00 00 00 
  8029f7:	ff d0                	callq  *%rax
	return r;
  8029f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029fc:	c9                   	leaveq 
  8029fd:	c3                   	retq   

00000000008029fe <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8029fe:	55                   	push   %rbp
  8029ff:	48 89 e5             	mov    %rsp,%rbp
  802a02:	48 83 ec 40          	sub    $0x40,%rsp
  802a06:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a09:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a0d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a11:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a15:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a18:	48 89 d6             	mov    %rdx,%rsi
  802a1b:	89 c7                	mov    %eax,%edi
  802a1d:	48 b8 cc 25 80 00 00 	movabs $0x8025cc,%rax
  802a24:	00 00 00 
  802a27:	ff d0                	callq  *%rax
  802a29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a30:	78 24                	js     802a56 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a36:	8b 00                	mov    (%rax),%eax
  802a38:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a3c:	48 89 d6             	mov    %rdx,%rsi
  802a3f:	89 c7                	mov    %eax,%edi
  802a41:	48 b8 25 27 80 00 00 	movabs $0x802725,%rax
  802a48:	00 00 00 
  802a4b:	ff d0                	callq  *%rax
  802a4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a54:	79 05                	jns    802a5b <read+0x5d>
		return r;
  802a56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a59:	eb 76                	jmp    802ad1 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802a5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a5f:	8b 40 08             	mov    0x8(%rax),%eax
  802a62:	83 e0 03             	and    $0x3,%eax
  802a65:	83 f8 01             	cmp    $0x1,%eax
  802a68:	75 3a                	jne    802aa4 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802a6a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802a71:	00 00 00 
  802a74:	48 8b 00             	mov    (%rax),%rax
  802a77:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a7d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a80:	89 c6                	mov    %eax,%esi
  802a82:	48 bf 37 46 80 00 00 	movabs $0x804637,%rdi
  802a89:	00 00 00 
  802a8c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a91:	48 b9 fb 06 80 00 00 	movabs $0x8006fb,%rcx
  802a98:	00 00 00 
  802a9b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a9d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802aa2:	eb 2d                	jmp    802ad1 <read+0xd3>
	}
	if (!dev->dev_read)
  802aa4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aa8:	48 8b 40 10          	mov    0x10(%rax),%rax
  802aac:	48 85 c0             	test   %rax,%rax
  802aaf:	75 07                	jne    802ab8 <read+0xba>
		return -E_NOT_SUPP;
  802ab1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ab6:	eb 19                	jmp    802ad1 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802ab8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802abc:	48 8b 40 10          	mov    0x10(%rax),%rax
  802ac0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ac4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ac8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802acc:	48 89 cf             	mov    %rcx,%rdi
  802acf:	ff d0                	callq  *%rax
}
  802ad1:	c9                   	leaveq 
  802ad2:	c3                   	retq   

0000000000802ad3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802ad3:	55                   	push   %rbp
  802ad4:	48 89 e5             	mov    %rsp,%rbp
  802ad7:	48 83 ec 30          	sub    $0x30,%rsp
  802adb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ade:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ae2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ae6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802aed:	eb 49                	jmp    802b38 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802aef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af2:	48 98                	cltq   
  802af4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802af8:	48 29 c2             	sub    %rax,%rdx
  802afb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802afe:	48 63 c8             	movslq %eax,%rcx
  802b01:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b05:	48 01 c1             	add    %rax,%rcx
  802b08:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b0b:	48 89 ce             	mov    %rcx,%rsi
  802b0e:	89 c7                	mov    %eax,%edi
  802b10:	48 b8 fe 29 80 00 00 	movabs $0x8029fe,%rax
  802b17:	00 00 00 
  802b1a:	ff d0                	callq  *%rax
  802b1c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802b1f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b23:	79 05                	jns    802b2a <readn+0x57>
			return m;
  802b25:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b28:	eb 1c                	jmp    802b46 <readn+0x73>
		if (m == 0)
  802b2a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b2e:	75 02                	jne    802b32 <readn+0x5f>
			break;
  802b30:	eb 11                	jmp    802b43 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b32:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b35:	01 45 fc             	add    %eax,-0x4(%rbp)
  802b38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b3b:	48 98                	cltq   
  802b3d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b41:	72 ac                	jb     802aef <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802b43:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b46:	c9                   	leaveq 
  802b47:	c3                   	retq   

0000000000802b48 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802b48:	55                   	push   %rbp
  802b49:	48 89 e5             	mov    %rsp,%rbp
  802b4c:	48 83 ec 40          	sub    $0x40,%rsp
  802b50:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b53:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b57:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b5b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b5f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b62:	48 89 d6             	mov    %rdx,%rsi
  802b65:	89 c7                	mov    %eax,%edi
  802b67:	48 b8 cc 25 80 00 00 	movabs $0x8025cc,%rax
  802b6e:	00 00 00 
  802b71:	ff d0                	callq  *%rax
  802b73:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b76:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b7a:	78 24                	js     802ba0 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b80:	8b 00                	mov    (%rax),%eax
  802b82:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b86:	48 89 d6             	mov    %rdx,%rsi
  802b89:	89 c7                	mov    %eax,%edi
  802b8b:	48 b8 25 27 80 00 00 	movabs $0x802725,%rax
  802b92:	00 00 00 
  802b95:	ff d0                	callq  *%rax
  802b97:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b9e:	79 05                	jns    802ba5 <write+0x5d>
		return r;
  802ba0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba3:	eb 75                	jmp    802c1a <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ba5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba9:	8b 40 08             	mov    0x8(%rax),%eax
  802bac:	83 e0 03             	and    $0x3,%eax
  802baf:	85 c0                	test   %eax,%eax
  802bb1:	75 3a                	jne    802bed <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802bb3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802bba:	00 00 00 
  802bbd:	48 8b 00             	mov    (%rax),%rax
  802bc0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802bc6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802bc9:	89 c6                	mov    %eax,%esi
  802bcb:	48 bf 53 46 80 00 00 	movabs $0x804653,%rdi
  802bd2:	00 00 00 
  802bd5:	b8 00 00 00 00       	mov    $0x0,%eax
  802bda:	48 b9 fb 06 80 00 00 	movabs $0x8006fb,%rcx
  802be1:	00 00 00 
  802be4:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802be6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802beb:	eb 2d                	jmp    802c1a <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802bed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bf1:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bf5:	48 85 c0             	test   %rax,%rax
  802bf8:	75 07                	jne    802c01 <write+0xb9>
		return -E_NOT_SUPP;
  802bfa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bff:	eb 19                	jmp    802c1a <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802c01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c05:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c09:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c0d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c11:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c15:	48 89 cf             	mov    %rcx,%rdi
  802c18:	ff d0                	callq  *%rax
}
  802c1a:	c9                   	leaveq 
  802c1b:	c3                   	retq   

0000000000802c1c <seek>:

int
seek(int fdnum, off_t offset)
{
  802c1c:	55                   	push   %rbp
  802c1d:	48 89 e5             	mov    %rsp,%rbp
  802c20:	48 83 ec 18          	sub    $0x18,%rsp
  802c24:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c27:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c2a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c2e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c31:	48 89 d6             	mov    %rdx,%rsi
  802c34:	89 c7                	mov    %eax,%edi
  802c36:	48 b8 cc 25 80 00 00 	movabs $0x8025cc,%rax
  802c3d:	00 00 00 
  802c40:	ff d0                	callq  *%rax
  802c42:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c45:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c49:	79 05                	jns    802c50 <seek+0x34>
		return r;
  802c4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4e:	eb 0f                	jmp    802c5f <seek+0x43>
	fd->fd_offset = offset;
  802c50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c54:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c57:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802c5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c5f:	c9                   	leaveq 
  802c60:	c3                   	retq   

0000000000802c61 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802c61:	55                   	push   %rbp
  802c62:	48 89 e5             	mov    %rsp,%rbp
  802c65:	48 83 ec 30          	sub    $0x30,%rsp
  802c69:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c6c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c6f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c73:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c76:	48 89 d6             	mov    %rdx,%rsi
  802c79:	89 c7                	mov    %eax,%edi
  802c7b:	48 b8 cc 25 80 00 00 	movabs $0x8025cc,%rax
  802c82:	00 00 00 
  802c85:	ff d0                	callq  *%rax
  802c87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c8e:	78 24                	js     802cb4 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c94:	8b 00                	mov    (%rax),%eax
  802c96:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c9a:	48 89 d6             	mov    %rdx,%rsi
  802c9d:	89 c7                	mov    %eax,%edi
  802c9f:	48 b8 25 27 80 00 00 	movabs $0x802725,%rax
  802ca6:	00 00 00 
  802ca9:	ff d0                	callq  *%rax
  802cab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cb2:	79 05                	jns    802cb9 <ftruncate+0x58>
		return r;
  802cb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb7:	eb 72                	jmp    802d2b <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802cb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cbd:	8b 40 08             	mov    0x8(%rax),%eax
  802cc0:	83 e0 03             	and    $0x3,%eax
  802cc3:	85 c0                	test   %eax,%eax
  802cc5:	75 3a                	jne    802d01 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802cc7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802cce:	00 00 00 
  802cd1:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802cd4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cda:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802cdd:	89 c6                	mov    %eax,%esi
  802cdf:	48 bf 70 46 80 00 00 	movabs $0x804670,%rdi
  802ce6:	00 00 00 
  802ce9:	b8 00 00 00 00       	mov    $0x0,%eax
  802cee:	48 b9 fb 06 80 00 00 	movabs $0x8006fb,%rcx
  802cf5:	00 00 00 
  802cf8:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802cfa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cff:	eb 2a                	jmp    802d2b <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802d01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d05:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d09:	48 85 c0             	test   %rax,%rax
  802d0c:	75 07                	jne    802d15 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802d0e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d13:	eb 16                	jmp    802d2b <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802d15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d19:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d1d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d21:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802d24:	89 ce                	mov    %ecx,%esi
  802d26:	48 89 d7             	mov    %rdx,%rdi
  802d29:	ff d0                	callq  *%rax
}
  802d2b:	c9                   	leaveq 
  802d2c:	c3                   	retq   

0000000000802d2d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802d2d:	55                   	push   %rbp
  802d2e:	48 89 e5             	mov    %rsp,%rbp
  802d31:	48 83 ec 30          	sub    $0x30,%rsp
  802d35:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d38:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d3c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d40:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d43:	48 89 d6             	mov    %rdx,%rsi
  802d46:	89 c7                	mov    %eax,%edi
  802d48:	48 b8 cc 25 80 00 00 	movabs $0x8025cc,%rax
  802d4f:	00 00 00 
  802d52:	ff d0                	callq  *%rax
  802d54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d5b:	78 24                	js     802d81 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d61:	8b 00                	mov    (%rax),%eax
  802d63:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d67:	48 89 d6             	mov    %rdx,%rsi
  802d6a:	89 c7                	mov    %eax,%edi
  802d6c:	48 b8 25 27 80 00 00 	movabs $0x802725,%rax
  802d73:	00 00 00 
  802d76:	ff d0                	callq  *%rax
  802d78:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d7f:	79 05                	jns    802d86 <fstat+0x59>
		return r;
  802d81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d84:	eb 5e                	jmp    802de4 <fstat+0xb7>
	if (!dev->dev_stat)
  802d86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d8a:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d8e:	48 85 c0             	test   %rax,%rax
  802d91:	75 07                	jne    802d9a <fstat+0x6d>
		return -E_NOT_SUPP;
  802d93:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d98:	eb 4a                	jmp    802de4 <fstat+0xb7>
	stat->st_name[0] = 0;
  802d9a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d9e:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802da1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802da5:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802dac:	00 00 00 
	stat->st_isdir = 0;
  802daf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802db3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802dba:	00 00 00 
	stat->st_dev = dev;
  802dbd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802dc1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dc5:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802dcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd0:	48 8b 40 28          	mov    0x28(%rax),%rax
  802dd4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802dd8:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ddc:	48 89 ce             	mov    %rcx,%rsi
  802ddf:	48 89 d7             	mov    %rdx,%rdi
  802de2:	ff d0                	callq  *%rax
}
  802de4:	c9                   	leaveq 
  802de5:	c3                   	retq   

0000000000802de6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802de6:	55                   	push   %rbp
  802de7:	48 89 e5             	mov    %rsp,%rbp
  802dea:	48 83 ec 20          	sub    $0x20,%rsp
  802dee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802df2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802df6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dfa:	be 00 00 00 00       	mov    $0x0,%esi
  802dff:	48 89 c7             	mov    %rax,%rdi
  802e02:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  802e09:	00 00 00 
  802e0c:	ff d0                	callq  *%rax
  802e0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e15:	79 05                	jns    802e1c <stat+0x36>
		return fd;
  802e17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e1a:	eb 2f                	jmp    802e4b <stat+0x65>
	r = fstat(fd, stat);
  802e1c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e23:	48 89 d6             	mov    %rdx,%rsi
  802e26:	89 c7                	mov    %eax,%edi
  802e28:	48 b8 2d 2d 80 00 00 	movabs $0x802d2d,%rax
  802e2f:	00 00 00 
  802e32:	ff d0                	callq  *%rax
  802e34:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802e37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e3a:	89 c7                	mov    %eax,%edi
  802e3c:	48 b8 dc 27 80 00 00 	movabs $0x8027dc,%rax
  802e43:	00 00 00 
  802e46:	ff d0                	callq  *%rax
	return r;
  802e48:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802e4b:	c9                   	leaveq 
  802e4c:	c3                   	retq   

0000000000802e4d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802e4d:	55                   	push   %rbp
  802e4e:	48 89 e5             	mov    %rsp,%rbp
  802e51:	48 83 ec 10          	sub    $0x10,%rsp
  802e55:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e58:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802e5c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e63:	00 00 00 
  802e66:	8b 00                	mov    (%rax),%eax
  802e68:	85 c0                	test   %eax,%eax
  802e6a:	75 1d                	jne    802e89 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802e6c:	bf 01 00 00 00       	mov    $0x1,%edi
  802e71:	48 b8 33 3e 80 00 00 	movabs $0x803e33,%rax
  802e78:	00 00 00 
  802e7b:	ff d0                	callq  *%rax
  802e7d:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802e84:	00 00 00 
  802e87:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e89:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e90:	00 00 00 
  802e93:	8b 00                	mov    (%rax),%eax
  802e95:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e98:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e9d:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802ea4:	00 00 00 
  802ea7:	89 c7                	mov    %eax,%edi
  802ea9:	48 b8 d1 3d 80 00 00 	movabs $0x803dd1,%rax
  802eb0:	00 00 00 
  802eb3:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802eb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb9:	ba 00 00 00 00       	mov    $0x0,%edx
  802ebe:	48 89 c6             	mov    %rax,%rsi
  802ec1:	bf 00 00 00 00       	mov    $0x0,%edi
  802ec6:	48 b8 cb 3c 80 00 00 	movabs $0x803ccb,%rax
  802ecd:	00 00 00 
  802ed0:	ff d0                	callq  *%rax
}
  802ed2:	c9                   	leaveq 
  802ed3:	c3                   	retq   

0000000000802ed4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802ed4:	55                   	push   %rbp
  802ed5:	48 89 e5             	mov    %rsp,%rbp
  802ed8:	48 83 ec 30          	sub    $0x30,%rsp
  802edc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802ee0:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802ee3:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802eea:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802ef1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802ef8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802efd:	75 08                	jne    802f07 <open+0x33>
	{
		return r;
  802eff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f02:	e9 f2 00 00 00       	jmpq   802ff9 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802f07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f0b:	48 89 c7             	mov    %rax,%rdi
  802f0e:	48 b8 44 12 80 00 00 	movabs $0x801244,%rax
  802f15:	00 00 00 
  802f18:	ff d0                	callq  *%rax
  802f1a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802f1d:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802f24:	7e 0a                	jle    802f30 <open+0x5c>
	{
		return -E_BAD_PATH;
  802f26:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f2b:	e9 c9 00 00 00       	jmpq   802ff9 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802f30:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802f37:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802f38:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802f3c:	48 89 c7             	mov    %rax,%rdi
  802f3f:	48 b8 34 25 80 00 00 	movabs $0x802534,%rax
  802f46:	00 00 00 
  802f49:	ff d0                	callq  *%rax
  802f4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f52:	78 09                	js     802f5d <open+0x89>
  802f54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f58:	48 85 c0             	test   %rax,%rax
  802f5b:	75 08                	jne    802f65 <open+0x91>
		{
			return r;
  802f5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f60:	e9 94 00 00 00       	jmpq   802ff9 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802f65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f69:	ba 00 04 00 00       	mov    $0x400,%edx
  802f6e:	48 89 c6             	mov    %rax,%rsi
  802f71:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802f78:	00 00 00 
  802f7b:	48 b8 42 13 80 00 00 	movabs $0x801342,%rax
  802f82:	00 00 00 
  802f85:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802f87:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f8e:	00 00 00 
  802f91:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802f94:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802f9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f9e:	48 89 c6             	mov    %rax,%rsi
  802fa1:	bf 01 00 00 00       	mov    $0x1,%edi
  802fa6:	48 b8 4d 2e 80 00 00 	movabs $0x802e4d,%rax
  802fad:	00 00 00 
  802fb0:	ff d0                	callq  *%rax
  802fb2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fb5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fb9:	79 2b                	jns    802fe6 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802fbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fbf:	be 00 00 00 00       	mov    $0x0,%esi
  802fc4:	48 89 c7             	mov    %rax,%rdi
  802fc7:	48 b8 5c 26 80 00 00 	movabs $0x80265c,%rax
  802fce:	00 00 00 
  802fd1:	ff d0                	callq  *%rax
  802fd3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802fd6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802fda:	79 05                	jns    802fe1 <open+0x10d>
			{
				return d;
  802fdc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fdf:	eb 18                	jmp    802ff9 <open+0x125>
			}
			return r;
  802fe1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe4:	eb 13                	jmp    802ff9 <open+0x125>
		}	
		return fd2num(fd_store);
  802fe6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fea:	48 89 c7             	mov    %rax,%rdi
  802fed:	48 b8 e6 24 80 00 00 	movabs $0x8024e6,%rax
  802ff4:	00 00 00 
  802ff7:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802ff9:	c9                   	leaveq 
  802ffa:	c3                   	retq   

0000000000802ffb <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802ffb:	55                   	push   %rbp
  802ffc:	48 89 e5             	mov    %rsp,%rbp
  802fff:	48 83 ec 10          	sub    $0x10,%rsp
  803003:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803007:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80300b:	8b 50 0c             	mov    0xc(%rax),%edx
  80300e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803015:	00 00 00 
  803018:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80301a:	be 00 00 00 00       	mov    $0x0,%esi
  80301f:	bf 06 00 00 00       	mov    $0x6,%edi
  803024:	48 b8 4d 2e 80 00 00 	movabs $0x802e4d,%rax
  80302b:	00 00 00 
  80302e:	ff d0                	callq  *%rax
}
  803030:	c9                   	leaveq 
  803031:	c3                   	retq   

0000000000803032 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803032:	55                   	push   %rbp
  803033:	48 89 e5             	mov    %rsp,%rbp
  803036:	48 83 ec 30          	sub    $0x30,%rsp
  80303a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80303e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803042:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  803046:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80304d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803052:	74 07                	je     80305b <devfile_read+0x29>
  803054:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803059:	75 07                	jne    803062 <devfile_read+0x30>
		return -E_INVAL;
  80305b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803060:	eb 77                	jmp    8030d9 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803062:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803066:	8b 50 0c             	mov    0xc(%rax),%edx
  803069:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803070:	00 00 00 
  803073:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803075:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80307c:	00 00 00 
  80307f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803083:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  803087:	be 00 00 00 00       	mov    $0x0,%esi
  80308c:	bf 03 00 00 00       	mov    $0x3,%edi
  803091:	48 b8 4d 2e 80 00 00 	movabs $0x802e4d,%rax
  803098:	00 00 00 
  80309b:	ff d0                	callq  *%rax
  80309d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a4:	7f 05                	jg     8030ab <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8030a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a9:	eb 2e                	jmp    8030d9 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8030ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ae:	48 63 d0             	movslq %eax,%rdx
  8030b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030b5:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8030bc:	00 00 00 
  8030bf:	48 89 c7             	mov    %rax,%rdi
  8030c2:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  8030c9:	00 00 00 
  8030cc:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8030ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030d2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8030d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8030d9:	c9                   	leaveq 
  8030da:	c3                   	retq   

00000000008030db <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8030db:	55                   	push   %rbp
  8030dc:	48 89 e5             	mov    %rsp,%rbp
  8030df:	48 83 ec 30          	sub    $0x30,%rsp
  8030e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8030ef:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8030f6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8030fb:	74 07                	je     803104 <devfile_write+0x29>
  8030fd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803102:	75 08                	jne    80310c <devfile_write+0x31>
		return r;
  803104:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803107:	e9 9a 00 00 00       	jmpq   8031a6 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80310c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803110:	8b 50 0c             	mov    0xc(%rax),%edx
  803113:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80311a:	00 00 00 
  80311d:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80311f:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803126:	00 
  803127:	76 08                	jbe    803131 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  803129:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803130:	00 
	}
	fsipcbuf.write.req_n = n;
  803131:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803138:	00 00 00 
  80313b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80313f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  803143:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803147:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80314b:	48 89 c6             	mov    %rax,%rsi
  80314e:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803155:	00 00 00 
  803158:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  80315f:	00 00 00 
  803162:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803164:	be 00 00 00 00       	mov    $0x0,%esi
  803169:	bf 04 00 00 00       	mov    $0x4,%edi
  80316e:	48 b8 4d 2e 80 00 00 	movabs $0x802e4d,%rax
  803175:	00 00 00 
  803178:	ff d0                	callq  *%rax
  80317a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80317d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803181:	7f 20                	jg     8031a3 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803183:	48 bf 96 46 80 00 00 	movabs $0x804696,%rdi
  80318a:	00 00 00 
  80318d:	b8 00 00 00 00       	mov    $0x0,%eax
  803192:	48 ba fb 06 80 00 00 	movabs $0x8006fb,%rdx
  803199:	00 00 00 
  80319c:	ff d2                	callq  *%rdx
		return r;
  80319e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a1:	eb 03                	jmp    8031a6 <devfile_write+0xcb>
	}
	return r;
  8031a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8031a6:	c9                   	leaveq 
  8031a7:	c3                   	retq   

00000000008031a8 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8031a8:	55                   	push   %rbp
  8031a9:	48 89 e5             	mov    %rsp,%rbp
  8031ac:	48 83 ec 20          	sub    $0x20,%rsp
  8031b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8031b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031bc:	8b 50 0c             	mov    0xc(%rax),%edx
  8031bf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031c6:	00 00 00 
  8031c9:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8031cb:	be 00 00 00 00       	mov    $0x0,%esi
  8031d0:	bf 05 00 00 00       	mov    $0x5,%edi
  8031d5:	48 b8 4d 2e 80 00 00 	movabs $0x802e4d,%rax
  8031dc:	00 00 00 
  8031df:	ff d0                	callq  *%rax
  8031e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031e8:	79 05                	jns    8031ef <devfile_stat+0x47>
		return r;
  8031ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ed:	eb 56                	jmp    803245 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8031ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031f3:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8031fa:	00 00 00 
  8031fd:	48 89 c7             	mov    %rax,%rdi
  803200:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  803207:	00 00 00 
  80320a:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80320c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803213:	00 00 00 
  803216:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80321c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803220:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803226:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80322d:	00 00 00 
  803230:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803236:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80323a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803240:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803245:	c9                   	leaveq 
  803246:	c3                   	retq   

0000000000803247 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803247:	55                   	push   %rbp
  803248:	48 89 e5             	mov    %rsp,%rbp
  80324b:	48 83 ec 10          	sub    $0x10,%rsp
  80324f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803253:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803256:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80325a:	8b 50 0c             	mov    0xc(%rax),%edx
  80325d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803264:	00 00 00 
  803267:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803269:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803270:	00 00 00 
  803273:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803276:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803279:	be 00 00 00 00       	mov    $0x0,%esi
  80327e:	bf 02 00 00 00       	mov    $0x2,%edi
  803283:	48 b8 4d 2e 80 00 00 	movabs $0x802e4d,%rax
  80328a:	00 00 00 
  80328d:	ff d0                	callq  *%rax
}
  80328f:	c9                   	leaveq 
  803290:	c3                   	retq   

0000000000803291 <remove>:

// Delete a file
int
remove(const char *path)
{
  803291:	55                   	push   %rbp
  803292:	48 89 e5             	mov    %rsp,%rbp
  803295:	48 83 ec 10          	sub    $0x10,%rsp
  803299:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80329d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032a1:	48 89 c7             	mov    %rax,%rdi
  8032a4:	48 b8 44 12 80 00 00 	movabs $0x801244,%rax
  8032ab:	00 00 00 
  8032ae:	ff d0                	callq  *%rax
  8032b0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8032b5:	7e 07                	jle    8032be <remove+0x2d>
		return -E_BAD_PATH;
  8032b7:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8032bc:	eb 33                	jmp    8032f1 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8032be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032c2:	48 89 c6             	mov    %rax,%rsi
  8032c5:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8032cc:	00 00 00 
  8032cf:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  8032d6:	00 00 00 
  8032d9:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8032db:	be 00 00 00 00       	mov    $0x0,%esi
  8032e0:	bf 07 00 00 00       	mov    $0x7,%edi
  8032e5:	48 b8 4d 2e 80 00 00 	movabs $0x802e4d,%rax
  8032ec:	00 00 00 
  8032ef:	ff d0                	callq  *%rax
}
  8032f1:	c9                   	leaveq 
  8032f2:	c3                   	retq   

00000000008032f3 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8032f3:	55                   	push   %rbp
  8032f4:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8032f7:	be 00 00 00 00       	mov    $0x0,%esi
  8032fc:	bf 08 00 00 00       	mov    $0x8,%edi
  803301:	48 b8 4d 2e 80 00 00 	movabs $0x802e4d,%rax
  803308:	00 00 00 
  80330b:	ff d0                	callq  *%rax
}
  80330d:	5d                   	pop    %rbp
  80330e:	c3                   	retq   

000000000080330f <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80330f:	55                   	push   %rbp
  803310:	48 89 e5             	mov    %rsp,%rbp
  803313:	53                   	push   %rbx
  803314:	48 83 ec 38          	sub    $0x38,%rsp
  803318:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80331c:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803320:	48 89 c7             	mov    %rax,%rdi
  803323:	48 b8 34 25 80 00 00 	movabs $0x802534,%rax
  80332a:	00 00 00 
  80332d:	ff d0                	callq  *%rax
  80332f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803332:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803336:	0f 88 bf 01 00 00    	js     8034fb <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80333c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803340:	ba 07 04 00 00       	mov    $0x407,%edx
  803345:	48 89 c6             	mov    %rax,%rsi
  803348:	bf 00 00 00 00       	mov    $0x0,%edi
  80334d:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  803354:	00 00 00 
  803357:	ff d0                	callq  *%rax
  803359:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80335c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803360:	0f 88 95 01 00 00    	js     8034fb <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803366:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80336a:	48 89 c7             	mov    %rax,%rdi
  80336d:	48 b8 34 25 80 00 00 	movabs $0x802534,%rax
  803374:	00 00 00 
  803377:	ff d0                	callq  *%rax
  803379:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80337c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803380:	0f 88 5d 01 00 00    	js     8034e3 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803386:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80338a:	ba 07 04 00 00       	mov    $0x407,%edx
  80338f:	48 89 c6             	mov    %rax,%rsi
  803392:	bf 00 00 00 00       	mov    $0x0,%edi
  803397:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  80339e:	00 00 00 
  8033a1:	ff d0                	callq  *%rax
  8033a3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033aa:	0f 88 33 01 00 00    	js     8034e3 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8033b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033b4:	48 89 c7             	mov    %rax,%rdi
  8033b7:	48 b8 09 25 80 00 00 	movabs $0x802509,%rax
  8033be:	00 00 00 
  8033c1:	ff d0                	callq  *%rax
  8033c3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033cb:	ba 07 04 00 00       	mov    $0x407,%edx
  8033d0:	48 89 c6             	mov    %rax,%rsi
  8033d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8033d8:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  8033df:	00 00 00 
  8033e2:	ff d0                	callq  *%rax
  8033e4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033eb:	79 05                	jns    8033f2 <pipe+0xe3>
		goto err2;
  8033ed:	e9 d9 00 00 00       	jmpq   8034cb <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033f6:	48 89 c7             	mov    %rax,%rdi
  8033f9:	48 b8 09 25 80 00 00 	movabs $0x802509,%rax
  803400:	00 00 00 
  803403:	ff d0                	callq  *%rax
  803405:	48 89 c2             	mov    %rax,%rdx
  803408:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80340c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803412:	48 89 d1             	mov    %rdx,%rcx
  803415:	ba 00 00 00 00       	mov    $0x0,%edx
  80341a:	48 89 c6             	mov    %rax,%rsi
  80341d:	bf 00 00 00 00       	mov    $0x0,%edi
  803422:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  803429:	00 00 00 
  80342c:	ff d0                	callq  *%rax
  80342e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803431:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803435:	79 1b                	jns    803452 <pipe+0x143>
		goto err3;
  803437:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803438:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80343c:	48 89 c6             	mov    %rax,%rsi
  80343f:	bf 00 00 00 00       	mov    $0x0,%edi
  803444:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  80344b:	00 00 00 
  80344e:	ff d0                	callq  *%rax
  803450:	eb 79                	jmp    8034cb <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803452:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803456:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80345d:	00 00 00 
  803460:	8b 12                	mov    (%rdx),%edx
  803462:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803464:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803468:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80346f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803473:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80347a:	00 00 00 
  80347d:	8b 12                	mov    (%rdx),%edx
  80347f:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803481:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803485:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80348c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803490:	48 89 c7             	mov    %rax,%rdi
  803493:	48 b8 e6 24 80 00 00 	movabs $0x8024e6,%rax
  80349a:	00 00 00 
  80349d:	ff d0                	callq  *%rax
  80349f:	89 c2                	mov    %eax,%edx
  8034a1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8034a5:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8034a7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8034ab:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8034af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034b3:	48 89 c7             	mov    %rax,%rdi
  8034b6:	48 b8 e6 24 80 00 00 	movabs $0x8024e6,%rax
  8034bd:	00 00 00 
  8034c0:	ff d0                	callq  *%rax
  8034c2:	89 03                	mov    %eax,(%rbx)
	return 0;
  8034c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c9:	eb 33                	jmp    8034fe <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8034cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034cf:	48 89 c6             	mov    %rax,%rsi
  8034d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8034d7:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  8034de:	00 00 00 
  8034e1:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8034e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034e7:	48 89 c6             	mov    %rax,%rsi
  8034ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8034ef:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  8034f6:	00 00 00 
  8034f9:	ff d0                	callq  *%rax
    err:
	return r;
  8034fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8034fe:	48 83 c4 38          	add    $0x38,%rsp
  803502:	5b                   	pop    %rbx
  803503:	5d                   	pop    %rbp
  803504:	c3                   	retq   

0000000000803505 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803505:	55                   	push   %rbp
  803506:	48 89 e5             	mov    %rsp,%rbp
  803509:	53                   	push   %rbx
  80350a:	48 83 ec 28          	sub    $0x28,%rsp
  80350e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803512:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803516:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80351d:	00 00 00 
  803520:	48 8b 00             	mov    (%rax),%rax
  803523:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803529:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80352c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803530:	48 89 c7             	mov    %rax,%rdi
  803533:	48 b8 b5 3e 80 00 00 	movabs $0x803eb5,%rax
  80353a:	00 00 00 
  80353d:	ff d0                	callq  *%rax
  80353f:	89 c3                	mov    %eax,%ebx
  803541:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803545:	48 89 c7             	mov    %rax,%rdi
  803548:	48 b8 b5 3e 80 00 00 	movabs $0x803eb5,%rax
  80354f:	00 00 00 
  803552:	ff d0                	callq  *%rax
  803554:	39 c3                	cmp    %eax,%ebx
  803556:	0f 94 c0             	sete   %al
  803559:	0f b6 c0             	movzbl %al,%eax
  80355c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80355f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803566:	00 00 00 
  803569:	48 8b 00             	mov    (%rax),%rax
  80356c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803572:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803575:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803578:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80357b:	75 05                	jne    803582 <_pipeisclosed+0x7d>
			return ret;
  80357d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803580:	eb 4f                	jmp    8035d1 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803582:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803585:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803588:	74 42                	je     8035cc <_pipeisclosed+0xc7>
  80358a:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80358e:	75 3c                	jne    8035cc <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803590:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803597:	00 00 00 
  80359a:	48 8b 00             	mov    (%rax),%rax
  80359d:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8035a3:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8035a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035a9:	89 c6                	mov    %eax,%esi
  8035ab:	48 bf b7 46 80 00 00 	movabs $0x8046b7,%rdi
  8035b2:	00 00 00 
  8035b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ba:	49 b8 fb 06 80 00 00 	movabs $0x8006fb,%r8
  8035c1:	00 00 00 
  8035c4:	41 ff d0             	callq  *%r8
	}
  8035c7:	e9 4a ff ff ff       	jmpq   803516 <_pipeisclosed+0x11>
  8035cc:	e9 45 ff ff ff       	jmpq   803516 <_pipeisclosed+0x11>
}
  8035d1:	48 83 c4 28          	add    $0x28,%rsp
  8035d5:	5b                   	pop    %rbx
  8035d6:	5d                   	pop    %rbp
  8035d7:	c3                   	retq   

00000000008035d8 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8035d8:	55                   	push   %rbp
  8035d9:	48 89 e5             	mov    %rsp,%rbp
  8035dc:	48 83 ec 30          	sub    $0x30,%rsp
  8035e0:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8035e3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8035e7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8035ea:	48 89 d6             	mov    %rdx,%rsi
  8035ed:	89 c7                	mov    %eax,%edi
  8035ef:	48 b8 cc 25 80 00 00 	movabs $0x8025cc,%rax
  8035f6:	00 00 00 
  8035f9:	ff d0                	callq  *%rax
  8035fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803602:	79 05                	jns    803609 <pipeisclosed+0x31>
		return r;
  803604:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803607:	eb 31                	jmp    80363a <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803609:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80360d:	48 89 c7             	mov    %rax,%rdi
  803610:	48 b8 09 25 80 00 00 	movabs $0x802509,%rax
  803617:	00 00 00 
  80361a:	ff d0                	callq  *%rax
  80361c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803620:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803624:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803628:	48 89 d6             	mov    %rdx,%rsi
  80362b:	48 89 c7             	mov    %rax,%rdi
  80362e:	48 b8 05 35 80 00 00 	movabs $0x803505,%rax
  803635:	00 00 00 
  803638:	ff d0                	callq  *%rax
}
  80363a:	c9                   	leaveq 
  80363b:	c3                   	retq   

000000000080363c <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80363c:	55                   	push   %rbp
  80363d:	48 89 e5             	mov    %rsp,%rbp
  803640:	48 83 ec 40          	sub    $0x40,%rsp
  803644:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803648:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80364c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803654:	48 89 c7             	mov    %rax,%rdi
  803657:	48 b8 09 25 80 00 00 	movabs $0x802509,%rax
  80365e:	00 00 00 
  803661:	ff d0                	callq  *%rax
  803663:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803667:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80366b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80366f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803676:	00 
  803677:	e9 92 00 00 00       	jmpq   80370e <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80367c:	eb 41                	jmp    8036bf <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80367e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803683:	74 09                	je     80368e <devpipe_read+0x52>
				return i;
  803685:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803689:	e9 92 00 00 00       	jmpq   803720 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80368e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803692:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803696:	48 89 d6             	mov    %rdx,%rsi
  803699:	48 89 c7             	mov    %rax,%rdi
  80369c:	48 b8 05 35 80 00 00 	movabs $0x803505,%rax
  8036a3:	00 00 00 
  8036a6:	ff d0                	callq  *%rax
  8036a8:	85 c0                	test   %eax,%eax
  8036aa:	74 07                	je     8036b3 <devpipe_read+0x77>
				return 0;
  8036ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8036b1:	eb 6d                	jmp    803720 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8036b3:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  8036ba:	00 00 00 
  8036bd:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8036bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c3:	8b 10                	mov    (%rax),%edx
  8036c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c9:	8b 40 04             	mov    0x4(%rax),%eax
  8036cc:	39 c2                	cmp    %eax,%edx
  8036ce:	74 ae                	je     80367e <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8036d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036d8:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8036dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036e0:	8b 00                	mov    (%rax),%eax
  8036e2:	99                   	cltd   
  8036e3:	c1 ea 1b             	shr    $0x1b,%edx
  8036e6:	01 d0                	add    %edx,%eax
  8036e8:	83 e0 1f             	and    $0x1f,%eax
  8036eb:	29 d0                	sub    %edx,%eax
  8036ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036f1:	48 98                	cltq   
  8036f3:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8036f8:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8036fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036fe:	8b 00                	mov    (%rax),%eax
  803700:	8d 50 01             	lea    0x1(%rax),%edx
  803703:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803707:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803709:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80370e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803712:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803716:	0f 82 60 ff ff ff    	jb     80367c <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80371c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803720:	c9                   	leaveq 
  803721:	c3                   	retq   

0000000000803722 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803722:	55                   	push   %rbp
  803723:	48 89 e5             	mov    %rsp,%rbp
  803726:	48 83 ec 40          	sub    $0x40,%rsp
  80372a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80372e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803732:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803736:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80373a:	48 89 c7             	mov    %rax,%rdi
  80373d:	48 b8 09 25 80 00 00 	movabs $0x802509,%rax
  803744:	00 00 00 
  803747:	ff d0                	callq  *%rax
  803749:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80374d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803751:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803755:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80375c:	00 
  80375d:	e9 8e 00 00 00       	jmpq   8037f0 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803762:	eb 31                	jmp    803795 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803764:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803768:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80376c:	48 89 d6             	mov    %rdx,%rsi
  80376f:	48 89 c7             	mov    %rax,%rdi
  803772:	48 b8 05 35 80 00 00 	movabs $0x803505,%rax
  803779:	00 00 00 
  80377c:	ff d0                	callq  *%rax
  80377e:	85 c0                	test   %eax,%eax
  803780:	74 07                	je     803789 <devpipe_write+0x67>
				return 0;
  803782:	b8 00 00 00 00       	mov    $0x0,%eax
  803787:	eb 79                	jmp    803802 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803789:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  803790:	00 00 00 
  803793:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803795:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803799:	8b 40 04             	mov    0x4(%rax),%eax
  80379c:	48 63 d0             	movslq %eax,%rdx
  80379f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037a3:	8b 00                	mov    (%rax),%eax
  8037a5:	48 98                	cltq   
  8037a7:	48 83 c0 20          	add    $0x20,%rax
  8037ab:	48 39 c2             	cmp    %rax,%rdx
  8037ae:	73 b4                	jae    803764 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8037b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037b4:	8b 40 04             	mov    0x4(%rax),%eax
  8037b7:	99                   	cltd   
  8037b8:	c1 ea 1b             	shr    $0x1b,%edx
  8037bb:	01 d0                	add    %edx,%eax
  8037bd:	83 e0 1f             	and    $0x1f,%eax
  8037c0:	29 d0                	sub    %edx,%eax
  8037c2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8037c6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8037ca:	48 01 ca             	add    %rcx,%rdx
  8037cd:	0f b6 0a             	movzbl (%rdx),%ecx
  8037d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037d4:	48 98                	cltq   
  8037d6:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8037da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037de:	8b 40 04             	mov    0x4(%rax),%eax
  8037e1:	8d 50 01             	lea    0x1(%rax),%edx
  8037e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037e8:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8037eb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8037f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8037f8:	0f 82 64 ff ff ff    	jb     803762 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8037fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803802:	c9                   	leaveq 
  803803:	c3                   	retq   

0000000000803804 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803804:	55                   	push   %rbp
  803805:	48 89 e5             	mov    %rsp,%rbp
  803808:	48 83 ec 20          	sub    $0x20,%rsp
  80380c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803810:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803814:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803818:	48 89 c7             	mov    %rax,%rdi
  80381b:	48 b8 09 25 80 00 00 	movabs $0x802509,%rax
  803822:	00 00 00 
  803825:	ff d0                	callq  *%rax
  803827:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80382b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80382f:	48 be ca 46 80 00 00 	movabs $0x8046ca,%rsi
  803836:	00 00 00 
  803839:	48 89 c7             	mov    %rax,%rdi
  80383c:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  803843:	00 00 00 
  803846:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803848:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80384c:	8b 50 04             	mov    0x4(%rax),%edx
  80384f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803853:	8b 00                	mov    (%rax),%eax
  803855:	29 c2                	sub    %eax,%edx
  803857:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80385b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803861:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803865:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80386c:	00 00 00 
	stat->st_dev = &devpipe;
  80386f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803873:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  80387a:	00 00 00 
  80387d:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803884:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803889:	c9                   	leaveq 
  80388a:	c3                   	retq   

000000000080388b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80388b:	55                   	push   %rbp
  80388c:	48 89 e5             	mov    %rsp,%rbp
  80388f:	48 83 ec 10          	sub    $0x10,%rsp
  803893:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803897:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80389b:	48 89 c6             	mov    %rax,%rsi
  80389e:	bf 00 00 00 00       	mov    $0x0,%edi
  8038a3:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  8038aa:	00 00 00 
  8038ad:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8038af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038b3:	48 89 c7             	mov    %rax,%rdi
  8038b6:	48 b8 09 25 80 00 00 	movabs $0x802509,%rax
  8038bd:	00 00 00 
  8038c0:	ff d0                	callq  *%rax
  8038c2:	48 89 c6             	mov    %rax,%rsi
  8038c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8038ca:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  8038d1:	00 00 00 
  8038d4:	ff d0                	callq  *%rax
}
  8038d6:	c9                   	leaveq 
  8038d7:	c3                   	retq   

00000000008038d8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8038d8:	55                   	push   %rbp
  8038d9:	48 89 e5             	mov    %rsp,%rbp
  8038dc:	48 83 ec 20          	sub    $0x20,%rsp
  8038e0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8038e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038e6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8038e9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8038ed:	be 01 00 00 00       	mov    $0x1,%esi
  8038f2:	48 89 c7             	mov    %rax,%rdi
  8038f5:	48 b8 97 1a 80 00 00 	movabs $0x801a97,%rax
  8038fc:	00 00 00 
  8038ff:	ff d0                	callq  *%rax
}
  803901:	c9                   	leaveq 
  803902:	c3                   	retq   

0000000000803903 <getchar>:

int
getchar(void)
{
  803903:	55                   	push   %rbp
  803904:	48 89 e5             	mov    %rsp,%rbp
  803907:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80390b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80390f:	ba 01 00 00 00       	mov    $0x1,%edx
  803914:	48 89 c6             	mov    %rax,%rsi
  803917:	bf 00 00 00 00       	mov    $0x0,%edi
  80391c:	48 b8 fe 29 80 00 00 	movabs $0x8029fe,%rax
  803923:	00 00 00 
  803926:	ff d0                	callq  *%rax
  803928:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80392b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80392f:	79 05                	jns    803936 <getchar+0x33>
		return r;
  803931:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803934:	eb 14                	jmp    80394a <getchar+0x47>
	if (r < 1)
  803936:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80393a:	7f 07                	jg     803943 <getchar+0x40>
		return -E_EOF;
  80393c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803941:	eb 07                	jmp    80394a <getchar+0x47>
	return c;
  803943:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803947:	0f b6 c0             	movzbl %al,%eax
}
  80394a:	c9                   	leaveq 
  80394b:	c3                   	retq   

000000000080394c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80394c:	55                   	push   %rbp
  80394d:	48 89 e5             	mov    %rsp,%rbp
  803950:	48 83 ec 20          	sub    $0x20,%rsp
  803954:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803957:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80395b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80395e:	48 89 d6             	mov    %rdx,%rsi
  803961:	89 c7                	mov    %eax,%edi
  803963:	48 b8 cc 25 80 00 00 	movabs $0x8025cc,%rax
  80396a:	00 00 00 
  80396d:	ff d0                	callq  *%rax
  80396f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803972:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803976:	79 05                	jns    80397d <iscons+0x31>
		return r;
  803978:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80397b:	eb 1a                	jmp    803997 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80397d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803981:	8b 10                	mov    (%rax),%edx
  803983:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  80398a:	00 00 00 
  80398d:	8b 00                	mov    (%rax),%eax
  80398f:	39 c2                	cmp    %eax,%edx
  803991:	0f 94 c0             	sete   %al
  803994:	0f b6 c0             	movzbl %al,%eax
}
  803997:	c9                   	leaveq 
  803998:	c3                   	retq   

0000000000803999 <opencons>:

int
opencons(void)
{
  803999:	55                   	push   %rbp
  80399a:	48 89 e5             	mov    %rsp,%rbp
  80399d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8039a1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8039a5:	48 89 c7             	mov    %rax,%rdi
  8039a8:	48 b8 34 25 80 00 00 	movabs $0x802534,%rax
  8039af:	00 00 00 
  8039b2:	ff d0                	callq  *%rax
  8039b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039bb:	79 05                	jns    8039c2 <opencons+0x29>
		return r;
  8039bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039c0:	eb 5b                	jmp    803a1d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8039c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039c6:	ba 07 04 00 00       	mov    $0x407,%edx
  8039cb:	48 89 c6             	mov    %rax,%rsi
  8039ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8039d3:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  8039da:	00 00 00 
  8039dd:	ff d0                	callq  *%rax
  8039df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039e6:	79 05                	jns    8039ed <opencons+0x54>
		return r;
  8039e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039eb:	eb 30                	jmp    803a1d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8039ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f1:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  8039f8:	00 00 00 
  8039fb:	8b 12                	mov    (%rdx),%edx
  8039fd:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8039ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a03:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803a0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a0e:	48 89 c7             	mov    %rax,%rdi
  803a11:	48 b8 e6 24 80 00 00 	movabs $0x8024e6,%rax
  803a18:	00 00 00 
  803a1b:	ff d0                	callq  *%rax
}
  803a1d:	c9                   	leaveq 
  803a1e:	c3                   	retq   

0000000000803a1f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a1f:	55                   	push   %rbp
  803a20:	48 89 e5             	mov    %rsp,%rbp
  803a23:	48 83 ec 30          	sub    $0x30,%rsp
  803a27:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a2b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a2f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803a33:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a38:	75 07                	jne    803a41 <devcons_read+0x22>
		return 0;
  803a3a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a3f:	eb 4b                	jmp    803a8c <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803a41:	eb 0c                	jmp    803a4f <devcons_read+0x30>
		sys_yield();
  803a43:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  803a4a:	00 00 00 
  803a4d:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803a4f:	48 b8 e1 1a 80 00 00 	movabs $0x801ae1,%rax
  803a56:	00 00 00 
  803a59:	ff d0                	callq  *%rax
  803a5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a62:	74 df                	je     803a43 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803a64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a68:	79 05                	jns    803a6f <devcons_read+0x50>
		return c;
  803a6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a6d:	eb 1d                	jmp    803a8c <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803a6f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803a73:	75 07                	jne    803a7c <devcons_read+0x5d>
		return 0;
  803a75:	b8 00 00 00 00       	mov    $0x0,%eax
  803a7a:	eb 10                	jmp    803a8c <devcons_read+0x6d>
	*(char*)vbuf = c;
  803a7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a7f:	89 c2                	mov    %eax,%edx
  803a81:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a85:	88 10                	mov    %dl,(%rax)
	return 1;
  803a87:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803a8c:	c9                   	leaveq 
  803a8d:	c3                   	retq   

0000000000803a8e <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a8e:	55                   	push   %rbp
  803a8f:	48 89 e5             	mov    %rsp,%rbp
  803a92:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803a99:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803aa0:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803aa7:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803aae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ab5:	eb 76                	jmp    803b2d <devcons_write+0x9f>
		m = n - tot;
  803ab7:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803abe:	89 c2                	mov    %eax,%edx
  803ac0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ac3:	29 c2                	sub    %eax,%edx
  803ac5:	89 d0                	mov    %edx,%eax
  803ac7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803aca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803acd:	83 f8 7f             	cmp    $0x7f,%eax
  803ad0:	76 07                	jbe    803ad9 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803ad2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803ad9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803adc:	48 63 d0             	movslq %eax,%rdx
  803adf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ae2:	48 63 c8             	movslq %eax,%rcx
  803ae5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803aec:	48 01 c1             	add    %rax,%rcx
  803aef:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803af6:	48 89 ce             	mov    %rcx,%rsi
  803af9:	48 89 c7             	mov    %rax,%rdi
  803afc:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  803b03:	00 00 00 
  803b06:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803b08:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b0b:	48 63 d0             	movslq %eax,%rdx
  803b0e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803b15:	48 89 d6             	mov    %rdx,%rsi
  803b18:	48 89 c7             	mov    %rax,%rdi
  803b1b:	48 b8 97 1a 80 00 00 	movabs $0x801a97,%rax
  803b22:	00 00 00 
  803b25:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803b27:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b2a:	01 45 fc             	add    %eax,-0x4(%rbp)
  803b2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b30:	48 98                	cltq   
  803b32:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803b39:	0f 82 78 ff ff ff    	jb     803ab7 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803b3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b42:	c9                   	leaveq 
  803b43:	c3                   	retq   

0000000000803b44 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803b44:	55                   	push   %rbp
  803b45:	48 89 e5             	mov    %rsp,%rbp
  803b48:	48 83 ec 08          	sub    $0x8,%rsp
  803b4c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803b50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b55:	c9                   	leaveq 
  803b56:	c3                   	retq   

0000000000803b57 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803b57:	55                   	push   %rbp
  803b58:	48 89 e5             	mov    %rsp,%rbp
  803b5b:	48 83 ec 10          	sub    $0x10,%rsp
  803b5f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b63:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803b67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b6b:	48 be d6 46 80 00 00 	movabs $0x8046d6,%rsi
  803b72:	00 00 00 
  803b75:	48 89 c7             	mov    %rax,%rdi
  803b78:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  803b7f:	00 00 00 
  803b82:	ff d0                	callq  *%rax
	return 0;
  803b84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b89:	c9                   	leaveq 
  803b8a:	c3                   	retq   

0000000000803b8b <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803b8b:	55                   	push   %rbp
  803b8c:	48 89 e5             	mov    %rsp,%rbp
  803b8f:	48 83 ec 10          	sub    $0x10,%rsp
  803b93:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  803b97:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803b9e:	00 00 00 
  803ba1:	48 8b 00             	mov    (%rax),%rax
  803ba4:	48 85 c0             	test   %rax,%rax
  803ba7:	0f 85 84 00 00 00    	jne    803c31 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  803bad:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803bb4:	00 00 00 
  803bb7:	48 8b 00             	mov    (%rax),%rax
  803bba:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803bc0:	ba 07 00 00 00       	mov    $0x7,%edx
  803bc5:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803bca:	89 c7                	mov    %eax,%edi
  803bcc:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  803bd3:	00 00 00 
  803bd6:	ff d0                	callq  *%rax
  803bd8:	85 c0                	test   %eax,%eax
  803bda:	79 2a                	jns    803c06 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  803bdc:	48 ba e0 46 80 00 00 	movabs $0x8046e0,%rdx
  803be3:	00 00 00 
  803be6:	be 23 00 00 00       	mov    $0x23,%esi
  803beb:	48 bf 07 47 80 00 00 	movabs $0x804707,%rdi
  803bf2:	00 00 00 
  803bf5:	b8 00 00 00 00       	mov    $0x0,%eax
  803bfa:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  803c01:	00 00 00 
  803c04:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  803c06:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c0d:	00 00 00 
  803c10:	48 8b 00             	mov    (%rax),%rax
  803c13:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803c19:	48 be 44 3c 80 00 00 	movabs $0x803c44,%rsi
  803c20:	00 00 00 
  803c23:	89 c7                	mov    %eax,%edi
  803c25:	48 b8 69 1d 80 00 00 	movabs $0x801d69,%rax
  803c2c:	00 00 00 
  803c2f:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803c31:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803c38:	00 00 00 
  803c3b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803c3f:	48 89 10             	mov    %rdx,(%rax)
}
  803c42:	c9                   	leaveq 
  803c43:	c3                   	retq   

0000000000803c44 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  803c44:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  803c47:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803c4e:	00 00 00 
	call *%rax
  803c51:	ff d0                	callq  *%rax


	/*This code is to be removed*/

	// LAB 4: Your code here.
	movq 136(%rsp), %rbx  //Load RIP 
  803c53:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803c5a:	00 
	movq 152(%rsp), %rcx  //Load RSP
  803c5b:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803c62:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  803c63:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  803c67:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  803c6a:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803c71:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  803c72:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  803c76:	4c 8b 3c 24          	mov    (%rsp),%r15
  803c7a:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803c7f:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803c84:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803c89:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803c8e:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803c93:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803c98:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803c9d:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803ca2:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803ca7:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803cac:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803cb1:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803cb6:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803cbb:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803cc0:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  803cc4:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  803cc8:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  803cc9:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803cca:	c3                   	retq   

0000000000803ccb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803ccb:	55                   	push   %rbp
  803ccc:	48 89 e5             	mov    %rsp,%rbp
  803ccf:	48 83 ec 30          	sub    $0x30,%rsp
  803cd3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803cd7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803cdb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803cdf:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ce6:	00 00 00 
  803ce9:	48 8b 00             	mov    (%rax),%rax
  803cec:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803cf2:	85 c0                	test   %eax,%eax
  803cf4:	75 3c                	jne    803d32 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803cf6:	48 b8 63 1b 80 00 00 	movabs $0x801b63,%rax
  803cfd:	00 00 00 
  803d00:	ff d0                	callq  *%rax
  803d02:	25 ff 03 00 00       	and    $0x3ff,%eax
  803d07:	48 63 d0             	movslq %eax,%rdx
  803d0a:	48 89 d0             	mov    %rdx,%rax
  803d0d:	48 c1 e0 03          	shl    $0x3,%rax
  803d11:	48 01 d0             	add    %rdx,%rax
  803d14:	48 c1 e0 05          	shl    $0x5,%rax
  803d18:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803d1f:	00 00 00 
  803d22:	48 01 c2             	add    %rax,%rdx
  803d25:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d2c:	00 00 00 
  803d2f:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803d32:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d37:	75 0e                	jne    803d47 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803d39:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d40:	00 00 00 
  803d43:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803d47:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d4b:	48 89 c7             	mov    %rax,%rdi
  803d4e:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  803d55:	00 00 00 
  803d58:	ff d0                	callq  *%rax
  803d5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803d5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d61:	79 19                	jns    803d7c <ipc_recv+0xb1>
		*from_env_store = 0;
  803d63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d67:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803d6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d71:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803d77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d7a:	eb 53                	jmp    803dcf <ipc_recv+0x104>
	}
	if(from_env_store)
  803d7c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803d81:	74 19                	je     803d9c <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803d83:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d8a:	00 00 00 
  803d8d:	48 8b 00             	mov    (%rax),%rax
  803d90:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803d96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d9a:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803d9c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803da1:	74 19                	je     803dbc <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803da3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803daa:	00 00 00 
  803dad:	48 8b 00             	mov    (%rax),%rax
  803db0:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803db6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dba:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803dbc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803dc3:	00 00 00 
  803dc6:	48 8b 00             	mov    (%rax),%rax
  803dc9:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803dcf:	c9                   	leaveq 
  803dd0:	c3                   	retq   

0000000000803dd1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803dd1:	55                   	push   %rbp
  803dd2:	48 89 e5             	mov    %rsp,%rbp
  803dd5:	48 83 ec 30          	sub    $0x30,%rsp
  803dd9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ddc:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803ddf:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803de3:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803de6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803deb:	75 0e                	jne    803dfb <ipc_send+0x2a>
		pg = (void*)UTOP;
  803ded:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803df4:	00 00 00 
  803df7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803dfb:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803dfe:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803e01:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803e05:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e08:	89 c7                	mov    %eax,%edi
  803e0a:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  803e11:	00 00 00 
  803e14:	ff d0                	callq  *%rax
  803e16:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803e19:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803e1d:	75 0c                	jne    803e2b <ipc_send+0x5a>
			sys_yield();
  803e1f:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  803e26:	00 00 00 
  803e29:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803e2b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803e2f:	74 ca                	je     803dfb <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803e31:	c9                   	leaveq 
  803e32:	c3                   	retq   

0000000000803e33 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803e33:	55                   	push   %rbp
  803e34:	48 89 e5             	mov    %rsp,%rbp
  803e37:	48 83 ec 14          	sub    $0x14,%rsp
  803e3b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803e3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e45:	eb 5e                	jmp    803ea5 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803e47:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803e4e:	00 00 00 
  803e51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e54:	48 63 d0             	movslq %eax,%rdx
  803e57:	48 89 d0             	mov    %rdx,%rax
  803e5a:	48 c1 e0 03          	shl    $0x3,%rax
  803e5e:	48 01 d0             	add    %rdx,%rax
  803e61:	48 c1 e0 05          	shl    $0x5,%rax
  803e65:	48 01 c8             	add    %rcx,%rax
  803e68:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803e6e:	8b 00                	mov    (%rax),%eax
  803e70:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803e73:	75 2c                	jne    803ea1 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803e75:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803e7c:	00 00 00 
  803e7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e82:	48 63 d0             	movslq %eax,%rdx
  803e85:	48 89 d0             	mov    %rdx,%rax
  803e88:	48 c1 e0 03          	shl    $0x3,%rax
  803e8c:	48 01 d0             	add    %rdx,%rax
  803e8f:	48 c1 e0 05          	shl    $0x5,%rax
  803e93:	48 01 c8             	add    %rcx,%rax
  803e96:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803e9c:	8b 40 08             	mov    0x8(%rax),%eax
  803e9f:	eb 12                	jmp    803eb3 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803ea1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803ea5:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803eac:	7e 99                	jle    803e47 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803eae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803eb3:	c9                   	leaveq 
  803eb4:	c3                   	retq   

0000000000803eb5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803eb5:	55                   	push   %rbp
  803eb6:	48 89 e5             	mov    %rsp,%rbp
  803eb9:	48 83 ec 18          	sub    $0x18,%rsp
  803ebd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803ec1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ec5:	48 c1 e8 15          	shr    $0x15,%rax
  803ec9:	48 89 c2             	mov    %rax,%rdx
  803ecc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803ed3:	01 00 00 
  803ed6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803eda:	83 e0 01             	and    $0x1,%eax
  803edd:	48 85 c0             	test   %rax,%rax
  803ee0:	75 07                	jne    803ee9 <pageref+0x34>
		return 0;
  803ee2:	b8 00 00 00 00       	mov    $0x0,%eax
  803ee7:	eb 53                	jmp    803f3c <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803ee9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803eed:	48 c1 e8 0c          	shr    $0xc,%rax
  803ef1:	48 89 c2             	mov    %rax,%rdx
  803ef4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803efb:	01 00 00 
  803efe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f02:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803f06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f0a:	83 e0 01             	and    $0x1,%eax
  803f0d:	48 85 c0             	test   %rax,%rax
  803f10:	75 07                	jne    803f19 <pageref+0x64>
		return 0;
  803f12:	b8 00 00 00 00       	mov    $0x0,%eax
  803f17:	eb 23                	jmp    803f3c <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803f19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f1d:	48 c1 e8 0c          	shr    $0xc,%rax
  803f21:	48 89 c2             	mov    %rax,%rdx
  803f24:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803f2b:	00 00 00 
  803f2e:	48 c1 e2 04          	shl    $0x4,%rdx
  803f32:	48 01 d0             	add    %rdx,%rax
  803f35:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803f39:	0f b7 c0             	movzwl %ax,%eax
}
  803f3c:	c9                   	leaveq 
  803f3d:	c3                   	retq   
