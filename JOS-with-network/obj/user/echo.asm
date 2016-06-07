
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
  80006a:	48 be 60 3f 80 00 00 	movabs $0x803f60,%rsi
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
  8000ab:	48 be 63 3f 80 00 00 	movabs $0x803f63,%rsi
  8000b2:	00 00 00 
  8000b5:	bf 01 00 00 00       	mov    $0x1,%edi
  8000ba:	48 b8 34 15 80 00 00 	movabs $0x801534,%rax
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
  80010e:	48 b8 34 15 80 00 00 	movabs $0x801534,%rax
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
  800135:	48 be 65 3f 80 00 00 	movabs $0x803f65,%rsi
  80013c:	00 00 00 
  80013f:	bf 01 00 00 00       	mov    $0x1,%edi
  800144:	48 b8 34 15 80 00 00 	movabs $0x801534,%rax
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
  800190:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
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
  8001aa:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
  8001e1:	48 b8 13 12 80 00 00 	movabs $0x801213,%rax
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
  800a1d:	48 ba 71 3f 80 00 00 	movabs $0x803f71,%rdx
  800a24:	00 00 00 
  800a27:	be 23 00 00 00       	mov    $0x23,%esi
  800a2c:	48 bf 8e 3f 80 00 00 	movabs $0x803f8e,%rdi
  800a33:	00 00 00 
  800a36:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3b:	49 b9 5e 2f 80 00 00 	movabs $0x802f5e,%r9
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

0000000000800e08 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  800e08:	55                   	push   %rbp
  800e09:	48 89 e5             	mov    %rsp,%rbp
  800e0c:	48 83 ec 20          	sub    $0x20,%rsp
  800e10:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800e14:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  800e18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800e1c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e20:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800e27:	00 
  800e28:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800e2e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800e34:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e39:	89 c6                	mov    %eax,%esi
  800e3b:	bf 0f 00 00 00       	mov    $0xf,%edi
  800e40:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800e47:	00 00 00 
  800e4a:	ff d0                	callq  *%rax
}
  800e4c:	c9                   	leaveq 
  800e4d:	c3                   	retq   

0000000000800e4e <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  800e4e:	55                   	push   %rbp
  800e4f:	48 89 e5             	mov    %rsp,%rbp
  800e52:	48 83 ec 20          	sub    $0x20,%rsp
  800e56:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800e5a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  800e5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800e62:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e66:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800e6d:	00 
  800e6e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800e74:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800e7a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e7f:	89 c6                	mov    %eax,%esi
  800e81:	bf 10 00 00 00       	mov    $0x10,%edi
  800e86:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800e8d:	00 00 00 
  800e90:	ff d0                	callq  *%rax
}
  800e92:	c9                   	leaveq 
  800e93:	c3                   	retq   

0000000000800e94 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  800e94:	55                   	push   %rbp
  800e95:	48 89 e5             	mov    %rsp,%rbp
  800e98:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  800e9c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800ea3:	00 
  800ea4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800eaa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800eb0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eb5:	ba 00 00 00 00       	mov    $0x0,%edx
  800eba:	be 00 00 00 00       	mov    $0x0,%esi
  800ebf:	bf 0e 00 00 00       	mov    $0xe,%edi
  800ec4:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800ecb:	00 00 00 
  800ece:	ff d0                	callq  *%rax
}
  800ed0:	c9                   	leaveq 
  800ed1:	c3                   	retq   

0000000000800ed2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800ed2:	55                   	push   %rbp
  800ed3:	48 89 e5             	mov    %rsp,%rbp
  800ed6:	48 83 ec 08          	sub    $0x8,%rsp
  800eda:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ede:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800ee2:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800ee9:	ff ff ff 
  800eec:	48 01 d0             	add    %rdx,%rax
  800eef:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800ef3:	c9                   	leaveq 
  800ef4:	c3                   	retq   

0000000000800ef5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ef5:	55                   	push   %rbp
  800ef6:	48 89 e5             	mov    %rsp,%rbp
  800ef9:	48 83 ec 08          	sub    $0x8,%rsp
  800efd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800f01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f05:	48 89 c7             	mov    %rax,%rdi
  800f08:	48 b8 d2 0e 80 00 00 	movabs $0x800ed2,%rax
  800f0f:	00 00 00 
  800f12:	ff d0                	callq  *%rax
  800f14:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800f1a:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800f1e:	c9                   	leaveq 
  800f1f:	c3                   	retq   

0000000000800f20 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f20:	55                   	push   %rbp
  800f21:	48 89 e5             	mov    %rsp,%rbp
  800f24:	48 83 ec 18          	sub    $0x18,%rsp
  800f28:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800f2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f33:	eb 6b                	jmp    800fa0 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  800f35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f38:	48 98                	cltq   
  800f3a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800f40:	48 c1 e0 0c          	shl    $0xc,%rax
  800f44:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f4c:	48 c1 e8 15          	shr    $0x15,%rax
  800f50:	48 89 c2             	mov    %rax,%rdx
  800f53:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800f5a:	01 00 00 
  800f5d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800f61:	83 e0 01             	and    $0x1,%eax
  800f64:	48 85 c0             	test   %rax,%rax
  800f67:	74 21                	je     800f8a <fd_alloc+0x6a>
  800f69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f6d:	48 c1 e8 0c          	shr    $0xc,%rax
  800f71:	48 89 c2             	mov    %rax,%rdx
  800f74:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800f7b:	01 00 00 
  800f7e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800f82:	83 e0 01             	and    $0x1,%eax
  800f85:	48 85 c0             	test   %rax,%rax
  800f88:	75 12                	jne    800f9c <fd_alloc+0x7c>
			*fd_store = fd;
  800f8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f8e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f92:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800f95:	b8 00 00 00 00       	mov    $0x0,%eax
  800f9a:	eb 1a                	jmp    800fb6 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800f9c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800fa0:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800fa4:	7e 8f                	jle    800f35 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800fa6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800faa:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800fb1:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800fb6:	c9                   	leaveq 
  800fb7:	c3                   	retq   

0000000000800fb8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fb8:	55                   	push   %rbp
  800fb9:	48 89 e5             	mov    %rsp,%rbp
  800fbc:	48 83 ec 20          	sub    $0x20,%rsp
  800fc0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800fc3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fc7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800fcb:	78 06                	js     800fd3 <fd_lookup+0x1b>
  800fcd:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800fd1:	7e 07                	jle    800fda <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800fd3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fd8:	eb 6c                	jmp    801046 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800fda:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800fdd:	48 98                	cltq   
  800fdf:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800fe5:	48 c1 e0 0c          	shl    $0xc,%rax
  800fe9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ff1:	48 c1 e8 15          	shr    $0x15,%rax
  800ff5:	48 89 c2             	mov    %rax,%rdx
  800ff8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800fff:	01 00 00 
  801002:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801006:	83 e0 01             	and    $0x1,%eax
  801009:	48 85 c0             	test   %rax,%rax
  80100c:	74 21                	je     80102f <fd_lookup+0x77>
  80100e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801012:	48 c1 e8 0c          	shr    $0xc,%rax
  801016:	48 89 c2             	mov    %rax,%rdx
  801019:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801020:	01 00 00 
  801023:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801027:	83 e0 01             	and    $0x1,%eax
  80102a:	48 85 c0             	test   %rax,%rax
  80102d:	75 07                	jne    801036 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80102f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801034:	eb 10                	jmp    801046 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801036:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80103a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80103e:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801041:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801046:	c9                   	leaveq 
  801047:	c3                   	retq   

0000000000801048 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801048:	55                   	push   %rbp
  801049:	48 89 e5             	mov    %rsp,%rbp
  80104c:	48 83 ec 30          	sub    $0x30,%rsp
  801050:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801054:	89 f0                	mov    %esi,%eax
  801056:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801059:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80105d:	48 89 c7             	mov    %rax,%rdi
  801060:	48 b8 d2 0e 80 00 00 	movabs $0x800ed2,%rax
  801067:	00 00 00 
  80106a:	ff d0                	callq  *%rax
  80106c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801070:	48 89 d6             	mov    %rdx,%rsi
  801073:	89 c7                	mov    %eax,%edi
  801075:	48 b8 b8 0f 80 00 00 	movabs $0x800fb8,%rax
  80107c:	00 00 00 
  80107f:	ff d0                	callq  *%rax
  801081:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801084:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801088:	78 0a                	js     801094 <fd_close+0x4c>
	    || fd != fd2)
  80108a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80108e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801092:	74 12                	je     8010a6 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801094:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801098:	74 05                	je     80109f <fd_close+0x57>
  80109a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80109d:	eb 05                	jmp    8010a4 <fd_close+0x5c>
  80109f:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a4:	eb 69                	jmp    80110f <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010aa:	8b 00                	mov    (%rax),%eax
  8010ac:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8010b0:	48 89 d6             	mov    %rdx,%rsi
  8010b3:	89 c7                	mov    %eax,%edi
  8010b5:	48 b8 11 11 80 00 00 	movabs $0x801111,%rax
  8010bc:	00 00 00 
  8010bf:	ff d0                	callq  *%rax
  8010c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010c8:	78 2a                	js     8010f4 <fd_close+0xac>
		if (dev->dev_close)
  8010ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ce:	48 8b 40 20          	mov    0x20(%rax),%rax
  8010d2:	48 85 c0             	test   %rax,%rax
  8010d5:	74 16                	je     8010ed <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8010d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010db:	48 8b 40 20          	mov    0x20(%rax),%rax
  8010df:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8010e3:	48 89 d7             	mov    %rdx,%rdi
  8010e6:	ff d0                	callq  *%rax
  8010e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010eb:	eb 07                	jmp    8010f4 <fd_close+0xac>
		else
			r = 0;
  8010ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8010f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010f8:	48 89 c6             	mov    %rax,%rsi
  8010fb:	bf 00 00 00 00       	mov    $0x0,%edi
  801100:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  801107:	00 00 00 
  80110a:	ff d0                	callq  *%rax
	return r;
  80110c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80110f:	c9                   	leaveq 
  801110:	c3                   	retq   

0000000000801111 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801111:	55                   	push   %rbp
  801112:	48 89 e5             	mov    %rsp,%rbp
  801115:	48 83 ec 20          	sub    $0x20,%rsp
  801119:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80111c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801120:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801127:	eb 41                	jmp    80116a <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801129:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801130:	00 00 00 
  801133:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801136:	48 63 d2             	movslq %edx,%rdx
  801139:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80113d:	8b 00                	mov    (%rax),%eax
  80113f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801142:	75 22                	jne    801166 <dev_lookup+0x55>
			*dev = devtab[i];
  801144:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80114b:	00 00 00 
  80114e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801151:	48 63 d2             	movslq %edx,%rdx
  801154:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801158:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80115c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80115f:	b8 00 00 00 00       	mov    $0x0,%eax
  801164:	eb 60                	jmp    8011c6 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801166:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80116a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801171:	00 00 00 
  801174:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801177:	48 63 d2             	movslq %edx,%rdx
  80117a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80117e:	48 85 c0             	test   %rax,%rax
  801181:	75 a6                	jne    801129 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801183:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80118a:	00 00 00 
  80118d:	48 8b 00             	mov    (%rax),%rax
  801190:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801196:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801199:	89 c6                	mov    %eax,%esi
  80119b:	48 bf a0 3f 80 00 00 	movabs $0x803fa0,%rdi
  8011a2:	00 00 00 
  8011a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8011aa:	48 b9 97 31 80 00 00 	movabs $0x803197,%rcx
  8011b1:	00 00 00 
  8011b4:	ff d1                	callq  *%rcx
	*dev = 0;
  8011b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ba:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8011c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011c6:	c9                   	leaveq 
  8011c7:	c3                   	retq   

00000000008011c8 <close>:

int
close(int fdnum)
{
  8011c8:	55                   	push   %rbp
  8011c9:	48 89 e5             	mov    %rsp,%rbp
  8011cc:	48 83 ec 20          	sub    $0x20,%rsp
  8011d0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011d3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8011d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8011da:	48 89 d6             	mov    %rdx,%rsi
  8011dd:	89 c7                	mov    %eax,%edi
  8011df:	48 b8 b8 0f 80 00 00 	movabs $0x800fb8,%rax
  8011e6:	00 00 00 
  8011e9:	ff d0                	callq  *%rax
  8011eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011f2:	79 05                	jns    8011f9 <close+0x31>
		return r;
  8011f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011f7:	eb 18                	jmp    801211 <close+0x49>
	else
		return fd_close(fd, 1);
  8011f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011fd:	be 01 00 00 00       	mov    $0x1,%esi
  801202:	48 89 c7             	mov    %rax,%rdi
  801205:	48 b8 48 10 80 00 00 	movabs $0x801048,%rax
  80120c:	00 00 00 
  80120f:	ff d0                	callq  *%rax
}
  801211:	c9                   	leaveq 
  801212:	c3                   	retq   

0000000000801213 <close_all>:

void
close_all(void)
{
  801213:	55                   	push   %rbp
  801214:	48 89 e5             	mov    %rsp,%rbp
  801217:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80121b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801222:	eb 15                	jmp    801239 <close_all+0x26>
		close(i);
  801224:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801227:	89 c7                	mov    %eax,%edi
  801229:	48 b8 c8 11 80 00 00 	movabs $0x8011c8,%rax
  801230:	00 00 00 
  801233:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801235:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801239:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80123d:	7e e5                	jle    801224 <close_all+0x11>
		close(i);
}
  80123f:	c9                   	leaveq 
  801240:	c3                   	retq   

0000000000801241 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801241:	55                   	push   %rbp
  801242:	48 89 e5             	mov    %rsp,%rbp
  801245:	48 83 ec 40          	sub    $0x40,%rsp
  801249:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80124c:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80124f:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801253:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801256:	48 89 d6             	mov    %rdx,%rsi
  801259:	89 c7                	mov    %eax,%edi
  80125b:	48 b8 b8 0f 80 00 00 	movabs $0x800fb8,%rax
  801262:	00 00 00 
  801265:	ff d0                	callq  *%rax
  801267:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80126a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80126e:	79 08                	jns    801278 <dup+0x37>
		return r;
  801270:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801273:	e9 70 01 00 00       	jmpq   8013e8 <dup+0x1a7>
	close(newfdnum);
  801278:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80127b:	89 c7                	mov    %eax,%edi
  80127d:	48 b8 c8 11 80 00 00 	movabs $0x8011c8,%rax
  801284:	00 00 00 
  801287:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801289:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80128c:	48 98                	cltq   
  80128e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801294:	48 c1 e0 0c          	shl    $0xc,%rax
  801298:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80129c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a0:	48 89 c7             	mov    %rax,%rdi
  8012a3:	48 b8 f5 0e 80 00 00 	movabs $0x800ef5,%rax
  8012aa:	00 00 00 
  8012ad:	ff d0                	callq  *%rax
  8012af:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8012b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b7:	48 89 c7             	mov    %rax,%rdi
  8012ba:	48 b8 f5 0e 80 00 00 	movabs $0x800ef5,%rax
  8012c1:	00 00 00 
  8012c4:	ff d0                	callq  *%rax
  8012c6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ce:	48 c1 e8 15          	shr    $0x15,%rax
  8012d2:	48 89 c2             	mov    %rax,%rdx
  8012d5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8012dc:	01 00 00 
  8012df:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8012e3:	83 e0 01             	and    $0x1,%eax
  8012e6:	48 85 c0             	test   %rax,%rax
  8012e9:	74 73                	je     80135e <dup+0x11d>
  8012eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ef:	48 c1 e8 0c          	shr    $0xc,%rax
  8012f3:	48 89 c2             	mov    %rax,%rdx
  8012f6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8012fd:	01 00 00 
  801300:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801304:	83 e0 01             	and    $0x1,%eax
  801307:	48 85 c0             	test   %rax,%rax
  80130a:	74 52                	je     80135e <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80130c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801310:	48 c1 e8 0c          	shr    $0xc,%rax
  801314:	48 89 c2             	mov    %rax,%rdx
  801317:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80131e:	01 00 00 
  801321:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801325:	25 07 0e 00 00       	and    $0xe07,%eax
  80132a:	89 c1                	mov    %eax,%ecx
  80132c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801330:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801334:	41 89 c8             	mov    %ecx,%r8d
  801337:	48 89 d1             	mov    %rdx,%rcx
  80133a:	ba 00 00 00 00       	mov    $0x0,%edx
  80133f:	48 89 c6             	mov    %rax,%rsi
  801342:	bf 00 00 00 00       	mov    $0x0,%edi
  801347:	48 b8 eb 0b 80 00 00 	movabs $0x800beb,%rax
  80134e:	00 00 00 
  801351:	ff d0                	callq  *%rax
  801353:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801356:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80135a:	79 02                	jns    80135e <dup+0x11d>
			goto err;
  80135c:	eb 57                	jmp    8013b5 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80135e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801362:	48 c1 e8 0c          	shr    $0xc,%rax
  801366:	48 89 c2             	mov    %rax,%rdx
  801369:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801370:	01 00 00 
  801373:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801377:	25 07 0e 00 00       	and    $0xe07,%eax
  80137c:	89 c1                	mov    %eax,%ecx
  80137e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801382:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801386:	41 89 c8             	mov    %ecx,%r8d
  801389:	48 89 d1             	mov    %rdx,%rcx
  80138c:	ba 00 00 00 00       	mov    $0x0,%edx
  801391:	48 89 c6             	mov    %rax,%rsi
  801394:	bf 00 00 00 00       	mov    $0x0,%edi
  801399:	48 b8 eb 0b 80 00 00 	movabs $0x800beb,%rax
  8013a0:	00 00 00 
  8013a3:	ff d0                	callq  *%rax
  8013a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8013a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8013ac:	79 02                	jns    8013b0 <dup+0x16f>
		goto err;
  8013ae:	eb 05                	jmp    8013b5 <dup+0x174>

	return newfdnum;
  8013b0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8013b3:	eb 33                	jmp    8013e8 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8013b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b9:	48 89 c6             	mov    %rax,%rsi
  8013bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8013c1:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  8013c8:	00 00 00 
  8013cb:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8013cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013d1:	48 89 c6             	mov    %rax,%rsi
  8013d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8013d9:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  8013e0:	00 00 00 
  8013e3:	ff d0                	callq  *%rax
	return r;
  8013e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013e8:	c9                   	leaveq 
  8013e9:	c3                   	retq   

