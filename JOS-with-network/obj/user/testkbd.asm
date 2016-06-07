
obj/user/testkbd.debug:     file format elf64-x86-64


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
  80003c:	e8 2a 04 00 00       	callq  80046b <libmain>
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
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800052:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800059:	eb 10                	jmp    80006b <umain+0x28>
		sys_yield();
  80005b:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  800062:	00 00 00 
  800065:	ff d0                	callq  *%rax
umain(int argc, char **argv)
{
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800067:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80006b:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
  80006f:	7e ea                	jle    80005b <umain+0x18>
		sys_yield();

	close(0);
  800071:	bf 00 00 00 00       	mov    $0x0,%edi
  800076:	48 b8 bd 23 80 00 00 	movabs $0x8023bd,%rax
  80007d:	00 00 00 
  800080:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  800082:	48 b8 79 02 80 00 00 	movabs $0x800279,%rax
  800089:	00 00 00 
  80008c:	ff d0                	callq  *%rax
  80008e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800091:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800095:	79 30                	jns    8000c7 <umain+0x84>
		panic("opencons: %e", r);
  800097:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80009a:	89 c1                	mov    %eax,%ecx
  80009c:	48 ba 20 44 80 00 00 	movabs $0x804420,%rdx
  8000a3:	00 00 00 
  8000a6:	be 0f 00 00 00       	mov    $0xf,%esi
  8000ab:	48 bf 2d 44 80 00 00 	movabs $0x80442d,%rdi
  8000b2:	00 00 00 
  8000b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ba:	49 b8 19 05 80 00 00 	movabs $0x800519,%r8
  8000c1:	00 00 00 
  8000c4:	41 ff d0             	callq  *%r8
	if (r != 0)
  8000c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cb:	74 30                	je     8000fd <umain+0xba>
		panic("first opencons used fd %d", r);
  8000cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba 3c 44 80 00 00 	movabs $0x80443c,%rdx
  8000d9:	00 00 00 
  8000dc:	be 11 00 00 00       	mov    $0x11,%esi
  8000e1:	48 bf 2d 44 80 00 00 	movabs $0x80442d,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 19 05 80 00 00 	movabs $0x800519,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  8000fd:	be 01 00 00 00       	mov    $0x1,%esi
  800102:	bf 00 00 00 00       	mov    $0x0,%edi
  800107:	48 b8 36 24 80 00 00 	movabs $0x802436,%rax
  80010e:	00 00 00 
  800111:	ff d0                	callq  *%rax
  800113:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800116:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80011a:	79 30                	jns    80014c <umain+0x109>
		panic("dup: %e", r);
  80011c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80011f:	89 c1                	mov    %eax,%ecx
  800121:	48 ba 56 44 80 00 00 	movabs $0x804456,%rdx
  800128:	00 00 00 
  80012b:	be 13 00 00 00       	mov    $0x13,%esi
  800130:	48 bf 2d 44 80 00 00 	movabs $0x80442d,%rdi
  800137:	00 00 00 
  80013a:	b8 00 00 00 00       	mov    $0x0,%eax
  80013f:	49 b8 19 05 80 00 00 	movabs $0x800519,%r8
  800146:	00 00 00 
  800149:	41 ff d0             	callq  *%r8

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  80014c:	48 bf 5e 44 80 00 00 	movabs $0x80445e,%rdi
  800153:	00 00 00 
  800156:	48 b8 9b 12 80 00 00 	movabs $0x80129b,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if (buf != NULL)
  800166:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  80016b:	74 29                	je     800196 <umain+0x153>
			fprintf(1, "%s\n", buf);
  80016d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800171:	48 89 c2             	mov    %rax,%rdx
  800174:	48 be 6c 44 80 00 00 	movabs $0x80446c,%rsi
  80017b:	00 00 00 
  80017e:	bf 01 00 00 00       	mov    $0x1,%edi
  800183:	b8 00 00 00 00       	mov    $0x0,%eax
  800188:	48 b9 61 32 80 00 00 	movabs $0x803261,%rcx
  80018f:	00 00 00 
  800192:	ff d1                	callq  *%rcx
		else
			fprintf(1, "(end of file received)\n");
	}
  800194:	eb b6                	jmp    80014c <umain+0x109>

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
		else
			fprintf(1, "(end of file received)\n");
  800196:	48 be 70 44 80 00 00 	movabs $0x804470,%rsi
  80019d:	00 00 00 
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
  8001a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001aa:	48 ba 61 32 80 00 00 	movabs $0x803261,%rdx
  8001b1:	00 00 00 
  8001b4:	ff d2                	callq  *%rdx
	}
  8001b6:	eb 94                	jmp    80014c <umain+0x109>

00000000008001b8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8001b8:	55                   	push   %rbp
  8001b9:	48 89 e5             	mov    %rsp,%rbp
  8001bc:	48 83 ec 20          	sub    $0x20,%rsp
  8001c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8001c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001c6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8001c9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8001cd:	be 01 00 00 00       	mov    $0x1,%esi
  8001d2:	48 89 c7             	mov    %rax,%rdi
  8001d5:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  8001dc:	00 00 00 
  8001df:	ff d0                	callq  *%rax
}
  8001e1:	c9                   	leaveq 
  8001e2:	c3                   	retq   

00000000008001e3 <getchar>:

int
getchar(void)
{
  8001e3:	55                   	push   %rbp
  8001e4:	48 89 e5             	mov    %rsp,%rbp
  8001e7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8001eb:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8001ef:	ba 01 00 00 00       	mov    $0x1,%edx
  8001f4:	48 89 c6             	mov    %rax,%rsi
  8001f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001fc:	48 b8 df 25 80 00 00 	movabs $0x8025df,%rax
  800203:	00 00 00 
  800206:	ff d0                	callq  *%rax
  800208:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80020b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80020f:	79 05                	jns    800216 <getchar+0x33>
		return r;
  800211:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800214:	eb 14                	jmp    80022a <getchar+0x47>
	if (r < 1)
  800216:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80021a:	7f 07                	jg     800223 <getchar+0x40>
		return -E_EOF;
  80021c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800221:	eb 07                	jmp    80022a <getchar+0x47>
	return c;
  800223:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800227:	0f b6 c0             	movzbl %al,%eax
}
  80022a:	c9                   	leaveq 
  80022b:	c3                   	retq   

000000000080022c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80022c:	55                   	push   %rbp
  80022d:	48 89 e5             	mov    %rsp,%rbp
  800230:	48 83 ec 20          	sub    $0x20,%rsp
  800234:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800237:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80023b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80023e:	48 89 d6             	mov    %rdx,%rsi
  800241:	89 c7                	mov    %eax,%edi
  800243:	48 b8 ad 21 80 00 00 	movabs $0x8021ad,%rax
  80024a:	00 00 00 
  80024d:	ff d0                	callq  *%rax
  80024f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800252:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800256:	79 05                	jns    80025d <iscons+0x31>
		return r;
  800258:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80025b:	eb 1a                	jmp    800277 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80025d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800261:	8b 10                	mov    (%rax),%edx
  800263:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80026a:	00 00 00 
  80026d:	8b 00                	mov    (%rax),%eax
  80026f:	39 c2                	cmp    %eax,%edx
  800271:	0f 94 c0             	sete   %al
  800274:	0f b6 c0             	movzbl %al,%eax
}
  800277:	c9                   	leaveq 
  800278:	c3                   	retq   

0000000000800279 <opencons>:

int
opencons(void)
{
  800279:	55                   	push   %rbp
  80027a:	48 89 e5             	mov    %rsp,%rbp
  80027d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800281:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800285:	48 89 c7             	mov    %rax,%rdi
  800288:	48 b8 15 21 80 00 00 	movabs $0x802115,%rax
  80028f:	00 00 00 
  800292:	ff d0                	callq  *%rax
  800294:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800297:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80029b:	79 05                	jns    8002a2 <opencons+0x29>
		return r;
  80029d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002a0:	eb 5b                	jmp    8002fd <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8002a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a6:	ba 07 04 00 00       	mov    $0x407,%edx
  8002ab:	48 89 c6             	mov    %rax,%rsi
  8002ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b3:	48 b8 90 1d 80 00 00 	movabs $0x801d90,%rax
  8002ba:	00 00 00 
  8002bd:	ff d0                	callq  *%rax
  8002bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8002c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002c6:	79 05                	jns    8002cd <opencons+0x54>
		return r;
  8002c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002cb:	eb 30                	jmp    8002fd <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8002cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d1:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8002d8:	00 00 00 
  8002db:	8b 12                	mov    (%rdx),%edx
  8002dd:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8002df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8002ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ee:	48 89 c7             	mov    %rax,%rdi
  8002f1:	48 b8 c7 20 80 00 00 	movabs $0x8020c7,%rax
  8002f8:	00 00 00 
  8002fb:	ff d0                	callq  *%rax
}
  8002fd:	c9                   	leaveq 
  8002fe:	c3                   	retq   

00000000008002ff <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8002ff:	55                   	push   %rbp
  800300:	48 89 e5             	mov    %rsp,%rbp
  800303:	48 83 ec 30          	sub    $0x30,%rsp
  800307:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80030b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80030f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800313:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800318:	75 07                	jne    800321 <devcons_read+0x22>
		return 0;
  80031a:	b8 00 00 00 00       	mov    $0x0,%eax
  80031f:	eb 4b                	jmp    80036c <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  800321:	eb 0c                	jmp    80032f <devcons_read+0x30>
		sys_yield();
  800323:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  80032a:	00 00 00 
  80032d:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80032f:	48 b8 92 1c 80 00 00 	movabs $0x801c92,%rax
  800336:	00 00 00 
  800339:	ff d0                	callq  *%rax
  80033b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80033e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800342:	74 df                	je     800323 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  800344:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800348:	79 05                	jns    80034f <devcons_read+0x50>
		return c;
  80034a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80034d:	eb 1d                	jmp    80036c <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80034f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800353:	75 07                	jne    80035c <devcons_read+0x5d>
		return 0;
  800355:	b8 00 00 00 00       	mov    $0x0,%eax
  80035a:	eb 10                	jmp    80036c <devcons_read+0x6d>
	*(char*)vbuf = c;
  80035c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80035f:	89 c2                	mov    %eax,%edx
  800361:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800365:	88 10                	mov    %dl,(%rax)
	return 1;
  800367:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80036c:	c9                   	leaveq 
  80036d:	c3                   	retq   

000000000080036e <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80036e:	55                   	push   %rbp
  80036f:	48 89 e5             	mov    %rsp,%rbp
  800372:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800379:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  800380:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800387:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80038e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800395:	eb 76                	jmp    80040d <devcons_write+0x9f>
		m = n - tot;
  800397:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80039e:	89 c2                	mov    %eax,%edx
  8003a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a3:	29 c2                	sub    %eax,%edx
  8003a5:	89 d0                	mov    %edx,%eax
  8003a7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8003aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003ad:	83 f8 7f             	cmp    $0x7f,%eax
  8003b0:	76 07                	jbe    8003b9 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8003b2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8003b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003bc:	48 63 d0             	movslq %eax,%rdx
  8003bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c2:	48 63 c8             	movslq %eax,%rcx
  8003c5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8003cc:	48 01 c1             	add    %rax,%rcx
  8003cf:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003d6:	48 89 ce             	mov    %rcx,%rsi
  8003d9:	48 89 c7             	mov    %rax,%rdi
  8003dc:	48 b8 85 17 80 00 00 	movabs $0x801785,%rax
  8003e3:	00 00 00 
  8003e6:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8003e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003eb:	48 63 d0             	movslq %eax,%rdx
  8003ee:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003f5:	48 89 d6             	mov    %rdx,%rsi
  8003f8:	48 89 c7             	mov    %rax,%rdi
  8003fb:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  800402:	00 00 00 
  800405:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800407:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80040a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80040d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800410:	48 98                	cltq   
  800412:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  800419:	0f 82 78 ff ff ff    	jb     800397 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80041f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800422:	c9                   	leaveq 
  800423:	c3                   	retq   

0000000000800424 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  800424:	55                   	push   %rbp
  800425:	48 89 e5             	mov    %rsp,%rbp
  800428:	48 83 ec 08          	sub    $0x8,%rsp
  80042c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  800430:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800435:	c9                   	leaveq 
  800436:	c3                   	retq   

0000000000800437 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800437:	55                   	push   %rbp
  800438:	48 89 e5             	mov    %rsp,%rbp
  80043b:	48 83 ec 10          	sub    $0x10,%rsp
  80043f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800443:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800447:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044b:	48 be 8d 44 80 00 00 	movabs $0x80448d,%rsi
  800452:	00 00 00 
  800455:	48 89 c7             	mov    %rax,%rdi
  800458:	48 b8 61 14 80 00 00 	movabs $0x801461,%rax
  80045f:	00 00 00 
  800462:	ff d0                	callq  *%rax
	return 0;
  800464:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800469:	c9                   	leaveq 
  80046a:	c3                   	retq   

000000000080046b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80046b:	55                   	push   %rbp
  80046c:	48 89 e5             	mov    %rsp,%rbp
  80046f:	48 83 ec 10          	sub    $0x10,%rsp
  800473:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800476:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80047a:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  800481:	00 00 00 
  800484:	ff d0                	callq  *%rax
  800486:	25 ff 03 00 00       	and    $0x3ff,%eax
  80048b:	48 63 d0             	movslq %eax,%rdx
  80048e:	48 89 d0             	mov    %rdx,%rax
  800491:	48 c1 e0 03          	shl    $0x3,%rax
  800495:	48 01 d0             	add    %rdx,%rax
  800498:	48 c1 e0 05          	shl    $0x5,%rax
  80049c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8004a3:	00 00 00 
  8004a6:	48 01 c2             	add    %rax,%rdx
  8004a9:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8004b0:	00 00 00 
  8004b3:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004ba:	7e 14                	jle    8004d0 <libmain+0x65>
		binaryname = argv[0];
  8004bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004c0:	48 8b 10             	mov    (%rax),%rdx
  8004c3:	48 b8 38 60 80 00 00 	movabs $0x806038,%rax
  8004ca:	00 00 00 
  8004cd:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8004d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004d7:	48 89 d6             	mov    %rdx,%rsi
  8004da:	89 c7                	mov    %eax,%edi
  8004dc:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8004e3:	00 00 00 
  8004e6:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8004e8:	48 b8 f6 04 80 00 00 	movabs $0x8004f6,%rax
  8004ef:	00 00 00 
  8004f2:	ff d0                	callq  *%rax
}
  8004f4:	c9                   	leaveq 
  8004f5:	c3                   	retq   

00000000008004f6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004f6:	55                   	push   %rbp
  8004f7:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8004fa:	48 b8 08 24 80 00 00 	movabs $0x802408,%rax
  800501:	00 00 00 
  800504:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800506:	bf 00 00 00 00       	mov    $0x0,%edi
  80050b:	48 b8 d0 1c 80 00 00 	movabs $0x801cd0,%rax
  800512:	00 00 00 
  800515:	ff d0                	callq  *%rax

}
  800517:	5d                   	pop    %rbp
  800518:	c3                   	retq   

0000000000800519 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800519:	55                   	push   %rbp
  80051a:	48 89 e5             	mov    %rsp,%rbp
  80051d:	53                   	push   %rbx
  80051e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800525:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80052c:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800532:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800539:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800540:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800547:	84 c0                	test   %al,%al
  800549:	74 23                	je     80056e <_panic+0x55>
  80054b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800552:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800556:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80055a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80055e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800562:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800566:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80056a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80056e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800575:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80057c:	00 00 00 
  80057f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800586:	00 00 00 
  800589:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80058d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800594:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80059b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005a2:	48 b8 38 60 80 00 00 	movabs $0x806038,%rax
  8005a9:	00 00 00 
  8005ac:	48 8b 18             	mov    (%rax),%rbx
  8005af:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  8005b6:	00 00 00 
  8005b9:	ff d0                	callq  *%rax
  8005bb:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8005c1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005c8:	41 89 c8             	mov    %ecx,%r8d
  8005cb:	48 89 d1             	mov    %rdx,%rcx
  8005ce:	48 89 da             	mov    %rbx,%rdx
  8005d1:	89 c6                	mov    %eax,%esi
  8005d3:	48 bf a0 44 80 00 00 	movabs $0x8044a0,%rdi
  8005da:	00 00 00 
  8005dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e2:	49 b9 52 07 80 00 00 	movabs $0x800752,%r9
  8005e9:	00 00 00 
  8005ec:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005ef:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005f6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005fd:	48 89 d6             	mov    %rdx,%rsi
  800600:	48 89 c7             	mov    %rax,%rdi
  800603:	48 b8 a6 06 80 00 00 	movabs $0x8006a6,%rax
  80060a:	00 00 00 
  80060d:	ff d0                	callq  *%rax
	cprintf("\n");
  80060f:	48 bf c3 44 80 00 00 	movabs $0x8044c3,%rdi
  800616:	00 00 00 
  800619:	b8 00 00 00 00       	mov    $0x0,%eax
  80061e:	48 ba 52 07 80 00 00 	movabs $0x800752,%rdx
  800625:	00 00 00 
  800628:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80062a:	cc                   	int3   
  80062b:	eb fd                	jmp    80062a <_panic+0x111>

000000000080062d <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80062d:	55                   	push   %rbp
  80062e:	48 89 e5             	mov    %rsp,%rbp
  800631:	48 83 ec 10          	sub    $0x10,%rsp
  800635:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800638:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80063c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800640:	8b 00                	mov    (%rax),%eax
  800642:	8d 48 01             	lea    0x1(%rax),%ecx
  800645:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800649:	89 0a                	mov    %ecx,(%rdx)
  80064b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80064e:	89 d1                	mov    %edx,%ecx
  800650:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800654:	48 98                	cltq   
  800656:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80065a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80065e:	8b 00                	mov    (%rax),%eax
  800660:	3d ff 00 00 00       	cmp    $0xff,%eax
  800665:	75 2c                	jne    800693 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800667:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80066b:	8b 00                	mov    (%rax),%eax
  80066d:	48 98                	cltq   
  80066f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800673:	48 83 c2 08          	add    $0x8,%rdx
  800677:	48 89 c6             	mov    %rax,%rsi
  80067a:	48 89 d7             	mov    %rdx,%rdi
  80067d:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  800684:	00 00 00 
  800687:	ff d0                	callq  *%rax
        b->idx = 0;
  800689:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800693:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800697:	8b 40 04             	mov    0x4(%rax),%eax
  80069a:	8d 50 01             	lea    0x1(%rax),%edx
  80069d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006a1:	89 50 04             	mov    %edx,0x4(%rax)
}
  8006a4:	c9                   	leaveq 
  8006a5:	c3                   	retq   

00000000008006a6 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8006a6:	55                   	push   %rbp
  8006a7:	48 89 e5             	mov    %rsp,%rbp
  8006aa:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006b1:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006b8:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006bf:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006c6:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006cd:	48 8b 0a             	mov    (%rdx),%rcx
  8006d0:	48 89 08             	mov    %rcx,(%rax)
  8006d3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006d7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006db:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006df:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006e3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006ea:	00 00 00 
    b.cnt = 0;
  8006ed:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006f4:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006f7:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006fe:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800705:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80070c:	48 89 c6             	mov    %rax,%rsi
  80070f:	48 bf 2d 06 80 00 00 	movabs $0x80062d,%rdi
  800716:	00 00 00 
  800719:	48 b8 05 0b 80 00 00 	movabs $0x800b05,%rax
  800720:	00 00 00 
  800723:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800725:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80072b:	48 98                	cltq   
  80072d:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800734:	48 83 c2 08          	add    $0x8,%rdx
  800738:	48 89 c6             	mov    %rax,%rsi
  80073b:	48 89 d7             	mov    %rdx,%rdi
  80073e:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  800745:	00 00 00 
  800748:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80074a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800750:	c9                   	leaveq 
  800751:	c3                   	retq   

0000000000800752 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800752:	55                   	push   %rbp
  800753:	48 89 e5             	mov    %rsp,%rbp
  800756:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80075d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800764:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80076b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800772:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800779:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800780:	84 c0                	test   %al,%al
  800782:	74 20                	je     8007a4 <cprintf+0x52>
  800784:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800788:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80078c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800790:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800794:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800798:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80079c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8007a0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8007a4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8007ab:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007b2:	00 00 00 
  8007b5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007bc:	00 00 00 
  8007bf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007c3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007ca:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007d1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007d8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007df:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007e6:	48 8b 0a             	mov    (%rdx),%rcx
  8007e9:	48 89 08             	mov    %rcx,(%rax)
  8007ec:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007f0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007f4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007f8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007fc:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800803:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80080a:	48 89 d6             	mov    %rdx,%rsi
  80080d:	48 89 c7             	mov    %rax,%rdi
  800810:	48 b8 a6 06 80 00 00 	movabs $0x8006a6,%rax
  800817:	00 00 00 
  80081a:	ff d0                	callq  *%rax
  80081c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800822:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800828:	c9                   	leaveq 
  800829:	c3                   	retq   

000000000080082a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80082a:	55                   	push   %rbp
  80082b:	48 89 e5             	mov    %rsp,%rbp
  80082e:	53                   	push   %rbx
  80082f:	48 83 ec 38          	sub    $0x38,%rsp
  800833:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800837:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80083b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80083f:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800842:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800846:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80084a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80084d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800851:	77 3b                	ja     80088e <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800853:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800856:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80085a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80085d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800861:	ba 00 00 00 00       	mov    $0x0,%edx
  800866:	48 f7 f3             	div    %rbx
  800869:	48 89 c2             	mov    %rax,%rdx
  80086c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80086f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800872:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800876:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087a:	41 89 f9             	mov    %edi,%r9d
  80087d:	48 89 c7             	mov    %rax,%rdi
  800880:	48 b8 2a 08 80 00 00 	movabs $0x80082a,%rax
  800887:	00 00 00 
  80088a:	ff d0                	callq  *%rax
  80088c:	eb 1e                	jmp    8008ac <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80088e:	eb 12                	jmp    8008a2 <printnum+0x78>
			putch(padc, putdat);
  800890:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800894:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800897:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089b:	48 89 ce             	mov    %rcx,%rsi
  80089e:	89 d7                	mov    %edx,%edi
  8008a0:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008a2:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8008a6:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8008aa:	7f e4                	jg     800890 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008ac:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8008af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b8:	48 f7 f1             	div    %rcx
  8008bb:	48 89 d0             	mov    %rdx,%rax
  8008be:	48 ba d0 46 80 00 00 	movabs $0x8046d0,%rdx
  8008c5:	00 00 00 
  8008c8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008cc:	0f be d0             	movsbl %al,%edx
  8008cf:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d7:	48 89 ce             	mov    %rcx,%rsi
  8008da:	89 d7                	mov    %edx,%edi
  8008dc:	ff d0                	callq  *%rax
}
  8008de:	48 83 c4 38          	add    $0x38,%rsp
  8008e2:	5b                   	pop    %rbx
  8008e3:	5d                   	pop    %rbp
  8008e4:	c3                   	retq   

