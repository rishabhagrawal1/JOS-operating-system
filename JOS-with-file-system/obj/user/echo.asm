
obj/user/echo.debug:     file format elf64-x86-64


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
  80003c:	e8 11 01 00 00       	callq  800152 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, nflag;

	nflag = 0;
  800052:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800059:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  80005d:	7e 38                	jle    800097 <umain+0x54>
  80005f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800063:	48 83 c0 08          	add    $0x8,%rax
  800067:	48 8b 00             	mov    (%rax),%rax
  80006a:	48 be c0 34 80 00 00 	movabs $0x8034c0,%rsi
  800071:	00 00 00 
  800074:	48 89 c7             	mov    %rax,%rdi
  800077:	48 b8 ce 03 80 00 00 	movabs $0x8003ce,%rax
  80007e:	00 00 00 
  800081:	ff d0                	callq  *%rax
  800083:	85 c0                	test   %eax,%eax
  800085:	75 10                	jne    800097 <umain+0x54>
		nflag = 1;
  800087:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
		argc--;
  80008e:	83 6d ec 01          	subl   $0x1,-0x14(%rbp)
		argv++;
  800092:	48 83 45 e0 08       	addq   $0x8,-0x20(%rbp)
	}
	for (i = 1; i < argc; i++) {
  800097:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  80009e:	eb 7e                	jmp    80011e <umain+0xdb>
		if (i > 1)
  8000a0:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
  8000a4:	7e 20                	jle    8000c6 <umain+0x83>
			write(1, " ", 1);
  8000a6:	ba 01 00 00 00       	mov    $0x1,%edx
  8000ab:	48 be c3 34 80 00 00 	movabs $0x8034c3,%rsi
  8000b2:	00 00 00 
  8000b5:	bf 01 00 00 00       	mov    $0x1,%edi
  8000ba:	48 b8 6a 14 80 00 00 	movabs $0x80146a,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
		write(1, argv[i], strlen(argv[i]));
  8000c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c9:	48 98                	cltq   
  8000cb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8000d2:	00 
  8000d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000d7:	48 01 d0             	add    %rdx,%rax
  8000da:	48 8b 00             	mov    (%rax),%rax
  8000dd:	48 89 c7             	mov    %rax,%rdi
  8000e0:	48 b8 00 02 80 00 00 	movabs $0x800200,%rax
  8000e7:	00 00 00 
  8000ea:	ff d0                	callq  *%rax
  8000ec:	48 63 d0             	movslq %eax,%rdx
  8000ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000f2:	48 98                	cltq   
  8000f4:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
  8000fb:	00 
  8000fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800100:	48 01 c8             	add    %rcx,%rax
  800103:	48 8b 00             	mov    (%rax),%rax
  800106:	48 89 c6             	mov    %rax,%rsi
  800109:	bf 01 00 00 00       	mov    $0x1,%edi
  80010e:	48 b8 6a 14 80 00 00 	movabs $0x80146a,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80011a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80011e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800121:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800124:	0f 8c 76 ff ff ff    	jl     8000a0 <umain+0x5d>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
  80012a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80012e:	75 20                	jne    800150 <umain+0x10d>
		write(1, "\n", 1);
  800130:	ba 01 00 00 00       	mov    $0x1,%edx
  800135:	48 be c5 34 80 00 00 	movabs $0x8034c5,%rsi
  80013c:	00 00 00 
  80013f:	bf 01 00 00 00       	mov    $0x1,%edi
  800144:	48 b8 6a 14 80 00 00 	movabs $0x80146a,%rax
  80014b:	00 00 00 
  80014e:	ff d0                	callq  *%rax
}
  800150:	c9                   	leaveq 
  800151:	c3                   	retq   

0000000000800152 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800152:	55                   	push   %rbp
  800153:	48 89 e5             	mov    %rsp,%rbp
  800156:	48 83 ec 10          	sub    $0x10,%rsp
  80015a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80015d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800161:	48 b8 1f 0b 80 00 00 	movabs $0x800b1f,%rax
  800168:	00 00 00 
  80016b:	ff d0                	callq  *%rax
  80016d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800172:	48 63 d0             	movslq %eax,%rdx
  800175:	48 89 d0             	mov    %rdx,%rax
  800178:	48 c1 e0 03          	shl    $0x3,%rax
  80017c:	48 01 d0             	add    %rdx,%rax
  80017f:	48 c1 e0 05          	shl    $0x5,%rax
  800183:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80018a:	00 00 00 
  80018d:	48 01 c2             	add    %rax,%rdx
  800190:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800197:	00 00 00 
  80019a:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80019d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001a1:	7e 14                	jle    8001b7 <libmain+0x65>
		binaryname = argv[0];
  8001a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a7:	48 8b 10             	mov    (%rax),%rdx
  8001aa:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8001b1:	00 00 00 
  8001b4:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001be:	48 89 d6             	mov    %rdx,%rsi
  8001c1:	89 c7                	mov    %eax,%edi
  8001c3:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001ca:	00 00 00 
  8001cd:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8001cf:	48 b8 dd 01 80 00 00 	movabs $0x8001dd,%rax
  8001d6:	00 00 00 
  8001d9:	ff d0                	callq  *%rax
}
  8001db:	c9                   	leaveq 
  8001dc:	c3                   	retq   

00000000008001dd <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001dd:	55                   	push   %rbp
  8001de:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001e1:	48 b8 49 11 80 00 00 	movabs $0x801149,%rax
  8001e8:	00 00 00 
  8001eb:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f2:	48 b8 db 0a 80 00 00 	movabs $0x800adb,%rax
  8001f9:	00 00 00 
  8001fc:	ff d0                	callq  *%rax

}
  8001fe:	5d                   	pop    %rbp
  8001ff:	c3                   	retq   

0000000000800200 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800200:	55                   	push   %rbp
  800201:	48 89 e5             	mov    %rsp,%rbp
  800204:	48 83 ec 18          	sub    $0x18,%rsp
  800208:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80020c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800213:	eb 09                	jmp    80021e <strlen+0x1e>
		n++;
  800215:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800219:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80021e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800222:	0f b6 00             	movzbl (%rax),%eax
  800225:	84 c0                	test   %al,%al
  800227:	75 ec                	jne    800215 <strlen+0x15>
		n++;
	return n;
  800229:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80022c:	c9                   	leaveq 
  80022d:	c3                   	retq   

000000000080022e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80022e:	55                   	push   %rbp
  80022f:	48 89 e5             	mov    %rsp,%rbp
  800232:	48 83 ec 20          	sub    $0x20,%rsp
  800236:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80023a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80023e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800245:	eb 0e                	jmp    800255 <strnlen+0x27>
		n++;
  800247:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80024b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800250:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800255:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80025a:	74 0b                	je     800267 <strnlen+0x39>
  80025c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800260:	0f b6 00             	movzbl (%rax),%eax
  800263:	84 c0                	test   %al,%al
  800265:	75 e0                	jne    800247 <strnlen+0x19>
		n++;
	return n;
  800267:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80026a:	c9                   	leaveq 
  80026b:	c3                   	retq   

000000000080026c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80026c:	55                   	push   %rbp
  80026d:	48 89 e5             	mov    %rsp,%rbp
  800270:	48 83 ec 20          	sub    $0x20,%rsp
  800274:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800278:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80027c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800280:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800284:	90                   	nop
  800285:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800289:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80028d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800291:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800295:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800299:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80029d:	0f b6 12             	movzbl (%rdx),%edx
  8002a0:	88 10                	mov    %dl,(%rax)
  8002a2:	0f b6 00             	movzbl (%rax),%eax
  8002a5:	84 c0                	test   %al,%al
  8002a7:	75 dc                	jne    800285 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8002a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8002ad:	c9                   	leaveq 
  8002ae:	c3                   	retq   

00000000008002af <strcat>:

char *
strcat(char *dst, const char *src)
{
  8002af:	55                   	push   %rbp
  8002b0:	48 89 e5             	mov    %rsp,%rbp
  8002b3:	48 83 ec 20          	sub    $0x20,%rsp
  8002b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8002bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8002bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002c3:	48 89 c7             	mov    %rax,%rdi
  8002c6:	48 b8 00 02 80 00 00 	movabs $0x800200,%rax
  8002cd:	00 00 00 
  8002d0:	ff d0                	callq  *%rax
  8002d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8002d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002d8:	48 63 d0             	movslq %eax,%rdx
  8002db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002df:	48 01 c2             	add    %rax,%rdx
  8002e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8002e6:	48 89 c6             	mov    %rax,%rsi
  8002e9:	48 89 d7             	mov    %rdx,%rdi
  8002ec:	48 b8 6c 02 80 00 00 	movabs $0x80026c,%rax
  8002f3:	00 00 00 
  8002f6:	ff d0                	callq  *%rax
	return dst;
  8002f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8002fc:	c9                   	leaveq 
  8002fd:	c3                   	retq   

00000000008002fe <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8002fe:	55                   	push   %rbp
  8002ff:	48 89 e5             	mov    %rsp,%rbp
  800302:	48 83 ec 28          	sub    $0x28,%rsp
  800306:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80030a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80030e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800312:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800316:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80031a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800321:	00 
  800322:	eb 2a                	jmp    80034e <strncpy+0x50>
		*dst++ = *src;
  800324:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800328:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80032c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800330:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800334:	0f b6 12             	movzbl (%rdx),%edx
  800337:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800339:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80033d:	0f b6 00             	movzbl (%rax),%eax
  800340:	84 c0                	test   %al,%al
  800342:	74 05                	je     800349 <strncpy+0x4b>
			src++;
  800344:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800349:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80034e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800352:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800356:	72 cc                	jb     800324 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800358:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80035c:	c9                   	leaveq 
  80035d:	c3                   	retq   

000000000080035e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80035e:	55                   	push   %rbp
  80035f:	48 89 e5             	mov    %rsp,%rbp
  800362:	48 83 ec 28          	sub    $0x28,%rsp
  800366:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80036a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80036e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800372:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800376:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80037a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80037f:	74 3d                	je     8003be <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800381:	eb 1d                	jmp    8003a0 <strlcpy+0x42>
			*dst++ = *src++;
  800383:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800387:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80038b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80038f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800393:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800397:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80039b:	0f b6 12             	movzbl (%rdx),%edx
  80039e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8003a0:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8003a5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8003aa:	74 0b                	je     8003b7 <strlcpy+0x59>
  8003ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8003b0:	0f b6 00             	movzbl (%rax),%eax
  8003b3:	84 c0                	test   %al,%al
  8003b5:	75 cc                	jne    800383 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8003b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003bb:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8003be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8003c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003c6:	48 29 c2             	sub    %rax,%rdx
  8003c9:	48 89 d0             	mov    %rdx,%rax
}
  8003cc:	c9                   	leaveq 
  8003cd:	c3                   	retq   

00000000008003ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8003ce:	55                   	push   %rbp
  8003cf:	48 89 e5             	mov    %rsp,%rbp
  8003d2:	48 83 ec 10          	sub    $0x10,%rsp
  8003d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8003da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8003de:	eb 0a                	jmp    8003ea <strcmp+0x1c>
		p++, q++;
  8003e0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8003e5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8003ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003ee:	0f b6 00             	movzbl (%rax),%eax
  8003f1:	84 c0                	test   %al,%al
  8003f3:	74 12                	je     800407 <strcmp+0x39>
  8003f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003f9:	0f b6 10             	movzbl (%rax),%edx
  8003fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800400:	0f b6 00             	movzbl (%rax),%eax
  800403:	38 c2                	cmp    %al,%dl
  800405:	74 d9                	je     8003e0 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800407:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80040b:	0f b6 00             	movzbl (%rax),%eax
  80040e:	0f b6 d0             	movzbl %al,%edx
  800411:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800415:	0f b6 00             	movzbl (%rax),%eax
  800418:	0f b6 c0             	movzbl %al,%eax
  80041b:	29 c2                	sub    %eax,%edx
  80041d:	89 d0                	mov    %edx,%eax
}
  80041f:	c9                   	leaveq 
  800420:	c3                   	retq   

0000000000800421 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800421:	55                   	push   %rbp
  800422:	48 89 e5             	mov    %rsp,%rbp
  800425:	48 83 ec 18          	sub    $0x18,%rsp
  800429:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80042d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800431:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800435:	eb 0f                	jmp    800446 <strncmp+0x25>
		n--, p++, q++;
  800437:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80043c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800441:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800446:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80044b:	74 1d                	je     80046a <strncmp+0x49>
  80044d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800451:	0f b6 00             	movzbl (%rax),%eax
  800454:	84 c0                	test   %al,%al
  800456:	74 12                	je     80046a <strncmp+0x49>
  800458:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80045c:	0f b6 10             	movzbl (%rax),%edx
  80045f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800463:	0f b6 00             	movzbl (%rax),%eax
  800466:	38 c2                	cmp    %al,%dl
  800468:	74 cd                	je     800437 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80046a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80046f:	75 07                	jne    800478 <strncmp+0x57>
		return 0;
  800471:	b8 00 00 00 00       	mov    $0x0,%eax
  800476:	eb 18                	jmp    800490 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800478:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80047c:	0f b6 00             	movzbl (%rax),%eax
  80047f:	0f b6 d0             	movzbl %al,%edx
  800482:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800486:	0f b6 00             	movzbl (%rax),%eax
  800489:	0f b6 c0             	movzbl %al,%eax
  80048c:	29 c2                	sub    %eax,%edx
  80048e:	89 d0                	mov    %edx,%eax
}
  800490:	c9                   	leaveq 
  800491:	c3                   	retq   

0000000000800492 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800492:	55                   	push   %rbp
  800493:	48 89 e5             	mov    %rsp,%rbp
  800496:	48 83 ec 0c          	sub    $0xc,%rsp
  80049a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80049e:	89 f0                	mov    %esi,%eax
  8004a0:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004a3:	eb 17                	jmp    8004bc <strchr+0x2a>
		if (*s == c)
  8004a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004a9:	0f b6 00             	movzbl (%rax),%eax
  8004ac:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004af:	75 06                	jne    8004b7 <strchr+0x25>
			return (char *) s;
  8004b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004b5:	eb 15                	jmp    8004cc <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8004b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004c0:	0f b6 00             	movzbl (%rax),%eax
  8004c3:	84 c0                	test   %al,%al
  8004c5:	75 de                	jne    8004a5 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8004c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004cc:	c9                   	leaveq 
  8004cd:	c3                   	retq   

00000000008004ce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8004ce:	55                   	push   %rbp
  8004cf:	48 89 e5             	mov    %rsp,%rbp
  8004d2:	48 83 ec 0c          	sub    $0xc,%rsp
  8004d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004da:	89 f0                	mov    %esi,%eax
  8004dc:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004df:	eb 13                	jmp    8004f4 <strfind+0x26>
		if (*s == c)
  8004e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004e5:	0f b6 00             	movzbl (%rax),%eax
  8004e8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004eb:	75 02                	jne    8004ef <strfind+0x21>
			break;
  8004ed:	eb 10                	jmp    8004ff <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8004ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004f8:	0f b6 00             	movzbl (%rax),%eax
  8004fb:	84 c0                	test   %al,%al
  8004fd:	75 e2                	jne    8004e1 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8004ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800503:	c9                   	leaveq 
  800504:	c3                   	retq   

0000000000800505 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800505:	55                   	push   %rbp
  800506:	48 89 e5             	mov    %rsp,%rbp
  800509:	48 83 ec 18          	sub    $0x18,%rsp
  80050d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800511:	89 75 f4             	mov    %esi,-0xc(%rbp)
  800514:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  800518:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80051d:	75 06                	jne    800525 <memset+0x20>
		return v;
  80051f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800523:	eb 69                	jmp    80058e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  800525:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800529:	83 e0 03             	and    $0x3,%eax
  80052c:	48 85 c0             	test   %rax,%rax
  80052f:	75 48                	jne    800579 <memset+0x74>
  800531:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800535:	83 e0 03             	and    $0x3,%eax
  800538:	48 85 c0             	test   %rax,%rax
  80053b:	75 3c                	jne    800579 <memset+0x74>
		c &= 0xFF;
  80053d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800544:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800547:	c1 e0 18             	shl    $0x18,%eax
  80054a:	89 c2                	mov    %eax,%edx
  80054c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80054f:	c1 e0 10             	shl    $0x10,%eax
  800552:	09 c2                	or     %eax,%edx
  800554:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800557:	c1 e0 08             	shl    $0x8,%eax
  80055a:	09 d0                	or     %edx,%eax
  80055c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80055f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800563:	48 c1 e8 02          	shr    $0x2,%rax
  800567:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80056a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80056e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800571:	48 89 d7             	mov    %rdx,%rdi
  800574:	fc                   	cld    
  800575:	f3 ab                	rep stos %eax,%es:(%rdi)
  800577:	eb 11                	jmp    80058a <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800579:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80057d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800580:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800584:	48 89 d7             	mov    %rdx,%rdi
  800587:	fc                   	cld    
  800588:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80058a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80058e:	c9                   	leaveq 
  80058f:	c3                   	retq   

0000000000800590 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800590:	55                   	push   %rbp
  800591:	48 89 e5             	mov    %rsp,%rbp
  800594:	48 83 ec 28          	sub    $0x28,%rsp
  800598:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80059c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8005a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8005a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8005ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8005b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005b8:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8005bc:	0f 83 88 00 00 00    	jae    80064a <memmove+0xba>
  8005c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005c6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8005ca:	48 01 d0             	add    %rdx,%rax
  8005cd:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8005d1:	76 77                	jbe    80064a <memmove+0xba>
		s += n;
  8005d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005d7:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8005db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005df:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8005e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005e7:	83 e0 03             	and    $0x3,%eax
  8005ea:	48 85 c0             	test   %rax,%rax
  8005ed:	75 3b                	jne    80062a <memmove+0x9a>
  8005ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005f3:	83 e0 03             	and    $0x3,%eax
  8005f6:	48 85 c0             	test   %rax,%rax
  8005f9:	75 2f                	jne    80062a <memmove+0x9a>
  8005fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005ff:	83 e0 03             	and    $0x3,%eax
  800602:	48 85 c0             	test   %rax,%rax
  800605:	75 23                	jne    80062a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800607:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80060b:	48 83 e8 04          	sub    $0x4,%rax
  80060f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800613:	48 83 ea 04          	sub    $0x4,%rdx
  800617:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80061b:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80061f:	48 89 c7             	mov    %rax,%rdi
  800622:	48 89 d6             	mov    %rdx,%rsi
  800625:	fd                   	std    
  800626:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  800628:	eb 1d                	jmp    800647 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80062a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800632:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800636:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80063a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80063e:	48 89 d7             	mov    %rdx,%rdi
  800641:	48 89 c1             	mov    %rax,%rcx
  800644:	fd                   	std    
  800645:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800647:	fc                   	cld    
  800648:	eb 57                	jmp    8006a1 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80064a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80064e:	83 e0 03             	and    $0x3,%eax
  800651:	48 85 c0             	test   %rax,%rax
  800654:	75 36                	jne    80068c <memmove+0xfc>
  800656:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80065a:	83 e0 03             	and    $0x3,%eax
  80065d:	48 85 c0             	test   %rax,%rax
  800660:	75 2a                	jne    80068c <memmove+0xfc>
  800662:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800666:	83 e0 03             	and    $0x3,%eax
  800669:	48 85 c0             	test   %rax,%rax
  80066c:	75 1e                	jne    80068c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80066e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800672:	48 c1 e8 02          	shr    $0x2,%rax
  800676:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800679:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80067d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800681:	48 89 c7             	mov    %rax,%rdi
  800684:	48 89 d6             	mov    %rdx,%rsi
  800687:	fc                   	cld    
  800688:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80068a:	eb 15                	jmp    8006a1 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80068c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800690:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800694:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800698:	48 89 c7             	mov    %rax,%rdi
  80069b:	48 89 d6             	mov    %rdx,%rsi
  80069e:	fc                   	cld    
  80069f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8006a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8006a5:	c9                   	leaveq 
  8006a6:	c3                   	retq   