00000000008013ea <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013ea:	55                   	push   %rbp
  8013eb:	48 89 e5             	mov    %rsp,%rbp
  8013ee:	48 83 ec 40          	sub    $0x40,%rsp
  8013f2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8013f5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013f9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013fd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801401:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801404:	48 89 d6             	mov    %rdx,%rsi
  801407:	89 c7                	mov    %eax,%edi
  801409:	48 b8 b8 0f 80 00 00 	movabs $0x800fb8,%rax
  801410:	00 00 00 
  801413:	ff d0                	callq  *%rax
  801415:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801418:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80141c:	78 24                	js     801442 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80141e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801422:	8b 00                	mov    (%rax),%eax
  801424:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801428:	48 89 d6             	mov    %rdx,%rsi
  80142b:	89 c7                	mov    %eax,%edi
  80142d:	48 b8 11 11 80 00 00 	movabs $0x801111,%rax
  801434:	00 00 00 
  801437:	ff d0                	callq  *%rax
  801439:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80143c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801440:	79 05                	jns    801447 <read+0x5d>
		return r;
  801442:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801445:	eb 76                	jmp    8014bd <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801447:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80144b:	8b 40 08             	mov    0x8(%rax),%eax
  80144e:	83 e0 03             	and    $0x3,%eax
  801451:	83 f8 01             	cmp    $0x1,%eax
  801454:	75 3a                	jne    801490 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801456:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80145d:	00 00 00 
  801460:	48 8b 00             	mov    (%rax),%rax
  801463:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801469:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80146c:	89 c6                	mov    %eax,%esi
  80146e:	48 bf bf 3f 80 00 00 	movabs $0x803fbf,%rdi
  801475:	00 00 00 
  801478:	b8 00 00 00 00       	mov    $0x0,%eax
  80147d:	48 b9 97 31 80 00 00 	movabs $0x803197,%rcx
  801484:	00 00 00 
  801487:	ff d1                	callq  *%rcx
		return -E_INVAL;
  801489:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80148e:	eb 2d                	jmp    8014bd <read+0xd3>
	}
	if (!dev->dev_read)
  801490:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801494:	48 8b 40 10          	mov    0x10(%rax),%rax
  801498:	48 85 c0             	test   %rax,%rax
  80149b:	75 07                	jne    8014a4 <read+0xba>
		return -E_NOT_SUPP;
  80149d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8014a2:	eb 19                	jmp    8014bd <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8014a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8014ac:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8014b0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8014b4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8014b8:	48 89 cf             	mov    %rcx,%rdi
  8014bb:	ff d0                	callq  *%rax
}
  8014bd:	c9                   	leaveq 
  8014be:	c3                   	retq   

00000000008014bf <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014bf:	55                   	push   %rbp
  8014c0:	48 89 e5             	mov    %rsp,%rbp
  8014c3:	48 83 ec 30          	sub    $0x30,%rsp
  8014c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8014ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014ce:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8014d9:	eb 49                	jmp    801524 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014de:	48 98                	cltq   
  8014e0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014e4:	48 29 c2             	sub    %rax,%rdx
  8014e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014ea:	48 63 c8             	movslq %eax,%rcx
  8014ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014f1:	48 01 c1             	add    %rax,%rcx
  8014f4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014f7:	48 89 ce             	mov    %rcx,%rsi
  8014fa:	89 c7                	mov    %eax,%edi
  8014fc:	48 b8 ea 13 80 00 00 	movabs $0x8013ea,%rax
  801503:	00 00 00 
  801506:	ff d0                	callq  *%rax
  801508:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80150b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80150f:	79 05                	jns    801516 <readn+0x57>
			return m;
  801511:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801514:	eb 1c                	jmp    801532 <readn+0x73>
		if (m == 0)
  801516:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80151a:	75 02                	jne    80151e <readn+0x5f>
			break;
  80151c:	eb 11                	jmp    80152f <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80151e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801521:	01 45 fc             	add    %eax,-0x4(%rbp)
  801524:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801527:	48 98                	cltq   
  801529:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80152d:	72 ac                	jb     8014db <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80152f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801532:	c9                   	leaveq 
  801533:	c3                   	retq   

0000000000801534 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801534:	55                   	push   %rbp
  801535:	48 89 e5             	mov    %rsp,%rbp
  801538:	48 83 ec 40          	sub    $0x40,%rsp
  80153c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80153f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801543:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801547:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80154b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80154e:	48 89 d6             	mov    %rdx,%rsi
  801551:	89 c7                	mov    %eax,%edi
  801553:	48 b8 b8 0f 80 00 00 	movabs $0x800fb8,%rax
  80155a:	00 00 00 
  80155d:	ff d0                	callq  *%rax
  80155f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801562:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801566:	78 24                	js     80158c <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801568:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156c:	8b 00                	mov    (%rax),%eax
  80156e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801572:	48 89 d6             	mov    %rdx,%rsi
  801575:	89 c7                	mov    %eax,%edi
  801577:	48 b8 11 11 80 00 00 	movabs $0x801111,%rax
  80157e:	00 00 00 
  801581:	ff d0                	callq  *%rax
  801583:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801586:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80158a:	79 05                	jns    801591 <write+0x5d>
		return r;
  80158c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80158f:	eb 75                	jmp    801606 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801591:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801595:	8b 40 08             	mov    0x8(%rax),%eax
  801598:	83 e0 03             	and    $0x3,%eax
  80159b:	85 c0                	test   %eax,%eax
  80159d:	75 3a                	jne    8015d9 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80159f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8015a6:	00 00 00 
  8015a9:	48 8b 00             	mov    (%rax),%rax
  8015ac:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8015b2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8015b5:	89 c6                	mov    %eax,%esi
  8015b7:	48 bf db 3f 80 00 00 	movabs $0x803fdb,%rdi
  8015be:	00 00 00 
  8015c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c6:	48 b9 97 31 80 00 00 	movabs $0x803197,%rcx
  8015cd:	00 00 00 
  8015d0:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8015d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d7:	eb 2d                	jmp    801606 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8015d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015dd:	48 8b 40 18          	mov    0x18(%rax),%rax
  8015e1:	48 85 c0             	test   %rax,%rax
  8015e4:	75 07                	jne    8015ed <write+0xb9>
		return -E_NOT_SUPP;
  8015e6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8015eb:	eb 19                	jmp    801606 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8015ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f1:	48 8b 40 18          	mov    0x18(%rax),%rax
  8015f5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8015f9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8015fd:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801601:	48 89 cf             	mov    %rcx,%rdi
  801604:	ff d0                	callq  *%rax
}
  801606:	c9                   	leaveq 
  801607:	c3                   	retq   

0000000000801608 <seek>:

int
seek(int fdnum, off_t offset)
{
  801608:	55                   	push   %rbp
  801609:	48 89 e5             	mov    %rsp,%rbp
  80160c:	48 83 ec 18          	sub    $0x18,%rsp
  801610:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801613:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801616:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80161a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80161d:	48 89 d6             	mov    %rdx,%rsi
  801620:	89 c7                	mov    %eax,%edi
  801622:	48 b8 b8 0f 80 00 00 	movabs $0x800fb8,%rax
  801629:	00 00 00 
  80162c:	ff d0                	callq  *%rax
  80162e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801631:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801635:	79 05                	jns    80163c <seek+0x34>
		return r;
  801637:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80163a:	eb 0f                	jmp    80164b <seek+0x43>
	fd->fd_offset = offset;
  80163c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801640:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801643:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  801646:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80164b:	c9                   	leaveq 
  80164c:	c3                   	retq   

000000000080164d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80164d:	55                   	push   %rbp
  80164e:	48 89 e5             	mov    %rsp,%rbp
  801651:	48 83 ec 30          	sub    $0x30,%rsp
  801655:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801658:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80165b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80165f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801662:	48 89 d6             	mov    %rdx,%rsi
  801665:	89 c7                	mov    %eax,%edi
  801667:	48 b8 b8 0f 80 00 00 	movabs $0x800fb8,%rax
  80166e:	00 00 00 
  801671:	ff d0                	callq  *%rax
  801673:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801676:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80167a:	78 24                	js     8016a0 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80167c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801680:	8b 00                	mov    (%rax),%eax
  801682:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801686:	48 89 d6             	mov    %rdx,%rsi
  801689:	89 c7                	mov    %eax,%edi
  80168b:	48 b8 11 11 80 00 00 	movabs $0x801111,%rax
  801692:	00 00 00 
  801695:	ff d0                	callq  *%rax
  801697:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80169a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80169e:	79 05                	jns    8016a5 <ftruncate+0x58>
		return r;
  8016a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016a3:	eb 72                	jmp    801717 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016a9:	8b 40 08             	mov    0x8(%rax),%eax
  8016ac:	83 e0 03             	and    $0x3,%eax
  8016af:	85 c0                	test   %eax,%eax
  8016b1:	75 3a                	jne    8016ed <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8016b3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8016ba:	00 00 00 
  8016bd:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016c0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8016c6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8016c9:	89 c6                	mov    %eax,%esi
  8016cb:	48 bf f8 3f 80 00 00 	movabs $0x803ff8,%rdi
  8016d2:	00 00 00 
  8016d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016da:	48 b9 97 31 80 00 00 	movabs $0x803197,%rcx
  8016e1:	00 00 00 
  8016e4:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8016e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016eb:	eb 2a                	jmp    801717 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8016ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f1:	48 8b 40 30          	mov    0x30(%rax),%rax
  8016f5:	48 85 c0             	test   %rax,%rax
  8016f8:	75 07                	jne    801701 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8016fa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8016ff:	eb 16                	jmp    801717 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  801701:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801705:	48 8b 40 30          	mov    0x30(%rax),%rax
  801709:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80170d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  801710:	89 ce                	mov    %ecx,%esi
  801712:	48 89 d7             	mov    %rdx,%rdi
  801715:	ff d0                	callq  *%rax
}
  801717:	c9                   	leaveq 
  801718:	c3                   	retq   

0000000000801719 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801719:	55                   	push   %rbp
  80171a:	48 89 e5             	mov    %rsp,%rbp
  80171d:	48 83 ec 30          	sub    $0x30,%rsp
  801721:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801724:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801728:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80172c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80172f:	48 89 d6             	mov    %rdx,%rsi
  801732:	89 c7                	mov    %eax,%edi
  801734:	48 b8 b8 0f 80 00 00 	movabs $0x800fb8,%rax
  80173b:	00 00 00 
  80173e:	ff d0                	callq  *%rax
  801740:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801743:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801747:	78 24                	js     80176d <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801749:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80174d:	8b 00                	mov    (%rax),%eax
  80174f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801753:	48 89 d6             	mov    %rdx,%rsi
  801756:	89 c7                	mov    %eax,%edi
  801758:	48 b8 11 11 80 00 00 	movabs $0x801111,%rax
  80175f:	00 00 00 
  801762:	ff d0                	callq  *%rax
  801764:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801767:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80176b:	79 05                	jns    801772 <fstat+0x59>
		return r;
  80176d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801770:	eb 5e                	jmp    8017d0 <fstat+0xb7>
	if (!dev->dev_stat)
  801772:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801776:	48 8b 40 28          	mov    0x28(%rax),%rax
  80177a:	48 85 c0             	test   %rax,%rax
  80177d:	75 07                	jne    801786 <fstat+0x6d>
		return -E_NOT_SUPP;
  80177f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801784:	eb 4a                	jmp    8017d0 <fstat+0xb7>
	stat->st_name[0] = 0;
  801786:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80178a:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80178d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801791:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  801798:	00 00 00 
	stat->st_isdir = 0;
  80179b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80179f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8017a6:	00 00 00 
	stat->st_dev = dev;
  8017a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017ad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017b1:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8017b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017bc:	48 8b 40 28          	mov    0x28(%rax),%rax
  8017c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017c4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017c8:	48 89 ce             	mov    %rcx,%rsi
  8017cb:	48 89 d7             	mov    %rdx,%rdi
  8017ce:	ff d0                	callq  *%rax
}
  8017d0:	c9                   	leaveq 
  8017d1:	c3                   	retq   

00000000008017d2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017d2:	55                   	push   %rbp
  8017d3:	48 89 e5             	mov    %rsp,%rbp
  8017d6:	48 83 ec 20          	sub    $0x20,%rsp
  8017da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017e6:	be 00 00 00 00       	mov    $0x0,%esi
  8017eb:	48 89 c7             	mov    %rax,%rdi
  8017ee:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  8017f5:	00 00 00 
  8017f8:	ff d0                	callq  *%rax
  8017fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8017fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801801:	79 05                	jns    801808 <stat+0x36>
		return fd;
  801803:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801806:	eb 2f                	jmp    801837 <stat+0x65>
	r = fstat(fd, stat);
  801808:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80180c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80180f:	48 89 d6             	mov    %rdx,%rsi
  801812:	89 c7                	mov    %eax,%edi
  801814:	48 b8 19 17 80 00 00 	movabs $0x801719,%rax
  80181b:	00 00 00 
  80181e:	ff d0                	callq  *%rax
  801820:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  801823:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801826:	89 c7                	mov    %eax,%edi
  801828:	48 b8 c8 11 80 00 00 	movabs $0x8011c8,%rax
  80182f:	00 00 00 
  801832:	ff d0                	callq  *%rax
	return r;
  801834:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  801837:	c9                   	leaveq 
  801838:	c3                   	retq   

0000000000801839 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801839:	55                   	push   %rbp
  80183a:	48 89 e5             	mov    %rsp,%rbp
  80183d:	48 83 ec 10          	sub    $0x10,%rsp
  801841:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801844:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  801848:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80184f:	00 00 00 
  801852:	8b 00                	mov    (%rax),%eax
  801854:	85 c0                	test   %eax,%eax
  801856:	75 1d                	jne    801875 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801858:	bf 01 00 00 00       	mov    $0x1,%edi
  80185d:	48 b8 48 3e 80 00 00 	movabs $0x803e48,%rax
  801864:	00 00 00 
  801867:	ff d0                	callq  *%rax
  801869:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  801870:	00 00 00 
  801873:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801875:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80187c:	00 00 00 
  80187f:	8b 00                	mov    (%rax),%eax
  801881:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801884:	b9 07 00 00 00       	mov    $0x7,%ecx
  801889:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  801890:	00 00 00 
  801893:	89 c7                	mov    %eax,%edi
  801895:	48 b8 e6 3d 80 00 00 	movabs $0x803de6,%rax
  80189c:	00 00 00 
  80189f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8018a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018aa:	48 89 c6             	mov    %rax,%rsi
  8018ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8018b2:	48 b8 e0 3c 80 00 00 	movabs $0x803ce0,%rax
  8018b9:	00 00 00 
  8018bc:	ff d0                	callq  *%rax
}
  8018be:	c9                   	leaveq 
  8018bf:	c3                   	retq   

