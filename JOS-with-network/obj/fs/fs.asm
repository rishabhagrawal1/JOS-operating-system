
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
  80003c:	e8 f7 32 00 00       	callq  803338 <libmain>
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
  800120:	48 bf 80 72 80 00 00 	movabs $0x807280,%rdi
  800127:	00 00 00 
  80012a:	b8 00 00 00 00       	mov    $0x0,%eax
  80012f:	48 ba 1f 36 80 00 00 	movabs $0x80361f,%rdx
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
  80015e:	48 ba 97 72 80 00 00 	movabs $0x807297,%rdx
  800165:	00 00 00 
  800168:	be 3a 00 00 00       	mov    $0x3a,%esi
  80016d:	48 bf a7 72 80 00 00 	movabs $0x8072a7,%rdi
  800174:	00 00 00 
  800177:	b8 00 00 00 00       	mov    $0x0,%eax
  80017c:	48 b9 e6 33 80 00 00 	movabs $0x8033e6,%rcx
  800183:	00 00 00 
  800186:	ff d1                	callq  *%rcx
	diskno = d;
  800188:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
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
  8001b6:	48 b9 b0 72 80 00 00 	movabs $0x8072b0,%rcx
  8001bd:	00 00 00 
  8001c0:	48 ba bd 72 80 00 00 	movabs $0x8072bd,%rdx
  8001c7:	00 00 00 
  8001ca:	be 43 00 00 00       	mov    $0x43,%esi
  8001cf:	48 bf a7 72 80 00 00 	movabs $0x8072a7,%rdi
  8001d6:	00 00 00 
  8001d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001de:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
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
  800263:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
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
  8002ad:	eb 64                	jmp    800313 <ide_read+0x17a>
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
  8002cc:	eb 51                	jmp    80031f <ide_read+0x186>
  8002ce:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%rbp)
  8002d5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8002d9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8002dd:	c7 45 bc 00 01 00 00 	movl   $0x100,-0x44(%rbp)
}

static __inline void
insw(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsw"			:
  8002e4:	8b 55 c8             	mov    -0x38(%rbp),%edx
  8002e7:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8002eb:	8b 45 bc             	mov    -0x44(%rbp),%eax
  8002ee:	48 89 ce             	mov    %rcx,%rsi
  8002f1:	48 89 f7             	mov    %rsi,%rdi
  8002f4:	89 c1                	mov    %eax,%ecx
  8002f6:	fc                   	cld    
  8002f7:	f2 66 6d             	repnz insw (%dx),%es:(%rdi)
  8002fa:	89 c8                	mov    %ecx,%eax
  8002fc:	48 89 fe             	mov    %rdi,%rsi
  8002ff:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800303:	89 45 bc             	mov    %eax,-0x44(%rbp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800306:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80030b:	48 81 45 a0 00 02 00 	addq   $0x200,-0x60(%rbp)
  800312:	00 
  800313:	48 83 7d 98 00       	cmpq   $0x0,-0x68(%rbp)
  800318:	75 95                	jne    8002af <ide_read+0x116>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insw(0x1F0, dst, SECTSIZE/2);
	}

	return 0;
  80031a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80031f:	c9                   	leaveq 
  800320:	c3                   	retq   

0000000000800321 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  800321:	55                   	push   %rbp
  800322:	48 89 e5             	mov    %rsp,%rbp
  800325:	48 83 ec 70          	sub    $0x70,%rsp
  800329:	89 7d ac             	mov    %edi,-0x54(%rbp)
  80032c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800330:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
	int r;

	assert(nsecs <= 256);
  800334:	48 81 7d 98 00 01 00 	cmpq   $0x100,-0x68(%rbp)
  80033b:	00 
  80033c:	76 35                	jbe    800373 <ide_write+0x52>
  80033e:	48 b9 b0 72 80 00 00 	movabs $0x8072b0,%rcx
  800345:	00 00 00 
  800348:	48 ba bd 72 80 00 00 	movabs $0x8072bd,%rdx
  80034f:	00 00 00 
  800352:	be 5c 00 00 00       	mov    $0x5c,%esi
  800357:	48 bf a7 72 80 00 00 	movabs $0x8072a7,%rdi
  80035e:	00 00 00 
  800361:	b8 00 00 00 00       	mov    $0x0,%eax
  800366:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  80036d:	00 00 00 
  800370:	41 ff d0             	callq  *%r8

	ide_wait_ready(0);
  800373:	bf 00 00 00 00       	mov    $0x0,%edi
  800378:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80037f:	00 00 00 
  800382:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  800384:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800388:	0f b6 c0             	movzbl %al,%eax
  80038b:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%rbp)
  800392:	88 45 f7             	mov    %al,-0x9(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800395:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800399:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80039c:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  80039d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003a0:	0f b6 c0             	movzbl %al,%eax
  8003a3:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%rbp)
  8003aa:	88 45 ef             	mov    %al,-0x11(%rbp)
  8003ad:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8003b1:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8003b4:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  8003b5:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003b8:	c1 e8 08             	shr    $0x8,%eax
  8003bb:	0f b6 c0             	movzbl %al,%eax
  8003be:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%rbp)
  8003c5:	88 45 e7             	mov    %al,-0x19(%rbp)
  8003c8:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8003cc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8003cf:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8003d0:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003d3:	c1 e8 10             	shr    $0x10,%eax
  8003d6:	0f b6 c0             	movzbl %al,%eax
  8003d9:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%rbp)
  8003e0:	88 45 df             	mov    %al,-0x21(%rbp)
  8003e3:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  8003e7:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8003ea:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  8003eb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8003f2:	00 00 00 
  8003f5:	8b 00                	mov    (%rax),%eax
  8003f7:	83 e0 01             	and    $0x1,%eax
  8003fa:	c1 e0 04             	shl    $0x4,%eax
  8003fd:	89 c2                	mov    %eax,%edx
  8003ff:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800402:	c1 e8 18             	shr    $0x18,%eax
  800405:	83 e0 0f             	and    $0xf,%eax
  800408:	09 d0                	or     %edx,%eax
  80040a:	83 c8 e0             	or     $0xffffffe0,%eax
  80040d:	0f b6 c0             	movzbl %al,%eax
  800410:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%rbp)
  800417:	88 45 d7             	mov    %al,-0x29(%rbp)
  80041a:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
  80041e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800421:	ee                   	out    %al,(%dx)
  800422:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%rbp)
  800429:	c6 45 cf 30          	movb   $0x30,-0x31(%rbp)
  80042d:	0f b6 45 cf          	movzbl -0x31(%rbp),%eax
  800431:	8b 55 d0             	mov    -0x30(%rbp),%edx
  800434:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800435:	eb 5e                	jmp    800495 <ide_write+0x174>
		if ((r = ide_wait_ready(1)) < 0)
  800437:	bf 01 00 00 00       	mov    $0x1,%edi
  80043c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800443:	00 00 00 
  800446:	ff d0                	callq  *%rax
  800448:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80044b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80044f:	79 05                	jns    800456 <ide_write+0x135>
			return r;
  800451:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800454:	eb 4b                	jmp    8004a1 <ide_write+0x180>
  800456:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%rbp)
  80045d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800461:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800465:	c7 45 bc 00 01 00 00 	movl   $0x100,-0x44(%rbp)
}

static __inline void
outsw(int port, const void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\toutsw"		:
  80046c:	8b 55 c8             	mov    -0x38(%rbp),%edx
  80046f:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800473:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800476:	48 89 ce             	mov    %rcx,%rsi
  800479:	89 c1                	mov    %eax,%ecx
  80047b:	fc                   	cld    
  80047c:	f2 66 6f             	repnz outsw %ds:(%rsi),(%dx)
  80047f:	89 c8                	mov    %ecx,%eax
  800481:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800485:	89 45 bc             	mov    %eax,-0x44(%rbp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800488:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80048d:	48 81 45 a0 00 02 00 	addq   $0x200,-0x60(%rbp)
  800494:	00 
  800495:	48 83 7d 98 00       	cmpq   $0x0,-0x68(%rbp)
  80049a:	75 9b                	jne    800437 <ide_write+0x116>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsw(0x1F0, src, SECTSIZE/2);
	}

	return 0;
  80049c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004a1:	c9                   	leaveq 
  8004a2:	c3                   	retq   

00000000008004a3 <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint64_t blockno)
{
  8004a3:	55                   	push   %rbp
  8004a4:	48 89 e5             	mov    %rsp,%rbp
  8004a7:	48 83 ec 10          	sub    $0x10,%rsp
  8004ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8004af:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004b4:	74 2a                	je     8004e0 <diskaddr+0x3d>
  8004b6:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  8004bd:	00 00 00 
  8004c0:	48 8b 00             	mov    (%rax),%rax
  8004c3:	48 85 c0             	test   %rax,%rax
  8004c6:	74 4a                	je     800512 <diskaddr+0x6f>
  8004c8:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  8004cf:	00 00 00 
  8004d2:	48 8b 00             	mov    (%rax),%rax
  8004d5:	8b 40 04             	mov    0x4(%rax),%eax
  8004d8:	89 c0                	mov    %eax,%eax
  8004da:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8004de:	77 32                	ja     800512 <diskaddr+0x6f>
		panic("bad block number %08x in diskaddr", blockno);
  8004e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004e4:	48 89 c1             	mov    %rax,%rcx
  8004e7:	48 ba d8 72 80 00 00 	movabs $0x8072d8,%rdx
  8004ee:	00 00 00 
  8004f1:	be 09 00 00 00       	mov    $0x9,%esi
  8004f6:	48 bf fa 72 80 00 00 	movabs $0x8072fa,%rdi
  8004fd:	00 00 00 
  800500:	b8 00 00 00 00       	mov    $0x0,%eax
  800505:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  80050c:	00 00 00 
  80050f:	41 ff d0             	callq  *%r8
	return (char*) (DISKMAP + blockno * BLKSIZE);
  800512:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800516:	48 05 00 00 01 00    	add    $0x10000,%rax
  80051c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800520:	c9                   	leaveq 
  800521:	c3                   	retq   

0000000000800522 <va_is_mapped>:

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  800522:	55                   	push   %rbp
  800523:	48 89 e5             	mov    %rsp,%rbp
  800526:	48 83 ec 08          	sub    $0x8,%rsp
  80052a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpml4e[VPML4E(va)] & PTE_P) && (uvpde[VPDPE(va)] & PTE_P) && (uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  80052e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800532:	48 c1 e8 27          	shr    $0x27,%rax
  800536:	48 89 c2             	mov    %rax,%rdx
  800539:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  800540:	01 00 00 
  800543:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800547:	83 e0 01             	and    $0x1,%eax
  80054a:	48 85 c0             	test   %rax,%rax
  80054d:	74 6a                	je     8005b9 <va_is_mapped+0x97>
  80054f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800553:	48 c1 e8 1e          	shr    $0x1e,%rax
  800557:	48 89 c2             	mov    %rax,%rdx
  80055a:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  800561:	01 00 00 
  800564:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800568:	83 e0 01             	and    $0x1,%eax
  80056b:	48 85 c0             	test   %rax,%rax
  80056e:	74 49                	je     8005b9 <va_is_mapped+0x97>
  800570:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800574:	48 c1 e8 15          	shr    $0x15,%rax
  800578:	48 89 c2             	mov    %rax,%rdx
  80057b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800582:	01 00 00 
  800585:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800589:	83 e0 01             	and    $0x1,%eax
  80058c:	48 85 c0             	test   %rax,%rax
  80058f:	74 28                	je     8005b9 <va_is_mapped+0x97>
  800591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800595:	48 c1 e8 0c          	shr    $0xc,%rax
  800599:	48 89 c2             	mov    %rax,%rdx
  80059c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005a3:	01 00 00 
  8005a6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005aa:	83 e0 01             	and    $0x1,%eax
  8005ad:	48 85 c0             	test   %rax,%rax
  8005b0:	74 07                	je     8005b9 <va_is_mapped+0x97>
  8005b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8005b7:	eb 05                	jmp    8005be <va_is_mapped+0x9c>
  8005b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8005be:	83 e0 01             	and    $0x1,%eax
}
  8005c1:	c9                   	leaveq 
  8005c2:	c3                   	retq   

00000000008005c3 <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  8005c3:	55                   	push   %rbp
  8005c4:	48 89 e5             	mov    %rsp,%rbp
  8005c7:	48 83 ec 08          	sub    $0x8,%rsp
  8005cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  8005cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005d3:	48 c1 e8 0c          	shr    $0xc,%rax
  8005d7:	48 89 c2             	mov    %rax,%rdx
  8005da:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005e1:	01 00 00 
  8005e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005e8:	83 e0 40             	and    $0x40,%eax
  8005eb:	48 85 c0             	test   %rax,%rax
  8005ee:	0f 95 c0             	setne  %al
}
  8005f1:	c9                   	leaveq 
  8005f2:	c3                   	retq   

00000000008005f3 <bc_pgfault>:
// Fault any disk block that is read in to memory by
// loading it from disk.
// Hint: Use ide_read and BLKSECTS.
static void
bc_pgfault(struct UTrapframe *utf)
{
  8005f3:	55                   	push   %rbp
  8005f4:	48 89 e5             	mov    %rsp,%rbp
  8005f7:	48 83 ec 50          	sub    $0x50,%rsp
  8005fb:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  8005ff:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800603:	48 8b 00             	mov    (%rax),%rax
  800606:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  80060a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80060e:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  800614:	48 c1 e8 0c          	shr    $0xc,%rax
  800618:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80061c:	48 81 7d f8 ff ff ff 	cmpq   $0xfffffff,-0x8(%rbp)
  800623:	0f 
  800624:	76 0b                	jbe    800631 <bc_pgfault+0x3e>
  800626:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  80062b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80062f:	76 4b                	jbe    80067c <bc_pgfault+0x89>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  800631:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800635:	48 8b 48 08          	mov    0x8(%rax),%rcx
  800639:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80063d:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  800644:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800648:	49 89 c9             	mov    %rcx,%r9
  80064b:	49 89 d0             	mov    %rdx,%r8
  80064e:	48 89 c1             	mov    %rax,%rcx
  800651:	48 ba 08 73 80 00 00 	movabs $0x807308,%rdx
  800658:	00 00 00 
  80065b:	be 28 00 00 00       	mov    $0x28,%esi
  800660:	48 bf fa 72 80 00 00 	movabs $0x8072fa,%rdi
  800667:	00 00 00 
  80066a:	b8 00 00 00 00       	mov    $0x0,%eax
  80066f:	49 ba e6 33 80 00 00 	movabs $0x8033e6,%r10
  800676:	00 00 00 
  800679:	41 ff d2             	callq  *%r10
		      utf->utf_rip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  80067c:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  800683:	00 00 00 
  800686:	48 8b 00             	mov    (%rax),%rax
  800689:	48 85 c0             	test   %rax,%rax
  80068c:	74 4a                	je     8006d8 <bc_pgfault+0xe5>
  80068e:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  800695:	00 00 00 
  800698:	48 8b 00             	mov    (%rax),%rax
  80069b:	8b 40 04             	mov    0x4(%rax),%eax
  80069e:	89 c0                	mov    %eax,%eax
  8006a0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8006a4:	77 32                	ja     8006d8 <bc_pgfault+0xe5>
		panic("reading non-existent block %08x\n", blockno);
  8006a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006aa:	48 89 c1             	mov    %rax,%rcx
  8006ad:	48 ba 38 73 80 00 00 	movabs $0x807338,%rdx
  8006b4:	00 00 00 
  8006b7:	be 2c 00 00 00       	mov    $0x2c,%esi
  8006bc:	48 bf fa 72 80 00 00 	movabs $0x8072fa,%rdi
  8006c3:	00 00 00 
  8006c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006cb:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  8006d2:	00 00 00 
  8006d5:	41 ff d0             	callq  *%r8


	// LAB 5: Your code here


	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8006d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006dc:	48 c1 e8 0c          	shr    $0xc,%rax
  8006e0:	48 89 c2             	mov    %rax,%rdx
  8006e3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006ea:	01 00 00 
  8006ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006f1:	25 07 0e 00 00       	and    $0xe07,%eax
  8006f6:	89 c1                	mov    %eax,%ecx
  8006f8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8006fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800700:	41 89 c8             	mov    %ecx,%r8d
  800703:	48 89 d1             	mov    %rdx,%rcx
  800706:	ba 00 00 00 00       	mov    $0x0,%edx
  80070b:	48 89 c6             	mov    %rax,%rsi
  80070e:	bf 00 00 00 00       	mov    $0x0,%edi
  800713:	48 b8 53 4b 80 00 00 	movabs $0x804b53,%rax
  80071a:	00 00 00 
  80071d:	ff d0                	callq  *%rax
  80071f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800722:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800726:	79 30                	jns    800758 <bc_pgfault+0x165>
		panic("in bc_pgfault, sys_page_map: %e", r);
  800728:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80072b:	89 c1                	mov    %eax,%ecx
  80072d:	48 ba 60 73 80 00 00 	movabs $0x807360,%rdx
  800734:	00 00 00 
  800737:	be 3a 00 00 00       	mov    $0x3a,%esi
  80073c:	48 bf fa 72 80 00 00 	movabs $0x8072fa,%rdi
  800743:	00 00 00 
  800746:	b8 00 00 00 00       	mov    $0x0,%eax
  80074b:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  800752:	00 00 00 
  800755:	41 ff d0             	callq  *%r8

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  800758:	48 b8 10 30 81 00 00 	movabs $0x813010,%rax
  80075f:	00 00 00 
  800762:	48 8b 00             	mov    (%rax),%rax
  800765:	48 85 c0             	test   %rax,%rax
  800768:	74 48                	je     8007b2 <bc_pgfault+0x1bf>
  80076a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80076e:	89 c7                	mov    %eax,%edi
  800770:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  800777:	00 00 00 
  80077a:	ff d0                	callq  *%rax
  80077c:	84 c0                	test   %al,%al
  80077e:	74 32                	je     8007b2 <bc_pgfault+0x1bf>
		panic("reading free block %08x\n", blockno);
  800780:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800784:	48 89 c1             	mov    %rax,%rcx
  800787:	48 ba 80 73 80 00 00 	movabs $0x807380,%rdx
  80078e:	00 00 00 
  800791:	be 40 00 00 00       	mov    $0x40,%esi
  800796:	48 bf fa 72 80 00 00 	movabs $0x8072fa,%rdi
  80079d:	00 00 00 
  8007a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a5:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  8007ac:	00 00 00 
  8007af:	41 ff d0             	callq  *%r8

	{
		void *addr = (void *) utf->utf_fault_va;
  8007b2:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8007b6:	48 8b 00             	mov    (%rax),%rax
  8007b9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  8007bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8007c1:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  8007c7:	48 c1 e8 0c          	shr    $0xc,%rax
  8007cb:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
		int r;
	
		// Check that the fault was within the block cache region
		if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  8007cf:	48 81 7d e0 ff ff ff 	cmpq   $0xfffffff,-0x20(%rbp)
  8007d6:	0f 
  8007d7:	76 0b                	jbe    8007e4 <bc_pgfault+0x1f1>
  8007d9:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  8007de:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
  8007e2:	76 4b                	jbe    80082f <bc_pgfault+0x23c>
			panic("page fault in FS: eip %08x, va %08x, err %04x",
  8007e4:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8007e8:	48 8b 48 08          	mov    0x8(%rax),%rcx
  8007ec:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8007f0:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  8007f7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8007fb:	49 89 c9             	mov    %rcx,%r9
  8007fe:	49 89 d0             	mov    %rdx,%r8
  800801:	48 89 c1             	mov    %rax,%rcx
  800804:	48 ba 08 73 80 00 00 	movabs $0x807308,%rdx
  80080b:	00 00 00 
  80080e:	be 4a 00 00 00       	mov    $0x4a,%esi
  800813:	48 bf fa 72 80 00 00 	movabs $0x8072fa,%rdi
  80081a:	00 00 00 
  80081d:	b8 00 00 00 00       	mov    $0x0,%eax
  800822:	49 ba e6 33 80 00 00 	movabs $0x8033e6,%r10
  800829:	00 00 00 
  80082c:	41 ff d2             	callq  *%r10
				  utf->utf_rip, addr, utf->utf_err);
	
		// Sanity check the block number.
		if (super && blockno >= super->s_nblocks)
  80082f:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  800836:	00 00 00 
  800839:	48 8b 00             	mov    (%rax),%rax
  80083c:	48 85 c0             	test   %rax,%rax
  80083f:	74 4a                	je     80088b <bc_pgfault+0x298>
  800841:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  800848:	00 00 00 
  80084b:	48 8b 00             	mov    (%rax),%rax
  80084e:	8b 40 04             	mov    0x4(%rax),%eax
  800851:	89 c0                	mov    %eax,%eax
  800853:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800857:	77 32                	ja     80088b <bc_pgfault+0x298>
			panic("reading non-existent block %08x\n", blockno);
  800859:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80085d:	48 89 c1             	mov    %rax,%rcx
  800860:	48 ba 38 73 80 00 00 	movabs $0x807338,%rdx
  800867:	00 00 00 
  80086a:	be 4e 00 00 00       	mov    $0x4e,%esi
  80086f:	48 bf fa 72 80 00 00 	movabs $0x8072fa,%rdi
  800876:	00 00 00 
  800879:	b8 00 00 00 00       	mov    $0x0,%eax
  80087e:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  800885:	00 00 00 
  800888:	41 ff d0             	callq  *%r8
		// Allocate a page in the disk map region, read the contents
		// of the block from the disk into that page.
		// Hint: first round addr to page boundary.
		//
		// LAB 5: your code here:
		addr = ROUNDDOWN(addr, PGSIZE);
  80088b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80088f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800893:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800897:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80089d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		if(0 != sys_page_alloc(0, (void*)addr, PTE_SYSCALL)){
  8008a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008a5:	ba 07 0e 00 00       	mov    $0xe07,%edx
  8008aa:	48 89 c6             	mov    %rax,%rsi
  8008ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8008b2:	48 b8 03 4b 80 00 00 	movabs $0x804b03,%rax
  8008b9:	00 00 00 
  8008bc:	ff d0                	callq  *%rax
  8008be:	85 c0                	test   %eax,%eax
  8008c0:	74 2a                	je     8008ec <bc_pgfault+0x2f9>
			panic("Page Allocation Failed during handling page fault in FS");
  8008c2:	48 ba a0 73 80 00 00 	movabs $0x8073a0,%rdx
  8008c9:	00 00 00 
  8008cc:	be 57 00 00 00       	mov    $0x57,%esi
  8008d1:	48 bf fa 72 80 00 00 	movabs $0x8072fa,%rdi
  8008d8:	00 00 00 
  8008db:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e0:	48 b9 e6 33 80 00 00 	movabs $0x8033e6,%rcx
  8008e7:	00 00 00 
  8008ea:	ff d1                	callq  *%rcx
		}
		
		if(0 != ide_read((uint32_t) (blockno * BLKSECTS), (void*)addr, BLKSECTS))
  8008ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008f0:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
  8008f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008fb:	ba 08 00 00 00       	mov    $0x8,%edx
  800900:	48 89 c6             	mov    %rax,%rsi
  800903:	89 cf                	mov    %ecx,%edi
  800905:	48 b8 99 01 80 00 00 	movabs $0x800199,%rax
  80090c:	00 00 00 
  80090f:	ff d0                	callq  *%rax
  800911:	85 c0                	test   %eax,%eax
  800913:	74 2a                	je     80093f <bc_pgfault+0x34c>
		{
			panic("ide read failed in Page Fault Handling");		
  800915:	48 ba d8 73 80 00 00 	movabs $0x8073d8,%rdx
  80091c:	00 00 00 
  80091f:	be 5c 00 00 00       	mov    $0x5c,%esi
  800924:	48 bf fa 72 80 00 00 	movabs $0x8072fa,%rdi
  80092b:	00 00 00 
  80092e:	b8 00 00 00 00       	mov    $0x0,%eax
  800933:	48 b9 e6 33 80 00 00 	movabs $0x8033e6,%rcx
  80093a:	00 00 00 
  80093d:	ff d1                	callq  *%rcx
		}
	
		if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  80093f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800943:	48 c1 e8 0c          	shr    $0xc,%rax
  800947:	48 89 c2             	mov    %rax,%rdx
  80094a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800951:	01 00 00 
  800954:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800958:	25 07 0e 00 00       	and    $0xe07,%eax
  80095d:	89 c1                	mov    %eax,%ecx
  80095f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800963:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800967:	41 89 c8             	mov    %ecx,%r8d
  80096a:	48 89 d1             	mov    %rdx,%rcx
  80096d:	ba 00 00 00 00       	mov    $0x0,%edx
  800972:	48 89 c6             	mov    %rax,%rsi
  800975:	bf 00 00 00 00       	mov    $0x0,%edi
  80097a:	48 b8 53 4b 80 00 00 	movabs $0x804b53,%rax
  800981:	00 00 00 
  800984:	ff d0                	callq  *%rax
  800986:	89 45 cc             	mov    %eax,-0x34(%rbp)
  800989:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80098d:	79 30                	jns    8009bf <bc_pgfault+0x3cc>
			panic("in bc_pgfault, sys_page_map: %e", r);
  80098f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800992:	89 c1                	mov    %eax,%ecx
  800994:	48 ba 60 73 80 00 00 	movabs $0x807360,%rdx
  80099b:	00 00 00 
  80099e:	be 60 00 00 00       	mov    $0x60,%esi
  8009a3:	48 bf fa 72 80 00 00 	movabs $0x8072fa,%rdi
  8009aa:	00 00 00 
  8009ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b2:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  8009b9:	00 00 00 
  8009bc:	41 ff d0             	callq  *%r8
	
		// Check that the block we read was allocated. (exercise for
		// the reader: why do we do this *after* reading the block
		// in?)
		if (bitmap && block_is_free(blockno))
  8009bf:	48 b8 10 30 81 00 00 	movabs $0x813010,%rax
  8009c6:	00 00 00 
  8009c9:	48 8b 00             	mov    (%rax),%rax
  8009cc:	48 85 c0             	test   %rax,%rax
  8009cf:	74 48                	je     800a19 <bc_pgfault+0x426>
  8009d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009d5:	89 c7                	mov    %eax,%edi
  8009d7:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  8009de:	00 00 00 
  8009e1:	ff d0                	callq  *%rax
  8009e3:	84 c0                	test   %al,%al
  8009e5:	74 32                	je     800a19 <bc_pgfault+0x426>
			panic("reading free block %08x\n", blockno);
  8009e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009eb:	48 89 c1             	mov    %rax,%rcx
  8009ee:	48 ba 80 73 80 00 00 	movabs $0x807380,%rdx
  8009f5:	00 00 00 
  8009f8:	be 66 00 00 00       	mov    $0x66,%esi
  8009fd:	48 bf fa 72 80 00 00 	movabs $0x8072fa,%rdi
  800a04:	00 00 00 
  800a07:	b8 00 00 00 00       	mov    $0x0,%eax
  800a0c:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  800a13:	00 00 00 
  800a16:	41 ff d0             	callq  *%r8
	}
}
  800a19:	c9                   	leaveq 
  800a1a:	c3                   	retq   

0000000000800a1b <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
        {
  800a1b:	55                   	push   %rbp
  800a1c:	48 89 e5             	mov    %rsp,%rbp
  800a1f:	48 83 ec 30          	sub    $0x30,%rsp
  800a23:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
                uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  800a27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a2b:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  800a31:	48 c1 e8 0c          	shr    $0xc,%rax
  800a35:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
                int r;

                if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800a39:	48 81 7d d8 ff ff ff 	cmpq   $0xfffffff,-0x28(%rbp)
  800a40:	0f 
  800a41:	76 0b                	jbe    800a4e <flush_block+0x33>
  800a43:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  800a48:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  800a4c:	76 32                	jbe    800a80 <flush_block+0x65>
                        panic("flush_block of bad va %08x", addr);
  800a4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a52:	48 89 c1             	mov    %rax,%rcx
  800a55:	48 ba ff 73 80 00 00 	movabs $0x8073ff,%rdx
  800a5c:	00 00 00 
  800a5f:	be 78 00 00 00       	mov    $0x78,%esi
  800a64:	48 bf fa 72 80 00 00 	movabs $0x8072fa,%rdi
  800a6b:	00 00 00 
  800a6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a73:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  800a7a:	00 00 00 
  800a7d:	41 ff d0             	callq  *%r8

                // LAB 5: Your code here.
                //panic("flush_block not implemented");
                if(va_is_mapped(addr) == false || va_is_dirty(addr) == false)
  800a80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a84:	48 89 c7             	mov    %rax,%rdi
  800a87:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  800a8e:	00 00 00 
  800a91:	ff d0                	callq  *%rax
  800a93:	83 f0 01             	xor    $0x1,%eax
  800a96:	84 c0                	test   %al,%al
  800a98:	75 1a                	jne    800ab4 <flush_block+0x99>
  800a9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a9e:	48 89 c7             	mov    %rax,%rdi
  800aa1:	48 b8 c3 05 80 00 00 	movabs $0x8005c3,%rax
  800aa8:	00 00 00 
  800aab:	ff d0                	callq  *%rax
  800aad:	83 f0 01             	xor    $0x1,%eax
  800ab0:	84 c0                	test   %al,%al
  800ab2:	74 05                	je     800ab9 <flush_block+0x9e>
                {
                        return;
  800ab4:	e9 cc 00 00 00       	jmpq   800b85 <flush_block+0x16a>
                }
                addr = ROUNDDOWN(addr, PGSIZE);
  800ab9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800abd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800ac1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ac5:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  800acb:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
                if(0 != ide_write((uint32_t) (blockno * BLKSECTS), (void*)addr, BLKSECTS))
  800acf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ad3:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
  800ada:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800ade:	ba 08 00 00 00       	mov    $0x8,%edx
  800ae3:	48 89 c6             	mov    %rax,%rsi
  800ae6:	89 cf                	mov    %ecx,%edi
  800ae8:	48 b8 21 03 80 00 00 	movabs $0x800321,%rax
  800aef:	00 00 00 
  800af2:	ff d0                	callq  *%rax
  800af4:	85 c0                	test   %eax,%eax
  800af6:	74 2a                	je     800b22 <flush_block+0x107>
                {
                        panic("ide write failed in Flush Block");
  800af8:	48 ba 20 74 80 00 00 	movabs $0x807420,%rdx
  800aff:	00 00 00 
  800b02:	be 83 00 00 00       	mov    $0x83,%esi
  800b07:	48 bf fa 72 80 00 00 	movabs $0x8072fa,%rdi
  800b0e:	00 00 00 
  800b11:	b8 00 00 00 00       	mov    $0x0,%eax
  800b16:	48 b9 e6 33 80 00 00 	movabs $0x8033e6,%rcx
  800b1d:	00 00 00 
  800b20:	ff d1                	callq  *%rcx
                }
                if ((r = sys_page_map(0, addr, 0, addr, PTE_SYSCALL)) < 0)
  800b22:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800b26:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800b2a:	41 b8 07 0e 00 00    	mov    $0xe07,%r8d
  800b30:	48 89 d1             	mov    %rdx,%rcx
  800b33:	ba 00 00 00 00       	mov    $0x0,%edx
  800b38:	48 89 c6             	mov    %rax,%rsi
  800b3b:	bf 00 00 00 00       	mov    $0x0,%edi
  800b40:	48 b8 53 4b 80 00 00 	movabs $0x804b53,%rax
  800b47:	00 00 00 
  800b4a:	ff d0                	callq  *%rax
  800b4c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800b4f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800b53:	79 30                	jns    800b85 <flush_block+0x16a>
                {
                        panic("in flush_block, sys_page_map: %e", r);
  800b55:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800b58:	89 c1                	mov    %eax,%ecx
  800b5a:	48 ba 40 74 80 00 00 	movabs $0x807440,%rdx
  800b61:	00 00 00 
  800b64:	be 87 00 00 00       	mov    $0x87,%esi
  800b69:	48 bf fa 72 80 00 00 	movabs $0x8072fa,%rdi
  800b70:	00 00 00 
  800b73:	b8 00 00 00 00       	mov    $0x0,%eax
  800b78:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  800b7f:	00 00 00 
  800b82:	41 ff d0             	callq  *%r8
                }
        }
  800b85:	c9                   	leaveq 
  800b86:	c3                   	retq   

0000000000800b87 <check_bc>:

// Test that the block cache works, by smashing the superblock and
// reading it back.
static void
check_bc(void)
{
  800b87:	55                   	push   %rbp
  800b88:	48 89 e5             	mov    %rsp,%rbp
  800b8b:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super backup;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  800b92:	bf 01 00 00 00       	mov    $0x1,%edi
  800b97:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800b9e:	00 00 00 
  800ba1:	ff d0                	callq  *%rax
  800ba3:	48 89 c1             	mov    %rax,%rcx
  800ba6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800bad:	ba 08 01 00 00       	mov    $0x108,%edx
  800bb2:	48 89 ce             	mov    %rcx,%rsi
  800bb5:	48 89 c7             	mov    %rax,%rdi
  800bb8:	48 b8 f8 44 80 00 00 	movabs $0x8044f8,%rax
  800bbf:	00 00 00 
  800bc2:	ff d0                	callq  *%rax

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  800bc4:	bf 01 00 00 00       	mov    $0x1,%edi
  800bc9:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800bd0:	00 00 00 
  800bd3:	ff d0                	callq  *%rax
  800bd5:	48 be 61 74 80 00 00 	movabs $0x807461,%rsi
  800bdc:	00 00 00 
  800bdf:	48 89 c7             	mov    %rax,%rdi
  800be2:	48 b8 d4 41 80 00 00 	movabs $0x8041d4,%rax
  800be9:	00 00 00 
  800bec:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800bee:	bf 01 00 00 00       	mov    $0x1,%edi
  800bf3:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800bfa:	00 00 00 
  800bfd:	ff d0                	callq  *%rax
  800bff:	48 89 c7             	mov    %rax,%rdi
  800c02:	48 b8 1b 0a 80 00 00 	movabs $0x800a1b,%rax
  800c09:	00 00 00 
  800c0c:	ff d0                	callq  *%rax
	assert(va_is_mapped(diskaddr(1)));
  800c0e:	bf 01 00 00 00       	mov    $0x1,%edi
  800c13:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800c1a:	00 00 00 
  800c1d:	ff d0                	callq  *%rax
  800c1f:	48 89 c7             	mov    %rax,%rdi
  800c22:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  800c29:	00 00 00 
  800c2c:	ff d0                	callq  *%rax
  800c2e:	83 f0 01             	xor    $0x1,%eax
  800c31:	84 c0                	test   %al,%al
  800c33:	74 35                	je     800c6a <check_bc+0xe3>
  800c35:	48 b9 68 74 80 00 00 	movabs $0x807468,%rcx
  800c3c:	00 00 00 
  800c3f:	48 ba 82 74 80 00 00 	movabs $0x807482,%rdx
  800c46:	00 00 00 
  800c49:	be 99 00 00 00       	mov    $0x99,%esi
  800c4e:	48 bf fa 72 80 00 00 	movabs $0x8072fa,%rdi
  800c55:	00 00 00 
  800c58:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5d:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  800c64:	00 00 00 
  800c67:	41 ff d0             	callq  *%r8
	assert(!va_is_dirty(diskaddr(1)));
  800c6a:	bf 01 00 00 00       	mov    $0x1,%edi
  800c6f:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800c76:	00 00 00 
  800c79:	ff d0                	callq  *%rax
  800c7b:	48 89 c7             	mov    %rax,%rdi
  800c7e:	48 b8 c3 05 80 00 00 	movabs $0x8005c3,%rax
  800c85:	00 00 00 
  800c88:	ff d0                	callq  *%rax
  800c8a:	84 c0                	test   %al,%al
  800c8c:	74 35                	je     800cc3 <check_bc+0x13c>
  800c8e:	48 b9 97 74 80 00 00 	movabs $0x807497,%rcx
  800c95:	00 00 00 
  800c98:	48 ba 82 74 80 00 00 	movabs $0x807482,%rdx
  800c9f:	00 00 00 
  800ca2:	be 9a 00 00 00       	mov    $0x9a,%esi
  800ca7:	48 bf fa 72 80 00 00 	movabs $0x8072fa,%rdi
  800cae:	00 00 00 
  800cb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb6:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  800cbd:	00 00 00 
  800cc0:	41 ff d0             	callq  *%r8

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  800cc3:	bf 01 00 00 00       	mov    $0x1,%edi
  800cc8:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800ccf:	00 00 00 
  800cd2:	ff d0                	callq  *%rax
  800cd4:	48 89 c6             	mov    %rax,%rsi
  800cd7:	bf 00 00 00 00       	mov    $0x0,%edi
  800cdc:	48 b8 ae 4b 80 00 00 	movabs $0x804bae,%rax
  800ce3:	00 00 00 
  800ce6:	ff d0                	callq  *%rax
	assert(!va_is_mapped(diskaddr(1)));
  800ce8:	bf 01 00 00 00       	mov    $0x1,%edi
  800ced:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800cf4:	00 00 00 
  800cf7:	ff d0                	callq  *%rax
  800cf9:	48 89 c7             	mov    %rax,%rdi
  800cfc:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  800d03:	00 00 00 
  800d06:	ff d0                	callq  *%rax
  800d08:	84 c0                	test   %al,%al
  800d0a:	74 35                	je     800d41 <check_bc+0x1ba>
  800d0c:	48 b9 b1 74 80 00 00 	movabs $0x8074b1,%rcx
  800d13:	00 00 00 
  800d16:	48 ba 82 74 80 00 00 	movabs $0x807482,%rdx
  800d1d:	00 00 00 
  800d20:	be 9e 00 00 00       	mov    $0x9e,%esi
  800d25:	48 bf fa 72 80 00 00 	movabs $0x8072fa,%rdi
  800d2c:	00 00 00 
  800d2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d34:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  800d3b:	00 00 00 
  800d3e:	41 ff d0             	callq  *%r8

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800d41:	bf 01 00 00 00       	mov    $0x1,%edi
  800d46:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800d4d:	00 00 00 
  800d50:	ff d0                	callq  *%rax
  800d52:	48 be 61 74 80 00 00 	movabs $0x807461,%rsi
  800d59:	00 00 00 
  800d5c:	48 89 c7             	mov    %rax,%rdi
  800d5f:	48 b8 36 43 80 00 00 	movabs $0x804336,%rax
  800d66:	00 00 00 
  800d69:	ff d0                	callq  *%rax
  800d6b:	85 c0                	test   %eax,%eax
  800d6d:	74 35                	je     800da4 <check_bc+0x21d>
  800d6f:	48 b9 d0 74 80 00 00 	movabs $0x8074d0,%rcx
  800d76:	00 00 00 
  800d79:	48 ba 82 74 80 00 00 	movabs $0x807482,%rdx
  800d80:	00 00 00 
  800d83:	be a1 00 00 00       	mov    $0xa1,%esi
  800d88:	48 bf fa 72 80 00 00 	movabs $0x8072fa,%rdi
  800d8f:	00 00 00 
  800d92:	b8 00 00 00 00       	mov    $0x0,%eax
  800d97:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  800d9e:	00 00 00 
  800da1:	41 ff d0             	callq  *%r8

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  800da4:	bf 01 00 00 00       	mov    $0x1,%edi
  800da9:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800db0:	00 00 00 
  800db3:	ff d0                	callq  *%rax
  800db5:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  800dbc:	ba 08 01 00 00       	mov    $0x108,%edx
  800dc1:	48 89 ce             	mov    %rcx,%rsi
  800dc4:	48 89 c7             	mov    %rax,%rdi
  800dc7:	48 b8 f8 44 80 00 00 	movabs $0x8044f8,%rax
  800dce:	00 00 00 
  800dd1:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800dd3:	bf 01 00 00 00       	mov    $0x1,%edi
  800dd8:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800ddf:	00 00 00 
  800de2:	ff d0                	callq  *%rax
  800de4:	48 89 c7             	mov    %rax,%rdi
  800de7:	48 b8 1b 0a 80 00 00 	movabs $0x800a1b,%rax
  800dee:	00 00 00 
  800df1:	ff d0                	callq  *%rax

	cprintf("block cache is good\n");
  800df3:	48 bf f4 74 80 00 00 	movabs $0x8074f4,%rdi
  800dfa:	00 00 00 
  800dfd:	b8 00 00 00 00       	mov    $0x0,%eax
  800e02:	48 ba 1f 36 80 00 00 	movabs $0x80361f,%rdx
  800e09:	00 00 00 
  800e0c:	ff d2                	callq  *%rdx
}
  800e0e:	c9                   	leaveq 
  800e0f:	c3                   	retq   

0000000000800e10 <bc_init>:

void
bc_init(void)
{
  800e10:	55                   	push   %rbp
  800e11:	48 89 e5             	mov    %rsp,%rbp
  800e14:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  800e1b:	48 bf f3 05 80 00 00 	movabs $0x8005f3,%rdi
  800e22:	00 00 00 
  800e25:	48 b8 3a 4e 80 00 00 	movabs $0x804e3a,%rax
  800e2c:	00 00 00 
  800e2f:	ff d0                	callq  *%rax
	check_bc();
  800e31:	48 b8 87 0b 80 00 00 	movabs $0x800b87,%rax
  800e38:	00 00 00 
  800e3b:	ff d0                	callq  *%rax

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800e3d:	bf 01 00 00 00       	mov    $0x1,%edi
  800e42:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800e49:	00 00 00 
  800e4c:	ff d0                	callq  *%rax
  800e4e:	48 89 c1             	mov    %rax,%rcx
  800e51:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800e58:	ba 08 01 00 00       	mov    $0x108,%edx
  800e5d:	48 89 ce             	mov    %rcx,%rsi
  800e60:	48 89 c7             	mov    %rax,%rdi
  800e63:	48 b8 f8 44 80 00 00 	movabs $0x8044f8,%rax
  800e6a:	00 00 00 
  800e6d:	ff d0                	callq  *%rax
}
  800e6f:	c9                   	leaveq 
  800e70:	c3                   	retq   

0000000000800e71 <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  800e71:	55                   	push   %rbp
  800e72:	48 89 e5             	mov    %rsp,%rbp
	if (super->s_magic != FS_MAGIC)
  800e75:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  800e7c:	00 00 00 
  800e7f:	48 8b 00             	mov    (%rax),%rax
  800e82:	8b 00                	mov    (%rax),%eax
  800e84:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  800e89:	74 2a                	je     800eb5 <check_super+0x44>
		panic("bad file system magic number");
  800e8b:	48 ba 10 75 80 00 00 	movabs $0x807510,%rdx
  800e92:	00 00 00 
  800e95:	be 0e 00 00 00       	mov    $0xe,%esi
  800e9a:	48 bf 2d 75 80 00 00 	movabs $0x80752d,%rdi
  800ea1:	00 00 00 
  800ea4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea9:	48 b9 e6 33 80 00 00 	movabs $0x8033e6,%rcx
  800eb0:	00 00 00 
  800eb3:	ff d1                	callq  *%rcx

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800eb5:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  800ebc:	00 00 00 
  800ebf:	48 8b 00             	mov    (%rax),%rax
  800ec2:	8b 40 04             	mov    0x4(%rax),%eax
  800ec5:	3d 00 00 0c 00       	cmp    $0xc0000,%eax
  800eca:	76 2a                	jbe    800ef6 <check_super+0x85>
		panic("file system is too large");
  800ecc:	48 ba 35 75 80 00 00 	movabs $0x807535,%rdx
  800ed3:	00 00 00 
  800ed6:	be 11 00 00 00       	mov    $0x11,%esi
  800edb:	48 bf 2d 75 80 00 00 	movabs $0x80752d,%rdi
  800ee2:	00 00 00 
  800ee5:	b8 00 00 00 00       	mov    $0x0,%eax
  800eea:	48 b9 e6 33 80 00 00 	movabs $0x8033e6,%rcx
  800ef1:	00 00 00 
  800ef4:	ff d1                	callq  *%rcx

	cprintf("superblock is good\n");
  800ef6:	48 bf 4e 75 80 00 00 	movabs $0x80754e,%rdi
  800efd:	00 00 00 
  800f00:	b8 00 00 00 00       	mov    $0x0,%eax
  800f05:	48 ba 1f 36 80 00 00 	movabs $0x80361f,%rdx
  800f0c:	00 00 00 
  800f0f:	ff d2                	callq  *%rdx
}
  800f11:	5d                   	pop    %rbp
  800f12:	c3                   	retq   

0000000000800f13 <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  800f13:	55                   	push   %rbp
  800f14:	48 89 e5             	mov    %rsp,%rbp
  800f17:	48 83 ec 04          	sub    $0x4,%rsp
  800f1b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	if (super == 0 || blockno >= super->s_nblocks)
  800f1e:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  800f25:	00 00 00 
  800f28:	48 8b 00             	mov    (%rax),%rax
  800f2b:	48 85 c0             	test   %rax,%rax
  800f2e:	74 15                	je     800f45 <block_is_free+0x32>
  800f30:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  800f37:	00 00 00 
  800f3a:	48 8b 00             	mov    (%rax),%rax
  800f3d:	8b 40 04             	mov    0x4(%rax),%eax
  800f40:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800f43:	77 07                	ja     800f4c <block_is_free+0x39>
		return 0;
  800f45:	b8 00 00 00 00       	mov    $0x0,%eax
  800f4a:	eb 41                	jmp    800f8d <block_is_free+0x7a>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  800f4c:	48 b8 10 30 81 00 00 	movabs $0x813010,%rax
  800f53:	00 00 00 
  800f56:	48 8b 00             	mov    (%rax),%rax
  800f59:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f5c:	c1 ea 05             	shr    $0x5,%edx
  800f5f:	89 d2                	mov    %edx,%edx
  800f61:	48 c1 e2 02          	shl    $0x2,%rdx
  800f65:	48 01 d0             	add    %rdx,%rax
  800f68:	8b 10                	mov    (%rax),%edx
  800f6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f6d:	83 e0 1f             	and    $0x1f,%eax
  800f70:	be 01 00 00 00       	mov    $0x1,%esi
  800f75:	89 c1                	mov    %eax,%ecx
  800f77:	d3 e6                	shl    %cl,%esi
  800f79:	89 f0                	mov    %esi,%eax
  800f7b:	21 d0                	and    %edx,%eax
  800f7d:	85 c0                	test   %eax,%eax
  800f7f:	74 07                	je     800f88 <block_is_free+0x75>
		return 1;
  800f81:	b8 01 00 00 00       	mov    $0x1,%eax
  800f86:	eb 05                	jmp    800f8d <block_is_free+0x7a>
	return 0;
  800f88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f8d:	c9                   	leaveq 
  800f8e:	c3                   	retq   

0000000000800f8f <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800f8f:	55                   	push   %rbp
  800f90:	48 89 e5             	mov    %rsp,%rbp
  800f93:	48 83 ec 10          	sub    $0x10,%rsp
  800f97:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  800f9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f9e:	75 2a                	jne    800fca <free_block+0x3b>
		panic("attempt to free zero block");
  800fa0:	48 ba 62 75 80 00 00 	movabs $0x807562,%rdx
  800fa7:	00 00 00 
  800faa:	be 2c 00 00 00       	mov    $0x2c,%esi
  800faf:	48 bf 2d 75 80 00 00 	movabs $0x80752d,%rdi
  800fb6:	00 00 00 
  800fb9:	b8 00 00 00 00       	mov    $0x0,%eax
  800fbe:	48 b9 e6 33 80 00 00 	movabs $0x8033e6,%rcx
  800fc5:	00 00 00 
  800fc8:	ff d1                	callq  *%rcx
	bitmap[blockno/32] |= 1<<(blockno%32);
  800fca:	48 b8 10 30 81 00 00 	movabs $0x813010,%rax
  800fd1:	00 00 00 
  800fd4:	48 8b 10             	mov    (%rax),%rdx
  800fd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fda:	c1 e8 05             	shr    $0x5,%eax
  800fdd:	89 c1                	mov    %eax,%ecx
  800fdf:	48 c1 e1 02          	shl    $0x2,%rcx
  800fe3:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
  800fe7:	48 ba 10 30 81 00 00 	movabs $0x813010,%rdx
  800fee:	00 00 00 
  800ff1:	48 8b 12             	mov    (%rdx),%rdx
  800ff4:	89 c0                	mov    %eax,%eax
  800ff6:	48 c1 e0 02          	shl    $0x2,%rax
  800ffa:	48 01 d0             	add    %rdx,%rax
  800ffd:	8b 10                	mov    (%rax),%edx
  800fff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801002:	83 e0 1f             	and    $0x1f,%eax
  801005:	bf 01 00 00 00       	mov    $0x1,%edi
  80100a:	89 c1                	mov    %eax,%ecx
  80100c:	d3 e7                	shl    %cl,%edi
  80100e:	89 f8                	mov    %edi,%eax
  801010:	09 d0                	or     %edx,%eax
  801012:	89 06                	mov    %eax,(%rsi)
}
  801014:	c9                   	leaveq 
  801015:	c3                   	retq   

0000000000801016 <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
        {
  801016:	55                   	push   %rbp
  801017:	48 89 e5             	mov    %rsp,%rbp
  80101a:	48 83 ec 10          	sub    $0x10,%rsp
                // contains the in-use bits for BLKBITSIZE blocks.      There are
                // super->s_nblocks blocks in the disk altogether.

                // LAB 5: Your code here.
                //panic("alloc_block not implemented");
                uint32_t blockno = 2;
  80101e:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%rbp)
                static int blocks_allocated = 0;
                for(; blockno < super->s_nblocks; blockno++)
  801025:	e9 a5 00 00 00       	jmpq   8010cf <alloc_block+0xb9>
                {
                        if(block_is_free(blockno))
  80102a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80102d:	89 c7                	mov    %eax,%edi
  80102f:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  801036:	00 00 00 
  801039:	ff d0                	callq  *%rax
  80103b:	84 c0                	test   %al,%al
  80103d:	0f 84 88 00 00 00    	je     8010cb <alloc_block+0xb5>
                        {
                                bitmap[blockno/32] &= ~(1<<(blockno%32));
  801043:	48 b8 10 30 81 00 00 	movabs $0x813010,%rax
  80104a:	00 00 00 
  80104d:	48 8b 10             	mov    (%rax),%rdx
  801050:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801053:	c1 e8 05             	shr    $0x5,%eax
  801056:	89 c1                	mov    %eax,%ecx
  801058:	48 c1 e1 02          	shl    $0x2,%rcx
  80105c:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
  801060:	48 ba 10 30 81 00 00 	movabs $0x813010,%rdx
  801067:	00 00 00 
  80106a:	48 8b 12             	mov    (%rdx),%rdx
  80106d:	89 c0                	mov    %eax,%eax
  80106f:	48 c1 e0 02          	shl    $0x2,%rax
  801073:	48 01 d0             	add    %rdx,%rax
  801076:	8b 10                	mov    (%rax),%edx
  801078:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80107b:	83 e0 1f             	and    $0x1f,%eax
  80107e:	bf 01 00 00 00       	mov    $0x1,%edi
  801083:	89 c1                	mov    %eax,%ecx
  801085:	d3 e7                	shl    %cl,%edi
  801087:	89 f8                	mov    %edi,%eax
  801089:	f7 d0                	not    %eax
  80108b:	21 d0                	and    %edx,%eax
  80108d:	89 06                	mov    %eax,(%rsi)
                                flush_block((void*)bitmap);
  80108f:	48 b8 10 30 81 00 00 	movabs $0x813010,%rax
  801096:	00 00 00 
  801099:	48 8b 00             	mov    (%rax),%rax
  80109c:	48 89 c7             	mov    %rax,%rdi
  80109f:	48 b8 1b 0a 80 00 00 	movabs $0x800a1b,%rax
  8010a6:	00 00 00 
  8010a9:	ff d0                	callq  *%rax
                                //cprintf("alloc_block_retrning block # [%d]\n", blockno);
                                blocks_allocated++;
  8010ab:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  8010b2:	00 00 00 
  8010b5:	8b 00                	mov    (%rax),%eax
  8010b7:	8d 50 01             	lea    0x1(%rax),%edx
  8010ba:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  8010c1:	00 00 00 
  8010c4:	89 10                	mov    %edx,(%rax)
                                return blockno;
  8010c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010c9:	eb 4b                	jmp    801116 <alloc_block+0x100>

                // LAB 5: Your code here.
                //panic("alloc_block not implemented");
                uint32_t blockno = 2;
                static int blocks_allocated = 0;
                for(; blockno < super->s_nblocks; blockno++)
  8010cb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8010cf:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  8010d6:	00 00 00 
  8010d9:	48 8b 00             	mov    (%rax),%rax
  8010dc:	8b 40 04             	mov    0x4(%rax),%eax
  8010df:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8010e2:	0f 87 42 ff ff ff    	ja     80102a <alloc_block+0x14>
                                //cprintf("alloc_block_retrning block # [%d]\n", blockno);
                                blocks_allocated++;
                                return blockno;
                        }
                }
                cprintf("alloc_block_failed and retrning block # [%d]\n", blocks_allocated);
  8010e8:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  8010ef:	00 00 00 
  8010f2:	8b 00                	mov    (%rax),%eax
  8010f4:	89 c6                	mov    %eax,%esi
  8010f6:	48 bf 80 75 80 00 00 	movabs $0x807580,%rdi
  8010fd:	00 00 00 
  801100:	b8 00 00 00 00       	mov    $0x0,%eax
  801105:	48 ba 1f 36 80 00 00 	movabs $0x80361f,%rdx
  80110c:	00 00 00 
  80110f:	ff d2                	callq  *%rdx
                return -E_NO_DISK;
  801111:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
        }
  801116:	c9                   	leaveq 
  801117:	c3                   	retq   

0000000000801118 <check_bitmap>:
//
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use.
void
check_bitmap(void)
{
  801118:	55                   	push   %rbp
  801119:	48 89 e5             	mov    %rsp,%rbp
  80111c:	48 83 ec 10          	sub    $0x10,%rsp
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  801120:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801127:	eb 51                	jmp    80117a <check_bitmap+0x62>
		assert(!block_is_free(2+i));
  801129:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80112c:	83 c0 02             	add    $0x2,%eax
  80112f:	89 c7                	mov    %eax,%edi
  801131:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  801138:	00 00 00 
  80113b:	ff d0                	callq  *%rax
  80113d:	84 c0                	test   %al,%al
  80113f:	74 35                	je     801176 <check_bitmap+0x5e>
  801141:	48 b9 ae 75 80 00 00 	movabs $0x8075ae,%rcx
  801148:	00 00 00 
  80114b:	48 ba c2 75 80 00 00 	movabs $0x8075c2,%rdx
  801152:	00 00 00 
  801155:	be 5e 00 00 00       	mov    $0x5e,%esi
  80115a:	48 bf 2d 75 80 00 00 	movabs $0x80752d,%rdi
  801161:	00 00 00 
  801164:	b8 00 00 00 00       	mov    $0x0,%eax
  801169:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  801170:	00 00 00 
  801173:	41 ff d0             	callq  *%r8
check_bitmap(void)
{
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  801176:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80117a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80117d:	c1 e0 0f             	shl    $0xf,%eax
  801180:	89 c2                	mov    %eax,%edx
  801182:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  801189:	00 00 00 
  80118c:	48 8b 00             	mov    (%rax),%rax
  80118f:	8b 40 04             	mov    0x4(%rax),%eax
  801192:	39 c2                	cmp    %eax,%edx
  801194:	72 93                	jb     801129 <check_bitmap+0x11>
		assert(!block_is_free(2+i));

	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
  801196:	bf 00 00 00 00       	mov    $0x0,%edi
  80119b:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  8011a2:	00 00 00 
  8011a5:	ff d0                	callq  *%rax
  8011a7:	84 c0                	test   %al,%al
  8011a9:	74 35                	je     8011e0 <check_bitmap+0xc8>
  8011ab:	48 b9 d7 75 80 00 00 	movabs $0x8075d7,%rcx
  8011b2:	00 00 00 
  8011b5:	48 ba c2 75 80 00 00 	movabs $0x8075c2,%rdx
  8011bc:	00 00 00 
  8011bf:	be 61 00 00 00       	mov    $0x61,%esi
  8011c4:	48 bf 2d 75 80 00 00 	movabs $0x80752d,%rdi
  8011cb:	00 00 00 
  8011ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d3:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  8011da:	00 00 00 
  8011dd:	41 ff d0             	callq  *%r8
	assert(!block_is_free(1));
  8011e0:	bf 01 00 00 00       	mov    $0x1,%edi
  8011e5:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  8011ec:	00 00 00 
  8011ef:	ff d0                	callq  *%rax
  8011f1:	84 c0                	test   %al,%al
  8011f3:	74 35                	je     80122a <check_bitmap+0x112>
  8011f5:	48 b9 e9 75 80 00 00 	movabs $0x8075e9,%rcx
  8011fc:	00 00 00 
  8011ff:	48 ba c2 75 80 00 00 	movabs $0x8075c2,%rdx
  801206:	00 00 00 
  801209:	be 62 00 00 00       	mov    $0x62,%esi
  80120e:	48 bf 2d 75 80 00 00 	movabs $0x80752d,%rdi
  801215:	00 00 00 
  801218:	b8 00 00 00 00       	mov    $0x0,%eax
  80121d:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  801224:	00 00 00 
  801227:	41 ff d0             	callq  *%r8

	cprintf("bitmap is good\n");
  80122a:	48 bf fb 75 80 00 00 	movabs $0x8075fb,%rdi
  801231:	00 00 00 
  801234:	b8 00 00 00 00       	mov    $0x0,%eax
  801239:	48 ba 1f 36 80 00 00 	movabs $0x80361f,%rdx
  801240:	00 00 00 
  801243:	ff d2                	callq  *%rdx
}
  801245:	c9                   	leaveq 
  801246:	c3                   	retq   

0000000000801247 <fs_init>:


// Initialize the file system
void
fs_init(void)
{
  801247:	55                   	push   %rbp
  801248:	48 89 e5             	mov    %rsp,%rbp
	static_assert(sizeof(struct File) == 256);


	// Find a JOS disk.  Use the second IDE disk (number 1) if available.
	if (ide_probe_disk1())
  80124b:	48 b8 96 00 80 00 00 	movabs $0x800096,%rax
  801252:	00 00 00 
  801255:	ff d0                	callq  *%rax
  801257:	84 c0                	test   %al,%al
  801259:	74 13                	je     80126e <fs_init+0x27>
		ide_set_disk(1);
  80125b:	bf 01 00 00 00       	mov    $0x1,%edi
  801260:	48 b8 47 01 80 00 00 	movabs $0x800147,%rax
  801267:	00 00 00 
  80126a:	ff d0                	callq  *%rax
  80126c:	eb 11                	jmp    80127f <fs_init+0x38>
	else
		ide_set_disk(0);
  80126e:	bf 00 00 00 00       	mov    $0x0,%edi
  801273:	48 b8 47 01 80 00 00 	movabs $0x800147,%rax
  80127a:	00 00 00 
  80127d:	ff d0                	callq  *%rax


	bc_init();
  80127f:	48 b8 10 0e 80 00 00 	movabs $0x800e10,%rax
  801286:	00 00 00 
  801289:	ff d0                	callq  *%rax

	// Set "super" to point to the super block.
	super = diskaddr(1);
  80128b:	bf 01 00 00 00       	mov    $0x1,%edi
  801290:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801297:	00 00 00 
  80129a:	ff d0                	callq  *%rax
  80129c:	48 ba 18 30 81 00 00 	movabs $0x813018,%rdx
  8012a3:	00 00 00 
  8012a6:	48 89 02             	mov    %rax,(%rdx)
	check_super();
  8012a9:	48 b8 71 0e 80 00 00 	movabs $0x800e71,%rax
  8012b0:	00 00 00 
  8012b3:	ff d0                	callq  *%rax

	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
  8012b5:	bf 02 00 00 00       	mov    $0x2,%edi
  8012ba:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8012c1:	00 00 00 
  8012c4:	ff d0                	callq  *%rax
  8012c6:	48 ba 10 30 81 00 00 	movabs $0x813010,%rdx
  8012cd:	00 00 00 
  8012d0:	48 89 02             	mov    %rax,(%rdx)
	check_bitmap();
  8012d3:	48 b8 18 11 80 00 00 	movabs $0x801118,%rax
  8012da:	00 00 00 
  8012dd:	ff d0                	callq  *%rax
}
  8012df:	5d                   	pop    %rbp
  8012e0:	c3                   	retq   

00000000008012e1 <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
        {
  8012e1:	55                   	push   %rbp
  8012e2:	48 89 e5             	mov    %rsp,%rbp
  8012e5:	48 83 ec 30          	sub    $0x30,%rsp
  8012e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ed:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8012f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8012f4:	89 c8                	mov    %ecx,%eax
  8012f6:	88 45 e0             	mov    %al,-0x20(%rbp)
                // LAB 5: Your code here.
                //if filebno is out of range
                //panic("file_block_walk not implemented");
                uint32_t* indirect = 0;
  8012f9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801300:	00 
                uint32_t nblock = 0;
  801301:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
                int freeBlock = 0;
  801308:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)

                if(filebno >= NDIRECT + NINDIRECT)
  80130f:	81 7d e4 09 04 00 00 	cmpl   $0x409,-0x1c(%rbp)
  801316:	76 0a                	jbe    801322 <file_block_walk+0x41>
                {
                        return -E_INVAL;
  801318:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80131d:	e9 1f 01 00 00       	jmpq   801441 <file_block_walk+0x160>
                }
                nblock = f->f_size / BLKSIZE;
  801322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801326:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  80132c:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801332:	85 c0                	test   %eax,%eax
  801334:	0f 48 c2             	cmovs  %edx,%eax
  801337:	c1 f8 0c             	sar    $0xc,%eax
  80133a:	89 45 f4             	mov    %eax,-0xc(%rbp)
                if (filebno > nblock) {
  80133d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801340:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801343:	76 0a                	jbe    80134f <file_block_walk+0x6e>
                        return -E_NOT_FOUND;
  801345:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  80134a:	e9 f2 00 00 00       	jmpq   801441 <file_block_walk+0x160>
                }
                if(filebno >= 0 && filebno < 10)
  80134f:	83 7d e4 09          	cmpl   $0x9,-0x1c(%rbp)
  801353:	77 26                	ja     80137b <file_block_walk+0x9a>
                {
                        *ppdiskbno = (uint32_t *)(f->f_direct + filebno);
  801355:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801358:	48 83 c0 20          	add    $0x20,%rax
  80135c:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  801363:	00 
  801364:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801368:	48 01 d0             	add    %rdx,%rax
  80136b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80136f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801373:	48 89 10             	mov    %rdx,(%rax)
  801376:	e9 c1 00 00 00       	jmpq   80143c <file_block_walk+0x15b>
                }
                else if(filebno >= 10)
  80137b:	83 7d e4 09          	cmpl   $0x9,-0x1c(%rbp)
  80137f:	0f 86 b7 00 00 00    	jbe    80143c <file_block_walk+0x15b>
                {
                        filebno = filebno - 10;
  801385:	83 6d e4 0a          	subl   $0xa,-0x1c(%rbp)

                        if(f->f_indirect != 0)
  801389:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80138d:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801393:	85 c0                	test   %eax,%eax
  801395:	74 3a                	je     8013d1 <file_block_walk+0xf0>
                        {

                                indirect = (uint32_t*)diskaddr(f->f_indirect);
  801397:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80139b:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  8013a1:	89 c0                	mov    %eax,%eax
  8013a3:	48 89 c7             	mov    %rax,%rdi
  8013a6:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8013ad:	00 00 00 
  8013b0:	ff d0                	callq  *%rax
  8013b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
                                *ppdiskbno = indirect + filebno;
  8013b6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013b9:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  8013c0:	00 
  8013c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c5:	48 01 c2             	add    %rax,%rdx
  8013c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013cc:	48 89 10             	mov    %rdx,(%rax)
  8013cf:	eb 6b                	jmp    80143c <file_block_walk+0x15b>
                        }
                        else if(f->f_indirect == 0 && alloc)
  8013d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d5:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  8013db:	85 c0                	test   %eax,%eax
  8013dd:	75 56                	jne    801435 <file_block_walk+0x154>
  8013df:	80 7d e0 00          	cmpb   $0x0,-0x20(%rbp)
  8013e3:	74 50                	je     801435 <file_block_walk+0x154>
                        {
                                freeBlock = alloc_block();
  8013e5:	48 b8 16 10 80 00 00 	movabs $0x801016,%rax
  8013ec:	00 00 00 
  8013ef:	ff d0                	callq  *%rax
  8013f1:	89 45 f0             	mov    %eax,-0x10(%rbp)

                                if(freeBlock == -E_NO_DISK)
  8013f4:	83 7d f0 f6          	cmpl   $0xfffffff6,-0x10(%rbp)
  8013f8:	75 07                	jne    801401 <file_block_walk+0x120>
                                {
                                        //f->f_indirect = freeBlock;
                                        return -E_NO_DISK;
  8013fa:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8013ff:	eb 40                	jmp    801441 <file_block_walk+0x160>
                                }
                                f->f_indirect = freeBlock;
  801401:	8b 55 f0             	mov    -0x10(%rbp),%edx
  801404:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801408:	89 90 b0 00 00 00    	mov    %edx,0xb0(%rax)

                                *ppdiskbno = (uint32_t*)diskaddr(freeBlock) + filebno;
  80140e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801411:	48 98                	cltq   
  801413:	48 89 c7             	mov    %rax,%rdi
  801416:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  80141d:	00 00 00 
  801420:	ff d0                	callq  *%rax
  801422:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801425:	48 c1 e2 02          	shl    $0x2,%rdx
  801429:	48 01 c2             	add    %rax,%rdx
  80142c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801430:	48 89 10             	mov    %rdx,(%rax)
  801433:	eb 07                	jmp    80143c <file_block_walk+0x15b>
                        }
                        else
                        {
                                return -E_NOT_FOUND;
  801435:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  80143a:	eb 05                	jmp    801441 <file_block_walk+0x160>
                        }
                }
                return 0;
  80143c:	b8 00 00 00 00       	mov    $0x0,%eax
                //panic("file_block_walk not implemented");
        }
  801441:	c9                   	leaveq 
  801442:	c3                   	retq   

0000000000801443 <file_get_block>:
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_INVAL if filebno is out of range.
//
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  801443:	55                   	push   %rbp
  801444:	48 89 e5             	mov    %rsp,%rbp
  801447:	48 83 ec 30          	sub    $0x30,%rsp
  80144b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80144f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801452:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
        // LAB 5: Your code here.
        //panic("file_get_block not implemented");
        //cprintf("called from file_get_walk\n");
        if(filebno >= NDIRECT + NINDIRECT || !f || !blk)
  801456:	81 7d e4 09 04 00 00 	cmpl   $0x409,-0x1c(%rbp)
  80145d:	77 0e                	ja     80146d <file_get_block+0x2a>
  80145f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801464:	74 07                	je     80146d <file_get_block+0x2a>
  801466:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80146b:	75 0a                	jne    801477 <file_get_block+0x34>
        {
                return -E_INVAL;
  80146d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801472:	e9 9e 00 00 00       	jmpq   801515 <file_get_block+0xd2>
        }
        uint32_t * pdiskbno;
        if(file_block_walk(f, filebno, &pdiskbno, true) < 0)
  801477:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80147b:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80147e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801482:	b9 01 00 00 00       	mov    $0x1,%ecx
  801487:	48 89 c7             	mov    %rax,%rdi
  80148a:	48 b8 e1 12 80 00 00 	movabs $0x8012e1,%rax
  801491:	00 00 00 
  801494:	ff d0                	callq  *%rax
  801496:	85 c0                	test   %eax,%eax
  801498:	79 07                	jns    8014a1 <file_get_block+0x5e>
        {
                return -E_NO_DISK;
  80149a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80149f:	eb 74                	jmp    801515 <file_get_block+0xd2>
        }
        if(*pdiskbno != 0)
  8014a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a5:	8b 00                	mov    (%rax),%eax
  8014a7:	85 c0                	test   %eax,%eax
  8014a9:	74 20                	je     8014cb <file_get_block+0x88>
        {
                *blk = (char*)diskaddr(*pdiskbno);
  8014ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014af:	8b 00                	mov    (%rax),%eax
  8014b1:	89 c0                	mov    %eax,%eax
  8014b3:	48 89 c7             	mov    %rax,%rdi
  8014b6:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8014bd:	00 00 00 
  8014c0:	ff d0                	callq  *%rax
  8014c2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014c6:	48 89 02             	mov    %rax,(%rdx)
  8014c9:	eb 45                	jmp    801510 <file_get_block+0xcd>
        }
        else
        {
                uint32_t freeBlock = -1;
  8014cb:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
                freeBlock = alloc_block();
  8014d2:	48 b8 16 10 80 00 00 	movabs $0x801016,%rax
  8014d9:	00 00 00 
  8014dc:	ff d0                	callq  *%rax
  8014de:	89 45 fc             	mov    %eax,-0x4(%rbp)

                if(freeBlock == -E_NO_DISK)
  8014e1:	83 7d fc f6          	cmpl   $0xfffffff6,-0x4(%rbp)
  8014e5:	75 07                	jne    8014ee <file_get_block+0xab>
                {
                        //f->f_indirect = freeBlock;
                        //fprintf(1,"file get blockreturning from here with -E_NO_DISK");
                        return -E_NO_DISK;
  8014e7:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8014ec:	eb 27                	jmp    801515 <file_get_block+0xd2>
                }

                //fprintf(1,"file get blockcalled from file_block_walk2\n");
                *pdiskbno = freeBlock;
  8014ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8014f5:	89 10                	mov    %edx,(%rax)
                *blk = (char*)diskaddr(freeBlock);
  8014f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014fa:	48 89 c7             	mov    %rax,%rdi
  8014fd:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801504:	00 00 00 
  801507:	ff d0                	callq  *%rax
  801509:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80150d:	48 89 02             	mov    %rax,(%rdx)
        }
        return 0;
  801510:	b8 00 00 00 00       	mov    $0x0,%eax
        //panic("file_block_walk not implemented");
}
  801515:	c9                   	leaveq 
  801516:	c3                   	retq   

0000000000801517 <dir_lookup>:
//
// Returns 0 and sets *file on success, < 0 on error.  Errors are:
//	-E_NOT_FOUND if the file is not found
static int
dir_lookup(struct File *dir, const char *name, struct File **file)
{
  801517:	55                   	push   %rbp
  801518:	48 89 e5             	mov    %rsp,%rbp
  80151b:	48 83 ec 40          	sub    $0x40,%rsp
  80151f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801523:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801527:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  80152b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152f:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801535:	25 ff 0f 00 00       	and    $0xfff,%eax
  80153a:	85 c0                	test   %eax,%eax
  80153c:	74 35                	je     801573 <dir_lookup+0x5c>
  80153e:	48 b9 0b 76 80 00 00 	movabs $0x80760b,%rcx
  801545:	00 00 00 
  801548:	48 ba c2 75 80 00 00 	movabs $0x8075c2,%rdx
  80154f:	00 00 00 
  801552:	be 0b 01 00 00       	mov    $0x10b,%esi
  801557:	48 bf 2d 75 80 00 00 	movabs $0x80752d,%rdi
  80155e:	00 00 00 
  801561:	b8 00 00 00 00       	mov    $0x0,%eax
  801566:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  80156d:	00 00 00 
  801570:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  801573:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801577:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  80157d:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801583:	85 c0                	test   %eax,%eax
  801585:	0f 48 c2             	cmovs  %edx,%eax
  801588:	c1 f8 0c             	sar    $0xc,%eax
  80158b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  80158e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801595:	e9 93 00 00 00       	jmpq   80162d <dir_lookup+0x116>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  80159a:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80159e:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8015a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a5:	89 ce                	mov    %ecx,%esi
  8015a7:	48 89 c7             	mov    %rax,%rdi
  8015aa:	48 b8 43 14 80 00 00 	movabs $0x801443,%rax
  8015b1:	00 00 00 
  8015b4:	ff d0                	callq  *%rax
  8015b6:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8015b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8015bd:	79 05                	jns    8015c4 <dir_lookup+0xad>
			return r;
  8015bf:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8015c2:	eb 7a                	jmp    80163e <dir_lookup+0x127>
		f = (struct File*) blk;
  8015c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015c8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  8015cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8015d3:	eb 4e                	jmp    801623 <dir_lookup+0x10c>
			if (strcmp(f[j].f_name, name) == 0) {
  8015d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8015d8:	48 c1 e0 08          	shl    $0x8,%rax
  8015dc:	48 89 c2             	mov    %rax,%rdx
  8015df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e3:	48 01 d0             	add    %rdx,%rax
  8015e6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015ea:	48 89 d6             	mov    %rdx,%rsi
  8015ed:	48 89 c7             	mov    %rax,%rdi
  8015f0:	48 b8 36 43 80 00 00 	movabs $0x804336,%rax
  8015f7:	00 00 00 
  8015fa:	ff d0                	callq  *%rax
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	75 1f                	jne    80161f <dir_lookup+0x108>
				*file = &f[j];
  801600:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801603:	48 c1 e0 08          	shl    $0x8,%rax
  801607:	48 89 c2             	mov    %rax,%rdx
  80160a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80160e:	48 01 c2             	add    %rax,%rdx
  801611:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801615:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  801618:	b8 00 00 00 00       	mov    $0x0,%eax
  80161d:	eb 1f                	jmp    80163e <dir_lookup+0x127>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  80161f:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  801623:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  801627:	76 ac                	jbe    8015d5 <dir_lookup+0xbe>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  801629:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80162d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801630:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801633:	0f 82 61 ff ff ff    	jb     80159a <dir_lookup+0x83>
			if (strcmp(f[j].f_name, name) == 0) {
				*file = &f[j];
				return 0;
			}
	}
	return -E_NOT_FOUND;
  801639:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
}
  80163e:	c9                   	leaveq 
  80163f:	c3                   	retq   

0000000000801640 <dir_alloc_file>:

// Set *file to point at a free File structure in dir.  The caller is
// responsible for filling in the File fields.
static int
dir_alloc_file(struct File *dir, struct File **file)
{
  801640:	55                   	push   %rbp
  801641:	48 89 e5             	mov    %rsp,%rbp
  801644:	48 83 ec 30          	sub    $0x30,%rsp
  801648:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80164c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  801650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801654:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  80165a:	25 ff 0f 00 00       	and    $0xfff,%eax
  80165f:	85 c0                	test   %eax,%eax
  801661:	74 35                	je     801698 <dir_alloc_file+0x58>
  801663:	48 b9 0b 76 80 00 00 	movabs $0x80760b,%rcx
  80166a:	00 00 00 
  80166d:	48 ba c2 75 80 00 00 	movabs $0x8075c2,%rdx
  801674:	00 00 00 
  801677:	be 24 01 00 00       	mov    $0x124,%esi
  80167c:	48 bf 2d 75 80 00 00 	movabs $0x80752d,%rdi
  801683:	00 00 00 
  801686:	b8 00 00 00 00       	mov    $0x0,%eax
  80168b:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  801692:	00 00 00 
  801695:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  801698:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169c:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8016a2:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  8016a8:	85 c0                	test   %eax,%eax
  8016aa:	0f 48 c2             	cmovs  %edx,%eax
  8016ad:	c1 f8 0c             	sar    $0xc,%eax
  8016b0:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  8016b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8016ba:	e9 83 00 00 00       	jmpq   801742 <dir_alloc_file+0x102>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  8016bf:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  8016c3:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8016c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ca:	89 ce                	mov    %ecx,%esi
  8016cc:	48 89 c7             	mov    %rax,%rdi
  8016cf:	48 b8 43 14 80 00 00 	movabs $0x801443,%rax
  8016d6:	00 00 00 
  8016d9:	ff d0                	callq  *%rax
  8016db:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8016de:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8016e2:	79 08                	jns    8016ec <dir_alloc_file+0xac>
			return r;
  8016e4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8016e7:	e9 be 00 00 00       	jmpq   8017aa <dir_alloc_file+0x16a>
		f = (struct File*) blk;
  8016ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016f0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  8016f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8016fb:	eb 3b                	jmp    801738 <dir_alloc_file+0xf8>
			if (f[j].f_name[0] == '\0') {
  8016fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801700:	48 c1 e0 08          	shl    $0x8,%rax
  801704:	48 89 c2             	mov    %rax,%rdx
  801707:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80170b:	48 01 d0             	add    %rdx,%rax
  80170e:	0f b6 00             	movzbl (%rax),%eax
  801711:	84 c0                	test   %al,%al
  801713:	75 1f                	jne    801734 <dir_alloc_file+0xf4>
				*file = &f[j];
  801715:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801718:	48 c1 e0 08          	shl    $0x8,%rax
  80171c:	48 89 c2             	mov    %rax,%rdx
  80171f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801723:	48 01 c2             	add    %rax,%rdx
  801726:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80172a:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  80172d:	b8 00 00 00 00       	mov    $0x0,%eax
  801732:	eb 76                	jmp    8017aa <dir_alloc_file+0x16a>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  801734:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  801738:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  80173c:	76 bf                	jbe    8016fd <dir_alloc_file+0xbd>
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  80173e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801742:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801745:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801748:	0f 82 71 ff ff ff    	jb     8016bf <dir_alloc_file+0x7f>
			if (f[j].f_name[0] == '\0') {
				*file = &f[j];
				return 0;
			}
	}
	dir->f_size += BLKSIZE;
  80174e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801752:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801758:	8d 90 00 10 00 00    	lea    0x1000(%rax),%edx
  80175e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801762:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	if ((r = file_get_block(dir, i, &blk)) < 0)
  801768:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80176c:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80176f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801773:	89 ce                	mov    %ecx,%esi
  801775:	48 89 c7             	mov    %rax,%rdi
  801778:	48 b8 43 14 80 00 00 	movabs $0x801443,%rax
  80177f:	00 00 00 
  801782:	ff d0                	callq  *%rax
  801784:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801787:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80178b:	79 05                	jns    801792 <dir_alloc_file+0x152>
		return r;
  80178d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801790:	eb 18                	jmp    8017aa <dir_alloc_file+0x16a>
	f = (struct File*) blk;
  801792:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801796:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	*file = &f[0];
  80179a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80179e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017a2:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8017a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017aa:	c9                   	leaveq 
  8017ab:	c3                   	retq   

00000000008017ac <skip_slash>:

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
  8017ac:	55                   	push   %rbp
  8017ad:	48 89 e5             	mov    %rsp,%rbp
  8017b0:	48 83 ec 08          	sub    $0x8,%rsp
  8017b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	while (*p == '/')
  8017b8:	eb 05                	jmp    8017bf <skip_slash+0x13>
		p++;
  8017ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  8017bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017c3:	0f b6 00             	movzbl (%rax),%eax
  8017c6:	3c 2f                	cmp    $0x2f,%al
  8017c8:	74 f0                	je     8017ba <skip_slash+0xe>
		p++;
	return p;
  8017ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017ce:	c9                   	leaveq 
  8017cf:	c3                   	retq   

00000000008017d0 <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  8017d0:	55                   	push   %rbp
  8017d1:	48 89 e5             	mov    %rsp,%rbp
  8017d4:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  8017db:	48 89 bd 48 ff ff ff 	mov    %rdi,-0xb8(%rbp)
  8017e2:	48 89 b5 40 ff ff ff 	mov    %rsi,-0xc0(%rbp)
  8017e9:	48 89 95 38 ff ff ff 	mov    %rdx,-0xc8(%rbp)
  8017f0:	48 89 8d 30 ff ff ff 	mov    %rcx,-0xd0(%rbp)
	struct File *dir, *f;
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
  8017f7:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8017fe:	48 89 c7             	mov    %rax,%rdi
  801801:	48 b8 ac 17 80 00 00 	movabs $0x8017ac,%rax
  801808:	00 00 00 
  80180b:	ff d0                	callq  *%rax
  80180d:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	f = &super->s_root;
  801814:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  80181b:	00 00 00 
  80181e:	48 8b 00             	mov    (%rax),%rax
  801821:	48 83 c0 08          	add    $0x8,%rax
  801825:	48 89 85 58 ff ff ff 	mov    %rax,-0xa8(%rbp)
	dir = 0;
  80182c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801833:	00 
	name[0] = 0;
  801834:	c6 85 60 ff ff ff 00 	movb   $0x0,-0xa0(%rbp)

	if (pdir)
  80183b:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  801842:	00 
  801843:	74 0e                	je     801853 <walk_path+0x83>
		*pdir = 0;
  801845:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  80184c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*pf = 0;
  801853:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  80185a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	while (*path != '\0') {
  801861:	e9 73 01 00 00       	jmpq   8019d9 <walk_path+0x209>
		dir = f;
  801866:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80186d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		p = path;
  801871:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801878:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		while (*path != '/' && *path != '\0')
  80187c:	eb 08                	jmp    801886 <walk_path+0xb6>
			path++;
  80187e:	48 83 85 48 ff ff ff 	addq   $0x1,-0xb8(%rbp)
  801885:	01 
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  801886:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80188d:	0f b6 00             	movzbl (%rax),%eax
  801890:	3c 2f                	cmp    $0x2f,%al
  801892:	74 0e                	je     8018a2 <walk_path+0xd2>
  801894:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80189b:	0f b6 00             	movzbl (%rax),%eax
  80189e:	84 c0                	test   %al,%al
  8018a0:	75 dc                	jne    80187e <walk_path+0xae>
			path++;
		if (path - p >= MAXNAMELEN)
  8018a2:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  8018a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ad:	48 29 c2             	sub    %rax,%rdx
  8018b0:	48 89 d0             	mov    %rdx,%rax
  8018b3:	48 83 f8 7f          	cmp    $0x7f,%rax
  8018b7:	7e 0a                	jle    8018c3 <walk_path+0xf3>
			return -E_BAD_PATH;
  8018b9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8018be:	e9 56 01 00 00       	jmpq   801a19 <walk_path+0x249>
		memmove(name, p, path - p);
  8018c3:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  8018ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ce:	48 29 c2             	sub    %rax,%rdx
  8018d1:	48 89 d0             	mov    %rdx,%rax
  8018d4:	48 89 c2             	mov    %rax,%rdx
  8018d7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8018db:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
  8018e2:	48 89 ce             	mov    %rcx,%rsi
  8018e5:	48 89 c7             	mov    %rax,%rdi
  8018e8:	48 b8 f8 44 80 00 00 	movabs $0x8044f8,%rax
  8018ef:	00 00 00 
  8018f2:	ff d0                	callq  *%rax
		name[path - p] = '\0';
  8018f4:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  8018fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ff:	48 29 c2             	sub    %rax,%rdx
  801902:	48 89 d0             	mov    %rdx,%rax
  801905:	c6 84 05 60 ff ff ff 	movb   $0x0,-0xa0(%rbp,%rax,1)
  80190c:	00 
		path = skip_slash(path);
  80190d:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801914:	48 89 c7             	mov    %rax,%rdi
  801917:	48 b8 ac 17 80 00 00 	movabs $0x8017ac,%rax
  80191e:	00 00 00 
  801921:	ff d0                	callq  *%rax
  801923:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)

		if (dir->f_type != FTYPE_DIR)
  80192a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80192e:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801934:	83 f8 01             	cmp    $0x1,%eax
  801937:	74 0a                	je     801943 <walk_path+0x173>
			return -E_NOT_FOUND;
  801939:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  80193e:	e9 d6 00 00 00       	jmpq   801a19 <walk_path+0x249>

		if ((r = dir_lookup(dir, name, &f)) < 0) {
  801943:	48 8d 95 58 ff ff ff 	lea    -0xa8(%rbp),%rdx
  80194a:	48 8d 8d 60 ff ff ff 	lea    -0xa0(%rbp),%rcx
  801951:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801955:	48 89 ce             	mov    %rcx,%rsi
  801958:	48 89 c7             	mov    %rax,%rdi
  80195b:	48 b8 17 15 80 00 00 	movabs $0x801517,%rax
  801962:	00 00 00 
  801965:	ff d0                	callq  *%rax
  801967:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80196a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80196e:	79 69                	jns    8019d9 <walk_path+0x209>
			if (r == -E_NOT_FOUND && *path == '\0') {
  801970:	83 7d ec f4          	cmpl   $0xfffffff4,-0x14(%rbp)
  801974:	75 5e                	jne    8019d4 <walk_path+0x204>
  801976:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80197d:	0f b6 00             	movzbl (%rax),%eax
  801980:	84 c0                	test   %al,%al
  801982:	75 50                	jne    8019d4 <walk_path+0x204>
				if (pdir)
  801984:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  80198b:	00 
  80198c:	74 0e                	je     80199c <walk_path+0x1cc>
					*pdir = dir;
  80198e:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  801995:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801999:	48 89 10             	mov    %rdx,(%rax)
				if (lastelem)
  80199c:	48 83 bd 30 ff ff ff 	cmpq   $0x0,-0xd0(%rbp)
  8019a3:	00 
  8019a4:	74 20                	je     8019c6 <walk_path+0x1f6>
					strcpy(lastelem, name);
  8019a6:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  8019ad:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
  8019b4:	48 89 d6             	mov    %rdx,%rsi
  8019b7:	48 89 c7             	mov    %rax,%rdi
  8019ba:	48 b8 d4 41 80 00 00 	movabs $0x8041d4,%rax
  8019c1:	00 00 00 
  8019c4:	ff d0                	callq  *%rax
				*pf = 0;
  8019c6:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  8019cd:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
			}
			return r;
  8019d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019d7:	eb 40                	jmp    801a19 <walk_path+0x249>
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  8019d9:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8019e0:	0f b6 00             	movzbl (%rax),%eax
  8019e3:	84 c0                	test   %al,%al
  8019e5:	0f 85 7b fe ff ff    	jne    801866 <walk_path+0x96>
			}
			return r;
		}
	}

	if (pdir)
  8019eb:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  8019f2:	00 
  8019f3:	74 0e                	je     801a03 <walk_path+0x233>
		*pdir = dir;
  8019f5:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  8019fc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a00:	48 89 10             	mov    %rdx,(%rax)
	*pf = f;
  801a03:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  801a0a:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  801a11:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801a14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a19:	c9                   	leaveq 
  801a1a:	c3                   	retq   

0000000000801a1b <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  801a1b:	55                   	push   %rbp
  801a1c:	48 89 e5             	mov    %rsp,%rbp
  801a1f:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801a26:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  801a2d:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  801a34:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
  801a3b:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  801a42:	48 8d b5 68 ff ff ff 	lea    -0x98(%rbp),%rsi
  801a49:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801a50:	48 89 c7             	mov    %rax,%rdi
  801a53:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  801a5a:	00 00 00 
  801a5d:	ff d0                	callq  *%rax
  801a5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a66:	75 0a                	jne    801a72 <file_create+0x57>
		return -E_FILE_EXISTS;
  801a68:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801a6d:	e9 91 00 00 00       	jmpq   801b03 <file_create+0xe8>
	if (r != -E_NOT_FOUND || dir == 0)
  801a72:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  801a76:	75 0c                	jne    801a84 <file_create+0x69>
  801a78:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  801a7f:	48 85 c0             	test   %rax,%rax
  801a82:	75 05                	jne    801a89 <file_create+0x6e>
		return r;
  801a84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a87:	eb 7a                	jmp    801b03 <file_create+0xe8>
	if ((r = dir_alloc_file(dir, &f)) < 0)
  801a89:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  801a90:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  801a97:	48 89 d6             	mov    %rdx,%rsi
  801a9a:	48 89 c7             	mov    %rax,%rdi
  801a9d:	48 b8 40 16 80 00 00 	movabs $0x801640,%rax
  801aa4:	00 00 00 
  801aa7:	ff d0                	callq  *%rax
  801aa9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801aac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ab0:	79 05                	jns    801ab7 <file_create+0x9c>
		return r;
  801ab2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab5:	eb 4c                	jmp    801b03 <file_create+0xe8>
	strcpy(f->f_name, name);
  801ab7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801abe:	48 8d 95 70 ff ff ff 	lea    -0x90(%rbp),%rdx
  801ac5:	48 89 d6             	mov    %rdx,%rsi
  801ac8:	48 89 c7             	mov    %rax,%rdi
  801acb:	48 b8 d4 41 80 00 00 	movabs $0x8041d4,%rax
  801ad2:	00 00 00 
  801ad5:	ff d0                	callq  *%rax
	*pf = f;
  801ad7:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  801ade:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  801ae5:	48 89 10             	mov    %rdx,(%rax)
	file_flush(dir);
  801ae8:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  801aef:	48 89 c7             	mov    %rax,%rdi
  801af2:	48 b8 91 1f 80 00 00 	movabs $0x801f91,%rax
  801af9:	00 00 00 
  801afc:	ff d0                	callq  *%rax
	return 0;
  801afe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b03:	c9                   	leaveq 
  801b04:	c3                   	retq   

0000000000801b05 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  801b05:	55                   	push   %rbp
  801b06:	48 89 e5             	mov    %rsp,%rbp
  801b09:	48 83 ec 10          	sub    $0x10,%rsp
  801b0d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return walk_path(path, 0, pf, 0);
  801b15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b1d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b22:	be 00 00 00 00       	mov    $0x0,%esi
  801b27:	48 89 c7             	mov    %rax,%rdi
  801b2a:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  801b31:	00 00 00 
  801b34:	ff d0                	callq  *%rax
}
  801b36:	c9                   	leaveq 
  801b37:	c3                   	retq   

0000000000801b38 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  801b38:	55                   	push   %rbp
  801b39:	48 89 e5             	mov    %rsp,%rbp
  801b3c:	48 83 ec 60          	sub    $0x60,%rsp
  801b40:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  801b44:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  801b48:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  801b4c:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  801b4f:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801b53:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801b59:	3b 45 a4             	cmp    -0x5c(%rbp),%eax
  801b5c:	7f 0a                	jg     801b68 <file_read+0x30>
		return 0;
  801b5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b63:	e9 24 01 00 00       	jmpq   801c8c <file_read+0x154>

	count = MIN(count, f->f_size - offset);
  801b68:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b6c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801b70:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801b74:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801b7a:	2b 45 a4             	sub    -0x5c(%rbp),%eax
  801b7d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b80:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b83:	48 63 d0             	movslq %eax,%rdx
  801b86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b8a:	48 39 c2             	cmp    %rax,%rdx
  801b8d:	48 0f 46 c2          	cmovbe %rdx,%rax
  801b91:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	for (pos = offset; pos < offset + count; ) {
  801b95:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  801b98:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b9b:	e9 cd 00 00 00       	jmpq   801c6d <file_read+0x135>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801ba0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ba3:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801ba9:	85 c0                	test   %eax,%eax
  801bab:	0f 48 c2             	cmovs  %edx,%eax
  801bae:	c1 f8 0c             	sar    $0xc,%eax
  801bb1:	89 c1                	mov    %eax,%ecx
  801bb3:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  801bb7:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801bbb:	89 ce                	mov    %ecx,%esi
  801bbd:	48 89 c7             	mov    %rax,%rdi
  801bc0:	48 b8 43 14 80 00 00 	movabs $0x801443,%rax
  801bc7:	00 00 00 
  801bca:	ff d0                	callq  *%rax
  801bcc:	89 45 e8             	mov    %eax,-0x18(%rbp)
  801bcf:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801bd3:	79 08                	jns    801bdd <file_read+0xa5>
			return r;
  801bd5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801bd8:	e9 af 00 00 00       	jmpq   801c8c <file_read+0x154>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801bdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801be0:	99                   	cltd   
  801be1:	c1 ea 14             	shr    $0x14,%edx
  801be4:	01 d0                	add    %edx,%eax
  801be6:	25 ff 0f 00 00       	and    $0xfff,%eax
  801beb:	29 d0                	sub    %edx,%eax
  801bed:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bf2:	29 c2                	sub    %eax,%edx
  801bf4:	89 d0                	mov    %edx,%eax
  801bf6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  801bf9:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  801bfc:	48 63 d0             	movslq %eax,%rdx
  801bff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c03:	48 01 c2             	add    %rax,%rdx
  801c06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c09:	48 98                	cltq   
  801c0b:	48 29 c2             	sub    %rax,%rdx
  801c0e:	48 89 d0             	mov    %rdx,%rax
  801c11:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801c15:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c18:	48 63 d0             	movslq %eax,%rdx
  801c1b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c1f:	48 39 c2             	cmp    %rax,%rdx
  801c22:	48 0f 46 c2          	cmovbe %rdx,%rax
  801c26:	89 45 d4             	mov    %eax,-0x2c(%rbp)
		memmove(buf, blk + pos % BLKSIZE, bn);
  801c29:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801c2c:	48 63 c8             	movslq %eax,%rcx
  801c2f:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  801c33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c36:	99                   	cltd   
  801c37:	c1 ea 14             	shr    $0x14,%edx
  801c3a:	01 d0                	add    %edx,%eax
  801c3c:	25 ff 0f 00 00       	and    $0xfff,%eax
  801c41:	29 d0                	sub    %edx,%eax
  801c43:	48 98                	cltq   
  801c45:	48 01 c6             	add    %rax,%rsi
  801c48:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801c4c:	48 89 ca             	mov    %rcx,%rdx
  801c4f:	48 89 c7             	mov    %rax,%rdi
  801c52:	48 b8 f8 44 80 00 00 	movabs $0x8044f8,%rax
  801c59:	00 00 00 
  801c5c:	ff d0                	callq  *%rax
		pos += bn;
  801c5e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801c61:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  801c64:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801c67:	48 98                	cltq   
  801c69:	48 01 45 b0          	add    %rax,-0x50(%rbp)
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
  801c6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c70:	48 98                	cltq   
  801c72:	8b 55 a4             	mov    -0x5c(%rbp),%edx
  801c75:	48 63 ca             	movslq %edx,%rcx
  801c78:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801c7c:	48 01 ca             	add    %rcx,%rdx
  801c7f:	48 39 d0             	cmp    %rdx,%rax
  801c82:	0f 82 18 ff ff ff    	jb     801ba0 <file_read+0x68>
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801c88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
}
  801c8c:	c9                   	leaveq 
  801c8d:	c3                   	retq   

0000000000801c8e <file_write>:
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  801c8e:	55                   	push   %rbp
  801c8f:	48 89 e5             	mov    %rsp,%rbp
  801c92:	48 83 ec 50          	sub    $0x50,%rsp
  801c96:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801c9a:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  801c9e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801ca2:	89 4d b4             	mov    %ecx,-0x4c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
  801ca5:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801ca8:	48 63 d0             	movslq %eax,%rdx
  801cab:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801caf:	48 01 c2             	add    %rax,%rdx
  801cb2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801cb6:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801cbc:	48 98                	cltq   
  801cbe:	48 39 c2             	cmp    %rax,%rdx
  801cc1:	76 33                	jbe    801cf6 <file_write+0x68>
		if ((r = file_set_size(f, offset + count)) < 0)
  801cc3:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801cc7:	89 c2                	mov    %eax,%edx
  801cc9:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801ccc:	01 d0                	add    %edx,%eax
  801cce:	89 c2                	mov    %eax,%edx
  801cd0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801cd4:	89 d6                	mov    %edx,%esi
  801cd6:	48 89 c7             	mov    %rax,%rdi
  801cd9:	48 b8 34 1f 80 00 00 	movabs $0x801f34,%rax
  801ce0:	00 00 00 
  801ce3:	ff d0                	callq  *%rax
  801ce5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801ce8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801cec:	79 08                	jns    801cf6 <file_write+0x68>
			return r;
  801cee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cf1:	e9 f8 00 00 00       	jmpq   801dee <file_write+0x160>

	for (pos = offset; pos < offset + count; ) {
  801cf6:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801cf9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cfc:	e9 ce 00 00 00       	jmpq   801dcf <file_write+0x141>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801d01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d04:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	0f 48 c2             	cmovs  %edx,%eax
  801d0f:	c1 f8 0c             	sar    $0xc,%eax
  801d12:	89 c1                	mov    %eax,%ecx
  801d14:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801d18:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801d1c:	89 ce                	mov    %ecx,%esi
  801d1e:	48 89 c7             	mov    %rax,%rdi
  801d21:	48 b8 43 14 80 00 00 	movabs $0x801443,%rax
  801d28:	00 00 00 
  801d2b:	ff d0                	callq  *%rax
  801d2d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801d30:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801d34:	79 08                	jns    801d3e <file_write+0xb0>
			return r;
  801d36:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d39:	e9 b0 00 00 00       	jmpq   801dee <file_write+0x160>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801d3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d41:	99                   	cltd   
  801d42:	c1 ea 14             	shr    $0x14,%edx
  801d45:	01 d0                	add    %edx,%eax
  801d47:	25 ff 0f 00 00       	and    $0xfff,%eax
  801d4c:	29 d0                	sub    %edx,%eax
  801d4e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d53:	29 c2                	sub    %eax,%edx
  801d55:	89 d0                	mov    %edx,%eax
  801d57:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801d5a:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801d5d:	48 63 d0             	movslq %eax,%rdx
  801d60:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801d64:	48 01 c2             	add    %rax,%rdx
  801d67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d6a:	48 98                	cltq   
  801d6c:	48 29 c2             	sub    %rax,%rdx
  801d6f:	48 89 d0             	mov    %rdx,%rax
  801d72:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801d76:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d79:	48 63 d0             	movslq %eax,%rdx
  801d7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d80:	48 39 c2             	cmp    %rax,%rdx
  801d83:	48 0f 46 c2          	cmovbe %rdx,%rax
  801d87:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		memmove(blk + pos % BLKSIZE, buf, bn);
  801d8a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d8d:	48 63 c8             	movslq %eax,%rcx
  801d90:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801d94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d97:	99                   	cltd   
  801d98:	c1 ea 14             	shr    $0x14,%edx
  801d9b:	01 d0                	add    %edx,%eax
  801d9d:	25 ff 0f 00 00       	and    $0xfff,%eax
  801da2:	29 d0                	sub    %edx,%eax
  801da4:	48 98                	cltq   
  801da6:	48 8d 3c 06          	lea    (%rsi,%rax,1),%rdi
  801daa:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801dae:	48 89 ca             	mov    %rcx,%rdx
  801db1:	48 89 c6             	mov    %rax,%rsi
  801db4:	48 b8 f8 44 80 00 00 	movabs $0x8044f8,%rax
  801dbb:	00 00 00 
  801dbe:	ff d0                	callq  *%rax
		pos += bn;
  801dc0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801dc3:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  801dc6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801dc9:	48 98                	cltq   
  801dcb:	48 01 45 c0          	add    %rax,-0x40(%rbp)
	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
  801dcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dd2:	48 98                	cltq   
  801dd4:	8b 55 b4             	mov    -0x4c(%rbp),%edx
  801dd7:	48 63 ca             	movslq %edx,%rcx
  801dda:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801dde:	48 01 ca             	add    %rcx,%rdx
  801de1:	48 39 d0             	cmp    %rdx,%rax
  801de4:	0f 82 17 ff ff ff    	jb     801d01 <file_write+0x73>
		memmove(blk + pos % BLKSIZE, buf, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801dea:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
}
  801dee:	c9                   	leaveq 
  801def:	c3                   	retq   

0000000000801df0 <file_free_block>:

// Remove a block from file f.  If it's not there, just silently succeed.
// Returns 0 on success, < 0 on error.
static int
file_free_block(struct File *f, uint32_t filebno)
{
  801df0:	55                   	push   %rbp
  801df1:	48 89 e5             	mov    %rsp,%rbp
  801df4:	48 83 ec 20          	sub    $0x20,%rsp
  801df8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801dfc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  801dff:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e03:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  801e06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e0a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e0f:	48 89 c7             	mov    %rax,%rdi
  801e12:	48 b8 e1 12 80 00 00 	movabs $0x8012e1,%rax
  801e19:	00 00 00 
  801e1c:	ff d0                	callq  *%rax
  801e1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e25:	79 05                	jns    801e2c <file_free_block+0x3c>
		return r;
  801e27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e2a:	eb 2d                	jmp    801e59 <file_free_block+0x69>
	if (*ptr) {
  801e2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e30:	8b 00                	mov    (%rax),%eax
  801e32:	85 c0                	test   %eax,%eax
  801e34:	74 1e                	je     801e54 <file_free_block+0x64>
		free_block(*ptr);
  801e36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e3a:	8b 00                	mov    (%rax),%eax
  801e3c:	89 c7                	mov    %eax,%edi
  801e3e:	48 b8 8f 0f 80 00 00 	movabs $0x800f8f,%rax
  801e45:	00 00 00 
  801e48:	ff d0                	callq  *%rax
		*ptr = 0;
  801e4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e4e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	return 0;
  801e54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e59:	c9                   	leaveq 
  801e5a:	c3                   	retq   

0000000000801e5b <file_truncate_blocks>:
// (Remember to clear the f->f_indirect pointer so you'll know
// whether it's valid!)
// Do not change f->f_size.
static void
file_truncate_blocks(struct File *f, off_t newsize)
{
  801e5b:	55                   	push   %rbp
  801e5c:	48 89 e5             	mov    %rsp,%rbp
  801e5f:	48 83 ec 20          	sub    $0x20,%rsp
  801e63:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801e67:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  801e6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e6e:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801e74:	05 ff 0f 00 00       	add    $0xfff,%eax
  801e79:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801e7f:	85 c0                	test   %eax,%eax
  801e81:	0f 48 c2             	cmovs  %edx,%eax
  801e84:	c1 f8 0c             	sar    $0xc,%eax
  801e87:	89 45 f8             	mov    %eax,-0x8(%rbp)
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  801e8a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e8d:	05 ff 0f 00 00       	add    $0xfff,%eax
  801e92:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801e98:	85 c0                	test   %eax,%eax
  801e9a:	0f 48 c2             	cmovs  %edx,%eax
  801e9d:	c1 f8 0c             	sar    $0xc,%eax
  801ea0:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801ea3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ea6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ea9:	eb 45                	jmp    801ef0 <file_truncate_blocks+0x95>
		if ((r = file_free_block(f, bno)) < 0)
  801eab:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801eae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eb2:	89 d6                	mov    %edx,%esi
  801eb4:	48 89 c7             	mov    %rax,%rdi
  801eb7:	48 b8 f0 1d 80 00 00 	movabs $0x801df0,%rax
  801ebe:	00 00 00 
  801ec1:	ff d0                	callq  *%rax
  801ec3:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801ec6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801eca:	79 20                	jns    801eec <file_truncate_blocks+0x91>
			cprintf("warning: file_free_block: %e", r);
  801ecc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801ecf:	89 c6                	mov    %eax,%esi
  801ed1:	48 bf 28 76 80 00 00 	movabs $0x807628,%rdi
  801ed8:	00 00 00 
  801edb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee0:	48 ba 1f 36 80 00 00 	movabs $0x80361f,%rdx
  801ee7:	00 00 00 
  801eea:	ff d2                	callq  *%rdx
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801eec:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ef0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ef3:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  801ef6:	72 b3                	jb     801eab <file_truncate_blocks+0x50>
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  801ef8:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  801efc:	77 34                	ja     801f32 <file_truncate_blocks+0xd7>
  801efe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f02:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801f08:	85 c0                	test   %eax,%eax
  801f0a:	74 26                	je     801f32 <file_truncate_blocks+0xd7>
		free_block(f->f_indirect);
  801f0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f10:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801f16:	89 c7                	mov    %eax,%edi
  801f18:	48 b8 8f 0f 80 00 00 	movabs $0x800f8f,%rax
  801f1f:	00 00 00 
  801f22:	ff d0                	callq  *%rax
		f->f_indirect = 0;
  801f24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f28:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%rax)
  801f2f:	00 00 00 
	}
}
  801f32:	c9                   	leaveq 
  801f33:	c3                   	retq   

0000000000801f34 <file_set_size>:

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  801f34:	55                   	push   %rbp
  801f35:	48 89 e5             	mov    %rsp,%rbp
  801f38:	48 83 ec 10          	sub    $0x10,%rsp
  801f3c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f40:	89 75 f4             	mov    %esi,-0xc(%rbp)
	if (f->f_size > newsize)
  801f43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f47:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801f4d:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801f50:	7e 18                	jle    801f6a <file_set_size+0x36>
		file_truncate_blocks(f, newsize);
  801f52:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801f55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f59:	89 d6                	mov    %edx,%esi
  801f5b:	48 89 c7             	mov    %rax,%rdi
  801f5e:	48 b8 5b 1e 80 00 00 	movabs $0x801e5b,%rax
  801f65:	00 00 00 
  801f68:	ff d0                	callq  *%rax
	f->f_size = newsize;
  801f6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f6e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801f71:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	flush_block(f);
  801f77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f7b:	48 89 c7             	mov    %rax,%rdi
  801f7e:	48 b8 1b 0a 80 00 00 	movabs $0x800a1b,%rax
  801f85:	00 00 00 
  801f88:	ff d0                	callq  *%rax
	return 0;
  801f8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f8f:	c9                   	leaveq 
  801f90:	c3                   	retq   

0000000000801f91 <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  801f91:	55                   	push   %rbp
  801f92:	48 89 e5             	mov    %rsp,%rbp
  801f95:	48 83 ec 20          	sub    $0x20,%rsp
  801f99:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801f9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fa4:	eb 62                	jmp    802008 <file_flush+0x77>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801fa6:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801fa9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801fad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fb1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fb6:	48 89 c7             	mov    %rax,%rdi
  801fb9:	48 b8 e1 12 80 00 00 	movabs $0x8012e1,%rax
  801fc0:	00 00 00 
  801fc3:	ff d0                	callq  *%rax
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	78 13                	js     801fdc <file_flush+0x4b>
		    pdiskbno == NULL || *pdiskbno == 0)
  801fc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801fcd:	48 85 c0             	test   %rax,%rax
  801fd0:	74 0a                	je     801fdc <file_flush+0x4b>
		    pdiskbno == NULL || *pdiskbno == 0)
  801fd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fd6:	8b 00                	mov    (%rax),%eax
  801fd8:	85 c0                	test   %eax,%eax
  801fda:	75 02                	jne    801fde <file_flush+0x4d>
			continue;
  801fdc:	eb 26                	jmp    802004 <file_flush+0x73>
		flush_block(diskaddr(*pdiskbno));
  801fde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fe2:	8b 00                	mov    (%rax),%eax
  801fe4:	89 c0                	mov    %eax,%eax
  801fe6:	48 89 c7             	mov    %rax,%rdi
  801fe9:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801ff0:	00 00 00 
  801ff3:	ff d0                	callq  *%rax
  801ff5:	48 89 c7             	mov    %rax,%rdi
  801ff8:	48 b8 1b 0a 80 00 00 	movabs $0x800a1b,%rax
  801fff:	00 00 00 
  802002:	ff d0                	callq  *%rax
file_flush(struct File *f)
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  802004:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802008:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80200c:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  802012:	05 ff 0f 00 00       	add    $0xfff,%eax
  802017:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  80201d:	85 c0                	test   %eax,%eax
  80201f:	0f 48 c2             	cmovs  %edx,%eax
  802022:	c1 f8 0c             	sar    $0xc,%eax
  802025:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802028:	0f 8f 78 ff ff ff    	jg     801fa6 <file_flush+0x15>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
  80202e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802032:	48 89 c7             	mov    %rax,%rdi
  802035:	48 b8 1b 0a 80 00 00 	movabs $0x800a1b,%rax
  80203c:	00 00 00 
  80203f:	ff d0                	callq  *%rax
	if (f->f_indirect)
  802041:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802045:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  80204b:	85 c0                	test   %eax,%eax
  80204d:	74 2a                	je     802079 <file_flush+0xe8>
		flush_block(diskaddr(f->f_indirect));
  80204f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802053:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  802059:	89 c0                	mov    %eax,%eax
  80205b:	48 89 c7             	mov    %rax,%rdi
  80205e:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  802065:	00 00 00 
  802068:	ff d0                	callq  *%rax
  80206a:	48 89 c7             	mov    %rax,%rdi
  80206d:	48 b8 1b 0a 80 00 00 	movabs $0x800a1b,%rax
  802074:	00 00 00 
  802077:	ff d0                	callq  *%rax
}
  802079:	c9                   	leaveq 
  80207a:	c3                   	retq   

000000000080207b <file_remove>:

// Remove a file by truncating it and then zeroing the name.
int
file_remove(const char *path)
{
  80207b:	55                   	push   %rbp
  80207c:	48 89 e5             	mov    %rsp,%rbp
  80207f:	48 83 ec 20          	sub    $0x20,%rsp
  802083:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;
	struct File *f;

	if ((r = walk_path(path, 0, &f, 0)) < 0)
  802087:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80208b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80208f:	b9 00 00 00 00       	mov    $0x0,%ecx
  802094:	be 00 00 00 00       	mov    $0x0,%esi
  802099:	48 89 c7             	mov    %rax,%rdi
  80209c:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  8020a3:	00 00 00 
  8020a6:	ff d0                	callq  *%rax
  8020a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020af:	79 05                	jns    8020b6 <file_remove+0x3b>
		return r;
  8020b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020b4:	eb 45                	jmp    8020fb <file_remove+0x80>

	file_truncate_blocks(f, 0);
  8020b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020ba:	be 00 00 00 00       	mov    $0x0,%esi
  8020bf:	48 89 c7             	mov    %rax,%rdi
  8020c2:	48 b8 5b 1e 80 00 00 	movabs $0x801e5b,%rax
  8020c9:	00 00 00 
  8020cc:	ff d0                	callq  *%rax
	f->f_name[0] = '\0';
  8020ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020d2:	c6 00 00             	movb   $0x0,(%rax)
	f->f_size = 0;
  8020d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020d9:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8020e0:	00 00 00 
	flush_block(f);
  8020e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020e7:	48 89 c7             	mov    %rax,%rdi
  8020ea:	48 b8 1b 0a 80 00 00 	movabs $0x800a1b,%rax
  8020f1:	00 00 00 
  8020f4:	ff d0                	callq  *%rax

	return 0;
  8020f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020fb:	c9                   	leaveq 
  8020fc:	c3                   	retq   

00000000008020fd <fs_sync>:

// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  8020fd:	55                   	push   %rbp
  8020fe:	48 89 e5             	mov    %rsp,%rbp
  802101:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  802105:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  80210c:	eb 27                	jmp    802135 <fs_sync+0x38>
		flush_block(diskaddr(i));
  80210e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802111:	48 98                	cltq   
  802113:	48 89 c7             	mov    %rax,%rdi
  802116:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  80211d:	00 00 00 
  802120:	ff d0                	callq  *%rax
  802122:	48 89 c7             	mov    %rax,%rdi
  802125:	48 b8 1b 0a 80 00 00 	movabs $0x800a1b,%rax
  80212c:	00 00 00 
  80212f:	ff d0                	callq  *%rax
// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  802131:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802135:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802138:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  80213f:	00 00 00 
  802142:	48 8b 00             	mov    (%rax),%rax
  802145:	8b 40 04             	mov    0x4(%rax),%eax
  802148:	39 c2                	cmp    %eax,%edx
  80214a:	72 c2                	jb     80210e <fs_sync+0x11>
		flush_block(diskaddr(i));
}
  80214c:	c9                   	leaveq 
  80214d:	c3                   	retq   

000000000080214e <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  80214e:	55                   	push   %rbp
  80214f:	48 89 e5             	mov    %rsp,%rbp
  802152:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	uintptr_t va = FILEVA;
  802156:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
  80215b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < MAXOPEN; i++) {
  80215f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802166:	eb 4b                	jmp    8021b3 <serve_init+0x65>
		opentab[i].o_fileid = i;
  802168:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80216b:	48 ba 20 a0 80 00 00 	movabs $0x80a020,%rdx
  802172:	00 00 00 
  802175:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802178:	48 63 c9             	movslq %ecx,%rcx
  80217b:	48 c1 e1 05          	shl    $0x5,%rcx
  80217f:	48 01 ca             	add    %rcx,%rdx
  802182:	89 02                	mov    %eax,(%rdx)
		opentab[i].o_fd = (struct Fd*) va;
  802184:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802188:	48 ba 20 a0 80 00 00 	movabs $0x80a020,%rdx
  80218f:	00 00 00 
  802192:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802195:	48 63 c9             	movslq %ecx,%rcx
  802198:	48 c1 e1 05          	shl    $0x5,%rcx
  80219c:	48 01 ca             	add    %rcx,%rdx
  80219f:	48 83 c2 10          	add    $0x10,%rdx
  8021a3:	48 89 42 08          	mov    %rax,0x8(%rdx)
		va += PGSIZE;
  8021a7:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
  8021ae:	00 
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  8021af:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021b3:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8021ba:	7e ac                	jle    802168 <serve_init+0x1a>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  8021bc:	c9                   	leaveq 
  8021bd:	c3                   	retq   

00000000008021be <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  8021be:	55                   	push   %rbp
  8021bf:	48 89 e5             	mov    %rsp,%rbp
  8021c2:	48 83 ec 20          	sub    $0x20,%rsp
  8021c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  8021ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021d1:	e9 24 01 00 00       	jmpq   8022fa <openfile_alloc+0x13c>
		switch (pageref(opentab[i].o_fd)) {
  8021d6:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  8021dd:	00 00 00 
  8021e0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8021e3:	48 63 d2             	movslq %edx,%rdx
  8021e6:	48 c1 e2 05          	shl    $0x5,%rdx
  8021ea:	48 01 d0             	add    %rdx,%rax
  8021ed:	48 83 c0 10          	add    $0x10,%rax
  8021f1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8021f5:	48 89 c7             	mov    %rax,%rdi
  8021f8:	48 b8 68 61 80 00 00 	movabs $0x806168,%rax
  8021ff:	00 00 00 
  802202:	ff d0                	callq  *%rax
  802204:	85 c0                	test   %eax,%eax
  802206:	74 0a                	je     802212 <openfile_alloc+0x54>
  802208:	83 f8 01             	cmp    $0x1,%eax
  80220b:	74 4e                	je     80225b <openfile_alloc+0x9d>
  80220d:	e9 e4 00 00 00       	jmpq   8022f6 <openfile_alloc+0x138>

		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  802212:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  802219:	00 00 00 
  80221c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80221f:	48 63 d2             	movslq %edx,%rdx
  802222:	48 c1 e2 05          	shl    $0x5,%rdx
  802226:	48 01 d0             	add    %rdx,%rax
  802229:	48 83 c0 10          	add    $0x10,%rax
  80222d:	48 8b 40 08          	mov    0x8(%rax),%rax
  802231:	ba 07 00 00 00       	mov    $0x7,%edx
  802236:	48 89 c6             	mov    %rax,%rsi
  802239:	bf 00 00 00 00       	mov    $0x0,%edi
  80223e:	48 b8 03 4b 80 00 00 	movabs $0x804b03,%rax
  802245:	00 00 00 
  802248:	ff d0                	callq  *%rax
  80224a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80224d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802251:	79 08                	jns    80225b <openfile_alloc+0x9d>
				return r;
  802253:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802256:	e9 b1 00 00 00       	jmpq   80230c <openfile_alloc+0x14e>
			/* fall through */
		case 1:

			opentab[i].o_fileid += MAXOPEN;
  80225b:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  802262:	00 00 00 
  802265:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802268:	48 63 d2             	movslq %edx,%rdx
  80226b:	48 c1 e2 05          	shl    $0x5,%rdx
  80226f:	48 01 d0             	add    %rdx,%rax
  802272:	8b 00                	mov    (%rax),%eax
  802274:	8d 90 00 04 00 00    	lea    0x400(%rax),%edx
  80227a:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  802281:	00 00 00 
  802284:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802287:	48 63 c9             	movslq %ecx,%rcx
  80228a:	48 c1 e1 05          	shl    $0x5,%rcx
  80228e:	48 01 c8             	add    %rcx,%rax
  802291:	89 10                	mov    %edx,(%rax)
			*o = &opentab[i];
  802293:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802296:	48 98                	cltq   
  802298:	48 c1 e0 05          	shl    $0x5,%rax
  80229c:	48 89 c2             	mov    %rax,%rdx
  80229f:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  8022a6:	00 00 00 
  8022a9:	48 01 c2             	add    %rax,%rdx
  8022ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b0:	48 89 10             	mov    %rdx,(%rax)
			memset(opentab[i].o_fd, 0, PGSIZE);
  8022b3:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  8022ba:	00 00 00 
  8022bd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8022c0:	48 63 d2             	movslq %edx,%rdx
  8022c3:	48 c1 e2 05          	shl    $0x5,%rdx
  8022c7:	48 01 d0             	add    %rdx,%rax
  8022ca:	48 83 c0 10          	add    $0x10,%rax
  8022ce:	48 8b 40 08          	mov    0x8(%rax),%rax
  8022d2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022d7:	be 00 00 00 00       	mov    $0x0,%esi
  8022dc:	48 89 c7             	mov    %rax,%rdi
  8022df:	48 b8 6d 44 80 00 00 	movabs $0x80446d,%rax
  8022e6:	00 00 00 
  8022e9:	ff d0                	callq  *%rax
			return (*o)->o_fileid;
  8022eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ef:	48 8b 00             	mov    (%rax),%rax
  8022f2:	8b 00                	mov    (%rax),%eax
  8022f4:	eb 16                	jmp    80230c <openfile_alloc+0x14e>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  8022f6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8022fa:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802301:	0f 8e cf fe ff ff    	jle    8021d6 <openfile_alloc+0x18>
			memset(opentab[i].o_fd, 0, PGSIZE);
			return (*o)->o_fileid;
	         }
	}
	//cprintf("am I returning from here ????");
	return -E_MAX_OPEN;
  802307:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80230c:	c9                   	leaveq 
  80230d:	c3                   	retq   

000000000080230e <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  80230e:	55                   	push   %rbp
  80230f:	48 89 e5             	mov    %rsp,%rbp
  802312:	48 83 ec 20          	sub    $0x20,%rsp
  802316:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802319:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80231c:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  802320:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802323:	25 ff 03 00 00       	and    $0x3ff,%eax
  802328:	89 c0                	mov    %eax,%eax
  80232a:	48 c1 e0 05          	shl    $0x5,%rax
  80232e:	48 89 c2             	mov    %rax,%rdx
  802331:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  802338:	00 00 00 
  80233b:	48 01 d0             	add    %rdx,%rax
  80233e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
  802342:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802346:	48 8b 40 18          	mov    0x18(%rax),%rax
  80234a:	48 89 c7             	mov    %rax,%rdi
  80234d:	48 b8 68 61 80 00 00 	movabs $0x806168,%rax
  802354:	00 00 00 
  802357:	ff d0                	callq  *%rax
  802359:	83 f8 01             	cmp    $0x1,%eax
  80235c:	74 0b                	je     802369 <openfile_lookup+0x5b>
  80235e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802362:	8b 00                	mov    (%rax),%eax
  802364:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  802367:	74 07                	je     802370 <openfile_lookup+0x62>
		return -E_INVAL;
  802369:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80236e:	eb 10                	jmp    802380 <openfile_lookup+0x72>
	*po = o;
  802370:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802374:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802378:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80237b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802380:	c9                   	leaveq 
  802381:	c3                   	retq   

0000000000802382 <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  802382:	55                   	push   %rbp
  802383:	48 89 e5             	mov    %rsp,%rbp
  802386:	48 81 ec 40 04 00 00 	sub    $0x440,%rsp
  80238d:	89 bd dc fb ff ff    	mov    %edi,-0x424(%rbp)
  802393:	48 89 b5 d0 fb ff ff 	mov    %rsi,-0x430(%rbp)
  80239a:	48 89 95 c8 fb ff ff 	mov    %rdx,-0x438(%rbp)
  8023a1:	48 89 8d c0 fb ff ff 	mov    %rcx,-0x440(%rbp)

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  8023a8:	48 8b 8d d0 fb ff ff 	mov    -0x430(%rbp),%rcx
  8023af:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  8023b6:	ba 00 04 00 00       	mov    $0x400,%edx
  8023bb:	48 89 ce             	mov    %rcx,%rsi
  8023be:	48 89 c7             	mov    %rax,%rdi
  8023c1:	48 b8 f8 44 80 00 00 	movabs $0x8044f8,%rax
  8023c8:	00 00 00 
  8023cb:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  8023cd:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  8023d1:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  8023d8:	48 89 c7             	mov    %rax,%rdi
  8023db:	48 b8 be 21 80 00 00 	movabs $0x8021be,%rax
  8023e2:	00 00 00 
  8023e5:	ff d0                	callq  *%rax
  8023e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ee:	79 08                	jns    8023f8 <serve_open+0x76>
		if (debug)
			cprintf("openfile_alloc failed: %e", r);
		return r;
  8023f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023f3:	e9 7c 01 00 00       	jmpq   802574 <serve_open+0x1f2>
	}
	fileid = r;
  8023f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023fb:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// Open the file
	if (req->req_omode & O_CREAT) {
  8023fe:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  802405:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  80240b:	25 00 01 00 00       	and    $0x100,%eax
  802410:	85 c0                	test   %eax,%eax
  802412:	74 4f                	je     802463 <serve_open+0xe1>
		if ((r = file_create(path, &f)) < 0) {
  802414:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  80241b:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  802422:	48 89 d6             	mov    %rdx,%rsi
  802425:	48 89 c7             	mov    %rax,%rdi
  802428:	48 b8 1b 1a 80 00 00 	movabs $0x801a1b,%rax
  80242f:	00 00 00 
  802432:	ff d0                	callq  *%rax
  802434:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802437:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80243b:	79 57                	jns    802494 <serve_open+0x112>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  80243d:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  802444:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  80244a:	25 00 04 00 00       	and    $0x400,%eax
  80244f:	85 c0                	test   %eax,%eax
  802451:	75 08                	jne    80245b <serve_open+0xd9>
  802453:	83 7d fc f2          	cmpl   $0xfffffff2,-0x4(%rbp)
  802457:	75 02                	jne    80245b <serve_open+0xd9>
				goto try_open;
  802459:	eb 08                	jmp    802463 <serve_open+0xe1>
			if (debug)
				cprintf("file_create failed: %e", r);
			return r;
  80245b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80245e:	e9 11 01 00 00       	jmpq   802574 <serve_open+0x1f2>
		}
	} else {
try_open:
		if ((r = file_open(path, &f)) < 0) {
  802463:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  80246a:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  802471:	48 89 d6             	mov    %rdx,%rsi
  802474:	48 89 c7             	mov    %rax,%rdi
  802477:	48 b8 05 1b 80 00 00 	movabs $0x801b05,%rax
  80247e:	00 00 00 
  802481:	ff d0                	callq  *%rax
  802483:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802486:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80248a:	79 08                	jns    802494 <serve_open+0x112>
			if (debug)
				cprintf("file_open failed: %e", r);
			return r;
  80248c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80248f:	e9 e0 00 00 00       	jmpq   802574 <serve_open+0x1f2>
		}
	}

	// Truncate
	if (req->req_omode & O_TRUNC) {
  802494:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  80249b:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  8024a1:	25 00 02 00 00       	and    $0x200,%eax
  8024a6:	85 c0                	test   %eax,%eax
  8024a8:	74 2c                	je     8024d6 <serve_open+0x154>
		if ((r = file_set_size(f, 0)) < 0) {
  8024aa:	48 8b 85 e8 fb ff ff 	mov    -0x418(%rbp),%rax
  8024b1:	be 00 00 00 00       	mov    $0x0,%esi
  8024b6:	48 89 c7             	mov    %rax,%rdi
  8024b9:	48 b8 34 1f 80 00 00 	movabs $0x801f34,%rax
  8024c0:	00 00 00 
  8024c3:	ff d0                	callq  *%rax
  8024c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024cc:	79 08                	jns    8024d6 <serve_open+0x154>
			if (debug)
				cprintf("file_set_size failed: %e", r);
			return r;
  8024ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024d1:	e9 9e 00 00 00       	jmpq   802574 <serve_open+0x1f2>
		}
	}

	// Save the file pointer
	o->o_file = f;
  8024d6:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8024dd:	48 8b 95 e8 fb ff ff 	mov    -0x418(%rbp),%rdx
  8024e4:	48 89 50 08          	mov    %rdx,0x8(%rax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  8024e8:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8024ef:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024f3:	48 8b 95 e0 fb ff ff 	mov    -0x420(%rbp),%rdx
  8024fa:	8b 12                	mov    (%rdx),%edx
  8024fc:	89 50 0c             	mov    %edx,0xc(%rax)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  8024ff:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802506:	48 8b 40 18          	mov    0x18(%rax),%rax
  80250a:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  802511:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  802517:	83 e2 03             	and    $0x3,%edx
  80251a:	89 50 08             	mov    %edx,0x8(%rax)
	o->o_fd->fd_dev_id = devfile.dev_id;
  80251d:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802524:	48 8b 40 18          	mov    0x18(%rax),%rax
  802528:	48 ba e0 20 81 00 00 	movabs $0x8120e0,%rdx
  80252f:	00 00 00 
  802532:	8b 12                	mov    (%rdx),%edx
  802534:	89 10                	mov    %edx,(%rax)
	o->o_mode = req->req_omode;
  802536:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  80253d:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  802544:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  80254a:	89 50 10             	mov    %edx,0x10(%rax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  80254d:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802554:	48 8b 50 18          	mov    0x18(%rax),%rdx
  802558:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  80255f:	48 89 10             	mov    %rdx,(%rax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  802562:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  802569:	c7 00 07 04 00 00    	movl   $0x407,(%rax)

	return 0;
  80256f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802574:	c9                   	leaveq 
  802575:	c3                   	retq   

0000000000802576 <serve_set_size>:

// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
  802576:	55                   	push   %rbp
  802577:	48 89 e5             	mov    %rsp,%rbp
  80257a:	48 83 ec 20          	sub    $0x20,%rsp
  80257e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802581:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802585:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802589:	8b 00                	mov    (%rax),%eax
  80258b:	89 c1                	mov    %eax,%ecx
  80258d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802591:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802594:	89 ce                	mov    %ecx,%esi
  802596:	89 c7                	mov    %eax,%edi
  802598:	48 b8 0e 23 80 00 00 	movabs $0x80230e,%rax
  80259f:	00 00 00 
  8025a2:	ff d0                	callq  *%rax
  8025a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ab:	79 05                	jns    8025b2 <serve_set_size+0x3c>
		return r;
  8025ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b0:	eb 20                	jmp    8025d2 <serve_set_size+0x5c>

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
  8025b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025b6:	8b 50 04             	mov    0x4(%rax),%edx
  8025b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025bd:	48 8b 40 08          	mov    0x8(%rax),%rax
  8025c1:	89 d6                	mov    %edx,%esi
  8025c3:	48 89 c7             	mov    %rax,%rdi
  8025c6:	48 b8 34 1f 80 00 00 	movabs $0x801f34,%rax
  8025cd:	00 00 00 
  8025d0:	ff d0                	callq  *%rax
}
  8025d2:	c9                   	leaveq 
  8025d3:	c3                   	retq   

00000000008025d4 <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  8025d4:	55                   	push   %rbp
  8025d5:	48 89 e5             	mov    %rsp,%rbp
  8025d8:	48 83 ec 30          	sub    $0x30,%rsp
  8025dc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025df:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r = -1;
  8025e3:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!ipc)
  8025ea:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8025ef:	75 08                	jne    8025f9 <serve_read+0x25>
		return r; 
  8025f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f4:	e9 e0 00 00 00       	jmpq   8026d9 <serve_read+0x105>
	struct Fsreq_read *req = &ipc->read;
  8025f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025fd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	struct Fsret_read *ret = &ipc->readRet;
  802601:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802605:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	// (remember that read is always allowed to return fewer bytes
	// than requested).  Also, be careful because ipc is a union,
	// so filling in ret will overwrite req.
	//
	// LAB 5: Your code here
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802609:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80260d:	8b 00                	mov    (%rax),%eax
  80260f:	89 c1                	mov    %eax,%ecx
  802611:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802615:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802618:	89 ce                	mov    %ecx,%esi
  80261a:	89 c7                	mov    %eax,%edi
  80261c:	48 b8 0e 23 80 00 00 	movabs $0x80230e,%rax
  802623:	00 00 00 
  802626:	ff d0                	callq  *%rax
  802628:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80262b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80262f:	79 08                	jns    802639 <serve_read+0x65>
		return r;
  802631:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802634:	e9 a0 00 00 00       	jmpq   8026d9 <serve_read+0x105>

	if(!o || !o->o_file || !o->o_fd)
  802639:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80263d:	48 85 c0             	test   %rax,%rax
  802640:	74 1a                	je     80265c <serve_read+0x88>
  802642:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802646:	48 8b 40 08          	mov    0x8(%rax),%rax
  80264a:	48 85 c0             	test   %rax,%rax
  80264d:	74 0d                	je     80265c <serve_read+0x88>
  80264f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802653:	48 8b 40 18          	mov    0x18(%rax),%rax
  802657:	48 85 c0             	test   %rax,%rax
  80265a:	75 07                	jne    802663 <serve_read+0x8f>
	{
		return -1;
  80265c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802661:	eb 76                	jmp    8026d9 <serve_read+0x105>
	}
	if(req->req_n > PGSIZE)
  802663:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802667:	48 8b 40 08          	mov    0x8(%rax),%rax
  80266b:	48 3d 00 10 00 00    	cmp    $0x1000,%rax
  802671:	76 0c                	jbe    80267f <serve_read+0xab>
	{
		req->req_n = PGSIZE;
  802673:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802677:	48 c7 40 08 00 10 00 	movq   $0x1000,0x8(%rax)
  80267e:	00 
	}
	
	if ((r = file_read(o->o_file, ret->ret_buf, req->req_n, o->o_fd->fd_offset)) <= 0) {
  80267f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802683:	48 8b 40 18          	mov    0x18(%rax),%rax
  802687:	8b 48 04             	mov    0x4(%rax),%ecx
  80268a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80268e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802692:	48 8b 75 e8          	mov    -0x18(%rbp),%rsi
  802696:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80269a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80269e:	48 89 c7             	mov    %rax,%rdi
  8026a1:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  8026a8:	00 00 00 
  8026ab:	ff d0                	callq  *%rax
  8026ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b4:	7f 05                	jg     8026bb <serve_read+0xe7>
		if (debug)
		cprintf("file_read failed: %e", r);
		return r;
  8026b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026b9:	eb 1e                	jmp    8026d9 <serve_read+0x105>
	}
	//cprintf("server in serve_read()  is [%d]  %x %x %x %x\n",r,ret->ret_buf[0], ret->ret_buf[1], ret->ret_buf[2], ret->ret_buf[3]);
	o->o_fd->fd_offset += r;
  8026bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026bf:	48 8b 40 18          	mov    0x18(%rax),%rax
  8026c3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026c7:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  8026cb:	8b 4a 04             	mov    0x4(%rdx),%ecx
  8026ce:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026d1:	01 ca                	add    %ecx,%edx
  8026d3:	89 50 04             	mov    %edx,0x4(%rax)
	
	return r;
  8026d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("serve_read not implemented");
}
  8026d9:	c9                   	leaveq 
  8026da:	c3                   	retq   

00000000008026db <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  8026db:	55                   	push   %rbp
  8026dc:	48 89 e5             	mov    %rsp,%rbp
  8026df:	48 83 ec 20          	sub    $0x20,%rsp
  8026e3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r = -1;
  8026ea:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!req)
  8026f1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8026f6:	75 08                	jne    802700 <serve_write+0x25>
		return r;
  8026f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026fb:	e9 d8 00 00 00       	jmpq   8027d8 <serve_write+0xfd>

	if (debug)
		cprintf("serve_write %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// LAB 5: Your code here.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802700:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802704:	8b 00                	mov    (%rax),%eax
  802706:	89 c1                	mov    %eax,%ecx
  802708:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80270c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80270f:	89 ce                	mov    %ecx,%esi
  802711:	89 c7                	mov    %eax,%edi
  802713:	48 b8 0e 23 80 00 00 	movabs $0x80230e,%rax
  80271a:	00 00 00 
  80271d:	ff d0                	callq  *%rax
  80271f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802722:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802726:	79 08                	jns    802730 <serve_write+0x55>
		return r;
  802728:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80272b:	e9 a8 00 00 00       	jmpq   8027d8 <serve_write+0xfd>

	if(!o || !o->o_file || !o->o_fd)
  802730:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802734:	48 85 c0             	test   %rax,%rax
  802737:	74 1a                	je     802753 <serve_write+0x78>
  802739:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80273d:	48 8b 40 08          	mov    0x8(%rax),%rax
  802741:	48 85 c0             	test   %rax,%rax
  802744:	74 0d                	je     802753 <serve_write+0x78>
  802746:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80274a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80274e:	48 85 c0             	test   %rax,%rax
  802751:	75 07                	jne    80275a <serve_write+0x7f>
		return -1;
  802753:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802758:	eb 7e                	jmp    8027d8 <serve_write+0xfd>
	
	if ((r = file_write(o->o_file, req->req_buf, req->req_n, o->o_fd->fd_offset)) < 0) {
  80275a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80275e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802762:	8b 48 04             	mov    0x4(%rax),%ecx
  802765:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802769:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80276d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802771:	48 8d 70 10          	lea    0x10(%rax),%rsi
  802775:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802779:	48 8b 40 08          	mov    0x8(%rax),%rax
  80277d:	48 89 c7             	mov    %rax,%rdi
  802780:	48 b8 8e 1c 80 00 00 	movabs $0x801c8e,%rax
  802787:	00 00 00 
  80278a:	ff d0                	callq  *%rax
  80278c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80278f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802793:	79 25                	jns    8027ba <serve_write+0xdf>
		cprintf("file_write failed: %e", r);
  802795:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802798:	89 c6                	mov    %eax,%esi
  80279a:	48 bf 48 76 80 00 00 	movabs $0x807648,%rdi
  8027a1:	00 00 00 
  8027a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a9:	48 ba 1f 36 80 00 00 	movabs $0x80361f,%rdx
  8027b0:	00 00 00 
  8027b3:	ff d2                	callq  *%rdx
		return r;
  8027b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b8:	eb 1e                	jmp    8027d8 <serve_write+0xfd>
	}
	o->o_fd->fd_offset += r;
  8027ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027be:	48 8b 40 18          	mov    0x18(%rax),%rax
  8027c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027c6:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  8027ca:	8b 4a 04             	mov    0x4(%rdx),%ecx
  8027cd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027d0:	01 ca                	add    %ecx,%edx
  8027d2:	89 50 04             	mov    %edx,0x4(%rax)
	
	return r;
  8027d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("serve_write not implemented");
}
  8027d8:	c9                   	leaveq 
  8027d9:	c3                   	retq   

00000000008027da <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  8027da:	55                   	push   %rbp
  8027db:	48 89 e5             	mov    %rsp,%rbp
  8027de:	48 83 ec 30          	sub    $0x30,%rsp
  8027e2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8027e5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	struct Fsreq_stat *req = &ipc->stat;
  8027e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Fsret_stat *ret = &ipc->statRet;
  8027f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027f5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8027f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027fd:	8b 00                	mov    (%rax),%eax
  8027ff:	89 c1                	mov    %eax,%ecx
  802801:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802805:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802808:	89 ce                	mov    %ecx,%esi
  80280a:	89 c7                	mov    %eax,%edi
  80280c:	48 b8 0e 23 80 00 00 	movabs $0x80230e,%rax
  802813:	00 00 00 
  802816:	ff d0                	callq  *%rax
  802818:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80281b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80281f:	79 05                	jns    802826 <serve_stat+0x4c>
		return r;
  802821:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802824:	eb 5f                	jmp    802885 <serve_stat+0xab>

	strcpy(ret->ret_name, o->o_file->f_name);
  802826:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80282a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80282e:	48 89 c2             	mov    %rax,%rdx
  802831:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802835:	48 89 d6             	mov    %rdx,%rsi
  802838:	48 89 c7             	mov    %rax,%rdi
  80283b:	48 b8 d4 41 80 00 00 	movabs $0x8041d4,%rax
  802842:	00 00 00 
  802845:	ff d0                	callq  *%rax
	ret->ret_size = o->o_file->f_size;
  802847:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80284b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80284f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802855:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802859:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  80285f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802863:	48 8b 40 08          	mov    0x8(%rax),%rax
  802867:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  80286d:	83 f8 01             	cmp    $0x1,%eax
  802870:	0f 94 c0             	sete   %al
  802873:	0f b6 d0             	movzbl %al,%edx
  802876:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80287a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802880:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802885:	c9                   	leaveq 
  802886:	c3                   	retq   

0000000000802887 <serve_flush>:

// Flush all data and metadata of req->req_fileid to disk.
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  802887:	55                   	push   %rbp
  802888:	48 89 e5             	mov    %rsp,%rbp
  80288b:	48 83 ec 20          	sub    $0x20,%rsp
  80288f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802892:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (debug)
		cprintf("serve_flush %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802896:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80289a:	8b 00                	mov    (%rax),%eax
  80289c:	89 c1                	mov    %eax,%ecx
  80289e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028a5:	89 ce                	mov    %ecx,%esi
  8028a7:	89 c7                	mov    %eax,%edi
  8028a9:	48 b8 0e 23 80 00 00 	movabs $0x80230e,%rax
  8028b0:	00 00 00 
  8028b3:	ff d0                	callq  *%rax
  8028b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028bc:	79 05                	jns    8028c3 <serve_flush+0x3c>
		return r;
  8028be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c1:	eb 1c                	jmp    8028df <serve_flush+0x58>
	file_flush(o->o_file);
  8028c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8028cb:	48 89 c7             	mov    %rax,%rdi
  8028ce:	48 b8 91 1f 80 00 00 	movabs $0x801f91,%rax
  8028d5:	00 00 00 
  8028d8:	ff d0                	callq  *%rax
	return 0;
  8028da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028df:	c9                   	leaveq 
  8028e0:	c3                   	retq   

00000000008028e1 <serve_remove>:

// Remove the file req->req_path.
int
serve_remove(envid_t envid, struct Fsreq_remove *req)
{
  8028e1:	55                   	push   %rbp
  8028e2:	48 89 e5             	mov    %rsp,%rbp
  8028e5:	48 81 ec 10 04 00 00 	sub    $0x410,%rsp
  8028ec:	89 bd fc fb ff ff    	mov    %edi,-0x404(%rbp)
  8028f2:	48 89 b5 f0 fb ff ff 	mov    %rsi,-0x410(%rbp)

	// Delete the named file.
	// Note: This request doesn't refer to an open file.

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  8028f9:	48 8b 8d f0 fb ff ff 	mov    -0x410(%rbp),%rcx
  802900:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  802907:	ba 00 04 00 00       	mov    $0x400,%edx
  80290c:	48 89 ce             	mov    %rcx,%rsi
  80290f:	48 89 c7             	mov    %rax,%rdi
  802912:	48 b8 f8 44 80 00 00 	movabs $0x8044f8,%rax
  802919:	00 00 00 
  80291c:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  80291e:	c6 45 ff 00          	movb   $0x0,-0x1(%rbp)

	// Delete the specified file
	return file_remove(path);
  802922:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  802929:	48 89 c7             	mov    %rax,%rdi
  80292c:	48 b8 7b 20 80 00 00 	movabs $0x80207b,%rax
  802933:	00 00 00 
  802936:	ff d0                	callq  *%rax
}
  802938:	c9                   	leaveq 
  802939:	c3                   	retq   

000000000080293a <serve_sync>:

// Sync the file system.
int
serve_sync(envid_t envid, union Fsipc *req)
{
  80293a:	55                   	push   %rbp
  80293b:	48 89 e5             	mov    %rsp,%rbp
  80293e:	48 83 ec 10          	sub    $0x10,%rsp
  802942:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802945:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	fs_sync();
  802949:	48 b8 fd 20 80 00 00 	movabs $0x8020fd,%rax
  802950:	00 00 00 
  802953:	ff d0                	callq  *%rax
	return 0;
  802955:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80295a:	c9                   	leaveq 
  80295b:	c3                   	retq   

000000000080295c <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  80295c:	55                   	push   %rbp
  80295d:	48 89 e5             	mov    %rsp,%rbp
  802960:	48 83 ec 20          	sub    $0x20,%rsp
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  802964:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  80296b:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  802972:	00 00 00 
  802975:	48 8b 08             	mov    (%rax),%rcx
  802978:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80297c:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
  802980:	48 89 ce             	mov    %rcx,%rsi
  802983:	48 89 c7             	mov    %rax,%rdi
  802986:	48 b8 7a 4f 80 00 00 	movabs $0x804f7a,%rax
  80298d:	00 00 00 
  802990:	ff d0                	callq  *%rax
  802992:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  802995:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802998:	83 e0 01             	and    $0x1,%eax
  80299b:	85 c0                	test   %eax,%eax
  80299d:	75 23                	jne    8029c2 <serve+0x66>
			cprintf("Invalid request from %08x: no argument page\n",
  80299f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8029a2:	89 c6                	mov    %eax,%esi
  8029a4:	48 bf 60 76 80 00 00 	movabs $0x807660,%rdi
  8029ab:	00 00 00 
  8029ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b3:	48 ba 1f 36 80 00 00 	movabs $0x80361f,%rdx
  8029ba:	00 00 00 
  8029bd:	ff d2                	callq  *%rdx
				whom);
			continue; // just leave it hanging...
  8029bf:	90                   	nop
		}
		ipc_send(whom, r, pg, perm);
		if(debug)
			cprintf("FS: Sent response %d to %x\n", r, whom);
		sys_page_unmap(0, fsreq);
	}
  8029c0:	eb a2                	jmp    802964 <serve+0x8>
			cprintf("Invalid request from %08x: no argument page\n",
				whom);
			continue; // just leave it hanging...
		}

		pg = NULL;
  8029c2:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8029c9:	00 
		if (req == FSREQ_OPEN) {
  8029ca:	83 7d f8 01          	cmpl   $0x1,-0x8(%rbp)
  8029ce:	75 2b                	jne    8029fb <serve+0x9f>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  8029d0:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  8029d7:	00 00 00 
  8029da:	48 8b 30             	mov    (%rax),%rsi
  8029dd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8029e0:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  8029e4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029e8:	89 c7                	mov    %eax,%edi
  8029ea:	48 b8 82 23 80 00 00 	movabs $0x802382,%rax
  8029f1:	00 00 00 
  8029f4:	ff d0                	callq  *%rax
  8029f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f9:	eb 73                	jmp    802a6e <serve+0x112>
		} else if (req < NHANDLERS && handlers[req]) {
  8029fb:	83 7d f8 08          	cmpl   $0x8,-0x8(%rbp)
  8029ff:	77 43                	ja     802a44 <serve+0xe8>
  802a01:	48 b8 40 20 81 00 00 	movabs $0x812040,%rax
  802a08:	00 00 00 
  802a0b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802a0e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a12:	48 85 c0             	test   %rax,%rax
  802a15:	74 2d                	je     802a44 <serve+0xe8>
			r = handlers[req](whom, fsreq);
  802a17:	48 b8 40 20 81 00 00 	movabs $0x812040,%rax
  802a1e:	00 00 00 
  802a21:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802a24:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a28:	48 ba 20 20 81 00 00 	movabs $0x812020,%rdx
  802a2f:	00 00 00 
  802a32:	48 8b 0a             	mov    (%rdx),%rcx
  802a35:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a38:	48 89 ce             	mov    %rcx,%rsi
  802a3b:	89 d7                	mov    %edx,%edi
  802a3d:	ff d0                	callq  *%rax
  802a3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a42:	eb 2a                	jmp    802a6e <serve+0x112>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  802a44:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a47:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a4a:	89 c6                	mov    %eax,%esi
  802a4c:	48 bf 90 76 80 00 00 	movabs $0x807690,%rdi
  802a53:	00 00 00 
  802a56:	b8 00 00 00 00       	mov    $0x0,%eax
  802a5b:	48 b9 1f 36 80 00 00 	movabs $0x80361f,%rcx
  802a62:	00 00 00 
  802a65:	ff d1                	callq  *%rcx
			r = -E_INVAL;
  802a67:	c7 45 fc fd ff ff ff 	movl   $0xfffffffd,-0x4(%rbp)
		}
		ipc_send(whom, r, pg, perm);
  802a6e:	8b 4d f0             	mov    -0x10(%rbp),%ecx
  802a71:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a75:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802a78:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a7b:	89 c7                	mov    %eax,%edi
  802a7d:	48 b8 80 50 80 00 00 	movabs $0x805080,%rax
  802a84:	00 00 00 
  802a87:	ff d0                	callq  *%rax
		if(debug)
			cprintf("FS: Sent response %d to %x\n", r, whom);
		sys_page_unmap(0, fsreq);
  802a89:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  802a90:	00 00 00 
  802a93:	48 8b 00             	mov    (%rax),%rax
  802a96:	48 89 c6             	mov    %rax,%rsi
  802a99:	bf 00 00 00 00       	mov    $0x0,%edi
  802a9e:	48 b8 ae 4b 80 00 00 	movabs $0x804bae,%rax
  802aa5:	00 00 00 
  802aa8:	ff d0                	callq  *%rax
	}
  802aaa:	e9 b5 fe ff ff       	jmpq   802964 <serve+0x8>

0000000000802aaf <umain>:
}

void
umain(int argc, char **argv)
{
  802aaf:	55                   	push   %rbp
  802ab0:	48 89 e5             	mov    %rsp,%rbp
  802ab3:	48 83 ec 20          	sub    $0x20,%rsp
  802ab7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802aba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  802abe:	48 b8 90 20 81 00 00 	movabs $0x812090,%rax
  802ac5:	00 00 00 
  802ac8:	48 b9 b3 76 80 00 00 	movabs $0x8076b3,%rcx
  802acf:	00 00 00 
  802ad2:	48 89 08             	mov    %rcx,(%rax)
	cprintf("FS is running\n");
  802ad5:	48 bf b6 76 80 00 00 	movabs $0x8076b6,%rdi
  802adc:	00 00 00 
  802adf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae4:	48 ba 1f 36 80 00 00 	movabs $0x80361f,%rdx
  802aeb:	00 00 00 
  802aee:	ff d2                	callq  *%rdx
  802af0:	c7 45 fc 00 8a 00 00 	movl   $0x8a00,-0x4(%rbp)
  802af7:	66 c7 45 fa 00 8a    	movw   $0x8a00,-0x6(%rbp)
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  802afd:	0f b7 45 fa          	movzwl -0x6(%rbp),%eax
  802b01:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b04:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  802b06:	48 bf c5 76 80 00 00 	movabs $0x8076c5,%rdi
  802b0d:	00 00 00 
  802b10:	b8 00 00 00 00       	mov    $0x0,%eax
  802b15:	48 ba 1f 36 80 00 00 	movabs $0x80361f,%rdx
  802b1c:	00 00 00 
  802b1f:	ff d2                	callq  *%rdx

	serve_init();
  802b21:	48 b8 4e 21 80 00 00 	movabs $0x80214e,%rax
  802b28:	00 00 00 
  802b2b:	ff d0                	callq  *%rax
	fs_init();
  802b2d:	48 b8 47 12 80 00 00 	movabs $0x801247,%rax
  802b34:	00 00 00 
  802b37:	ff d0                	callq  *%rax
	serve();
  802b39:	48 b8 5c 29 80 00 00 	movabs $0x80295c,%rax
  802b40:	00 00 00 
  802b43:	ff d0                	callq  *%rax
}
  802b45:	c9                   	leaveq 
  802b46:	c3                   	retq   

0000000000802b47 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  802b47:	55                   	push   %rbp
  802b48:	48 89 e5             	mov    %rsp,%rbp
  802b4b:	48 83 ec 20          	sub    $0x20,%rsp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  802b4f:	ba 07 00 00 00       	mov    $0x7,%edx
  802b54:	be 00 10 00 00       	mov    $0x1000,%esi
  802b59:	bf 00 00 00 00       	mov    $0x0,%edi
  802b5e:	48 b8 03 4b 80 00 00 	movabs $0x804b03,%rax
  802b65:	00 00 00 
  802b68:	ff d0                	callq  *%rax
  802b6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b71:	79 30                	jns    802ba3 <fs_test+0x5c>
		panic("sys_page_alloc: %e", r);
  802b73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b76:	89 c1                	mov    %eax,%ecx
  802b78:	48 ba fe 76 80 00 00 	movabs $0x8076fe,%rdx
  802b7f:	00 00 00 
  802b82:	be 13 00 00 00       	mov    $0x13,%esi
  802b87:	48 bf 11 77 80 00 00 	movabs $0x807711,%rdi
  802b8e:	00 00 00 
  802b91:	b8 00 00 00 00       	mov    $0x0,%eax
  802b96:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  802b9d:	00 00 00 
  802ba0:	41 ff d0             	callq  *%r8
	bits = (uint32_t*) PGSIZE;
  802ba3:	48 c7 45 f0 00 10 00 	movq   $0x1000,-0x10(%rbp)
  802baa:	00 
	memmove(bits, bitmap, PGSIZE);
  802bab:	48 b8 10 30 81 00 00 	movabs $0x813010,%rax
  802bb2:	00 00 00 
  802bb5:	48 8b 08             	mov    (%rax),%rcx
  802bb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bbc:	ba 00 10 00 00       	mov    $0x1000,%edx
  802bc1:	48 89 ce             	mov    %rcx,%rsi
  802bc4:	48 89 c7             	mov    %rax,%rdi
  802bc7:	48 b8 f8 44 80 00 00 	movabs $0x8044f8,%rax
  802bce:	00 00 00 
  802bd1:	ff d0                	callq  *%rax
	// allocate block
	if ((r = alloc_block()) < 0)
  802bd3:	48 b8 16 10 80 00 00 	movabs $0x801016,%rax
  802bda:	00 00 00 
  802bdd:	ff d0                	callq  *%rax
  802bdf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802be2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802be6:	79 30                	jns    802c18 <fs_test+0xd1>
		panic("alloc_block: %e", r);
  802be8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802beb:	89 c1                	mov    %eax,%ecx
  802bed:	48 ba 1b 77 80 00 00 	movabs $0x80771b,%rdx
  802bf4:	00 00 00 
  802bf7:	be 18 00 00 00       	mov    $0x18,%esi
  802bfc:	48 bf 11 77 80 00 00 	movabs $0x807711,%rdi
  802c03:	00 00 00 
  802c06:	b8 00 00 00 00       	mov    $0x0,%eax
  802c0b:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  802c12:	00 00 00 
  802c15:	41 ff d0             	callq  *%r8
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  802c18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c1b:	8d 50 1f             	lea    0x1f(%rax),%edx
  802c1e:	85 c0                	test   %eax,%eax
  802c20:	0f 48 c2             	cmovs  %edx,%eax
  802c23:	c1 f8 05             	sar    $0x5,%eax
  802c26:	48 98                	cltq   
  802c28:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  802c2f:	00 
  802c30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c34:	48 01 d0             	add    %rdx,%rax
  802c37:	8b 30                	mov    (%rax),%esi
  802c39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3c:	99                   	cltd   
  802c3d:	c1 ea 1b             	shr    $0x1b,%edx
  802c40:	01 d0                	add    %edx,%eax
  802c42:	83 e0 1f             	and    $0x1f,%eax
  802c45:	29 d0                	sub    %edx,%eax
  802c47:	ba 01 00 00 00       	mov    $0x1,%edx
  802c4c:	89 c1                	mov    %eax,%ecx
  802c4e:	d3 e2                	shl    %cl,%edx
  802c50:	89 d0                	mov    %edx,%eax
  802c52:	21 f0                	and    %esi,%eax
  802c54:	85 c0                	test   %eax,%eax
  802c56:	75 35                	jne    802c8d <fs_test+0x146>
  802c58:	48 b9 2b 77 80 00 00 	movabs $0x80772b,%rcx
  802c5f:	00 00 00 
  802c62:	48 ba 46 77 80 00 00 	movabs $0x807746,%rdx
  802c69:	00 00 00 
  802c6c:	be 1a 00 00 00       	mov    $0x1a,%esi
  802c71:	48 bf 11 77 80 00 00 	movabs $0x807711,%rdi
  802c78:	00 00 00 
  802c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c80:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  802c87:	00 00 00 
  802c8a:	41 ff d0             	callq  *%r8
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  802c8d:	48 b8 10 30 81 00 00 	movabs $0x813010,%rax
  802c94:	00 00 00 
  802c97:	48 8b 10             	mov    (%rax),%rdx
  802c9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9d:	8d 48 1f             	lea    0x1f(%rax),%ecx
  802ca0:	85 c0                	test   %eax,%eax
  802ca2:	0f 48 c1             	cmovs  %ecx,%eax
  802ca5:	c1 f8 05             	sar    $0x5,%eax
  802ca8:	48 98                	cltq   
  802caa:	48 c1 e0 02          	shl    $0x2,%rax
  802cae:	48 01 d0             	add    %rdx,%rax
  802cb1:	8b 30                	mov    (%rax),%esi
  802cb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb6:	99                   	cltd   
  802cb7:	c1 ea 1b             	shr    $0x1b,%edx
  802cba:	01 d0                	add    %edx,%eax
  802cbc:	83 e0 1f             	and    $0x1f,%eax
  802cbf:	29 d0                	sub    %edx,%eax
  802cc1:	ba 01 00 00 00       	mov    $0x1,%edx
  802cc6:	89 c1                	mov    %eax,%ecx
  802cc8:	d3 e2                	shl    %cl,%edx
  802cca:	89 d0                	mov    %edx,%eax
  802ccc:	21 f0                	and    %esi,%eax
  802cce:	85 c0                	test   %eax,%eax
  802cd0:	74 35                	je     802d07 <fs_test+0x1c0>
  802cd2:	48 b9 60 77 80 00 00 	movabs $0x807760,%rcx
  802cd9:	00 00 00 
  802cdc:	48 ba 46 77 80 00 00 	movabs $0x807746,%rdx
  802ce3:	00 00 00 
  802ce6:	be 1c 00 00 00       	mov    $0x1c,%esi
  802ceb:	48 bf 11 77 80 00 00 	movabs $0x807711,%rdi
  802cf2:	00 00 00 
  802cf5:	b8 00 00 00 00       	mov    $0x0,%eax
  802cfa:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  802d01:	00 00 00 
  802d04:	41 ff d0             	callq  *%r8
	cprintf("alloc_block is good\n");
  802d07:	48 bf 80 77 80 00 00 	movabs $0x807780,%rdi
  802d0e:	00 00 00 
  802d11:	b8 00 00 00 00       	mov    $0x0,%eax
  802d16:	48 ba 1f 36 80 00 00 	movabs $0x80361f,%rdx
  802d1d:	00 00 00 
  802d20:	ff d2                	callq  *%rdx

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  802d22:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802d26:	48 89 c6             	mov    %rax,%rsi
  802d29:	48 bf 95 77 80 00 00 	movabs $0x807795,%rdi
  802d30:	00 00 00 
  802d33:	48 b8 05 1b 80 00 00 	movabs $0x801b05,%rax
  802d3a:	00 00 00 
  802d3d:	ff d0                	callq  *%rax
  802d3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d46:	79 36                	jns    802d7e <fs_test+0x237>
  802d48:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  802d4c:	74 30                	je     802d7e <fs_test+0x237>
		panic("file_open /not-found: %e", r);
  802d4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d51:	89 c1                	mov    %eax,%ecx
  802d53:	48 ba a0 77 80 00 00 	movabs $0x8077a0,%rdx
  802d5a:	00 00 00 
  802d5d:	be 20 00 00 00       	mov    $0x20,%esi
  802d62:	48 bf 11 77 80 00 00 	movabs $0x807711,%rdi
  802d69:	00 00 00 
  802d6c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d71:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  802d78:	00 00 00 
  802d7b:	41 ff d0             	callq  *%r8
	else if (r == 0)
  802d7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d82:	75 2a                	jne    802dae <fs_test+0x267>
		panic("file_open /not-found succeeded!");
  802d84:	48 ba c0 77 80 00 00 	movabs $0x8077c0,%rdx
  802d8b:	00 00 00 
  802d8e:	be 22 00 00 00       	mov    $0x22,%esi
  802d93:	48 bf 11 77 80 00 00 	movabs $0x807711,%rdi
  802d9a:	00 00 00 
  802d9d:	b8 00 00 00 00       	mov    $0x0,%eax
  802da2:	48 b9 e6 33 80 00 00 	movabs $0x8033e6,%rcx
  802da9:	00 00 00 
  802dac:	ff d1                	callq  *%rcx
	if ((r = file_open("/newmotd", &f)) < 0)
  802dae:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802db2:	48 89 c6             	mov    %rax,%rsi
  802db5:	48 bf e0 77 80 00 00 	movabs $0x8077e0,%rdi
  802dbc:	00 00 00 
  802dbf:	48 b8 05 1b 80 00 00 	movabs $0x801b05,%rax
  802dc6:	00 00 00 
  802dc9:	ff d0                	callq  *%rax
  802dcb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd2:	79 30                	jns    802e04 <fs_test+0x2bd>
		panic("file_open /newmotd: %e", r);
  802dd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd7:	89 c1                	mov    %eax,%ecx
  802dd9:	48 ba e9 77 80 00 00 	movabs $0x8077e9,%rdx
  802de0:	00 00 00 
  802de3:	be 24 00 00 00       	mov    $0x24,%esi
  802de8:	48 bf 11 77 80 00 00 	movabs $0x807711,%rdi
  802def:	00 00 00 
  802df2:	b8 00 00 00 00       	mov    $0x0,%eax
  802df7:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  802dfe:	00 00 00 
  802e01:	41 ff d0             	callq  *%r8
	cprintf("file_open is good\n");
  802e04:	48 bf 00 78 80 00 00 	movabs $0x807800,%rdi
  802e0b:	00 00 00 
  802e0e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e13:	48 ba 1f 36 80 00 00 	movabs $0x80361f,%rdx
  802e1a:	00 00 00 
  802e1d:	ff d2                	callq  *%rdx

	if ((r = file_get_block(f, 0, &blk)) < 0)
  802e1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e23:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802e27:	be 00 00 00 00       	mov    $0x0,%esi
  802e2c:	48 89 c7             	mov    %rax,%rdi
  802e2f:	48 b8 43 14 80 00 00 	movabs $0x801443,%rax
  802e36:	00 00 00 
  802e39:	ff d0                	callq  *%rax
  802e3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e42:	79 30                	jns    802e74 <fs_test+0x32d>
		panic("file_get_block: %e", r);
  802e44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e47:	89 c1                	mov    %eax,%ecx
  802e49:	48 ba 13 78 80 00 00 	movabs $0x807813,%rdx
  802e50:	00 00 00 
  802e53:	be 28 00 00 00       	mov    $0x28,%esi
  802e58:	48 bf 11 77 80 00 00 	movabs $0x807711,%rdi
  802e5f:	00 00 00 
  802e62:	b8 00 00 00 00       	mov    $0x0,%eax
  802e67:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  802e6e:	00 00 00 
  802e71:	41 ff d0             	callq  *%r8
	if (strcmp(blk, msg) != 0)
  802e74:	48 b8 88 20 81 00 00 	movabs $0x812088,%rax
  802e7b:	00 00 00 
  802e7e:	48 8b 10             	mov    (%rax),%rdx
  802e81:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e85:	48 89 d6             	mov    %rdx,%rsi
  802e88:	48 89 c7             	mov    %rax,%rdi
  802e8b:	48 b8 36 43 80 00 00 	movabs $0x804336,%rax
  802e92:	00 00 00 
  802e95:	ff d0                	callq  *%rax
  802e97:	85 c0                	test   %eax,%eax
  802e99:	74 2a                	je     802ec5 <fs_test+0x37e>
		panic("file_get_block returned wrong data");
  802e9b:	48 ba 28 78 80 00 00 	movabs $0x807828,%rdx
  802ea2:	00 00 00 
  802ea5:	be 2a 00 00 00       	mov    $0x2a,%esi
  802eaa:	48 bf 11 77 80 00 00 	movabs $0x807711,%rdi
  802eb1:	00 00 00 
  802eb4:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb9:	48 b9 e6 33 80 00 00 	movabs $0x8033e6,%rcx
  802ec0:	00 00 00 
  802ec3:	ff d1                	callq  *%rcx
	cprintf("file_get_block is good\n");
  802ec5:	48 bf 4b 78 80 00 00 	movabs $0x80784b,%rdi
  802ecc:	00 00 00 
  802ecf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed4:	48 ba 1f 36 80 00 00 	movabs $0x80361f,%rdx
  802edb:	00 00 00 
  802ede:	ff d2                	callq  *%rdx

	*(volatile char*)blk = *(volatile char*)blk;
  802ee0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ee4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ee8:	0f b6 12             	movzbl (%rdx),%edx
  802eeb:	88 10                	mov    %dl,(%rax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  802eed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ef1:	48 c1 e8 0c          	shr    $0xc,%rax
  802ef5:	48 89 c2             	mov    %rax,%rdx
  802ef8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802eff:	01 00 00 
  802f02:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f06:	83 e0 40             	and    $0x40,%eax
  802f09:	48 85 c0             	test   %rax,%rax
  802f0c:	75 35                	jne    802f43 <fs_test+0x3fc>
  802f0e:	48 b9 63 78 80 00 00 	movabs $0x807863,%rcx
  802f15:	00 00 00 
  802f18:	48 ba 46 77 80 00 00 	movabs $0x807746,%rdx
  802f1f:	00 00 00 
  802f22:	be 2e 00 00 00       	mov    $0x2e,%esi
  802f27:	48 bf 11 77 80 00 00 	movabs $0x807711,%rdi
  802f2e:	00 00 00 
  802f31:	b8 00 00 00 00       	mov    $0x0,%eax
  802f36:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  802f3d:	00 00 00 
  802f40:	41 ff d0             	callq  *%r8
	file_flush(f);
  802f43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f47:	48 89 c7             	mov    %rax,%rdi
  802f4a:	48 b8 91 1f 80 00 00 	movabs $0x801f91,%rax
  802f51:	00 00 00 
  802f54:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  802f56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f5a:	48 c1 e8 0c          	shr    $0xc,%rax
  802f5e:	48 89 c2             	mov    %rax,%rdx
  802f61:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f68:	01 00 00 
  802f6b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f6f:	83 e0 40             	and    $0x40,%eax
  802f72:	48 85 c0             	test   %rax,%rax
  802f75:	74 35                	je     802fac <fs_test+0x465>
  802f77:	48 b9 7e 78 80 00 00 	movabs $0x80787e,%rcx
  802f7e:	00 00 00 
  802f81:	48 ba 46 77 80 00 00 	movabs $0x807746,%rdx
  802f88:	00 00 00 
  802f8b:	be 30 00 00 00       	mov    $0x30,%esi
  802f90:	48 bf 11 77 80 00 00 	movabs $0x807711,%rdi
  802f97:	00 00 00 
  802f9a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f9f:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  802fa6:	00 00 00 
  802fa9:	41 ff d0             	callq  *%r8
	cprintf("file_flush is good\n");
  802fac:	48 bf 9a 78 80 00 00 	movabs $0x80789a,%rdi
  802fb3:	00 00 00 
  802fb6:	b8 00 00 00 00       	mov    $0x0,%eax
  802fbb:	48 ba 1f 36 80 00 00 	movabs $0x80361f,%rdx
  802fc2:	00 00 00 
  802fc5:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, 0)) < 0)
  802fc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fcb:	be 00 00 00 00       	mov    $0x0,%esi
  802fd0:	48 89 c7             	mov    %rax,%rdi
  802fd3:	48 b8 34 1f 80 00 00 	movabs $0x801f34,%rax
  802fda:	00 00 00 
  802fdd:	ff d0                	callq  *%rax
  802fdf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fe2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe6:	79 30                	jns    803018 <fs_test+0x4d1>
		panic("file_set_size: %e", r);
  802fe8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802feb:	89 c1                	mov    %eax,%ecx
  802fed:	48 ba ae 78 80 00 00 	movabs $0x8078ae,%rdx
  802ff4:	00 00 00 
  802ff7:	be 34 00 00 00       	mov    $0x34,%esi
  802ffc:	48 bf 11 77 80 00 00 	movabs $0x807711,%rdi
  803003:	00 00 00 
  803006:	b8 00 00 00 00       	mov    $0x0,%eax
  80300b:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  803012:	00 00 00 
  803015:	41 ff d0             	callq  *%r8
	assert(f->f_direct[0] == 0);
  803018:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80301c:	8b 80 88 00 00 00    	mov    0x88(%rax),%eax
  803022:	85 c0                	test   %eax,%eax
  803024:	74 35                	je     80305b <fs_test+0x514>
  803026:	48 b9 c0 78 80 00 00 	movabs $0x8078c0,%rcx
  80302d:	00 00 00 
  803030:	48 ba 46 77 80 00 00 	movabs $0x807746,%rdx
  803037:	00 00 00 
  80303a:	be 35 00 00 00       	mov    $0x35,%esi
  80303f:	48 bf 11 77 80 00 00 	movabs $0x807711,%rdi
  803046:	00 00 00 
  803049:	b8 00 00 00 00       	mov    $0x0,%eax
  80304e:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  803055:	00 00 00 
  803058:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  80305b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80305f:	48 c1 e8 0c          	shr    $0xc,%rax
  803063:	48 89 c2             	mov    %rax,%rdx
  803066:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80306d:	01 00 00 
  803070:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803074:	83 e0 40             	and    $0x40,%eax
  803077:	48 85 c0             	test   %rax,%rax
  80307a:	74 35                	je     8030b1 <fs_test+0x56a>
  80307c:	48 b9 d4 78 80 00 00 	movabs $0x8078d4,%rcx
  803083:	00 00 00 
  803086:	48 ba 46 77 80 00 00 	movabs $0x807746,%rdx
  80308d:	00 00 00 
  803090:	be 36 00 00 00       	mov    $0x36,%esi
  803095:	48 bf 11 77 80 00 00 	movabs $0x807711,%rdi
  80309c:	00 00 00 
  80309f:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a4:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  8030ab:	00 00 00 
  8030ae:	41 ff d0             	callq  *%r8
	cprintf("file_truncate is good\n");
  8030b1:	48 bf ee 78 80 00 00 	movabs $0x8078ee,%rdi
  8030b8:	00 00 00 
  8030bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c0:	48 ba 1f 36 80 00 00 	movabs $0x80361f,%rdx
  8030c7:	00 00 00 
  8030ca:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, strlen(msg))) < 0)
  8030cc:	48 b8 88 20 81 00 00 	movabs $0x812088,%rax
  8030d3:	00 00 00 
  8030d6:	48 8b 00             	mov    (%rax),%rax
  8030d9:	48 89 c7             	mov    %rax,%rdi
  8030dc:	48 b8 68 41 80 00 00 	movabs $0x804168,%rax
  8030e3:	00 00 00 
  8030e6:	ff d0                	callq  *%rax
  8030e8:	89 c2                	mov    %eax,%edx
  8030ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ee:	89 d6                	mov    %edx,%esi
  8030f0:	48 89 c7             	mov    %rax,%rdi
  8030f3:	48 b8 34 1f 80 00 00 	movabs $0x801f34,%rax
  8030fa:	00 00 00 
  8030fd:	ff d0                	callq  *%rax
  8030ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803102:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803106:	79 30                	jns    803138 <fs_test+0x5f1>
		panic("file_set_size 2: %e", r);
  803108:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80310b:	89 c1                	mov    %eax,%ecx
  80310d:	48 ba 05 79 80 00 00 	movabs $0x807905,%rdx
  803114:	00 00 00 
  803117:	be 3a 00 00 00       	mov    $0x3a,%esi
  80311c:	48 bf 11 77 80 00 00 	movabs $0x807711,%rdi
  803123:	00 00 00 
  803126:	b8 00 00 00 00       	mov    $0x0,%eax
  80312b:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  803132:	00 00 00 
  803135:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  803138:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80313c:	48 c1 e8 0c          	shr    $0xc,%rax
  803140:	48 89 c2             	mov    %rax,%rdx
  803143:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80314a:	01 00 00 
  80314d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803151:	83 e0 40             	and    $0x40,%eax
  803154:	48 85 c0             	test   %rax,%rax
  803157:	74 35                	je     80318e <fs_test+0x647>
  803159:	48 b9 d4 78 80 00 00 	movabs $0x8078d4,%rcx
  803160:	00 00 00 
  803163:	48 ba 46 77 80 00 00 	movabs $0x807746,%rdx
  80316a:	00 00 00 
  80316d:	be 3b 00 00 00       	mov    $0x3b,%esi
  803172:	48 bf 11 77 80 00 00 	movabs $0x807711,%rdi
  803179:	00 00 00 
  80317c:	b8 00 00 00 00       	mov    $0x0,%eax
  803181:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  803188:	00 00 00 
  80318b:	41 ff d0             	callq  *%r8
	if ((r = file_get_block(f, 0, &blk)) < 0)
  80318e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803192:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  803196:	be 00 00 00 00       	mov    $0x0,%esi
  80319b:	48 89 c7             	mov    %rax,%rdi
  80319e:	48 b8 43 14 80 00 00 	movabs $0x801443,%rax
  8031a5:	00 00 00 
  8031a8:	ff d0                	callq  *%rax
  8031aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031b1:	79 30                	jns    8031e3 <fs_test+0x69c>
		panic("file_get_block 2: %e", r);
  8031b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b6:	89 c1                	mov    %eax,%ecx
  8031b8:	48 ba 19 79 80 00 00 	movabs $0x807919,%rdx
  8031bf:	00 00 00 
  8031c2:	be 3d 00 00 00       	mov    $0x3d,%esi
  8031c7:	48 bf 11 77 80 00 00 	movabs $0x807711,%rdi
  8031ce:	00 00 00 
  8031d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8031d6:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  8031dd:	00 00 00 
  8031e0:	41 ff d0             	callq  *%r8
	strcpy(blk, msg);
  8031e3:	48 b8 88 20 81 00 00 	movabs $0x812088,%rax
  8031ea:	00 00 00 
  8031ed:	48 8b 10             	mov    (%rax),%rdx
  8031f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031f4:	48 89 d6             	mov    %rdx,%rsi
  8031f7:	48 89 c7             	mov    %rax,%rdi
  8031fa:	48 b8 d4 41 80 00 00 	movabs $0x8041d4,%rax
  803201:	00 00 00 
  803204:	ff d0                	callq  *%rax
	assert((uvpt[PGNUM(blk)] & PTE_D));
  803206:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80320a:	48 c1 e8 0c          	shr    $0xc,%rax
  80320e:	48 89 c2             	mov    %rax,%rdx
  803211:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803218:	01 00 00 
  80321b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80321f:	83 e0 40             	and    $0x40,%eax
  803222:	48 85 c0             	test   %rax,%rax
  803225:	75 35                	jne    80325c <fs_test+0x715>
  803227:	48 b9 63 78 80 00 00 	movabs $0x807863,%rcx
  80322e:	00 00 00 
  803231:	48 ba 46 77 80 00 00 	movabs $0x807746,%rdx
  803238:	00 00 00 
  80323b:	be 3f 00 00 00       	mov    $0x3f,%esi
  803240:	48 bf 11 77 80 00 00 	movabs $0x807711,%rdi
  803247:	00 00 00 
  80324a:	b8 00 00 00 00       	mov    $0x0,%eax
  80324f:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  803256:	00 00 00 
  803259:	41 ff d0             	callq  *%r8
	file_flush(f);
  80325c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803260:	48 89 c7             	mov    %rax,%rdi
  803263:	48 b8 91 1f 80 00 00 	movabs $0x801f91,%rax
  80326a:	00 00 00 
  80326d:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  80326f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803273:	48 c1 e8 0c          	shr    $0xc,%rax
  803277:	48 89 c2             	mov    %rax,%rdx
  80327a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803281:	01 00 00 
  803284:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803288:	83 e0 40             	and    $0x40,%eax
  80328b:	48 85 c0             	test   %rax,%rax
  80328e:	74 35                	je     8032c5 <fs_test+0x77e>
  803290:	48 b9 7e 78 80 00 00 	movabs $0x80787e,%rcx
  803297:	00 00 00 
  80329a:	48 ba 46 77 80 00 00 	movabs $0x807746,%rdx
  8032a1:	00 00 00 
  8032a4:	be 41 00 00 00       	mov    $0x41,%esi
  8032a9:	48 bf 11 77 80 00 00 	movabs $0x807711,%rdi
  8032b0:	00 00 00 
  8032b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b8:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  8032bf:	00 00 00 
  8032c2:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8032c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032c9:	48 c1 e8 0c          	shr    $0xc,%rax
  8032cd:	48 89 c2             	mov    %rax,%rdx
  8032d0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8032d7:	01 00 00 
  8032da:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8032de:	83 e0 40             	and    $0x40,%eax
  8032e1:	48 85 c0             	test   %rax,%rax
  8032e4:	74 35                	je     80331b <fs_test+0x7d4>
  8032e6:	48 b9 d4 78 80 00 00 	movabs $0x8078d4,%rcx
  8032ed:	00 00 00 
  8032f0:	48 ba 46 77 80 00 00 	movabs $0x807746,%rdx
  8032f7:	00 00 00 
  8032fa:	be 42 00 00 00       	mov    $0x42,%esi
  8032ff:	48 bf 11 77 80 00 00 	movabs $0x807711,%rdi
  803306:	00 00 00 
  803309:	b8 00 00 00 00       	mov    $0x0,%eax
  80330e:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  803315:	00 00 00 
  803318:	41 ff d0             	callq  *%r8
	cprintf("file rewrite is good\n");
  80331b:	48 bf 2e 79 80 00 00 	movabs $0x80792e,%rdi
  803322:	00 00 00 
  803325:	b8 00 00 00 00       	mov    $0x0,%eax
  80332a:	48 ba 1f 36 80 00 00 	movabs $0x80361f,%rdx
  803331:	00 00 00 
  803334:	ff d2                	callq  *%rdx
}
  803336:	c9                   	leaveq 
  803337:	c3                   	retq   

0000000000803338 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  803338:	55                   	push   %rbp
  803339:	48 89 e5             	mov    %rsp,%rbp
  80333c:	48 83 ec 10          	sub    $0x10,%rsp
  803340:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803343:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  803347:	48 b8 87 4a 80 00 00 	movabs $0x804a87,%rax
  80334e:	00 00 00 
  803351:	ff d0                	callq  *%rax
  803353:	25 ff 03 00 00       	and    $0x3ff,%eax
  803358:	48 63 d0             	movslq %eax,%rdx
  80335b:	48 89 d0             	mov    %rdx,%rax
  80335e:	48 c1 e0 03          	shl    $0x3,%rax
  803362:	48 01 d0             	add    %rdx,%rax
  803365:	48 c1 e0 05          	shl    $0x5,%rax
  803369:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803370:	00 00 00 
  803373:	48 01 c2             	add    %rax,%rdx
  803376:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  80337d:	00 00 00 
  803380:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  803383:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803387:	7e 14                	jle    80339d <libmain+0x65>
		binaryname = argv[0];
  803389:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80338d:	48 8b 10             	mov    (%rax),%rdx
  803390:	48 b8 90 20 81 00 00 	movabs $0x812090,%rax
  803397:	00 00 00 
  80339a:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80339d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033a4:	48 89 d6             	mov    %rdx,%rsi
  8033a7:	89 c7                	mov    %eax,%edi
  8033a9:	48 b8 af 2a 80 00 00 	movabs $0x802aaf,%rax
  8033b0:	00 00 00 
  8033b3:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8033b5:	48 b8 c3 33 80 00 00 	movabs $0x8033c3,%rax
  8033bc:	00 00 00 
  8033bf:	ff d0                	callq  *%rax
}
  8033c1:	c9                   	leaveq 
  8033c2:	c3                   	retq   

00000000008033c3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8033c3:	55                   	push   %rbp
  8033c4:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8033c7:	48 b8 a5 54 80 00 00 	movabs $0x8054a5,%rax
  8033ce:	00 00 00 
  8033d1:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8033d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8033d8:	48 b8 43 4a 80 00 00 	movabs $0x804a43,%rax
  8033df:	00 00 00 
  8033e2:	ff d0                	callq  *%rax

}
  8033e4:	5d                   	pop    %rbp
  8033e5:	c3                   	retq   

00000000008033e6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8033e6:	55                   	push   %rbp
  8033e7:	48 89 e5             	mov    %rsp,%rbp
  8033ea:	53                   	push   %rbx
  8033eb:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8033f2:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8033f9:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8033ff:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803406:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80340d:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803414:	84 c0                	test   %al,%al
  803416:	74 23                	je     80343b <_panic+0x55>
  803418:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80341f:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803423:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803427:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80342b:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80342f:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803433:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803437:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80343b:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803442:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803449:	00 00 00 
  80344c:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803453:	00 00 00 
  803456:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80345a:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803461:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803468:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80346f:	48 b8 90 20 81 00 00 	movabs $0x812090,%rax
  803476:	00 00 00 
  803479:	48 8b 18             	mov    (%rax),%rbx
  80347c:	48 b8 87 4a 80 00 00 	movabs $0x804a87,%rax
  803483:	00 00 00 
  803486:	ff d0                	callq  *%rax
  803488:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80348e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803495:	41 89 c8             	mov    %ecx,%r8d
  803498:	48 89 d1             	mov    %rdx,%rcx
  80349b:	48 89 da             	mov    %rbx,%rdx
  80349e:	89 c6                	mov    %eax,%esi
  8034a0:	48 bf 50 79 80 00 00 	movabs $0x807950,%rdi
  8034a7:	00 00 00 
  8034aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8034af:	49 b9 1f 36 80 00 00 	movabs $0x80361f,%r9
  8034b6:	00 00 00 
  8034b9:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8034bc:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8034c3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8034ca:	48 89 d6             	mov    %rdx,%rsi
  8034cd:	48 89 c7             	mov    %rax,%rdi
  8034d0:	48 b8 73 35 80 00 00 	movabs $0x803573,%rax
  8034d7:	00 00 00 
  8034da:	ff d0                	callq  *%rax
	cprintf("\n");
  8034dc:	48 bf 73 79 80 00 00 	movabs $0x807973,%rdi
  8034e3:	00 00 00 
  8034e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8034eb:	48 ba 1f 36 80 00 00 	movabs $0x80361f,%rdx
  8034f2:	00 00 00 
  8034f5:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8034f7:	cc                   	int3   
  8034f8:	eb fd                	jmp    8034f7 <_panic+0x111>

00000000008034fa <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8034fa:	55                   	push   %rbp
  8034fb:	48 89 e5             	mov    %rsp,%rbp
  8034fe:	48 83 ec 10          	sub    $0x10,%rsp
  803502:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803505:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  803509:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80350d:	8b 00                	mov    (%rax),%eax
  80350f:	8d 48 01             	lea    0x1(%rax),%ecx
  803512:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803516:	89 0a                	mov    %ecx,(%rdx)
  803518:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80351b:	89 d1                	mov    %edx,%ecx
  80351d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803521:	48 98                	cltq   
  803523:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  803527:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80352b:	8b 00                	mov    (%rax),%eax
  80352d:	3d ff 00 00 00       	cmp    $0xff,%eax
  803532:	75 2c                	jne    803560 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  803534:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803538:	8b 00                	mov    (%rax),%eax
  80353a:	48 98                	cltq   
  80353c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803540:	48 83 c2 08          	add    $0x8,%rdx
  803544:	48 89 c6             	mov    %rax,%rsi
  803547:	48 89 d7             	mov    %rdx,%rdi
  80354a:	48 b8 bb 49 80 00 00 	movabs $0x8049bb,%rax
  803551:	00 00 00 
  803554:	ff d0                	callq  *%rax
        b->idx = 0;
  803556:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80355a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  803560:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803564:	8b 40 04             	mov    0x4(%rax),%eax
  803567:	8d 50 01             	lea    0x1(%rax),%edx
  80356a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80356e:	89 50 04             	mov    %edx,0x4(%rax)
}
  803571:	c9                   	leaveq 
  803572:	c3                   	retq   

0000000000803573 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  803573:	55                   	push   %rbp
  803574:	48 89 e5             	mov    %rsp,%rbp
  803577:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80357e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  803585:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80358c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  803593:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80359a:	48 8b 0a             	mov    (%rdx),%rcx
  80359d:	48 89 08             	mov    %rcx,(%rax)
  8035a0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8035a4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8035a8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8035ac:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8035b0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8035b7:	00 00 00 
    b.cnt = 0;
  8035ba:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8035c1:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8035c4:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8035cb:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8035d2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8035d9:	48 89 c6             	mov    %rax,%rsi
  8035dc:	48 bf fa 34 80 00 00 	movabs $0x8034fa,%rdi
  8035e3:	00 00 00 
  8035e6:	48 b8 d2 39 80 00 00 	movabs $0x8039d2,%rax
  8035ed:	00 00 00 
  8035f0:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8035f2:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8035f8:	48 98                	cltq   
  8035fa:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  803601:	48 83 c2 08          	add    $0x8,%rdx
  803605:	48 89 c6             	mov    %rax,%rsi
  803608:	48 89 d7             	mov    %rdx,%rdi
  80360b:	48 b8 bb 49 80 00 00 	movabs $0x8049bb,%rax
  803612:	00 00 00 
  803615:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  803617:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80361d:	c9                   	leaveq 
  80361e:	c3                   	retq   

000000000080361f <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80361f:	55                   	push   %rbp
  803620:	48 89 e5             	mov    %rsp,%rbp
  803623:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80362a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803631:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803638:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80363f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803646:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80364d:	84 c0                	test   %al,%al
  80364f:	74 20                	je     803671 <cprintf+0x52>
  803651:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803655:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803659:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80365d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803661:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803665:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803669:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80366d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803671:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  803678:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80367f:	00 00 00 
  803682:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803689:	00 00 00 
  80368c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803690:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803697:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80369e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8036a5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8036ac:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8036b3:	48 8b 0a             	mov    (%rdx),%rcx
  8036b6:	48 89 08             	mov    %rcx,(%rax)
  8036b9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8036bd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8036c1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8036c5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8036c9:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8036d0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8036d7:	48 89 d6             	mov    %rdx,%rsi
  8036da:	48 89 c7             	mov    %rax,%rdi
  8036dd:	48 b8 73 35 80 00 00 	movabs $0x803573,%rax
  8036e4:	00 00 00 
  8036e7:	ff d0                	callq  *%rax
  8036e9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8036ef:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8036f5:	c9                   	leaveq 
  8036f6:	c3                   	retq   

00000000008036f7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8036f7:	55                   	push   %rbp
  8036f8:	48 89 e5             	mov    %rsp,%rbp
  8036fb:	53                   	push   %rbx
  8036fc:	48 83 ec 38          	sub    $0x38,%rsp
  803700:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803704:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803708:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80370c:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80370f:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  803713:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  803717:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80371a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80371e:	77 3b                	ja     80375b <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  803720:	8b 45 d0             	mov    -0x30(%rbp),%eax
  803723:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  803727:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80372a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80372e:	ba 00 00 00 00       	mov    $0x0,%edx
  803733:	48 f7 f3             	div    %rbx
  803736:	48 89 c2             	mov    %rax,%rdx
  803739:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80373c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80373f:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  803743:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803747:	41 89 f9             	mov    %edi,%r9d
  80374a:	48 89 c7             	mov    %rax,%rdi
  80374d:	48 b8 f7 36 80 00 00 	movabs $0x8036f7,%rax
  803754:	00 00 00 
  803757:	ff d0                	callq  *%rax
  803759:	eb 1e                	jmp    803779 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80375b:	eb 12                	jmp    80376f <printnum+0x78>
			putch(padc, putdat);
  80375d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803761:	8b 55 cc             	mov    -0x34(%rbp),%edx
  803764:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803768:	48 89 ce             	mov    %rcx,%rsi
  80376b:	89 d7                	mov    %edx,%edi
  80376d:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80376f:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  803773:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  803777:	7f e4                	jg     80375d <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  803779:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80377c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803780:	ba 00 00 00 00       	mov    $0x0,%edx
  803785:	48 f7 f1             	div    %rcx
  803788:	48 89 d0             	mov    %rdx,%rax
  80378b:	48 ba 70 7b 80 00 00 	movabs $0x807b70,%rdx
  803792:	00 00 00 
  803795:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  803799:	0f be d0             	movsbl %al,%edx
  80379c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8037a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037a4:	48 89 ce             	mov    %rcx,%rsi
  8037a7:	89 d7                	mov    %edx,%edi
  8037a9:	ff d0                	callq  *%rax
}
  8037ab:	48 83 c4 38          	add    $0x38,%rsp
  8037af:	5b                   	pop    %rbx
  8037b0:	5d                   	pop    %rbp
  8037b1:	c3                   	retq   

00000000008037b2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8037b2:	55                   	push   %rbp
  8037b3:	48 89 e5             	mov    %rsp,%rbp
  8037b6:	48 83 ec 1c          	sub    $0x1c,%rsp
  8037ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037be:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8037c1:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8037c5:	7e 52                	jle    803819 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8037c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037cb:	8b 00                	mov    (%rax),%eax
  8037cd:	83 f8 30             	cmp    $0x30,%eax
  8037d0:	73 24                	jae    8037f6 <getuint+0x44>
  8037d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037d6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8037da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037de:	8b 00                	mov    (%rax),%eax
  8037e0:	89 c0                	mov    %eax,%eax
  8037e2:	48 01 d0             	add    %rdx,%rax
  8037e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037e9:	8b 12                	mov    (%rdx),%edx
  8037eb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8037ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037f2:	89 0a                	mov    %ecx,(%rdx)
  8037f4:	eb 17                	jmp    80380d <getuint+0x5b>
  8037f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037fa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8037fe:	48 89 d0             	mov    %rdx,%rax
  803801:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803805:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803809:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80380d:	48 8b 00             	mov    (%rax),%rax
  803810:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803814:	e9 a3 00 00 00       	jmpq   8038bc <getuint+0x10a>
	else if (lflag)
  803819:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80381d:	74 4f                	je     80386e <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80381f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803823:	8b 00                	mov    (%rax),%eax
  803825:	83 f8 30             	cmp    $0x30,%eax
  803828:	73 24                	jae    80384e <getuint+0x9c>
  80382a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80382e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803832:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803836:	8b 00                	mov    (%rax),%eax
  803838:	89 c0                	mov    %eax,%eax
  80383a:	48 01 d0             	add    %rdx,%rax
  80383d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803841:	8b 12                	mov    (%rdx),%edx
  803843:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803846:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80384a:	89 0a                	mov    %ecx,(%rdx)
  80384c:	eb 17                	jmp    803865 <getuint+0xb3>
  80384e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803852:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803856:	48 89 d0             	mov    %rdx,%rax
  803859:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80385d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803861:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803865:	48 8b 00             	mov    (%rax),%rax
  803868:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80386c:	eb 4e                	jmp    8038bc <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80386e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803872:	8b 00                	mov    (%rax),%eax
  803874:	83 f8 30             	cmp    $0x30,%eax
  803877:	73 24                	jae    80389d <getuint+0xeb>
  803879:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80387d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803881:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803885:	8b 00                	mov    (%rax),%eax
  803887:	89 c0                	mov    %eax,%eax
  803889:	48 01 d0             	add    %rdx,%rax
  80388c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803890:	8b 12                	mov    (%rdx),%edx
  803892:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803895:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803899:	89 0a                	mov    %ecx,(%rdx)
  80389b:	eb 17                	jmp    8038b4 <getuint+0x102>
  80389d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038a1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8038a5:	48 89 d0             	mov    %rdx,%rax
  8038a8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8038ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8038b0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8038b4:	8b 00                	mov    (%rax),%eax
  8038b6:	89 c0                	mov    %eax,%eax
  8038b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8038bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038c0:	c9                   	leaveq 
  8038c1:	c3                   	retq   

00000000008038c2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8038c2:	55                   	push   %rbp
  8038c3:	48 89 e5             	mov    %rsp,%rbp
  8038c6:	48 83 ec 1c          	sub    $0x1c,%rsp
  8038ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038ce:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8038d1:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8038d5:	7e 52                	jle    803929 <getint+0x67>
		x=va_arg(*ap, long long);
  8038d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038db:	8b 00                	mov    (%rax),%eax
  8038dd:	83 f8 30             	cmp    $0x30,%eax
  8038e0:	73 24                	jae    803906 <getint+0x44>
  8038e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038e6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8038ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038ee:	8b 00                	mov    (%rax),%eax
  8038f0:	89 c0                	mov    %eax,%eax
  8038f2:	48 01 d0             	add    %rdx,%rax
  8038f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8038f9:	8b 12                	mov    (%rdx),%edx
  8038fb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8038fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803902:	89 0a                	mov    %ecx,(%rdx)
  803904:	eb 17                	jmp    80391d <getint+0x5b>
  803906:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80390a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80390e:	48 89 d0             	mov    %rdx,%rax
  803911:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803915:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803919:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80391d:	48 8b 00             	mov    (%rax),%rax
  803920:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803924:	e9 a3 00 00 00       	jmpq   8039cc <getint+0x10a>
	else if (lflag)
  803929:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80392d:	74 4f                	je     80397e <getint+0xbc>
		x=va_arg(*ap, long);
  80392f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803933:	8b 00                	mov    (%rax),%eax
  803935:	83 f8 30             	cmp    $0x30,%eax
  803938:	73 24                	jae    80395e <getint+0x9c>
  80393a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80393e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803942:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803946:	8b 00                	mov    (%rax),%eax
  803948:	89 c0                	mov    %eax,%eax
  80394a:	48 01 d0             	add    %rdx,%rax
  80394d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803951:	8b 12                	mov    (%rdx),%edx
  803953:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803956:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80395a:	89 0a                	mov    %ecx,(%rdx)
  80395c:	eb 17                	jmp    803975 <getint+0xb3>
  80395e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803962:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803966:	48 89 d0             	mov    %rdx,%rax
  803969:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80396d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803971:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803975:	48 8b 00             	mov    (%rax),%rax
  803978:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80397c:	eb 4e                	jmp    8039cc <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80397e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803982:	8b 00                	mov    (%rax),%eax
  803984:	83 f8 30             	cmp    $0x30,%eax
  803987:	73 24                	jae    8039ad <getint+0xeb>
  803989:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80398d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803991:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803995:	8b 00                	mov    (%rax),%eax
  803997:	89 c0                	mov    %eax,%eax
  803999:	48 01 d0             	add    %rdx,%rax
  80399c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039a0:	8b 12                	mov    (%rdx),%edx
  8039a2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8039a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039a9:	89 0a                	mov    %ecx,(%rdx)
  8039ab:	eb 17                	jmp    8039c4 <getint+0x102>
  8039ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039b1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8039b5:	48 89 d0             	mov    %rdx,%rax
  8039b8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8039bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039c0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8039c4:	8b 00                	mov    (%rax),%eax
  8039c6:	48 98                	cltq   
  8039c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8039cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039d0:	c9                   	leaveq 
  8039d1:	c3                   	retq   

00000000008039d2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8039d2:	55                   	push   %rbp
  8039d3:	48 89 e5             	mov    %rsp,%rbp
  8039d6:	41 54                	push   %r12
  8039d8:	53                   	push   %rbx
  8039d9:	48 83 ec 60          	sub    $0x60,%rsp
  8039dd:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8039e1:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8039e5:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8039e9:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8039ed:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8039f1:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8039f5:	48 8b 0a             	mov    (%rdx),%rcx
  8039f8:	48 89 08             	mov    %rcx,(%rax)
  8039fb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8039ff:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803a03:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803a07:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803a0b:	eb 17                	jmp    803a24 <vprintfmt+0x52>
			if (ch == '\0')
  803a0d:	85 db                	test   %ebx,%ebx
  803a0f:	0f 84 cc 04 00 00    	je     803ee1 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  803a15:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803a19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803a1d:	48 89 d6             	mov    %rdx,%rsi
  803a20:	89 df                	mov    %ebx,%edi
  803a22:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803a24:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803a28:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803a2c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803a30:	0f b6 00             	movzbl (%rax),%eax
  803a33:	0f b6 d8             	movzbl %al,%ebx
  803a36:	83 fb 25             	cmp    $0x25,%ebx
  803a39:	75 d2                	jne    803a0d <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  803a3b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  803a3f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  803a46:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  803a4d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  803a54:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  803a5b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803a5f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803a63:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803a67:	0f b6 00             	movzbl (%rax),%eax
  803a6a:	0f b6 d8             	movzbl %al,%ebx
  803a6d:	8d 43 dd             	lea    -0x23(%rbx),%eax
  803a70:	83 f8 55             	cmp    $0x55,%eax
  803a73:	0f 87 34 04 00 00    	ja     803ead <vprintfmt+0x4db>
  803a79:	89 c0                	mov    %eax,%eax
  803a7b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803a82:	00 
  803a83:	48 b8 98 7b 80 00 00 	movabs $0x807b98,%rax
  803a8a:	00 00 00 
  803a8d:	48 01 d0             	add    %rdx,%rax
  803a90:	48 8b 00             	mov    (%rax),%rax
  803a93:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  803a95:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  803a99:	eb c0                	jmp    803a5b <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  803a9b:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  803a9f:	eb ba                	jmp    803a5b <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803aa1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  803aa8:	8b 55 d8             	mov    -0x28(%rbp),%edx
  803aab:	89 d0                	mov    %edx,%eax
  803aad:	c1 e0 02             	shl    $0x2,%eax
  803ab0:	01 d0                	add    %edx,%eax
  803ab2:	01 c0                	add    %eax,%eax
  803ab4:	01 d8                	add    %ebx,%eax
  803ab6:	83 e8 30             	sub    $0x30,%eax
  803ab9:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  803abc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803ac0:	0f b6 00             	movzbl (%rax),%eax
  803ac3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  803ac6:	83 fb 2f             	cmp    $0x2f,%ebx
  803ac9:	7e 0c                	jle    803ad7 <vprintfmt+0x105>
  803acb:	83 fb 39             	cmp    $0x39,%ebx
  803ace:	7f 07                	jg     803ad7 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803ad0:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  803ad5:	eb d1                	jmp    803aa8 <vprintfmt+0xd6>
			goto process_precision;
  803ad7:	eb 58                	jmp    803b31 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  803ad9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803adc:	83 f8 30             	cmp    $0x30,%eax
  803adf:	73 17                	jae    803af8 <vprintfmt+0x126>
  803ae1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803ae5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803ae8:	89 c0                	mov    %eax,%eax
  803aea:	48 01 d0             	add    %rdx,%rax
  803aed:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803af0:	83 c2 08             	add    $0x8,%edx
  803af3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803af6:	eb 0f                	jmp    803b07 <vprintfmt+0x135>
  803af8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803afc:	48 89 d0             	mov    %rdx,%rax
  803aff:	48 83 c2 08          	add    $0x8,%rdx
  803b03:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803b07:	8b 00                	mov    (%rax),%eax
  803b09:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  803b0c:	eb 23                	jmp    803b31 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  803b0e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803b12:	79 0c                	jns    803b20 <vprintfmt+0x14e>
				width = 0;
  803b14:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  803b1b:	e9 3b ff ff ff       	jmpq   803a5b <vprintfmt+0x89>
  803b20:	e9 36 ff ff ff       	jmpq   803a5b <vprintfmt+0x89>

		case '#':
			altflag = 1;
  803b25:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  803b2c:	e9 2a ff ff ff       	jmpq   803a5b <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  803b31:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803b35:	79 12                	jns    803b49 <vprintfmt+0x177>
				width = precision, precision = -1;
  803b37:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803b3a:	89 45 dc             	mov    %eax,-0x24(%rbp)
  803b3d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  803b44:	e9 12 ff ff ff       	jmpq   803a5b <vprintfmt+0x89>
  803b49:	e9 0d ff ff ff       	jmpq   803a5b <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  803b4e:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  803b52:	e9 04 ff ff ff       	jmpq   803a5b <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  803b57:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803b5a:	83 f8 30             	cmp    $0x30,%eax
  803b5d:	73 17                	jae    803b76 <vprintfmt+0x1a4>
  803b5f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803b63:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803b66:	89 c0                	mov    %eax,%eax
  803b68:	48 01 d0             	add    %rdx,%rax
  803b6b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803b6e:	83 c2 08             	add    $0x8,%edx
  803b71:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803b74:	eb 0f                	jmp    803b85 <vprintfmt+0x1b3>
  803b76:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803b7a:	48 89 d0             	mov    %rdx,%rax
  803b7d:	48 83 c2 08          	add    $0x8,%rdx
  803b81:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803b85:	8b 10                	mov    (%rax),%edx
  803b87:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803b8b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b8f:	48 89 ce             	mov    %rcx,%rsi
  803b92:	89 d7                	mov    %edx,%edi
  803b94:	ff d0                	callq  *%rax
			break;
  803b96:	e9 40 03 00 00       	jmpq   803edb <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  803b9b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803b9e:	83 f8 30             	cmp    $0x30,%eax
  803ba1:	73 17                	jae    803bba <vprintfmt+0x1e8>
  803ba3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803ba7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803baa:	89 c0                	mov    %eax,%eax
  803bac:	48 01 d0             	add    %rdx,%rax
  803baf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803bb2:	83 c2 08             	add    $0x8,%edx
  803bb5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803bb8:	eb 0f                	jmp    803bc9 <vprintfmt+0x1f7>
  803bba:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803bbe:	48 89 d0             	mov    %rdx,%rax
  803bc1:	48 83 c2 08          	add    $0x8,%rdx
  803bc5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803bc9:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  803bcb:	85 db                	test   %ebx,%ebx
  803bcd:	79 02                	jns    803bd1 <vprintfmt+0x1ff>
				err = -err;
  803bcf:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  803bd1:	83 fb 15             	cmp    $0x15,%ebx
  803bd4:	7f 16                	jg     803bec <vprintfmt+0x21a>
  803bd6:	48 b8 c0 7a 80 00 00 	movabs $0x807ac0,%rax
  803bdd:	00 00 00 
  803be0:	48 63 d3             	movslq %ebx,%rdx
  803be3:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  803be7:	4d 85 e4             	test   %r12,%r12
  803bea:	75 2e                	jne    803c1a <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  803bec:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803bf0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803bf4:	89 d9                	mov    %ebx,%ecx
  803bf6:	48 ba 81 7b 80 00 00 	movabs $0x807b81,%rdx
  803bfd:	00 00 00 
  803c00:	48 89 c7             	mov    %rax,%rdi
  803c03:	b8 00 00 00 00       	mov    $0x0,%eax
  803c08:	49 b8 ea 3e 80 00 00 	movabs $0x803eea,%r8
  803c0f:	00 00 00 
  803c12:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  803c15:	e9 c1 02 00 00       	jmpq   803edb <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  803c1a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803c1e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803c22:	4c 89 e1             	mov    %r12,%rcx
  803c25:	48 ba 8a 7b 80 00 00 	movabs $0x807b8a,%rdx
  803c2c:	00 00 00 
  803c2f:	48 89 c7             	mov    %rax,%rdi
  803c32:	b8 00 00 00 00       	mov    $0x0,%eax
  803c37:	49 b8 ea 3e 80 00 00 	movabs $0x803eea,%r8
  803c3e:	00 00 00 
  803c41:	41 ff d0             	callq  *%r8
			break;
  803c44:	e9 92 02 00 00       	jmpq   803edb <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  803c49:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803c4c:	83 f8 30             	cmp    $0x30,%eax
  803c4f:	73 17                	jae    803c68 <vprintfmt+0x296>
  803c51:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803c55:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803c58:	89 c0                	mov    %eax,%eax
  803c5a:	48 01 d0             	add    %rdx,%rax
  803c5d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803c60:	83 c2 08             	add    $0x8,%edx
  803c63:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803c66:	eb 0f                	jmp    803c77 <vprintfmt+0x2a5>
  803c68:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803c6c:	48 89 d0             	mov    %rdx,%rax
  803c6f:	48 83 c2 08          	add    $0x8,%rdx
  803c73:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803c77:	4c 8b 20             	mov    (%rax),%r12
  803c7a:	4d 85 e4             	test   %r12,%r12
  803c7d:	75 0a                	jne    803c89 <vprintfmt+0x2b7>
				p = "(null)";
  803c7f:	49 bc 8d 7b 80 00 00 	movabs $0x807b8d,%r12
  803c86:	00 00 00 
			if (width > 0 && padc != '-')
  803c89:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803c8d:	7e 3f                	jle    803cce <vprintfmt+0x2fc>
  803c8f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  803c93:	74 39                	je     803cce <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  803c95:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803c98:	48 98                	cltq   
  803c9a:	48 89 c6             	mov    %rax,%rsi
  803c9d:	4c 89 e7             	mov    %r12,%rdi
  803ca0:	48 b8 96 41 80 00 00 	movabs $0x804196,%rax
  803ca7:	00 00 00 
  803caa:	ff d0                	callq  *%rax
  803cac:	29 45 dc             	sub    %eax,-0x24(%rbp)
  803caf:	eb 17                	jmp    803cc8 <vprintfmt+0x2f6>
					putch(padc, putdat);
  803cb1:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  803cb5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803cb9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803cbd:	48 89 ce             	mov    %rcx,%rsi
  803cc0:	89 d7                	mov    %edx,%edi
  803cc2:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  803cc4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803cc8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803ccc:	7f e3                	jg     803cb1 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803cce:	eb 37                	jmp    803d07 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  803cd0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  803cd4:	74 1e                	je     803cf4 <vprintfmt+0x322>
  803cd6:	83 fb 1f             	cmp    $0x1f,%ebx
  803cd9:	7e 05                	jle    803ce0 <vprintfmt+0x30e>
  803cdb:	83 fb 7e             	cmp    $0x7e,%ebx
  803cde:	7e 14                	jle    803cf4 <vprintfmt+0x322>
					putch('?', putdat);
  803ce0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803ce4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803ce8:	48 89 d6             	mov    %rdx,%rsi
  803ceb:	bf 3f 00 00 00       	mov    $0x3f,%edi
  803cf0:	ff d0                	callq  *%rax
  803cf2:	eb 0f                	jmp    803d03 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  803cf4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803cf8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803cfc:	48 89 d6             	mov    %rdx,%rsi
  803cff:	89 df                	mov    %ebx,%edi
  803d01:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803d03:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803d07:	4c 89 e0             	mov    %r12,%rax
  803d0a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  803d0e:	0f b6 00             	movzbl (%rax),%eax
  803d11:	0f be d8             	movsbl %al,%ebx
  803d14:	85 db                	test   %ebx,%ebx
  803d16:	74 10                	je     803d28 <vprintfmt+0x356>
  803d18:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803d1c:	78 b2                	js     803cd0 <vprintfmt+0x2fe>
  803d1e:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  803d22:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803d26:	79 a8                	jns    803cd0 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803d28:	eb 16                	jmp    803d40 <vprintfmt+0x36e>
				putch(' ', putdat);
  803d2a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803d2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803d32:	48 89 d6             	mov    %rdx,%rsi
  803d35:	bf 20 00 00 00       	mov    $0x20,%edi
  803d3a:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803d3c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803d40:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803d44:	7f e4                	jg     803d2a <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  803d46:	e9 90 01 00 00       	jmpq   803edb <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  803d4b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803d4f:	be 03 00 00 00       	mov    $0x3,%esi
  803d54:	48 89 c7             	mov    %rax,%rdi
  803d57:	48 b8 c2 38 80 00 00 	movabs $0x8038c2,%rax
  803d5e:	00 00 00 
  803d61:	ff d0                	callq  *%rax
  803d63:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  803d67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d6b:	48 85 c0             	test   %rax,%rax
  803d6e:	79 1d                	jns    803d8d <vprintfmt+0x3bb>
				putch('-', putdat);
  803d70:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803d74:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803d78:	48 89 d6             	mov    %rdx,%rsi
  803d7b:	bf 2d 00 00 00       	mov    $0x2d,%edi
  803d80:	ff d0                	callq  *%rax
				num = -(long long) num;
  803d82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d86:	48 f7 d8             	neg    %rax
  803d89:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  803d8d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803d94:	e9 d5 00 00 00       	jmpq   803e6e <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  803d99:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803d9d:	be 03 00 00 00       	mov    $0x3,%esi
  803da2:	48 89 c7             	mov    %rax,%rdi
  803da5:	48 b8 b2 37 80 00 00 	movabs $0x8037b2,%rax
  803dac:	00 00 00 
  803daf:	ff d0                	callq  *%rax
  803db1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  803db5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803dbc:	e9 ad 00 00 00       	jmpq   803e6e <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  803dc1:	8b 55 e0             	mov    -0x20(%rbp),%edx
  803dc4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803dc8:	89 d6                	mov    %edx,%esi
  803dca:	48 89 c7             	mov    %rax,%rdi
  803dcd:	48 b8 c2 38 80 00 00 	movabs $0x8038c2,%rax
  803dd4:	00 00 00 
  803dd7:	ff d0                	callq  *%rax
  803dd9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  803ddd:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  803de4:	e9 85 00 00 00       	jmpq   803e6e <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  803de9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803ded:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803df1:	48 89 d6             	mov    %rdx,%rsi
  803df4:	bf 30 00 00 00       	mov    $0x30,%edi
  803df9:	ff d0                	callq  *%rax
			putch('x', putdat);
  803dfb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803dff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803e03:	48 89 d6             	mov    %rdx,%rsi
  803e06:	bf 78 00 00 00       	mov    $0x78,%edi
  803e0b:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803e0d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803e10:	83 f8 30             	cmp    $0x30,%eax
  803e13:	73 17                	jae    803e2c <vprintfmt+0x45a>
  803e15:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803e19:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803e1c:	89 c0                	mov    %eax,%eax
  803e1e:	48 01 d0             	add    %rdx,%rax
  803e21:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803e24:	83 c2 08             	add    $0x8,%edx
  803e27:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803e2a:	eb 0f                	jmp    803e3b <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  803e2c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803e30:	48 89 d0             	mov    %rdx,%rax
  803e33:	48 83 c2 08          	add    $0x8,%rdx
  803e37:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803e3b:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803e3e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  803e42:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  803e49:	eb 23                	jmp    803e6e <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  803e4b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803e4f:	be 03 00 00 00       	mov    $0x3,%esi
  803e54:	48 89 c7             	mov    %rax,%rdi
  803e57:	48 b8 b2 37 80 00 00 	movabs $0x8037b2,%rax
  803e5e:	00 00 00 
  803e61:	ff d0                	callq  *%rax
  803e63:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  803e67:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  803e6e:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  803e73:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803e76:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803e79:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803e7d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803e81:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803e85:	45 89 c1             	mov    %r8d,%r9d
  803e88:	41 89 f8             	mov    %edi,%r8d
  803e8b:	48 89 c7             	mov    %rax,%rdi
  803e8e:	48 b8 f7 36 80 00 00 	movabs $0x8036f7,%rax
  803e95:	00 00 00 
  803e98:	ff d0                	callq  *%rax
			break;
  803e9a:	eb 3f                	jmp    803edb <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  803e9c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803ea0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803ea4:	48 89 d6             	mov    %rdx,%rsi
  803ea7:	89 df                	mov    %ebx,%edi
  803ea9:	ff d0                	callq  *%rax
			break;
  803eab:	eb 2e                	jmp    803edb <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  803ead:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803eb1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803eb5:	48 89 d6             	mov    %rdx,%rsi
  803eb8:	bf 25 00 00 00       	mov    $0x25,%edi
  803ebd:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  803ebf:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803ec4:	eb 05                	jmp    803ecb <vprintfmt+0x4f9>
  803ec6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803ecb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803ecf:	48 83 e8 01          	sub    $0x1,%rax
  803ed3:	0f b6 00             	movzbl (%rax),%eax
  803ed6:	3c 25                	cmp    $0x25,%al
  803ed8:	75 ec                	jne    803ec6 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  803eda:	90                   	nop
		}
	}
  803edb:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803edc:	e9 43 fb ff ff       	jmpq   803a24 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  803ee1:	48 83 c4 60          	add    $0x60,%rsp
  803ee5:	5b                   	pop    %rbx
  803ee6:	41 5c                	pop    %r12
  803ee8:	5d                   	pop    %rbp
  803ee9:	c3                   	retq   

0000000000803eea <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  803eea:	55                   	push   %rbp
  803eeb:	48 89 e5             	mov    %rsp,%rbp
  803eee:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  803ef5:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803efc:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  803f03:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803f0a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803f11:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803f18:	84 c0                	test   %al,%al
  803f1a:	74 20                	je     803f3c <printfmt+0x52>
  803f1c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803f20:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803f24:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803f28:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803f2c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803f30:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803f34:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803f38:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803f3c:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803f43:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  803f4a:	00 00 00 
  803f4d:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  803f54:	00 00 00 
  803f57:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803f5b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  803f62:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803f69:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  803f70:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  803f77:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803f7e:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  803f85:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803f8c:	48 89 c7             	mov    %rax,%rdi
  803f8f:	48 b8 d2 39 80 00 00 	movabs $0x8039d2,%rax
  803f96:	00 00 00 
  803f99:	ff d0                	callq  *%rax
	va_end(ap);
}
  803f9b:	c9                   	leaveq 
  803f9c:	c3                   	retq   

0000000000803f9d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  803f9d:	55                   	push   %rbp
  803f9e:	48 89 e5             	mov    %rsp,%rbp
  803fa1:	48 83 ec 10          	sub    $0x10,%rsp
  803fa5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803fa8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803fac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fb0:	8b 40 10             	mov    0x10(%rax),%eax
  803fb3:	8d 50 01             	lea    0x1(%rax),%edx
  803fb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fba:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  803fbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fc1:	48 8b 10             	mov    (%rax),%rdx
  803fc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fc8:	48 8b 40 08          	mov    0x8(%rax),%rax
  803fcc:	48 39 c2             	cmp    %rax,%rdx
  803fcf:	73 17                	jae    803fe8 <sprintputch+0x4b>
		*b->buf++ = ch;
  803fd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fd5:	48 8b 00             	mov    (%rax),%rax
  803fd8:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803fdc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803fe0:	48 89 0a             	mov    %rcx,(%rdx)
  803fe3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803fe6:	88 10                	mov    %dl,(%rax)
}
  803fe8:	c9                   	leaveq 
  803fe9:	c3                   	retq   

0000000000803fea <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803fea:	55                   	push   %rbp
  803feb:	48 89 e5             	mov    %rsp,%rbp
  803fee:	48 83 ec 50          	sub    $0x50,%rsp
  803ff2:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803ff6:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  803ff9:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  803ffd:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  804001:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  804005:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  804009:	48 8b 0a             	mov    (%rdx),%rcx
  80400c:	48 89 08             	mov    %rcx,(%rax)
  80400f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  804013:	48 89 48 08          	mov    %rcx,0x8(%rax)
  804017:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80401b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80401f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804023:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  804027:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80402a:	48 98                	cltq   
  80402c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  804030:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804034:	48 01 d0             	add    %rdx,%rax
  804037:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80403b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  804042:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  804047:	74 06                	je     80404f <vsnprintf+0x65>
  804049:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80404d:	7f 07                	jg     804056 <vsnprintf+0x6c>
		return -E_INVAL;
  80404f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  804054:	eb 2f                	jmp    804085 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  804056:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80405a:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80405e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804062:	48 89 c6             	mov    %rax,%rsi
  804065:	48 bf 9d 3f 80 00 00 	movabs $0x803f9d,%rdi
  80406c:	00 00 00 
  80406f:	48 b8 d2 39 80 00 00 	movabs $0x8039d2,%rax
  804076:	00 00 00 
  804079:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80407b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80407f:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  804082:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  804085:	c9                   	leaveq 
  804086:	c3                   	retq   

0000000000804087 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  804087:	55                   	push   %rbp
  804088:	48 89 e5             	mov    %rsp,%rbp
  80408b:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  804092:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  804099:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80409f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8040a6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8040ad:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8040b4:	84 c0                	test   %al,%al
  8040b6:	74 20                	je     8040d8 <snprintf+0x51>
  8040b8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8040bc:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8040c0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8040c4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8040c8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8040cc:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8040d0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8040d4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8040d8:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8040df:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8040e6:	00 00 00 
  8040e9:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8040f0:	00 00 00 
  8040f3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8040f7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8040fe:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804105:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80410c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  804113:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80411a:	48 8b 0a             	mov    (%rdx),%rcx
  80411d:	48 89 08             	mov    %rcx,(%rax)
  804120:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  804124:	48 89 48 08          	mov    %rcx,0x8(%rax)
  804128:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80412c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  804130:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  804137:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80413e:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  804144:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80414b:	48 89 c7             	mov    %rax,%rdi
  80414e:	48 b8 ea 3f 80 00 00 	movabs $0x803fea,%rax
  804155:	00 00 00 
  804158:	ff d0                	callq  *%rax
  80415a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  804160:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  804166:	c9                   	leaveq 
  804167:	c3                   	retq   

0000000000804168 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  804168:	55                   	push   %rbp
  804169:	48 89 e5             	mov    %rsp,%rbp
  80416c:	48 83 ec 18          	sub    $0x18,%rsp
  804170:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  804174:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80417b:	eb 09                	jmp    804186 <strlen+0x1e>
		n++;
  80417d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  804181:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  804186:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80418a:	0f b6 00             	movzbl (%rax),%eax
  80418d:	84 c0                	test   %al,%al
  80418f:	75 ec                	jne    80417d <strlen+0x15>
		n++;
	return n;
  804191:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804194:	c9                   	leaveq 
  804195:	c3                   	retq   

0000000000804196 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  804196:	55                   	push   %rbp
  804197:	48 89 e5             	mov    %rsp,%rbp
  80419a:	48 83 ec 20          	sub    $0x20,%rsp
  80419e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041a2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8041a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8041ad:	eb 0e                	jmp    8041bd <strnlen+0x27>
		n++;
  8041af:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8041b3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8041b8:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8041bd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8041c2:	74 0b                	je     8041cf <strnlen+0x39>
  8041c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041c8:	0f b6 00             	movzbl (%rax),%eax
  8041cb:	84 c0                	test   %al,%al
  8041cd:	75 e0                	jne    8041af <strnlen+0x19>
		n++;
	return n;
  8041cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8041d2:	c9                   	leaveq 
  8041d3:	c3                   	retq   

00000000008041d4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8041d4:	55                   	push   %rbp
  8041d5:	48 89 e5             	mov    %rsp,%rbp
  8041d8:	48 83 ec 20          	sub    $0x20,%rsp
  8041dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8041e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8041ec:	90                   	nop
  8041ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041f1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8041f5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8041f9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8041fd:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  804201:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  804205:	0f b6 12             	movzbl (%rdx),%edx
  804208:	88 10                	mov    %dl,(%rax)
  80420a:	0f b6 00             	movzbl (%rax),%eax
  80420d:	84 c0                	test   %al,%al
  80420f:	75 dc                	jne    8041ed <strcpy+0x19>
		/* do nothing */;
	return ret;
  804211:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804215:	c9                   	leaveq 
  804216:	c3                   	retq   

0000000000804217 <strcat>:

char *
strcat(char *dst, const char *src)
{
  804217:	55                   	push   %rbp
  804218:	48 89 e5             	mov    %rsp,%rbp
  80421b:	48 83 ec 20          	sub    $0x20,%rsp
  80421f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804223:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  804227:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80422b:	48 89 c7             	mov    %rax,%rdi
  80422e:	48 b8 68 41 80 00 00 	movabs $0x804168,%rax
  804235:	00 00 00 
  804238:	ff d0                	callq  *%rax
  80423a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80423d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804240:	48 63 d0             	movslq %eax,%rdx
  804243:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804247:	48 01 c2             	add    %rax,%rdx
  80424a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80424e:	48 89 c6             	mov    %rax,%rsi
  804251:	48 89 d7             	mov    %rdx,%rdi
  804254:	48 b8 d4 41 80 00 00 	movabs $0x8041d4,%rax
  80425b:	00 00 00 
  80425e:	ff d0                	callq  *%rax
	return dst;
  804260:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804264:	c9                   	leaveq 
  804265:	c3                   	retq   

0000000000804266 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  804266:	55                   	push   %rbp
  804267:	48 89 e5             	mov    %rsp,%rbp
  80426a:	48 83 ec 28          	sub    $0x28,%rsp
  80426e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804272:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804276:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80427a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80427e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  804282:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804289:	00 
  80428a:	eb 2a                	jmp    8042b6 <strncpy+0x50>
		*dst++ = *src;
  80428c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804290:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804294:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804298:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80429c:	0f b6 12             	movzbl (%rdx),%edx
  80429f:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8042a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042a5:	0f b6 00             	movzbl (%rax),%eax
  8042a8:	84 c0                	test   %al,%al
  8042aa:	74 05                	je     8042b1 <strncpy+0x4b>
			src++;
  8042ac:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8042b1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8042b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042ba:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8042be:	72 cc                	jb     80428c <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8042c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8042c4:	c9                   	leaveq 
  8042c5:	c3                   	retq   

00000000008042c6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8042c6:	55                   	push   %rbp
  8042c7:	48 89 e5             	mov    %rsp,%rbp
  8042ca:	48 83 ec 28          	sub    $0x28,%rsp
  8042ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8042d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8042d6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8042da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8042e2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8042e7:	74 3d                	je     804326 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8042e9:	eb 1d                	jmp    804308 <strlcpy+0x42>
			*dst++ = *src++;
  8042eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042ef:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8042f3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8042f7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8042fb:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8042ff:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  804303:	0f b6 12             	movzbl (%rdx),%edx
  804306:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  804308:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80430d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804312:	74 0b                	je     80431f <strlcpy+0x59>
  804314:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804318:	0f b6 00             	movzbl (%rax),%eax
  80431b:	84 c0                	test   %al,%al
  80431d:	75 cc                	jne    8042eb <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80431f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804323:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  804326:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80432a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80432e:	48 29 c2             	sub    %rax,%rdx
  804331:	48 89 d0             	mov    %rdx,%rax
}
  804334:	c9                   	leaveq 
  804335:	c3                   	retq   

0000000000804336 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  804336:	55                   	push   %rbp
  804337:	48 89 e5             	mov    %rsp,%rbp
  80433a:	48 83 ec 10          	sub    $0x10,%rsp
  80433e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804342:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  804346:	eb 0a                	jmp    804352 <strcmp+0x1c>
		p++, q++;
  804348:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80434d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  804352:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804356:	0f b6 00             	movzbl (%rax),%eax
  804359:	84 c0                	test   %al,%al
  80435b:	74 12                	je     80436f <strcmp+0x39>
  80435d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804361:	0f b6 10             	movzbl (%rax),%edx
  804364:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804368:	0f b6 00             	movzbl (%rax),%eax
  80436b:	38 c2                	cmp    %al,%dl
  80436d:	74 d9                	je     804348 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80436f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804373:	0f b6 00             	movzbl (%rax),%eax
  804376:	0f b6 d0             	movzbl %al,%edx
  804379:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80437d:	0f b6 00             	movzbl (%rax),%eax
  804380:	0f b6 c0             	movzbl %al,%eax
  804383:	29 c2                	sub    %eax,%edx
  804385:	89 d0                	mov    %edx,%eax
}
  804387:	c9                   	leaveq 
  804388:	c3                   	retq   

0000000000804389 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  804389:	55                   	push   %rbp
  80438a:	48 89 e5             	mov    %rsp,%rbp
  80438d:	48 83 ec 18          	sub    $0x18,%rsp
  804391:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804395:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804399:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80439d:	eb 0f                	jmp    8043ae <strncmp+0x25>
		n--, p++, q++;
  80439f:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8043a4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8043a9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8043ae:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8043b3:	74 1d                	je     8043d2 <strncmp+0x49>
  8043b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043b9:	0f b6 00             	movzbl (%rax),%eax
  8043bc:	84 c0                	test   %al,%al
  8043be:	74 12                	je     8043d2 <strncmp+0x49>
  8043c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043c4:	0f b6 10             	movzbl (%rax),%edx
  8043c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043cb:	0f b6 00             	movzbl (%rax),%eax
  8043ce:	38 c2                	cmp    %al,%dl
  8043d0:	74 cd                	je     80439f <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8043d2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8043d7:	75 07                	jne    8043e0 <strncmp+0x57>
		return 0;
  8043d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8043de:	eb 18                	jmp    8043f8 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8043e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043e4:	0f b6 00             	movzbl (%rax),%eax
  8043e7:	0f b6 d0             	movzbl %al,%edx
  8043ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043ee:	0f b6 00             	movzbl (%rax),%eax
  8043f1:	0f b6 c0             	movzbl %al,%eax
  8043f4:	29 c2                	sub    %eax,%edx
  8043f6:	89 d0                	mov    %edx,%eax
}
  8043f8:	c9                   	leaveq 
  8043f9:	c3                   	retq   

00000000008043fa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8043fa:	55                   	push   %rbp
  8043fb:	48 89 e5             	mov    %rsp,%rbp
  8043fe:	48 83 ec 0c          	sub    $0xc,%rsp
  804402:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804406:	89 f0                	mov    %esi,%eax
  804408:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80440b:	eb 17                	jmp    804424 <strchr+0x2a>
		if (*s == c)
  80440d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804411:	0f b6 00             	movzbl (%rax),%eax
  804414:	3a 45 f4             	cmp    -0xc(%rbp),%al
  804417:	75 06                	jne    80441f <strchr+0x25>
			return (char *) s;
  804419:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80441d:	eb 15                	jmp    804434 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80441f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804424:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804428:	0f b6 00             	movzbl (%rax),%eax
  80442b:	84 c0                	test   %al,%al
  80442d:	75 de                	jne    80440d <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80442f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804434:	c9                   	leaveq 
  804435:	c3                   	retq   

0000000000804436 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  804436:	55                   	push   %rbp
  804437:	48 89 e5             	mov    %rsp,%rbp
  80443a:	48 83 ec 0c          	sub    $0xc,%rsp
  80443e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804442:	89 f0                	mov    %esi,%eax
  804444:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  804447:	eb 13                	jmp    80445c <strfind+0x26>
		if (*s == c)
  804449:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80444d:	0f b6 00             	movzbl (%rax),%eax
  804450:	3a 45 f4             	cmp    -0xc(%rbp),%al
  804453:	75 02                	jne    804457 <strfind+0x21>
			break;
  804455:	eb 10                	jmp    804467 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  804457:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80445c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804460:	0f b6 00             	movzbl (%rax),%eax
  804463:	84 c0                	test   %al,%al
  804465:	75 e2                	jne    804449 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  804467:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80446b:	c9                   	leaveq 
  80446c:	c3                   	retq   

000000000080446d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80446d:	55                   	push   %rbp
  80446e:	48 89 e5             	mov    %rsp,%rbp
  804471:	48 83 ec 18          	sub    $0x18,%rsp
  804475:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804479:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80447c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  804480:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804485:	75 06                	jne    80448d <memset+0x20>
		return v;
  804487:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80448b:	eb 69                	jmp    8044f6 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80448d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804491:	83 e0 03             	and    $0x3,%eax
  804494:	48 85 c0             	test   %rax,%rax
  804497:	75 48                	jne    8044e1 <memset+0x74>
  804499:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80449d:	83 e0 03             	and    $0x3,%eax
  8044a0:	48 85 c0             	test   %rax,%rax
  8044a3:	75 3c                	jne    8044e1 <memset+0x74>
		c &= 0xFF;
  8044a5:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8044ac:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8044af:	c1 e0 18             	shl    $0x18,%eax
  8044b2:	89 c2                	mov    %eax,%edx
  8044b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8044b7:	c1 e0 10             	shl    $0x10,%eax
  8044ba:	09 c2                	or     %eax,%edx
  8044bc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8044bf:	c1 e0 08             	shl    $0x8,%eax
  8044c2:	09 d0                	or     %edx,%eax
  8044c4:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8044c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044cb:	48 c1 e8 02          	shr    $0x2,%rax
  8044cf:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8044d2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8044d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8044d9:	48 89 d7             	mov    %rdx,%rdi
  8044dc:	fc                   	cld    
  8044dd:	f3 ab                	rep stos %eax,%es:(%rdi)
  8044df:	eb 11                	jmp    8044f2 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8044e1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8044e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8044e8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8044ec:	48 89 d7             	mov    %rdx,%rdi
  8044ef:	fc                   	cld    
  8044f0:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8044f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8044f6:	c9                   	leaveq 
  8044f7:	c3                   	retq   

00000000008044f8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8044f8:	55                   	push   %rbp
  8044f9:	48 89 e5             	mov    %rsp,%rbp
  8044fc:	48 83 ec 28          	sub    $0x28,%rsp
  804500:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804504:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804508:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80450c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804510:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  804514:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804518:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80451c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804520:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  804524:	0f 83 88 00 00 00    	jae    8045b2 <memmove+0xba>
  80452a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80452e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804532:	48 01 d0             	add    %rdx,%rax
  804535:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  804539:	76 77                	jbe    8045b2 <memmove+0xba>
		s += n;
  80453b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80453f:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  804543:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804547:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80454b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80454f:	83 e0 03             	and    $0x3,%eax
  804552:	48 85 c0             	test   %rax,%rax
  804555:	75 3b                	jne    804592 <memmove+0x9a>
  804557:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80455b:	83 e0 03             	and    $0x3,%eax
  80455e:	48 85 c0             	test   %rax,%rax
  804561:	75 2f                	jne    804592 <memmove+0x9a>
  804563:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804567:	83 e0 03             	and    $0x3,%eax
  80456a:	48 85 c0             	test   %rax,%rax
  80456d:	75 23                	jne    804592 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80456f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804573:	48 83 e8 04          	sub    $0x4,%rax
  804577:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80457b:	48 83 ea 04          	sub    $0x4,%rdx
  80457f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  804583:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  804587:	48 89 c7             	mov    %rax,%rdi
  80458a:	48 89 d6             	mov    %rdx,%rsi
  80458d:	fd                   	std    
  80458e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  804590:	eb 1d                	jmp    8045af <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  804592:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804596:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80459a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80459e:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8045a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045a6:	48 89 d7             	mov    %rdx,%rdi
  8045a9:	48 89 c1             	mov    %rax,%rcx
  8045ac:	fd                   	std    
  8045ad:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8045af:	fc                   	cld    
  8045b0:	eb 57                	jmp    804609 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8045b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045b6:	83 e0 03             	and    $0x3,%eax
  8045b9:	48 85 c0             	test   %rax,%rax
  8045bc:	75 36                	jne    8045f4 <memmove+0xfc>
  8045be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045c2:	83 e0 03             	and    $0x3,%eax
  8045c5:	48 85 c0             	test   %rax,%rax
  8045c8:	75 2a                	jne    8045f4 <memmove+0xfc>
  8045ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045ce:	83 e0 03             	and    $0x3,%eax
  8045d1:	48 85 c0             	test   %rax,%rax
  8045d4:	75 1e                	jne    8045f4 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8045d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045da:	48 c1 e8 02          	shr    $0x2,%rax
  8045de:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8045e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045e5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8045e9:	48 89 c7             	mov    %rax,%rdi
  8045ec:	48 89 d6             	mov    %rdx,%rsi
  8045ef:	fc                   	cld    
  8045f0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8045f2:	eb 15                	jmp    804609 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8045f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045f8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8045fc:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  804600:	48 89 c7             	mov    %rax,%rdi
  804603:	48 89 d6             	mov    %rdx,%rsi
  804606:	fc                   	cld    
  804607:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  804609:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80460d:	c9                   	leaveq 
  80460e:	c3                   	retq   

000000000080460f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80460f:	55                   	push   %rbp
  804610:	48 89 e5             	mov    %rsp,%rbp
  804613:	48 83 ec 18          	sub    $0x18,%rsp
  804617:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80461b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80461f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  804623:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804627:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80462b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80462f:	48 89 ce             	mov    %rcx,%rsi
  804632:	48 89 c7             	mov    %rax,%rdi
  804635:	48 b8 f8 44 80 00 00 	movabs $0x8044f8,%rax
  80463c:	00 00 00 
  80463f:	ff d0                	callq  *%rax
}
  804641:	c9                   	leaveq 
  804642:	c3                   	retq   

0000000000804643 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  804643:	55                   	push   %rbp
  804644:	48 89 e5             	mov    %rsp,%rbp
  804647:	48 83 ec 28          	sub    $0x28,%rsp
  80464b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80464f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804653:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  804657:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80465b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80465f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804663:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  804667:	eb 36                	jmp    80469f <memcmp+0x5c>
		if (*s1 != *s2)
  804669:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80466d:	0f b6 10             	movzbl (%rax),%edx
  804670:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804674:	0f b6 00             	movzbl (%rax),%eax
  804677:	38 c2                	cmp    %al,%dl
  804679:	74 1a                	je     804695 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80467b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80467f:	0f b6 00             	movzbl (%rax),%eax
  804682:	0f b6 d0             	movzbl %al,%edx
  804685:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804689:	0f b6 00             	movzbl (%rax),%eax
  80468c:	0f b6 c0             	movzbl %al,%eax
  80468f:	29 c2                	sub    %eax,%edx
  804691:	89 d0                	mov    %edx,%eax
  804693:	eb 20                	jmp    8046b5 <memcmp+0x72>
		s1++, s2++;
  804695:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80469a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80469f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046a3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8046a7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8046ab:	48 85 c0             	test   %rax,%rax
  8046ae:	75 b9                	jne    804669 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8046b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046b5:	c9                   	leaveq 
  8046b6:	c3                   	retq   

00000000008046b7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8046b7:	55                   	push   %rbp
  8046b8:	48 89 e5             	mov    %rsp,%rbp
  8046bb:	48 83 ec 28          	sub    $0x28,%rsp
  8046bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8046c3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8046c6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8046ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8046d2:	48 01 d0             	add    %rdx,%rax
  8046d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8046d9:	eb 15                	jmp    8046f0 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8046db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046df:	0f b6 10             	movzbl (%rax),%edx
  8046e2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8046e5:	38 c2                	cmp    %al,%dl
  8046e7:	75 02                	jne    8046eb <memfind+0x34>
			break;
  8046e9:	eb 0f                	jmp    8046fa <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8046eb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8046f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046f4:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8046f8:	72 e1                	jb     8046db <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8046fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8046fe:	c9                   	leaveq 
  8046ff:	c3                   	retq   

0000000000804700 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  804700:	55                   	push   %rbp
  804701:	48 89 e5             	mov    %rsp,%rbp
  804704:	48 83 ec 34          	sub    $0x34,%rsp
  804708:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80470c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804710:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  804713:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80471a:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  804721:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  804722:	eb 05                	jmp    804729 <strtol+0x29>
		s++;
  804724:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  804729:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80472d:	0f b6 00             	movzbl (%rax),%eax
  804730:	3c 20                	cmp    $0x20,%al
  804732:	74 f0                	je     804724 <strtol+0x24>
  804734:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804738:	0f b6 00             	movzbl (%rax),%eax
  80473b:	3c 09                	cmp    $0x9,%al
  80473d:	74 e5                	je     804724 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80473f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804743:	0f b6 00             	movzbl (%rax),%eax
  804746:	3c 2b                	cmp    $0x2b,%al
  804748:	75 07                	jne    804751 <strtol+0x51>
		s++;
  80474a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80474f:	eb 17                	jmp    804768 <strtol+0x68>
	else if (*s == '-')
  804751:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804755:	0f b6 00             	movzbl (%rax),%eax
  804758:	3c 2d                	cmp    $0x2d,%al
  80475a:	75 0c                	jne    804768 <strtol+0x68>
		s++, neg = 1;
  80475c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  804761:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  804768:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80476c:	74 06                	je     804774 <strtol+0x74>
  80476e:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  804772:	75 28                	jne    80479c <strtol+0x9c>
  804774:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804778:	0f b6 00             	movzbl (%rax),%eax
  80477b:	3c 30                	cmp    $0x30,%al
  80477d:	75 1d                	jne    80479c <strtol+0x9c>
  80477f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804783:	48 83 c0 01          	add    $0x1,%rax
  804787:	0f b6 00             	movzbl (%rax),%eax
  80478a:	3c 78                	cmp    $0x78,%al
  80478c:	75 0e                	jne    80479c <strtol+0x9c>
		s += 2, base = 16;
  80478e:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  804793:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80479a:	eb 2c                	jmp    8047c8 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80479c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8047a0:	75 19                	jne    8047bb <strtol+0xbb>
  8047a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047a6:	0f b6 00             	movzbl (%rax),%eax
  8047a9:	3c 30                	cmp    $0x30,%al
  8047ab:	75 0e                	jne    8047bb <strtol+0xbb>
		s++, base = 8;
  8047ad:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8047b2:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8047b9:	eb 0d                	jmp    8047c8 <strtol+0xc8>
	else if (base == 0)
  8047bb:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8047bf:	75 07                	jne    8047c8 <strtol+0xc8>
		base = 10;
  8047c1:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8047c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047cc:	0f b6 00             	movzbl (%rax),%eax
  8047cf:	3c 2f                	cmp    $0x2f,%al
  8047d1:	7e 1d                	jle    8047f0 <strtol+0xf0>
  8047d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047d7:	0f b6 00             	movzbl (%rax),%eax
  8047da:	3c 39                	cmp    $0x39,%al
  8047dc:	7f 12                	jg     8047f0 <strtol+0xf0>
			dig = *s - '0';
  8047de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047e2:	0f b6 00             	movzbl (%rax),%eax
  8047e5:	0f be c0             	movsbl %al,%eax
  8047e8:	83 e8 30             	sub    $0x30,%eax
  8047eb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8047ee:	eb 4e                	jmp    80483e <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8047f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047f4:	0f b6 00             	movzbl (%rax),%eax
  8047f7:	3c 60                	cmp    $0x60,%al
  8047f9:	7e 1d                	jle    804818 <strtol+0x118>
  8047fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047ff:	0f b6 00             	movzbl (%rax),%eax
  804802:	3c 7a                	cmp    $0x7a,%al
  804804:	7f 12                	jg     804818 <strtol+0x118>
			dig = *s - 'a' + 10;
  804806:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80480a:	0f b6 00             	movzbl (%rax),%eax
  80480d:	0f be c0             	movsbl %al,%eax
  804810:	83 e8 57             	sub    $0x57,%eax
  804813:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804816:	eb 26                	jmp    80483e <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  804818:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80481c:	0f b6 00             	movzbl (%rax),%eax
  80481f:	3c 40                	cmp    $0x40,%al
  804821:	7e 48                	jle    80486b <strtol+0x16b>
  804823:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804827:	0f b6 00             	movzbl (%rax),%eax
  80482a:	3c 5a                	cmp    $0x5a,%al
  80482c:	7f 3d                	jg     80486b <strtol+0x16b>
			dig = *s - 'A' + 10;
  80482e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804832:	0f b6 00             	movzbl (%rax),%eax
  804835:	0f be c0             	movsbl %al,%eax
  804838:	83 e8 37             	sub    $0x37,%eax
  80483b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80483e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804841:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  804844:	7c 02                	jl     804848 <strtol+0x148>
			break;
  804846:	eb 23                	jmp    80486b <strtol+0x16b>
		s++, val = (val * base) + dig;
  804848:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80484d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  804850:	48 98                	cltq   
  804852:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  804857:	48 89 c2             	mov    %rax,%rdx
  80485a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80485d:	48 98                	cltq   
  80485f:	48 01 d0             	add    %rdx,%rax
  804862:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  804866:	e9 5d ff ff ff       	jmpq   8047c8 <strtol+0xc8>

	if (endptr)
  80486b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  804870:	74 0b                	je     80487d <strtol+0x17d>
		*endptr = (char *) s;
  804872:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804876:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80487a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80487d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804881:	74 09                	je     80488c <strtol+0x18c>
  804883:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804887:	48 f7 d8             	neg    %rax
  80488a:	eb 04                	jmp    804890 <strtol+0x190>
  80488c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  804890:	c9                   	leaveq 
  804891:	c3                   	retq   

0000000000804892 <strstr>:

char * strstr(const char *in, const char *str)
{
  804892:	55                   	push   %rbp
  804893:	48 89 e5             	mov    %rsp,%rbp
  804896:	48 83 ec 30          	sub    $0x30,%rsp
  80489a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80489e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8048a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8048a6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8048aa:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8048ae:	0f b6 00             	movzbl (%rax),%eax
  8048b1:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8048b4:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8048b8:	75 06                	jne    8048c0 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8048ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048be:	eb 6b                	jmp    80492b <strstr+0x99>

	len = strlen(str);
  8048c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8048c4:	48 89 c7             	mov    %rax,%rdi
  8048c7:	48 b8 68 41 80 00 00 	movabs $0x804168,%rax
  8048ce:	00 00 00 
  8048d1:	ff d0                	callq  *%rax
  8048d3:	48 98                	cltq   
  8048d5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8048d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048dd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8048e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8048e5:	0f b6 00             	movzbl (%rax),%eax
  8048e8:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8048eb:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8048ef:	75 07                	jne    8048f8 <strstr+0x66>
				return (char *) 0;
  8048f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8048f6:	eb 33                	jmp    80492b <strstr+0x99>
		} while (sc != c);
  8048f8:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8048fc:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8048ff:	75 d8                	jne    8048d9 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  804901:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804905:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  804909:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80490d:	48 89 ce             	mov    %rcx,%rsi
  804910:	48 89 c7             	mov    %rax,%rdi
  804913:	48 b8 89 43 80 00 00 	movabs $0x804389,%rax
  80491a:	00 00 00 
  80491d:	ff d0                	callq  *%rax
  80491f:	85 c0                	test   %eax,%eax
  804921:	75 b6                	jne    8048d9 <strstr+0x47>

	return (char *) (in - 1);
  804923:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804927:	48 83 e8 01          	sub    $0x1,%rax
}
  80492b:	c9                   	leaveq 
  80492c:	c3                   	retq   

000000000080492d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80492d:	55                   	push   %rbp
  80492e:	48 89 e5             	mov    %rsp,%rbp
  804931:	53                   	push   %rbx
  804932:	48 83 ec 48          	sub    $0x48,%rsp
  804936:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804939:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80493c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804940:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  804944:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  804948:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80494c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80494f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  804953:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  804957:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80495b:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80495f:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  804963:	4c 89 c3             	mov    %r8,%rbx
  804966:	cd 30                	int    $0x30
  804968:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80496c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  804970:	74 3e                	je     8049b0 <syscall+0x83>
  804972:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804977:	7e 37                	jle    8049b0 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  804979:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80497d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804980:	49 89 d0             	mov    %rdx,%r8
  804983:	89 c1                	mov    %eax,%ecx
  804985:	48 ba 48 7e 80 00 00 	movabs $0x807e48,%rdx
  80498c:	00 00 00 
  80498f:	be 23 00 00 00       	mov    $0x23,%esi
  804994:	48 bf 65 7e 80 00 00 	movabs $0x807e65,%rdi
  80499b:	00 00 00 
  80499e:	b8 00 00 00 00       	mov    $0x0,%eax
  8049a3:	49 b9 e6 33 80 00 00 	movabs $0x8033e6,%r9
  8049aa:	00 00 00 
  8049ad:	41 ff d1             	callq  *%r9

	return ret;
  8049b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8049b4:	48 83 c4 48          	add    $0x48,%rsp
  8049b8:	5b                   	pop    %rbx
  8049b9:	5d                   	pop    %rbp
  8049ba:	c3                   	retq   

00000000008049bb <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8049bb:	55                   	push   %rbp
  8049bc:	48 89 e5             	mov    %rsp,%rbp
  8049bf:	48 83 ec 20          	sub    $0x20,%rsp
  8049c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8049c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8049cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8049d3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8049da:	00 
  8049db:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8049e1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8049e7:	48 89 d1             	mov    %rdx,%rcx
  8049ea:	48 89 c2             	mov    %rax,%rdx
  8049ed:	be 00 00 00 00       	mov    $0x0,%esi
  8049f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8049f7:	48 b8 2d 49 80 00 00 	movabs $0x80492d,%rax
  8049fe:	00 00 00 
  804a01:	ff d0                	callq  *%rax
}
  804a03:	c9                   	leaveq 
  804a04:	c3                   	retq   

0000000000804a05 <sys_cgetc>:

int
sys_cgetc(void)
{
  804a05:	55                   	push   %rbp
  804a06:	48 89 e5             	mov    %rsp,%rbp
  804a09:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  804a0d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804a14:	00 
  804a15:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804a1b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804a21:	b9 00 00 00 00       	mov    $0x0,%ecx
  804a26:	ba 00 00 00 00       	mov    $0x0,%edx
  804a2b:	be 00 00 00 00       	mov    $0x0,%esi
  804a30:	bf 01 00 00 00       	mov    $0x1,%edi
  804a35:	48 b8 2d 49 80 00 00 	movabs $0x80492d,%rax
  804a3c:	00 00 00 
  804a3f:	ff d0                	callq  *%rax
}
  804a41:	c9                   	leaveq 
  804a42:	c3                   	retq   

0000000000804a43 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  804a43:	55                   	push   %rbp
  804a44:	48 89 e5             	mov    %rsp,%rbp
  804a47:	48 83 ec 10          	sub    $0x10,%rsp
  804a4b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  804a4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a51:	48 98                	cltq   
  804a53:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804a5a:	00 
  804a5b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804a61:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804a67:	b9 00 00 00 00       	mov    $0x0,%ecx
  804a6c:	48 89 c2             	mov    %rax,%rdx
  804a6f:	be 01 00 00 00       	mov    $0x1,%esi
  804a74:	bf 03 00 00 00       	mov    $0x3,%edi
  804a79:	48 b8 2d 49 80 00 00 	movabs $0x80492d,%rax
  804a80:	00 00 00 
  804a83:	ff d0                	callq  *%rax
}
  804a85:	c9                   	leaveq 
  804a86:	c3                   	retq   

0000000000804a87 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  804a87:	55                   	push   %rbp
  804a88:	48 89 e5             	mov    %rsp,%rbp
  804a8b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  804a8f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804a96:	00 
  804a97:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804a9d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804aa3:	b9 00 00 00 00       	mov    $0x0,%ecx
  804aa8:	ba 00 00 00 00       	mov    $0x0,%edx
  804aad:	be 00 00 00 00       	mov    $0x0,%esi
  804ab2:	bf 02 00 00 00       	mov    $0x2,%edi
  804ab7:	48 b8 2d 49 80 00 00 	movabs $0x80492d,%rax
  804abe:	00 00 00 
  804ac1:	ff d0                	callq  *%rax
}
  804ac3:	c9                   	leaveq 
  804ac4:	c3                   	retq   

0000000000804ac5 <sys_yield>:

void
sys_yield(void)
{
  804ac5:	55                   	push   %rbp
  804ac6:	48 89 e5             	mov    %rsp,%rbp
  804ac9:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  804acd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804ad4:	00 
  804ad5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804adb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804ae1:	b9 00 00 00 00       	mov    $0x0,%ecx
  804ae6:	ba 00 00 00 00       	mov    $0x0,%edx
  804aeb:	be 00 00 00 00       	mov    $0x0,%esi
  804af0:	bf 0b 00 00 00       	mov    $0xb,%edi
  804af5:	48 b8 2d 49 80 00 00 	movabs $0x80492d,%rax
  804afc:	00 00 00 
  804aff:	ff d0                	callq  *%rax
}
  804b01:	c9                   	leaveq 
  804b02:	c3                   	retq   

0000000000804b03 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  804b03:	55                   	push   %rbp
  804b04:	48 89 e5             	mov    %rsp,%rbp
  804b07:	48 83 ec 20          	sub    $0x20,%rsp
  804b0b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804b0e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804b12:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  804b15:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804b18:	48 63 c8             	movslq %eax,%rcx
  804b1b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b22:	48 98                	cltq   
  804b24:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804b2b:	00 
  804b2c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804b32:	49 89 c8             	mov    %rcx,%r8
  804b35:	48 89 d1             	mov    %rdx,%rcx
  804b38:	48 89 c2             	mov    %rax,%rdx
  804b3b:	be 01 00 00 00       	mov    $0x1,%esi
  804b40:	bf 04 00 00 00       	mov    $0x4,%edi
  804b45:	48 b8 2d 49 80 00 00 	movabs $0x80492d,%rax
  804b4c:	00 00 00 
  804b4f:	ff d0                	callq  *%rax
}
  804b51:	c9                   	leaveq 
  804b52:	c3                   	retq   

0000000000804b53 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  804b53:	55                   	push   %rbp
  804b54:	48 89 e5             	mov    %rsp,%rbp
  804b57:	48 83 ec 30          	sub    $0x30,%rsp
  804b5b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804b5e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804b62:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804b65:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  804b69:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  804b6d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804b70:	48 63 c8             	movslq %eax,%rcx
  804b73:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  804b77:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804b7a:	48 63 f0             	movslq %eax,%rsi
  804b7d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b84:	48 98                	cltq   
  804b86:	48 89 0c 24          	mov    %rcx,(%rsp)
  804b8a:	49 89 f9             	mov    %rdi,%r9
  804b8d:	49 89 f0             	mov    %rsi,%r8
  804b90:	48 89 d1             	mov    %rdx,%rcx
  804b93:	48 89 c2             	mov    %rax,%rdx
  804b96:	be 01 00 00 00       	mov    $0x1,%esi
  804b9b:	bf 05 00 00 00       	mov    $0x5,%edi
  804ba0:	48 b8 2d 49 80 00 00 	movabs $0x80492d,%rax
  804ba7:	00 00 00 
  804baa:	ff d0                	callq  *%rax
}
  804bac:	c9                   	leaveq 
  804bad:	c3                   	retq   

0000000000804bae <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  804bae:	55                   	push   %rbp
  804baf:	48 89 e5             	mov    %rsp,%rbp
  804bb2:	48 83 ec 20          	sub    $0x20,%rsp
  804bb6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804bb9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  804bbd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804bc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804bc4:	48 98                	cltq   
  804bc6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804bcd:	00 
  804bce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804bd4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804bda:	48 89 d1             	mov    %rdx,%rcx
  804bdd:	48 89 c2             	mov    %rax,%rdx
  804be0:	be 01 00 00 00       	mov    $0x1,%esi
  804be5:	bf 06 00 00 00       	mov    $0x6,%edi
  804bea:	48 b8 2d 49 80 00 00 	movabs $0x80492d,%rax
  804bf1:	00 00 00 
  804bf4:	ff d0                	callq  *%rax
}
  804bf6:	c9                   	leaveq 
  804bf7:	c3                   	retq   

0000000000804bf8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  804bf8:	55                   	push   %rbp
  804bf9:	48 89 e5             	mov    %rsp,%rbp
  804bfc:	48 83 ec 10          	sub    $0x10,%rsp
  804c00:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804c03:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  804c06:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804c09:	48 63 d0             	movslq %eax,%rdx
  804c0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c0f:	48 98                	cltq   
  804c11:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804c18:	00 
  804c19:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804c1f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804c25:	48 89 d1             	mov    %rdx,%rcx
  804c28:	48 89 c2             	mov    %rax,%rdx
  804c2b:	be 01 00 00 00       	mov    $0x1,%esi
  804c30:	bf 08 00 00 00       	mov    $0x8,%edi
  804c35:	48 b8 2d 49 80 00 00 	movabs $0x80492d,%rax
  804c3c:	00 00 00 
  804c3f:	ff d0                	callq  *%rax
}
  804c41:	c9                   	leaveq 
  804c42:	c3                   	retq   

0000000000804c43 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  804c43:	55                   	push   %rbp
  804c44:	48 89 e5             	mov    %rsp,%rbp
  804c47:	48 83 ec 20          	sub    $0x20,%rsp
  804c4b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804c4e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  804c52:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804c56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c59:	48 98                	cltq   
  804c5b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804c62:	00 
  804c63:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804c69:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804c6f:	48 89 d1             	mov    %rdx,%rcx
  804c72:	48 89 c2             	mov    %rax,%rdx
  804c75:	be 01 00 00 00       	mov    $0x1,%esi
  804c7a:	bf 09 00 00 00       	mov    $0x9,%edi
  804c7f:	48 b8 2d 49 80 00 00 	movabs $0x80492d,%rax
  804c86:	00 00 00 
  804c89:	ff d0                	callq  *%rax
}
  804c8b:	c9                   	leaveq 
  804c8c:	c3                   	retq   

0000000000804c8d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  804c8d:	55                   	push   %rbp
  804c8e:	48 89 e5             	mov    %rsp,%rbp
  804c91:	48 83 ec 20          	sub    $0x20,%rsp
  804c95:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804c98:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  804c9c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804ca0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ca3:	48 98                	cltq   
  804ca5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804cac:	00 
  804cad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804cb3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804cb9:	48 89 d1             	mov    %rdx,%rcx
  804cbc:	48 89 c2             	mov    %rax,%rdx
  804cbf:	be 01 00 00 00       	mov    $0x1,%esi
  804cc4:	bf 0a 00 00 00       	mov    $0xa,%edi
  804cc9:	48 b8 2d 49 80 00 00 	movabs $0x80492d,%rax
  804cd0:	00 00 00 
  804cd3:	ff d0                	callq  *%rax
}
  804cd5:	c9                   	leaveq 
  804cd6:	c3                   	retq   

0000000000804cd7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  804cd7:	55                   	push   %rbp
  804cd8:	48 89 e5             	mov    %rsp,%rbp
  804cdb:	48 83 ec 20          	sub    $0x20,%rsp
  804cdf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804ce2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804ce6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804cea:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  804ced:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804cf0:	48 63 f0             	movslq %eax,%rsi
  804cf3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804cf7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804cfa:	48 98                	cltq   
  804cfc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804d00:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804d07:	00 
  804d08:	49 89 f1             	mov    %rsi,%r9
  804d0b:	49 89 c8             	mov    %rcx,%r8
  804d0e:	48 89 d1             	mov    %rdx,%rcx
  804d11:	48 89 c2             	mov    %rax,%rdx
  804d14:	be 00 00 00 00       	mov    $0x0,%esi
  804d19:	bf 0c 00 00 00       	mov    $0xc,%edi
  804d1e:	48 b8 2d 49 80 00 00 	movabs $0x80492d,%rax
  804d25:	00 00 00 
  804d28:	ff d0                	callq  *%rax
}
  804d2a:	c9                   	leaveq 
  804d2b:	c3                   	retq   

0000000000804d2c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  804d2c:	55                   	push   %rbp
  804d2d:	48 89 e5             	mov    %rsp,%rbp
  804d30:	48 83 ec 10          	sub    $0x10,%rsp
  804d34:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  804d38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d3c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804d43:	00 
  804d44:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804d4a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804d50:	b9 00 00 00 00       	mov    $0x0,%ecx
  804d55:	48 89 c2             	mov    %rax,%rdx
  804d58:	be 01 00 00 00       	mov    $0x1,%esi
  804d5d:	bf 0d 00 00 00       	mov    $0xd,%edi
  804d62:	48 b8 2d 49 80 00 00 	movabs $0x80492d,%rax
  804d69:	00 00 00 
  804d6c:	ff d0                	callq  *%rax
}
  804d6e:	c9                   	leaveq 
  804d6f:	c3                   	retq   

0000000000804d70 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  804d70:	55                   	push   %rbp
  804d71:	48 89 e5             	mov    %rsp,%rbp
  804d74:	48 83 ec 20          	sub    $0x20,%rsp
  804d78:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804d7c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  804d80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804d88:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804d8f:	00 
  804d90:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804d96:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804d9c:	b9 00 00 00 00       	mov    $0x0,%ecx
  804da1:	89 c6                	mov    %eax,%esi
  804da3:	bf 0f 00 00 00       	mov    $0xf,%edi
  804da8:	48 b8 2d 49 80 00 00 	movabs $0x80492d,%rax
  804daf:	00 00 00 
  804db2:	ff d0                	callq  *%rax
}
  804db4:	c9                   	leaveq 
  804db5:	c3                   	retq   

0000000000804db6 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  804db6:	55                   	push   %rbp
  804db7:	48 89 e5             	mov    %rsp,%rbp
  804dba:	48 83 ec 20          	sub    $0x20,%rsp
  804dbe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804dc2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  804dc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804dca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804dce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804dd5:	00 
  804dd6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804ddc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804de2:	b9 00 00 00 00       	mov    $0x0,%ecx
  804de7:	89 c6                	mov    %eax,%esi
  804de9:	bf 10 00 00 00       	mov    $0x10,%edi
  804dee:	48 b8 2d 49 80 00 00 	movabs $0x80492d,%rax
  804df5:	00 00 00 
  804df8:	ff d0                	callq  *%rax
}
  804dfa:	c9                   	leaveq 
  804dfb:	c3                   	retq   

0000000000804dfc <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  804dfc:	55                   	push   %rbp
  804dfd:	48 89 e5             	mov    %rsp,%rbp
  804e00:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  804e04:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804e0b:	00 
  804e0c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804e12:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804e18:	b9 00 00 00 00       	mov    $0x0,%ecx
  804e1d:	ba 00 00 00 00       	mov    $0x0,%edx
  804e22:	be 00 00 00 00       	mov    $0x0,%esi
  804e27:	bf 0e 00 00 00       	mov    $0xe,%edi
  804e2c:	48 b8 2d 49 80 00 00 	movabs $0x80492d,%rax
  804e33:	00 00 00 
  804e36:	ff d0                	callq  *%rax
}
  804e38:	c9                   	leaveq 
  804e39:	c3                   	retq   

0000000000804e3a <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804e3a:	55                   	push   %rbp
  804e3b:	48 89 e5             	mov    %rsp,%rbp
  804e3e:	48 83 ec 10          	sub    $0x10,%rsp
  804e42:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804e46:	48 b8 28 30 81 00 00 	movabs $0x813028,%rax
  804e4d:	00 00 00 
  804e50:	48 8b 00             	mov    (%rax),%rax
  804e53:	48 85 c0             	test   %rax,%rax
  804e56:	0f 85 84 00 00 00    	jne    804ee0 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  804e5c:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  804e63:	00 00 00 
  804e66:	48 8b 00             	mov    (%rax),%rax
  804e69:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804e6f:	ba 07 00 00 00       	mov    $0x7,%edx
  804e74:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804e79:	89 c7                	mov    %eax,%edi
  804e7b:	48 b8 03 4b 80 00 00 	movabs $0x804b03,%rax
  804e82:	00 00 00 
  804e85:	ff d0                	callq  *%rax
  804e87:	85 c0                	test   %eax,%eax
  804e89:	79 2a                	jns    804eb5 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  804e8b:	48 ba 78 7e 80 00 00 	movabs $0x807e78,%rdx
  804e92:	00 00 00 
  804e95:	be 23 00 00 00       	mov    $0x23,%esi
  804e9a:	48 bf 9f 7e 80 00 00 	movabs $0x807e9f,%rdi
  804ea1:	00 00 00 
  804ea4:	b8 00 00 00 00       	mov    $0x0,%eax
  804ea9:	48 b9 e6 33 80 00 00 	movabs $0x8033e6,%rcx
  804eb0:	00 00 00 
  804eb3:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  804eb5:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  804ebc:	00 00 00 
  804ebf:	48 8b 00             	mov    (%rax),%rax
  804ec2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804ec8:	48 be f3 4e 80 00 00 	movabs $0x804ef3,%rsi
  804ecf:	00 00 00 
  804ed2:	89 c7                	mov    %eax,%edi
  804ed4:	48 b8 8d 4c 80 00 00 	movabs $0x804c8d,%rax
  804edb:	00 00 00 
  804ede:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  804ee0:	48 b8 28 30 81 00 00 	movabs $0x813028,%rax
  804ee7:	00 00 00 
  804eea:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804eee:	48 89 10             	mov    %rdx,(%rax)
}
  804ef1:	c9                   	leaveq 
  804ef2:	c3                   	retq   

0000000000804ef3 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804ef3:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804ef6:	48 a1 28 30 81 00 00 	movabs 0x813028,%rax
  804efd:	00 00 00 
call *%rax
  804f00:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  804f02:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804f09:	00 
	movq 152(%rsp), %rcx  //Load RSP
  804f0a:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804f11:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  804f12:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  804f16:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  804f19:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804f20:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  804f21:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  804f25:	4c 8b 3c 24          	mov    (%rsp),%r15
  804f29:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804f2e:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804f33:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804f38:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804f3d:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804f42:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804f47:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804f4c:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804f51:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804f56:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804f5b:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804f60:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804f65:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804f6a:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804f6f:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  804f73:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  804f77:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  804f78:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  804f79:	c3                   	retq   

0000000000804f7a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804f7a:	55                   	push   %rbp
  804f7b:	48 89 e5             	mov    %rsp,%rbp
  804f7e:	48 83 ec 30          	sub    $0x30,%rsp
  804f82:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804f86:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804f8a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804f8e:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  804f95:	00 00 00 
  804f98:	48 8b 00             	mov    (%rax),%rax
  804f9b:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804fa1:	85 c0                	test   %eax,%eax
  804fa3:	75 3c                	jne    804fe1 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  804fa5:	48 b8 87 4a 80 00 00 	movabs $0x804a87,%rax
  804fac:	00 00 00 
  804faf:	ff d0                	callq  *%rax
  804fb1:	25 ff 03 00 00       	and    $0x3ff,%eax
  804fb6:	48 63 d0             	movslq %eax,%rdx
  804fb9:	48 89 d0             	mov    %rdx,%rax
  804fbc:	48 c1 e0 03          	shl    $0x3,%rax
  804fc0:	48 01 d0             	add    %rdx,%rax
  804fc3:	48 c1 e0 05          	shl    $0x5,%rax
  804fc7:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804fce:	00 00 00 
  804fd1:	48 01 c2             	add    %rax,%rdx
  804fd4:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  804fdb:	00 00 00 
  804fde:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804fe1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804fe6:	75 0e                	jne    804ff6 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  804fe8:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804fef:	00 00 00 
  804ff2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804ff6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804ffa:	48 89 c7             	mov    %rax,%rdi
  804ffd:	48 b8 2c 4d 80 00 00 	movabs $0x804d2c,%rax
  805004:	00 00 00 
  805007:	ff d0                	callq  *%rax
  805009:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  80500c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805010:	79 19                	jns    80502b <ipc_recv+0xb1>
		*from_env_store = 0;
  805012:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805016:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80501c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805020:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  805026:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805029:	eb 53                	jmp    80507e <ipc_recv+0x104>
	}
	if(from_env_store)
  80502b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805030:	74 19                	je     80504b <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  805032:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  805039:	00 00 00 
  80503c:	48 8b 00             	mov    (%rax),%rax
  80503f:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  805045:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805049:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80504b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805050:	74 19                	je     80506b <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  805052:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  805059:	00 00 00 
  80505c:	48 8b 00             	mov    (%rax),%rax
  80505f:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  805065:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805069:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  80506b:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  805072:	00 00 00 
  805075:	48 8b 00             	mov    (%rax),%rax
  805078:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  80507e:	c9                   	leaveq 
  80507f:	c3                   	retq   

0000000000805080 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  805080:	55                   	push   %rbp
  805081:	48 89 e5             	mov    %rsp,%rbp
  805084:	48 83 ec 30          	sub    $0x30,%rsp
  805088:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80508b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80508e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  805092:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  805095:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80509a:	75 0e                	jne    8050aa <ipc_send+0x2a>
		pg = (void*)UTOP;
  80509c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8050a3:	00 00 00 
  8050a6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8050aa:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8050ad:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8050b0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8050b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8050b7:	89 c7                	mov    %eax,%edi
  8050b9:	48 b8 d7 4c 80 00 00 	movabs $0x804cd7,%rax
  8050c0:	00 00 00 
  8050c3:	ff d0                	callq  *%rax
  8050c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8050c8:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8050cc:	75 0c                	jne    8050da <ipc_send+0x5a>
			sys_yield();
  8050ce:	48 b8 c5 4a 80 00 00 	movabs $0x804ac5,%rax
  8050d5:	00 00 00 
  8050d8:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8050da:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8050de:	74 ca                	je     8050aa <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8050e0:	c9                   	leaveq 
  8050e1:	c3                   	retq   

00000000008050e2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8050e2:	55                   	push   %rbp
  8050e3:	48 89 e5             	mov    %rsp,%rbp
  8050e6:	48 83 ec 14          	sub    $0x14,%rsp
  8050ea:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8050ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8050f4:	eb 5e                	jmp    805154 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8050f6:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8050fd:	00 00 00 
  805100:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805103:	48 63 d0             	movslq %eax,%rdx
  805106:	48 89 d0             	mov    %rdx,%rax
  805109:	48 c1 e0 03          	shl    $0x3,%rax
  80510d:	48 01 d0             	add    %rdx,%rax
  805110:	48 c1 e0 05          	shl    $0x5,%rax
  805114:	48 01 c8             	add    %rcx,%rax
  805117:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80511d:	8b 00                	mov    (%rax),%eax
  80511f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805122:	75 2c                	jne    805150 <ipc_find_env+0x6e>
			return envs[i].env_id;
  805124:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80512b:	00 00 00 
  80512e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805131:	48 63 d0             	movslq %eax,%rdx
  805134:	48 89 d0             	mov    %rdx,%rax
  805137:	48 c1 e0 03          	shl    $0x3,%rax
  80513b:	48 01 d0             	add    %rdx,%rax
  80513e:	48 c1 e0 05          	shl    $0x5,%rax
  805142:	48 01 c8             	add    %rcx,%rax
  805145:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80514b:	8b 40 08             	mov    0x8(%rax),%eax
  80514e:	eb 12                	jmp    805162 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  805150:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805154:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80515b:	7e 99                	jle    8050f6 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80515d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805162:	c9                   	leaveq 
  805163:	c3                   	retq   

0000000000805164 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  805164:	55                   	push   %rbp
  805165:	48 89 e5             	mov    %rsp,%rbp
  805168:	48 83 ec 08          	sub    $0x8,%rsp
  80516c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  805170:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805174:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80517b:	ff ff ff 
  80517e:	48 01 d0             	add    %rdx,%rax
  805181:	48 c1 e8 0c          	shr    $0xc,%rax
}
  805185:	c9                   	leaveq 
  805186:	c3                   	retq   

0000000000805187 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  805187:	55                   	push   %rbp
  805188:	48 89 e5             	mov    %rsp,%rbp
  80518b:	48 83 ec 08          	sub    $0x8,%rsp
  80518f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  805193:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805197:	48 89 c7             	mov    %rax,%rdi
  80519a:	48 b8 64 51 80 00 00 	movabs $0x805164,%rax
  8051a1:	00 00 00 
  8051a4:	ff d0                	callq  *%rax
  8051a6:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8051ac:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8051b0:	c9                   	leaveq 
  8051b1:	c3                   	retq   

00000000008051b2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8051b2:	55                   	push   %rbp
  8051b3:	48 89 e5             	mov    %rsp,%rbp
  8051b6:	48 83 ec 18          	sub    $0x18,%rsp
  8051ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8051be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8051c5:	eb 6b                	jmp    805232 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8051c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051ca:	48 98                	cltq   
  8051cc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8051d2:	48 c1 e0 0c          	shl    $0xc,%rax
  8051d6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8051da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8051de:	48 c1 e8 15          	shr    $0x15,%rax
  8051e2:	48 89 c2             	mov    %rax,%rdx
  8051e5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8051ec:	01 00 00 
  8051ef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8051f3:	83 e0 01             	and    $0x1,%eax
  8051f6:	48 85 c0             	test   %rax,%rax
  8051f9:	74 21                	je     80521c <fd_alloc+0x6a>
  8051fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8051ff:	48 c1 e8 0c          	shr    $0xc,%rax
  805203:	48 89 c2             	mov    %rax,%rdx
  805206:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80520d:	01 00 00 
  805210:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805214:	83 e0 01             	and    $0x1,%eax
  805217:	48 85 c0             	test   %rax,%rax
  80521a:	75 12                	jne    80522e <fd_alloc+0x7c>
			*fd_store = fd;
  80521c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805220:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805224:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  805227:	b8 00 00 00 00       	mov    $0x0,%eax
  80522c:	eb 1a                	jmp    805248 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80522e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805232:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  805236:	7e 8f                	jle    8051c7 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  805238:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80523c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  805243:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  805248:	c9                   	leaveq 
  805249:	c3                   	retq   

000000000080524a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80524a:	55                   	push   %rbp
  80524b:	48 89 e5             	mov    %rsp,%rbp
  80524e:	48 83 ec 20          	sub    $0x20,%rsp
  805252:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805255:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  805259:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80525d:	78 06                	js     805265 <fd_lookup+0x1b>
  80525f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  805263:	7e 07                	jle    80526c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  805265:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80526a:	eb 6c                	jmp    8052d8 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80526c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80526f:	48 98                	cltq   
  805271:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  805277:	48 c1 e0 0c          	shl    $0xc,%rax
  80527b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80527f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805283:	48 c1 e8 15          	shr    $0x15,%rax
  805287:	48 89 c2             	mov    %rax,%rdx
  80528a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805291:	01 00 00 
  805294:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805298:	83 e0 01             	and    $0x1,%eax
  80529b:	48 85 c0             	test   %rax,%rax
  80529e:	74 21                	je     8052c1 <fd_lookup+0x77>
  8052a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8052a4:	48 c1 e8 0c          	shr    $0xc,%rax
  8052a8:	48 89 c2             	mov    %rax,%rdx
  8052ab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8052b2:	01 00 00 
  8052b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8052b9:	83 e0 01             	and    $0x1,%eax
  8052bc:	48 85 c0             	test   %rax,%rax
  8052bf:	75 07                	jne    8052c8 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8052c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8052c6:	eb 10                	jmp    8052d8 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8052c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8052cc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8052d0:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8052d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8052d8:	c9                   	leaveq 
  8052d9:	c3                   	retq   

00000000008052da <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8052da:	55                   	push   %rbp
  8052db:	48 89 e5             	mov    %rsp,%rbp
  8052de:	48 83 ec 30          	sub    $0x30,%rsp
  8052e2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8052e6:	89 f0                	mov    %esi,%eax
  8052e8:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8052eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8052ef:	48 89 c7             	mov    %rax,%rdi
  8052f2:	48 b8 64 51 80 00 00 	movabs $0x805164,%rax
  8052f9:	00 00 00 
  8052fc:	ff d0                	callq  *%rax
  8052fe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805302:	48 89 d6             	mov    %rdx,%rsi
  805305:	89 c7                	mov    %eax,%edi
  805307:	48 b8 4a 52 80 00 00 	movabs $0x80524a,%rax
  80530e:	00 00 00 
  805311:	ff d0                	callq  *%rax
  805313:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805316:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80531a:	78 0a                	js     805326 <fd_close+0x4c>
	    || fd != fd2)
  80531c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805320:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  805324:	74 12                	je     805338 <fd_close+0x5e>
		return (must_exist ? r : 0);
  805326:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80532a:	74 05                	je     805331 <fd_close+0x57>
  80532c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80532f:	eb 05                	jmp    805336 <fd_close+0x5c>
  805331:	b8 00 00 00 00       	mov    $0x0,%eax
  805336:	eb 69                	jmp    8053a1 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  805338:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80533c:	8b 00                	mov    (%rax),%eax
  80533e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805342:	48 89 d6             	mov    %rdx,%rsi
  805345:	89 c7                	mov    %eax,%edi
  805347:	48 b8 a3 53 80 00 00 	movabs $0x8053a3,%rax
  80534e:	00 00 00 
  805351:	ff d0                	callq  *%rax
  805353:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805356:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80535a:	78 2a                	js     805386 <fd_close+0xac>
		if (dev->dev_close)
  80535c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805360:	48 8b 40 20          	mov    0x20(%rax),%rax
  805364:	48 85 c0             	test   %rax,%rax
  805367:	74 16                	je     80537f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  805369:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80536d:	48 8b 40 20          	mov    0x20(%rax),%rax
  805371:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805375:	48 89 d7             	mov    %rdx,%rdi
  805378:	ff d0                	callq  *%rax
  80537a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80537d:	eb 07                	jmp    805386 <fd_close+0xac>
		else
			r = 0;
  80537f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  805386:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80538a:	48 89 c6             	mov    %rax,%rsi
  80538d:	bf 00 00 00 00       	mov    $0x0,%edi
  805392:	48 b8 ae 4b 80 00 00 	movabs $0x804bae,%rax
  805399:	00 00 00 
  80539c:	ff d0                	callq  *%rax
	return r;
  80539e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8053a1:	c9                   	leaveq 
  8053a2:	c3                   	retq   

00000000008053a3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8053a3:	55                   	push   %rbp
  8053a4:	48 89 e5             	mov    %rsp,%rbp
  8053a7:	48 83 ec 20          	sub    $0x20,%rsp
  8053ab:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8053ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8053b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8053b9:	eb 41                	jmp    8053fc <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8053bb:	48 b8 a0 20 81 00 00 	movabs $0x8120a0,%rax
  8053c2:	00 00 00 
  8053c5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8053c8:	48 63 d2             	movslq %edx,%rdx
  8053cb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8053cf:	8b 00                	mov    (%rax),%eax
  8053d1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8053d4:	75 22                	jne    8053f8 <dev_lookup+0x55>
			*dev = devtab[i];
  8053d6:	48 b8 a0 20 81 00 00 	movabs $0x8120a0,%rax
  8053dd:	00 00 00 
  8053e0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8053e3:	48 63 d2             	movslq %edx,%rdx
  8053e6:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8053ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8053ee:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8053f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8053f6:	eb 60                	jmp    805458 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8053f8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8053fc:	48 b8 a0 20 81 00 00 	movabs $0x8120a0,%rax
  805403:	00 00 00 
  805406:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805409:	48 63 d2             	movslq %edx,%rdx
  80540c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805410:	48 85 c0             	test   %rax,%rax
  805413:	75 a6                	jne    8053bb <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  805415:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  80541c:	00 00 00 
  80541f:	48 8b 00             	mov    (%rax),%rax
  805422:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805428:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80542b:	89 c6                	mov    %eax,%esi
  80542d:	48 bf b0 7e 80 00 00 	movabs $0x807eb0,%rdi
  805434:	00 00 00 
  805437:	b8 00 00 00 00       	mov    $0x0,%eax
  80543c:	48 b9 1f 36 80 00 00 	movabs $0x80361f,%rcx
  805443:	00 00 00 
  805446:	ff d1                	callq  *%rcx
	*dev = 0;
  805448:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80544c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  805453:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  805458:	c9                   	leaveq 
  805459:	c3                   	retq   

000000000080545a <close>:

int
close(int fdnum)
{
  80545a:	55                   	push   %rbp
  80545b:	48 89 e5             	mov    %rsp,%rbp
  80545e:	48 83 ec 20          	sub    $0x20,%rsp
  805462:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  805465:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805469:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80546c:	48 89 d6             	mov    %rdx,%rsi
  80546f:	89 c7                	mov    %eax,%edi
  805471:	48 b8 4a 52 80 00 00 	movabs $0x80524a,%rax
  805478:	00 00 00 
  80547b:	ff d0                	callq  *%rax
  80547d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805480:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805484:	79 05                	jns    80548b <close+0x31>
		return r;
  805486:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805489:	eb 18                	jmp    8054a3 <close+0x49>
	else
		return fd_close(fd, 1);
  80548b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80548f:	be 01 00 00 00       	mov    $0x1,%esi
  805494:	48 89 c7             	mov    %rax,%rdi
  805497:	48 b8 da 52 80 00 00 	movabs $0x8052da,%rax
  80549e:	00 00 00 
  8054a1:	ff d0                	callq  *%rax
}
  8054a3:	c9                   	leaveq 
  8054a4:	c3                   	retq   

00000000008054a5 <close_all>:

void
close_all(void)
{
  8054a5:	55                   	push   %rbp
  8054a6:	48 89 e5             	mov    %rsp,%rbp
  8054a9:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8054ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8054b4:	eb 15                	jmp    8054cb <close_all+0x26>
		close(i);
  8054b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054b9:	89 c7                	mov    %eax,%edi
  8054bb:	48 b8 5a 54 80 00 00 	movabs $0x80545a,%rax
  8054c2:	00 00 00 
  8054c5:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8054c7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8054cb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8054cf:	7e e5                	jle    8054b6 <close_all+0x11>
		close(i);
}
  8054d1:	c9                   	leaveq 
  8054d2:	c3                   	retq   

00000000008054d3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8054d3:	55                   	push   %rbp
  8054d4:	48 89 e5             	mov    %rsp,%rbp
  8054d7:	48 83 ec 40          	sub    $0x40,%rsp
  8054db:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8054de:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8054e1:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8054e5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8054e8:	48 89 d6             	mov    %rdx,%rsi
  8054eb:	89 c7                	mov    %eax,%edi
  8054ed:	48 b8 4a 52 80 00 00 	movabs $0x80524a,%rax
  8054f4:	00 00 00 
  8054f7:	ff d0                	callq  *%rax
  8054f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8054fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805500:	79 08                	jns    80550a <dup+0x37>
		return r;
  805502:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805505:	e9 70 01 00 00       	jmpq   80567a <dup+0x1a7>
	close(newfdnum);
  80550a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80550d:	89 c7                	mov    %eax,%edi
  80550f:	48 b8 5a 54 80 00 00 	movabs $0x80545a,%rax
  805516:	00 00 00 
  805519:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80551b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80551e:	48 98                	cltq   
  805520:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  805526:	48 c1 e0 0c          	shl    $0xc,%rax
  80552a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80552e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805532:	48 89 c7             	mov    %rax,%rdi
  805535:	48 b8 87 51 80 00 00 	movabs $0x805187,%rax
  80553c:	00 00 00 
  80553f:	ff d0                	callq  *%rax
  805541:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  805545:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805549:	48 89 c7             	mov    %rax,%rdi
  80554c:	48 b8 87 51 80 00 00 	movabs $0x805187,%rax
  805553:	00 00 00 
  805556:	ff d0                	callq  *%rax
  805558:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80555c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805560:	48 c1 e8 15          	shr    $0x15,%rax
  805564:	48 89 c2             	mov    %rax,%rdx
  805567:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80556e:	01 00 00 
  805571:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805575:	83 e0 01             	and    $0x1,%eax
  805578:	48 85 c0             	test   %rax,%rax
  80557b:	74 73                	je     8055f0 <dup+0x11d>
  80557d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805581:	48 c1 e8 0c          	shr    $0xc,%rax
  805585:	48 89 c2             	mov    %rax,%rdx
  805588:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80558f:	01 00 00 
  805592:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805596:	83 e0 01             	and    $0x1,%eax
  805599:	48 85 c0             	test   %rax,%rax
  80559c:	74 52                	je     8055f0 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80559e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8055a2:	48 c1 e8 0c          	shr    $0xc,%rax
  8055a6:	48 89 c2             	mov    %rax,%rdx
  8055a9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8055b0:	01 00 00 
  8055b3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8055b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8055bc:	89 c1                	mov    %eax,%ecx
  8055be:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8055c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8055c6:	41 89 c8             	mov    %ecx,%r8d
  8055c9:	48 89 d1             	mov    %rdx,%rcx
  8055cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8055d1:	48 89 c6             	mov    %rax,%rsi
  8055d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8055d9:	48 b8 53 4b 80 00 00 	movabs $0x804b53,%rax
  8055e0:	00 00 00 
  8055e3:	ff d0                	callq  *%rax
  8055e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8055e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8055ec:	79 02                	jns    8055f0 <dup+0x11d>
			goto err;
  8055ee:	eb 57                	jmp    805647 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8055f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8055f4:	48 c1 e8 0c          	shr    $0xc,%rax
  8055f8:	48 89 c2             	mov    %rax,%rdx
  8055fb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805602:	01 00 00 
  805605:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805609:	25 07 0e 00 00       	and    $0xe07,%eax
  80560e:	89 c1                	mov    %eax,%ecx
  805610:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805614:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805618:	41 89 c8             	mov    %ecx,%r8d
  80561b:	48 89 d1             	mov    %rdx,%rcx
  80561e:	ba 00 00 00 00       	mov    $0x0,%edx
  805623:	48 89 c6             	mov    %rax,%rsi
  805626:	bf 00 00 00 00       	mov    $0x0,%edi
  80562b:	48 b8 53 4b 80 00 00 	movabs $0x804b53,%rax
  805632:	00 00 00 
  805635:	ff d0                	callq  *%rax
  805637:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80563a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80563e:	79 02                	jns    805642 <dup+0x16f>
		goto err;
  805640:	eb 05                	jmp    805647 <dup+0x174>

	return newfdnum;
  805642:	8b 45 c8             	mov    -0x38(%rbp),%eax
  805645:	eb 33                	jmp    80567a <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  805647:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80564b:	48 89 c6             	mov    %rax,%rsi
  80564e:	bf 00 00 00 00       	mov    $0x0,%edi
  805653:	48 b8 ae 4b 80 00 00 	movabs $0x804bae,%rax
  80565a:	00 00 00 
  80565d:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80565f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805663:	48 89 c6             	mov    %rax,%rsi
  805666:	bf 00 00 00 00       	mov    $0x0,%edi
  80566b:	48 b8 ae 4b 80 00 00 	movabs $0x804bae,%rax
  805672:	00 00 00 
  805675:	ff d0                	callq  *%rax
	return r;
  805677:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80567a:	c9                   	leaveq 
  80567b:	c3                   	retq   

000000000080567c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80567c:	55                   	push   %rbp
  80567d:	48 89 e5             	mov    %rsp,%rbp
  805680:	48 83 ec 40          	sub    $0x40,%rsp
  805684:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805687:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80568b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80568f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805693:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805696:	48 89 d6             	mov    %rdx,%rsi
  805699:	89 c7                	mov    %eax,%edi
  80569b:	48 b8 4a 52 80 00 00 	movabs $0x80524a,%rax
  8056a2:	00 00 00 
  8056a5:	ff d0                	callq  *%rax
  8056a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8056aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8056ae:	78 24                	js     8056d4 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8056b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8056b4:	8b 00                	mov    (%rax),%eax
  8056b6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8056ba:	48 89 d6             	mov    %rdx,%rsi
  8056bd:	89 c7                	mov    %eax,%edi
  8056bf:	48 b8 a3 53 80 00 00 	movabs $0x8053a3,%rax
  8056c6:	00 00 00 
  8056c9:	ff d0                	callq  *%rax
  8056cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8056ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8056d2:	79 05                	jns    8056d9 <read+0x5d>
		return r;
  8056d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8056d7:	eb 76                	jmp    80574f <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8056d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8056dd:	8b 40 08             	mov    0x8(%rax),%eax
  8056e0:	83 e0 03             	and    $0x3,%eax
  8056e3:	83 f8 01             	cmp    $0x1,%eax
  8056e6:	75 3a                	jne    805722 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8056e8:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  8056ef:	00 00 00 
  8056f2:	48 8b 00             	mov    (%rax),%rax
  8056f5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8056fb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8056fe:	89 c6                	mov    %eax,%esi
  805700:	48 bf cf 7e 80 00 00 	movabs $0x807ecf,%rdi
  805707:	00 00 00 
  80570a:	b8 00 00 00 00       	mov    $0x0,%eax
  80570f:	48 b9 1f 36 80 00 00 	movabs $0x80361f,%rcx
  805716:	00 00 00 
  805719:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80571b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805720:	eb 2d                	jmp    80574f <read+0xd3>
	}
	if (!dev->dev_read)
  805722:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805726:	48 8b 40 10          	mov    0x10(%rax),%rax
  80572a:	48 85 c0             	test   %rax,%rax
  80572d:	75 07                	jne    805736 <read+0xba>
		return -E_NOT_SUPP;
  80572f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805734:	eb 19                	jmp    80574f <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  805736:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80573a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80573e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  805742:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  805746:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80574a:	48 89 cf             	mov    %rcx,%rdi
  80574d:	ff d0                	callq  *%rax
}
  80574f:	c9                   	leaveq 
  805750:	c3                   	retq   

0000000000805751 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  805751:	55                   	push   %rbp
  805752:	48 89 e5             	mov    %rsp,%rbp
  805755:	48 83 ec 30          	sub    $0x30,%rsp
  805759:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80575c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805760:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  805764:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80576b:	eb 49                	jmp    8057b6 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80576d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805770:	48 98                	cltq   
  805772:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805776:	48 29 c2             	sub    %rax,%rdx
  805779:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80577c:	48 63 c8             	movslq %eax,%rcx
  80577f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805783:	48 01 c1             	add    %rax,%rcx
  805786:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805789:	48 89 ce             	mov    %rcx,%rsi
  80578c:	89 c7                	mov    %eax,%edi
  80578e:	48 b8 7c 56 80 00 00 	movabs $0x80567c,%rax
  805795:	00 00 00 
  805798:	ff d0                	callq  *%rax
  80579a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80579d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8057a1:	79 05                	jns    8057a8 <readn+0x57>
			return m;
  8057a3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8057a6:	eb 1c                	jmp    8057c4 <readn+0x73>
		if (m == 0)
  8057a8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8057ac:	75 02                	jne    8057b0 <readn+0x5f>
			break;
  8057ae:	eb 11                	jmp    8057c1 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8057b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8057b3:	01 45 fc             	add    %eax,-0x4(%rbp)
  8057b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8057b9:	48 98                	cltq   
  8057bb:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8057bf:	72 ac                	jb     80576d <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8057c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8057c4:	c9                   	leaveq 
  8057c5:	c3                   	retq   

00000000008057c6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8057c6:	55                   	push   %rbp
  8057c7:	48 89 e5             	mov    %rsp,%rbp
  8057ca:	48 83 ec 40          	sub    $0x40,%rsp
  8057ce:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8057d1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8057d5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8057d9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8057dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8057e0:	48 89 d6             	mov    %rdx,%rsi
  8057e3:	89 c7                	mov    %eax,%edi
  8057e5:	48 b8 4a 52 80 00 00 	movabs $0x80524a,%rax
  8057ec:	00 00 00 
  8057ef:	ff d0                	callq  *%rax
  8057f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8057f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8057f8:	78 24                	js     80581e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8057fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8057fe:	8b 00                	mov    (%rax),%eax
  805800:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805804:	48 89 d6             	mov    %rdx,%rsi
  805807:	89 c7                	mov    %eax,%edi
  805809:	48 b8 a3 53 80 00 00 	movabs $0x8053a3,%rax
  805810:	00 00 00 
  805813:	ff d0                	callq  *%rax
  805815:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805818:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80581c:	79 05                	jns    805823 <write+0x5d>
		return r;
  80581e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805821:	eb 75                	jmp    805898 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  805823:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805827:	8b 40 08             	mov    0x8(%rax),%eax
  80582a:	83 e0 03             	and    $0x3,%eax
  80582d:	85 c0                	test   %eax,%eax
  80582f:	75 3a                	jne    80586b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  805831:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  805838:	00 00 00 
  80583b:	48 8b 00             	mov    (%rax),%rax
  80583e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805844:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805847:	89 c6                	mov    %eax,%esi
  805849:	48 bf eb 7e 80 00 00 	movabs $0x807eeb,%rdi
  805850:	00 00 00 
  805853:	b8 00 00 00 00       	mov    $0x0,%eax
  805858:	48 b9 1f 36 80 00 00 	movabs $0x80361f,%rcx
  80585f:	00 00 00 
  805862:	ff d1                	callq  *%rcx
		return -E_INVAL;
  805864:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805869:	eb 2d                	jmp    805898 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  80586b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80586f:	48 8b 40 18          	mov    0x18(%rax),%rax
  805873:	48 85 c0             	test   %rax,%rax
  805876:	75 07                	jne    80587f <write+0xb9>
		return -E_NOT_SUPP;
  805878:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80587d:	eb 19                	jmp    805898 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80587f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805883:	48 8b 40 18          	mov    0x18(%rax),%rax
  805887:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80588b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80588f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  805893:	48 89 cf             	mov    %rcx,%rdi
  805896:	ff d0                	callq  *%rax
}
  805898:	c9                   	leaveq 
  805899:	c3                   	retq   

000000000080589a <seek>:

int
seek(int fdnum, off_t offset)
{
  80589a:	55                   	push   %rbp
  80589b:	48 89 e5             	mov    %rsp,%rbp
  80589e:	48 83 ec 18          	sub    $0x18,%rsp
  8058a2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8058a5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8058a8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8058ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8058af:	48 89 d6             	mov    %rdx,%rsi
  8058b2:	89 c7                	mov    %eax,%edi
  8058b4:	48 b8 4a 52 80 00 00 	movabs $0x80524a,%rax
  8058bb:	00 00 00 
  8058be:	ff d0                	callq  *%rax
  8058c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8058c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8058c7:	79 05                	jns    8058ce <seek+0x34>
		return r;
  8058c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8058cc:	eb 0f                	jmp    8058dd <seek+0x43>
	fd->fd_offset = offset;
  8058ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8058d2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8058d5:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8058d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8058dd:	c9                   	leaveq 
  8058de:	c3                   	retq   

00000000008058df <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8058df:	55                   	push   %rbp
  8058e0:	48 89 e5             	mov    %rsp,%rbp
  8058e3:	48 83 ec 30          	sub    $0x30,%rsp
  8058e7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8058ea:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8058ed:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8058f1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8058f4:	48 89 d6             	mov    %rdx,%rsi
  8058f7:	89 c7                	mov    %eax,%edi
  8058f9:	48 b8 4a 52 80 00 00 	movabs $0x80524a,%rax
  805900:	00 00 00 
  805903:	ff d0                	callq  *%rax
  805905:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805908:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80590c:	78 24                	js     805932 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80590e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805912:	8b 00                	mov    (%rax),%eax
  805914:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805918:	48 89 d6             	mov    %rdx,%rsi
  80591b:	89 c7                	mov    %eax,%edi
  80591d:	48 b8 a3 53 80 00 00 	movabs $0x8053a3,%rax
  805924:	00 00 00 
  805927:	ff d0                	callq  *%rax
  805929:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80592c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805930:	79 05                	jns    805937 <ftruncate+0x58>
		return r;
  805932:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805935:	eb 72                	jmp    8059a9 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  805937:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80593b:	8b 40 08             	mov    0x8(%rax),%eax
  80593e:	83 e0 03             	and    $0x3,%eax
  805941:	85 c0                	test   %eax,%eax
  805943:	75 3a                	jne    80597f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  805945:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  80594c:	00 00 00 
  80594f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  805952:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805958:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80595b:	89 c6                	mov    %eax,%esi
  80595d:	48 bf 08 7f 80 00 00 	movabs $0x807f08,%rdi
  805964:	00 00 00 
  805967:	b8 00 00 00 00       	mov    $0x0,%eax
  80596c:	48 b9 1f 36 80 00 00 	movabs $0x80361f,%rcx
  805973:	00 00 00 
  805976:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  805978:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80597d:	eb 2a                	jmp    8059a9 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80597f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805983:	48 8b 40 30          	mov    0x30(%rax),%rax
  805987:	48 85 c0             	test   %rax,%rax
  80598a:	75 07                	jne    805993 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80598c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805991:	eb 16                	jmp    8059a9 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  805993:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805997:	48 8b 40 30          	mov    0x30(%rax),%rax
  80599b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80599f:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8059a2:	89 ce                	mov    %ecx,%esi
  8059a4:	48 89 d7             	mov    %rdx,%rdi
  8059a7:	ff d0                	callq  *%rax
}
  8059a9:	c9                   	leaveq 
  8059aa:	c3                   	retq   

00000000008059ab <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8059ab:	55                   	push   %rbp
  8059ac:	48 89 e5             	mov    %rsp,%rbp
  8059af:	48 83 ec 30          	sub    $0x30,%rsp
  8059b3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8059b6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8059ba:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8059be:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8059c1:	48 89 d6             	mov    %rdx,%rsi
  8059c4:	89 c7                	mov    %eax,%edi
  8059c6:	48 b8 4a 52 80 00 00 	movabs $0x80524a,%rax
  8059cd:	00 00 00 
  8059d0:	ff d0                	callq  *%rax
  8059d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8059d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8059d9:	78 24                	js     8059ff <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8059db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8059df:	8b 00                	mov    (%rax),%eax
  8059e1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8059e5:	48 89 d6             	mov    %rdx,%rsi
  8059e8:	89 c7                	mov    %eax,%edi
  8059ea:	48 b8 a3 53 80 00 00 	movabs $0x8053a3,%rax
  8059f1:	00 00 00 
  8059f4:	ff d0                	callq  *%rax
  8059f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8059f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8059fd:	79 05                	jns    805a04 <fstat+0x59>
		return r;
  8059ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a02:	eb 5e                	jmp    805a62 <fstat+0xb7>
	if (!dev->dev_stat)
  805a04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a08:	48 8b 40 28          	mov    0x28(%rax),%rax
  805a0c:	48 85 c0             	test   %rax,%rax
  805a0f:	75 07                	jne    805a18 <fstat+0x6d>
		return -E_NOT_SUPP;
  805a11:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805a16:	eb 4a                	jmp    805a62 <fstat+0xb7>
	stat->st_name[0] = 0;
  805a18:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805a1c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  805a1f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805a23:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  805a2a:	00 00 00 
	stat->st_isdir = 0;
  805a2d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805a31:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  805a38:	00 00 00 
	stat->st_dev = dev;
  805a3b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805a3f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805a43:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  805a4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a4e:	48 8b 40 28          	mov    0x28(%rax),%rax
  805a52:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805a56:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  805a5a:	48 89 ce             	mov    %rcx,%rsi
  805a5d:	48 89 d7             	mov    %rdx,%rdi
  805a60:	ff d0                	callq  *%rax
}
  805a62:	c9                   	leaveq 
  805a63:	c3                   	retq   

0000000000805a64 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  805a64:	55                   	push   %rbp
  805a65:	48 89 e5             	mov    %rsp,%rbp
  805a68:	48 83 ec 20          	sub    $0x20,%rsp
  805a6c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805a70:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  805a74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805a78:	be 00 00 00 00       	mov    $0x0,%esi
  805a7d:	48 89 c7             	mov    %rax,%rdi
  805a80:	48 b8 52 5b 80 00 00 	movabs $0x805b52,%rax
  805a87:	00 00 00 
  805a8a:	ff d0                	callq  *%rax
  805a8c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805a8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805a93:	79 05                	jns    805a9a <stat+0x36>
		return fd;
  805a95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a98:	eb 2f                	jmp    805ac9 <stat+0x65>
	r = fstat(fd, stat);
  805a9a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805a9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805aa1:	48 89 d6             	mov    %rdx,%rsi
  805aa4:	89 c7                	mov    %eax,%edi
  805aa6:	48 b8 ab 59 80 00 00 	movabs $0x8059ab,%rax
  805aad:	00 00 00 
  805ab0:	ff d0                	callq  *%rax
  805ab2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  805ab5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805ab8:	89 c7                	mov    %eax,%edi
  805aba:	48 b8 5a 54 80 00 00 	movabs $0x80545a,%rax
  805ac1:	00 00 00 
  805ac4:	ff d0                	callq  *%rax
	return r;
  805ac6:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  805ac9:	c9                   	leaveq 
  805aca:	c3                   	retq   

0000000000805acb <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  805acb:	55                   	push   %rbp
  805acc:	48 89 e5             	mov    %rsp,%rbp
  805acf:	48 83 ec 10          	sub    $0x10,%rsp
  805ad3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805ad6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  805ada:	48 b8 04 30 81 00 00 	movabs $0x813004,%rax
  805ae1:	00 00 00 
  805ae4:	8b 00                	mov    (%rax),%eax
  805ae6:	85 c0                	test   %eax,%eax
  805ae8:	75 1d                	jne    805b07 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  805aea:	bf 01 00 00 00       	mov    $0x1,%edi
  805aef:	48 b8 e2 50 80 00 00 	movabs $0x8050e2,%rax
  805af6:	00 00 00 
  805af9:	ff d0                	callq  *%rax
  805afb:	48 ba 04 30 81 00 00 	movabs $0x813004,%rdx
  805b02:	00 00 00 
  805b05:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  805b07:	48 b8 04 30 81 00 00 	movabs $0x813004,%rax
  805b0e:	00 00 00 
  805b11:	8b 00                	mov    (%rax),%eax
  805b13:	8b 75 fc             	mov    -0x4(%rbp),%esi
  805b16:	b9 07 00 00 00       	mov    $0x7,%ecx
  805b1b:	48 ba 00 40 81 00 00 	movabs $0x814000,%rdx
  805b22:	00 00 00 
  805b25:	89 c7                	mov    %eax,%edi
  805b27:	48 b8 80 50 80 00 00 	movabs $0x805080,%rax
  805b2e:	00 00 00 
  805b31:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  805b33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805b37:	ba 00 00 00 00       	mov    $0x0,%edx
  805b3c:	48 89 c6             	mov    %rax,%rsi
  805b3f:	bf 00 00 00 00       	mov    $0x0,%edi
  805b44:	48 b8 7a 4f 80 00 00 	movabs $0x804f7a,%rax
  805b4b:	00 00 00 
  805b4e:	ff d0                	callq  *%rax
}
  805b50:	c9                   	leaveq 
  805b51:	c3                   	retq   

0000000000805b52 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  805b52:	55                   	push   %rbp
  805b53:	48 89 e5             	mov    %rsp,%rbp
  805b56:	48 83 ec 30          	sub    $0x30,%rsp
  805b5a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805b5e:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  805b61:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  805b68:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  805b6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  805b76:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805b7b:	75 08                	jne    805b85 <open+0x33>
	{
		return r;
  805b7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805b80:	e9 f2 00 00 00       	jmpq   805c77 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  805b85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805b89:	48 89 c7             	mov    %rax,%rdi
  805b8c:	48 b8 68 41 80 00 00 	movabs $0x804168,%rax
  805b93:	00 00 00 
  805b96:	ff d0                	callq  *%rax
  805b98:	89 45 f4             	mov    %eax,-0xc(%rbp)
  805b9b:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  805ba2:	7e 0a                	jle    805bae <open+0x5c>
	{
		return -E_BAD_PATH;
  805ba4:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  805ba9:	e9 c9 00 00 00       	jmpq   805c77 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  805bae:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  805bb5:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  805bb6:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  805bba:	48 89 c7             	mov    %rax,%rdi
  805bbd:	48 b8 b2 51 80 00 00 	movabs $0x8051b2,%rax
  805bc4:	00 00 00 
  805bc7:	ff d0                	callq  *%rax
  805bc9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805bcc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805bd0:	78 09                	js     805bdb <open+0x89>
  805bd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805bd6:	48 85 c0             	test   %rax,%rax
  805bd9:	75 08                	jne    805be3 <open+0x91>
		{
			return r;
  805bdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805bde:	e9 94 00 00 00       	jmpq   805c77 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  805be3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805be7:	ba 00 04 00 00       	mov    $0x400,%edx
  805bec:	48 89 c6             	mov    %rax,%rsi
  805bef:	48 bf 00 40 81 00 00 	movabs $0x814000,%rdi
  805bf6:	00 00 00 
  805bf9:	48 b8 66 42 80 00 00 	movabs $0x804266,%rax
  805c00:	00 00 00 
  805c03:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  805c05:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  805c0c:	00 00 00 
  805c0f:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  805c12:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  805c18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805c1c:	48 89 c6             	mov    %rax,%rsi
  805c1f:	bf 01 00 00 00       	mov    $0x1,%edi
  805c24:	48 b8 cb 5a 80 00 00 	movabs $0x805acb,%rax
  805c2b:	00 00 00 
  805c2e:	ff d0                	callq  *%rax
  805c30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805c33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805c37:	79 2b                	jns    805c64 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  805c39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805c3d:	be 00 00 00 00       	mov    $0x0,%esi
  805c42:	48 89 c7             	mov    %rax,%rdi
  805c45:	48 b8 da 52 80 00 00 	movabs $0x8052da,%rax
  805c4c:	00 00 00 
  805c4f:	ff d0                	callq  *%rax
  805c51:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805c54:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805c58:	79 05                	jns    805c5f <open+0x10d>
			{
				return d;
  805c5a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805c5d:	eb 18                	jmp    805c77 <open+0x125>
			}
			return r;
  805c5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c62:	eb 13                	jmp    805c77 <open+0x125>
		}	
		return fd2num(fd_store);
  805c64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805c68:	48 89 c7             	mov    %rax,%rdi
  805c6b:	48 b8 64 51 80 00 00 	movabs $0x805164,%rax
  805c72:	00 00 00 
  805c75:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  805c77:	c9                   	leaveq 
  805c78:	c3                   	retq   

0000000000805c79 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  805c79:	55                   	push   %rbp
  805c7a:	48 89 e5             	mov    %rsp,%rbp
  805c7d:	48 83 ec 10          	sub    $0x10,%rsp
  805c81:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  805c85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805c89:	8b 50 0c             	mov    0xc(%rax),%edx
  805c8c:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  805c93:	00 00 00 
  805c96:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  805c98:	be 00 00 00 00       	mov    $0x0,%esi
  805c9d:	bf 06 00 00 00       	mov    $0x6,%edi
  805ca2:	48 b8 cb 5a 80 00 00 	movabs $0x805acb,%rax
  805ca9:	00 00 00 
  805cac:	ff d0                	callq  *%rax
}
  805cae:	c9                   	leaveq 
  805caf:	c3                   	retq   

0000000000805cb0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  805cb0:	55                   	push   %rbp
  805cb1:	48 89 e5             	mov    %rsp,%rbp
  805cb4:	48 83 ec 30          	sub    $0x30,%rsp
  805cb8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805cbc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805cc0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  805cc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  805ccb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805cd0:	74 07                	je     805cd9 <devfile_read+0x29>
  805cd2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805cd7:	75 07                	jne    805ce0 <devfile_read+0x30>
		return -E_INVAL;
  805cd9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805cde:	eb 77                	jmp    805d57 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  805ce0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805ce4:	8b 50 0c             	mov    0xc(%rax),%edx
  805ce7:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  805cee:	00 00 00 
  805cf1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  805cf3:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  805cfa:	00 00 00 
  805cfd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805d01:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  805d05:	be 00 00 00 00       	mov    $0x0,%esi
  805d0a:	bf 03 00 00 00       	mov    $0x3,%edi
  805d0f:	48 b8 cb 5a 80 00 00 	movabs $0x805acb,%rax
  805d16:	00 00 00 
  805d19:	ff d0                	callq  *%rax
  805d1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805d1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805d22:	7f 05                	jg     805d29 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  805d24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805d27:	eb 2e                	jmp    805d57 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  805d29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805d2c:	48 63 d0             	movslq %eax,%rdx
  805d2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805d33:	48 be 00 40 81 00 00 	movabs $0x814000,%rsi
  805d3a:	00 00 00 
  805d3d:	48 89 c7             	mov    %rax,%rdi
  805d40:	48 b8 f8 44 80 00 00 	movabs $0x8044f8,%rax
  805d47:	00 00 00 
  805d4a:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  805d4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805d50:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  805d54:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  805d57:	c9                   	leaveq 
  805d58:	c3                   	retq   

0000000000805d59 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  805d59:	55                   	push   %rbp
  805d5a:	48 89 e5             	mov    %rsp,%rbp
  805d5d:	48 83 ec 30          	sub    $0x30,%rsp
  805d61:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805d65:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805d69:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  805d6d:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  805d74:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805d79:	74 07                	je     805d82 <devfile_write+0x29>
  805d7b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805d80:	75 08                	jne    805d8a <devfile_write+0x31>
		return r;
  805d82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805d85:	e9 9a 00 00 00       	jmpq   805e24 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  805d8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805d8e:	8b 50 0c             	mov    0xc(%rax),%edx
  805d91:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  805d98:	00 00 00 
  805d9b:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  805d9d:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  805da4:	00 
  805da5:	76 08                	jbe    805daf <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  805da7:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  805dae:	00 
	}
	fsipcbuf.write.req_n = n;
  805daf:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  805db6:	00 00 00 
  805db9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805dbd:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  805dc1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805dc5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805dc9:	48 89 c6             	mov    %rax,%rsi
  805dcc:	48 bf 10 40 81 00 00 	movabs $0x814010,%rdi
  805dd3:	00 00 00 
  805dd6:	48 b8 f8 44 80 00 00 	movabs $0x8044f8,%rax
  805ddd:	00 00 00 
  805de0:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  805de2:	be 00 00 00 00       	mov    $0x0,%esi
  805de7:	bf 04 00 00 00       	mov    $0x4,%edi
  805dec:	48 b8 cb 5a 80 00 00 	movabs $0x805acb,%rax
  805df3:	00 00 00 
  805df6:	ff d0                	callq  *%rax
  805df8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805dfb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805dff:	7f 20                	jg     805e21 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  805e01:	48 bf 2e 7f 80 00 00 	movabs $0x807f2e,%rdi
  805e08:	00 00 00 
  805e0b:	b8 00 00 00 00       	mov    $0x0,%eax
  805e10:	48 ba 1f 36 80 00 00 	movabs $0x80361f,%rdx
  805e17:	00 00 00 
  805e1a:	ff d2                	callq  *%rdx
		return r;
  805e1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805e1f:	eb 03                	jmp    805e24 <devfile_write+0xcb>
	}
	return r;
  805e21:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  805e24:	c9                   	leaveq 
  805e25:	c3                   	retq   

0000000000805e26 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  805e26:	55                   	push   %rbp
  805e27:	48 89 e5             	mov    %rsp,%rbp
  805e2a:	48 83 ec 20          	sub    $0x20,%rsp
  805e2e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805e32:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  805e36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805e3a:	8b 50 0c             	mov    0xc(%rax),%edx
  805e3d:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  805e44:	00 00 00 
  805e47:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  805e49:	be 00 00 00 00       	mov    $0x0,%esi
  805e4e:	bf 05 00 00 00       	mov    $0x5,%edi
  805e53:	48 b8 cb 5a 80 00 00 	movabs $0x805acb,%rax
  805e5a:	00 00 00 
  805e5d:	ff d0                	callq  *%rax
  805e5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805e62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805e66:	79 05                	jns    805e6d <devfile_stat+0x47>
		return r;
  805e68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805e6b:	eb 56                	jmp    805ec3 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  805e6d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805e71:	48 be 00 40 81 00 00 	movabs $0x814000,%rsi
  805e78:	00 00 00 
  805e7b:	48 89 c7             	mov    %rax,%rdi
  805e7e:	48 b8 d4 41 80 00 00 	movabs $0x8041d4,%rax
  805e85:	00 00 00 
  805e88:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  805e8a:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  805e91:	00 00 00 
  805e94:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  805e9a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805e9e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  805ea4:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  805eab:	00 00 00 
  805eae:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  805eb4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805eb8:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  805ebe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805ec3:	c9                   	leaveq 
  805ec4:	c3                   	retq   

0000000000805ec5 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  805ec5:	55                   	push   %rbp
  805ec6:	48 89 e5             	mov    %rsp,%rbp
  805ec9:	48 83 ec 10          	sub    $0x10,%rsp
  805ecd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805ed1:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  805ed4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805ed8:	8b 50 0c             	mov    0xc(%rax),%edx
  805edb:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  805ee2:	00 00 00 
  805ee5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  805ee7:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  805eee:	00 00 00 
  805ef1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  805ef4:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  805ef7:	be 00 00 00 00       	mov    $0x0,%esi
  805efc:	bf 02 00 00 00       	mov    $0x2,%edi
  805f01:	48 b8 cb 5a 80 00 00 	movabs $0x805acb,%rax
  805f08:	00 00 00 
  805f0b:	ff d0                	callq  *%rax
}
  805f0d:	c9                   	leaveq 
  805f0e:	c3                   	retq   

0000000000805f0f <remove>:

// Delete a file
int
remove(const char *path)
{
  805f0f:	55                   	push   %rbp
  805f10:	48 89 e5             	mov    %rsp,%rbp
  805f13:	48 83 ec 10          	sub    $0x10,%rsp
  805f17:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  805f1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805f1f:	48 89 c7             	mov    %rax,%rdi
  805f22:	48 b8 68 41 80 00 00 	movabs $0x804168,%rax
  805f29:	00 00 00 
  805f2c:	ff d0                	callq  *%rax
  805f2e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  805f33:	7e 07                	jle    805f3c <remove+0x2d>
		return -E_BAD_PATH;
  805f35:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  805f3a:	eb 33                	jmp    805f6f <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  805f3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805f40:	48 89 c6             	mov    %rax,%rsi
  805f43:	48 bf 00 40 81 00 00 	movabs $0x814000,%rdi
  805f4a:	00 00 00 
  805f4d:	48 b8 d4 41 80 00 00 	movabs $0x8041d4,%rax
  805f54:	00 00 00 
  805f57:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  805f59:	be 00 00 00 00       	mov    $0x0,%esi
  805f5e:	bf 07 00 00 00       	mov    $0x7,%edi
  805f63:	48 b8 cb 5a 80 00 00 	movabs $0x805acb,%rax
  805f6a:	00 00 00 
  805f6d:	ff d0                	callq  *%rax
}
  805f6f:	c9                   	leaveq 
  805f70:	c3                   	retq   

0000000000805f71 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  805f71:	55                   	push   %rbp
  805f72:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  805f75:	be 00 00 00 00       	mov    $0x0,%esi
  805f7a:	bf 08 00 00 00       	mov    $0x8,%edi
  805f7f:	48 b8 cb 5a 80 00 00 	movabs $0x805acb,%rax
  805f86:	00 00 00 
  805f89:	ff d0                	callq  *%rax
}
  805f8b:	5d                   	pop    %rbp
  805f8c:	c3                   	retq   

0000000000805f8d <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  805f8d:	55                   	push   %rbp
  805f8e:	48 89 e5             	mov    %rsp,%rbp
  805f91:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  805f98:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  805f9f:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  805fa6:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  805fad:	be 00 00 00 00       	mov    $0x0,%esi
  805fb2:	48 89 c7             	mov    %rax,%rdi
  805fb5:	48 b8 52 5b 80 00 00 	movabs $0x805b52,%rax
  805fbc:	00 00 00 
  805fbf:	ff d0                	callq  *%rax
  805fc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  805fc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805fc8:	79 28                	jns    805ff2 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  805fca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805fcd:	89 c6                	mov    %eax,%esi
  805fcf:	48 bf 4a 7f 80 00 00 	movabs $0x807f4a,%rdi
  805fd6:	00 00 00 
  805fd9:	b8 00 00 00 00       	mov    $0x0,%eax
  805fde:	48 ba 1f 36 80 00 00 	movabs $0x80361f,%rdx
  805fe5:	00 00 00 
  805fe8:	ff d2                	callq  *%rdx
		return fd_src;
  805fea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805fed:	e9 74 01 00 00       	jmpq   806166 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  805ff2:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  805ff9:	be 01 01 00 00       	mov    $0x101,%esi
  805ffe:	48 89 c7             	mov    %rax,%rdi
  806001:	48 b8 52 5b 80 00 00 	movabs $0x805b52,%rax
  806008:	00 00 00 
  80600b:	ff d0                	callq  *%rax
  80600d:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  806010:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  806014:	79 39                	jns    80604f <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  806016:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806019:	89 c6                	mov    %eax,%esi
  80601b:	48 bf 60 7f 80 00 00 	movabs $0x807f60,%rdi
  806022:	00 00 00 
  806025:	b8 00 00 00 00       	mov    $0x0,%eax
  80602a:	48 ba 1f 36 80 00 00 	movabs $0x80361f,%rdx
  806031:	00 00 00 
  806034:	ff d2                	callq  *%rdx
		close(fd_src);
  806036:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806039:	89 c7                	mov    %eax,%edi
  80603b:	48 b8 5a 54 80 00 00 	movabs $0x80545a,%rax
  806042:	00 00 00 
  806045:	ff d0                	callq  *%rax
		return fd_dest;
  806047:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80604a:	e9 17 01 00 00       	jmpq   806166 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80604f:	eb 74                	jmp    8060c5 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  806051:	8b 45 f4             	mov    -0xc(%rbp),%eax
  806054:	48 63 d0             	movslq %eax,%rdx
  806057:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80605e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806061:	48 89 ce             	mov    %rcx,%rsi
  806064:	89 c7                	mov    %eax,%edi
  806066:	48 b8 c6 57 80 00 00 	movabs $0x8057c6,%rax
  80606d:	00 00 00 
  806070:	ff d0                	callq  *%rax
  806072:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  806075:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  806079:	79 4a                	jns    8060c5 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80607b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80607e:	89 c6                	mov    %eax,%esi
  806080:	48 bf 7a 7f 80 00 00 	movabs $0x807f7a,%rdi
  806087:	00 00 00 
  80608a:	b8 00 00 00 00       	mov    $0x0,%eax
  80608f:	48 ba 1f 36 80 00 00 	movabs $0x80361f,%rdx
  806096:	00 00 00 
  806099:	ff d2                	callq  *%rdx
			close(fd_src);
  80609b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80609e:	89 c7                	mov    %eax,%edi
  8060a0:	48 b8 5a 54 80 00 00 	movabs $0x80545a,%rax
  8060a7:	00 00 00 
  8060aa:	ff d0                	callq  *%rax
			close(fd_dest);
  8060ac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8060af:	89 c7                	mov    %eax,%edi
  8060b1:	48 b8 5a 54 80 00 00 	movabs $0x80545a,%rax
  8060b8:	00 00 00 
  8060bb:	ff d0                	callq  *%rax
			return write_size;
  8060bd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8060c0:	e9 a1 00 00 00       	jmpq   806166 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8060c5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8060cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8060cf:	ba 00 02 00 00       	mov    $0x200,%edx
  8060d4:	48 89 ce             	mov    %rcx,%rsi
  8060d7:	89 c7                	mov    %eax,%edi
  8060d9:	48 b8 7c 56 80 00 00 	movabs $0x80567c,%rax
  8060e0:	00 00 00 
  8060e3:	ff d0                	callq  *%rax
  8060e5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8060e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8060ec:	0f 8f 5f ff ff ff    	jg     806051 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8060f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8060f6:	79 47                	jns    80613f <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8060f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8060fb:	89 c6                	mov    %eax,%esi
  8060fd:	48 bf 8d 7f 80 00 00 	movabs $0x807f8d,%rdi
  806104:	00 00 00 
  806107:	b8 00 00 00 00       	mov    $0x0,%eax
  80610c:	48 ba 1f 36 80 00 00 	movabs $0x80361f,%rdx
  806113:	00 00 00 
  806116:	ff d2                	callq  *%rdx
		close(fd_src);
  806118:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80611b:	89 c7                	mov    %eax,%edi
  80611d:	48 b8 5a 54 80 00 00 	movabs $0x80545a,%rax
  806124:	00 00 00 
  806127:	ff d0                	callq  *%rax
		close(fd_dest);
  806129:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80612c:	89 c7                	mov    %eax,%edi
  80612e:	48 b8 5a 54 80 00 00 	movabs $0x80545a,%rax
  806135:	00 00 00 
  806138:	ff d0                	callq  *%rax
		return read_size;
  80613a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80613d:	eb 27                	jmp    806166 <copy+0x1d9>
	}
	close(fd_src);
  80613f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806142:	89 c7                	mov    %eax,%edi
  806144:	48 b8 5a 54 80 00 00 	movabs $0x80545a,%rax
  80614b:	00 00 00 
  80614e:	ff d0                	callq  *%rax
	close(fd_dest);
  806150:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806153:	89 c7                	mov    %eax,%edi
  806155:	48 b8 5a 54 80 00 00 	movabs $0x80545a,%rax
  80615c:	00 00 00 
  80615f:	ff d0                	callq  *%rax
	return 0;
  806161:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  806166:	c9                   	leaveq 
  806167:	c3                   	retq   

0000000000806168 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  806168:	55                   	push   %rbp
  806169:	48 89 e5             	mov    %rsp,%rbp
  80616c:	48 83 ec 18          	sub    $0x18,%rsp
  806170:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  806174:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806178:	48 c1 e8 15          	shr    $0x15,%rax
  80617c:	48 89 c2             	mov    %rax,%rdx
  80617f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  806186:	01 00 00 
  806189:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80618d:	83 e0 01             	and    $0x1,%eax
  806190:	48 85 c0             	test   %rax,%rax
  806193:	75 07                	jne    80619c <pageref+0x34>
		return 0;
  806195:	b8 00 00 00 00       	mov    $0x0,%eax
  80619a:	eb 53                	jmp    8061ef <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80619c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8061a0:	48 c1 e8 0c          	shr    $0xc,%rax
  8061a4:	48 89 c2             	mov    %rax,%rdx
  8061a7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8061ae:	01 00 00 
  8061b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8061b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8061b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8061bd:	83 e0 01             	and    $0x1,%eax
  8061c0:	48 85 c0             	test   %rax,%rax
  8061c3:	75 07                	jne    8061cc <pageref+0x64>
		return 0;
  8061c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8061ca:	eb 23                	jmp    8061ef <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8061cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8061d0:	48 c1 e8 0c          	shr    $0xc,%rax
  8061d4:	48 89 c2             	mov    %rax,%rdx
  8061d7:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8061de:	00 00 00 
  8061e1:	48 c1 e2 04          	shl    $0x4,%rdx
  8061e5:	48 01 d0             	add    %rdx,%rax
  8061e8:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8061ec:	0f b7 c0             	movzwl %ax,%eax
}
  8061ef:	c9                   	leaveq 
  8061f0:	c3                   	retq   

00000000008061f1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8061f1:	55                   	push   %rbp
  8061f2:	48 89 e5             	mov    %rsp,%rbp
  8061f5:	48 83 ec 20          	sub    $0x20,%rsp
  8061f9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8061fc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  806200:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806203:	48 89 d6             	mov    %rdx,%rsi
  806206:	89 c7                	mov    %eax,%edi
  806208:	48 b8 4a 52 80 00 00 	movabs $0x80524a,%rax
  80620f:	00 00 00 
  806212:	ff d0                	callq  *%rax
  806214:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806217:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80621b:	79 05                	jns    806222 <fd2sockid+0x31>
		return r;
  80621d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806220:	eb 24                	jmp    806246 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  806222:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806226:	8b 10                	mov    (%rax),%edx
  806228:	48 b8 20 21 81 00 00 	movabs $0x812120,%rax
  80622f:	00 00 00 
  806232:	8b 00                	mov    (%rax),%eax
  806234:	39 c2                	cmp    %eax,%edx
  806236:	74 07                	je     80623f <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  806238:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80623d:	eb 07                	jmp    806246 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80623f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806243:	8b 40 0c             	mov    0xc(%rax),%eax
}
  806246:	c9                   	leaveq 
  806247:	c3                   	retq   

0000000000806248 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  806248:	55                   	push   %rbp
  806249:	48 89 e5             	mov    %rsp,%rbp
  80624c:	48 83 ec 20          	sub    $0x20,%rsp
  806250:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  806253:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  806257:	48 89 c7             	mov    %rax,%rdi
  80625a:	48 b8 b2 51 80 00 00 	movabs $0x8051b2,%rax
  806261:	00 00 00 
  806264:	ff d0                	callq  *%rax
  806266:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806269:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80626d:	78 26                	js     806295 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80626f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806273:	ba 07 04 00 00       	mov    $0x407,%edx
  806278:	48 89 c6             	mov    %rax,%rsi
  80627b:	bf 00 00 00 00       	mov    $0x0,%edi
  806280:	48 b8 03 4b 80 00 00 	movabs $0x804b03,%rax
  806287:	00 00 00 
  80628a:	ff d0                	callq  *%rax
  80628c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80628f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806293:	79 16                	jns    8062ab <alloc_sockfd+0x63>
		nsipc_close(sockid);
  806295:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806298:	89 c7                	mov    %eax,%edi
  80629a:	48 b8 55 67 80 00 00 	movabs $0x806755,%rax
  8062a1:	00 00 00 
  8062a4:	ff d0                	callq  *%rax
		return r;
  8062a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8062a9:	eb 3a                	jmp    8062e5 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8062ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8062af:	48 ba 20 21 81 00 00 	movabs $0x812120,%rdx
  8062b6:	00 00 00 
  8062b9:	8b 12                	mov    (%rdx),%edx
  8062bb:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8062bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8062c1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8062c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8062cc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8062cf:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8062d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8062d6:	48 89 c7             	mov    %rax,%rdi
  8062d9:	48 b8 64 51 80 00 00 	movabs $0x805164,%rax
  8062e0:	00 00 00 
  8062e3:	ff d0                	callq  *%rax
}
  8062e5:	c9                   	leaveq 
  8062e6:	c3                   	retq   

00000000008062e7 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8062e7:	55                   	push   %rbp
  8062e8:	48 89 e5             	mov    %rsp,%rbp
  8062eb:	48 83 ec 30          	sub    $0x30,%rsp
  8062ef:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8062f2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8062f6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8062fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8062fd:	89 c7                	mov    %eax,%edi
  8062ff:	48 b8 f1 61 80 00 00 	movabs $0x8061f1,%rax
  806306:	00 00 00 
  806309:	ff d0                	callq  *%rax
  80630b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80630e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806312:	79 05                	jns    806319 <accept+0x32>
		return r;
  806314:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806317:	eb 3b                	jmp    806354 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  806319:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80631d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  806321:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806324:	48 89 ce             	mov    %rcx,%rsi
  806327:	89 c7                	mov    %eax,%edi
  806329:	48 b8 32 66 80 00 00 	movabs $0x806632,%rax
  806330:	00 00 00 
  806333:	ff d0                	callq  *%rax
  806335:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806338:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80633c:	79 05                	jns    806343 <accept+0x5c>
		return r;
  80633e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806341:	eb 11                	jmp    806354 <accept+0x6d>
	return alloc_sockfd(r);
  806343:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806346:	89 c7                	mov    %eax,%edi
  806348:	48 b8 48 62 80 00 00 	movabs $0x806248,%rax
  80634f:	00 00 00 
  806352:	ff d0                	callq  *%rax
}
  806354:	c9                   	leaveq 
  806355:	c3                   	retq   

0000000000806356 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  806356:	55                   	push   %rbp
  806357:	48 89 e5             	mov    %rsp,%rbp
  80635a:	48 83 ec 20          	sub    $0x20,%rsp
  80635e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806361:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  806365:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  806368:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80636b:	89 c7                	mov    %eax,%edi
  80636d:	48 b8 f1 61 80 00 00 	movabs $0x8061f1,%rax
  806374:	00 00 00 
  806377:	ff d0                	callq  *%rax
  806379:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80637c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806380:	79 05                	jns    806387 <bind+0x31>
		return r;
  806382:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806385:	eb 1b                	jmp    8063a2 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  806387:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80638a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80638e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806391:	48 89 ce             	mov    %rcx,%rsi
  806394:	89 c7                	mov    %eax,%edi
  806396:	48 b8 b1 66 80 00 00 	movabs $0x8066b1,%rax
  80639d:	00 00 00 
  8063a0:	ff d0                	callq  *%rax
}
  8063a2:	c9                   	leaveq 
  8063a3:	c3                   	retq   

00000000008063a4 <shutdown>:

int
shutdown(int s, int how)
{
  8063a4:	55                   	push   %rbp
  8063a5:	48 89 e5             	mov    %rsp,%rbp
  8063a8:	48 83 ec 20          	sub    $0x20,%rsp
  8063ac:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8063af:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8063b2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8063b5:	89 c7                	mov    %eax,%edi
  8063b7:	48 b8 f1 61 80 00 00 	movabs $0x8061f1,%rax
  8063be:	00 00 00 
  8063c1:	ff d0                	callq  *%rax
  8063c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8063c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8063ca:	79 05                	jns    8063d1 <shutdown+0x2d>
		return r;
  8063cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8063cf:	eb 16                	jmp    8063e7 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8063d1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8063d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8063d7:	89 d6                	mov    %edx,%esi
  8063d9:	89 c7                	mov    %eax,%edi
  8063db:	48 b8 15 67 80 00 00 	movabs $0x806715,%rax
  8063e2:	00 00 00 
  8063e5:	ff d0                	callq  *%rax
}
  8063e7:	c9                   	leaveq 
  8063e8:	c3                   	retq   

00000000008063e9 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8063e9:	55                   	push   %rbp
  8063ea:	48 89 e5             	mov    %rsp,%rbp
  8063ed:	48 83 ec 10          	sub    $0x10,%rsp
  8063f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8063f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8063f9:	48 89 c7             	mov    %rax,%rdi
  8063fc:	48 b8 68 61 80 00 00 	movabs $0x806168,%rax
  806403:	00 00 00 
  806406:	ff d0                	callq  *%rax
  806408:	83 f8 01             	cmp    $0x1,%eax
  80640b:	75 17                	jne    806424 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80640d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806411:	8b 40 0c             	mov    0xc(%rax),%eax
  806414:	89 c7                	mov    %eax,%edi
  806416:	48 b8 55 67 80 00 00 	movabs $0x806755,%rax
  80641d:	00 00 00 
  806420:	ff d0                	callq  *%rax
  806422:	eb 05                	jmp    806429 <devsock_close+0x40>
	else
		return 0;
  806424:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806429:	c9                   	leaveq 
  80642a:	c3                   	retq   

000000000080642b <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80642b:	55                   	push   %rbp
  80642c:	48 89 e5             	mov    %rsp,%rbp
  80642f:	48 83 ec 20          	sub    $0x20,%rsp
  806433:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806436:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80643a:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80643d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806440:	89 c7                	mov    %eax,%edi
  806442:	48 b8 f1 61 80 00 00 	movabs $0x8061f1,%rax
  806449:	00 00 00 
  80644c:	ff d0                	callq  *%rax
  80644e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806451:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806455:	79 05                	jns    80645c <connect+0x31>
		return r;
  806457:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80645a:	eb 1b                	jmp    806477 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80645c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80645f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  806463:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806466:	48 89 ce             	mov    %rcx,%rsi
  806469:	89 c7                	mov    %eax,%edi
  80646b:	48 b8 82 67 80 00 00 	movabs $0x806782,%rax
  806472:	00 00 00 
  806475:	ff d0                	callq  *%rax
}
  806477:	c9                   	leaveq 
  806478:	c3                   	retq   

0000000000806479 <listen>:

int
listen(int s, int backlog)
{
  806479:	55                   	push   %rbp
  80647a:	48 89 e5             	mov    %rsp,%rbp
  80647d:	48 83 ec 20          	sub    $0x20,%rsp
  806481:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806484:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  806487:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80648a:	89 c7                	mov    %eax,%edi
  80648c:	48 b8 f1 61 80 00 00 	movabs $0x8061f1,%rax
  806493:	00 00 00 
  806496:	ff d0                	callq  *%rax
  806498:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80649b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80649f:	79 05                	jns    8064a6 <listen+0x2d>
		return r;
  8064a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8064a4:	eb 16                	jmp    8064bc <listen+0x43>
	return nsipc_listen(r, backlog);
  8064a6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8064a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8064ac:	89 d6                	mov    %edx,%esi
  8064ae:	89 c7                	mov    %eax,%edi
  8064b0:	48 b8 e6 67 80 00 00 	movabs $0x8067e6,%rax
  8064b7:	00 00 00 
  8064ba:	ff d0                	callq  *%rax
}
  8064bc:	c9                   	leaveq 
  8064bd:	c3                   	retq   

00000000008064be <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8064be:	55                   	push   %rbp
  8064bf:	48 89 e5             	mov    %rsp,%rbp
  8064c2:	48 83 ec 20          	sub    $0x20,%rsp
  8064c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8064ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8064ce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8064d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8064d6:	89 c2                	mov    %eax,%edx
  8064d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8064dc:	8b 40 0c             	mov    0xc(%rax),%eax
  8064df:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8064e3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8064e8:	89 c7                	mov    %eax,%edi
  8064ea:	48 b8 26 68 80 00 00 	movabs $0x806826,%rax
  8064f1:	00 00 00 
  8064f4:	ff d0                	callq  *%rax
}
  8064f6:	c9                   	leaveq 
  8064f7:	c3                   	retq   

00000000008064f8 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8064f8:	55                   	push   %rbp
  8064f9:	48 89 e5             	mov    %rsp,%rbp
  8064fc:	48 83 ec 20          	sub    $0x20,%rsp
  806500:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  806504:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  806508:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80650c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806510:	89 c2                	mov    %eax,%edx
  806512:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806516:	8b 40 0c             	mov    0xc(%rax),%eax
  806519:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80651d:	b9 00 00 00 00       	mov    $0x0,%ecx
  806522:	89 c7                	mov    %eax,%edi
  806524:	48 b8 f2 68 80 00 00 	movabs $0x8068f2,%rax
  80652b:	00 00 00 
  80652e:	ff d0                	callq  *%rax
}
  806530:	c9                   	leaveq 
  806531:	c3                   	retq   

0000000000806532 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  806532:	55                   	push   %rbp
  806533:	48 89 e5             	mov    %rsp,%rbp
  806536:	48 83 ec 10          	sub    $0x10,%rsp
  80653a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80653e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  806542:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806546:	48 be a8 7f 80 00 00 	movabs $0x807fa8,%rsi
  80654d:	00 00 00 
  806550:	48 89 c7             	mov    %rax,%rdi
  806553:	48 b8 d4 41 80 00 00 	movabs $0x8041d4,%rax
  80655a:	00 00 00 
  80655d:	ff d0                	callq  *%rax
	return 0;
  80655f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806564:	c9                   	leaveq 
  806565:	c3                   	retq   

0000000000806566 <socket>:

int
socket(int domain, int type, int protocol)
{
  806566:	55                   	push   %rbp
  806567:	48 89 e5             	mov    %rsp,%rbp
  80656a:	48 83 ec 20          	sub    $0x20,%rsp
  80656e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806571:	89 75 e8             	mov    %esi,-0x18(%rbp)
  806574:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  806577:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80657a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80657d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806580:	89 ce                	mov    %ecx,%esi
  806582:	89 c7                	mov    %eax,%edi
  806584:	48 b8 aa 69 80 00 00 	movabs $0x8069aa,%rax
  80658b:	00 00 00 
  80658e:	ff d0                	callq  *%rax
  806590:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806593:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806597:	79 05                	jns    80659e <socket+0x38>
		return r;
  806599:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80659c:	eb 11                	jmp    8065af <socket+0x49>
	return alloc_sockfd(r);
  80659e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8065a1:	89 c7                	mov    %eax,%edi
  8065a3:	48 b8 48 62 80 00 00 	movabs $0x806248,%rax
  8065aa:	00 00 00 
  8065ad:	ff d0                	callq  *%rax
}
  8065af:	c9                   	leaveq 
  8065b0:	c3                   	retq   

00000000008065b1 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8065b1:	55                   	push   %rbp
  8065b2:	48 89 e5             	mov    %rsp,%rbp
  8065b5:	48 83 ec 10          	sub    $0x10,%rsp
  8065b9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8065bc:	48 b8 08 30 81 00 00 	movabs $0x813008,%rax
  8065c3:	00 00 00 
  8065c6:	8b 00                	mov    (%rax),%eax
  8065c8:	85 c0                	test   %eax,%eax
  8065ca:	75 1d                	jne    8065e9 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8065cc:	bf 02 00 00 00       	mov    $0x2,%edi
  8065d1:	48 b8 e2 50 80 00 00 	movabs $0x8050e2,%rax
  8065d8:	00 00 00 
  8065db:	ff d0                	callq  *%rax
  8065dd:	48 ba 08 30 81 00 00 	movabs $0x813008,%rdx
  8065e4:	00 00 00 
  8065e7:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8065e9:	48 b8 08 30 81 00 00 	movabs $0x813008,%rax
  8065f0:	00 00 00 
  8065f3:	8b 00                	mov    (%rax),%eax
  8065f5:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8065f8:	b9 07 00 00 00       	mov    $0x7,%ecx
  8065fd:	48 ba 00 60 81 00 00 	movabs $0x816000,%rdx
  806604:	00 00 00 
  806607:	89 c7                	mov    %eax,%edi
  806609:	48 b8 80 50 80 00 00 	movabs $0x805080,%rax
  806610:	00 00 00 
  806613:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  806615:	ba 00 00 00 00       	mov    $0x0,%edx
  80661a:	be 00 00 00 00       	mov    $0x0,%esi
  80661f:	bf 00 00 00 00       	mov    $0x0,%edi
  806624:	48 b8 7a 4f 80 00 00 	movabs $0x804f7a,%rax
  80662b:	00 00 00 
  80662e:	ff d0                	callq  *%rax
}
  806630:	c9                   	leaveq 
  806631:	c3                   	retq   

0000000000806632 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  806632:	55                   	push   %rbp
  806633:	48 89 e5             	mov    %rsp,%rbp
  806636:	48 83 ec 30          	sub    $0x30,%rsp
  80663a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80663d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  806641:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  806645:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  80664c:	00 00 00 
  80664f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  806652:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  806654:	bf 01 00 00 00       	mov    $0x1,%edi
  806659:	48 b8 b1 65 80 00 00 	movabs $0x8065b1,%rax
  806660:	00 00 00 
  806663:	ff d0                	callq  *%rax
  806665:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806668:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80666c:	78 3e                	js     8066ac <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80666e:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  806675:	00 00 00 
  806678:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80667c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806680:	8b 40 10             	mov    0x10(%rax),%eax
  806683:	89 c2                	mov    %eax,%edx
  806685:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  806689:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80668d:	48 89 ce             	mov    %rcx,%rsi
  806690:	48 89 c7             	mov    %rax,%rdi
  806693:	48 b8 f8 44 80 00 00 	movabs $0x8044f8,%rax
  80669a:	00 00 00 
  80669d:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80669f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8066a3:	8b 50 10             	mov    0x10(%rax),%edx
  8066a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8066aa:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8066ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8066af:	c9                   	leaveq 
  8066b0:	c3                   	retq   

00000000008066b1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8066b1:	55                   	push   %rbp
  8066b2:	48 89 e5             	mov    %rsp,%rbp
  8066b5:	48 83 ec 10          	sub    $0x10,%rsp
  8066b9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8066bc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8066c0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8066c3:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  8066ca:	00 00 00 
  8066cd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8066d0:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8066d2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8066d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8066d9:	48 89 c6             	mov    %rax,%rsi
  8066dc:	48 bf 04 60 81 00 00 	movabs $0x816004,%rdi
  8066e3:	00 00 00 
  8066e6:	48 b8 f8 44 80 00 00 	movabs $0x8044f8,%rax
  8066ed:	00 00 00 
  8066f0:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8066f2:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  8066f9:	00 00 00 
  8066fc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8066ff:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  806702:	bf 02 00 00 00       	mov    $0x2,%edi
  806707:	48 b8 b1 65 80 00 00 	movabs $0x8065b1,%rax
  80670e:	00 00 00 
  806711:	ff d0                	callq  *%rax
}
  806713:	c9                   	leaveq 
  806714:	c3                   	retq   

0000000000806715 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  806715:	55                   	push   %rbp
  806716:	48 89 e5             	mov    %rsp,%rbp
  806719:	48 83 ec 10          	sub    $0x10,%rsp
  80671d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  806720:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  806723:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  80672a:	00 00 00 
  80672d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806730:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  806732:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  806739:	00 00 00 
  80673c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80673f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  806742:	bf 03 00 00 00       	mov    $0x3,%edi
  806747:	48 b8 b1 65 80 00 00 	movabs $0x8065b1,%rax
  80674e:	00 00 00 
  806751:	ff d0                	callq  *%rax
}
  806753:	c9                   	leaveq 
  806754:	c3                   	retq   

0000000000806755 <nsipc_close>:

int
nsipc_close(int s)
{
  806755:	55                   	push   %rbp
  806756:	48 89 e5             	mov    %rsp,%rbp
  806759:	48 83 ec 10          	sub    $0x10,%rsp
  80675d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  806760:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  806767:	00 00 00 
  80676a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80676d:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80676f:	bf 04 00 00 00       	mov    $0x4,%edi
  806774:	48 b8 b1 65 80 00 00 	movabs $0x8065b1,%rax
  80677b:	00 00 00 
  80677e:	ff d0                	callq  *%rax
}
  806780:	c9                   	leaveq 
  806781:	c3                   	retq   

0000000000806782 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  806782:	55                   	push   %rbp
  806783:	48 89 e5             	mov    %rsp,%rbp
  806786:	48 83 ec 10          	sub    $0x10,%rsp
  80678a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80678d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  806791:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  806794:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  80679b:	00 00 00 
  80679e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8067a1:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8067a3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8067a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8067aa:	48 89 c6             	mov    %rax,%rsi
  8067ad:	48 bf 04 60 81 00 00 	movabs $0x816004,%rdi
  8067b4:	00 00 00 
  8067b7:	48 b8 f8 44 80 00 00 	movabs $0x8044f8,%rax
  8067be:	00 00 00 
  8067c1:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8067c3:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  8067ca:	00 00 00 
  8067cd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8067d0:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8067d3:	bf 05 00 00 00       	mov    $0x5,%edi
  8067d8:	48 b8 b1 65 80 00 00 	movabs $0x8065b1,%rax
  8067df:	00 00 00 
  8067e2:	ff d0                	callq  *%rax
}
  8067e4:	c9                   	leaveq 
  8067e5:	c3                   	retq   

00000000008067e6 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8067e6:	55                   	push   %rbp
  8067e7:	48 89 e5             	mov    %rsp,%rbp
  8067ea:	48 83 ec 10          	sub    $0x10,%rsp
  8067ee:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8067f1:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8067f4:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  8067fb:	00 00 00 
  8067fe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806801:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  806803:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  80680a:	00 00 00 
  80680d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  806810:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  806813:	bf 06 00 00 00       	mov    $0x6,%edi
  806818:	48 b8 b1 65 80 00 00 	movabs $0x8065b1,%rax
  80681f:	00 00 00 
  806822:	ff d0                	callq  *%rax
}
  806824:	c9                   	leaveq 
  806825:	c3                   	retq   

0000000000806826 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  806826:	55                   	push   %rbp
  806827:	48 89 e5             	mov    %rsp,%rbp
  80682a:	48 83 ec 30          	sub    $0x30,%rsp
  80682e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806831:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  806835:	89 55 e8             	mov    %edx,-0x18(%rbp)
  806838:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80683b:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  806842:	00 00 00 
  806845:	8b 55 ec             	mov    -0x14(%rbp),%edx
  806848:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80684a:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  806851:	00 00 00 
  806854:	8b 55 e8             	mov    -0x18(%rbp),%edx
  806857:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80685a:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  806861:	00 00 00 
  806864:	8b 55 dc             	mov    -0x24(%rbp),%edx
  806867:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80686a:	bf 07 00 00 00       	mov    $0x7,%edi
  80686f:	48 b8 b1 65 80 00 00 	movabs $0x8065b1,%rax
  806876:	00 00 00 
  806879:	ff d0                	callq  *%rax
  80687b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80687e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806882:	78 69                	js     8068ed <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  806884:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80688b:	7f 08                	jg     806895 <nsipc_recv+0x6f>
  80688d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806890:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  806893:	7e 35                	jle    8068ca <nsipc_recv+0xa4>
  806895:	48 b9 af 7f 80 00 00 	movabs $0x807faf,%rcx
  80689c:	00 00 00 
  80689f:	48 ba c4 7f 80 00 00 	movabs $0x807fc4,%rdx
  8068a6:	00 00 00 
  8068a9:	be 61 00 00 00       	mov    $0x61,%esi
  8068ae:	48 bf d9 7f 80 00 00 	movabs $0x807fd9,%rdi
  8068b5:	00 00 00 
  8068b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8068bd:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  8068c4:	00 00 00 
  8068c7:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8068ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8068cd:	48 63 d0             	movslq %eax,%rdx
  8068d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8068d4:	48 be 00 60 81 00 00 	movabs $0x816000,%rsi
  8068db:	00 00 00 
  8068de:	48 89 c7             	mov    %rax,%rdi
  8068e1:	48 b8 f8 44 80 00 00 	movabs $0x8044f8,%rax
  8068e8:	00 00 00 
  8068eb:	ff d0                	callq  *%rax
	}

	return r;
  8068ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8068f0:	c9                   	leaveq 
  8068f1:	c3                   	retq   

00000000008068f2 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8068f2:	55                   	push   %rbp
  8068f3:	48 89 e5             	mov    %rsp,%rbp
  8068f6:	48 83 ec 20          	sub    $0x20,%rsp
  8068fa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8068fd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  806901:	89 55 f8             	mov    %edx,-0x8(%rbp)
  806904:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  806907:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  80690e:	00 00 00 
  806911:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806914:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  806916:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80691d:	7e 35                	jle    806954 <nsipc_send+0x62>
  80691f:	48 b9 e5 7f 80 00 00 	movabs $0x807fe5,%rcx
  806926:	00 00 00 
  806929:	48 ba c4 7f 80 00 00 	movabs $0x807fc4,%rdx
  806930:	00 00 00 
  806933:	be 6c 00 00 00       	mov    $0x6c,%esi
  806938:	48 bf d9 7f 80 00 00 	movabs $0x807fd9,%rdi
  80693f:	00 00 00 
  806942:	b8 00 00 00 00       	mov    $0x0,%eax
  806947:	49 b8 e6 33 80 00 00 	movabs $0x8033e6,%r8
  80694e:	00 00 00 
  806951:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  806954:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806957:	48 63 d0             	movslq %eax,%rdx
  80695a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80695e:	48 89 c6             	mov    %rax,%rsi
  806961:	48 bf 0c 60 81 00 00 	movabs $0x81600c,%rdi
  806968:	00 00 00 
  80696b:	48 b8 f8 44 80 00 00 	movabs $0x8044f8,%rax
  806972:	00 00 00 
  806975:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  806977:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  80697e:	00 00 00 
  806981:	8b 55 f8             	mov    -0x8(%rbp),%edx
  806984:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  806987:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  80698e:	00 00 00 
  806991:	8b 55 ec             	mov    -0x14(%rbp),%edx
  806994:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  806997:	bf 08 00 00 00       	mov    $0x8,%edi
  80699c:	48 b8 b1 65 80 00 00 	movabs $0x8065b1,%rax
  8069a3:	00 00 00 
  8069a6:	ff d0                	callq  *%rax
}
  8069a8:	c9                   	leaveq 
  8069a9:	c3                   	retq   

00000000008069aa <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8069aa:	55                   	push   %rbp
  8069ab:	48 89 e5             	mov    %rsp,%rbp
  8069ae:	48 83 ec 10          	sub    $0x10,%rsp
  8069b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8069b5:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8069b8:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8069bb:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  8069c2:	00 00 00 
  8069c5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8069c8:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8069ca:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  8069d1:	00 00 00 
  8069d4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8069d7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8069da:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  8069e1:	00 00 00 
  8069e4:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8069e7:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8069ea:	bf 09 00 00 00       	mov    $0x9,%edi
  8069ef:	48 b8 b1 65 80 00 00 	movabs $0x8065b1,%rax
  8069f6:	00 00 00 
  8069f9:	ff d0                	callq  *%rax
}
  8069fb:	c9                   	leaveq 
  8069fc:	c3                   	retq   

00000000008069fd <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8069fd:	55                   	push   %rbp
  8069fe:	48 89 e5             	mov    %rsp,%rbp
  806a01:	53                   	push   %rbx
  806a02:	48 83 ec 38          	sub    $0x38,%rsp
  806a06:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  806a0a:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  806a0e:	48 89 c7             	mov    %rax,%rdi
  806a11:	48 b8 b2 51 80 00 00 	movabs $0x8051b2,%rax
  806a18:	00 00 00 
  806a1b:	ff d0                	callq  *%rax
  806a1d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806a20:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806a24:	0f 88 bf 01 00 00    	js     806be9 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806a2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806a2e:	ba 07 04 00 00       	mov    $0x407,%edx
  806a33:	48 89 c6             	mov    %rax,%rsi
  806a36:	bf 00 00 00 00       	mov    $0x0,%edi
  806a3b:	48 b8 03 4b 80 00 00 	movabs $0x804b03,%rax
  806a42:	00 00 00 
  806a45:	ff d0                	callq  *%rax
  806a47:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806a4a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806a4e:	0f 88 95 01 00 00    	js     806be9 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  806a54:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  806a58:	48 89 c7             	mov    %rax,%rdi
  806a5b:	48 b8 b2 51 80 00 00 	movabs $0x8051b2,%rax
  806a62:	00 00 00 
  806a65:	ff d0                	callq  *%rax
  806a67:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806a6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806a6e:	0f 88 5d 01 00 00    	js     806bd1 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806a74:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806a78:	ba 07 04 00 00       	mov    $0x407,%edx
  806a7d:	48 89 c6             	mov    %rax,%rsi
  806a80:	bf 00 00 00 00       	mov    $0x0,%edi
  806a85:	48 b8 03 4b 80 00 00 	movabs $0x804b03,%rax
  806a8c:	00 00 00 
  806a8f:	ff d0                	callq  *%rax
  806a91:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806a94:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806a98:	0f 88 33 01 00 00    	js     806bd1 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  806a9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806aa2:	48 89 c7             	mov    %rax,%rdi
  806aa5:	48 b8 87 51 80 00 00 	movabs $0x805187,%rax
  806aac:	00 00 00 
  806aaf:	ff d0                	callq  *%rax
  806ab1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806ab5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806ab9:	ba 07 04 00 00       	mov    $0x407,%edx
  806abe:	48 89 c6             	mov    %rax,%rsi
  806ac1:	bf 00 00 00 00       	mov    $0x0,%edi
  806ac6:	48 b8 03 4b 80 00 00 	movabs $0x804b03,%rax
  806acd:	00 00 00 
  806ad0:	ff d0                	callq  *%rax
  806ad2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806ad5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806ad9:	79 05                	jns    806ae0 <pipe+0xe3>
		goto err2;
  806adb:	e9 d9 00 00 00       	jmpq   806bb9 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806ae0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806ae4:	48 89 c7             	mov    %rax,%rdi
  806ae7:	48 b8 87 51 80 00 00 	movabs $0x805187,%rax
  806aee:	00 00 00 
  806af1:	ff d0                	callq  *%rax
  806af3:	48 89 c2             	mov    %rax,%rdx
  806af6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806afa:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  806b00:	48 89 d1             	mov    %rdx,%rcx
  806b03:	ba 00 00 00 00       	mov    $0x0,%edx
  806b08:	48 89 c6             	mov    %rax,%rsi
  806b0b:	bf 00 00 00 00       	mov    $0x0,%edi
  806b10:	48 b8 53 4b 80 00 00 	movabs $0x804b53,%rax
  806b17:	00 00 00 
  806b1a:	ff d0                	callq  *%rax
  806b1c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806b1f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806b23:	79 1b                	jns    806b40 <pipe+0x143>
		goto err3;
  806b25:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  806b26:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806b2a:	48 89 c6             	mov    %rax,%rsi
  806b2d:	bf 00 00 00 00       	mov    $0x0,%edi
  806b32:	48 b8 ae 4b 80 00 00 	movabs $0x804bae,%rax
  806b39:	00 00 00 
  806b3c:	ff d0                	callq  *%rax
  806b3e:	eb 79                	jmp    806bb9 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  806b40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806b44:	48 ba 60 21 81 00 00 	movabs $0x812160,%rdx
  806b4b:	00 00 00 
  806b4e:	8b 12                	mov    (%rdx),%edx
  806b50:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  806b52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806b56:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  806b5d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806b61:	48 ba 60 21 81 00 00 	movabs $0x812160,%rdx
  806b68:	00 00 00 
  806b6b:	8b 12                	mov    (%rdx),%edx
  806b6d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  806b6f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806b73:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  806b7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806b7e:	48 89 c7             	mov    %rax,%rdi
  806b81:	48 b8 64 51 80 00 00 	movabs $0x805164,%rax
  806b88:	00 00 00 
  806b8b:	ff d0                	callq  *%rax
  806b8d:	89 c2                	mov    %eax,%edx
  806b8f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  806b93:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  806b95:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  806b99:	48 8d 58 04          	lea    0x4(%rax),%rbx
  806b9d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806ba1:	48 89 c7             	mov    %rax,%rdi
  806ba4:	48 b8 64 51 80 00 00 	movabs $0x805164,%rax
  806bab:	00 00 00 
  806bae:	ff d0                	callq  *%rax
  806bb0:	89 03                	mov    %eax,(%rbx)
	return 0;
  806bb2:	b8 00 00 00 00       	mov    $0x0,%eax
  806bb7:	eb 33                	jmp    806bec <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  806bb9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806bbd:	48 89 c6             	mov    %rax,%rsi
  806bc0:	bf 00 00 00 00       	mov    $0x0,%edi
  806bc5:	48 b8 ae 4b 80 00 00 	movabs $0x804bae,%rax
  806bcc:	00 00 00 
  806bcf:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  806bd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806bd5:	48 89 c6             	mov    %rax,%rsi
  806bd8:	bf 00 00 00 00       	mov    $0x0,%edi
  806bdd:	48 b8 ae 4b 80 00 00 	movabs $0x804bae,%rax
  806be4:	00 00 00 
  806be7:	ff d0                	callq  *%rax
err:
	return r;
  806be9:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  806bec:	48 83 c4 38          	add    $0x38,%rsp
  806bf0:	5b                   	pop    %rbx
  806bf1:	5d                   	pop    %rbp
  806bf2:	c3                   	retq   

0000000000806bf3 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  806bf3:	55                   	push   %rbp
  806bf4:	48 89 e5             	mov    %rsp,%rbp
  806bf7:	53                   	push   %rbx
  806bf8:	48 83 ec 28          	sub    $0x28,%rsp
  806bfc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  806c00:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  806c04:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  806c0b:	00 00 00 
  806c0e:	48 8b 00             	mov    (%rax),%rax
  806c11:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  806c17:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  806c1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806c1e:	48 89 c7             	mov    %rax,%rdi
  806c21:	48 b8 68 61 80 00 00 	movabs $0x806168,%rax
  806c28:	00 00 00 
  806c2b:	ff d0                	callq  *%rax
  806c2d:	89 c3                	mov    %eax,%ebx
  806c2f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806c33:	48 89 c7             	mov    %rax,%rdi
  806c36:	48 b8 68 61 80 00 00 	movabs $0x806168,%rax
  806c3d:	00 00 00 
  806c40:	ff d0                	callq  *%rax
  806c42:	39 c3                	cmp    %eax,%ebx
  806c44:	0f 94 c0             	sete   %al
  806c47:	0f b6 c0             	movzbl %al,%eax
  806c4a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  806c4d:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  806c54:	00 00 00 
  806c57:	48 8b 00             	mov    (%rax),%rax
  806c5a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  806c60:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  806c63:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806c66:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806c69:	75 05                	jne    806c70 <_pipeisclosed+0x7d>
			return ret;
  806c6b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  806c6e:	eb 4f                	jmp    806cbf <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  806c70:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806c73:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806c76:	74 42                	je     806cba <_pipeisclosed+0xc7>
  806c78:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  806c7c:	75 3c                	jne    806cba <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  806c7e:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  806c85:	00 00 00 
  806c88:	48 8b 00             	mov    (%rax),%rax
  806c8b:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  806c91:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  806c94:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806c97:	89 c6                	mov    %eax,%esi
  806c99:	48 bf f6 7f 80 00 00 	movabs $0x807ff6,%rdi
  806ca0:	00 00 00 
  806ca3:	b8 00 00 00 00       	mov    $0x0,%eax
  806ca8:	49 b8 1f 36 80 00 00 	movabs $0x80361f,%r8
  806caf:	00 00 00 
  806cb2:	41 ff d0             	callq  *%r8
	}
  806cb5:	e9 4a ff ff ff       	jmpq   806c04 <_pipeisclosed+0x11>
  806cba:	e9 45 ff ff ff       	jmpq   806c04 <_pipeisclosed+0x11>
}
  806cbf:	48 83 c4 28          	add    $0x28,%rsp
  806cc3:	5b                   	pop    %rbx
  806cc4:	5d                   	pop    %rbp
  806cc5:	c3                   	retq   

0000000000806cc6 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  806cc6:	55                   	push   %rbp
  806cc7:	48 89 e5             	mov    %rsp,%rbp
  806cca:	48 83 ec 30          	sub    $0x30,%rsp
  806cce:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  806cd1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  806cd5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  806cd8:	48 89 d6             	mov    %rdx,%rsi
  806cdb:	89 c7                	mov    %eax,%edi
  806cdd:	48 b8 4a 52 80 00 00 	movabs $0x80524a,%rax
  806ce4:	00 00 00 
  806ce7:	ff d0                	callq  *%rax
  806ce9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806cec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806cf0:	79 05                	jns    806cf7 <pipeisclosed+0x31>
		return r;
  806cf2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806cf5:	eb 31                	jmp    806d28 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  806cf7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806cfb:	48 89 c7             	mov    %rax,%rdi
  806cfe:	48 b8 87 51 80 00 00 	movabs $0x805187,%rax
  806d05:	00 00 00 
  806d08:	ff d0                	callq  *%rax
  806d0a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  806d0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806d12:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806d16:	48 89 d6             	mov    %rdx,%rsi
  806d19:	48 89 c7             	mov    %rax,%rdi
  806d1c:	48 b8 f3 6b 80 00 00 	movabs $0x806bf3,%rax
  806d23:	00 00 00 
  806d26:	ff d0                	callq  *%rax
}
  806d28:	c9                   	leaveq 
  806d29:	c3                   	retq   

0000000000806d2a <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  806d2a:	55                   	push   %rbp
  806d2b:	48 89 e5             	mov    %rsp,%rbp
  806d2e:	48 83 ec 40          	sub    $0x40,%rsp
  806d32:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  806d36:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  806d3a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  806d3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806d42:	48 89 c7             	mov    %rax,%rdi
  806d45:	48 b8 87 51 80 00 00 	movabs $0x805187,%rax
  806d4c:	00 00 00 
  806d4f:	ff d0                	callq  *%rax
  806d51:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  806d55:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806d59:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  806d5d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  806d64:	00 
  806d65:	e9 92 00 00 00       	jmpq   806dfc <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  806d6a:	eb 41                	jmp    806dad <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  806d6c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  806d71:	74 09                	je     806d7c <devpipe_read+0x52>
				return i;
  806d73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806d77:	e9 92 00 00 00       	jmpq   806e0e <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  806d7c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806d80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806d84:	48 89 d6             	mov    %rdx,%rsi
  806d87:	48 89 c7             	mov    %rax,%rdi
  806d8a:	48 b8 f3 6b 80 00 00 	movabs $0x806bf3,%rax
  806d91:	00 00 00 
  806d94:	ff d0                	callq  *%rax
  806d96:	85 c0                	test   %eax,%eax
  806d98:	74 07                	je     806da1 <devpipe_read+0x77>
				return 0;
  806d9a:	b8 00 00 00 00       	mov    $0x0,%eax
  806d9f:	eb 6d                	jmp    806e0e <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  806da1:	48 b8 c5 4a 80 00 00 	movabs $0x804ac5,%rax
  806da8:	00 00 00 
  806dab:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  806dad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806db1:	8b 10                	mov    (%rax),%edx
  806db3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806db7:	8b 40 04             	mov    0x4(%rax),%eax
  806dba:	39 c2                	cmp    %eax,%edx
  806dbc:	74 ae                	je     806d6c <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  806dbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806dc2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  806dc6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  806dca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806dce:	8b 00                	mov    (%rax),%eax
  806dd0:	99                   	cltd   
  806dd1:	c1 ea 1b             	shr    $0x1b,%edx
  806dd4:	01 d0                	add    %edx,%eax
  806dd6:	83 e0 1f             	and    $0x1f,%eax
  806dd9:	29 d0                	sub    %edx,%eax
  806ddb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806ddf:	48 98                	cltq   
  806de1:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  806de6:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  806de8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806dec:	8b 00                	mov    (%rax),%eax
  806dee:	8d 50 01             	lea    0x1(%rax),%edx
  806df1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806df5:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  806df7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  806dfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806e00:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  806e04:	0f 82 60 ff ff ff    	jb     806d6a <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  806e0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  806e0e:	c9                   	leaveq 
  806e0f:	c3                   	retq   

0000000000806e10 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  806e10:	55                   	push   %rbp
  806e11:	48 89 e5             	mov    %rsp,%rbp
  806e14:	48 83 ec 40          	sub    $0x40,%rsp
  806e18:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  806e1c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  806e20:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  806e24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806e28:	48 89 c7             	mov    %rax,%rdi
  806e2b:	48 b8 87 51 80 00 00 	movabs $0x805187,%rax
  806e32:	00 00 00 
  806e35:	ff d0                	callq  *%rax
  806e37:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  806e3b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806e3f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  806e43:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  806e4a:	00 
  806e4b:	e9 8e 00 00 00       	jmpq   806ede <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  806e50:	eb 31                	jmp    806e83 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  806e52:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806e56:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806e5a:	48 89 d6             	mov    %rdx,%rsi
  806e5d:	48 89 c7             	mov    %rax,%rdi
  806e60:	48 b8 f3 6b 80 00 00 	movabs $0x806bf3,%rax
  806e67:	00 00 00 
  806e6a:	ff d0                	callq  *%rax
  806e6c:	85 c0                	test   %eax,%eax
  806e6e:	74 07                	je     806e77 <devpipe_write+0x67>
				return 0;
  806e70:	b8 00 00 00 00       	mov    $0x0,%eax
  806e75:	eb 79                	jmp    806ef0 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  806e77:	48 b8 c5 4a 80 00 00 	movabs $0x804ac5,%rax
  806e7e:	00 00 00 
  806e81:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  806e83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806e87:	8b 40 04             	mov    0x4(%rax),%eax
  806e8a:	48 63 d0             	movslq %eax,%rdx
  806e8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806e91:	8b 00                	mov    (%rax),%eax
  806e93:	48 98                	cltq   
  806e95:	48 83 c0 20          	add    $0x20,%rax
  806e99:	48 39 c2             	cmp    %rax,%rdx
  806e9c:	73 b4                	jae    806e52 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  806e9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806ea2:	8b 40 04             	mov    0x4(%rax),%eax
  806ea5:	99                   	cltd   
  806ea6:	c1 ea 1b             	shr    $0x1b,%edx
  806ea9:	01 d0                	add    %edx,%eax
  806eab:	83 e0 1f             	and    $0x1f,%eax
  806eae:	29 d0                	sub    %edx,%eax
  806eb0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  806eb4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  806eb8:	48 01 ca             	add    %rcx,%rdx
  806ebb:	0f b6 0a             	movzbl (%rdx),%ecx
  806ebe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806ec2:	48 98                	cltq   
  806ec4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  806ec8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806ecc:	8b 40 04             	mov    0x4(%rax),%eax
  806ecf:	8d 50 01             	lea    0x1(%rax),%edx
  806ed2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806ed6:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  806ed9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  806ede:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806ee2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  806ee6:	0f 82 64 ff ff ff    	jb     806e50 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  806eec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  806ef0:	c9                   	leaveq 
  806ef1:	c3                   	retq   

0000000000806ef2 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  806ef2:	55                   	push   %rbp
  806ef3:	48 89 e5             	mov    %rsp,%rbp
  806ef6:	48 83 ec 20          	sub    $0x20,%rsp
  806efa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  806efe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  806f02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806f06:	48 89 c7             	mov    %rax,%rdi
  806f09:	48 b8 87 51 80 00 00 	movabs $0x805187,%rax
  806f10:	00 00 00 
  806f13:	ff d0                	callq  *%rax
  806f15:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  806f19:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806f1d:	48 be 09 80 80 00 00 	movabs $0x808009,%rsi
  806f24:	00 00 00 
  806f27:	48 89 c7             	mov    %rax,%rdi
  806f2a:	48 b8 d4 41 80 00 00 	movabs $0x8041d4,%rax
  806f31:	00 00 00 
  806f34:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  806f36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806f3a:	8b 50 04             	mov    0x4(%rax),%edx
  806f3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806f41:	8b 00                	mov    (%rax),%eax
  806f43:	29 c2                	sub    %eax,%edx
  806f45:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806f49:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  806f4f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806f53:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  806f5a:	00 00 00 
	stat->st_dev = &devpipe;
  806f5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806f61:	48 b9 60 21 81 00 00 	movabs $0x812160,%rcx
  806f68:	00 00 00 
  806f6b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  806f72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806f77:	c9                   	leaveq 
  806f78:	c3                   	retq   

0000000000806f79 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  806f79:	55                   	push   %rbp
  806f7a:	48 89 e5             	mov    %rsp,%rbp
  806f7d:	48 83 ec 10          	sub    $0x10,%rsp
  806f81:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  806f85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806f89:	48 89 c6             	mov    %rax,%rsi
  806f8c:	bf 00 00 00 00       	mov    $0x0,%edi
  806f91:	48 b8 ae 4b 80 00 00 	movabs $0x804bae,%rax
  806f98:	00 00 00 
  806f9b:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  806f9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806fa1:	48 89 c7             	mov    %rax,%rdi
  806fa4:	48 b8 87 51 80 00 00 	movabs $0x805187,%rax
  806fab:	00 00 00 
  806fae:	ff d0                	callq  *%rax
  806fb0:	48 89 c6             	mov    %rax,%rsi
  806fb3:	bf 00 00 00 00       	mov    $0x0,%edi
  806fb8:	48 b8 ae 4b 80 00 00 	movabs $0x804bae,%rax
  806fbf:	00 00 00 
  806fc2:	ff d0                	callq  *%rax
}
  806fc4:	c9                   	leaveq 
  806fc5:	c3                   	retq   

0000000000806fc6 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  806fc6:	55                   	push   %rbp
  806fc7:	48 89 e5             	mov    %rsp,%rbp
  806fca:	48 83 ec 20          	sub    $0x20,%rsp
  806fce:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  806fd1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806fd4:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  806fd7:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  806fdb:	be 01 00 00 00       	mov    $0x1,%esi
  806fe0:	48 89 c7             	mov    %rax,%rdi
  806fe3:	48 b8 bb 49 80 00 00 	movabs $0x8049bb,%rax
  806fea:	00 00 00 
  806fed:	ff d0                	callq  *%rax
}
  806fef:	c9                   	leaveq 
  806ff0:	c3                   	retq   

0000000000806ff1 <getchar>:

int
getchar(void)
{
  806ff1:	55                   	push   %rbp
  806ff2:	48 89 e5             	mov    %rsp,%rbp
  806ff5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  806ff9:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  806ffd:	ba 01 00 00 00       	mov    $0x1,%edx
  807002:	48 89 c6             	mov    %rax,%rsi
  807005:	bf 00 00 00 00       	mov    $0x0,%edi
  80700a:	48 b8 7c 56 80 00 00 	movabs $0x80567c,%rax
  807011:	00 00 00 
  807014:	ff d0                	callq  *%rax
  807016:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  807019:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80701d:	79 05                	jns    807024 <getchar+0x33>
		return r;
  80701f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807022:	eb 14                	jmp    807038 <getchar+0x47>
	if (r < 1)
  807024:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807028:	7f 07                	jg     807031 <getchar+0x40>
		return -E_EOF;
  80702a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80702f:	eb 07                	jmp    807038 <getchar+0x47>
	return c;
  807031:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  807035:	0f b6 c0             	movzbl %al,%eax
}
  807038:	c9                   	leaveq 
  807039:	c3                   	retq   

000000000080703a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80703a:	55                   	push   %rbp
  80703b:	48 89 e5             	mov    %rsp,%rbp
  80703e:	48 83 ec 20          	sub    $0x20,%rsp
  807042:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  807045:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  807049:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80704c:	48 89 d6             	mov    %rdx,%rsi
  80704f:	89 c7                	mov    %eax,%edi
  807051:	48 b8 4a 52 80 00 00 	movabs $0x80524a,%rax
  807058:	00 00 00 
  80705b:	ff d0                	callq  *%rax
  80705d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  807060:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807064:	79 05                	jns    80706b <iscons+0x31>
		return r;
  807066:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807069:	eb 1a                	jmp    807085 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80706b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80706f:	8b 10                	mov    (%rax),%edx
  807071:	48 b8 a0 21 81 00 00 	movabs $0x8121a0,%rax
  807078:	00 00 00 
  80707b:	8b 00                	mov    (%rax),%eax
  80707d:	39 c2                	cmp    %eax,%edx
  80707f:	0f 94 c0             	sete   %al
  807082:	0f b6 c0             	movzbl %al,%eax
}
  807085:	c9                   	leaveq 
  807086:	c3                   	retq   

0000000000807087 <opencons>:

int
opencons(void)
{
  807087:	55                   	push   %rbp
  807088:	48 89 e5             	mov    %rsp,%rbp
  80708b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80708f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  807093:	48 89 c7             	mov    %rax,%rdi
  807096:	48 b8 b2 51 80 00 00 	movabs $0x8051b2,%rax
  80709d:	00 00 00 
  8070a0:	ff d0                	callq  *%rax
  8070a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8070a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8070a9:	79 05                	jns    8070b0 <opencons+0x29>
		return r;
  8070ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8070ae:	eb 5b                	jmp    80710b <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8070b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8070b4:	ba 07 04 00 00       	mov    $0x407,%edx
  8070b9:	48 89 c6             	mov    %rax,%rsi
  8070bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8070c1:	48 b8 03 4b 80 00 00 	movabs $0x804b03,%rax
  8070c8:	00 00 00 
  8070cb:	ff d0                	callq  *%rax
  8070cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8070d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8070d4:	79 05                	jns    8070db <opencons+0x54>
		return r;
  8070d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8070d9:	eb 30                	jmp    80710b <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8070db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8070df:	48 ba a0 21 81 00 00 	movabs $0x8121a0,%rdx
  8070e6:	00 00 00 
  8070e9:	8b 12                	mov    (%rdx),%edx
  8070eb:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8070ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8070f1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8070f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8070fc:	48 89 c7             	mov    %rax,%rdi
  8070ff:	48 b8 64 51 80 00 00 	movabs $0x805164,%rax
  807106:	00 00 00 
  807109:	ff d0                	callq  *%rax
}
  80710b:	c9                   	leaveq 
  80710c:	c3                   	retq   

000000000080710d <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80710d:	55                   	push   %rbp
  80710e:	48 89 e5             	mov    %rsp,%rbp
  807111:	48 83 ec 30          	sub    $0x30,%rsp
  807115:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  807119:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80711d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  807121:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  807126:	75 07                	jne    80712f <devcons_read+0x22>
		return 0;
  807128:	b8 00 00 00 00       	mov    $0x0,%eax
  80712d:	eb 4b                	jmp    80717a <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80712f:	eb 0c                	jmp    80713d <devcons_read+0x30>
		sys_yield();
  807131:	48 b8 c5 4a 80 00 00 	movabs $0x804ac5,%rax
  807138:	00 00 00 
  80713b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80713d:	48 b8 05 4a 80 00 00 	movabs $0x804a05,%rax
  807144:	00 00 00 
  807147:	ff d0                	callq  *%rax
  807149:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80714c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807150:	74 df                	je     807131 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  807152:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807156:	79 05                	jns    80715d <devcons_read+0x50>
		return c;
  807158:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80715b:	eb 1d                	jmp    80717a <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80715d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  807161:	75 07                	jne    80716a <devcons_read+0x5d>
		return 0;
  807163:	b8 00 00 00 00       	mov    $0x0,%eax
  807168:	eb 10                	jmp    80717a <devcons_read+0x6d>
	*(char*)vbuf = c;
  80716a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80716d:	89 c2                	mov    %eax,%edx
  80716f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  807173:	88 10                	mov    %dl,(%rax)
	return 1;
  807175:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80717a:	c9                   	leaveq 
  80717b:	c3                   	retq   

000000000080717c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80717c:	55                   	push   %rbp
  80717d:	48 89 e5             	mov    %rsp,%rbp
  807180:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  807187:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80718e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  807195:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80719c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8071a3:	eb 76                	jmp    80721b <devcons_write+0x9f>
		m = n - tot;
  8071a5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8071ac:	89 c2                	mov    %eax,%edx
  8071ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8071b1:	29 c2                	sub    %eax,%edx
  8071b3:	89 d0                	mov    %edx,%eax
  8071b5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8071b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8071bb:	83 f8 7f             	cmp    $0x7f,%eax
  8071be:	76 07                	jbe    8071c7 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8071c0:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8071c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8071ca:	48 63 d0             	movslq %eax,%rdx
  8071cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8071d0:	48 63 c8             	movslq %eax,%rcx
  8071d3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8071da:	48 01 c1             	add    %rax,%rcx
  8071dd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8071e4:	48 89 ce             	mov    %rcx,%rsi
  8071e7:	48 89 c7             	mov    %rax,%rdi
  8071ea:	48 b8 f8 44 80 00 00 	movabs $0x8044f8,%rax
  8071f1:	00 00 00 
  8071f4:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8071f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8071f9:	48 63 d0             	movslq %eax,%rdx
  8071fc:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  807203:	48 89 d6             	mov    %rdx,%rsi
  807206:	48 89 c7             	mov    %rax,%rdi
  807209:	48 b8 bb 49 80 00 00 	movabs $0x8049bb,%rax
  807210:	00 00 00 
  807213:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  807215:	8b 45 f8             	mov    -0x8(%rbp),%eax
  807218:	01 45 fc             	add    %eax,-0x4(%rbp)
  80721b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80721e:	48 98                	cltq   
  807220:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  807227:	0f 82 78 ff ff ff    	jb     8071a5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80722d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  807230:	c9                   	leaveq 
  807231:	c3                   	retq   

0000000000807232 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  807232:	55                   	push   %rbp
  807233:	48 89 e5             	mov    %rsp,%rbp
  807236:	48 83 ec 08          	sub    $0x8,%rsp
  80723a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80723e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  807243:	c9                   	leaveq 
  807244:	c3                   	retq   

0000000000807245 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  807245:	55                   	push   %rbp
  807246:	48 89 e5             	mov    %rsp,%rbp
  807249:	48 83 ec 10          	sub    $0x10,%rsp
  80724d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  807251:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  807255:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807259:	48 be 15 80 80 00 00 	movabs $0x808015,%rsi
  807260:	00 00 00 
  807263:	48 89 c7             	mov    %rax,%rdi
  807266:	48 b8 d4 41 80 00 00 	movabs $0x8041d4,%rax
  80726d:	00 00 00 
  807270:	ff d0                	callq  *%rax
	return 0;
  807272:	b8 00 00 00 00       	mov    $0x0,%eax
}
  807277:	c9                   	leaveq 
  807278:	c3                   	retq   