00000000008006a7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8006a7:	55                   	push   %rbp
  8006a8:	48 89 e5             	mov    %rsp,%rbp
  8006ab:	48 83 ec 18          	sub    $0x18,%rsp
  8006af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8006b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8006b7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8006bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006bf:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8006c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006c7:	48 89 ce             	mov    %rcx,%rsi
  8006ca:	48 89 c7             	mov    %rax,%rdi
  8006cd:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  8006d4:	00 00 00 
  8006d7:	ff d0                	callq  *%rax
}
  8006d9:	c9                   	leaveq 
  8006da:	c3                   	retq   

00000000008006db <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8006db:	55                   	push   %rbp
  8006dc:	48 89 e5             	mov    %rsp,%rbp
  8006df:	48 83 ec 28          	sub    $0x28,%rsp
  8006e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8006ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8006f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8006ff:	eb 36                	jmp    800737 <memcmp+0x5c>
		if (*s1 != *s2)
  800701:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800705:	0f b6 10             	movzbl (%rax),%edx
  800708:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80070c:	0f b6 00             	movzbl (%rax),%eax
  80070f:	38 c2                	cmp    %al,%dl
  800711:	74 1a                	je     80072d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  800713:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800717:	0f b6 00             	movzbl (%rax),%eax
  80071a:	0f b6 d0             	movzbl %al,%edx
  80071d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800721:	0f b6 00             	movzbl (%rax),%eax
  800724:	0f b6 c0             	movzbl %al,%eax
  800727:	29 c2                	sub    %eax,%edx
  800729:	89 d0                	mov    %edx,%eax
  80072b:	eb 20                	jmp    80074d <memcmp+0x72>
		s1++, s2++;
  80072d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800732:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800737:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80073b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80073f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800743:	48 85 c0             	test   %rax,%rax
  800746:	75 b9                	jne    800701 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800748:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80074d:	c9                   	leaveq 
  80074e:	c3                   	retq   

000000000080074f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80074f:	55                   	push   %rbp
  800750:	48 89 e5             	mov    %rsp,%rbp
  800753:	48 83 ec 28          	sub    $0x28,%rsp
  800757:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80075b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80075e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  800762:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800766:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076a:	48 01 d0             	add    %rdx,%rax
  80076d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  800771:	eb 15                	jmp    800788 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  800773:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800777:	0f b6 10             	movzbl (%rax),%edx
  80077a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80077d:	38 c2                	cmp    %al,%dl
  80077f:	75 02                	jne    800783 <memfind+0x34>
			break;
  800781:	eb 0f                	jmp    800792 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800783:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800788:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800790:	72 e1                	jb     800773 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  800792:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800796:	c9                   	leaveq 
  800797:	c3                   	retq   

0000000000800798 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800798:	55                   	push   %rbp
  800799:	48 89 e5             	mov    %rsp,%rbp
  80079c:	48 83 ec 34          	sub    $0x34,%rsp
  8007a0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8007a4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8007a8:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8007ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8007b2:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8007b9:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8007ba:	eb 05                	jmp    8007c1 <strtol+0x29>
		s++;
  8007bc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8007c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007c5:	0f b6 00             	movzbl (%rax),%eax
  8007c8:	3c 20                	cmp    $0x20,%al
  8007ca:	74 f0                	je     8007bc <strtol+0x24>
  8007cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007d0:	0f b6 00             	movzbl (%rax),%eax
  8007d3:	3c 09                	cmp    $0x9,%al
  8007d5:	74 e5                	je     8007bc <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8007d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007db:	0f b6 00             	movzbl (%rax),%eax
  8007de:	3c 2b                	cmp    $0x2b,%al
  8007e0:	75 07                	jne    8007e9 <strtol+0x51>
		s++;
  8007e2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8007e7:	eb 17                	jmp    800800 <strtol+0x68>
	else if (*s == '-')
  8007e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007ed:	0f b6 00             	movzbl (%rax),%eax
  8007f0:	3c 2d                	cmp    $0x2d,%al
  8007f2:	75 0c                	jne    800800 <strtol+0x68>
		s++, neg = 1;
  8007f4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8007f9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800800:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  800804:	74 06                	je     80080c <strtol+0x74>
  800806:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80080a:	75 28                	jne    800834 <strtol+0x9c>
  80080c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800810:	0f b6 00             	movzbl (%rax),%eax
  800813:	3c 30                	cmp    $0x30,%al
  800815:	75 1d                	jne    800834 <strtol+0x9c>
  800817:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80081b:	48 83 c0 01          	add    $0x1,%rax
  80081f:	0f b6 00             	movzbl (%rax),%eax
  800822:	3c 78                	cmp    $0x78,%al
  800824:	75 0e                	jne    800834 <strtol+0x9c>
		s += 2, base = 16;
  800826:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80082b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  800832:	eb 2c                	jmp    800860 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  800834:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  800838:	75 19                	jne    800853 <strtol+0xbb>
  80083a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80083e:	0f b6 00             	movzbl (%rax),%eax
  800841:	3c 30                	cmp    $0x30,%al
  800843:	75 0e                	jne    800853 <strtol+0xbb>
		s++, base = 8;
  800845:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80084a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  800851:	eb 0d                	jmp    800860 <strtol+0xc8>
	else if (base == 0)
  800853:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  800857:	75 07                	jne    800860 <strtol+0xc8>
		base = 10;
  800859:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800860:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800864:	0f b6 00             	movzbl (%rax),%eax
  800867:	3c 2f                	cmp    $0x2f,%al
  800869:	7e 1d                	jle    800888 <strtol+0xf0>
  80086b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80086f:	0f b6 00             	movzbl (%rax),%eax
  800872:	3c 39                	cmp    $0x39,%al
  800874:	7f 12                	jg     800888 <strtol+0xf0>
			dig = *s - '0';
  800876:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80087a:	0f b6 00             	movzbl (%rax),%eax
  80087d:	0f be c0             	movsbl %al,%eax
  800880:	83 e8 30             	sub    $0x30,%eax
  800883:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800886:	eb 4e                	jmp    8008d6 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  800888:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80088c:	0f b6 00             	movzbl (%rax),%eax
  80088f:	3c 60                	cmp    $0x60,%al
  800891:	7e 1d                	jle    8008b0 <strtol+0x118>
  800893:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800897:	0f b6 00             	movzbl (%rax),%eax
  80089a:	3c 7a                	cmp    $0x7a,%al
  80089c:	7f 12                	jg     8008b0 <strtol+0x118>
			dig = *s - 'a' + 10;
  80089e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008a2:	0f b6 00             	movzbl (%rax),%eax
  8008a5:	0f be c0             	movsbl %al,%eax
  8008a8:	83 e8 57             	sub    $0x57,%eax
  8008ab:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8008ae:	eb 26                	jmp    8008d6 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8008b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008b4:	0f b6 00             	movzbl (%rax),%eax
  8008b7:	3c 40                	cmp    $0x40,%al
  8008b9:	7e 48                	jle    800903 <strtol+0x16b>
  8008bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008bf:	0f b6 00             	movzbl (%rax),%eax
  8008c2:	3c 5a                	cmp    $0x5a,%al
  8008c4:	7f 3d                	jg     800903 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8008c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008ca:	0f b6 00             	movzbl (%rax),%eax
  8008cd:	0f be c0             	movsbl %al,%eax
  8008d0:	83 e8 37             	sub    $0x37,%eax
  8008d3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8008d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008d9:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8008dc:	7c 02                	jl     8008e0 <strtol+0x148>
			break;
  8008de:	eb 23                	jmp    800903 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8008e0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8008e5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008e8:	48 98                	cltq   
  8008ea:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8008ef:	48 89 c2             	mov    %rax,%rdx
  8008f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008f5:	48 98                	cltq   
  8008f7:	48 01 d0             	add    %rdx,%rax
  8008fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8008fe:	e9 5d ff ff ff       	jmpq   800860 <strtol+0xc8>

	if (endptr)
  800903:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800908:	74 0b                	je     800915 <strtol+0x17d>
		*endptr = (char *) s;
  80090a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80090e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800912:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  800915:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800919:	74 09                	je     800924 <strtol+0x18c>
  80091b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80091f:	48 f7 d8             	neg    %rax
  800922:	eb 04                	jmp    800928 <strtol+0x190>
  800924:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800928:	c9                   	leaveq 
  800929:	c3                   	retq   

000000000080092a <strstr>:

char * strstr(const char *in, const char *str)
{
  80092a:	55                   	push   %rbp
  80092b:	48 89 e5             	mov    %rsp,%rbp
  80092e:	48 83 ec 30          	sub    $0x30,%rsp
  800932:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800936:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  80093a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80093e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800942:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800946:	0f b6 00             	movzbl (%rax),%eax
  800949:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  80094c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  800950:	75 06                	jne    800958 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  800952:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800956:	eb 6b                	jmp    8009c3 <strstr+0x99>

    len = strlen(str);
  800958:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80095c:	48 89 c7             	mov    %rax,%rdi
  80095f:	48 b8 00 02 80 00 00 	movabs $0x800200,%rax
  800966:	00 00 00 
  800969:	ff d0                	callq  *%rax
  80096b:	48 98                	cltq   
  80096d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  800971:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800975:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800979:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80097d:	0f b6 00             	movzbl (%rax),%eax
  800980:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  800983:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  800987:	75 07                	jne    800990 <strstr+0x66>
                return (char *) 0;
  800989:	b8 00 00 00 00       	mov    $0x0,%eax
  80098e:	eb 33                	jmp    8009c3 <strstr+0x99>
        } while (sc != c);
  800990:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  800994:	3a 45 ff             	cmp    -0x1(%rbp),%al
  800997:	75 d8                	jne    800971 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  800999:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80099d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8009a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009a5:	48 89 ce             	mov    %rcx,%rsi
  8009a8:	48 89 c7             	mov    %rax,%rdi
  8009ab:	48 b8 21 04 80 00 00 	movabs $0x800421,%rax
  8009b2:	00 00 00 
  8009b5:	ff d0                	callq  *%rax
  8009b7:	85 c0                	test   %eax,%eax
  8009b9:	75 b6                	jne    800971 <strstr+0x47>

    return (char *) (in - 1);
  8009bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009bf:	48 83 e8 01          	sub    $0x1,%rax
}
  8009c3:	c9                   	leaveq 
  8009c4:	c3                   	retq   

00000000008009c5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8009c5:	55                   	push   %rbp
  8009c6:	48 89 e5             	mov    %rsp,%rbp
  8009c9:	53                   	push   %rbx
  8009ca:	48 83 ec 48          	sub    $0x48,%rsp
  8009ce:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8009d1:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8009d4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8009d8:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8009dc:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8009e0:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8009e4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8009e7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8009eb:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8009ef:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8009f3:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8009f7:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8009fb:	4c 89 c3             	mov    %r8,%rbx
  8009fe:	cd 30                	int    $0x30
  800a00:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800a04:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a08:	74 3e                	je     800a48 <syscall+0x83>
  800a0a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800a0f:	7e 37                	jle    800a48 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800a11:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a15:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a18:	49 89 d0             	mov    %rdx,%r8
  800a1b:	89 c1                	mov    %eax,%ecx
  800a1d:	48 ba d1 34 80 00 00 	movabs $0x8034d1,%rdx
  800a24:	00 00 00 
  800a27:	be 23 00 00 00       	mov    $0x23,%esi
  800a2c:	48 bf ee 34 80 00 00 	movabs $0x8034ee,%rdi
  800a33:	00 00 00 
  800a36:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3b:	49 b9 ad 24 80 00 00 	movabs $0x8024ad,%r9
  800a42:	00 00 00 
  800a45:	41 ff d1             	callq  *%r9

	return ret;
  800a48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800a4c:	48 83 c4 48          	add    $0x48,%rsp
  800a50:	5b                   	pop    %rbx
  800a51:	5d                   	pop    %rbp
  800a52:	c3                   	retq   

0000000000800a53 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800a53:	55                   	push   %rbp
  800a54:	48 89 e5             	mov    %rsp,%rbp
  800a57:	48 83 ec 20          	sub    $0x20,%rsp
  800a5b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a5f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  800a63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a67:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a6b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800a72:	00 
  800a73:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800a79:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800a7f:	48 89 d1             	mov    %rdx,%rcx
  800a82:	48 89 c2             	mov    %rax,%rdx
  800a85:	be 00 00 00 00       	mov    $0x0,%esi
  800a8a:	bf 00 00 00 00       	mov    $0x0,%edi
  800a8f:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800a96:	00 00 00 
  800a99:	ff d0                	callq  *%rax
}
  800a9b:	c9                   	leaveq 
  800a9c:	c3                   	retq   

0000000000800a9d <sys_cgetc>:

int
sys_cgetc(void)
{
  800a9d:	55                   	push   %rbp
  800a9e:	48 89 e5             	mov    %rsp,%rbp
  800aa1:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800aa5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800aac:	00 
  800aad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800ab3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800ab9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800abe:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac3:	be 00 00 00 00       	mov    $0x0,%esi
  800ac8:	bf 01 00 00 00       	mov    $0x1,%edi
  800acd:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800ad4:	00 00 00 
  800ad7:	ff d0                	callq  *%rax
}
  800ad9:	c9                   	leaveq 
  800ada:	c3                   	retq   

0000000000800adb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800adb:	55                   	push   %rbp
  800adc:	48 89 e5             	mov    %rsp,%rbp
  800adf:	48 83 ec 10          	sub    $0x10,%rsp
  800ae3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800ae6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ae9:	48 98                	cltq   
  800aeb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800af2:	00 
  800af3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800af9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800aff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b04:	48 89 c2             	mov    %rax,%rdx
  800b07:	be 01 00 00 00       	mov    $0x1,%esi
  800b0c:	bf 03 00 00 00       	mov    $0x3,%edi
  800b11:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800b18:	00 00 00 
  800b1b:	ff d0                	callq  *%rax
}
  800b1d:	c9                   	leaveq 
  800b1e:	c3                   	retq   

0000000000800b1f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b1f:	55                   	push   %rbp
  800b20:	48 89 e5             	mov    %rsp,%rbp
  800b23:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b27:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800b2e:	00 
  800b2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b35:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b40:	ba 00 00 00 00       	mov    $0x0,%edx
  800b45:	be 00 00 00 00       	mov    $0x0,%esi
  800b4a:	bf 02 00 00 00       	mov    $0x2,%edi
  800b4f:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800b56:	00 00 00 
  800b59:	ff d0                	callq  *%rax
}
  800b5b:	c9                   	leaveq 
  800b5c:	c3                   	retq   

0000000000800b5d <sys_yield>:

void
sys_yield(void)
{
  800b5d:	55                   	push   %rbp
  800b5e:	48 89 e5             	mov    %rsp,%rbp
  800b61:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b65:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800b6c:	00 
  800b6d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b73:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b79:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b83:	be 00 00 00 00       	mov    $0x0,%esi
  800b88:	bf 0b 00 00 00       	mov    $0xb,%edi
  800b8d:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800b94:	00 00 00 
  800b97:	ff d0                	callq  *%rax
}
  800b99:	c9                   	leaveq 
  800b9a:	c3                   	retq   

0000000000800b9b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b9b:	55                   	push   %rbp
  800b9c:	48 89 e5             	mov    %rsp,%rbp
  800b9f:	48 83 ec 20          	sub    $0x20,%rsp
  800ba3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ba6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800baa:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800bad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bb0:	48 63 c8             	movslq %eax,%rcx
  800bb3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800bb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bba:	48 98                	cltq   
  800bbc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800bc3:	00 
  800bc4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800bca:	49 89 c8             	mov    %rcx,%r8
  800bcd:	48 89 d1             	mov    %rdx,%rcx
  800bd0:	48 89 c2             	mov    %rax,%rdx
  800bd3:	be 01 00 00 00       	mov    $0x1,%esi
  800bd8:	bf 04 00 00 00       	mov    $0x4,%edi
  800bdd:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800be4:	00 00 00 
  800be7:	ff d0                	callq  *%rax
}
  800be9:	c9                   	leaveq 
  800bea:	c3                   	retq   

0000000000800beb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800beb:	55                   	push   %rbp
  800bec:	48 89 e5             	mov    %rsp,%rbp
  800bef:	48 83 ec 30          	sub    $0x30,%rsp
  800bf3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bf6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800bfa:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800bfd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800c01:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800c05:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800c08:	48 63 c8             	movslq %eax,%rcx
  800c0b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800c0f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c12:	48 63 f0             	movslq %eax,%rsi
  800c15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c1c:	48 98                	cltq   
  800c1e:	48 89 0c 24          	mov    %rcx,(%rsp)
  800c22:	49 89 f9             	mov    %rdi,%r9
  800c25:	49 89 f0             	mov    %rsi,%r8
  800c28:	48 89 d1             	mov    %rdx,%rcx
  800c2b:	48 89 c2             	mov    %rax,%rdx
  800c2e:	be 01 00 00 00       	mov    $0x1,%esi
  800c33:	bf 05 00 00 00       	mov    $0x5,%edi
  800c38:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800c3f:	00 00 00 
  800c42:	ff d0                	callq  *%rax
}
  800c44:	c9                   	leaveq 
  800c45:	c3                   	retq   