00000000008018c0 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8018c0:	55                   	push   %rbp
  8018c1:	48 89 e5             	mov    %rsp,%rbp
  8018c4:	48 83 ec 30          	sub    $0x30,%rsp
  8018c8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018cc:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8018cf:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8018d6:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8018dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8018e4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8018e9:	75 08                	jne    8018f3 <open+0x33>
	{
		return r;
  8018eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ee:	e9 f2 00 00 00       	jmpq   8019e5 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8018f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f7:	48 89 c7             	mov    %rax,%rdi
  8018fa:	48 b8 00 02 80 00 00 	movabs $0x800200,%rax
  801901:	00 00 00 
  801904:	ff d0                	callq  *%rax
  801906:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801909:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  801910:	7e 0a                	jle    80191c <open+0x5c>
	{
		return -E_BAD_PATH;
  801912:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801917:	e9 c9 00 00 00       	jmpq   8019e5 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80191c:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801923:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  801924:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801928:	48 89 c7             	mov    %rax,%rdi
  80192b:	48 b8 20 0f 80 00 00 	movabs $0x800f20,%rax
  801932:	00 00 00 
  801935:	ff d0                	callq  *%rax
  801937:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80193a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80193e:	78 09                	js     801949 <open+0x89>
  801940:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801944:	48 85 c0             	test   %rax,%rax
  801947:	75 08                	jne    801951 <open+0x91>
		{
			return r;
  801949:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80194c:	e9 94 00 00 00       	jmpq   8019e5 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  801951:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801955:	ba 00 04 00 00       	mov    $0x400,%edx
  80195a:	48 89 c6             	mov    %rax,%rsi
  80195d:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  801964:	00 00 00 
  801967:	48 b8 fe 02 80 00 00 	movabs $0x8002fe,%rax
  80196e:	00 00 00 
  801971:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  801973:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80197a:	00 00 00 
  80197d:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  801980:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  801986:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80198a:	48 89 c6             	mov    %rax,%rsi
  80198d:	bf 01 00 00 00       	mov    $0x1,%edi
  801992:	48 b8 39 18 80 00 00 	movabs $0x801839,%rax
  801999:	00 00 00 
  80199c:	ff d0                	callq  *%rax
  80199e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8019a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019a5:	79 2b                	jns    8019d2 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8019a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019ab:	be 00 00 00 00       	mov    $0x0,%esi
  8019b0:	48 89 c7             	mov    %rax,%rdi
  8019b3:	48 b8 48 10 80 00 00 	movabs $0x801048,%rax
  8019ba:	00 00 00 
  8019bd:	ff d0                	callq  *%rax
  8019bf:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8019c2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8019c6:	79 05                	jns    8019cd <open+0x10d>
			{
				return d;
  8019c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019cb:	eb 18                	jmp    8019e5 <open+0x125>
			}
			return r;
  8019cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019d0:	eb 13                	jmp    8019e5 <open+0x125>
		}	
		return fd2num(fd_store);
  8019d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019d6:	48 89 c7             	mov    %rax,%rdi
  8019d9:	48 b8 d2 0e 80 00 00 	movabs $0x800ed2,%rax
  8019e0:	00 00 00 
  8019e3:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8019e5:	c9                   	leaveq 
  8019e6:	c3                   	retq   

00000000008019e7 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8019e7:	55                   	push   %rbp
  8019e8:	48 89 e5             	mov    %rsp,%rbp
  8019eb:	48 83 ec 10          	sub    $0x10,%rsp
  8019ef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019f7:	8b 50 0c             	mov    0xc(%rax),%edx
  8019fa:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801a01:	00 00 00 
  801a04:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801a06:	be 00 00 00 00       	mov    $0x0,%esi
  801a0b:	bf 06 00 00 00       	mov    $0x6,%edi
  801a10:	48 b8 39 18 80 00 00 	movabs $0x801839,%rax
  801a17:	00 00 00 
  801a1a:	ff d0                	callq  *%rax
}
  801a1c:	c9                   	leaveq 
  801a1d:	c3                   	retq   

0000000000801a1e <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a1e:	55                   	push   %rbp
  801a1f:	48 89 e5             	mov    %rsp,%rbp
  801a22:	48 83 ec 30          	sub    $0x30,%rsp
  801a26:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a2a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a2e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  801a32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  801a39:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a3e:	74 07                	je     801a47 <devfile_read+0x29>
  801a40:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801a45:	75 07                	jne    801a4e <devfile_read+0x30>
		return -E_INVAL;
  801a47:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a4c:	eb 77                	jmp    801ac5 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a52:	8b 50 0c             	mov    0xc(%rax),%edx
  801a55:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801a5c:	00 00 00 
  801a5f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801a61:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801a68:	00 00 00 
  801a6b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a6f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  801a73:	be 00 00 00 00       	mov    $0x0,%esi
  801a78:	bf 03 00 00 00       	mov    $0x3,%edi
  801a7d:	48 b8 39 18 80 00 00 	movabs $0x801839,%rax
  801a84:	00 00 00 
  801a87:	ff d0                	callq  *%rax
  801a89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a90:	7f 05                	jg     801a97 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  801a92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a95:	eb 2e                	jmp    801ac5 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  801a97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a9a:	48 63 d0             	movslq %eax,%rdx
  801a9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801aa1:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801aa8:	00 00 00 
  801aab:	48 89 c7             	mov    %rax,%rdi
  801aae:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  801ab5:	00 00 00 
  801ab8:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  801aba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801abe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  801ac2:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  801ac5:	c9                   	leaveq 
  801ac6:	c3                   	retq   

0000000000801ac7 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801ac7:	55                   	push   %rbp
  801ac8:	48 89 e5             	mov    %rsp,%rbp
  801acb:	48 83 ec 30          	sub    $0x30,%rsp
  801acf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ad3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801ad7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  801adb:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  801ae2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ae7:	74 07                	je     801af0 <devfile_write+0x29>
  801ae9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801aee:	75 08                	jne    801af8 <devfile_write+0x31>
		return r;
  801af0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af3:	e9 9a 00 00 00       	jmpq   801b92 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801af8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801afc:	8b 50 0c             	mov    0xc(%rax),%edx
  801aff:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801b06:	00 00 00 
  801b09:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  801b0b:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  801b12:	00 
  801b13:	76 08                	jbe    801b1d <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  801b15:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  801b1c:	00 
	}
	fsipcbuf.write.req_n = n;
  801b1d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801b24:	00 00 00 
  801b27:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801b2b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  801b2f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801b33:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b37:	48 89 c6             	mov    %rax,%rsi
  801b3a:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  801b41:	00 00 00 
  801b44:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  801b4b:	00 00 00 
  801b4e:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  801b50:	be 00 00 00 00       	mov    $0x0,%esi
  801b55:	bf 04 00 00 00       	mov    $0x4,%edi
  801b5a:	48 b8 39 18 80 00 00 	movabs $0x801839,%rax
  801b61:	00 00 00 
  801b64:	ff d0                	callq  *%rax
  801b66:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b6d:	7f 20                	jg     801b8f <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  801b6f:	48 bf 1e 40 80 00 00 	movabs $0x80401e,%rdi
  801b76:	00 00 00 
  801b79:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7e:	48 ba 97 31 80 00 00 	movabs $0x803197,%rdx
  801b85:	00 00 00 
  801b88:	ff d2                	callq  *%rdx
		return r;
  801b8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b8d:	eb 03                	jmp    801b92 <devfile_write+0xcb>
	}
	return r;
  801b8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  801b92:	c9                   	leaveq 
  801b93:	c3                   	retq   

0000000000801b94 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b94:	55                   	push   %rbp
  801b95:	48 89 e5             	mov    %rsp,%rbp
  801b98:	48 83 ec 20          	sub    $0x20,%rsp
  801b9c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ba0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ba4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ba8:	8b 50 0c             	mov    0xc(%rax),%edx
  801bab:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801bb2:	00 00 00 
  801bb5:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bb7:	be 00 00 00 00       	mov    $0x0,%esi
  801bbc:	bf 05 00 00 00       	mov    $0x5,%edi
  801bc1:	48 b8 39 18 80 00 00 	movabs $0x801839,%rax
  801bc8:	00 00 00 
  801bcb:	ff d0                	callq  *%rax
  801bcd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bd0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bd4:	79 05                	jns    801bdb <devfile_stat+0x47>
		return r;
  801bd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bd9:	eb 56                	jmp    801c31 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bdb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bdf:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801be6:	00 00 00 
  801be9:	48 89 c7             	mov    %rax,%rdi
  801bec:	48 b8 6c 02 80 00 00 	movabs $0x80026c,%rax
  801bf3:	00 00 00 
  801bf6:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801bf8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801bff:	00 00 00 
  801c02:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801c08:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c0c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c12:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801c19:	00 00 00 
  801c1c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801c22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c26:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801c2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c31:	c9                   	leaveq 
  801c32:	c3                   	retq   

0000000000801c33 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c33:	55                   	push   %rbp
  801c34:	48 89 e5             	mov    %rsp,%rbp
  801c37:	48 83 ec 10          	sub    $0x10,%rsp
  801c3b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c3f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c46:	8b 50 0c             	mov    0xc(%rax),%edx
  801c49:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801c50:	00 00 00 
  801c53:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801c55:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801c5c:	00 00 00 
  801c5f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801c62:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c65:	be 00 00 00 00       	mov    $0x0,%esi
  801c6a:	bf 02 00 00 00       	mov    $0x2,%edi
  801c6f:	48 b8 39 18 80 00 00 	movabs $0x801839,%rax
  801c76:	00 00 00 
  801c79:	ff d0                	callq  *%rax
}
  801c7b:	c9                   	leaveq 
  801c7c:	c3                   	retq   

0000000000801c7d <remove>:

// Delete a file
int
remove(const char *path)
{
  801c7d:	55                   	push   %rbp
  801c7e:	48 89 e5             	mov    %rsp,%rbp
  801c81:	48 83 ec 10          	sub    $0x10,%rsp
  801c85:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801c89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c8d:	48 89 c7             	mov    %rax,%rdi
  801c90:	48 b8 00 02 80 00 00 	movabs $0x800200,%rax
  801c97:	00 00 00 
  801c9a:	ff d0                	callq  *%rax
  801c9c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ca1:	7e 07                	jle    801caa <remove+0x2d>
		return -E_BAD_PATH;
  801ca3:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801ca8:	eb 33                	jmp    801cdd <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801caa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cae:	48 89 c6             	mov    %rax,%rsi
  801cb1:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  801cb8:	00 00 00 
  801cbb:	48 b8 6c 02 80 00 00 	movabs $0x80026c,%rax
  801cc2:	00 00 00 
  801cc5:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801cc7:	be 00 00 00 00       	mov    $0x0,%esi
  801ccc:	bf 07 00 00 00       	mov    $0x7,%edi
  801cd1:	48 b8 39 18 80 00 00 	movabs $0x801839,%rax
  801cd8:	00 00 00 
  801cdb:	ff d0                	callq  *%rax
}
  801cdd:	c9                   	leaveq 
  801cde:	c3                   	retq   

0000000000801cdf <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801cdf:	55                   	push   %rbp
  801ce0:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ce3:	be 00 00 00 00       	mov    $0x0,%esi
  801ce8:	bf 08 00 00 00       	mov    $0x8,%edi
  801ced:	48 b8 39 18 80 00 00 	movabs $0x801839,%rax
  801cf4:	00 00 00 
  801cf7:	ff d0                	callq  *%rax
}
  801cf9:	5d                   	pop    %rbp
  801cfa:	c3                   	retq   

0000000000801cfb <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  801cfb:	55                   	push   %rbp
  801cfc:	48 89 e5             	mov    %rsp,%rbp
  801cff:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  801d06:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  801d0d:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  801d14:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  801d1b:	be 00 00 00 00       	mov    $0x0,%esi
  801d20:	48 89 c7             	mov    %rax,%rdi
  801d23:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801d2a:	00 00 00 
  801d2d:	ff d0                	callq  *%rax
  801d2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  801d32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d36:	79 28                	jns    801d60 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801d38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d3b:	89 c6                	mov    %eax,%esi
  801d3d:	48 bf 3a 40 80 00 00 	movabs $0x80403a,%rdi
  801d44:	00 00 00 
  801d47:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4c:	48 ba 97 31 80 00 00 	movabs $0x803197,%rdx
  801d53:	00 00 00 
  801d56:	ff d2                	callq  *%rdx
		return fd_src;
  801d58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d5b:	e9 74 01 00 00       	jmpq   801ed4 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  801d60:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  801d67:	be 01 01 00 00       	mov    $0x101,%esi
  801d6c:	48 89 c7             	mov    %rax,%rdi
  801d6f:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801d76:	00 00 00 
  801d79:	ff d0                	callq  *%rax
  801d7b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  801d7e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801d82:	79 39                	jns    801dbd <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  801d84:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d87:	89 c6                	mov    %eax,%esi
  801d89:	48 bf 50 40 80 00 00 	movabs $0x804050,%rdi
  801d90:	00 00 00 
  801d93:	b8 00 00 00 00       	mov    $0x0,%eax
  801d98:	48 ba 97 31 80 00 00 	movabs $0x803197,%rdx
  801d9f:	00 00 00 
  801da2:	ff d2                	callq  *%rdx
		close(fd_src);
  801da4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801da7:	89 c7                	mov    %eax,%edi
  801da9:	48 b8 c8 11 80 00 00 	movabs $0x8011c8,%rax
  801db0:	00 00 00 
  801db3:	ff d0                	callq  *%rax
		return fd_dest;
  801db5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801db8:	e9 17 01 00 00       	jmpq   801ed4 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801dbd:	eb 74                	jmp    801e33 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  801dbf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801dc2:	48 63 d0             	movslq %eax,%rdx
  801dc5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801dcc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dcf:	48 89 ce             	mov    %rcx,%rsi
  801dd2:	89 c7                	mov    %eax,%edi
  801dd4:	48 b8 34 15 80 00 00 	movabs $0x801534,%rax
  801ddb:	00 00 00 
  801dde:	ff d0                	callq  *%rax
  801de0:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  801de3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801de7:	79 4a                	jns    801e33 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  801de9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801dec:	89 c6                	mov    %eax,%esi
  801dee:	48 bf 6a 40 80 00 00 	movabs $0x80406a,%rdi
  801df5:	00 00 00 
  801df8:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfd:	48 ba 97 31 80 00 00 	movabs $0x803197,%rdx
  801e04:	00 00 00 
  801e07:	ff d2                	callq  *%rdx
			close(fd_src);
  801e09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e0c:	89 c7                	mov    %eax,%edi
  801e0e:	48 b8 c8 11 80 00 00 	movabs $0x8011c8,%rax
  801e15:	00 00 00 
  801e18:	ff d0                	callq  *%rax
			close(fd_dest);
  801e1a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e1d:	89 c7                	mov    %eax,%edi
  801e1f:	48 b8 c8 11 80 00 00 	movabs $0x8011c8,%rax
  801e26:	00 00 00 
  801e29:	ff d0                	callq  *%rax
			return write_size;
  801e2b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801e2e:	e9 a1 00 00 00       	jmpq   801ed4 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801e33:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801e3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e3d:	ba 00 02 00 00       	mov    $0x200,%edx
  801e42:	48 89 ce             	mov    %rcx,%rsi
  801e45:	89 c7                	mov    %eax,%edi
  801e47:	48 b8 ea 13 80 00 00 	movabs $0x8013ea,%rax
  801e4e:	00 00 00 
  801e51:	ff d0                	callq  *%rax
  801e53:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801e56:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e5a:	0f 8f 5f ff ff ff    	jg     801dbf <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  801e60:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e64:	79 47                	jns    801ead <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  801e66:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e69:	89 c6                	mov    %eax,%esi
  801e6b:	48 bf 7d 40 80 00 00 	movabs $0x80407d,%rdi
  801e72:	00 00 00 
  801e75:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7a:	48 ba 97 31 80 00 00 	movabs $0x803197,%rdx
  801e81:	00 00 00 
  801e84:	ff d2                	callq  *%rdx
		close(fd_src);
  801e86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e89:	89 c7                	mov    %eax,%edi
  801e8b:	48 b8 c8 11 80 00 00 	movabs $0x8011c8,%rax
  801e92:	00 00 00 
  801e95:	ff d0                	callq  *%rax
		close(fd_dest);
  801e97:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e9a:	89 c7                	mov    %eax,%edi
  801e9c:	48 b8 c8 11 80 00 00 	movabs $0x8011c8,%rax
  801ea3:	00 00 00 
  801ea6:	ff d0                	callq  *%rax
		return read_size;
  801ea8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801eab:	eb 27                	jmp    801ed4 <copy+0x1d9>
	}
	close(fd_src);
  801ead:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eb0:	89 c7                	mov    %eax,%edi
  801eb2:	48 b8 c8 11 80 00 00 	movabs $0x8011c8,%rax
  801eb9:	00 00 00 
  801ebc:	ff d0                	callq  *%rax
	close(fd_dest);
  801ebe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ec1:	89 c7                	mov    %eax,%edi
  801ec3:	48 b8 c8 11 80 00 00 	movabs $0x8011c8,%rax
  801eca:	00 00 00 
  801ecd:	ff d0                	callq  *%rax
	return 0;
  801ecf:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  801ed4:	c9                   	leaveq 
  801ed5:	c3                   	retq   

0000000000801ed6 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801ed6:	55                   	push   %rbp
  801ed7:	48 89 e5             	mov    %rsp,%rbp
  801eda:	48 83 ec 20          	sub    $0x20,%rsp
  801ede:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ee1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ee5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ee8:	48 89 d6             	mov    %rdx,%rsi
  801eeb:	89 c7                	mov    %eax,%edi
  801eed:	48 b8 b8 0f 80 00 00 	movabs $0x800fb8,%rax
  801ef4:	00 00 00 
  801ef7:	ff d0                	callq  *%rax
  801ef9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801efc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f00:	79 05                	jns    801f07 <fd2sockid+0x31>
		return r;
  801f02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f05:	eb 24                	jmp    801f2b <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f0b:	8b 10                	mov    (%rax),%edx
  801f0d:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  801f14:	00 00 00 
  801f17:	8b 00                	mov    (%rax),%eax
  801f19:	39 c2                	cmp    %eax,%edx
  801f1b:	74 07                	je     801f24 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  801f1d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801f22:	eb 07                	jmp    801f2b <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  801f24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f28:	8b 40 0c             	mov    0xc(%rax),%eax
}
  801f2b:	c9                   	leaveq 
  801f2c:	c3                   	retq   

0000000000801f2d <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801f2d:	55                   	push   %rbp
  801f2e:	48 89 e5             	mov    %rsp,%rbp
  801f31:	48 83 ec 20          	sub    $0x20,%rsp
  801f35:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f38:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801f3c:	48 89 c7             	mov    %rax,%rdi
  801f3f:	48 b8 20 0f 80 00 00 	movabs $0x800f20,%rax
  801f46:	00 00 00 
  801f49:	ff d0                	callq  *%rax
  801f4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f52:	78 26                	js     801f7a <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f58:	ba 07 04 00 00       	mov    $0x407,%edx
  801f5d:	48 89 c6             	mov    %rax,%rsi
  801f60:	bf 00 00 00 00       	mov    $0x0,%edi
  801f65:	48 b8 9b 0b 80 00 00 	movabs $0x800b9b,%rax
  801f6c:	00 00 00 
  801f6f:	ff d0                	callq  *%rax
  801f71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f78:	79 16                	jns    801f90 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  801f7a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f7d:	89 c7                	mov    %eax,%edi
  801f7f:	48 b8 3a 24 80 00 00 	movabs $0x80243a,%rax
  801f86:	00 00 00 
  801f89:	ff d0                	callq  *%rax
		return r;
  801f8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f8e:	eb 3a                	jmp    801fca <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801f90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f94:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  801f9b:	00 00 00 
  801f9e:	8b 12                	mov    (%rdx),%edx
  801fa0:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  801fa2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fa6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  801fad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fb1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fb4:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  801fb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fbb:	48 89 c7             	mov    %rax,%rdi
  801fbe:	48 b8 d2 0e 80 00 00 	movabs $0x800ed2,%rax
  801fc5:	00 00 00 
  801fc8:	ff d0                	callq  *%rax
}
  801fca:	c9                   	leaveq 
  801fcb:	c3                   	retq   