00000000008008e5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008e5:	55                   	push   %rbp
  8008e6:	48 89 e5             	mov    %rsp,%rbp
  8008e9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008f1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008f4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008f8:	7e 52                	jle    80094c <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fe:	8b 00                	mov    (%rax),%eax
  800900:	83 f8 30             	cmp    $0x30,%eax
  800903:	73 24                	jae    800929 <getuint+0x44>
  800905:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800909:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80090d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800911:	8b 00                	mov    (%rax),%eax
  800913:	89 c0                	mov    %eax,%eax
  800915:	48 01 d0             	add    %rdx,%rax
  800918:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091c:	8b 12                	mov    (%rdx),%edx
  80091e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800921:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800925:	89 0a                	mov    %ecx,(%rdx)
  800927:	eb 17                	jmp    800940 <getuint+0x5b>
  800929:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800931:	48 89 d0             	mov    %rdx,%rax
  800934:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800938:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800940:	48 8b 00             	mov    (%rax),%rax
  800943:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800947:	e9 a3 00 00 00       	jmpq   8009ef <getuint+0x10a>
	else if (lflag)
  80094c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800950:	74 4f                	je     8009a1 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800952:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800956:	8b 00                	mov    (%rax),%eax
  800958:	83 f8 30             	cmp    $0x30,%eax
  80095b:	73 24                	jae    800981 <getuint+0x9c>
  80095d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800961:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800965:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800969:	8b 00                	mov    (%rax),%eax
  80096b:	89 c0                	mov    %eax,%eax
  80096d:	48 01 d0             	add    %rdx,%rax
  800970:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800974:	8b 12                	mov    (%rdx),%edx
  800976:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800979:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097d:	89 0a                	mov    %ecx,(%rdx)
  80097f:	eb 17                	jmp    800998 <getuint+0xb3>
  800981:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800985:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800989:	48 89 d0             	mov    %rdx,%rax
  80098c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800990:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800994:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800998:	48 8b 00             	mov    (%rax),%rax
  80099b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80099f:	eb 4e                	jmp    8009ef <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8009a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a5:	8b 00                	mov    (%rax),%eax
  8009a7:	83 f8 30             	cmp    $0x30,%eax
  8009aa:	73 24                	jae    8009d0 <getuint+0xeb>
  8009ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b8:	8b 00                	mov    (%rax),%eax
  8009ba:	89 c0                	mov    %eax,%eax
  8009bc:	48 01 d0             	add    %rdx,%rax
  8009bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c3:	8b 12                	mov    (%rdx),%edx
  8009c5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009cc:	89 0a                	mov    %ecx,(%rdx)
  8009ce:	eb 17                	jmp    8009e7 <getuint+0x102>
  8009d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009d8:	48 89 d0             	mov    %rdx,%rax
  8009db:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009e7:	8b 00                	mov    (%rax),%eax
  8009e9:	89 c0                	mov    %eax,%eax
  8009eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009f3:	c9                   	leaveq 
  8009f4:	c3                   	retq   

00000000008009f5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009f5:	55                   	push   %rbp
  8009f6:	48 89 e5             	mov    %rsp,%rbp
  8009f9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a01:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a04:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a08:	7e 52                	jle    800a5c <getint+0x67>
		x=va_arg(*ap, long long);
  800a0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0e:	8b 00                	mov    (%rax),%eax
  800a10:	83 f8 30             	cmp    $0x30,%eax
  800a13:	73 24                	jae    800a39 <getint+0x44>
  800a15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a19:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a21:	8b 00                	mov    (%rax),%eax
  800a23:	89 c0                	mov    %eax,%eax
  800a25:	48 01 d0             	add    %rdx,%rax
  800a28:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2c:	8b 12                	mov    (%rdx),%edx
  800a2e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a31:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a35:	89 0a                	mov    %ecx,(%rdx)
  800a37:	eb 17                	jmp    800a50 <getint+0x5b>
  800a39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a41:	48 89 d0             	mov    %rdx,%rax
  800a44:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a48:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a50:	48 8b 00             	mov    (%rax),%rax
  800a53:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a57:	e9 a3 00 00 00       	jmpq   800aff <getint+0x10a>
	else if (lflag)
  800a5c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a60:	74 4f                	je     800ab1 <getint+0xbc>
		x=va_arg(*ap, long);
  800a62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a66:	8b 00                	mov    (%rax),%eax
  800a68:	83 f8 30             	cmp    $0x30,%eax
  800a6b:	73 24                	jae    800a91 <getint+0x9c>
  800a6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a71:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a79:	8b 00                	mov    (%rax),%eax
  800a7b:	89 c0                	mov    %eax,%eax
  800a7d:	48 01 d0             	add    %rdx,%rax
  800a80:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a84:	8b 12                	mov    (%rdx),%edx
  800a86:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a89:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a8d:	89 0a                	mov    %ecx,(%rdx)
  800a8f:	eb 17                	jmp    800aa8 <getint+0xb3>
  800a91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a95:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a99:	48 89 d0             	mov    %rdx,%rax
  800a9c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800aa0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aa8:	48 8b 00             	mov    (%rax),%rax
  800aab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800aaf:	eb 4e                	jmp    800aff <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800ab1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab5:	8b 00                	mov    (%rax),%eax
  800ab7:	83 f8 30             	cmp    $0x30,%eax
  800aba:	73 24                	jae    800ae0 <getint+0xeb>
  800abc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ac4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac8:	8b 00                	mov    (%rax),%eax
  800aca:	89 c0                	mov    %eax,%eax
  800acc:	48 01 d0             	add    %rdx,%rax
  800acf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad3:	8b 12                	mov    (%rdx),%edx
  800ad5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ad8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800adc:	89 0a                	mov    %ecx,(%rdx)
  800ade:	eb 17                	jmp    800af7 <getint+0x102>
  800ae0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ae8:	48 89 d0             	mov    %rdx,%rax
  800aeb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800aef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800af7:	8b 00                	mov    (%rax),%eax
  800af9:	48 98                	cltq   
  800afb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800aff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b03:	c9                   	leaveq 
  800b04:	c3                   	retq   

0000000000800b05 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b05:	55                   	push   %rbp
  800b06:	48 89 e5             	mov    %rsp,%rbp
  800b09:	41 54                	push   %r12
  800b0b:	53                   	push   %rbx
  800b0c:	48 83 ec 60          	sub    $0x60,%rsp
  800b10:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b14:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b18:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b1c:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b20:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b24:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b28:	48 8b 0a             	mov    (%rdx),%rcx
  800b2b:	48 89 08             	mov    %rcx,(%rax)
  800b2e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b32:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b36:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b3a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b3e:	eb 17                	jmp    800b57 <vprintfmt+0x52>
			if (ch == '\0')
  800b40:	85 db                	test   %ebx,%ebx
  800b42:	0f 84 cc 04 00 00    	je     801014 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800b48:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b4c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b50:	48 89 d6             	mov    %rdx,%rsi
  800b53:	89 df                	mov    %ebx,%edi
  800b55:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b57:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b5b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b5f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b63:	0f b6 00             	movzbl (%rax),%eax
  800b66:	0f b6 d8             	movzbl %al,%ebx
  800b69:	83 fb 25             	cmp    $0x25,%ebx
  800b6c:	75 d2                	jne    800b40 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b6e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b72:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b79:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b80:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b87:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b8e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b92:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b96:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b9a:	0f b6 00             	movzbl (%rax),%eax
  800b9d:	0f b6 d8             	movzbl %al,%ebx
  800ba0:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800ba3:	83 f8 55             	cmp    $0x55,%eax
  800ba6:	0f 87 34 04 00 00    	ja     800fe0 <vprintfmt+0x4db>
  800bac:	89 c0                	mov    %eax,%eax
  800bae:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800bb5:	00 
  800bb6:	48 b8 f8 46 80 00 00 	movabs $0x8046f8,%rax
  800bbd:	00 00 00 
  800bc0:	48 01 d0             	add    %rdx,%rax
  800bc3:	48 8b 00             	mov    (%rax),%rax
  800bc6:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800bc8:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bcc:	eb c0                	jmp    800b8e <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bce:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bd2:	eb ba                	jmp    800b8e <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bd4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bdb:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bde:	89 d0                	mov    %edx,%eax
  800be0:	c1 e0 02             	shl    $0x2,%eax
  800be3:	01 d0                	add    %edx,%eax
  800be5:	01 c0                	add    %eax,%eax
  800be7:	01 d8                	add    %ebx,%eax
  800be9:	83 e8 30             	sub    $0x30,%eax
  800bec:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bef:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bf3:	0f b6 00             	movzbl (%rax),%eax
  800bf6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bf9:	83 fb 2f             	cmp    $0x2f,%ebx
  800bfc:	7e 0c                	jle    800c0a <vprintfmt+0x105>
  800bfe:	83 fb 39             	cmp    $0x39,%ebx
  800c01:	7f 07                	jg     800c0a <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c03:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c08:	eb d1                	jmp    800bdb <vprintfmt+0xd6>
			goto process_precision;
  800c0a:	eb 58                	jmp    800c64 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800c0c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c0f:	83 f8 30             	cmp    $0x30,%eax
  800c12:	73 17                	jae    800c2b <vprintfmt+0x126>
  800c14:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c18:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c1b:	89 c0                	mov    %eax,%eax
  800c1d:	48 01 d0             	add    %rdx,%rax
  800c20:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c23:	83 c2 08             	add    $0x8,%edx
  800c26:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c29:	eb 0f                	jmp    800c3a <vprintfmt+0x135>
  800c2b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c2f:	48 89 d0             	mov    %rdx,%rax
  800c32:	48 83 c2 08          	add    $0x8,%rdx
  800c36:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c3a:	8b 00                	mov    (%rax),%eax
  800c3c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c3f:	eb 23                	jmp    800c64 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800c41:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c45:	79 0c                	jns    800c53 <vprintfmt+0x14e>
				width = 0;
  800c47:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c4e:	e9 3b ff ff ff       	jmpq   800b8e <vprintfmt+0x89>
  800c53:	e9 36 ff ff ff       	jmpq   800b8e <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c58:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c5f:	e9 2a ff ff ff       	jmpq   800b8e <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c64:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c68:	79 12                	jns    800c7c <vprintfmt+0x177>
				width = precision, precision = -1;
  800c6a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c6d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c70:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c77:	e9 12 ff ff ff       	jmpq   800b8e <vprintfmt+0x89>
  800c7c:	e9 0d ff ff ff       	jmpq   800b8e <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c81:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c85:	e9 04 ff ff ff       	jmpq   800b8e <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c8a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8d:	83 f8 30             	cmp    $0x30,%eax
  800c90:	73 17                	jae    800ca9 <vprintfmt+0x1a4>
  800c92:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c96:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c99:	89 c0                	mov    %eax,%eax
  800c9b:	48 01 d0             	add    %rdx,%rax
  800c9e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ca1:	83 c2 08             	add    $0x8,%edx
  800ca4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ca7:	eb 0f                	jmp    800cb8 <vprintfmt+0x1b3>
  800ca9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cad:	48 89 d0             	mov    %rdx,%rax
  800cb0:	48 83 c2 08          	add    $0x8,%rdx
  800cb4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cb8:	8b 10                	mov    (%rax),%edx
  800cba:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cbe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc2:	48 89 ce             	mov    %rcx,%rsi
  800cc5:	89 d7                	mov    %edx,%edi
  800cc7:	ff d0                	callq  *%rax
			break;
  800cc9:	e9 40 03 00 00       	jmpq   80100e <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800cce:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd1:	83 f8 30             	cmp    $0x30,%eax
  800cd4:	73 17                	jae    800ced <vprintfmt+0x1e8>
  800cd6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cda:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cdd:	89 c0                	mov    %eax,%eax
  800cdf:	48 01 d0             	add    %rdx,%rax
  800ce2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ce5:	83 c2 08             	add    $0x8,%edx
  800ce8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ceb:	eb 0f                	jmp    800cfc <vprintfmt+0x1f7>
  800ced:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cf1:	48 89 d0             	mov    %rdx,%rax
  800cf4:	48 83 c2 08          	add    $0x8,%rdx
  800cf8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cfc:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cfe:	85 db                	test   %ebx,%ebx
  800d00:	79 02                	jns    800d04 <vprintfmt+0x1ff>
				err = -err;
  800d02:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d04:	83 fb 15             	cmp    $0x15,%ebx
  800d07:	7f 16                	jg     800d1f <vprintfmt+0x21a>
  800d09:	48 b8 20 46 80 00 00 	movabs $0x804620,%rax
  800d10:	00 00 00 
  800d13:	48 63 d3             	movslq %ebx,%rdx
  800d16:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d1a:	4d 85 e4             	test   %r12,%r12
  800d1d:	75 2e                	jne    800d4d <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800d1f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d27:	89 d9                	mov    %ebx,%ecx
  800d29:	48 ba e1 46 80 00 00 	movabs $0x8046e1,%rdx
  800d30:	00 00 00 
  800d33:	48 89 c7             	mov    %rax,%rdi
  800d36:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3b:	49 b8 1d 10 80 00 00 	movabs $0x80101d,%r8
  800d42:	00 00 00 
  800d45:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d48:	e9 c1 02 00 00       	jmpq   80100e <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d4d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d51:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d55:	4c 89 e1             	mov    %r12,%rcx
  800d58:	48 ba ea 46 80 00 00 	movabs $0x8046ea,%rdx
  800d5f:	00 00 00 
  800d62:	48 89 c7             	mov    %rax,%rdi
  800d65:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6a:	49 b8 1d 10 80 00 00 	movabs $0x80101d,%r8
  800d71:	00 00 00 
  800d74:	41 ff d0             	callq  *%r8
			break;
  800d77:	e9 92 02 00 00       	jmpq   80100e <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d7c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d7f:	83 f8 30             	cmp    $0x30,%eax
  800d82:	73 17                	jae    800d9b <vprintfmt+0x296>
  800d84:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d88:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d8b:	89 c0                	mov    %eax,%eax
  800d8d:	48 01 d0             	add    %rdx,%rax
  800d90:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d93:	83 c2 08             	add    $0x8,%edx
  800d96:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d99:	eb 0f                	jmp    800daa <vprintfmt+0x2a5>
  800d9b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d9f:	48 89 d0             	mov    %rdx,%rax
  800da2:	48 83 c2 08          	add    $0x8,%rdx
  800da6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800daa:	4c 8b 20             	mov    (%rax),%r12
  800dad:	4d 85 e4             	test   %r12,%r12
  800db0:	75 0a                	jne    800dbc <vprintfmt+0x2b7>
				p = "(null)";
  800db2:	49 bc ed 46 80 00 00 	movabs $0x8046ed,%r12
  800db9:	00 00 00 
			if (width > 0 && padc != '-')
  800dbc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dc0:	7e 3f                	jle    800e01 <vprintfmt+0x2fc>
  800dc2:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800dc6:	74 39                	je     800e01 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800dcb:	48 98                	cltq   
  800dcd:	48 89 c6             	mov    %rax,%rsi
  800dd0:	4c 89 e7             	mov    %r12,%rdi
  800dd3:	48 b8 23 14 80 00 00 	movabs $0x801423,%rax
  800dda:	00 00 00 
  800ddd:	ff d0                	callq  *%rax
  800ddf:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800de2:	eb 17                	jmp    800dfb <vprintfmt+0x2f6>
					putch(padc, putdat);
  800de4:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800de8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800dec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df0:	48 89 ce             	mov    %rcx,%rsi
  800df3:	89 d7                	mov    %edx,%edi
  800df5:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800df7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dfb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dff:	7f e3                	jg     800de4 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e01:	eb 37                	jmp    800e3a <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800e03:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e07:	74 1e                	je     800e27 <vprintfmt+0x322>
  800e09:	83 fb 1f             	cmp    $0x1f,%ebx
  800e0c:	7e 05                	jle    800e13 <vprintfmt+0x30e>
  800e0e:	83 fb 7e             	cmp    $0x7e,%ebx
  800e11:	7e 14                	jle    800e27 <vprintfmt+0x322>
					putch('?', putdat);
  800e13:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e17:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e1b:	48 89 d6             	mov    %rdx,%rsi
  800e1e:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e23:	ff d0                	callq  *%rax
  800e25:	eb 0f                	jmp    800e36 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800e27:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e2b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e2f:	48 89 d6             	mov    %rdx,%rsi
  800e32:	89 df                	mov    %ebx,%edi
  800e34:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e36:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e3a:	4c 89 e0             	mov    %r12,%rax
  800e3d:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e41:	0f b6 00             	movzbl (%rax),%eax
  800e44:	0f be d8             	movsbl %al,%ebx
  800e47:	85 db                	test   %ebx,%ebx
  800e49:	74 10                	je     800e5b <vprintfmt+0x356>
  800e4b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e4f:	78 b2                	js     800e03 <vprintfmt+0x2fe>
  800e51:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e55:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e59:	79 a8                	jns    800e03 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e5b:	eb 16                	jmp    800e73 <vprintfmt+0x36e>
				putch(' ', putdat);
  800e5d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e65:	48 89 d6             	mov    %rdx,%rsi
  800e68:	bf 20 00 00 00       	mov    $0x20,%edi
  800e6d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e6f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e73:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e77:	7f e4                	jg     800e5d <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800e79:	e9 90 01 00 00       	jmpq   80100e <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e7e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e82:	be 03 00 00 00       	mov    $0x3,%esi
  800e87:	48 89 c7             	mov    %rax,%rdi
  800e8a:	48 b8 f5 09 80 00 00 	movabs $0x8009f5,%rax
  800e91:	00 00 00 
  800e94:	ff d0                	callq  *%rax
  800e96:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9e:	48 85 c0             	test   %rax,%rax
  800ea1:	79 1d                	jns    800ec0 <vprintfmt+0x3bb>
				putch('-', putdat);
  800ea3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ea7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eab:	48 89 d6             	mov    %rdx,%rsi
  800eae:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800eb3:	ff d0                	callq  *%rax
				num = -(long long) num;
  800eb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb9:	48 f7 d8             	neg    %rax
  800ebc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ec0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ec7:	e9 d5 00 00 00       	jmpq   800fa1 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ecc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ed0:	be 03 00 00 00       	mov    $0x3,%esi
  800ed5:	48 89 c7             	mov    %rax,%rdi
  800ed8:	48 b8 e5 08 80 00 00 	movabs $0x8008e5,%rax
  800edf:	00 00 00 
  800ee2:	ff d0                	callq  *%rax
  800ee4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ee8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800eef:	e9 ad 00 00 00       	jmpq   800fa1 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800ef4:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800ef7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800efb:	89 d6                	mov    %edx,%esi
  800efd:	48 89 c7             	mov    %rax,%rdi
  800f00:	48 b8 f5 09 80 00 00 	movabs $0x8009f5,%rax
  800f07:	00 00 00 
  800f0a:	ff d0                	callq  *%rax
  800f0c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800f10:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f17:	e9 85 00 00 00       	jmpq   800fa1 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800f1c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f20:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f24:	48 89 d6             	mov    %rdx,%rsi
  800f27:	bf 30 00 00 00       	mov    $0x30,%edi
  800f2c:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f2e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f36:	48 89 d6             	mov    %rdx,%rsi
  800f39:	bf 78 00 00 00       	mov    $0x78,%edi
  800f3e:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f40:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f43:	83 f8 30             	cmp    $0x30,%eax
  800f46:	73 17                	jae    800f5f <vprintfmt+0x45a>
  800f48:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f4c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f4f:	89 c0                	mov    %eax,%eax
  800f51:	48 01 d0             	add    %rdx,%rax
  800f54:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f57:	83 c2 08             	add    $0x8,%edx
  800f5a:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f5d:	eb 0f                	jmp    800f6e <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800f5f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f63:	48 89 d0             	mov    %rdx,%rax
  800f66:	48 83 c2 08          	add    $0x8,%rdx
  800f6a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f6e:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f71:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f75:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f7c:	eb 23                	jmp    800fa1 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f7e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f82:	be 03 00 00 00       	mov    $0x3,%esi
  800f87:	48 89 c7             	mov    %rax,%rdi
  800f8a:	48 b8 e5 08 80 00 00 	movabs $0x8008e5,%rax
  800f91:	00 00 00 
  800f94:	ff d0                	callq  *%rax
  800f96:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f9a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fa1:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800fa6:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800fa9:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800fac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fb0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fb4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fb8:	45 89 c1             	mov    %r8d,%r9d
  800fbb:	41 89 f8             	mov    %edi,%r8d
  800fbe:	48 89 c7             	mov    %rax,%rdi
  800fc1:	48 b8 2a 08 80 00 00 	movabs $0x80082a,%rax
  800fc8:	00 00 00 
  800fcb:	ff d0                	callq  *%rax
			break;
  800fcd:	eb 3f                	jmp    80100e <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fcf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fd3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fd7:	48 89 d6             	mov    %rdx,%rsi
  800fda:	89 df                	mov    %ebx,%edi
  800fdc:	ff d0                	callq  *%rax
			break;
  800fde:	eb 2e                	jmp    80100e <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fe0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fe4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fe8:	48 89 d6             	mov    %rdx,%rsi
  800feb:	bf 25 00 00 00       	mov    $0x25,%edi
  800ff0:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ff2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ff7:	eb 05                	jmp    800ffe <vprintfmt+0x4f9>
  800ff9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ffe:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801002:	48 83 e8 01          	sub    $0x1,%rax
  801006:	0f b6 00             	movzbl (%rax),%eax
  801009:	3c 25                	cmp    $0x25,%al
  80100b:	75 ec                	jne    800ff9 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  80100d:	90                   	nop
		}
	}
  80100e:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80100f:	e9 43 fb ff ff       	jmpq   800b57 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801014:	48 83 c4 60          	add    $0x60,%rsp
  801018:	5b                   	pop    %rbx
  801019:	41 5c                	pop    %r12
  80101b:	5d                   	pop    %rbp
  80101c:	c3                   	retq   

000000000080101d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80101d:	55                   	push   %rbp
  80101e:	48 89 e5             	mov    %rsp,%rbp
  801021:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801028:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80102f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801036:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80103d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801044:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80104b:	84 c0                	test   %al,%al
  80104d:	74 20                	je     80106f <printfmt+0x52>
  80104f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801053:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801057:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80105b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80105f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801063:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801067:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80106b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80106f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801076:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80107d:	00 00 00 
  801080:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801087:	00 00 00 
  80108a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80108e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801095:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80109c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8010a3:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010aa:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010b1:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010b8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010bf:	48 89 c7             	mov    %rax,%rdi
  8010c2:	48 b8 05 0b 80 00 00 	movabs $0x800b05,%rax
  8010c9:	00 00 00 
  8010cc:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010ce:	c9                   	leaveq 
  8010cf:	c3                   	retq   

00000000008010d0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010d0:	55                   	push   %rbp
  8010d1:	48 89 e5             	mov    %rsp,%rbp
  8010d4:	48 83 ec 10          	sub    $0x10,%rsp
  8010d8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e3:	8b 40 10             	mov    0x10(%rax),%eax
  8010e6:	8d 50 01             	lea    0x1(%rax),%edx
  8010e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ed:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f4:	48 8b 10             	mov    (%rax),%rdx
  8010f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010fb:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010ff:	48 39 c2             	cmp    %rax,%rdx
  801102:	73 17                	jae    80111b <sprintputch+0x4b>
		*b->buf++ = ch;
  801104:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801108:	48 8b 00             	mov    (%rax),%rax
  80110b:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80110f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801113:	48 89 0a             	mov    %rcx,(%rdx)
  801116:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801119:	88 10                	mov    %dl,(%rax)
}
  80111b:	c9                   	leaveq 
  80111c:	c3                   	retq   

000000000080111d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80111d:	55                   	push   %rbp
  80111e:	48 89 e5             	mov    %rsp,%rbp
  801121:	48 83 ec 50          	sub    $0x50,%rsp
  801125:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801129:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80112c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801130:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801134:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801138:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80113c:	48 8b 0a             	mov    (%rdx),%rcx
  80113f:	48 89 08             	mov    %rcx,(%rax)
  801142:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801146:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80114a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80114e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801152:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801156:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80115a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80115d:	48 98                	cltq   
  80115f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801163:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801167:	48 01 d0             	add    %rdx,%rax
  80116a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80116e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801175:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80117a:	74 06                	je     801182 <vsnprintf+0x65>
  80117c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801180:	7f 07                	jg     801189 <vsnprintf+0x6c>
		return -E_INVAL;
  801182:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801187:	eb 2f                	jmp    8011b8 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801189:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80118d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801191:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801195:	48 89 c6             	mov    %rax,%rsi
  801198:	48 bf d0 10 80 00 00 	movabs $0x8010d0,%rdi
  80119f:	00 00 00 
  8011a2:	48 b8 05 0b 80 00 00 	movabs $0x800b05,%rax
  8011a9:	00 00 00 
  8011ac:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011b2:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011b5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011b8:	c9                   	leaveq 
  8011b9:	c3                   	retq   