0000000000800c46 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c46:	55                   	push   %rbp
  800c47:	48 89 e5             	mov    %rsp,%rbp
  800c4a:	48 83 ec 20          	sub    $0x20,%rsp
  800c4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  800c55:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c5c:	48 98                	cltq   
  800c5e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800c65:	00 
  800c66:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800c6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800c72:	48 89 d1             	mov    %rdx,%rcx
  800c75:	48 89 c2             	mov    %rax,%rdx
  800c78:	be 01 00 00 00       	mov    $0x1,%esi
  800c7d:	bf 06 00 00 00       	mov    $0x6,%edi
  800c82:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800c89:	00 00 00 
  800c8c:	ff d0                	callq  *%rax
}
  800c8e:	c9                   	leaveq 
  800c8f:	c3                   	retq   

0000000000800c90 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c90:	55                   	push   %rbp
  800c91:	48 89 e5             	mov    %rsp,%rbp
  800c94:	48 83 ec 10          	sub    $0x10,%rsp
  800c98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c9b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800ca1:	48 63 d0             	movslq %eax,%rdx
  800ca4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ca7:	48 98                	cltq   
  800ca9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800cb0:	00 
  800cb1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800cb7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800cbd:	48 89 d1             	mov    %rdx,%rcx
  800cc0:	48 89 c2             	mov    %rax,%rdx
  800cc3:	be 01 00 00 00       	mov    $0x1,%esi
  800cc8:	bf 08 00 00 00       	mov    $0x8,%edi
  800ccd:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800cd4:	00 00 00 
  800cd7:	ff d0                	callq  *%rax
}
  800cd9:	c9                   	leaveq 
  800cda:	c3                   	retq   

0000000000800cdb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cdb:	55                   	push   %rbp
  800cdc:	48 89 e5             	mov    %rsp,%rbp
  800cdf:	48 83 ec 20          	sub    $0x20,%rsp
  800ce3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ce6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800cea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cf1:	48 98                	cltq   
  800cf3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800cfa:	00 
  800cfb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800d01:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800d07:	48 89 d1             	mov    %rdx,%rcx
  800d0a:	48 89 c2             	mov    %rax,%rdx
  800d0d:	be 01 00 00 00       	mov    $0x1,%esi
  800d12:	bf 09 00 00 00       	mov    $0x9,%edi
  800d17:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800d1e:	00 00 00 
  800d21:	ff d0                	callq  *%rax
}
  800d23:	c9                   	leaveq 
  800d24:	c3                   	retq   

0000000000800d25 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d25:	55                   	push   %rbp
  800d26:	48 89 e5             	mov    %rsp,%rbp
  800d29:	48 83 ec 20          	sub    $0x20,%rsp
  800d2d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d30:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800d34:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d3b:	48 98                	cltq   
  800d3d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800d44:	00 
  800d45:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800d4b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800d51:	48 89 d1             	mov    %rdx,%rcx
  800d54:	48 89 c2             	mov    %rax,%rdx
  800d57:	be 01 00 00 00       	mov    $0x1,%esi
  800d5c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800d61:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800d68:	00 00 00 
  800d6b:	ff d0                	callq  *%rax
}
  800d6d:	c9                   	leaveq 
  800d6e:	c3                   	retq   

0000000000800d6f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800d6f:	55                   	push   %rbp
  800d70:	48 89 e5             	mov    %rsp,%rbp
  800d73:	48 83 ec 20          	sub    $0x20,%rsp
  800d77:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d7a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800d7e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800d82:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800d85:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800d88:	48 63 f0             	movslq %eax,%rsi
  800d8b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800d8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d92:	48 98                	cltq   
  800d94:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d98:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800d9f:	00 
  800da0:	49 89 f1             	mov    %rsi,%r9
  800da3:	49 89 c8             	mov    %rcx,%r8
  800da6:	48 89 d1             	mov    %rdx,%rcx
  800da9:	48 89 c2             	mov    %rax,%rdx
  800dac:	be 00 00 00 00       	mov    $0x0,%esi
  800db1:	bf 0c 00 00 00       	mov    $0xc,%edi
  800db6:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800dbd:	00 00 00 
  800dc0:	ff d0                	callq  *%rax
}
  800dc2:	c9                   	leaveq 
  800dc3:	c3                   	retq   

0000000000800dc4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dc4:	55                   	push   %rbp
  800dc5:	48 89 e5             	mov    %rsp,%rbp
  800dc8:	48 83 ec 10          	sub    $0x10,%rsp
  800dcc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800dd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800dd4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800ddb:	00 
  800ddc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800de2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800de8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ded:	48 89 c2             	mov    %rax,%rdx
  800df0:	be 01 00 00 00       	mov    $0x1,%esi
  800df5:	bf 0d 00 00 00       	mov    $0xd,%edi
  800dfa:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800e01:	00 00 00 
  800e04:	ff d0                	callq  *%rax
}
  800e06:	c9                   	leaveq 
  800e07:	c3                   	retq   

0000000000800e08 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800e08:	55                   	push   %rbp
  800e09:	48 89 e5             	mov    %rsp,%rbp
  800e0c:	48 83 ec 08          	sub    $0x8,%rsp
  800e10:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e14:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800e18:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800e1f:	ff ff ff 
  800e22:	48 01 d0             	add    %rdx,%rax
  800e25:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800e29:	c9                   	leaveq 
  800e2a:	c3                   	retq   

0000000000800e2b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e2b:	55                   	push   %rbp
  800e2c:	48 89 e5             	mov    %rsp,%rbp
  800e2f:	48 83 ec 08          	sub    $0x8,%rsp
  800e33:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800e37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800e3b:	48 89 c7             	mov    %rax,%rdi
  800e3e:	48 b8 08 0e 80 00 00 	movabs $0x800e08,%rax
  800e45:	00 00 00 
  800e48:	ff d0                	callq  *%rax
  800e4a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800e50:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800e54:	c9                   	leaveq 
  800e55:	c3                   	retq   

0000000000800e56 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e56:	55                   	push   %rbp
  800e57:	48 89 e5             	mov    %rsp,%rbp
  800e5a:	48 83 ec 18          	sub    $0x18,%rsp
  800e5e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800e62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e69:	eb 6b                	jmp    800ed6 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  800e6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e6e:	48 98                	cltq   
  800e70:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800e76:	48 c1 e0 0c          	shl    $0xc,%rax
  800e7a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e82:	48 c1 e8 15          	shr    $0x15,%rax
  800e86:	48 89 c2             	mov    %rax,%rdx
  800e89:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800e90:	01 00 00 
  800e93:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800e97:	83 e0 01             	and    $0x1,%eax
  800e9a:	48 85 c0             	test   %rax,%rax
  800e9d:	74 21                	je     800ec0 <fd_alloc+0x6a>
  800e9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea3:	48 c1 e8 0c          	shr    $0xc,%rax
  800ea7:	48 89 c2             	mov    %rax,%rdx
  800eaa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800eb1:	01 00 00 
  800eb4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800eb8:	83 e0 01             	and    $0x1,%eax
  800ebb:	48 85 c0             	test   %rax,%rax
  800ebe:	75 12                	jne    800ed2 <fd_alloc+0x7c>
			*fd_store = fd;
  800ec0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ec8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800ecb:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed0:	eb 1a                	jmp    800eec <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800ed2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800ed6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800eda:	7e 8f                	jle    800e6b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800edc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800ee7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800eec:	c9                   	leaveq 
  800eed:	c3                   	retq   

0000000000800eee <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800eee:	55                   	push   %rbp
  800eef:	48 89 e5             	mov    %rsp,%rbp
  800ef2:	48 83 ec 20          	sub    $0x20,%rsp
  800ef6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800ef9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800efd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800f01:	78 06                	js     800f09 <fd_lookup+0x1b>
  800f03:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800f07:	7e 07                	jle    800f10 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800f09:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f0e:	eb 6c                	jmp    800f7c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800f10:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800f13:	48 98                	cltq   
  800f15:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800f1b:	48 c1 e0 0c          	shl    $0xc,%rax
  800f1f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f27:	48 c1 e8 15          	shr    $0x15,%rax
  800f2b:	48 89 c2             	mov    %rax,%rdx
  800f2e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800f35:	01 00 00 
  800f38:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800f3c:	83 e0 01             	and    $0x1,%eax
  800f3f:	48 85 c0             	test   %rax,%rax
  800f42:	74 21                	je     800f65 <fd_lookup+0x77>
  800f44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f48:	48 c1 e8 0c          	shr    $0xc,%rax
  800f4c:	48 89 c2             	mov    %rax,%rdx
  800f4f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800f56:	01 00 00 
  800f59:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800f5d:	83 e0 01             	and    $0x1,%eax
  800f60:	48 85 c0             	test   %rax,%rax
  800f63:	75 07                	jne    800f6c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800f65:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f6a:	eb 10                	jmp    800f7c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  800f6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f70:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800f74:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  800f77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f7c:	c9                   	leaveq 
  800f7d:	c3                   	retq   

0000000000800f7e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800f7e:	55                   	push   %rbp
  800f7f:	48 89 e5             	mov    %rsp,%rbp
  800f82:	48 83 ec 30          	sub    $0x30,%rsp
  800f86:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800f8a:	89 f0                	mov    %esi,%eax
  800f8c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f8f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800f93:	48 89 c7             	mov    %rax,%rdi
  800f96:	48 b8 08 0e 80 00 00 	movabs $0x800e08,%rax
  800f9d:	00 00 00 
  800fa0:	ff d0                	callq  *%rax
  800fa2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800fa6:	48 89 d6             	mov    %rdx,%rsi
  800fa9:	89 c7                	mov    %eax,%edi
  800fab:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  800fb2:	00 00 00 
  800fb5:	ff d0                	callq  *%rax
  800fb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fbe:	78 0a                	js     800fca <fd_close+0x4c>
	    || fd != fd2)
  800fc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  800fc8:	74 12                	je     800fdc <fd_close+0x5e>
		return (must_exist ? r : 0);
  800fca:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  800fce:	74 05                	je     800fd5 <fd_close+0x57>
  800fd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fd3:	eb 05                	jmp    800fda <fd_close+0x5c>
  800fd5:	b8 00 00 00 00       	mov    $0x0,%eax
  800fda:	eb 69                	jmp    801045 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fdc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800fe0:	8b 00                	mov    (%rax),%eax
  800fe2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800fe6:	48 89 d6             	mov    %rdx,%rsi
  800fe9:	89 c7                	mov    %eax,%edi
  800feb:	48 b8 47 10 80 00 00 	movabs $0x801047,%rax
  800ff2:	00 00 00 
  800ff5:	ff d0                	callq  *%rax
  800ff7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ffa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ffe:	78 2a                	js     80102a <fd_close+0xac>
		if (dev->dev_close)
  801000:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801004:	48 8b 40 20          	mov    0x20(%rax),%rax
  801008:	48 85 c0             	test   %rax,%rax
  80100b:	74 16                	je     801023 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80100d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801011:	48 8b 40 20          	mov    0x20(%rax),%rax
  801015:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801019:	48 89 d7             	mov    %rdx,%rdi
  80101c:	ff d0                	callq  *%rax
  80101e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801021:	eb 07                	jmp    80102a <fd_close+0xac>
		else
			r = 0;
  801023:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80102a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80102e:	48 89 c6             	mov    %rax,%rsi
  801031:	bf 00 00 00 00       	mov    $0x0,%edi
  801036:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  80103d:	00 00 00 
  801040:	ff d0                	callq  *%rax
	return r;
  801042:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801045:	c9                   	leaveq 
  801046:	c3                   	retq   

0000000000801047 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801047:	55                   	push   %rbp
  801048:	48 89 e5             	mov    %rsp,%rbp
  80104b:	48 83 ec 20          	sub    $0x20,%rsp
  80104f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801052:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801056:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80105d:	eb 41                	jmp    8010a0 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80105f:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801066:	00 00 00 
  801069:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80106c:	48 63 d2             	movslq %edx,%rdx
  80106f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801073:	8b 00                	mov    (%rax),%eax
  801075:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801078:	75 22                	jne    80109c <dev_lookup+0x55>
			*dev = devtab[i];
  80107a:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801081:	00 00 00 
  801084:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801087:	48 63 d2             	movslq %edx,%rdx
  80108a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80108e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801092:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801095:	b8 00 00 00 00       	mov    $0x0,%eax
  80109a:	eb 60                	jmp    8010fc <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80109c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8010a0:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8010a7:	00 00 00 
  8010aa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010ad:	48 63 d2             	movslq %edx,%rdx
  8010b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8010b4:	48 85 c0             	test   %rax,%rax
  8010b7:	75 a6                	jne    80105f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010b9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8010c0:	00 00 00 
  8010c3:	48 8b 00             	mov    (%rax),%rax
  8010c6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8010cc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8010cf:	89 c6                	mov    %eax,%esi
  8010d1:	48 bf 00 35 80 00 00 	movabs $0x803500,%rdi
  8010d8:	00 00 00 
  8010db:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e0:	48 b9 e6 26 80 00 00 	movabs $0x8026e6,%rcx
  8010e7:	00 00 00 
  8010ea:	ff d1                	callq  *%rcx
	*dev = 0;
  8010ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010f0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8010f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010fc:	c9                   	leaveq 
  8010fd:	c3                   	retq   

00000000008010fe <close>:

int
close(int fdnum)
{
  8010fe:	55                   	push   %rbp
  8010ff:	48 89 e5             	mov    %rsp,%rbp
  801102:	48 83 ec 20          	sub    $0x20,%rsp
  801106:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801109:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80110d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801110:	48 89 d6             	mov    %rdx,%rsi
  801113:	89 c7                	mov    %eax,%edi
  801115:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  80111c:	00 00 00 
  80111f:	ff d0                	callq  *%rax
  801121:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801124:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801128:	79 05                	jns    80112f <close+0x31>
		return r;
  80112a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80112d:	eb 18                	jmp    801147 <close+0x49>
	else
		return fd_close(fd, 1);
  80112f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801133:	be 01 00 00 00       	mov    $0x1,%esi
  801138:	48 89 c7             	mov    %rax,%rdi
  80113b:	48 b8 7e 0f 80 00 00 	movabs $0x800f7e,%rax
  801142:	00 00 00 
  801145:	ff d0                	callq  *%rax
}
  801147:	c9                   	leaveq 
  801148:	c3                   	retq   

0000000000801149 <close_all>:

void
close_all(void)
{
  801149:	55                   	push   %rbp
  80114a:	48 89 e5             	mov    %rsp,%rbp
  80114d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801151:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801158:	eb 15                	jmp    80116f <close_all+0x26>
		close(i);
  80115a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80115d:	89 c7                	mov    %eax,%edi
  80115f:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  801166:	00 00 00 
  801169:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80116b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80116f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801173:	7e e5                	jle    80115a <close_all+0x11>
		close(i);
}
  801175:	c9                   	leaveq 
  801176:	c3                   	retq   

0000000000801177 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801177:	55                   	push   %rbp
  801178:	48 89 e5             	mov    %rsp,%rbp
  80117b:	48 83 ec 40          	sub    $0x40,%rsp
  80117f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801182:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801185:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801189:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80118c:	48 89 d6             	mov    %rdx,%rsi
  80118f:	89 c7                	mov    %eax,%edi
  801191:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  801198:	00 00 00 
  80119b:	ff d0                	callq  *%rax
  80119d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011a4:	79 08                	jns    8011ae <dup+0x37>
		return r;
  8011a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011a9:	e9 70 01 00 00       	jmpq   80131e <dup+0x1a7>
	close(newfdnum);
  8011ae:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8011b1:	89 c7                	mov    %eax,%edi
  8011b3:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  8011ba:	00 00 00 
  8011bd:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8011bf:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8011c2:	48 98                	cltq   
  8011c4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8011ca:	48 c1 e0 0c          	shl    $0xc,%rax
  8011ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8011d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011d6:	48 89 c7             	mov    %rax,%rdi
  8011d9:	48 b8 2b 0e 80 00 00 	movabs $0x800e2b,%rax
  8011e0:	00 00 00 
  8011e3:	ff d0                	callq  *%rax
  8011e5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8011e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ed:	48 89 c7             	mov    %rax,%rdi
  8011f0:	48 b8 2b 0e 80 00 00 	movabs $0x800e2b,%rax
  8011f7:	00 00 00 
  8011fa:	ff d0                	callq  *%rax
  8011fc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801200:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801204:	48 c1 e8 15          	shr    $0x15,%rax
  801208:	48 89 c2             	mov    %rax,%rdx
  80120b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801212:	01 00 00 
  801215:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801219:	83 e0 01             	and    $0x1,%eax
  80121c:	48 85 c0             	test   %rax,%rax
  80121f:	74 73                	je     801294 <dup+0x11d>
  801221:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801225:	48 c1 e8 0c          	shr    $0xc,%rax
  801229:	48 89 c2             	mov    %rax,%rdx
  80122c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801233:	01 00 00 
  801236:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80123a:	83 e0 01             	and    $0x1,%eax
  80123d:	48 85 c0             	test   %rax,%rax
  801240:	74 52                	je     801294 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801242:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801246:	48 c1 e8 0c          	shr    $0xc,%rax
  80124a:	48 89 c2             	mov    %rax,%rdx
  80124d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801254:	01 00 00 
  801257:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80125b:	25 07 0e 00 00       	and    $0xe07,%eax
  801260:	89 c1                	mov    %eax,%ecx
  801262:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801266:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126a:	41 89 c8             	mov    %ecx,%r8d
  80126d:	48 89 d1             	mov    %rdx,%rcx
  801270:	ba 00 00 00 00       	mov    $0x0,%edx
  801275:	48 89 c6             	mov    %rax,%rsi
  801278:	bf 00 00 00 00       	mov    $0x0,%edi
  80127d:	48 b8 eb 0b 80 00 00 	movabs $0x800beb,%rax
  801284:	00 00 00 
  801287:	ff d0                	callq  *%rax
  801289:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80128c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801290:	79 02                	jns    801294 <dup+0x11d>
			goto err;
  801292:	eb 57                	jmp    8012eb <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801294:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801298:	48 c1 e8 0c          	shr    $0xc,%rax
  80129c:	48 89 c2             	mov    %rax,%rdx
  80129f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8012a6:	01 00 00 
  8012a9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8012ad:	25 07 0e 00 00       	and    $0xe07,%eax
  8012b2:	89 c1                	mov    %eax,%ecx
  8012b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8012bc:	41 89 c8             	mov    %ecx,%r8d
  8012bf:	48 89 d1             	mov    %rdx,%rcx
  8012c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8012c7:	48 89 c6             	mov    %rax,%rsi
  8012ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8012cf:	48 b8 eb 0b 80 00 00 	movabs $0x800beb,%rax
  8012d6:	00 00 00 
  8012d9:	ff d0                	callq  *%rax
  8012db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012e2:	79 02                	jns    8012e6 <dup+0x16f>
		goto err;
  8012e4:	eb 05                	jmp    8012eb <dup+0x174>

	return newfdnum;
  8012e6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8012e9:	eb 33                	jmp    80131e <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8012eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ef:	48 89 c6             	mov    %rax,%rsi
  8012f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8012f7:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  8012fe:	00 00 00 
  801301:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  801303:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801307:	48 89 c6             	mov    %rax,%rsi
  80130a:	bf 00 00 00 00       	mov    $0x0,%edi
  80130f:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  801316:	00 00 00 
  801319:	ff d0                	callq  *%rax
	return r;
  80131b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80131e:	c9                   	leaveq 
  80131f:	c3                   	retq   