0000000000801fcc <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fcc:	55                   	push   %rbp
  801fcd:	48 89 e5             	mov    %rsp,%rbp
  801fd0:	48 83 ec 30          	sub    $0x30,%rsp
  801fd4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fd7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801fdb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fdf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fe2:	89 c7                	mov    %eax,%edi
  801fe4:	48 b8 d6 1e 80 00 00 	movabs $0x801ed6,%rax
  801feb:	00 00 00 
  801fee:	ff d0                	callq  *%rax
  801ff0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ff3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ff7:	79 05                	jns    801ffe <accept+0x32>
		return r;
  801ff9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ffc:	eb 3b                	jmp    802039 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ffe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802002:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802006:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802009:	48 89 ce             	mov    %rcx,%rsi
  80200c:	89 c7                	mov    %eax,%edi
  80200e:	48 b8 17 23 80 00 00 	movabs $0x802317,%rax
  802015:	00 00 00 
  802018:	ff d0                	callq  *%rax
  80201a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80201d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802021:	79 05                	jns    802028 <accept+0x5c>
		return r;
  802023:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802026:	eb 11                	jmp    802039 <accept+0x6d>
	return alloc_sockfd(r);
  802028:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80202b:	89 c7                	mov    %eax,%edi
  80202d:	48 b8 2d 1f 80 00 00 	movabs $0x801f2d,%rax
  802034:	00 00 00 
  802037:	ff d0                	callq  *%rax
}
  802039:	c9                   	leaveq 
  80203a:	c3                   	retq   

000000000080203b <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80203b:	55                   	push   %rbp
  80203c:	48 89 e5             	mov    %rsp,%rbp
  80203f:	48 83 ec 20          	sub    $0x20,%rsp
  802043:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802046:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80204a:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80204d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802050:	89 c7                	mov    %eax,%edi
  802052:	48 b8 d6 1e 80 00 00 	movabs $0x801ed6,%rax
  802059:	00 00 00 
  80205c:	ff d0                	callq  *%rax
  80205e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802061:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802065:	79 05                	jns    80206c <bind+0x31>
		return r;
  802067:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80206a:	eb 1b                	jmp    802087 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80206c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80206f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802073:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802076:	48 89 ce             	mov    %rcx,%rsi
  802079:	89 c7                	mov    %eax,%edi
  80207b:	48 b8 96 23 80 00 00 	movabs $0x802396,%rax
  802082:	00 00 00 
  802085:	ff d0                	callq  *%rax
}
  802087:	c9                   	leaveq 
  802088:	c3                   	retq   

0000000000802089 <shutdown>:

int
shutdown(int s, int how)
{
  802089:	55                   	push   %rbp
  80208a:	48 89 e5             	mov    %rsp,%rbp
  80208d:	48 83 ec 20          	sub    $0x20,%rsp
  802091:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802094:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802097:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80209a:	89 c7                	mov    %eax,%edi
  80209c:	48 b8 d6 1e 80 00 00 	movabs $0x801ed6,%rax
  8020a3:	00 00 00 
  8020a6:	ff d0                	callq  *%rax
  8020a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020af:	79 05                	jns    8020b6 <shutdown+0x2d>
		return r;
  8020b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020b4:	eb 16                	jmp    8020cc <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8020b6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8020b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020bc:	89 d6                	mov    %edx,%esi
  8020be:	89 c7                	mov    %eax,%edi
  8020c0:	48 b8 fa 23 80 00 00 	movabs $0x8023fa,%rax
  8020c7:	00 00 00 
  8020ca:	ff d0                	callq  *%rax
}
  8020cc:	c9                   	leaveq 
  8020cd:	c3                   	retq   

00000000008020ce <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8020ce:	55                   	push   %rbp
  8020cf:	48 89 e5             	mov    %rsp,%rbp
  8020d2:	48 83 ec 10          	sub    $0x10,%rsp
  8020d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8020da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020de:	48 89 c7             	mov    %rax,%rdi
  8020e1:	48 b8 ca 3e 80 00 00 	movabs $0x803eca,%rax
  8020e8:	00 00 00 
  8020eb:	ff d0                	callq  *%rax
  8020ed:	83 f8 01             	cmp    $0x1,%eax
  8020f0:	75 17                	jne    802109 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8020f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020f6:	8b 40 0c             	mov    0xc(%rax),%eax
  8020f9:	89 c7                	mov    %eax,%edi
  8020fb:	48 b8 3a 24 80 00 00 	movabs $0x80243a,%rax
  802102:	00 00 00 
  802105:	ff d0                	callq  *%rax
  802107:	eb 05                	jmp    80210e <devsock_close+0x40>
	else
		return 0;
  802109:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80210e:	c9                   	leaveq 
  80210f:	c3                   	retq   

0000000000802110 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802110:	55                   	push   %rbp
  802111:	48 89 e5             	mov    %rsp,%rbp
  802114:	48 83 ec 20          	sub    $0x20,%rsp
  802118:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80211b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80211f:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802122:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802125:	89 c7                	mov    %eax,%edi
  802127:	48 b8 d6 1e 80 00 00 	movabs $0x801ed6,%rax
  80212e:	00 00 00 
  802131:	ff d0                	callq  *%rax
  802133:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802136:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80213a:	79 05                	jns    802141 <connect+0x31>
		return r;
  80213c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80213f:	eb 1b                	jmp    80215c <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802141:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802144:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802148:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80214b:	48 89 ce             	mov    %rcx,%rsi
  80214e:	89 c7                	mov    %eax,%edi
  802150:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  802157:	00 00 00 
  80215a:	ff d0                	callq  *%rax
}
  80215c:	c9                   	leaveq 
  80215d:	c3                   	retq   

000000000080215e <listen>:

int
listen(int s, int backlog)
{
  80215e:	55                   	push   %rbp
  80215f:	48 89 e5             	mov    %rsp,%rbp
  802162:	48 83 ec 20          	sub    $0x20,%rsp
  802166:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802169:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80216c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80216f:	89 c7                	mov    %eax,%edi
  802171:	48 b8 d6 1e 80 00 00 	movabs $0x801ed6,%rax
  802178:	00 00 00 
  80217b:	ff d0                	callq  *%rax
  80217d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802180:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802184:	79 05                	jns    80218b <listen+0x2d>
		return r;
  802186:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802189:	eb 16                	jmp    8021a1 <listen+0x43>
	return nsipc_listen(r, backlog);
  80218b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80218e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802191:	89 d6                	mov    %edx,%esi
  802193:	89 c7                	mov    %eax,%edi
  802195:	48 b8 cb 24 80 00 00 	movabs $0x8024cb,%rax
  80219c:	00 00 00 
  80219f:	ff d0                	callq  *%rax
}
  8021a1:	c9                   	leaveq 
  8021a2:	c3                   	retq   

00000000008021a3 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8021a3:	55                   	push   %rbp
  8021a4:	48 89 e5             	mov    %rsp,%rbp
  8021a7:	48 83 ec 20          	sub    $0x20,%rsp
  8021ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8021af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8021b3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8021b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021bb:	89 c2                	mov    %eax,%edx
  8021bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021c1:	8b 40 0c             	mov    0xc(%rax),%eax
  8021c4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8021c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021cd:	89 c7                	mov    %eax,%edi
  8021cf:	48 b8 0b 25 80 00 00 	movabs $0x80250b,%rax
  8021d6:	00 00 00 
  8021d9:	ff d0                	callq  *%rax
}
  8021db:	c9                   	leaveq 
  8021dc:	c3                   	retq   

00000000008021dd <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8021dd:	55                   	push   %rbp
  8021de:	48 89 e5             	mov    %rsp,%rbp
  8021e1:	48 83 ec 20          	sub    $0x20,%rsp
  8021e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8021e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8021ed:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8021f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f5:	89 c2                	mov    %eax,%edx
  8021f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021fb:	8b 40 0c             	mov    0xc(%rax),%eax
  8021fe:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802202:	b9 00 00 00 00       	mov    $0x0,%ecx
  802207:	89 c7                	mov    %eax,%edi
  802209:	48 b8 d7 25 80 00 00 	movabs $0x8025d7,%rax
  802210:	00 00 00 
  802213:	ff d0                	callq  *%rax
}
  802215:	c9                   	leaveq 
  802216:	c3                   	retq   

0000000000802217 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802217:	55                   	push   %rbp
  802218:	48 89 e5             	mov    %rsp,%rbp
  80221b:	48 83 ec 10          	sub    $0x10,%rsp
  80221f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802223:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802227:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80222b:	48 be 98 40 80 00 00 	movabs $0x804098,%rsi
  802232:	00 00 00 
  802235:	48 89 c7             	mov    %rax,%rdi
  802238:	48 b8 6c 02 80 00 00 	movabs $0x80026c,%rax
  80223f:	00 00 00 
  802242:	ff d0                	callq  *%rax
	return 0;
  802244:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802249:	c9                   	leaveq 
  80224a:	c3                   	retq   

000000000080224b <socket>:

int
socket(int domain, int type, int protocol)
{
  80224b:	55                   	push   %rbp
  80224c:	48 89 e5             	mov    %rsp,%rbp
  80224f:	48 83 ec 20          	sub    $0x20,%rsp
  802253:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802256:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802259:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80225c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80225f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802262:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802265:	89 ce                	mov    %ecx,%esi
  802267:	89 c7                	mov    %eax,%edi
  802269:	48 b8 8f 26 80 00 00 	movabs $0x80268f,%rax
  802270:	00 00 00 
  802273:	ff d0                	callq  *%rax
  802275:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802278:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80227c:	79 05                	jns    802283 <socket+0x38>
		return r;
  80227e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802281:	eb 11                	jmp    802294 <socket+0x49>
	return alloc_sockfd(r);
  802283:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802286:	89 c7                	mov    %eax,%edi
  802288:	48 b8 2d 1f 80 00 00 	movabs $0x801f2d,%rax
  80228f:	00 00 00 
  802292:	ff d0                	callq  *%rax
}
  802294:	c9                   	leaveq 
  802295:	c3                   	retq   

0000000000802296 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802296:	55                   	push   %rbp
  802297:	48 89 e5             	mov    %rsp,%rbp
  80229a:	48 83 ec 10          	sub    $0x10,%rsp
  80229e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8022a1:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8022a8:	00 00 00 
  8022ab:	8b 00                	mov    (%rax),%eax
  8022ad:	85 c0                	test   %eax,%eax
  8022af:	75 1d                	jne    8022ce <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8022b1:	bf 02 00 00 00       	mov    $0x2,%edi
  8022b6:	48 b8 48 3e 80 00 00 	movabs $0x803e48,%rax
  8022bd:	00 00 00 
  8022c0:	ff d0                	callq  *%rax
  8022c2:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  8022c9:	00 00 00 
  8022cc:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022ce:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8022d5:	00 00 00 
  8022d8:	8b 00                	mov    (%rax),%eax
  8022da:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8022dd:	b9 07 00 00 00       	mov    $0x7,%ecx
  8022e2:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8022e9:	00 00 00 
  8022ec:	89 c7                	mov    %eax,%edi
  8022ee:	48 b8 e6 3d 80 00 00 	movabs $0x803de6,%rax
  8022f5:	00 00 00 
  8022f8:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8022fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8022ff:	be 00 00 00 00       	mov    $0x0,%esi
  802304:	bf 00 00 00 00       	mov    $0x0,%edi
  802309:	48 b8 e0 3c 80 00 00 	movabs $0x803ce0,%rax
  802310:	00 00 00 
  802313:	ff d0                	callq  *%rax
}
  802315:	c9                   	leaveq 
  802316:	c3                   	retq   

0000000000802317 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802317:	55                   	push   %rbp
  802318:	48 89 e5             	mov    %rsp,%rbp
  80231b:	48 83 ec 30          	sub    $0x30,%rsp
  80231f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802322:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802326:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80232a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802331:	00 00 00 
  802334:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802337:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802339:	bf 01 00 00 00       	mov    $0x1,%edi
  80233e:	48 b8 96 22 80 00 00 	movabs $0x802296,%rax
  802345:	00 00 00 
  802348:	ff d0                	callq  *%rax
  80234a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80234d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802351:	78 3e                	js     802391 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802353:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80235a:	00 00 00 
  80235d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802361:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802365:	8b 40 10             	mov    0x10(%rax),%eax
  802368:	89 c2                	mov    %eax,%edx
  80236a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80236e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802372:	48 89 ce             	mov    %rcx,%rsi
  802375:	48 89 c7             	mov    %rax,%rdi
  802378:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  80237f:	00 00 00 
  802382:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802384:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802388:	8b 50 10             	mov    0x10(%rax),%edx
  80238b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80238f:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802391:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802394:	c9                   	leaveq 
  802395:	c3                   	retq   

0000000000802396 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802396:	55                   	push   %rbp
  802397:	48 89 e5             	mov    %rsp,%rbp
  80239a:	48 83 ec 10          	sub    $0x10,%rsp
  80239e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8023a5:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8023a8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8023af:	00 00 00 
  8023b2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023b5:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8023b7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8023ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023be:	48 89 c6             	mov    %rax,%rsi
  8023c1:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8023c8:	00 00 00 
  8023cb:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  8023d2:	00 00 00 
  8023d5:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8023d7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8023de:	00 00 00 
  8023e1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8023e4:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8023e7:	bf 02 00 00 00       	mov    $0x2,%edi
  8023ec:	48 b8 96 22 80 00 00 	movabs $0x802296,%rax
  8023f3:	00 00 00 
  8023f6:	ff d0                	callq  *%rax
}
  8023f8:	c9                   	leaveq 
  8023f9:	c3                   	retq   

00000000008023fa <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8023fa:	55                   	push   %rbp
  8023fb:	48 89 e5             	mov    %rsp,%rbp
  8023fe:	48 83 ec 10          	sub    $0x10,%rsp
  802402:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802405:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  802408:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80240f:	00 00 00 
  802412:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802415:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  802417:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80241e:	00 00 00 
  802421:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802424:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  802427:	bf 03 00 00 00       	mov    $0x3,%edi
  80242c:	48 b8 96 22 80 00 00 	movabs $0x802296,%rax
  802433:	00 00 00 
  802436:	ff d0                	callq  *%rax
}
  802438:	c9                   	leaveq 
  802439:	c3                   	retq   

000000000080243a <nsipc_close>:

int
nsipc_close(int s)
{
  80243a:	55                   	push   %rbp
  80243b:	48 89 e5             	mov    %rsp,%rbp
  80243e:	48 83 ec 10          	sub    $0x10,%rsp
  802442:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  802445:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80244c:	00 00 00 
  80244f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802452:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  802454:	bf 04 00 00 00       	mov    $0x4,%edi
  802459:	48 b8 96 22 80 00 00 	movabs $0x802296,%rax
  802460:	00 00 00 
  802463:	ff d0                	callq  *%rax
}
  802465:	c9                   	leaveq 
  802466:	c3                   	retq   

0000000000802467 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802467:	55                   	push   %rbp
  802468:	48 89 e5             	mov    %rsp,%rbp
  80246b:	48 83 ec 10          	sub    $0x10,%rsp
  80246f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802472:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802476:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  802479:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802480:	00 00 00 
  802483:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802486:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802488:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80248b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80248f:	48 89 c6             	mov    %rax,%rsi
  802492:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802499:	00 00 00 
  80249c:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  8024a3:	00 00 00 
  8024a6:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8024a8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8024af:	00 00 00 
  8024b2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8024b5:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8024b8:	bf 05 00 00 00       	mov    $0x5,%edi
  8024bd:	48 b8 96 22 80 00 00 	movabs $0x802296,%rax
  8024c4:	00 00 00 
  8024c7:	ff d0                	callq  *%rax
}
  8024c9:	c9                   	leaveq 
  8024ca:	c3                   	retq   

00000000008024cb <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8024cb:	55                   	push   %rbp
  8024cc:	48 89 e5             	mov    %rsp,%rbp
  8024cf:	48 83 ec 10          	sub    $0x10,%rsp
  8024d3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024d6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8024d9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8024e0:	00 00 00 
  8024e3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024e6:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8024e8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8024ef:	00 00 00 
  8024f2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8024f5:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8024f8:	bf 06 00 00 00       	mov    $0x6,%edi
  8024fd:	48 b8 96 22 80 00 00 	movabs $0x802296,%rax
  802504:	00 00 00 
  802507:	ff d0                	callq  *%rax
}
  802509:	c9                   	leaveq 
  80250a:	c3                   	retq   

000000000080250b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80250b:	55                   	push   %rbp
  80250c:	48 89 e5             	mov    %rsp,%rbp
  80250f:	48 83 ec 30          	sub    $0x30,%rsp
  802513:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802516:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80251a:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80251d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  802520:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802527:	00 00 00 
  80252a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80252d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80252f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802536:	00 00 00 
  802539:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80253c:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80253f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802546:	00 00 00 
  802549:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80254c:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80254f:	bf 07 00 00 00       	mov    $0x7,%edi
  802554:	48 b8 96 22 80 00 00 	movabs $0x802296,%rax
  80255b:	00 00 00 
  80255e:	ff d0                	callq  *%rax
  802560:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802563:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802567:	78 69                	js     8025d2 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  802569:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  802570:	7f 08                	jg     80257a <nsipc_recv+0x6f>
  802572:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802575:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  802578:	7e 35                	jle    8025af <nsipc_recv+0xa4>
  80257a:	48 b9 9f 40 80 00 00 	movabs $0x80409f,%rcx
  802581:	00 00 00 
  802584:	48 ba b4 40 80 00 00 	movabs $0x8040b4,%rdx
  80258b:	00 00 00 
  80258e:	be 61 00 00 00       	mov    $0x61,%esi
  802593:	48 bf c9 40 80 00 00 	movabs $0x8040c9,%rdi
  80259a:	00 00 00 
  80259d:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a2:	49 b8 5e 2f 80 00 00 	movabs $0x802f5e,%r8
  8025a9:	00 00 00 
  8025ac:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8025af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b2:	48 63 d0             	movslq %eax,%rdx
  8025b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025b9:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8025c0:	00 00 00 
  8025c3:	48 89 c7             	mov    %rax,%rdi
  8025c6:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  8025cd:	00 00 00 
  8025d0:	ff d0                	callq  *%rax
	}

	return r;
  8025d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025d5:	c9                   	leaveq 
  8025d6:	c3                   	retq   