00000000008011ba <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011ba:	55                   	push   %rbp
  8011bb:	48 89 e5             	mov    %rsp,%rbp
  8011be:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011c5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011cc:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011d2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011d9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011e0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011e7:	84 c0                	test   %al,%al
  8011e9:	74 20                	je     80120b <snprintf+0x51>
  8011eb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011ef:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011f3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011f7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011fb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011ff:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801203:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801207:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80120b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801212:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801219:	00 00 00 
  80121c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801223:	00 00 00 
  801226:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80122a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801231:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801238:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80123f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801246:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80124d:	48 8b 0a             	mov    (%rdx),%rcx
  801250:	48 89 08             	mov    %rcx,(%rax)
  801253:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801257:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80125b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80125f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801263:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80126a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801271:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801277:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80127e:	48 89 c7             	mov    %rax,%rdi
  801281:	48 b8 1d 11 80 00 00 	movabs $0x80111d,%rax
  801288:	00 00 00 
  80128b:	ff d0                	callq  *%rax
  80128d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801293:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801299:	c9                   	leaveq 
  80129a:	c3                   	retq   

000000000080129b <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  80129b:	55                   	push   %rbp
  80129c:	48 89 e5             	mov    %rsp,%rbp
  80129f:	48 83 ec 20          	sub    $0x20,%rsp
  8012a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  8012a7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012ac:	74 27                	je     8012d5 <readline+0x3a>
		fprintf(1, "%s", prompt);
  8012ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b2:	48 89 c2             	mov    %rax,%rdx
  8012b5:	48 be a8 49 80 00 00 	movabs $0x8049a8,%rsi
  8012bc:	00 00 00 
  8012bf:	bf 01 00 00 00       	mov    $0x1,%edi
  8012c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c9:	48 b9 61 32 80 00 00 	movabs $0x803261,%rcx
  8012d0:	00 00 00 
  8012d3:	ff d1                	callq  *%rcx
#endif

	i = 0;
  8012d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  8012dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8012e1:	48 b8 2c 02 80 00 00 	movabs $0x80022c,%rax
  8012e8:	00 00 00 
  8012eb:	ff d0                	callq  *%rax
  8012ed:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  8012f0:	48 b8 e3 01 80 00 00 	movabs $0x8001e3,%rax
  8012f7:	00 00 00 
  8012fa:	ff d0                	callq  *%rax
  8012fc:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  8012ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801303:	79 30                	jns    801335 <readline+0x9a>
			if (c != -E_EOF)
  801305:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  801309:	74 20                	je     80132b <readline+0x90>
				cprintf("read error: %e\n", c);
  80130b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80130e:	89 c6                	mov    %eax,%esi
  801310:	48 bf ab 49 80 00 00 	movabs $0x8049ab,%rdi
  801317:	00 00 00 
  80131a:	b8 00 00 00 00       	mov    $0x0,%eax
  80131f:	48 ba 52 07 80 00 00 	movabs $0x800752,%rdx
  801326:	00 00 00 
  801329:	ff d2                	callq  *%rdx
			return NULL;
  80132b:	b8 00 00 00 00       	mov    $0x0,%eax
  801330:	e9 be 00 00 00       	jmpq   8013f3 <readline+0x158>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  801335:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  801339:	74 06                	je     801341 <readline+0xa6>
  80133b:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  80133f:	75 26                	jne    801367 <readline+0xcc>
  801341:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801345:	7e 20                	jle    801367 <readline+0xcc>
			if (echoing)
  801347:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80134b:	74 11                	je     80135e <readline+0xc3>
				cputchar('\b');
  80134d:	bf 08 00 00 00       	mov    $0x8,%edi
  801352:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  801359:	00 00 00 
  80135c:	ff d0                	callq  *%rax
			i--;
  80135e:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  801362:	e9 87 00 00 00       	jmpq   8013ee <readline+0x153>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801367:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  80136b:	7e 3f                	jle    8013ac <readline+0x111>
  80136d:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  801374:	7f 36                	jg     8013ac <readline+0x111>
			if (echoing)
  801376:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80137a:	74 11                	je     80138d <readline+0xf2>
				cputchar(c);
  80137c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80137f:	89 c7                	mov    %eax,%edi
  801381:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  801388:	00 00 00 
  80138b:	ff d0                	callq  *%rax
			buf[i++] = c;
  80138d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801390:	8d 50 01             	lea    0x1(%rax),%edx
  801393:	89 55 fc             	mov    %edx,-0x4(%rbp)
  801396:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801399:	89 d1                	mov    %edx,%ecx
  80139b:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8013a2:	00 00 00 
  8013a5:	48 98                	cltq   
  8013a7:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  8013aa:	eb 42                	jmp    8013ee <readline+0x153>
		} else if (c == '\n' || c == '\r') {
  8013ac:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8013b0:	74 06                	je     8013b8 <readline+0x11d>
  8013b2:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8013b6:	75 36                	jne    8013ee <readline+0x153>
			if (echoing)
  8013b8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8013bc:	74 11                	je     8013cf <readline+0x134>
				cputchar('\n');
  8013be:	bf 0a 00 00 00       	mov    $0xa,%edi
  8013c3:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  8013ca:	00 00 00 
  8013cd:	ff d0                	callq  *%rax
			buf[i] = 0;
  8013cf:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8013d6:	00 00 00 
  8013d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013dc:	48 98                	cltq   
  8013de:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  8013e2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8013e9:	00 00 00 
  8013ec:	eb 05                	jmp    8013f3 <readline+0x158>
		}
	}
  8013ee:	e9 fd fe ff ff       	jmpq   8012f0 <readline+0x55>
}
  8013f3:	c9                   	leaveq 
  8013f4:	c3                   	retq   

00000000008013f5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8013f5:	55                   	push   %rbp
  8013f6:	48 89 e5             	mov    %rsp,%rbp
  8013f9:	48 83 ec 18          	sub    $0x18,%rsp
  8013fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801401:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801408:	eb 09                	jmp    801413 <strlen+0x1e>
		n++;
  80140a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80140e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801413:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801417:	0f b6 00             	movzbl (%rax),%eax
  80141a:	84 c0                	test   %al,%al
  80141c:	75 ec                	jne    80140a <strlen+0x15>
		n++;
	return n;
  80141e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801421:	c9                   	leaveq 
  801422:	c3                   	retq   

0000000000801423 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801423:	55                   	push   %rbp
  801424:	48 89 e5             	mov    %rsp,%rbp
  801427:	48 83 ec 20          	sub    $0x20,%rsp
  80142b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80142f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801433:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80143a:	eb 0e                	jmp    80144a <strnlen+0x27>
		n++;
  80143c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801440:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801445:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80144a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80144f:	74 0b                	je     80145c <strnlen+0x39>
  801451:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801455:	0f b6 00             	movzbl (%rax),%eax
  801458:	84 c0                	test   %al,%al
  80145a:	75 e0                	jne    80143c <strnlen+0x19>
		n++;
	return n;
  80145c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80145f:	c9                   	leaveq 
  801460:	c3                   	retq   

0000000000801461 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801461:	55                   	push   %rbp
  801462:	48 89 e5             	mov    %rsp,%rbp
  801465:	48 83 ec 20          	sub    $0x20,%rsp
  801469:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80146d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801471:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801475:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801479:	90                   	nop
  80147a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80147e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801482:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801486:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80148a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80148e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801492:	0f b6 12             	movzbl (%rdx),%edx
  801495:	88 10                	mov    %dl,(%rax)
  801497:	0f b6 00             	movzbl (%rax),%eax
  80149a:	84 c0                	test   %al,%al
  80149c:	75 dc                	jne    80147a <strcpy+0x19>
		/* do nothing */;
	return ret;
  80149e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014a2:	c9                   	leaveq 
  8014a3:	c3                   	retq   

00000000008014a4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8014a4:	55                   	push   %rbp
  8014a5:	48 89 e5             	mov    %rsp,%rbp
  8014a8:	48 83 ec 20          	sub    $0x20,%rsp
  8014ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8014b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b8:	48 89 c7             	mov    %rax,%rdi
  8014bb:	48 b8 f5 13 80 00 00 	movabs $0x8013f5,%rax
  8014c2:	00 00 00 
  8014c5:	ff d0                	callq  *%rax
  8014c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8014ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014cd:	48 63 d0             	movslq %eax,%rdx
  8014d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d4:	48 01 c2             	add    %rax,%rdx
  8014d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014db:	48 89 c6             	mov    %rax,%rsi
  8014de:	48 89 d7             	mov    %rdx,%rdi
  8014e1:	48 b8 61 14 80 00 00 	movabs $0x801461,%rax
  8014e8:	00 00 00 
  8014eb:	ff d0                	callq  *%rax
	return dst;
  8014ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014f1:	c9                   	leaveq 
  8014f2:	c3                   	retq   

00000000008014f3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8014f3:	55                   	push   %rbp
  8014f4:	48 89 e5             	mov    %rsp,%rbp
  8014f7:	48 83 ec 28          	sub    $0x28,%rsp
  8014fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801503:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801507:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80150f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801516:	00 
  801517:	eb 2a                	jmp    801543 <strncpy+0x50>
		*dst++ = *src;
  801519:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80151d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801521:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801525:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801529:	0f b6 12             	movzbl (%rdx),%edx
  80152c:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80152e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801532:	0f b6 00             	movzbl (%rax),%eax
  801535:	84 c0                	test   %al,%al
  801537:	74 05                	je     80153e <strncpy+0x4b>
			src++;
  801539:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80153e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801543:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801547:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80154b:	72 cc                	jb     801519 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80154d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801551:	c9                   	leaveq 
  801552:	c3                   	retq   

0000000000801553 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801553:	55                   	push   %rbp
  801554:	48 89 e5             	mov    %rsp,%rbp
  801557:	48 83 ec 28          	sub    $0x28,%rsp
  80155b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80155f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801563:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801567:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80156f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801574:	74 3d                	je     8015b3 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801576:	eb 1d                	jmp    801595 <strlcpy+0x42>
			*dst++ = *src++;
  801578:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80157c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801580:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801584:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801588:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80158c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801590:	0f b6 12             	movzbl (%rdx),%edx
  801593:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801595:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80159a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80159f:	74 0b                	je     8015ac <strlcpy+0x59>
  8015a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015a5:	0f b6 00             	movzbl (%rax),%eax
  8015a8:	84 c0                	test   %al,%al
  8015aa:	75 cc                	jne    801578 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8015ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b0:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8015b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015bb:	48 29 c2             	sub    %rax,%rdx
  8015be:	48 89 d0             	mov    %rdx,%rax
}
  8015c1:	c9                   	leaveq 
  8015c2:	c3                   	retq   

00000000008015c3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015c3:	55                   	push   %rbp
  8015c4:	48 89 e5             	mov    %rsp,%rbp
  8015c7:	48 83 ec 10          	sub    $0x10,%rsp
  8015cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8015d3:	eb 0a                	jmp    8015df <strcmp+0x1c>
		p++, q++;
  8015d5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015da:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e3:	0f b6 00             	movzbl (%rax),%eax
  8015e6:	84 c0                	test   %al,%al
  8015e8:	74 12                	je     8015fc <strcmp+0x39>
  8015ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ee:	0f b6 10             	movzbl (%rax),%edx
  8015f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f5:	0f b6 00             	movzbl (%rax),%eax
  8015f8:	38 c2                	cmp    %al,%dl
  8015fa:	74 d9                	je     8015d5 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801600:	0f b6 00             	movzbl (%rax),%eax
  801603:	0f b6 d0             	movzbl %al,%edx
  801606:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160a:	0f b6 00             	movzbl (%rax),%eax
  80160d:	0f b6 c0             	movzbl %al,%eax
  801610:	29 c2                	sub    %eax,%edx
  801612:	89 d0                	mov    %edx,%eax
}
  801614:	c9                   	leaveq 
  801615:	c3                   	retq   

0000000000801616 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801616:	55                   	push   %rbp
  801617:	48 89 e5             	mov    %rsp,%rbp
  80161a:	48 83 ec 18          	sub    $0x18,%rsp
  80161e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801622:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801626:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80162a:	eb 0f                	jmp    80163b <strncmp+0x25>
		n--, p++, q++;
  80162c:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801631:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801636:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80163b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801640:	74 1d                	je     80165f <strncmp+0x49>
  801642:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801646:	0f b6 00             	movzbl (%rax),%eax
  801649:	84 c0                	test   %al,%al
  80164b:	74 12                	je     80165f <strncmp+0x49>
  80164d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801651:	0f b6 10             	movzbl (%rax),%edx
  801654:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801658:	0f b6 00             	movzbl (%rax),%eax
  80165b:	38 c2                	cmp    %al,%dl
  80165d:	74 cd                	je     80162c <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80165f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801664:	75 07                	jne    80166d <strncmp+0x57>
		return 0;
  801666:	b8 00 00 00 00       	mov    $0x0,%eax
  80166b:	eb 18                	jmp    801685 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80166d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801671:	0f b6 00             	movzbl (%rax),%eax
  801674:	0f b6 d0             	movzbl %al,%edx
  801677:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80167b:	0f b6 00             	movzbl (%rax),%eax
  80167e:	0f b6 c0             	movzbl %al,%eax
  801681:	29 c2                	sub    %eax,%edx
  801683:	89 d0                	mov    %edx,%eax
}
  801685:	c9                   	leaveq 
  801686:	c3                   	retq   

0000000000801687 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801687:	55                   	push   %rbp
  801688:	48 89 e5             	mov    %rsp,%rbp
  80168b:	48 83 ec 0c          	sub    $0xc,%rsp
  80168f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801693:	89 f0                	mov    %esi,%eax
  801695:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801698:	eb 17                	jmp    8016b1 <strchr+0x2a>
		if (*s == c)
  80169a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169e:	0f b6 00             	movzbl (%rax),%eax
  8016a1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8016a4:	75 06                	jne    8016ac <strchr+0x25>
			return (char *) s;
  8016a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016aa:	eb 15                	jmp    8016c1 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8016ac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b5:	0f b6 00             	movzbl (%rax),%eax
  8016b8:	84 c0                	test   %al,%al
  8016ba:	75 de                	jne    80169a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8016bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c1:	c9                   	leaveq 
  8016c2:	c3                   	retq   

00000000008016c3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8016c3:	55                   	push   %rbp
  8016c4:	48 89 e5             	mov    %rsp,%rbp
  8016c7:	48 83 ec 0c          	sub    $0xc,%rsp
  8016cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016cf:	89 f0                	mov    %esi,%eax
  8016d1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8016d4:	eb 13                	jmp    8016e9 <strfind+0x26>
		if (*s == c)
  8016d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016da:	0f b6 00             	movzbl (%rax),%eax
  8016dd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8016e0:	75 02                	jne    8016e4 <strfind+0x21>
			break;
  8016e2:	eb 10                	jmp    8016f4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016e4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ed:	0f b6 00             	movzbl (%rax),%eax
  8016f0:	84 c0                	test   %al,%al
  8016f2:	75 e2                	jne    8016d6 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8016f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016f8:	c9                   	leaveq 
  8016f9:	c3                   	retq   

00000000008016fa <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8016fa:	55                   	push   %rbp
  8016fb:	48 89 e5             	mov    %rsp,%rbp
  8016fe:	48 83 ec 18          	sub    $0x18,%rsp
  801702:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801706:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801709:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80170d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801712:	75 06                	jne    80171a <memset+0x20>
		return v;
  801714:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801718:	eb 69                	jmp    801783 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80171a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80171e:	83 e0 03             	and    $0x3,%eax
  801721:	48 85 c0             	test   %rax,%rax
  801724:	75 48                	jne    80176e <memset+0x74>
  801726:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80172a:	83 e0 03             	and    $0x3,%eax
  80172d:	48 85 c0             	test   %rax,%rax
  801730:	75 3c                	jne    80176e <memset+0x74>
		c &= 0xFF;
  801732:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801739:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80173c:	c1 e0 18             	shl    $0x18,%eax
  80173f:	89 c2                	mov    %eax,%edx
  801741:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801744:	c1 e0 10             	shl    $0x10,%eax
  801747:	09 c2                	or     %eax,%edx
  801749:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80174c:	c1 e0 08             	shl    $0x8,%eax
  80174f:	09 d0                	or     %edx,%eax
  801751:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801758:	48 c1 e8 02          	shr    $0x2,%rax
  80175c:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80175f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801763:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801766:	48 89 d7             	mov    %rdx,%rdi
  801769:	fc                   	cld    
  80176a:	f3 ab                	rep stos %eax,%es:(%rdi)
  80176c:	eb 11                	jmp    80177f <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80176e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801772:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801775:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801779:	48 89 d7             	mov    %rdx,%rdi
  80177c:	fc                   	cld    
  80177d:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80177f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801783:	c9                   	leaveq 
  801784:	c3                   	retq   

0000000000801785 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801785:	55                   	push   %rbp
  801786:	48 89 e5             	mov    %rsp,%rbp
  801789:	48 83 ec 28          	sub    $0x28,%rsp
  80178d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801791:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801795:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801799:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80179d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8017a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8017a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ad:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8017b1:	0f 83 88 00 00 00    	jae    80183f <memmove+0xba>
  8017b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017bf:	48 01 d0             	add    %rdx,%rax
  8017c2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8017c6:	76 77                	jbe    80183f <memmove+0xba>
		s += n;
  8017c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cc:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8017d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d4:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017dc:	83 e0 03             	and    $0x3,%eax
  8017df:	48 85 c0             	test   %rax,%rax
  8017e2:	75 3b                	jne    80181f <memmove+0x9a>
  8017e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017e8:	83 e0 03             	and    $0x3,%eax
  8017eb:	48 85 c0             	test   %rax,%rax
  8017ee:	75 2f                	jne    80181f <memmove+0x9a>
  8017f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f4:	83 e0 03             	and    $0x3,%eax
  8017f7:	48 85 c0             	test   %rax,%rax
  8017fa:	75 23                	jne    80181f <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8017fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801800:	48 83 e8 04          	sub    $0x4,%rax
  801804:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801808:	48 83 ea 04          	sub    $0x4,%rdx
  80180c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801810:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801814:	48 89 c7             	mov    %rax,%rdi
  801817:	48 89 d6             	mov    %rdx,%rsi
  80181a:	fd                   	std    
  80181b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80181d:	eb 1d                	jmp    80183c <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80181f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801823:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801827:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80182b:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80182f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801833:	48 89 d7             	mov    %rdx,%rdi
  801836:	48 89 c1             	mov    %rax,%rcx
  801839:	fd                   	std    
  80183a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80183c:	fc                   	cld    
  80183d:	eb 57                	jmp    801896 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80183f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801843:	83 e0 03             	and    $0x3,%eax
  801846:	48 85 c0             	test   %rax,%rax
  801849:	75 36                	jne    801881 <memmove+0xfc>
  80184b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80184f:	83 e0 03             	and    $0x3,%eax
  801852:	48 85 c0             	test   %rax,%rax
  801855:	75 2a                	jne    801881 <memmove+0xfc>
  801857:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185b:	83 e0 03             	and    $0x3,%eax
  80185e:	48 85 c0             	test   %rax,%rax
  801861:	75 1e                	jne    801881 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801863:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801867:	48 c1 e8 02          	shr    $0x2,%rax
  80186b:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80186e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801872:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801876:	48 89 c7             	mov    %rax,%rdi
  801879:	48 89 d6             	mov    %rdx,%rsi
  80187c:	fc                   	cld    
  80187d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80187f:	eb 15                	jmp    801896 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801881:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801885:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801889:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80188d:	48 89 c7             	mov    %rax,%rdi
  801890:	48 89 d6             	mov    %rdx,%rsi
  801893:	fc                   	cld    
  801894:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801896:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80189a:	c9                   	leaveq 
  80189b:	c3                   	retq   

000000000080189c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80189c:	55                   	push   %rbp
  80189d:	48 89 e5             	mov    %rsp,%rbp
  8018a0:	48 83 ec 18          	sub    $0x18,%rsp
  8018a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018ac:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8018b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018b4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8018b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018bc:	48 89 ce             	mov    %rcx,%rsi
  8018bf:	48 89 c7             	mov    %rax,%rdi
  8018c2:	48 b8 85 17 80 00 00 	movabs $0x801785,%rax
  8018c9:	00 00 00 
  8018cc:	ff d0                	callq  *%rax
}
  8018ce:	c9                   	leaveq 
  8018cf:	c3                   	retq   

00000000008018d0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8018d0:	55                   	push   %rbp
  8018d1:	48 89 e5             	mov    %rsp,%rbp
  8018d4:	48 83 ec 28          	sub    $0x28,%rsp
  8018d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8018e0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8018e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8018ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018f0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8018f4:	eb 36                	jmp    80192c <memcmp+0x5c>
		if (*s1 != *s2)
  8018f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018fa:	0f b6 10             	movzbl (%rax),%edx
  8018fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801901:	0f b6 00             	movzbl (%rax),%eax
  801904:	38 c2                	cmp    %al,%dl
  801906:	74 1a                	je     801922 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801908:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80190c:	0f b6 00             	movzbl (%rax),%eax
  80190f:	0f b6 d0             	movzbl %al,%edx
  801912:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801916:	0f b6 00             	movzbl (%rax),%eax
  801919:	0f b6 c0             	movzbl %al,%eax
  80191c:	29 c2                	sub    %eax,%edx
  80191e:	89 d0                	mov    %edx,%eax
  801920:	eb 20                	jmp    801942 <memcmp+0x72>
		s1++, s2++;
  801922:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801927:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80192c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801930:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801934:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801938:	48 85 c0             	test   %rax,%rax
  80193b:	75 b9                	jne    8018f6 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80193d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801942:	c9                   	leaveq 
  801943:	c3                   	retq   

0000000000801944 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801944:	55                   	push   %rbp
  801945:	48 89 e5             	mov    %rsp,%rbp
  801948:	48 83 ec 28          	sub    $0x28,%rsp
  80194c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801950:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801953:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801957:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80195b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80195f:	48 01 d0             	add    %rdx,%rax
  801962:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801966:	eb 15                	jmp    80197d <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801968:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80196c:	0f b6 10             	movzbl (%rax),%edx
  80196f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801972:	38 c2                	cmp    %al,%dl
  801974:	75 02                	jne    801978 <memfind+0x34>
			break;
  801976:	eb 0f                	jmp    801987 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801978:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80197d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801981:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801985:	72 e1                	jb     801968 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801987:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80198b:	c9                   	leaveq 
  80198c:	c3                   	retq   