0000000000801320 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801320:	55                   	push   %rbp
  801321:	48 89 e5             	mov    %rsp,%rbp
  801324:	48 83 ec 40          	sub    $0x40,%rsp
  801328:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80132b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80132f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801333:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801337:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80133a:	48 89 d6             	mov    %rdx,%rsi
  80133d:	89 c7                	mov    %eax,%edi
  80133f:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  801346:	00 00 00 
  801349:	ff d0                	callq  *%rax
  80134b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80134e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801352:	78 24                	js     801378 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801354:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801358:	8b 00                	mov    (%rax),%eax
  80135a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80135e:	48 89 d6             	mov    %rdx,%rsi
  801361:	89 c7                	mov    %eax,%edi
  801363:	48 b8 47 10 80 00 00 	movabs $0x801047,%rax
  80136a:	00 00 00 
  80136d:	ff d0                	callq  *%rax
  80136f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801372:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801376:	79 05                	jns    80137d <read+0x5d>
		return r;
  801378:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80137b:	eb 76                	jmp    8013f3 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80137d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801381:	8b 40 08             	mov    0x8(%rax),%eax
  801384:	83 e0 03             	and    $0x3,%eax
  801387:	83 f8 01             	cmp    $0x1,%eax
  80138a:	75 3a                	jne    8013c6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80138c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801393:	00 00 00 
  801396:	48 8b 00             	mov    (%rax),%rax
  801399:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80139f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8013a2:	89 c6                	mov    %eax,%esi
  8013a4:	48 bf 1f 35 80 00 00 	movabs $0x80351f,%rdi
  8013ab:	00 00 00 
  8013ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b3:	48 b9 e6 26 80 00 00 	movabs $0x8026e6,%rcx
  8013ba:	00 00 00 
  8013bd:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8013bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c4:	eb 2d                	jmp    8013f3 <read+0xd3>
	}
	if (!dev->dev_read)
  8013c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ca:	48 8b 40 10          	mov    0x10(%rax),%rax
  8013ce:	48 85 c0             	test   %rax,%rax
  8013d1:	75 07                	jne    8013da <read+0xba>
		return -E_NOT_SUPP;
  8013d3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8013d8:	eb 19                	jmp    8013f3 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8013da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013de:	48 8b 40 10          	mov    0x10(%rax),%rax
  8013e2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013e6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8013ea:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8013ee:	48 89 cf             	mov    %rcx,%rdi
  8013f1:	ff d0                	callq  *%rax
}
  8013f3:	c9                   	leaveq 
  8013f4:	c3                   	retq   

00000000008013f5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013f5:	55                   	push   %rbp
  8013f6:	48 89 e5             	mov    %rsp,%rbp
  8013f9:	48 83 ec 30          	sub    $0x30,%rsp
  8013fd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801400:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801404:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801408:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80140f:	eb 49                	jmp    80145a <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801411:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801414:	48 98                	cltq   
  801416:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80141a:	48 29 c2             	sub    %rax,%rdx
  80141d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801420:	48 63 c8             	movslq %eax,%rcx
  801423:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801427:	48 01 c1             	add    %rax,%rcx
  80142a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80142d:	48 89 ce             	mov    %rcx,%rsi
  801430:	89 c7                	mov    %eax,%edi
  801432:	48 b8 20 13 80 00 00 	movabs $0x801320,%rax
  801439:	00 00 00 
  80143c:	ff d0                	callq  *%rax
  80143e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  801441:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801445:	79 05                	jns    80144c <readn+0x57>
			return m;
  801447:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80144a:	eb 1c                	jmp    801468 <readn+0x73>
		if (m == 0)
  80144c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801450:	75 02                	jne    801454 <readn+0x5f>
			break;
  801452:	eb 11                	jmp    801465 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801454:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801457:	01 45 fc             	add    %eax,-0x4(%rbp)
  80145a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80145d:	48 98                	cltq   
  80145f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801463:	72 ac                	jb     801411 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  801465:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801468:	c9                   	leaveq 
  801469:	c3                   	retq   

000000000080146a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80146a:	55                   	push   %rbp
  80146b:	48 89 e5             	mov    %rsp,%rbp
  80146e:	48 83 ec 40          	sub    $0x40,%rsp
  801472:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801475:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801479:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80147d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801481:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801484:	48 89 d6             	mov    %rdx,%rsi
  801487:	89 c7                	mov    %eax,%edi
  801489:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  801490:	00 00 00 
  801493:	ff d0                	callq  *%rax
  801495:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801498:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80149c:	78 24                	js     8014c2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80149e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a2:	8b 00                	mov    (%rax),%eax
  8014a4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8014a8:	48 89 d6             	mov    %rdx,%rsi
  8014ab:	89 c7                	mov    %eax,%edi
  8014ad:	48 b8 47 10 80 00 00 	movabs $0x801047,%rax
  8014b4:	00 00 00 
  8014b7:	ff d0                	callq  *%rax
  8014b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8014bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014c0:	79 05                	jns    8014c7 <write+0x5d>
		return r;
  8014c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014c5:	eb 75                	jmp    80153c <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014cb:	8b 40 08             	mov    0x8(%rax),%eax
  8014ce:	83 e0 03             	and    $0x3,%eax
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	75 3a                	jne    80150f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014d5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8014dc:	00 00 00 
  8014df:	48 8b 00             	mov    (%rax),%rax
  8014e2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8014e8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8014eb:	89 c6                	mov    %eax,%esi
  8014ed:	48 bf 3b 35 80 00 00 	movabs $0x80353b,%rdi
  8014f4:	00 00 00 
  8014f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fc:	48 b9 e6 26 80 00 00 	movabs $0x8026e6,%rcx
  801503:	00 00 00 
  801506:	ff d1                	callq  *%rcx
		return -E_INVAL;
  801508:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80150d:	eb 2d                	jmp    80153c <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80150f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801513:	48 8b 40 18          	mov    0x18(%rax),%rax
  801517:	48 85 c0             	test   %rax,%rax
  80151a:	75 07                	jne    801523 <write+0xb9>
		return -E_NOT_SUPP;
  80151c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801521:	eb 19                	jmp    80153c <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  801523:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801527:	48 8b 40 18          	mov    0x18(%rax),%rax
  80152b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80152f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801533:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801537:	48 89 cf             	mov    %rcx,%rdi
  80153a:	ff d0                	callq  *%rax
}
  80153c:	c9                   	leaveq 
  80153d:	c3                   	retq   

000000000080153e <seek>:

int
seek(int fdnum, off_t offset)
{
  80153e:	55                   	push   %rbp
  80153f:	48 89 e5             	mov    %rsp,%rbp
  801542:	48 83 ec 18          	sub    $0x18,%rsp
  801546:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801549:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80154c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801550:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801553:	48 89 d6             	mov    %rdx,%rsi
  801556:	89 c7                	mov    %eax,%edi
  801558:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  80155f:	00 00 00 
  801562:	ff d0                	callq  *%rax
  801564:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801567:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80156b:	79 05                	jns    801572 <seek+0x34>
		return r;
  80156d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801570:	eb 0f                	jmp    801581 <seek+0x43>
	fd->fd_offset = offset;
  801572:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801576:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801579:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80157c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801581:	c9                   	leaveq 
  801582:	c3                   	retq   

0000000000801583 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801583:	55                   	push   %rbp
  801584:	48 89 e5             	mov    %rsp,%rbp
  801587:	48 83 ec 30          	sub    $0x30,%rsp
  80158b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80158e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801591:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801595:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801598:	48 89 d6             	mov    %rdx,%rsi
  80159b:	89 c7                	mov    %eax,%edi
  80159d:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  8015a4:	00 00 00 
  8015a7:	ff d0                	callq  *%rax
  8015a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8015ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015b0:	78 24                	js     8015d6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b6:	8b 00                	mov    (%rax),%eax
  8015b8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8015bc:	48 89 d6             	mov    %rdx,%rsi
  8015bf:	89 c7                	mov    %eax,%edi
  8015c1:	48 b8 47 10 80 00 00 	movabs $0x801047,%rax
  8015c8:	00 00 00 
  8015cb:	ff d0                	callq  *%rax
  8015cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8015d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015d4:	79 05                	jns    8015db <ftruncate+0x58>
		return r;
  8015d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015d9:	eb 72                	jmp    80164d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015df:	8b 40 08             	mov    0x8(%rax),%eax
  8015e2:	83 e0 03             	and    $0x3,%eax
  8015e5:	85 c0                	test   %eax,%eax
  8015e7:	75 3a                	jne    801623 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8015e9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8015f0:	00 00 00 
  8015f3:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015f6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8015fc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8015ff:	89 c6                	mov    %eax,%esi
  801601:	48 bf 58 35 80 00 00 	movabs $0x803558,%rdi
  801608:	00 00 00 
  80160b:	b8 00 00 00 00       	mov    $0x0,%eax
  801610:	48 b9 e6 26 80 00 00 	movabs $0x8026e6,%rcx
  801617:	00 00 00 
  80161a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80161c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801621:	eb 2a                	jmp    80164d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  801623:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801627:	48 8b 40 30          	mov    0x30(%rax),%rax
  80162b:	48 85 c0             	test   %rax,%rax
  80162e:	75 07                	jne    801637 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  801630:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801635:	eb 16                	jmp    80164d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  801637:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80163b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80163f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801643:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  801646:	89 ce                	mov    %ecx,%esi
  801648:	48 89 d7             	mov    %rdx,%rdi
  80164b:	ff d0                	callq  *%rax
}
  80164d:	c9                   	leaveq 
  80164e:	c3                   	retq   

000000000080164f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80164f:	55                   	push   %rbp
  801650:	48 89 e5             	mov    %rsp,%rbp
  801653:	48 83 ec 30          	sub    $0x30,%rsp
  801657:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80165a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80165e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801662:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801665:	48 89 d6             	mov    %rdx,%rsi
  801668:	89 c7                	mov    %eax,%edi
  80166a:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  801671:	00 00 00 
  801674:	ff d0                	callq  *%rax
  801676:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801679:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80167d:	78 24                	js     8016a3 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80167f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801683:	8b 00                	mov    (%rax),%eax
  801685:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801689:	48 89 d6             	mov    %rdx,%rsi
  80168c:	89 c7                	mov    %eax,%edi
  80168e:	48 b8 47 10 80 00 00 	movabs $0x801047,%rax
  801695:	00 00 00 
  801698:	ff d0                	callq  *%rax
  80169a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80169d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016a1:	79 05                	jns    8016a8 <fstat+0x59>
		return r;
  8016a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016a6:	eb 5e                	jmp    801706 <fstat+0xb7>
	if (!dev->dev_stat)
  8016a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ac:	48 8b 40 28          	mov    0x28(%rax),%rax
  8016b0:	48 85 c0             	test   %rax,%rax
  8016b3:	75 07                	jne    8016bc <fstat+0x6d>
		return -E_NOT_SUPP;
  8016b5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8016ba:	eb 4a                	jmp    801706 <fstat+0xb7>
	stat->st_name[0] = 0;
  8016bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016c0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8016c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016c7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8016ce:	00 00 00 
	stat->st_isdir = 0;
  8016d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016d5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8016dc:	00 00 00 
	stat->st_dev = dev;
  8016df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016e7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8016ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f2:	48 8b 40 28          	mov    0x28(%rax),%rax
  8016f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016fa:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8016fe:	48 89 ce             	mov    %rcx,%rsi
  801701:	48 89 d7             	mov    %rdx,%rdi
  801704:	ff d0                	callq  *%rax
}
  801706:	c9                   	leaveq 
  801707:	c3                   	retq   

0000000000801708 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801708:	55                   	push   %rbp
  801709:	48 89 e5             	mov    %rsp,%rbp
  80170c:	48 83 ec 20          	sub    $0x20,%rsp
  801710:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801714:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801718:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80171c:	be 00 00 00 00       	mov    $0x0,%esi
  801721:	48 89 c7             	mov    %rax,%rdi
  801724:	48 b8 f6 17 80 00 00 	movabs $0x8017f6,%rax
  80172b:	00 00 00 
  80172e:	ff d0                	callq  *%rax
  801730:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801733:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801737:	79 05                	jns    80173e <stat+0x36>
		return fd;
  801739:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80173c:	eb 2f                	jmp    80176d <stat+0x65>
	r = fstat(fd, stat);
  80173e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801742:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801745:	48 89 d6             	mov    %rdx,%rsi
  801748:	89 c7                	mov    %eax,%edi
  80174a:	48 b8 4f 16 80 00 00 	movabs $0x80164f,%rax
  801751:	00 00 00 
  801754:	ff d0                	callq  *%rax
  801756:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  801759:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80175c:	89 c7                	mov    %eax,%edi
  80175e:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  801765:	00 00 00 
  801768:	ff d0                	callq  *%rax
	return r;
  80176a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80176d:	c9                   	leaveq 
  80176e:	c3                   	retq   

000000000080176f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80176f:	55                   	push   %rbp
  801770:	48 89 e5             	mov    %rsp,%rbp
  801773:	48 83 ec 10          	sub    $0x10,%rsp
  801777:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80177a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80177e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801785:	00 00 00 
  801788:	8b 00                	mov    (%rax),%eax
  80178a:	85 c0                	test   %eax,%eax
  80178c:	75 1d                	jne    8017ab <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80178e:	bf 01 00 00 00       	mov    $0x1,%edi
  801793:	48 b8 97 33 80 00 00 	movabs $0x803397,%rax
  80179a:	00 00 00 
  80179d:	ff d0                	callq  *%rax
  80179f:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8017a6:	00 00 00 
  8017a9:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017ab:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8017b2:	00 00 00 
  8017b5:	8b 00                	mov    (%rax),%eax
  8017b7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8017ba:	b9 07 00 00 00       	mov    $0x7,%ecx
  8017bf:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8017c6:	00 00 00 
  8017c9:	89 c7                	mov    %eax,%edi
  8017cb:	48 b8 35 33 80 00 00 	movabs $0x803335,%rax
  8017d2:	00 00 00 
  8017d5:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8017d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017db:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e0:	48 89 c6             	mov    %rax,%rsi
  8017e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8017e8:	48 b8 2f 32 80 00 00 	movabs $0x80322f,%rax
  8017ef:	00 00 00 
  8017f2:	ff d0                	callq  *%rax
}
  8017f4:	c9                   	leaveq 
  8017f5:	c3                   	retq   

00000000008017f6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8017f6:	55                   	push   %rbp
  8017f7:	48 89 e5             	mov    %rsp,%rbp
  8017fa:	48 83 ec 30          	sub    $0x30,%rsp
  8017fe:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801802:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  801805:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80180c:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  801813:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80181a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80181f:	75 08                	jne    801829 <open+0x33>
	{
		return r;
  801821:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801824:	e9 f2 00 00 00       	jmpq   80191b <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  801829:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182d:	48 89 c7             	mov    %rax,%rdi
  801830:	48 b8 00 02 80 00 00 	movabs $0x800200,%rax
  801837:	00 00 00 
  80183a:	ff d0                	callq  *%rax
  80183c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80183f:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  801846:	7e 0a                	jle    801852 <open+0x5c>
	{
		return -E_BAD_PATH;
  801848:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80184d:	e9 c9 00 00 00       	jmpq   80191b <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  801852:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801859:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80185a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80185e:	48 89 c7             	mov    %rax,%rdi
  801861:	48 b8 56 0e 80 00 00 	movabs $0x800e56,%rax
  801868:	00 00 00 
  80186b:	ff d0                	callq  *%rax
  80186d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801870:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801874:	78 09                	js     80187f <open+0x89>
  801876:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80187a:	48 85 c0             	test   %rax,%rax
  80187d:	75 08                	jne    801887 <open+0x91>
		{
			return r;
  80187f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801882:	e9 94 00 00 00       	jmpq   80191b <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  801887:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188b:	ba 00 04 00 00       	mov    $0x400,%edx
  801890:	48 89 c6             	mov    %rax,%rsi
  801893:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80189a:	00 00 00 
  80189d:	48 b8 fe 02 80 00 00 	movabs $0x8002fe,%rax
  8018a4:	00 00 00 
  8018a7:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8018a9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8018b0:	00 00 00 
  8018b3:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8018b6:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8018bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018c0:	48 89 c6             	mov    %rax,%rsi
  8018c3:	bf 01 00 00 00       	mov    $0x1,%edi
  8018c8:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  8018cf:	00 00 00 
  8018d2:	ff d0                	callq  *%rax
  8018d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8018d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018db:	79 2b                	jns    801908 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8018dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018e1:	be 00 00 00 00       	mov    $0x0,%esi
  8018e6:	48 89 c7             	mov    %rax,%rdi
  8018e9:	48 b8 7e 0f 80 00 00 	movabs $0x800f7e,%rax
  8018f0:	00 00 00 
  8018f3:	ff d0                	callq  *%rax
  8018f5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8018f8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8018fc:	79 05                	jns    801903 <open+0x10d>
			{
				return d;
  8018fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801901:	eb 18                	jmp    80191b <open+0x125>
			}
			return r;
  801903:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801906:	eb 13                	jmp    80191b <open+0x125>
		}	
		return fd2num(fd_store);
  801908:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80190c:	48 89 c7             	mov    %rax,%rdi
  80190f:	48 b8 08 0e 80 00 00 	movabs $0x800e08,%rax
  801916:	00 00 00 
  801919:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80191b:	c9                   	leaveq 
  80191c:	c3                   	retq   

000000000080191d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80191d:	55                   	push   %rbp
  80191e:	48 89 e5             	mov    %rsp,%rbp
  801921:	48 83 ec 10          	sub    $0x10,%rsp
  801925:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801929:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80192d:	8b 50 0c             	mov    0xc(%rax),%edx
  801930:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801937:	00 00 00 
  80193a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80193c:	be 00 00 00 00       	mov    $0x0,%esi
  801941:	bf 06 00 00 00       	mov    $0x6,%edi
  801946:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  80194d:	00 00 00 
  801950:	ff d0                	callq  *%rax
}
  801952:	c9                   	leaveq 
  801953:	c3                   	retq   

0000000000801954 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801954:	55                   	push   %rbp
  801955:	48 89 e5             	mov    %rsp,%rbp
  801958:	48 83 ec 30          	sub    $0x30,%rsp
  80195c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801960:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801964:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  801968:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80196f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801974:	74 07                	je     80197d <devfile_read+0x29>
  801976:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80197b:	75 07                	jne    801984 <devfile_read+0x30>
		return -E_INVAL;
  80197d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801982:	eb 77                	jmp    8019fb <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801984:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801988:	8b 50 0c             	mov    0xc(%rax),%edx
  80198b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801992:	00 00 00 
  801995:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801997:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80199e:	00 00 00 
  8019a1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8019a5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8019a9:	be 00 00 00 00       	mov    $0x0,%esi
  8019ae:	bf 03 00 00 00       	mov    $0x3,%edi
  8019b3:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  8019ba:	00 00 00 
  8019bd:	ff d0                	callq  *%rax
  8019bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8019c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019c6:	7f 05                	jg     8019cd <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8019c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019cb:	eb 2e                	jmp    8019fb <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8019cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019d0:	48 63 d0             	movslq %eax,%rdx
  8019d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019d7:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8019de:	00 00 00 
  8019e1:	48 89 c7             	mov    %rax,%rdi
  8019e4:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  8019eb:	00 00 00 
  8019ee:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8019f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019f4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8019f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8019fb:	c9                   	leaveq 
  8019fc:	c3                   	retq   

00000000008019fd <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8019fd:	55                   	push   %rbp
  8019fe:	48 89 e5             	mov    %rsp,%rbp
  801a01:	48 83 ec 30          	sub    $0x30,%rsp
  801a05:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a09:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a0d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  801a11:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  801a18:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a1d:	74 07                	je     801a26 <devfile_write+0x29>
  801a1f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801a24:	75 08                	jne    801a2e <devfile_write+0x31>
		return r;
  801a26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a29:	e9 9a 00 00 00       	jmpq   801ac8 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a32:	8b 50 0c             	mov    0xc(%rax),%edx
  801a35:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801a3c:	00 00 00 
  801a3f:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  801a41:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  801a48:	00 
  801a49:	76 08                	jbe    801a53 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  801a4b:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  801a52:	00 
	}
	fsipcbuf.write.req_n = n;
  801a53:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801a5a:	00 00 00 
  801a5d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a61:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  801a65:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a69:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a6d:	48 89 c6             	mov    %rax,%rsi
  801a70:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  801a77:	00 00 00 
  801a7a:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  801a81:	00 00 00 
  801a84:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  801a86:	be 00 00 00 00       	mov    $0x0,%esi
  801a8b:	bf 04 00 00 00       	mov    $0x4,%edi
  801a90:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  801a97:	00 00 00 
  801a9a:	ff d0                	callq  *%rax
  801a9c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801aa3:	7f 20                	jg     801ac5 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  801aa5:	48 bf 7e 35 80 00 00 	movabs $0x80357e,%rdi
  801aac:	00 00 00 
  801aaf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab4:	48 ba e6 26 80 00 00 	movabs $0x8026e6,%rdx
  801abb:	00 00 00 
  801abe:	ff d2                	callq  *%rdx
		return r;
  801ac0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac3:	eb 03                	jmp    801ac8 <devfile_write+0xcb>
	}
	return r;
  801ac5:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  801ac8:	c9                   	leaveq 
  801ac9:	c3                   	retq   