00000000008025d7 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8025d7:	55                   	push   %rbp
  8025d8:	48 89 e5             	mov    %rsp,%rbp
  8025db:	48 83 ec 20          	sub    $0x20,%rsp
  8025df:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8025e6:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8025e9:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8025ec:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8025f3:	00 00 00 
  8025f6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025f9:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8025fb:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  802602:	7e 35                	jle    802639 <nsipc_send+0x62>
  802604:	48 b9 d5 40 80 00 00 	movabs $0x8040d5,%rcx
  80260b:	00 00 00 
  80260e:	48 ba b4 40 80 00 00 	movabs $0x8040b4,%rdx
  802615:	00 00 00 
  802618:	be 6c 00 00 00       	mov    $0x6c,%esi
  80261d:	48 bf c9 40 80 00 00 	movabs $0x8040c9,%rdi
  802624:	00 00 00 
  802627:	b8 00 00 00 00       	mov    $0x0,%eax
  80262c:	49 b8 5e 2f 80 00 00 	movabs $0x802f5e,%r8
  802633:	00 00 00 
  802636:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802639:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80263c:	48 63 d0             	movslq %eax,%rdx
  80263f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802643:	48 89 c6             	mov    %rax,%rsi
  802646:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80264d:	00 00 00 
  802650:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  802657:	00 00 00 
  80265a:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80265c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802663:	00 00 00 
  802666:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802669:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80266c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802673:	00 00 00 
  802676:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802679:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80267c:	bf 08 00 00 00       	mov    $0x8,%edi
  802681:	48 b8 96 22 80 00 00 	movabs $0x802296,%rax
  802688:	00 00 00 
  80268b:	ff d0                	callq  *%rax
}
  80268d:	c9                   	leaveq 
  80268e:	c3                   	retq   

000000000080268f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80268f:	55                   	push   %rbp
  802690:	48 89 e5             	mov    %rsp,%rbp
  802693:	48 83 ec 10          	sub    $0x10,%rsp
  802697:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80269a:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80269d:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8026a0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8026a7:	00 00 00 
  8026aa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026ad:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8026af:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8026b6:	00 00 00 
  8026b9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8026bc:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8026bf:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8026c6:	00 00 00 
  8026c9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8026cc:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8026cf:	bf 09 00 00 00       	mov    $0x9,%edi
  8026d4:	48 b8 96 22 80 00 00 	movabs $0x802296,%rax
  8026db:	00 00 00 
  8026de:	ff d0                	callq  *%rax
}
  8026e0:	c9                   	leaveq 
  8026e1:	c3                   	retq   

00000000008026e2 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8026e2:	55                   	push   %rbp
  8026e3:	48 89 e5             	mov    %rsp,%rbp
  8026e6:	53                   	push   %rbx
  8026e7:	48 83 ec 38          	sub    $0x38,%rsp
  8026eb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8026ef:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8026f3:	48 89 c7             	mov    %rax,%rdi
  8026f6:	48 b8 20 0f 80 00 00 	movabs $0x800f20,%rax
  8026fd:	00 00 00 
  802700:	ff d0                	callq  *%rax
  802702:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802705:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802709:	0f 88 bf 01 00 00    	js     8028ce <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80270f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802713:	ba 07 04 00 00       	mov    $0x407,%edx
  802718:	48 89 c6             	mov    %rax,%rsi
  80271b:	bf 00 00 00 00       	mov    $0x0,%edi
  802720:	48 b8 9b 0b 80 00 00 	movabs $0x800b9b,%rax
  802727:	00 00 00 
  80272a:	ff d0                	callq  *%rax
  80272c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80272f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802733:	0f 88 95 01 00 00    	js     8028ce <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802739:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80273d:	48 89 c7             	mov    %rax,%rdi
  802740:	48 b8 20 0f 80 00 00 	movabs $0x800f20,%rax
  802747:	00 00 00 
  80274a:	ff d0                	callq  *%rax
  80274c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80274f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802753:	0f 88 5d 01 00 00    	js     8028b6 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802759:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80275d:	ba 07 04 00 00       	mov    $0x407,%edx
  802762:	48 89 c6             	mov    %rax,%rsi
  802765:	bf 00 00 00 00       	mov    $0x0,%edi
  80276a:	48 b8 9b 0b 80 00 00 	movabs $0x800b9b,%rax
  802771:	00 00 00 
  802774:	ff d0                	callq  *%rax
  802776:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802779:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80277d:	0f 88 33 01 00 00    	js     8028b6 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802783:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802787:	48 89 c7             	mov    %rax,%rdi
  80278a:	48 b8 f5 0e 80 00 00 	movabs $0x800ef5,%rax
  802791:	00 00 00 
  802794:	ff d0                	callq  *%rax
  802796:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80279a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80279e:	ba 07 04 00 00       	mov    $0x407,%edx
  8027a3:	48 89 c6             	mov    %rax,%rsi
  8027a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8027ab:	48 b8 9b 0b 80 00 00 	movabs $0x800b9b,%rax
  8027b2:	00 00 00 
  8027b5:	ff d0                	callq  *%rax
  8027b7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8027ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8027be:	79 05                	jns    8027c5 <pipe+0xe3>
		goto err2;
  8027c0:	e9 d9 00 00 00       	jmpq   80289e <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027c9:	48 89 c7             	mov    %rax,%rdi
  8027cc:	48 b8 f5 0e 80 00 00 	movabs $0x800ef5,%rax
  8027d3:	00 00 00 
  8027d6:	ff d0                	callq  *%rax
  8027d8:	48 89 c2             	mov    %rax,%rdx
  8027db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027df:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8027e5:	48 89 d1             	mov    %rdx,%rcx
  8027e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ed:	48 89 c6             	mov    %rax,%rsi
  8027f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8027f5:	48 b8 eb 0b 80 00 00 	movabs $0x800beb,%rax
  8027fc:	00 00 00 
  8027ff:	ff d0                	callq  *%rax
  802801:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802804:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802808:	79 1b                	jns    802825 <pipe+0x143>
		goto err3;
  80280a:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80280b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80280f:	48 89 c6             	mov    %rax,%rsi
  802812:	bf 00 00 00 00       	mov    $0x0,%edi
  802817:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  80281e:	00 00 00 
  802821:	ff d0                	callq  *%rax
  802823:	eb 79                	jmp    80289e <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802825:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802829:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  802830:	00 00 00 
  802833:	8b 12                	mov    (%rdx),%edx
  802835:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802837:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80283b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802842:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802846:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80284d:	00 00 00 
  802850:	8b 12                	mov    (%rdx),%edx
  802852:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802854:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802858:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80285f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802863:	48 89 c7             	mov    %rax,%rdi
  802866:	48 b8 d2 0e 80 00 00 	movabs $0x800ed2,%rax
  80286d:	00 00 00 
  802870:	ff d0                	callq  *%rax
  802872:	89 c2                	mov    %eax,%edx
  802874:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802878:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80287a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80287e:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802882:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802886:	48 89 c7             	mov    %rax,%rdi
  802889:	48 b8 d2 0e 80 00 00 	movabs $0x800ed2,%rax
  802890:	00 00 00 
  802893:	ff d0                	callq  *%rax
  802895:	89 03                	mov    %eax,(%rbx)
	return 0;
  802897:	b8 00 00 00 00       	mov    $0x0,%eax
  80289c:	eb 33                	jmp    8028d1 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80289e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028a2:	48 89 c6             	mov    %rax,%rsi
  8028a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8028aa:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  8028b1:	00 00 00 
  8028b4:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8028b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028ba:	48 89 c6             	mov    %rax,%rsi
  8028bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8028c2:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  8028c9:	00 00 00 
  8028cc:	ff d0                	callq  *%rax
err:
	return r;
  8028ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8028d1:	48 83 c4 38          	add    $0x38,%rsp
  8028d5:	5b                   	pop    %rbx
  8028d6:	5d                   	pop    %rbp
  8028d7:	c3                   	retq   

00000000008028d8 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8028d8:	55                   	push   %rbp
  8028d9:	48 89 e5             	mov    %rsp,%rbp
  8028dc:	53                   	push   %rbx
  8028dd:	48 83 ec 28          	sub    $0x28,%rsp
  8028e1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8028e5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8028e9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8028f0:	00 00 00 
  8028f3:	48 8b 00             	mov    (%rax),%rax
  8028f6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8028fc:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8028ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802903:	48 89 c7             	mov    %rax,%rdi
  802906:	48 b8 ca 3e 80 00 00 	movabs $0x803eca,%rax
  80290d:	00 00 00 
  802910:	ff d0                	callq  *%rax
  802912:	89 c3                	mov    %eax,%ebx
  802914:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802918:	48 89 c7             	mov    %rax,%rdi
  80291b:	48 b8 ca 3e 80 00 00 	movabs $0x803eca,%rax
  802922:	00 00 00 
  802925:	ff d0                	callq  *%rax
  802927:	39 c3                	cmp    %eax,%ebx
  802929:	0f 94 c0             	sete   %al
  80292c:	0f b6 c0             	movzbl %al,%eax
  80292f:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802932:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802939:	00 00 00 
  80293c:	48 8b 00             	mov    (%rax),%rax
  80293f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802945:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802948:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80294b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80294e:	75 05                	jne    802955 <_pipeisclosed+0x7d>
			return ret;
  802950:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802953:	eb 4f                	jmp    8029a4 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802955:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802958:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80295b:	74 42                	je     80299f <_pipeisclosed+0xc7>
  80295d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802961:	75 3c                	jne    80299f <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802963:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80296a:	00 00 00 
  80296d:	48 8b 00             	mov    (%rax),%rax
  802970:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802976:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802979:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80297c:	89 c6                	mov    %eax,%esi
  80297e:	48 bf e6 40 80 00 00 	movabs $0x8040e6,%rdi
  802985:	00 00 00 
  802988:	b8 00 00 00 00       	mov    $0x0,%eax
  80298d:	49 b8 97 31 80 00 00 	movabs $0x803197,%r8
  802994:	00 00 00 
  802997:	41 ff d0             	callq  *%r8
	}
  80299a:	e9 4a ff ff ff       	jmpq   8028e9 <_pipeisclosed+0x11>
  80299f:	e9 45 ff ff ff       	jmpq   8028e9 <_pipeisclosed+0x11>
}
  8029a4:	48 83 c4 28          	add    $0x28,%rsp
  8029a8:	5b                   	pop    %rbx
  8029a9:	5d                   	pop    %rbp
  8029aa:	c3                   	retq   

00000000008029ab <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8029ab:	55                   	push   %rbp
  8029ac:	48 89 e5             	mov    %rsp,%rbp
  8029af:	48 83 ec 30          	sub    $0x30,%rsp
  8029b3:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029b6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029ba:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029bd:	48 89 d6             	mov    %rdx,%rsi
  8029c0:	89 c7                	mov    %eax,%edi
  8029c2:	48 b8 b8 0f 80 00 00 	movabs $0x800fb8,%rax
  8029c9:	00 00 00 
  8029cc:	ff d0                	callq  *%rax
  8029ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d5:	79 05                	jns    8029dc <pipeisclosed+0x31>
		return r;
  8029d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029da:	eb 31                	jmp    802a0d <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8029dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e0:	48 89 c7             	mov    %rax,%rdi
  8029e3:	48 b8 f5 0e 80 00 00 	movabs $0x800ef5,%rax
  8029ea:	00 00 00 
  8029ed:	ff d0                	callq  *%rax
  8029ef:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8029f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029fb:	48 89 d6             	mov    %rdx,%rsi
  8029fe:	48 89 c7             	mov    %rax,%rdi
  802a01:	48 b8 d8 28 80 00 00 	movabs $0x8028d8,%rax
  802a08:	00 00 00 
  802a0b:	ff d0                	callq  *%rax
}
  802a0d:	c9                   	leaveq 
  802a0e:	c3                   	retq   

0000000000802a0f <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802a0f:	55                   	push   %rbp
  802a10:	48 89 e5             	mov    %rsp,%rbp
  802a13:	48 83 ec 40          	sub    $0x40,%rsp
  802a17:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802a1b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a1f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802a23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a27:	48 89 c7             	mov    %rax,%rdi
  802a2a:	48 b8 f5 0e 80 00 00 	movabs $0x800ef5,%rax
  802a31:	00 00 00 
  802a34:	ff d0                	callq  *%rax
  802a36:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802a3a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a3e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802a42:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802a49:	00 
  802a4a:	e9 92 00 00 00       	jmpq   802ae1 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802a4f:	eb 41                	jmp    802a92 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802a51:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802a56:	74 09                	je     802a61 <devpipe_read+0x52>
				return i;
  802a58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a5c:	e9 92 00 00 00       	jmpq   802af3 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802a61:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a69:	48 89 d6             	mov    %rdx,%rsi
  802a6c:	48 89 c7             	mov    %rax,%rdi
  802a6f:	48 b8 d8 28 80 00 00 	movabs $0x8028d8,%rax
  802a76:	00 00 00 
  802a79:	ff d0                	callq  *%rax
  802a7b:	85 c0                	test   %eax,%eax
  802a7d:	74 07                	je     802a86 <devpipe_read+0x77>
				return 0;
  802a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a84:	eb 6d                	jmp    802af3 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802a86:	48 b8 5d 0b 80 00 00 	movabs $0x800b5d,%rax
  802a8d:	00 00 00 
  802a90:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802a92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a96:	8b 10                	mov    (%rax),%edx
  802a98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a9c:	8b 40 04             	mov    0x4(%rax),%eax
  802a9f:	39 c2                	cmp    %eax,%edx
  802aa1:	74 ae                	je     802a51 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802aa3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802aa7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802aab:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802aaf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ab3:	8b 00                	mov    (%rax),%eax
  802ab5:	99                   	cltd   
  802ab6:	c1 ea 1b             	shr    $0x1b,%edx
  802ab9:	01 d0                	add    %edx,%eax
  802abb:	83 e0 1f             	and    $0x1f,%eax
  802abe:	29 d0                	sub    %edx,%eax
  802ac0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ac4:	48 98                	cltq   
  802ac6:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802acb:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802acd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ad1:	8b 00                	mov    (%rax),%eax
  802ad3:	8d 50 01             	lea    0x1(%rax),%edx
  802ad6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ada:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802adc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802ae1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ae5:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802ae9:	0f 82 60 ff ff ff    	jb     802a4f <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802aef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802af3:	c9                   	leaveq 
  802af4:	c3                   	retq   

0000000000802af5 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802af5:	55                   	push   %rbp
  802af6:	48 89 e5             	mov    %rsp,%rbp
  802af9:	48 83 ec 40          	sub    $0x40,%rsp
  802afd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b01:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b05:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802b09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b0d:	48 89 c7             	mov    %rax,%rdi
  802b10:	48 b8 f5 0e 80 00 00 	movabs $0x800ef5,%rax
  802b17:	00 00 00 
  802b1a:	ff d0                	callq  *%rax
  802b1c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802b20:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b24:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802b28:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802b2f:	00 
  802b30:	e9 8e 00 00 00       	jmpq   802bc3 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802b35:	eb 31                	jmp    802b68 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802b37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b3f:	48 89 d6             	mov    %rdx,%rsi
  802b42:	48 89 c7             	mov    %rax,%rdi
  802b45:	48 b8 d8 28 80 00 00 	movabs $0x8028d8,%rax
  802b4c:	00 00 00 
  802b4f:	ff d0                	callq  *%rax
  802b51:	85 c0                	test   %eax,%eax
  802b53:	74 07                	je     802b5c <devpipe_write+0x67>
				return 0;
  802b55:	b8 00 00 00 00       	mov    $0x0,%eax
  802b5a:	eb 79                	jmp    802bd5 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802b5c:	48 b8 5d 0b 80 00 00 	movabs $0x800b5d,%rax
  802b63:	00 00 00 
  802b66:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802b68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b6c:	8b 40 04             	mov    0x4(%rax),%eax
  802b6f:	48 63 d0             	movslq %eax,%rdx
  802b72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b76:	8b 00                	mov    (%rax),%eax
  802b78:	48 98                	cltq   
  802b7a:	48 83 c0 20          	add    $0x20,%rax
  802b7e:	48 39 c2             	cmp    %rax,%rdx
  802b81:	73 b4                	jae    802b37 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802b83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b87:	8b 40 04             	mov    0x4(%rax),%eax
  802b8a:	99                   	cltd   
  802b8b:	c1 ea 1b             	shr    $0x1b,%edx
  802b8e:	01 d0                	add    %edx,%eax
  802b90:	83 e0 1f             	and    $0x1f,%eax
  802b93:	29 d0                	sub    %edx,%eax
  802b95:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b99:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b9d:	48 01 ca             	add    %rcx,%rdx
  802ba0:	0f b6 0a             	movzbl (%rdx),%ecx
  802ba3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ba7:	48 98                	cltq   
  802ba9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802bad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb1:	8b 40 04             	mov    0x4(%rax),%eax
  802bb4:	8d 50 01             	lea    0x1(%rax),%edx
  802bb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bbb:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802bbe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802bc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bc7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802bcb:	0f 82 64 ff ff ff    	jb     802b35 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802bd1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802bd5:	c9                   	leaveq 
  802bd6:	c3                   	retq   