000000000080198d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80198d:	55                   	push   %rbp
  80198e:	48 89 e5             	mov    %rsp,%rbp
  801991:	48 83 ec 34          	sub    $0x34,%rsp
  801995:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801999:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80199d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8019a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8019a7:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8019ae:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019af:	eb 05                	jmp    8019b6 <strtol+0x29>
		s++;
  8019b1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ba:	0f b6 00             	movzbl (%rax),%eax
  8019bd:	3c 20                	cmp    $0x20,%al
  8019bf:	74 f0                	je     8019b1 <strtol+0x24>
  8019c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c5:	0f b6 00             	movzbl (%rax),%eax
  8019c8:	3c 09                	cmp    $0x9,%al
  8019ca:	74 e5                	je     8019b1 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d0:	0f b6 00             	movzbl (%rax),%eax
  8019d3:	3c 2b                	cmp    $0x2b,%al
  8019d5:	75 07                	jne    8019de <strtol+0x51>
		s++;
  8019d7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019dc:	eb 17                	jmp    8019f5 <strtol+0x68>
	else if (*s == '-')
  8019de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e2:	0f b6 00             	movzbl (%rax),%eax
  8019e5:	3c 2d                	cmp    $0x2d,%al
  8019e7:	75 0c                	jne    8019f5 <strtol+0x68>
		s++, neg = 1;
  8019e9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019ee:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019f5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019f9:	74 06                	je     801a01 <strtol+0x74>
  8019fb:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8019ff:	75 28                	jne    801a29 <strtol+0x9c>
  801a01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a05:	0f b6 00             	movzbl (%rax),%eax
  801a08:	3c 30                	cmp    $0x30,%al
  801a0a:	75 1d                	jne    801a29 <strtol+0x9c>
  801a0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a10:	48 83 c0 01          	add    $0x1,%rax
  801a14:	0f b6 00             	movzbl (%rax),%eax
  801a17:	3c 78                	cmp    $0x78,%al
  801a19:	75 0e                	jne    801a29 <strtol+0x9c>
		s += 2, base = 16;
  801a1b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801a20:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801a27:	eb 2c                	jmp    801a55 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801a29:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a2d:	75 19                	jne    801a48 <strtol+0xbb>
  801a2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a33:	0f b6 00             	movzbl (%rax),%eax
  801a36:	3c 30                	cmp    $0x30,%al
  801a38:	75 0e                	jne    801a48 <strtol+0xbb>
		s++, base = 8;
  801a3a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a3f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801a46:	eb 0d                	jmp    801a55 <strtol+0xc8>
	else if (base == 0)
  801a48:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a4c:	75 07                	jne    801a55 <strtol+0xc8>
		base = 10;
  801a4e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a59:	0f b6 00             	movzbl (%rax),%eax
  801a5c:	3c 2f                	cmp    $0x2f,%al
  801a5e:	7e 1d                	jle    801a7d <strtol+0xf0>
  801a60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a64:	0f b6 00             	movzbl (%rax),%eax
  801a67:	3c 39                	cmp    $0x39,%al
  801a69:	7f 12                	jg     801a7d <strtol+0xf0>
			dig = *s - '0';
  801a6b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a6f:	0f b6 00             	movzbl (%rax),%eax
  801a72:	0f be c0             	movsbl %al,%eax
  801a75:	83 e8 30             	sub    $0x30,%eax
  801a78:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a7b:	eb 4e                	jmp    801acb <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801a7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a81:	0f b6 00             	movzbl (%rax),%eax
  801a84:	3c 60                	cmp    $0x60,%al
  801a86:	7e 1d                	jle    801aa5 <strtol+0x118>
  801a88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a8c:	0f b6 00             	movzbl (%rax),%eax
  801a8f:	3c 7a                	cmp    $0x7a,%al
  801a91:	7f 12                	jg     801aa5 <strtol+0x118>
			dig = *s - 'a' + 10;
  801a93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a97:	0f b6 00             	movzbl (%rax),%eax
  801a9a:	0f be c0             	movsbl %al,%eax
  801a9d:	83 e8 57             	sub    $0x57,%eax
  801aa0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801aa3:	eb 26                	jmp    801acb <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801aa5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa9:	0f b6 00             	movzbl (%rax),%eax
  801aac:	3c 40                	cmp    $0x40,%al
  801aae:	7e 48                	jle    801af8 <strtol+0x16b>
  801ab0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ab4:	0f b6 00             	movzbl (%rax),%eax
  801ab7:	3c 5a                	cmp    $0x5a,%al
  801ab9:	7f 3d                	jg     801af8 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801abb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801abf:	0f b6 00             	movzbl (%rax),%eax
  801ac2:	0f be c0             	movsbl %al,%eax
  801ac5:	83 e8 37             	sub    $0x37,%eax
  801ac8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801acb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ace:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801ad1:	7c 02                	jl     801ad5 <strtol+0x148>
			break;
  801ad3:	eb 23                	jmp    801af8 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801ad5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ada:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801add:	48 98                	cltq   
  801adf:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801ae4:	48 89 c2             	mov    %rax,%rdx
  801ae7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801aea:	48 98                	cltq   
  801aec:	48 01 d0             	add    %rdx,%rax
  801aef:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801af3:	e9 5d ff ff ff       	jmpq   801a55 <strtol+0xc8>

	if (endptr)
  801af8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801afd:	74 0b                	je     801b0a <strtol+0x17d>
		*endptr = (char *) s;
  801aff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b03:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801b07:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801b0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b0e:	74 09                	je     801b19 <strtol+0x18c>
  801b10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b14:	48 f7 d8             	neg    %rax
  801b17:	eb 04                	jmp    801b1d <strtol+0x190>
  801b19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801b1d:	c9                   	leaveq 
  801b1e:	c3                   	retq   

0000000000801b1f <strstr>:

char * strstr(const char *in, const char *str)
{
  801b1f:	55                   	push   %rbp
  801b20:	48 89 e5             	mov    %rsp,%rbp
  801b23:	48 83 ec 30          	sub    $0x30,%rsp
  801b27:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b2b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801b2f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b33:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b37:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b3b:	0f b6 00             	movzbl (%rax),%eax
  801b3e:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801b41:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801b45:	75 06                	jne    801b4d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801b47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b4b:	eb 6b                	jmp    801bb8 <strstr+0x99>

	len = strlen(str);
  801b4d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b51:	48 89 c7             	mov    %rax,%rdi
  801b54:	48 b8 f5 13 80 00 00 	movabs $0x8013f5,%rax
  801b5b:	00 00 00 
  801b5e:	ff d0                	callq  *%rax
  801b60:	48 98                	cltq   
  801b62:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801b66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b6a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b6e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801b72:	0f b6 00             	movzbl (%rax),%eax
  801b75:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801b78:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801b7c:	75 07                	jne    801b85 <strstr+0x66>
				return (char *) 0;
  801b7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b83:	eb 33                	jmp    801bb8 <strstr+0x99>
		} while (sc != c);
  801b85:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b89:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b8c:	75 d8                	jne    801b66 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801b8e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b92:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b9a:	48 89 ce             	mov    %rcx,%rsi
  801b9d:	48 89 c7             	mov    %rax,%rdi
  801ba0:	48 b8 16 16 80 00 00 	movabs $0x801616,%rax
  801ba7:	00 00 00 
  801baa:	ff d0                	callq  *%rax
  801bac:	85 c0                	test   %eax,%eax
  801bae:	75 b6                	jne    801b66 <strstr+0x47>

	return (char *) (in - 1);
  801bb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bb4:	48 83 e8 01          	sub    $0x1,%rax
}
  801bb8:	c9                   	leaveq 
  801bb9:	c3                   	retq   

0000000000801bba <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801bba:	55                   	push   %rbp
  801bbb:	48 89 e5             	mov    %rsp,%rbp
  801bbe:	53                   	push   %rbx
  801bbf:	48 83 ec 48          	sub    $0x48,%rsp
  801bc3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801bc6:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801bc9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801bcd:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801bd1:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801bd5:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bd9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801bdc:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801be0:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801be4:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801be8:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801bec:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801bf0:	4c 89 c3             	mov    %r8,%rbx
  801bf3:	cd 30                	int    $0x30
  801bf5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801bf9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801bfd:	74 3e                	je     801c3d <syscall+0x83>
  801bff:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801c04:	7e 37                	jle    801c3d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801c06:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c0a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c0d:	49 89 d0             	mov    %rdx,%r8
  801c10:	89 c1                	mov    %eax,%ecx
  801c12:	48 ba bb 49 80 00 00 	movabs $0x8049bb,%rdx
  801c19:	00 00 00 
  801c1c:	be 23 00 00 00       	mov    $0x23,%esi
  801c21:	48 bf d8 49 80 00 00 	movabs $0x8049d8,%rdi
  801c28:	00 00 00 
  801c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c30:	49 b9 19 05 80 00 00 	movabs $0x800519,%r9
  801c37:	00 00 00 
  801c3a:	41 ff d1             	callq  *%r9

	return ret;
  801c3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c41:	48 83 c4 48          	add    $0x48,%rsp
  801c45:	5b                   	pop    %rbx
  801c46:	5d                   	pop    %rbp
  801c47:	c3                   	retq   

0000000000801c48 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801c48:	55                   	push   %rbp
  801c49:	48 89 e5             	mov    %rsp,%rbp
  801c4c:	48 83 ec 20          	sub    $0x20,%rsp
  801c50:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c54:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801c58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c5c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c60:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c67:	00 
  801c68:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c6e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c74:	48 89 d1             	mov    %rdx,%rcx
  801c77:	48 89 c2             	mov    %rax,%rdx
  801c7a:	be 00 00 00 00       	mov    $0x0,%esi
  801c7f:	bf 00 00 00 00       	mov    $0x0,%edi
  801c84:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801c8b:	00 00 00 
  801c8e:	ff d0                	callq  *%rax
}
  801c90:	c9                   	leaveq 
  801c91:	c3                   	retq   

0000000000801c92 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c92:	55                   	push   %rbp
  801c93:	48 89 e5             	mov    %rsp,%rbp
  801c96:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c9a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca1:	00 
  801ca2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cae:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cb3:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb8:	be 00 00 00 00       	mov    $0x0,%esi
  801cbd:	bf 01 00 00 00       	mov    $0x1,%edi
  801cc2:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801cc9:	00 00 00 
  801ccc:	ff d0                	callq  *%rax
}
  801cce:	c9                   	leaveq 
  801ccf:	c3                   	retq   

0000000000801cd0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801cd0:	55                   	push   %rbp
  801cd1:	48 89 e5             	mov    %rsp,%rbp
  801cd4:	48 83 ec 10          	sub    $0x10,%rsp
  801cd8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801cdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cde:	48 98                	cltq   
  801ce0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce7:	00 
  801ce8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cf9:	48 89 c2             	mov    %rax,%rdx
  801cfc:	be 01 00 00 00       	mov    $0x1,%esi
  801d01:	bf 03 00 00 00       	mov    $0x3,%edi
  801d06:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801d0d:	00 00 00 
  801d10:	ff d0                	callq  *%rax
}
  801d12:	c9                   	leaveq 
  801d13:	c3                   	retq   

0000000000801d14 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801d14:	55                   	push   %rbp
  801d15:	48 89 e5             	mov    %rsp,%rbp
  801d18:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801d1c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d23:	00 
  801d24:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d2a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d30:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d35:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3a:	be 00 00 00 00       	mov    $0x0,%esi
  801d3f:	bf 02 00 00 00       	mov    $0x2,%edi
  801d44:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801d4b:	00 00 00 
  801d4e:	ff d0                	callq  *%rax
}
  801d50:	c9                   	leaveq 
  801d51:	c3                   	retq   

0000000000801d52 <sys_yield>:

void
sys_yield(void)
{
  801d52:	55                   	push   %rbp
  801d53:	48 89 e5             	mov    %rsp,%rbp
  801d56:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801d5a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d61:	00 
  801d62:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d68:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d73:	ba 00 00 00 00       	mov    $0x0,%edx
  801d78:	be 00 00 00 00       	mov    $0x0,%esi
  801d7d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d82:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801d89:	00 00 00 
  801d8c:	ff d0                	callq  *%rax
}
  801d8e:	c9                   	leaveq 
  801d8f:	c3                   	retq   

0000000000801d90 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d90:	55                   	push   %rbp
  801d91:	48 89 e5             	mov    %rsp,%rbp
  801d94:	48 83 ec 20          	sub    $0x20,%rsp
  801d98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d9f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801da2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801da5:	48 63 c8             	movslq %eax,%rcx
  801da8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801daf:	48 98                	cltq   
  801db1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db8:	00 
  801db9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dbf:	49 89 c8             	mov    %rcx,%r8
  801dc2:	48 89 d1             	mov    %rdx,%rcx
  801dc5:	48 89 c2             	mov    %rax,%rdx
  801dc8:	be 01 00 00 00       	mov    $0x1,%esi
  801dcd:	bf 04 00 00 00       	mov    $0x4,%edi
  801dd2:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801dd9:	00 00 00 
  801ddc:	ff d0                	callq  *%rax
}
  801dde:	c9                   	leaveq 
  801ddf:	c3                   	retq   

0000000000801de0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801de0:	55                   	push   %rbp
  801de1:	48 89 e5             	mov    %rsp,%rbp
  801de4:	48 83 ec 30          	sub    $0x30,%rsp
  801de8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801deb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801def:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801df2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801df6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801dfa:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801dfd:	48 63 c8             	movslq %eax,%rcx
  801e00:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e04:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e07:	48 63 f0             	movslq %eax,%rsi
  801e0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e11:	48 98                	cltq   
  801e13:	48 89 0c 24          	mov    %rcx,(%rsp)
  801e17:	49 89 f9             	mov    %rdi,%r9
  801e1a:	49 89 f0             	mov    %rsi,%r8
  801e1d:	48 89 d1             	mov    %rdx,%rcx
  801e20:	48 89 c2             	mov    %rax,%rdx
  801e23:	be 01 00 00 00       	mov    $0x1,%esi
  801e28:	bf 05 00 00 00       	mov    $0x5,%edi
  801e2d:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801e34:	00 00 00 
  801e37:	ff d0                	callq  *%rax
}
  801e39:	c9                   	leaveq 
  801e3a:	c3                   	retq   

0000000000801e3b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801e3b:	55                   	push   %rbp
  801e3c:	48 89 e5             	mov    %rsp,%rbp
  801e3f:	48 83 ec 20          	sub    $0x20,%rsp
  801e43:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e46:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801e4a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e51:	48 98                	cltq   
  801e53:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e5a:	00 
  801e5b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e61:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e67:	48 89 d1             	mov    %rdx,%rcx
  801e6a:	48 89 c2             	mov    %rax,%rdx
  801e6d:	be 01 00 00 00       	mov    $0x1,%esi
  801e72:	bf 06 00 00 00       	mov    $0x6,%edi
  801e77:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801e7e:	00 00 00 
  801e81:	ff d0                	callq  *%rax
}
  801e83:	c9                   	leaveq 
  801e84:	c3                   	retq   

0000000000801e85 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e85:	55                   	push   %rbp
  801e86:	48 89 e5             	mov    %rsp,%rbp
  801e89:	48 83 ec 10          	sub    $0x10,%rsp
  801e8d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e90:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e93:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e96:	48 63 d0             	movslq %eax,%rdx
  801e99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e9c:	48 98                	cltq   
  801e9e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ea5:	00 
  801ea6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eb2:	48 89 d1             	mov    %rdx,%rcx
  801eb5:	48 89 c2             	mov    %rax,%rdx
  801eb8:	be 01 00 00 00       	mov    $0x1,%esi
  801ebd:	bf 08 00 00 00       	mov    $0x8,%edi
  801ec2:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801ec9:	00 00 00 
  801ecc:	ff d0                	callq  *%rax
}
  801ece:	c9                   	leaveq 
  801ecf:	c3                   	retq   

0000000000801ed0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ed0:	55                   	push   %rbp
  801ed1:	48 89 e5             	mov    %rsp,%rbp
  801ed4:	48 83 ec 20          	sub    $0x20,%rsp
  801ed8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801edb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801edf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ee3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ee6:	48 98                	cltq   
  801ee8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eef:	00 
  801ef0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ef6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801efc:	48 89 d1             	mov    %rdx,%rcx
  801eff:	48 89 c2             	mov    %rax,%rdx
  801f02:	be 01 00 00 00       	mov    $0x1,%esi
  801f07:	bf 09 00 00 00       	mov    $0x9,%edi
  801f0c:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801f13:	00 00 00 
  801f16:	ff d0                	callq  *%rax
}
  801f18:	c9                   	leaveq 
  801f19:	c3                   	retq   

0000000000801f1a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801f1a:	55                   	push   %rbp
  801f1b:	48 89 e5             	mov    %rsp,%rbp
  801f1e:	48 83 ec 20          	sub    $0x20,%rsp
  801f22:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f25:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801f29:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f30:	48 98                	cltq   
  801f32:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f39:	00 
  801f3a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f40:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f46:	48 89 d1             	mov    %rdx,%rcx
  801f49:	48 89 c2             	mov    %rax,%rdx
  801f4c:	be 01 00 00 00       	mov    $0x1,%esi
  801f51:	bf 0a 00 00 00       	mov    $0xa,%edi
  801f56:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801f5d:	00 00 00 
  801f60:	ff d0                	callq  *%rax
}
  801f62:	c9                   	leaveq 
  801f63:	c3                   	retq   

0000000000801f64 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801f64:	55                   	push   %rbp
  801f65:	48 89 e5             	mov    %rsp,%rbp
  801f68:	48 83 ec 20          	sub    $0x20,%rsp
  801f6c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f6f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f73:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801f77:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801f7a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f7d:	48 63 f0             	movslq %eax,%rsi
  801f80:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f87:	48 98                	cltq   
  801f89:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f8d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f94:	00 
  801f95:	49 89 f1             	mov    %rsi,%r9
  801f98:	49 89 c8             	mov    %rcx,%r8
  801f9b:	48 89 d1             	mov    %rdx,%rcx
  801f9e:	48 89 c2             	mov    %rax,%rdx
  801fa1:	be 00 00 00 00       	mov    $0x0,%esi
  801fa6:	bf 0c 00 00 00       	mov    $0xc,%edi
  801fab:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801fb2:	00 00 00 
  801fb5:	ff d0                	callq  *%rax
}
  801fb7:	c9                   	leaveq 
  801fb8:	c3                   	retq   

0000000000801fb9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801fb9:	55                   	push   %rbp
  801fba:	48 89 e5             	mov    %rsp,%rbp
  801fbd:	48 83 ec 10          	sub    $0x10,%rsp
  801fc1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801fc5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fd0:	00 
  801fd1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fd7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fdd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fe2:	48 89 c2             	mov    %rax,%rdx
  801fe5:	be 01 00 00 00       	mov    $0x1,%esi
  801fea:	bf 0d 00 00 00       	mov    $0xd,%edi
  801fef:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801ff6:	00 00 00 
  801ff9:	ff d0                	callq  *%rax
}
  801ffb:	c9                   	leaveq 
  801ffc:	c3                   	retq   

0000000000801ffd <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801ffd:	55                   	push   %rbp
  801ffe:	48 89 e5             	mov    %rsp,%rbp
  802001:	48 83 ec 20          	sub    $0x20,%rsp
  802005:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802009:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  80200d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802011:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802015:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80201c:	00 
  80201d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802023:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802029:	b9 00 00 00 00       	mov    $0x0,%ecx
  80202e:	89 c6                	mov    %eax,%esi
  802030:	bf 0f 00 00 00       	mov    $0xf,%edi
  802035:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  80203c:	00 00 00 
  80203f:	ff d0                	callq  *%rax
}
  802041:	c9                   	leaveq 
  802042:	c3                   	retq   

0000000000802043 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  802043:	55                   	push   %rbp
  802044:	48 89 e5             	mov    %rsp,%rbp
  802047:	48 83 ec 20          	sub    $0x20,%rsp
  80204b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80204f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  802053:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802057:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80205b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802062:	00 
  802063:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802069:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80206f:	b9 00 00 00 00       	mov    $0x0,%ecx
  802074:	89 c6                	mov    %eax,%esi
  802076:	bf 10 00 00 00       	mov    $0x10,%edi
  80207b:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  802082:	00 00 00 
  802085:	ff d0                	callq  *%rax
}
  802087:	c9                   	leaveq 
  802088:	c3                   	retq   

0000000000802089 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  802089:	55                   	push   %rbp
  80208a:	48 89 e5             	mov    %rsp,%rbp
  80208d:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802091:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802098:	00 
  802099:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80209f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8020af:	be 00 00 00 00       	mov    $0x0,%esi
  8020b4:	bf 0e 00 00 00       	mov    $0xe,%edi
  8020b9:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  8020c0:	00 00 00 
  8020c3:	ff d0                	callq  *%rax
}
  8020c5:	c9                   	leaveq 
  8020c6:	c3                   	retq   

00000000008020c7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8020c7:	55                   	push   %rbp
  8020c8:	48 89 e5             	mov    %rsp,%rbp
  8020cb:	48 83 ec 08          	sub    $0x8,%rsp
  8020cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8020d3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8020d7:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8020de:	ff ff ff 
  8020e1:	48 01 d0             	add    %rdx,%rax
  8020e4:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8020e8:	c9                   	leaveq 
  8020e9:	c3                   	retq   

00000000008020ea <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8020ea:	55                   	push   %rbp
  8020eb:	48 89 e5             	mov    %rsp,%rbp
  8020ee:	48 83 ec 08          	sub    $0x8,%rsp
  8020f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8020f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020fa:	48 89 c7             	mov    %rax,%rdi
  8020fd:	48 b8 c7 20 80 00 00 	movabs $0x8020c7,%rax
  802104:	00 00 00 
  802107:	ff d0                	callq  *%rax
  802109:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80210f:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802113:	c9                   	leaveq 
  802114:	c3                   	retq   

0000000000802115 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802115:	55                   	push   %rbp
  802116:	48 89 e5             	mov    %rsp,%rbp
  802119:	48 83 ec 18          	sub    $0x18,%rsp
  80211d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802121:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802128:	eb 6b                	jmp    802195 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80212a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80212d:	48 98                	cltq   
  80212f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802135:	48 c1 e0 0c          	shl    $0xc,%rax
  802139:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80213d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802141:	48 c1 e8 15          	shr    $0x15,%rax
  802145:	48 89 c2             	mov    %rax,%rdx
  802148:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80214f:	01 00 00 
  802152:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802156:	83 e0 01             	and    $0x1,%eax
  802159:	48 85 c0             	test   %rax,%rax
  80215c:	74 21                	je     80217f <fd_alloc+0x6a>
  80215e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802162:	48 c1 e8 0c          	shr    $0xc,%rax
  802166:	48 89 c2             	mov    %rax,%rdx
  802169:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802170:	01 00 00 
  802173:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802177:	83 e0 01             	and    $0x1,%eax
  80217a:	48 85 c0             	test   %rax,%rax
  80217d:	75 12                	jne    802191 <fd_alloc+0x7c>
			*fd_store = fd;
  80217f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802183:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802187:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80218a:	b8 00 00 00 00       	mov    $0x0,%eax
  80218f:	eb 1a                	jmp    8021ab <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802191:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802195:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802199:	7e 8f                	jle    80212a <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80219b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80219f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8021a6:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8021ab:	c9                   	leaveq 
  8021ac:	c3                   	retq   

00000000008021ad <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8021ad:	55                   	push   %rbp
  8021ae:	48 89 e5             	mov    %rsp,%rbp
  8021b1:	48 83 ec 20          	sub    $0x20,%rsp
  8021b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8021bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021c0:	78 06                	js     8021c8 <fd_lookup+0x1b>
  8021c2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8021c6:	7e 07                	jle    8021cf <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8021c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021cd:	eb 6c                	jmp    80223b <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8021cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021d2:	48 98                	cltq   
  8021d4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021da:	48 c1 e0 0c          	shl    $0xc,%rax
  8021de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8021e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021e6:	48 c1 e8 15          	shr    $0x15,%rax
  8021ea:	48 89 c2             	mov    %rax,%rdx
  8021ed:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021f4:	01 00 00 
  8021f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021fb:	83 e0 01             	and    $0x1,%eax
  8021fe:	48 85 c0             	test   %rax,%rax
  802201:	74 21                	je     802224 <fd_lookup+0x77>
  802203:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802207:	48 c1 e8 0c          	shr    $0xc,%rax
  80220b:	48 89 c2             	mov    %rax,%rdx
  80220e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802215:	01 00 00 
  802218:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80221c:	83 e0 01             	and    $0x1,%eax
  80221f:	48 85 c0             	test   %rax,%rax
  802222:	75 07                	jne    80222b <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802224:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802229:	eb 10                	jmp    80223b <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80222b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80222f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802233:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802236:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80223b:	c9                   	leaveq 
  80223c:	c3                   	retq   

000000000080223d <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80223d:	55                   	push   %rbp
  80223e:	48 89 e5             	mov    %rsp,%rbp
  802241:	48 83 ec 30          	sub    $0x30,%rsp
  802245:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802249:	89 f0                	mov    %esi,%eax
  80224b:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80224e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802252:	48 89 c7             	mov    %rax,%rdi
  802255:	48 b8 c7 20 80 00 00 	movabs $0x8020c7,%rax
  80225c:	00 00 00 
  80225f:	ff d0                	callq  *%rax
  802261:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802265:	48 89 d6             	mov    %rdx,%rsi
  802268:	89 c7                	mov    %eax,%edi
  80226a:	48 b8 ad 21 80 00 00 	movabs $0x8021ad,%rax
  802271:	00 00 00 
  802274:	ff d0                	callq  *%rax
  802276:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802279:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80227d:	78 0a                	js     802289 <fd_close+0x4c>
	    || fd != fd2)
  80227f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802283:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802287:	74 12                	je     80229b <fd_close+0x5e>
		return (must_exist ? r : 0);
  802289:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80228d:	74 05                	je     802294 <fd_close+0x57>
  80228f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802292:	eb 05                	jmp    802299 <fd_close+0x5c>
  802294:	b8 00 00 00 00       	mov    $0x0,%eax
  802299:	eb 69                	jmp    802304 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80229b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80229f:	8b 00                	mov    (%rax),%eax
  8022a1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022a5:	48 89 d6             	mov    %rdx,%rsi
  8022a8:	89 c7                	mov    %eax,%edi
  8022aa:	48 b8 06 23 80 00 00 	movabs $0x802306,%rax
  8022b1:	00 00 00 
  8022b4:	ff d0                	callq  *%rax
  8022b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022bd:	78 2a                	js     8022e9 <fd_close+0xac>
		if (dev->dev_close)
  8022bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c3:	48 8b 40 20          	mov    0x20(%rax),%rax
  8022c7:	48 85 c0             	test   %rax,%rax
  8022ca:	74 16                	je     8022e2 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8022cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d0:	48 8b 40 20          	mov    0x20(%rax),%rax
  8022d4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8022d8:	48 89 d7             	mov    %rdx,%rdi
  8022db:	ff d0                	callq  *%rax
  8022dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e0:	eb 07                	jmp    8022e9 <fd_close+0xac>
		else
			r = 0;
  8022e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8022e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022ed:	48 89 c6             	mov    %rax,%rsi
  8022f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8022f5:	48 b8 3b 1e 80 00 00 	movabs $0x801e3b,%rax
  8022fc:	00 00 00 
  8022ff:	ff d0                	callq  *%rax
	return r;
  802301:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802304:	c9                   	leaveq 
  802305:	c3                   	retq   