0000000000801aca <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801aca:	55                   	push   %rbp
  801acb:	48 89 e5             	mov    %rsp,%rbp
  801ace:	48 83 ec 20          	sub    $0x20,%rsp
  801ad2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ad6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ada:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ade:	8b 50 0c             	mov    0xc(%rax),%edx
  801ae1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801ae8:	00 00 00 
  801aeb:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801aed:	be 00 00 00 00       	mov    $0x0,%esi
  801af2:	bf 05 00 00 00       	mov    $0x5,%edi
  801af7:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  801afe:	00 00 00 
  801b01:	ff d0                	callq  *%rax
  801b03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b0a:	79 05                	jns    801b11 <devfile_stat+0x47>
		return r;
  801b0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b0f:	eb 56                	jmp    801b67 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b11:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b15:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801b1c:	00 00 00 
  801b1f:	48 89 c7             	mov    %rax,%rdi
  801b22:	48 b8 6c 02 80 00 00 	movabs $0x80026c,%rax
  801b29:	00 00 00 
  801b2c:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801b2e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b35:	00 00 00 
  801b38:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801b3e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b42:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b48:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b4f:	00 00 00 
  801b52:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801b58:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b5c:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801b62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b67:	c9                   	leaveq 
  801b68:	c3                   	retq   

0000000000801b69 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b69:	55                   	push   %rbp
  801b6a:	48 89 e5             	mov    %rsp,%rbp
  801b6d:	48 83 ec 10          	sub    $0x10,%rsp
  801b71:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b75:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b7c:	8b 50 0c             	mov    0xc(%rax),%edx
  801b7f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b86:	00 00 00 
  801b89:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801b8b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b92:	00 00 00 
  801b95:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801b98:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b9b:	be 00 00 00 00       	mov    $0x0,%esi
  801ba0:	bf 02 00 00 00       	mov    $0x2,%edi
  801ba5:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  801bac:	00 00 00 
  801baf:	ff d0                	callq  *%rax
}
  801bb1:	c9                   	leaveq 
  801bb2:	c3                   	retq   

0000000000801bb3 <remove>:

// Delete a file
int
remove(const char *path)
{
  801bb3:	55                   	push   %rbp
  801bb4:	48 89 e5             	mov    %rsp,%rbp
  801bb7:	48 83 ec 10          	sub    $0x10,%rsp
  801bbb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801bbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bc3:	48 89 c7             	mov    %rax,%rdi
  801bc6:	48 b8 00 02 80 00 00 	movabs $0x800200,%rax
  801bcd:	00 00 00 
  801bd0:	ff d0                	callq  *%rax
  801bd2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bd7:	7e 07                	jle    801be0 <remove+0x2d>
		return -E_BAD_PATH;
  801bd9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801bde:	eb 33                	jmp    801c13 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801be0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801be4:	48 89 c6             	mov    %rax,%rsi
  801be7:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801bee:	00 00 00 
  801bf1:	48 b8 6c 02 80 00 00 	movabs $0x80026c,%rax
  801bf8:	00 00 00 
  801bfb:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801bfd:	be 00 00 00 00       	mov    $0x0,%esi
  801c02:	bf 07 00 00 00       	mov    $0x7,%edi
  801c07:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  801c0e:	00 00 00 
  801c11:	ff d0                	callq  *%rax
}
  801c13:	c9                   	leaveq 
  801c14:	c3                   	retq   

0000000000801c15 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801c15:	55                   	push   %rbp
  801c16:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c19:	be 00 00 00 00       	mov    $0x0,%esi
  801c1e:	bf 08 00 00 00       	mov    $0x8,%edi
  801c23:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  801c2a:	00 00 00 
  801c2d:	ff d0                	callq  *%rax
}
  801c2f:	5d                   	pop    %rbp
  801c30:	c3                   	retq   

0000000000801c31 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801c31:	55                   	push   %rbp
  801c32:	48 89 e5             	mov    %rsp,%rbp
  801c35:	53                   	push   %rbx
  801c36:	48 83 ec 38          	sub    $0x38,%rsp
  801c3a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801c3e:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801c42:	48 89 c7             	mov    %rax,%rdi
  801c45:	48 b8 56 0e 80 00 00 	movabs $0x800e56,%rax
  801c4c:	00 00 00 
  801c4f:	ff d0                	callq  *%rax
  801c51:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801c54:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c58:	0f 88 bf 01 00 00    	js     801e1d <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c5e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c62:	ba 07 04 00 00       	mov    $0x407,%edx
  801c67:	48 89 c6             	mov    %rax,%rsi
  801c6a:	bf 00 00 00 00       	mov    $0x0,%edi
  801c6f:	48 b8 9b 0b 80 00 00 	movabs $0x800b9b,%rax
  801c76:	00 00 00 
  801c79:	ff d0                	callq  *%rax
  801c7b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801c7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c82:	0f 88 95 01 00 00    	js     801e1d <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801c88:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801c8c:	48 89 c7             	mov    %rax,%rdi
  801c8f:	48 b8 56 0e 80 00 00 	movabs $0x800e56,%rax
  801c96:	00 00 00 
  801c99:	ff d0                	callq  *%rax
  801c9b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801c9e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ca2:	0f 88 5d 01 00 00    	js     801e05 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ca8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801cac:	ba 07 04 00 00       	mov    $0x407,%edx
  801cb1:	48 89 c6             	mov    %rax,%rsi
  801cb4:	bf 00 00 00 00       	mov    $0x0,%edi
  801cb9:	48 b8 9b 0b 80 00 00 	movabs $0x800b9b,%rax
  801cc0:	00 00 00 
  801cc3:	ff d0                	callq  *%rax
  801cc5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801cc8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ccc:	0f 88 33 01 00 00    	js     801e05 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801cd2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd6:	48 89 c7             	mov    %rax,%rdi
  801cd9:	48 b8 2b 0e 80 00 00 	movabs $0x800e2b,%rax
  801ce0:	00 00 00 
  801ce3:	ff d0                	callq  *%rax
  801ce5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ce9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ced:	ba 07 04 00 00       	mov    $0x407,%edx
  801cf2:	48 89 c6             	mov    %rax,%rsi
  801cf5:	bf 00 00 00 00       	mov    $0x0,%edi
  801cfa:	48 b8 9b 0b 80 00 00 	movabs $0x800b9b,%rax
  801d01:	00 00 00 
  801d04:	ff d0                	callq  *%rax
  801d06:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d09:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d0d:	79 05                	jns    801d14 <pipe+0xe3>
		goto err2;
  801d0f:	e9 d9 00 00 00       	jmpq   801ded <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d14:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d18:	48 89 c7             	mov    %rax,%rdi
  801d1b:	48 b8 2b 0e 80 00 00 	movabs $0x800e2b,%rax
  801d22:	00 00 00 
  801d25:	ff d0                	callq  *%rax
  801d27:	48 89 c2             	mov    %rax,%rdx
  801d2a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d2e:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801d34:	48 89 d1             	mov    %rdx,%rcx
  801d37:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3c:	48 89 c6             	mov    %rax,%rsi
  801d3f:	bf 00 00 00 00       	mov    $0x0,%edi
  801d44:	48 b8 eb 0b 80 00 00 	movabs $0x800beb,%rax
  801d4b:	00 00 00 
  801d4e:	ff d0                	callq  *%rax
  801d50:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d53:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d57:	79 1b                	jns    801d74 <pipe+0x143>
		goto err3;
  801d59:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  801d5a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d5e:	48 89 c6             	mov    %rax,%rsi
  801d61:	bf 00 00 00 00       	mov    $0x0,%edi
  801d66:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  801d6d:	00 00 00 
  801d70:	ff d0                	callq  *%rax
  801d72:	eb 79                	jmp    801ded <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801d74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d78:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801d7f:	00 00 00 
  801d82:	8b 12                	mov    (%rdx),%edx
  801d84:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801d86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d8a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  801d91:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d95:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801d9c:	00 00 00 
  801d9f:	8b 12                	mov    (%rdx),%edx
  801da1:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801da3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801da7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801dae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801db2:	48 89 c7             	mov    %rax,%rdi
  801db5:	48 b8 08 0e 80 00 00 	movabs $0x800e08,%rax
  801dbc:	00 00 00 
  801dbf:	ff d0                	callq  *%rax
  801dc1:	89 c2                	mov    %eax,%edx
  801dc3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801dc7:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801dc9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801dcd:	48 8d 58 04          	lea    0x4(%rax),%rbx
  801dd1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dd5:	48 89 c7             	mov    %rax,%rdi
  801dd8:	48 b8 08 0e 80 00 00 	movabs $0x800e08,%rax
  801ddf:	00 00 00 
  801de2:	ff d0                	callq  *%rax
  801de4:	89 03                	mov    %eax,(%rbx)
	return 0;
  801de6:	b8 00 00 00 00       	mov    $0x0,%eax
  801deb:	eb 33                	jmp    801e20 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  801ded:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801df1:	48 89 c6             	mov    %rax,%rsi
  801df4:	bf 00 00 00 00       	mov    $0x0,%edi
  801df9:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  801e00:	00 00 00 
  801e03:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  801e05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e09:	48 89 c6             	mov    %rax,%rsi
  801e0c:	bf 00 00 00 00       	mov    $0x0,%edi
  801e11:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  801e18:	00 00 00 
  801e1b:	ff d0                	callq  *%rax
    err:
	return r;
  801e1d:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801e20:	48 83 c4 38          	add    $0x38,%rsp
  801e24:	5b                   	pop    %rbx
  801e25:	5d                   	pop    %rbp
  801e26:	c3                   	retq   

0000000000801e27 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801e27:	55                   	push   %rbp
  801e28:	48 89 e5             	mov    %rsp,%rbp
  801e2b:	53                   	push   %rbx
  801e2c:	48 83 ec 28          	sub    $0x28,%rsp
  801e30:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e34:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801e38:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801e3f:	00 00 00 
  801e42:	48 8b 00             	mov    (%rax),%rax
  801e45:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801e4b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  801e4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e52:	48 89 c7             	mov    %rax,%rdi
  801e55:	48 b8 19 34 80 00 00 	movabs $0x803419,%rax
  801e5c:	00 00 00 
  801e5f:	ff d0                	callq  *%rax
  801e61:	89 c3                	mov    %eax,%ebx
  801e63:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e67:	48 89 c7             	mov    %rax,%rdi
  801e6a:	48 b8 19 34 80 00 00 	movabs $0x803419,%rax
  801e71:	00 00 00 
  801e74:	ff d0                	callq  *%rax
  801e76:	39 c3                	cmp    %eax,%ebx
  801e78:	0f 94 c0             	sete   %al
  801e7b:	0f b6 c0             	movzbl %al,%eax
  801e7e:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  801e81:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801e88:	00 00 00 
  801e8b:	48 8b 00             	mov    (%rax),%rax
  801e8e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801e94:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  801e97:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e9a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801e9d:	75 05                	jne    801ea4 <_pipeisclosed+0x7d>
			return ret;
  801e9f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801ea2:	eb 4f                	jmp    801ef3 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  801ea4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ea7:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801eaa:	74 42                	je     801eee <_pipeisclosed+0xc7>
  801eac:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  801eb0:	75 3c                	jne    801eee <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801eb2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801eb9:	00 00 00 
  801ebc:	48 8b 00             	mov    (%rax),%rax
  801ebf:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  801ec5:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801ec8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ecb:	89 c6                	mov    %eax,%esi
  801ecd:	48 bf 9f 35 80 00 00 	movabs $0x80359f,%rdi
  801ed4:	00 00 00 
  801ed7:	b8 00 00 00 00       	mov    $0x0,%eax
  801edc:	49 b8 e6 26 80 00 00 	movabs $0x8026e6,%r8
  801ee3:	00 00 00 
  801ee6:	41 ff d0             	callq  *%r8
	}
  801ee9:	e9 4a ff ff ff       	jmpq   801e38 <_pipeisclosed+0x11>
  801eee:	e9 45 ff ff ff       	jmpq   801e38 <_pipeisclosed+0x11>
}
  801ef3:	48 83 c4 28          	add    $0x28,%rsp
  801ef7:	5b                   	pop    %rbx
  801ef8:	5d                   	pop    %rbp
  801ef9:	c3                   	retq   

0000000000801efa <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  801efa:	55                   	push   %rbp
  801efb:	48 89 e5             	mov    %rsp,%rbp
  801efe:	48 83 ec 30          	sub    $0x30,%rsp
  801f02:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f05:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f09:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801f0c:	48 89 d6             	mov    %rdx,%rsi
  801f0f:	89 c7                	mov    %eax,%edi
  801f11:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  801f18:	00 00 00 
  801f1b:	ff d0                	callq  *%rax
  801f1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f24:	79 05                	jns    801f2b <pipeisclosed+0x31>
		return r;
  801f26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f29:	eb 31                	jmp    801f5c <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  801f2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f2f:	48 89 c7             	mov    %rax,%rdi
  801f32:	48 b8 2b 0e 80 00 00 	movabs $0x800e2b,%rax
  801f39:	00 00 00 
  801f3c:	ff d0                	callq  *%rax
  801f3e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  801f42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f46:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f4a:	48 89 d6             	mov    %rdx,%rsi
  801f4d:	48 89 c7             	mov    %rax,%rdi
  801f50:	48 b8 27 1e 80 00 00 	movabs $0x801e27,%rax
  801f57:	00 00 00 
  801f5a:	ff d0                	callq  *%rax
}
  801f5c:	c9                   	leaveq 
  801f5d:	c3                   	retq   

0000000000801f5e <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f5e:	55                   	push   %rbp
  801f5f:	48 89 e5             	mov    %rsp,%rbp
  801f62:	48 83 ec 40          	sub    $0x40,%rsp
  801f66:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f6a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801f6e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801f72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f76:	48 89 c7             	mov    %rax,%rdi
  801f79:	48 b8 2b 0e 80 00 00 	movabs $0x800e2b,%rax
  801f80:	00 00 00 
  801f83:	ff d0                	callq  *%rax
  801f85:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801f89:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f8d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801f91:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801f98:	00 
  801f99:	e9 92 00 00 00       	jmpq   802030 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  801f9e:	eb 41                	jmp    801fe1 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801fa0:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  801fa5:	74 09                	je     801fb0 <devpipe_read+0x52>
				return i;
  801fa7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fab:	e9 92 00 00 00       	jmpq   802042 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801fb0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fb4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fb8:	48 89 d6             	mov    %rdx,%rsi
  801fbb:	48 89 c7             	mov    %rax,%rdi
  801fbe:	48 b8 27 1e 80 00 00 	movabs $0x801e27,%rax
  801fc5:	00 00 00 
  801fc8:	ff d0                	callq  *%rax
  801fca:	85 c0                	test   %eax,%eax
  801fcc:	74 07                	je     801fd5 <devpipe_read+0x77>
				return 0;
  801fce:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd3:	eb 6d                	jmp    802042 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801fd5:	48 b8 5d 0b 80 00 00 	movabs $0x800b5d,%rax
  801fdc:	00 00 00 
  801fdf:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801fe1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fe5:	8b 10                	mov    (%rax),%edx
  801fe7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801feb:	8b 40 04             	mov    0x4(%rax),%eax
  801fee:	39 c2                	cmp    %eax,%edx
  801ff0:	74 ae                	je     801fa0 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ff2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ff6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801ffa:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  801ffe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802002:	8b 00                	mov    (%rax),%eax
  802004:	99                   	cltd   
  802005:	c1 ea 1b             	shr    $0x1b,%edx
  802008:	01 d0                	add    %edx,%eax
  80200a:	83 e0 1f             	and    $0x1f,%eax
  80200d:	29 d0                	sub    %edx,%eax
  80200f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802013:	48 98                	cltq   
  802015:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80201a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80201c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802020:	8b 00                	mov    (%rax),%eax
  802022:	8d 50 01             	lea    0x1(%rax),%edx
  802025:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802029:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80202b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802030:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802034:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802038:	0f 82 60 ff ff ff    	jb     801f9e <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80203e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802042:	c9                   	leaveq 
  802043:	c3                   	retq   