0000000000802bd7 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802bd7:	55                   	push   %rbp
  802bd8:	48 89 e5             	mov    %rsp,%rbp
  802bdb:	48 83 ec 20          	sub    $0x20,%rsp
  802bdf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802be3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802be7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802beb:	48 89 c7             	mov    %rax,%rdi
  802bee:	48 b8 f5 0e 80 00 00 	movabs $0x800ef5,%rax
  802bf5:	00 00 00 
  802bf8:	ff d0                	callq  *%rax
  802bfa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802bfe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c02:	48 be f9 40 80 00 00 	movabs $0x8040f9,%rsi
  802c09:	00 00 00 
  802c0c:	48 89 c7             	mov    %rax,%rdi
  802c0f:	48 b8 6c 02 80 00 00 	movabs $0x80026c,%rax
  802c16:	00 00 00 
  802c19:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802c1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c1f:	8b 50 04             	mov    0x4(%rax),%edx
  802c22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c26:	8b 00                	mov    (%rax),%eax
  802c28:	29 c2                	sub    %eax,%edx
  802c2a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c2e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802c34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c38:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802c3f:	00 00 00 
	stat->st_dev = &devpipe;
  802c42:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c46:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  802c4d:	00 00 00 
  802c50:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802c57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c5c:	c9                   	leaveq 
  802c5d:	c3                   	retq   

0000000000802c5e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802c5e:	55                   	push   %rbp
  802c5f:	48 89 e5             	mov    %rsp,%rbp
  802c62:	48 83 ec 10          	sub    $0x10,%rsp
  802c66:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802c6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c6e:	48 89 c6             	mov    %rax,%rsi
  802c71:	bf 00 00 00 00       	mov    $0x0,%edi
  802c76:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  802c7d:	00 00 00 
  802c80:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  802c82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c86:	48 89 c7             	mov    %rax,%rdi
  802c89:	48 b8 f5 0e 80 00 00 	movabs $0x800ef5,%rax
  802c90:	00 00 00 
  802c93:	ff d0                	callq  *%rax
  802c95:	48 89 c6             	mov    %rax,%rsi
  802c98:	bf 00 00 00 00       	mov    $0x0,%edi
  802c9d:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  802ca4:	00 00 00 
  802ca7:	ff d0                	callq  *%rax
}
  802ca9:	c9                   	leaveq 
  802caa:	c3                   	retq   

0000000000802cab <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802cab:	55                   	push   %rbp
  802cac:	48 89 e5             	mov    %rsp,%rbp
  802caf:	48 83 ec 20          	sub    $0x20,%rsp
  802cb3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802cb6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cb9:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802cbc:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802cc0:	be 01 00 00 00       	mov    $0x1,%esi
  802cc5:	48 89 c7             	mov    %rax,%rdi
  802cc8:	48 b8 53 0a 80 00 00 	movabs $0x800a53,%rax
  802ccf:	00 00 00 
  802cd2:	ff d0                	callq  *%rax
}
  802cd4:	c9                   	leaveq 
  802cd5:	c3                   	retq   

0000000000802cd6 <getchar>:

int
getchar(void)
{
  802cd6:	55                   	push   %rbp
  802cd7:	48 89 e5             	mov    %rsp,%rbp
  802cda:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802cde:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802ce2:	ba 01 00 00 00       	mov    $0x1,%edx
  802ce7:	48 89 c6             	mov    %rax,%rsi
  802cea:	bf 00 00 00 00       	mov    $0x0,%edi
  802cef:	48 b8 ea 13 80 00 00 	movabs $0x8013ea,%rax
  802cf6:	00 00 00 
  802cf9:	ff d0                	callq  *%rax
  802cfb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  802cfe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d02:	79 05                	jns    802d09 <getchar+0x33>
		return r;
  802d04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d07:	eb 14                	jmp    802d1d <getchar+0x47>
	if (r < 1)
  802d09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d0d:	7f 07                	jg     802d16 <getchar+0x40>
		return -E_EOF;
  802d0f:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802d14:	eb 07                	jmp    802d1d <getchar+0x47>
	return c;
  802d16:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  802d1a:	0f b6 c0             	movzbl %al,%eax
}
  802d1d:	c9                   	leaveq 
  802d1e:	c3                   	retq   

0000000000802d1f <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802d1f:	55                   	push   %rbp
  802d20:	48 89 e5             	mov    %rsp,%rbp
  802d23:	48 83 ec 20          	sub    $0x20,%rsp
  802d27:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d2a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d2e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d31:	48 89 d6             	mov    %rdx,%rsi
  802d34:	89 c7                	mov    %eax,%edi
  802d36:	48 b8 b8 0f 80 00 00 	movabs $0x800fb8,%rax
  802d3d:	00 00 00 
  802d40:	ff d0                	callq  *%rax
  802d42:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d45:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d49:	79 05                	jns    802d50 <iscons+0x31>
		return r;
  802d4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d4e:	eb 1a                	jmp    802d6a <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  802d50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d54:	8b 10                	mov    (%rax),%edx
  802d56:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  802d5d:	00 00 00 
  802d60:	8b 00                	mov    (%rax),%eax
  802d62:	39 c2                	cmp    %eax,%edx
  802d64:	0f 94 c0             	sete   %al
  802d67:	0f b6 c0             	movzbl %al,%eax
}
  802d6a:	c9                   	leaveq 
  802d6b:	c3                   	retq   

0000000000802d6c <opencons>:

int
opencons(void)
{
  802d6c:	55                   	push   %rbp
  802d6d:	48 89 e5             	mov    %rsp,%rbp
  802d70:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802d74:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d78:	48 89 c7             	mov    %rax,%rdi
  802d7b:	48 b8 20 0f 80 00 00 	movabs $0x800f20,%rax
  802d82:	00 00 00 
  802d85:	ff d0                	callq  *%rax
  802d87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d8e:	79 05                	jns    802d95 <opencons+0x29>
		return r;
  802d90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d93:	eb 5b                	jmp    802df0 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802d95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d99:	ba 07 04 00 00       	mov    $0x407,%edx
  802d9e:	48 89 c6             	mov    %rax,%rsi
  802da1:	bf 00 00 00 00       	mov    $0x0,%edi
  802da6:	48 b8 9b 0b 80 00 00 	movabs $0x800b9b,%rax
  802dad:	00 00 00 
  802db0:	ff d0                	callq  *%rax
  802db2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802db5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db9:	79 05                	jns    802dc0 <opencons+0x54>
		return r;
  802dbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dbe:	eb 30                	jmp    802df0 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  802dc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc4:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  802dcb:	00 00 00 
  802dce:	8b 12                	mov    (%rdx),%edx
  802dd0:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  802dd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  802ddd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de1:	48 89 c7             	mov    %rax,%rdi
  802de4:	48 b8 d2 0e 80 00 00 	movabs $0x800ed2,%rax
  802deb:	00 00 00 
  802dee:	ff d0                	callq  *%rax
}
  802df0:	c9                   	leaveq 
  802df1:	c3                   	retq   

0000000000802df2 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802df2:	55                   	push   %rbp
  802df3:	48 89 e5             	mov    %rsp,%rbp
  802df6:	48 83 ec 30          	sub    $0x30,%rsp
  802dfa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dfe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e02:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  802e06:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802e0b:	75 07                	jne    802e14 <devcons_read+0x22>
		return 0;
  802e0d:	b8 00 00 00 00       	mov    $0x0,%eax
  802e12:	eb 4b                	jmp    802e5f <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  802e14:	eb 0c                	jmp    802e22 <devcons_read+0x30>
		sys_yield();
  802e16:	48 b8 5d 0b 80 00 00 	movabs $0x800b5d,%rax
  802e1d:	00 00 00 
  802e20:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802e22:	48 b8 9d 0a 80 00 00 	movabs $0x800a9d,%rax
  802e29:	00 00 00 
  802e2c:	ff d0                	callq  *%rax
  802e2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e35:	74 df                	je     802e16 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  802e37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e3b:	79 05                	jns    802e42 <devcons_read+0x50>
		return c;
  802e3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e40:	eb 1d                	jmp    802e5f <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  802e42:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  802e46:	75 07                	jne    802e4f <devcons_read+0x5d>
		return 0;
  802e48:	b8 00 00 00 00       	mov    $0x0,%eax
  802e4d:	eb 10                	jmp    802e5f <devcons_read+0x6d>
	*(char*)vbuf = c;
  802e4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e52:	89 c2                	mov    %eax,%edx
  802e54:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e58:	88 10                	mov    %dl,(%rax)
	return 1;
  802e5a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802e5f:	c9                   	leaveq 
  802e60:	c3                   	retq   

0000000000802e61 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802e61:	55                   	push   %rbp
  802e62:	48 89 e5             	mov    %rsp,%rbp
  802e65:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  802e6c:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  802e73:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  802e7a:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802e81:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e88:	eb 76                	jmp    802f00 <devcons_write+0x9f>
		m = n - tot;
  802e8a:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  802e91:	89 c2                	mov    %eax,%edx
  802e93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e96:	29 c2                	sub    %eax,%edx
  802e98:	89 d0                	mov    %edx,%eax
  802e9a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  802e9d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ea0:	83 f8 7f             	cmp    $0x7f,%eax
  802ea3:	76 07                	jbe    802eac <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  802ea5:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  802eac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802eaf:	48 63 d0             	movslq %eax,%rdx
  802eb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb5:	48 63 c8             	movslq %eax,%rcx
  802eb8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  802ebf:	48 01 c1             	add    %rax,%rcx
  802ec2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802ec9:	48 89 ce             	mov    %rcx,%rsi
  802ecc:	48 89 c7             	mov    %rax,%rdi
  802ecf:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  802ed6:	00 00 00 
  802ed9:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  802edb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ede:	48 63 d0             	movslq %eax,%rdx
  802ee1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802ee8:	48 89 d6             	mov    %rdx,%rsi
  802eeb:	48 89 c7             	mov    %rax,%rdi
  802eee:	48 b8 53 0a 80 00 00 	movabs $0x800a53,%rax
  802ef5:	00 00 00 
  802ef8:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802efa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802efd:	01 45 fc             	add    %eax,-0x4(%rbp)
  802f00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f03:	48 98                	cltq   
  802f05:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  802f0c:	0f 82 78 ff ff ff    	jb     802e8a <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  802f12:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f15:	c9                   	leaveq 
  802f16:	c3                   	retq   

0000000000802f17 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  802f17:	55                   	push   %rbp
  802f18:	48 89 e5             	mov    %rsp,%rbp
  802f1b:	48 83 ec 08          	sub    $0x8,%rsp
  802f1f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  802f23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f28:	c9                   	leaveq 
  802f29:	c3                   	retq   

0000000000802f2a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802f2a:	55                   	push   %rbp
  802f2b:	48 89 e5             	mov    %rsp,%rbp
  802f2e:	48 83 ec 10          	sub    $0x10,%rsp
  802f32:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f36:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  802f3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f3e:	48 be 05 41 80 00 00 	movabs $0x804105,%rsi
  802f45:	00 00 00 
  802f48:	48 89 c7             	mov    %rax,%rdi
  802f4b:	48 b8 6c 02 80 00 00 	movabs $0x80026c,%rax
  802f52:	00 00 00 
  802f55:	ff d0                	callq  *%rax
	return 0;
  802f57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f5c:	c9                   	leaveq 
  802f5d:	c3                   	retq   

0000000000802f5e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802f5e:	55                   	push   %rbp
  802f5f:	48 89 e5             	mov    %rsp,%rbp
  802f62:	53                   	push   %rbx
  802f63:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802f6a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  802f71:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  802f77:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  802f7e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802f85:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802f8c:	84 c0                	test   %al,%al
  802f8e:	74 23                	je     802fb3 <_panic+0x55>
  802f90:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802f97:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802f9b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802f9f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802fa3:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802fa7:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802fab:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802faf:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802fb3:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802fba:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  802fc1:	00 00 00 
  802fc4:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  802fcb:	00 00 00 
  802fce:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802fd2:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  802fd9:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  802fe0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802fe7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802fee:	00 00 00 
  802ff1:	48 8b 18             	mov    (%rax),%rbx
  802ff4:	48 b8 1f 0b 80 00 00 	movabs $0x800b1f,%rax
  802ffb:	00 00 00 
  802ffe:	ff d0                	callq  *%rax
  803000:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803006:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80300d:	41 89 c8             	mov    %ecx,%r8d
  803010:	48 89 d1             	mov    %rdx,%rcx
  803013:	48 89 da             	mov    %rbx,%rdx
  803016:	89 c6                	mov    %eax,%esi
  803018:	48 bf 10 41 80 00 00 	movabs $0x804110,%rdi
  80301f:	00 00 00 
  803022:	b8 00 00 00 00       	mov    $0x0,%eax
  803027:	49 b9 97 31 80 00 00 	movabs $0x803197,%r9
  80302e:	00 00 00 
  803031:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803034:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80303b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803042:	48 89 d6             	mov    %rdx,%rsi
  803045:	48 89 c7             	mov    %rax,%rdi
  803048:	48 b8 eb 30 80 00 00 	movabs $0x8030eb,%rax
  80304f:	00 00 00 
  803052:	ff d0                	callq  *%rax
	cprintf("\n");
  803054:	48 bf 33 41 80 00 00 	movabs $0x804133,%rdi
  80305b:	00 00 00 
  80305e:	b8 00 00 00 00       	mov    $0x0,%eax
  803063:	48 ba 97 31 80 00 00 	movabs $0x803197,%rdx
  80306a:	00 00 00 
  80306d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80306f:	cc                   	int3   
  803070:	eb fd                	jmp    80306f <_panic+0x111>

0000000000803072 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  803072:	55                   	push   %rbp
  803073:	48 89 e5             	mov    %rsp,%rbp
  803076:	48 83 ec 10          	sub    $0x10,%rsp
  80307a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80307d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  803081:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803085:	8b 00                	mov    (%rax),%eax
  803087:	8d 48 01             	lea    0x1(%rax),%ecx
  80308a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80308e:	89 0a                	mov    %ecx,(%rdx)
  803090:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803093:	89 d1                	mov    %edx,%ecx
  803095:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803099:	48 98                	cltq   
  80309b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80309f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030a3:	8b 00                	mov    (%rax),%eax
  8030a5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8030aa:	75 2c                	jne    8030d8 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8030ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b0:	8b 00                	mov    (%rax),%eax
  8030b2:	48 98                	cltq   
  8030b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030b8:	48 83 c2 08          	add    $0x8,%rdx
  8030bc:	48 89 c6             	mov    %rax,%rsi
  8030bf:	48 89 d7             	mov    %rdx,%rdi
  8030c2:	48 b8 53 0a 80 00 00 	movabs $0x800a53,%rax
  8030c9:	00 00 00 
  8030cc:	ff d0                	callq  *%rax
        b->idx = 0;
  8030ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8030d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030dc:	8b 40 04             	mov    0x4(%rax),%eax
  8030df:	8d 50 01             	lea    0x1(%rax),%edx
  8030e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030e6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8030e9:	c9                   	leaveq 
  8030ea:	c3                   	retq   

00000000008030eb <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8030eb:	55                   	push   %rbp
  8030ec:	48 89 e5             	mov    %rsp,%rbp
  8030ef:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8030f6:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8030fd:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  803104:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80310b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  803112:	48 8b 0a             	mov    (%rdx),%rcx
  803115:	48 89 08             	mov    %rcx,(%rax)
  803118:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80311c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803120:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803124:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  803128:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80312f:	00 00 00 
    b.cnt = 0;
  803132:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  803139:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80313c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  803143:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80314a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803151:	48 89 c6             	mov    %rax,%rsi
  803154:	48 bf 72 30 80 00 00 	movabs $0x803072,%rdi
  80315b:	00 00 00 
  80315e:	48 b8 4a 35 80 00 00 	movabs $0x80354a,%rax
  803165:	00 00 00 
  803168:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80316a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  803170:	48 98                	cltq   
  803172:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  803179:	48 83 c2 08          	add    $0x8,%rdx
  80317d:	48 89 c6             	mov    %rax,%rsi
  803180:	48 89 d7             	mov    %rdx,%rdi
  803183:	48 b8 53 0a 80 00 00 	movabs $0x800a53,%rax
  80318a:	00 00 00 
  80318d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80318f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  803195:	c9                   	leaveq 
  803196:	c3                   	retq   

0000000000803197 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  803197:	55                   	push   %rbp
  803198:	48 89 e5             	mov    %rsp,%rbp
  80319b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8031a2:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8031a9:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8031b0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8031b7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8031be:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8031c5:	84 c0                	test   %al,%al
  8031c7:	74 20                	je     8031e9 <cprintf+0x52>
  8031c9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8031cd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8031d1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8031d5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8031d9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8031dd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8031e1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8031e5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8031e9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8031f0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8031f7:	00 00 00 
  8031fa:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803201:	00 00 00 
  803204:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803208:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80320f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803216:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80321d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803224:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80322b:	48 8b 0a             	mov    (%rdx),%rcx
  80322e:	48 89 08             	mov    %rcx,(%rax)
  803231:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803235:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803239:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80323d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  803241:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  803248:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80324f:	48 89 d6             	mov    %rdx,%rsi
  803252:	48 89 c7             	mov    %rax,%rdi
  803255:	48 b8 eb 30 80 00 00 	movabs $0x8030eb,%rax
  80325c:	00 00 00 
  80325f:	ff d0                	callq  *%rax
  803261:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  803267:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80326d:	c9                   	leaveq 
  80326e:	c3                   	retq   