0000000000802306 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802306:	55                   	push   %rbp
  802307:	48 89 e5             	mov    %rsp,%rbp
  80230a:	48 83 ec 20          	sub    $0x20,%rsp
  80230e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802311:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802315:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80231c:	eb 41                	jmp    80235f <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80231e:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  802325:	00 00 00 
  802328:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80232b:	48 63 d2             	movslq %edx,%rdx
  80232e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802332:	8b 00                	mov    (%rax),%eax
  802334:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802337:	75 22                	jne    80235b <dev_lookup+0x55>
			*dev = devtab[i];
  802339:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  802340:	00 00 00 
  802343:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802346:	48 63 d2             	movslq %edx,%rdx
  802349:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80234d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802351:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802354:	b8 00 00 00 00       	mov    $0x0,%eax
  802359:	eb 60                	jmp    8023bb <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80235b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80235f:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  802366:	00 00 00 
  802369:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80236c:	48 63 d2             	movslq %edx,%rdx
  80236f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802373:	48 85 c0             	test   %rax,%rax
  802376:	75 a6                	jne    80231e <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802378:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  80237f:	00 00 00 
  802382:	48 8b 00             	mov    (%rax),%rax
  802385:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80238b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80238e:	89 c6                	mov    %eax,%esi
  802390:	48 bf e8 49 80 00 00 	movabs $0x8049e8,%rdi
  802397:	00 00 00 
  80239a:	b8 00 00 00 00       	mov    $0x0,%eax
  80239f:	48 b9 52 07 80 00 00 	movabs $0x800752,%rcx
  8023a6:	00 00 00 
  8023a9:	ff d1                	callq  *%rcx
	*dev = 0;
  8023ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023af:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8023b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8023bb:	c9                   	leaveq 
  8023bc:	c3                   	retq   

00000000008023bd <close>:

int
close(int fdnum)
{
  8023bd:	55                   	push   %rbp
  8023be:	48 89 e5             	mov    %rsp,%rbp
  8023c1:	48 83 ec 20          	sub    $0x20,%rsp
  8023c5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023c8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023cf:	48 89 d6             	mov    %rdx,%rsi
  8023d2:	89 c7                	mov    %eax,%edi
  8023d4:	48 b8 ad 21 80 00 00 	movabs $0x8021ad,%rax
  8023db:	00 00 00 
  8023de:	ff d0                	callq  *%rax
  8023e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e7:	79 05                	jns    8023ee <close+0x31>
		return r;
  8023e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ec:	eb 18                	jmp    802406 <close+0x49>
	else
		return fd_close(fd, 1);
  8023ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023f2:	be 01 00 00 00       	mov    $0x1,%esi
  8023f7:	48 89 c7             	mov    %rax,%rdi
  8023fa:	48 b8 3d 22 80 00 00 	movabs $0x80223d,%rax
  802401:	00 00 00 
  802404:	ff d0                	callq  *%rax
}
  802406:	c9                   	leaveq 
  802407:	c3                   	retq   

0000000000802408 <close_all>:

void
close_all(void)
{
  802408:	55                   	push   %rbp
  802409:	48 89 e5             	mov    %rsp,%rbp
  80240c:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802417:	eb 15                	jmp    80242e <close_all+0x26>
		close(i);
  802419:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241c:	89 c7                	mov    %eax,%edi
  80241e:	48 b8 bd 23 80 00 00 	movabs $0x8023bd,%rax
  802425:	00 00 00 
  802428:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80242a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80242e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802432:	7e e5                	jle    802419 <close_all+0x11>
		close(i);
}
  802434:	c9                   	leaveq 
  802435:	c3                   	retq   

0000000000802436 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802436:	55                   	push   %rbp
  802437:	48 89 e5             	mov    %rsp,%rbp
  80243a:	48 83 ec 40          	sub    $0x40,%rsp
  80243e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802441:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802444:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802448:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80244b:	48 89 d6             	mov    %rdx,%rsi
  80244e:	89 c7                	mov    %eax,%edi
  802450:	48 b8 ad 21 80 00 00 	movabs $0x8021ad,%rax
  802457:	00 00 00 
  80245a:	ff d0                	callq  *%rax
  80245c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80245f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802463:	79 08                	jns    80246d <dup+0x37>
		return r;
  802465:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802468:	e9 70 01 00 00       	jmpq   8025dd <dup+0x1a7>
	close(newfdnum);
  80246d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802470:	89 c7                	mov    %eax,%edi
  802472:	48 b8 bd 23 80 00 00 	movabs $0x8023bd,%rax
  802479:	00 00 00 
  80247c:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80247e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802481:	48 98                	cltq   
  802483:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802489:	48 c1 e0 0c          	shl    $0xc,%rax
  80248d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802491:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802495:	48 89 c7             	mov    %rax,%rdi
  802498:	48 b8 ea 20 80 00 00 	movabs $0x8020ea,%rax
  80249f:	00 00 00 
  8024a2:	ff d0                	callq  *%rax
  8024a4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8024a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ac:	48 89 c7             	mov    %rax,%rdi
  8024af:	48 b8 ea 20 80 00 00 	movabs $0x8020ea,%rax
  8024b6:	00 00 00 
  8024b9:	ff d0                	callq  *%rax
  8024bb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8024bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024c3:	48 c1 e8 15          	shr    $0x15,%rax
  8024c7:	48 89 c2             	mov    %rax,%rdx
  8024ca:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024d1:	01 00 00 
  8024d4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024d8:	83 e0 01             	and    $0x1,%eax
  8024db:	48 85 c0             	test   %rax,%rax
  8024de:	74 73                	je     802553 <dup+0x11d>
  8024e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024e4:	48 c1 e8 0c          	shr    $0xc,%rax
  8024e8:	48 89 c2             	mov    %rax,%rdx
  8024eb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024f2:	01 00 00 
  8024f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024f9:	83 e0 01             	and    $0x1,%eax
  8024fc:	48 85 c0             	test   %rax,%rax
  8024ff:	74 52                	je     802553 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802501:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802505:	48 c1 e8 0c          	shr    $0xc,%rax
  802509:	48 89 c2             	mov    %rax,%rdx
  80250c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802513:	01 00 00 
  802516:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80251a:	25 07 0e 00 00       	and    $0xe07,%eax
  80251f:	89 c1                	mov    %eax,%ecx
  802521:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802529:	41 89 c8             	mov    %ecx,%r8d
  80252c:	48 89 d1             	mov    %rdx,%rcx
  80252f:	ba 00 00 00 00       	mov    $0x0,%edx
  802534:	48 89 c6             	mov    %rax,%rsi
  802537:	bf 00 00 00 00       	mov    $0x0,%edi
  80253c:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  802543:	00 00 00 
  802546:	ff d0                	callq  *%rax
  802548:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80254b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80254f:	79 02                	jns    802553 <dup+0x11d>
			goto err;
  802551:	eb 57                	jmp    8025aa <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802553:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802557:	48 c1 e8 0c          	shr    $0xc,%rax
  80255b:	48 89 c2             	mov    %rax,%rdx
  80255e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802565:	01 00 00 
  802568:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80256c:	25 07 0e 00 00       	and    $0xe07,%eax
  802571:	89 c1                	mov    %eax,%ecx
  802573:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802577:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80257b:	41 89 c8             	mov    %ecx,%r8d
  80257e:	48 89 d1             	mov    %rdx,%rcx
  802581:	ba 00 00 00 00       	mov    $0x0,%edx
  802586:	48 89 c6             	mov    %rax,%rsi
  802589:	bf 00 00 00 00       	mov    $0x0,%edi
  80258e:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  802595:	00 00 00 
  802598:	ff d0                	callq  *%rax
  80259a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80259d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a1:	79 02                	jns    8025a5 <dup+0x16f>
		goto err;
  8025a3:	eb 05                	jmp    8025aa <dup+0x174>

	return newfdnum;
  8025a5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025a8:	eb 33                	jmp    8025dd <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8025aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ae:	48 89 c6             	mov    %rax,%rsi
  8025b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b6:	48 b8 3b 1e 80 00 00 	movabs $0x801e3b,%rax
  8025bd:	00 00 00 
  8025c0:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8025c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025c6:	48 89 c6             	mov    %rax,%rsi
  8025c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8025ce:	48 b8 3b 1e 80 00 00 	movabs $0x801e3b,%rax
  8025d5:	00 00 00 
  8025d8:	ff d0                	callq  *%rax
	return r;
  8025da:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025dd:	c9                   	leaveq 
  8025de:	c3                   	retq   

00000000008025df <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8025df:	55                   	push   %rbp
  8025e0:	48 89 e5             	mov    %rsp,%rbp
  8025e3:	48 83 ec 40          	sub    $0x40,%rsp
  8025e7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025ea:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8025ee:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025f2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025f6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025f9:	48 89 d6             	mov    %rdx,%rsi
  8025fc:	89 c7                	mov    %eax,%edi
  8025fe:	48 b8 ad 21 80 00 00 	movabs $0x8021ad,%rax
  802605:	00 00 00 
  802608:	ff d0                	callq  *%rax
  80260a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80260d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802611:	78 24                	js     802637 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802613:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802617:	8b 00                	mov    (%rax),%eax
  802619:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80261d:	48 89 d6             	mov    %rdx,%rsi
  802620:	89 c7                	mov    %eax,%edi
  802622:	48 b8 06 23 80 00 00 	movabs $0x802306,%rax
  802629:	00 00 00 
  80262c:	ff d0                	callq  *%rax
  80262e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802631:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802635:	79 05                	jns    80263c <read+0x5d>
		return r;
  802637:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80263a:	eb 76                	jmp    8026b2 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80263c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802640:	8b 40 08             	mov    0x8(%rax),%eax
  802643:	83 e0 03             	and    $0x3,%eax
  802646:	83 f8 01             	cmp    $0x1,%eax
  802649:	75 3a                	jne    802685 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80264b:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  802652:	00 00 00 
  802655:	48 8b 00             	mov    (%rax),%rax
  802658:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80265e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802661:	89 c6                	mov    %eax,%esi
  802663:	48 bf 07 4a 80 00 00 	movabs $0x804a07,%rdi
  80266a:	00 00 00 
  80266d:	b8 00 00 00 00       	mov    $0x0,%eax
  802672:	48 b9 52 07 80 00 00 	movabs $0x800752,%rcx
  802679:	00 00 00 
  80267c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80267e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802683:	eb 2d                	jmp    8026b2 <read+0xd3>
	}
	if (!dev->dev_read)
  802685:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802689:	48 8b 40 10          	mov    0x10(%rax),%rax
  80268d:	48 85 c0             	test   %rax,%rax
  802690:	75 07                	jne    802699 <read+0xba>
		return -E_NOT_SUPP;
  802692:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802697:	eb 19                	jmp    8026b2 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802699:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80269d:	48 8b 40 10          	mov    0x10(%rax),%rax
  8026a1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8026a5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8026a9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026ad:	48 89 cf             	mov    %rcx,%rdi
  8026b0:	ff d0                	callq  *%rax
}
  8026b2:	c9                   	leaveq 
  8026b3:	c3                   	retq   

00000000008026b4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8026b4:	55                   	push   %rbp
  8026b5:	48 89 e5             	mov    %rsp,%rbp
  8026b8:	48 83 ec 30          	sub    $0x30,%rsp
  8026bc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026c3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8026c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026ce:	eb 49                	jmp    802719 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8026d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026d3:	48 98                	cltq   
  8026d5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026d9:	48 29 c2             	sub    %rax,%rdx
  8026dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026df:	48 63 c8             	movslq %eax,%rcx
  8026e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026e6:	48 01 c1             	add    %rax,%rcx
  8026e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026ec:	48 89 ce             	mov    %rcx,%rsi
  8026ef:	89 c7                	mov    %eax,%edi
  8026f1:	48 b8 df 25 80 00 00 	movabs $0x8025df,%rax
  8026f8:	00 00 00 
  8026fb:	ff d0                	callq  *%rax
  8026fd:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802700:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802704:	79 05                	jns    80270b <readn+0x57>
			return m;
  802706:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802709:	eb 1c                	jmp    802727 <readn+0x73>
		if (m == 0)
  80270b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80270f:	75 02                	jne    802713 <readn+0x5f>
			break;
  802711:	eb 11                	jmp    802724 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802713:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802716:	01 45 fc             	add    %eax,-0x4(%rbp)
  802719:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80271c:	48 98                	cltq   
  80271e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802722:	72 ac                	jb     8026d0 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802724:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802727:	c9                   	leaveq 
  802728:	c3                   	retq   

0000000000802729 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802729:	55                   	push   %rbp
  80272a:	48 89 e5             	mov    %rsp,%rbp
  80272d:	48 83 ec 40          	sub    $0x40,%rsp
  802731:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802734:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802738:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80273c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802740:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802743:	48 89 d6             	mov    %rdx,%rsi
  802746:	89 c7                	mov    %eax,%edi
  802748:	48 b8 ad 21 80 00 00 	movabs $0x8021ad,%rax
  80274f:	00 00 00 
  802752:	ff d0                	callq  *%rax
  802754:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802757:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80275b:	78 24                	js     802781 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80275d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802761:	8b 00                	mov    (%rax),%eax
  802763:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802767:	48 89 d6             	mov    %rdx,%rsi
  80276a:	89 c7                	mov    %eax,%edi
  80276c:	48 b8 06 23 80 00 00 	movabs $0x802306,%rax
  802773:	00 00 00 
  802776:	ff d0                	callq  *%rax
  802778:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80277b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80277f:	79 05                	jns    802786 <write+0x5d>
		return r;
  802781:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802784:	eb 75                	jmp    8027fb <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802786:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278a:	8b 40 08             	mov    0x8(%rax),%eax
  80278d:	83 e0 03             	and    $0x3,%eax
  802790:	85 c0                	test   %eax,%eax
  802792:	75 3a                	jne    8027ce <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802794:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  80279b:	00 00 00 
  80279e:	48 8b 00             	mov    (%rax),%rax
  8027a1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027a7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027aa:	89 c6                	mov    %eax,%esi
  8027ac:	48 bf 23 4a 80 00 00 	movabs $0x804a23,%rdi
  8027b3:	00 00 00 
  8027b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bb:	48 b9 52 07 80 00 00 	movabs $0x800752,%rcx
  8027c2:	00 00 00 
  8027c5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8027c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027cc:	eb 2d                	jmp    8027fb <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8027ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d2:	48 8b 40 18          	mov    0x18(%rax),%rax
  8027d6:	48 85 c0             	test   %rax,%rax
  8027d9:	75 07                	jne    8027e2 <write+0xb9>
		return -E_NOT_SUPP;
  8027db:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027e0:	eb 19                	jmp    8027fb <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8027e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027e6:	48 8b 40 18          	mov    0x18(%rax),%rax
  8027ea:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8027ee:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027f2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027f6:	48 89 cf             	mov    %rcx,%rdi
  8027f9:	ff d0                	callq  *%rax
}
  8027fb:	c9                   	leaveq 
  8027fc:	c3                   	retq   

00000000008027fd <seek>:

int
seek(int fdnum, off_t offset)
{
  8027fd:	55                   	push   %rbp
  8027fe:	48 89 e5             	mov    %rsp,%rbp
  802801:	48 83 ec 18          	sub    $0x18,%rsp
  802805:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802808:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80280b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80280f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802812:	48 89 d6             	mov    %rdx,%rsi
  802815:	89 c7                	mov    %eax,%edi
  802817:	48 b8 ad 21 80 00 00 	movabs $0x8021ad,%rax
  80281e:	00 00 00 
  802821:	ff d0                	callq  *%rax
  802823:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802826:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80282a:	79 05                	jns    802831 <seek+0x34>
		return r;
  80282c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80282f:	eb 0f                	jmp    802840 <seek+0x43>
	fd->fd_offset = offset;
  802831:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802835:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802838:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80283b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802840:	c9                   	leaveq 
  802841:	c3                   	retq   

0000000000802842 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802842:	55                   	push   %rbp
  802843:	48 89 e5             	mov    %rsp,%rbp
  802846:	48 83 ec 30          	sub    $0x30,%rsp
  80284a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80284d:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802850:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802854:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802857:	48 89 d6             	mov    %rdx,%rsi
  80285a:	89 c7                	mov    %eax,%edi
  80285c:	48 b8 ad 21 80 00 00 	movabs $0x8021ad,%rax
  802863:	00 00 00 
  802866:	ff d0                	callq  *%rax
  802868:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80286b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80286f:	78 24                	js     802895 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802871:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802875:	8b 00                	mov    (%rax),%eax
  802877:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80287b:	48 89 d6             	mov    %rdx,%rsi
  80287e:	89 c7                	mov    %eax,%edi
  802880:	48 b8 06 23 80 00 00 	movabs $0x802306,%rax
  802887:	00 00 00 
  80288a:	ff d0                	callq  *%rax
  80288c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80288f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802893:	79 05                	jns    80289a <ftruncate+0x58>
		return r;
  802895:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802898:	eb 72                	jmp    80290c <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80289a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80289e:	8b 40 08             	mov    0x8(%rax),%eax
  8028a1:	83 e0 03             	and    $0x3,%eax
  8028a4:	85 c0                	test   %eax,%eax
  8028a6:	75 3a                	jne    8028e2 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8028a8:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8028af:	00 00 00 
  8028b2:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8028b5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028bb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028be:	89 c6                	mov    %eax,%esi
  8028c0:	48 bf 40 4a 80 00 00 	movabs $0x804a40,%rdi
  8028c7:	00 00 00 
  8028ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8028cf:	48 b9 52 07 80 00 00 	movabs $0x800752,%rcx
  8028d6:	00 00 00 
  8028d9:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8028db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028e0:	eb 2a                	jmp    80290c <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8028e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028e6:	48 8b 40 30          	mov    0x30(%rax),%rax
  8028ea:	48 85 c0             	test   %rax,%rax
  8028ed:	75 07                	jne    8028f6 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8028ef:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028f4:	eb 16                	jmp    80290c <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8028f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028fa:	48 8b 40 30          	mov    0x30(%rax),%rax
  8028fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802902:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802905:	89 ce                	mov    %ecx,%esi
  802907:	48 89 d7             	mov    %rdx,%rdi
  80290a:	ff d0                	callq  *%rax
}
  80290c:	c9                   	leaveq 
  80290d:	c3                   	retq   

000000000080290e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80290e:	55                   	push   %rbp
  80290f:	48 89 e5             	mov    %rsp,%rbp
  802912:	48 83 ec 30          	sub    $0x30,%rsp
  802916:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802919:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80291d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802921:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802924:	48 89 d6             	mov    %rdx,%rsi
  802927:	89 c7                	mov    %eax,%edi
  802929:	48 b8 ad 21 80 00 00 	movabs $0x8021ad,%rax
  802930:	00 00 00 
  802933:	ff d0                	callq  *%rax
  802935:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802938:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80293c:	78 24                	js     802962 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80293e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802942:	8b 00                	mov    (%rax),%eax
  802944:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802948:	48 89 d6             	mov    %rdx,%rsi
  80294b:	89 c7                	mov    %eax,%edi
  80294d:	48 b8 06 23 80 00 00 	movabs $0x802306,%rax
  802954:	00 00 00 
  802957:	ff d0                	callq  *%rax
  802959:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80295c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802960:	79 05                	jns    802967 <fstat+0x59>
		return r;
  802962:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802965:	eb 5e                	jmp    8029c5 <fstat+0xb7>
	if (!dev->dev_stat)
  802967:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80296b:	48 8b 40 28          	mov    0x28(%rax),%rax
  80296f:	48 85 c0             	test   %rax,%rax
  802972:	75 07                	jne    80297b <fstat+0x6d>
		return -E_NOT_SUPP;
  802974:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802979:	eb 4a                	jmp    8029c5 <fstat+0xb7>
	stat->st_name[0] = 0;
  80297b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80297f:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802982:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802986:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80298d:	00 00 00 
	stat->st_isdir = 0;
  802990:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802994:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80299b:	00 00 00 
	stat->st_dev = dev;
  80299e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029a6:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8029ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029b1:	48 8b 40 28          	mov    0x28(%rax),%rax
  8029b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029b9:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8029bd:	48 89 ce             	mov    %rcx,%rsi
  8029c0:	48 89 d7             	mov    %rdx,%rdi
  8029c3:	ff d0                	callq  *%rax
}
  8029c5:	c9                   	leaveq 
  8029c6:	c3                   	retq   

00000000008029c7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8029c7:	55                   	push   %rbp
  8029c8:	48 89 e5             	mov    %rsp,%rbp
  8029cb:	48 83 ec 20          	sub    $0x20,%rsp
  8029cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8029d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029db:	be 00 00 00 00       	mov    $0x0,%esi
  8029e0:	48 89 c7             	mov    %rax,%rdi
  8029e3:	48 b8 b5 2a 80 00 00 	movabs $0x802ab5,%rax
  8029ea:	00 00 00 
  8029ed:	ff d0                	callq  *%rax
  8029ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f6:	79 05                	jns    8029fd <stat+0x36>
		return fd;
  8029f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029fb:	eb 2f                	jmp    802a2c <stat+0x65>
	r = fstat(fd, stat);
  8029fd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a04:	48 89 d6             	mov    %rdx,%rsi
  802a07:	89 c7                	mov    %eax,%edi
  802a09:	48 b8 0e 29 80 00 00 	movabs $0x80290e,%rax
  802a10:	00 00 00 
  802a13:	ff d0                	callq  *%rax
  802a15:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802a18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1b:	89 c7                	mov    %eax,%edi
  802a1d:	48 b8 bd 23 80 00 00 	movabs $0x8023bd,%rax
  802a24:	00 00 00 
  802a27:	ff d0                	callq  *%rax
	return r;
  802a29:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802a2c:	c9                   	leaveq 
  802a2d:	c3                   	retq   

0000000000802a2e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802a2e:	55                   	push   %rbp
  802a2f:	48 89 e5             	mov    %rsp,%rbp
  802a32:	48 83 ec 10          	sub    $0x10,%rsp
  802a36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802a39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802a3d:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  802a44:	00 00 00 
  802a47:	8b 00                	mov    (%rax),%eax
  802a49:	85 c0                	test   %eax,%eax
  802a4b:	75 1d                	jne    802a6a <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802a4d:	bf 01 00 00 00       	mov    $0x1,%edi
  802a52:	48 b8 0c 43 80 00 00 	movabs $0x80430c,%rax
  802a59:	00 00 00 
  802a5c:	ff d0                	callq  *%rax
  802a5e:	48 ba 00 74 80 00 00 	movabs $0x807400,%rdx
  802a65:	00 00 00 
  802a68:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802a6a:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  802a71:	00 00 00 
  802a74:	8b 00                	mov    (%rax),%eax
  802a76:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802a79:	b9 07 00 00 00       	mov    $0x7,%ecx
  802a7e:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802a85:	00 00 00 
  802a88:	89 c7                	mov    %eax,%edi
  802a8a:	48 b8 aa 42 80 00 00 	movabs $0x8042aa,%rax
  802a91:	00 00 00 
  802a94:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802a96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a9a:	ba 00 00 00 00       	mov    $0x0,%edx
  802a9f:	48 89 c6             	mov    %rax,%rsi
  802aa2:	bf 00 00 00 00       	mov    $0x0,%edi
  802aa7:	48 b8 a4 41 80 00 00 	movabs $0x8041a4,%rax
  802aae:	00 00 00 
  802ab1:	ff d0                	callq  *%rax
}
  802ab3:	c9                   	leaveq 
  802ab4:	c3                   	retq   