0000000000802044 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802044:	55                   	push   %rbp
  802045:	48 89 e5             	mov    %rsp,%rbp
  802048:	48 83 ec 40          	sub    $0x40,%rsp
  80204c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802050:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802054:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802058:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80205c:	48 89 c7             	mov    %rax,%rdi
  80205f:	48 b8 2b 0e 80 00 00 	movabs $0x800e2b,%rax
  802066:	00 00 00 
  802069:	ff d0                	callq  *%rax
  80206b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80206f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802073:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802077:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80207e:	00 
  80207f:	e9 8e 00 00 00       	jmpq   802112 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802084:	eb 31                	jmp    8020b7 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802086:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80208a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80208e:	48 89 d6             	mov    %rdx,%rsi
  802091:	48 89 c7             	mov    %rax,%rdi
  802094:	48 b8 27 1e 80 00 00 	movabs $0x801e27,%rax
  80209b:	00 00 00 
  80209e:	ff d0                	callq  *%rax
  8020a0:	85 c0                	test   %eax,%eax
  8020a2:	74 07                	je     8020ab <devpipe_write+0x67>
				return 0;
  8020a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a9:	eb 79                	jmp    802124 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8020ab:	48 b8 5d 0b 80 00 00 	movabs $0x800b5d,%rax
  8020b2:	00 00 00 
  8020b5:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8020b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020bb:	8b 40 04             	mov    0x4(%rax),%eax
  8020be:	48 63 d0             	movslq %eax,%rdx
  8020c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020c5:	8b 00                	mov    (%rax),%eax
  8020c7:	48 98                	cltq   
  8020c9:	48 83 c0 20          	add    $0x20,%rax
  8020cd:	48 39 c2             	cmp    %rax,%rdx
  8020d0:	73 b4                	jae    802086 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8020d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020d6:	8b 40 04             	mov    0x4(%rax),%eax
  8020d9:	99                   	cltd   
  8020da:	c1 ea 1b             	shr    $0x1b,%edx
  8020dd:	01 d0                	add    %edx,%eax
  8020df:	83 e0 1f             	and    $0x1f,%eax
  8020e2:	29 d0                	sub    %edx,%eax
  8020e4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8020e8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8020ec:	48 01 ca             	add    %rcx,%rdx
  8020ef:	0f b6 0a             	movzbl (%rdx),%ecx
  8020f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020f6:	48 98                	cltq   
  8020f8:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8020fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802100:	8b 40 04             	mov    0x4(%rax),%eax
  802103:	8d 50 01             	lea    0x1(%rax),%edx
  802106:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80210a:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80210d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802112:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802116:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80211a:	0f 82 64 ff ff ff    	jb     802084 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802120:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802124:	c9                   	leaveq 
  802125:	c3                   	retq   

0000000000802126 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802126:	55                   	push   %rbp
  802127:	48 89 e5             	mov    %rsp,%rbp
  80212a:	48 83 ec 20          	sub    $0x20,%rsp
  80212e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802132:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802136:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80213a:	48 89 c7             	mov    %rax,%rdi
  80213d:	48 b8 2b 0e 80 00 00 	movabs $0x800e2b,%rax
  802144:	00 00 00 
  802147:	ff d0                	callq  *%rax
  802149:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80214d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802151:	48 be b2 35 80 00 00 	movabs $0x8035b2,%rsi
  802158:	00 00 00 
  80215b:	48 89 c7             	mov    %rax,%rdi
  80215e:	48 b8 6c 02 80 00 00 	movabs $0x80026c,%rax
  802165:	00 00 00 
  802168:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80216a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80216e:	8b 50 04             	mov    0x4(%rax),%edx
  802171:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802175:	8b 00                	mov    (%rax),%eax
  802177:	29 c2                	sub    %eax,%edx
  802179:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80217d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802183:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802187:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80218e:	00 00 00 
	stat->st_dev = &devpipe;
  802191:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802195:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  80219c:	00 00 00 
  80219f:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8021a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ab:	c9                   	leaveq 
  8021ac:	c3                   	retq   

00000000008021ad <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021ad:	55                   	push   %rbp
  8021ae:	48 89 e5             	mov    %rsp,%rbp
  8021b1:	48 83 ec 10          	sub    $0x10,%rsp
  8021b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8021b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021bd:	48 89 c6             	mov    %rax,%rsi
  8021c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8021c5:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  8021cc:	00 00 00 
  8021cf:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8021d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021d5:	48 89 c7             	mov    %rax,%rdi
  8021d8:	48 b8 2b 0e 80 00 00 	movabs $0x800e2b,%rax
  8021df:	00 00 00 
  8021e2:	ff d0                	callq  *%rax
  8021e4:	48 89 c6             	mov    %rax,%rsi
  8021e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ec:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  8021f3:	00 00 00 
  8021f6:	ff d0                	callq  *%rax
}
  8021f8:	c9                   	leaveq 
  8021f9:	c3                   	retq   

00000000008021fa <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8021fa:	55                   	push   %rbp
  8021fb:	48 89 e5             	mov    %rsp,%rbp
  8021fe:	48 83 ec 20          	sub    $0x20,%rsp
  802202:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802205:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802208:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80220b:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80220f:	be 01 00 00 00       	mov    $0x1,%esi
  802214:	48 89 c7             	mov    %rax,%rdi
  802217:	48 b8 53 0a 80 00 00 	movabs $0x800a53,%rax
  80221e:	00 00 00 
  802221:	ff d0                	callq  *%rax
}
  802223:	c9                   	leaveq 
  802224:	c3                   	retq   

0000000000802225 <getchar>:

int
getchar(void)
{
  802225:	55                   	push   %rbp
  802226:	48 89 e5             	mov    %rsp,%rbp
  802229:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80222d:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802231:	ba 01 00 00 00       	mov    $0x1,%edx
  802236:	48 89 c6             	mov    %rax,%rsi
  802239:	bf 00 00 00 00       	mov    $0x0,%edi
  80223e:	48 b8 20 13 80 00 00 	movabs $0x801320,%rax
  802245:	00 00 00 
  802248:	ff d0                	callq  *%rax
  80224a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80224d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802251:	79 05                	jns    802258 <getchar+0x33>
		return r;
  802253:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802256:	eb 14                	jmp    80226c <getchar+0x47>
	if (r < 1)
  802258:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80225c:	7f 07                	jg     802265 <getchar+0x40>
		return -E_EOF;
  80225e:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802263:	eb 07                	jmp    80226c <getchar+0x47>
	return c;
  802265:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  802269:	0f b6 c0             	movzbl %al,%eax
}
  80226c:	c9                   	leaveq 
  80226d:	c3                   	retq   

000000000080226e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80226e:	55                   	push   %rbp
  80226f:	48 89 e5             	mov    %rsp,%rbp
  802272:	48 83 ec 20          	sub    $0x20,%rsp
  802276:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802279:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80227d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802280:	48 89 d6             	mov    %rdx,%rsi
  802283:	89 c7                	mov    %eax,%edi
  802285:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  80228c:	00 00 00 
  80228f:	ff d0                	callq  *%rax
  802291:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802294:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802298:	79 05                	jns    80229f <iscons+0x31>
		return r;
  80229a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80229d:	eb 1a                	jmp    8022b9 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80229f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022a3:	8b 10                	mov    (%rax),%edx
  8022a5:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8022ac:	00 00 00 
  8022af:	8b 00                	mov    (%rax),%eax
  8022b1:	39 c2                	cmp    %eax,%edx
  8022b3:	0f 94 c0             	sete   %al
  8022b6:	0f b6 c0             	movzbl %al,%eax
}
  8022b9:	c9                   	leaveq 
  8022ba:	c3                   	retq   

00000000008022bb <opencons>:

int
opencons(void)
{
  8022bb:	55                   	push   %rbp
  8022bc:	48 89 e5             	mov    %rsp,%rbp
  8022bf:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8022c3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8022c7:	48 89 c7             	mov    %rax,%rdi
  8022ca:	48 b8 56 0e 80 00 00 	movabs $0x800e56,%rax
  8022d1:	00 00 00 
  8022d4:	ff d0                	callq  *%rax
  8022d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022dd:	79 05                	jns    8022e4 <opencons+0x29>
		return r;
  8022df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022e2:	eb 5b                	jmp    80233f <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e8:	ba 07 04 00 00       	mov    $0x407,%edx
  8022ed:	48 89 c6             	mov    %rax,%rsi
  8022f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8022f5:	48 b8 9b 0b 80 00 00 	movabs $0x800b9b,%rax
  8022fc:	00 00 00 
  8022ff:	ff d0                	callq  *%rax
  802301:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802304:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802308:	79 05                	jns    80230f <opencons+0x54>
		return r;
  80230a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80230d:	eb 30                	jmp    80233f <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80230f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802313:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  80231a:	00 00 00 
  80231d:	8b 12                	mov    (%rdx),%edx
  80231f:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  802321:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802325:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80232c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802330:	48 89 c7             	mov    %rax,%rdi
  802333:	48 b8 08 0e 80 00 00 	movabs $0x800e08,%rax
  80233a:	00 00 00 
  80233d:	ff d0                	callq  *%rax
}
  80233f:	c9                   	leaveq 
  802340:	c3                   	retq   

0000000000802341 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802341:	55                   	push   %rbp
  802342:	48 89 e5             	mov    %rsp,%rbp
  802345:	48 83 ec 30          	sub    $0x30,%rsp
  802349:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80234d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802351:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  802355:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80235a:	75 07                	jne    802363 <devcons_read+0x22>
		return 0;
  80235c:	b8 00 00 00 00       	mov    $0x0,%eax
  802361:	eb 4b                	jmp    8023ae <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  802363:	eb 0c                	jmp    802371 <devcons_read+0x30>
		sys_yield();
  802365:	48 b8 5d 0b 80 00 00 	movabs $0x800b5d,%rax
  80236c:	00 00 00 
  80236f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802371:	48 b8 9d 0a 80 00 00 	movabs $0x800a9d,%rax
  802378:	00 00 00 
  80237b:	ff d0                	callq  *%rax
  80237d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802380:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802384:	74 df                	je     802365 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  802386:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80238a:	79 05                	jns    802391 <devcons_read+0x50>
		return c;
  80238c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80238f:	eb 1d                	jmp    8023ae <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  802391:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  802395:	75 07                	jne    80239e <devcons_read+0x5d>
		return 0;
  802397:	b8 00 00 00 00       	mov    $0x0,%eax
  80239c:	eb 10                	jmp    8023ae <devcons_read+0x6d>
	*(char*)vbuf = c;
  80239e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a1:	89 c2                	mov    %eax,%edx
  8023a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023a7:	88 10                	mov    %dl,(%rax)
	return 1;
  8023a9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8023ae:	c9                   	leaveq 
  8023af:	c3                   	retq   

00000000008023b0 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8023b0:	55                   	push   %rbp
  8023b1:	48 89 e5             	mov    %rsp,%rbp
  8023b4:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8023bb:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8023c2:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8023c9:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8023d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023d7:	eb 76                	jmp    80244f <devcons_write+0x9f>
		m = n - tot;
  8023d9:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8023e0:	89 c2                	mov    %eax,%edx
  8023e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023e5:	29 c2                	sub    %eax,%edx
  8023e7:	89 d0                	mov    %edx,%eax
  8023e9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8023ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023ef:	83 f8 7f             	cmp    $0x7f,%eax
  8023f2:	76 07                	jbe    8023fb <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8023f4:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8023fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023fe:	48 63 d0             	movslq %eax,%rdx
  802401:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802404:	48 63 c8             	movslq %eax,%rcx
  802407:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80240e:	48 01 c1             	add    %rax,%rcx
  802411:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802418:	48 89 ce             	mov    %rcx,%rsi
  80241b:	48 89 c7             	mov    %rax,%rdi
  80241e:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  802425:	00 00 00 
  802428:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80242a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80242d:	48 63 d0             	movslq %eax,%rdx
  802430:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802437:	48 89 d6             	mov    %rdx,%rsi
  80243a:	48 89 c7             	mov    %rax,%rdi
  80243d:	48 b8 53 0a 80 00 00 	movabs $0x800a53,%rax
  802444:	00 00 00 
  802447:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802449:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80244c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80244f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802452:	48 98                	cltq   
  802454:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80245b:	0f 82 78 ff ff ff    	jb     8023d9 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  802461:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802464:	c9                   	leaveq 
  802465:	c3                   	retq   

0000000000802466 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  802466:	55                   	push   %rbp
  802467:	48 89 e5             	mov    %rsp,%rbp
  80246a:	48 83 ec 08          	sub    $0x8,%rsp
  80246e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  802472:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802477:	c9                   	leaveq 
  802478:	c3                   	retq   

0000000000802479 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802479:	55                   	push   %rbp
  80247a:	48 89 e5             	mov    %rsp,%rbp
  80247d:	48 83 ec 10          	sub    $0x10,%rsp
  802481:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802485:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  802489:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80248d:	48 be be 35 80 00 00 	movabs $0x8035be,%rsi
  802494:	00 00 00 
  802497:	48 89 c7             	mov    %rax,%rdi
  80249a:	48 b8 6c 02 80 00 00 	movabs $0x80026c,%rax
  8024a1:	00 00 00 
  8024a4:	ff d0                	callq  *%rax
	return 0;
  8024a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ab:	c9                   	leaveq 
  8024ac:	c3                   	retq   

00000000008024ad <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8024ad:	55                   	push   %rbp
  8024ae:	48 89 e5             	mov    %rsp,%rbp
  8024b1:	53                   	push   %rbx
  8024b2:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8024b9:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8024c0:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8024c6:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8024cd:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8024d4:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8024db:	84 c0                	test   %al,%al
  8024dd:	74 23                	je     802502 <_panic+0x55>
  8024df:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8024e6:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8024ea:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8024ee:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8024f2:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8024f6:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8024fa:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8024fe:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802502:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802509:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  802510:	00 00 00 
  802513:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80251a:	00 00 00 
  80251d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802521:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  802528:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80252f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802536:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80253d:	00 00 00 
  802540:	48 8b 18             	mov    (%rax),%rbx
  802543:	48 b8 1f 0b 80 00 00 	movabs $0x800b1f,%rax
  80254a:	00 00 00 
  80254d:	ff d0                	callq  *%rax
  80254f:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  802555:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80255c:	41 89 c8             	mov    %ecx,%r8d
  80255f:	48 89 d1             	mov    %rdx,%rcx
  802562:	48 89 da             	mov    %rbx,%rdx
  802565:	89 c6                	mov    %eax,%esi
  802567:	48 bf c8 35 80 00 00 	movabs $0x8035c8,%rdi
  80256e:	00 00 00 
  802571:	b8 00 00 00 00       	mov    $0x0,%eax
  802576:	49 b9 e6 26 80 00 00 	movabs $0x8026e6,%r9
  80257d:	00 00 00 
  802580:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802583:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80258a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802591:	48 89 d6             	mov    %rdx,%rsi
  802594:	48 89 c7             	mov    %rax,%rdi
  802597:	48 b8 3a 26 80 00 00 	movabs $0x80263a,%rax
  80259e:	00 00 00 
  8025a1:	ff d0                	callq  *%rax
	cprintf("\n");
  8025a3:	48 bf eb 35 80 00 00 	movabs $0x8035eb,%rdi
  8025aa:	00 00 00 
  8025ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b2:	48 ba e6 26 80 00 00 	movabs $0x8026e6,%rdx
  8025b9:	00 00 00 
  8025bc:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8025be:	cc                   	int3   
  8025bf:	eb fd                	jmp    8025be <_panic+0x111>

00000000008025c1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8025c1:	55                   	push   %rbp
  8025c2:	48 89 e5             	mov    %rsp,%rbp
  8025c5:	48 83 ec 10          	sub    $0x10,%rsp
  8025c9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8025d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d4:	8b 00                	mov    (%rax),%eax
  8025d6:	8d 48 01             	lea    0x1(%rax),%ecx
  8025d9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025dd:	89 0a                	mov    %ecx,(%rdx)
  8025df:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025e2:	89 d1                	mov    %edx,%ecx
  8025e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025e8:	48 98                	cltq   
  8025ea:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  8025ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f2:	8b 00                	mov    (%rax),%eax
  8025f4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8025f9:	75 2c                	jne    802627 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  8025fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ff:	8b 00                	mov    (%rax),%eax
  802601:	48 98                	cltq   
  802603:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802607:	48 83 c2 08          	add    $0x8,%rdx
  80260b:	48 89 c6             	mov    %rax,%rsi
  80260e:	48 89 d7             	mov    %rdx,%rdi
  802611:	48 b8 53 0a 80 00 00 	movabs $0x800a53,%rax
  802618:	00 00 00 
  80261b:	ff d0                	callq  *%rax
		b->idx = 0;
  80261d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802621:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  802627:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80262b:	8b 40 04             	mov    0x4(%rax),%eax
  80262e:	8d 50 01             	lea    0x1(%rax),%edx
  802631:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802635:	89 50 04             	mov    %edx,0x4(%rax)
}
  802638:	c9                   	leaveq 
  802639:	c3                   	retq   

000000000080263a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80263a:	55                   	push   %rbp
  80263b:	48 89 e5             	mov    %rsp,%rbp
  80263e:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  802645:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80264c:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  802653:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80265a:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  802661:	48 8b 0a             	mov    (%rdx),%rcx
  802664:	48 89 08             	mov    %rcx,(%rax)
  802667:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80266b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80266f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802673:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  802677:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80267e:	00 00 00 
	b.cnt = 0;
  802681:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802688:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  80268b:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  802692:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  802699:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8026a0:	48 89 c6             	mov    %rax,%rsi
  8026a3:	48 bf c1 25 80 00 00 	movabs $0x8025c1,%rdi
  8026aa:	00 00 00 
  8026ad:	48 b8 99 2a 80 00 00 	movabs $0x802a99,%rax
  8026b4:	00 00 00 
  8026b7:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8026b9:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8026bf:	48 98                	cltq   
  8026c1:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8026c8:	48 83 c2 08          	add    $0x8,%rdx
  8026cc:	48 89 c6             	mov    %rax,%rsi
  8026cf:	48 89 d7             	mov    %rdx,%rdi
  8026d2:	48 b8 53 0a 80 00 00 	movabs $0x800a53,%rax
  8026d9:	00 00 00 
  8026dc:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8026de:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8026e4:	c9                   	leaveq 
  8026e5:	c3                   	retq   

