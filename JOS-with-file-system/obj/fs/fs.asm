
obj/fs/fs:     file format elf64-x86-64


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
  80003c:	e8 7d 30 00 00       	callq  8030be <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 14          	sub    $0x14,%rsp
  80004b:	89 f8                	mov    %edi,%eax
  80004d:	88 45 ec             	mov    %al,-0x14(%rbp)
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800050:	90                   	nop
  800051:	c7 45 f8 f7 01 00 00 	movl   $0x1f7,-0x8(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800058:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80005b:	89 c2                	mov    %eax,%edx
  80005d:	ec                   	in     (%dx),%al
  80005e:	88 45 f7             	mov    %al,-0x9(%rbp)
	return data;
  800061:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800065:	0f b6 c0             	movzbl %al,%eax
  800068:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80006b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80006e:	25 c0 00 00 00       	and    $0xc0,%eax
  800073:	83 f8 40             	cmp    $0x40,%eax
  800076:	75 d9                	jne    800051 <ide_wait_ready+0xe>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  800078:	80 7d ec 00          	cmpb   $0x0,-0x14(%rbp)
  80007c:	74 11                	je     80008f <ide_wait_ready+0x4c>
  80007e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800081:	83 e0 21             	and    $0x21,%eax
  800084:	85 c0                	test   %eax,%eax
  800086:	74 07                	je     80008f <ide_wait_ready+0x4c>
		return -1;
  800088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80008d:	eb 05                	jmp    800094 <ide_wait_ready+0x51>
	return 0;
  80008f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800094:	c9                   	leaveq 
  800095:	c3                   	retq   

0000000000800096 <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  800096:	55                   	push   %rbp
  800097:	48 89 e5             	mov    %rsp,%rbp
  80009a:	48 83 ec 20          	sub    $0x20,%rsp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  80009e:	bf 00 00 00 00       	mov    $0x0,%edi
  8000a3:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000aa:	00 00 00 
  8000ad:	ff d0                	callq  *%rax
  8000af:	c7 45 f4 f6 01 00 00 	movl   $0x1f6,-0xc(%rbp)
  8000b6:	c6 45 f3 f0          	movb   $0xf0,-0xd(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8000ba:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  8000be:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8000c1:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000c9:	eb 04                	jmp    8000cf <ide_probe_disk1+0x39>
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
	     x++)
  8000cb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000cf:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  8000d6:	7f 26                	jg     8000fe <ide_probe_disk1+0x68>
  8000d8:	c7 45 ec f7 01 00 00 	movl   $0x1f7,-0x14(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  8000df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000e2:	89 c2                	mov    %eax,%edx
  8000e4:	ec                   	in     (%dx),%al
  8000e5:	88 45 eb             	mov    %al,-0x15(%rbp)
	return data;
  8000e8:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  8000ec:	0f b6 c0             	movzbl %al,%eax
  8000ef:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000f5:	25 a1 00 00 00       	and    $0xa1,%eax
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	75 cd                	jne    8000cb <ide_probe_disk1+0x35>
  8000fe:	c7 45 e4 f6 01 00 00 	movl   $0x1f6,-0x1c(%rbp)
  800105:	c6 45 e3 e0          	movb   $0xe0,-0x1d(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800109:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
  80010d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800110:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  800111:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  800118:	0f 9e c0             	setle  %al
  80011b:	0f b6 c0             	movzbl %al,%eax
  80011e:	89 c6                	mov    %eax,%esi
  800120:	48 bf 60 65 80 00 00 	movabs $0x806560,%rdi
  800127:	00 00 00 
  80012a:	b8 00 00 00 00       	mov    $0x0,%eax
  80012f:	48 ba a5 33 80 00 00 	movabs $0x8033a5,%rdx
  800136:	00 00 00 
  800139:	ff d2                	callq  *%rdx
	return (x < 1000);
  80013b:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  800142:	0f 9e c0             	setle  %al
}
  800145:	c9                   	leaveq 
  800146:	c3                   	retq   

0000000000800147 <ide_set_disk>:

void
ide_set_disk(int d)
{
  800147:	55                   	push   %rbp
  800148:	48 89 e5             	mov    %rsp,%rbp
  80014b:	48 83 ec 10          	sub    $0x10,%rsp
  80014f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	if (d != 0 && d != 1)
  800152:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800156:	74 30                	je     800188 <ide_set_disk+0x41>
  800158:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
  80015c:	74 2a                	je     800188 <ide_set_disk+0x41>
		panic("bad disk number");
  80015e:	48 ba 77 65 80 00 00 	movabs $0x806577,%rdx
  800165:	00 00 00 
  800168:	be 3a 00 00 00       	mov    $0x3a,%esi
  80016d:	48 bf 87 65 80 00 00 	movabs $0x806587,%rdi
  800174:	00 00 00 
  800177:	b8 00 00 00 00       	mov    $0x0,%eax
  80017c:	48 b9 6c 31 80 00 00 	movabs $0x80316c,%rcx
  800183:	00 00 00 
  800186:	ff d1                	callq  *%rcx
	diskno = d;
  800188:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80018f:	00 00 00 
  800192:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800195:	89 10                	mov    %edx,(%rax)
}
  800197:	c9                   	leaveq 
  800198:	c3                   	retq   

0000000000800199 <ide_read>:

int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  800199:	55                   	push   %rbp
  80019a:	48 89 e5             	mov    %rsp,%rbp
  80019d:	48 83 ec 70          	sub    $0x70,%rsp
  8001a1:	89 7d ac             	mov    %edi,-0x54(%rbp)
  8001a4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8001a8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
	int r;

	assert(nsecs <= 256);
  8001ac:	48 81 7d 98 00 01 00 	cmpq   $0x100,-0x68(%rbp)
  8001b3:	00 
  8001b4:	76 35                	jbe    8001eb <ide_read+0x52>
  8001b6:	48 b9 90 65 80 00 00 	movabs $0x806590,%rcx
  8001bd:	00 00 00 
  8001c0:	48 ba 9d 65 80 00 00 	movabs $0x80659d,%rdx
  8001c7:	00 00 00 
  8001ca:	be 43 00 00 00       	mov    $0x43,%esi
  8001cf:	48 bf 87 65 80 00 00 	movabs $0x806587,%rdi
  8001d6:	00 00 00 
  8001d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001de:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  8001e5:	00 00 00 
  8001e8:	41 ff d0             	callq  *%r8

	ide_wait_ready(0);
  8001eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001f7:	00 00 00 
  8001fa:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  8001fc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800200:	0f b6 c0             	movzbl %al,%eax
  800203:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%rbp)
  80020a:	88 45 f7             	mov    %al,-0x9(%rbp)
  80020d:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800211:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800214:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  800215:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800218:	0f b6 c0             	movzbl %al,%eax
  80021b:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%rbp)
  800222:	88 45 ef             	mov    %al,-0x11(%rbp)
  800225:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  800229:	8b 55 f0             	mov    -0x10(%rbp),%edx
  80022c:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  80022d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800230:	c1 e8 08             	shr    $0x8,%eax
  800233:	0f b6 c0             	movzbl %al,%eax
  800236:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%rbp)
  80023d:	88 45 e7             	mov    %al,-0x19(%rbp)
  800240:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  800244:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800247:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  800248:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80024b:	c1 e8 10             	shr    $0x10,%eax
  80024e:	0f b6 c0             	movzbl %al,%eax
  800251:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%rbp)
  800258:	88 45 df             	mov    %al,-0x21(%rbp)
  80025b:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  80025f:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800262:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800263:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80026a:	00 00 00 
  80026d:	8b 00                	mov    (%rax),%eax
  80026f:	83 e0 01             	and    $0x1,%eax
  800272:	c1 e0 04             	shl    $0x4,%eax
  800275:	89 c2                	mov    %eax,%edx
  800277:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80027a:	c1 e8 18             	shr    $0x18,%eax
  80027d:	83 e0 0f             	and    $0xf,%eax
  800280:	09 d0                	or     %edx,%eax
  800282:	83 c8 e0             	or     $0xffffffe0,%eax
  800285:	0f b6 c0             	movzbl %al,%eax
  800288:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%rbp)
  80028f:	88 45 d7             	mov    %al,-0x29(%rbp)
  800292:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
  800296:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800299:	ee                   	out    %al,(%dx)
  80029a:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%rbp)
  8002a1:	c6 45 cf 20          	movb   $0x20,-0x31(%rbp)
  8002a5:	0f b6 45 cf          	movzbl -0x31(%rbp),%eax
  8002a9:	8b 55 d0             	mov    -0x30(%rbp),%edx
  8002ac:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8002ad:	eb 63                	jmp    800312 <ide_read+0x179>
		if ((r = ide_wait_ready(1)) < 0)
  8002af:	bf 01 00 00 00       	mov    $0x1,%edi
  8002b4:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
  8002c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8002c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002c7:	79 05                	jns    8002ce <ide_read+0x135>
			return r;
  8002c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002cc:	eb 50                	jmp    80031e <ide_read+0x185>
  8002ce:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%rbp)
  8002d5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8002d9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8002dd:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%rbp)
}

static __inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
  8002e4:	8b 55 c8             	mov    -0x38(%rbp),%edx
  8002e7:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8002eb:	8b 45 bc             	mov    -0x44(%rbp),%eax
  8002ee:	48 89 ce             	mov    %rcx,%rsi
  8002f1:	48 89 f7             	mov    %rsi,%rdi
  8002f4:	89 c1                	mov    %eax,%ecx
  8002f6:	fc                   	cld    
  8002f7:	f2 6d                	repnz insl (%dx),%es:(%rdi)
  8002f9:	89 c8                	mov    %ecx,%eax
  8002fb:	48 89 fe             	mov    %rdi,%rsi
  8002fe:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800302:	89 45 bc             	mov    %eax,-0x44(%rbp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800305:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80030a:	48 81 45 a0 00 02 00 	addq   $0x200,-0x60(%rbp)
  800311:	00 
  800312:	48 83 7d 98 00       	cmpq   $0x0,-0x68(%rbp)
  800317:	75 96                	jne    8002af <ide_read+0x116>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  800319:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80031e:	c9                   	leaveq 
  80031f:	c3                   	retq   

0000000000800320 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  800320:	55                   	push   %rbp
  800321:	48 89 e5             	mov    %rsp,%rbp
  800324:	48 83 ec 70          	sub    $0x70,%rsp
  800328:	89 7d ac             	mov    %edi,-0x54(%rbp)
  80032b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80032f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
	int r;

	assert(nsecs <= 256);
  800333:	48 81 7d 98 00 01 00 	cmpq   $0x100,-0x68(%rbp)
  80033a:	00 
  80033b:	76 35                	jbe    800372 <ide_write+0x52>
  80033d:	48 b9 90 65 80 00 00 	movabs $0x806590,%rcx
  800344:	00 00 00 
  800347:	48 ba 9d 65 80 00 00 	movabs $0x80659d,%rdx
  80034e:	00 00 00 
  800351:	be 5c 00 00 00       	mov    $0x5c,%esi
  800356:	48 bf 87 65 80 00 00 	movabs $0x806587,%rdi
  80035d:	00 00 00 
  800360:	b8 00 00 00 00       	mov    $0x0,%eax
  800365:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  80036c:	00 00 00 
  80036f:	41 ff d0             	callq  *%r8

	ide_wait_ready(0);
  800372:	bf 00 00 00 00       	mov    $0x0,%edi
  800377:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80037e:	00 00 00 
  800381:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  800383:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800387:	0f b6 c0             	movzbl %al,%eax
  80038a:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%rbp)
  800391:	88 45 f7             	mov    %al,-0x9(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800394:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800398:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80039b:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  80039c:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80039f:	0f b6 c0             	movzbl %al,%eax
  8003a2:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%rbp)
  8003a9:	88 45 ef             	mov    %al,-0x11(%rbp)
  8003ac:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8003b0:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8003b3:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  8003b4:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003b7:	c1 e8 08             	shr    $0x8,%eax
  8003ba:	0f b6 c0             	movzbl %al,%eax
  8003bd:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%rbp)
  8003c4:	88 45 e7             	mov    %al,-0x19(%rbp)
  8003c7:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8003cb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8003ce:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8003cf:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003d2:	c1 e8 10             	shr    $0x10,%eax
  8003d5:	0f b6 c0             	movzbl %al,%eax
  8003d8:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%rbp)
  8003df:	88 45 df             	mov    %al,-0x21(%rbp)
  8003e2:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  8003e6:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8003e9:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  8003ea:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8003f1:	00 00 00 
  8003f4:	8b 00                	mov    (%rax),%eax
  8003f6:	83 e0 01             	and    $0x1,%eax
  8003f9:	c1 e0 04             	shl    $0x4,%eax
  8003fc:	89 c2                	mov    %eax,%edx
  8003fe:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800401:	c1 e8 18             	shr    $0x18,%eax
  800404:	83 e0 0f             	and    $0xf,%eax
  800407:	09 d0                	or     %edx,%eax
  800409:	83 c8 e0             	or     $0xffffffe0,%eax
  80040c:	0f b6 c0             	movzbl %al,%eax
  80040f:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%rbp)
  800416:	88 45 d7             	mov    %al,-0x29(%rbp)
  800419:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
  80041d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800420:	ee                   	out    %al,(%dx)
  800421:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%rbp)
  800428:	c6 45 cf 30          	movb   $0x30,-0x31(%rbp)
  80042c:	0f b6 45 cf          	movzbl -0x31(%rbp),%eax
  800430:	8b 55 d0             	mov    -0x30(%rbp),%edx
  800433:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800434:	eb 5d                	jmp    800493 <ide_write+0x173>
		if ((r = ide_wait_ready(1)) < 0)
  800436:	bf 01 00 00 00       	mov    $0x1,%edi
  80043b:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800442:	00 00 00 
  800445:	ff d0                	callq  *%rax
  800447:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80044a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80044e:	79 05                	jns    800455 <ide_write+0x135>
			return r;
  800450:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800453:	eb 4a                	jmp    80049f <ide_write+0x17f>
  800455:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%rbp)
  80045c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800460:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800464:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%rbp)
}

static __inline void
outsl(int port, const void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\toutsl"		:
  80046b:	8b 55 c8             	mov    -0x38(%rbp),%edx
  80046e:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800472:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800475:	48 89 ce             	mov    %rcx,%rsi
  800478:	89 c1                	mov    %eax,%ecx
  80047a:	fc                   	cld    
  80047b:	f2 6f                	repnz outsl %ds:(%rsi),(%dx)
  80047d:	89 c8                	mov    %ecx,%eax
  80047f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800483:	89 45 bc             	mov    %eax,-0x44(%rbp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800486:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80048b:	48 81 45 a0 00 02 00 	addq   $0x200,-0x60(%rbp)
  800492:	00 
  800493:	48 83 7d 98 00       	cmpq   $0x0,-0x68(%rbp)
  800498:	75 9c                	jne    800436 <ide_write+0x116>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  80049a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80049f:	c9                   	leaveq 
  8004a0:	c3                   	retq   

00000000008004a1 <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint64_t blockno)
{
  8004a1:	55                   	push   %rbp
  8004a2:	48 89 e5             	mov    %rsp,%rbp
  8004a5:	48 83 ec 10          	sub    $0x10,%rsp
  8004a9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8004ad:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004b2:	74 2a                	je     8004de <diskaddr+0x3d>
  8004b4:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  8004bb:	00 00 00 
  8004be:	48 8b 00             	mov    (%rax),%rax
  8004c1:	48 85 c0             	test   %rax,%rax
  8004c4:	74 4a                	je     800510 <diskaddr+0x6f>
  8004c6:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  8004cd:	00 00 00 
  8004d0:	48 8b 00             	mov    (%rax),%rax
  8004d3:	8b 40 04             	mov    0x4(%rax),%eax
  8004d6:	89 c0                	mov    %eax,%eax
  8004d8:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8004dc:	77 32                	ja     800510 <diskaddr+0x6f>
		panic("bad block number %08x in diskaddr", blockno);
  8004de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004e2:	48 89 c1             	mov    %rax,%rcx
  8004e5:	48 ba b8 65 80 00 00 	movabs $0x8065b8,%rdx
  8004ec:	00 00 00 
  8004ef:	be 09 00 00 00       	mov    $0x9,%esi
  8004f4:	48 bf da 65 80 00 00 	movabs $0x8065da,%rdi
  8004fb:	00 00 00 
  8004fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800503:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  80050a:	00 00 00 
  80050d:	41 ff d0             	callq  *%r8
	return (char*) (DISKMAP + blockno * BLKSIZE);
  800510:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800514:	48 05 00 00 01 00    	add    $0x10000,%rax
  80051a:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80051e:	c9                   	leaveq 
  80051f:	c3                   	retq   

0000000000800520 <va_is_mapped>:

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  800520:	55                   	push   %rbp
  800521:	48 89 e5             	mov    %rsp,%rbp
  800524:	48 83 ec 08          	sub    $0x8,%rsp
  800528:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpml4e[VPML4E(va)] & PTE_P) && (uvpde[VPDPE(va)] & PTE_P) && (uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  80052c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800530:	48 c1 e8 27          	shr    $0x27,%rax
  800534:	48 89 c2             	mov    %rax,%rdx
  800537:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80053e:	01 00 00 
  800541:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800545:	83 e0 01             	and    $0x1,%eax
  800548:	48 85 c0             	test   %rax,%rax
  80054b:	74 6a                	je     8005b7 <va_is_mapped+0x97>
  80054d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800551:	48 c1 e8 1e          	shr    $0x1e,%rax
  800555:	48 89 c2             	mov    %rax,%rdx
  800558:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80055f:	01 00 00 
  800562:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800566:	83 e0 01             	and    $0x1,%eax
  800569:	48 85 c0             	test   %rax,%rax
  80056c:	74 49                	je     8005b7 <va_is_mapped+0x97>
  80056e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800572:	48 c1 e8 15          	shr    $0x15,%rax
  800576:	48 89 c2             	mov    %rax,%rdx
  800579:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800580:	01 00 00 
  800583:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800587:	83 e0 01             	and    $0x1,%eax
  80058a:	48 85 c0             	test   %rax,%rax
  80058d:	74 28                	je     8005b7 <va_is_mapped+0x97>
  80058f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800593:	48 c1 e8 0c          	shr    $0xc,%rax
  800597:	48 89 c2             	mov    %rax,%rdx
  80059a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005a1:	01 00 00 
  8005a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005a8:	83 e0 01             	and    $0x1,%eax
  8005ab:	48 85 c0             	test   %rax,%rax
  8005ae:	74 07                	je     8005b7 <va_is_mapped+0x97>
  8005b0:	b8 01 00 00 00       	mov    $0x1,%eax
  8005b5:	eb 05                	jmp    8005bc <va_is_mapped+0x9c>
  8005b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8005bc:	83 e0 01             	and    $0x1,%eax
}
  8005bf:	c9                   	leaveq 
  8005c0:	c3                   	retq   

00000000008005c1 <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  8005c1:	55                   	push   %rbp
  8005c2:	48 89 e5             	mov    %rsp,%rbp
  8005c5:	48 83 ec 08          	sub    $0x8,%rsp
  8005c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  8005cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005d1:	48 c1 e8 0c          	shr    $0xc,%rax
  8005d5:	48 89 c2             	mov    %rax,%rdx
  8005d8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005df:	01 00 00 
  8005e2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005e6:	83 e0 40             	and    $0x40,%eax
  8005e9:	48 85 c0             	test   %rax,%rax
  8005ec:	0f 95 c0             	setne  %al
}
  8005ef:	c9                   	leaveq 
  8005f0:	c3                   	retq   

00000000008005f1 <bc_pgfault>:
// Fault any disk block that is read in to memory by
// loading it from disk.
// Hint: Use ide_read and BLKSECTS.
static void
bc_pgfault(struct UTrapframe *utf)
	{
  8005f1:	55                   	push   %rbp
  8005f2:	48 89 e5             	mov    %rsp,%rbp
  8005f5:	48 83 ec 30          	sub    $0x30,%rsp
  8005f9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
		void *addr = (void *) utf->utf_fault_va;
  8005fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800601:	48 8b 00             	mov    (%rax),%rax
  800604:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  800608:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80060c:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  800612:	48 c1 e8 0c          	shr    $0xc,%rax
  800616:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		int r;
	
		// Check that the fault was within the block cache region
		if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80061a:	48 81 7d f8 ff ff ff 	cmpq   $0xfffffff,-0x8(%rbp)
  800621:	0f 
  800622:	76 0b                	jbe    80062f <bc_pgfault+0x3e>
  800624:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  800629:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80062d:	76 4b                	jbe    80067a <bc_pgfault+0x89>
			panic("page fault in FS: eip %08x, va %08x, err %04x",
  80062f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800633:	48 8b 48 08          	mov    0x8(%rax),%rcx
  800637:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80063b:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  800642:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800646:	49 89 c9             	mov    %rcx,%r9
  800649:	49 89 d0             	mov    %rdx,%r8
  80064c:	48 89 c1             	mov    %rax,%rcx
  80064f:	48 ba e8 65 80 00 00 	movabs $0x8065e8,%rdx
  800656:	00 00 00 
  800659:	be 28 00 00 00       	mov    $0x28,%esi
  80065e:	48 bf da 65 80 00 00 	movabs $0x8065da,%rdi
  800665:	00 00 00 
  800668:	b8 00 00 00 00       	mov    $0x0,%eax
  80066d:	49 ba 6c 31 80 00 00 	movabs $0x80316c,%r10
  800674:	00 00 00 
  800677:	41 ff d2             	callq  *%r10
				  utf->utf_rip, addr, utf->utf_err);
	
		// Sanity check the block number.
		if (super && blockno >= super->s_nblocks)
  80067a:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800681:	00 00 00 
  800684:	48 8b 00             	mov    (%rax),%rax
  800687:	48 85 c0             	test   %rax,%rax
  80068a:	74 4a                	je     8006d6 <bc_pgfault+0xe5>
  80068c:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800693:	00 00 00 
  800696:	48 8b 00             	mov    (%rax),%rax
  800699:	8b 40 04             	mov    0x4(%rax),%eax
  80069c:	89 c0                	mov    %eax,%eax
  80069e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8006a2:	77 32                	ja     8006d6 <bc_pgfault+0xe5>
			panic("reading non-existent block %08x\n", blockno);
  8006a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006a8:	48 89 c1             	mov    %rax,%rcx
  8006ab:	48 ba 18 66 80 00 00 	movabs $0x806618,%rdx
  8006b2:	00 00 00 
  8006b5:	be 2c 00 00 00       	mov    $0x2c,%esi
  8006ba:	48 bf da 65 80 00 00 	movabs $0x8065da,%rdi
  8006c1:	00 00 00 
  8006c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c9:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  8006d0:	00 00 00 
  8006d3:	41 ff d0             	callq  *%r8
		// Allocate a page in the disk map region, read the contents
		// of the block from the disk into that page.
		// Hint: first round addr to page boundary.
		//
		// LAB 5: your code here:
		addr = ROUNDDOWN(addr, PGSIZE);
  8006d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006da:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8006de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e2:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8006e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		if(0 != sys_page_alloc(0, (void*)addr, PTE_SYSCALL)){
  8006ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006f0:	ba 07 0e 00 00       	mov    $0xe07,%edx
  8006f5:	48 89 c6             	mov    %rax,%rsi
  8006f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8006fd:	48 b8 89 48 80 00 00 	movabs $0x804889,%rax
  800704:	00 00 00 
  800707:	ff d0                	callq  *%rax
  800709:	85 c0                	test   %eax,%eax
  80070b:	74 2a                	je     800737 <bc_pgfault+0x146>
			panic("Page Allocation Failed during handling page fault in FS");
  80070d:	48 ba 40 66 80 00 00 	movabs $0x806640,%rdx
  800714:	00 00 00 
  800717:	be 35 00 00 00       	mov    $0x35,%esi
  80071c:	48 bf da 65 80 00 00 	movabs $0x8065da,%rdi
  800723:	00 00 00 
  800726:	b8 00 00 00 00       	mov    $0x0,%eax
  80072b:	48 b9 6c 31 80 00 00 	movabs $0x80316c,%rcx
  800732:	00 00 00 
  800735:	ff d1                	callq  *%rcx
		}
		
		if(0 != ide_read((uint32_t) (blockno * BLKSECTS), (void*)addr, BLKSECTS))
  800737:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80073b:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
  800742:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800746:	ba 08 00 00 00       	mov    $0x8,%edx
  80074b:	48 89 c6             	mov    %rax,%rsi
  80074e:	89 cf                	mov    %ecx,%edi
  800750:	48 b8 99 01 80 00 00 	movabs $0x800199,%rax
  800757:	00 00 00 
  80075a:	ff d0                	callq  *%rax
  80075c:	85 c0                	test   %eax,%eax
  80075e:	74 2a                	je     80078a <bc_pgfault+0x199>
		{
			panic("ide read failed in Page Fault Handling");		
  800760:	48 ba 78 66 80 00 00 	movabs $0x806678,%rdx
  800767:	00 00 00 
  80076a:	be 3a 00 00 00       	mov    $0x3a,%esi
  80076f:	48 bf da 65 80 00 00 	movabs $0x8065da,%rdi
  800776:	00 00 00 
  800779:	b8 00 00 00 00       	mov    $0x0,%eax
  80077e:	48 b9 6c 31 80 00 00 	movabs $0x80316c,%rcx
  800785:	00 00 00 
  800788:	ff d1                	callq  *%rcx
		}
	
		if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  80078a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80078e:	48 c1 e8 0c          	shr    $0xc,%rax
  800792:	48 89 c2             	mov    %rax,%rdx
  800795:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80079c:	01 00 00 
  80079f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007a3:	25 07 0e 00 00       	and    $0xe07,%eax
  8007a8:	89 c1                	mov    %eax,%ecx
  8007aa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8007ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007b2:	41 89 c8             	mov    %ecx,%r8d
  8007b5:	48 89 d1             	mov    %rdx,%rcx
  8007b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007bd:	48 89 c6             	mov    %rax,%rsi
  8007c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8007c5:	48 b8 d9 48 80 00 00 	movabs $0x8048d9,%rax
  8007cc:	00 00 00 
  8007cf:	ff d0                	callq  *%rax
  8007d1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8007d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007d8:	79 30                	jns    80080a <bc_pgfault+0x219>
			panic("in bc_pgfault, sys_page_map: %e", r);
  8007da:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8007dd:	89 c1                	mov    %eax,%ecx
  8007df:	48 ba a0 66 80 00 00 	movabs $0x8066a0,%rdx
  8007e6:	00 00 00 
  8007e9:	be 3e 00 00 00       	mov    $0x3e,%esi
  8007ee:	48 bf da 65 80 00 00 	movabs $0x8065da,%rdi
  8007f5:	00 00 00 
  8007f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fd:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  800804:	00 00 00 
  800807:	41 ff d0             	callq  *%r8
	
		// Check that the block we read was allocated. (exercise for
		// the reader: why do we do this *after* reading the block
		// in?)
		if (bitmap && block_is_free(blockno))
  80080a:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800811:	00 00 00 
  800814:	48 8b 00             	mov    (%rax),%rax
  800817:	48 85 c0             	test   %rax,%rax
  80081a:	74 48                	je     800864 <bc_pgfault+0x273>
  80081c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800820:	89 c7                	mov    %eax,%edi
  800822:	48 b8 5e 0d 80 00 00 	movabs $0x800d5e,%rax
  800829:	00 00 00 
  80082c:	ff d0                	callq  *%rax
  80082e:	84 c0                	test   %al,%al
  800830:	74 32                	je     800864 <bc_pgfault+0x273>
			panic("reading free block %08x\n", blockno);
  800832:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800836:	48 89 c1             	mov    %rax,%rcx
  800839:	48 ba c0 66 80 00 00 	movabs $0x8066c0,%rdx
  800840:	00 00 00 
  800843:	be 44 00 00 00       	mov    $0x44,%esi
  800848:	48 bf da 65 80 00 00 	movabs $0x8065da,%rdi
  80084f:	00 00 00 
  800852:	b8 00 00 00 00       	mov    $0x0,%eax
  800857:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  80085e:	00 00 00 
  800861:	41 ff d0             	callq  *%r8
	}
  800864:	c9                   	leaveq 
  800865:	c3                   	retq   

0000000000800866 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
	{
  800866:	55                   	push   %rbp
  800867:	48 89 e5             	mov    %rsp,%rbp
  80086a:	48 83 ec 30          	sub    $0x30,%rsp
  80086e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
		uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  800872:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800876:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  80087c:	48 c1 e8 0c          	shr    $0xc,%rax
  800880:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		int r;
		
		if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800884:	48 81 7d d8 ff ff ff 	cmpq   $0xfffffff,-0x28(%rbp)
  80088b:	0f 
  80088c:	76 0b                	jbe    800899 <flush_block+0x33>
  80088e:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  800893:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  800897:	76 32                	jbe    8008cb <flush_block+0x65>
			panic("flush_block of bad va %08x", addr);
  800899:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80089d:	48 89 c1             	mov    %rax,%rcx
  8008a0:	48 ba d9 66 80 00 00 	movabs $0x8066d9,%rdx
  8008a7:	00 00 00 
  8008aa:	be 56 00 00 00       	mov    $0x56,%esi
  8008af:	48 bf da 65 80 00 00 	movabs $0x8065da,%rdi
  8008b6:	00 00 00 
  8008b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008be:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  8008c5:	00 00 00 
  8008c8:	41 ff d0             	callq  *%r8
	
		// LAB 5: Your code here.
		//panic("flush_block not implemented");
		if(va_is_mapped(addr) == false || va_is_dirty(addr) == false)
  8008cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008cf:	48 89 c7             	mov    %rax,%rdi
  8008d2:	48 b8 20 05 80 00 00 	movabs $0x800520,%rax
  8008d9:	00 00 00 
  8008dc:	ff d0                	callq  *%rax
  8008de:	83 f0 01             	xor    $0x1,%eax
  8008e1:	84 c0                	test   %al,%al
  8008e3:	75 1a                	jne    8008ff <flush_block+0x99>
  8008e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008e9:	48 89 c7             	mov    %rax,%rdi
  8008ec:	48 b8 c1 05 80 00 00 	movabs $0x8005c1,%rax
  8008f3:	00 00 00 
  8008f6:	ff d0                	callq  *%rax
  8008f8:	83 f0 01             	xor    $0x1,%eax
  8008fb:	84 c0                	test   %al,%al
  8008fd:	74 05                	je     800904 <flush_block+0x9e>
		{
			return;
  8008ff:	e9 cc 00 00 00       	jmpq   8009d0 <flush_block+0x16a>
		}
		addr = ROUNDDOWN(addr, PGSIZE);
  800904:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800908:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  80090c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800910:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  800916:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
		if(0 != ide_write((uint32_t) (blockno * BLKSECTS), (void*)addr, BLKSECTS))
  80091a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80091e:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
  800925:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800929:	ba 08 00 00 00       	mov    $0x8,%edx
  80092e:	48 89 c6             	mov    %rax,%rsi
  800931:	89 cf                	mov    %ecx,%edi
  800933:	48 b8 20 03 80 00 00 	movabs $0x800320,%rax
  80093a:	00 00 00 
  80093d:	ff d0                	callq  *%rax
  80093f:	85 c0                	test   %eax,%eax
  800941:	74 2a                	je     80096d <flush_block+0x107>
		{
			panic("ide write failed in Flush Block");	
  800943:	48 ba f8 66 80 00 00 	movabs $0x8066f8,%rdx
  80094a:	00 00 00 
  80094d:	be 61 00 00 00       	mov    $0x61,%esi
  800952:	48 bf da 65 80 00 00 	movabs $0x8065da,%rdi
  800959:	00 00 00 
  80095c:	b8 00 00 00 00       	mov    $0x0,%eax
  800961:	48 b9 6c 31 80 00 00 	movabs $0x80316c,%rcx
  800968:	00 00 00 
  80096b:	ff d1                	callq  *%rcx
		}
	
		if ((r = sys_page_map(0, addr, 0, addr, PTE_SYSCALL)) < 0)
  80096d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800971:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800975:	41 b8 07 0e 00 00    	mov    $0xe07,%r8d
  80097b:	48 89 d1             	mov    %rdx,%rcx
  80097e:	ba 00 00 00 00       	mov    $0x0,%edx
  800983:	48 89 c6             	mov    %rax,%rsi
  800986:	bf 00 00 00 00       	mov    $0x0,%edi
  80098b:	48 b8 d9 48 80 00 00 	movabs $0x8048d9,%rax
  800992:	00 00 00 
  800995:	ff d0                	callq  *%rax
  800997:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80099a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80099e:	79 30                	jns    8009d0 <flush_block+0x16a>
		{
			panic("in flush_block, sys_page_map: %e", r);
  8009a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8009a3:	89 c1                	mov    %eax,%ecx
  8009a5:	48 ba 18 67 80 00 00 	movabs $0x806718,%rdx
  8009ac:	00 00 00 
  8009af:	be 66 00 00 00       	mov    $0x66,%esi
  8009b4:	48 bf da 65 80 00 00 	movabs $0x8065da,%rdi
  8009bb:	00 00 00 
  8009be:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c3:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  8009ca:	00 00 00 
  8009cd:	41 ff d0             	callq  *%r8
		}
	}
  8009d0:	c9                   	leaveq 
  8009d1:	c3                   	retq   

00000000008009d2 <check_bc>:

// Test that the block cache works, by smashing the superblock and
// reading it back.
static void
check_bc(void)
{
  8009d2:	55                   	push   %rbp
  8009d3:	48 89 e5             	mov    %rsp,%rbp
  8009d6:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super backup;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  8009dd:	bf 01 00 00 00       	mov    $0x1,%edi
  8009e2:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  8009e9:	00 00 00 
  8009ec:	ff d0                	callq  *%rax
  8009ee:	48 89 c1             	mov    %rax,%rcx
  8009f1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8009f8:	ba 08 01 00 00       	mov    $0x108,%edx
  8009fd:	48 89 ce             	mov    %rcx,%rsi
  800a00:	48 89 c7             	mov    %rax,%rdi
  800a03:	48 b8 7e 42 80 00 00 	movabs $0x80427e,%rax
  800a0a:	00 00 00 
  800a0d:	ff d0                	callq  *%rax

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  800a0f:	bf 01 00 00 00       	mov    $0x1,%edi
  800a14:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  800a1b:	00 00 00 
  800a1e:	ff d0                	callq  *%rax
  800a20:	48 be 39 67 80 00 00 	movabs $0x806739,%rsi
  800a27:	00 00 00 
  800a2a:	48 89 c7             	mov    %rax,%rdi
  800a2d:	48 b8 5a 3f 80 00 00 	movabs $0x803f5a,%rax
  800a34:	00 00 00 
  800a37:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800a39:	bf 01 00 00 00       	mov    $0x1,%edi
  800a3e:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  800a45:	00 00 00 
  800a48:	ff d0                	callq  *%rax
  800a4a:	48 89 c7             	mov    %rax,%rdi
  800a4d:	48 b8 66 08 80 00 00 	movabs $0x800866,%rax
  800a54:	00 00 00 
  800a57:	ff d0                	callq  *%rax
	assert(va_is_mapped(diskaddr(1)));
  800a59:	bf 01 00 00 00       	mov    $0x1,%edi
  800a5e:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  800a65:	00 00 00 
  800a68:	ff d0                	callq  *%rax
  800a6a:	48 89 c7             	mov    %rax,%rdi
  800a6d:	48 b8 20 05 80 00 00 	movabs $0x800520,%rax
  800a74:	00 00 00 
  800a77:	ff d0                	callq  *%rax
  800a79:	83 f0 01             	xor    $0x1,%eax
  800a7c:	84 c0                	test   %al,%al
  800a7e:	74 35                	je     800ab5 <check_bc+0xe3>
  800a80:	48 b9 40 67 80 00 00 	movabs $0x806740,%rcx
  800a87:	00 00 00 
  800a8a:	48 ba 5a 67 80 00 00 	movabs $0x80675a,%rdx
  800a91:	00 00 00 
  800a94:	be 78 00 00 00       	mov    $0x78,%esi
  800a99:	48 bf da 65 80 00 00 	movabs $0x8065da,%rdi
  800aa0:	00 00 00 
  800aa3:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa8:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  800aaf:	00 00 00 
  800ab2:	41 ff d0             	callq  *%r8
	assert(!va_is_dirty(diskaddr(1)));
  800ab5:	bf 01 00 00 00       	mov    $0x1,%edi
  800aba:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  800ac1:	00 00 00 
  800ac4:	ff d0                	callq  *%rax
  800ac6:	48 89 c7             	mov    %rax,%rdi
  800ac9:	48 b8 c1 05 80 00 00 	movabs $0x8005c1,%rax
  800ad0:	00 00 00 
  800ad3:	ff d0                	callq  *%rax
  800ad5:	84 c0                	test   %al,%al
  800ad7:	74 35                	je     800b0e <check_bc+0x13c>
  800ad9:	48 b9 6f 67 80 00 00 	movabs $0x80676f,%rcx
  800ae0:	00 00 00 
  800ae3:	48 ba 5a 67 80 00 00 	movabs $0x80675a,%rdx
  800aea:	00 00 00 
  800aed:	be 79 00 00 00       	mov    $0x79,%esi
  800af2:	48 bf da 65 80 00 00 	movabs $0x8065da,%rdi
  800af9:	00 00 00 
  800afc:	b8 00 00 00 00       	mov    $0x0,%eax
  800b01:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  800b08:	00 00 00 
  800b0b:	41 ff d0             	callq  *%r8

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  800b0e:	bf 01 00 00 00       	mov    $0x1,%edi
  800b13:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  800b1a:	00 00 00 
  800b1d:	ff d0                	callq  *%rax
  800b1f:	48 89 c6             	mov    %rax,%rsi
  800b22:	bf 00 00 00 00       	mov    $0x0,%edi
  800b27:	48 b8 34 49 80 00 00 	movabs $0x804934,%rax
  800b2e:	00 00 00 
  800b31:	ff d0                	callq  *%rax
	assert(!va_is_mapped(diskaddr(1)));
  800b33:	bf 01 00 00 00       	mov    $0x1,%edi
  800b38:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  800b3f:	00 00 00 
  800b42:	ff d0                	callq  *%rax
  800b44:	48 89 c7             	mov    %rax,%rdi
  800b47:	48 b8 20 05 80 00 00 	movabs $0x800520,%rax
  800b4e:	00 00 00 
  800b51:	ff d0                	callq  *%rax
  800b53:	84 c0                	test   %al,%al
  800b55:	74 35                	je     800b8c <check_bc+0x1ba>
  800b57:	48 b9 89 67 80 00 00 	movabs $0x806789,%rcx
  800b5e:	00 00 00 
  800b61:	48 ba 5a 67 80 00 00 	movabs $0x80675a,%rdx
  800b68:	00 00 00 
  800b6b:	be 7d 00 00 00       	mov    $0x7d,%esi
  800b70:	48 bf da 65 80 00 00 	movabs $0x8065da,%rdi
  800b77:	00 00 00 
  800b7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7f:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  800b86:	00 00 00 
  800b89:	41 ff d0             	callq  *%r8

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800b8c:	bf 01 00 00 00       	mov    $0x1,%edi
  800b91:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  800b98:	00 00 00 
  800b9b:	ff d0                	callq  *%rax
  800b9d:	48 be 39 67 80 00 00 	movabs $0x806739,%rsi
  800ba4:	00 00 00 
  800ba7:	48 89 c7             	mov    %rax,%rdi
  800baa:	48 b8 bc 40 80 00 00 	movabs $0x8040bc,%rax
  800bb1:	00 00 00 
  800bb4:	ff d0                	callq  *%rax
  800bb6:	85 c0                	test   %eax,%eax
  800bb8:	74 35                	je     800bef <check_bc+0x21d>
  800bba:	48 b9 a8 67 80 00 00 	movabs $0x8067a8,%rcx
  800bc1:	00 00 00 
  800bc4:	48 ba 5a 67 80 00 00 	movabs $0x80675a,%rdx
  800bcb:	00 00 00 
  800bce:	be 80 00 00 00       	mov    $0x80,%esi
  800bd3:	48 bf da 65 80 00 00 	movabs $0x8065da,%rdi
  800bda:	00 00 00 
  800bdd:	b8 00 00 00 00       	mov    $0x0,%eax
  800be2:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  800be9:	00 00 00 
  800bec:	41 ff d0             	callq  *%r8

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  800bef:	bf 01 00 00 00       	mov    $0x1,%edi
  800bf4:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  800bfb:	00 00 00 
  800bfe:	ff d0                	callq  *%rax
  800c00:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  800c07:	ba 08 01 00 00       	mov    $0x108,%edx
  800c0c:	48 89 ce             	mov    %rcx,%rsi
  800c0f:	48 89 c7             	mov    %rax,%rdi
  800c12:	48 b8 7e 42 80 00 00 	movabs $0x80427e,%rax
  800c19:	00 00 00 
  800c1c:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800c1e:	bf 01 00 00 00       	mov    $0x1,%edi
  800c23:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  800c2a:	00 00 00 
  800c2d:	ff d0                	callq  *%rax
  800c2f:	48 89 c7             	mov    %rax,%rdi
  800c32:	48 b8 66 08 80 00 00 	movabs $0x800866,%rax
  800c39:	00 00 00 
  800c3c:	ff d0                	callq  *%rax

	cprintf("block cache is good\n");
  800c3e:	48 bf cc 67 80 00 00 	movabs $0x8067cc,%rdi
  800c45:	00 00 00 
  800c48:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4d:	48 ba a5 33 80 00 00 	movabs $0x8033a5,%rdx
  800c54:	00 00 00 
  800c57:	ff d2                	callq  *%rdx
}
  800c59:	c9                   	leaveq 
  800c5a:	c3                   	retq   

0000000000800c5b <bc_init>:

void
bc_init(void)
{
  800c5b:	55                   	push   %rbp
  800c5c:	48 89 e5             	mov    %rsp,%rbp
  800c5f:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  800c66:	48 bf f1 05 80 00 00 	movabs $0x8005f1,%rdi
  800c6d:	00 00 00 
  800c70:	48 b8 f6 4a 80 00 00 	movabs $0x804af6,%rax
  800c77:	00 00 00 
  800c7a:	ff d0                	callq  *%rax
	check_bc();
  800c7c:	48 b8 d2 09 80 00 00 	movabs $0x8009d2,%rax
  800c83:	00 00 00 
  800c86:	ff d0                	callq  *%rax

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800c88:	bf 01 00 00 00       	mov    $0x1,%edi
  800c8d:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  800c94:	00 00 00 
  800c97:	ff d0                	callq  *%rax
  800c99:	48 89 c1             	mov    %rax,%rcx
  800c9c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800ca3:	ba 08 01 00 00       	mov    $0x108,%edx
  800ca8:	48 89 ce             	mov    %rcx,%rsi
  800cab:	48 89 c7             	mov    %rax,%rdi
  800cae:	48 b8 7e 42 80 00 00 	movabs $0x80427e,%rax
  800cb5:	00 00 00 
  800cb8:	ff d0                	callq  *%rax
}
  800cba:	c9                   	leaveq 
  800cbb:	c3                   	retq   

0000000000800cbc <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  800cbc:	55                   	push   %rbp
  800cbd:	48 89 e5             	mov    %rsp,%rbp
	if (super->s_magic != FS_MAGIC)
  800cc0:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800cc7:	00 00 00 
  800cca:	48 8b 00             	mov    (%rax),%rax
  800ccd:	8b 00                	mov    (%rax),%eax
  800ccf:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  800cd4:	74 2a                	je     800d00 <check_super+0x44>
		panic("bad file system magic number");
  800cd6:	48 ba e1 67 80 00 00 	movabs $0x8067e1,%rdx
  800cdd:	00 00 00 
  800ce0:	be 0e 00 00 00       	mov    $0xe,%esi
  800ce5:	48 bf fe 67 80 00 00 	movabs $0x8067fe,%rdi
  800cec:	00 00 00 
  800cef:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf4:	48 b9 6c 31 80 00 00 	movabs $0x80316c,%rcx
  800cfb:	00 00 00 
  800cfe:	ff d1                	callq  *%rcx

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800d00:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800d07:	00 00 00 
  800d0a:	48 8b 00             	mov    (%rax),%rax
  800d0d:	8b 40 04             	mov    0x4(%rax),%eax
  800d10:	3d 00 00 0c 00       	cmp    $0xc0000,%eax
  800d15:	76 2a                	jbe    800d41 <check_super+0x85>
		panic("file system is too large");
  800d17:	48 ba 06 68 80 00 00 	movabs $0x806806,%rdx
  800d1e:	00 00 00 
  800d21:	be 11 00 00 00       	mov    $0x11,%esi
  800d26:	48 bf fe 67 80 00 00 	movabs $0x8067fe,%rdi
  800d2d:	00 00 00 
  800d30:	b8 00 00 00 00       	mov    $0x0,%eax
  800d35:	48 b9 6c 31 80 00 00 	movabs $0x80316c,%rcx
  800d3c:	00 00 00 
  800d3f:	ff d1                	callq  *%rcx

	cprintf("superblock is good\n");
  800d41:	48 bf 1f 68 80 00 00 	movabs $0x80681f,%rdi
  800d48:	00 00 00 
  800d4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d50:	48 ba a5 33 80 00 00 	movabs $0x8033a5,%rdx
  800d57:	00 00 00 
  800d5a:	ff d2                	callq  *%rdx
}
  800d5c:	5d                   	pop    %rbp
  800d5d:	c3                   	retq   

0000000000800d5e <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  800d5e:	55                   	push   %rbp
  800d5f:	48 89 e5             	mov    %rsp,%rbp
  800d62:	48 83 ec 04          	sub    $0x4,%rsp
  800d66:	89 7d fc             	mov    %edi,-0x4(%rbp)
	if (super == 0 || blockno >= super->s_nblocks)
  800d69:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800d70:	00 00 00 
  800d73:	48 8b 00             	mov    (%rax),%rax
  800d76:	48 85 c0             	test   %rax,%rax
  800d79:	74 15                	je     800d90 <block_is_free+0x32>
  800d7b:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800d82:	00 00 00 
  800d85:	48 8b 00             	mov    (%rax),%rax
  800d88:	8b 40 04             	mov    0x4(%rax),%eax
  800d8b:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800d8e:	77 07                	ja     800d97 <block_is_free+0x39>
		return 0;
  800d90:	b8 00 00 00 00       	mov    $0x0,%eax
  800d95:	eb 41                	jmp    800dd8 <block_is_free+0x7a>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  800d97:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800d9e:	00 00 00 
  800da1:	48 8b 00             	mov    (%rax),%rax
  800da4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800da7:	c1 ea 05             	shr    $0x5,%edx
  800daa:	89 d2                	mov    %edx,%edx
  800dac:	48 c1 e2 02          	shl    $0x2,%rdx
  800db0:	48 01 d0             	add    %rdx,%rax
  800db3:	8b 10                	mov    (%rax),%edx
  800db5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800db8:	83 e0 1f             	and    $0x1f,%eax
  800dbb:	be 01 00 00 00       	mov    $0x1,%esi
  800dc0:	89 c1                	mov    %eax,%ecx
  800dc2:	d3 e6                	shl    %cl,%esi
  800dc4:	89 f0                	mov    %esi,%eax
  800dc6:	21 d0                	and    %edx,%eax
  800dc8:	85 c0                	test   %eax,%eax
  800dca:	74 07                	je     800dd3 <block_is_free+0x75>
		return 1;
  800dcc:	b8 01 00 00 00       	mov    $0x1,%eax
  800dd1:	eb 05                	jmp    800dd8 <block_is_free+0x7a>
	return 0;
  800dd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dd8:	c9                   	leaveq 
  800dd9:	c3                   	retq   

0000000000800dda <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800dda:	55                   	push   %rbp
  800ddb:	48 89 e5             	mov    %rsp,%rbp
  800dde:	48 83 ec 10          	sub    $0x10,%rsp
  800de2:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  800de5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800de9:	75 2a                	jne    800e15 <free_block+0x3b>
		panic("attempt to free zero block");
  800deb:	48 ba 33 68 80 00 00 	movabs $0x806833,%rdx
  800df2:	00 00 00 
  800df5:	be 2c 00 00 00       	mov    $0x2c,%esi
  800dfa:	48 bf fe 67 80 00 00 	movabs $0x8067fe,%rdi
  800e01:	00 00 00 
  800e04:	b8 00 00 00 00       	mov    $0x0,%eax
  800e09:	48 b9 6c 31 80 00 00 	movabs $0x80316c,%rcx
  800e10:	00 00 00 
  800e13:	ff d1                	callq  *%rcx
	bitmap[blockno/32] |= 1<<(blockno%32);
  800e15:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800e1c:	00 00 00 
  800e1f:	48 8b 10             	mov    (%rax),%rdx
  800e22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e25:	c1 e8 05             	shr    $0x5,%eax
  800e28:	89 c1                	mov    %eax,%ecx
  800e2a:	48 c1 e1 02          	shl    $0x2,%rcx
  800e2e:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
  800e32:	48 ba 08 20 81 00 00 	movabs $0x812008,%rdx
  800e39:	00 00 00 
  800e3c:	48 8b 12             	mov    (%rdx),%rdx
  800e3f:	89 c0                	mov    %eax,%eax
  800e41:	48 c1 e0 02          	shl    $0x2,%rax
  800e45:	48 01 d0             	add    %rdx,%rax
  800e48:	8b 10                	mov    (%rax),%edx
  800e4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e4d:	83 e0 1f             	and    $0x1f,%eax
  800e50:	bf 01 00 00 00       	mov    $0x1,%edi
  800e55:	89 c1                	mov    %eax,%ecx
  800e57:	d3 e7                	shl    %cl,%edi
  800e59:	89 f8                	mov    %edi,%eax
  800e5b:	09 d0                	or     %edx,%eax
  800e5d:	89 06                	mov    %eax,(%rsi)
}
  800e5f:	c9                   	leaveq 
  800e60:	c3                   	retq   

0000000000800e61 <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
	{
  800e61:	55                   	push   %rbp
  800e62:	48 89 e5             	mov    %rsp,%rbp
  800e65:	48 83 ec 10          	sub    $0x10,%rsp
		// contains the in-use bits for BLKBITSIZE blocks.	There are
		// super->s_nblocks blocks in the disk altogether.
	
		// LAB 5: Your code here.
		//panic("alloc_block not implemented");
		uint32_t blockno = 2;
  800e69:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%rbp)
		for(; blockno < super->s_nblocks; blockno++)
  800e70:	eb 5c                	jmp    800ece <alloc_block+0x6d>
		{
			if(block_is_free(blockno))
  800e72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e75:	89 c7                	mov    %eax,%edi
  800e77:	48 b8 5e 0d 80 00 00 	movabs $0x800d5e,%rax
  800e7e:	00 00 00 
  800e81:	ff d0                	callq  *%rax
  800e83:	84 c0                	test   %al,%al
  800e85:	74 43                	je     800eca <alloc_block+0x69>
			{
				bitmap[blockno/32] &= 0<<(blockno%32);
  800e87:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800e8e:	00 00 00 
  800e91:	48 8b 00             	mov    (%rax),%rax
  800e94:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e97:	c1 ea 05             	shr    $0x5,%edx
  800e9a:	89 d2                	mov    %edx,%edx
  800e9c:	48 c1 e2 02          	shl    $0x2,%rdx
  800ea0:	48 01 d0             	add    %rdx,%rax
  800ea3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
				flush_block((void*)bitmap);
  800ea9:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800eb0:	00 00 00 
  800eb3:	48 8b 00             	mov    (%rax),%rax
  800eb6:	48 89 c7             	mov    %rax,%rdi
  800eb9:	48 b8 66 08 80 00 00 	movabs $0x800866,%rax
  800ec0:	00 00 00 
  800ec3:	ff d0                	callq  *%rax
				return blockno; 
  800ec5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ec8:	eb 1e                	jmp    800ee8 <alloc_block+0x87>
		// super->s_nblocks blocks in the disk altogether.
	
		// LAB 5: Your code here.
		//panic("alloc_block not implemented");
		uint32_t blockno = 2;
		for(; blockno < super->s_nblocks; blockno++)
  800eca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800ece:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800ed5:	00 00 00 
  800ed8:	48 8b 00             	mov    (%rax),%rax
  800edb:	8b 40 04             	mov    0x4(%rax),%eax
  800ede:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800ee1:	77 8f                	ja     800e72 <alloc_block+0x11>
				bitmap[blockno/32] &= 0<<(blockno%32);
				flush_block((void*)bitmap);
				return blockno; 
			}
		}
		return -E_NO_DISK;
  800ee3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	}
  800ee8:	c9                   	leaveq 
  800ee9:	c3                   	retq   

0000000000800eea <check_bitmap>:
//
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use.
void
check_bitmap(void)
{
  800eea:	55                   	push   %rbp
  800eeb:	48 89 e5             	mov    %rsp,%rbp
  800eee:	48 83 ec 10          	sub    $0x10,%rsp
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800ef2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ef9:	eb 51                	jmp    800f4c <check_bitmap+0x62>
		assert(!block_is_free(2+i));
  800efb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800efe:	83 c0 02             	add    $0x2,%eax
  800f01:	89 c7                	mov    %eax,%edi
  800f03:	48 b8 5e 0d 80 00 00 	movabs $0x800d5e,%rax
  800f0a:	00 00 00 
  800f0d:	ff d0                	callq  *%rax
  800f0f:	84 c0                	test   %al,%al
  800f11:	74 35                	je     800f48 <check_bitmap+0x5e>
  800f13:	48 b9 4e 68 80 00 00 	movabs $0x80684e,%rcx
  800f1a:	00 00 00 
  800f1d:	48 ba 62 68 80 00 00 	movabs $0x806862,%rdx
  800f24:	00 00 00 
  800f27:	be 5a 00 00 00       	mov    $0x5a,%esi
  800f2c:	48 bf fe 67 80 00 00 	movabs $0x8067fe,%rdi
  800f33:	00 00 00 
  800f36:	b8 00 00 00 00       	mov    $0x0,%eax
  800f3b:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  800f42:	00 00 00 
  800f45:	41 ff d0             	callq  *%r8
check_bitmap(void)
{
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800f48:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800f4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f4f:	c1 e0 0f             	shl    $0xf,%eax
  800f52:	89 c2                	mov    %eax,%edx
  800f54:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800f5b:	00 00 00 
  800f5e:	48 8b 00             	mov    (%rax),%rax
  800f61:	8b 40 04             	mov    0x4(%rax),%eax
  800f64:	39 c2                	cmp    %eax,%edx
  800f66:	72 93                	jb     800efb <check_bitmap+0x11>
		assert(!block_is_free(2+i));

	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
  800f68:	bf 00 00 00 00       	mov    $0x0,%edi
  800f6d:	48 b8 5e 0d 80 00 00 	movabs $0x800d5e,%rax
  800f74:	00 00 00 
  800f77:	ff d0                	callq  *%rax
  800f79:	84 c0                	test   %al,%al
  800f7b:	74 35                	je     800fb2 <check_bitmap+0xc8>
  800f7d:	48 b9 77 68 80 00 00 	movabs $0x806877,%rcx
  800f84:	00 00 00 
  800f87:	48 ba 62 68 80 00 00 	movabs $0x806862,%rdx
  800f8e:	00 00 00 
  800f91:	be 5d 00 00 00       	mov    $0x5d,%esi
  800f96:	48 bf fe 67 80 00 00 	movabs $0x8067fe,%rdi
  800f9d:	00 00 00 
  800fa0:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa5:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  800fac:	00 00 00 
  800faf:	41 ff d0             	callq  *%r8
	assert(!block_is_free(1));
  800fb2:	bf 01 00 00 00       	mov    $0x1,%edi
  800fb7:	48 b8 5e 0d 80 00 00 	movabs $0x800d5e,%rax
  800fbe:	00 00 00 
  800fc1:	ff d0                	callq  *%rax
  800fc3:	84 c0                	test   %al,%al
  800fc5:	74 35                	je     800ffc <check_bitmap+0x112>
  800fc7:	48 b9 89 68 80 00 00 	movabs $0x806889,%rcx
  800fce:	00 00 00 
  800fd1:	48 ba 62 68 80 00 00 	movabs $0x806862,%rdx
  800fd8:	00 00 00 
  800fdb:	be 5e 00 00 00       	mov    $0x5e,%esi
  800fe0:	48 bf fe 67 80 00 00 	movabs $0x8067fe,%rdi
  800fe7:	00 00 00 
  800fea:	b8 00 00 00 00       	mov    $0x0,%eax
  800fef:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  800ff6:	00 00 00 
  800ff9:	41 ff d0             	callq  *%r8

	cprintf("bitmap is good\n");
  800ffc:	48 bf 9b 68 80 00 00 	movabs $0x80689b,%rdi
  801003:	00 00 00 
  801006:	b8 00 00 00 00       	mov    $0x0,%eax
  80100b:	48 ba a5 33 80 00 00 	movabs $0x8033a5,%rdx
  801012:	00 00 00 
  801015:	ff d2                	callq  *%rdx
}
  801017:	c9                   	leaveq 
  801018:	c3                   	retq   

0000000000801019 <fs_init>:
// --------------------------------------------------------------

// Initialize the file system
void
fs_init(void)
{
  801019:	55                   	push   %rbp
  80101a:	48 89 e5             	mov    %rsp,%rbp
	static_assert(sizeof(struct File) == 256);

	// Find a JOS disk.  Use the second IDE disk (number 1) if available.
	if (ide_probe_disk1())
  80101d:	48 b8 96 00 80 00 00 	movabs $0x800096,%rax
  801024:	00 00 00 
  801027:	ff d0                	callq  *%rax
  801029:	84 c0                	test   %al,%al
  80102b:	74 13                	je     801040 <fs_init+0x27>
		ide_set_disk(1);
  80102d:	bf 01 00 00 00       	mov    $0x1,%edi
  801032:	48 b8 47 01 80 00 00 	movabs $0x800147,%rax
  801039:	00 00 00 
  80103c:	ff d0                	callq  *%rax
  80103e:	eb 11                	jmp    801051 <fs_init+0x38>
	else
		ide_set_disk(0);
  801040:	bf 00 00 00 00       	mov    $0x0,%edi
  801045:	48 b8 47 01 80 00 00 	movabs $0x800147,%rax
  80104c:	00 00 00 
  80104f:	ff d0                	callq  *%rax

	bc_init();
  801051:	48 b8 5b 0c 80 00 00 	movabs $0x800c5b,%rax
  801058:	00 00 00 
  80105b:	ff d0                	callq  *%rax

	// Set "super" to point to the super block.
	super = diskaddr(1);
  80105d:	bf 01 00 00 00       	mov    $0x1,%edi
  801062:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  801069:	00 00 00 
  80106c:	ff d0                	callq  *%rax
  80106e:	48 ba 10 20 81 00 00 	movabs $0x812010,%rdx
  801075:	00 00 00 
  801078:	48 89 02             	mov    %rax,(%rdx)
	check_super();
  80107b:	48 b8 bc 0c 80 00 00 	movabs $0x800cbc,%rax
  801082:	00 00 00 
  801085:	ff d0                	callq  *%rax

	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
  801087:	bf 02 00 00 00       	mov    $0x2,%edi
  80108c:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  801093:	00 00 00 
  801096:	ff d0                	callq  *%rax
  801098:	48 ba 08 20 81 00 00 	movabs $0x812008,%rdx
  80109f:	00 00 00 
  8010a2:	48 89 02             	mov    %rax,(%rdx)
	check_bitmap();
  8010a5:	48 b8 ea 0e 80 00 00 	movabs $0x800eea,%rax
  8010ac:	00 00 00 
  8010af:	ff d0                	callq  *%rax
}
  8010b1:	5d                   	pop    %rbp
  8010b2:	c3                   	retq   

00000000008010b3 <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
	{
  8010b3:	55                   	push   %rbp
  8010b4:	48 89 e5             	mov    %rsp,%rbp
  8010b7:	48 83 ec 30          	sub    $0x30,%rsp
  8010bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010bf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8010c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8010c6:	89 c8                	mov    %ecx,%eax
  8010c8:	88 45 e0             	mov    %al,-0x20(%rbp)
		// LAB 5: Your code here.
		//if filebno is out of range
		//panic("file_block_walk not implemented");
		if(filebno >= NDIRECT + NINDIRECT)
  8010cb:	81 7d e4 09 04 00 00 	cmpl   $0x409,-0x1c(%rbp)
  8010d2:	76 0a                	jbe    8010de <file_block_walk+0x2b>
		{
			return -E_INVAL;
  8010d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010d9:	e9 ea 00 00 00       	jmpq   8011c8 <file_block_walk+0x115>
		}
		if(filebno >= 0 && filebno < 10)
  8010de:	83 7d e4 09          	cmpl   $0x9,-0x1c(%rbp)
  8010e2:	77 26                	ja     80110a <file_block_walk+0x57>
		{
			*ppdiskbno = (uint32_t *)(f->f_direct + filebno);
  8010e4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8010e7:	48 83 c0 20          	add    $0x20,%rax
  8010eb:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  8010f2:	00 
  8010f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f7:	48 01 d0             	add    %rdx,%rax
  8010fa:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8010fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801102:	48 89 10             	mov    %rdx,(%rax)
  801105:	e9 b9 00 00 00       	jmpq   8011c3 <file_block_walk+0x110>
		}
		else if(filebno >= 10)
  80110a:	83 7d e4 09          	cmpl   $0x9,-0x1c(%rbp)
  80110e:	0f 86 af 00 00 00    	jbe    8011c3 <file_block_walk+0x110>
		{
			filebno = filebno - 10;
  801114:	83 6d e4 0a          	subl   $0xa,-0x1c(%rbp)
			if(f->f_indirect != 0)
  801118:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111c:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801122:	85 c0                	test   %eax,%eax
  801124:	74 3a                	je     801160 <file_block_walk+0xad>
			{
				uint32_t* indirect = (uint32_t*)diskaddr(f->f_indirect);
  801126:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112a:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801130:	89 c0                	mov    %eax,%eax
  801132:	48 89 c7             	mov    %rax,%rdi
  801135:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  80113c:	00 00 00 
  80113f:	ff d0                	callq  *%rax
  801141:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
				*ppdiskbno = indirect + filebno;
  801145:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801148:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  80114f:	00 
  801150:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801154:	48 01 c2             	add    %rax,%rdx
  801157:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80115b:	48 89 10             	mov    %rdx,(%rax)
  80115e:	eb 63                	jmp    8011c3 <file_block_walk+0x110>
			}
			else if(f->f_indirect == 0 && alloc)
  801160:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801164:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  80116a:	85 c0                	test   %eax,%eax
  80116c:	75 4e                	jne    8011bc <file_block_walk+0x109>
  80116e:	80 7d e0 00          	cmpb   $0x0,-0x20(%rbp)
  801172:	74 48                	je     8011bc <file_block_walk+0x109>
			{
				uint32_t freeBlock = -1;
  801174:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%rbp)
				if((freeBlock = alloc_block()) < 0)
  80117b:	48 b8 61 0e 80 00 00 	movabs $0x800e61,%rax
  801182:	00 00 00 
  801185:	ff d0                	callq  *%rax
  801187:	89 45 f4             	mov    %eax,-0xc(%rbp)
				{
					return -E_NO_DISK;
				}
				f->f_indirect = freeBlock;
  80118a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801191:	89 90 b0 00 00 00    	mov    %edx,0xb0(%rax)
				*ppdiskbno = (uint32_t*)diskaddr(freeBlock) + filebno;
  801197:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80119a:	48 89 c7             	mov    %rax,%rdi
  80119d:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  8011a4:	00 00 00 
  8011a7:	ff d0                	callq  *%rax
  8011a9:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8011ac:	48 c1 e2 02          	shl    $0x2,%rdx
  8011b0:	48 01 c2             	add    %rax,%rdx
  8011b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011b7:	48 89 10             	mov    %rdx,(%rax)
			{
				uint32_t* indirect = (uint32_t*)diskaddr(f->f_indirect);
				*ppdiskbno = indirect + filebno;
			}
			else if(f->f_indirect == 0 && alloc)
			{
  8011ba:	eb 07                	jmp    8011c3 <file_block_walk+0x110>
				f->f_indirect = freeBlock;
				*ppdiskbno = (uint32_t*)diskaddr(freeBlock) + filebno;
			}
			else
			{
				return -E_NOT_FOUND;
  8011bc:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8011c1:	eb 05                	jmp    8011c8 <file_block_walk+0x115>
			}
		}
		return 0;
  8011c3:	b8 00 00 00 00       	mov    $0x0,%eax
		//panic("file_block_walk not implemented");
	}
  8011c8:	c9                   	leaveq 
  8011c9:	c3                   	retq   

00000000008011ca <file_get_block>:
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_INVAL if filebno is out of range.
//
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  8011ca:	55                   	push   %rbp
  8011cb:	48 89 e5             	mov    %rsp,%rbp
  8011ce:	48 83 ec 30          	sub    $0x30,%rsp
  8011d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011d6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8011d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 5: Your code here.
	//panic("file_get_block not implemented");
	if(filebno >= NDIRECT + NINDIRECT || !f || !blk)
  8011dd:	81 7d e4 09 04 00 00 	cmpl   $0x409,-0x1c(%rbp)
  8011e4:	77 0e                	ja     8011f4 <file_get_block+0x2a>
  8011e6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011eb:	74 07                	je     8011f4 <file_get_block+0x2a>
  8011ed:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011f2:	75 0a                	jne    8011fe <file_get_block+0x34>
	{
		return -E_INVAL;
  8011f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f9:	e9 91 00 00 00       	jmpq   80128f <file_get_block+0xc5>
	}
	uint32_t * pdiskbno;
	if(file_block_walk(f, filebno, &pdiskbno, true) < 0)
  8011fe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801202:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  801205:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801209:	b9 01 00 00 00       	mov    $0x1,%ecx
  80120e:	48 89 c7             	mov    %rax,%rdi
  801211:	48 b8 b3 10 80 00 00 	movabs $0x8010b3,%rax
  801218:	00 00 00 
  80121b:	ff d0                	callq  *%rax
  80121d:	85 c0                	test   %eax,%eax
  80121f:	79 07                	jns    801228 <file_get_block+0x5e>
	{
		return -E_NO_DISK;
  801221:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801226:	eb 67                	jmp    80128f <file_get_block+0xc5>
	}
	if(*pdiskbno != 0)
  801228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122c:	8b 00                	mov    (%rax),%eax
  80122e:	85 c0                	test   %eax,%eax
  801230:	74 20                	je     801252 <file_get_block+0x88>
	{
		*blk = (char*)diskaddr(*pdiskbno);
  801232:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801236:	8b 00                	mov    (%rax),%eax
  801238:	89 c0                	mov    %eax,%eax
  80123a:	48 89 c7             	mov    %rax,%rdi
  80123d:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  801244:	00 00 00 
  801247:	ff d0                	callq  *%rax
  801249:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80124d:	48 89 02             	mov    %rax,(%rdx)
  801250:	eb 38                	jmp    80128a <file_get_block+0xc0>
	}
	else
	{
		uint32_t freeBlock = -1;
  801252:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
		if((freeBlock = alloc_block()) < 0)
  801259:	48 b8 61 0e 80 00 00 	movabs $0x800e61,%rax
  801260:	00 00 00 
  801263:	ff d0                	callq  *%rax
  801265:	89 45 fc             	mov    %eax,-0x4(%rbp)
		{
			return -E_NO_DISK;
		}
		*pdiskbno = freeBlock;
  801268:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80126f:	89 10                	mov    %edx,(%rax)
		*blk = (char*)diskaddr(freeBlock);
  801271:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801274:	48 89 c7             	mov    %rax,%rdi
  801277:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  80127e:	00 00 00 
  801281:	ff d0                	callq  *%rax
  801283:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801287:	48 89 02             	mov    %rax,(%rdx)
	}
	return 0;
  80128a:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("file_block_walk not implemented");
}
  80128f:	c9                   	leaveq 
  801290:	c3                   	retq   

0000000000801291 <dir_lookup>:
//
// Returns 0 and sets *file on success, < 0 on error.  Errors are:
//	-E_NOT_FOUND if the file is not found
static int
dir_lookup(struct File *dir, const char *name, struct File **file)
{
  801291:	55                   	push   %rbp
  801292:	48 89 e5             	mov    %rsp,%rbp
  801295:	48 83 ec 40          	sub    $0x40,%rsp
  801299:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80129d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8012a1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  8012a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a9:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8012af:	25 ff 0f 00 00       	and    $0xfff,%eax
  8012b4:	85 c0                	test   %eax,%eax
  8012b6:	74 35                	je     8012ed <dir_lookup+0x5c>
  8012b8:	48 b9 ab 68 80 00 00 	movabs $0x8068ab,%rcx
  8012bf:	00 00 00 
  8012c2:	48 ba 62 68 80 00 00 	movabs $0x806862,%rdx
  8012c9:	00 00 00 
  8012cc:	be f0 00 00 00       	mov    $0xf0,%esi
  8012d1:	48 bf fe 67 80 00 00 	movabs $0x8067fe,%rdi
  8012d8:	00 00 00 
  8012db:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e0:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  8012e7:	00 00 00 
  8012ea:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  8012ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f1:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8012f7:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  8012fd:	85 c0                	test   %eax,%eax
  8012ff:	0f 48 c2             	cmovs  %edx,%eax
  801302:	c1 f8 0c             	sar    $0xc,%eax
  801305:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  801308:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80130f:	e9 93 00 00 00       	jmpq   8013a7 <dir_lookup+0x116>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801314:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  801318:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80131b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80131f:	89 ce                	mov    %ecx,%esi
  801321:	48 89 c7             	mov    %rax,%rdi
  801324:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  80132b:	00 00 00 
  80132e:	ff d0                	callq  *%rax
  801330:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801333:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801337:	79 05                	jns    80133e <dir_lookup+0xad>
			return r;
  801339:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80133c:	eb 7a                	jmp    8013b8 <dir_lookup+0x127>
		f = (struct File*) blk;
  80133e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801342:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  801346:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  80134d:	eb 4e                	jmp    80139d <dir_lookup+0x10c>
			if (strcmp(f[j].f_name, name) == 0) {
  80134f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801352:	48 c1 e0 08          	shl    $0x8,%rax
  801356:	48 89 c2             	mov    %rax,%rdx
  801359:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135d:	48 01 d0             	add    %rdx,%rax
  801360:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801364:	48 89 d6             	mov    %rdx,%rsi
  801367:	48 89 c7             	mov    %rax,%rdi
  80136a:	48 b8 bc 40 80 00 00 	movabs $0x8040bc,%rax
  801371:	00 00 00 
  801374:	ff d0                	callq  *%rax
  801376:	85 c0                	test   %eax,%eax
  801378:	75 1f                	jne    801399 <dir_lookup+0x108>
				*file = &f[j];
  80137a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80137d:	48 c1 e0 08          	shl    $0x8,%rax
  801381:	48 89 c2             	mov    %rax,%rdx
  801384:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801388:	48 01 c2             	add    %rax,%rdx
  80138b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80138f:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  801392:	b8 00 00 00 00       	mov    $0x0,%eax
  801397:	eb 1f                	jmp    8013b8 <dir_lookup+0x127>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  801399:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  80139d:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  8013a1:	76 ac                	jbe    80134f <dir_lookup+0xbe>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  8013a3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8013a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013aa:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8013ad:	0f 82 61 ff ff ff    	jb     801314 <dir_lookup+0x83>
			if (strcmp(f[j].f_name, name) == 0) {
				*file = &f[j];
				return 0;
			}
	}
	return -E_NOT_FOUND;
  8013b3:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
}
  8013b8:	c9                   	leaveq 
  8013b9:	c3                   	retq   

00000000008013ba <dir_alloc_file>:

// Set *file to point at a free File structure in dir.  The caller is
// responsible for filling in the File fields.
static int
dir_alloc_file(struct File *dir, struct File **file)
{
  8013ba:	55                   	push   %rbp
  8013bb:	48 89 e5             	mov    %rsp,%rbp
  8013be:	48 83 ec 30          	sub    $0x30,%rsp
  8013c2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013c6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  8013ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ce:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8013d4:	25 ff 0f 00 00       	and    $0xfff,%eax
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	74 35                	je     801412 <dir_alloc_file+0x58>
  8013dd:	48 b9 ab 68 80 00 00 	movabs $0x8068ab,%rcx
  8013e4:	00 00 00 
  8013e7:	48 ba 62 68 80 00 00 	movabs $0x806862,%rdx
  8013ee:	00 00 00 
  8013f1:	be 09 01 00 00       	mov    $0x109,%esi
  8013f6:	48 bf fe 67 80 00 00 	movabs $0x8067fe,%rdi
  8013fd:	00 00 00 
  801400:	b8 00 00 00 00       	mov    $0x0,%eax
  801405:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  80140c:	00 00 00 
  80140f:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  801412:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801416:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  80141c:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801422:	85 c0                	test   %eax,%eax
  801424:	0f 48 c2             	cmovs  %edx,%eax
  801427:	c1 f8 0c             	sar    $0xc,%eax
  80142a:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  80142d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801434:	e9 83 00 00 00       	jmpq   8014bc <dir_alloc_file+0x102>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801439:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80143d:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801440:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801444:	89 ce                	mov    %ecx,%esi
  801446:	48 89 c7             	mov    %rax,%rdi
  801449:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  801450:	00 00 00 
  801453:	ff d0                	callq  *%rax
  801455:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801458:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80145c:	79 08                	jns    801466 <dir_alloc_file+0xac>
			return r;
  80145e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801461:	e9 be 00 00 00       	jmpq   801524 <dir_alloc_file+0x16a>
		f = (struct File*) blk;
  801466:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80146a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  80146e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  801475:	eb 3b                	jmp    8014b2 <dir_alloc_file+0xf8>
			if (f[j].f_name[0] == '\0') {
  801477:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80147a:	48 c1 e0 08          	shl    $0x8,%rax
  80147e:	48 89 c2             	mov    %rax,%rdx
  801481:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801485:	48 01 d0             	add    %rdx,%rax
  801488:	0f b6 00             	movzbl (%rax),%eax
  80148b:	84 c0                	test   %al,%al
  80148d:	75 1f                	jne    8014ae <dir_alloc_file+0xf4>
				*file = &f[j];
  80148f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801492:	48 c1 e0 08          	shl    $0x8,%rax
  801496:	48 89 c2             	mov    %rax,%rdx
  801499:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80149d:	48 01 c2             	add    %rax,%rdx
  8014a0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014a4:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  8014a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ac:	eb 76                	jmp    801524 <dir_alloc_file+0x16a>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  8014ae:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8014b2:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  8014b6:	76 bf                	jbe    801477 <dir_alloc_file+0xbd>
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  8014b8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8014bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014bf:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8014c2:	0f 82 71 ff ff ff    	jb     801439 <dir_alloc_file+0x7f>
			if (f[j].f_name[0] == '\0') {
				*file = &f[j];
				return 0;
			}
	}
	dir->f_size += BLKSIZE;
  8014c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014cc:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8014d2:	8d 90 00 10 00 00    	lea    0x1000(%rax),%edx
  8014d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014dc:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	if ((r = file_get_block(dir, i, &blk)) < 0)
  8014e2:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  8014e6:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8014e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ed:	89 ce                	mov    %ecx,%esi
  8014ef:	48 89 c7             	mov    %rax,%rdi
  8014f2:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  8014f9:	00 00 00 
  8014fc:	ff d0                	callq  *%rax
  8014fe:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801501:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801505:	79 05                	jns    80150c <dir_alloc_file+0x152>
		return r;
  801507:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80150a:	eb 18                	jmp    801524 <dir_alloc_file+0x16a>
	f = (struct File*) blk;
  80150c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801510:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	*file = &f[0];
  801514:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801518:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80151c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80151f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801524:	c9                   	leaveq 
  801525:	c3                   	retq   

0000000000801526 <skip_slash>:

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
  801526:	55                   	push   %rbp
  801527:	48 89 e5             	mov    %rsp,%rbp
  80152a:	48 83 ec 08          	sub    $0x8,%rsp
  80152e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	while (*p == '/')
  801532:	eb 05                	jmp    801539 <skip_slash+0x13>
		p++;
  801534:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  801539:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153d:	0f b6 00             	movzbl (%rax),%eax
  801540:	3c 2f                	cmp    $0x2f,%al
  801542:	74 f0                	je     801534 <skip_slash+0xe>
		p++;
	return p;
  801544:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801548:	c9                   	leaveq 
  801549:	c3                   	retq   

000000000080154a <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  80154a:	55                   	push   %rbp
  80154b:	48 89 e5             	mov    %rsp,%rbp
  80154e:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  801555:	48 89 bd 48 ff ff ff 	mov    %rdi,-0xb8(%rbp)
  80155c:	48 89 b5 40 ff ff ff 	mov    %rsi,-0xc0(%rbp)
  801563:	48 89 95 38 ff ff ff 	mov    %rdx,-0xc8(%rbp)
  80156a:	48 89 8d 30 ff ff ff 	mov    %rcx,-0xd0(%rbp)
	struct File *dir, *f;
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
  801571:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801578:	48 89 c7             	mov    %rax,%rdi
  80157b:	48 b8 26 15 80 00 00 	movabs $0x801526,%rax
  801582:	00 00 00 
  801585:	ff d0                	callq  *%rax
  801587:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	f = &super->s_root;
  80158e:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  801595:	00 00 00 
  801598:	48 8b 00             	mov    (%rax),%rax
  80159b:	48 83 c0 08          	add    $0x8,%rax
  80159f:	48 89 85 58 ff ff ff 	mov    %rax,-0xa8(%rbp)
	dir = 0;
  8015a6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8015ad:	00 
	name[0] = 0;
  8015ae:	c6 85 60 ff ff ff 00 	movb   $0x0,-0xa0(%rbp)

	if (pdir)
  8015b5:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  8015bc:	00 
  8015bd:	74 0e                	je     8015cd <walk_path+0x83>
		*pdir = 0;
  8015bf:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  8015c6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*pf = 0;
  8015cd:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  8015d4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	while (*path != '\0') {
  8015db:	e9 73 01 00 00       	jmpq   801753 <walk_path+0x209>
		dir = f;
  8015e0:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8015e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		p = path;
  8015eb:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8015f2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		while (*path != '/' && *path != '\0')
  8015f6:	eb 08                	jmp    801600 <walk_path+0xb6>
			path++;
  8015f8:	48 83 85 48 ff ff ff 	addq   $0x1,-0xb8(%rbp)
  8015ff:	01 
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  801600:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801607:	0f b6 00             	movzbl (%rax),%eax
  80160a:	3c 2f                	cmp    $0x2f,%al
  80160c:	74 0e                	je     80161c <walk_path+0xd2>
  80160e:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801615:	0f b6 00             	movzbl (%rax),%eax
  801618:	84 c0                	test   %al,%al
  80161a:	75 dc                	jne    8015f8 <walk_path+0xae>
			path++;
		if (path - p >= MAXNAMELEN)
  80161c:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  801623:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801627:	48 29 c2             	sub    %rax,%rdx
  80162a:	48 89 d0             	mov    %rdx,%rax
  80162d:	48 83 f8 7f          	cmp    $0x7f,%rax
  801631:	7e 0a                	jle    80163d <walk_path+0xf3>
			return -E_BAD_PATH;
  801633:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801638:	e9 56 01 00 00       	jmpq   801793 <walk_path+0x249>
		memmove(name, p, path - p);
  80163d:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  801644:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801648:	48 29 c2             	sub    %rax,%rdx
  80164b:	48 89 d0             	mov    %rdx,%rax
  80164e:	48 89 c2             	mov    %rax,%rdx
  801651:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801655:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
  80165c:	48 89 ce             	mov    %rcx,%rsi
  80165f:	48 89 c7             	mov    %rax,%rdi
  801662:	48 b8 7e 42 80 00 00 	movabs $0x80427e,%rax
  801669:	00 00 00 
  80166c:	ff d0                	callq  *%rax
		name[path - p] = '\0';
  80166e:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  801675:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801679:	48 29 c2             	sub    %rax,%rdx
  80167c:	48 89 d0             	mov    %rdx,%rax
  80167f:	c6 84 05 60 ff ff ff 	movb   $0x0,-0xa0(%rbp,%rax,1)
  801686:	00 
		path = skip_slash(path);
  801687:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80168e:	48 89 c7             	mov    %rax,%rdi
  801691:	48 b8 26 15 80 00 00 	movabs $0x801526,%rax
  801698:	00 00 00 
  80169b:	ff d0                	callq  *%rax
  80169d:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)

		if (dir->f_type != FTYPE_DIR)
  8016a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a8:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  8016ae:	83 f8 01             	cmp    $0x1,%eax
  8016b1:	74 0a                	je     8016bd <walk_path+0x173>
			return -E_NOT_FOUND;
  8016b3:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8016b8:	e9 d6 00 00 00       	jmpq   801793 <walk_path+0x249>

		if ((r = dir_lookup(dir, name, &f)) < 0) {
  8016bd:	48 8d 95 58 ff ff ff 	lea    -0xa8(%rbp),%rdx
  8016c4:	48 8d 8d 60 ff ff ff 	lea    -0xa0(%rbp),%rcx
  8016cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016cf:	48 89 ce             	mov    %rcx,%rsi
  8016d2:	48 89 c7             	mov    %rax,%rdi
  8016d5:	48 b8 91 12 80 00 00 	movabs $0x801291,%rax
  8016dc:	00 00 00 
  8016df:	ff d0                	callq  *%rax
  8016e1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8016e8:	79 69                	jns    801753 <walk_path+0x209>
			if (r == -E_NOT_FOUND && *path == '\0') {
  8016ea:	83 7d ec f4          	cmpl   $0xfffffff4,-0x14(%rbp)
  8016ee:	75 5e                	jne    80174e <walk_path+0x204>
  8016f0:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8016f7:	0f b6 00             	movzbl (%rax),%eax
  8016fa:	84 c0                	test   %al,%al
  8016fc:	75 50                	jne    80174e <walk_path+0x204>
				if (pdir)
  8016fe:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  801705:	00 
  801706:	74 0e                	je     801716 <walk_path+0x1cc>
					*pdir = dir;
  801708:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  80170f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801713:	48 89 10             	mov    %rdx,(%rax)
				if (lastelem)
  801716:	48 83 bd 30 ff ff ff 	cmpq   $0x0,-0xd0(%rbp)
  80171d:	00 
  80171e:	74 20                	je     801740 <walk_path+0x1f6>
					strcpy(lastelem, name);
  801720:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  801727:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
  80172e:	48 89 d6             	mov    %rdx,%rsi
  801731:	48 89 c7             	mov    %rax,%rdi
  801734:	48 b8 5a 3f 80 00 00 	movabs $0x803f5a,%rax
  80173b:	00 00 00 
  80173e:	ff d0                	callq  *%rax
				*pf = 0;
  801740:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  801747:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
			}
			return r;
  80174e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801751:	eb 40                	jmp    801793 <walk_path+0x249>
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  801753:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80175a:	0f b6 00             	movzbl (%rax),%eax
  80175d:	84 c0                	test   %al,%al
  80175f:	0f 85 7b fe ff ff    	jne    8015e0 <walk_path+0x96>
			}
			return r;
		}
	}

	if (pdir)
  801765:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  80176c:	00 
  80176d:	74 0e                	je     80177d <walk_path+0x233>
		*pdir = dir;
  80176f:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  801776:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80177a:	48 89 10             	mov    %rdx,(%rax)
	*pf = f;
  80177d:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  801784:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  80178b:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80178e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801793:	c9                   	leaveq 
  801794:	c3                   	retq   

0000000000801795 <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  801795:	55                   	push   %rbp
  801796:	48 89 e5             	mov    %rsp,%rbp
  801799:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8017a0:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  8017a7:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  8017ae:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
  8017b5:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  8017bc:	48 8d b5 68 ff ff ff 	lea    -0x98(%rbp),%rsi
  8017c3:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8017ca:	48 89 c7             	mov    %rax,%rdi
  8017cd:	48 b8 4a 15 80 00 00 	movabs $0x80154a,%rax
  8017d4:	00 00 00 
  8017d7:	ff d0                	callq  *%rax
  8017d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8017dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017e0:	75 0a                	jne    8017ec <file_create+0x57>
		return -E_FILE_EXISTS;
  8017e2:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8017e7:	e9 91 00 00 00       	jmpq   80187d <file_create+0xe8>
	if (r != -E_NOT_FOUND || dir == 0)
  8017ec:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  8017f0:	75 0c                	jne    8017fe <file_create+0x69>
  8017f2:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8017f9:	48 85 c0             	test   %rax,%rax
  8017fc:	75 05                	jne    801803 <file_create+0x6e>
		return r;
  8017fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801801:	eb 7a                	jmp    80187d <file_create+0xe8>
	if ((r = dir_alloc_file(dir, &f)) < 0)
  801803:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80180a:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  801811:	48 89 d6             	mov    %rdx,%rsi
  801814:	48 89 c7             	mov    %rax,%rdi
  801817:	48 b8 ba 13 80 00 00 	movabs $0x8013ba,%rax
  80181e:	00 00 00 
  801821:	ff d0                	callq  *%rax
  801823:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801826:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80182a:	79 05                	jns    801831 <file_create+0x9c>
		return r;
  80182c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80182f:	eb 4c                	jmp    80187d <file_create+0xe8>
	strcpy(f->f_name, name);
  801831:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801838:	48 8d 95 70 ff ff ff 	lea    -0x90(%rbp),%rdx
  80183f:	48 89 d6             	mov    %rdx,%rsi
  801842:	48 89 c7             	mov    %rax,%rdi
  801845:	48 b8 5a 3f 80 00 00 	movabs $0x803f5a,%rax
  80184c:	00 00 00 
  80184f:	ff d0                	callq  *%rax
	*pf = f;
  801851:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  801858:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  80185f:	48 89 10             	mov    %rdx,(%rax)
	file_flush(dir);
  801862:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  801869:	48 89 c7             	mov    %rax,%rdi
  80186c:	48 b8 0b 1d 80 00 00 	movabs $0x801d0b,%rax
  801873:	00 00 00 
  801876:	ff d0                	callq  *%rax
	return 0;
  801878:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80187d:	c9                   	leaveq 
  80187e:	c3                   	retq   

000000000080187f <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  80187f:	55                   	push   %rbp
  801880:	48 89 e5             	mov    %rsp,%rbp
  801883:	48 83 ec 10          	sub    $0x10,%rsp
  801887:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80188b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return walk_path(path, 0, pf, 0);
  80188f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801893:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801897:	b9 00 00 00 00       	mov    $0x0,%ecx
  80189c:	be 00 00 00 00       	mov    $0x0,%esi
  8018a1:	48 89 c7             	mov    %rax,%rdi
  8018a4:	48 b8 4a 15 80 00 00 	movabs $0x80154a,%rax
  8018ab:	00 00 00 
  8018ae:	ff d0                	callq  *%rax
}
  8018b0:	c9                   	leaveq 
  8018b1:	c3                   	retq   

00000000008018b2 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  8018b2:	55                   	push   %rbp
  8018b3:	48 89 e5             	mov    %rsp,%rbp
  8018b6:	48 83 ec 60          	sub    $0x60,%rsp
  8018ba:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  8018be:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  8018c2:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  8018c6:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  8018c9:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8018cd:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8018d3:	3b 45 a4             	cmp    -0x5c(%rbp),%eax
  8018d6:	7f 0a                	jg     8018e2 <file_read+0x30>
		return 0;
  8018d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8018dd:	e9 24 01 00 00       	jmpq   801a06 <file_read+0x154>

	count = MIN(count, f->f_size - offset);
  8018e2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8018e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8018ea:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8018ee:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8018f4:	2b 45 a4             	sub    -0x5c(%rbp),%eax
  8018f7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018fd:	48 63 d0             	movslq %eax,%rdx
  801900:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801904:	48 39 c2             	cmp    %rax,%rdx
  801907:	48 0f 46 c2          	cmovbe %rdx,%rax
  80190b:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	for (pos = offset; pos < offset + count; ) {
  80190f:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  801912:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801915:	e9 cd 00 00 00       	jmpq   8019e7 <file_read+0x135>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  80191a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80191d:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801923:	85 c0                	test   %eax,%eax
  801925:	0f 48 c2             	cmovs  %edx,%eax
  801928:	c1 f8 0c             	sar    $0xc,%eax
  80192b:	89 c1                	mov    %eax,%ecx
  80192d:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  801931:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801935:	89 ce                	mov    %ecx,%esi
  801937:	48 89 c7             	mov    %rax,%rdi
  80193a:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  801941:	00 00 00 
  801944:	ff d0                	callq  *%rax
  801946:	89 45 e8             	mov    %eax,-0x18(%rbp)
  801949:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80194d:	79 08                	jns    801957 <file_read+0xa5>
			return r;
  80194f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801952:	e9 af 00 00 00       	jmpq   801a06 <file_read+0x154>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801957:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80195a:	99                   	cltd   
  80195b:	c1 ea 14             	shr    $0x14,%edx
  80195e:	01 d0                	add    %edx,%eax
  801960:	25 ff 0f 00 00       	and    $0xfff,%eax
  801965:	29 d0                	sub    %edx,%eax
  801967:	ba 00 10 00 00       	mov    $0x1000,%edx
  80196c:	29 c2                	sub    %eax,%edx
  80196e:	89 d0                	mov    %edx,%eax
  801970:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  801973:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  801976:	48 63 d0             	movslq %eax,%rdx
  801979:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80197d:	48 01 c2             	add    %rax,%rdx
  801980:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801983:	48 98                	cltq   
  801985:	48 29 c2             	sub    %rax,%rdx
  801988:	48 89 d0             	mov    %rdx,%rax
  80198b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80198f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801992:	48 63 d0             	movslq %eax,%rdx
  801995:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801999:	48 39 c2             	cmp    %rax,%rdx
  80199c:	48 0f 46 c2          	cmovbe %rdx,%rax
  8019a0:	89 45 d4             	mov    %eax,-0x2c(%rbp)
		memmove(buf, blk + pos % BLKSIZE, bn);
  8019a3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8019a6:	48 63 c8             	movslq %eax,%rcx
  8019a9:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8019ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b0:	99                   	cltd   
  8019b1:	c1 ea 14             	shr    $0x14,%edx
  8019b4:	01 d0                	add    %edx,%eax
  8019b6:	25 ff 0f 00 00       	and    $0xfff,%eax
  8019bb:	29 d0                	sub    %edx,%eax
  8019bd:	48 98                	cltq   
  8019bf:	48 01 c6             	add    %rax,%rsi
  8019c2:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8019c6:	48 89 ca             	mov    %rcx,%rdx
  8019c9:	48 89 c7             	mov    %rax,%rdi
  8019cc:	48 b8 7e 42 80 00 00 	movabs $0x80427e,%rax
  8019d3:	00 00 00 
  8019d6:	ff d0                	callq  *%rax
		pos += bn;
  8019d8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8019db:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  8019de:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8019e1:	48 98                	cltq   
  8019e3:	48 01 45 b0          	add    %rax,-0x50(%rbp)
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
  8019e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ea:	48 98                	cltq   
  8019ec:	8b 55 a4             	mov    -0x5c(%rbp),%edx
  8019ef:	48 63 ca             	movslq %edx,%rcx
  8019f2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8019f6:	48 01 ca             	add    %rcx,%rdx
  8019f9:	48 39 d0             	cmp    %rdx,%rax
  8019fc:	0f 82 18 ff ff ff    	jb     80191a <file_read+0x68>
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801a02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
}
  801a06:	c9                   	leaveq 
  801a07:	c3                   	retq   

0000000000801a08 <file_write>:
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  801a08:	55                   	push   %rbp
  801a09:	48 89 e5             	mov    %rsp,%rbp
  801a0c:	48 83 ec 50          	sub    $0x50,%rsp
  801a10:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801a14:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  801a18:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801a1c:	89 4d b4             	mov    %ecx,-0x4c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
  801a1f:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801a22:	48 63 d0             	movslq %eax,%rdx
  801a25:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a29:	48 01 c2             	add    %rax,%rdx
  801a2c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a30:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801a36:	48 98                	cltq   
  801a38:	48 39 c2             	cmp    %rax,%rdx
  801a3b:	76 33                	jbe    801a70 <file_write+0x68>
		if ((r = file_set_size(f, offset + count)) < 0)
  801a3d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a41:	89 c2                	mov    %eax,%edx
  801a43:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801a46:	01 d0                	add    %edx,%eax
  801a48:	89 c2                	mov    %eax,%edx
  801a4a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a4e:	89 d6                	mov    %edx,%esi
  801a50:	48 89 c7             	mov    %rax,%rdi
  801a53:	48 b8 ae 1c 80 00 00 	movabs $0x801cae,%rax
  801a5a:	00 00 00 
  801a5d:	ff d0                	callq  *%rax
  801a5f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801a62:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801a66:	79 08                	jns    801a70 <file_write+0x68>
			return r;
  801a68:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a6b:	e9 f8 00 00 00       	jmpq   801b68 <file_write+0x160>

	for (pos = offset; pos < offset + count; ) {
  801a70:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801a73:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a76:	e9 ce 00 00 00       	jmpq   801b49 <file_write+0x141>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801a7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a7e:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801a84:	85 c0                	test   %eax,%eax
  801a86:	0f 48 c2             	cmovs  %edx,%eax
  801a89:	c1 f8 0c             	sar    $0xc,%eax
  801a8c:	89 c1                	mov    %eax,%ecx
  801a8e:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801a92:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a96:	89 ce                	mov    %ecx,%esi
  801a98:	48 89 c7             	mov    %rax,%rdi
  801a9b:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  801aa2:	00 00 00 
  801aa5:	ff d0                	callq  *%rax
  801aa7:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801aaa:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801aae:	79 08                	jns    801ab8 <file_write+0xb0>
			return r;
  801ab0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ab3:	e9 b0 00 00 00       	jmpq   801b68 <file_write+0x160>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801ab8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801abb:	99                   	cltd   
  801abc:	c1 ea 14             	shr    $0x14,%edx
  801abf:	01 d0                	add    %edx,%eax
  801ac1:	25 ff 0f 00 00       	and    $0xfff,%eax
  801ac6:	29 d0                	sub    %edx,%eax
  801ac8:	ba 00 10 00 00       	mov    $0x1000,%edx
  801acd:	29 c2                	sub    %eax,%edx
  801acf:	89 d0                	mov    %edx,%eax
  801ad1:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801ad4:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801ad7:	48 63 d0             	movslq %eax,%rdx
  801ada:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801ade:	48 01 c2             	add    %rax,%rdx
  801ae1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ae4:	48 98                	cltq   
  801ae6:	48 29 c2             	sub    %rax,%rdx
  801ae9:	48 89 d0             	mov    %rdx,%rax
  801aec:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801af0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801af3:	48 63 d0             	movslq %eax,%rdx
  801af6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801afa:	48 39 c2             	cmp    %rax,%rdx
  801afd:	48 0f 46 c2          	cmovbe %rdx,%rax
  801b01:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		memmove(blk + pos % BLKSIZE, buf, bn);
  801b04:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b07:	48 63 c8             	movslq %eax,%rcx
  801b0a:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801b0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b11:	99                   	cltd   
  801b12:	c1 ea 14             	shr    $0x14,%edx
  801b15:	01 d0                	add    %edx,%eax
  801b17:	25 ff 0f 00 00       	and    $0xfff,%eax
  801b1c:	29 d0                	sub    %edx,%eax
  801b1e:	48 98                	cltq   
  801b20:	48 8d 3c 06          	lea    (%rsi,%rax,1),%rdi
  801b24:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801b28:	48 89 ca             	mov    %rcx,%rdx
  801b2b:	48 89 c6             	mov    %rax,%rsi
  801b2e:	48 b8 7e 42 80 00 00 	movabs $0x80427e,%rax
  801b35:	00 00 00 
  801b38:	ff d0                	callq  *%rax
		pos += bn;
  801b3a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b3d:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  801b40:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b43:	48 98                	cltq   
  801b45:	48 01 45 c0          	add    %rax,-0x40(%rbp)
	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
  801b49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b4c:	48 98                	cltq   
  801b4e:	8b 55 b4             	mov    -0x4c(%rbp),%edx
  801b51:	48 63 ca             	movslq %edx,%rcx
  801b54:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801b58:	48 01 ca             	add    %rcx,%rdx
  801b5b:	48 39 d0             	cmp    %rdx,%rax
  801b5e:	0f 82 17 ff ff ff    	jb     801a7b <file_write+0x73>
		memmove(blk + pos % BLKSIZE, buf, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801b64:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
}
  801b68:	c9                   	leaveq 
  801b69:	c3                   	retq   

0000000000801b6a <file_free_block>:

// Remove a block from file f.  If it's not there, just silently succeed.
// Returns 0 on success, < 0 on error.
static int
file_free_block(struct File *f, uint32_t filebno)
{
  801b6a:	55                   	push   %rbp
  801b6b:	48 89 e5             	mov    %rsp,%rbp
  801b6e:	48 83 ec 20          	sub    $0x20,%rsp
  801b72:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b76:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  801b79:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801b7d:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  801b80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b84:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b89:	48 89 c7             	mov    %rax,%rdi
  801b8c:	48 b8 b3 10 80 00 00 	movabs $0x8010b3,%rax
  801b93:	00 00 00 
  801b96:	ff d0                	callq  *%rax
  801b98:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b9f:	79 05                	jns    801ba6 <file_free_block+0x3c>
		return r;
  801ba1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ba4:	eb 2d                	jmp    801bd3 <file_free_block+0x69>
	if (*ptr) {
  801ba6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801baa:	8b 00                	mov    (%rax),%eax
  801bac:	85 c0                	test   %eax,%eax
  801bae:	74 1e                	je     801bce <file_free_block+0x64>
		free_block(*ptr);
  801bb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bb4:	8b 00                	mov    (%rax),%eax
  801bb6:	89 c7                	mov    %eax,%edi
  801bb8:	48 b8 da 0d 80 00 00 	movabs $0x800dda,%rax
  801bbf:	00 00 00 
  801bc2:	ff d0                	callq  *%rax
		*ptr = 0;
  801bc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bc8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	return 0;
  801bce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd3:	c9                   	leaveq 
  801bd4:	c3                   	retq   

0000000000801bd5 <file_truncate_blocks>:
// (Remember to clear the f->f_indirect pointer so you'll know
// whether it's valid!)
// Do not change f->f_size.
static void
file_truncate_blocks(struct File *f, off_t newsize)
{
  801bd5:	55                   	push   %rbp
  801bd6:	48 89 e5             	mov    %rsp,%rbp
  801bd9:	48 83 ec 20          	sub    $0x20,%rsp
  801bdd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801be1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  801be4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801be8:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801bee:	05 ff 0f 00 00       	add    $0xfff,%eax
  801bf3:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801bf9:	85 c0                	test   %eax,%eax
  801bfb:	0f 48 c2             	cmovs  %edx,%eax
  801bfe:	c1 f8 0c             	sar    $0xc,%eax
  801c01:	89 45 f8             	mov    %eax,-0x8(%rbp)
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  801c04:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c07:	05 ff 0f 00 00       	add    $0xfff,%eax
  801c0c:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801c12:	85 c0                	test   %eax,%eax
  801c14:	0f 48 c2             	cmovs  %edx,%eax
  801c17:	c1 f8 0c             	sar    $0xc,%eax
  801c1a:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801c1d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c23:	eb 45                	jmp    801c6a <file_truncate_blocks+0x95>
		if ((r = file_free_block(f, bno)) < 0)
  801c25:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c2c:	89 d6                	mov    %edx,%esi
  801c2e:	48 89 c7             	mov    %rax,%rdi
  801c31:	48 b8 6a 1b 80 00 00 	movabs $0x801b6a,%rax
  801c38:	00 00 00 
  801c3b:	ff d0                	callq  *%rax
  801c3d:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801c40:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801c44:	79 20                	jns    801c66 <file_truncate_blocks+0x91>
			cprintf("warning: file_free_block: %e", r);
  801c46:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801c49:	89 c6                	mov    %eax,%esi
  801c4b:	48 bf c8 68 80 00 00 	movabs $0x8068c8,%rdi
  801c52:	00 00 00 
  801c55:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5a:	48 ba a5 33 80 00 00 	movabs $0x8033a5,%rdx
  801c61:	00 00 00 
  801c64:	ff d2                	callq  *%rdx
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801c66:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801c6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c6d:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  801c70:	72 b3                	jb     801c25 <file_truncate_blocks+0x50>
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  801c72:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  801c76:	77 34                	ja     801cac <file_truncate_blocks+0xd7>
  801c78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c7c:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801c82:	85 c0                	test   %eax,%eax
  801c84:	74 26                	je     801cac <file_truncate_blocks+0xd7>
		free_block(f->f_indirect);
  801c86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c8a:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801c90:	89 c7                	mov    %eax,%edi
  801c92:	48 b8 da 0d 80 00 00 	movabs $0x800dda,%rax
  801c99:	00 00 00 
  801c9c:	ff d0                	callq  *%rax
		f->f_indirect = 0;
  801c9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ca2:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%rax)
  801ca9:	00 00 00 
	}
}
  801cac:	c9                   	leaveq 
  801cad:	c3                   	retq   

0000000000801cae <file_set_size>:

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  801cae:	55                   	push   %rbp
  801caf:	48 89 e5             	mov    %rsp,%rbp
  801cb2:	48 83 ec 10          	sub    $0x10,%rsp
  801cb6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cba:	89 75 f4             	mov    %esi,-0xc(%rbp)
	if (f->f_size > newsize)
  801cbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cc1:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801cc7:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801cca:	7e 18                	jle    801ce4 <file_set_size+0x36>
		file_truncate_blocks(f, newsize);
  801ccc:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801ccf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cd3:	89 d6                	mov    %edx,%esi
  801cd5:	48 89 c7             	mov    %rax,%rdi
  801cd8:	48 b8 d5 1b 80 00 00 	movabs $0x801bd5,%rax
  801cdf:	00 00 00 
  801ce2:	ff d0                	callq  *%rax
	f->f_size = newsize;
  801ce4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ce8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801ceb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	flush_block(f);
  801cf1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cf5:	48 89 c7             	mov    %rax,%rdi
  801cf8:	48 b8 66 08 80 00 00 	movabs $0x800866,%rax
  801cff:	00 00 00 
  801d02:	ff d0                	callq  *%rax
	return 0;
  801d04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d09:	c9                   	leaveq 
  801d0a:	c3                   	retq   

0000000000801d0b <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  801d0b:	55                   	push   %rbp
  801d0c:	48 89 e5             	mov    %rsp,%rbp
  801d0f:	48 83 ec 20          	sub    $0x20,%rsp
  801d13:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801d17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d1e:	eb 62                	jmp    801d82 <file_flush+0x77>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801d20:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d23:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801d27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d2b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d30:	48 89 c7             	mov    %rax,%rdi
  801d33:	48 b8 b3 10 80 00 00 	movabs $0x8010b3,%rax
  801d3a:	00 00 00 
  801d3d:	ff d0                	callq  *%rax
  801d3f:	85 c0                	test   %eax,%eax
  801d41:	78 13                	js     801d56 <file_flush+0x4b>
		    pdiskbno == NULL || *pdiskbno == 0)
  801d43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801d47:	48 85 c0             	test   %rax,%rax
  801d4a:	74 0a                	je     801d56 <file_flush+0x4b>
		    pdiskbno == NULL || *pdiskbno == 0)
  801d4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d50:	8b 00                	mov    (%rax),%eax
  801d52:	85 c0                	test   %eax,%eax
  801d54:	75 02                	jne    801d58 <file_flush+0x4d>
			continue;
  801d56:	eb 26                	jmp    801d7e <file_flush+0x73>
		flush_block(diskaddr(*pdiskbno));
  801d58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d5c:	8b 00                	mov    (%rax),%eax
  801d5e:	89 c0                	mov    %eax,%eax
  801d60:	48 89 c7             	mov    %rax,%rdi
  801d63:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  801d6a:	00 00 00 
  801d6d:	ff d0                	callq  *%rax
  801d6f:	48 89 c7             	mov    %rax,%rdi
  801d72:	48 b8 66 08 80 00 00 	movabs $0x800866,%rax
  801d79:	00 00 00 
  801d7c:	ff d0                	callq  *%rax
file_flush(struct File *f)
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801d7e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d86:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801d8c:	05 ff 0f 00 00       	add    $0xfff,%eax
  801d91:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801d97:	85 c0                	test   %eax,%eax
  801d99:	0f 48 c2             	cmovs  %edx,%eax
  801d9c:	c1 f8 0c             	sar    $0xc,%eax
  801d9f:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  801da2:	0f 8f 78 ff ff ff    	jg     801d20 <file_flush+0x15>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
  801da8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dac:	48 89 c7             	mov    %rax,%rdi
  801daf:	48 b8 66 08 80 00 00 	movabs $0x800866,%rax
  801db6:	00 00 00 
  801db9:	ff d0                	callq  *%rax
	if (f->f_indirect)
  801dbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dbf:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801dc5:	85 c0                	test   %eax,%eax
  801dc7:	74 2a                	je     801df3 <file_flush+0xe8>
		flush_block(diskaddr(f->f_indirect));
  801dc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dcd:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801dd3:	89 c0                	mov    %eax,%eax
  801dd5:	48 89 c7             	mov    %rax,%rdi
  801dd8:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  801ddf:	00 00 00 
  801de2:	ff d0                	callq  *%rax
  801de4:	48 89 c7             	mov    %rax,%rdi
  801de7:	48 b8 66 08 80 00 00 	movabs $0x800866,%rax
  801dee:	00 00 00 
  801df1:	ff d0                	callq  *%rax
}
  801df3:	c9                   	leaveq 
  801df4:	c3                   	retq   

0000000000801df5 <file_remove>:

// Remove a file by truncating it and then zeroing the name.
int
file_remove(const char *path)
{
  801df5:	55                   	push   %rbp
  801df6:	48 89 e5             	mov    %rsp,%rbp
  801df9:	48 83 ec 20          	sub    $0x20,%rsp
  801dfd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;
	struct File *f;

	if ((r = walk_path(path, 0, &f, 0)) < 0)
  801e01:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e09:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e0e:	be 00 00 00 00       	mov    $0x0,%esi
  801e13:	48 89 c7             	mov    %rax,%rdi
  801e16:	48 b8 4a 15 80 00 00 	movabs $0x80154a,%rax
  801e1d:	00 00 00 
  801e20:	ff d0                	callq  *%rax
  801e22:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e29:	79 05                	jns    801e30 <file_remove+0x3b>
		return r;
  801e2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e2e:	eb 45                	jmp    801e75 <file_remove+0x80>

	file_truncate_blocks(f, 0);
  801e30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e34:	be 00 00 00 00       	mov    $0x0,%esi
  801e39:	48 89 c7             	mov    %rax,%rdi
  801e3c:	48 b8 d5 1b 80 00 00 	movabs $0x801bd5,%rax
  801e43:	00 00 00 
  801e46:	ff d0                	callq  *%rax
	f->f_name[0] = '\0';
  801e48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e4c:	c6 00 00             	movb   $0x0,(%rax)
	f->f_size = 0;
  801e4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e53:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  801e5a:	00 00 00 
	flush_block(f);
  801e5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e61:	48 89 c7             	mov    %rax,%rdi
  801e64:	48 b8 66 08 80 00 00 	movabs $0x800866,%rax
  801e6b:	00 00 00 
  801e6e:	ff d0                	callq  *%rax

	return 0;
  801e70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e75:	c9                   	leaveq 
  801e76:	c3                   	retq   

0000000000801e77 <fs_sync>:

// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  801e77:	55                   	push   %rbp
  801e78:	48 89 e5             	mov    %rsp,%rbp
  801e7b:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801e7f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  801e86:	eb 27                	jmp    801eaf <fs_sync+0x38>
		flush_block(diskaddr(i));
  801e88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e8b:	48 98                	cltq   
  801e8d:	48 89 c7             	mov    %rax,%rdi
  801e90:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  801e97:	00 00 00 
  801e9a:	ff d0                	callq  *%rax
  801e9c:	48 89 c7             	mov    %rax,%rdi
  801e9f:	48 b8 66 08 80 00 00 	movabs $0x800866,%rax
  801ea6:	00 00 00 
  801ea9:	ff d0                	callq  *%rax
// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801eab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801eaf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801eb2:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  801eb9:	00 00 00 
  801ebc:	48 8b 00             	mov    (%rax),%rax
  801ebf:	8b 40 04             	mov    0x4(%rax),%eax
  801ec2:	39 c2                	cmp    %eax,%edx
  801ec4:	72 c2                	jb     801e88 <fs_sync+0x11>
		flush_block(diskaddr(i));
}
  801ec6:	c9                   	leaveq 
  801ec7:	c3                   	retq   

0000000000801ec8 <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  801ec8:	55                   	push   %rbp
  801ec9:	48 89 e5             	mov    %rsp,%rbp
  801ecc:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	uintptr_t va = FILEVA;
  801ed0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
  801ed5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < MAXOPEN; i++) {
  801ed9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ee0:	eb 4b                	jmp    801f2d <serve_init+0x65>
		opentab[i].o_fileid = i;
  801ee2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ee5:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  801eec:	00 00 00 
  801eef:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801ef2:	48 63 c9             	movslq %ecx,%rcx
  801ef5:	48 c1 e1 05          	shl    $0x5,%rcx
  801ef9:	48 01 ca             	add    %rcx,%rdx
  801efc:	89 02                	mov    %eax,(%rdx)
		opentab[i].o_fd = (struct Fd*) va;
  801efe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f02:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  801f09:	00 00 00 
  801f0c:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801f0f:	48 63 c9             	movslq %ecx,%rcx
  801f12:	48 c1 e1 05          	shl    $0x5,%rcx
  801f16:	48 01 ca             	add    %rcx,%rdx
  801f19:	48 83 c2 10          	add    $0x10,%rdx
  801f1d:	48 89 42 08          	mov    %rax,0x8(%rdx)
		va += PGSIZE;
  801f21:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
  801f28:	00 
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  801f29:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f2d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  801f34:	7e ac                	jle    801ee2 <serve_init+0x1a>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  801f36:	c9                   	leaveq 
  801f37:	c3                   	retq   

0000000000801f38 <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  801f38:	55                   	push   %rbp
  801f39:	48 89 e5             	mov    %rsp,%rbp
  801f3c:	48 83 ec 20          	sub    $0x20,%rsp
  801f40:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  801f44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f4b:	e9 24 01 00 00       	jmpq   802074 <openfile_alloc+0x13c>
		switch (pageref(opentab[i].o_fd)) {
  801f50:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  801f57:	00 00 00 
  801f5a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f5d:	48 63 d2             	movslq %edx,%rdx
  801f60:	48 c1 e2 05          	shl    $0x5,%rdx
  801f64:	48 01 d0             	add    %rdx,%rax
  801f67:	48 83 c0 10          	add    $0x10,%rax
  801f6b:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f6f:	48 89 c7             	mov    %rax,%rdi
  801f72:	48 b8 49 5c 80 00 00 	movabs $0x805c49,%rax
  801f79:	00 00 00 
  801f7c:	ff d0                	callq  *%rax
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	74 0a                	je     801f8c <openfile_alloc+0x54>
  801f82:	83 f8 01             	cmp    $0x1,%eax
  801f85:	74 4e                	je     801fd5 <openfile_alloc+0x9d>
  801f87:	e9 e4 00 00 00       	jmpq   802070 <openfile_alloc+0x138>
		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  801f8c:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  801f93:	00 00 00 
  801f96:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f99:	48 63 d2             	movslq %edx,%rdx
  801f9c:	48 c1 e2 05          	shl    $0x5,%rdx
  801fa0:	48 01 d0             	add    %rdx,%rax
  801fa3:	48 83 c0 10          	add    $0x10,%rax
  801fa7:	48 8b 40 08          	mov    0x8(%rax),%rax
  801fab:	ba 07 00 00 00       	mov    $0x7,%edx
  801fb0:	48 89 c6             	mov    %rax,%rsi
  801fb3:	bf 00 00 00 00       	mov    $0x0,%edi
  801fb8:	48 b8 89 48 80 00 00 	movabs $0x804889,%rax
  801fbf:	00 00 00 
  801fc2:	ff d0                	callq  *%rax
  801fc4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801fc7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801fcb:	79 08                	jns    801fd5 <openfile_alloc+0x9d>
				return r;
  801fcd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fd0:	e9 b1 00 00 00       	jmpq   802086 <openfile_alloc+0x14e>
			/* fall through */
		case 1:
			opentab[i].o_fileid += MAXOPEN;
  801fd5:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  801fdc:	00 00 00 
  801fdf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fe2:	48 63 d2             	movslq %edx,%rdx
  801fe5:	48 c1 e2 05          	shl    $0x5,%rdx
  801fe9:	48 01 d0             	add    %rdx,%rax
  801fec:	8b 00                	mov    (%rax),%eax
  801fee:	8d 90 00 04 00 00    	lea    0x400(%rax),%edx
  801ff4:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  801ffb:	00 00 00 
  801ffe:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802001:	48 63 c9             	movslq %ecx,%rcx
  802004:	48 c1 e1 05          	shl    $0x5,%rcx
  802008:	48 01 c8             	add    %rcx,%rax
  80200b:	89 10                	mov    %edx,(%rax)
			*o = &opentab[i];
  80200d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802010:	48 98                	cltq   
  802012:	48 c1 e0 05          	shl    $0x5,%rax
  802016:	48 89 c2             	mov    %rax,%rdx
  802019:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802020:	00 00 00 
  802023:	48 01 c2             	add    %rax,%rdx
  802026:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80202a:	48 89 10             	mov    %rdx,(%rax)
			memset(opentab[i].o_fd, 0, PGSIZE);
  80202d:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802034:	00 00 00 
  802037:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80203a:	48 63 d2             	movslq %edx,%rdx
  80203d:	48 c1 e2 05          	shl    $0x5,%rdx
  802041:	48 01 d0             	add    %rdx,%rax
  802044:	48 83 c0 10          	add    $0x10,%rax
  802048:	48 8b 40 08          	mov    0x8(%rax),%rax
  80204c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802051:	be 00 00 00 00       	mov    $0x0,%esi
  802056:	48 89 c7             	mov    %rax,%rdi
  802059:	48 b8 f3 41 80 00 00 	movabs $0x8041f3,%rax
  802060:	00 00 00 
  802063:	ff d0                	callq  *%rax
			return (*o)->o_fileid;
  802065:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802069:	48 8b 00             	mov    (%rax),%rax
  80206c:	8b 00                	mov    (%rax),%eax
  80206e:	eb 16                	jmp    802086 <openfile_alloc+0x14e>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  802070:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802074:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80207b:	0f 8e cf fe ff ff    	jle    801f50 <openfile_alloc+0x18>
			memset(opentab[i].o_fd, 0, PGSIZE);
			return (*o)->o_fileid;
		}
	}
	//cprintf("am I returning from here ????");
	return -E_MAX_OPEN;
  802081:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802086:	c9                   	leaveq 
  802087:	c3                   	retq   

0000000000802088 <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  802088:	55                   	push   %rbp
  802089:	48 89 e5             	mov    %rsp,%rbp
  80208c:	48 83 ec 20          	sub    $0x20,%rsp
  802090:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802093:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802096:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  80209a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80209d:	25 ff 03 00 00       	and    $0x3ff,%eax
  8020a2:	89 c0                	mov    %eax,%eax
  8020a4:	48 c1 e0 05          	shl    $0x5,%rax
  8020a8:	48 89 c2             	mov    %rax,%rdx
  8020ab:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8020b2:	00 00 00 
  8020b5:	48 01 d0             	add    %rdx,%rax
  8020b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
  8020bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020c0:	48 8b 40 18          	mov    0x18(%rax),%rax
  8020c4:	48 89 c7             	mov    %rax,%rdi
  8020c7:	48 b8 49 5c 80 00 00 	movabs $0x805c49,%rax
  8020ce:	00 00 00 
  8020d1:	ff d0                	callq  *%rax
  8020d3:	83 f8 01             	cmp    $0x1,%eax
  8020d6:	74 0b                	je     8020e3 <openfile_lookup+0x5b>
  8020d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020dc:	8b 00                	mov    (%rax),%eax
  8020de:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8020e1:	74 07                	je     8020ea <openfile_lookup+0x62>
		return -E_INVAL;
  8020e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020e8:	eb 10                	jmp    8020fa <openfile_lookup+0x72>
	*po = o;
  8020ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8020f2:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8020f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020fa:	c9                   	leaveq 
  8020fb:	c3                   	retq   

00000000008020fc <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  8020fc:	55                   	push   %rbp
  8020fd:	48 89 e5             	mov    %rsp,%rbp
  802100:	48 81 ec 40 04 00 00 	sub    $0x440,%rsp
  802107:	89 bd dc fb ff ff    	mov    %edi,-0x424(%rbp)
  80210d:	48 89 b5 d0 fb ff ff 	mov    %rsi,-0x430(%rbp)
  802114:	48 89 95 c8 fb ff ff 	mov    %rdx,-0x438(%rbp)
  80211b:	48 89 8d c0 fb ff ff 	mov    %rcx,-0x440(%rbp)

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  802122:	48 8b 8d d0 fb ff ff 	mov    -0x430(%rbp),%rcx
  802129:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  802130:	ba 00 04 00 00       	mov    $0x400,%edx
  802135:	48 89 ce             	mov    %rcx,%rsi
  802138:	48 89 c7             	mov    %rax,%rdi
  80213b:	48 b8 7e 42 80 00 00 	movabs $0x80427e,%rax
  802142:	00 00 00 
  802145:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  802147:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  80214b:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  802152:	48 89 c7             	mov    %rax,%rdi
  802155:	48 b8 38 1f 80 00 00 	movabs $0x801f38,%rax
  80215c:	00 00 00 
  80215f:	ff d0                	callq  *%rax
  802161:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802164:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802168:	79 08                	jns    802172 <serve_open+0x76>
		if (debug)
			cprintf("openfile_alloc failed: %e", r);
		return r;
  80216a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80216d:	e9 7c 01 00 00       	jmpq   8022ee <serve_open+0x1f2>
	}
	fileid = r;
  802172:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802175:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// Open the file
	if (req->req_omode & O_CREAT) {
  802178:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  80217f:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  802185:	25 00 01 00 00       	and    $0x100,%eax
  80218a:	85 c0                	test   %eax,%eax
  80218c:	74 4f                	je     8021dd <serve_open+0xe1>
		if ((r = file_create(path, &f)) < 0) {
  80218e:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  802195:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  80219c:	48 89 d6             	mov    %rdx,%rsi
  80219f:	48 89 c7             	mov    %rax,%rdi
  8021a2:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  8021a9:	00 00 00 
  8021ac:	ff d0                	callq  *%rax
  8021ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021b5:	79 57                	jns    80220e <serve_open+0x112>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  8021b7:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  8021be:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  8021c4:	25 00 04 00 00       	and    $0x400,%eax
  8021c9:	85 c0                	test   %eax,%eax
  8021cb:	75 08                	jne    8021d5 <serve_open+0xd9>
  8021cd:	83 7d fc f2          	cmpl   $0xfffffff2,-0x4(%rbp)
  8021d1:	75 02                	jne    8021d5 <serve_open+0xd9>
				goto try_open;
  8021d3:	eb 08                	jmp    8021dd <serve_open+0xe1>
			if (debug)
				cprintf("file_create failed: %e", r);
			return r;
  8021d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021d8:	e9 11 01 00 00       	jmpq   8022ee <serve_open+0x1f2>
		}
	} else {
try_open:
		if ((r = file_open(path, &f)) < 0) {
  8021dd:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  8021e4:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  8021eb:	48 89 d6             	mov    %rdx,%rsi
  8021ee:	48 89 c7             	mov    %rax,%rdi
  8021f1:	48 b8 7f 18 80 00 00 	movabs $0x80187f,%rax
  8021f8:	00 00 00 
  8021fb:	ff d0                	callq  *%rax
  8021fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802200:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802204:	79 08                	jns    80220e <serve_open+0x112>
			if (debug)
				cprintf("file_open failed: %e", r);
			return r;
  802206:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802209:	e9 e0 00 00 00       	jmpq   8022ee <serve_open+0x1f2>
		}
	}

	// Truncate
	if (req->req_omode & O_TRUNC) {
  80220e:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  802215:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  80221b:	25 00 02 00 00       	and    $0x200,%eax
  802220:	85 c0                	test   %eax,%eax
  802222:	74 2c                	je     802250 <serve_open+0x154>
		if ((r = file_set_size(f, 0)) < 0) {
  802224:	48 8b 85 e8 fb ff ff 	mov    -0x418(%rbp),%rax
  80222b:	be 00 00 00 00       	mov    $0x0,%esi
  802230:	48 89 c7             	mov    %rax,%rdi
  802233:	48 b8 ae 1c 80 00 00 	movabs $0x801cae,%rax
  80223a:	00 00 00 
  80223d:	ff d0                	callq  *%rax
  80223f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802242:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802246:	79 08                	jns    802250 <serve_open+0x154>
			if (debug)
				cprintf("file_set_size failed: %e", r);
			return r;
  802248:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80224b:	e9 9e 00 00 00       	jmpq   8022ee <serve_open+0x1f2>
		}
	}

	// Save the file pointer
	o->o_file = f;
  802250:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802257:	48 8b 95 e8 fb ff ff 	mov    -0x418(%rbp),%rdx
  80225e:	48 89 50 08          	mov    %rdx,0x8(%rax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  802262:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802269:	48 8b 40 18          	mov    0x18(%rax),%rax
  80226d:	48 8b 95 e0 fb ff ff 	mov    -0x420(%rbp),%rdx
  802274:	8b 12                	mov    (%rdx),%edx
  802276:	89 50 0c             	mov    %edx,0xc(%rax)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  802279:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802280:	48 8b 40 18          	mov    0x18(%rax),%rax
  802284:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  80228b:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  802291:	83 e2 03             	and    $0x3,%edx
  802294:	89 50 08             	mov    %edx,0x8(%rax)
	o->o_fd->fd_dev_id = devfile.dev_id;
  802297:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  80229e:	48 8b 40 18          	mov    0x18(%rax),%rax
  8022a2:	48 ba c0 10 81 00 00 	movabs $0x8110c0,%rdx
  8022a9:	00 00 00 
  8022ac:	8b 12                	mov    (%rdx),%edx
  8022ae:	89 10                	mov    %edx,(%rax)
	o->o_mode = req->req_omode;
  8022b0:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8022b7:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  8022be:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  8022c4:	89 50 10             	mov    %edx,0x10(%rax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  8022c7:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8022ce:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8022d2:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  8022d9:	48 89 10             	mov    %rdx,(%rax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  8022dc:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  8022e3:	c7 00 07 04 00 00    	movl   $0x407,(%rax)

	return 0;
  8022e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ee:	c9                   	leaveq 
  8022ef:	c3                   	retq   

00000000008022f0 <serve_set_size>:

// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
  8022f0:	55                   	push   %rbp
  8022f1:	48 89 e5             	mov    %rsp,%rbp
  8022f4:	48 83 ec 20          	sub    $0x20,%rsp
  8022f8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022fb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8022ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802303:	8b 00                	mov    (%rax),%eax
  802305:	89 c1                	mov    %eax,%ecx
  802307:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80230b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80230e:	89 ce                	mov    %ecx,%esi
  802310:	89 c7                	mov    %eax,%edi
  802312:	48 b8 88 20 80 00 00 	movabs $0x802088,%rax
  802319:	00 00 00 
  80231c:	ff d0                	callq  *%rax
  80231e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802321:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802325:	79 05                	jns    80232c <serve_set_size+0x3c>
		return r;
  802327:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80232a:	eb 20                	jmp    80234c <serve_set_size+0x5c>

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
  80232c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802330:	8b 50 04             	mov    0x4(%rax),%edx
  802333:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802337:	48 8b 40 08          	mov    0x8(%rax),%rax
  80233b:	89 d6                	mov    %edx,%esi
  80233d:	48 89 c7             	mov    %rax,%rdi
  802340:	48 b8 ae 1c 80 00 00 	movabs $0x801cae,%rax
  802347:	00 00 00 
  80234a:	ff d0                	callq  *%rax
}
  80234c:	c9                   	leaveq 
  80234d:	c3                   	retq   

000000000080234e <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  80234e:	55                   	push   %rbp
  80234f:	48 89 e5             	mov    %rsp,%rbp
  802352:	48 83 ec 30          	sub    $0x30,%rsp
  802356:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802359:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r = -1;
  80235d:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!ipc)
  802364:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  802369:	75 08                	jne    802373 <serve_read+0x25>
		return r; 
  80236b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80236e:	e9 e0 00 00 00       	jmpq   802453 <serve_read+0x105>
	struct Fsreq_read *req = &ipc->read;
  802373:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802377:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	struct Fsret_read *ret = &ipc->readRet;
  80237b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80237f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	// (remember that read is always allowed to return fewer bytes
	// than requested).  Also, be careful because ipc is a union,
	// so filling in ret will overwrite req.
	//
	// LAB 5: Your code here
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802383:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802387:	8b 00                	mov    (%rax),%eax
  802389:	89 c1                	mov    %eax,%ecx
  80238b:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80238f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802392:	89 ce                	mov    %ecx,%esi
  802394:	89 c7                	mov    %eax,%edi
  802396:	48 b8 88 20 80 00 00 	movabs $0x802088,%rax
  80239d:	00 00 00 
  8023a0:	ff d0                	callq  *%rax
  8023a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023a9:	79 08                	jns    8023b3 <serve_read+0x65>
		return r;
  8023ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ae:	e9 a0 00 00 00       	jmpq   802453 <serve_read+0x105>

	if(!o || !o->o_file || !o->o_fd)
  8023b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023b7:	48 85 c0             	test   %rax,%rax
  8023ba:	74 1a                	je     8023d6 <serve_read+0x88>
  8023bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023c0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8023c4:	48 85 c0             	test   %rax,%rax
  8023c7:	74 0d                	je     8023d6 <serve_read+0x88>
  8023c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023cd:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023d1:	48 85 c0             	test   %rax,%rax
  8023d4:	75 07                	jne    8023dd <serve_read+0x8f>
	{
		return -1;
  8023d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8023db:	eb 76                	jmp    802453 <serve_read+0x105>
	}
	if(req->req_n > PGSIZE)
  8023dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023e1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8023e5:	48 3d 00 10 00 00    	cmp    $0x1000,%rax
  8023eb:	76 0c                	jbe    8023f9 <serve_read+0xab>
	{
		req->req_n = PGSIZE;
  8023ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023f1:	48 c7 40 08 00 10 00 	movq   $0x1000,0x8(%rax)
  8023f8:	00 
	}
	
	if ((r = file_read(o->o_file, ret->ret_buf, req->req_n, o->o_fd->fd_offset)) <= 0) {
  8023f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023fd:	48 8b 40 18          	mov    0x18(%rax),%rax
  802401:	8b 48 04             	mov    0x4(%rax),%ecx
  802404:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802408:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80240c:	48 8b 75 e8          	mov    -0x18(%rbp),%rsi
  802410:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802414:	48 8b 40 08          	mov    0x8(%rax),%rax
  802418:	48 89 c7             	mov    %rax,%rdi
  80241b:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  802422:	00 00 00 
  802425:	ff d0                	callq  *%rax
  802427:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80242a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80242e:	7f 05                	jg     802435 <serve_read+0xe7>
		if (debug)
		cprintf("file_read failed: %e", r);
		return r;
  802430:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802433:	eb 1e                	jmp    802453 <serve_read+0x105>
	}
	//cprintf("server in serve_read()  is [%d]  %x %x %x %x\n",r,ret->ret_buf[0], ret->ret_buf[1], ret->ret_buf[2], ret->ret_buf[3]);
	o->o_fd->fd_offset += r;
  802435:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802439:	48 8b 40 18          	mov    0x18(%rax),%rax
  80243d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802441:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  802445:	8b 4a 04             	mov    0x4(%rdx),%ecx
  802448:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80244b:	01 ca                	add    %ecx,%edx
  80244d:	89 50 04             	mov    %edx,0x4(%rax)
	
	return r;
  802450:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("serve_read not implemented");
}
  802453:	c9                   	leaveq 
  802454:	c3                   	retq   

0000000000802455 <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  802455:	55                   	push   %rbp
  802456:	48 89 e5             	mov    %rsp,%rbp
  802459:	48 83 ec 20          	sub    $0x20,%rsp
  80245d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802460:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r = -1;
  802464:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!req)
  80246b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802470:	75 08                	jne    80247a <serve_write+0x25>
		return r;
  802472:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802475:	e9 d8 00 00 00       	jmpq   802552 <serve_write+0xfd>

	if (debug)
		cprintf("serve_write %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// LAB 5: Your code here.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80247a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80247e:	8b 00                	mov    (%rax),%eax
  802480:	89 c1                	mov    %eax,%ecx
  802482:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802486:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802489:	89 ce                	mov    %ecx,%esi
  80248b:	89 c7                	mov    %eax,%edi
  80248d:	48 b8 88 20 80 00 00 	movabs $0x802088,%rax
  802494:	00 00 00 
  802497:	ff d0                	callq  *%rax
  802499:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80249c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a0:	79 08                	jns    8024aa <serve_write+0x55>
		return r;
  8024a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024a5:	e9 a8 00 00 00       	jmpq   802552 <serve_write+0xfd>

	if(!o || !o->o_file || !o->o_fd)
  8024aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ae:	48 85 c0             	test   %rax,%rax
  8024b1:	74 1a                	je     8024cd <serve_write+0x78>
  8024b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8024bb:	48 85 c0             	test   %rax,%rax
  8024be:	74 0d                	je     8024cd <serve_write+0x78>
  8024c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c4:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024c8:	48 85 c0             	test   %rax,%rax
  8024cb:	75 07                	jne    8024d4 <serve_write+0x7f>
		return -1;
  8024cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8024d2:	eb 7e                	jmp    802552 <serve_write+0xfd>
	
	if ((r = file_write(o->o_file, req->req_buf, req->req_n, o->o_fd->fd_offset)) < 0) {
  8024d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d8:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024dc:	8b 48 04             	mov    0x4(%rax),%ecx
  8024df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024e3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8024e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024eb:	48 8d 70 10          	lea    0x10(%rax),%rsi
  8024ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024f3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8024f7:	48 89 c7             	mov    %rax,%rdi
  8024fa:	48 b8 08 1a 80 00 00 	movabs $0x801a08,%rax
  802501:	00 00 00 
  802504:	ff d0                	callq  *%rax
  802506:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802509:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250d:	79 25                	jns    802534 <serve_write+0xdf>
		cprintf("file_write failed: %e", r);
  80250f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802512:	89 c6                	mov    %eax,%esi
  802514:	48 bf e8 68 80 00 00 	movabs $0x8068e8,%rdi
  80251b:	00 00 00 
  80251e:	b8 00 00 00 00       	mov    $0x0,%eax
  802523:	48 ba a5 33 80 00 00 	movabs $0x8033a5,%rdx
  80252a:	00 00 00 
  80252d:	ff d2                	callq  *%rdx
		return r;
  80252f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802532:	eb 1e                	jmp    802552 <serve_write+0xfd>
	}
	o->o_fd->fd_offset += r;
  802534:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802538:	48 8b 40 18          	mov    0x18(%rax),%rax
  80253c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802540:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  802544:	8b 4a 04             	mov    0x4(%rdx),%ecx
  802547:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80254a:	01 ca                	add    %ecx,%edx
  80254c:	89 50 04             	mov    %edx,0x4(%rax)
	
	return r;
  80254f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("serve_write not implemented");
}
  802552:	c9                   	leaveq 
  802553:	c3                   	retq   

0000000000802554 <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  802554:	55                   	push   %rbp
  802555:	48 89 e5             	mov    %rsp,%rbp
  802558:	48 83 ec 30          	sub    $0x30,%rsp
  80255c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80255f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	struct Fsreq_stat *req = &ipc->stat;
  802563:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802567:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Fsret_stat *ret = &ipc->statRet;
  80256b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80256f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802573:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802577:	8b 00                	mov    (%rax),%eax
  802579:	89 c1                	mov    %eax,%ecx
  80257b:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80257f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802582:	89 ce                	mov    %ecx,%esi
  802584:	89 c7                	mov    %eax,%edi
  802586:	48 b8 88 20 80 00 00 	movabs $0x802088,%rax
  80258d:	00 00 00 
  802590:	ff d0                	callq  *%rax
  802592:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802595:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802599:	79 05                	jns    8025a0 <serve_stat+0x4c>
		return r;
  80259b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80259e:	eb 5f                	jmp    8025ff <serve_stat+0xab>

	strcpy(ret->ret_name, o->o_file->f_name);
  8025a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025a4:	48 8b 40 08          	mov    0x8(%rax),%rax
  8025a8:	48 89 c2             	mov    %rax,%rdx
  8025ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025af:	48 89 d6             	mov    %rdx,%rsi
  8025b2:	48 89 c7             	mov    %rax,%rdi
  8025b5:	48 b8 5a 3f 80 00 00 	movabs $0x803f5a,%rax
  8025bc:	00 00 00 
  8025bf:	ff d0                	callq  *%rax
	ret->ret_size = o->o_file->f_size;
  8025c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025c5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8025c9:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8025cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  8025d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025dd:	48 8b 40 08          	mov    0x8(%rax),%rax
  8025e1:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  8025e7:	83 f8 01             	cmp    $0x1,%eax
  8025ea:	0f 94 c0             	sete   %al
  8025ed:	0f b6 d0             	movzbl %al,%edx
  8025f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f4:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8025fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ff:	c9                   	leaveq 
  802600:	c3                   	retq   

0000000000802601 <serve_flush>:

// Flush all data and metadata of req->req_fileid to disk.
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  802601:	55                   	push   %rbp
  802602:	48 89 e5             	mov    %rsp,%rbp
  802605:	48 83 ec 20          	sub    $0x20,%rsp
  802609:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80260c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (debug)
		cprintf("serve_flush %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802610:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802614:	8b 00                	mov    (%rax),%eax
  802616:	89 c1                	mov    %eax,%ecx
  802618:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80261c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80261f:	89 ce                	mov    %ecx,%esi
  802621:	89 c7                	mov    %eax,%edi
  802623:	48 b8 88 20 80 00 00 	movabs $0x802088,%rax
  80262a:	00 00 00 
  80262d:	ff d0                	callq  *%rax
  80262f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802632:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802636:	79 05                	jns    80263d <serve_flush+0x3c>
		return r;
  802638:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80263b:	eb 1c                	jmp    802659 <serve_flush+0x58>
	file_flush(o->o_file);
  80263d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802641:	48 8b 40 08          	mov    0x8(%rax),%rax
  802645:	48 89 c7             	mov    %rax,%rdi
  802648:	48 b8 0b 1d 80 00 00 	movabs $0x801d0b,%rax
  80264f:	00 00 00 
  802652:	ff d0                	callq  *%rax
	return 0;
  802654:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802659:	c9                   	leaveq 
  80265a:	c3                   	retq   

000000000080265b <serve_remove>:

// Remove the file req->req_path.
int
serve_remove(envid_t envid, struct Fsreq_remove *req)
{
  80265b:	55                   	push   %rbp
  80265c:	48 89 e5             	mov    %rsp,%rbp
  80265f:	48 81 ec 10 04 00 00 	sub    $0x410,%rsp
  802666:	89 bd fc fb ff ff    	mov    %edi,-0x404(%rbp)
  80266c:	48 89 b5 f0 fb ff ff 	mov    %rsi,-0x410(%rbp)

	// Delete the named file.
	// Note: This request doesn't refer to an open file.

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  802673:	48 8b 8d f0 fb ff ff 	mov    -0x410(%rbp),%rcx
  80267a:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  802681:	ba 00 04 00 00       	mov    $0x400,%edx
  802686:	48 89 ce             	mov    %rcx,%rsi
  802689:	48 89 c7             	mov    %rax,%rdi
  80268c:	48 b8 7e 42 80 00 00 	movabs $0x80427e,%rax
  802693:	00 00 00 
  802696:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  802698:	c6 45 ff 00          	movb   $0x0,-0x1(%rbp)

	// Delete the specified file
	return file_remove(path);
  80269c:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  8026a3:	48 89 c7             	mov    %rax,%rdi
  8026a6:	48 b8 f5 1d 80 00 00 	movabs $0x801df5,%rax
  8026ad:	00 00 00 
  8026b0:	ff d0                	callq  *%rax
}
  8026b2:	c9                   	leaveq 
  8026b3:	c3                   	retq   

00000000008026b4 <serve_sync>:

// Sync the file system.
int
serve_sync(envid_t envid, union Fsipc *req)
{
  8026b4:	55                   	push   %rbp
  8026b5:	48 89 e5             	mov    %rsp,%rbp
  8026b8:	48 83 ec 10          	sub    $0x10,%rsp
  8026bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	fs_sync();
  8026c3:	48 b8 77 1e 80 00 00 	movabs $0x801e77,%rax
  8026ca:	00 00 00 
  8026cd:	ff d0                	callq  *%rax
	return 0;
  8026cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026d4:	c9                   	leaveq 
  8026d5:	c3                   	retq   

00000000008026d6 <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  8026d6:	55                   	push   %rbp
  8026d7:	48 89 e5             	mov    %rsp,%rbp
  8026da:	48 83 ec 20          	sub    $0x20,%rsp
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  8026de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8026e5:	48 b8 20 10 81 00 00 	movabs $0x811020,%rax
  8026ec:	00 00 00 
  8026ef:	48 8b 08             	mov    (%rax),%rcx
  8026f2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026f6:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
  8026fa:	48 89 ce             	mov    %rcx,%rsi
  8026fd:	48 89 c7             	mov    %rax,%rdi
  802700:	48 b8 36 4c 80 00 00 	movabs $0x804c36,%rax
  802707:	00 00 00 
  80270a:	ff d0                	callq  *%rax
  80270c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  80270f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802712:	83 e0 01             	and    $0x1,%eax
  802715:	85 c0                	test   %eax,%eax
  802717:	75 23                	jne    80273c <serve+0x66>
			cprintf("Invalid request from %08x: no argument page\n",
  802719:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80271c:	89 c6                	mov    %eax,%esi
  80271e:	48 bf 00 69 80 00 00 	movabs $0x806900,%rdi
  802725:	00 00 00 
  802728:	b8 00 00 00 00       	mov    $0x0,%eax
  80272d:	48 ba a5 33 80 00 00 	movabs $0x8033a5,%rdx
  802734:	00 00 00 
  802737:	ff d2                	callq  *%rdx
				whom);
			continue; // just leave it hanging...
  802739:	90                   	nop
			cprintf("Invalid request code %d from %08x\n", req, whom);
			r = -E_INVAL;
		}
		ipc_send(whom, r, pg, perm);
		sys_page_unmap(0, fsreq);
	}
  80273a:	eb a2                	jmp    8026de <serve+0x8>
			cprintf("Invalid request from %08x: no argument page\n",
				whom);
			continue; // just leave it hanging...
		}

		pg = NULL;
  80273c:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802743:	00 
		if (req == FSREQ_OPEN) {
  802744:	83 7d f8 01          	cmpl   $0x1,-0x8(%rbp)
  802748:	75 2b                	jne    802775 <serve+0x9f>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  80274a:	48 b8 20 10 81 00 00 	movabs $0x811020,%rax
  802751:	00 00 00 
  802754:	48 8b 30             	mov    (%rax),%rsi
  802757:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80275a:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  80275e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802762:	89 c7                	mov    %eax,%edi
  802764:	48 b8 fc 20 80 00 00 	movabs $0x8020fc,%rax
  80276b:	00 00 00 
  80276e:	ff d0                	callq  *%rax
  802770:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802773:	eb 73                	jmp    8027e8 <serve+0x112>
		} else if (req < NHANDLERS && handlers[req]) {
  802775:	83 7d f8 08          	cmpl   $0x8,-0x8(%rbp)
  802779:	77 43                	ja     8027be <serve+0xe8>
  80277b:	48 b8 40 10 81 00 00 	movabs $0x811040,%rax
  802782:	00 00 00 
  802785:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802788:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80278c:	48 85 c0             	test   %rax,%rax
  80278f:	74 2d                	je     8027be <serve+0xe8>
			r = handlers[req](whom, fsreq);
  802791:	48 b8 40 10 81 00 00 	movabs $0x811040,%rax
  802798:	00 00 00 
  80279b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80279e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027a2:	48 ba 20 10 81 00 00 	movabs $0x811020,%rdx
  8027a9:	00 00 00 
  8027ac:	48 8b 0a             	mov    (%rdx),%rcx
  8027af:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8027b2:	48 89 ce             	mov    %rcx,%rsi
  8027b5:	89 d7                	mov    %edx,%edi
  8027b7:	ff d0                	callq  *%rax
  8027b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027bc:	eb 2a                	jmp    8027e8 <serve+0x112>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  8027be:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8027c1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027c4:	89 c6                	mov    %eax,%esi
  8027c6:	48 bf 30 69 80 00 00 	movabs $0x806930,%rdi
  8027cd:	00 00 00 
  8027d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d5:	48 b9 a5 33 80 00 00 	movabs $0x8033a5,%rcx
  8027dc:	00 00 00 
  8027df:	ff d1                	callq  *%rcx
			r = -E_INVAL;
  8027e1:	c7 45 fc fd ff ff ff 	movl   $0xfffffffd,-0x4(%rbp)
		}
		ipc_send(whom, r, pg, perm);
  8027e8:	8b 4d f0             	mov    -0x10(%rbp),%ecx
  8027eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027ef:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8027f2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8027f5:	89 c7                	mov    %eax,%edi
  8027f7:	48 b8 3c 4d 80 00 00 	movabs $0x804d3c,%rax
  8027fe:	00 00 00 
  802801:	ff d0                	callq  *%rax
		sys_page_unmap(0, fsreq);
  802803:	48 b8 20 10 81 00 00 	movabs $0x811020,%rax
  80280a:	00 00 00 
  80280d:	48 8b 00             	mov    (%rax),%rax
  802810:	48 89 c6             	mov    %rax,%rsi
  802813:	bf 00 00 00 00       	mov    $0x0,%edi
  802818:	48 b8 34 49 80 00 00 	movabs $0x804934,%rax
  80281f:	00 00 00 
  802822:	ff d0                	callq  *%rax
	}
  802824:	e9 b5 fe ff ff       	jmpq   8026de <serve+0x8>

0000000000802829 <umain>:
}

void
umain(int argc, char **argv)
{
  802829:	55                   	push   %rbp
  80282a:	48 89 e5             	mov    %rsp,%rbp
  80282d:	48 83 ec 20          	sub    $0x20,%rsp
  802831:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802834:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  802838:	48 b8 90 10 81 00 00 	movabs $0x811090,%rax
  80283f:	00 00 00 
  802842:	48 b9 53 69 80 00 00 	movabs $0x806953,%rcx
  802849:	00 00 00 
  80284c:	48 89 08             	mov    %rcx,(%rax)
	cprintf("FS is running\n");
  80284f:	48 bf 56 69 80 00 00 	movabs $0x806956,%rdi
  802856:	00 00 00 
  802859:	b8 00 00 00 00       	mov    $0x0,%eax
  80285e:	48 ba a5 33 80 00 00 	movabs $0x8033a5,%rdx
  802865:	00 00 00 
  802868:	ff d2                	callq  *%rdx
  80286a:	c7 45 fc 00 8a 00 00 	movl   $0x8a00,-0x4(%rbp)
  802871:	66 c7 45 fa 00 8a    	movw   $0x8a00,-0x6(%rbp)
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  802877:	0f b7 45 fa          	movzwl -0x6(%rbp),%eax
  80287b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80287e:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  802880:	48 bf 65 69 80 00 00 	movabs $0x806965,%rdi
  802887:	00 00 00 
  80288a:	b8 00 00 00 00       	mov    $0x0,%eax
  80288f:	48 ba a5 33 80 00 00 	movabs $0x8033a5,%rdx
  802896:	00 00 00 
  802899:	ff d2                	callq  *%rdx

	serve_init();
  80289b:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  8028a2:	00 00 00 
  8028a5:	ff d0                	callq  *%rax
	fs_init();
  8028a7:	48 b8 19 10 80 00 00 	movabs $0x801019,%rax
  8028ae:	00 00 00 
  8028b1:	ff d0                	callq  *%rax
	fs_test();
  8028b3:	48 b8 cd 28 80 00 00 	movabs $0x8028cd,%rax
  8028ba:	00 00 00 
  8028bd:	ff d0                	callq  *%rax
	serve();
  8028bf:	48 b8 d6 26 80 00 00 	movabs $0x8026d6,%rax
  8028c6:	00 00 00 
  8028c9:	ff d0                	callq  *%rax
}
  8028cb:	c9                   	leaveq 
  8028cc:	c3                   	retq   

00000000008028cd <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  8028cd:	55                   	push   %rbp
  8028ce:	48 89 e5             	mov    %rsp,%rbp
  8028d1:	48 83 ec 20          	sub    $0x20,%rsp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8028d5:	ba 07 00 00 00       	mov    $0x7,%edx
  8028da:	be 00 10 00 00       	mov    $0x1000,%esi
  8028df:	bf 00 00 00 00       	mov    $0x0,%edi
  8028e4:	48 b8 89 48 80 00 00 	movabs $0x804889,%rax
  8028eb:	00 00 00 
  8028ee:	ff d0                	callq  *%rax
  8028f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028f7:	79 30                	jns    802929 <fs_test+0x5c>
		panic("sys_page_alloc: %e", r);
  8028f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028fc:	89 c1                	mov    %eax,%ecx
  8028fe:	48 ba 9e 69 80 00 00 	movabs $0x80699e,%rdx
  802905:	00 00 00 
  802908:	be 13 00 00 00       	mov    $0x13,%esi
  80290d:	48 bf b1 69 80 00 00 	movabs $0x8069b1,%rdi
  802914:	00 00 00 
  802917:	b8 00 00 00 00       	mov    $0x0,%eax
  80291c:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  802923:	00 00 00 
  802926:	41 ff d0             	callq  *%r8
	bits = (uint32_t*) PGSIZE;
  802929:	48 c7 45 f0 00 10 00 	movq   $0x1000,-0x10(%rbp)
  802930:	00 
	memmove(bits, bitmap, PGSIZE);
  802931:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  802938:	00 00 00 
  80293b:	48 8b 08             	mov    (%rax),%rcx
  80293e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802942:	ba 00 10 00 00       	mov    $0x1000,%edx
  802947:	48 89 ce             	mov    %rcx,%rsi
  80294a:	48 89 c7             	mov    %rax,%rdi
  80294d:	48 b8 7e 42 80 00 00 	movabs $0x80427e,%rax
  802954:	00 00 00 
  802957:	ff d0                	callq  *%rax
	// allocate block
	if ((r = alloc_block()) < 0)
  802959:	48 b8 61 0e 80 00 00 	movabs $0x800e61,%rax
  802960:	00 00 00 
  802963:	ff d0                	callq  *%rax
  802965:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802968:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80296c:	79 30                	jns    80299e <fs_test+0xd1>
		panic("alloc_block: %e", r);
  80296e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802971:	89 c1                	mov    %eax,%ecx
  802973:	48 ba bb 69 80 00 00 	movabs $0x8069bb,%rdx
  80297a:	00 00 00 
  80297d:	be 18 00 00 00       	mov    $0x18,%esi
  802982:	48 bf b1 69 80 00 00 	movabs $0x8069b1,%rdi
  802989:	00 00 00 
  80298c:	b8 00 00 00 00       	mov    $0x0,%eax
  802991:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  802998:	00 00 00 
  80299b:	41 ff d0             	callq  *%r8
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  80299e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a1:	8d 50 1f             	lea    0x1f(%rax),%edx
  8029a4:	85 c0                	test   %eax,%eax
  8029a6:	0f 48 c2             	cmovs  %edx,%eax
  8029a9:	c1 f8 05             	sar    $0x5,%eax
  8029ac:	48 98                	cltq   
  8029ae:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  8029b5:	00 
  8029b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ba:	48 01 d0             	add    %rdx,%rax
  8029bd:	8b 30                	mov    (%rax),%esi
  8029bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c2:	99                   	cltd   
  8029c3:	c1 ea 1b             	shr    $0x1b,%edx
  8029c6:	01 d0                	add    %edx,%eax
  8029c8:	83 e0 1f             	and    $0x1f,%eax
  8029cb:	29 d0                	sub    %edx,%eax
  8029cd:	ba 01 00 00 00       	mov    $0x1,%edx
  8029d2:	89 c1                	mov    %eax,%ecx
  8029d4:	d3 e2                	shl    %cl,%edx
  8029d6:	89 d0                	mov    %edx,%eax
  8029d8:	21 f0                	and    %esi,%eax
  8029da:	85 c0                	test   %eax,%eax
  8029dc:	75 35                	jne    802a13 <fs_test+0x146>
  8029de:	48 b9 cb 69 80 00 00 	movabs $0x8069cb,%rcx
  8029e5:	00 00 00 
  8029e8:	48 ba e6 69 80 00 00 	movabs $0x8069e6,%rdx
  8029ef:	00 00 00 
  8029f2:	be 1a 00 00 00       	mov    $0x1a,%esi
  8029f7:	48 bf b1 69 80 00 00 	movabs $0x8069b1,%rdi
  8029fe:	00 00 00 
  802a01:	b8 00 00 00 00       	mov    $0x0,%eax
  802a06:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  802a0d:	00 00 00 
  802a10:	41 ff d0             	callq  *%r8
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  802a13:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  802a1a:	00 00 00 
  802a1d:	48 8b 10             	mov    (%rax),%rdx
  802a20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a23:	8d 48 1f             	lea    0x1f(%rax),%ecx
  802a26:	85 c0                	test   %eax,%eax
  802a28:	0f 48 c1             	cmovs  %ecx,%eax
  802a2b:	c1 f8 05             	sar    $0x5,%eax
  802a2e:	48 98                	cltq   
  802a30:	48 c1 e0 02          	shl    $0x2,%rax
  802a34:	48 01 d0             	add    %rdx,%rax
  802a37:	8b 30                	mov    (%rax),%esi
  802a39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3c:	99                   	cltd   
  802a3d:	c1 ea 1b             	shr    $0x1b,%edx
  802a40:	01 d0                	add    %edx,%eax
  802a42:	83 e0 1f             	and    $0x1f,%eax
  802a45:	29 d0                	sub    %edx,%eax
  802a47:	ba 01 00 00 00       	mov    $0x1,%edx
  802a4c:	89 c1                	mov    %eax,%ecx
  802a4e:	d3 e2                	shl    %cl,%edx
  802a50:	89 d0                	mov    %edx,%eax
  802a52:	21 f0                	and    %esi,%eax
  802a54:	85 c0                	test   %eax,%eax
  802a56:	74 35                	je     802a8d <fs_test+0x1c0>
  802a58:	48 b9 00 6a 80 00 00 	movabs $0x806a00,%rcx
  802a5f:	00 00 00 
  802a62:	48 ba e6 69 80 00 00 	movabs $0x8069e6,%rdx
  802a69:	00 00 00 
  802a6c:	be 1c 00 00 00       	mov    $0x1c,%esi
  802a71:	48 bf b1 69 80 00 00 	movabs $0x8069b1,%rdi
  802a78:	00 00 00 
  802a7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a80:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  802a87:	00 00 00 
  802a8a:	41 ff d0             	callq  *%r8
	cprintf("alloc_block is good\n");
  802a8d:	48 bf 20 6a 80 00 00 	movabs $0x806a20,%rdi
  802a94:	00 00 00 
  802a97:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9c:	48 ba a5 33 80 00 00 	movabs $0x8033a5,%rdx
  802aa3:	00 00 00 
  802aa6:	ff d2                	callq  *%rdx

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  802aa8:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802aac:	48 89 c6             	mov    %rax,%rsi
  802aaf:	48 bf 35 6a 80 00 00 	movabs $0x806a35,%rdi
  802ab6:	00 00 00 
  802ab9:	48 b8 7f 18 80 00 00 	movabs $0x80187f,%rax
  802ac0:	00 00 00 
  802ac3:	ff d0                	callq  *%rax
  802ac5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ac8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802acc:	79 36                	jns    802b04 <fs_test+0x237>
  802ace:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  802ad2:	74 30                	je     802b04 <fs_test+0x237>
		panic("file_open /not-found: %e", r);
  802ad4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad7:	89 c1                	mov    %eax,%ecx
  802ad9:	48 ba 40 6a 80 00 00 	movabs $0x806a40,%rdx
  802ae0:	00 00 00 
  802ae3:	be 20 00 00 00       	mov    $0x20,%esi
  802ae8:	48 bf b1 69 80 00 00 	movabs $0x8069b1,%rdi
  802aef:	00 00 00 
  802af2:	b8 00 00 00 00       	mov    $0x0,%eax
  802af7:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  802afe:	00 00 00 
  802b01:	41 ff d0             	callq  *%r8
	else if (r == 0)
  802b04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b08:	75 2a                	jne    802b34 <fs_test+0x267>
		panic("file_open /not-found succeeded!");
  802b0a:	48 ba 60 6a 80 00 00 	movabs $0x806a60,%rdx
  802b11:	00 00 00 
  802b14:	be 22 00 00 00       	mov    $0x22,%esi
  802b19:	48 bf b1 69 80 00 00 	movabs $0x8069b1,%rdi
  802b20:	00 00 00 
  802b23:	b8 00 00 00 00       	mov    $0x0,%eax
  802b28:	48 b9 6c 31 80 00 00 	movabs $0x80316c,%rcx
  802b2f:	00 00 00 
  802b32:	ff d1                	callq  *%rcx
	if ((r = file_open("/newmotd", &f)) < 0)
  802b34:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802b38:	48 89 c6             	mov    %rax,%rsi
  802b3b:	48 bf 80 6a 80 00 00 	movabs $0x806a80,%rdi
  802b42:	00 00 00 
  802b45:	48 b8 7f 18 80 00 00 	movabs $0x80187f,%rax
  802b4c:	00 00 00 
  802b4f:	ff d0                	callq  *%rax
  802b51:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b54:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b58:	79 30                	jns    802b8a <fs_test+0x2bd>
		panic("file_open /newmotd: %e", r);
  802b5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b5d:	89 c1                	mov    %eax,%ecx
  802b5f:	48 ba 89 6a 80 00 00 	movabs $0x806a89,%rdx
  802b66:	00 00 00 
  802b69:	be 24 00 00 00       	mov    $0x24,%esi
  802b6e:	48 bf b1 69 80 00 00 	movabs $0x8069b1,%rdi
  802b75:	00 00 00 
  802b78:	b8 00 00 00 00       	mov    $0x0,%eax
  802b7d:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  802b84:	00 00 00 
  802b87:	41 ff d0             	callq  *%r8
	cprintf("file_open is good\n");
  802b8a:	48 bf a0 6a 80 00 00 	movabs $0x806aa0,%rdi
  802b91:	00 00 00 
  802b94:	b8 00 00 00 00       	mov    $0x0,%eax
  802b99:	48 ba a5 33 80 00 00 	movabs $0x8033a5,%rdx
  802ba0:	00 00 00 
  802ba3:	ff d2                	callq  *%rdx

	if ((r = file_get_block(f, 0, &blk)) < 0)
  802ba5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba9:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802bad:	be 00 00 00 00       	mov    $0x0,%esi
  802bb2:	48 89 c7             	mov    %rax,%rdi
  802bb5:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  802bbc:	00 00 00 
  802bbf:	ff d0                	callq  *%rax
  802bc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc8:	79 30                	jns    802bfa <fs_test+0x32d>
		panic("file_get_block: %e", r);
  802bca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bcd:	89 c1                	mov    %eax,%ecx
  802bcf:	48 ba b3 6a 80 00 00 	movabs $0x806ab3,%rdx
  802bd6:	00 00 00 
  802bd9:	be 28 00 00 00       	mov    $0x28,%esi
  802bde:	48 bf b1 69 80 00 00 	movabs $0x8069b1,%rdi
  802be5:	00 00 00 
  802be8:	b8 00 00 00 00       	mov    $0x0,%eax
  802bed:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  802bf4:	00 00 00 
  802bf7:	41 ff d0             	callq  *%r8
	if (strcmp(blk, msg) != 0)
  802bfa:	48 b8 88 10 81 00 00 	movabs $0x811088,%rax
  802c01:	00 00 00 
  802c04:	48 8b 10             	mov    (%rax),%rdx
  802c07:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c0b:	48 89 d6             	mov    %rdx,%rsi
  802c0e:	48 89 c7             	mov    %rax,%rdi
  802c11:	48 b8 bc 40 80 00 00 	movabs $0x8040bc,%rax
  802c18:	00 00 00 
  802c1b:	ff d0                	callq  *%rax
  802c1d:	85 c0                	test   %eax,%eax
  802c1f:	74 2a                	je     802c4b <fs_test+0x37e>
		panic("file_get_block returned wrong data");
  802c21:	48 ba c8 6a 80 00 00 	movabs $0x806ac8,%rdx
  802c28:	00 00 00 
  802c2b:	be 2a 00 00 00       	mov    $0x2a,%esi
  802c30:	48 bf b1 69 80 00 00 	movabs $0x8069b1,%rdi
  802c37:	00 00 00 
  802c3a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3f:	48 b9 6c 31 80 00 00 	movabs $0x80316c,%rcx
  802c46:	00 00 00 
  802c49:	ff d1                	callq  *%rcx
	cprintf("file_get_block is good\n");
  802c4b:	48 bf eb 6a 80 00 00 	movabs $0x806aeb,%rdi
  802c52:	00 00 00 
  802c55:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5a:	48 ba a5 33 80 00 00 	movabs $0x8033a5,%rdx
  802c61:	00 00 00 
  802c64:	ff d2                	callq  *%rdx

	*(volatile char*)blk = *(volatile char*)blk;
  802c66:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c6a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c6e:	0f b6 12             	movzbl (%rdx),%edx
  802c71:	88 10                	mov    %dl,(%rax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  802c73:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c77:	48 c1 e8 0c          	shr    $0xc,%rax
  802c7b:	48 89 c2             	mov    %rax,%rdx
  802c7e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c85:	01 00 00 
  802c88:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c8c:	83 e0 40             	and    $0x40,%eax
  802c8f:	48 85 c0             	test   %rax,%rax
  802c92:	75 35                	jne    802cc9 <fs_test+0x3fc>
  802c94:	48 b9 03 6b 80 00 00 	movabs $0x806b03,%rcx
  802c9b:	00 00 00 
  802c9e:	48 ba e6 69 80 00 00 	movabs $0x8069e6,%rdx
  802ca5:	00 00 00 
  802ca8:	be 2e 00 00 00       	mov    $0x2e,%esi
  802cad:	48 bf b1 69 80 00 00 	movabs $0x8069b1,%rdi
  802cb4:	00 00 00 
  802cb7:	b8 00 00 00 00       	mov    $0x0,%eax
  802cbc:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  802cc3:	00 00 00 
  802cc6:	41 ff d0             	callq  *%r8
	file_flush(f);
  802cc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ccd:	48 89 c7             	mov    %rax,%rdi
  802cd0:	48 b8 0b 1d 80 00 00 	movabs $0x801d0b,%rax
  802cd7:	00 00 00 
  802cda:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  802cdc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ce0:	48 c1 e8 0c          	shr    $0xc,%rax
  802ce4:	48 89 c2             	mov    %rax,%rdx
  802ce7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cee:	01 00 00 
  802cf1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cf5:	83 e0 40             	and    $0x40,%eax
  802cf8:	48 85 c0             	test   %rax,%rax
  802cfb:	74 35                	je     802d32 <fs_test+0x465>
  802cfd:	48 b9 1e 6b 80 00 00 	movabs $0x806b1e,%rcx
  802d04:	00 00 00 
  802d07:	48 ba e6 69 80 00 00 	movabs $0x8069e6,%rdx
  802d0e:	00 00 00 
  802d11:	be 30 00 00 00       	mov    $0x30,%esi
  802d16:	48 bf b1 69 80 00 00 	movabs $0x8069b1,%rdi
  802d1d:	00 00 00 
  802d20:	b8 00 00 00 00       	mov    $0x0,%eax
  802d25:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  802d2c:	00 00 00 
  802d2f:	41 ff d0             	callq  *%r8
	cprintf("file_flush is good\n");
  802d32:	48 bf 3a 6b 80 00 00 	movabs $0x806b3a,%rdi
  802d39:	00 00 00 
  802d3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d41:	48 ba a5 33 80 00 00 	movabs $0x8033a5,%rdx
  802d48:	00 00 00 
  802d4b:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, 0)) < 0)
  802d4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d51:	be 00 00 00 00       	mov    $0x0,%esi
  802d56:	48 89 c7             	mov    %rax,%rdi
  802d59:	48 b8 ae 1c 80 00 00 	movabs $0x801cae,%rax
  802d60:	00 00 00 
  802d63:	ff d0                	callq  *%rax
  802d65:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d6c:	79 30                	jns    802d9e <fs_test+0x4d1>
		panic("file_set_size: %e", r);
  802d6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d71:	89 c1                	mov    %eax,%ecx
  802d73:	48 ba 4e 6b 80 00 00 	movabs $0x806b4e,%rdx
  802d7a:	00 00 00 
  802d7d:	be 34 00 00 00       	mov    $0x34,%esi
  802d82:	48 bf b1 69 80 00 00 	movabs $0x8069b1,%rdi
  802d89:	00 00 00 
  802d8c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d91:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  802d98:	00 00 00 
  802d9b:	41 ff d0             	callq  *%r8
	assert(f->f_direct[0] == 0);
  802d9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da2:	8b 80 88 00 00 00    	mov    0x88(%rax),%eax
  802da8:	85 c0                	test   %eax,%eax
  802daa:	74 35                	je     802de1 <fs_test+0x514>
  802dac:	48 b9 60 6b 80 00 00 	movabs $0x806b60,%rcx
  802db3:	00 00 00 
  802db6:	48 ba e6 69 80 00 00 	movabs $0x8069e6,%rdx
  802dbd:	00 00 00 
  802dc0:	be 35 00 00 00       	mov    $0x35,%esi
  802dc5:	48 bf b1 69 80 00 00 	movabs $0x8069b1,%rdi
  802dcc:	00 00 00 
  802dcf:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd4:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  802ddb:	00 00 00 
  802dde:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802de1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802de5:	48 c1 e8 0c          	shr    $0xc,%rax
  802de9:	48 89 c2             	mov    %rax,%rdx
  802dec:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802df3:	01 00 00 
  802df6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802dfa:	83 e0 40             	and    $0x40,%eax
  802dfd:	48 85 c0             	test   %rax,%rax
  802e00:	74 35                	je     802e37 <fs_test+0x56a>
  802e02:	48 b9 74 6b 80 00 00 	movabs $0x806b74,%rcx
  802e09:	00 00 00 
  802e0c:	48 ba e6 69 80 00 00 	movabs $0x8069e6,%rdx
  802e13:	00 00 00 
  802e16:	be 36 00 00 00       	mov    $0x36,%esi
  802e1b:	48 bf b1 69 80 00 00 	movabs $0x8069b1,%rdi
  802e22:	00 00 00 
  802e25:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2a:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  802e31:	00 00 00 
  802e34:	41 ff d0             	callq  *%r8
	cprintf("file_truncate is good\n");
  802e37:	48 bf 8e 6b 80 00 00 	movabs $0x806b8e,%rdi
  802e3e:	00 00 00 
  802e41:	b8 00 00 00 00       	mov    $0x0,%eax
  802e46:	48 ba a5 33 80 00 00 	movabs $0x8033a5,%rdx
  802e4d:	00 00 00 
  802e50:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, strlen(msg))) < 0)
  802e52:	48 b8 88 10 81 00 00 	movabs $0x811088,%rax
  802e59:	00 00 00 
  802e5c:	48 8b 00             	mov    (%rax),%rax
  802e5f:	48 89 c7             	mov    %rax,%rdi
  802e62:	48 b8 ee 3e 80 00 00 	movabs $0x803eee,%rax
  802e69:	00 00 00 
  802e6c:	ff d0                	callq  *%rax
  802e6e:	89 c2                	mov    %eax,%edx
  802e70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e74:	89 d6                	mov    %edx,%esi
  802e76:	48 89 c7             	mov    %rax,%rdi
  802e79:	48 b8 ae 1c 80 00 00 	movabs $0x801cae,%rax
  802e80:	00 00 00 
  802e83:	ff d0                	callq  *%rax
  802e85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e8c:	79 30                	jns    802ebe <fs_test+0x5f1>
		panic("file_set_size 2: %e", r);
  802e8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e91:	89 c1                	mov    %eax,%ecx
  802e93:	48 ba a5 6b 80 00 00 	movabs $0x806ba5,%rdx
  802e9a:	00 00 00 
  802e9d:	be 3a 00 00 00       	mov    $0x3a,%esi
  802ea2:	48 bf b1 69 80 00 00 	movabs $0x8069b1,%rdi
  802ea9:	00 00 00 
  802eac:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb1:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  802eb8:	00 00 00 
  802ebb:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802ebe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec2:	48 c1 e8 0c          	shr    $0xc,%rax
  802ec6:	48 89 c2             	mov    %rax,%rdx
  802ec9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ed0:	01 00 00 
  802ed3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ed7:	83 e0 40             	and    $0x40,%eax
  802eda:	48 85 c0             	test   %rax,%rax
  802edd:	74 35                	je     802f14 <fs_test+0x647>
  802edf:	48 b9 74 6b 80 00 00 	movabs $0x806b74,%rcx
  802ee6:	00 00 00 
  802ee9:	48 ba e6 69 80 00 00 	movabs $0x8069e6,%rdx
  802ef0:	00 00 00 
  802ef3:	be 3b 00 00 00       	mov    $0x3b,%esi
  802ef8:	48 bf b1 69 80 00 00 	movabs $0x8069b1,%rdi
  802eff:	00 00 00 
  802f02:	b8 00 00 00 00       	mov    $0x0,%eax
  802f07:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  802f0e:	00 00 00 
  802f11:	41 ff d0             	callq  *%r8
	if ((r = file_get_block(f, 0, &blk)) < 0)
  802f14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f18:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802f1c:	be 00 00 00 00       	mov    $0x0,%esi
  802f21:	48 89 c7             	mov    %rax,%rdi
  802f24:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  802f2b:	00 00 00 
  802f2e:	ff d0                	callq  *%rax
  802f30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f37:	79 30                	jns    802f69 <fs_test+0x69c>
		panic("file_get_block 2: %e", r);
  802f39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f3c:	89 c1                	mov    %eax,%ecx
  802f3e:	48 ba b9 6b 80 00 00 	movabs $0x806bb9,%rdx
  802f45:	00 00 00 
  802f48:	be 3d 00 00 00       	mov    $0x3d,%esi
  802f4d:	48 bf b1 69 80 00 00 	movabs $0x8069b1,%rdi
  802f54:	00 00 00 
  802f57:	b8 00 00 00 00       	mov    $0x0,%eax
  802f5c:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  802f63:	00 00 00 
  802f66:	41 ff d0             	callq  *%r8
	strcpy(blk, msg);
  802f69:	48 b8 88 10 81 00 00 	movabs $0x811088,%rax
  802f70:	00 00 00 
  802f73:	48 8b 10             	mov    (%rax),%rdx
  802f76:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f7a:	48 89 d6             	mov    %rdx,%rsi
  802f7d:	48 89 c7             	mov    %rax,%rdi
  802f80:	48 b8 5a 3f 80 00 00 	movabs $0x803f5a,%rax
  802f87:	00 00 00 
  802f8a:	ff d0                	callq  *%rax
	assert((uvpt[PGNUM(blk)] & PTE_D));
  802f8c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f90:	48 c1 e8 0c          	shr    $0xc,%rax
  802f94:	48 89 c2             	mov    %rax,%rdx
  802f97:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f9e:	01 00 00 
  802fa1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802fa5:	83 e0 40             	and    $0x40,%eax
  802fa8:	48 85 c0             	test   %rax,%rax
  802fab:	75 35                	jne    802fe2 <fs_test+0x715>
  802fad:	48 b9 03 6b 80 00 00 	movabs $0x806b03,%rcx
  802fb4:	00 00 00 
  802fb7:	48 ba e6 69 80 00 00 	movabs $0x8069e6,%rdx
  802fbe:	00 00 00 
  802fc1:	be 3f 00 00 00       	mov    $0x3f,%esi
  802fc6:	48 bf b1 69 80 00 00 	movabs $0x8069b1,%rdi
  802fcd:	00 00 00 
  802fd0:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd5:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  802fdc:	00 00 00 
  802fdf:	41 ff d0             	callq  *%r8
	file_flush(f);
  802fe2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fe6:	48 89 c7             	mov    %rax,%rdi
  802fe9:	48 b8 0b 1d 80 00 00 	movabs $0x801d0b,%rax
  802ff0:	00 00 00 
  802ff3:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  802ff5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ff9:	48 c1 e8 0c          	shr    $0xc,%rax
  802ffd:	48 89 c2             	mov    %rax,%rdx
  803000:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803007:	01 00 00 
  80300a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80300e:	83 e0 40             	and    $0x40,%eax
  803011:	48 85 c0             	test   %rax,%rax
  803014:	74 35                	je     80304b <fs_test+0x77e>
  803016:	48 b9 1e 6b 80 00 00 	movabs $0x806b1e,%rcx
  80301d:	00 00 00 
  803020:	48 ba e6 69 80 00 00 	movabs $0x8069e6,%rdx
  803027:	00 00 00 
  80302a:	be 41 00 00 00       	mov    $0x41,%esi
  80302f:	48 bf b1 69 80 00 00 	movabs $0x8069b1,%rdi
  803036:	00 00 00 
  803039:	b8 00 00 00 00       	mov    $0x0,%eax
  80303e:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  803045:	00 00 00 
  803048:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  80304b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80304f:	48 c1 e8 0c          	shr    $0xc,%rax
  803053:	48 89 c2             	mov    %rax,%rdx
  803056:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80305d:	01 00 00 
  803060:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803064:	83 e0 40             	and    $0x40,%eax
  803067:	48 85 c0             	test   %rax,%rax
  80306a:	74 35                	je     8030a1 <fs_test+0x7d4>
  80306c:	48 b9 74 6b 80 00 00 	movabs $0x806b74,%rcx
  803073:	00 00 00 
  803076:	48 ba e6 69 80 00 00 	movabs $0x8069e6,%rdx
  80307d:	00 00 00 
  803080:	be 42 00 00 00       	mov    $0x42,%esi
  803085:	48 bf b1 69 80 00 00 	movabs $0x8069b1,%rdi
  80308c:	00 00 00 
  80308f:	b8 00 00 00 00       	mov    $0x0,%eax
  803094:	49 b8 6c 31 80 00 00 	movabs $0x80316c,%r8
  80309b:	00 00 00 
  80309e:	41 ff d0             	callq  *%r8
	cprintf("file rewrite is good\n");
  8030a1:	48 bf ce 6b 80 00 00 	movabs $0x806bce,%rdi
  8030a8:	00 00 00 
  8030ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b0:	48 ba a5 33 80 00 00 	movabs $0x8033a5,%rdx
  8030b7:	00 00 00 
  8030ba:	ff d2                	callq  *%rdx
}
  8030bc:	c9                   	leaveq 
  8030bd:	c3                   	retq   

00000000008030be <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8030be:	55                   	push   %rbp
  8030bf:	48 89 e5             	mov    %rsp,%rbp
  8030c2:	48 83 ec 10          	sub    $0x10,%rsp
  8030c6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8030c9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8030cd:	48 b8 0d 48 80 00 00 	movabs $0x80480d,%rax
  8030d4:	00 00 00 
  8030d7:	ff d0                	callq  *%rax
  8030d9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8030de:	48 63 d0             	movslq %eax,%rdx
  8030e1:	48 89 d0             	mov    %rdx,%rax
  8030e4:	48 c1 e0 03          	shl    $0x3,%rax
  8030e8:	48 01 d0             	add    %rdx,%rax
  8030eb:	48 c1 e0 05          	shl    $0x5,%rax
  8030ef:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8030f6:	00 00 00 
  8030f9:	48 01 c2             	add    %rax,%rdx
  8030fc:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  803103:	00 00 00 
  803106:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  803109:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80310d:	7e 14                	jle    803123 <libmain+0x65>
		binaryname = argv[0];
  80310f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803113:	48 8b 10             	mov    (%rax),%rdx
  803116:	48 b8 90 10 81 00 00 	movabs $0x811090,%rax
  80311d:	00 00 00 
  803120:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  803123:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803127:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80312a:	48 89 d6             	mov    %rdx,%rsi
  80312d:	89 c7                	mov    %eax,%edi
  80312f:	48 b8 29 28 80 00 00 	movabs $0x802829,%rax
  803136:	00 00 00 
  803139:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80313b:	48 b8 49 31 80 00 00 	movabs $0x803149,%rax
  803142:	00 00 00 
  803145:	ff d0                	callq  *%rax
}
  803147:	c9                   	leaveq 
  803148:	c3                   	retq   

0000000000803149 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  803149:	55                   	push   %rbp
  80314a:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80314d:	48 b8 61 51 80 00 00 	movabs $0x805161,%rax
  803154:	00 00 00 
  803157:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  803159:	bf 00 00 00 00       	mov    $0x0,%edi
  80315e:	48 b8 c9 47 80 00 00 	movabs $0x8047c9,%rax
  803165:	00 00 00 
  803168:	ff d0                	callq  *%rax

}
  80316a:	5d                   	pop    %rbp
  80316b:	c3                   	retq   

000000000080316c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80316c:	55                   	push   %rbp
  80316d:	48 89 e5             	mov    %rsp,%rbp
  803170:	53                   	push   %rbx
  803171:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803178:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80317f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803185:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80318c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803193:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80319a:	84 c0                	test   %al,%al
  80319c:	74 23                	je     8031c1 <_panic+0x55>
  80319e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8031a5:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8031a9:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8031ad:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8031b1:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8031b5:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8031b9:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8031bd:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8031c1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8031c8:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8031cf:	00 00 00 
  8031d2:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8031d9:	00 00 00 
  8031dc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8031e0:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8031e7:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8031ee:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8031f5:	48 b8 90 10 81 00 00 	movabs $0x811090,%rax
  8031fc:	00 00 00 
  8031ff:	48 8b 18             	mov    (%rax),%rbx
  803202:	48 b8 0d 48 80 00 00 	movabs $0x80480d,%rax
  803209:	00 00 00 
  80320c:	ff d0                	callq  *%rax
  80320e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803214:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80321b:	41 89 c8             	mov    %ecx,%r8d
  80321e:	48 89 d1             	mov    %rdx,%rcx
  803221:	48 89 da             	mov    %rbx,%rdx
  803224:	89 c6                	mov    %eax,%esi
  803226:	48 bf f0 6b 80 00 00 	movabs $0x806bf0,%rdi
  80322d:	00 00 00 
  803230:	b8 00 00 00 00       	mov    $0x0,%eax
  803235:	49 b9 a5 33 80 00 00 	movabs $0x8033a5,%r9
  80323c:	00 00 00 
  80323f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803242:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803249:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803250:	48 89 d6             	mov    %rdx,%rsi
  803253:	48 89 c7             	mov    %rax,%rdi
  803256:	48 b8 f9 32 80 00 00 	movabs $0x8032f9,%rax
  80325d:	00 00 00 
  803260:	ff d0                	callq  *%rax
	cprintf("\n");
  803262:	48 bf 13 6c 80 00 00 	movabs $0x806c13,%rdi
  803269:	00 00 00 
  80326c:	b8 00 00 00 00       	mov    $0x0,%eax
  803271:	48 ba a5 33 80 00 00 	movabs $0x8033a5,%rdx
  803278:	00 00 00 
  80327b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80327d:	cc                   	int3   
  80327e:	eb fd                	jmp    80327d <_panic+0x111>

0000000000803280 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  803280:	55                   	push   %rbp
  803281:	48 89 e5             	mov    %rsp,%rbp
  803284:	48 83 ec 10          	sub    $0x10,%rsp
  803288:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80328b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80328f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803293:	8b 00                	mov    (%rax),%eax
  803295:	8d 48 01             	lea    0x1(%rax),%ecx
  803298:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80329c:	89 0a                	mov    %ecx,(%rdx)
  80329e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032a1:	89 d1                	mov    %edx,%ecx
  8032a3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032a7:	48 98                	cltq   
  8032a9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  8032ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b1:	8b 00                	mov    (%rax),%eax
  8032b3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8032b8:	75 2c                	jne    8032e6 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  8032ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032be:	8b 00                	mov    (%rax),%eax
  8032c0:	48 98                	cltq   
  8032c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032c6:	48 83 c2 08          	add    $0x8,%rdx
  8032ca:	48 89 c6             	mov    %rax,%rsi
  8032cd:	48 89 d7             	mov    %rdx,%rdi
  8032d0:	48 b8 41 47 80 00 00 	movabs $0x804741,%rax
  8032d7:	00 00 00 
  8032da:	ff d0                	callq  *%rax
		b->idx = 0;
  8032dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8032e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ea:	8b 40 04             	mov    0x4(%rax),%eax
  8032ed:	8d 50 01             	lea    0x1(%rax),%edx
  8032f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032f4:	89 50 04             	mov    %edx,0x4(%rax)
}
  8032f7:	c9                   	leaveq 
  8032f8:	c3                   	retq   

00000000008032f9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8032f9:	55                   	push   %rbp
  8032fa:	48 89 e5             	mov    %rsp,%rbp
  8032fd:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  803304:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80330b:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  803312:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  803319:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  803320:	48 8b 0a             	mov    (%rdx),%rcx
  803323:	48 89 08             	mov    %rcx,(%rax)
  803326:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80332a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80332e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803332:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  803336:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80333d:	00 00 00 
	b.cnt = 0;
  803340:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  803347:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  80334a:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  803351:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  803358:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80335f:	48 89 c6             	mov    %rax,%rsi
  803362:	48 bf 80 32 80 00 00 	movabs $0x803280,%rdi
  803369:	00 00 00 
  80336c:	48 b8 58 37 80 00 00 	movabs $0x803758,%rax
  803373:	00 00 00 
  803376:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  803378:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80337e:	48 98                	cltq   
  803380:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  803387:	48 83 c2 08          	add    $0x8,%rdx
  80338b:	48 89 c6             	mov    %rax,%rsi
  80338e:	48 89 d7             	mov    %rdx,%rdi
  803391:	48 b8 41 47 80 00 00 	movabs $0x804741,%rax
  803398:	00 00 00 
  80339b:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80339d:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8033a3:	c9                   	leaveq 
  8033a4:	c3                   	retq   

00000000008033a5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8033a5:	55                   	push   %rbp
  8033a6:	48 89 e5             	mov    %rsp,%rbp
  8033a9:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8033b0:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8033b7:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8033be:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8033c5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8033cc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8033d3:	84 c0                	test   %al,%al
  8033d5:	74 20                	je     8033f7 <cprintf+0x52>
  8033d7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8033db:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8033df:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8033e3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8033e7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8033eb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8033ef:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8033f3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8033f7:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8033fe:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803405:	00 00 00 
  803408:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80340f:	00 00 00 
  803412:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803416:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80341d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803424:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80342b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803432:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803439:	48 8b 0a             	mov    (%rdx),%rcx
  80343c:	48 89 08             	mov    %rcx,(%rax)
  80343f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803443:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803447:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80344b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  80344f:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  803456:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80345d:	48 89 d6             	mov    %rdx,%rsi
  803460:	48 89 c7             	mov    %rax,%rdi
  803463:	48 b8 f9 32 80 00 00 	movabs $0x8032f9,%rax
  80346a:	00 00 00 
  80346d:	ff d0                	callq  *%rax
  80346f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  803475:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80347b:	c9                   	leaveq 
  80347c:	c3                   	retq   

000000000080347d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80347d:	55                   	push   %rbp
  80347e:	48 89 e5             	mov    %rsp,%rbp
  803481:	53                   	push   %rbx
  803482:	48 83 ec 38          	sub    $0x38,%rsp
  803486:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80348a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80348e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803492:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  803495:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  803499:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80349d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8034a0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8034a4:	77 3b                	ja     8034e1 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8034a6:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8034a9:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8034ad:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8034b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8034b9:	48 f7 f3             	div    %rbx
  8034bc:	48 89 c2             	mov    %rax,%rdx
  8034bf:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8034c2:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8034c5:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8034c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034cd:	41 89 f9             	mov    %edi,%r9d
  8034d0:	48 89 c7             	mov    %rax,%rdi
  8034d3:	48 b8 7d 34 80 00 00 	movabs $0x80347d,%rax
  8034da:	00 00 00 
  8034dd:	ff d0                	callq  *%rax
  8034df:	eb 1e                	jmp    8034ff <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8034e1:	eb 12                	jmp    8034f5 <printnum+0x78>
			putch(padc, putdat);
  8034e3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8034e7:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8034ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ee:	48 89 ce             	mov    %rcx,%rsi
  8034f1:	89 d7                	mov    %edx,%edi
  8034f3:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8034f5:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8034f9:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8034fd:	7f e4                	jg     8034e3 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8034ff:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  803502:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803506:	ba 00 00 00 00       	mov    $0x0,%edx
  80350b:	48 f7 f1             	div    %rcx
  80350e:	48 89 d0             	mov    %rdx,%rax
  803511:	48 ba e8 6d 80 00 00 	movabs $0x806de8,%rdx
  803518:	00 00 00 
  80351b:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80351f:	0f be d0             	movsbl %al,%edx
  803522:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803526:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80352a:	48 89 ce             	mov    %rcx,%rsi
  80352d:	89 d7                	mov    %edx,%edi
  80352f:	ff d0                	callq  *%rax
}
  803531:	48 83 c4 38          	add    $0x38,%rsp
  803535:	5b                   	pop    %rbx
  803536:	5d                   	pop    %rbp
  803537:	c3                   	retq   

0000000000803538 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  803538:	55                   	push   %rbp
  803539:	48 89 e5             	mov    %rsp,%rbp
  80353c:	48 83 ec 1c          	sub    $0x1c,%rsp
  803540:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803544:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  803547:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80354b:	7e 52                	jle    80359f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80354d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803551:	8b 00                	mov    (%rax),%eax
  803553:	83 f8 30             	cmp    $0x30,%eax
  803556:	73 24                	jae    80357c <getuint+0x44>
  803558:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80355c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803560:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803564:	8b 00                	mov    (%rax),%eax
  803566:	89 c0                	mov    %eax,%eax
  803568:	48 01 d0             	add    %rdx,%rax
  80356b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80356f:	8b 12                	mov    (%rdx),%edx
  803571:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803574:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803578:	89 0a                	mov    %ecx,(%rdx)
  80357a:	eb 17                	jmp    803593 <getuint+0x5b>
  80357c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803580:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803584:	48 89 d0             	mov    %rdx,%rax
  803587:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80358b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80358f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803593:	48 8b 00             	mov    (%rax),%rax
  803596:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80359a:	e9 a3 00 00 00       	jmpq   803642 <getuint+0x10a>
	else if (lflag)
  80359f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8035a3:	74 4f                	je     8035f4 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8035a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035a9:	8b 00                	mov    (%rax),%eax
  8035ab:	83 f8 30             	cmp    $0x30,%eax
  8035ae:	73 24                	jae    8035d4 <getuint+0x9c>
  8035b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8035b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035bc:	8b 00                	mov    (%rax),%eax
  8035be:	89 c0                	mov    %eax,%eax
  8035c0:	48 01 d0             	add    %rdx,%rax
  8035c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035c7:	8b 12                	mov    (%rdx),%edx
  8035c9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8035cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035d0:	89 0a                	mov    %ecx,(%rdx)
  8035d2:	eb 17                	jmp    8035eb <getuint+0xb3>
  8035d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035d8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8035dc:	48 89 d0             	mov    %rdx,%rax
  8035df:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8035e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035e7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8035eb:	48 8b 00             	mov    (%rax),%rax
  8035ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8035f2:	eb 4e                	jmp    803642 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8035f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035f8:	8b 00                	mov    (%rax),%eax
  8035fa:	83 f8 30             	cmp    $0x30,%eax
  8035fd:	73 24                	jae    803623 <getuint+0xeb>
  8035ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803603:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803607:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80360b:	8b 00                	mov    (%rax),%eax
  80360d:	89 c0                	mov    %eax,%eax
  80360f:	48 01 d0             	add    %rdx,%rax
  803612:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803616:	8b 12                	mov    (%rdx),%edx
  803618:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80361b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80361f:	89 0a                	mov    %ecx,(%rdx)
  803621:	eb 17                	jmp    80363a <getuint+0x102>
  803623:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803627:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80362b:	48 89 d0             	mov    %rdx,%rax
  80362e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803632:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803636:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80363a:	8b 00                	mov    (%rax),%eax
  80363c:	89 c0                	mov    %eax,%eax
  80363e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803642:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803646:	c9                   	leaveq 
  803647:	c3                   	retq   

0000000000803648 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  803648:	55                   	push   %rbp
  803649:	48 89 e5             	mov    %rsp,%rbp
  80364c:	48 83 ec 1c          	sub    $0x1c,%rsp
  803650:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803654:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  803657:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80365b:	7e 52                	jle    8036af <getint+0x67>
		x=va_arg(*ap, long long);
  80365d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803661:	8b 00                	mov    (%rax),%eax
  803663:	83 f8 30             	cmp    $0x30,%eax
  803666:	73 24                	jae    80368c <getint+0x44>
  803668:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80366c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803670:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803674:	8b 00                	mov    (%rax),%eax
  803676:	89 c0                	mov    %eax,%eax
  803678:	48 01 d0             	add    %rdx,%rax
  80367b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80367f:	8b 12                	mov    (%rdx),%edx
  803681:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803684:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803688:	89 0a                	mov    %ecx,(%rdx)
  80368a:	eb 17                	jmp    8036a3 <getint+0x5b>
  80368c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803690:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803694:	48 89 d0             	mov    %rdx,%rax
  803697:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80369b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80369f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8036a3:	48 8b 00             	mov    (%rax),%rax
  8036a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8036aa:	e9 a3 00 00 00       	jmpq   803752 <getint+0x10a>
	else if (lflag)
  8036af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8036b3:	74 4f                	je     803704 <getint+0xbc>
		x=va_arg(*ap, long);
  8036b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036b9:	8b 00                	mov    (%rax),%eax
  8036bb:	83 f8 30             	cmp    $0x30,%eax
  8036be:	73 24                	jae    8036e4 <getint+0x9c>
  8036c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036c4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8036c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036cc:	8b 00                	mov    (%rax),%eax
  8036ce:	89 c0                	mov    %eax,%eax
  8036d0:	48 01 d0             	add    %rdx,%rax
  8036d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036d7:	8b 12                	mov    (%rdx),%edx
  8036d9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8036dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036e0:	89 0a                	mov    %ecx,(%rdx)
  8036e2:	eb 17                	jmp    8036fb <getint+0xb3>
  8036e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036e8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8036ec:	48 89 d0             	mov    %rdx,%rax
  8036ef:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8036f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8036fb:	48 8b 00             	mov    (%rax),%rax
  8036fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803702:	eb 4e                	jmp    803752 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  803704:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803708:	8b 00                	mov    (%rax),%eax
  80370a:	83 f8 30             	cmp    $0x30,%eax
  80370d:	73 24                	jae    803733 <getint+0xeb>
  80370f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803713:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803717:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80371b:	8b 00                	mov    (%rax),%eax
  80371d:	89 c0                	mov    %eax,%eax
  80371f:	48 01 d0             	add    %rdx,%rax
  803722:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803726:	8b 12                	mov    (%rdx),%edx
  803728:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80372b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80372f:	89 0a                	mov    %ecx,(%rdx)
  803731:	eb 17                	jmp    80374a <getint+0x102>
  803733:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803737:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80373b:	48 89 d0             	mov    %rdx,%rax
  80373e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803742:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803746:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80374a:	8b 00                	mov    (%rax),%eax
  80374c:	48 98                	cltq   
  80374e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803752:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803756:	c9                   	leaveq 
  803757:	c3                   	retq   

0000000000803758 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  803758:	55                   	push   %rbp
  803759:	48 89 e5             	mov    %rsp,%rbp
  80375c:	41 54                	push   %r12
  80375e:	53                   	push   %rbx
  80375f:	48 83 ec 60          	sub    $0x60,%rsp
  803763:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  803767:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80376b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80376f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  803773:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803777:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80377b:	48 8b 0a             	mov    (%rdx),%rcx
  80377e:	48 89 08             	mov    %rcx,(%rax)
  803781:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803785:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803789:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80378d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803791:	eb 17                	jmp    8037aa <vprintfmt+0x52>
			if (ch == '\0')
  803793:	85 db                	test   %ebx,%ebx
  803795:	0f 84 cc 04 00 00    	je     803c67 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80379b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80379f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8037a3:	48 89 d6             	mov    %rdx,%rsi
  8037a6:	89 df                	mov    %ebx,%edi
  8037a8:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8037aa:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8037ae:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8037b2:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8037b6:	0f b6 00             	movzbl (%rax),%eax
  8037b9:	0f b6 d8             	movzbl %al,%ebx
  8037bc:	83 fb 25             	cmp    $0x25,%ebx
  8037bf:	75 d2                	jne    803793 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8037c1:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8037c5:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8037cc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8037d3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8037da:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8037e1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8037e5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8037e9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8037ed:	0f b6 00             	movzbl (%rax),%eax
  8037f0:	0f b6 d8             	movzbl %al,%ebx
  8037f3:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8037f6:	83 f8 55             	cmp    $0x55,%eax
  8037f9:	0f 87 34 04 00 00    	ja     803c33 <vprintfmt+0x4db>
  8037ff:	89 c0                	mov    %eax,%eax
  803801:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803808:	00 
  803809:	48 b8 10 6e 80 00 00 	movabs $0x806e10,%rax
  803810:	00 00 00 
  803813:	48 01 d0             	add    %rdx,%rax
  803816:	48 8b 00             	mov    (%rax),%rax
  803819:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  80381b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80381f:	eb c0                	jmp    8037e1 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  803821:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  803825:	eb ba                	jmp    8037e1 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803827:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80382e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  803831:	89 d0                	mov    %edx,%eax
  803833:	c1 e0 02             	shl    $0x2,%eax
  803836:	01 d0                	add    %edx,%eax
  803838:	01 c0                	add    %eax,%eax
  80383a:	01 d8                	add    %ebx,%eax
  80383c:	83 e8 30             	sub    $0x30,%eax
  80383f:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  803842:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803846:	0f b6 00             	movzbl (%rax),%eax
  803849:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80384c:	83 fb 2f             	cmp    $0x2f,%ebx
  80384f:	7e 0c                	jle    80385d <vprintfmt+0x105>
  803851:	83 fb 39             	cmp    $0x39,%ebx
  803854:	7f 07                	jg     80385d <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803856:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80385b:	eb d1                	jmp    80382e <vprintfmt+0xd6>
			goto process_precision;
  80385d:	eb 58                	jmp    8038b7 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80385f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803862:	83 f8 30             	cmp    $0x30,%eax
  803865:	73 17                	jae    80387e <vprintfmt+0x126>
  803867:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80386b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80386e:	89 c0                	mov    %eax,%eax
  803870:	48 01 d0             	add    %rdx,%rax
  803873:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803876:	83 c2 08             	add    $0x8,%edx
  803879:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80387c:	eb 0f                	jmp    80388d <vprintfmt+0x135>
  80387e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803882:	48 89 d0             	mov    %rdx,%rax
  803885:	48 83 c2 08          	add    $0x8,%rdx
  803889:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80388d:	8b 00                	mov    (%rax),%eax
  80388f:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  803892:	eb 23                	jmp    8038b7 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  803894:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803898:	79 0c                	jns    8038a6 <vprintfmt+0x14e>
				width = 0;
  80389a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8038a1:	e9 3b ff ff ff       	jmpq   8037e1 <vprintfmt+0x89>
  8038a6:	e9 36 ff ff ff       	jmpq   8037e1 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8038ab:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8038b2:	e9 2a ff ff ff       	jmpq   8037e1 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8038b7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8038bb:	79 12                	jns    8038cf <vprintfmt+0x177>
				width = precision, precision = -1;
  8038bd:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8038c0:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8038c3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8038ca:	e9 12 ff ff ff       	jmpq   8037e1 <vprintfmt+0x89>
  8038cf:	e9 0d ff ff ff       	jmpq   8037e1 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8038d4:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8038d8:	e9 04 ff ff ff       	jmpq   8037e1 <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8038dd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8038e0:	83 f8 30             	cmp    $0x30,%eax
  8038e3:	73 17                	jae    8038fc <vprintfmt+0x1a4>
  8038e5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8038e9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8038ec:	89 c0                	mov    %eax,%eax
  8038ee:	48 01 d0             	add    %rdx,%rax
  8038f1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8038f4:	83 c2 08             	add    $0x8,%edx
  8038f7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8038fa:	eb 0f                	jmp    80390b <vprintfmt+0x1b3>
  8038fc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803900:	48 89 d0             	mov    %rdx,%rax
  803903:	48 83 c2 08          	add    $0x8,%rdx
  803907:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80390b:	8b 10                	mov    (%rax),%edx
  80390d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803911:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803915:	48 89 ce             	mov    %rcx,%rsi
  803918:	89 d7                	mov    %edx,%edi
  80391a:	ff d0                	callq  *%rax
			break;
  80391c:	e9 40 03 00 00       	jmpq   803c61 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  803921:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803924:	83 f8 30             	cmp    $0x30,%eax
  803927:	73 17                	jae    803940 <vprintfmt+0x1e8>
  803929:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80392d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803930:	89 c0                	mov    %eax,%eax
  803932:	48 01 d0             	add    %rdx,%rax
  803935:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803938:	83 c2 08             	add    $0x8,%edx
  80393b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80393e:	eb 0f                	jmp    80394f <vprintfmt+0x1f7>
  803940:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803944:	48 89 d0             	mov    %rdx,%rax
  803947:	48 83 c2 08          	add    $0x8,%rdx
  80394b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80394f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  803951:	85 db                	test   %ebx,%ebx
  803953:	79 02                	jns    803957 <vprintfmt+0x1ff>
				err = -err;
  803955:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  803957:	83 fb 10             	cmp    $0x10,%ebx
  80395a:	7f 16                	jg     803972 <vprintfmt+0x21a>
  80395c:	48 b8 60 6d 80 00 00 	movabs $0x806d60,%rax
  803963:	00 00 00 
  803966:	48 63 d3             	movslq %ebx,%rdx
  803969:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80396d:	4d 85 e4             	test   %r12,%r12
  803970:	75 2e                	jne    8039a0 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  803972:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803976:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80397a:	89 d9                	mov    %ebx,%ecx
  80397c:	48 ba f9 6d 80 00 00 	movabs $0x806df9,%rdx
  803983:	00 00 00 
  803986:	48 89 c7             	mov    %rax,%rdi
  803989:	b8 00 00 00 00       	mov    $0x0,%eax
  80398e:	49 b8 70 3c 80 00 00 	movabs $0x803c70,%r8
  803995:	00 00 00 
  803998:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80399b:	e9 c1 02 00 00       	jmpq   803c61 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8039a0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8039a4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8039a8:	4c 89 e1             	mov    %r12,%rcx
  8039ab:	48 ba 02 6e 80 00 00 	movabs $0x806e02,%rdx
  8039b2:	00 00 00 
  8039b5:	48 89 c7             	mov    %rax,%rdi
  8039b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8039bd:	49 b8 70 3c 80 00 00 	movabs $0x803c70,%r8
  8039c4:	00 00 00 
  8039c7:	41 ff d0             	callq  *%r8
			break;
  8039ca:	e9 92 02 00 00       	jmpq   803c61 <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8039cf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8039d2:	83 f8 30             	cmp    $0x30,%eax
  8039d5:	73 17                	jae    8039ee <vprintfmt+0x296>
  8039d7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8039db:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8039de:	89 c0                	mov    %eax,%eax
  8039e0:	48 01 d0             	add    %rdx,%rax
  8039e3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8039e6:	83 c2 08             	add    $0x8,%edx
  8039e9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8039ec:	eb 0f                	jmp    8039fd <vprintfmt+0x2a5>
  8039ee:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8039f2:	48 89 d0             	mov    %rdx,%rax
  8039f5:	48 83 c2 08          	add    $0x8,%rdx
  8039f9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8039fd:	4c 8b 20             	mov    (%rax),%r12
  803a00:	4d 85 e4             	test   %r12,%r12
  803a03:	75 0a                	jne    803a0f <vprintfmt+0x2b7>
				p = "(null)";
  803a05:	49 bc 05 6e 80 00 00 	movabs $0x806e05,%r12
  803a0c:	00 00 00 
			if (width > 0 && padc != '-')
  803a0f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803a13:	7e 3f                	jle    803a54 <vprintfmt+0x2fc>
  803a15:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  803a19:	74 39                	je     803a54 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  803a1b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803a1e:	48 98                	cltq   
  803a20:	48 89 c6             	mov    %rax,%rsi
  803a23:	4c 89 e7             	mov    %r12,%rdi
  803a26:	48 b8 1c 3f 80 00 00 	movabs $0x803f1c,%rax
  803a2d:	00 00 00 
  803a30:	ff d0                	callq  *%rax
  803a32:	29 45 dc             	sub    %eax,-0x24(%rbp)
  803a35:	eb 17                	jmp    803a4e <vprintfmt+0x2f6>
					putch(padc, putdat);
  803a37:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  803a3b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803a3f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803a43:	48 89 ce             	mov    %rcx,%rsi
  803a46:	89 d7                	mov    %edx,%edi
  803a48:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  803a4a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803a4e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803a52:	7f e3                	jg     803a37 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803a54:	eb 37                	jmp    803a8d <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  803a56:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  803a5a:	74 1e                	je     803a7a <vprintfmt+0x322>
  803a5c:	83 fb 1f             	cmp    $0x1f,%ebx
  803a5f:	7e 05                	jle    803a66 <vprintfmt+0x30e>
  803a61:	83 fb 7e             	cmp    $0x7e,%ebx
  803a64:	7e 14                	jle    803a7a <vprintfmt+0x322>
					putch('?', putdat);
  803a66:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803a6a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803a6e:	48 89 d6             	mov    %rdx,%rsi
  803a71:	bf 3f 00 00 00       	mov    $0x3f,%edi
  803a76:	ff d0                	callq  *%rax
  803a78:	eb 0f                	jmp    803a89 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  803a7a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803a7e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803a82:	48 89 d6             	mov    %rdx,%rsi
  803a85:	89 df                	mov    %ebx,%edi
  803a87:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803a89:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803a8d:	4c 89 e0             	mov    %r12,%rax
  803a90:	4c 8d 60 01          	lea    0x1(%rax),%r12
  803a94:	0f b6 00             	movzbl (%rax),%eax
  803a97:	0f be d8             	movsbl %al,%ebx
  803a9a:	85 db                	test   %ebx,%ebx
  803a9c:	74 10                	je     803aae <vprintfmt+0x356>
  803a9e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803aa2:	78 b2                	js     803a56 <vprintfmt+0x2fe>
  803aa4:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  803aa8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803aac:	79 a8                	jns    803a56 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803aae:	eb 16                	jmp    803ac6 <vprintfmt+0x36e>
				putch(' ', putdat);
  803ab0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803ab4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803ab8:	48 89 d6             	mov    %rdx,%rsi
  803abb:	bf 20 00 00 00       	mov    $0x20,%edi
  803ac0:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803ac2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803ac6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803aca:	7f e4                	jg     803ab0 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  803acc:	e9 90 01 00 00       	jmpq   803c61 <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  803ad1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803ad5:	be 03 00 00 00       	mov    $0x3,%esi
  803ada:	48 89 c7             	mov    %rax,%rdi
  803add:	48 b8 48 36 80 00 00 	movabs $0x803648,%rax
  803ae4:	00 00 00 
  803ae7:	ff d0                	callq  *%rax
  803ae9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  803aed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803af1:	48 85 c0             	test   %rax,%rax
  803af4:	79 1d                	jns    803b13 <vprintfmt+0x3bb>
				putch('-', putdat);
  803af6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803afa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803afe:	48 89 d6             	mov    %rdx,%rsi
  803b01:	bf 2d 00 00 00       	mov    $0x2d,%edi
  803b06:	ff d0                	callq  *%rax
				num = -(long long) num;
  803b08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b0c:	48 f7 d8             	neg    %rax
  803b0f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  803b13:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803b1a:	e9 d5 00 00 00       	jmpq   803bf4 <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  803b1f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803b23:	be 03 00 00 00       	mov    $0x3,%esi
  803b28:	48 89 c7             	mov    %rax,%rdi
  803b2b:	48 b8 38 35 80 00 00 	movabs $0x803538,%rax
  803b32:	00 00 00 
  803b35:	ff d0                	callq  *%rax
  803b37:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  803b3b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803b42:	e9 ad 00 00 00       	jmpq   803bf4 <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  803b47:	8b 55 e0             	mov    -0x20(%rbp),%edx
  803b4a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803b4e:	89 d6                	mov    %edx,%esi
  803b50:	48 89 c7             	mov    %rax,%rdi
  803b53:	48 b8 48 36 80 00 00 	movabs $0x803648,%rax
  803b5a:	00 00 00 
  803b5d:	ff d0                	callq  *%rax
  803b5f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  803b63:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  803b6a:	e9 85 00 00 00       	jmpq   803bf4 <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  803b6f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803b73:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b77:	48 89 d6             	mov    %rdx,%rsi
  803b7a:	bf 30 00 00 00       	mov    $0x30,%edi
  803b7f:	ff d0                	callq  *%rax
			putch('x', putdat);
  803b81:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803b85:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b89:	48 89 d6             	mov    %rdx,%rsi
  803b8c:	bf 78 00 00 00       	mov    $0x78,%edi
  803b91:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803b93:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803b96:	83 f8 30             	cmp    $0x30,%eax
  803b99:	73 17                	jae    803bb2 <vprintfmt+0x45a>
  803b9b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803b9f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803ba2:	89 c0                	mov    %eax,%eax
  803ba4:	48 01 d0             	add    %rdx,%rax
  803ba7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803baa:	83 c2 08             	add    $0x8,%edx
  803bad:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803bb0:	eb 0f                	jmp    803bc1 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  803bb2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803bb6:	48 89 d0             	mov    %rdx,%rax
  803bb9:	48 83 c2 08          	add    $0x8,%rdx
  803bbd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803bc1:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803bc4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  803bc8:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  803bcf:	eb 23                	jmp    803bf4 <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  803bd1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803bd5:	be 03 00 00 00       	mov    $0x3,%esi
  803bda:	48 89 c7             	mov    %rax,%rdi
  803bdd:	48 b8 38 35 80 00 00 	movabs $0x803538,%rax
  803be4:	00 00 00 
  803be7:	ff d0                	callq  *%rax
  803be9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  803bed:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  803bf4:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  803bf9:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803bfc:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803bff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c03:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803c07:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803c0b:	45 89 c1             	mov    %r8d,%r9d
  803c0e:	41 89 f8             	mov    %edi,%r8d
  803c11:	48 89 c7             	mov    %rax,%rdi
  803c14:	48 b8 7d 34 80 00 00 	movabs $0x80347d,%rax
  803c1b:	00 00 00 
  803c1e:	ff d0                	callq  *%rax
			break;
  803c20:	eb 3f                	jmp    803c61 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  803c22:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803c26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803c2a:	48 89 d6             	mov    %rdx,%rsi
  803c2d:	89 df                	mov    %ebx,%edi
  803c2f:	ff d0                	callq  *%rax
			break;
  803c31:	eb 2e                	jmp    803c61 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  803c33:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803c37:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803c3b:	48 89 d6             	mov    %rdx,%rsi
  803c3e:	bf 25 00 00 00       	mov    $0x25,%edi
  803c43:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  803c45:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803c4a:	eb 05                	jmp    803c51 <vprintfmt+0x4f9>
  803c4c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803c51:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803c55:	48 83 e8 01          	sub    $0x1,%rax
  803c59:	0f b6 00             	movzbl (%rax),%eax
  803c5c:	3c 25                	cmp    $0x25,%al
  803c5e:	75 ec                	jne    803c4c <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  803c60:	90                   	nop
		}
	}
  803c61:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803c62:	e9 43 fb ff ff       	jmpq   8037aa <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  803c67:	48 83 c4 60          	add    $0x60,%rsp
  803c6b:	5b                   	pop    %rbx
  803c6c:	41 5c                	pop    %r12
  803c6e:	5d                   	pop    %rbp
  803c6f:	c3                   	retq   

0000000000803c70 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  803c70:	55                   	push   %rbp
  803c71:	48 89 e5             	mov    %rsp,%rbp
  803c74:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  803c7b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803c82:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  803c89:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803c90:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803c97:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803c9e:	84 c0                	test   %al,%al
  803ca0:	74 20                	je     803cc2 <printfmt+0x52>
  803ca2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803ca6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803caa:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803cae:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803cb2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803cb6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803cba:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803cbe:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803cc2:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803cc9:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  803cd0:	00 00 00 
  803cd3:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  803cda:	00 00 00 
  803cdd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803ce1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  803ce8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803cef:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  803cf6:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  803cfd:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803d04:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  803d0b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803d12:	48 89 c7             	mov    %rax,%rdi
  803d15:	48 b8 58 37 80 00 00 	movabs $0x803758,%rax
  803d1c:	00 00 00 
  803d1f:	ff d0                	callq  *%rax
	va_end(ap);
}
  803d21:	c9                   	leaveq 
  803d22:	c3                   	retq   

0000000000803d23 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  803d23:	55                   	push   %rbp
  803d24:	48 89 e5             	mov    %rsp,%rbp
  803d27:	48 83 ec 10          	sub    $0x10,%rsp
  803d2b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d2e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803d32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d36:	8b 40 10             	mov    0x10(%rax),%eax
  803d39:	8d 50 01             	lea    0x1(%rax),%edx
  803d3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d40:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  803d43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d47:	48 8b 10             	mov    (%rax),%rdx
  803d4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d4e:	48 8b 40 08          	mov    0x8(%rax),%rax
  803d52:	48 39 c2             	cmp    %rax,%rdx
  803d55:	73 17                	jae    803d6e <sprintputch+0x4b>
		*b->buf++ = ch;
  803d57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d5b:	48 8b 00             	mov    (%rax),%rax
  803d5e:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803d62:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d66:	48 89 0a             	mov    %rcx,(%rdx)
  803d69:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d6c:	88 10                	mov    %dl,(%rax)
}
  803d6e:	c9                   	leaveq 
  803d6f:	c3                   	retq   

0000000000803d70 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803d70:	55                   	push   %rbp
  803d71:	48 89 e5             	mov    %rsp,%rbp
  803d74:	48 83 ec 50          	sub    $0x50,%rsp
  803d78:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803d7c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  803d7f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  803d83:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  803d87:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803d8b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  803d8f:	48 8b 0a             	mov    (%rdx),%rcx
  803d92:	48 89 08             	mov    %rcx,(%rax)
  803d95:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803d99:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803d9d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803da1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803da5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803da9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803dad:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803db0:	48 98                	cltq   
  803db2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803db6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803dba:	48 01 d0             	add    %rdx,%rax
  803dbd:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803dc1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  803dc8:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  803dcd:	74 06                	je     803dd5 <vsnprintf+0x65>
  803dcf:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803dd3:	7f 07                	jg     803ddc <vsnprintf+0x6c>
		return -E_INVAL;
  803dd5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803dda:	eb 2f                	jmp    803e0b <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  803ddc:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  803de0:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803de4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803de8:	48 89 c6             	mov    %rax,%rsi
  803deb:	48 bf 23 3d 80 00 00 	movabs $0x803d23,%rdi
  803df2:	00 00 00 
  803df5:	48 b8 58 37 80 00 00 	movabs $0x803758,%rax
  803dfc:	00 00 00 
  803dff:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  803e01:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e05:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  803e08:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  803e0b:	c9                   	leaveq 
  803e0c:	c3                   	retq   

0000000000803e0d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  803e0d:	55                   	push   %rbp
  803e0e:	48 89 e5             	mov    %rsp,%rbp
  803e11:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  803e18:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803e1f:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803e25:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803e2c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803e33:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803e3a:	84 c0                	test   %al,%al
  803e3c:	74 20                	je     803e5e <snprintf+0x51>
  803e3e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803e42:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803e46:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803e4a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803e4e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803e52:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803e56:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803e5a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803e5e:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  803e65:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  803e6c:	00 00 00 
  803e6f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803e76:	00 00 00 
  803e79:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803e7d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803e84:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803e8b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  803e92:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803e99:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803ea0:	48 8b 0a             	mov    (%rdx),%rcx
  803ea3:	48 89 08             	mov    %rcx,(%rax)
  803ea6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803eaa:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803eae:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803eb2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803eb6:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  803ebd:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  803ec4:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  803eca:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803ed1:	48 89 c7             	mov    %rax,%rdi
  803ed4:	48 b8 70 3d 80 00 00 	movabs $0x803d70,%rax
  803edb:	00 00 00 
  803ede:	ff d0                	callq  *%rax
  803ee0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  803ee6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803eec:	c9                   	leaveq 
  803eed:	c3                   	retq   

0000000000803eee <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  803eee:	55                   	push   %rbp
  803eef:	48 89 e5             	mov    %rsp,%rbp
  803ef2:	48 83 ec 18          	sub    $0x18,%rsp
  803ef6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  803efa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f01:	eb 09                	jmp    803f0c <strlen+0x1e>
		n++;
  803f03:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  803f07:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803f0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f10:	0f b6 00             	movzbl (%rax),%eax
  803f13:	84 c0                	test   %al,%al
  803f15:	75 ec                	jne    803f03 <strlen+0x15>
		n++;
	return n;
  803f17:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803f1a:	c9                   	leaveq 
  803f1b:	c3                   	retq   

0000000000803f1c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  803f1c:	55                   	push   %rbp
  803f1d:	48 89 e5             	mov    %rsp,%rbp
  803f20:	48 83 ec 20          	sub    $0x20,%rsp
  803f24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f28:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803f2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f33:	eb 0e                	jmp    803f43 <strnlen+0x27>
		n++;
  803f35:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803f39:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803f3e:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  803f43:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f48:	74 0b                	je     803f55 <strnlen+0x39>
  803f4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f4e:	0f b6 00             	movzbl (%rax),%eax
  803f51:	84 c0                	test   %al,%al
  803f53:	75 e0                	jne    803f35 <strnlen+0x19>
		n++;
	return n;
  803f55:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803f58:	c9                   	leaveq 
  803f59:	c3                   	retq   

0000000000803f5a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  803f5a:	55                   	push   %rbp
  803f5b:	48 89 e5             	mov    %rsp,%rbp
  803f5e:	48 83 ec 20          	sub    $0x20,%rsp
  803f62:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  803f6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f6e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  803f72:	90                   	nop
  803f73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f77:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803f7b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  803f7f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f83:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  803f87:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  803f8b:	0f b6 12             	movzbl (%rdx),%edx
  803f8e:	88 10                	mov    %dl,(%rax)
  803f90:	0f b6 00             	movzbl (%rax),%eax
  803f93:	84 c0                	test   %al,%al
  803f95:	75 dc                	jne    803f73 <strcpy+0x19>
		/* do nothing */;
	return ret;
  803f97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803f9b:	c9                   	leaveq 
  803f9c:	c3                   	retq   

0000000000803f9d <strcat>:

char *
strcat(char *dst, const char *src)
{
  803f9d:	55                   	push   %rbp
  803f9e:	48 89 e5             	mov    %rsp,%rbp
  803fa1:	48 83 ec 20          	sub    $0x20,%rsp
  803fa5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803fa9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  803fad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fb1:	48 89 c7             	mov    %rax,%rdi
  803fb4:	48 b8 ee 3e 80 00 00 	movabs $0x803eee,%rax
  803fbb:	00 00 00 
  803fbe:	ff d0                	callq  *%rax
  803fc0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  803fc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc6:	48 63 d0             	movslq %eax,%rdx
  803fc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fcd:	48 01 c2             	add    %rax,%rdx
  803fd0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fd4:	48 89 c6             	mov    %rax,%rsi
  803fd7:	48 89 d7             	mov    %rdx,%rdi
  803fda:	48 b8 5a 3f 80 00 00 	movabs $0x803f5a,%rax
  803fe1:	00 00 00 
  803fe4:	ff d0                	callq  *%rax
	return dst;
  803fe6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803fea:	c9                   	leaveq 
  803feb:	c3                   	retq   

0000000000803fec <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  803fec:	55                   	push   %rbp
  803fed:	48 89 e5             	mov    %rsp,%rbp
  803ff0:	48 83 ec 28          	sub    $0x28,%rsp
  803ff4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ff8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ffc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  804000:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804004:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  804008:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80400f:	00 
  804010:	eb 2a                	jmp    80403c <strncpy+0x50>
		*dst++ = *src;
  804012:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804016:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80401a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80401e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804022:	0f b6 12             	movzbl (%rdx),%edx
  804025:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  804027:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80402b:	0f b6 00             	movzbl (%rax),%eax
  80402e:	84 c0                	test   %al,%al
  804030:	74 05                	je     804037 <strncpy+0x4b>
			src++;
  804032:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  804037:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80403c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804040:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  804044:	72 cc                	jb     804012 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  804046:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80404a:	c9                   	leaveq 
  80404b:	c3                   	retq   

000000000080404c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80404c:	55                   	push   %rbp
  80404d:	48 89 e5             	mov    %rsp,%rbp
  804050:	48 83 ec 28          	sub    $0x28,%rsp
  804054:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804058:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80405c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  804060:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804064:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  804068:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80406d:	74 3d                	je     8040ac <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80406f:	eb 1d                	jmp    80408e <strlcpy+0x42>
			*dst++ = *src++;
  804071:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804075:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804079:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80407d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804081:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  804085:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  804089:	0f b6 12             	movzbl (%rdx),%edx
  80408c:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80408e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  804093:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804098:	74 0b                	je     8040a5 <strlcpy+0x59>
  80409a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80409e:	0f b6 00             	movzbl (%rax),%eax
  8040a1:	84 c0                	test   %al,%al
  8040a3:	75 cc                	jne    804071 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8040a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040a9:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8040ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8040b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040b4:	48 29 c2             	sub    %rax,%rdx
  8040b7:	48 89 d0             	mov    %rdx,%rax
}
  8040ba:	c9                   	leaveq 
  8040bb:	c3                   	retq   

00000000008040bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8040bc:	55                   	push   %rbp
  8040bd:	48 89 e5             	mov    %rsp,%rbp
  8040c0:	48 83 ec 10          	sub    $0x10,%rsp
  8040c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8040c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8040cc:	eb 0a                	jmp    8040d8 <strcmp+0x1c>
		p++, q++;
  8040ce:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8040d3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8040d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040dc:	0f b6 00             	movzbl (%rax),%eax
  8040df:	84 c0                	test   %al,%al
  8040e1:	74 12                	je     8040f5 <strcmp+0x39>
  8040e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040e7:	0f b6 10             	movzbl (%rax),%edx
  8040ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040ee:	0f b6 00             	movzbl (%rax),%eax
  8040f1:	38 c2                	cmp    %al,%dl
  8040f3:	74 d9                	je     8040ce <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8040f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040f9:	0f b6 00             	movzbl (%rax),%eax
  8040fc:	0f b6 d0             	movzbl %al,%edx
  8040ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804103:	0f b6 00             	movzbl (%rax),%eax
  804106:	0f b6 c0             	movzbl %al,%eax
  804109:	29 c2                	sub    %eax,%edx
  80410b:	89 d0                	mov    %edx,%eax
}
  80410d:	c9                   	leaveq 
  80410e:	c3                   	retq   

000000000080410f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80410f:	55                   	push   %rbp
  804110:	48 89 e5             	mov    %rsp,%rbp
  804113:	48 83 ec 18          	sub    $0x18,%rsp
  804117:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80411b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80411f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  804123:	eb 0f                	jmp    804134 <strncmp+0x25>
		n--, p++, q++;
  804125:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80412a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80412f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  804134:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804139:	74 1d                	je     804158 <strncmp+0x49>
  80413b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80413f:	0f b6 00             	movzbl (%rax),%eax
  804142:	84 c0                	test   %al,%al
  804144:	74 12                	je     804158 <strncmp+0x49>
  804146:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80414a:	0f b6 10             	movzbl (%rax),%edx
  80414d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804151:	0f b6 00             	movzbl (%rax),%eax
  804154:	38 c2                	cmp    %al,%dl
  804156:	74 cd                	je     804125 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  804158:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80415d:	75 07                	jne    804166 <strncmp+0x57>
		return 0;
  80415f:	b8 00 00 00 00       	mov    $0x0,%eax
  804164:	eb 18                	jmp    80417e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  804166:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80416a:	0f b6 00             	movzbl (%rax),%eax
  80416d:	0f b6 d0             	movzbl %al,%edx
  804170:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804174:	0f b6 00             	movzbl (%rax),%eax
  804177:	0f b6 c0             	movzbl %al,%eax
  80417a:	29 c2                	sub    %eax,%edx
  80417c:	89 d0                	mov    %edx,%eax
}
  80417e:	c9                   	leaveq 
  80417f:	c3                   	retq   

0000000000804180 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  804180:	55                   	push   %rbp
  804181:	48 89 e5             	mov    %rsp,%rbp
  804184:	48 83 ec 0c          	sub    $0xc,%rsp
  804188:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80418c:	89 f0                	mov    %esi,%eax
  80418e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  804191:	eb 17                	jmp    8041aa <strchr+0x2a>
		if (*s == c)
  804193:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804197:	0f b6 00             	movzbl (%rax),%eax
  80419a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80419d:	75 06                	jne    8041a5 <strchr+0x25>
			return (char *) s;
  80419f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041a3:	eb 15                	jmp    8041ba <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8041a5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8041aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041ae:	0f b6 00             	movzbl (%rax),%eax
  8041b1:	84 c0                	test   %al,%al
  8041b3:	75 de                	jne    804193 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8041b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041ba:	c9                   	leaveq 
  8041bb:	c3                   	retq   

00000000008041bc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8041bc:	55                   	push   %rbp
  8041bd:	48 89 e5             	mov    %rsp,%rbp
  8041c0:	48 83 ec 0c          	sub    $0xc,%rsp
  8041c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8041c8:	89 f0                	mov    %esi,%eax
  8041ca:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8041cd:	eb 13                	jmp    8041e2 <strfind+0x26>
		if (*s == c)
  8041cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041d3:	0f b6 00             	movzbl (%rax),%eax
  8041d6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8041d9:	75 02                	jne    8041dd <strfind+0x21>
			break;
  8041db:	eb 10                	jmp    8041ed <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8041dd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8041e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041e6:	0f b6 00             	movzbl (%rax),%eax
  8041e9:	84 c0                	test   %al,%al
  8041eb:	75 e2                	jne    8041cf <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8041ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8041f1:	c9                   	leaveq 
  8041f2:	c3                   	retq   

00000000008041f3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8041f3:	55                   	push   %rbp
  8041f4:	48 89 e5             	mov    %rsp,%rbp
  8041f7:	48 83 ec 18          	sub    $0x18,%rsp
  8041fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8041ff:	89 75 f4             	mov    %esi,-0xc(%rbp)
  804202:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  804206:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80420b:	75 06                	jne    804213 <memset+0x20>
		return v;
  80420d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804211:	eb 69                	jmp    80427c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  804213:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804217:	83 e0 03             	and    $0x3,%eax
  80421a:	48 85 c0             	test   %rax,%rax
  80421d:	75 48                	jne    804267 <memset+0x74>
  80421f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804223:	83 e0 03             	and    $0x3,%eax
  804226:	48 85 c0             	test   %rax,%rax
  804229:	75 3c                	jne    804267 <memset+0x74>
		c &= 0xFF;
  80422b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  804232:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804235:	c1 e0 18             	shl    $0x18,%eax
  804238:	89 c2                	mov    %eax,%edx
  80423a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80423d:	c1 e0 10             	shl    $0x10,%eax
  804240:	09 c2                	or     %eax,%edx
  804242:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804245:	c1 e0 08             	shl    $0x8,%eax
  804248:	09 d0                	or     %edx,%eax
  80424a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80424d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804251:	48 c1 e8 02          	shr    $0x2,%rax
  804255:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  804258:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80425c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80425f:	48 89 d7             	mov    %rdx,%rdi
  804262:	fc                   	cld    
  804263:	f3 ab                	rep stos %eax,%es:(%rdi)
  804265:	eb 11                	jmp    804278 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  804267:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80426b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80426e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804272:	48 89 d7             	mov    %rdx,%rdi
  804275:	fc                   	cld    
  804276:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  804278:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80427c:	c9                   	leaveq 
  80427d:	c3                   	retq   

000000000080427e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80427e:	55                   	push   %rbp
  80427f:	48 89 e5             	mov    %rsp,%rbp
  804282:	48 83 ec 28          	sub    $0x28,%rsp
  804286:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80428a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80428e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  804292:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804296:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80429a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80429e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8042a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042a6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8042aa:	0f 83 88 00 00 00    	jae    804338 <memmove+0xba>
  8042b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042b4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8042b8:	48 01 d0             	add    %rdx,%rax
  8042bb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8042bf:	76 77                	jbe    804338 <memmove+0xba>
		s += n;
  8042c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042c5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8042c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042cd:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8042d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042d5:	83 e0 03             	and    $0x3,%eax
  8042d8:	48 85 c0             	test   %rax,%rax
  8042db:	75 3b                	jne    804318 <memmove+0x9a>
  8042dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042e1:	83 e0 03             	and    $0x3,%eax
  8042e4:	48 85 c0             	test   %rax,%rax
  8042e7:	75 2f                	jne    804318 <memmove+0x9a>
  8042e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042ed:	83 e0 03             	and    $0x3,%eax
  8042f0:	48 85 c0             	test   %rax,%rax
  8042f3:	75 23                	jne    804318 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8042f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042f9:	48 83 e8 04          	sub    $0x4,%rax
  8042fd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804301:	48 83 ea 04          	sub    $0x4,%rdx
  804305:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  804309:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80430d:	48 89 c7             	mov    %rax,%rdi
  804310:	48 89 d6             	mov    %rdx,%rsi
  804313:	fd                   	std    
  804314:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  804316:	eb 1d                	jmp    804335 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  804318:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80431c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  804320:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804324:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  804328:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80432c:	48 89 d7             	mov    %rdx,%rdi
  80432f:	48 89 c1             	mov    %rax,%rcx
  804332:	fd                   	std    
  804333:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  804335:	fc                   	cld    
  804336:	eb 57                	jmp    80438f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  804338:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80433c:	83 e0 03             	and    $0x3,%eax
  80433f:	48 85 c0             	test   %rax,%rax
  804342:	75 36                	jne    80437a <memmove+0xfc>
  804344:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804348:	83 e0 03             	and    $0x3,%eax
  80434b:	48 85 c0             	test   %rax,%rax
  80434e:	75 2a                	jne    80437a <memmove+0xfc>
  804350:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804354:	83 e0 03             	and    $0x3,%eax
  804357:	48 85 c0             	test   %rax,%rax
  80435a:	75 1e                	jne    80437a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80435c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804360:	48 c1 e8 02          	shr    $0x2,%rax
  804364:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  804367:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80436b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80436f:	48 89 c7             	mov    %rax,%rdi
  804372:	48 89 d6             	mov    %rdx,%rsi
  804375:	fc                   	cld    
  804376:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  804378:	eb 15                	jmp    80438f <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80437a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80437e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804382:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  804386:	48 89 c7             	mov    %rax,%rdi
  804389:	48 89 d6             	mov    %rdx,%rsi
  80438c:	fc                   	cld    
  80438d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80438f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804393:	c9                   	leaveq 
  804394:	c3                   	retq   

0000000000804395 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  804395:	55                   	push   %rbp
  804396:	48 89 e5             	mov    %rsp,%rbp
  804399:	48 83 ec 18          	sub    $0x18,%rsp
  80439d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8043a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8043a5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8043a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8043ad:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8043b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043b5:	48 89 ce             	mov    %rcx,%rsi
  8043b8:	48 89 c7             	mov    %rax,%rdi
  8043bb:	48 b8 7e 42 80 00 00 	movabs $0x80427e,%rax
  8043c2:	00 00 00 
  8043c5:	ff d0                	callq  *%rax
}
  8043c7:	c9                   	leaveq 
  8043c8:	c3                   	retq   

00000000008043c9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8043c9:	55                   	push   %rbp
  8043ca:	48 89 e5             	mov    %rsp,%rbp
  8043cd:	48 83 ec 28          	sub    $0x28,%rsp
  8043d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8043d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8043d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8043dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8043e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043e9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8043ed:	eb 36                	jmp    804425 <memcmp+0x5c>
		if (*s1 != *s2)
  8043ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043f3:	0f b6 10             	movzbl (%rax),%edx
  8043f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043fa:	0f b6 00             	movzbl (%rax),%eax
  8043fd:	38 c2                	cmp    %al,%dl
  8043ff:	74 1a                	je     80441b <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  804401:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804405:	0f b6 00             	movzbl (%rax),%eax
  804408:	0f b6 d0             	movzbl %al,%edx
  80440b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80440f:	0f b6 00             	movzbl (%rax),%eax
  804412:	0f b6 c0             	movzbl %al,%eax
  804415:	29 c2                	sub    %eax,%edx
  804417:	89 d0                	mov    %edx,%eax
  804419:	eb 20                	jmp    80443b <memcmp+0x72>
		s1++, s2++;
  80441b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804420:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  804425:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804429:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80442d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  804431:	48 85 c0             	test   %rax,%rax
  804434:	75 b9                	jne    8043ef <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  804436:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80443b:	c9                   	leaveq 
  80443c:	c3                   	retq   

000000000080443d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80443d:	55                   	push   %rbp
  80443e:	48 89 e5             	mov    %rsp,%rbp
  804441:	48 83 ec 28          	sub    $0x28,%rsp
  804445:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804449:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80444c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  804450:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804454:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804458:	48 01 d0             	add    %rdx,%rax
  80445b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80445f:	eb 15                	jmp    804476 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  804461:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804465:	0f b6 10             	movzbl (%rax),%edx
  804468:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80446b:	38 c2                	cmp    %al,%dl
  80446d:	75 02                	jne    804471 <memfind+0x34>
			break;
  80446f:	eb 0f                	jmp    804480 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  804471:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  804476:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80447a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80447e:	72 e1                	jb     804461 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  804480:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804484:	c9                   	leaveq 
  804485:	c3                   	retq   

0000000000804486 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  804486:	55                   	push   %rbp
  804487:	48 89 e5             	mov    %rsp,%rbp
  80448a:	48 83 ec 34          	sub    $0x34,%rsp
  80448e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804492:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804496:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  804499:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8044a0:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8044a7:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8044a8:	eb 05                	jmp    8044af <strtol+0x29>
		s++;
  8044aa:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8044af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044b3:	0f b6 00             	movzbl (%rax),%eax
  8044b6:	3c 20                	cmp    $0x20,%al
  8044b8:	74 f0                	je     8044aa <strtol+0x24>
  8044ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044be:	0f b6 00             	movzbl (%rax),%eax
  8044c1:	3c 09                	cmp    $0x9,%al
  8044c3:	74 e5                	je     8044aa <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8044c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044c9:	0f b6 00             	movzbl (%rax),%eax
  8044cc:	3c 2b                	cmp    $0x2b,%al
  8044ce:	75 07                	jne    8044d7 <strtol+0x51>
		s++;
  8044d0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8044d5:	eb 17                	jmp    8044ee <strtol+0x68>
	else if (*s == '-')
  8044d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044db:	0f b6 00             	movzbl (%rax),%eax
  8044de:	3c 2d                	cmp    $0x2d,%al
  8044e0:	75 0c                	jne    8044ee <strtol+0x68>
		s++, neg = 1;
  8044e2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8044e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8044ee:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8044f2:	74 06                	je     8044fa <strtol+0x74>
  8044f4:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8044f8:	75 28                	jne    804522 <strtol+0x9c>
  8044fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044fe:	0f b6 00             	movzbl (%rax),%eax
  804501:	3c 30                	cmp    $0x30,%al
  804503:	75 1d                	jne    804522 <strtol+0x9c>
  804505:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804509:	48 83 c0 01          	add    $0x1,%rax
  80450d:	0f b6 00             	movzbl (%rax),%eax
  804510:	3c 78                	cmp    $0x78,%al
  804512:	75 0e                	jne    804522 <strtol+0x9c>
		s += 2, base = 16;
  804514:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  804519:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  804520:	eb 2c                	jmp    80454e <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  804522:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  804526:	75 19                	jne    804541 <strtol+0xbb>
  804528:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80452c:	0f b6 00             	movzbl (%rax),%eax
  80452f:	3c 30                	cmp    $0x30,%al
  804531:	75 0e                	jne    804541 <strtol+0xbb>
		s++, base = 8;
  804533:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  804538:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80453f:	eb 0d                	jmp    80454e <strtol+0xc8>
	else if (base == 0)
  804541:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  804545:	75 07                	jne    80454e <strtol+0xc8>
		base = 10;
  804547:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80454e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804552:	0f b6 00             	movzbl (%rax),%eax
  804555:	3c 2f                	cmp    $0x2f,%al
  804557:	7e 1d                	jle    804576 <strtol+0xf0>
  804559:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80455d:	0f b6 00             	movzbl (%rax),%eax
  804560:	3c 39                	cmp    $0x39,%al
  804562:	7f 12                	jg     804576 <strtol+0xf0>
			dig = *s - '0';
  804564:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804568:	0f b6 00             	movzbl (%rax),%eax
  80456b:	0f be c0             	movsbl %al,%eax
  80456e:	83 e8 30             	sub    $0x30,%eax
  804571:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804574:	eb 4e                	jmp    8045c4 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  804576:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80457a:	0f b6 00             	movzbl (%rax),%eax
  80457d:	3c 60                	cmp    $0x60,%al
  80457f:	7e 1d                	jle    80459e <strtol+0x118>
  804581:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804585:	0f b6 00             	movzbl (%rax),%eax
  804588:	3c 7a                	cmp    $0x7a,%al
  80458a:	7f 12                	jg     80459e <strtol+0x118>
			dig = *s - 'a' + 10;
  80458c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804590:	0f b6 00             	movzbl (%rax),%eax
  804593:	0f be c0             	movsbl %al,%eax
  804596:	83 e8 57             	sub    $0x57,%eax
  804599:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80459c:	eb 26                	jmp    8045c4 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80459e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045a2:	0f b6 00             	movzbl (%rax),%eax
  8045a5:	3c 40                	cmp    $0x40,%al
  8045a7:	7e 48                	jle    8045f1 <strtol+0x16b>
  8045a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045ad:	0f b6 00             	movzbl (%rax),%eax
  8045b0:	3c 5a                	cmp    $0x5a,%al
  8045b2:	7f 3d                	jg     8045f1 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8045b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045b8:	0f b6 00             	movzbl (%rax),%eax
  8045bb:	0f be c0             	movsbl %al,%eax
  8045be:	83 e8 37             	sub    $0x37,%eax
  8045c1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8045c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045c7:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8045ca:	7c 02                	jl     8045ce <strtol+0x148>
			break;
  8045cc:	eb 23                	jmp    8045f1 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8045ce:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8045d3:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8045d6:	48 98                	cltq   
  8045d8:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8045dd:	48 89 c2             	mov    %rax,%rdx
  8045e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045e3:	48 98                	cltq   
  8045e5:	48 01 d0             	add    %rdx,%rax
  8045e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8045ec:	e9 5d ff ff ff       	jmpq   80454e <strtol+0xc8>

	if (endptr)
  8045f1:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8045f6:	74 0b                	je     804603 <strtol+0x17d>
		*endptr = (char *) s;
  8045f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8045fc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804600:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  804603:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804607:	74 09                	je     804612 <strtol+0x18c>
  804609:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80460d:	48 f7 d8             	neg    %rax
  804610:	eb 04                	jmp    804616 <strtol+0x190>
  804612:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  804616:	c9                   	leaveq 
  804617:	c3                   	retq   

0000000000804618 <strstr>:

char * strstr(const char *in, const char *str)
{
  804618:	55                   	push   %rbp
  804619:	48 89 e5             	mov    %rsp,%rbp
  80461c:	48 83 ec 30          	sub    $0x30,%rsp
  804620:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804624:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  804628:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80462c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804630:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804634:	0f b6 00             	movzbl (%rax),%eax
  804637:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  80463a:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80463e:	75 06                	jne    804646 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  804640:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804644:	eb 6b                	jmp    8046b1 <strstr+0x99>

    len = strlen(str);
  804646:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80464a:	48 89 c7             	mov    %rax,%rdi
  80464d:	48 b8 ee 3e 80 00 00 	movabs $0x803eee,%rax
  804654:	00 00 00 
  804657:	ff d0                	callq  *%rax
  804659:	48 98                	cltq   
  80465b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80465f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804663:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804667:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80466b:	0f b6 00             	movzbl (%rax),%eax
  80466e:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  804671:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  804675:	75 07                	jne    80467e <strstr+0x66>
                return (char *) 0;
  804677:	b8 00 00 00 00       	mov    $0x0,%eax
  80467c:	eb 33                	jmp    8046b1 <strstr+0x99>
        } while (sc != c);
  80467e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  804682:	3a 45 ff             	cmp    -0x1(%rbp),%al
  804685:	75 d8                	jne    80465f <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  804687:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80468b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80468f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804693:	48 89 ce             	mov    %rcx,%rsi
  804696:	48 89 c7             	mov    %rax,%rdi
  804699:	48 b8 0f 41 80 00 00 	movabs $0x80410f,%rax
  8046a0:	00 00 00 
  8046a3:	ff d0                	callq  *%rax
  8046a5:	85 c0                	test   %eax,%eax
  8046a7:	75 b6                	jne    80465f <strstr+0x47>

    return (char *) (in - 1);
  8046a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046ad:	48 83 e8 01          	sub    $0x1,%rax
}
  8046b1:	c9                   	leaveq 
  8046b2:	c3                   	retq   

00000000008046b3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8046b3:	55                   	push   %rbp
  8046b4:	48 89 e5             	mov    %rsp,%rbp
  8046b7:	53                   	push   %rbx
  8046b8:	48 83 ec 48          	sub    $0x48,%rsp
  8046bc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8046bf:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8046c2:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8046c6:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8046ca:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8046ce:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8046d2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8046d5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8046d9:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8046dd:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8046e1:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8046e5:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8046e9:	4c 89 c3             	mov    %r8,%rbx
  8046ec:	cd 30                	int    $0x30
  8046ee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8046f2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8046f6:	74 3e                	je     804736 <syscall+0x83>
  8046f8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8046fd:	7e 37                	jle    804736 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8046ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804703:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804706:	49 89 d0             	mov    %rdx,%r8
  804709:	89 c1                	mov    %eax,%ecx
  80470b:	48 ba c0 70 80 00 00 	movabs $0x8070c0,%rdx
  804712:	00 00 00 
  804715:	be 23 00 00 00       	mov    $0x23,%esi
  80471a:	48 bf dd 70 80 00 00 	movabs $0x8070dd,%rdi
  804721:	00 00 00 
  804724:	b8 00 00 00 00       	mov    $0x0,%eax
  804729:	49 b9 6c 31 80 00 00 	movabs $0x80316c,%r9
  804730:	00 00 00 
  804733:	41 ff d1             	callq  *%r9

	return ret;
  804736:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80473a:	48 83 c4 48          	add    $0x48,%rsp
  80473e:	5b                   	pop    %rbx
  80473f:	5d                   	pop    %rbp
  804740:	c3                   	retq   

0000000000804741 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  804741:	55                   	push   %rbp
  804742:	48 89 e5             	mov    %rsp,%rbp
  804745:	48 83 ec 20          	sub    $0x20,%rsp
  804749:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80474d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  804751:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804755:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804759:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804760:	00 
  804761:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804767:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80476d:	48 89 d1             	mov    %rdx,%rcx
  804770:	48 89 c2             	mov    %rax,%rdx
  804773:	be 00 00 00 00       	mov    $0x0,%esi
  804778:	bf 00 00 00 00       	mov    $0x0,%edi
  80477d:	48 b8 b3 46 80 00 00 	movabs $0x8046b3,%rax
  804784:	00 00 00 
  804787:	ff d0                	callq  *%rax
}
  804789:	c9                   	leaveq 
  80478a:	c3                   	retq   

000000000080478b <sys_cgetc>:

int
sys_cgetc(void)
{
  80478b:	55                   	push   %rbp
  80478c:	48 89 e5             	mov    %rsp,%rbp
  80478f:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  804793:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80479a:	00 
  80479b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8047a1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8047a7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8047ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8047b1:	be 00 00 00 00       	mov    $0x0,%esi
  8047b6:	bf 01 00 00 00       	mov    $0x1,%edi
  8047bb:	48 b8 b3 46 80 00 00 	movabs $0x8046b3,%rax
  8047c2:	00 00 00 
  8047c5:	ff d0                	callq  *%rax
}
  8047c7:	c9                   	leaveq 
  8047c8:	c3                   	retq   

00000000008047c9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8047c9:	55                   	push   %rbp
  8047ca:	48 89 e5             	mov    %rsp,%rbp
  8047cd:	48 83 ec 10          	sub    $0x10,%rsp
  8047d1:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8047d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047d7:	48 98                	cltq   
  8047d9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8047e0:	00 
  8047e1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8047e7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8047ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8047f2:	48 89 c2             	mov    %rax,%rdx
  8047f5:	be 01 00 00 00       	mov    $0x1,%esi
  8047fa:	bf 03 00 00 00       	mov    $0x3,%edi
  8047ff:	48 b8 b3 46 80 00 00 	movabs $0x8046b3,%rax
  804806:	00 00 00 
  804809:	ff d0                	callq  *%rax
}
  80480b:	c9                   	leaveq 
  80480c:	c3                   	retq   

000000000080480d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80480d:	55                   	push   %rbp
  80480e:	48 89 e5             	mov    %rsp,%rbp
  804811:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  804815:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80481c:	00 
  80481d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804823:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804829:	b9 00 00 00 00       	mov    $0x0,%ecx
  80482e:	ba 00 00 00 00       	mov    $0x0,%edx
  804833:	be 00 00 00 00       	mov    $0x0,%esi
  804838:	bf 02 00 00 00       	mov    $0x2,%edi
  80483d:	48 b8 b3 46 80 00 00 	movabs $0x8046b3,%rax
  804844:	00 00 00 
  804847:	ff d0                	callq  *%rax
}
  804849:	c9                   	leaveq 
  80484a:	c3                   	retq   

000000000080484b <sys_yield>:

void
sys_yield(void)
{
  80484b:	55                   	push   %rbp
  80484c:	48 89 e5             	mov    %rsp,%rbp
  80484f:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  804853:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80485a:	00 
  80485b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804861:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804867:	b9 00 00 00 00       	mov    $0x0,%ecx
  80486c:	ba 00 00 00 00       	mov    $0x0,%edx
  804871:	be 00 00 00 00       	mov    $0x0,%esi
  804876:	bf 0b 00 00 00       	mov    $0xb,%edi
  80487b:	48 b8 b3 46 80 00 00 	movabs $0x8046b3,%rax
  804882:	00 00 00 
  804885:	ff d0                	callq  *%rax
}
  804887:	c9                   	leaveq 
  804888:	c3                   	retq   

0000000000804889 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  804889:	55                   	push   %rbp
  80488a:	48 89 e5             	mov    %rsp,%rbp
  80488d:	48 83 ec 20          	sub    $0x20,%rsp
  804891:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804894:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804898:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80489b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80489e:	48 63 c8             	movslq %eax,%rcx
  8048a1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8048a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048a8:	48 98                	cltq   
  8048aa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8048b1:	00 
  8048b2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8048b8:	49 89 c8             	mov    %rcx,%r8
  8048bb:	48 89 d1             	mov    %rdx,%rcx
  8048be:	48 89 c2             	mov    %rax,%rdx
  8048c1:	be 01 00 00 00       	mov    $0x1,%esi
  8048c6:	bf 04 00 00 00       	mov    $0x4,%edi
  8048cb:	48 b8 b3 46 80 00 00 	movabs $0x8046b3,%rax
  8048d2:	00 00 00 
  8048d5:	ff d0                	callq  *%rax
}
  8048d7:	c9                   	leaveq 
  8048d8:	c3                   	retq   

00000000008048d9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8048d9:	55                   	push   %rbp
  8048da:	48 89 e5             	mov    %rsp,%rbp
  8048dd:	48 83 ec 30          	sub    $0x30,%rsp
  8048e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8048e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8048e8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8048eb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8048ef:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8048f3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8048f6:	48 63 c8             	movslq %eax,%rcx
  8048f9:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8048fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804900:	48 63 f0             	movslq %eax,%rsi
  804903:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804907:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80490a:	48 98                	cltq   
  80490c:	48 89 0c 24          	mov    %rcx,(%rsp)
  804910:	49 89 f9             	mov    %rdi,%r9
  804913:	49 89 f0             	mov    %rsi,%r8
  804916:	48 89 d1             	mov    %rdx,%rcx
  804919:	48 89 c2             	mov    %rax,%rdx
  80491c:	be 01 00 00 00       	mov    $0x1,%esi
  804921:	bf 05 00 00 00       	mov    $0x5,%edi
  804926:	48 b8 b3 46 80 00 00 	movabs $0x8046b3,%rax
  80492d:	00 00 00 
  804930:	ff d0                	callq  *%rax
}
  804932:	c9                   	leaveq 
  804933:	c3                   	retq   

0000000000804934 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  804934:	55                   	push   %rbp
  804935:	48 89 e5             	mov    %rsp,%rbp
  804938:	48 83 ec 20          	sub    $0x20,%rsp
  80493c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80493f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  804943:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804947:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80494a:	48 98                	cltq   
  80494c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804953:	00 
  804954:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80495a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804960:	48 89 d1             	mov    %rdx,%rcx
  804963:	48 89 c2             	mov    %rax,%rdx
  804966:	be 01 00 00 00       	mov    $0x1,%esi
  80496b:	bf 06 00 00 00       	mov    $0x6,%edi
  804970:	48 b8 b3 46 80 00 00 	movabs $0x8046b3,%rax
  804977:	00 00 00 
  80497a:	ff d0                	callq  *%rax
}
  80497c:	c9                   	leaveq 
  80497d:	c3                   	retq   

000000000080497e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80497e:	55                   	push   %rbp
  80497f:	48 89 e5             	mov    %rsp,%rbp
  804982:	48 83 ec 10          	sub    $0x10,%rsp
  804986:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804989:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80498c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80498f:	48 63 d0             	movslq %eax,%rdx
  804992:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804995:	48 98                	cltq   
  804997:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80499e:	00 
  80499f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8049a5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8049ab:	48 89 d1             	mov    %rdx,%rcx
  8049ae:	48 89 c2             	mov    %rax,%rdx
  8049b1:	be 01 00 00 00       	mov    $0x1,%esi
  8049b6:	bf 08 00 00 00       	mov    $0x8,%edi
  8049bb:	48 b8 b3 46 80 00 00 	movabs $0x8046b3,%rax
  8049c2:	00 00 00 
  8049c5:	ff d0                	callq  *%rax
}
  8049c7:	c9                   	leaveq 
  8049c8:	c3                   	retq   

00000000008049c9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8049c9:	55                   	push   %rbp
  8049ca:	48 89 e5             	mov    %rsp,%rbp
  8049cd:	48 83 ec 20          	sub    $0x20,%rsp
  8049d1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8049d4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8049d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8049dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049df:	48 98                	cltq   
  8049e1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8049e8:	00 
  8049e9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8049ef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8049f5:	48 89 d1             	mov    %rdx,%rcx
  8049f8:	48 89 c2             	mov    %rax,%rdx
  8049fb:	be 01 00 00 00       	mov    $0x1,%esi
  804a00:	bf 09 00 00 00       	mov    $0x9,%edi
  804a05:	48 b8 b3 46 80 00 00 	movabs $0x8046b3,%rax
  804a0c:	00 00 00 
  804a0f:	ff d0                	callq  *%rax
}
  804a11:	c9                   	leaveq 
  804a12:	c3                   	retq   

0000000000804a13 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  804a13:	55                   	push   %rbp
  804a14:	48 89 e5             	mov    %rsp,%rbp
  804a17:	48 83 ec 20          	sub    $0x20,%rsp
  804a1b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804a1e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  804a22:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a29:	48 98                	cltq   
  804a2b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804a32:	00 
  804a33:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804a39:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804a3f:	48 89 d1             	mov    %rdx,%rcx
  804a42:	48 89 c2             	mov    %rax,%rdx
  804a45:	be 01 00 00 00       	mov    $0x1,%esi
  804a4a:	bf 0a 00 00 00       	mov    $0xa,%edi
  804a4f:	48 b8 b3 46 80 00 00 	movabs $0x8046b3,%rax
  804a56:	00 00 00 
  804a59:	ff d0                	callq  *%rax
}
  804a5b:	c9                   	leaveq 
  804a5c:	c3                   	retq   

0000000000804a5d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  804a5d:	55                   	push   %rbp
  804a5e:	48 89 e5             	mov    %rsp,%rbp
  804a61:	48 83 ec 20          	sub    $0x20,%rsp
  804a65:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804a68:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804a6c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804a70:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  804a73:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804a76:	48 63 f0             	movslq %eax,%rsi
  804a79:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804a7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a80:	48 98                	cltq   
  804a82:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a86:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804a8d:	00 
  804a8e:	49 89 f1             	mov    %rsi,%r9
  804a91:	49 89 c8             	mov    %rcx,%r8
  804a94:	48 89 d1             	mov    %rdx,%rcx
  804a97:	48 89 c2             	mov    %rax,%rdx
  804a9a:	be 00 00 00 00       	mov    $0x0,%esi
  804a9f:	bf 0c 00 00 00       	mov    $0xc,%edi
  804aa4:	48 b8 b3 46 80 00 00 	movabs $0x8046b3,%rax
  804aab:	00 00 00 
  804aae:	ff d0                	callq  *%rax
}
  804ab0:	c9                   	leaveq 
  804ab1:	c3                   	retq   

0000000000804ab2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  804ab2:	55                   	push   %rbp
  804ab3:	48 89 e5             	mov    %rsp,%rbp
  804ab6:	48 83 ec 10          	sub    $0x10,%rsp
  804aba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  804abe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ac2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804ac9:	00 
  804aca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804ad0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804ad6:	b9 00 00 00 00       	mov    $0x0,%ecx
  804adb:	48 89 c2             	mov    %rax,%rdx
  804ade:	be 01 00 00 00       	mov    $0x1,%esi
  804ae3:	bf 0d 00 00 00       	mov    $0xd,%edi
  804ae8:	48 b8 b3 46 80 00 00 	movabs $0x8046b3,%rax
  804aef:	00 00 00 
  804af2:	ff d0                	callq  *%rax
}
  804af4:	c9                   	leaveq 
  804af5:	c3                   	retq   

0000000000804af6 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804af6:	55                   	push   %rbp
  804af7:	48 89 e5             	mov    %rsp,%rbp
  804afa:	48 83 ec 10          	sub    $0x10,%rsp
  804afe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804b02:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  804b09:	00 00 00 
  804b0c:	48 8b 00             	mov    (%rax),%rax
  804b0f:	48 85 c0             	test   %rax,%rax
  804b12:	0f 85 84 00 00 00    	jne    804b9c <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  804b18:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804b1f:	00 00 00 
  804b22:	48 8b 00             	mov    (%rax),%rax
  804b25:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804b2b:	ba 07 00 00 00       	mov    $0x7,%edx
  804b30:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804b35:	89 c7                	mov    %eax,%edi
  804b37:	48 b8 89 48 80 00 00 	movabs $0x804889,%rax
  804b3e:	00 00 00 
  804b41:	ff d0                	callq  *%rax
  804b43:	85 c0                	test   %eax,%eax
  804b45:	79 2a                	jns    804b71 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  804b47:	48 ba f0 70 80 00 00 	movabs $0x8070f0,%rdx
  804b4e:	00 00 00 
  804b51:	be 23 00 00 00       	mov    $0x23,%esi
  804b56:	48 bf 17 71 80 00 00 	movabs $0x807117,%rdi
  804b5d:	00 00 00 
  804b60:	b8 00 00 00 00       	mov    $0x0,%eax
  804b65:	48 b9 6c 31 80 00 00 	movabs $0x80316c,%rcx
  804b6c:	00 00 00 
  804b6f:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  804b71:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804b78:	00 00 00 
  804b7b:	48 8b 00             	mov    (%rax),%rax
  804b7e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804b84:	48 be af 4b 80 00 00 	movabs $0x804baf,%rsi
  804b8b:	00 00 00 
  804b8e:	89 c7                	mov    %eax,%edi
  804b90:	48 b8 13 4a 80 00 00 	movabs $0x804a13,%rax
  804b97:	00 00 00 
  804b9a:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  804b9c:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  804ba3:	00 00 00 
  804ba6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804baa:	48 89 10             	mov    %rdx,(%rax)
}
  804bad:	c9                   	leaveq 
  804bae:	c3                   	retq   

0000000000804baf <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  804baf:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  804bb2:	48 a1 20 20 81 00 00 	movabs 0x812020,%rax
  804bb9:	00 00 00 
	call *%rax
  804bbc:	ff d0                	callq  *%rax


	/*This code is to be removed*/

	// LAB 4: Your code here.
	movq 136(%rsp), %rbx  //Load RIP 
  804bbe:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804bc5:	00 
	movq 152(%rsp), %rcx  //Load RSP
  804bc6:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804bcd:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  804bce:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  804bd2:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  804bd5:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804bdc:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  804bdd:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  804be1:	4c 8b 3c 24          	mov    (%rsp),%r15
  804be5:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804bea:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804bef:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804bf4:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804bf9:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804bfe:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804c03:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804c08:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804c0d:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804c12:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804c17:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804c1c:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804c21:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804c26:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804c2b:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  804c2f:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  804c33:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  804c34:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  804c35:	c3                   	retq   

0000000000804c36 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804c36:	55                   	push   %rbp
  804c37:	48 89 e5             	mov    %rsp,%rbp
  804c3a:	48 83 ec 30          	sub    $0x30,%rsp
  804c3e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804c42:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804c46:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804c4a:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804c51:	00 00 00 
  804c54:	48 8b 00             	mov    (%rax),%rax
  804c57:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804c5d:	85 c0                	test   %eax,%eax
  804c5f:	75 3c                	jne    804c9d <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  804c61:	48 b8 0d 48 80 00 00 	movabs $0x80480d,%rax
  804c68:	00 00 00 
  804c6b:	ff d0                	callq  *%rax
  804c6d:	25 ff 03 00 00       	and    $0x3ff,%eax
  804c72:	48 63 d0             	movslq %eax,%rdx
  804c75:	48 89 d0             	mov    %rdx,%rax
  804c78:	48 c1 e0 03          	shl    $0x3,%rax
  804c7c:	48 01 d0             	add    %rdx,%rax
  804c7f:	48 c1 e0 05          	shl    $0x5,%rax
  804c83:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804c8a:	00 00 00 
  804c8d:	48 01 c2             	add    %rax,%rdx
  804c90:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804c97:	00 00 00 
  804c9a:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804c9d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804ca2:	75 0e                	jne    804cb2 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  804ca4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804cab:	00 00 00 
  804cae:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804cb2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804cb6:	48 89 c7             	mov    %rax,%rdi
  804cb9:	48 b8 b2 4a 80 00 00 	movabs $0x804ab2,%rax
  804cc0:	00 00 00 
  804cc3:	ff d0                	callq  *%rax
  804cc5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804cc8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ccc:	79 19                	jns    804ce7 <ipc_recv+0xb1>
		*from_env_store = 0;
  804cce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804cd2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  804cd8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804cdc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  804ce2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ce5:	eb 53                	jmp    804d3a <ipc_recv+0x104>
	}
	if(from_env_store)
  804ce7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804cec:	74 19                	je     804d07 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  804cee:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804cf5:	00 00 00 
  804cf8:	48 8b 00             	mov    (%rax),%rax
  804cfb:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804d01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d05:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804d07:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804d0c:	74 19                	je     804d27 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  804d0e:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804d15:	00 00 00 
  804d18:	48 8b 00             	mov    (%rax),%rax
  804d1b:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804d21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d25:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804d27:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804d2e:	00 00 00 
  804d31:	48 8b 00             	mov    (%rax),%rax
  804d34:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804d3a:	c9                   	leaveq 
  804d3b:	c3                   	retq   

0000000000804d3c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804d3c:	55                   	push   %rbp
  804d3d:	48 89 e5             	mov    %rsp,%rbp
  804d40:	48 83 ec 30          	sub    $0x30,%rsp
  804d44:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804d47:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804d4a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804d4e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804d51:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804d56:	75 0e                	jne    804d66 <ipc_send+0x2a>
		pg = (void*)UTOP;
  804d58:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804d5f:	00 00 00 
  804d62:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804d66:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804d69:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804d6c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804d70:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804d73:	89 c7                	mov    %eax,%edi
  804d75:	48 b8 5d 4a 80 00 00 	movabs $0x804a5d,%rax
  804d7c:	00 00 00 
  804d7f:	ff d0                	callq  *%rax
  804d81:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804d84:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804d88:	75 0c                	jne    804d96 <ipc_send+0x5a>
			sys_yield();
  804d8a:	48 b8 4b 48 80 00 00 	movabs $0x80484b,%rax
  804d91:	00 00 00 
  804d94:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804d96:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804d9a:	74 ca                	je     804d66 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  804d9c:	c9                   	leaveq 
  804d9d:	c3                   	retq   

0000000000804d9e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804d9e:	55                   	push   %rbp
  804d9f:	48 89 e5             	mov    %rsp,%rbp
  804da2:	48 83 ec 14          	sub    $0x14,%rsp
  804da6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  804da9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804db0:	eb 5e                	jmp    804e10 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804db2:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804db9:	00 00 00 
  804dbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804dbf:	48 63 d0             	movslq %eax,%rdx
  804dc2:	48 89 d0             	mov    %rdx,%rax
  804dc5:	48 c1 e0 03          	shl    $0x3,%rax
  804dc9:	48 01 d0             	add    %rdx,%rax
  804dcc:	48 c1 e0 05          	shl    $0x5,%rax
  804dd0:	48 01 c8             	add    %rcx,%rax
  804dd3:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804dd9:	8b 00                	mov    (%rax),%eax
  804ddb:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804dde:	75 2c                	jne    804e0c <ipc_find_env+0x6e>
			return envs[i].env_id;
  804de0:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804de7:	00 00 00 
  804dea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ded:	48 63 d0             	movslq %eax,%rdx
  804df0:	48 89 d0             	mov    %rdx,%rax
  804df3:	48 c1 e0 03          	shl    $0x3,%rax
  804df7:	48 01 d0             	add    %rdx,%rax
  804dfa:	48 c1 e0 05          	shl    $0x5,%rax
  804dfe:	48 01 c8             	add    %rcx,%rax
  804e01:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804e07:	8b 40 08             	mov    0x8(%rax),%eax
  804e0a:	eb 12                	jmp    804e1e <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  804e0c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804e10:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804e17:	7e 99                	jle    804db2 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  804e19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804e1e:	c9                   	leaveq 
  804e1f:	c3                   	retq   

0000000000804e20 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  804e20:	55                   	push   %rbp
  804e21:	48 89 e5             	mov    %rsp,%rbp
  804e24:	48 83 ec 08          	sub    $0x8,%rsp
  804e28:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  804e2c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804e30:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  804e37:	ff ff ff 
  804e3a:	48 01 d0             	add    %rdx,%rax
  804e3d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  804e41:	c9                   	leaveq 
  804e42:	c3                   	retq   

0000000000804e43 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  804e43:	55                   	push   %rbp
  804e44:	48 89 e5             	mov    %rsp,%rbp
  804e47:	48 83 ec 08          	sub    $0x8,%rsp
  804e4b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  804e4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804e53:	48 89 c7             	mov    %rax,%rdi
  804e56:	48 b8 20 4e 80 00 00 	movabs $0x804e20,%rax
  804e5d:	00 00 00 
  804e60:	ff d0                	callq  *%rax
  804e62:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  804e68:	48 c1 e0 0c          	shl    $0xc,%rax
}
  804e6c:	c9                   	leaveq 
  804e6d:	c3                   	retq   

0000000000804e6e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  804e6e:	55                   	push   %rbp
  804e6f:	48 89 e5             	mov    %rsp,%rbp
  804e72:	48 83 ec 18          	sub    $0x18,%rsp
  804e76:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  804e7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804e81:	eb 6b                	jmp    804eee <fd_alloc+0x80>
		fd = INDEX2FD(i);
  804e83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e86:	48 98                	cltq   
  804e88:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  804e8e:	48 c1 e0 0c          	shl    $0xc,%rax
  804e92:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  804e96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e9a:	48 c1 e8 15          	shr    $0x15,%rax
  804e9e:	48 89 c2             	mov    %rax,%rdx
  804ea1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804ea8:	01 00 00 
  804eab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804eaf:	83 e0 01             	and    $0x1,%eax
  804eb2:	48 85 c0             	test   %rax,%rax
  804eb5:	74 21                	je     804ed8 <fd_alloc+0x6a>
  804eb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ebb:	48 c1 e8 0c          	shr    $0xc,%rax
  804ebf:	48 89 c2             	mov    %rax,%rdx
  804ec2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804ec9:	01 00 00 
  804ecc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804ed0:	83 e0 01             	and    $0x1,%eax
  804ed3:	48 85 c0             	test   %rax,%rax
  804ed6:	75 12                	jne    804eea <fd_alloc+0x7c>
			*fd_store = fd;
  804ed8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804edc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804ee0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  804ee3:	b8 00 00 00 00       	mov    $0x0,%eax
  804ee8:	eb 1a                	jmp    804f04 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  804eea:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804eee:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  804ef2:	7e 8f                	jle    804e83 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  804ef4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ef8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  804eff:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  804f04:	c9                   	leaveq 
  804f05:	c3                   	retq   

0000000000804f06 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  804f06:	55                   	push   %rbp
  804f07:	48 89 e5             	mov    %rsp,%rbp
  804f0a:	48 83 ec 20          	sub    $0x20,%rsp
  804f0e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804f11:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  804f15:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804f19:	78 06                	js     804f21 <fd_lookup+0x1b>
  804f1b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  804f1f:	7e 07                	jle    804f28 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  804f21:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  804f26:	eb 6c                	jmp    804f94 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  804f28:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804f2b:	48 98                	cltq   
  804f2d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  804f33:	48 c1 e0 0c          	shl    $0xc,%rax
  804f37:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  804f3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804f3f:	48 c1 e8 15          	shr    $0x15,%rax
  804f43:	48 89 c2             	mov    %rax,%rdx
  804f46:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804f4d:	01 00 00 
  804f50:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804f54:	83 e0 01             	and    $0x1,%eax
  804f57:	48 85 c0             	test   %rax,%rax
  804f5a:	74 21                	je     804f7d <fd_lookup+0x77>
  804f5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804f60:	48 c1 e8 0c          	shr    $0xc,%rax
  804f64:	48 89 c2             	mov    %rax,%rdx
  804f67:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804f6e:	01 00 00 
  804f71:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804f75:	83 e0 01             	and    $0x1,%eax
  804f78:	48 85 c0             	test   %rax,%rax
  804f7b:	75 07                	jne    804f84 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  804f7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  804f82:	eb 10                	jmp    804f94 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  804f84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804f88:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804f8c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  804f8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804f94:	c9                   	leaveq 
  804f95:	c3                   	retq   

0000000000804f96 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  804f96:	55                   	push   %rbp
  804f97:	48 89 e5             	mov    %rsp,%rbp
  804f9a:	48 83 ec 30          	sub    $0x30,%rsp
  804f9e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804fa2:	89 f0                	mov    %esi,%eax
  804fa4:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  804fa7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804fab:	48 89 c7             	mov    %rax,%rdi
  804fae:	48 b8 20 4e 80 00 00 	movabs $0x804e20,%rax
  804fb5:	00 00 00 
  804fb8:	ff d0                	callq  *%rax
  804fba:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804fbe:	48 89 d6             	mov    %rdx,%rsi
  804fc1:	89 c7                	mov    %eax,%edi
  804fc3:	48 b8 06 4f 80 00 00 	movabs $0x804f06,%rax
  804fca:	00 00 00 
  804fcd:	ff d0                	callq  *%rax
  804fcf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804fd2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804fd6:	78 0a                	js     804fe2 <fd_close+0x4c>
	    || fd != fd2)
  804fd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804fdc:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  804fe0:	74 12                	je     804ff4 <fd_close+0x5e>
		return (must_exist ? r : 0);
  804fe2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  804fe6:	74 05                	je     804fed <fd_close+0x57>
  804fe8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804feb:	eb 05                	jmp    804ff2 <fd_close+0x5c>
  804fed:	b8 00 00 00 00       	mov    $0x0,%eax
  804ff2:	eb 69                	jmp    80505d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  804ff4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ff8:	8b 00                	mov    (%rax),%eax
  804ffa:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804ffe:	48 89 d6             	mov    %rdx,%rsi
  805001:	89 c7                	mov    %eax,%edi
  805003:	48 b8 5f 50 80 00 00 	movabs $0x80505f,%rax
  80500a:	00 00 00 
  80500d:	ff d0                	callq  *%rax
  80500f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805012:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805016:	78 2a                	js     805042 <fd_close+0xac>
		if (dev->dev_close)
  805018:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80501c:	48 8b 40 20          	mov    0x20(%rax),%rax
  805020:	48 85 c0             	test   %rax,%rax
  805023:	74 16                	je     80503b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  805025:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805029:	48 8b 40 20          	mov    0x20(%rax),%rax
  80502d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805031:	48 89 d7             	mov    %rdx,%rdi
  805034:	ff d0                	callq  *%rax
  805036:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805039:	eb 07                	jmp    805042 <fd_close+0xac>
		else
			r = 0;
  80503b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  805042:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805046:	48 89 c6             	mov    %rax,%rsi
  805049:	bf 00 00 00 00       	mov    $0x0,%edi
  80504e:	48 b8 34 49 80 00 00 	movabs $0x804934,%rax
  805055:	00 00 00 
  805058:	ff d0                	callq  *%rax
	return r;
  80505a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80505d:	c9                   	leaveq 
  80505e:	c3                   	retq   

000000000080505f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80505f:	55                   	push   %rbp
  805060:	48 89 e5             	mov    %rsp,%rbp
  805063:	48 83 ec 20          	sub    $0x20,%rsp
  805067:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80506a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80506e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805075:	eb 41                	jmp    8050b8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  805077:	48 b8 a0 10 81 00 00 	movabs $0x8110a0,%rax
  80507e:	00 00 00 
  805081:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805084:	48 63 d2             	movslq %edx,%rdx
  805087:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80508b:	8b 00                	mov    (%rax),%eax
  80508d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805090:	75 22                	jne    8050b4 <dev_lookup+0x55>
			*dev = devtab[i];
  805092:	48 b8 a0 10 81 00 00 	movabs $0x8110a0,%rax
  805099:	00 00 00 
  80509c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80509f:	48 63 d2             	movslq %edx,%rdx
  8050a2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8050a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8050aa:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8050ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8050b2:	eb 60                	jmp    805114 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8050b4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8050b8:	48 b8 a0 10 81 00 00 	movabs $0x8110a0,%rax
  8050bf:	00 00 00 
  8050c2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8050c5:	48 63 d2             	movslq %edx,%rdx
  8050c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8050cc:	48 85 c0             	test   %rax,%rax
  8050cf:	75 a6                	jne    805077 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8050d1:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  8050d8:	00 00 00 
  8050db:	48 8b 00             	mov    (%rax),%rax
  8050de:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8050e4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8050e7:	89 c6                	mov    %eax,%esi
  8050e9:	48 bf 28 71 80 00 00 	movabs $0x807128,%rdi
  8050f0:	00 00 00 
  8050f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8050f8:	48 b9 a5 33 80 00 00 	movabs $0x8033a5,%rcx
  8050ff:	00 00 00 
  805102:	ff d1                	callq  *%rcx
	*dev = 0;
  805104:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805108:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80510f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  805114:	c9                   	leaveq 
  805115:	c3                   	retq   

0000000000805116 <close>:

int
close(int fdnum)
{
  805116:	55                   	push   %rbp
  805117:	48 89 e5             	mov    %rsp,%rbp
  80511a:	48 83 ec 20          	sub    $0x20,%rsp
  80511e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  805121:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805125:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805128:	48 89 d6             	mov    %rdx,%rsi
  80512b:	89 c7                	mov    %eax,%edi
  80512d:	48 b8 06 4f 80 00 00 	movabs $0x804f06,%rax
  805134:	00 00 00 
  805137:	ff d0                	callq  *%rax
  805139:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80513c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805140:	79 05                	jns    805147 <close+0x31>
		return r;
  805142:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805145:	eb 18                	jmp    80515f <close+0x49>
	else
		return fd_close(fd, 1);
  805147:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80514b:	be 01 00 00 00       	mov    $0x1,%esi
  805150:	48 89 c7             	mov    %rax,%rdi
  805153:	48 b8 96 4f 80 00 00 	movabs $0x804f96,%rax
  80515a:	00 00 00 
  80515d:	ff d0                	callq  *%rax
}
  80515f:	c9                   	leaveq 
  805160:	c3                   	retq   

0000000000805161 <close_all>:

void
close_all(void)
{
  805161:	55                   	push   %rbp
  805162:	48 89 e5             	mov    %rsp,%rbp
  805165:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  805169:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805170:	eb 15                	jmp    805187 <close_all+0x26>
		close(i);
  805172:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805175:	89 c7                	mov    %eax,%edi
  805177:	48 b8 16 51 80 00 00 	movabs $0x805116,%rax
  80517e:	00 00 00 
  805181:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  805183:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805187:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80518b:	7e e5                	jle    805172 <close_all+0x11>
		close(i);
}
  80518d:	c9                   	leaveq 
  80518e:	c3                   	retq   

000000000080518f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80518f:	55                   	push   %rbp
  805190:	48 89 e5             	mov    %rsp,%rbp
  805193:	48 83 ec 40          	sub    $0x40,%rsp
  805197:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80519a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80519d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8051a1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8051a4:	48 89 d6             	mov    %rdx,%rsi
  8051a7:	89 c7                	mov    %eax,%edi
  8051a9:	48 b8 06 4f 80 00 00 	movabs $0x804f06,%rax
  8051b0:	00 00 00 
  8051b3:	ff d0                	callq  *%rax
  8051b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8051b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8051bc:	79 08                	jns    8051c6 <dup+0x37>
		return r;
  8051be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051c1:	e9 70 01 00 00       	jmpq   805336 <dup+0x1a7>
	close(newfdnum);
  8051c6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8051c9:	89 c7                	mov    %eax,%edi
  8051cb:	48 b8 16 51 80 00 00 	movabs $0x805116,%rax
  8051d2:	00 00 00 
  8051d5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8051d7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8051da:	48 98                	cltq   
  8051dc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8051e2:	48 c1 e0 0c          	shl    $0xc,%rax
  8051e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8051ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8051ee:	48 89 c7             	mov    %rax,%rdi
  8051f1:	48 b8 43 4e 80 00 00 	movabs $0x804e43,%rax
  8051f8:	00 00 00 
  8051fb:	ff d0                	callq  *%rax
  8051fd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  805201:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805205:	48 89 c7             	mov    %rax,%rdi
  805208:	48 b8 43 4e 80 00 00 	movabs $0x804e43,%rax
  80520f:	00 00 00 
  805212:	ff d0                	callq  *%rax
  805214:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  805218:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80521c:	48 c1 e8 15          	shr    $0x15,%rax
  805220:	48 89 c2             	mov    %rax,%rdx
  805223:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80522a:	01 00 00 
  80522d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805231:	83 e0 01             	and    $0x1,%eax
  805234:	48 85 c0             	test   %rax,%rax
  805237:	74 73                	je     8052ac <dup+0x11d>
  805239:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80523d:	48 c1 e8 0c          	shr    $0xc,%rax
  805241:	48 89 c2             	mov    %rax,%rdx
  805244:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80524b:	01 00 00 
  80524e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805252:	83 e0 01             	and    $0x1,%eax
  805255:	48 85 c0             	test   %rax,%rax
  805258:	74 52                	je     8052ac <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80525a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80525e:	48 c1 e8 0c          	shr    $0xc,%rax
  805262:	48 89 c2             	mov    %rax,%rdx
  805265:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80526c:	01 00 00 
  80526f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805273:	25 07 0e 00 00       	and    $0xe07,%eax
  805278:	89 c1                	mov    %eax,%ecx
  80527a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80527e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805282:	41 89 c8             	mov    %ecx,%r8d
  805285:	48 89 d1             	mov    %rdx,%rcx
  805288:	ba 00 00 00 00       	mov    $0x0,%edx
  80528d:	48 89 c6             	mov    %rax,%rsi
  805290:	bf 00 00 00 00       	mov    $0x0,%edi
  805295:	48 b8 d9 48 80 00 00 	movabs $0x8048d9,%rax
  80529c:	00 00 00 
  80529f:	ff d0                	callq  *%rax
  8052a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8052a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8052a8:	79 02                	jns    8052ac <dup+0x11d>
			goto err;
  8052aa:	eb 57                	jmp    805303 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8052ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8052b0:	48 c1 e8 0c          	shr    $0xc,%rax
  8052b4:	48 89 c2             	mov    %rax,%rdx
  8052b7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8052be:	01 00 00 
  8052c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8052c5:	25 07 0e 00 00       	and    $0xe07,%eax
  8052ca:	89 c1                	mov    %eax,%ecx
  8052cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8052d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8052d4:	41 89 c8             	mov    %ecx,%r8d
  8052d7:	48 89 d1             	mov    %rdx,%rcx
  8052da:	ba 00 00 00 00       	mov    $0x0,%edx
  8052df:	48 89 c6             	mov    %rax,%rsi
  8052e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8052e7:	48 b8 d9 48 80 00 00 	movabs $0x8048d9,%rax
  8052ee:	00 00 00 
  8052f1:	ff d0                	callq  *%rax
  8052f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8052f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8052fa:	79 02                	jns    8052fe <dup+0x16f>
		goto err;
  8052fc:	eb 05                	jmp    805303 <dup+0x174>

	return newfdnum;
  8052fe:	8b 45 c8             	mov    -0x38(%rbp),%eax
  805301:	eb 33                	jmp    805336 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  805303:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805307:	48 89 c6             	mov    %rax,%rsi
  80530a:	bf 00 00 00 00       	mov    $0x0,%edi
  80530f:	48 b8 34 49 80 00 00 	movabs $0x804934,%rax
  805316:	00 00 00 
  805319:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80531b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80531f:	48 89 c6             	mov    %rax,%rsi
  805322:	bf 00 00 00 00       	mov    $0x0,%edi
  805327:	48 b8 34 49 80 00 00 	movabs $0x804934,%rax
  80532e:	00 00 00 
  805331:	ff d0                	callq  *%rax
	return r;
  805333:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805336:	c9                   	leaveq 
  805337:	c3                   	retq   

0000000000805338 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  805338:	55                   	push   %rbp
  805339:	48 89 e5             	mov    %rsp,%rbp
  80533c:	48 83 ec 40          	sub    $0x40,%rsp
  805340:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805343:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805347:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80534b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80534f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805352:	48 89 d6             	mov    %rdx,%rsi
  805355:	89 c7                	mov    %eax,%edi
  805357:	48 b8 06 4f 80 00 00 	movabs $0x804f06,%rax
  80535e:	00 00 00 
  805361:	ff d0                	callq  *%rax
  805363:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805366:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80536a:	78 24                	js     805390 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80536c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805370:	8b 00                	mov    (%rax),%eax
  805372:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805376:	48 89 d6             	mov    %rdx,%rsi
  805379:	89 c7                	mov    %eax,%edi
  80537b:	48 b8 5f 50 80 00 00 	movabs $0x80505f,%rax
  805382:	00 00 00 
  805385:	ff d0                	callq  *%rax
  805387:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80538a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80538e:	79 05                	jns    805395 <read+0x5d>
		return r;
  805390:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805393:	eb 76                	jmp    80540b <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  805395:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805399:	8b 40 08             	mov    0x8(%rax),%eax
  80539c:	83 e0 03             	and    $0x3,%eax
  80539f:	83 f8 01             	cmp    $0x1,%eax
  8053a2:	75 3a                	jne    8053de <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8053a4:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  8053ab:	00 00 00 
  8053ae:	48 8b 00             	mov    (%rax),%rax
  8053b1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8053b7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8053ba:	89 c6                	mov    %eax,%esi
  8053bc:	48 bf 47 71 80 00 00 	movabs $0x807147,%rdi
  8053c3:	00 00 00 
  8053c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8053cb:	48 b9 a5 33 80 00 00 	movabs $0x8033a5,%rcx
  8053d2:	00 00 00 
  8053d5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8053d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8053dc:	eb 2d                	jmp    80540b <read+0xd3>
	}
	if (!dev->dev_read)
  8053de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8053e2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8053e6:	48 85 c0             	test   %rax,%rax
  8053e9:	75 07                	jne    8053f2 <read+0xba>
		return -E_NOT_SUPP;
  8053eb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8053f0:	eb 19                	jmp    80540b <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8053f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8053f6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8053fa:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8053fe:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  805402:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  805406:	48 89 cf             	mov    %rcx,%rdi
  805409:	ff d0                	callq  *%rax
}
  80540b:	c9                   	leaveq 
  80540c:	c3                   	retq   

000000000080540d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80540d:	55                   	push   %rbp
  80540e:	48 89 e5             	mov    %rsp,%rbp
  805411:	48 83 ec 30          	sub    $0x30,%rsp
  805415:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805418:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80541c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  805420:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805427:	eb 49                	jmp    805472 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  805429:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80542c:	48 98                	cltq   
  80542e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805432:	48 29 c2             	sub    %rax,%rdx
  805435:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805438:	48 63 c8             	movslq %eax,%rcx
  80543b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80543f:	48 01 c1             	add    %rax,%rcx
  805442:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805445:	48 89 ce             	mov    %rcx,%rsi
  805448:	89 c7                	mov    %eax,%edi
  80544a:	48 b8 38 53 80 00 00 	movabs $0x805338,%rax
  805451:	00 00 00 
  805454:	ff d0                	callq  *%rax
  805456:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  805459:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80545d:	79 05                	jns    805464 <readn+0x57>
			return m;
  80545f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805462:	eb 1c                	jmp    805480 <readn+0x73>
		if (m == 0)
  805464:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805468:	75 02                	jne    80546c <readn+0x5f>
			break;
  80546a:	eb 11                	jmp    80547d <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80546c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80546f:	01 45 fc             	add    %eax,-0x4(%rbp)
  805472:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805475:	48 98                	cltq   
  805477:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80547b:	72 ac                	jb     805429 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80547d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805480:	c9                   	leaveq 
  805481:	c3                   	retq   

0000000000805482 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  805482:	55                   	push   %rbp
  805483:	48 89 e5             	mov    %rsp,%rbp
  805486:	48 83 ec 40          	sub    $0x40,%rsp
  80548a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80548d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805491:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  805495:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805499:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80549c:	48 89 d6             	mov    %rdx,%rsi
  80549f:	89 c7                	mov    %eax,%edi
  8054a1:	48 b8 06 4f 80 00 00 	movabs $0x804f06,%rax
  8054a8:	00 00 00 
  8054ab:	ff d0                	callq  *%rax
  8054ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8054b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8054b4:	78 24                	js     8054da <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8054b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8054ba:	8b 00                	mov    (%rax),%eax
  8054bc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8054c0:	48 89 d6             	mov    %rdx,%rsi
  8054c3:	89 c7                	mov    %eax,%edi
  8054c5:	48 b8 5f 50 80 00 00 	movabs $0x80505f,%rax
  8054cc:	00 00 00 
  8054cf:	ff d0                	callq  *%rax
  8054d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8054d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8054d8:	79 05                	jns    8054df <write+0x5d>
		return r;
  8054da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054dd:	eb 75                	jmp    805554 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8054df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8054e3:	8b 40 08             	mov    0x8(%rax),%eax
  8054e6:	83 e0 03             	and    $0x3,%eax
  8054e9:	85 c0                	test   %eax,%eax
  8054eb:	75 3a                	jne    805527 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8054ed:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  8054f4:	00 00 00 
  8054f7:	48 8b 00             	mov    (%rax),%rax
  8054fa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805500:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805503:	89 c6                	mov    %eax,%esi
  805505:	48 bf 63 71 80 00 00 	movabs $0x807163,%rdi
  80550c:	00 00 00 
  80550f:	b8 00 00 00 00       	mov    $0x0,%eax
  805514:	48 b9 a5 33 80 00 00 	movabs $0x8033a5,%rcx
  80551b:	00 00 00 
  80551e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  805520:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805525:	eb 2d                	jmp    805554 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  805527:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80552b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80552f:	48 85 c0             	test   %rax,%rax
  805532:	75 07                	jne    80553b <write+0xb9>
		return -E_NOT_SUPP;
  805534:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805539:	eb 19                	jmp    805554 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80553b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80553f:	48 8b 40 18          	mov    0x18(%rax),%rax
  805543:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  805547:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80554b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80554f:	48 89 cf             	mov    %rcx,%rdi
  805552:	ff d0                	callq  *%rax
}
  805554:	c9                   	leaveq 
  805555:	c3                   	retq   

0000000000805556 <seek>:

int
seek(int fdnum, off_t offset)
{
  805556:	55                   	push   %rbp
  805557:	48 89 e5             	mov    %rsp,%rbp
  80555a:	48 83 ec 18          	sub    $0x18,%rsp
  80555e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805561:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  805564:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805568:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80556b:	48 89 d6             	mov    %rdx,%rsi
  80556e:	89 c7                	mov    %eax,%edi
  805570:	48 b8 06 4f 80 00 00 	movabs $0x804f06,%rax
  805577:	00 00 00 
  80557a:	ff d0                	callq  *%rax
  80557c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80557f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805583:	79 05                	jns    80558a <seek+0x34>
		return r;
  805585:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805588:	eb 0f                	jmp    805599 <seek+0x43>
	fd->fd_offset = offset;
  80558a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80558e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805591:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  805594:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805599:	c9                   	leaveq 
  80559a:	c3                   	retq   

000000000080559b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80559b:	55                   	push   %rbp
  80559c:	48 89 e5             	mov    %rsp,%rbp
  80559f:	48 83 ec 30          	sub    $0x30,%rsp
  8055a3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8055a6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8055a9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8055ad:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8055b0:	48 89 d6             	mov    %rdx,%rsi
  8055b3:	89 c7                	mov    %eax,%edi
  8055b5:	48 b8 06 4f 80 00 00 	movabs $0x804f06,%rax
  8055bc:	00 00 00 
  8055bf:	ff d0                	callq  *%rax
  8055c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8055c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8055c8:	78 24                	js     8055ee <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8055ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8055ce:	8b 00                	mov    (%rax),%eax
  8055d0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8055d4:	48 89 d6             	mov    %rdx,%rsi
  8055d7:	89 c7                	mov    %eax,%edi
  8055d9:	48 b8 5f 50 80 00 00 	movabs $0x80505f,%rax
  8055e0:	00 00 00 
  8055e3:	ff d0                	callq  *%rax
  8055e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8055e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8055ec:	79 05                	jns    8055f3 <ftruncate+0x58>
		return r;
  8055ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8055f1:	eb 72                	jmp    805665 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8055f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8055f7:	8b 40 08             	mov    0x8(%rax),%eax
  8055fa:	83 e0 03             	and    $0x3,%eax
  8055fd:	85 c0                	test   %eax,%eax
  8055ff:	75 3a                	jne    80563b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  805601:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  805608:	00 00 00 
  80560b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80560e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805614:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805617:	89 c6                	mov    %eax,%esi
  805619:	48 bf 80 71 80 00 00 	movabs $0x807180,%rdi
  805620:	00 00 00 
  805623:	b8 00 00 00 00       	mov    $0x0,%eax
  805628:	48 b9 a5 33 80 00 00 	movabs $0x8033a5,%rcx
  80562f:	00 00 00 
  805632:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  805634:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805639:	eb 2a                	jmp    805665 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80563b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80563f:	48 8b 40 30          	mov    0x30(%rax),%rax
  805643:	48 85 c0             	test   %rax,%rax
  805646:	75 07                	jne    80564f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  805648:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80564d:	eb 16                	jmp    805665 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80564f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805653:	48 8b 40 30          	mov    0x30(%rax),%rax
  805657:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80565b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80565e:	89 ce                	mov    %ecx,%esi
  805660:	48 89 d7             	mov    %rdx,%rdi
  805663:	ff d0                	callq  *%rax
}
  805665:	c9                   	leaveq 
  805666:	c3                   	retq   

0000000000805667 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  805667:	55                   	push   %rbp
  805668:	48 89 e5             	mov    %rsp,%rbp
  80566b:	48 83 ec 30          	sub    $0x30,%rsp
  80566f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805672:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  805676:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80567a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80567d:	48 89 d6             	mov    %rdx,%rsi
  805680:	89 c7                	mov    %eax,%edi
  805682:	48 b8 06 4f 80 00 00 	movabs $0x804f06,%rax
  805689:	00 00 00 
  80568c:	ff d0                	callq  *%rax
  80568e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805691:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805695:	78 24                	js     8056bb <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80569b:	8b 00                	mov    (%rax),%eax
  80569d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8056a1:	48 89 d6             	mov    %rdx,%rsi
  8056a4:	89 c7                	mov    %eax,%edi
  8056a6:	48 b8 5f 50 80 00 00 	movabs $0x80505f,%rax
  8056ad:	00 00 00 
  8056b0:	ff d0                	callq  *%rax
  8056b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8056b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8056b9:	79 05                	jns    8056c0 <fstat+0x59>
		return r;
  8056bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8056be:	eb 5e                	jmp    80571e <fstat+0xb7>
	if (!dev->dev_stat)
  8056c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8056c4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8056c8:	48 85 c0             	test   %rax,%rax
  8056cb:	75 07                	jne    8056d4 <fstat+0x6d>
		return -E_NOT_SUPP;
  8056cd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8056d2:	eb 4a                	jmp    80571e <fstat+0xb7>
	stat->st_name[0] = 0;
  8056d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8056d8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8056db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8056df:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8056e6:	00 00 00 
	stat->st_isdir = 0;
  8056e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8056ed:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8056f4:	00 00 00 
	stat->st_dev = dev;
  8056f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8056fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8056ff:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  805706:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80570a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80570e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805712:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  805716:	48 89 ce             	mov    %rcx,%rsi
  805719:	48 89 d7             	mov    %rdx,%rdi
  80571c:	ff d0                	callq  *%rax
}
  80571e:	c9                   	leaveq 
  80571f:	c3                   	retq   

0000000000805720 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  805720:	55                   	push   %rbp
  805721:	48 89 e5             	mov    %rsp,%rbp
  805724:	48 83 ec 20          	sub    $0x20,%rsp
  805728:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80572c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  805730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805734:	be 00 00 00 00       	mov    $0x0,%esi
  805739:	48 89 c7             	mov    %rax,%rdi
  80573c:	48 b8 0e 58 80 00 00 	movabs $0x80580e,%rax
  805743:	00 00 00 
  805746:	ff d0                	callq  *%rax
  805748:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80574b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80574f:	79 05                	jns    805756 <stat+0x36>
		return fd;
  805751:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805754:	eb 2f                	jmp    805785 <stat+0x65>
	r = fstat(fd, stat);
  805756:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80575a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80575d:	48 89 d6             	mov    %rdx,%rsi
  805760:	89 c7                	mov    %eax,%edi
  805762:	48 b8 67 56 80 00 00 	movabs $0x805667,%rax
  805769:	00 00 00 
  80576c:	ff d0                	callq  *%rax
  80576e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  805771:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805774:	89 c7                	mov    %eax,%edi
  805776:	48 b8 16 51 80 00 00 	movabs $0x805116,%rax
  80577d:	00 00 00 
  805780:	ff d0                	callq  *%rax
	return r;
  805782:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  805785:	c9                   	leaveq 
  805786:	c3                   	retq   

0000000000805787 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  805787:	55                   	push   %rbp
  805788:	48 89 e5             	mov    %rsp,%rbp
  80578b:	48 83 ec 10          	sub    $0x10,%rsp
  80578f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805792:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  805796:	48 b8 00 20 81 00 00 	movabs $0x812000,%rax
  80579d:	00 00 00 
  8057a0:	8b 00                	mov    (%rax),%eax
  8057a2:	85 c0                	test   %eax,%eax
  8057a4:	75 1d                	jne    8057c3 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8057a6:	bf 01 00 00 00       	mov    $0x1,%edi
  8057ab:	48 b8 9e 4d 80 00 00 	movabs $0x804d9e,%rax
  8057b2:	00 00 00 
  8057b5:	ff d0                	callq  *%rax
  8057b7:	48 ba 00 20 81 00 00 	movabs $0x812000,%rdx
  8057be:	00 00 00 
  8057c1:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8057c3:	48 b8 00 20 81 00 00 	movabs $0x812000,%rax
  8057ca:	00 00 00 
  8057cd:	8b 00                	mov    (%rax),%eax
  8057cf:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8057d2:	b9 07 00 00 00       	mov    $0x7,%ecx
  8057d7:	48 ba 00 30 81 00 00 	movabs $0x813000,%rdx
  8057de:	00 00 00 
  8057e1:	89 c7                	mov    %eax,%edi
  8057e3:	48 b8 3c 4d 80 00 00 	movabs $0x804d3c,%rax
  8057ea:	00 00 00 
  8057ed:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8057ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8057f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8057f8:	48 89 c6             	mov    %rax,%rsi
  8057fb:	bf 00 00 00 00       	mov    $0x0,%edi
  805800:	48 b8 36 4c 80 00 00 	movabs $0x804c36,%rax
  805807:	00 00 00 
  80580a:	ff d0                	callq  *%rax
}
  80580c:	c9                   	leaveq 
  80580d:	c3                   	retq   

000000000080580e <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80580e:	55                   	push   %rbp
  80580f:	48 89 e5             	mov    %rsp,%rbp
  805812:	48 83 ec 30          	sub    $0x30,%rsp
  805816:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80581a:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80581d:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  805824:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80582b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  805832:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805837:	75 08                	jne    805841 <open+0x33>
	{
		return r;
  805839:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80583c:	e9 f2 00 00 00       	jmpq   805933 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  805841:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805845:	48 89 c7             	mov    %rax,%rdi
  805848:	48 b8 ee 3e 80 00 00 	movabs $0x803eee,%rax
  80584f:	00 00 00 
  805852:	ff d0                	callq  *%rax
  805854:	89 45 f4             	mov    %eax,-0xc(%rbp)
  805857:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  80585e:	7e 0a                	jle    80586a <open+0x5c>
	{
		return -E_BAD_PATH;
  805860:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  805865:	e9 c9 00 00 00       	jmpq   805933 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80586a:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  805871:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  805872:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  805876:	48 89 c7             	mov    %rax,%rdi
  805879:	48 b8 6e 4e 80 00 00 	movabs $0x804e6e,%rax
  805880:	00 00 00 
  805883:	ff d0                	callq  *%rax
  805885:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805888:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80588c:	78 09                	js     805897 <open+0x89>
  80588e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805892:	48 85 c0             	test   %rax,%rax
  805895:	75 08                	jne    80589f <open+0x91>
		{
			return r;
  805897:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80589a:	e9 94 00 00 00       	jmpq   805933 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80589f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8058a3:	ba 00 04 00 00       	mov    $0x400,%edx
  8058a8:	48 89 c6             	mov    %rax,%rsi
  8058ab:	48 bf 00 30 81 00 00 	movabs $0x813000,%rdi
  8058b2:	00 00 00 
  8058b5:	48 b8 ec 3f 80 00 00 	movabs $0x803fec,%rax
  8058bc:	00 00 00 
  8058bf:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8058c1:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  8058c8:	00 00 00 
  8058cb:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8058ce:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8058d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8058d8:	48 89 c6             	mov    %rax,%rsi
  8058db:	bf 01 00 00 00       	mov    $0x1,%edi
  8058e0:	48 b8 87 57 80 00 00 	movabs $0x805787,%rax
  8058e7:	00 00 00 
  8058ea:	ff d0                	callq  *%rax
  8058ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8058ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8058f3:	79 2b                	jns    805920 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8058f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8058f9:	be 00 00 00 00       	mov    $0x0,%esi
  8058fe:	48 89 c7             	mov    %rax,%rdi
  805901:	48 b8 96 4f 80 00 00 	movabs $0x804f96,%rax
  805908:	00 00 00 
  80590b:	ff d0                	callq  *%rax
  80590d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805910:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805914:	79 05                	jns    80591b <open+0x10d>
			{
				return d;
  805916:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805919:	eb 18                	jmp    805933 <open+0x125>
			}
			return r;
  80591b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80591e:	eb 13                	jmp    805933 <open+0x125>
		}	
		return fd2num(fd_store);
  805920:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805924:	48 89 c7             	mov    %rax,%rdi
  805927:	48 b8 20 4e 80 00 00 	movabs $0x804e20,%rax
  80592e:	00 00 00 
  805931:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  805933:	c9                   	leaveq 
  805934:	c3                   	retq   

0000000000805935 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  805935:	55                   	push   %rbp
  805936:	48 89 e5             	mov    %rsp,%rbp
  805939:	48 83 ec 10          	sub    $0x10,%rsp
  80593d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  805941:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805945:	8b 50 0c             	mov    0xc(%rax),%edx
  805948:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  80594f:	00 00 00 
  805952:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  805954:	be 00 00 00 00       	mov    $0x0,%esi
  805959:	bf 06 00 00 00       	mov    $0x6,%edi
  80595e:	48 b8 87 57 80 00 00 	movabs $0x805787,%rax
  805965:	00 00 00 
  805968:	ff d0                	callq  *%rax
}
  80596a:	c9                   	leaveq 
  80596b:	c3                   	retq   

000000000080596c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80596c:	55                   	push   %rbp
  80596d:	48 89 e5             	mov    %rsp,%rbp
  805970:	48 83 ec 30          	sub    $0x30,%rsp
  805974:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805978:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80597c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  805980:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  805987:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80598c:	74 07                	je     805995 <devfile_read+0x29>
  80598e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805993:	75 07                	jne    80599c <devfile_read+0x30>
		return -E_INVAL;
  805995:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80599a:	eb 77                	jmp    805a13 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80599c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8059a0:	8b 50 0c             	mov    0xc(%rax),%edx
  8059a3:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  8059aa:	00 00 00 
  8059ad:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8059af:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  8059b6:	00 00 00 
  8059b9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8059bd:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8059c1:	be 00 00 00 00       	mov    $0x0,%esi
  8059c6:	bf 03 00 00 00       	mov    $0x3,%edi
  8059cb:	48 b8 87 57 80 00 00 	movabs $0x805787,%rax
  8059d2:	00 00 00 
  8059d5:	ff d0                	callq  *%rax
  8059d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8059da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8059de:	7f 05                	jg     8059e5 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8059e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8059e3:	eb 2e                	jmp    805a13 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8059e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8059e8:	48 63 d0             	movslq %eax,%rdx
  8059eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8059ef:	48 be 00 30 81 00 00 	movabs $0x813000,%rsi
  8059f6:	00 00 00 
  8059f9:	48 89 c7             	mov    %rax,%rdi
  8059fc:	48 b8 7e 42 80 00 00 	movabs $0x80427e,%rax
  805a03:	00 00 00 
  805a06:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  805a08:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805a0c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  805a10:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  805a13:	c9                   	leaveq 
  805a14:	c3                   	retq   

0000000000805a15 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  805a15:	55                   	push   %rbp
  805a16:	48 89 e5             	mov    %rsp,%rbp
  805a19:	48 83 ec 30          	sub    $0x30,%rsp
  805a1d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805a21:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805a25:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  805a29:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  805a30:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805a35:	74 07                	je     805a3e <devfile_write+0x29>
  805a37:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805a3c:	75 08                	jne    805a46 <devfile_write+0x31>
		return r;
  805a3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a41:	e9 9a 00 00 00       	jmpq   805ae0 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  805a46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805a4a:	8b 50 0c             	mov    0xc(%rax),%edx
  805a4d:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805a54:	00 00 00 
  805a57:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  805a59:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  805a60:	00 
  805a61:	76 08                	jbe    805a6b <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  805a63:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  805a6a:	00 
	}
	fsipcbuf.write.req_n = n;
  805a6b:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805a72:	00 00 00 
  805a75:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805a79:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  805a7d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805a81:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805a85:	48 89 c6             	mov    %rax,%rsi
  805a88:	48 bf 10 30 81 00 00 	movabs $0x813010,%rdi
  805a8f:	00 00 00 
  805a92:	48 b8 7e 42 80 00 00 	movabs $0x80427e,%rax
  805a99:	00 00 00 
  805a9c:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  805a9e:	be 00 00 00 00       	mov    $0x0,%esi
  805aa3:	bf 04 00 00 00       	mov    $0x4,%edi
  805aa8:	48 b8 87 57 80 00 00 	movabs $0x805787,%rax
  805aaf:	00 00 00 
  805ab2:	ff d0                	callq  *%rax
  805ab4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805ab7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805abb:	7f 20                	jg     805add <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  805abd:	48 bf a6 71 80 00 00 	movabs $0x8071a6,%rdi
  805ac4:	00 00 00 
  805ac7:	b8 00 00 00 00       	mov    $0x0,%eax
  805acc:	48 ba a5 33 80 00 00 	movabs $0x8033a5,%rdx
  805ad3:	00 00 00 
  805ad6:	ff d2                	callq  *%rdx
		return r;
  805ad8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805adb:	eb 03                	jmp    805ae0 <devfile_write+0xcb>
	}
	return r;
  805add:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  805ae0:	c9                   	leaveq 
  805ae1:	c3                   	retq   

0000000000805ae2 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  805ae2:	55                   	push   %rbp
  805ae3:	48 89 e5             	mov    %rsp,%rbp
  805ae6:	48 83 ec 20          	sub    $0x20,%rsp
  805aea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805aee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  805af2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805af6:	8b 50 0c             	mov    0xc(%rax),%edx
  805af9:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805b00:	00 00 00 
  805b03:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  805b05:	be 00 00 00 00       	mov    $0x0,%esi
  805b0a:	bf 05 00 00 00       	mov    $0x5,%edi
  805b0f:	48 b8 87 57 80 00 00 	movabs $0x805787,%rax
  805b16:	00 00 00 
  805b19:	ff d0                	callq  *%rax
  805b1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805b1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805b22:	79 05                	jns    805b29 <devfile_stat+0x47>
		return r;
  805b24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805b27:	eb 56                	jmp    805b7f <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  805b29:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805b2d:	48 be 00 30 81 00 00 	movabs $0x813000,%rsi
  805b34:	00 00 00 
  805b37:	48 89 c7             	mov    %rax,%rdi
  805b3a:	48 b8 5a 3f 80 00 00 	movabs $0x803f5a,%rax
  805b41:	00 00 00 
  805b44:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  805b46:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805b4d:	00 00 00 
  805b50:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  805b56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805b5a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  805b60:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805b67:	00 00 00 
  805b6a:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  805b70:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805b74:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  805b7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805b7f:	c9                   	leaveq 
  805b80:	c3                   	retq   

0000000000805b81 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  805b81:	55                   	push   %rbp
  805b82:	48 89 e5             	mov    %rsp,%rbp
  805b85:	48 83 ec 10          	sub    $0x10,%rsp
  805b89:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805b8d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  805b90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805b94:	8b 50 0c             	mov    0xc(%rax),%edx
  805b97:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805b9e:	00 00 00 
  805ba1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  805ba3:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805baa:	00 00 00 
  805bad:	8b 55 f4             	mov    -0xc(%rbp),%edx
  805bb0:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  805bb3:	be 00 00 00 00       	mov    $0x0,%esi
  805bb8:	bf 02 00 00 00       	mov    $0x2,%edi
  805bbd:	48 b8 87 57 80 00 00 	movabs $0x805787,%rax
  805bc4:	00 00 00 
  805bc7:	ff d0                	callq  *%rax
}
  805bc9:	c9                   	leaveq 
  805bca:	c3                   	retq   

0000000000805bcb <remove>:

// Delete a file
int
remove(const char *path)
{
  805bcb:	55                   	push   %rbp
  805bcc:	48 89 e5             	mov    %rsp,%rbp
  805bcf:	48 83 ec 10          	sub    $0x10,%rsp
  805bd3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  805bd7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805bdb:	48 89 c7             	mov    %rax,%rdi
  805bde:	48 b8 ee 3e 80 00 00 	movabs $0x803eee,%rax
  805be5:	00 00 00 
  805be8:	ff d0                	callq  *%rax
  805bea:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  805bef:	7e 07                	jle    805bf8 <remove+0x2d>
		return -E_BAD_PATH;
  805bf1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  805bf6:	eb 33                	jmp    805c2b <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  805bf8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805bfc:	48 89 c6             	mov    %rax,%rsi
  805bff:	48 bf 00 30 81 00 00 	movabs $0x813000,%rdi
  805c06:	00 00 00 
  805c09:	48 b8 5a 3f 80 00 00 	movabs $0x803f5a,%rax
  805c10:	00 00 00 
  805c13:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  805c15:	be 00 00 00 00       	mov    $0x0,%esi
  805c1a:	bf 07 00 00 00       	mov    $0x7,%edi
  805c1f:	48 b8 87 57 80 00 00 	movabs $0x805787,%rax
  805c26:	00 00 00 
  805c29:	ff d0                	callq  *%rax
}
  805c2b:	c9                   	leaveq 
  805c2c:	c3                   	retq   

0000000000805c2d <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  805c2d:	55                   	push   %rbp
  805c2e:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  805c31:	be 00 00 00 00       	mov    $0x0,%esi
  805c36:	bf 08 00 00 00       	mov    $0x8,%edi
  805c3b:	48 b8 87 57 80 00 00 	movabs $0x805787,%rax
  805c42:	00 00 00 
  805c45:	ff d0                	callq  *%rax
}
  805c47:	5d                   	pop    %rbp
  805c48:	c3                   	retq   

0000000000805c49 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  805c49:	55                   	push   %rbp
  805c4a:	48 89 e5             	mov    %rsp,%rbp
  805c4d:	48 83 ec 18          	sub    $0x18,%rsp
  805c51:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  805c55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805c59:	48 c1 e8 15          	shr    $0x15,%rax
  805c5d:	48 89 c2             	mov    %rax,%rdx
  805c60:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805c67:	01 00 00 
  805c6a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805c6e:	83 e0 01             	and    $0x1,%eax
  805c71:	48 85 c0             	test   %rax,%rax
  805c74:	75 07                	jne    805c7d <pageref+0x34>
		return 0;
  805c76:	b8 00 00 00 00       	mov    $0x0,%eax
  805c7b:	eb 53                	jmp    805cd0 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  805c7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805c81:	48 c1 e8 0c          	shr    $0xc,%rax
  805c85:	48 89 c2             	mov    %rax,%rdx
  805c88:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805c8f:	01 00 00 
  805c92:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805c96:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  805c9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805c9e:	83 e0 01             	and    $0x1,%eax
  805ca1:	48 85 c0             	test   %rax,%rax
  805ca4:	75 07                	jne    805cad <pageref+0x64>
		return 0;
  805ca6:	b8 00 00 00 00       	mov    $0x0,%eax
  805cab:	eb 23                	jmp    805cd0 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  805cad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805cb1:	48 c1 e8 0c          	shr    $0xc,%rax
  805cb5:	48 89 c2             	mov    %rax,%rdx
  805cb8:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805cbf:	00 00 00 
  805cc2:	48 c1 e2 04          	shl    $0x4,%rdx
  805cc6:	48 01 d0             	add    %rdx,%rax
  805cc9:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  805ccd:	0f b7 c0             	movzwl %ax,%eax
}
  805cd0:	c9                   	leaveq 
  805cd1:	c3                   	retq   

0000000000805cd2 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  805cd2:	55                   	push   %rbp
  805cd3:	48 89 e5             	mov    %rsp,%rbp
  805cd6:	53                   	push   %rbx
  805cd7:	48 83 ec 38          	sub    $0x38,%rsp
  805cdb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  805cdf:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  805ce3:	48 89 c7             	mov    %rax,%rdi
  805ce6:	48 b8 6e 4e 80 00 00 	movabs $0x804e6e,%rax
  805ced:	00 00 00 
  805cf0:	ff d0                	callq  *%rax
  805cf2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805cf5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805cf9:	0f 88 bf 01 00 00    	js     805ebe <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805cff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805d03:	ba 07 04 00 00       	mov    $0x407,%edx
  805d08:	48 89 c6             	mov    %rax,%rsi
  805d0b:	bf 00 00 00 00       	mov    $0x0,%edi
  805d10:	48 b8 89 48 80 00 00 	movabs $0x804889,%rax
  805d17:	00 00 00 
  805d1a:	ff d0                	callq  *%rax
  805d1c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805d1f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805d23:	0f 88 95 01 00 00    	js     805ebe <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  805d29:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  805d2d:	48 89 c7             	mov    %rax,%rdi
  805d30:	48 b8 6e 4e 80 00 00 	movabs $0x804e6e,%rax
  805d37:	00 00 00 
  805d3a:	ff d0                	callq  *%rax
  805d3c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805d3f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805d43:	0f 88 5d 01 00 00    	js     805ea6 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805d49:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805d4d:	ba 07 04 00 00       	mov    $0x407,%edx
  805d52:	48 89 c6             	mov    %rax,%rsi
  805d55:	bf 00 00 00 00       	mov    $0x0,%edi
  805d5a:	48 b8 89 48 80 00 00 	movabs $0x804889,%rax
  805d61:	00 00 00 
  805d64:	ff d0                	callq  *%rax
  805d66:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805d69:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805d6d:	0f 88 33 01 00 00    	js     805ea6 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  805d73:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805d77:	48 89 c7             	mov    %rax,%rdi
  805d7a:	48 b8 43 4e 80 00 00 	movabs $0x804e43,%rax
  805d81:	00 00 00 
  805d84:	ff d0                	callq  *%rax
  805d86:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805d8a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805d8e:	ba 07 04 00 00       	mov    $0x407,%edx
  805d93:	48 89 c6             	mov    %rax,%rsi
  805d96:	bf 00 00 00 00       	mov    $0x0,%edi
  805d9b:	48 b8 89 48 80 00 00 	movabs $0x804889,%rax
  805da2:	00 00 00 
  805da5:	ff d0                	callq  *%rax
  805da7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805daa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805dae:	79 05                	jns    805db5 <pipe+0xe3>
		goto err2;
  805db0:	e9 d9 00 00 00       	jmpq   805e8e <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805db5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805db9:	48 89 c7             	mov    %rax,%rdi
  805dbc:	48 b8 43 4e 80 00 00 	movabs $0x804e43,%rax
  805dc3:	00 00 00 
  805dc6:	ff d0                	callq  *%rax
  805dc8:	48 89 c2             	mov    %rax,%rdx
  805dcb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805dcf:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  805dd5:	48 89 d1             	mov    %rdx,%rcx
  805dd8:	ba 00 00 00 00       	mov    $0x0,%edx
  805ddd:	48 89 c6             	mov    %rax,%rsi
  805de0:	bf 00 00 00 00       	mov    $0x0,%edi
  805de5:	48 b8 d9 48 80 00 00 	movabs $0x8048d9,%rax
  805dec:	00 00 00 
  805def:	ff d0                	callq  *%rax
  805df1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805df4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805df8:	79 1b                	jns    805e15 <pipe+0x143>
		goto err3;
  805dfa:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  805dfb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805dff:	48 89 c6             	mov    %rax,%rsi
  805e02:	bf 00 00 00 00       	mov    $0x0,%edi
  805e07:	48 b8 34 49 80 00 00 	movabs $0x804934,%rax
  805e0e:	00 00 00 
  805e11:	ff d0                	callq  *%rax
  805e13:	eb 79                	jmp    805e8e <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  805e15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805e19:	48 ba 00 11 81 00 00 	movabs $0x811100,%rdx
  805e20:	00 00 00 
  805e23:	8b 12                	mov    (%rdx),%edx
  805e25:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  805e27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805e2b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  805e32:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805e36:	48 ba 00 11 81 00 00 	movabs $0x811100,%rdx
  805e3d:	00 00 00 
  805e40:	8b 12                	mov    (%rdx),%edx
  805e42:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  805e44:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805e48:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  805e4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805e53:	48 89 c7             	mov    %rax,%rdi
  805e56:	48 b8 20 4e 80 00 00 	movabs $0x804e20,%rax
  805e5d:	00 00 00 
  805e60:	ff d0                	callq  *%rax
  805e62:	89 c2                	mov    %eax,%edx
  805e64:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805e68:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  805e6a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805e6e:	48 8d 58 04          	lea    0x4(%rax),%rbx
  805e72:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805e76:	48 89 c7             	mov    %rax,%rdi
  805e79:	48 b8 20 4e 80 00 00 	movabs $0x804e20,%rax
  805e80:	00 00 00 
  805e83:	ff d0                	callq  *%rax
  805e85:	89 03                	mov    %eax,(%rbx)
	return 0;
  805e87:	b8 00 00 00 00       	mov    $0x0,%eax
  805e8c:	eb 33                	jmp    805ec1 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  805e8e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805e92:	48 89 c6             	mov    %rax,%rsi
  805e95:	bf 00 00 00 00       	mov    $0x0,%edi
  805e9a:	48 b8 34 49 80 00 00 	movabs $0x804934,%rax
  805ea1:	00 00 00 
  805ea4:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  805ea6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805eaa:	48 89 c6             	mov    %rax,%rsi
  805ead:	bf 00 00 00 00       	mov    $0x0,%edi
  805eb2:	48 b8 34 49 80 00 00 	movabs $0x804934,%rax
  805eb9:	00 00 00 
  805ebc:	ff d0                	callq  *%rax
    err:
	return r;
  805ebe:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  805ec1:	48 83 c4 38          	add    $0x38,%rsp
  805ec5:	5b                   	pop    %rbx
  805ec6:	5d                   	pop    %rbp
  805ec7:	c3                   	retq   

0000000000805ec8 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  805ec8:	55                   	push   %rbp
  805ec9:	48 89 e5             	mov    %rsp,%rbp
  805ecc:	53                   	push   %rbx
  805ecd:	48 83 ec 28          	sub    $0x28,%rsp
  805ed1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805ed5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  805ed9:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  805ee0:	00 00 00 
  805ee3:	48 8b 00             	mov    (%rax),%rax
  805ee6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  805eec:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  805eef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805ef3:	48 89 c7             	mov    %rax,%rdi
  805ef6:	48 b8 49 5c 80 00 00 	movabs $0x805c49,%rax
  805efd:	00 00 00 
  805f00:	ff d0                	callq  *%rax
  805f02:	89 c3                	mov    %eax,%ebx
  805f04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805f08:	48 89 c7             	mov    %rax,%rdi
  805f0b:	48 b8 49 5c 80 00 00 	movabs $0x805c49,%rax
  805f12:	00 00 00 
  805f15:	ff d0                	callq  *%rax
  805f17:	39 c3                	cmp    %eax,%ebx
  805f19:	0f 94 c0             	sete   %al
  805f1c:	0f b6 c0             	movzbl %al,%eax
  805f1f:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  805f22:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  805f29:	00 00 00 
  805f2c:	48 8b 00             	mov    (%rax),%rax
  805f2f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  805f35:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  805f38:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805f3b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  805f3e:	75 05                	jne    805f45 <_pipeisclosed+0x7d>
			return ret;
  805f40:	8b 45 e8             	mov    -0x18(%rbp),%eax
  805f43:	eb 4f                	jmp    805f94 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  805f45:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805f48:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  805f4b:	74 42                	je     805f8f <_pipeisclosed+0xc7>
  805f4d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  805f51:	75 3c                	jne    805f8f <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  805f53:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  805f5a:	00 00 00 
  805f5d:	48 8b 00             	mov    (%rax),%rax
  805f60:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  805f66:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  805f69:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805f6c:	89 c6                	mov    %eax,%esi
  805f6e:	48 bf c7 71 80 00 00 	movabs $0x8071c7,%rdi
  805f75:	00 00 00 
  805f78:	b8 00 00 00 00       	mov    $0x0,%eax
  805f7d:	49 b8 a5 33 80 00 00 	movabs $0x8033a5,%r8
  805f84:	00 00 00 
  805f87:	41 ff d0             	callq  *%r8
	}
  805f8a:	e9 4a ff ff ff       	jmpq   805ed9 <_pipeisclosed+0x11>
  805f8f:	e9 45 ff ff ff       	jmpq   805ed9 <_pipeisclosed+0x11>
}
  805f94:	48 83 c4 28          	add    $0x28,%rsp
  805f98:	5b                   	pop    %rbx
  805f99:	5d                   	pop    %rbp
  805f9a:	c3                   	retq   

0000000000805f9b <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  805f9b:	55                   	push   %rbp
  805f9c:	48 89 e5             	mov    %rsp,%rbp
  805f9f:	48 83 ec 30          	sub    $0x30,%rsp
  805fa3:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  805fa6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805faa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805fad:	48 89 d6             	mov    %rdx,%rsi
  805fb0:	89 c7                	mov    %eax,%edi
  805fb2:	48 b8 06 4f 80 00 00 	movabs $0x804f06,%rax
  805fb9:	00 00 00 
  805fbc:	ff d0                	callq  *%rax
  805fbe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805fc1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805fc5:	79 05                	jns    805fcc <pipeisclosed+0x31>
		return r;
  805fc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805fca:	eb 31                	jmp    805ffd <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  805fcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805fd0:	48 89 c7             	mov    %rax,%rdi
  805fd3:	48 b8 43 4e 80 00 00 	movabs $0x804e43,%rax
  805fda:	00 00 00 
  805fdd:	ff d0                	callq  *%rax
  805fdf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  805fe3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805fe7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805feb:	48 89 d6             	mov    %rdx,%rsi
  805fee:	48 89 c7             	mov    %rax,%rdi
  805ff1:	48 b8 c8 5e 80 00 00 	movabs $0x805ec8,%rax
  805ff8:	00 00 00 
  805ffb:	ff d0                	callq  *%rax
}
  805ffd:	c9                   	leaveq 
  805ffe:	c3                   	retq   

0000000000805fff <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  805fff:	55                   	push   %rbp
  806000:	48 89 e5             	mov    %rsp,%rbp
  806003:	48 83 ec 40          	sub    $0x40,%rsp
  806007:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80600b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80600f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  806013:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806017:	48 89 c7             	mov    %rax,%rdi
  80601a:	48 b8 43 4e 80 00 00 	movabs $0x804e43,%rax
  806021:	00 00 00 
  806024:	ff d0                	callq  *%rax
  806026:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80602a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80602e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  806032:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  806039:	00 
  80603a:	e9 92 00 00 00       	jmpq   8060d1 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80603f:	eb 41                	jmp    806082 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  806041:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  806046:	74 09                	je     806051 <devpipe_read+0x52>
				return i;
  806048:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80604c:	e9 92 00 00 00       	jmpq   8060e3 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  806051:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806055:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806059:	48 89 d6             	mov    %rdx,%rsi
  80605c:	48 89 c7             	mov    %rax,%rdi
  80605f:	48 b8 c8 5e 80 00 00 	movabs $0x805ec8,%rax
  806066:	00 00 00 
  806069:	ff d0                	callq  *%rax
  80606b:	85 c0                	test   %eax,%eax
  80606d:	74 07                	je     806076 <devpipe_read+0x77>
				return 0;
  80606f:	b8 00 00 00 00       	mov    $0x0,%eax
  806074:	eb 6d                	jmp    8060e3 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  806076:	48 b8 4b 48 80 00 00 	movabs $0x80484b,%rax
  80607d:	00 00 00 
  806080:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  806082:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806086:	8b 10                	mov    (%rax),%edx
  806088:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80608c:	8b 40 04             	mov    0x4(%rax),%eax
  80608f:	39 c2                	cmp    %eax,%edx
  806091:	74 ae                	je     806041 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  806093:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806097:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80609b:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80609f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8060a3:	8b 00                	mov    (%rax),%eax
  8060a5:	99                   	cltd   
  8060a6:	c1 ea 1b             	shr    $0x1b,%edx
  8060a9:	01 d0                	add    %edx,%eax
  8060ab:	83 e0 1f             	and    $0x1f,%eax
  8060ae:	29 d0                	sub    %edx,%eax
  8060b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8060b4:	48 98                	cltq   
  8060b6:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8060bb:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8060bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8060c1:	8b 00                	mov    (%rax),%eax
  8060c3:	8d 50 01             	lea    0x1(%rax),%edx
  8060c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8060ca:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8060cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8060d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8060d5:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8060d9:	0f 82 60 ff ff ff    	jb     80603f <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8060df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8060e3:	c9                   	leaveq 
  8060e4:	c3                   	retq   

00000000008060e5 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8060e5:	55                   	push   %rbp
  8060e6:	48 89 e5             	mov    %rsp,%rbp
  8060e9:	48 83 ec 40          	sub    $0x40,%rsp
  8060ed:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8060f1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8060f5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8060f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8060fd:	48 89 c7             	mov    %rax,%rdi
  806100:	48 b8 43 4e 80 00 00 	movabs $0x804e43,%rax
  806107:	00 00 00 
  80610a:	ff d0                	callq  *%rax
  80610c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  806110:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806114:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  806118:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80611f:	00 
  806120:	e9 8e 00 00 00       	jmpq   8061b3 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  806125:	eb 31                	jmp    806158 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  806127:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80612b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80612f:	48 89 d6             	mov    %rdx,%rsi
  806132:	48 89 c7             	mov    %rax,%rdi
  806135:	48 b8 c8 5e 80 00 00 	movabs $0x805ec8,%rax
  80613c:	00 00 00 
  80613f:	ff d0                	callq  *%rax
  806141:	85 c0                	test   %eax,%eax
  806143:	74 07                	je     80614c <devpipe_write+0x67>
				return 0;
  806145:	b8 00 00 00 00       	mov    $0x0,%eax
  80614a:	eb 79                	jmp    8061c5 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80614c:	48 b8 4b 48 80 00 00 	movabs $0x80484b,%rax
  806153:	00 00 00 
  806156:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  806158:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80615c:	8b 40 04             	mov    0x4(%rax),%eax
  80615f:	48 63 d0             	movslq %eax,%rdx
  806162:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806166:	8b 00                	mov    (%rax),%eax
  806168:	48 98                	cltq   
  80616a:	48 83 c0 20          	add    $0x20,%rax
  80616e:	48 39 c2             	cmp    %rax,%rdx
  806171:	73 b4                	jae    806127 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  806173:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806177:	8b 40 04             	mov    0x4(%rax),%eax
  80617a:	99                   	cltd   
  80617b:	c1 ea 1b             	shr    $0x1b,%edx
  80617e:	01 d0                	add    %edx,%eax
  806180:	83 e0 1f             	and    $0x1f,%eax
  806183:	29 d0                	sub    %edx,%eax
  806185:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  806189:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80618d:	48 01 ca             	add    %rcx,%rdx
  806190:	0f b6 0a             	movzbl (%rdx),%ecx
  806193:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806197:	48 98                	cltq   
  806199:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80619d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8061a1:	8b 40 04             	mov    0x4(%rax),%eax
  8061a4:	8d 50 01             	lea    0x1(%rax),%edx
  8061a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8061ab:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8061ae:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8061b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8061b7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8061bb:	0f 82 64 ff ff ff    	jb     806125 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8061c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8061c5:	c9                   	leaveq 
  8061c6:	c3                   	retq   

00000000008061c7 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8061c7:	55                   	push   %rbp
  8061c8:	48 89 e5             	mov    %rsp,%rbp
  8061cb:	48 83 ec 20          	sub    $0x20,%rsp
  8061cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8061d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8061d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8061db:	48 89 c7             	mov    %rax,%rdi
  8061de:	48 b8 43 4e 80 00 00 	movabs $0x804e43,%rax
  8061e5:	00 00 00 
  8061e8:	ff d0                	callq  *%rax
  8061ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8061ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8061f2:	48 be da 71 80 00 00 	movabs $0x8071da,%rsi
  8061f9:	00 00 00 
  8061fc:	48 89 c7             	mov    %rax,%rdi
  8061ff:	48 b8 5a 3f 80 00 00 	movabs $0x803f5a,%rax
  806206:	00 00 00 
  806209:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80620b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80620f:	8b 50 04             	mov    0x4(%rax),%edx
  806212:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806216:	8b 00                	mov    (%rax),%eax
  806218:	29 c2                	sub    %eax,%edx
  80621a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80621e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  806224:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806228:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80622f:	00 00 00 
	stat->st_dev = &devpipe;
  806232:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806236:	48 b9 00 11 81 00 00 	movabs $0x811100,%rcx
  80623d:	00 00 00 
  806240:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  806247:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80624c:	c9                   	leaveq 
  80624d:	c3                   	retq   

000000000080624e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80624e:	55                   	push   %rbp
  80624f:	48 89 e5             	mov    %rsp,%rbp
  806252:	48 83 ec 10          	sub    $0x10,%rsp
  806256:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80625a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80625e:	48 89 c6             	mov    %rax,%rsi
  806261:	bf 00 00 00 00       	mov    $0x0,%edi
  806266:	48 b8 34 49 80 00 00 	movabs $0x804934,%rax
  80626d:	00 00 00 
  806270:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  806272:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806276:	48 89 c7             	mov    %rax,%rdi
  806279:	48 b8 43 4e 80 00 00 	movabs $0x804e43,%rax
  806280:	00 00 00 
  806283:	ff d0                	callq  *%rax
  806285:	48 89 c6             	mov    %rax,%rsi
  806288:	bf 00 00 00 00       	mov    $0x0,%edi
  80628d:	48 b8 34 49 80 00 00 	movabs $0x804934,%rax
  806294:	00 00 00 
  806297:	ff d0                	callq  *%rax
}
  806299:	c9                   	leaveq 
  80629a:	c3                   	retq   

000000000080629b <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80629b:	55                   	push   %rbp
  80629c:	48 89 e5             	mov    %rsp,%rbp
  80629f:	48 83 ec 20          	sub    $0x20,%rsp
  8062a3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8062a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8062a9:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8062ac:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8062b0:	be 01 00 00 00       	mov    $0x1,%esi
  8062b5:	48 89 c7             	mov    %rax,%rdi
  8062b8:	48 b8 41 47 80 00 00 	movabs $0x804741,%rax
  8062bf:	00 00 00 
  8062c2:	ff d0                	callq  *%rax
}
  8062c4:	c9                   	leaveq 
  8062c5:	c3                   	retq   

00000000008062c6 <getchar>:

int
getchar(void)
{
  8062c6:	55                   	push   %rbp
  8062c7:	48 89 e5             	mov    %rsp,%rbp
  8062ca:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8062ce:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8062d2:	ba 01 00 00 00       	mov    $0x1,%edx
  8062d7:	48 89 c6             	mov    %rax,%rsi
  8062da:	bf 00 00 00 00       	mov    $0x0,%edi
  8062df:	48 b8 38 53 80 00 00 	movabs $0x805338,%rax
  8062e6:	00 00 00 
  8062e9:	ff d0                	callq  *%rax
  8062eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8062ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8062f2:	79 05                	jns    8062f9 <getchar+0x33>
		return r;
  8062f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8062f7:	eb 14                	jmp    80630d <getchar+0x47>
	if (r < 1)
  8062f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8062fd:	7f 07                	jg     806306 <getchar+0x40>
		return -E_EOF;
  8062ff:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  806304:	eb 07                	jmp    80630d <getchar+0x47>
	return c;
  806306:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80630a:	0f b6 c0             	movzbl %al,%eax
}
  80630d:	c9                   	leaveq 
  80630e:	c3                   	retq   

000000000080630f <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80630f:	55                   	push   %rbp
  806310:	48 89 e5             	mov    %rsp,%rbp
  806313:	48 83 ec 20          	sub    $0x20,%rsp
  806317:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80631a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80631e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806321:	48 89 d6             	mov    %rdx,%rsi
  806324:	89 c7                	mov    %eax,%edi
  806326:	48 b8 06 4f 80 00 00 	movabs $0x804f06,%rax
  80632d:	00 00 00 
  806330:	ff d0                	callq  *%rax
  806332:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806335:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806339:	79 05                	jns    806340 <iscons+0x31>
		return r;
  80633b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80633e:	eb 1a                	jmp    80635a <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  806340:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806344:	8b 10                	mov    (%rax),%edx
  806346:	48 b8 40 11 81 00 00 	movabs $0x811140,%rax
  80634d:	00 00 00 
  806350:	8b 00                	mov    (%rax),%eax
  806352:	39 c2                	cmp    %eax,%edx
  806354:	0f 94 c0             	sete   %al
  806357:	0f b6 c0             	movzbl %al,%eax
}
  80635a:	c9                   	leaveq 
  80635b:	c3                   	retq   

000000000080635c <opencons>:

int
opencons(void)
{
  80635c:	55                   	push   %rbp
  80635d:	48 89 e5             	mov    %rsp,%rbp
  806360:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  806364:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  806368:	48 89 c7             	mov    %rax,%rdi
  80636b:	48 b8 6e 4e 80 00 00 	movabs $0x804e6e,%rax
  806372:	00 00 00 
  806375:	ff d0                	callq  *%rax
  806377:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80637a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80637e:	79 05                	jns    806385 <opencons+0x29>
		return r;
  806380:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806383:	eb 5b                	jmp    8063e0 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  806385:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806389:	ba 07 04 00 00       	mov    $0x407,%edx
  80638e:	48 89 c6             	mov    %rax,%rsi
  806391:	bf 00 00 00 00       	mov    $0x0,%edi
  806396:	48 b8 89 48 80 00 00 	movabs $0x804889,%rax
  80639d:	00 00 00 
  8063a0:	ff d0                	callq  *%rax
  8063a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8063a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8063a9:	79 05                	jns    8063b0 <opencons+0x54>
		return r;
  8063ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8063ae:	eb 30                	jmp    8063e0 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8063b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8063b4:	48 ba 40 11 81 00 00 	movabs $0x811140,%rdx
  8063bb:	00 00 00 
  8063be:	8b 12                	mov    (%rdx),%edx
  8063c0:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8063c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8063c6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8063cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8063d1:	48 89 c7             	mov    %rax,%rdi
  8063d4:	48 b8 20 4e 80 00 00 	movabs $0x804e20,%rax
  8063db:	00 00 00 
  8063de:	ff d0                	callq  *%rax
}
  8063e0:	c9                   	leaveq 
  8063e1:	c3                   	retq   

00000000008063e2 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8063e2:	55                   	push   %rbp
  8063e3:	48 89 e5             	mov    %rsp,%rbp
  8063e6:	48 83 ec 30          	sub    $0x30,%rsp
  8063ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8063ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8063f2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8063f6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8063fb:	75 07                	jne    806404 <devcons_read+0x22>
		return 0;
  8063fd:	b8 00 00 00 00       	mov    $0x0,%eax
  806402:	eb 4b                	jmp    80644f <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  806404:	eb 0c                	jmp    806412 <devcons_read+0x30>
		sys_yield();
  806406:	48 b8 4b 48 80 00 00 	movabs $0x80484b,%rax
  80640d:	00 00 00 
  806410:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  806412:	48 b8 8b 47 80 00 00 	movabs $0x80478b,%rax
  806419:	00 00 00 
  80641c:	ff d0                	callq  *%rax
  80641e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806421:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806425:	74 df                	je     806406 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  806427:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80642b:	79 05                	jns    806432 <devcons_read+0x50>
		return c;
  80642d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806430:	eb 1d                	jmp    80644f <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  806432:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  806436:	75 07                	jne    80643f <devcons_read+0x5d>
		return 0;
  806438:	b8 00 00 00 00       	mov    $0x0,%eax
  80643d:	eb 10                	jmp    80644f <devcons_read+0x6d>
	*(char*)vbuf = c;
  80643f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806442:	89 c2                	mov    %eax,%edx
  806444:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806448:	88 10                	mov    %dl,(%rax)
	return 1;
  80644a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80644f:	c9                   	leaveq 
  806450:	c3                   	retq   

0000000000806451 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  806451:	55                   	push   %rbp
  806452:	48 89 e5             	mov    %rsp,%rbp
  806455:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80645c:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  806463:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80646a:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  806471:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  806478:	eb 76                	jmp    8064f0 <devcons_write+0x9f>
		m = n - tot;
  80647a:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  806481:	89 c2                	mov    %eax,%edx
  806483:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806486:	29 c2                	sub    %eax,%edx
  806488:	89 d0                	mov    %edx,%eax
  80648a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80648d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806490:	83 f8 7f             	cmp    $0x7f,%eax
  806493:	76 07                	jbe    80649c <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  806495:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80649c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80649f:	48 63 d0             	movslq %eax,%rdx
  8064a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8064a5:	48 63 c8             	movslq %eax,%rcx
  8064a8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8064af:	48 01 c1             	add    %rax,%rcx
  8064b2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8064b9:	48 89 ce             	mov    %rcx,%rsi
  8064bc:	48 89 c7             	mov    %rax,%rdi
  8064bf:	48 b8 7e 42 80 00 00 	movabs $0x80427e,%rax
  8064c6:	00 00 00 
  8064c9:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8064cb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8064ce:	48 63 d0             	movslq %eax,%rdx
  8064d1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8064d8:	48 89 d6             	mov    %rdx,%rsi
  8064db:	48 89 c7             	mov    %rax,%rdi
  8064de:	48 b8 41 47 80 00 00 	movabs $0x804741,%rax
  8064e5:	00 00 00 
  8064e8:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8064ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8064ed:	01 45 fc             	add    %eax,-0x4(%rbp)
  8064f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8064f3:	48 98                	cltq   
  8064f5:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8064fc:	0f 82 78 ff ff ff    	jb     80647a <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  806502:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  806505:	c9                   	leaveq 
  806506:	c3                   	retq   

0000000000806507 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  806507:	55                   	push   %rbp
  806508:	48 89 e5             	mov    %rsp,%rbp
  80650b:	48 83 ec 08          	sub    $0x8,%rsp
  80650f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  806513:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806518:	c9                   	leaveq 
  806519:	c3                   	retq   

000000000080651a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80651a:	55                   	push   %rbp
  80651b:	48 89 e5             	mov    %rsp,%rbp
  80651e:	48 83 ec 10          	sub    $0x10,%rsp
  806522:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  806526:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80652a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80652e:	48 be e6 71 80 00 00 	movabs $0x8071e6,%rsi
  806535:	00 00 00 
  806538:	48 89 c7             	mov    %rax,%rdi
  80653b:	48 b8 5a 3f 80 00 00 	movabs $0x803f5a,%rax
  806542:	00 00 00 
  806545:	ff d0                	callq  *%rax
	return 0;
  806547:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80654c:	c9                   	leaveq 
  80654d:	c3                   	retq   