0000000000802ab5 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802ab5:	55                   	push   %rbp
  802ab6:	48 89 e5             	mov    %rsp,%rbp
  802ab9:	48 83 ec 30          	sub    $0x30,%rsp
  802abd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802ac1:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802ac4:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802acb:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802ad2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802ad9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802ade:	75 08                	jne    802ae8 <open+0x33>
	{
		return r;
  802ae0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae3:	e9 f2 00 00 00       	jmpq   802bda <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802ae8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aec:	48 89 c7             	mov    %rax,%rdi
  802aef:	48 b8 f5 13 80 00 00 	movabs $0x8013f5,%rax
  802af6:	00 00 00 
  802af9:	ff d0                	callq  *%rax
  802afb:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802afe:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802b05:	7e 0a                	jle    802b11 <open+0x5c>
	{
		return -E_BAD_PATH;
  802b07:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b0c:	e9 c9 00 00 00       	jmpq   802bda <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802b11:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802b18:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802b19:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802b1d:	48 89 c7             	mov    %rax,%rdi
  802b20:	48 b8 15 21 80 00 00 	movabs $0x802115,%rax
  802b27:	00 00 00 
  802b2a:	ff d0                	callq  *%rax
  802b2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b33:	78 09                	js     802b3e <open+0x89>
  802b35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b39:	48 85 c0             	test   %rax,%rax
  802b3c:	75 08                	jne    802b46 <open+0x91>
		{
			return r;
  802b3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b41:	e9 94 00 00 00       	jmpq   802bda <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802b46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b4a:	ba 00 04 00 00       	mov    $0x400,%edx
  802b4f:	48 89 c6             	mov    %rax,%rsi
  802b52:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802b59:	00 00 00 
  802b5c:	48 b8 f3 14 80 00 00 	movabs $0x8014f3,%rax
  802b63:	00 00 00 
  802b66:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802b68:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b6f:	00 00 00 
  802b72:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802b75:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802b7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b7f:	48 89 c6             	mov    %rax,%rsi
  802b82:	bf 01 00 00 00       	mov    $0x1,%edi
  802b87:	48 b8 2e 2a 80 00 00 	movabs $0x802a2e,%rax
  802b8e:	00 00 00 
  802b91:	ff d0                	callq  *%rax
  802b93:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b9a:	79 2b                	jns    802bc7 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802b9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba0:	be 00 00 00 00       	mov    $0x0,%esi
  802ba5:	48 89 c7             	mov    %rax,%rdi
  802ba8:	48 b8 3d 22 80 00 00 	movabs $0x80223d,%rax
  802baf:	00 00 00 
  802bb2:	ff d0                	callq  *%rax
  802bb4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802bb7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bbb:	79 05                	jns    802bc2 <open+0x10d>
			{
				return d;
  802bbd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bc0:	eb 18                	jmp    802bda <open+0x125>
			}
			return r;
  802bc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc5:	eb 13                	jmp    802bda <open+0x125>
		}	
		return fd2num(fd_store);
  802bc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bcb:	48 89 c7             	mov    %rax,%rdi
  802bce:	48 b8 c7 20 80 00 00 	movabs $0x8020c7,%rax
  802bd5:	00 00 00 
  802bd8:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802bda:	c9                   	leaveq 
  802bdb:	c3                   	retq   

0000000000802bdc <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802bdc:	55                   	push   %rbp
  802bdd:	48 89 e5             	mov    %rsp,%rbp
  802be0:	48 83 ec 10          	sub    $0x10,%rsp
  802be4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802be8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bec:	8b 50 0c             	mov    0xc(%rax),%edx
  802bef:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bf6:	00 00 00 
  802bf9:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802bfb:	be 00 00 00 00       	mov    $0x0,%esi
  802c00:	bf 06 00 00 00       	mov    $0x6,%edi
  802c05:	48 b8 2e 2a 80 00 00 	movabs $0x802a2e,%rax
  802c0c:	00 00 00 
  802c0f:	ff d0                	callq  *%rax
}
  802c11:	c9                   	leaveq 
  802c12:	c3                   	retq   

0000000000802c13 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802c13:	55                   	push   %rbp
  802c14:	48 89 e5             	mov    %rsp,%rbp
  802c17:	48 83 ec 30          	sub    $0x30,%rsp
  802c1b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c1f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c23:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802c27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802c2e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802c33:	74 07                	je     802c3c <devfile_read+0x29>
  802c35:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802c3a:	75 07                	jne    802c43 <devfile_read+0x30>
		return -E_INVAL;
  802c3c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c41:	eb 77                	jmp    802cba <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802c43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c47:	8b 50 0c             	mov    0xc(%rax),%edx
  802c4a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c51:	00 00 00 
  802c54:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802c56:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c5d:	00 00 00 
  802c60:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c64:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802c68:	be 00 00 00 00       	mov    $0x0,%esi
  802c6d:	bf 03 00 00 00       	mov    $0x3,%edi
  802c72:	48 b8 2e 2a 80 00 00 	movabs $0x802a2e,%rax
  802c79:	00 00 00 
  802c7c:	ff d0                	callq  *%rax
  802c7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c85:	7f 05                	jg     802c8c <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802c87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c8a:	eb 2e                	jmp    802cba <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802c8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c8f:	48 63 d0             	movslq %eax,%rdx
  802c92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c96:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802c9d:	00 00 00 
  802ca0:	48 89 c7             	mov    %rax,%rdi
  802ca3:	48 b8 85 17 80 00 00 	movabs $0x801785,%rax
  802caa:	00 00 00 
  802cad:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802caf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cb3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802cb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802cba:	c9                   	leaveq 
  802cbb:	c3                   	retq   

0000000000802cbc <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802cbc:	55                   	push   %rbp
  802cbd:	48 89 e5             	mov    %rsp,%rbp
  802cc0:	48 83 ec 30          	sub    $0x30,%rsp
  802cc4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cc8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ccc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802cd0:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802cd7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802cdc:	74 07                	je     802ce5 <devfile_write+0x29>
  802cde:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802ce3:	75 08                	jne    802ced <devfile_write+0x31>
		return r;
  802ce5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce8:	e9 9a 00 00 00       	jmpq   802d87 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802ced:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf1:	8b 50 0c             	mov    0xc(%rax),%edx
  802cf4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cfb:	00 00 00 
  802cfe:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802d00:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802d07:	00 
  802d08:	76 08                	jbe    802d12 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802d0a:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802d11:	00 
	}
	fsipcbuf.write.req_n = n;
  802d12:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d19:	00 00 00 
  802d1c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d20:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802d24:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d28:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d2c:	48 89 c6             	mov    %rax,%rsi
  802d2f:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802d36:	00 00 00 
  802d39:	48 b8 85 17 80 00 00 	movabs $0x801785,%rax
  802d40:	00 00 00 
  802d43:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802d45:	be 00 00 00 00       	mov    $0x0,%esi
  802d4a:	bf 04 00 00 00       	mov    $0x4,%edi
  802d4f:	48 b8 2e 2a 80 00 00 	movabs $0x802a2e,%rax
  802d56:	00 00 00 
  802d59:	ff d0                	callq  *%rax
  802d5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d62:	7f 20                	jg     802d84 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802d64:	48 bf 66 4a 80 00 00 	movabs $0x804a66,%rdi
  802d6b:	00 00 00 
  802d6e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d73:	48 ba 52 07 80 00 00 	movabs $0x800752,%rdx
  802d7a:	00 00 00 
  802d7d:	ff d2                	callq  *%rdx
		return r;
  802d7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d82:	eb 03                	jmp    802d87 <devfile_write+0xcb>
	}
	return r;
  802d84:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802d87:	c9                   	leaveq 
  802d88:	c3                   	retq   

0000000000802d89 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802d89:	55                   	push   %rbp
  802d8a:	48 89 e5             	mov    %rsp,%rbp
  802d8d:	48 83 ec 20          	sub    $0x20,%rsp
  802d91:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d95:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802d99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9d:	8b 50 0c             	mov    0xc(%rax),%edx
  802da0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802da7:	00 00 00 
  802daa:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802dac:	be 00 00 00 00       	mov    $0x0,%esi
  802db1:	bf 05 00 00 00       	mov    $0x5,%edi
  802db6:	48 b8 2e 2a 80 00 00 	movabs $0x802a2e,%rax
  802dbd:	00 00 00 
  802dc0:	ff d0                	callq  *%rax
  802dc2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dc5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dc9:	79 05                	jns    802dd0 <devfile_stat+0x47>
		return r;
  802dcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dce:	eb 56                	jmp    802e26 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802dd0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dd4:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ddb:	00 00 00 
  802dde:	48 89 c7             	mov    %rax,%rdi
  802de1:	48 b8 61 14 80 00 00 	movabs $0x801461,%rax
  802de8:	00 00 00 
  802deb:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802ded:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802df4:	00 00 00 
  802df7:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802dfd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e01:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802e07:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e0e:	00 00 00 
  802e11:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802e17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e1b:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802e21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e26:	c9                   	leaveq 
  802e27:	c3                   	retq   

0000000000802e28 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802e28:	55                   	push   %rbp
  802e29:	48 89 e5             	mov    %rsp,%rbp
  802e2c:	48 83 ec 10          	sub    $0x10,%rsp
  802e30:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e34:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802e37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e3b:	8b 50 0c             	mov    0xc(%rax),%edx
  802e3e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e45:	00 00 00 
  802e48:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802e4a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e51:	00 00 00 
  802e54:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802e57:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802e5a:	be 00 00 00 00       	mov    $0x0,%esi
  802e5f:	bf 02 00 00 00       	mov    $0x2,%edi
  802e64:	48 b8 2e 2a 80 00 00 	movabs $0x802a2e,%rax
  802e6b:	00 00 00 
  802e6e:	ff d0                	callq  *%rax
}
  802e70:	c9                   	leaveq 
  802e71:	c3                   	retq   

0000000000802e72 <remove>:

// Delete a file
int
remove(const char *path)
{
  802e72:	55                   	push   %rbp
  802e73:	48 89 e5             	mov    %rsp,%rbp
  802e76:	48 83 ec 10          	sub    $0x10,%rsp
  802e7a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802e7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e82:	48 89 c7             	mov    %rax,%rdi
  802e85:	48 b8 f5 13 80 00 00 	movabs $0x8013f5,%rax
  802e8c:	00 00 00 
  802e8f:	ff d0                	callq  *%rax
  802e91:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802e96:	7e 07                	jle    802e9f <remove+0x2d>
		return -E_BAD_PATH;
  802e98:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e9d:	eb 33                	jmp    802ed2 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802e9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea3:	48 89 c6             	mov    %rax,%rsi
  802ea6:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802ead:	00 00 00 
  802eb0:	48 b8 61 14 80 00 00 	movabs $0x801461,%rax
  802eb7:	00 00 00 
  802eba:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802ebc:	be 00 00 00 00       	mov    $0x0,%esi
  802ec1:	bf 07 00 00 00       	mov    $0x7,%edi
  802ec6:	48 b8 2e 2a 80 00 00 	movabs $0x802a2e,%rax
  802ecd:	00 00 00 
  802ed0:	ff d0                	callq  *%rax
}
  802ed2:	c9                   	leaveq 
  802ed3:	c3                   	retq   

0000000000802ed4 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802ed4:	55                   	push   %rbp
  802ed5:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802ed8:	be 00 00 00 00       	mov    $0x0,%esi
  802edd:	bf 08 00 00 00       	mov    $0x8,%edi
  802ee2:	48 b8 2e 2a 80 00 00 	movabs $0x802a2e,%rax
  802ee9:	00 00 00 
  802eec:	ff d0                	callq  *%rax
}
  802eee:	5d                   	pop    %rbp
  802eef:	c3                   	retq   

0000000000802ef0 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802ef0:	55                   	push   %rbp
  802ef1:	48 89 e5             	mov    %rsp,%rbp
  802ef4:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802efb:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802f02:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802f09:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802f10:	be 00 00 00 00       	mov    $0x0,%esi
  802f15:	48 89 c7             	mov    %rax,%rdi
  802f18:	48 b8 b5 2a 80 00 00 	movabs $0x802ab5,%rax
  802f1f:	00 00 00 
  802f22:	ff d0                	callq  *%rax
  802f24:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802f27:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f2b:	79 28                	jns    802f55 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802f2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f30:	89 c6                	mov    %eax,%esi
  802f32:	48 bf 82 4a 80 00 00 	movabs $0x804a82,%rdi
  802f39:	00 00 00 
  802f3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f41:	48 ba 52 07 80 00 00 	movabs $0x800752,%rdx
  802f48:	00 00 00 
  802f4b:	ff d2                	callq  *%rdx
		return fd_src;
  802f4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f50:	e9 74 01 00 00       	jmpq   8030c9 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802f55:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802f5c:	be 01 01 00 00       	mov    $0x101,%esi
  802f61:	48 89 c7             	mov    %rax,%rdi
  802f64:	48 b8 b5 2a 80 00 00 	movabs $0x802ab5,%rax
  802f6b:	00 00 00 
  802f6e:	ff d0                	callq  *%rax
  802f70:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802f73:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f77:	79 39                	jns    802fb2 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802f79:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f7c:	89 c6                	mov    %eax,%esi
  802f7e:	48 bf 98 4a 80 00 00 	movabs $0x804a98,%rdi
  802f85:	00 00 00 
  802f88:	b8 00 00 00 00       	mov    $0x0,%eax
  802f8d:	48 ba 52 07 80 00 00 	movabs $0x800752,%rdx
  802f94:	00 00 00 
  802f97:	ff d2                	callq  *%rdx
		close(fd_src);
  802f99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f9c:	89 c7                	mov    %eax,%edi
  802f9e:	48 b8 bd 23 80 00 00 	movabs $0x8023bd,%rax
  802fa5:	00 00 00 
  802fa8:	ff d0                	callq  *%rax
		return fd_dest;
  802faa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fad:	e9 17 01 00 00       	jmpq   8030c9 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802fb2:	eb 74                	jmp    803028 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802fb4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fb7:	48 63 d0             	movslq %eax,%rdx
  802fba:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802fc1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fc4:	48 89 ce             	mov    %rcx,%rsi
  802fc7:	89 c7                	mov    %eax,%edi
  802fc9:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  802fd0:	00 00 00 
  802fd3:	ff d0                	callq  *%rax
  802fd5:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802fd8:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802fdc:	79 4a                	jns    803028 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802fde:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802fe1:	89 c6                	mov    %eax,%esi
  802fe3:	48 bf b2 4a 80 00 00 	movabs $0x804ab2,%rdi
  802fea:	00 00 00 
  802fed:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff2:	48 ba 52 07 80 00 00 	movabs $0x800752,%rdx
  802ff9:	00 00 00 
  802ffc:	ff d2                	callq  *%rdx
			close(fd_src);
  802ffe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803001:	89 c7                	mov    %eax,%edi
  803003:	48 b8 bd 23 80 00 00 	movabs $0x8023bd,%rax
  80300a:	00 00 00 
  80300d:	ff d0                	callq  *%rax
			close(fd_dest);
  80300f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803012:	89 c7                	mov    %eax,%edi
  803014:	48 b8 bd 23 80 00 00 	movabs $0x8023bd,%rax
  80301b:	00 00 00 
  80301e:	ff d0                	callq  *%rax
			return write_size;
  803020:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803023:	e9 a1 00 00 00       	jmpq   8030c9 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803028:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80302f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803032:	ba 00 02 00 00       	mov    $0x200,%edx
  803037:	48 89 ce             	mov    %rcx,%rsi
  80303a:	89 c7                	mov    %eax,%edi
  80303c:	48 b8 df 25 80 00 00 	movabs $0x8025df,%rax
  803043:	00 00 00 
  803046:	ff d0                	callq  *%rax
  803048:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80304b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80304f:	0f 8f 5f ff ff ff    	jg     802fb4 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803055:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803059:	79 47                	jns    8030a2 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80305b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80305e:	89 c6                	mov    %eax,%esi
  803060:	48 bf c5 4a 80 00 00 	movabs $0x804ac5,%rdi
  803067:	00 00 00 
  80306a:	b8 00 00 00 00       	mov    $0x0,%eax
  80306f:	48 ba 52 07 80 00 00 	movabs $0x800752,%rdx
  803076:	00 00 00 
  803079:	ff d2                	callq  *%rdx
		close(fd_src);
  80307b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80307e:	89 c7                	mov    %eax,%edi
  803080:	48 b8 bd 23 80 00 00 	movabs $0x8023bd,%rax
  803087:	00 00 00 
  80308a:	ff d0                	callq  *%rax
		close(fd_dest);
  80308c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80308f:	89 c7                	mov    %eax,%edi
  803091:	48 b8 bd 23 80 00 00 	movabs $0x8023bd,%rax
  803098:	00 00 00 
  80309b:	ff d0                	callq  *%rax
		return read_size;
  80309d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8030a0:	eb 27                	jmp    8030c9 <copy+0x1d9>
	}
	close(fd_src);
  8030a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a5:	89 c7                	mov    %eax,%edi
  8030a7:	48 b8 bd 23 80 00 00 	movabs $0x8023bd,%rax
  8030ae:	00 00 00 
  8030b1:	ff d0                	callq  *%rax
	close(fd_dest);
  8030b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030b6:	89 c7                	mov    %eax,%edi
  8030b8:	48 b8 bd 23 80 00 00 	movabs $0x8023bd,%rax
  8030bf:	00 00 00 
  8030c2:	ff d0                	callq  *%rax
	return 0;
  8030c4:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8030c9:	c9                   	leaveq 
  8030ca:	c3                   	retq   

00000000008030cb <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8030cb:	55                   	push   %rbp
  8030cc:	48 89 e5             	mov    %rsp,%rbp
  8030cf:	48 83 ec 20          	sub    $0x20,%rsp
  8030d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  8030d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030db:	8b 40 0c             	mov    0xc(%rax),%eax
  8030de:	85 c0                	test   %eax,%eax
  8030e0:	7e 67                	jle    803149 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8030e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030e6:	8b 40 04             	mov    0x4(%rax),%eax
  8030e9:	48 63 d0             	movslq %eax,%rdx
  8030ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030f0:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8030f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030f8:	8b 00                	mov    (%rax),%eax
  8030fa:	48 89 ce             	mov    %rcx,%rsi
  8030fd:	89 c7                	mov    %eax,%edi
  8030ff:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  803106:	00 00 00 
  803109:	ff d0                	callq  *%rax
  80310b:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  80310e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803112:	7e 13                	jle    803127 <writebuf+0x5c>
			b->result += result;
  803114:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803118:	8b 50 08             	mov    0x8(%rax),%edx
  80311b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80311e:	01 c2                	add    %eax,%edx
  803120:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803124:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  803127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80312b:	8b 40 04             	mov    0x4(%rax),%eax
  80312e:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803131:	74 16                	je     803149 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  803133:	b8 00 00 00 00       	mov    $0x0,%eax
  803138:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80313c:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  803140:	89 c2                	mov    %eax,%edx
  803142:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803146:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  803149:	c9                   	leaveq 
  80314a:	c3                   	retq   

000000000080314b <putch>:

static void
putch(int ch, void *thunk)
{
  80314b:	55                   	push   %rbp
  80314c:	48 89 e5             	mov    %rsp,%rbp
  80314f:	48 83 ec 20          	sub    $0x20,%rsp
  803153:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803156:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  80315a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80315e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  803162:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803166:	8b 40 04             	mov    0x4(%rax),%eax
  803169:	8d 48 01             	lea    0x1(%rax),%ecx
  80316c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803170:	89 4a 04             	mov    %ecx,0x4(%rdx)
  803173:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803176:	89 d1                	mov    %edx,%ecx
  803178:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80317c:	48 98                	cltq   
  80317e:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  803182:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803186:	8b 40 04             	mov    0x4(%rax),%eax
  803189:	3d 00 01 00 00       	cmp    $0x100,%eax
  80318e:	75 1e                	jne    8031ae <putch+0x63>
		writebuf(b);
  803190:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803194:	48 89 c7             	mov    %rax,%rdi
  803197:	48 b8 cb 30 80 00 00 	movabs $0x8030cb,%rax
  80319e:	00 00 00 
  8031a1:	ff d0                	callq  *%rax
		b->idx = 0;
  8031a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  8031ae:	c9                   	leaveq 
  8031af:	c3                   	retq   

00000000008031b0 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8031b0:	55                   	push   %rbp
  8031b1:	48 89 e5             	mov    %rsp,%rbp
  8031b4:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  8031bb:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  8031c1:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  8031c8:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  8031cf:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  8031d5:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  8031db:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8031e2:	00 00 00 
	b.result = 0;
  8031e5:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  8031ec:	00 00 00 
	b.error = 1;
  8031ef:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  8031f6:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8031f9:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  803200:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  803207:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80320e:	48 89 c6             	mov    %rax,%rsi
  803211:	48 bf 4b 31 80 00 00 	movabs $0x80314b,%rdi
  803218:	00 00 00 
  80321b:	48 b8 05 0b 80 00 00 	movabs $0x800b05,%rax
  803222:	00 00 00 
  803225:	ff d0                	callq  *%rax
	if (b.idx > 0)
  803227:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  80322d:	85 c0                	test   %eax,%eax
  80322f:	7e 16                	jle    803247 <vfprintf+0x97>
		writebuf(&b);
  803231:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803238:	48 89 c7             	mov    %rax,%rdi
  80323b:	48 b8 cb 30 80 00 00 	movabs $0x8030cb,%rax
  803242:	00 00 00 
  803245:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  803247:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80324d:	85 c0                	test   %eax,%eax
  80324f:	74 08                	je     803259 <vfprintf+0xa9>
  803251:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803257:	eb 06                	jmp    80325f <vfprintf+0xaf>
  803259:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  80325f:	c9                   	leaveq 
  803260:	c3                   	retq   

0000000000803261 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  803261:	55                   	push   %rbp
  803262:	48 89 e5             	mov    %rsp,%rbp
  803265:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80326c:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  803272:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803279:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803280:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803287:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80328e:	84 c0                	test   %al,%al
  803290:	74 20                	je     8032b2 <fprintf+0x51>
  803292:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803296:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80329a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80329e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8032a2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8032a6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8032aa:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8032ae:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8032b2:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8032b9:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  8032c0:	00 00 00 
  8032c3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8032ca:	00 00 00 
  8032cd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8032d1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8032d8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8032df:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8032e6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8032ed:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8032f4:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8032fa:	48 89 ce             	mov    %rcx,%rsi
  8032fd:	89 c7                	mov    %eax,%edi
  8032ff:	48 b8 b0 31 80 00 00 	movabs $0x8031b0,%rax
  803306:	00 00 00 
  803309:	ff d0                	callq  *%rax
  80330b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803311:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803317:	c9                   	leaveq 
  803318:	c3                   	retq   

0000000000803319 <printf>:

int
printf(const char *fmt, ...)
{
  803319:	55                   	push   %rbp
  80331a:	48 89 e5             	mov    %rsp,%rbp
  80331d:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803324:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80332b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803332:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803339:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803340:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803347:	84 c0                	test   %al,%al
  803349:	74 20                	je     80336b <printf+0x52>
  80334b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80334f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803353:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803357:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80335b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80335f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803363:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803367:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80336b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803372:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803379:	00 00 00 
  80337c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803383:	00 00 00 
  803386:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80338a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803391:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803398:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  80339f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8033a6:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8033ad:	48 89 c6             	mov    %rax,%rsi
  8033b0:	bf 01 00 00 00       	mov    $0x1,%edi
  8033b5:	48 b8 b0 31 80 00 00 	movabs $0x8031b0,%rax
  8033bc:	00 00 00 
  8033bf:	ff d0                	callq  *%rax
  8033c1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8033c7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8033cd:	c9                   	leaveq 
  8033ce:	c3                   	retq   

00000000008033cf <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8033cf:	55                   	push   %rbp
  8033d0:	48 89 e5             	mov    %rsp,%rbp
  8033d3:	48 83 ec 20          	sub    $0x20,%rsp
  8033d7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8033da:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8033de:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033e1:	48 89 d6             	mov    %rdx,%rsi
  8033e4:	89 c7                	mov    %eax,%edi
  8033e6:	48 b8 ad 21 80 00 00 	movabs $0x8021ad,%rax
  8033ed:	00 00 00 
  8033f0:	ff d0                	callq  *%rax
  8033f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033f9:	79 05                	jns    803400 <fd2sockid+0x31>
		return r;
  8033fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033fe:	eb 24                	jmp    803424 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803400:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803404:	8b 10                	mov    (%rax),%edx
  803406:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  80340d:	00 00 00 
  803410:	8b 00                	mov    (%rax),%eax
  803412:	39 c2                	cmp    %eax,%edx
  803414:	74 07                	je     80341d <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803416:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80341b:	eb 07                	jmp    803424 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80341d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803421:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803424:	c9                   	leaveq 
  803425:	c3                   	retq   

0000000000803426 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803426:	55                   	push   %rbp
  803427:	48 89 e5             	mov    %rsp,%rbp
  80342a:	48 83 ec 20          	sub    $0x20,%rsp
  80342e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803431:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803435:	48 89 c7             	mov    %rax,%rdi
  803438:	48 b8 15 21 80 00 00 	movabs $0x802115,%rax
  80343f:	00 00 00 
  803442:	ff d0                	callq  *%rax
  803444:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803447:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80344b:	78 26                	js     803473 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80344d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803451:	ba 07 04 00 00       	mov    $0x407,%edx
  803456:	48 89 c6             	mov    %rax,%rsi
  803459:	bf 00 00 00 00       	mov    $0x0,%edi
  80345e:	48 b8 90 1d 80 00 00 	movabs $0x801d90,%rax
  803465:	00 00 00 
  803468:	ff d0                	callq  *%rax
  80346a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80346d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803471:	79 16                	jns    803489 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803473:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803476:	89 c7                	mov    %eax,%edi
  803478:	48 b8 33 39 80 00 00 	movabs $0x803933,%rax
  80347f:	00 00 00 
  803482:	ff d0                	callq  *%rax
		return r;
  803484:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803487:	eb 3a                	jmp    8034c3 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803489:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80348d:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803494:	00 00 00 
  803497:	8b 12                	mov    (%rdx),%edx
  803499:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80349b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80349f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8034a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034aa:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034ad:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8034b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034b4:	48 89 c7             	mov    %rax,%rdi
  8034b7:	48 b8 c7 20 80 00 00 	movabs $0x8020c7,%rax
  8034be:	00 00 00 
  8034c1:	ff d0                	callq  *%rax
}
  8034c3:	c9                   	leaveq 
  8034c4:	c3                   	retq   

00000000008034c5 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8034c5:	55                   	push   %rbp
  8034c6:	48 89 e5             	mov    %rsp,%rbp
  8034c9:	48 83 ec 30          	sub    $0x30,%rsp
  8034cd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034d4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034db:	89 c7                	mov    %eax,%edi
  8034dd:	48 b8 cf 33 80 00 00 	movabs $0x8033cf,%rax
  8034e4:	00 00 00 
  8034e7:	ff d0                	callq  *%rax
  8034e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034f0:	79 05                	jns    8034f7 <accept+0x32>
		return r;
  8034f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f5:	eb 3b                	jmp    803532 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8034f7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8034fb:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8034ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803502:	48 89 ce             	mov    %rcx,%rsi
  803505:	89 c7                	mov    %eax,%edi
  803507:	48 b8 10 38 80 00 00 	movabs $0x803810,%rax
  80350e:	00 00 00 
  803511:	ff d0                	callq  *%rax
  803513:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803516:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80351a:	79 05                	jns    803521 <accept+0x5c>
		return r;
  80351c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80351f:	eb 11                	jmp    803532 <accept+0x6d>
	return alloc_sockfd(r);
  803521:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803524:	89 c7                	mov    %eax,%edi
  803526:	48 b8 26 34 80 00 00 	movabs $0x803426,%rax
  80352d:	00 00 00 
  803530:	ff d0                	callq  *%rax
}
  803532:	c9                   	leaveq 
  803533:	c3                   	retq   