00000000008026e6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8026e6:	55                   	push   %rbp
  8026e7:	48 89 e5             	mov    %rsp,%rbp
  8026ea:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8026f1:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8026f8:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8026ff:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802706:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80270d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802714:	84 c0                	test   %al,%al
  802716:	74 20                	je     802738 <cprintf+0x52>
  802718:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80271c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802720:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802724:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802728:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80272c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802730:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802734:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802738:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80273f:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802746:	00 00 00 
  802749:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802750:	00 00 00 
  802753:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802757:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80275e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802765:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80276c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802773:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80277a:	48 8b 0a             	mov    (%rdx),%rcx
  80277d:	48 89 08             	mov    %rcx,(%rax)
  802780:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802784:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802788:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80278c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  802790:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  802797:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80279e:	48 89 d6             	mov    %rdx,%rsi
  8027a1:	48 89 c7             	mov    %rax,%rdi
  8027a4:	48 b8 3a 26 80 00 00 	movabs $0x80263a,%rax
  8027ab:	00 00 00 
  8027ae:	ff d0                	callq  *%rax
  8027b0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8027b6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8027bc:	c9                   	leaveq 
  8027bd:	c3                   	retq   

00000000008027be <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8027be:	55                   	push   %rbp
  8027bf:	48 89 e5             	mov    %rsp,%rbp
  8027c2:	53                   	push   %rbx
  8027c3:	48 83 ec 38          	sub    $0x38,%rsp
  8027c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027cb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027cf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8027d3:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8027d6:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8027da:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8027de:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8027e1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8027e5:	77 3b                	ja     802822 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8027e7:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8027ea:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8027ee:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8027f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8027fa:	48 f7 f3             	div    %rbx
  8027fd:	48 89 c2             	mov    %rax,%rdx
  802800:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802803:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802806:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80280a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80280e:	41 89 f9             	mov    %edi,%r9d
  802811:	48 89 c7             	mov    %rax,%rdi
  802814:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  80281b:	00 00 00 
  80281e:	ff d0                	callq  *%rax
  802820:	eb 1e                	jmp    802840 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802822:	eb 12                	jmp    802836 <printnum+0x78>
			putch(padc, putdat);
  802824:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802828:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80282b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80282f:	48 89 ce             	mov    %rcx,%rsi
  802832:	89 d7                	mov    %edx,%edi
  802834:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802836:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80283a:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80283e:	7f e4                	jg     802824 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  802840:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802843:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802847:	ba 00 00 00 00       	mov    $0x0,%edx
  80284c:	48 f7 f1             	div    %rcx
  80284f:	48 89 d0             	mov    %rdx,%rax
  802852:	48 ba c8 37 80 00 00 	movabs $0x8037c8,%rdx
  802859:	00 00 00 
  80285c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  802860:	0f be d0             	movsbl %al,%edx
  802863:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802867:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80286b:	48 89 ce             	mov    %rcx,%rsi
  80286e:	89 d7                	mov    %edx,%edi
  802870:	ff d0                	callq  *%rax
}
  802872:	48 83 c4 38          	add    $0x38,%rsp
  802876:	5b                   	pop    %rbx
  802877:	5d                   	pop    %rbp
  802878:	c3                   	retq   

0000000000802879 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  802879:	55                   	push   %rbp
  80287a:	48 89 e5             	mov    %rsp,%rbp
  80287d:	48 83 ec 1c          	sub    $0x1c,%rsp
  802881:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802885:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  802888:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80288c:	7e 52                	jle    8028e0 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80288e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802892:	8b 00                	mov    (%rax),%eax
  802894:	83 f8 30             	cmp    $0x30,%eax
  802897:	73 24                	jae    8028bd <getuint+0x44>
  802899:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80289d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8028a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a5:	8b 00                	mov    (%rax),%eax
  8028a7:	89 c0                	mov    %eax,%eax
  8028a9:	48 01 d0             	add    %rdx,%rax
  8028ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028b0:	8b 12                	mov    (%rdx),%edx
  8028b2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8028b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028b9:	89 0a                	mov    %ecx,(%rdx)
  8028bb:	eb 17                	jmp    8028d4 <getuint+0x5b>
  8028bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8028c5:	48 89 d0             	mov    %rdx,%rax
  8028c8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8028cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028d0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8028d4:	48 8b 00             	mov    (%rax),%rax
  8028d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8028db:	e9 a3 00 00 00       	jmpq   802983 <getuint+0x10a>
	else if (lflag)
  8028e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8028e4:	74 4f                	je     802935 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8028e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ea:	8b 00                	mov    (%rax),%eax
  8028ec:	83 f8 30             	cmp    $0x30,%eax
  8028ef:	73 24                	jae    802915 <getuint+0x9c>
  8028f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028f5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8028f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028fd:	8b 00                	mov    (%rax),%eax
  8028ff:	89 c0                	mov    %eax,%eax
  802901:	48 01 d0             	add    %rdx,%rax
  802904:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802908:	8b 12                	mov    (%rdx),%edx
  80290a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80290d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802911:	89 0a                	mov    %ecx,(%rdx)
  802913:	eb 17                	jmp    80292c <getuint+0xb3>
  802915:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802919:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80291d:	48 89 d0             	mov    %rdx,%rax
  802920:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802924:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802928:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80292c:	48 8b 00             	mov    (%rax),%rax
  80292f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802933:	eb 4e                	jmp    802983 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  802935:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802939:	8b 00                	mov    (%rax),%eax
  80293b:	83 f8 30             	cmp    $0x30,%eax
  80293e:	73 24                	jae    802964 <getuint+0xeb>
  802940:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802944:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802948:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80294c:	8b 00                	mov    (%rax),%eax
  80294e:	89 c0                	mov    %eax,%eax
  802950:	48 01 d0             	add    %rdx,%rax
  802953:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802957:	8b 12                	mov    (%rdx),%edx
  802959:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80295c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802960:	89 0a                	mov    %ecx,(%rdx)
  802962:	eb 17                	jmp    80297b <getuint+0x102>
  802964:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802968:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80296c:	48 89 d0             	mov    %rdx,%rax
  80296f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802973:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802977:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80297b:	8b 00                	mov    (%rax),%eax
  80297d:	89 c0                	mov    %eax,%eax
  80297f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802983:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802987:	c9                   	leaveq 
  802988:	c3                   	retq   

0000000000802989 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802989:	55                   	push   %rbp
  80298a:	48 89 e5             	mov    %rsp,%rbp
  80298d:	48 83 ec 1c          	sub    $0x1c,%rsp
  802991:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802995:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802998:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80299c:	7e 52                	jle    8029f0 <getint+0x67>
		x=va_arg(*ap, long long);
  80299e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029a2:	8b 00                	mov    (%rax),%eax
  8029a4:	83 f8 30             	cmp    $0x30,%eax
  8029a7:	73 24                	jae    8029cd <getint+0x44>
  8029a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ad:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8029b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029b5:	8b 00                	mov    (%rax),%eax
  8029b7:	89 c0                	mov    %eax,%eax
  8029b9:	48 01 d0             	add    %rdx,%rax
  8029bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029c0:	8b 12                	mov    (%rdx),%edx
  8029c2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8029c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029c9:	89 0a                	mov    %ecx,(%rdx)
  8029cb:	eb 17                	jmp    8029e4 <getint+0x5b>
  8029cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8029d5:	48 89 d0             	mov    %rdx,%rax
  8029d8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8029dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029e0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8029e4:	48 8b 00             	mov    (%rax),%rax
  8029e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8029eb:	e9 a3 00 00 00       	jmpq   802a93 <getint+0x10a>
	else if (lflag)
  8029f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8029f4:	74 4f                	je     802a45 <getint+0xbc>
		x=va_arg(*ap, long);
  8029f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029fa:	8b 00                	mov    (%rax),%eax
  8029fc:	83 f8 30             	cmp    $0x30,%eax
  8029ff:	73 24                	jae    802a25 <getint+0x9c>
  802a01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a05:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802a09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a0d:	8b 00                	mov    (%rax),%eax
  802a0f:	89 c0                	mov    %eax,%eax
  802a11:	48 01 d0             	add    %rdx,%rax
  802a14:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a18:	8b 12                	mov    (%rdx),%edx
  802a1a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802a1d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a21:	89 0a                	mov    %ecx,(%rdx)
  802a23:	eb 17                	jmp    802a3c <getint+0xb3>
  802a25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a29:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802a2d:	48 89 d0             	mov    %rdx,%rax
  802a30:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802a34:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a38:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802a3c:	48 8b 00             	mov    (%rax),%rax
  802a3f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802a43:	eb 4e                	jmp    802a93 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  802a45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a49:	8b 00                	mov    (%rax),%eax
  802a4b:	83 f8 30             	cmp    $0x30,%eax
  802a4e:	73 24                	jae    802a74 <getint+0xeb>
  802a50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a54:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802a58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a5c:	8b 00                	mov    (%rax),%eax
  802a5e:	89 c0                	mov    %eax,%eax
  802a60:	48 01 d0             	add    %rdx,%rax
  802a63:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a67:	8b 12                	mov    (%rdx),%edx
  802a69:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802a6c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a70:	89 0a                	mov    %ecx,(%rdx)
  802a72:	eb 17                	jmp    802a8b <getint+0x102>
  802a74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a78:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802a7c:	48 89 d0             	mov    %rdx,%rax
  802a7f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802a83:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a87:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802a8b:	8b 00                	mov    (%rax),%eax
  802a8d:	48 98                	cltq   
  802a8f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802a93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802a97:	c9                   	leaveq 
  802a98:	c3                   	retq   

0000000000802a99 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802a99:	55                   	push   %rbp
  802a9a:	48 89 e5             	mov    %rsp,%rbp
  802a9d:	41 54                	push   %r12
  802a9f:	53                   	push   %rbx
  802aa0:	48 83 ec 60          	sub    $0x60,%rsp
  802aa4:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802aa8:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802aac:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802ab0:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802ab4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802ab8:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802abc:	48 8b 0a             	mov    (%rdx),%rcx
  802abf:	48 89 08             	mov    %rcx,(%rax)
  802ac2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802ac6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802aca:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802ace:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802ad2:	eb 17                	jmp    802aeb <vprintfmt+0x52>
			if (ch == '\0')
  802ad4:	85 db                	test   %ebx,%ebx
  802ad6:	0f 84 cc 04 00 00    	je     802fa8 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  802adc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802ae0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802ae4:	48 89 d6             	mov    %rdx,%rsi
  802ae7:	89 df                	mov    %ebx,%edi
  802ae9:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802aeb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802aef:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802af3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802af7:	0f b6 00             	movzbl (%rax),%eax
  802afa:	0f b6 d8             	movzbl %al,%ebx
  802afd:	83 fb 25             	cmp    $0x25,%ebx
  802b00:	75 d2                	jne    802ad4 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802b02:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802b06:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802b0d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802b14:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802b1b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802b22:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802b26:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802b2a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802b2e:	0f b6 00             	movzbl (%rax),%eax
  802b31:	0f b6 d8             	movzbl %al,%ebx
  802b34:	8d 43 dd             	lea    -0x23(%rbx),%eax
  802b37:	83 f8 55             	cmp    $0x55,%eax
  802b3a:	0f 87 34 04 00 00    	ja     802f74 <vprintfmt+0x4db>
  802b40:	89 c0                	mov    %eax,%eax
  802b42:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802b49:	00 
  802b4a:	48 b8 f0 37 80 00 00 	movabs $0x8037f0,%rax
  802b51:	00 00 00 
  802b54:	48 01 d0             	add    %rdx,%rax
  802b57:	48 8b 00             	mov    (%rax),%rax
  802b5a:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  802b5c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802b60:	eb c0                	jmp    802b22 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802b62:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802b66:	eb ba                	jmp    802b22 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802b68:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802b6f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802b72:	89 d0                	mov    %edx,%eax
  802b74:	c1 e0 02             	shl    $0x2,%eax
  802b77:	01 d0                	add    %edx,%eax
  802b79:	01 c0                	add    %eax,%eax
  802b7b:	01 d8                	add    %ebx,%eax
  802b7d:	83 e8 30             	sub    $0x30,%eax
  802b80:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802b83:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802b87:	0f b6 00             	movzbl (%rax),%eax
  802b8a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802b8d:	83 fb 2f             	cmp    $0x2f,%ebx
  802b90:	7e 0c                	jle    802b9e <vprintfmt+0x105>
  802b92:	83 fb 39             	cmp    $0x39,%ebx
  802b95:	7f 07                	jg     802b9e <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802b97:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802b9c:	eb d1                	jmp    802b6f <vprintfmt+0xd6>
			goto process_precision;
  802b9e:	eb 58                	jmp    802bf8 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802ba0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802ba3:	83 f8 30             	cmp    $0x30,%eax
  802ba6:	73 17                	jae    802bbf <vprintfmt+0x126>
  802ba8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bac:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802baf:	89 c0                	mov    %eax,%eax
  802bb1:	48 01 d0             	add    %rdx,%rax
  802bb4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802bb7:	83 c2 08             	add    $0x8,%edx
  802bba:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802bbd:	eb 0f                	jmp    802bce <vprintfmt+0x135>
  802bbf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802bc3:	48 89 d0             	mov    %rdx,%rax
  802bc6:	48 83 c2 08          	add    $0x8,%rdx
  802bca:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802bce:	8b 00                	mov    (%rax),%eax
  802bd0:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802bd3:	eb 23                	jmp    802bf8 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  802bd5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802bd9:	79 0c                	jns    802be7 <vprintfmt+0x14e>
				width = 0;
  802bdb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802be2:	e9 3b ff ff ff       	jmpq   802b22 <vprintfmt+0x89>
  802be7:	e9 36 ff ff ff       	jmpq   802b22 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802bec:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802bf3:	e9 2a ff ff ff       	jmpq   802b22 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  802bf8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802bfc:	79 12                	jns    802c10 <vprintfmt+0x177>
				width = precision, precision = -1;
  802bfe:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802c01:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802c04:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802c0b:	e9 12 ff ff ff       	jmpq   802b22 <vprintfmt+0x89>
  802c10:	e9 0d ff ff ff       	jmpq   802b22 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  802c15:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802c19:	e9 04 ff ff ff       	jmpq   802b22 <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802c1e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802c21:	83 f8 30             	cmp    $0x30,%eax
  802c24:	73 17                	jae    802c3d <vprintfmt+0x1a4>
  802c26:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c2a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802c2d:	89 c0                	mov    %eax,%eax
  802c2f:	48 01 d0             	add    %rdx,%rax
  802c32:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802c35:	83 c2 08             	add    $0x8,%edx
  802c38:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802c3b:	eb 0f                	jmp    802c4c <vprintfmt+0x1b3>
  802c3d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802c41:	48 89 d0             	mov    %rdx,%rax
  802c44:	48 83 c2 08          	add    $0x8,%rdx
  802c48:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802c4c:	8b 10                	mov    (%rax),%edx
  802c4e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802c52:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802c56:	48 89 ce             	mov    %rcx,%rsi
  802c59:	89 d7                	mov    %edx,%edi
  802c5b:	ff d0                	callq  *%rax
			break;
  802c5d:	e9 40 03 00 00       	jmpq   802fa2 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  802c62:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802c65:	83 f8 30             	cmp    $0x30,%eax
  802c68:	73 17                	jae    802c81 <vprintfmt+0x1e8>
  802c6a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c6e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802c71:	89 c0                	mov    %eax,%eax
  802c73:	48 01 d0             	add    %rdx,%rax
  802c76:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802c79:	83 c2 08             	add    $0x8,%edx
  802c7c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802c7f:	eb 0f                	jmp    802c90 <vprintfmt+0x1f7>
  802c81:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802c85:	48 89 d0             	mov    %rdx,%rax
  802c88:	48 83 c2 08          	add    $0x8,%rdx
  802c8c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802c90:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802c92:	85 db                	test   %ebx,%ebx
  802c94:	79 02                	jns    802c98 <vprintfmt+0x1ff>
				err = -err;
  802c96:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802c98:	83 fb 10             	cmp    $0x10,%ebx
  802c9b:	7f 16                	jg     802cb3 <vprintfmt+0x21a>
  802c9d:	48 b8 40 37 80 00 00 	movabs $0x803740,%rax
  802ca4:	00 00 00 
  802ca7:	48 63 d3             	movslq %ebx,%rdx
  802caa:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802cae:	4d 85 e4             	test   %r12,%r12
  802cb1:	75 2e                	jne    802ce1 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802cb3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802cb7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802cbb:	89 d9                	mov    %ebx,%ecx
  802cbd:	48 ba d9 37 80 00 00 	movabs $0x8037d9,%rdx
  802cc4:	00 00 00 
  802cc7:	48 89 c7             	mov    %rax,%rdi
  802cca:	b8 00 00 00 00       	mov    $0x0,%eax
  802ccf:	49 b8 b1 2f 80 00 00 	movabs $0x802fb1,%r8
  802cd6:	00 00 00 
  802cd9:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802cdc:	e9 c1 02 00 00       	jmpq   802fa2 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802ce1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802ce5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802ce9:	4c 89 e1             	mov    %r12,%rcx
  802cec:	48 ba e2 37 80 00 00 	movabs $0x8037e2,%rdx
  802cf3:	00 00 00 
  802cf6:	48 89 c7             	mov    %rax,%rdi
  802cf9:	b8 00 00 00 00       	mov    $0x0,%eax
  802cfe:	49 b8 b1 2f 80 00 00 	movabs $0x802fb1,%r8
  802d05:	00 00 00 
  802d08:	41 ff d0             	callq  *%r8
			break;
  802d0b:	e9 92 02 00 00       	jmpq   802fa2 <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802d10:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802d13:	83 f8 30             	cmp    $0x30,%eax
  802d16:	73 17                	jae    802d2f <vprintfmt+0x296>
  802d18:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d1c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802d1f:	89 c0                	mov    %eax,%eax
  802d21:	48 01 d0             	add    %rdx,%rax
  802d24:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802d27:	83 c2 08             	add    $0x8,%edx
  802d2a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802d2d:	eb 0f                	jmp    802d3e <vprintfmt+0x2a5>
  802d2f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802d33:	48 89 d0             	mov    %rdx,%rax
  802d36:	48 83 c2 08          	add    $0x8,%rdx
  802d3a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802d3e:	4c 8b 20             	mov    (%rax),%r12
  802d41:	4d 85 e4             	test   %r12,%r12
  802d44:	75 0a                	jne    802d50 <vprintfmt+0x2b7>
				p = "(null)";
  802d46:	49 bc e5 37 80 00 00 	movabs $0x8037e5,%r12
  802d4d:	00 00 00 
			if (width > 0 && padc != '-')
  802d50:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802d54:	7e 3f                	jle    802d95 <vprintfmt+0x2fc>
  802d56:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  802d5a:	74 39                	je     802d95 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  802d5c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802d5f:	48 98                	cltq   
  802d61:	48 89 c6             	mov    %rax,%rsi
  802d64:	4c 89 e7             	mov    %r12,%rdi
  802d67:	48 b8 2e 02 80 00 00 	movabs $0x80022e,%rax
  802d6e:	00 00 00 
  802d71:	ff d0                	callq  *%rax
  802d73:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802d76:	eb 17                	jmp    802d8f <vprintfmt+0x2f6>
					putch(padc, putdat);
  802d78:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  802d7c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802d80:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802d84:	48 89 ce             	mov    %rcx,%rsi
  802d87:	89 d7                	mov    %edx,%edi
  802d89:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802d8b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802d8f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802d93:	7f e3                	jg     802d78 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802d95:	eb 37                	jmp    802dce <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  802d97:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802d9b:	74 1e                	je     802dbb <vprintfmt+0x322>
  802d9d:	83 fb 1f             	cmp    $0x1f,%ebx
  802da0:	7e 05                	jle    802da7 <vprintfmt+0x30e>
  802da2:	83 fb 7e             	cmp    $0x7e,%ebx
  802da5:	7e 14                	jle    802dbb <vprintfmt+0x322>
					putch('?', putdat);
  802da7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802dab:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802daf:	48 89 d6             	mov    %rdx,%rsi
  802db2:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802db7:	ff d0                	callq  *%rax
  802db9:	eb 0f                	jmp    802dca <vprintfmt+0x331>
				else
					putch(ch, putdat);
  802dbb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802dbf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802dc3:	48 89 d6             	mov    %rdx,%rsi
  802dc6:	89 df                	mov    %ebx,%edi
  802dc8:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802dca:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802dce:	4c 89 e0             	mov    %r12,%rax
  802dd1:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802dd5:	0f b6 00             	movzbl (%rax),%eax
  802dd8:	0f be d8             	movsbl %al,%ebx
  802ddb:	85 db                	test   %ebx,%ebx
  802ddd:	74 10                	je     802def <vprintfmt+0x356>
  802ddf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802de3:	78 b2                	js     802d97 <vprintfmt+0x2fe>
  802de5:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  802de9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802ded:	79 a8                	jns    802d97 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802def:	eb 16                	jmp    802e07 <vprintfmt+0x36e>
				putch(' ', putdat);
  802df1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802df5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802df9:	48 89 d6             	mov    %rdx,%rsi
  802dfc:	bf 20 00 00 00       	mov    $0x20,%edi
  802e01:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802e03:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802e07:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802e0b:	7f e4                	jg     802df1 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  802e0d:	e9 90 01 00 00       	jmpq   802fa2 <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  802e12:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802e16:	be 03 00 00 00       	mov    $0x3,%esi
  802e1b:	48 89 c7             	mov    %rax,%rdi
  802e1e:	48 b8 89 29 80 00 00 	movabs $0x802989,%rax
  802e25:	00 00 00 
  802e28:	ff d0                	callq  *%rax
  802e2a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  802e2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e32:	48 85 c0             	test   %rax,%rax
  802e35:	79 1d                	jns    802e54 <vprintfmt+0x3bb>
				putch('-', putdat);
  802e37:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802e3b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802e3f:	48 89 d6             	mov    %rdx,%rsi
  802e42:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802e47:	ff d0                	callq  *%rax
				num = -(long long) num;
  802e49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e4d:	48 f7 d8             	neg    %rax
  802e50:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  802e54:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802e5b:	e9 d5 00 00 00       	jmpq   802f35 <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  802e60:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802e64:	be 03 00 00 00       	mov    $0x3,%esi
  802e69:	48 89 c7             	mov    %rax,%rdi
  802e6c:	48 b8 79 28 80 00 00 	movabs $0x802879,%rax
  802e73:	00 00 00 
  802e76:	ff d0                	callq  *%rax
  802e78:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  802e7c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802e83:	e9 ad 00 00 00       	jmpq   802f35 <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  802e88:	8b 55 e0             	mov    -0x20(%rbp),%edx
  802e8b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802e8f:	89 d6                	mov    %edx,%esi
  802e91:	48 89 c7             	mov    %rax,%rdi
  802e94:	48 b8 89 29 80 00 00 	movabs $0x802989,%rax
  802e9b:	00 00 00 
  802e9e:	ff d0                	callq  *%rax
  802ea0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  802ea4:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  802eab:	e9 85 00 00 00       	jmpq   802f35 <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  802eb0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802eb4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802eb8:	48 89 d6             	mov    %rdx,%rsi
  802ebb:	bf 30 00 00 00       	mov    $0x30,%edi
  802ec0:	ff d0                	callq  *%rax
			putch('x', putdat);
  802ec2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802ec6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802eca:	48 89 d6             	mov    %rdx,%rsi
  802ecd:	bf 78 00 00 00       	mov    $0x78,%edi
  802ed2:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  802ed4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802ed7:	83 f8 30             	cmp    $0x30,%eax
  802eda:	73 17                	jae    802ef3 <vprintfmt+0x45a>
  802edc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ee0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802ee3:	89 c0                	mov    %eax,%eax
  802ee5:	48 01 d0             	add    %rdx,%rax
  802ee8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802eeb:	83 c2 08             	add    $0x8,%edx
  802eee:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802ef1:	eb 0f                	jmp    802f02 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  802ef3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802ef7:	48 89 d0             	mov    %rdx,%rax
  802efa:	48 83 c2 08          	add    $0x8,%rdx
  802efe:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802f02:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802f05:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  802f09:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  802f10:	eb 23                	jmp    802f35 <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  802f12:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802f16:	be 03 00 00 00       	mov    $0x3,%esi
  802f1b:	48 89 c7             	mov    %rax,%rdi
  802f1e:	48 b8 79 28 80 00 00 	movabs $0x802879,%rax
  802f25:	00 00 00 
  802f28:	ff d0                	callq  *%rax
  802f2a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  802f2e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  802f35:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  802f3a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802f3d:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802f40:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f44:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802f48:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f4c:	45 89 c1             	mov    %r8d,%r9d
  802f4f:	41 89 f8             	mov    %edi,%r8d
  802f52:	48 89 c7             	mov    %rax,%rdi
  802f55:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  802f5c:	00 00 00 
  802f5f:	ff d0                	callq  *%rax
			break;
  802f61:	eb 3f                	jmp    802fa2 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  802f63:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802f67:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f6b:	48 89 d6             	mov    %rdx,%rsi
  802f6e:	89 df                	mov    %ebx,%edi
  802f70:	ff d0                	callq  *%rax
			break;
  802f72:	eb 2e                	jmp    802fa2 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802f74:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802f78:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f7c:	48 89 d6             	mov    %rdx,%rsi
  802f7f:	bf 25 00 00 00       	mov    $0x25,%edi
  802f84:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  802f86:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802f8b:	eb 05                	jmp    802f92 <vprintfmt+0x4f9>
  802f8d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802f92:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802f96:	48 83 e8 01          	sub    $0x1,%rax
  802f9a:	0f b6 00             	movzbl (%rax),%eax
  802f9d:	3c 25                	cmp    $0x25,%al
  802f9f:	75 ec                	jne    802f8d <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  802fa1:	90                   	nop
		}
	}
  802fa2:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802fa3:	e9 43 fb ff ff       	jmpq   802aeb <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  802fa8:	48 83 c4 60          	add    $0x60,%rsp
  802fac:	5b                   	pop    %rbx
  802fad:	41 5c                	pop    %r12
  802faf:	5d                   	pop    %rbp
  802fb0:	c3                   	retq   