000000000080326f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80326f:	55                   	push   %rbp
  803270:	48 89 e5             	mov    %rsp,%rbp
  803273:	53                   	push   %rbx
  803274:	48 83 ec 38          	sub    $0x38,%rsp
  803278:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80327c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803280:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803284:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  803287:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80328b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80328f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803292:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803296:	77 3b                	ja     8032d3 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  803298:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80329b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80329f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8032a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8032ab:	48 f7 f3             	div    %rbx
  8032ae:	48 89 c2             	mov    %rax,%rdx
  8032b1:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8032b4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8032b7:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8032bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032bf:	41 89 f9             	mov    %edi,%r9d
  8032c2:	48 89 c7             	mov    %rax,%rdi
  8032c5:	48 b8 6f 32 80 00 00 	movabs $0x80326f,%rax
  8032cc:	00 00 00 
  8032cf:	ff d0                	callq  *%rax
  8032d1:	eb 1e                	jmp    8032f1 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8032d3:	eb 12                	jmp    8032e7 <printnum+0x78>
			putch(padc, putdat);
  8032d5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8032d9:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8032dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032e0:	48 89 ce             	mov    %rcx,%rsi
  8032e3:	89 d7                	mov    %edx,%edi
  8032e5:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8032e7:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8032eb:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8032ef:	7f e4                	jg     8032d5 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8032f1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8032f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8032fd:	48 f7 f1             	div    %rcx
  803300:	48 89 d0             	mov    %rdx,%rax
  803303:	48 ba 30 43 80 00 00 	movabs $0x804330,%rdx
  80330a:	00 00 00 
  80330d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  803311:	0f be d0             	movsbl %al,%edx
  803314:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803318:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80331c:	48 89 ce             	mov    %rcx,%rsi
  80331f:	89 d7                	mov    %edx,%edi
  803321:	ff d0                	callq  *%rax
}
  803323:	48 83 c4 38          	add    $0x38,%rsp
  803327:	5b                   	pop    %rbx
  803328:	5d                   	pop    %rbp
  803329:	c3                   	retq   

000000000080332a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80332a:	55                   	push   %rbp
  80332b:	48 89 e5             	mov    %rsp,%rbp
  80332e:	48 83 ec 1c          	sub    $0x1c,%rsp
  803332:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803336:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  803339:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80333d:	7e 52                	jle    803391 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80333f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803343:	8b 00                	mov    (%rax),%eax
  803345:	83 f8 30             	cmp    $0x30,%eax
  803348:	73 24                	jae    80336e <getuint+0x44>
  80334a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80334e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803352:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803356:	8b 00                	mov    (%rax),%eax
  803358:	89 c0                	mov    %eax,%eax
  80335a:	48 01 d0             	add    %rdx,%rax
  80335d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803361:	8b 12                	mov    (%rdx),%edx
  803363:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803366:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80336a:	89 0a                	mov    %ecx,(%rdx)
  80336c:	eb 17                	jmp    803385 <getuint+0x5b>
  80336e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803372:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803376:	48 89 d0             	mov    %rdx,%rax
  803379:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80337d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803381:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803385:	48 8b 00             	mov    (%rax),%rax
  803388:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80338c:	e9 a3 00 00 00       	jmpq   803434 <getuint+0x10a>
	else if (lflag)
  803391:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803395:	74 4f                	je     8033e6 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  803397:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80339b:	8b 00                	mov    (%rax),%eax
  80339d:	83 f8 30             	cmp    $0x30,%eax
  8033a0:	73 24                	jae    8033c6 <getuint+0x9c>
  8033a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033a6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8033aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033ae:	8b 00                	mov    (%rax),%eax
  8033b0:	89 c0                	mov    %eax,%eax
  8033b2:	48 01 d0             	add    %rdx,%rax
  8033b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8033b9:	8b 12                	mov    (%rdx),%edx
  8033bb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8033be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8033c2:	89 0a                	mov    %ecx,(%rdx)
  8033c4:	eb 17                	jmp    8033dd <getuint+0xb3>
  8033c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033ca:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8033ce:	48 89 d0             	mov    %rdx,%rax
  8033d1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8033d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8033d9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8033dd:	48 8b 00             	mov    (%rax),%rax
  8033e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8033e4:	eb 4e                	jmp    803434 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8033e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033ea:	8b 00                	mov    (%rax),%eax
  8033ec:	83 f8 30             	cmp    $0x30,%eax
  8033ef:	73 24                	jae    803415 <getuint+0xeb>
  8033f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033f5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8033f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033fd:	8b 00                	mov    (%rax),%eax
  8033ff:	89 c0                	mov    %eax,%eax
  803401:	48 01 d0             	add    %rdx,%rax
  803404:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803408:	8b 12                	mov    (%rdx),%edx
  80340a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80340d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803411:	89 0a                	mov    %ecx,(%rdx)
  803413:	eb 17                	jmp    80342c <getuint+0x102>
  803415:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803419:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80341d:	48 89 d0             	mov    %rdx,%rax
  803420:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803424:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803428:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80342c:	8b 00                	mov    (%rax),%eax
  80342e:	89 c0                	mov    %eax,%eax
  803430:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803434:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803438:	c9                   	leaveq 
  803439:	c3                   	retq   

000000000080343a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80343a:	55                   	push   %rbp
  80343b:	48 89 e5             	mov    %rsp,%rbp
  80343e:	48 83 ec 1c          	sub    $0x1c,%rsp
  803442:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803446:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  803449:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80344d:	7e 52                	jle    8034a1 <getint+0x67>
		x=va_arg(*ap, long long);
  80344f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803453:	8b 00                	mov    (%rax),%eax
  803455:	83 f8 30             	cmp    $0x30,%eax
  803458:	73 24                	jae    80347e <getint+0x44>
  80345a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80345e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803462:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803466:	8b 00                	mov    (%rax),%eax
  803468:	89 c0                	mov    %eax,%eax
  80346a:	48 01 d0             	add    %rdx,%rax
  80346d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803471:	8b 12                	mov    (%rdx),%edx
  803473:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803476:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80347a:	89 0a                	mov    %ecx,(%rdx)
  80347c:	eb 17                	jmp    803495 <getint+0x5b>
  80347e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803482:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803486:	48 89 d0             	mov    %rdx,%rax
  803489:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80348d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803491:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803495:	48 8b 00             	mov    (%rax),%rax
  803498:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80349c:	e9 a3 00 00 00       	jmpq   803544 <getint+0x10a>
	else if (lflag)
  8034a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8034a5:	74 4f                	je     8034f6 <getint+0xbc>
		x=va_arg(*ap, long);
  8034a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ab:	8b 00                	mov    (%rax),%eax
  8034ad:	83 f8 30             	cmp    $0x30,%eax
  8034b0:	73 24                	jae    8034d6 <getint+0x9c>
  8034b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034b6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8034ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034be:	8b 00                	mov    (%rax),%eax
  8034c0:	89 c0                	mov    %eax,%eax
  8034c2:	48 01 d0             	add    %rdx,%rax
  8034c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8034c9:	8b 12                	mov    (%rdx),%edx
  8034cb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8034ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8034d2:	89 0a                	mov    %ecx,(%rdx)
  8034d4:	eb 17                	jmp    8034ed <getint+0xb3>
  8034d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034da:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8034de:	48 89 d0             	mov    %rdx,%rax
  8034e1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8034e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8034e9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8034ed:	48 8b 00             	mov    (%rax),%rax
  8034f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8034f4:	eb 4e                	jmp    803544 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8034f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034fa:	8b 00                	mov    (%rax),%eax
  8034fc:	83 f8 30             	cmp    $0x30,%eax
  8034ff:	73 24                	jae    803525 <getint+0xeb>
  803501:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803505:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803509:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80350d:	8b 00                	mov    (%rax),%eax
  80350f:	89 c0                	mov    %eax,%eax
  803511:	48 01 d0             	add    %rdx,%rax
  803514:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803518:	8b 12                	mov    (%rdx),%edx
  80351a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80351d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803521:	89 0a                	mov    %ecx,(%rdx)
  803523:	eb 17                	jmp    80353c <getint+0x102>
  803525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803529:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80352d:	48 89 d0             	mov    %rdx,%rax
  803530:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803534:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803538:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80353c:	8b 00                	mov    (%rax),%eax
  80353e:	48 98                	cltq   
  803540:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803544:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803548:	c9                   	leaveq 
  803549:	c3                   	retq   

000000000080354a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80354a:	55                   	push   %rbp
  80354b:	48 89 e5             	mov    %rsp,%rbp
  80354e:	41 54                	push   %r12
  803550:	53                   	push   %rbx
  803551:	48 83 ec 60          	sub    $0x60,%rsp
  803555:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  803559:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80355d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803561:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  803565:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803569:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80356d:	48 8b 0a             	mov    (%rdx),%rcx
  803570:	48 89 08             	mov    %rcx,(%rax)
  803573:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803577:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80357b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80357f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803583:	eb 17                	jmp    80359c <vprintfmt+0x52>
			if (ch == '\0')
  803585:	85 db                	test   %ebx,%ebx
  803587:	0f 84 cc 04 00 00    	je     803a59 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80358d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803591:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803595:	48 89 d6             	mov    %rdx,%rsi
  803598:	89 df                	mov    %ebx,%edi
  80359a:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80359c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8035a0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8035a4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8035a8:	0f b6 00             	movzbl (%rax),%eax
  8035ab:	0f b6 d8             	movzbl %al,%ebx
  8035ae:	83 fb 25             	cmp    $0x25,%ebx
  8035b1:	75 d2                	jne    803585 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8035b3:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8035b7:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8035be:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8035c5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8035cc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8035d3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8035d7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8035db:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8035df:	0f b6 00             	movzbl (%rax),%eax
  8035e2:	0f b6 d8             	movzbl %al,%ebx
  8035e5:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8035e8:	83 f8 55             	cmp    $0x55,%eax
  8035eb:	0f 87 34 04 00 00    	ja     803a25 <vprintfmt+0x4db>
  8035f1:	89 c0                	mov    %eax,%eax
  8035f3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8035fa:	00 
  8035fb:	48 b8 58 43 80 00 00 	movabs $0x804358,%rax
  803602:	00 00 00 
  803605:	48 01 d0             	add    %rdx,%rax
  803608:	48 8b 00             	mov    (%rax),%rax
  80360b:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80360d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  803611:	eb c0                	jmp    8035d3 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  803613:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  803617:	eb ba                	jmp    8035d3 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803619:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  803620:	8b 55 d8             	mov    -0x28(%rbp),%edx
  803623:	89 d0                	mov    %edx,%eax
  803625:	c1 e0 02             	shl    $0x2,%eax
  803628:	01 d0                	add    %edx,%eax
  80362a:	01 c0                	add    %eax,%eax
  80362c:	01 d8                	add    %ebx,%eax
  80362e:	83 e8 30             	sub    $0x30,%eax
  803631:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  803634:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803638:	0f b6 00             	movzbl (%rax),%eax
  80363b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80363e:	83 fb 2f             	cmp    $0x2f,%ebx
  803641:	7e 0c                	jle    80364f <vprintfmt+0x105>
  803643:	83 fb 39             	cmp    $0x39,%ebx
  803646:	7f 07                	jg     80364f <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803648:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80364d:	eb d1                	jmp    803620 <vprintfmt+0xd6>
			goto process_precision;
  80364f:	eb 58                	jmp    8036a9 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  803651:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803654:	83 f8 30             	cmp    $0x30,%eax
  803657:	73 17                	jae    803670 <vprintfmt+0x126>
  803659:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80365d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803660:	89 c0                	mov    %eax,%eax
  803662:	48 01 d0             	add    %rdx,%rax
  803665:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803668:	83 c2 08             	add    $0x8,%edx
  80366b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80366e:	eb 0f                	jmp    80367f <vprintfmt+0x135>
  803670:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803674:	48 89 d0             	mov    %rdx,%rax
  803677:	48 83 c2 08          	add    $0x8,%rdx
  80367b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80367f:	8b 00                	mov    (%rax),%eax
  803681:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  803684:	eb 23                	jmp    8036a9 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  803686:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80368a:	79 0c                	jns    803698 <vprintfmt+0x14e>
				width = 0;
  80368c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  803693:	e9 3b ff ff ff       	jmpq   8035d3 <vprintfmt+0x89>
  803698:	e9 36 ff ff ff       	jmpq   8035d3 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80369d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8036a4:	e9 2a ff ff ff       	jmpq   8035d3 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8036a9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8036ad:	79 12                	jns    8036c1 <vprintfmt+0x177>
				width = precision, precision = -1;
  8036af:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8036b2:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8036b5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8036bc:	e9 12 ff ff ff       	jmpq   8035d3 <vprintfmt+0x89>
  8036c1:	e9 0d ff ff ff       	jmpq   8035d3 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8036c6:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8036ca:	e9 04 ff ff ff       	jmpq   8035d3 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8036cf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8036d2:	83 f8 30             	cmp    $0x30,%eax
  8036d5:	73 17                	jae    8036ee <vprintfmt+0x1a4>
  8036d7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8036db:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8036de:	89 c0                	mov    %eax,%eax
  8036e0:	48 01 d0             	add    %rdx,%rax
  8036e3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8036e6:	83 c2 08             	add    $0x8,%edx
  8036e9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8036ec:	eb 0f                	jmp    8036fd <vprintfmt+0x1b3>
  8036ee:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8036f2:	48 89 d0             	mov    %rdx,%rax
  8036f5:	48 83 c2 08          	add    $0x8,%rdx
  8036f9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8036fd:	8b 10                	mov    (%rax),%edx
  8036ff:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803703:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803707:	48 89 ce             	mov    %rcx,%rsi
  80370a:	89 d7                	mov    %edx,%edi
  80370c:	ff d0                	callq  *%rax
			break;
  80370e:	e9 40 03 00 00       	jmpq   803a53 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  803713:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803716:	83 f8 30             	cmp    $0x30,%eax
  803719:	73 17                	jae    803732 <vprintfmt+0x1e8>
  80371b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80371f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803722:	89 c0                	mov    %eax,%eax
  803724:	48 01 d0             	add    %rdx,%rax
  803727:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80372a:	83 c2 08             	add    $0x8,%edx
  80372d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803730:	eb 0f                	jmp    803741 <vprintfmt+0x1f7>
  803732:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803736:	48 89 d0             	mov    %rdx,%rax
  803739:	48 83 c2 08          	add    $0x8,%rdx
  80373d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803741:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  803743:	85 db                	test   %ebx,%ebx
  803745:	79 02                	jns    803749 <vprintfmt+0x1ff>
				err = -err;
  803747:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  803749:	83 fb 15             	cmp    $0x15,%ebx
  80374c:	7f 16                	jg     803764 <vprintfmt+0x21a>
  80374e:	48 b8 80 42 80 00 00 	movabs $0x804280,%rax
  803755:	00 00 00 
  803758:	48 63 d3             	movslq %ebx,%rdx
  80375b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80375f:	4d 85 e4             	test   %r12,%r12
  803762:	75 2e                	jne    803792 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  803764:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803768:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80376c:	89 d9                	mov    %ebx,%ecx
  80376e:	48 ba 41 43 80 00 00 	movabs $0x804341,%rdx
  803775:	00 00 00 
  803778:	48 89 c7             	mov    %rax,%rdi
  80377b:	b8 00 00 00 00       	mov    $0x0,%eax
  803780:	49 b8 62 3a 80 00 00 	movabs $0x803a62,%r8
  803787:	00 00 00 
  80378a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80378d:	e9 c1 02 00 00       	jmpq   803a53 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  803792:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803796:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80379a:	4c 89 e1             	mov    %r12,%rcx
  80379d:	48 ba 4a 43 80 00 00 	movabs $0x80434a,%rdx
  8037a4:	00 00 00 
  8037a7:	48 89 c7             	mov    %rax,%rdi
  8037aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8037af:	49 b8 62 3a 80 00 00 	movabs $0x803a62,%r8
  8037b6:	00 00 00 
  8037b9:	41 ff d0             	callq  *%r8
			break;
  8037bc:	e9 92 02 00 00       	jmpq   803a53 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8037c1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8037c4:	83 f8 30             	cmp    $0x30,%eax
  8037c7:	73 17                	jae    8037e0 <vprintfmt+0x296>
  8037c9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8037cd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8037d0:	89 c0                	mov    %eax,%eax
  8037d2:	48 01 d0             	add    %rdx,%rax
  8037d5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8037d8:	83 c2 08             	add    $0x8,%edx
  8037db:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8037de:	eb 0f                	jmp    8037ef <vprintfmt+0x2a5>
  8037e0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8037e4:	48 89 d0             	mov    %rdx,%rax
  8037e7:	48 83 c2 08          	add    $0x8,%rdx
  8037eb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8037ef:	4c 8b 20             	mov    (%rax),%r12
  8037f2:	4d 85 e4             	test   %r12,%r12
  8037f5:	75 0a                	jne    803801 <vprintfmt+0x2b7>
				p = "(null)";
  8037f7:	49 bc 4d 43 80 00 00 	movabs $0x80434d,%r12
  8037fe:	00 00 00 
			if (width > 0 && padc != '-')
  803801:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803805:	7e 3f                	jle    803846 <vprintfmt+0x2fc>
  803807:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80380b:	74 39                	je     803846 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80380d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803810:	48 98                	cltq   
  803812:	48 89 c6             	mov    %rax,%rsi
  803815:	4c 89 e7             	mov    %r12,%rdi
  803818:	48 b8 2e 02 80 00 00 	movabs $0x80022e,%rax
  80381f:	00 00 00 
  803822:	ff d0                	callq  *%rax
  803824:	29 45 dc             	sub    %eax,-0x24(%rbp)
  803827:	eb 17                	jmp    803840 <vprintfmt+0x2f6>
					putch(padc, putdat);
  803829:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80382d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803831:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803835:	48 89 ce             	mov    %rcx,%rsi
  803838:	89 d7                	mov    %edx,%edi
  80383a:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80383c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803840:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803844:	7f e3                	jg     803829 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803846:	eb 37                	jmp    80387f <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  803848:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80384c:	74 1e                	je     80386c <vprintfmt+0x322>
  80384e:	83 fb 1f             	cmp    $0x1f,%ebx
  803851:	7e 05                	jle    803858 <vprintfmt+0x30e>
  803853:	83 fb 7e             	cmp    $0x7e,%ebx
  803856:	7e 14                	jle    80386c <vprintfmt+0x322>
					putch('?', putdat);
  803858:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80385c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803860:	48 89 d6             	mov    %rdx,%rsi
  803863:	bf 3f 00 00 00       	mov    $0x3f,%edi
  803868:	ff d0                	callq  *%rax
  80386a:	eb 0f                	jmp    80387b <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80386c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803870:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803874:	48 89 d6             	mov    %rdx,%rsi
  803877:	89 df                	mov    %ebx,%edi
  803879:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80387b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80387f:	4c 89 e0             	mov    %r12,%rax
  803882:	4c 8d 60 01          	lea    0x1(%rax),%r12
  803886:	0f b6 00             	movzbl (%rax),%eax
  803889:	0f be d8             	movsbl %al,%ebx
  80388c:	85 db                	test   %ebx,%ebx
  80388e:	74 10                	je     8038a0 <vprintfmt+0x356>
  803890:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803894:	78 b2                	js     803848 <vprintfmt+0x2fe>
  803896:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80389a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80389e:	79 a8                	jns    803848 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8038a0:	eb 16                	jmp    8038b8 <vprintfmt+0x36e>
				putch(' ', putdat);
  8038a2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8038a6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8038aa:	48 89 d6             	mov    %rdx,%rsi
  8038ad:	bf 20 00 00 00       	mov    $0x20,%edi
  8038b2:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8038b4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8038b8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8038bc:	7f e4                	jg     8038a2 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8038be:	e9 90 01 00 00       	jmpq   803a53 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8038c3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8038c7:	be 03 00 00 00       	mov    $0x3,%esi
  8038cc:	48 89 c7             	mov    %rax,%rdi
  8038cf:	48 b8 3a 34 80 00 00 	movabs $0x80343a,%rax
  8038d6:	00 00 00 
  8038d9:	ff d0                	callq  *%rax
  8038db:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8038df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038e3:	48 85 c0             	test   %rax,%rax
  8038e6:	79 1d                	jns    803905 <vprintfmt+0x3bb>
				putch('-', putdat);
  8038e8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8038ec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8038f0:	48 89 d6             	mov    %rdx,%rsi
  8038f3:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8038f8:	ff d0                	callq  *%rax
				num = -(long long) num;
  8038fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038fe:	48 f7 d8             	neg    %rax
  803901:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  803905:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80390c:	e9 d5 00 00 00       	jmpq   8039e6 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  803911:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803915:	be 03 00 00 00       	mov    $0x3,%esi
  80391a:	48 89 c7             	mov    %rax,%rdi
  80391d:	48 b8 2a 33 80 00 00 	movabs $0x80332a,%rax
  803924:	00 00 00 
  803927:	ff d0                	callq  *%rax
  803929:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80392d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803934:	e9 ad 00 00 00       	jmpq   8039e6 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  803939:	8b 55 e0             	mov    -0x20(%rbp),%edx
  80393c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803940:	89 d6                	mov    %edx,%esi
  803942:	48 89 c7             	mov    %rax,%rdi
  803945:	48 b8 3a 34 80 00 00 	movabs $0x80343a,%rax
  80394c:	00 00 00 
  80394f:	ff d0                	callq  *%rax
  803951:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  803955:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  80395c:	e9 85 00 00 00       	jmpq   8039e6 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  803961:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803965:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803969:	48 89 d6             	mov    %rdx,%rsi
  80396c:	bf 30 00 00 00       	mov    $0x30,%edi
  803971:	ff d0                	callq  *%rax
			putch('x', putdat);
  803973:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803977:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80397b:	48 89 d6             	mov    %rdx,%rsi
  80397e:	bf 78 00 00 00       	mov    $0x78,%edi
  803983:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803985:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803988:	83 f8 30             	cmp    $0x30,%eax
  80398b:	73 17                	jae    8039a4 <vprintfmt+0x45a>
  80398d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803991:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803994:	89 c0                	mov    %eax,%eax
  803996:	48 01 d0             	add    %rdx,%rax
  803999:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80399c:	83 c2 08             	add    $0x8,%edx
  80399f:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8039a2:	eb 0f                	jmp    8039b3 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  8039a4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8039a8:	48 89 d0             	mov    %rdx,%rax
  8039ab:	48 83 c2 08          	add    $0x8,%rdx
  8039af:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8039b3:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8039b6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8039ba:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8039c1:	eb 23                	jmp    8039e6 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8039c3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8039c7:	be 03 00 00 00       	mov    $0x3,%esi
  8039cc:	48 89 c7             	mov    %rax,%rdi
  8039cf:	48 b8 2a 33 80 00 00 	movabs $0x80332a,%rax
  8039d6:	00 00 00 
  8039d9:	ff d0                	callq  *%rax
  8039db:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8039df:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8039e6:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8039eb:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8039ee:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8039f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039f5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8039f9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8039fd:	45 89 c1             	mov    %r8d,%r9d
  803a00:	41 89 f8             	mov    %edi,%r8d
  803a03:	48 89 c7             	mov    %rax,%rdi
  803a06:	48 b8 6f 32 80 00 00 	movabs $0x80326f,%rax
  803a0d:	00 00 00 
  803a10:	ff d0                	callq  *%rax
			break;
  803a12:	eb 3f                	jmp    803a53 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  803a14:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803a18:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803a1c:	48 89 d6             	mov    %rdx,%rsi
  803a1f:	89 df                	mov    %ebx,%edi
  803a21:	ff d0                	callq  *%rax
			break;
  803a23:	eb 2e                	jmp    803a53 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  803a25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803a29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803a2d:	48 89 d6             	mov    %rdx,%rsi
  803a30:	bf 25 00 00 00       	mov    $0x25,%edi
  803a35:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  803a37:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803a3c:	eb 05                	jmp    803a43 <vprintfmt+0x4f9>
  803a3e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803a43:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803a47:	48 83 e8 01          	sub    $0x1,%rax
  803a4b:	0f b6 00             	movzbl (%rax),%eax
  803a4e:	3c 25                	cmp    $0x25,%al
  803a50:	75 ec                	jne    803a3e <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  803a52:	90                   	nop
		}
	}
  803a53:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803a54:	e9 43 fb ff ff       	jmpq   80359c <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  803a59:	48 83 c4 60          	add    $0x60,%rsp
  803a5d:	5b                   	pop    %rbx
  803a5e:	41 5c                	pop    %r12
  803a60:	5d                   	pop    %rbp
  803a61:	c3                   	retq   