0000000000803534 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803534:	55                   	push   %rbp
  803535:	48 89 e5             	mov    %rsp,%rbp
  803538:	48 83 ec 20          	sub    $0x20,%rsp
  80353c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80353f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803543:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803546:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803549:	89 c7                	mov    %eax,%edi
  80354b:	48 b8 cf 33 80 00 00 	movabs $0x8033cf,%rax
  803552:	00 00 00 
  803555:	ff d0                	callq  *%rax
  803557:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80355a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80355e:	79 05                	jns    803565 <bind+0x31>
		return r;
  803560:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803563:	eb 1b                	jmp    803580 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803565:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803568:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80356c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80356f:	48 89 ce             	mov    %rcx,%rsi
  803572:	89 c7                	mov    %eax,%edi
  803574:	48 b8 8f 38 80 00 00 	movabs $0x80388f,%rax
  80357b:	00 00 00 
  80357e:	ff d0                	callq  *%rax
}
  803580:	c9                   	leaveq 
  803581:	c3                   	retq   

0000000000803582 <shutdown>:

int
shutdown(int s, int how)
{
  803582:	55                   	push   %rbp
  803583:	48 89 e5             	mov    %rsp,%rbp
  803586:	48 83 ec 20          	sub    $0x20,%rsp
  80358a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80358d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803590:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803593:	89 c7                	mov    %eax,%edi
  803595:	48 b8 cf 33 80 00 00 	movabs $0x8033cf,%rax
  80359c:	00 00 00 
  80359f:	ff d0                	callq  *%rax
  8035a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035a8:	79 05                	jns    8035af <shutdown+0x2d>
		return r;
  8035aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ad:	eb 16                	jmp    8035c5 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8035af:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035b5:	89 d6                	mov    %edx,%esi
  8035b7:	89 c7                	mov    %eax,%edi
  8035b9:	48 b8 f3 38 80 00 00 	movabs $0x8038f3,%rax
  8035c0:	00 00 00 
  8035c3:	ff d0                	callq  *%rax
}
  8035c5:	c9                   	leaveq 
  8035c6:	c3                   	retq   

00000000008035c7 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8035c7:	55                   	push   %rbp
  8035c8:	48 89 e5             	mov    %rsp,%rbp
  8035cb:	48 83 ec 10          	sub    $0x10,%rsp
  8035cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8035d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035d7:	48 89 c7             	mov    %rax,%rdi
  8035da:	48 b8 8e 43 80 00 00 	movabs $0x80438e,%rax
  8035e1:	00 00 00 
  8035e4:	ff d0                	callq  *%rax
  8035e6:	83 f8 01             	cmp    $0x1,%eax
  8035e9:	75 17                	jne    803602 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8035eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035ef:	8b 40 0c             	mov    0xc(%rax),%eax
  8035f2:	89 c7                	mov    %eax,%edi
  8035f4:	48 b8 33 39 80 00 00 	movabs $0x803933,%rax
  8035fb:	00 00 00 
  8035fe:	ff d0                	callq  *%rax
  803600:	eb 05                	jmp    803607 <devsock_close+0x40>
	else
		return 0;
  803602:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803607:	c9                   	leaveq 
  803608:	c3                   	retq   

0000000000803609 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803609:	55                   	push   %rbp
  80360a:	48 89 e5             	mov    %rsp,%rbp
  80360d:	48 83 ec 20          	sub    $0x20,%rsp
  803611:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803614:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803618:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80361b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80361e:	89 c7                	mov    %eax,%edi
  803620:	48 b8 cf 33 80 00 00 	movabs $0x8033cf,%rax
  803627:	00 00 00 
  80362a:	ff d0                	callq  *%rax
  80362c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80362f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803633:	79 05                	jns    80363a <connect+0x31>
		return r;
  803635:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803638:	eb 1b                	jmp    803655 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80363a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80363d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803641:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803644:	48 89 ce             	mov    %rcx,%rsi
  803647:	89 c7                	mov    %eax,%edi
  803649:	48 b8 60 39 80 00 00 	movabs $0x803960,%rax
  803650:	00 00 00 
  803653:	ff d0                	callq  *%rax
}
  803655:	c9                   	leaveq 
  803656:	c3                   	retq   

0000000000803657 <listen>:

int
listen(int s, int backlog)
{
  803657:	55                   	push   %rbp
  803658:	48 89 e5             	mov    %rsp,%rbp
  80365b:	48 83 ec 20          	sub    $0x20,%rsp
  80365f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803662:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803665:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803668:	89 c7                	mov    %eax,%edi
  80366a:	48 b8 cf 33 80 00 00 	movabs $0x8033cf,%rax
  803671:	00 00 00 
  803674:	ff d0                	callq  *%rax
  803676:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803679:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80367d:	79 05                	jns    803684 <listen+0x2d>
		return r;
  80367f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803682:	eb 16                	jmp    80369a <listen+0x43>
	return nsipc_listen(r, backlog);
  803684:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803687:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80368a:	89 d6                	mov    %edx,%esi
  80368c:	89 c7                	mov    %eax,%edi
  80368e:	48 b8 c4 39 80 00 00 	movabs $0x8039c4,%rax
  803695:	00 00 00 
  803698:	ff d0                	callq  *%rax
}
  80369a:	c9                   	leaveq 
  80369b:	c3                   	retq   

000000000080369c <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80369c:	55                   	push   %rbp
  80369d:	48 89 e5             	mov    %rsp,%rbp
  8036a0:	48 83 ec 20          	sub    $0x20,%rsp
  8036a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036ac:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8036b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036b4:	89 c2                	mov    %eax,%edx
  8036b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036ba:	8b 40 0c             	mov    0xc(%rax),%eax
  8036bd:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8036c1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8036c6:	89 c7                	mov    %eax,%edi
  8036c8:	48 b8 04 3a 80 00 00 	movabs $0x803a04,%rax
  8036cf:	00 00 00 
  8036d2:	ff d0                	callq  *%rax
}
  8036d4:	c9                   	leaveq 
  8036d5:	c3                   	retq   

00000000008036d6 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8036d6:	55                   	push   %rbp
  8036d7:	48 89 e5             	mov    %rsp,%rbp
  8036da:	48 83 ec 20          	sub    $0x20,%rsp
  8036de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036e6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8036ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036ee:	89 c2                	mov    %eax,%edx
  8036f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036f4:	8b 40 0c             	mov    0xc(%rax),%eax
  8036f7:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8036fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  803700:	89 c7                	mov    %eax,%edi
  803702:	48 b8 d0 3a 80 00 00 	movabs $0x803ad0,%rax
  803709:	00 00 00 
  80370c:	ff d0                	callq  *%rax
}
  80370e:	c9                   	leaveq 
  80370f:	c3                   	retq   

0000000000803710 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803710:	55                   	push   %rbp
  803711:	48 89 e5             	mov    %rsp,%rbp
  803714:	48 83 ec 10          	sub    $0x10,%rsp
  803718:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80371c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803720:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803724:	48 be e0 4a 80 00 00 	movabs $0x804ae0,%rsi
  80372b:	00 00 00 
  80372e:	48 89 c7             	mov    %rax,%rdi
  803731:	48 b8 61 14 80 00 00 	movabs $0x801461,%rax
  803738:	00 00 00 
  80373b:	ff d0                	callq  *%rax
	return 0;
  80373d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803742:	c9                   	leaveq 
  803743:	c3                   	retq   

0000000000803744 <socket>:

int
socket(int domain, int type, int protocol)
{
  803744:	55                   	push   %rbp
  803745:	48 89 e5             	mov    %rsp,%rbp
  803748:	48 83 ec 20          	sub    $0x20,%rsp
  80374c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80374f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803752:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803755:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803758:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80375b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80375e:	89 ce                	mov    %ecx,%esi
  803760:	89 c7                	mov    %eax,%edi
  803762:	48 b8 88 3b 80 00 00 	movabs $0x803b88,%rax
  803769:	00 00 00 
  80376c:	ff d0                	callq  *%rax
  80376e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803771:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803775:	79 05                	jns    80377c <socket+0x38>
		return r;
  803777:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80377a:	eb 11                	jmp    80378d <socket+0x49>
	return alloc_sockfd(r);
  80377c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80377f:	89 c7                	mov    %eax,%edi
  803781:	48 b8 26 34 80 00 00 	movabs $0x803426,%rax
  803788:	00 00 00 
  80378b:	ff d0                	callq  *%rax
}
  80378d:	c9                   	leaveq 
  80378e:	c3                   	retq   

000000000080378f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80378f:	55                   	push   %rbp
  803790:	48 89 e5             	mov    %rsp,%rbp
  803793:	48 83 ec 10          	sub    $0x10,%rsp
  803797:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80379a:	48 b8 04 74 80 00 00 	movabs $0x807404,%rax
  8037a1:	00 00 00 
  8037a4:	8b 00                	mov    (%rax),%eax
  8037a6:	85 c0                	test   %eax,%eax
  8037a8:	75 1d                	jne    8037c7 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8037aa:	bf 02 00 00 00       	mov    $0x2,%edi
  8037af:	48 b8 0c 43 80 00 00 	movabs $0x80430c,%rax
  8037b6:	00 00 00 
  8037b9:	ff d0                	callq  *%rax
  8037bb:	48 ba 04 74 80 00 00 	movabs $0x807404,%rdx
  8037c2:	00 00 00 
  8037c5:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8037c7:	48 b8 04 74 80 00 00 	movabs $0x807404,%rax
  8037ce:	00 00 00 
  8037d1:	8b 00                	mov    (%rax),%eax
  8037d3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8037d6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8037db:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8037e2:	00 00 00 
  8037e5:	89 c7                	mov    %eax,%edi
  8037e7:	48 b8 aa 42 80 00 00 	movabs $0x8042aa,%rax
  8037ee:	00 00 00 
  8037f1:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8037f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8037f8:	be 00 00 00 00       	mov    $0x0,%esi
  8037fd:	bf 00 00 00 00       	mov    $0x0,%edi
  803802:	48 b8 a4 41 80 00 00 	movabs $0x8041a4,%rax
  803809:	00 00 00 
  80380c:	ff d0                	callq  *%rax
}
  80380e:	c9                   	leaveq 
  80380f:	c3                   	retq   

0000000000803810 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803810:	55                   	push   %rbp
  803811:	48 89 e5             	mov    %rsp,%rbp
  803814:	48 83 ec 30          	sub    $0x30,%rsp
  803818:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80381b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80381f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803823:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80382a:	00 00 00 
  80382d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803830:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803832:	bf 01 00 00 00       	mov    $0x1,%edi
  803837:	48 b8 8f 37 80 00 00 	movabs $0x80378f,%rax
  80383e:	00 00 00 
  803841:	ff d0                	callq  *%rax
  803843:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803846:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80384a:	78 3e                	js     80388a <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80384c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803853:	00 00 00 
  803856:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80385a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80385e:	8b 40 10             	mov    0x10(%rax),%eax
  803861:	89 c2                	mov    %eax,%edx
  803863:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803867:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80386b:	48 89 ce             	mov    %rcx,%rsi
  80386e:	48 89 c7             	mov    %rax,%rdi
  803871:	48 b8 85 17 80 00 00 	movabs $0x801785,%rax
  803878:	00 00 00 
  80387b:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80387d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803881:	8b 50 10             	mov    0x10(%rax),%edx
  803884:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803888:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80388a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80388d:	c9                   	leaveq 
  80388e:	c3                   	retq   

000000000080388f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80388f:	55                   	push   %rbp
  803890:	48 89 e5             	mov    %rsp,%rbp
  803893:	48 83 ec 10          	sub    $0x10,%rsp
  803897:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80389a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80389e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8038a1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038a8:	00 00 00 
  8038ab:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038ae:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8038b0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038b7:	48 89 c6             	mov    %rax,%rsi
  8038ba:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8038c1:	00 00 00 
  8038c4:	48 b8 85 17 80 00 00 	movabs $0x801785,%rax
  8038cb:	00 00 00 
  8038ce:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8038d0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038d7:	00 00 00 
  8038da:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038dd:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8038e0:	bf 02 00 00 00       	mov    $0x2,%edi
  8038e5:	48 b8 8f 37 80 00 00 	movabs $0x80378f,%rax
  8038ec:	00 00 00 
  8038ef:	ff d0                	callq  *%rax
}
  8038f1:	c9                   	leaveq 
  8038f2:	c3                   	retq   

00000000008038f3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8038f3:	55                   	push   %rbp
  8038f4:	48 89 e5             	mov    %rsp,%rbp
  8038f7:	48 83 ec 10          	sub    $0x10,%rsp
  8038fb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038fe:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803901:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803908:	00 00 00 
  80390b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80390e:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803910:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803917:	00 00 00 
  80391a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80391d:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803920:	bf 03 00 00 00       	mov    $0x3,%edi
  803925:	48 b8 8f 37 80 00 00 	movabs $0x80378f,%rax
  80392c:	00 00 00 
  80392f:	ff d0                	callq  *%rax
}
  803931:	c9                   	leaveq 
  803932:	c3                   	retq   

0000000000803933 <nsipc_close>:

int
nsipc_close(int s)
{
  803933:	55                   	push   %rbp
  803934:	48 89 e5             	mov    %rsp,%rbp
  803937:	48 83 ec 10          	sub    $0x10,%rsp
  80393b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80393e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803945:	00 00 00 
  803948:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80394b:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80394d:	bf 04 00 00 00       	mov    $0x4,%edi
  803952:	48 b8 8f 37 80 00 00 	movabs $0x80378f,%rax
  803959:	00 00 00 
  80395c:	ff d0                	callq  *%rax
}
  80395e:	c9                   	leaveq 
  80395f:	c3                   	retq   

0000000000803960 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803960:	55                   	push   %rbp
  803961:	48 89 e5             	mov    %rsp,%rbp
  803964:	48 83 ec 10          	sub    $0x10,%rsp
  803968:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80396b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80396f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803972:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803979:	00 00 00 
  80397c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80397f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803981:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803984:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803988:	48 89 c6             	mov    %rax,%rsi
  80398b:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803992:	00 00 00 
  803995:	48 b8 85 17 80 00 00 	movabs $0x801785,%rax
  80399c:	00 00 00 
  80399f:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8039a1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039a8:	00 00 00 
  8039ab:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039ae:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8039b1:	bf 05 00 00 00       	mov    $0x5,%edi
  8039b6:	48 b8 8f 37 80 00 00 	movabs $0x80378f,%rax
  8039bd:	00 00 00 
  8039c0:	ff d0                	callq  *%rax
}
  8039c2:	c9                   	leaveq 
  8039c3:	c3                   	retq   

00000000008039c4 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8039c4:	55                   	push   %rbp
  8039c5:	48 89 e5             	mov    %rsp,%rbp
  8039c8:	48 83 ec 10          	sub    $0x10,%rsp
  8039cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039cf:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8039d2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039d9:	00 00 00 
  8039dc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039df:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8039e1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039e8:	00 00 00 
  8039eb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039ee:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8039f1:	bf 06 00 00 00       	mov    $0x6,%edi
  8039f6:	48 b8 8f 37 80 00 00 	movabs $0x80378f,%rax
  8039fd:	00 00 00 
  803a00:	ff d0                	callq  *%rax
}
  803a02:	c9                   	leaveq 
  803a03:	c3                   	retq   

0000000000803a04 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803a04:	55                   	push   %rbp
  803a05:	48 89 e5             	mov    %rsp,%rbp
  803a08:	48 83 ec 30          	sub    $0x30,%rsp
  803a0c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a0f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a13:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803a16:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803a19:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a20:	00 00 00 
  803a23:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a26:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803a28:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a2f:	00 00 00 
  803a32:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a35:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803a38:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a3f:	00 00 00 
  803a42:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803a45:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803a48:	bf 07 00 00 00       	mov    $0x7,%edi
  803a4d:	48 b8 8f 37 80 00 00 	movabs $0x80378f,%rax
  803a54:	00 00 00 
  803a57:	ff d0                	callq  *%rax
  803a59:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a60:	78 69                	js     803acb <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803a62:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803a69:	7f 08                	jg     803a73 <nsipc_recv+0x6f>
  803a6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a6e:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803a71:	7e 35                	jle    803aa8 <nsipc_recv+0xa4>
  803a73:	48 b9 e7 4a 80 00 00 	movabs $0x804ae7,%rcx
  803a7a:	00 00 00 
  803a7d:	48 ba fc 4a 80 00 00 	movabs $0x804afc,%rdx
  803a84:	00 00 00 
  803a87:	be 61 00 00 00       	mov    $0x61,%esi
  803a8c:	48 bf 11 4b 80 00 00 	movabs $0x804b11,%rdi
  803a93:	00 00 00 
  803a96:	b8 00 00 00 00       	mov    $0x0,%eax
  803a9b:	49 b8 19 05 80 00 00 	movabs $0x800519,%r8
  803aa2:	00 00 00 
  803aa5:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803aa8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aab:	48 63 d0             	movslq %eax,%rdx
  803aae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ab2:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803ab9:	00 00 00 
  803abc:	48 89 c7             	mov    %rax,%rdi
  803abf:	48 b8 85 17 80 00 00 	movabs $0x801785,%rax
  803ac6:	00 00 00 
  803ac9:	ff d0                	callq  *%rax
	}

	return r;
  803acb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ace:	c9                   	leaveq 
  803acf:	c3                   	retq   

0000000000803ad0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803ad0:	55                   	push   %rbp
  803ad1:	48 89 e5             	mov    %rsp,%rbp
  803ad4:	48 83 ec 20          	sub    $0x20,%rsp
  803ad8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803adb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803adf:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803ae2:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803ae5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803aec:	00 00 00 
  803aef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803af2:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803af4:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803afb:	7e 35                	jle    803b32 <nsipc_send+0x62>
  803afd:	48 b9 1d 4b 80 00 00 	movabs $0x804b1d,%rcx
  803b04:	00 00 00 
  803b07:	48 ba fc 4a 80 00 00 	movabs $0x804afc,%rdx
  803b0e:	00 00 00 
  803b11:	be 6c 00 00 00       	mov    $0x6c,%esi
  803b16:	48 bf 11 4b 80 00 00 	movabs $0x804b11,%rdi
  803b1d:	00 00 00 
  803b20:	b8 00 00 00 00       	mov    $0x0,%eax
  803b25:	49 b8 19 05 80 00 00 	movabs $0x800519,%r8
  803b2c:	00 00 00 
  803b2f:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803b32:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b35:	48 63 d0             	movslq %eax,%rdx
  803b38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b3c:	48 89 c6             	mov    %rax,%rsi
  803b3f:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803b46:	00 00 00 
  803b49:	48 b8 85 17 80 00 00 	movabs $0x801785,%rax
  803b50:	00 00 00 
  803b53:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803b55:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b5c:	00 00 00 
  803b5f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b62:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803b65:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b6c:	00 00 00 
  803b6f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b72:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803b75:	bf 08 00 00 00       	mov    $0x8,%edi
  803b7a:	48 b8 8f 37 80 00 00 	movabs $0x80378f,%rax
  803b81:	00 00 00 
  803b84:	ff d0                	callq  *%rax
}
  803b86:	c9                   	leaveq 
  803b87:	c3                   	retq   

0000000000803b88 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803b88:	55                   	push   %rbp
  803b89:	48 89 e5             	mov    %rsp,%rbp
  803b8c:	48 83 ec 10          	sub    $0x10,%rsp
  803b90:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b93:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803b96:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803b99:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ba0:	00 00 00 
  803ba3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ba6:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803ba8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803baf:	00 00 00 
  803bb2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bb5:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803bb8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803bbf:	00 00 00 
  803bc2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803bc5:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803bc8:	bf 09 00 00 00       	mov    $0x9,%edi
  803bcd:	48 b8 8f 37 80 00 00 	movabs $0x80378f,%rax
  803bd4:	00 00 00 
  803bd7:	ff d0                	callq  *%rax
}
  803bd9:	c9                   	leaveq 
  803bda:	c3                   	retq   