0000000000802fb1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802fb1:	55                   	push   %rbp
  802fb2:	48 89 e5             	mov    %rsp,%rbp
  802fb5:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  802fbc:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  802fc3:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  802fca:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802fd1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802fd8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802fdf:	84 c0                	test   %al,%al
  802fe1:	74 20                	je     803003 <printfmt+0x52>
  802fe3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802fe7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802feb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802fef:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802ff3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802ff7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802ffb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802fff:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803003:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80300a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  803011:	00 00 00 
  803014:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80301b:	00 00 00 
  80301e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803022:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  803029:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803030:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  803037:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80303e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803045:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80304c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803053:	48 89 c7             	mov    %rax,%rdi
  803056:	48 b8 99 2a 80 00 00 	movabs $0x802a99,%rax
  80305d:	00 00 00 
  803060:	ff d0                	callq  *%rax
	va_end(ap);
}
  803062:	c9                   	leaveq 
  803063:	c3                   	retq   

0000000000803064 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  803064:	55                   	push   %rbp
  803065:	48 89 e5             	mov    %rsp,%rbp
  803068:	48 83 ec 10          	sub    $0x10,%rsp
  80306c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80306f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803073:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803077:	8b 40 10             	mov    0x10(%rax),%eax
  80307a:	8d 50 01             	lea    0x1(%rax),%edx
  80307d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803081:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  803084:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803088:	48 8b 10             	mov    (%rax),%rdx
  80308b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80308f:	48 8b 40 08          	mov    0x8(%rax),%rax
  803093:	48 39 c2             	cmp    %rax,%rdx
  803096:	73 17                	jae    8030af <sprintputch+0x4b>
		*b->buf++ = ch;
  803098:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80309c:	48 8b 00             	mov    (%rax),%rax
  80309f:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8030a3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030a7:	48 89 0a             	mov    %rcx,(%rdx)
  8030aa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8030ad:	88 10                	mov    %dl,(%rax)
}
  8030af:	c9                   	leaveq 
  8030b0:	c3                   	retq   

00000000008030b1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8030b1:	55                   	push   %rbp
  8030b2:	48 89 e5             	mov    %rsp,%rbp
  8030b5:	48 83 ec 50          	sub    $0x50,%rsp
  8030b9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8030bd:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8030c0:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8030c4:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8030c8:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8030cc:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8030d0:	48 8b 0a             	mov    (%rdx),%rcx
  8030d3:	48 89 08             	mov    %rcx,(%rax)
  8030d6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8030da:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8030de:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8030e2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8030e6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8030ea:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8030ee:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8030f1:	48 98                	cltq   
  8030f3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8030f7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8030fb:	48 01 d0             	add    %rdx,%rax
  8030fe:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803102:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  803109:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80310e:	74 06                	je     803116 <vsnprintf+0x65>
  803110:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803114:	7f 07                	jg     80311d <vsnprintf+0x6c>
		return -E_INVAL;
  803116:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80311b:	eb 2f                	jmp    80314c <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80311d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  803121:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803125:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803129:	48 89 c6             	mov    %rax,%rsi
  80312c:	48 bf 64 30 80 00 00 	movabs $0x803064,%rdi
  803133:	00 00 00 
  803136:	48 b8 99 2a 80 00 00 	movabs $0x802a99,%rax
  80313d:	00 00 00 
  803140:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  803142:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803146:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  803149:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80314c:	c9                   	leaveq 
  80314d:	c3                   	retq   

000000000080314e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80314e:	55                   	push   %rbp
  80314f:	48 89 e5             	mov    %rsp,%rbp
  803152:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  803159:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803160:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803166:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80316d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803174:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80317b:	84 c0                	test   %al,%al
  80317d:	74 20                	je     80319f <snprintf+0x51>
  80317f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803183:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803187:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80318b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80318f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803193:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803197:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80319b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80319f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8031a6:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8031ad:	00 00 00 
  8031b0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8031b7:	00 00 00 
  8031ba:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8031be:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8031c5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8031cc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8031d3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8031da:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8031e1:	48 8b 0a             	mov    (%rdx),%rcx
  8031e4:	48 89 08             	mov    %rcx,(%rax)
  8031e7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8031eb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8031ef:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8031f3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8031f7:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8031fe:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  803205:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80320b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803212:	48 89 c7             	mov    %rax,%rdi
  803215:	48 b8 b1 30 80 00 00 	movabs $0x8030b1,%rax
  80321c:	00 00 00 
  80321f:	ff d0                	callq  *%rax
  803221:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  803227:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80322d:	c9                   	leaveq 
  80322e:	c3                   	retq   

000000000080322f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80322f:	55                   	push   %rbp
  803230:	48 89 e5             	mov    %rsp,%rbp
  803233:	48 83 ec 30          	sub    $0x30,%rsp
  803237:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80323b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80323f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803243:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80324a:	00 00 00 
  80324d:	48 8b 00             	mov    (%rax),%rax
  803250:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803256:	85 c0                	test   %eax,%eax
  803258:	75 3c                	jne    803296 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  80325a:	48 b8 1f 0b 80 00 00 	movabs $0x800b1f,%rax
  803261:	00 00 00 
  803264:	ff d0                	callq  *%rax
  803266:	25 ff 03 00 00       	and    $0x3ff,%eax
  80326b:	48 63 d0             	movslq %eax,%rdx
  80326e:	48 89 d0             	mov    %rdx,%rax
  803271:	48 c1 e0 03          	shl    $0x3,%rax
  803275:	48 01 d0             	add    %rdx,%rax
  803278:	48 c1 e0 05          	shl    $0x5,%rax
  80327c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803283:	00 00 00 
  803286:	48 01 c2             	add    %rax,%rdx
  803289:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803290:	00 00 00 
  803293:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803296:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80329b:	75 0e                	jne    8032ab <ipc_recv+0x7c>
		pg = (void*) UTOP;
  80329d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8032a4:	00 00 00 
  8032a7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8032ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032af:	48 89 c7             	mov    %rax,%rdi
  8032b2:	48 b8 c4 0d 80 00 00 	movabs $0x800dc4,%rax
  8032b9:	00 00 00 
  8032bc:	ff d0                	callq  *%rax
  8032be:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8032c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032c5:	79 19                	jns    8032e0 <ipc_recv+0xb1>
		*from_env_store = 0;
  8032c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032cb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8032d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032d5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8032db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032de:	eb 53                	jmp    803333 <ipc_recv+0x104>
	}
	if(from_env_store)
  8032e0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8032e5:	74 19                	je     803300 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  8032e7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8032ee:	00 00 00 
  8032f1:	48 8b 00             	mov    (%rax),%rax
  8032f4:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8032fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032fe:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803300:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803305:	74 19                	je     803320 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803307:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80330e:	00 00 00 
  803311:	48 8b 00             	mov    (%rax),%rax
  803314:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80331a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80331e:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803320:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803327:	00 00 00 
  80332a:	48 8b 00             	mov    (%rax),%rax
  80332d:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803333:	c9                   	leaveq 
  803334:	c3                   	retq   

0000000000803335 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803335:	55                   	push   %rbp
  803336:	48 89 e5             	mov    %rsp,%rbp
  803339:	48 83 ec 30          	sub    $0x30,%rsp
  80333d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803340:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803343:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803347:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80334a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80334f:	75 0e                	jne    80335f <ipc_send+0x2a>
		pg = (void*)UTOP;
  803351:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803358:	00 00 00 
  80335b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80335f:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803362:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803365:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803369:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80336c:	89 c7                	mov    %eax,%edi
  80336e:	48 b8 6f 0d 80 00 00 	movabs $0x800d6f,%rax
  803375:	00 00 00 
  803378:	ff d0                	callq  *%rax
  80337a:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80337d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803381:	75 0c                	jne    80338f <ipc_send+0x5a>
			sys_yield();
  803383:	48 b8 5d 0b 80 00 00 	movabs $0x800b5d,%rax
  80338a:	00 00 00 
  80338d:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80338f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803393:	74 ca                	je     80335f <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803395:	c9                   	leaveq 
  803396:	c3                   	retq   

0000000000803397 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803397:	55                   	push   %rbp
  803398:	48 89 e5             	mov    %rsp,%rbp
  80339b:	48 83 ec 14          	sub    $0x14,%rsp
  80339f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8033a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8033a9:	eb 5e                	jmp    803409 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8033ab:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8033b2:	00 00 00 
  8033b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b8:	48 63 d0             	movslq %eax,%rdx
  8033bb:	48 89 d0             	mov    %rdx,%rax
  8033be:	48 c1 e0 03          	shl    $0x3,%rax
  8033c2:	48 01 d0             	add    %rdx,%rax
  8033c5:	48 c1 e0 05          	shl    $0x5,%rax
  8033c9:	48 01 c8             	add    %rcx,%rax
  8033cc:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8033d2:	8b 00                	mov    (%rax),%eax
  8033d4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8033d7:	75 2c                	jne    803405 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8033d9:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8033e0:	00 00 00 
  8033e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e6:	48 63 d0             	movslq %eax,%rdx
  8033e9:	48 89 d0             	mov    %rdx,%rax
  8033ec:	48 c1 e0 03          	shl    $0x3,%rax
  8033f0:	48 01 d0             	add    %rdx,%rax
  8033f3:	48 c1 e0 05          	shl    $0x5,%rax
  8033f7:	48 01 c8             	add    %rcx,%rax
  8033fa:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803400:	8b 40 08             	mov    0x8(%rax),%eax
  803403:	eb 12                	jmp    803417 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803405:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803409:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803410:	7e 99                	jle    8033ab <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803412:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803417:	c9                   	leaveq 
  803418:	c3                   	retq   

0000000000803419 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803419:	55                   	push   %rbp
  80341a:	48 89 e5             	mov    %rsp,%rbp
  80341d:	48 83 ec 18          	sub    $0x18,%rsp
  803421:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803425:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803429:	48 c1 e8 15          	shr    $0x15,%rax
  80342d:	48 89 c2             	mov    %rax,%rdx
  803430:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803437:	01 00 00 
  80343a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80343e:	83 e0 01             	and    $0x1,%eax
  803441:	48 85 c0             	test   %rax,%rax
  803444:	75 07                	jne    80344d <pageref+0x34>
		return 0;
  803446:	b8 00 00 00 00       	mov    $0x0,%eax
  80344b:	eb 53                	jmp    8034a0 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80344d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803451:	48 c1 e8 0c          	shr    $0xc,%rax
  803455:	48 89 c2             	mov    %rax,%rdx
  803458:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80345f:	01 00 00 
  803462:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803466:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80346a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80346e:	83 e0 01             	and    $0x1,%eax
  803471:	48 85 c0             	test   %rax,%rax
  803474:	75 07                	jne    80347d <pageref+0x64>
		return 0;
  803476:	b8 00 00 00 00       	mov    $0x0,%eax
  80347b:	eb 23                	jmp    8034a0 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80347d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803481:	48 c1 e8 0c          	shr    $0xc,%rax
  803485:	48 89 c2             	mov    %rax,%rdx
  803488:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80348f:	00 00 00 
  803492:	48 c1 e2 04          	shl    $0x4,%rdx
  803496:	48 01 d0             	add    %rdx,%rax
  803499:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80349d:	0f b7 c0             	movzwl %ax,%eax
}
  8034a0:	c9                   	leaveq 
  8034a1:	c3                   	retq   