0000000000803a62 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  803a62:	55                   	push   %rbp
  803a63:	48 89 e5             	mov    %rsp,%rbp
  803a66:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  803a6d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803a74:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  803a7b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803a82:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803a89:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803a90:	84 c0                	test   %al,%al
  803a92:	74 20                	je     803ab4 <printfmt+0x52>
  803a94:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803a98:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803a9c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803aa0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803aa4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803aa8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803aac:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803ab0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803ab4:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803abb:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  803ac2:	00 00 00 
  803ac5:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  803acc:	00 00 00 
  803acf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803ad3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  803ada:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803ae1:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  803ae8:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  803aef:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803af6:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  803afd:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803b04:	48 89 c7             	mov    %rax,%rdi
  803b07:	48 b8 4a 35 80 00 00 	movabs $0x80354a,%rax
  803b0e:	00 00 00 
  803b11:	ff d0                	callq  *%rax
	va_end(ap);
}
  803b13:	c9                   	leaveq 
  803b14:	c3                   	retq   

0000000000803b15 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  803b15:	55                   	push   %rbp
  803b16:	48 89 e5             	mov    %rsp,%rbp
  803b19:	48 83 ec 10          	sub    $0x10,%rsp
  803b1d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b20:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803b24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b28:	8b 40 10             	mov    0x10(%rax),%eax
  803b2b:	8d 50 01             	lea    0x1(%rax),%edx
  803b2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b32:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  803b35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b39:	48 8b 10             	mov    (%rax),%rdx
  803b3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b40:	48 8b 40 08          	mov    0x8(%rax),%rax
  803b44:	48 39 c2             	cmp    %rax,%rdx
  803b47:	73 17                	jae    803b60 <sprintputch+0x4b>
		*b->buf++ = ch;
  803b49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b4d:	48 8b 00             	mov    (%rax),%rax
  803b50:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803b54:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b58:	48 89 0a             	mov    %rcx,(%rdx)
  803b5b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b5e:	88 10                	mov    %dl,(%rax)
}
  803b60:	c9                   	leaveq 
  803b61:	c3                   	retq   

0000000000803b62 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803b62:	55                   	push   %rbp
  803b63:	48 89 e5             	mov    %rsp,%rbp
  803b66:	48 83 ec 50          	sub    $0x50,%rsp
  803b6a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803b6e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  803b71:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  803b75:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  803b79:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803b7d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  803b81:	48 8b 0a             	mov    (%rdx),%rcx
  803b84:	48 89 08             	mov    %rcx,(%rax)
  803b87:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803b8b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803b8f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803b93:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803b97:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b9b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803b9f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803ba2:	48 98                	cltq   
  803ba4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803ba8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803bac:	48 01 d0             	add    %rdx,%rax
  803baf:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803bb3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  803bba:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  803bbf:	74 06                	je     803bc7 <vsnprintf+0x65>
  803bc1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803bc5:	7f 07                	jg     803bce <vsnprintf+0x6c>
		return -E_INVAL;
  803bc7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803bcc:	eb 2f                	jmp    803bfd <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  803bce:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  803bd2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803bd6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803bda:	48 89 c6             	mov    %rax,%rsi
  803bdd:	48 bf 15 3b 80 00 00 	movabs $0x803b15,%rdi
  803be4:	00 00 00 
  803be7:	48 b8 4a 35 80 00 00 	movabs $0x80354a,%rax
  803bee:	00 00 00 
  803bf1:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  803bf3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bf7:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  803bfa:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  803bfd:	c9                   	leaveq 
  803bfe:	c3                   	retq   

0000000000803bff <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  803bff:	55                   	push   %rbp
  803c00:	48 89 e5             	mov    %rsp,%rbp
  803c03:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  803c0a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803c11:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803c17:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803c1e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803c25:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803c2c:	84 c0                	test   %al,%al
  803c2e:	74 20                	je     803c50 <snprintf+0x51>
  803c30:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803c34:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803c38:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803c3c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803c40:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803c44:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803c48:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803c4c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803c50:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  803c57:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  803c5e:	00 00 00 
  803c61:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803c68:	00 00 00 
  803c6b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803c6f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803c76:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803c7d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  803c84:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803c8b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803c92:	48 8b 0a             	mov    (%rdx),%rcx
  803c95:	48 89 08             	mov    %rcx,(%rax)
  803c98:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803c9c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803ca0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803ca4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803ca8:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  803caf:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  803cb6:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  803cbc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803cc3:	48 89 c7             	mov    %rax,%rdi
  803cc6:	48 b8 62 3b 80 00 00 	movabs $0x803b62,%rax
  803ccd:	00 00 00 
  803cd0:	ff d0                	callq  *%rax
  803cd2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  803cd8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803cde:	c9                   	leaveq 
  803cdf:	c3                   	retq   

0000000000803ce0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803ce0:	55                   	push   %rbp
  803ce1:	48 89 e5             	mov    %rsp,%rbp
  803ce4:	48 83 ec 30          	sub    $0x30,%rsp
  803ce8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803cec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803cf0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803cf4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cfb:	00 00 00 
  803cfe:	48 8b 00             	mov    (%rax),%rax
  803d01:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803d07:	85 c0                	test   %eax,%eax
  803d09:	75 3c                	jne    803d47 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803d0b:	48 b8 1f 0b 80 00 00 	movabs $0x800b1f,%rax
  803d12:	00 00 00 
  803d15:	ff d0                	callq  *%rax
  803d17:	25 ff 03 00 00       	and    $0x3ff,%eax
  803d1c:	48 63 d0             	movslq %eax,%rdx
  803d1f:	48 89 d0             	mov    %rdx,%rax
  803d22:	48 c1 e0 03          	shl    $0x3,%rax
  803d26:	48 01 d0             	add    %rdx,%rax
  803d29:	48 c1 e0 05          	shl    $0x5,%rax
  803d2d:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803d34:	00 00 00 
  803d37:	48 01 c2             	add    %rax,%rdx
  803d3a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d41:	00 00 00 
  803d44:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803d47:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d4c:	75 0e                	jne    803d5c <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803d4e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d55:	00 00 00 
  803d58:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803d5c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d60:	48 89 c7             	mov    %rax,%rdi
  803d63:	48 b8 c4 0d 80 00 00 	movabs $0x800dc4,%rax
  803d6a:	00 00 00 
  803d6d:	ff d0                	callq  *%rax
  803d6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803d72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d76:	79 19                	jns    803d91 <ipc_recv+0xb1>
		*from_env_store = 0;
  803d78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d7c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803d82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d86:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803d8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d8f:	eb 53                	jmp    803de4 <ipc_recv+0x104>
	}
	if(from_env_store)
  803d91:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803d96:	74 19                	je     803db1 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803d98:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d9f:	00 00 00 
  803da2:	48 8b 00             	mov    (%rax),%rax
  803da5:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803dab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803daf:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803db1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803db6:	74 19                	je     803dd1 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803db8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803dbf:	00 00 00 
  803dc2:	48 8b 00             	mov    (%rax),%rax
  803dc5:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803dcb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dcf:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803dd1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803dd8:	00 00 00 
  803ddb:	48 8b 00             	mov    (%rax),%rax
  803dde:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803de4:	c9                   	leaveq 
  803de5:	c3                   	retq   

0000000000803de6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803de6:	55                   	push   %rbp
  803de7:	48 89 e5             	mov    %rsp,%rbp
  803dea:	48 83 ec 30          	sub    $0x30,%rsp
  803dee:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803df1:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803df4:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803df8:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803dfb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e00:	75 0e                	jne    803e10 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803e02:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803e09:	00 00 00 
  803e0c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803e10:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803e13:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803e16:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803e1a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e1d:	89 c7                	mov    %eax,%edi
  803e1f:	48 b8 6f 0d 80 00 00 	movabs $0x800d6f,%rax
  803e26:	00 00 00 
  803e29:	ff d0                	callq  *%rax
  803e2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803e2e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803e32:	75 0c                	jne    803e40 <ipc_send+0x5a>
			sys_yield();
  803e34:	48 b8 5d 0b 80 00 00 	movabs $0x800b5d,%rax
  803e3b:	00 00 00 
  803e3e:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803e40:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803e44:	74 ca                	je     803e10 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803e46:	c9                   	leaveq 
  803e47:	c3                   	retq   

0000000000803e48 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803e48:	55                   	push   %rbp
  803e49:	48 89 e5             	mov    %rsp,%rbp
  803e4c:	48 83 ec 14          	sub    $0x14,%rsp
  803e50:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803e53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e5a:	eb 5e                	jmp    803eba <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803e5c:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803e63:	00 00 00 
  803e66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e69:	48 63 d0             	movslq %eax,%rdx
  803e6c:	48 89 d0             	mov    %rdx,%rax
  803e6f:	48 c1 e0 03          	shl    $0x3,%rax
  803e73:	48 01 d0             	add    %rdx,%rax
  803e76:	48 c1 e0 05          	shl    $0x5,%rax
  803e7a:	48 01 c8             	add    %rcx,%rax
  803e7d:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803e83:	8b 00                	mov    (%rax),%eax
  803e85:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803e88:	75 2c                	jne    803eb6 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803e8a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803e91:	00 00 00 
  803e94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e97:	48 63 d0             	movslq %eax,%rdx
  803e9a:	48 89 d0             	mov    %rdx,%rax
  803e9d:	48 c1 e0 03          	shl    $0x3,%rax
  803ea1:	48 01 d0             	add    %rdx,%rax
  803ea4:	48 c1 e0 05          	shl    $0x5,%rax
  803ea8:	48 01 c8             	add    %rcx,%rax
  803eab:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803eb1:	8b 40 08             	mov    0x8(%rax),%eax
  803eb4:	eb 12                	jmp    803ec8 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803eb6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803eba:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803ec1:	7e 99                	jle    803e5c <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803ec3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ec8:	c9                   	leaveq 
  803ec9:	c3                   	retq   

0000000000803eca <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803eca:	55                   	push   %rbp
  803ecb:	48 89 e5             	mov    %rsp,%rbp
  803ece:	48 83 ec 18          	sub    $0x18,%rsp
  803ed2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803ed6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803eda:	48 c1 e8 15          	shr    $0x15,%rax
  803ede:	48 89 c2             	mov    %rax,%rdx
  803ee1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803ee8:	01 00 00 
  803eeb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803eef:	83 e0 01             	and    $0x1,%eax
  803ef2:	48 85 c0             	test   %rax,%rax
  803ef5:	75 07                	jne    803efe <pageref+0x34>
		return 0;
  803ef7:	b8 00 00 00 00       	mov    $0x0,%eax
  803efc:	eb 53                	jmp    803f51 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803efe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f02:	48 c1 e8 0c          	shr    $0xc,%rax
  803f06:	48 89 c2             	mov    %rax,%rdx
  803f09:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f10:	01 00 00 
  803f13:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f17:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803f1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f1f:	83 e0 01             	and    $0x1,%eax
  803f22:	48 85 c0             	test   %rax,%rax
  803f25:	75 07                	jne    803f2e <pageref+0x64>
		return 0;
  803f27:	b8 00 00 00 00       	mov    $0x0,%eax
  803f2c:	eb 23                	jmp    803f51 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803f2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f32:	48 c1 e8 0c          	shr    $0xc,%rax
  803f36:	48 89 c2             	mov    %rax,%rdx
  803f39:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803f40:	00 00 00 
  803f43:	48 c1 e2 04          	shl    $0x4,%rdx
  803f47:	48 01 d0             	add    %rdx,%rax
  803f4a:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803f4e:	0f b7 c0             	movzwl %ax,%eax
}
  803f51:	c9                   	leaveq 
  803f52:	c3                   	retq   