0000000000803bdb <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803bdb:	55                   	push   %rbp
  803bdc:	48 89 e5             	mov    %rsp,%rbp
  803bdf:	53                   	push   %rbx
  803be0:	48 83 ec 38          	sub    $0x38,%rsp
  803be4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803be8:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803bec:	48 89 c7             	mov    %rax,%rdi
  803bef:	48 b8 15 21 80 00 00 	movabs $0x802115,%rax
  803bf6:	00 00 00 
  803bf9:	ff d0                	callq  *%rax
  803bfb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bfe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c02:	0f 88 bf 01 00 00    	js     803dc7 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c0c:	ba 07 04 00 00       	mov    $0x407,%edx
  803c11:	48 89 c6             	mov    %rax,%rsi
  803c14:	bf 00 00 00 00       	mov    $0x0,%edi
  803c19:	48 b8 90 1d 80 00 00 	movabs $0x801d90,%rax
  803c20:	00 00 00 
  803c23:	ff d0                	callq  *%rax
  803c25:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c28:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c2c:	0f 88 95 01 00 00    	js     803dc7 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803c32:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803c36:	48 89 c7             	mov    %rax,%rdi
  803c39:	48 b8 15 21 80 00 00 	movabs $0x802115,%rax
  803c40:	00 00 00 
  803c43:	ff d0                	callq  *%rax
  803c45:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c48:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c4c:	0f 88 5d 01 00 00    	js     803daf <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c52:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c56:	ba 07 04 00 00       	mov    $0x407,%edx
  803c5b:	48 89 c6             	mov    %rax,%rsi
  803c5e:	bf 00 00 00 00       	mov    $0x0,%edi
  803c63:	48 b8 90 1d 80 00 00 	movabs $0x801d90,%rax
  803c6a:	00 00 00 
  803c6d:	ff d0                	callq  *%rax
  803c6f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c72:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c76:	0f 88 33 01 00 00    	js     803daf <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803c7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c80:	48 89 c7             	mov    %rax,%rdi
  803c83:	48 b8 ea 20 80 00 00 	movabs $0x8020ea,%rax
  803c8a:	00 00 00 
  803c8d:	ff d0                	callq  *%rax
  803c8f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c97:	ba 07 04 00 00       	mov    $0x407,%edx
  803c9c:	48 89 c6             	mov    %rax,%rsi
  803c9f:	bf 00 00 00 00       	mov    $0x0,%edi
  803ca4:	48 b8 90 1d 80 00 00 	movabs $0x801d90,%rax
  803cab:	00 00 00 
  803cae:	ff d0                	callq  *%rax
  803cb0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cb3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cb7:	79 05                	jns    803cbe <pipe+0xe3>
		goto err2;
  803cb9:	e9 d9 00 00 00       	jmpq   803d97 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803cbe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cc2:	48 89 c7             	mov    %rax,%rdi
  803cc5:	48 b8 ea 20 80 00 00 	movabs $0x8020ea,%rax
  803ccc:	00 00 00 
  803ccf:	ff d0                	callq  *%rax
  803cd1:	48 89 c2             	mov    %rax,%rdx
  803cd4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cd8:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803cde:	48 89 d1             	mov    %rdx,%rcx
  803ce1:	ba 00 00 00 00       	mov    $0x0,%edx
  803ce6:	48 89 c6             	mov    %rax,%rsi
  803ce9:	bf 00 00 00 00       	mov    $0x0,%edi
  803cee:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  803cf5:	00 00 00 
  803cf8:	ff d0                	callq  *%rax
  803cfa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cfd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d01:	79 1b                	jns    803d1e <pipe+0x143>
		goto err3;
  803d03:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803d04:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d08:	48 89 c6             	mov    %rax,%rsi
  803d0b:	bf 00 00 00 00       	mov    $0x0,%edi
  803d10:	48 b8 3b 1e 80 00 00 	movabs $0x801e3b,%rax
  803d17:	00 00 00 
  803d1a:	ff d0                	callq  *%rax
  803d1c:	eb 79                	jmp    803d97 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803d1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d22:	48 ba 00 61 80 00 00 	movabs $0x806100,%rdx
  803d29:	00 00 00 
  803d2c:	8b 12                	mov    (%rdx),%edx
  803d2e:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803d30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d34:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803d3b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d3f:	48 ba 00 61 80 00 00 	movabs $0x806100,%rdx
  803d46:	00 00 00 
  803d49:	8b 12                	mov    (%rdx),%edx
  803d4b:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803d4d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d51:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803d58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d5c:	48 89 c7             	mov    %rax,%rdi
  803d5f:	48 b8 c7 20 80 00 00 	movabs $0x8020c7,%rax
  803d66:	00 00 00 
  803d69:	ff d0                	callq  *%rax
  803d6b:	89 c2                	mov    %eax,%edx
  803d6d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803d71:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803d73:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803d77:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803d7b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d7f:	48 89 c7             	mov    %rax,%rdi
  803d82:	48 b8 c7 20 80 00 00 	movabs $0x8020c7,%rax
  803d89:	00 00 00 
  803d8c:	ff d0                	callq  *%rax
  803d8e:	89 03                	mov    %eax,(%rbx)
	return 0;
  803d90:	b8 00 00 00 00       	mov    $0x0,%eax
  803d95:	eb 33                	jmp    803dca <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803d97:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d9b:	48 89 c6             	mov    %rax,%rsi
  803d9e:	bf 00 00 00 00       	mov    $0x0,%edi
  803da3:	48 b8 3b 1e 80 00 00 	movabs $0x801e3b,%rax
  803daa:	00 00 00 
  803dad:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803daf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803db3:	48 89 c6             	mov    %rax,%rsi
  803db6:	bf 00 00 00 00       	mov    $0x0,%edi
  803dbb:	48 b8 3b 1e 80 00 00 	movabs $0x801e3b,%rax
  803dc2:	00 00 00 
  803dc5:	ff d0                	callq  *%rax
err:
	return r;
  803dc7:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803dca:	48 83 c4 38          	add    $0x38,%rsp
  803dce:	5b                   	pop    %rbx
  803dcf:	5d                   	pop    %rbp
  803dd0:	c3                   	retq   

0000000000803dd1 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803dd1:	55                   	push   %rbp
  803dd2:	48 89 e5             	mov    %rsp,%rbp
  803dd5:	53                   	push   %rbx
  803dd6:	48 83 ec 28          	sub    $0x28,%rsp
  803dda:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803dde:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803de2:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803de9:	00 00 00 
  803dec:	48 8b 00             	mov    (%rax),%rax
  803def:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803df5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803df8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dfc:	48 89 c7             	mov    %rax,%rdi
  803dff:	48 b8 8e 43 80 00 00 	movabs $0x80438e,%rax
  803e06:	00 00 00 
  803e09:	ff d0                	callq  *%rax
  803e0b:	89 c3                	mov    %eax,%ebx
  803e0d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e11:	48 89 c7             	mov    %rax,%rdi
  803e14:	48 b8 8e 43 80 00 00 	movabs $0x80438e,%rax
  803e1b:	00 00 00 
  803e1e:	ff d0                	callq  *%rax
  803e20:	39 c3                	cmp    %eax,%ebx
  803e22:	0f 94 c0             	sete   %al
  803e25:	0f b6 c0             	movzbl %al,%eax
  803e28:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803e2b:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803e32:	00 00 00 
  803e35:	48 8b 00             	mov    (%rax),%rax
  803e38:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803e3e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803e41:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e44:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803e47:	75 05                	jne    803e4e <_pipeisclosed+0x7d>
			return ret;
  803e49:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803e4c:	eb 4f                	jmp    803e9d <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803e4e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e51:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803e54:	74 42                	je     803e98 <_pipeisclosed+0xc7>
  803e56:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803e5a:	75 3c                	jne    803e98 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803e5c:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803e63:	00 00 00 
  803e66:	48 8b 00             	mov    (%rax),%rax
  803e69:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803e6f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803e72:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e75:	89 c6                	mov    %eax,%esi
  803e77:	48 bf 2e 4b 80 00 00 	movabs $0x804b2e,%rdi
  803e7e:	00 00 00 
  803e81:	b8 00 00 00 00       	mov    $0x0,%eax
  803e86:	49 b8 52 07 80 00 00 	movabs $0x800752,%r8
  803e8d:	00 00 00 
  803e90:	41 ff d0             	callq  *%r8
	}
  803e93:	e9 4a ff ff ff       	jmpq   803de2 <_pipeisclosed+0x11>
  803e98:	e9 45 ff ff ff       	jmpq   803de2 <_pipeisclosed+0x11>
}
  803e9d:	48 83 c4 28          	add    $0x28,%rsp
  803ea1:	5b                   	pop    %rbx
  803ea2:	5d                   	pop    %rbp
  803ea3:	c3                   	retq   

0000000000803ea4 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803ea4:	55                   	push   %rbp
  803ea5:	48 89 e5             	mov    %rsp,%rbp
  803ea8:	48 83 ec 30          	sub    $0x30,%rsp
  803eac:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803eaf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803eb3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803eb6:	48 89 d6             	mov    %rdx,%rsi
  803eb9:	89 c7                	mov    %eax,%edi
  803ebb:	48 b8 ad 21 80 00 00 	movabs $0x8021ad,%rax
  803ec2:	00 00 00 
  803ec5:	ff d0                	callq  *%rax
  803ec7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ece:	79 05                	jns    803ed5 <pipeisclosed+0x31>
		return r;
  803ed0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ed3:	eb 31                	jmp    803f06 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803ed5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ed9:	48 89 c7             	mov    %rax,%rdi
  803edc:	48 b8 ea 20 80 00 00 	movabs $0x8020ea,%rax
  803ee3:	00 00 00 
  803ee6:	ff d0                	callq  *%rax
  803ee8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803eec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ef0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ef4:	48 89 d6             	mov    %rdx,%rsi
  803ef7:	48 89 c7             	mov    %rax,%rdi
  803efa:	48 b8 d1 3d 80 00 00 	movabs $0x803dd1,%rax
  803f01:	00 00 00 
  803f04:	ff d0                	callq  *%rax
}
  803f06:	c9                   	leaveq 
  803f07:	c3                   	retq   

0000000000803f08 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803f08:	55                   	push   %rbp
  803f09:	48 89 e5             	mov    %rsp,%rbp
  803f0c:	48 83 ec 40          	sub    $0x40,%rsp
  803f10:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f14:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f18:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803f1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f20:	48 89 c7             	mov    %rax,%rdi
  803f23:	48 b8 ea 20 80 00 00 	movabs $0x8020ea,%rax
  803f2a:	00 00 00 
  803f2d:	ff d0                	callq  *%rax
  803f2f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803f33:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f37:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803f3b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803f42:	00 
  803f43:	e9 92 00 00 00       	jmpq   803fda <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803f48:	eb 41                	jmp    803f8b <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803f4a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803f4f:	74 09                	je     803f5a <devpipe_read+0x52>
				return i;
  803f51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f55:	e9 92 00 00 00       	jmpq   803fec <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803f5a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f5e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f62:	48 89 d6             	mov    %rdx,%rsi
  803f65:	48 89 c7             	mov    %rax,%rdi
  803f68:	48 b8 d1 3d 80 00 00 	movabs $0x803dd1,%rax
  803f6f:	00 00 00 
  803f72:	ff d0                	callq  *%rax
  803f74:	85 c0                	test   %eax,%eax
  803f76:	74 07                	je     803f7f <devpipe_read+0x77>
				return 0;
  803f78:	b8 00 00 00 00       	mov    $0x0,%eax
  803f7d:	eb 6d                	jmp    803fec <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803f7f:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  803f86:	00 00 00 
  803f89:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803f8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f8f:	8b 10                	mov    (%rax),%edx
  803f91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f95:	8b 40 04             	mov    0x4(%rax),%eax
  803f98:	39 c2                	cmp    %eax,%edx
  803f9a:	74 ae                	je     803f4a <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803f9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fa0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803fa4:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803fa8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fac:	8b 00                	mov    (%rax),%eax
  803fae:	99                   	cltd   
  803faf:	c1 ea 1b             	shr    $0x1b,%edx
  803fb2:	01 d0                	add    %edx,%eax
  803fb4:	83 e0 1f             	and    $0x1f,%eax
  803fb7:	29 d0                	sub    %edx,%eax
  803fb9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803fbd:	48 98                	cltq   
  803fbf:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803fc4:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803fc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fca:	8b 00                	mov    (%rax),%eax
  803fcc:	8d 50 01             	lea    0x1(%rax),%edx
  803fcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fd3:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803fd5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803fda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fde:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803fe2:	0f 82 60 ff ff ff    	jb     803f48 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803fe8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803fec:	c9                   	leaveq 
  803fed:	c3                   	retq   

0000000000803fee <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803fee:	55                   	push   %rbp
  803fef:	48 89 e5             	mov    %rsp,%rbp
  803ff2:	48 83 ec 40          	sub    $0x40,%rsp
  803ff6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ffa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ffe:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804002:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804006:	48 89 c7             	mov    %rax,%rdi
  804009:	48 b8 ea 20 80 00 00 	movabs $0x8020ea,%rax
  804010:	00 00 00 
  804013:	ff d0                	callq  *%rax
  804015:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804019:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80401d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804021:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804028:	00 
  804029:	e9 8e 00 00 00       	jmpq   8040bc <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80402e:	eb 31                	jmp    804061 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804030:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804034:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804038:	48 89 d6             	mov    %rdx,%rsi
  80403b:	48 89 c7             	mov    %rax,%rdi
  80403e:	48 b8 d1 3d 80 00 00 	movabs $0x803dd1,%rax
  804045:	00 00 00 
  804048:	ff d0                	callq  *%rax
  80404a:	85 c0                	test   %eax,%eax
  80404c:	74 07                	je     804055 <devpipe_write+0x67>
				return 0;
  80404e:	b8 00 00 00 00       	mov    $0x0,%eax
  804053:	eb 79                	jmp    8040ce <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804055:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  80405c:	00 00 00 
  80405f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804061:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804065:	8b 40 04             	mov    0x4(%rax),%eax
  804068:	48 63 d0             	movslq %eax,%rdx
  80406b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80406f:	8b 00                	mov    (%rax),%eax
  804071:	48 98                	cltq   
  804073:	48 83 c0 20          	add    $0x20,%rax
  804077:	48 39 c2             	cmp    %rax,%rdx
  80407a:	73 b4                	jae    804030 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80407c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804080:	8b 40 04             	mov    0x4(%rax),%eax
  804083:	99                   	cltd   
  804084:	c1 ea 1b             	shr    $0x1b,%edx
  804087:	01 d0                	add    %edx,%eax
  804089:	83 e0 1f             	and    $0x1f,%eax
  80408c:	29 d0                	sub    %edx,%eax
  80408e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804092:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804096:	48 01 ca             	add    %rcx,%rdx
  804099:	0f b6 0a             	movzbl (%rdx),%ecx
  80409c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040a0:	48 98                	cltq   
  8040a2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8040a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040aa:	8b 40 04             	mov    0x4(%rax),%eax
  8040ad:	8d 50 01             	lea    0x1(%rax),%edx
  8040b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040b4:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8040b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8040bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040c0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8040c4:	0f 82 64 ff ff ff    	jb     80402e <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8040ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8040ce:	c9                   	leaveq 
  8040cf:	c3                   	retq   

00000000008040d0 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8040d0:	55                   	push   %rbp
  8040d1:	48 89 e5             	mov    %rsp,%rbp
  8040d4:	48 83 ec 20          	sub    $0x20,%rsp
  8040d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8040e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040e4:	48 89 c7             	mov    %rax,%rdi
  8040e7:	48 b8 ea 20 80 00 00 	movabs $0x8020ea,%rax
  8040ee:	00 00 00 
  8040f1:	ff d0                	callq  *%rax
  8040f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8040f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040fb:	48 be 41 4b 80 00 00 	movabs $0x804b41,%rsi
  804102:	00 00 00 
  804105:	48 89 c7             	mov    %rax,%rdi
  804108:	48 b8 61 14 80 00 00 	movabs $0x801461,%rax
  80410f:	00 00 00 
  804112:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804114:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804118:	8b 50 04             	mov    0x4(%rax),%edx
  80411b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80411f:	8b 00                	mov    (%rax),%eax
  804121:	29 c2                	sub    %eax,%edx
  804123:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804127:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80412d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804131:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804138:	00 00 00 
	stat->st_dev = &devpipe;
  80413b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80413f:	48 b9 00 61 80 00 00 	movabs $0x806100,%rcx
  804146:	00 00 00 
  804149:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804150:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804155:	c9                   	leaveq 
  804156:	c3                   	retq   

0000000000804157 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804157:	55                   	push   %rbp
  804158:	48 89 e5             	mov    %rsp,%rbp
  80415b:	48 83 ec 10          	sub    $0x10,%rsp
  80415f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804163:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804167:	48 89 c6             	mov    %rax,%rsi
  80416a:	bf 00 00 00 00       	mov    $0x0,%edi
  80416f:	48 b8 3b 1e 80 00 00 	movabs $0x801e3b,%rax
  804176:	00 00 00 
  804179:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80417b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80417f:	48 89 c7             	mov    %rax,%rdi
  804182:	48 b8 ea 20 80 00 00 	movabs $0x8020ea,%rax
  804189:	00 00 00 
  80418c:	ff d0                	callq  *%rax
  80418e:	48 89 c6             	mov    %rax,%rsi
  804191:	bf 00 00 00 00       	mov    $0x0,%edi
  804196:	48 b8 3b 1e 80 00 00 	movabs $0x801e3b,%rax
  80419d:	00 00 00 
  8041a0:	ff d0                	callq  *%rax
}
  8041a2:	c9                   	leaveq 
  8041a3:	c3                   	retq   

00000000008041a4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8041a4:	55                   	push   %rbp
  8041a5:	48 89 e5             	mov    %rsp,%rbp
  8041a8:	48 83 ec 30          	sub    $0x30,%rsp
  8041ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8041b4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8041b8:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8041bf:	00 00 00 
  8041c2:	48 8b 00             	mov    (%rax),%rax
  8041c5:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8041cb:	85 c0                	test   %eax,%eax
  8041cd:	75 3c                	jne    80420b <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8041cf:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  8041d6:	00 00 00 
  8041d9:	ff d0                	callq  *%rax
  8041db:	25 ff 03 00 00       	and    $0x3ff,%eax
  8041e0:	48 63 d0             	movslq %eax,%rdx
  8041e3:	48 89 d0             	mov    %rdx,%rax
  8041e6:	48 c1 e0 03          	shl    $0x3,%rax
  8041ea:	48 01 d0             	add    %rdx,%rax
  8041ed:	48 c1 e0 05          	shl    $0x5,%rax
  8041f1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8041f8:	00 00 00 
  8041fb:	48 01 c2             	add    %rax,%rdx
  8041fe:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  804205:	00 00 00 
  804208:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  80420b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804210:	75 0e                	jne    804220 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  804212:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804219:	00 00 00 
  80421c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804220:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804224:	48 89 c7             	mov    %rax,%rdi
  804227:	48 b8 b9 1f 80 00 00 	movabs $0x801fb9,%rax
  80422e:	00 00 00 
  804231:	ff d0                	callq  *%rax
  804233:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804236:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80423a:	79 19                	jns    804255 <ipc_recv+0xb1>
		*from_env_store = 0;
  80423c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804240:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  804246:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80424a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  804250:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804253:	eb 53                	jmp    8042a8 <ipc_recv+0x104>
	}
	if(from_env_store)
  804255:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80425a:	74 19                	je     804275 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  80425c:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  804263:	00 00 00 
  804266:	48 8b 00             	mov    (%rax),%rax
  804269:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80426f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804273:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804275:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80427a:	74 19                	je     804295 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  80427c:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  804283:	00 00 00 
  804286:	48 8b 00             	mov    (%rax),%rax
  804289:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80428f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804293:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804295:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  80429c:	00 00 00 
  80429f:	48 8b 00             	mov    (%rax),%rax
  8042a2:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8042a8:	c9                   	leaveq 
  8042a9:	c3                   	retq   

00000000008042aa <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8042aa:	55                   	push   %rbp
  8042ab:	48 89 e5             	mov    %rsp,%rbp
  8042ae:	48 83 ec 30          	sub    $0x30,%rsp
  8042b2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8042b5:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8042b8:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8042bc:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8042bf:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8042c4:	75 0e                	jne    8042d4 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8042c6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8042cd:	00 00 00 
  8042d0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8042d4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8042d7:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8042da:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8042de:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042e1:	89 c7                	mov    %eax,%edi
  8042e3:	48 b8 64 1f 80 00 00 	movabs $0x801f64,%rax
  8042ea:	00 00 00 
  8042ed:	ff d0                	callq  *%rax
  8042ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8042f2:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8042f6:	75 0c                	jne    804304 <ipc_send+0x5a>
			sys_yield();
  8042f8:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  8042ff:	00 00 00 
  804302:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804304:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804308:	74 ca                	je     8042d4 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  80430a:	c9                   	leaveq 
  80430b:	c3                   	retq   

000000000080430c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80430c:	55                   	push   %rbp
  80430d:	48 89 e5             	mov    %rsp,%rbp
  804310:	48 83 ec 14          	sub    $0x14,%rsp
  804314:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804317:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80431e:	eb 5e                	jmp    80437e <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804320:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804327:	00 00 00 
  80432a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80432d:	48 63 d0             	movslq %eax,%rdx
  804330:	48 89 d0             	mov    %rdx,%rax
  804333:	48 c1 e0 03          	shl    $0x3,%rax
  804337:	48 01 d0             	add    %rdx,%rax
  80433a:	48 c1 e0 05          	shl    $0x5,%rax
  80433e:	48 01 c8             	add    %rcx,%rax
  804341:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804347:	8b 00                	mov    (%rax),%eax
  804349:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80434c:	75 2c                	jne    80437a <ipc_find_env+0x6e>
			return envs[i].env_id;
  80434e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804355:	00 00 00 
  804358:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80435b:	48 63 d0             	movslq %eax,%rdx
  80435e:	48 89 d0             	mov    %rdx,%rax
  804361:	48 c1 e0 03          	shl    $0x3,%rax
  804365:	48 01 d0             	add    %rdx,%rax
  804368:	48 c1 e0 05          	shl    $0x5,%rax
  80436c:	48 01 c8             	add    %rcx,%rax
  80436f:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804375:	8b 40 08             	mov    0x8(%rax),%eax
  804378:	eb 12                	jmp    80438c <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80437a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80437e:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804385:	7e 99                	jle    804320 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804387:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80438c:	c9                   	leaveq 
  80438d:	c3                   	retq   

000000000080438e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80438e:	55                   	push   %rbp
  80438f:	48 89 e5             	mov    %rsp,%rbp
  804392:	48 83 ec 18          	sub    $0x18,%rsp
  804396:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80439a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80439e:	48 c1 e8 15          	shr    $0x15,%rax
  8043a2:	48 89 c2             	mov    %rax,%rdx
  8043a5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8043ac:	01 00 00 
  8043af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8043b3:	83 e0 01             	and    $0x1,%eax
  8043b6:	48 85 c0             	test   %rax,%rax
  8043b9:	75 07                	jne    8043c2 <pageref+0x34>
		return 0;
  8043bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8043c0:	eb 53                	jmp    804415 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8043c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043c6:	48 c1 e8 0c          	shr    $0xc,%rax
  8043ca:	48 89 c2             	mov    %rax,%rdx
  8043cd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8043d4:	01 00 00 
  8043d7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8043db:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8043df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043e3:	83 e0 01             	and    $0x1,%eax
  8043e6:	48 85 c0             	test   %rax,%rax
  8043e9:	75 07                	jne    8043f2 <pageref+0x64>
		return 0;
  8043eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8043f0:	eb 23                	jmp    804415 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8043f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043f6:	48 c1 e8 0c          	shr    $0xc,%rax
  8043fa:	48 89 c2             	mov    %rax,%rdx
  8043fd:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804404:	00 00 00 
  804407:	48 c1 e2 04          	shl    $0x4,%rdx
  80440b:	48 01 d0             	add    %rdx,%rax
  80440e:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804412:	0f b7 c0             	movzwl %ax,%eax
}
  804415:	c9                   	leaveq 
  804416:	c3                   	retq   
