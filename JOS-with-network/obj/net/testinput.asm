
obj/net/testinput:     file format elf64-x86-64


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
  80003c:	e8 59 08 00 00       	callq  80089a <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <announce>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


    static void
announce(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 30          	sub    $0x30,%rsp
    // with ARP requests.  Ideally, we would use gratuitous ARP
    // for this, but QEMU's ARP implementation is dumb and only
    // listens for very specific ARP requests, such as requests
    // for the gateway IP.

    uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  80004b:	c6 45 e0 52          	movb   $0x52,-0x20(%rbp)
  80004f:	c6 45 e1 54          	movb   $0x54,-0x1f(%rbp)
  800053:	c6 45 e2 00          	movb   $0x0,-0x1e(%rbp)
  800057:	c6 45 e3 12          	movb   $0x12,-0x1d(%rbp)
  80005b:	c6 45 e4 34          	movb   $0x34,-0x1c(%rbp)
  80005f:	c6 45 e5 56          	movb   $0x56,-0x1b(%rbp)
    uint32_t myip = inet_addr(IP);
  800063:	48 bf 20 53 80 00 00 	movabs $0x805320,%rdi
  80006a:	00 00 00 
  80006d:	48 b8 75 4e 80 00 00 	movabs $0x804e75,%rax
  800074:	00 00 00 
  800077:	ff d0                	callq  *%rax
  800079:	89 45 dc             	mov    %eax,-0x24(%rbp)
    uint32_t gwip = inet_addr(DEFAULT);
  80007c:	48 bf 2a 53 80 00 00 	movabs $0x80532a,%rdi
  800083:	00 00 00 
  800086:	48 b8 75 4e 80 00 00 	movabs $0x804e75,%rax
  80008d:	00 00 00 
  800090:	ff d0                	callq  *%rax
  800092:	89 45 d8             	mov    %eax,-0x28(%rbp)
    int r;

    if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  800095:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80009c:	00 00 00 
  80009f:	48 8b 00             	mov    (%rax),%rax
  8000a2:	ba 07 00 00 00       	mov    $0x7,%edx
  8000a7:	48 89 c6             	mov    %rax,%rsi
  8000aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8000af:	48 b8 65 20 80 00 00 	movabs $0x802065,%rax
  8000b6:	00 00 00 
  8000b9:	ff d0                	callq  *%rax
  8000bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000c2:	79 30                	jns    8000f4 <announce+0xb1>
        panic("sys_page_map: %e", r);
  8000c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c7:	89 c1                	mov    %eax,%ecx
  8000c9:	48 ba 33 53 80 00 00 	movabs $0x805333,%rdx
  8000d0:	00 00 00 
  8000d3:	be 19 00 00 00       	mov    $0x19,%esi
  8000d8:	48 bf 44 53 80 00 00 	movabs $0x805344,%rdi
  8000df:	00 00 00 
  8000e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e7:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  8000ee:	00 00 00 
  8000f1:	41 ff d0             	callq  *%r8

    struct etharp_hdr *arp = (struct etharp_hdr*)pkt->jp_data;
  8000f4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8000fb:	00 00 00 
  8000fe:	48 8b 00             	mov    (%rax),%rax
  800101:	48 83 c0 04          	add    $0x4,%rax
  800105:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    pkt->jp_len = sizeof(*arp);
  800109:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800110:	00 00 00 
  800113:	48 8b 00             	mov    (%rax),%rax
  800116:	c7 00 2a 00 00 00    	movl   $0x2a,(%rax)

    memset(arp->ethhdr.dest.addr, 0xff, ETHARP_HWADDR_LEN);
  80011c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800120:	ba 06 00 00 00       	mov    $0x6,%edx
  800125:	be ff 00 00 00       	mov    $0xff,%esi
  80012a:	48 89 c7             	mov    %rax,%rdi
  80012d:	48 b8 cf 19 80 00 00 	movabs $0x8019cf,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
    memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  800139:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80013d:	48 8d 48 06          	lea    0x6(%rax),%rcx
  800141:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800145:	ba 06 00 00 00       	mov    $0x6,%edx
  80014a:	48 89 c6             	mov    %rax,%rsi
  80014d:	48 89 cf             	mov    %rcx,%rdi
  800150:	48 b8 71 1b 80 00 00 	movabs $0x801b71,%rax
  800157:	00 00 00 
  80015a:	ff d0                	callq  *%rax
    arp->ethhdr.type = htons(ETHTYPE_ARP);
  80015c:	bf 06 08 00 00       	mov    $0x806,%edi
  800161:	48 b8 84 52 80 00 00 	movabs $0x805284,%rax
  800168:	00 00 00 
  80016b:	ff d0                	callq  *%rax
  80016d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800171:	66 89 42 0c          	mov    %ax,0xc(%rdx)
    arp->hwtype = htons(1); // Ethernet
  800175:	bf 01 00 00 00       	mov    $0x1,%edi
  80017a:	48 b8 84 52 80 00 00 	movabs $0x805284,%rax
  800181:	00 00 00 
  800184:	ff d0                	callq  *%rax
  800186:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80018a:	66 89 42 0e          	mov    %ax,0xe(%rdx)
    arp->proto = htons(ETHTYPE_IP);
  80018e:	bf 00 08 00 00       	mov    $0x800,%edi
  800193:	48 b8 84 52 80 00 00 	movabs $0x805284,%rax
  80019a:	00 00 00 
  80019d:	ff d0                	callq  *%rax
  80019f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001a3:	66 89 42 10          	mov    %ax,0x10(%rdx)
    arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  8001a7:	bf 04 06 00 00       	mov    $0x604,%edi
  8001ac:	48 b8 84 52 80 00 00 	movabs $0x805284,%rax
  8001b3:	00 00 00 
  8001b6:	ff d0                	callq  *%rax
  8001b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001bc:	66 89 42 12          	mov    %ax,0x12(%rdx)
    arp->opcode = htons(ARP_REQUEST);
  8001c0:	bf 01 00 00 00       	mov    $0x1,%edi
  8001c5:	48 b8 84 52 80 00 00 	movabs $0x805284,%rax
  8001cc:	00 00 00 
  8001cf:	ff d0                	callq  *%rax
  8001d1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d5:	66 89 42 14          	mov    %ax,0x14(%rdx)
    memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  8001d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001dd:	48 8d 48 16          	lea    0x16(%rax),%rcx
  8001e1:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8001e5:	ba 06 00 00 00       	mov    $0x6,%edx
  8001ea:	48 89 c6             	mov    %rax,%rsi
  8001ed:	48 89 cf             	mov    %rcx,%rdi
  8001f0:	48 b8 71 1b 80 00 00 	movabs $0x801b71,%rax
  8001f7:	00 00 00 
  8001fa:	ff d0                	callq  *%rax
    memcpy(arp->sipaddr.addrw, &myip, 4);
  8001fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800200:	48 8d 48 1c          	lea    0x1c(%rax),%rcx
  800204:	48 8d 45 dc          	lea    -0x24(%rbp),%rax
  800208:	ba 04 00 00 00       	mov    $0x4,%edx
  80020d:	48 89 c6             	mov    %rax,%rsi
  800210:	48 89 cf             	mov    %rcx,%rdi
  800213:	48 b8 71 1b 80 00 00 	movabs $0x801b71,%rax
  80021a:	00 00 00 
  80021d:	ff d0                	callq  *%rax
    memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  80021f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800223:	48 83 c0 20          	add    $0x20,%rax
  800227:	ba 06 00 00 00       	mov    $0x6,%edx
  80022c:	be 00 00 00 00       	mov    $0x0,%esi
  800231:	48 89 c7             	mov    %rax,%rdi
  800234:	48 b8 cf 19 80 00 00 	movabs $0x8019cf,%rax
  80023b:	00 00 00 
  80023e:	ff d0                	callq  *%rax
    memcpy(arp->dipaddr.addrw, &gwip, 4);
  800240:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800244:	48 8d 48 26          	lea    0x26(%rax),%rcx
  800248:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80024c:	ba 04 00 00 00       	mov    $0x4,%edx
  800251:	48 89 c6             	mov    %rax,%rsi
  800254:	48 89 cf             	mov    %rcx,%rdi
  800257:	48 b8 71 1b 80 00 00 	movabs $0x801b71,%rax
  80025e:	00 00 00 
  800261:	ff d0                	callq  *%rax

    ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  800263:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80026a:	00 00 00 
  80026d:	48 8b 10             	mov    (%rax),%rdx
  800270:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800277:	00 00 00 
  80027a:	8b 00                	mov    (%rax),%eax
  80027c:	b9 07 00 00 00       	mov    $0x7,%ecx
  800281:	be 0b 00 00 00       	mov    $0xb,%esi
  800286:	89 c7                	mov    %eax,%edi
  800288:	48 b8 3c 2b 80 00 00 	movabs $0x802b3c,%rax
  80028f:	00 00 00 
  800292:	ff d0                	callq  *%rax
    sys_page_unmap(0, pkt);
  800294:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80029b:	00 00 00 
  80029e:	48 8b 00             	mov    (%rax),%rax
  8002a1:	48 89 c6             	mov    %rax,%rsi
  8002a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8002a9:	48 b8 10 21 80 00 00 	movabs $0x802110,%rax
  8002b0:	00 00 00 
  8002b3:	ff d0                	callq  *%rax
}
  8002b5:	c9                   	leaveq 
  8002b6:	c3                   	retq   

00000000008002b7 <hexdump>:

    static void
hexdump(const char *prefix, const void *data, int len)
{
  8002b7:	55                   	push   %rbp
  8002b8:	48 89 e5             	mov    %rsp,%rbp
  8002bb:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  8002c2:	48 89 7d 88          	mov    %rdi,-0x78(%rbp)
  8002c6:	48 89 75 80          	mov    %rsi,-0x80(%rbp)
  8002ca:	89 95 7c ff ff ff    	mov    %edx,-0x84(%rbp)
    int i;
    char buf[80];
    char *end = buf + sizeof(buf);
  8002d0:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8002d4:	48 83 c0 50          	add    $0x50,%rax
  8002d8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    char *out = NULL;
  8002dc:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8002e3:	00 
    for (i = 0; i < len; i++) {
  8002e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8002eb:	e9 41 01 00 00       	jmpq   800431 <hexdump+0x17a>
        if (i % 16 == 0)
  8002f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002f3:	83 e0 0f             	and    $0xf,%eax
  8002f6:	85 c0                	test   %eax,%eax
  8002f8:	75 4d                	jne    800347 <hexdump+0x90>
            out = buf + snprintf(buf, end - buf,
  8002fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8002fe:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  800302:	48 29 c2             	sub    %rax,%rdx
  800305:	48 89 d0             	mov    %rdx,%rax
  800308:	89 c6                	mov    %eax,%esi
  80030a:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80030d:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
  800311:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  800315:	41 89 c8             	mov    %ecx,%r8d
  800318:	48 89 d1             	mov    %rdx,%rcx
  80031b:	48 ba 54 53 80 00 00 	movabs $0x805354,%rdx
  800322:	00 00 00 
  800325:	48 89 c7             	mov    %rax,%rdi
  800328:	b8 00 00 00 00       	mov    $0x0,%eax
  80032d:	49 b9 e9 15 80 00 00 	movabs $0x8015e9,%r9
  800334:	00 00 00 
  800337:	41 ff d1             	callq  *%r9
  80033a:	48 98                	cltq   
  80033c:	48 8d 55 90          	lea    -0x70(%rbp),%rdx
  800340:	48 01 d0             	add    %rdx,%rax
  800343:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
                    "%s%04x   ", prefix, i);
        out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
  800347:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80034a:	48 63 d0             	movslq %eax,%rdx
  80034d:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800351:	48 01 d0             	add    %rdx,%rax
  800354:	0f b6 00             	movzbl (%rax),%eax
  800357:	0f b6 d0             	movzbl %al,%edx
  80035a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80035e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800362:	48 29 c1             	sub    %rax,%rcx
  800365:	48 89 c8             	mov    %rcx,%rax
  800368:	89 c6                	mov    %eax,%esi
  80036a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80036e:	89 d1                	mov    %edx,%ecx
  800370:	48 ba 5e 53 80 00 00 	movabs $0x80535e,%rdx
  800377:	00 00 00 
  80037a:	48 89 c7             	mov    %rax,%rdi
  80037d:	b8 00 00 00 00       	mov    $0x0,%eax
  800382:	49 b8 e9 15 80 00 00 	movabs $0x8015e9,%r8
  800389:	00 00 00 
  80038c:	41 ff d0             	callq  *%r8
  80038f:	48 98                	cltq   
  800391:	48 01 45 f0          	add    %rax,-0x10(%rbp)
        if (i % 16 == 15 || i == len - 1)
  800395:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800398:	99                   	cltd   
  800399:	c1 ea 1c             	shr    $0x1c,%edx
  80039c:	01 d0                	add    %edx,%eax
  80039e:	83 e0 0f             	and    $0xf,%eax
  8003a1:	29 d0                	sub    %edx,%eax
  8003a3:	83 f8 0f             	cmp    $0xf,%eax
  8003a6:	74 0e                	je     8003b6 <hexdump+0xff>
  8003a8:	8b 85 7c ff ff ff    	mov    -0x84(%rbp),%eax
  8003ae:	83 e8 01             	sub    $0x1,%eax
  8003b1:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8003b4:	75 33                	jne    8003e9 <hexdump+0x132>
            cprintf("%.*s\n", out - buf, buf);
  8003b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ba:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8003be:	48 89 d1             	mov    %rdx,%rcx
  8003c1:	48 29 c1             	sub    %rax,%rcx
  8003c4:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8003c8:	48 89 c2             	mov    %rax,%rdx
  8003cb:	48 89 ce             	mov    %rcx,%rsi
  8003ce:	48 bf 63 53 80 00 00 	movabs $0x805363,%rdi
  8003d5:	00 00 00 
  8003d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8003dd:	48 b9 81 0b 80 00 00 	movabs $0x800b81,%rcx
  8003e4:	00 00 00 
  8003e7:	ff d1                	callq  *%rcx
        if (i % 2 == 1)
  8003e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003ec:	99                   	cltd   
  8003ed:	c1 ea 1f             	shr    $0x1f,%edx
  8003f0:	01 d0                	add    %edx,%eax
  8003f2:	83 e0 01             	and    $0x1,%eax
  8003f5:	29 d0                	sub    %edx,%eax
  8003f7:	83 f8 01             	cmp    $0x1,%eax
  8003fa:	75 0f                	jne    80040b <hexdump+0x154>
            *(out++) = ' ';
  8003fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800400:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800404:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  800408:	c6 00 20             	movb   $0x20,(%rax)
        if (i % 16 == 7)
  80040b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80040e:	99                   	cltd   
  80040f:	c1 ea 1c             	shr    $0x1c,%edx
  800412:	01 d0                	add    %edx,%eax
  800414:	83 e0 0f             	and    $0xf,%eax
  800417:	29 d0                	sub    %edx,%eax
  800419:	83 f8 07             	cmp    $0x7,%eax
  80041c:	75 0f                	jne    80042d <hexdump+0x176>
            *(out++) = ' ';
  80041e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800422:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800426:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  80042a:	c6 00 20             	movb   $0x20,(%rax)
{
    int i;
    char buf[80];
    char *end = buf + sizeof(buf);
    char *out = NULL;
    for (i = 0; i < len; i++) {
  80042d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800431:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800434:	3b 85 7c ff ff ff    	cmp    -0x84(%rbp),%eax
  80043a:	0f 8c b0 fe ff ff    	jl     8002f0 <hexdump+0x39>
        if (i % 2 == 1)
            *(out++) = ' ';
        if (i % 16 == 7)
            *(out++) = ' ';
    }
}
  800440:	c9                   	leaveq 
  800441:	c3                   	retq   

0000000000800442 <umain>:

    void
umain(int argc, char **argv)
{
  800442:	55                   	push   %rbp
  800443:	48 89 e5             	mov    %rsp,%rbp
  800446:	53                   	push   %rbx
  800447:	48 83 ec 38          	sub    $0x38,%rsp
  80044b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80044e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
    envid_t ns_envid = sys_getenvid();
  800452:	48 b8 e9 1f 80 00 00 	movabs $0x801fe9,%rax
  800459:	00 00 00 
  80045c:	ff d0                	callq  *%rax
  80045e:	89 45 e8             	mov    %eax,-0x18(%rbp)
    int i, r, first = 1;
  800461:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)

    binaryname = "testinput";
  800468:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80046f:	00 00 00 
  800472:	48 bb 69 53 80 00 00 	movabs $0x805369,%rbx
  800479:	00 00 00 
  80047c:	48 89 18             	mov    %rbx,(%rax)

    output_envid = fork();
  80047f:	48 b8 85 27 80 00 00 	movabs $0x802785,%rax
  800486:	00 00 00 
  800489:	ff d0                	callq  *%rax
  80048b:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  800492:	00 00 00 
  800495:	89 02                	mov    %eax,(%rdx)
    if (output_envid < 0)
  800497:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80049e:	00 00 00 
  8004a1:	8b 00                	mov    (%rax),%eax
  8004a3:	85 c0                	test   %eax,%eax
  8004a5:	79 2a                	jns    8004d1 <umain+0x8f>
        panic("error forking");
  8004a7:	48 ba 73 53 80 00 00 	movabs $0x805373,%rdx
  8004ae:	00 00 00 
  8004b1:	be 4d 00 00 00       	mov    $0x4d,%esi
  8004b6:	48 bf 44 53 80 00 00 	movabs $0x805344,%rdi
  8004bd:	00 00 00 
  8004c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c5:	48 b9 48 09 80 00 00 	movabs $0x800948,%rcx
  8004cc:	00 00 00 
  8004cf:	ff d1                	callq  *%rcx
    else if (output_envid == 0) {
  8004d1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8004d8:	00 00 00 
  8004db:	8b 00                	mov    (%rax),%eax
  8004dd:	85 c0                	test   %eax,%eax
  8004df:	75 16                	jne    8004f7 <umain+0xb5>
        output(ns_envid);
  8004e1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8004e4:	89 c7                	mov    %eax,%edi
  8004e6:	48 b8 3e 08 80 00 00 	movabs $0x80083e,%rax
  8004ed:	00 00 00 
  8004f0:	ff d0                	callq  *%rax
        return;
  8004f2:	e9 fb 01 00 00       	jmpq   8006f2 <umain+0x2b0>
    }

    input_envid = fork();
  8004f7:	48 b8 85 27 80 00 00 	movabs $0x802785,%rax
  8004fe:	00 00 00 
  800501:	ff d0                	callq  *%rax
  800503:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  80050a:	00 00 00 
  80050d:	89 02                	mov    %eax,(%rdx)
    if (input_envid < 0)
  80050f:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  800516:	00 00 00 
  800519:	8b 00                	mov    (%rax),%eax
  80051b:	85 c0                	test   %eax,%eax
  80051d:	79 2a                	jns    800549 <umain+0x107>
        panic("error forking");
  80051f:	48 ba 73 53 80 00 00 	movabs $0x805373,%rdx
  800526:	00 00 00 
  800529:	be 55 00 00 00       	mov    $0x55,%esi
  80052e:	48 bf 44 53 80 00 00 	movabs $0x805344,%rdi
  800535:	00 00 00 
  800538:	b8 00 00 00 00       	mov    $0x0,%eax
  80053d:	48 b9 48 09 80 00 00 	movabs $0x800948,%rcx
  800544:	00 00 00 
  800547:	ff d1                	callq  *%rcx
    else if (input_envid == 0) {
  800549:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  800550:	00 00 00 
  800553:	8b 00                	mov    (%rax),%eax
  800555:	85 c0                	test   %eax,%eax
  800557:	75 16                	jne    80056f <umain+0x12d>
        input(ns_envid);
  800559:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80055c:	89 c7                	mov    %eax,%edi
  80055e:	48 b8 1a 08 80 00 00 	movabs $0x80081a,%rax
  800565:	00 00 00 
  800568:	ff d0                	callq  *%rax
        return;
  80056a:	e9 83 01 00 00       	jmpq   8006f2 <umain+0x2b0>
    }

    cprintf("Sending ARP announcement...\n");
  80056f:	48 bf 81 53 80 00 00 	movabs $0x805381,%rdi
  800576:	00 00 00 
  800579:	b8 00 00 00 00       	mov    $0x0,%eax
  80057e:	48 ba 81 0b 80 00 00 	movabs $0x800b81,%rdx
  800585:	00 00 00 
  800588:	ff d2                	callq  *%rdx
    announce();
  80058a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800591:	00 00 00 
  800594:	ff d0                	callq  *%rax

    while (1) {
        envid_t whom;
        int perm;

        int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  800596:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80059d:	00 00 00 
  8005a0:	48 8b 08             	mov    (%rax),%rcx
  8005a3:	48 8d 55 dc          	lea    -0x24(%rbp),%rdx
  8005a7:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8005ab:	48 89 ce             	mov    %rcx,%rsi
  8005ae:	48 89 c7             	mov    %rax,%rdi
  8005b1:	48 b8 36 2a 80 00 00 	movabs $0x802a36,%rax
  8005b8:	00 00 00 
  8005bb:	ff d0                	callq  *%rax
  8005bd:	89 45 e4             	mov    %eax,-0x1c(%rbp)
        if (req < 0)
  8005c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005c4:	79 30                	jns    8005f6 <umain+0x1b4>
            panic("ipc_recv: %e", req);
  8005c6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005c9:	89 c1                	mov    %eax,%ecx
  8005cb:	48 ba 9e 53 80 00 00 	movabs $0x80539e,%rdx
  8005d2:	00 00 00 
  8005d5:	be 64 00 00 00       	mov    $0x64,%esi
  8005da:	48 bf 44 53 80 00 00 	movabs $0x805344,%rdi
  8005e1:	00 00 00 
  8005e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e9:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  8005f0:	00 00 00 
  8005f3:	41 ff d0             	callq  *%r8
        if (whom != input_envid)
  8005f6:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8005f9:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  800600:	00 00 00 
  800603:	8b 00                	mov    (%rax),%eax
  800605:	39 c2                	cmp    %eax,%edx
  800607:	74 30                	je     800639 <umain+0x1f7>
            panic("IPC from unexpected environment %08x", whom);
  800609:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80060c:	89 c1                	mov    %eax,%ecx
  80060e:	48 ba b0 53 80 00 00 	movabs $0x8053b0,%rdx
  800615:	00 00 00 
  800618:	be 66 00 00 00       	mov    $0x66,%esi
  80061d:	48 bf 44 53 80 00 00 	movabs $0x805344,%rdi
  800624:	00 00 00 
  800627:	b8 00 00 00 00       	mov    $0x0,%eax
  80062c:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  800633:	00 00 00 
  800636:	41 ff d0             	callq  *%r8
        if (req != NSREQ_INPUT)
  800639:	83 7d e4 0a          	cmpl   $0xa,-0x1c(%rbp)
  80063d:	74 30                	je     80066f <umain+0x22d>
            panic("Unexpected IPC %d", req);
  80063f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800642:	89 c1                	mov    %eax,%ecx
  800644:	48 ba d5 53 80 00 00 	movabs $0x8053d5,%rdx
  80064b:	00 00 00 
  80064e:	be 68 00 00 00       	mov    $0x68,%esi
  800653:	48 bf 44 53 80 00 00 	movabs $0x805344,%rdi
  80065a:	00 00 00 
  80065d:	b8 00 00 00 00       	mov    $0x0,%eax
  800662:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  800669:	00 00 00 
  80066c:	41 ff d0             	callq  *%r8

        hexdump("input: ", pkt->jp_data, pkt->jp_len);
  80066f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800676:	00 00 00 
  800679:	48 8b 00             	mov    (%rax),%rax
  80067c:	8b 00                	mov    (%rax),%eax
  80067e:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800685:	00 00 00 
  800688:	48 8b 12             	mov    (%rdx),%rdx
  80068b:	48 8d 4a 04          	lea    0x4(%rdx),%rcx
  80068f:	89 c2                	mov    %eax,%edx
  800691:	48 89 ce             	mov    %rcx,%rsi
  800694:	48 bf e7 53 80 00 00 	movabs $0x8053e7,%rdi
  80069b:	00 00 00 
  80069e:	48 b8 b7 02 80 00 00 	movabs $0x8002b7,%rax
  8006a5:	00 00 00 
  8006a8:	ff d0                	callq  *%rax
        cprintf("\n");
  8006aa:	48 bf ef 53 80 00 00 	movabs $0x8053ef,%rdi
  8006b1:	00 00 00 
  8006b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8006b9:	48 ba 81 0b 80 00 00 	movabs $0x800b81,%rdx
  8006c0:	00 00 00 
  8006c3:	ff d2                	callq  *%rdx

        // Only indicate that we're waiting for packets once
        // we've received the ARP reply
        if (first)
  8006c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8006c9:	74 1b                	je     8006e6 <umain+0x2a4>
            cprintf("Waiting for packets...\n");
  8006cb:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  8006d2:	00 00 00 
  8006d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006da:	48 ba 81 0b 80 00 00 	movabs $0x800b81,%rdx
  8006e1:	00 00 00 
  8006e4:	ff d2                	callq  *%rdx
        first = 0;
  8006e6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    }
  8006ed:	e9 a4 fe ff ff       	jmpq   800596 <umain+0x154>
}
  8006f2:	48 83 c4 38          	add    $0x38,%rsp
  8006f6:	5b                   	pop    %rbx
  8006f7:	5d                   	pop    %rbp
  8006f8:	c3                   	retq   

00000000008006f9 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  8006f9:	55                   	push   %rbp
  8006fa:	48 89 e5             	mov    %rsp,%rbp
  8006fd:	53                   	push   %rbx
  8006fe:	48 83 ec 28          	sub    $0x28,%rsp
  800702:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800705:	89 75 d8             	mov    %esi,-0x28(%rbp)
    int r;
    uint32_t stop = sys_time_msec() + initial_to;
  800708:	48 b8 5e 23 80 00 00 	movabs $0x80235e,%rax
  80070f:	00 00 00 
  800712:	ff d0                	callq  *%rax
  800714:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800717:	01 d0                	add    %edx,%eax
  800719:	89 45 ec             	mov    %eax,-0x14(%rbp)

    binaryname = "ns_timer";
  80071c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800723:	00 00 00 
  800726:	48 bb 10 54 80 00 00 	movabs $0x805410,%rbx
  80072d:	00 00 00 
  800730:	48 89 18             	mov    %rbx,(%rax)

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800733:	eb 0c                	jmp    800741 <timer+0x48>
            sys_yield();
  800735:	48 b8 27 20 80 00 00 	movabs $0x802027,%rax
  80073c:	00 00 00 
  80073f:	ff d0                	callq  *%rax
    uint32_t stop = sys_time_msec() + initial_to;

    binaryname = "ns_timer";

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800741:	48 b8 5e 23 80 00 00 	movabs $0x80235e,%rax
  800748:	00 00 00 
  80074b:	ff d0                	callq  *%rax
  80074d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800750:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800753:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800756:	73 06                	jae    80075e <timer+0x65>
  800758:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80075c:	79 d7                	jns    800735 <timer+0x3c>
            sys_yield();
        }
        if (r < 0)
  80075e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800762:	79 30                	jns    800794 <timer+0x9b>
            panic("sys_time_msec: %e", r);
  800764:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800767:	89 c1                	mov    %eax,%ecx
  800769:	48 ba 19 54 80 00 00 	movabs $0x805419,%rdx
  800770:	00 00 00 
  800773:	be 0f 00 00 00       	mov    $0xf,%esi
  800778:	48 bf 2b 54 80 00 00 	movabs $0x80542b,%rdi
  80077f:	00 00 00 
  800782:	b8 00 00 00 00       	mov    $0x0,%eax
  800787:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  80078e:	00 00 00 
  800791:	41 ff d0             	callq  *%r8

        ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  800794:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800797:	b9 00 00 00 00       	mov    $0x0,%ecx
  80079c:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a1:	be 0c 00 00 00       	mov    $0xc,%esi
  8007a6:	89 c7                	mov    %eax,%edi
  8007a8:	48 b8 3c 2b 80 00 00 	movabs $0x802b3c,%rax
  8007af:	00 00 00 
  8007b2:	ff d0                	callq  *%rax

        while (1) {
            uint32_t to, whom;
            to = ipc_recv((int32_t *) &whom, 0, 0);
  8007b4:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8007b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007bd:	be 00 00 00 00       	mov    $0x0,%esi
  8007c2:	48 89 c7             	mov    %rax,%rdi
  8007c5:	48 b8 36 2a 80 00 00 	movabs $0x802a36,%rax
  8007cc:	00 00 00 
  8007cf:	ff d0                	callq  *%rax
  8007d1:	89 45 e4             	mov    %eax,-0x1c(%rbp)

            if (whom != ns_envid) {
  8007d4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8007d7:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8007da:	39 c2                	cmp    %eax,%edx
  8007dc:	74 22                	je     800800 <timer+0x107>
                cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8007de:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8007e1:	89 c6                	mov    %eax,%esi
  8007e3:	48 bf 38 54 80 00 00 	movabs $0x805438,%rdi
  8007ea:	00 00 00 
  8007ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f2:	48 ba 81 0b 80 00 00 	movabs $0x800b81,%rdx
  8007f9:	00 00 00 
  8007fc:	ff d2                	callq  *%rdx
                continue;
            }

            stop = sys_time_msec() + to;
            break;
        }
  8007fe:	eb b4                	jmp    8007b4 <timer+0xbb>
            if (whom != ns_envid) {
                cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
                continue;
            }

            stop = sys_time_msec() + to;
  800800:	48 b8 5e 23 80 00 00 	movabs $0x80235e,%rax
  800807:	00 00 00 
  80080a:	ff d0                	callq  *%rax
  80080c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80080f:	01 d0                	add    %edx,%eax
  800811:	89 45 ec             	mov    %eax,-0x14(%rbp)
            break;
        }
    }
  800814:	90                   	nop
    uint32_t stop = sys_time_msec() + initial_to;

    binaryname = "ns_timer";

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800815:	e9 27 ff ff ff       	jmpq   800741 <timer+0x48>

000000000080081a <input>:

extern union Nsipc nsipcbuf;

    void
input(envid_t ns_envid)
{
  80081a:	55                   	push   %rbp
  80081b:	48 89 e5             	mov    %rsp,%rbp
  80081e:	48 83 ec 04          	sub    $0x4,%rsp
  800822:	89 7d fc             	mov    %edi,-0x4(%rbp)
    binaryname = "ns_input";
  800825:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80082c:	00 00 00 
  80082f:	48 ba 73 54 80 00 00 	movabs $0x805473,%rdx
  800836:	00 00 00 
  800839:	48 89 10             	mov    %rdx,(%rax)
    // 	- read a packet from the device driver
    //	- send it to the network server
    // Hint: When you IPC a page to the network server, it will be
    // reading from it for a while, so don't immediately receive
    // another packet in to the same physical page.
}
  80083c:	c9                   	leaveq 
  80083d:	c3                   	retq   

000000000080083e <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  80083e:	55                   	push   %rbp
  80083f:	48 89 e5             	mov    %rsp,%rbp
  800842:	48 83 ec 20          	sub    $0x20,%rsp
  800846:	89 7d ec             	mov    %edi,-0x14(%rbp)
    binaryname = "ns_output";
  800849:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800850:	00 00 00 
  800853:	48 ba 7c 54 80 00 00 	movabs $0x80547c,%rdx
  80085a:	00 00 00 
  80085d:	48 89 10             	mov    %rdx,(%rax)

    // LAB 6: Your code here:
    // 	- read a packet from the network server
    //	- send the packet to the device driver
	void* buf = NULL;
  800860:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800867:	00 
	size_t len = 0;
  800868:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80086f:	00 
	sys_net_tx((void*)nsipcbuf.send.req_buf, nsipcbuf.send.req_size);
  800870:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  800877:	00 00 00 
  80087a:	8b 40 04             	mov    0x4(%rax),%eax
  80087d:	48 98                	cltq   
  80087f:	48 89 c6             	mov    %rax,%rsi
  800882:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  800889:	00 00 00 
  80088c:	48 b8 d2 22 80 00 00 	movabs $0x8022d2,%rax
  800893:	00 00 00 
  800896:	ff d0                	callq  *%rax
}
  800898:	c9                   	leaveq 
  800899:	c3                   	retq   

000000000080089a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80089a:	55                   	push   %rbp
  80089b:	48 89 e5             	mov    %rsp,%rbp
  80089e:	48 83 ec 10          	sub    $0x10,%rsp
  8008a2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8008a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8008a9:	48 b8 e9 1f 80 00 00 	movabs $0x801fe9,%rax
  8008b0:	00 00 00 
  8008b3:	ff d0                	callq  *%rax
  8008b5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8008ba:	48 63 d0             	movslq %eax,%rdx
  8008bd:	48 89 d0             	mov    %rdx,%rax
  8008c0:	48 c1 e0 03          	shl    $0x3,%rax
  8008c4:	48 01 d0             	add    %rdx,%rax
  8008c7:	48 c1 e0 05          	shl    $0x5,%rax
  8008cb:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8008d2:	00 00 00 
  8008d5:	48 01 c2             	add    %rax,%rdx
  8008d8:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8008df:	00 00 00 
  8008e2:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008e9:	7e 14                	jle    8008ff <libmain+0x65>
		binaryname = argv[0];
  8008eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008ef:	48 8b 10             	mov    (%rax),%rdx
  8008f2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8008f9:	00 00 00 
  8008fc:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8008ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800903:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800906:	48 89 d6             	mov    %rdx,%rsi
  800909:	89 c7                	mov    %eax,%edi
  80090b:	48 b8 42 04 80 00 00 	movabs $0x800442,%rax
  800912:	00 00 00 
  800915:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800917:	48 b8 25 09 80 00 00 	movabs $0x800925,%rax
  80091e:	00 00 00 
  800921:	ff d0                	callq  *%rax
}
  800923:	c9                   	leaveq 
  800924:	c3                   	retq   

0000000000800925 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800925:	55                   	push   %rbp
  800926:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800929:	48 b8 61 2f 80 00 00 	movabs $0x802f61,%rax
  800930:	00 00 00 
  800933:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800935:	bf 00 00 00 00       	mov    $0x0,%edi
  80093a:	48 b8 a5 1f 80 00 00 	movabs $0x801fa5,%rax
  800941:	00 00 00 
  800944:	ff d0                	callq  *%rax

}
  800946:	5d                   	pop    %rbp
  800947:	c3                   	retq   

0000000000800948 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800948:	55                   	push   %rbp
  800949:	48 89 e5             	mov    %rsp,%rbp
  80094c:	53                   	push   %rbx
  80094d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800954:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80095b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800961:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800968:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80096f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800976:	84 c0                	test   %al,%al
  800978:	74 23                	je     80099d <_panic+0x55>
  80097a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800981:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800985:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800989:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80098d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800991:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800995:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800999:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80099d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8009a4:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8009ab:	00 00 00 
  8009ae:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8009b5:	00 00 00 
  8009b8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8009bc:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8009c3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8009ca:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8009d1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8009d8:	00 00 00 
  8009db:	48 8b 18             	mov    (%rax),%rbx
  8009de:	48 b8 e9 1f 80 00 00 	movabs $0x801fe9,%rax
  8009e5:	00 00 00 
  8009e8:	ff d0                	callq  *%rax
  8009ea:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8009f0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8009f7:	41 89 c8             	mov    %ecx,%r8d
  8009fa:	48 89 d1             	mov    %rdx,%rcx
  8009fd:	48 89 da             	mov    %rbx,%rdx
  800a00:	89 c6                	mov    %eax,%esi
  800a02:	48 bf 90 54 80 00 00 	movabs $0x805490,%rdi
  800a09:	00 00 00 
  800a0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a11:	49 b9 81 0b 80 00 00 	movabs $0x800b81,%r9
  800a18:	00 00 00 
  800a1b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800a1e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800a25:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800a2c:	48 89 d6             	mov    %rdx,%rsi
  800a2f:	48 89 c7             	mov    %rax,%rdi
  800a32:	48 b8 d5 0a 80 00 00 	movabs $0x800ad5,%rax
  800a39:	00 00 00 
  800a3c:	ff d0                	callq  *%rax
	cprintf("\n");
  800a3e:	48 bf b3 54 80 00 00 	movabs $0x8054b3,%rdi
  800a45:	00 00 00 
  800a48:	b8 00 00 00 00       	mov    $0x0,%eax
  800a4d:	48 ba 81 0b 80 00 00 	movabs $0x800b81,%rdx
  800a54:	00 00 00 
  800a57:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800a59:	cc                   	int3   
  800a5a:	eb fd                	jmp    800a59 <_panic+0x111>

0000000000800a5c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800a5c:	55                   	push   %rbp
  800a5d:	48 89 e5             	mov    %rsp,%rbp
  800a60:	48 83 ec 10          	sub    $0x10,%rsp
  800a64:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800a67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800a6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a6f:	8b 00                	mov    (%rax),%eax
  800a71:	8d 48 01             	lea    0x1(%rax),%ecx
  800a74:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a78:	89 0a                	mov    %ecx,(%rdx)
  800a7a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a7d:	89 d1                	mov    %edx,%ecx
  800a7f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a83:	48 98                	cltq   
  800a85:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800a89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a8d:	8b 00                	mov    (%rax),%eax
  800a8f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a94:	75 2c                	jne    800ac2 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800a96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a9a:	8b 00                	mov    (%rax),%eax
  800a9c:	48 98                	cltq   
  800a9e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800aa2:	48 83 c2 08          	add    $0x8,%rdx
  800aa6:	48 89 c6             	mov    %rax,%rsi
  800aa9:	48 89 d7             	mov    %rdx,%rdi
  800aac:	48 b8 1d 1f 80 00 00 	movabs $0x801f1d,%rax
  800ab3:	00 00 00 
  800ab6:	ff d0                	callq  *%rax
        b->idx = 0;
  800ab8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800abc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800ac2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ac6:	8b 40 04             	mov    0x4(%rax),%eax
  800ac9:	8d 50 01             	lea    0x1(%rax),%edx
  800acc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ad0:	89 50 04             	mov    %edx,0x4(%rax)
}
  800ad3:	c9                   	leaveq 
  800ad4:	c3                   	retq   

0000000000800ad5 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800ad5:	55                   	push   %rbp
  800ad6:	48 89 e5             	mov    %rsp,%rbp
  800ad9:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800ae0:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800ae7:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800aee:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800af5:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800afc:	48 8b 0a             	mov    (%rdx),%rcx
  800aff:	48 89 08             	mov    %rcx,(%rax)
  800b02:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b06:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b0a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b0e:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800b12:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800b19:	00 00 00 
    b.cnt = 0;
  800b1c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800b23:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800b26:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800b2d:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800b34:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800b3b:	48 89 c6             	mov    %rax,%rsi
  800b3e:	48 bf 5c 0a 80 00 00 	movabs $0x800a5c,%rdi
  800b45:	00 00 00 
  800b48:	48 b8 34 0f 80 00 00 	movabs $0x800f34,%rax
  800b4f:	00 00 00 
  800b52:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800b54:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800b5a:	48 98                	cltq   
  800b5c:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800b63:	48 83 c2 08          	add    $0x8,%rdx
  800b67:	48 89 c6             	mov    %rax,%rsi
  800b6a:	48 89 d7             	mov    %rdx,%rdi
  800b6d:	48 b8 1d 1f 80 00 00 	movabs $0x801f1d,%rax
  800b74:	00 00 00 
  800b77:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800b79:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800b7f:	c9                   	leaveq 
  800b80:	c3                   	retq   

0000000000800b81 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800b81:	55                   	push   %rbp
  800b82:	48 89 e5             	mov    %rsp,%rbp
  800b85:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800b8c:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800b93:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800b9a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ba1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ba8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800baf:	84 c0                	test   %al,%al
  800bb1:	74 20                	je     800bd3 <cprintf+0x52>
  800bb3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bb7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800bbb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800bbf:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800bc3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800bc7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800bcb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800bcf:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800bd3:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800bda:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800be1:	00 00 00 
  800be4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800beb:	00 00 00 
  800bee:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bf2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800bf9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c00:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800c07:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800c0e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800c15:	48 8b 0a             	mov    (%rdx),%rcx
  800c18:	48 89 08             	mov    %rcx,(%rax)
  800c1b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c1f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c23:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c27:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800c2b:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800c32:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800c39:	48 89 d6             	mov    %rdx,%rsi
  800c3c:	48 89 c7             	mov    %rax,%rdi
  800c3f:	48 b8 d5 0a 80 00 00 	movabs $0x800ad5,%rax
  800c46:	00 00 00 
  800c49:	ff d0                	callq  *%rax
  800c4b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800c51:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800c57:	c9                   	leaveq 
  800c58:	c3                   	retq   

0000000000800c59 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c59:	55                   	push   %rbp
  800c5a:	48 89 e5             	mov    %rsp,%rbp
  800c5d:	53                   	push   %rbx
  800c5e:	48 83 ec 38          	sub    $0x38,%rsp
  800c62:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800c6a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800c6e:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800c71:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800c75:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c79:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800c7c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800c80:	77 3b                	ja     800cbd <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c82:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800c85:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800c89:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800c8c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800c90:	ba 00 00 00 00       	mov    $0x0,%edx
  800c95:	48 f7 f3             	div    %rbx
  800c98:	48 89 c2             	mov    %rax,%rdx
  800c9b:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800c9e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800ca1:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800ca5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca9:	41 89 f9             	mov    %edi,%r9d
  800cac:	48 89 c7             	mov    %rax,%rdi
  800caf:	48 b8 59 0c 80 00 00 	movabs $0x800c59,%rax
  800cb6:	00 00 00 
  800cb9:	ff d0                	callq  *%rax
  800cbb:	eb 1e                	jmp    800cdb <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800cbd:	eb 12                	jmp    800cd1 <printnum+0x78>
			putch(padc, putdat);
  800cbf:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800cc3:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800cc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cca:	48 89 ce             	mov    %rcx,%rsi
  800ccd:	89 d7                	mov    %edx,%edi
  800ccf:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800cd1:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800cd5:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800cd9:	7f e4                	jg     800cbf <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800cdb:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800cde:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800ce2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce7:	48 f7 f1             	div    %rcx
  800cea:	48 89 d0             	mov    %rdx,%rax
  800ced:	48 ba b0 56 80 00 00 	movabs $0x8056b0,%rdx
  800cf4:	00 00 00 
  800cf7:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800cfb:	0f be d0             	movsbl %al,%edx
  800cfe:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800d02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d06:	48 89 ce             	mov    %rcx,%rsi
  800d09:	89 d7                	mov    %edx,%edi
  800d0b:	ff d0                	callq  *%rax
}
  800d0d:	48 83 c4 38          	add    $0x38,%rsp
  800d11:	5b                   	pop    %rbx
  800d12:	5d                   	pop    %rbp
  800d13:	c3                   	retq   

0000000000800d14 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d14:	55                   	push   %rbp
  800d15:	48 89 e5             	mov    %rsp,%rbp
  800d18:	48 83 ec 1c          	sub    $0x1c,%rsp
  800d1c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800d20:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800d23:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800d27:	7e 52                	jle    800d7b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800d29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d2d:	8b 00                	mov    (%rax),%eax
  800d2f:	83 f8 30             	cmp    $0x30,%eax
  800d32:	73 24                	jae    800d58 <getuint+0x44>
  800d34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d38:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d40:	8b 00                	mov    (%rax),%eax
  800d42:	89 c0                	mov    %eax,%eax
  800d44:	48 01 d0             	add    %rdx,%rax
  800d47:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d4b:	8b 12                	mov    (%rdx),%edx
  800d4d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d50:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d54:	89 0a                	mov    %ecx,(%rdx)
  800d56:	eb 17                	jmp    800d6f <getuint+0x5b>
  800d58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d5c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d60:	48 89 d0             	mov    %rdx,%rax
  800d63:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d67:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d6b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d6f:	48 8b 00             	mov    (%rax),%rax
  800d72:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d76:	e9 a3 00 00 00       	jmpq   800e1e <getuint+0x10a>
	else if (lflag)
  800d7b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800d7f:	74 4f                	je     800dd0 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800d81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d85:	8b 00                	mov    (%rax),%eax
  800d87:	83 f8 30             	cmp    $0x30,%eax
  800d8a:	73 24                	jae    800db0 <getuint+0x9c>
  800d8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d90:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d98:	8b 00                	mov    (%rax),%eax
  800d9a:	89 c0                	mov    %eax,%eax
  800d9c:	48 01 d0             	add    %rdx,%rax
  800d9f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800da3:	8b 12                	mov    (%rdx),%edx
  800da5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800da8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dac:	89 0a                	mov    %ecx,(%rdx)
  800dae:	eb 17                	jmp    800dc7 <getuint+0xb3>
  800db0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800db4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800db8:	48 89 d0             	mov    %rdx,%rax
  800dbb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800dbf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dc3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800dc7:	48 8b 00             	mov    (%rax),%rax
  800dca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800dce:	eb 4e                	jmp    800e1e <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800dd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd4:	8b 00                	mov    (%rax),%eax
  800dd6:	83 f8 30             	cmp    $0x30,%eax
  800dd9:	73 24                	jae    800dff <getuint+0xeb>
  800ddb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ddf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800de3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de7:	8b 00                	mov    (%rax),%eax
  800de9:	89 c0                	mov    %eax,%eax
  800deb:	48 01 d0             	add    %rdx,%rax
  800dee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800df2:	8b 12                	mov    (%rdx),%edx
  800df4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800df7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dfb:	89 0a                	mov    %ecx,(%rdx)
  800dfd:	eb 17                	jmp    800e16 <getuint+0x102>
  800dff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e03:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e07:	48 89 d0             	mov    %rdx,%rax
  800e0a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e0e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e12:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e16:	8b 00                	mov    (%rax),%eax
  800e18:	89 c0                	mov    %eax,%eax
  800e1a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800e1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e22:	c9                   	leaveq 
  800e23:	c3                   	retq   

0000000000800e24 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e24:	55                   	push   %rbp
  800e25:	48 89 e5             	mov    %rsp,%rbp
  800e28:	48 83 ec 1c          	sub    $0x1c,%rsp
  800e2c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e30:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800e33:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800e37:	7e 52                	jle    800e8b <getint+0x67>
		x=va_arg(*ap, long long);
  800e39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e3d:	8b 00                	mov    (%rax),%eax
  800e3f:	83 f8 30             	cmp    $0x30,%eax
  800e42:	73 24                	jae    800e68 <getint+0x44>
  800e44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e48:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e50:	8b 00                	mov    (%rax),%eax
  800e52:	89 c0                	mov    %eax,%eax
  800e54:	48 01 d0             	add    %rdx,%rax
  800e57:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e5b:	8b 12                	mov    (%rdx),%edx
  800e5d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e60:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e64:	89 0a                	mov    %ecx,(%rdx)
  800e66:	eb 17                	jmp    800e7f <getint+0x5b>
  800e68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e6c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e70:	48 89 d0             	mov    %rdx,%rax
  800e73:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e77:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e7b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e7f:	48 8b 00             	mov    (%rax),%rax
  800e82:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e86:	e9 a3 00 00 00       	jmpq   800f2e <getint+0x10a>
	else if (lflag)
  800e8b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800e8f:	74 4f                	je     800ee0 <getint+0xbc>
		x=va_arg(*ap, long);
  800e91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e95:	8b 00                	mov    (%rax),%eax
  800e97:	83 f8 30             	cmp    $0x30,%eax
  800e9a:	73 24                	jae    800ec0 <getint+0x9c>
  800e9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ea4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea8:	8b 00                	mov    (%rax),%eax
  800eaa:	89 c0                	mov    %eax,%eax
  800eac:	48 01 d0             	add    %rdx,%rax
  800eaf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eb3:	8b 12                	mov    (%rdx),%edx
  800eb5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800eb8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ebc:	89 0a                	mov    %ecx,(%rdx)
  800ebe:	eb 17                	jmp    800ed7 <getint+0xb3>
  800ec0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ec8:	48 89 d0             	mov    %rdx,%rax
  800ecb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ecf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ed3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ed7:	48 8b 00             	mov    (%rax),%rax
  800eda:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ede:	eb 4e                	jmp    800f2e <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800ee0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee4:	8b 00                	mov    (%rax),%eax
  800ee6:	83 f8 30             	cmp    $0x30,%eax
  800ee9:	73 24                	jae    800f0f <getint+0xeb>
  800eeb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eef:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ef3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef7:	8b 00                	mov    (%rax),%eax
  800ef9:	89 c0                	mov    %eax,%eax
  800efb:	48 01 d0             	add    %rdx,%rax
  800efe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f02:	8b 12                	mov    (%rdx),%edx
  800f04:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f07:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f0b:	89 0a                	mov    %ecx,(%rdx)
  800f0d:	eb 17                	jmp    800f26 <getint+0x102>
  800f0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f13:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f17:	48 89 d0             	mov    %rdx,%rax
  800f1a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f1e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f22:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f26:	8b 00                	mov    (%rax),%eax
  800f28:	48 98                	cltq   
  800f2a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800f2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f32:	c9                   	leaveq 
  800f33:	c3                   	retq   

0000000000800f34 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f34:	55                   	push   %rbp
  800f35:	48 89 e5             	mov    %rsp,%rbp
  800f38:	41 54                	push   %r12
  800f3a:	53                   	push   %rbx
  800f3b:	48 83 ec 60          	sub    $0x60,%rsp
  800f3f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800f43:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800f47:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f4b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800f4f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f53:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800f57:	48 8b 0a             	mov    (%rdx),%rcx
  800f5a:	48 89 08             	mov    %rcx,(%rax)
  800f5d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f61:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f65:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f69:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f6d:	eb 17                	jmp    800f86 <vprintfmt+0x52>
			if (ch == '\0')
  800f6f:	85 db                	test   %ebx,%ebx
  800f71:	0f 84 cc 04 00 00    	je     801443 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800f77:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f7b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f7f:	48 89 d6             	mov    %rdx,%rsi
  800f82:	89 df                	mov    %ebx,%edi
  800f84:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f86:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f8a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f8e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f92:	0f b6 00             	movzbl (%rax),%eax
  800f95:	0f b6 d8             	movzbl %al,%ebx
  800f98:	83 fb 25             	cmp    $0x25,%ebx
  800f9b:	75 d2                	jne    800f6f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f9d:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800fa1:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800fa8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800faf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800fb6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800fbd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fc1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fc5:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800fc9:	0f b6 00             	movzbl (%rax),%eax
  800fcc:	0f b6 d8             	movzbl %al,%ebx
  800fcf:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800fd2:	83 f8 55             	cmp    $0x55,%eax
  800fd5:	0f 87 34 04 00 00    	ja     80140f <vprintfmt+0x4db>
  800fdb:	89 c0                	mov    %eax,%eax
  800fdd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800fe4:	00 
  800fe5:	48 b8 d8 56 80 00 00 	movabs $0x8056d8,%rax
  800fec:	00 00 00 
  800fef:	48 01 d0             	add    %rdx,%rax
  800ff2:	48 8b 00             	mov    (%rax),%rax
  800ff5:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ff7:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ffb:	eb c0                	jmp    800fbd <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ffd:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  801001:	eb ba                	jmp    800fbd <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801003:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80100a:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80100d:	89 d0                	mov    %edx,%eax
  80100f:	c1 e0 02             	shl    $0x2,%eax
  801012:	01 d0                	add    %edx,%eax
  801014:	01 c0                	add    %eax,%eax
  801016:	01 d8                	add    %ebx,%eax
  801018:	83 e8 30             	sub    $0x30,%eax
  80101b:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80101e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801022:	0f b6 00             	movzbl (%rax),%eax
  801025:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801028:	83 fb 2f             	cmp    $0x2f,%ebx
  80102b:	7e 0c                	jle    801039 <vprintfmt+0x105>
  80102d:	83 fb 39             	cmp    $0x39,%ebx
  801030:	7f 07                	jg     801039 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801032:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801037:	eb d1                	jmp    80100a <vprintfmt+0xd6>
			goto process_precision;
  801039:	eb 58                	jmp    801093 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80103b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80103e:	83 f8 30             	cmp    $0x30,%eax
  801041:	73 17                	jae    80105a <vprintfmt+0x126>
  801043:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801047:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80104a:	89 c0                	mov    %eax,%eax
  80104c:	48 01 d0             	add    %rdx,%rax
  80104f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801052:	83 c2 08             	add    $0x8,%edx
  801055:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801058:	eb 0f                	jmp    801069 <vprintfmt+0x135>
  80105a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80105e:	48 89 d0             	mov    %rdx,%rax
  801061:	48 83 c2 08          	add    $0x8,%rdx
  801065:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801069:	8b 00                	mov    (%rax),%eax
  80106b:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80106e:	eb 23                	jmp    801093 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  801070:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801074:	79 0c                	jns    801082 <vprintfmt+0x14e>
				width = 0;
  801076:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80107d:	e9 3b ff ff ff       	jmpq   800fbd <vprintfmt+0x89>
  801082:	e9 36 ff ff ff       	jmpq   800fbd <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801087:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80108e:	e9 2a ff ff ff       	jmpq   800fbd <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  801093:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801097:	79 12                	jns    8010ab <vprintfmt+0x177>
				width = precision, precision = -1;
  801099:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80109c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80109f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8010a6:	e9 12 ff ff ff       	jmpq   800fbd <vprintfmt+0x89>
  8010ab:	e9 0d ff ff ff       	jmpq   800fbd <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8010b0:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8010b4:	e9 04 ff ff ff       	jmpq   800fbd <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8010b9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010bc:	83 f8 30             	cmp    $0x30,%eax
  8010bf:	73 17                	jae    8010d8 <vprintfmt+0x1a4>
  8010c1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8010c5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010c8:	89 c0                	mov    %eax,%eax
  8010ca:	48 01 d0             	add    %rdx,%rax
  8010cd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8010d0:	83 c2 08             	add    $0x8,%edx
  8010d3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8010d6:	eb 0f                	jmp    8010e7 <vprintfmt+0x1b3>
  8010d8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8010dc:	48 89 d0             	mov    %rdx,%rax
  8010df:	48 83 c2 08          	add    $0x8,%rdx
  8010e3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8010e7:	8b 10                	mov    (%rax),%edx
  8010e9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8010ed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010f1:	48 89 ce             	mov    %rcx,%rsi
  8010f4:	89 d7                	mov    %edx,%edi
  8010f6:	ff d0                	callq  *%rax
			break;
  8010f8:	e9 40 03 00 00       	jmpq   80143d <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8010fd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801100:	83 f8 30             	cmp    $0x30,%eax
  801103:	73 17                	jae    80111c <vprintfmt+0x1e8>
  801105:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801109:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80110c:	89 c0                	mov    %eax,%eax
  80110e:	48 01 d0             	add    %rdx,%rax
  801111:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801114:	83 c2 08             	add    $0x8,%edx
  801117:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80111a:	eb 0f                	jmp    80112b <vprintfmt+0x1f7>
  80111c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801120:	48 89 d0             	mov    %rdx,%rax
  801123:	48 83 c2 08          	add    $0x8,%rdx
  801127:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80112b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80112d:	85 db                	test   %ebx,%ebx
  80112f:	79 02                	jns    801133 <vprintfmt+0x1ff>
				err = -err;
  801131:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801133:	83 fb 15             	cmp    $0x15,%ebx
  801136:	7f 16                	jg     80114e <vprintfmt+0x21a>
  801138:	48 b8 00 56 80 00 00 	movabs $0x805600,%rax
  80113f:	00 00 00 
  801142:	48 63 d3             	movslq %ebx,%rdx
  801145:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801149:	4d 85 e4             	test   %r12,%r12
  80114c:	75 2e                	jne    80117c <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80114e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801152:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801156:	89 d9                	mov    %ebx,%ecx
  801158:	48 ba c1 56 80 00 00 	movabs $0x8056c1,%rdx
  80115f:	00 00 00 
  801162:	48 89 c7             	mov    %rax,%rdi
  801165:	b8 00 00 00 00       	mov    $0x0,%eax
  80116a:	49 b8 4c 14 80 00 00 	movabs $0x80144c,%r8
  801171:	00 00 00 
  801174:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801177:	e9 c1 02 00 00       	jmpq   80143d <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80117c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801180:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801184:	4c 89 e1             	mov    %r12,%rcx
  801187:	48 ba ca 56 80 00 00 	movabs $0x8056ca,%rdx
  80118e:	00 00 00 
  801191:	48 89 c7             	mov    %rax,%rdi
  801194:	b8 00 00 00 00       	mov    $0x0,%eax
  801199:	49 b8 4c 14 80 00 00 	movabs $0x80144c,%r8
  8011a0:	00 00 00 
  8011a3:	41 ff d0             	callq  *%r8
			break;
  8011a6:	e9 92 02 00 00       	jmpq   80143d <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8011ab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011ae:	83 f8 30             	cmp    $0x30,%eax
  8011b1:	73 17                	jae    8011ca <vprintfmt+0x296>
  8011b3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8011b7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011ba:	89 c0                	mov    %eax,%eax
  8011bc:	48 01 d0             	add    %rdx,%rax
  8011bf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8011c2:	83 c2 08             	add    $0x8,%edx
  8011c5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8011c8:	eb 0f                	jmp    8011d9 <vprintfmt+0x2a5>
  8011ca:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8011ce:	48 89 d0             	mov    %rdx,%rax
  8011d1:	48 83 c2 08          	add    $0x8,%rdx
  8011d5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8011d9:	4c 8b 20             	mov    (%rax),%r12
  8011dc:	4d 85 e4             	test   %r12,%r12
  8011df:	75 0a                	jne    8011eb <vprintfmt+0x2b7>
				p = "(null)";
  8011e1:	49 bc cd 56 80 00 00 	movabs $0x8056cd,%r12
  8011e8:	00 00 00 
			if (width > 0 && padc != '-')
  8011eb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8011ef:	7e 3f                	jle    801230 <vprintfmt+0x2fc>
  8011f1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8011f5:	74 39                	je     801230 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8011f7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8011fa:	48 98                	cltq   
  8011fc:	48 89 c6             	mov    %rax,%rsi
  8011ff:	4c 89 e7             	mov    %r12,%rdi
  801202:	48 b8 f8 16 80 00 00 	movabs $0x8016f8,%rax
  801209:	00 00 00 
  80120c:	ff d0                	callq  *%rax
  80120e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801211:	eb 17                	jmp    80122a <vprintfmt+0x2f6>
					putch(padc, putdat);
  801213:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801217:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80121b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80121f:	48 89 ce             	mov    %rcx,%rsi
  801222:	89 d7                	mov    %edx,%edi
  801224:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801226:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80122a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80122e:	7f e3                	jg     801213 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801230:	eb 37                	jmp    801269 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  801232:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801236:	74 1e                	je     801256 <vprintfmt+0x322>
  801238:	83 fb 1f             	cmp    $0x1f,%ebx
  80123b:	7e 05                	jle    801242 <vprintfmt+0x30e>
  80123d:	83 fb 7e             	cmp    $0x7e,%ebx
  801240:	7e 14                	jle    801256 <vprintfmt+0x322>
					putch('?', putdat);
  801242:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801246:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80124a:	48 89 d6             	mov    %rdx,%rsi
  80124d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801252:	ff d0                	callq  *%rax
  801254:	eb 0f                	jmp    801265 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  801256:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80125a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80125e:	48 89 d6             	mov    %rdx,%rsi
  801261:	89 df                	mov    %ebx,%edi
  801263:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801265:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801269:	4c 89 e0             	mov    %r12,%rax
  80126c:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801270:	0f b6 00             	movzbl (%rax),%eax
  801273:	0f be d8             	movsbl %al,%ebx
  801276:	85 db                	test   %ebx,%ebx
  801278:	74 10                	je     80128a <vprintfmt+0x356>
  80127a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80127e:	78 b2                	js     801232 <vprintfmt+0x2fe>
  801280:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801284:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801288:	79 a8                	jns    801232 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80128a:	eb 16                	jmp    8012a2 <vprintfmt+0x36e>
				putch(' ', putdat);
  80128c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801290:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801294:	48 89 d6             	mov    %rdx,%rsi
  801297:	bf 20 00 00 00       	mov    $0x20,%edi
  80129c:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80129e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8012a2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8012a6:	7f e4                	jg     80128c <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8012a8:	e9 90 01 00 00       	jmpq   80143d <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8012ad:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012b1:	be 03 00 00 00       	mov    $0x3,%esi
  8012b6:	48 89 c7             	mov    %rax,%rdi
  8012b9:	48 b8 24 0e 80 00 00 	movabs $0x800e24,%rax
  8012c0:	00 00 00 
  8012c3:	ff d0                	callq  *%rax
  8012c5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8012c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012cd:	48 85 c0             	test   %rax,%rax
  8012d0:	79 1d                	jns    8012ef <vprintfmt+0x3bb>
				putch('-', putdat);
  8012d2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012d6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012da:	48 89 d6             	mov    %rdx,%rsi
  8012dd:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8012e2:	ff d0                	callq  *%rax
				num = -(long long) num;
  8012e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e8:	48 f7 d8             	neg    %rax
  8012eb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8012ef:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8012f6:	e9 d5 00 00 00       	jmpq   8013d0 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8012fb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012ff:	be 03 00 00 00       	mov    $0x3,%esi
  801304:	48 89 c7             	mov    %rax,%rdi
  801307:	48 b8 14 0d 80 00 00 	movabs $0x800d14,%rax
  80130e:	00 00 00 
  801311:	ff d0                	callq  *%rax
  801313:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801317:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80131e:	e9 ad 00 00 00       	jmpq   8013d0 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  801323:	8b 55 e0             	mov    -0x20(%rbp),%edx
  801326:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80132a:	89 d6                	mov    %edx,%esi
  80132c:	48 89 c7             	mov    %rax,%rdi
  80132f:	48 b8 24 0e 80 00 00 	movabs $0x800e24,%rax
  801336:	00 00 00 
  801339:	ff d0                	callq  *%rax
  80133b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  80133f:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801346:	e9 85 00 00 00       	jmpq   8013d0 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  80134b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80134f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801353:	48 89 d6             	mov    %rdx,%rsi
  801356:	bf 30 00 00 00       	mov    $0x30,%edi
  80135b:	ff d0                	callq  *%rax
			putch('x', putdat);
  80135d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801361:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801365:	48 89 d6             	mov    %rdx,%rsi
  801368:	bf 78 00 00 00       	mov    $0x78,%edi
  80136d:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80136f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801372:	83 f8 30             	cmp    $0x30,%eax
  801375:	73 17                	jae    80138e <vprintfmt+0x45a>
  801377:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80137b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80137e:	89 c0                	mov    %eax,%eax
  801380:	48 01 d0             	add    %rdx,%rax
  801383:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801386:	83 c2 08             	add    $0x8,%edx
  801389:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80138c:	eb 0f                	jmp    80139d <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  80138e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801392:	48 89 d0             	mov    %rdx,%rax
  801395:	48 83 c2 08          	add    $0x8,%rdx
  801399:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80139d:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8013a0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8013a4:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8013ab:	eb 23                	jmp    8013d0 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8013ad:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8013b1:	be 03 00 00 00       	mov    $0x3,%esi
  8013b6:	48 89 c7             	mov    %rax,%rdi
  8013b9:	48 b8 14 0d 80 00 00 	movabs $0x800d14,%rax
  8013c0:	00 00 00 
  8013c3:	ff d0                	callq  *%rax
  8013c5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8013c9:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8013d0:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8013d5:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8013d8:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8013db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013df:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8013e3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013e7:	45 89 c1             	mov    %r8d,%r9d
  8013ea:	41 89 f8             	mov    %edi,%r8d
  8013ed:	48 89 c7             	mov    %rax,%rdi
  8013f0:	48 b8 59 0c 80 00 00 	movabs $0x800c59,%rax
  8013f7:	00 00 00 
  8013fa:	ff d0                	callq  *%rax
			break;
  8013fc:	eb 3f                	jmp    80143d <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8013fe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801402:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801406:	48 89 d6             	mov    %rdx,%rsi
  801409:	89 df                	mov    %ebx,%edi
  80140b:	ff d0                	callq  *%rax
			break;
  80140d:	eb 2e                	jmp    80143d <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80140f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801413:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801417:	48 89 d6             	mov    %rdx,%rsi
  80141a:	bf 25 00 00 00       	mov    $0x25,%edi
  80141f:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801421:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801426:	eb 05                	jmp    80142d <vprintfmt+0x4f9>
  801428:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80142d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801431:	48 83 e8 01          	sub    $0x1,%rax
  801435:	0f b6 00             	movzbl (%rax),%eax
  801438:	3c 25                	cmp    $0x25,%al
  80143a:	75 ec                	jne    801428 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  80143c:	90                   	nop
		}
	}
  80143d:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80143e:	e9 43 fb ff ff       	jmpq   800f86 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801443:	48 83 c4 60          	add    $0x60,%rsp
  801447:	5b                   	pop    %rbx
  801448:	41 5c                	pop    %r12
  80144a:	5d                   	pop    %rbp
  80144b:	c3                   	retq   

000000000080144c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80144c:	55                   	push   %rbp
  80144d:	48 89 e5             	mov    %rsp,%rbp
  801450:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801457:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80145e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801465:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80146c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801473:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80147a:	84 c0                	test   %al,%al
  80147c:	74 20                	je     80149e <printfmt+0x52>
  80147e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801482:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801486:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80148a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80148e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801492:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801496:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80149a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80149e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8014a5:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8014ac:	00 00 00 
  8014af:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8014b6:	00 00 00 
  8014b9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8014bd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8014c4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8014cb:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8014d2:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8014d9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8014e0:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8014e7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8014ee:	48 89 c7             	mov    %rax,%rdi
  8014f1:	48 b8 34 0f 80 00 00 	movabs $0x800f34,%rax
  8014f8:	00 00 00 
  8014fb:	ff d0                	callq  *%rax
	va_end(ap);
}
  8014fd:	c9                   	leaveq 
  8014fe:	c3                   	retq   

00000000008014ff <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014ff:	55                   	push   %rbp
  801500:	48 89 e5             	mov    %rsp,%rbp
  801503:	48 83 ec 10          	sub    $0x10,%rsp
  801507:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80150a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80150e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801512:	8b 40 10             	mov    0x10(%rax),%eax
  801515:	8d 50 01             	lea    0x1(%rax),%edx
  801518:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80151c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80151f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801523:	48 8b 10             	mov    (%rax),%rdx
  801526:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80152e:	48 39 c2             	cmp    %rax,%rdx
  801531:	73 17                	jae    80154a <sprintputch+0x4b>
		*b->buf++ = ch;
  801533:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801537:	48 8b 00             	mov    (%rax),%rax
  80153a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80153e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801542:	48 89 0a             	mov    %rcx,(%rdx)
  801545:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801548:	88 10                	mov    %dl,(%rax)
}
  80154a:	c9                   	leaveq 
  80154b:	c3                   	retq   

000000000080154c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80154c:	55                   	push   %rbp
  80154d:	48 89 e5             	mov    %rsp,%rbp
  801550:	48 83 ec 50          	sub    $0x50,%rsp
  801554:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801558:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80155b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80155f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801563:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801567:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80156b:	48 8b 0a             	mov    (%rdx),%rcx
  80156e:	48 89 08             	mov    %rcx,(%rax)
  801571:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801575:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801579:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80157d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801581:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801585:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801589:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80158c:	48 98                	cltq   
  80158e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801592:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801596:	48 01 d0             	add    %rdx,%rax
  801599:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80159d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8015a4:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8015a9:	74 06                	je     8015b1 <vsnprintf+0x65>
  8015ab:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8015af:	7f 07                	jg     8015b8 <vsnprintf+0x6c>
		return -E_INVAL;
  8015b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015b6:	eb 2f                	jmp    8015e7 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8015b8:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8015bc:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8015c0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8015c4:	48 89 c6             	mov    %rax,%rsi
  8015c7:	48 bf ff 14 80 00 00 	movabs $0x8014ff,%rdi
  8015ce:	00 00 00 
  8015d1:	48 b8 34 0f 80 00 00 	movabs $0x800f34,%rax
  8015d8:	00 00 00 
  8015db:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8015dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015e1:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8015e4:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8015e7:	c9                   	leaveq 
  8015e8:	c3                   	retq   

00000000008015e9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015e9:	55                   	push   %rbp
  8015ea:	48 89 e5             	mov    %rsp,%rbp
  8015ed:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8015f4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8015fb:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801601:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801608:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80160f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801616:	84 c0                	test   %al,%al
  801618:	74 20                	je     80163a <snprintf+0x51>
  80161a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80161e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801622:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801626:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80162a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80162e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801632:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801636:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80163a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801641:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801648:	00 00 00 
  80164b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801652:	00 00 00 
  801655:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801659:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801660:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801667:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80166e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801675:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80167c:	48 8b 0a             	mov    (%rdx),%rcx
  80167f:	48 89 08             	mov    %rcx,(%rax)
  801682:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801686:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80168a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80168e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801692:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801699:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8016a0:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8016a6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8016ad:	48 89 c7             	mov    %rax,%rdi
  8016b0:	48 b8 4c 15 80 00 00 	movabs $0x80154c,%rax
  8016b7:	00 00 00 
  8016ba:	ff d0                	callq  *%rax
  8016bc:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8016c2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8016c8:	c9                   	leaveq 
  8016c9:	c3                   	retq   

00000000008016ca <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8016ca:	55                   	push   %rbp
  8016cb:	48 89 e5             	mov    %rsp,%rbp
  8016ce:	48 83 ec 18          	sub    $0x18,%rsp
  8016d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8016d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8016dd:	eb 09                	jmp    8016e8 <strlen+0x1e>
		n++;
  8016df:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8016e3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ec:	0f b6 00             	movzbl (%rax),%eax
  8016ef:	84 c0                	test   %al,%al
  8016f1:	75 ec                	jne    8016df <strlen+0x15>
		n++;
	return n;
  8016f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8016f6:	c9                   	leaveq 
  8016f7:	c3                   	retq   

00000000008016f8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8016f8:	55                   	push   %rbp
  8016f9:	48 89 e5             	mov    %rsp,%rbp
  8016fc:	48 83 ec 20          	sub    $0x20,%rsp
  801700:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801704:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801708:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80170f:	eb 0e                	jmp    80171f <strnlen+0x27>
		n++;
  801711:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801715:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80171a:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80171f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801724:	74 0b                	je     801731 <strnlen+0x39>
  801726:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80172a:	0f b6 00             	movzbl (%rax),%eax
  80172d:	84 c0                	test   %al,%al
  80172f:	75 e0                	jne    801711 <strnlen+0x19>
		n++;
	return n;
  801731:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801734:	c9                   	leaveq 
  801735:	c3                   	retq   

0000000000801736 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801736:	55                   	push   %rbp
  801737:	48 89 e5             	mov    %rsp,%rbp
  80173a:	48 83 ec 20          	sub    $0x20,%rsp
  80173e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801742:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80174a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80174e:	90                   	nop
  80174f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801753:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801757:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80175b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80175f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801763:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801767:	0f b6 12             	movzbl (%rdx),%edx
  80176a:	88 10                	mov    %dl,(%rax)
  80176c:	0f b6 00             	movzbl (%rax),%eax
  80176f:	84 c0                	test   %al,%al
  801771:	75 dc                	jne    80174f <strcpy+0x19>
		/* do nothing */;
	return ret;
  801773:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801777:	c9                   	leaveq 
  801778:	c3                   	retq   

0000000000801779 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801779:	55                   	push   %rbp
  80177a:	48 89 e5             	mov    %rsp,%rbp
  80177d:	48 83 ec 20          	sub    $0x20,%rsp
  801781:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801785:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801789:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80178d:	48 89 c7             	mov    %rax,%rdi
  801790:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  801797:	00 00 00 
  80179a:	ff d0                	callq  *%rax
  80179c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80179f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017a2:	48 63 d0             	movslq %eax,%rdx
  8017a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017a9:	48 01 c2             	add    %rax,%rdx
  8017ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017b0:	48 89 c6             	mov    %rax,%rsi
  8017b3:	48 89 d7             	mov    %rdx,%rdi
  8017b6:	48 b8 36 17 80 00 00 	movabs $0x801736,%rax
  8017bd:	00 00 00 
  8017c0:	ff d0                	callq  *%rax
	return dst;
  8017c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017c6:	c9                   	leaveq 
  8017c7:	c3                   	retq   

00000000008017c8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8017c8:	55                   	push   %rbp
  8017c9:	48 89 e5             	mov    %rsp,%rbp
  8017cc:	48 83 ec 28          	sub    $0x28,%rsp
  8017d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017d8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8017dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017e0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8017e4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8017eb:	00 
  8017ec:	eb 2a                	jmp    801818 <strncpy+0x50>
		*dst++ = *src;
  8017ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017f2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017f6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8017fa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8017fe:	0f b6 12             	movzbl (%rdx),%edx
  801801:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801803:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801807:	0f b6 00             	movzbl (%rax),%eax
  80180a:	84 c0                	test   %al,%al
  80180c:	74 05                	je     801813 <strncpy+0x4b>
			src++;
  80180e:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801813:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801818:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80181c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801820:	72 cc                	jb     8017ee <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801822:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801826:	c9                   	leaveq 
  801827:	c3                   	retq   

0000000000801828 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801828:	55                   	push   %rbp
  801829:	48 89 e5             	mov    %rsp,%rbp
  80182c:	48 83 ec 28          	sub    $0x28,%rsp
  801830:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801834:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801838:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80183c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801840:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801844:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801849:	74 3d                	je     801888 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80184b:	eb 1d                	jmp    80186a <strlcpy+0x42>
			*dst++ = *src++;
  80184d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801851:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801855:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801859:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80185d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801861:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801865:	0f b6 12             	movzbl (%rdx),%edx
  801868:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80186a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80186f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801874:	74 0b                	je     801881 <strlcpy+0x59>
  801876:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80187a:	0f b6 00             	movzbl (%rax),%eax
  80187d:	84 c0                	test   %al,%al
  80187f:	75 cc                	jne    80184d <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801881:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801885:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801888:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80188c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801890:	48 29 c2             	sub    %rax,%rdx
  801893:	48 89 d0             	mov    %rdx,%rax
}
  801896:	c9                   	leaveq 
  801897:	c3                   	retq   

0000000000801898 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801898:	55                   	push   %rbp
  801899:	48 89 e5             	mov    %rsp,%rbp
  80189c:	48 83 ec 10          	sub    $0x10,%rsp
  8018a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8018a8:	eb 0a                	jmp    8018b4 <strcmp+0x1c>
		p++, q++;
  8018aa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018af:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8018b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018b8:	0f b6 00             	movzbl (%rax),%eax
  8018bb:	84 c0                	test   %al,%al
  8018bd:	74 12                	je     8018d1 <strcmp+0x39>
  8018bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018c3:	0f b6 10             	movzbl (%rax),%edx
  8018c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ca:	0f b6 00             	movzbl (%rax),%eax
  8018cd:	38 c2                	cmp    %al,%dl
  8018cf:	74 d9                	je     8018aa <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8018d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018d5:	0f b6 00             	movzbl (%rax),%eax
  8018d8:	0f b6 d0             	movzbl %al,%edx
  8018db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018df:	0f b6 00             	movzbl (%rax),%eax
  8018e2:	0f b6 c0             	movzbl %al,%eax
  8018e5:	29 c2                	sub    %eax,%edx
  8018e7:	89 d0                	mov    %edx,%eax
}
  8018e9:	c9                   	leaveq 
  8018ea:	c3                   	retq   

00000000008018eb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018eb:	55                   	push   %rbp
  8018ec:	48 89 e5             	mov    %rsp,%rbp
  8018ef:	48 83 ec 18          	sub    $0x18,%rsp
  8018f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018fb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8018ff:	eb 0f                	jmp    801910 <strncmp+0x25>
		n--, p++, q++;
  801901:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801906:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80190b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801910:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801915:	74 1d                	je     801934 <strncmp+0x49>
  801917:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80191b:	0f b6 00             	movzbl (%rax),%eax
  80191e:	84 c0                	test   %al,%al
  801920:	74 12                	je     801934 <strncmp+0x49>
  801922:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801926:	0f b6 10             	movzbl (%rax),%edx
  801929:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80192d:	0f b6 00             	movzbl (%rax),%eax
  801930:	38 c2                	cmp    %al,%dl
  801932:	74 cd                	je     801901 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801934:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801939:	75 07                	jne    801942 <strncmp+0x57>
		return 0;
  80193b:	b8 00 00 00 00       	mov    $0x0,%eax
  801940:	eb 18                	jmp    80195a <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801942:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801946:	0f b6 00             	movzbl (%rax),%eax
  801949:	0f b6 d0             	movzbl %al,%edx
  80194c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801950:	0f b6 00             	movzbl (%rax),%eax
  801953:	0f b6 c0             	movzbl %al,%eax
  801956:	29 c2                	sub    %eax,%edx
  801958:	89 d0                	mov    %edx,%eax
}
  80195a:	c9                   	leaveq 
  80195b:	c3                   	retq   

000000000080195c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80195c:	55                   	push   %rbp
  80195d:	48 89 e5             	mov    %rsp,%rbp
  801960:	48 83 ec 0c          	sub    $0xc,%rsp
  801964:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801968:	89 f0                	mov    %esi,%eax
  80196a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80196d:	eb 17                	jmp    801986 <strchr+0x2a>
		if (*s == c)
  80196f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801973:	0f b6 00             	movzbl (%rax),%eax
  801976:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801979:	75 06                	jne    801981 <strchr+0x25>
			return (char *) s;
  80197b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80197f:	eb 15                	jmp    801996 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801981:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801986:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80198a:	0f b6 00             	movzbl (%rax),%eax
  80198d:	84 c0                	test   %al,%al
  80198f:	75 de                	jne    80196f <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801991:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801996:	c9                   	leaveq 
  801997:	c3                   	retq   

0000000000801998 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801998:	55                   	push   %rbp
  801999:	48 89 e5             	mov    %rsp,%rbp
  80199c:	48 83 ec 0c          	sub    $0xc,%rsp
  8019a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019a4:	89 f0                	mov    %esi,%eax
  8019a6:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8019a9:	eb 13                	jmp    8019be <strfind+0x26>
		if (*s == c)
  8019ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019af:	0f b6 00             	movzbl (%rax),%eax
  8019b2:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8019b5:	75 02                	jne    8019b9 <strfind+0x21>
			break;
  8019b7:	eb 10                	jmp    8019c9 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8019b9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019c2:	0f b6 00             	movzbl (%rax),%eax
  8019c5:	84 c0                	test   %al,%al
  8019c7:	75 e2                	jne    8019ab <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8019c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019cd:	c9                   	leaveq 
  8019ce:	c3                   	retq   

00000000008019cf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8019cf:	55                   	push   %rbp
  8019d0:	48 89 e5             	mov    %rsp,%rbp
  8019d3:	48 83 ec 18          	sub    $0x18,%rsp
  8019d7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019db:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8019de:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8019e2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019e7:	75 06                	jne    8019ef <memset+0x20>
		return v;
  8019e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019ed:	eb 69                	jmp    801a58 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8019ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019f3:	83 e0 03             	and    $0x3,%eax
  8019f6:	48 85 c0             	test   %rax,%rax
  8019f9:	75 48                	jne    801a43 <memset+0x74>
  8019fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019ff:	83 e0 03             	and    $0x3,%eax
  801a02:	48 85 c0             	test   %rax,%rax
  801a05:	75 3c                	jne    801a43 <memset+0x74>
		c &= 0xFF;
  801a07:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801a0e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a11:	c1 e0 18             	shl    $0x18,%eax
  801a14:	89 c2                	mov    %eax,%edx
  801a16:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a19:	c1 e0 10             	shl    $0x10,%eax
  801a1c:	09 c2                	or     %eax,%edx
  801a1e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a21:	c1 e0 08             	shl    $0x8,%eax
  801a24:	09 d0                	or     %edx,%eax
  801a26:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801a29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a2d:	48 c1 e8 02          	shr    $0x2,%rax
  801a31:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801a34:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a38:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a3b:	48 89 d7             	mov    %rdx,%rdi
  801a3e:	fc                   	cld    
  801a3f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801a41:	eb 11                	jmp    801a54 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801a43:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a47:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a4a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a4e:	48 89 d7             	mov    %rdx,%rdi
  801a51:	fc                   	cld    
  801a52:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801a54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801a58:	c9                   	leaveq 
  801a59:	c3                   	retq   

0000000000801a5a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801a5a:	55                   	push   %rbp
  801a5b:	48 89 e5             	mov    %rsp,%rbp
  801a5e:	48 83 ec 28          	sub    $0x28,%rsp
  801a62:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a6a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801a6e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a72:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801a76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a7a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801a7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a82:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a86:	0f 83 88 00 00 00    	jae    801b14 <memmove+0xba>
  801a8c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a90:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a94:	48 01 d0             	add    %rdx,%rax
  801a97:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a9b:	76 77                	jbe    801b14 <memmove+0xba>
		s += n;
  801a9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa1:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801aa5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa9:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801aad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ab1:	83 e0 03             	and    $0x3,%eax
  801ab4:	48 85 c0             	test   %rax,%rax
  801ab7:	75 3b                	jne    801af4 <memmove+0x9a>
  801ab9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801abd:	83 e0 03             	and    $0x3,%eax
  801ac0:	48 85 c0             	test   %rax,%rax
  801ac3:	75 2f                	jne    801af4 <memmove+0x9a>
  801ac5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac9:	83 e0 03             	and    $0x3,%eax
  801acc:	48 85 c0             	test   %rax,%rax
  801acf:	75 23                	jne    801af4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801ad1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ad5:	48 83 e8 04          	sub    $0x4,%rax
  801ad9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801add:	48 83 ea 04          	sub    $0x4,%rdx
  801ae1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801ae5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801ae9:	48 89 c7             	mov    %rax,%rdi
  801aec:	48 89 d6             	mov    %rdx,%rsi
  801aef:	fd                   	std    
  801af0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801af2:	eb 1d                	jmp    801b11 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801af4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801af8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801afc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b00:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801b04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b08:	48 89 d7             	mov    %rdx,%rdi
  801b0b:	48 89 c1             	mov    %rax,%rcx
  801b0e:	fd                   	std    
  801b0f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801b11:	fc                   	cld    
  801b12:	eb 57                	jmp    801b6b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801b14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b18:	83 e0 03             	and    $0x3,%eax
  801b1b:	48 85 c0             	test   %rax,%rax
  801b1e:	75 36                	jne    801b56 <memmove+0xfc>
  801b20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b24:	83 e0 03             	and    $0x3,%eax
  801b27:	48 85 c0             	test   %rax,%rax
  801b2a:	75 2a                	jne    801b56 <memmove+0xfc>
  801b2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b30:	83 e0 03             	and    $0x3,%eax
  801b33:	48 85 c0             	test   %rax,%rax
  801b36:	75 1e                	jne    801b56 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801b38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b3c:	48 c1 e8 02          	shr    $0x2,%rax
  801b40:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801b43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b47:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b4b:	48 89 c7             	mov    %rax,%rdi
  801b4e:	48 89 d6             	mov    %rdx,%rsi
  801b51:	fc                   	cld    
  801b52:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801b54:	eb 15                	jmp    801b6b <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801b56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b5a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b5e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801b62:	48 89 c7             	mov    %rax,%rdi
  801b65:	48 89 d6             	mov    %rdx,%rsi
  801b68:	fc                   	cld    
  801b69:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801b6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b6f:	c9                   	leaveq 
  801b70:	c3                   	retq   

0000000000801b71 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801b71:	55                   	push   %rbp
  801b72:	48 89 e5             	mov    %rsp,%rbp
  801b75:	48 83 ec 18          	sub    $0x18,%rsp
  801b79:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b7d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b81:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801b85:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b89:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801b8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b91:	48 89 ce             	mov    %rcx,%rsi
  801b94:	48 89 c7             	mov    %rax,%rdi
  801b97:	48 b8 5a 1a 80 00 00 	movabs $0x801a5a,%rax
  801b9e:	00 00 00 
  801ba1:	ff d0                	callq  *%rax
}
  801ba3:	c9                   	leaveq 
  801ba4:	c3                   	retq   

0000000000801ba5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801ba5:	55                   	push   %rbp
  801ba6:	48 89 e5             	mov    %rsp,%rbp
  801ba9:	48 83 ec 28          	sub    $0x28,%rsp
  801bad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bb1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801bb5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801bb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bbd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801bc1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bc5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801bc9:	eb 36                	jmp    801c01 <memcmp+0x5c>
		if (*s1 != *s2)
  801bcb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bcf:	0f b6 10             	movzbl (%rax),%edx
  801bd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bd6:	0f b6 00             	movzbl (%rax),%eax
  801bd9:	38 c2                	cmp    %al,%dl
  801bdb:	74 1a                	je     801bf7 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801bdd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801be1:	0f b6 00             	movzbl (%rax),%eax
  801be4:	0f b6 d0             	movzbl %al,%edx
  801be7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801beb:	0f b6 00             	movzbl (%rax),%eax
  801bee:	0f b6 c0             	movzbl %al,%eax
  801bf1:	29 c2                	sub    %eax,%edx
  801bf3:	89 d0                	mov    %edx,%eax
  801bf5:	eb 20                	jmp    801c17 <memcmp+0x72>
		s1++, s2++;
  801bf7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801bfc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801c01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c05:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801c09:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801c0d:	48 85 c0             	test   %rax,%rax
  801c10:	75 b9                	jne    801bcb <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801c12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c17:	c9                   	leaveq 
  801c18:	c3                   	retq   

0000000000801c19 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801c19:	55                   	push   %rbp
  801c1a:	48 89 e5             	mov    %rsp,%rbp
  801c1d:	48 83 ec 28          	sub    $0x28,%rsp
  801c21:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c25:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801c28:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801c2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c30:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c34:	48 01 d0             	add    %rdx,%rax
  801c37:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801c3b:	eb 15                	jmp    801c52 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c41:	0f b6 10             	movzbl (%rax),%edx
  801c44:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c47:	38 c2                	cmp    %al,%dl
  801c49:	75 02                	jne    801c4d <memfind+0x34>
			break;
  801c4b:	eb 0f                	jmp    801c5c <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c4d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801c52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c56:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801c5a:	72 e1                	jb     801c3d <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801c5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c60:	c9                   	leaveq 
  801c61:	c3                   	retq   

0000000000801c62 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c62:	55                   	push   %rbp
  801c63:	48 89 e5             	mov    %rsp,%rbp
  801c66:	48 83 ec 34          	sub    $0x34,%rsp
  801c6a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c6e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801c72:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801c75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801c7c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801c83:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c84:	eb 05                	jmp    801c8b <strtol+0x29>
		s++;
  801c86:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c8f:	0f b6 00             	movzbl (%rax),%eax
  801c92:	3c 20                	cmp    $0x20,%al
  801c94:	74 f0                	je     801c86 <strtol+0x24>
  801c96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c9a:	0f b6 00             	movzbl (%rax),%eax
  801c9d:	3c 09                	cmp    $0x9,%al
  801c9f:	74 e5                	je     801c86 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801ca1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ca5:	0f b6 00             	movzbl (%rax),%eax
  801ca8:	3c 2b                	cmp    $0x2b,%al
  801caa:	75 07                	jne    801cb3 <strtol+0x51>
		s++;
  801cac:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801cb1:	eb 17                	jmp    801cca <strtol+0x68>
	else if (*s == '-')
  801cb3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cb7:	0f b6 00             	movzbl (%rax),%eax
  801cba:	3c 2d                	cmp    $0x2d,%al
  801cbc:	75 0c                	jne    801cca <strtol+0x68>
		s++, neg = 1;
  801cbe:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801cc3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801cca:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801cce:	74 06                	je     801cd6 <strtol+0x74>
  801cd0:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801cd4:	75 28                	jne    801cfe <strtol+0x9c>
  801cd6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cda:	0f b6 00             	movzbl (%rax),%eax
  801cdd:	3c 30                	cmp    $0x30,%al
  801cdf:	75 1d                	jne    801cfe <strtol+0x9c>
  801ce1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ce5:	48 83 c0 01          	add    $0x1,%rax
  801ce9:	0f b6 00             	movzbl (%rax),%eax
  801cec:	3c 78                	cmp    $0x78,%al
  801cee:	75 0e                	jne    801cfe <strtol+0x9c>
		s += 2, base = 16;
  801cf0:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801cf5:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801cfc:	eb 2c                	jmp    801d2a <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801cfe:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801d02:	75 19                	jne    801d1d <strtol+0xbb>
  801d04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d08:	0f b6 00             	movzbl (%rax),%eax
  801d0b:	3c 30                	cmp    $0x30,%al
  801d0d:	75 0e                	jne    801d1d <strtol+0xbb>
		s++, base = 8;
  801d0f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d14:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801d1b:	eb 0d                	jmp    801d2a <strtol+0xc8>
	else if (base == 0)
  801d1d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801d21:	75 07                	jne    801d2a <strtol+0xc8>
		base = 10;
  801d23:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801d2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d2e:	0f b6 00             	movzbl (%rax),%eax
  801d31:	3c 2f                	cmp    $0x2f,%al
  801d33:	7e 1d                	jle    801d52 <strtol+0xf0>
  801d35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d39:	0f b6 00             	movzbl (%rax),%eax
  801d3c:	3c 39                	cmp    $0x39,%al
  801d3e:	7f 12                	jg     801d52 <strtol+0xf0>
			dig = *s - '0';
  801d40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d44:	0f b6 00             	movzbl (%rax),%eax
  801d47:	0f be c0             	movsbl %al,%eax
  801d4a:	83 e8 30             	sub    $0x30,%eax
  801d4d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d50:	eb 4e                	jmp    801da0 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801d52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d56:	0f b6 00             	movzbl (%rax),%eax
  801d59:	3c 60                	cmp    $0x60,%al
  801d5b:	7e 1d                	jle    801d7a <strtol+0x118>
  801d5d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d61:	0f b6 00             	movzbl (%rax),%eax
  801d64:	3c 7a                	cmp    $0x7a,%al
  801d66:	7f 12                	jg     801d7a <strtol+0x118>
			dig = *s - 'a' + 10;
  801d68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d6c:	0f b6 00             	movzbl (%rax),%eax
  801d6f:	0f be c0             	movsbl %al,%eax
  801d72:	83 e8 57             	sub    $0x57,%eax
  801d75:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d78:	eb 26                	jmp    801da0 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801d7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d7e:	0f b6 00             	movzbl (%rax),%eax
  801d81:	3c 40                	cmp    $0x40,%al
  801d83:	7e 48                	jle    801dcd <strtol+0x16b>
  801d85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d89:	0f b6 00             	movzbl (%rax),%eax
  801d8c:	3c 5a                	cmp    $0x5a,%al
  801d8e:	7f 3d                	jg     801dcd <strtol+0x16b>
			dig = *s - 'A' + 10;
  801d90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d94:	0f b6 00             	movzbl (%rax),%eax
  801d97:	0f be c0             	movsbl %al,%eax
  801d9a:	83 e8 37             	sub    $0x37,%eax
  801d9d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801da0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801da3:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801da6:	7c 02                	jl     801daa <strtol+0x148>
			break;
  801da8:	eb 23                	jmp    801dcd <strtol+0x16b>
		s++, val = (val * base) + dig;
  801daa:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801daf:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801db2:	48 98                	cltq   
  801db4:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801db9:	48 89 c2             	mov    %rax,%rdx
  801dbc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801dbf:	48 98                	cltq   
  801dc1:	48 01 d0             	add    %rdx,%rax
  801dc4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801dc8:	e9 5d ff ff ff       	jmpq   801d2a <strtol+0xc8>

	if (endptr)
  801dcd:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801dd2:	74 0b                	je     801ddf <strtol+0x17d>
		*endptr = (char *) s;
  801dd4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dd8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801ddc:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801ddf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801de3:	74 09                	je     801dee <strtol+0x18c>
  801de5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801de9:	48 f7 d8             	neg    %rax
  801dec:	eb 04                	jmp    801df2 <strtol+0x190>
  801dee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801df2:	c9                   	leaveq 
  801df3:	c3                   	retq   

0000000000801df4 <strstr>:

char * strstr(const char *in, const char *str)
{
  801df4:	55                   	push   %rbp
  801df5:	48 89 e5             	mov    %rsp,%rbp
  801df8:	48 83 ec 30          	sub    $0x30,%rsp
  801dfc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e00:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801e04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e08:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e0c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801e10:	0f b6 00             	movzbl (%rax),%eax
  801e13:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801e16:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801e1a:	75 06                	jne    801e22 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801e1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e20:	eb 6b                	jmp    801e8d <strstr+0x99>

	len = strlen(str);
  801e22:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e26:	48 89 c7             	mov    %rax,%rdi
  801e29:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  801e30:	00 00 00 
  801e33:	ff d0                	callq  *%rax
  801e35:	48 98                	cltq   
  801e37:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801e3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e3f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e43:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801e47:	0f b6 00             	movzbl (%rax),%eax
  801e4a:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801e4d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801e51:	75 07                	jne    801e5a <strstr+0x66>
				return (char *) 0;
  801e53:	b8 00 00 00 00       	mov    $0x0,%eax
  801e58:	eb 33                	jmp    801e8d <strstr+0x99>
		} while (sc != c);
  801e5a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801e5e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801e61:	75 d8                	jne    801e3b <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801e63:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e67:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801e6b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e6f:	48 89 ce             	mov    %rcx,%rsi
  801e72:	48 89 c7             	mov    %rax,%rdi
  801e75:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  801e7c:	00 00 00 
  801e7f:	ff d0                	callq  *%rax
  801e81:	85 c0                	test   %eax,%eax
  801e83:	75 b6                	jne    801e3b <strstr+0x47>

	return (char *) (in - 1);
  801e85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e89:	48 83 e8 01          	sub    $0x1,%rax
}
  801e8d:	c9                   	leaveq 
  801e8e:	c3                   	retq   

0000000000801e8f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801e8f:	55                   	push   %rbp
  801e90:	48 89 e5             	mov    %rsp,%rbp
  801e93:	53                   	push   %rbx
  801e94:	48 83 ec 48          	sub    $0x48,%rsp
  801e98:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801e9b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801e9e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801ea2:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801ea6:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801eaa:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801eae:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801eb1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801eb5:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801eb9:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801ebd:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801ec1:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801ec5:	4c 89 c3             	mov    %r8,%rbx
  801ec8:	cd 30                	int    $0x30
  801eca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801ece:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801ed2:	74 3e                	je     801f12 <syscall+0x83>
  801ed4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ed9:	7e 37                	jle    801f12 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801edb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801edf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ee2:	49 89 d0             	mov    %rdx,%r8
  801ee5:	89 c1                	mov    %eax,%ecx
  801ee7:	48 ba 88 59 80 00 00 	movabs $0x805988,%rdx
  801eee:	00 00 00 
  801ef1:	be 23 00 00 00       	mov    $0x23,%esi
  801ef6:	48 bf a5 59 80 00 00 	movabs $0x8059a5,%rdi
  801efd:	00 00 00 
  801f00:	b8 00 00 00 00       	mov    $0x0,%eax
  801f05:	49 b9 48 09 80 00 00 	movabs $0x800948,%r9
  801f0c:	00 00 00 
  801f0f:	41 ff d1             	callq  *%r9

	return ret;
  801f12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801f16:	48 83 c4 48          	add    $0x48,%rsp
  801f1a:	5b                   	pop    %rbx
  801f1b:	5d                   	pop    %rbp
  801f1c:	c3                   	retq   

0000000000801f1d <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801f1d:	55                   	push   %rbp
  801f1e:	48 89 e5             	mov    %rsp,%rbp
  801f21:	48 83 ec 20          	sub    $0x20,%rsp
  801f25:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f29:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801f2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f31:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f35:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f3c:	00 
  801f3d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f43:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f49:	48 89 d1             	mov    %rdx,%rcx
  801f4c:	48 89 c2             	mov    %rax,%rdx
  801f4f:	be 00 00 00 00       	mov    $0x0,%esi
  801f54:	bf 00 00 00 00       	mov    $0x0,%edi
  801f59:	48 b8 8f 1e 80 00 00 	movabs $0x801e8f,%rax
  801f60:	00 00 00 
  801f63:	ff d0                	callq  *%rax
}
  801f65:	c9                   	leaveq 
  801f66:	c3                   	retq   

0000000000801f67 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f67:	55                   	push   %rbp
  801f68:	48 89 e5             	mov    %rsp,%rbp
  801f6b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801f6f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f76:	00 
  801f77:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f7d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f83:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f88:	ba 00 00 00 00       	mov    $0x0,%edx
  801f8d:	be 00 00 00 00       	mov    $0x0,%esi
  801f92:	bf 01 00 00 00       	mov    $0x1,%edi
  801f97:	48 b8 8f 1e 80 00 00 	movabs $0x801e8f,%rax
  801f9e:	00 00 00 
  801fa1:	ff d0                	callq  *%rax
}
  801fa3:	c9                   	leaveq 
  801fa4:	c3                   	retq   

0000000000801fa5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801fa5:	55                   	push   %rbp
  801fa6:	48 89 e5             	mov    %rsp,%rbp
  801fa9:	48 83 ec 10          	sub    $0x10,%rsp
  801fad:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801fb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fb3:	48 98                	cltq   
  801fb5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fbc:	00 
  801fbd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fc3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fc9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fce:	48 89 c2             	mov    %rax,%rdx
  801fd1:	be 01 00 00 00       	mov    $0x1,%esi
  801fd6:	bf 03 00 00 00       	mov    $0x3,%edi
  801fdb:	48 b8 8f 1e 80 00 00 	movabs $0x801e8f,%rax
  801fe2:	00 00 00 
  801fe5:	ff d0                	callq  *%rax
}
  801fe7:	c9                   	leaveq 
  801fe8:	c3                   	retq   

0000000000801fe9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801fe9:	55                   	push   %rbp
  801fea:	48 89 e5             	mov    %rsp,%rbp
  801fed:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ff1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ff8:	00 
  801ff9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802005:	b9 00 00 00 00       	mov    $0x0,%ecx
  80200a:	ba 00 00 00 00       	mov    $0x0,%edx
  80200f:	be 00 00 00 00       	mov    $0x0,%esi
  802014:	bf 02 00 00 00       	mov    $0x2,%edi
  802019:	48 b8 8f 1e 80 00 00 	movabs $0x801e8f,%rax
  802020:	00 00 00 
  802023:	ff d0                	callq  *%rax
}
  802025:	c9                   	leaveq 
  802026:	c3                   	retq   

0000000000802027 <sys_yield>:

void
sys_yield(void)
{
  802027:	55                   	push   %rbp
  802028:	48 89 e5             	mov    %rsp,%rbp
  80202b:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80202f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802036:	00 
  802037:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80203d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802043:	b9 00 00 00 00       	mov    $0x0,%ecx
  802048:	ba 00 00 00 00       	mov    $0x0,%edx
  80204d:	be 00 00 00 00       	mov    $0x0,%esi
  802052:	bf 0b 00 00 00       	mov    $0xb,%edi
  802057:	48 b8 8f 1e 80 00 00 	movabs $0x801e8f,%rax
  80205e:	00 00 00 
  802061:	ff d0                	callq  *%rax
}
  802063:	c9                   	leaveq 
  802064:	c3                   	retq   

0000000000802065 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802065:	55                   	push   %rbp
  802066:	48 89 e5             	mov    %rsp,%rbp
  802069:	48 83 ec 20          	sub    $0x20,%rsp
  80206d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802070:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802074:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802077:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80207a:	48 63 c8             	movslq %eax,%rcx
  80207d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802081:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802084:	48 98                	cltq   
  802086:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80208d:	00 
  80208e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802094:	49 89 c8             	mov    %rcx,%r8
  802097:	48 89 d1             	mov    %rdx,%rcx
  80209a:	48 89 c2             	mov    %rax,%rdx
  80209d:	be 01 00 00 00       	mov    $0x1,%esi
  8020a2:	bf 04 00 00 00       	mov    $0x4,%edi
  8020a7:	48 b8 8f 1e 80 00 00 	movabs $0x801e8f,%rax
  8020ae:	00 00 00 
  8020b1:	ff d0                	callq  *%rax
}
  8020b3:	c9                   	leaveq 
  8020b4:	c3                   	retq   

00000000008020b5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8020b5:	55                   	push   %rbp
  8020b6:	48 89 e5             	mov    %rsp,%rbp
  8020b9:	48 83 ec 30          	sub    $0x30,%rsp
  8020bd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8020c4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8020c7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8020cb:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8020cf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8020d2:	48 63 c8             	movslq %eax,%rcx
  8020d5:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8020d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020dc:	48 63 f0             	movslq %eax,%rsi
  8020df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020e6:	48 98                	cltq   
  8020e8:	48 89 0c 24          	mov    %rcx,(%rsp)
  8020ec:	49 89 f9             	mov    %rdi,%r9
  8020ef:	49 89 f0             	mov    %rsi,%r8
  8020f2:	48 89 d1             	mov    %rdx,%rcx
  8020f5:	48 89 c2             	mov    %rax,%rdx
  8020f8:	be 01 00 00 00       	mov    $0x1,%esi
  8020fd:	bf 05 00 00 00       	mov    $0x5,%edi
  802102:	48 b8 8f 1e 80 00 00 	movabs $0x801e8f,%rax
  802109:	00 00 00 
  80210c:	ff d0                	callq  *%rax
}
  80210e:	c9                   	leaveq 
  80210f:	c3                   	retq   

0000000000802110 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802110:	55                   	push   %rbp
  802111:	48 89 e5             	mov    %rsp,%rbp
  802114:	48 83 ec 20          	sub    $0x20,%rsp
  802118:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80211b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80211f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802123:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802126:	48 98                	cltq   
  802128:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80212f:	00 
  802130:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802136:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80213c:	48 89 d1             	mov    %rdx,%rcx
  80213f:	48 89 c2             	mov    %rax,%rdx
  802142:	be 01 00 00 00       	mov    $0x1,%esi
  802147:	bf 06 00 00 00       	mov    $0x6,%edi
  80214c:	48 b8 8f 1e 80 00 00 	movabs $0x801e8f,%rax
  802153:	00 00 00 
  802156:	ff d0                	callq  *%rax
}
  802158:	c9                   	leaveq 
  802159:	c3                   	retq   

000000000080215a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80215a:	55                   	push   %rbp
  80215b:	48 89 e5             	mov    %rsp,%rbp
  80215e:	48 83 ec 10          	sub    $0x10,%rsp
  802162:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802165:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802168:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80216b:	48 63 d0             	movslq %eax,%rdx
  80216e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802171:	48 98                	cltq   
  802173:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80217a:	00 
  80217b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802181:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802187:	48 89 d1             	mov    %rdx,%rcx
  80218a:	48 89 c2             	mov    %rax,%rdx
  80218d:	be 01 00 00 00       	mov    $0x1,%esi
  802192:	bf 08 00 00 00       	mov    $0x8,%edi
  802197:	48 b8 8f 1e 80 00 00 	movabs $0x801e8f,%rax
  80219e:	00 00 00 
  8021a1:	ff d0                	callq  *%rax
}
  8021a3:	c9                   	leaveq 
  8021a4:	c3                   	retq   

00000000008021a5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8021a5:	55                   	push   %rbp
  8021a6:	48 89 e5             	mov    %rsp,%rbp
  8021a9:	48 83 ec 20          	sub    $0x20,%rsp
  8021ad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8021b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021bb:	48 98                	cltq   
  8021bd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021c4:	00 
  8021c5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021cb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021d1:	48 89 d1             	mov    %rdx,%rcx
  8021d4:	48 89 c2             	mov    %rax,%rdx
  8021d7:	be 01 00 00 00       	mov    $0x1,%esi
  8021dc:	bf 09 00 00 00       	mov    $0x9,%edi
  8021e1:	48 b8 8f 1e 80 00 00 	movabs $0x801e8f,%rax
  8021e8:	00 00 00 
  8021eb:	ff d0                	callq  *%rax
}
  8021ed:	c9                   	leaveq 
  8021ee:	c3                   	retq   

00000000008021ef <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8021ef:	55                   	push   %rbp
  8021f0:	48 89 e5             	mov    %rsp,%rbp
  8021f3:	48 83 ec 20          	sub    $0x20,%rsp
  8021f7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021fa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8021fe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802202:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802205:	48 98                	cltq   
  802207:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80220e:	00 
  80220f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802215:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80221b:	48 89 d1             	mov    %rdx,%rcx
  80221e:	48 89 c2             	mov    %rax,%rdx
  802221:	be 01 00 00 00       	mov    $0x1,%esi
  802226:	bf 0a 00 00 00       	mov    $0xa,%edi
  80222b:	48 b8 8f 1e 80 00 00 	movabs $0x801e8f,%rax
  802232:	00 00 00 
  802235:	ff d0                	callq  *%rax
}
  802237:	c9                   	leaveq 
  802238:	c3                   	retq   

0000000000802239 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802239:	55                   	push   %rbp
  80223a:	48 89 e5             	mov    %rsp,%rbp
  80223d:	48 83 ec 20          	sub    $0x20,%rsp
  802241:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802244:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802248:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80224c:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80224f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802252:	48 63 f0             	movslq %eax,%rsi
  802255:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802259:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80225c:	48 98                	cltq   
  80225e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802262:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802269:	00 
  80226a:	49 89 f1             	mov    %rsi,%r9
  80226d:	49 89 c8             	mov    %rcx,%r8
  802270:	48 89 d1             	mov    %rdx,%rcx
  802273:	48 89 c2             	mov    %rax,%rdx
  802276:	be 00 00 00 00       	mov    $0x0,%esi
  80227b:	bf 0c 00 00 00       	mov    $0xc,%edi
  802280:	48 b8 8f 1e 80 00 00 	movabs $0x801e8f,%rax
  802287:	00 00 00 
  80228a:	ff d0                	callq  *%rax
}
  80228c:	c9                   	leaveq 
  80228d:	c3                   	retq   

000000000080228e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80228e:	55                   	push   %rbp
  80228f:	48 89 e5             	mov    %rsp,%rbp
  802292:	48 83 ec 10          	sub    $0x10,%rsp
  802296:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80229a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80229e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022a5:	00 
  8022a6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8022b7:	48 89 c2             	mov    %rax,%rdx
  8022ba:	be 01 00 00 00       	mov    $0x1,%esi
  8022bf:	bf 0d 00 00 00       	mov    $0xd,%edi
  8022c4:	48 b8 8f 1e 80 00 00 	movabs $0x801e8f,%rax
  8022cb:	00 00 00 
  8022ce:	ff d0                	callq  *%rax
}
  8022d0:	c9                   	leaveq 
  8022d1:	c3                   	retq   

00000000008022d2 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  8022d2:	55                   	push   %rbp
  8022d3:	48 89 e5             	mov    %rsp,%rbp
  8022d6:	48 83 ec 20          	sub    $0x20,%rsp
  8022da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8022de:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  8022e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022ea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022f1:	00 
  8022f2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022f8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  802303:	89 c6                	mov    %eax,%esi
  802305:	bf 0f 00 00 00       	mov    $0xf,%edi
  80230a:	48 b8 8f 1e 80 00 00 	movabs $0x801e8f,%rax
  802311:	00 00 00 
  802314:	ff d0                	callq  *%rax
}
  802316:	c9                   	leaveq 
  802317:	c3                   	retq   

0000000000802318 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  802318:	55                   	push   %rbp
  802319:	48 89 e5             	mov    %rsp,%rbp
  80231c:	48 83 ec 20          	sub    $0x20,%rsp
  802320:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802324:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  802328:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80232c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802330:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802337:	00 
  802338:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80233e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802344:	b9 00 00 00 00       	mov    $0x0,%ecx
  802349:	89 c6                	mov    %eax,%esi
  80234b:	bf 10 00 00 00       	mov    $0x10,%edi
  802350:	48 b8 8f 1e 80 00 00 	movabs $0x801e8f,%rax
  802357:	00 00 00 
  80235a:	ff d0                	callq  *%rax
}
  80235c:	c9                   	leaveq 
  80235d:	c3                   	retq   

000000000080235e <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  80235e:	55                   	push   %rbp
  80235f:	48 89 e5             	mov    %rsp,%rbp
  802362:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802366:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80236d:	00 
  80236e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802374:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80237a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80237f:	ba 00 00 00 00       	mov    $0x0,%edx
  802384:	be 00 00 00 00       	mov    $0x0,%esi
  802389:	bf 0e 00 00 00       	mov    $0xe,%edi
  80238e:	48 b8 8f 1e 80 00 00 	movabs $0x801e8f,%rax
  802395:	00 00 00 
  802398:	ff d0                	callq  *%rax
}
  80239a:	c9                   	leaveq 
  80239b:	c3                   	retq   

000000000080239c <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  80239c:	55                   	push   %rbp
  80239d:	48 89 e5             	mov    %rsp,%rbp
  8023a0:	48 83 ec 30          	sub    $0x30,%rsp
  8023a4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  8023a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023ac:	48 8b 00             	mov    (%rax),%rax
  8023af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  8023b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023b7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8023bb:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  8023be:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023c1:	83 e0 02             	and    $0x2,%eax
  8023c4:	85 c0                	test   %eax,%eax
  8023c6:	75 4d                	jne    802415 <pgfault+0x79>
  8023c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023cc:	48 c1 e8 0c          	shr    $0xc,%rax
  8023d0:	48 89 c2             	mov    %rax,%rdx
  8023d3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023da:	01 00 00 
  8023dd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023e1:	25 00 08 00 00       	and    $0x800,%eax
  8023e6:	48 85 c0             	test   %rax,%rax
  8023e9:	74 2a                	je     802415 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  8023eb:	48 ba b8 59 80 00 00 	movabs $0x8059b8,%rdx
  8023f2:	00 00 00 
  8023f5:	be 23 00 00 00       	mov    $0x23,%esi
  8023fa:	48 bf ed 59 80 00 00 	movabs $0x8059ed,%rdi
  802401:	00 00 00 
  802404:	b8 00 00 00 00       	mov    $0x0,%eax
  802409:	48 b9 48 09 80 00 00 	movabs $0x800948,%rcx
  802410:	00 00 00 
  802413:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  802415:	ba 07 00 00 00       	mov    $0x7,%edx
  80241a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80241f:	bf 00 00 00 00       	mov    $0x0,%edi
  802424:	48 b8 65 20 80 00 00 	movabs $0x802065,%rax
  80242b:	00 00 00 
  80242e:	ff d0                	callq  *%rax
  802430:	85 c0                	test   %eax,%eax
  802432:	0f 85 cd 00 00 00    	jne    802505 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  802438:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80243c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802440:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802444:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80244a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  80244e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802452:	ba 00 10 00 00       	mov    $0x1000,%edx
  802457:	48 89 c6             	mov    %rax,%rsi
  80245a:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80245f:	48 b8 5a 1a 80 00 00 	movabs $0x801a5a,%rax
  802466:	00 00 00 
  802469:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  80246b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80246f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802475:	48 89 c1             	mov    %rax,%rcx
  802478:	ba 00 00 00 00       	mov    $0x0,%edx
  80247d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802482:	bf 00 00 00 00       	mov    $0x0,%edi
  802487:	48 b8 b5 20 80 00 00 	movabs $0x8020b5,%rax
  80248e:	00 00 00 
  802491:	ff d0                	callq  *%rax
  802493:	85 c0                	test   %eax,%eax
  802495:	79 2a                	jns    8024c1 <pgfault+0x125>
				panic("Page map at temp address failed");
  802497:	48 ba f8 59 80 00 00 	movabs $0x8059f8,%rdx
  80249e:	00 00 00 
  8024a1:	be 30 00 00 00       	mov    $0x30,%esi
  8024a6:	48 bf ed 59 80 00 00 	movabs $0x8059ed,%rdi
  8024ad:	00 00 00 
  8024b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b5:	48 b9 48 09 80 00 00 	movabs $0x800948,%rcx
  8024bc:	00 00 00 
  8024bf:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  8024c1:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8024c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8024cb:	48 b8 10 21 80 00 00 	movabs $0x802110,%rax
  8024d2:	00 00 00 
  8024d5:	ff d0                	callq  *%rax
  8024d7:	85 c0                	test   %eax,%eax
  8024d9:	79 54                	jns    80252f <pgfault+0x193>
				panic("Page unmap from temp location failed");
  8024db:	48 ba 18 5a 80 00 00 	movabs $0x805a18,%rdx
  8024e2:	00 00 00 
  8024e5:	be 32 00 00 00       	mov    $0x32,%esi
  8024ea:	48 bf ed 59 80 00 00 	movabs $0x8059ed,%rdi
  8024f1:	00 00 00 
  8024f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f9:	48 b9 48 09 80 00 00 	movabs $0x800948,%rcx
  802500:	00 00 00 
  802503:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  802505:	48 ba 40 5a 80 00 00 	movabs $0x805a40,%rdx
  80250c:	00 00 00 
  80250f:	be 34 00 00 00       	mov    $0x34,%esi
  802514:	48 bf ed 59 80 00 00 	movabs $0x8059ed,%rdi
  80251b:	00 00 00 
  80251e:	b8 00 00 00 00       	mov    $0x0,%eax
  802523:	48 b9 48 09 80 00 00 	movabs $0x800948,%rcx
  80252a:	00 00 00 
  80252d:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  80252f:	c9                   	leaveq 
  802530:	c3                   	retq   

0000000000802531 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802531:	55                   	push   %rbp
  802532:	48 89 e5             	mov    %rsp,%rbp
  802535:	48 83 ec 20          	sub    $0x20,%rsp
  802539:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80253c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  80253f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802546:	01 00 00 
  802549:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80254c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802550:	25 07 0e 00 00       	and    $0xe07,%eax
  802555:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  802558:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80255b:	48 c1 e0 0c          	shl    $0xc,%rax
  80255f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  802563:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802566:	25 00 04 00 00       	and    $0x400,%eax
  80256b:	85 c0                	test   %eax,%eax
  80256d:	74 57                	je     8025c6 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80256f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802572:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802576:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802579:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257d:	41 89 f0             	mov    %esi,%r8d
  802580:	48 89 c6             	mov    %rax,%rsi
  802583:	bf 00 00 00 00       	mov    $0x0,%edi
  802588:	48 b8 b5 20 80 00 00 	movabs $0x8020b5,%rax
  80258f:	00 00 00 
  802592:	ff d0                	callq  *%rax
  802594:	85 c0                	test   %eax,%eax
  802596:	0f 8e 52 01 00 00    	jle    8026ee <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  80259c:	48 ba 72 5a 80 00 00 	movabs $0x805a72,%rdx
  8025a3:	00 00 00 
  8025a6:	be 4e 00 00 00       	mov    $0x4e,%esi
  8025ab:	48 bf ed 59 80 00 00 	movabs $0x8059ed,%rdi
  8025b2:	00 00 00 
  8025b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ba:	48 b9 48 09 80 00 00 	movabs $0x800948,%rcx
  8025c1:	00 00 00 
  8025c4:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  8025c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025c9:	83 e0 02             	and    $0x2,%eax
  8025cc:	85 c0                	test   %eax,%eax
  8025ce:	75 10                	jne    8025e0 <duppage+0xaf>
  8025d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d3:	25 00 08 00 00       	and    $0x800,%eax
  8025d8:	85 c0                	test   %eax,%eax
  8025da:	0f 84 bb 00 00 00    	je     80269b <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  8025e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e3:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  8025e8:	80 cc 08             	or     $0x8,%ah
  8025eb:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8025ee:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8025f1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8025f5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8025f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025fc:	41 89 f0             	mov    %esi,%r8d
  8025ff:	48 89 c6             	mov    %rax,%rsi
  802602:	bf 00 00 00 00       	mov    $0x0,%edi
  802607:	48 b8 b5 20 80 00 00 	movabs $0x8020b5,%rax
  80260e:	00 00 00 
  802611:	ff d0                	callq  *%rax
  802613:	85 c0                	test   %eax,%eax
  802615:	7e 2a                	jle    802641 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  802617:	48 ba 72 5a 80 00 00 	movabs $0x805a72,%rdx
  80261e:	00 00 00 
  802621:	be 55 00 00 00       	mov    $0x55,%esi
  802626:	48 bf ed 59 80 00 00 	movabs $0x8059ed,%rdi
  80262d:	00 00 00 
  802630:	b8 00 00 00 00       	mov    $0x0,%eax
  802635:	48 b9 48 09 80 00 00 	movabs $0x800948,%rcx
  80263c:	00 00 00 
  80263f:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802641:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802644:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802648:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80264c:	41 89 c8             	mov    %ecx,%r8d
  80264f:	48 89 d1             	mov    %rdx,%rcx
  802652:	ba 00 00 00 00       	mov    $0x0,%edx
  802657:	48 89 c6             	mov    %rax,%rsi
  80265a:	bf 00 00 00 00       	mov    $0x0,%edi
  80265f:	48 b8 b5 20 80 00 00 	movabs $0x8020b5,%rax
  802666:	00 00 00 
  802669:	ff d0                	callq  *%rax
  80266b:	85 c0                	test   %eax,%eax
  80266d:	7e 2a                	jle    802699 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  80266f:	48 ba 72 5a 80 00 00 	movabs $0x805a72,%rdx
  802676:	00 00 00 
  802679:	be 57 00 00 00       	mov    $0x57,%esi
  80267e:	48 bf ed 59 80 00 00 	movabs $0x8059ed,%rdi
  802685:	00 00 00 
  802688:	b8 00 00 00 00       	mov    $0x0,%eax
  80268d:	48 b9 48 09 80 00 00 	movabs $0x800948,%rcx
  802694:	00 00 00 
  802697:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802699:	eb 53                	jmp    8026ee <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80269b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80269e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8026a2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8026a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a9:	41 89 f0             	mov    %esi,%r8d
  8026ac:	48 89 c6             	mov    %rax,%rsi
  8026af:	bf 00 00 00 00       	mov    $0x0,%edi
  8026b4:	48 b8 b5 20 80 00 00 	movabs $0x8020b5,%rax
  8026bb:	00 00 00 
  8026be:	ff d0                	callq  *%rax
  8026c0:	85 c0                	test   %eax,%eax
  8026c2:	7e 2a                	jle    8026ee <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  8026c4:	48 ba 72 5a 80 00 00 	movabs $0x805a72,%rdx
  8026cb:	00 00 00 
  8026ce:	be 5b 00 00 00       	mov    $0x5b,%esi
  8026d3:	48 bf ed 59 80 00 00 	movabs $0x8059ed,%rdi
  8026da:	00 00 00 
  8026dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e2:	48 b9 48 09 80 00 00 	movabs $0x800948,%rcx
  8026e9:	00 00 00 
  8026ec:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  8026ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026f3:	c9                   	leaveq 
  8026f4:	c3                   	retq   

00000000008026f5 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  8026f5:	55                   	push   %rbp
  8026f6:	48 89 e5             	mov    %rsp,%rbp
  8026f9:	48 83 ec 18          	sub    $0x18,%rsp
  8026fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  802701:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802705:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  802709:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80270d:	48 c1 e8 27          	shr    $0x27,%rax
  802711:	48 89 c2             	mov    %rax,%rdx
  802714:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80271b:	01 00 00 
  80271e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802722:	83 e0 01             	and    $0x1,%eax
  802725:	48 85 c0             	test   %rax,%rax
  802728:	74 51                	je     80277b <pt_is_mapped+0x86>
  80272a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80272e:	48 c1 e0 0c          	shl    $0xc,%rax
  802732:	48 c1 e8 1e          	shr    $0x1e,%rax
  802736:	48 89 c2             	mov    %rax,%rdx
  802739:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802740:	01 00 00 
  802743:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802747:	83 e0 01             	and    $0x1,%eax
  80274a:	48 85 c0             	test   %rax,%rax
  80274d:	74 2c                	je     80277b <pt_is_mapped+0x86>
  80274f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802753:	48 c1 e0 0c          	shl    $0xc,%rax
  802757:	48 c1 e8 15          	shr    $0x15,%rax
  80275b:	48 89 c2             	mov    %rax,%rdx
  80275e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802765:	01 00 00 
  802768:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80276c:	83 e0 01             	and    $0x1,%eax
  80276f:	48 85 c0             	test   %rax,%rax
  802772:	74 07                	je     80277b <pt_is_mapped+0x86>
  802774:	b8 01 00 00 00       	mov    $0x1,%eax
  802779:	eb 05                	jmp    802780 <pt_is_mapped+0x8b>
  80277b:	b8 00 00 00 00       	mov    $0x0,%eax
  802780:	83 e0 01             	and    $0x1,%eax
}
  802783:	c9                   	leaveq 
  802784:	c3                   	retq   

0000000000802785 <fork>:

envid_t
fork(void)
{
  802785:	55                   	push   %rbp
  802786:	48 89 e5             	mov    %rsp,%rbp
  802789:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  80278d:	48 bf 9c 23 80 00 00 	movabs $0x80239c,%rdi
  802794:	00 00 00 
  802797:	48 b8 ac 4c 80 00 00 	movabs $0x804cac,%rax
  80279e:	00 00 00 
  8027a1:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8027a3:	b8 07 00 00 00       	mov    $0x7,%eax
  8027a8:	cd 30                	int    $0x30
  8027aa:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8027ad:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8027b0:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  8027b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8027b7:	79 30                	jns    8027e9 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8027b9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8027bc:	89 c1                	mov    %eax,%ecx
  8027be:	48 ba 90 5a 80 00 00 	movabs $0x805a90,%rdx
  8027c5:	00 00 00 
  8027c8:	be 86 00 00 00       	mov    $0x86,%esi
  8027cd:	48 bf ed 59 80 00 00 	movabs $0x8059ed,%rdi
  8027d4:	00 00 00 
  8027d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027dc:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  8027e3:	00 00 00 
  8027e6:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  8027e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8027ed:	75 46                	jne    802835 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8027ef:	48 b8 e9 1f 80 00 00 	movabs $0x801fe9,%rax
  8027f6:	00 00 00 
  8027f9:	ff d0                	callq  *%rax
  8027fb:	25 ff 03 00 00       	and    $0x3ff,%eax
  802800:	48 63 d0             	movslq %eax,%rdx
  802803:	48 89 d0             	mov    %rdx,%rax
  802806:	48 c1 e0 03          	shl    $0x3,%rax
  80280a:	48 01 d0             	add    %rdx,%rax
  80280d:	48 c1 e0 05          	shl    $0x5,%rax
  802811:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802818:	00 00 00 
  80281b:	48 01 c2             	add    %rax,%rdx
  80281e:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802825:	00 00 00 
  802828:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80282b:	b8 00 00 00 00       	mov    $0x0,%eax
  802830:	e9 d1 01 00 00       	jmpq   802a06 <fork+0x281>
	}
	uint64_t ad = 0;
  802835:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80283c:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80283d:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  802842:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802846:	e9 df 00 00 00       	jmpq   80292a <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  80284b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80284f:	48 c1 e8 27          	shr    $0x27,%rax
  802853:	48 89 c2             	mov    %rax,%rdx
  802856:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80285d:	01 00 00 
  802860:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802864:	83 e0 01             	and    $0x1,%eax
  802867:	48 85 c0             	test   %rax,%rax
  80286a:	0f 84 9e 00 00 00    	je     80290e <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802870:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802874:	48 c1 e8 1e          	shr    $0x1e,%rax
  802878:	48 89 c2             	mov    %rax,%rdx
  80287b:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802882:	01 00 00 
  802885:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802889:	83 e0 01             	and    $0x1,%eax
  80288c:	48 85 c0             	test   %rax,%rax
  80288f:	74 73                	je     802904 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  802891:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802895:	48 c1 e8 15          	shr    $0x15,%rax
  802899:	48 89 c2             	mov    %rax,%rdx
  80289c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028a3:	01 00 00 
  8028a6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028aa:	83 e0 01             	and    $0x1,%eax
  8028ad:	48 85 c0             	test   %rax,%rax
  8028b0:	74 48                	je     8028fa <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8028b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028b6:	48 c1 e8 0c          	shr    $0xc,%rax
  8028ba:	48 89 c2             	mov    %rax,%rdx
  8028bd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028c4:	01 00 00 
  8028c7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028cb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8028cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d3:	83 e0 01             	and    $0x1,%eax
  8028d6:	48 85 c0             	test   %rax,%rax
  8028d9:	74 47                	je     802922 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  8028db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028df:	48 c1 e8 0c          	shr    $0xc,%rax
  8028e3:	89 c2                	mov    %eax,%edx
  8028e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8028e8:	89 d6                	mov    %edx,%esi
  8028ea:	89 c7                	mov    %eax,%edi
  8028ec:	48 b8 31 25 80 00 00 	movabs $0x802531,%rax
  8028f3:	00 00 00 
  8028f6:	ff d0                	callq  *%rax
  8028f8:	eb 28                	jmp    802922 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  8028fa:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802901:	00 
  802902:	eb 1e                	jmp    802922 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802904:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  80290b:	40 
  80290c:	eb 14                	jmp    802922 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  80290e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802912:	48 c1 e8 27          	shr    $0x27,%rax
  802916:	48 83 c0 01          	add    $0x1,%rax
  80291a:	48 c1 e0 27          	shl    $0x27,%rax
  80291e:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802922:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802929:	00 
  80292a:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802931:	00 
  802932:	0f 87 13 ff ff ff    	ja     80284b <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802938:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80293b:	ba 07 00 00 00       	mov    $0x7,%edx
  802940:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802945:	89 c7                	mov    %eax,%edi
  802947:	48 b8 65 20 80 00 00 	movabs $0x802065,%rax
  80294e:	00 00 00 
  802951:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802953:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802956:	ba 07 00 00 00       	mov    $0x7,%edx
  80295b:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802960:	89 c7                	mov    %eax,%edi
  802962:	48 b8 65 20 80 00 00 	movabs $0x802065,%rax
  802969:	00 00 00 
  80296c:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  80296e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802971:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802977:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  80297c:	ba 00 00 00 00       	mov    $0x0,%edx
  802981:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802986:	89 c7                	mov    %eax,%edi
  802988:	48 b8 b5 20 80 00 00 	movabs $0x8020b5,%rax
  80298f:	00 00 00 
  802992:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802994:	ba 00 10 00 00       	mov    $0x1000,%edx
  802999:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80299e:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8029a3:	48 b8 5a 1a 80 00 00 	movabs $0x801a5a,%rax
  8029aa:	00 00 00 
  8029ad:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8029af:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8029b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8029b9:	48 b8 10 21 80 00 00 	movabs $0x802110,%rax
  8029c0:	00 00 00 
  8029c3:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  8029c5:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8029cc:	00 00 00 
  8029cf:	48 8b 00             	mov    (%rax),%rax
  8029d2:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8029d9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8029dc:	48 89 d6             	mov    %rdx,%rsi
  8029df:	89 c7                	mov    %eax,%edi
  8029e1:	48 b8 ef 21 80 00 00 	movabs $0x8021ef,%rax
  8029e8:	00 00 00 
  8029eb:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  8029ed:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8029f0:	be 02 00 00 00       	mov    $0x2,%esi
  8029f5:	89 c7                	mov    %eax,%edi
  8029f7:	48 b8 5a 21 80 00 00 	movabs $0x80215a,%rax
  8029fe:	00 00 00 
  802a01:	ff d0                	callq  *%rax

	return envid;
  802a03:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802a06:	c9                   	leaveq 
  802a07:	c3                   	retq   

0000000000802a08 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802a08:	55                   	push   %rbp
  802a09:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802a0c:	48 ba a8 5a 80 00 00 	movabs $0x805aa8,%rdx
  802a13:	00 00 00 
  802a16:	be bf 00 00 00       	mov    $0xbf,%esi
  802a1b:	48 bf ed 59 80 00 00 	movabs $0x8059ed,%rdi
  802a22:	00 00 00 
  802a25:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2a:	48 b9 48 09 80 00 00 	movabs $0x800948,%rcx
  802a31:	00 00 00 
  802a34:	ff d1                	callq  *%rcx

0000000000802a36 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802a36:	55                   	push   %rbp
  802a37:	48 89 e5             	mov    %rsp,%rbp
  802a3a:	48 83 ec 30          	sub    $0x30,%rsp
  802a3e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a42:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a46:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  802a4a:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802a51:	00 00 00 
  802a54:	48 8b 00             	mov    (%rax),%rax
  802a57:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  802a5d:	85 c0                	test   %eax,%eax
  802a5f:	75 3c                	jne    802a9d <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  802a61:	48 b8 e9 1f 80 00 00 	movabs $0x801fe9,%rax
  802a68:	00 00 00 
  802a6b:	ff d0                	callq  *%rax
  802a6d:	25 ff 03 00 00       	and    $0x3ff,%eax
  802a72:	48 63 d0             	movslq %eax,%rdx
  802a75:	48 89 d0             	mov    %rdx,%rax
  802a78:	48 c1 e0 03          	shl    $0x3,%rax
  802a7c:	48 01 d0             	add    %rdx,%rax
  802a7f:	48 c1 e0 05          	shl    $0x5,%rax
  802a83:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802a8a:	00 00 00 
  802a8d:	48 01 c2             	add    %rax,%rdx
  802a90:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802a97:	00 00 00 
  802a9a:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  802a9d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802aa2:	75 0e                	jne    802ab2 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  802aa4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802aab:	00 00 00 
  802aae:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  802ab2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ab6:	48 89 c7             	mov    %rax,%rdi
  802ab9:	48 b8 8e 22 80 00 00 	movabs $0x80228e,%rax
  802ac0:	00 00 00 
  802ac3:	ff d0                	callq  *%rax
  802ac5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  802ac8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802acc:	79 19                	jns    802ae7 <ipc_recv+0xb1>
		*from_env_store = 0;
  802ace:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  802ad8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802adc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  802ae2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae5:	eb 53                	jmp    802b3a <ipc_recv+0x104>
	}
	if(from_env_store)
  802ae7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802aec:	74 19                	je     802b07 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  802aee:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802af5:	00 00 00 
  802af8:	48 8b 00             	mov    (%rax),%rax
  802afb:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802b01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b05:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  802b07:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802b0c:	74 19                	je     802b27 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  802b0e:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802b15:	00 00 00 
  802b18:	48 8b 00             	mov    (%rax),%rax
  802b1b:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802b21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b25:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  802b27:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802b2e:	00 00 00 
  802b31:	48 8b 00             	mov    (%rax),%rax
  802b34:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  802b3a:	c9                   	leaveq 
  802b3b:	c3                   	retq   

0000000000802b3c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802b3c:	55                   	push   %rbp
  802b3d:	48 89 e5             	mov    %rsp,%rbp
  802b40:	48 83 ec 30          	sub    $0x30,%rsp
  802b44:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b47:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802b4a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802b4e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  802b51:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802b56:	75 0e                	jne    802b66 <ipc_send+0x2a>
		pg = (void*)UTOP;
  802b58:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802b5f:	00 00 00 
  802b62:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  802b66:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802b69:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802b6c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b70:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b73:	89 c7                	mov    %eax,%edi
  802b75:	48 b8 39 22 80 00 00 	movabs $0x802239,%rax
  802b7c:	00 00 00 
  802b7f:	ff d0                	callq  *%rax
  802b81:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  802b84:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802b88:	75 0c                	jne    802b96 <ipc_send+0x5a>
			sys_yield();
  802b8a:	48 b8 27 20 80 00 00 	movabs $0x802027,%rax
  802b91:	00 00 00 
  802b94:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  802b96:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802b9a:	74 ca                	je     802b66 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  802b9c:	c9                   	leaveq 
  802b9d:	c3                   	retq   

0000000000802b9e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802b9e:	55                   	push   %rbp
  802b9f:	48 89 e5             	mov    %rsp,%rbp
  802ba2:	48 83 ec 14          	sub    $0x14,%rsp
  802ba6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802ba9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bb0:	eb 5e                	jmp    802c10 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802bb2:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802bb9:	00 00 00 
  802bbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bbf:	48 63 d0             	movslq %eax,%rdx
  802bc2:	48 89 d0             	mov    %rdx,%rax
  802bc5:	48 c1 e0 03          	shl    $0x3,%rax
  802bc9:	48 01 d0             	add    %rdx,%rax
  802bcc:	48 c1 e0 05          	shl    $0x5,%rax
  802bd0:	48 01 c8             	add    %rcx,%rax
  802bd3:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802bd9:	8b 00                	mov    (%rax),%eax
  802bdb:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802bde:	75 2c                	jne    802c0c <ipc_find_env+0x6e>
			return envs[i].env_id;
  802be0:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802be7:	00 00 00 
  802bea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bed:	48 63 d0             	movslq %eax,%rdx
  802bf0:	48 89 d0             	mov    %rdx,%rax
  802bf3:	48 c1 e0 03          	shl    $0x3,%rax
  802bf7:	48 01 d0             	add    %rdx,%rax
  802bfa:	48 c1 e0 05          	shl    $0x5,%rax
  802bfe:	48 01 c8             	add    %rcx,%rax
  802c01:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802c07:	8b 40 08             	mov    0x8(%rax),%eax
  802c0a:	eb 12                	jmp    802c1e <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802c0c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802c10:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802c17:	7e 99                	jle    802bb2 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802c19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c1e:	c9                   	leaveq 
  802c1f:	c3                   	retq   

0000000000802c20 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802c20:	55                   	push   %rbp
  802c21:	48 89 e5             	mov    %rsp,%rbp
  802c24:	48 83 ec 08          	sub    $0x8,%rsp
  802c28:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802c2c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c30:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802c37:	ff ff ff 
  802c3a:	48 01 d0             	add    %rdx,%rax
  802c3d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802c41:	c9                   	leaveq 
  802c42:	c3                   	retq   

0000000000802c43 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802c43:	55                   	push   %rbp
  802c44:	48 89 e5             	mov    %rsp,%rbp
  802c47:	48 83 ec 08          	sub    $0x8,%rsp
  802c4b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802c4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c53:	48 89 c7             	mov    %rax,%rdi
  802c56:	48 b8 20 2c 80 00 00 	movabs $0x802c20,%rax
  802c5d:	00 00 00 
  802c60:	ff d0                	callq  *%rax
  802c62:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802c68:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802c6c:	c9                   	leaveq 
  802c6d:	c3                   	retq   

0000000000802c6e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802c6e:	55                   	push   %rbp
  802c6f:	48 89 e5             	mov    %rsp,%rbp
  802c72:	48 83 ec 18          	sub    $0x18,%rsp
  802c76:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802c7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c81:	eb 6b                	jmp    802cee <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802c83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c86:	48 98                	cltq   
  802c88:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802c8e:	48 c1 e0 0c          	shl    $0xc,%rax
  802c92:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802c96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c9a:	48 c1 e8 15          	shr    $0x15,%rax
  802c9e:	48 89 c2             	mov    %rax,%rdx
  802ca1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802ca8:	01 00 00 
  802cab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802caf:	83 e0 01             	and    $0x1,%eax
  802cb2:	48 85 c0             	test   %rax,%rax
  802cb5:	74 21                	je     802cd8 <fd_alloc+0x6a>
  802cb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cbb:	48 c1 e8 0c          	shr    $0xc,%rax
  802cbf:	48 89 c2             	mov    %rax,%rdx
  802cc2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cc9:	01 00 00 
  802ccc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cd0:	83 e0 01             	and    $0x1,%eax
  802cd3:	48 85 c0             	test   %rax,%rax
  802cd6:	75 12                	jne    802cea <fd_alloc+0x7c>
			*fd_store = fd;
  802cd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cdc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ce0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802ce3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce8:	eb 1a                	jmp    802d04 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802cea:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802cee:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802cf2:	7e 8f                	jle    802c83 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802cf4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802cff:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802d04:	c9                   	leaveq 
  802d05:	c3                   	retq   

0000000000802d06 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802d06:	55                   	push   %rbp
  802d07:	48 89 e5             	mov    %rsp,%rbp
  802d0a:	48 83 ec 20          	sub    $0x20,%rsp
  802d0e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d11:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802d15:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d19:	78 06                	js     802d21 <fd_lookup+0x1b>
  802d1b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802d1f:	7e 07                	jle    802d28 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802d21:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d26:	eb 6c                	jmp    802d94 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802d28:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d2b:	48 98                	cltq   
  802d2d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802d33:	48 c1 e0 0c          	shl    $0xc,%rax
  802d37:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802d3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d3f:	48 c1 e8 15          	shr    $0x15,%rax
  802d43:	48 89 c2             	mov    %rax,%rdx
  802d46:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802d4d:	01 00 00 
  802d50:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d54:	83 e0 01             	and    $0x1,%eax
  802d57:	48 85 c0             	test   %rax,%rax
  802d5a:	74 21                	je     802d7d <fd_lookup+0x77>
  802d5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d60:	48 c1 e8 0c          	shr    $0xc,%rax
  802d64:	48 89 c2             	mov    %rax,%rdx
  802d67:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d6e:	01 00 00 
  802d71:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d75:	83 e0 01             	and    $0x1,%eax
  802d78:	48 85 c0             	test   %rax,%rax
  802d7b:	75 07                	jne    802d84 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802d7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d82:	eb 10                	jmp    802d94 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802d84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d88:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d8c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802d8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d94:	c9                   	leaveq 
  802d95:	c3                   	retq   

0000000000802d96 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802d96:	55                   	push   %rbp
  802d97:	48 89 e5             	mov    %rsp,%rbp
  802d9a:	48 83 ec 30          	sub    $0x30,%rsp
  802d9e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802da2:	89 f0                	mov    %esi,%eax
  802da4:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802da7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dab:	48 89 c7             	mov    %rax,%rdi
  802dae:	48 b8 20 2c 80 00 00 	movabs $0x802c20,%rax
  802db5:	00 00 00 
  802db8:	ff d0                	callq  *%rax
  802dba:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dbe:	48 89 d6             	mov    %rdx,%rsi
  802dc1:	89 c7                	mov    %eax,%edi
  802dc3:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  802dca:	00 00 00 
  802dcd:	ff d0                	callq  *%rax
  802dcf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd6:	78 0a                	js     802de2 <fd_close+0x4c>
	    || fd != fd2)
  802dd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ddc:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802de0:	74 12                	je     802df4 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802de2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802de6:	74 05                	je     802ded <fd_close+0x57>
  802de8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802deb:	eb 05                	jmp    802df2 <fd_close+0x5c>
  802ded:	b8 00 00 00 00       	mov    $0x0,%eax
  802df2:	eb 69                	jmp    802e5d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802df4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802df8:	8b 00                	mov    (%rax),%eax
  802dfa:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802dfe:	48 89 d6             	mov    %rdx,%rsi
  802e01:	89 c7                	mov    %eax,%edi
  802e03:	48 b8 5f 2e 80 00 00 	movabs $0x802e5f,%rax
  802e0a:	00 00 00 
  802e0d:	ff d0                	callq  *%rax
  802e0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e16:	78 2a                	js     802e42 <fd_close+0xac>
		if (dev->dev_close)
  802e18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e1c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802e20:	48 85 c0             	test   %rax,%rax
  802e23:	74 16                	je     802e3b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802e25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e29:	48 8b 40 20          	mov    0x20(%rax),%rax
  802e2d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e31:	48 89 d7             	mov    %rdx,%rdi
  802e34:	ff d0                	callq  *%rax
  802e36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e39:	eb 07                	jmp    802e42 <fd_close+0xac>
		else
			r = 0;
  802e3b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802e42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e46:	48 89 c6             	mov    %rax,%rsi
  802e49:	bf 00 00 00 00       	mov    $0x0,%edi
  802e4e:	48 b8 10 21 80 00 00 	movabs $0x802110,%rax
  802e55:	00 00 00 
  802e58:	ff d0                	callq  *%rax
	return r;
  802e5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e5d:	c9                   	leaveq 
  802e5e:	c3                   	retq   

0000000000802e5f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802e5f:	55                   	push   %rbp
  802e60:	48 89 e5             	mov    %rsp,%rbp
  802e63:	48 83 ec 20          	sub    $0x20,%rsp
  802e67:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e6a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802e6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e75:	eb 41                	jmp    802eb8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802e77:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802e7e:	00 00 00 
  802e81:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802e84:	48 63 d2             	movslq %edx,%rdx
  802e87:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e8b:	8b 00                	mov    (%rax),%eax
  802e8d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802e90:	75 22                	jne    802eb4 <dev_lookup+0x55>
			*dev = devtab[i];
  802e92:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802e99:	00 00 00 
  802e9c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802e9f:	48 63 d2             	movslq %edx,%rdx
  802ea2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802ea6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eaa:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802ead:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb2:	eb 60                	jmp    802f14 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802eb4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802eb8:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802ebf:	00 00 00 
  802ec2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ec5:	48 63 d2             	movslq %edx,%rdx
  802ec8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ecc:	48 85 c0             	test   %rax,%rax
  802ecf:	75 a6                	jne    802e77 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802ed1:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802ed8:	00 00 00 
  802edb:	48 8b 00             	mov    (%rax),%rax
  802ede:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ee4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ee7:	89 c6                	mov    %eax,%esi
  802ee9:	48 bf c0 5a 80 00 00 	movabs $0x805ac0,%rdi
  802ef0:	00 00 00 
  802ef3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef8:	48 b9 81 0b 80 00 00 	movabs $0x800b81,%rcx
  802eff:	00 00 00 
  802f02:	ff d1                	callq  *%rcx
	*dev = 0;
  802f04:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f08:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802f0f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802f14:	c9                   	leaveq 
  802f15:	c3                   	retq   

0000000000802f16 <close>:

int
close(int fdnum)
{
  802f16:	55                   	push   %rbp
  802f17:	48 89 e5             	mov    %rsp,%rbp
  802f1a:	48 83 ec 20          	sub    $0x20,%rsp
  802f1e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f21:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f25:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f28:	48 89 d6             	mov    %rdx,%rsi
  802f2b:	89 c7                	mov    %eax,%edi
  802f2d:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  802f34:	00 00 00 
  802f37:	ff d0                	callq  *%rax
  802f39:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f40:	79 05                	jns    802f47 <close+0x31>
		return r;
  802f42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f45:	eb 18                	jmp    802f5f <close+0x49>
	else
		return fd_close(fd, 1);
  802f47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f4b:	be 01 00 00 00       	mov    $0x1,%esi
  802f50:	48 89 c7             	mov    %rax,%rdi
  802f53:	48 b8 96 2d 80 00 00 	movabs $0x802d96,%rax
  802f5a:	00 00 00 
  802f5d:	ff d0                	callq  *%rax
}
  802f5f:	c9                   	leaveq 
  802f60:	c3                   	retq   

0000000000802f61 <close_all>:

void
close_all(void)
{
  802f61:	55                   	push   %rbp
  802f62:	48 89 e5             	mov    %rsp,%rbp
  802f65:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802f69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802f70:	eb 15                	jmp    802f87 <close_all+0x26>
		close(i);
  802f72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f75:	89 c7                	mov    %eax,%edi
  802f77:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  802f7e:	00 00 00 
  802f81:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802f83:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802f87:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802f8b:	7e e5                	jle    802f72 <close_all+0x11>
		close(i);
}
  802f8d:	c9                   	leaveq 
  802f8e:	c3                   	retq   

0000000000802f8f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802f8f:	55                   	push   %rbp
  802f90:	48 89 e5             	mov    %rsp,%rbp
  802f93:	48 83 ec 40          	sub    $0x40,%rsp
  802f97:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802f9a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802f9d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802fa1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802fa4:	48 89 d6             	mov    %rdx,%rsi
  802fa7:	89 c7                	mov    %eax,%edi
  802fa9:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  802fb0:	00 00 00 
  802fb3:	ff d0                	callq  *%rax
  802fb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fbc:	79 08                	jns    802fc6 <dup+0x37>
		return r;
  802fbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc1:	e9 70 01 00 00       	jmpq   803136 <dup+0x1a7>
	close(newfdnum);
  802fc6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802fc9:	89 c7                	mov    %eax,%edi
  802fcb:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  802fd2:	00 00 00 
  802fd5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802fd7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802fda:	48 98                	cltq   
  802fdc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802fe2:	48 c1 e0 0c          	shl    $0xc,%rax
  802fe6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802fea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fee:	48 89 c7             	mov    %rax,%rdi
  802ff1:	48 b8 43 2c 80 00 00 	movabs $0x802c43,%rax
  802ff8:	00 00 00 
  802ffb:	ff d0                	callq  *%rax
  802ffd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  803001:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803005:	48 89 c7             	mov    %rax,%rdi
  803008:	48 b8 43 2c 80 00 00 	movabs $0x802c43,%rax
  80300f:	00 00 00 
  803012:	ff d0                	callq  *%rax
  803014:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  803018:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80301c:	48 c1 e8 15          	shr    $0x15,%rax
  803020:	48 89 c2             	mov    %rax,%rdx
  803023:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80302a:	01 00 00 
  80302d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803031:	83 e0 01             	and    $0x1,%eax
  803034:	48 85 c0             	test   %rax,%rax
  803037:	74 73                	je     8030ac <dup+0x11d>
  803039:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80303d:	48 c1 e8 0c          	shr    $0xc,%rax
  803041:	48 89 c2             	mov    %rax,%rdx
  803044:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80304b:	01 00 00 
  80304e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803052:	83 e0 01             	and    $0x1,%eax
  803055:	48 85 c0             	test   %rax,%rax
  803058:	74 52                	je     8030ac <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80305a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80305e:	48 c1 e8 0c          	shr    $0xc,%rax
  803062:	48 89 c2             	mov    %rax,%rdx
  803065:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80306c:	01 00 00 
  80306f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803073:	25 07 0e 00 00       	and    $0xe07,%eax
  803078:	89 c1                	mov    %eax,%ecx
  80307a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80307e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803082:	41 89 c8             	mov    %ecx,%r8d
  803085:	48 89 d1             	mov    %rdx,%rcx
  803088:	ba 00 00 00 00       	mov    $0x0,%edx
  80308d:	48 89 c6             	mov    %rax,%rsi
  803090:	bf 00 00 00 00       	mov    $0x0,%edi
  803095:	48 b8 b5 20 80 00 00 	movabs $0x8020b5,%rax
  80309c:	00 00 00 
  80309f:	ff d0                	callq  *%rax
  8030a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a8:	79 02                	jns    8030ac <dup+0x11d>
			goto err;
  8030aa:	eb 57                	jmp    803103 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8030ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030b0:	48 c1 e8 0c          	shr    $0xc,%rax
  8030b4:	48 89 c2             	mov    %rax,%rdx
  8030b7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8030be:	01 00 00 
  8030c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8030c5:	25 07 0e 00 00       	and    $0xe07,%eax
  8030ca:	89 c1                	mov    %eax,%ecx
  8030cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030d4:	41 89 c8             	mov    %ecx,%r8d
  8030d7:	48 89 d1             	mov    %rdx,%rcx
  8030da:	ba 00 00 00 00       	mov    $0x0,%edx
  8030df:	48 89 c6             	mov    %rax,%rsi
  8030e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8030e7:	48 b8 b5 20 80 00 00 	movabs $0x8020b5,%rax
  8030ee:	00 00 00 
  8030f1:	ff d0                	callq  *%rax
  8030f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030fa:	79 02                	jns    8030fe <dup+0x16f>
		goto err;
  8030fc:	eb 05                	jmp    803103 <dup+0x174>

	return newfdnum;
  8030fe:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803101:	eb 33                	jmp    803136 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  803103:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803107:	48 89 c6             	mov    %rax,%rsi
  80310a:	bf 00 00 00 00       	mov    $0x0,%edi
  80310f:	48 b8 10 21 80 00 00 	movabs $0x802110,%rax
  803116:	00 00 00 
  803119:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80311b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80311f:	48 89 c6             	mov    %rax,%rsi
  803122:	bf 00 00 00 00       	mov    $0x0,%edi
  803127:	48 b8 10 21 80 00 00 	movabs $0x802110,%rax
  80312e:	00 00 00 
  803131:	ff d0                	callq  *%rax
	return r;
  803133:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803136:	c9                   	leaveq 
  803137:	c3                   	retq   

0000000000803138 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803138:	55                   	push   %rbp
  803139:	48 89 e5             	mov    %rsp,%rbp
  80313c:	48 83 ec 40          	sub    $0x40,%rsp
  803140:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803143:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803147:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80314b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80314f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803152:	48 89 d6             	mov    %rdx,%rsi
  803155:	89 c7                	mov    %eax,%edi
  803157:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  80315e:	00 00 00 
  803161:	ff d0                	callq  *%rax
  803163:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803166:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80316a:	78 24                	js     803190 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80316c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803170:	8b 00                	mov    (%rax),%eax
  803172:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803176:	48 89 d6             	mov    %rdx,%rsi
  803179:	89 c7                	mov    %eax,%edi
  80317b:	48 b8 5f 2e 80 00 00 	movabs $0x802e5f,%rax
  803182:	00 00 00 
  803185:	ff d0                	callq  *%rax
  803187:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80318a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80318e:	79 05                	jns    803195 <read+0x5d>
		return r;
  803190:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803193:	eb 76                	jmp    80320b <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803195:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803199:	8b 40 08             	mov    0x8(%rax),%eax
  80319c:	83 e0 03             	and    $0x3,%eax
  80319f:	83 f8 01             	cmp    $0x1,%eax
  8031a2:	75 3a                	jne    8031de <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8031a4:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8031ab:	00 00 00 
  8031ae:	48 8b 00             	mov    (%rax),%rax
  8031b1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8031b7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8031ba:	89 c6                	mov    %eax,%esi
  8031bc:	48 bf df 5a 80 00 00 	movabs $0x805adf,%rdi
  8031c3:	00 00 00 
  8031c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8031cb:	48 b9 81 0b 80 00 00 	movabs $0x800b81,%rcx
  8031d2:	00 00 00 
  8031d5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8031d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8031dc:	eb 2d                	jmp    80320b <read+0xd3>
	}
	if (!dev->dev_read)
  8031de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031e2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8031e6:	48 85 c0             	test   %rax,%rax
  8031e9:	75 07                	jne    8031f2 <read+0xba>
		return -E_NOT_SUPP;
  8031eb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8031f0:	eb 19                	jmp    80320b <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8031f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031f6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8031fa:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8031fe:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803202:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803206:	48 89 cf             	mov    %rcx,%rdi
  803209:	ff d0                	callq  *%rax
}
  80320b:	c9                   	leaveq 
  80320c:	c3                   	retq   

000000000080320d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80320d:	55                   	push   %rbp
  80320e:	48 89 e5             	mov    %rsp,%rbp
  803211:	48 83 ec 30          	sub    $0x30,%rsp
  803215:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803218:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80321c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803220:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803227:	eb 49                	jmp    803272 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803229:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80322c:	48 98                	cltq   
  80322e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803232:	48 29 c2             	sub    %rax,%rdx
  803235:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803238:	48 63 c8             	movslq %eax,%rcx
  80323b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80323f:	48 01 c1             	add    %rax,%rcx
  803242:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803245:	48 89 ce             	mov    %rcx,%rsi
  803248:	89 c7                	mov    %eax,%edi
  80324a:	48 b8 38 31 80 00 00 	movabs $0x803138,%rax
  803251:	00 00 00 
  803254:	ff d0                	callq  *%rax
  803256:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803259:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80325d:	79 05                	jns    803264 <readn+0x57>
			return m;
  80325f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803262:	eb 1c                	jmp    803280 <readn+0x73>
		if (m == 0)
  803264:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803268:	75 02                	jne    80326c <readn+0x5f>
			break;
  80326a:	eb 11                	jmp    80327d <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80326c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80326f:	01 45 fc             	add    %eax,-0x4(%rbp)
  803272:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803275:	48 98                	cltq   
  803277:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80327b:	72 ac                	jb     803229 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80327d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803280:	c9                   	leaveq 
  803281:	c3                   	retq   

0000000000803282 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803282:	55                   	push   %rbp
  803283:	48 89 e5             	mov    %rsp,%rbp
  803286:	48 83 ec 40          	sub    $0x40,%rsp
  80328a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80328d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803291:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803295:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803299:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80329c:	48 89 d6             	mov    %rdx,%rsi
  80329f:	89 c7                	mov    %eax,%edi
  8032a1:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  8032a8:	00 00 00 
  8032ab:	ff d0                	callq  *%rax
  8032ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032b4:	78 24                	js     8032da <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8032b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032ba:	8b 00                	mov    (%rax),%eax
  8032bc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8032c0:	48 89 d6             	mov    %rdx,%rsi
  8032c3:	89 c7                	mov    %eax,%edi
  8032c5:	48 b8 5f 2e 80 00 00 	movabs $0x802e5f,%rax
  8032cc:	00 00 00 
  8032cf:	ff d0                	callq  *%rax
  8032d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d8:	79 05                	jns    8032df <write+0x5d>
		return r;
  8032da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032dd:	eb 75                	jmp    803354 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8032df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032e3:	8b 40 08             	mov    0x8(%rax),%eax
  8032e6:	83 e0 03             	and    $0x3,%eax
  8032e9:	85 c0                	test   %eax,%eax
  8032eb:	75 3a                	jne    803327 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8032ed:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8032f4:	00 00 00 
  8032f7:	48 8b 00             	mov    (%rax),%rax
  8032fa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803300:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803303:	89 c6                	mov    %eax,%esi
  803305:	48 bf fb 5a 80 00 00 	movabs $0x805afb,%rdi
  80330c:	00 00 00 
  80330f:	b8 00 00 00 00       	mov    $0x0,%eax
  803314:	48 b9 81 0b 80 00 00 	movabs $0x800b81,%rcx
  80331b:	00 00 00 
  80331e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803320:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803325:	eb 2d                	jmp    803354 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  803327:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80332b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80332f:	48 85 c0             	test   %rax,%rax
  803332:	75 07                	jne    80333b <write+0xb9>
		return -E_NOT_SUPP;
  803334:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803339:	eb 19                	jmp    803354 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80333b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80333f:	48 8b 40 18          	mov    0x18(%rax),%rax
  803343:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803347:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80334b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80334f:	48 89 cf             	mov    %rcx,%rdi
  803352:	ff d0                	callq  *%rax
}
  803354:	c9                   	leaveq 
  803355:	c3                   	retq   

0000000000803356 <seek>:

int
seek(int fdnum, off_t offset)
{
  803356:	55                   	push   %rbp
  803357:	48 89 e5             	mov    %rsp,%rbp
  80335a:	48 83 ec 18          	sub    $0x18,%rsp
  80335e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803361:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803364:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803368:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80336b:	48 89 d6             	mov    %rdx,%rsi
  80336e:	89 c7                	mov    %eax,%edi
  803370:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  803377:	00 00 00 
  80337a:	ff d0                	callq  *%rax
  80337c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80337f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803383:	79 05                	jns    80338a <seek+0x34>
		return r;
  803385:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803388:	eb 0f                	jmp    803399 <seek+0x43>
	fd->fd_offset = offset;
  80338a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80338e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803391:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803394:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803399:	c9                   	leaveq 
  80339a:	c3                   	retq   

000000000080339b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80339b:	55                   	push   %rbp
  80339c:	48 89 e5             	mov    %rsp,%rbp
  80339f:	48 83 ec 30          	sub    $0x30,%rsp
  8033a3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8033a6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8033a9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8033ad:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8033b0:	48 89 d6             	mov    %rdx,%rsi
  8033b3:	89 c7                	mov    %eax,%edi
  8033b5:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  8033bc:	00 00 00 
  8033bf:	ff d0                	callq  *%rax
  8033c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033c8:	78 24                	js     8033ee <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8033ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033ce:	8b 00                	mov    (%rax),%eax
  8033d0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8033d4:	48 89 d6             	mov    %rdx,%rsi
  8033d7:	89 c7                	mov    %eax,%edi
  8033d9:	48 b8 5f 2e 80 00 00 	movabs $0x802e5f,%rax
  8033e0:	00 00 00 
  8033e3:	ff d0                	callq  *%rax
  8033e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ec:	79 05                	jns    8033f3 <ftruncate+0x58>
		return r;
  8033ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f1:	eb 72                	jmp    803465 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8033f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033f7:	8b 40 08             	mov    0x8(%rax),%eax
  8033fa:	83 e0 03             	and    $0x3,%eax
  8033fd:	85 c0                	test   %eax,%eax
  8033ff:	75 3a                	jne    80343b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803401:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803408:	00 00 00 
  80340b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80340e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803414:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803417:	89 c6                	mov    %eax,%esi
  803419:	48 bf 18 5b 80 00 00 	movabs $0x805b18,%rdi
  803420:	00 00 00 
  803423:	b8 00 00 00 00       	mov    $0x0,%eax
  803428:	48 b9 81 0b 80 00 00 	movabs $0x800b81,%rcx
  80342f:	00 00 00 
  803432:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803434:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803439:	eb 2a                	jmp    803465 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80343b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80343f:	48 8b 40 30          	mov    0x30(%rax),%rax
  803443:	48 85 c0             	test   %rax,%rax
  803446:	75 07                	jne    80344f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803448:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80344d:	eb 16                	jmp    803465 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80344f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803453:	48 8b 40 30          	mov    0x30(%rax),%rax
  803457:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80345b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80345e:	89 ce                	mov    %ecx,%esi
  803460:	48 89 d7             	mov    %rdx,%rdi
  803463:	ff d0                	callq  *%rax
}
  803465:	c9                   	leaveq 
  803466:	c3                   	retq   

0000000000803467 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803467:	55                   	push   %rbp
  803468:	48 89 e5             	mov    %rsp,%rbp
  80346b:	48 83 ec 30          	sub    $0x30,%rsp
  80346f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803472:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803476:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80347a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80347d:	48 89 d6             	mov    %rdx,%rsi
  803480:	89 c7                	mov    %eax,%edi
  803482:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  803489:	00 00 00 
  80348c:	ff d0                	callq  *%rax
  80348e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803491:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803495:	78 24                	js     8034bb <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803497:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80349b:	8b 00                	mov    (%rax),%eax
  80349d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8034a1:	48 89 d6             	mov    %rdx,%rsi
  8034a4:	89 c7                	mov    %eax,%edi
  8034a6:	48 b8 5f 2e 80 00 00 	movabs $0x802e5f,%rax
  8034ad:	00 00 00 
  8034b0:	ff d0                	callq  *%rax
  8034b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034b9:	79 05                	jns    8034c0 <fstat+0x59>
		return r;
  8034bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034be:	eb 5e                	jmp    80351e <fstat+0xb7>
	if (!dev->dev_stat)
  8034c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034c4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8034c8:	48 85 c0             	test   %rax,%rax
  8034cb:	75 07                	jne    8034d4 <fstat+0x6d>
		return -E_NOT_SUPP;
  8034cd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8034d2:	eb 4a                	jmp    80351e <fstat+0xb7>
	stat->st_name[0] = 0;
  8034d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034d8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8034db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034df:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8034e6:	00 00 00 
	stat->st_isdir = 0;
  8034e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034ed:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8034f4:	00 00 00 
	stat->st_dev = dev;
  8034f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034ff:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803506:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80350a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80350e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803512:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803516:	48 89 ce             	mov    %rcx,%rsi
  803519:	48 89 d7             	mov    %rdx,%rdi
  80351c:	ff d0                	callq  *%rax
}
  80351e:	c9                   	leaveq 
  80351f:	c3                   	retq   

0000000000803520 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803520:	55                   	push   %rbp
  803521:	48 89 e5             	mov    %rsp,%rbp
  803524:	48 83 ec 20          	sub    $0x20,%rsp
  803528:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80352c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803530:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803534:	be 00 00 00 00       	mov    $0x0,%esi
  803539:	48 89 c7             	mov    %rax,%rdi
  80353c:	48 b8 0e 36 80 00 00 	movabs $0x80360e,%rax
  803543:	00 00 00 
  803546:	ff d0                	callq  *%rax
  803548:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80354b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80354f:	79 05                	jns    803556 <stat+0x36>
		return fd;
  803551:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803554:	eb 2f                	jmp    803585 <stat+0x65>
	r = fstat(fd, stat);
  803556:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80355a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80355d:	48 89 d6             	mov    %rdx,%rsi
  803560:	89 c7                	mov    %eax,%edi
  803562:	48 b8 67 34 80 00 00 	movabs $0x803467,%rax
  803569:	00 00 00 
  80356c:	ff d0                	callq  *%rax
  80356e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803571:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803574:	89 c7                	mov    %eax,%edi
  803576:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  80357d:	00 00 00 
  803580:	ff d0                	callq  *%rax
	return r;
  803582:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803585:	c9                   	leaveq 
  803586:	c3                   	retq   

0000000000803587 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803587:	55                   	push   %rbp
  803588:	48 89 e5             	mov    %rsp,%rbp
  80358b:	48 83 ec 10          	sub    $0x10,%rsp
  80358f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803592:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803596:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80359d:	00 00 00 
  8035a0:	8b 00                	mov    (%rax),%eax
  8035a2:	85 c0                	test   %eax,%eax
  8035a4:	75 1d                	jne    8035c3 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8035a6:	bf 01 00 00 00       	mov    $0x1,%edi
  8035ab:	48 b8 9e 2b 80 00 00 	movabs $0x802b9e,%rax
  8035b2:	00 00 00 
  8035b5:	ff d0                	callq  *%rax
  8035b7:	48 ba 08 80 80 00 00 	movabs $0x808008,%rdx
  8035be:	00 00 00 
  8035c1:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8035c3:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8035ca:	00 00 00 
  8035cd:	8b 00                	mov    (%rax),%eax
  8035cf:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8035d2:	b9 07 00 00 00       	mov    $0x7,%ecx
  8035d7:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  8035de:	00 00 00 
  8035e1:	89 c7                	mov    %eax,%edi
  8035e3:	48 b8 3c 2b 80 00 00 	movabs $0x802b3c,%rax
  8035ea:	00 00 00 
  8035ed:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8035ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8035f8:	48 89 c6             	mov    %rax,%rsi
  8035fb:	bf 00 00 00 00       	mov    $0x0,%edi
  803600:	48 b8 36 2a 80 00 00 	movabs $0x802a36,%rax
  803607:	00 00 00 
  80360a:	ff d0                	callq  *%rax
}
  80360c:	c9                   	leaveq 
  80360d:	c3                   	retq   

000000000080360e <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80360e:	55                   	push   %rbp
  80360f:	48 89 e5             	mov    %rsp,%rbp
  803612:	48 83 ec 30          	sub    $0x30,%rsp
  803616:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80361a:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80361d:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  803624:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80362b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  803632:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803637:	75 08                	jne    803641 <open+0x33>
	{
		return r;
  803639:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80363c:	e9 f2 00 00 00       	jmpq   803733 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  803641:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803645:	48 89 c7             	mov    %rax,%rdi
  803648:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  80364f:	00 00 00 
  803652:	ff d0                	callq  *%rax
  803654:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803657:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  80365e:	7e 0a                	jle    80366a <open+0x5c>
	{
		return -E_BAD_PATH;
  803660:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803665:	e9 c9 00 00 00       	jmpq   803733 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80366a:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803671:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  803672:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803676:	48 89 c7             	mov    %rax,%rdi
  803679:	48 b8 6e 2c 80 00 00 	movabs $0x802c6e,%rax
  803680:	00 00 00 
  803683:	ff d0                	callq  *%rax
  803685:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803688:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80368c:	78 09                	js     803697 <open+0x89>
  80368e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803692:	48 85 c0             	test   %rax,%rax
  803695:	75 08                	jne    80369f <open+0x91>
		{
			return r;
  803697:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80369a:	e9 94 00 00 00       	jmpq   803733 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80369f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036a3:	ba 00 04 00 00       	mov    $0x400,%edx
  8036a8:	48 89 c6             	mov    %rax,%rsi
  8036ab:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8036b2:	00 00 00 
  8036b5:	48 b8 c8 17 80 00 00 	movabs $0x8017c8,%rax
  8036bc:	00 00 00 
  8036bf:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8036c1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8036c8:	00 00 00 
  8036cb:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8036ce:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8036d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036d8:	48 89 c6             	mov    %rax,%rsi
  8036db:	bf 01 00 00 00       	mov    $0x1,%edi
  8036e0:	48 b8 87 35 80 00 00 	movabs $0x803587,%rax
  8036e7:	00 00 00 
  8036ea:	ff d0                	callq  *%rax
  8036ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036f3:	79 2b                	jns    803720 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8036f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036f9:	be 00 00 00 00       	mov    $0x0,%esi
  8036fe:	48 89 c7             	mov    %rax,%rdi
  803701:	48 b8 96 2d 80 00 00 	movabs $0x802d96,%rax
  803708:	00 00 00 
  80370b:	ff d0                	callq  *%rax
  80370d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803710:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803714:	79 05                	jns    80371b <open+0x10d>
			{
				return d;
  803716:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803719:	eb 18                	jmp    803733 <open+0x125>
			}
			return r;
  80371b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80371e:	eb 13                	jmp    803733 <open+0x125>
		}	
		return fd2num(fd_store);
  803720:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803724:	48 89 c7             	mov    %rax,%rdi
  803727:	48 b8 20 2c 80 00 00 	movabs $0x802c20,%rax
  80372e:	00 00 00 
  803731:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  803733:	c9                   	leaveq 
  803734:	c3                   	retq   

0000000000803735 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803735:	55                   	push   %rbp
  803736:	48 89 e5             	mov    %rsp,%rbp
  803739:	48 83 ec 10          	sub    $0x10,%rsp
  80373d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803741:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803745:	8b 50 0c             	mov    0xc(%rax),%edx
  803748:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80374f:	00 00 00 
  803752:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803754:	be 00 00 00 00       	mov    $0x0,%esi
  803759:	bf 06 00 00 00       	mov    $0x6,%edi
  80375e:	48 b8 87 35 80 00 00 	movabs $0x803587,%rax
  803765:	00 00 00 
  803768:	ff d0                	callq  *%rax
}
  80376a:	c9                   	leaveq 
  80376b:	c3                   	retq   

000000000080376c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80376c:	55                   	push   %rbp
  80376d:	48 89 e5             	mov    %rsp,%rbp
  803770:	48 83 ec 30          	sub    $0x30,%rsp
  803774:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803778:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80377c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  803780:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  803787:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80378c:	74 07                	je     803795 <devfile_read+0x29>
  80378e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803793:	75 07                	jne    80379c <devfile_read+0x30>
		return -E_INVAL;
  803795:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80379a:	eb 77                	jmp    803813 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80379c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037a0:	8b 50 0c             	mov    0xc(%rax),%edx
  8037a3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8037aa:	00 00 00 
  8037ad:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8037af:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8037b6:	00 00 00 
  8037b9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8037bd:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8037c1:	be 00 00 00 00       	mov    $0x0,%esi
  8037c6:	bf 03 00 00 00       	mov    $0x3,%edi
  8037cb:	48 b8 87 35 80 00 00 	movabs $0x803587,%rax
  8037d2:	00 00 00 
  8037d5:	ff d0                	callq  *%rax
  8037d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037de:	7f 05                	jg     8037e5 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8037e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e3:	eb 2e                	jmp    803813 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8037e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e8:	48 63 d0             	movslq %eax,%rdx
  8037eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037ef:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8037f6:	00 00 00 
  8037f9:	48 89 c7             	mov    %rax,%rdi
  8037fc:	48 b8 5a 1a 80 00 00 	movabs $0x801a5a,%rax
  803803:	00 00 00 
  803806:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803808:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80380c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803810:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803813:	c9                   	leaveq 
  803814:	c3                   	retq   

0000000000803815 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803815:	55                   	push   %rbp
  803816:	48 89 e5             	mov    %rsp,%rbp
  803819:	48 83 ec 30          	sub    $0x30,%rsp
  80381d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803821:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803825:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  803829:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  803830:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803835:	74 07                	je     80383e <devfile_write+0x29>
  803837:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80383c:	75 08                	jne    803846 <devfile_write+0x31>
		return r;
  80383e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803841:	e9 9a 00 00 00       	jmpq   8038e0 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803846:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80384a:	8b 50 0c             	mov    0xc(%rax),%edx
  80384d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803854:	00 00 00 
  803857:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  803859:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803860:	00 
  803861:	76 08                	jbe    80386b <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  803863:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80386a:	00 
	}
	fsipcbuf.write.req_n = n;
  80386b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803872:	00 00 00 
  803875:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803879:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80387d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803881:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803885:	48 89 c6             	mov    %rax,%rsi
  803888:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  80388f:	00 00 00 
  803892:	48 b8 5a 1a 80 00 00 	movabs $0x801a5a,%rax
  803899:	00 00 00 
  80389c:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80389e:	be 00 00 00 00       	mov    $0x0,%esi
  8038a3:	bf 04 00 00 00       	mov    $0x4,%edi
  8038a8:	48 b8 87 35 80 00 00 	movabs $0x803587,%rax
  8038af:	00 00 00 
  8038b2:	ff d0                	callq  *%rax
  8038b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038bb:	7f 20                	jg     8038dd <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8038bd:	48 bf 3e 5b 80 00 00 	movabs $0x805b3e,%rdi
  8038c4:	00 00 00 
  8038c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8038cc:	48 ba 81 0b 80 00 00 	movabs $0x800b81,%rdx
  8038d3:	00 00 00 
  8038d6:	ff d2                	callq  *%rdx
		return r;
  8038d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038db:	eb 03                	jmp    8038e0 <devfile_write+0xcb>
	}
	return r;
  8038dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8038e0:	c9                   	leaveq 
  8038e1:	c3                   	retq   

00000000008038e2 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8038e2:	55                   	push   %rbp
  8038e3:	48 89 e5             	mov    %rsp,%rbp
  8038e6:	48 83 ec 20          	sub    $0x20,%rsp
  8038ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8038f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038f6:	8b 50 0c             	mov    0xc(%rax),%edx
  8038f9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803900:	00 00 00 
  803903:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803905:	be 00 00 00 00       	mov    $0x0,%esi
  80390a:	bf 05 00 00 00       	mov    $0x5,%edi
  80390f:	48 b8 87 35 80 00 00 	movabs $0x803587,%rax
  803916:	00 00 00 
  803919:	ff d0                	callq  *%rax
  80391b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80391e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803922:	79 05                	jns    803929 <devfile_stat+0x47>
		return r;
  803924:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803927:	eb 56                	jmp    80397f <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803929:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80392d:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803934:	00 00 00 
  803937:	48 89 c7             	mov    %rax,%rdi
  80393a:	48 b8 36 17 80 00 00 	movabs $0x801736,%rax
  803941:	00 00 00 
  803944:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803946:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80394d:	00 00 00 
  803950:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803956:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80395a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803960:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803967:	00 00 00 
  80396a:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803970:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803974:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80397a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80397f:	c9                   	leaveq 
  803980:	c3                   	retq   

0000000000803981 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803981:	55                   	push   %rbp
  803982:	48 89 e5             	mov    %rsp,%rbp
  803985:	48 83 ec 10          	sub    $0x10,%rsp
  803989:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80398d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803990:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803994:	8b 50 0c             	mov    0xc(%rax),%edx
  803997:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80399e:	00 00 00 
  8039a1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8039a3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8039aa:	00 00 00 
  8039ad:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8039b0:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8039b3:	be 00 00 00 00       	mov    $0x0,%esi
  8039b8:	bf 02 00 00 00       	mov    $0x2,%edi
  8039bd:	48 b8 87 35 80 00 00 	movabs $0x803587,%rax
  8039c4:	00 00 00 
  8039c7:	ff d0                	callq  *%rax
}
  8039c9:	c9                   	leaveq 
  8039ca:	c3                   	retq   

00000000008039cb <remove>:

// Delete a file
int
remove(const char *path)
{
  8039cb:	55                   	push   %rbp
  8039cc:	48 89 e5             	mov    %rsp,%rbp
  8039cf:	48 83 ec 10          	sub    $0x10,%rsp
  8039d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8039d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039db:	48 89 c7             	mov    %rax,%rdi
  8039de:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  8039e5:	00 00 00 
  8039e8:	ff d0                	callq  *%rax
  8039ea:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8039ef:	7e 07                	jle    8039f8 <remove+0x2d>
		return -E_BAD_PATH;
  8039f1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8039f6:	eb 33                	jmp    803a2b <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8039f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039fc:	48 89 c6             	mov    %rax,%rsi
  8039ff:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803a06:	00 00 00 
  803a09:	48 b8 36 17 80 00 00 	movabs $0x801736,%rax
  803a10:	00 00 00 
  803a13:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803a15:	be 00 00 00 00       	mov    $0x0,%esi
  803a1a:	bf 07 00 00 00       	mov    $0x7,%edi
  803a1f:	48 b8 87 35 80 00 00 	movabs $0x803587,%rax
  803a26:	00 00 00 
  803a29:	ff d0                	callq  *%rax
}
  803a2b:	c9                   	leaveq 
  803a2c:	c3                   	retq   

0000000000803a2d <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803a2d:	55                   	push   %rbp
  803a2e:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803a31:	be 00 00 00 00       	mov    $0x0,%esi
  803a36:	bf 08 00 00 00       	mov    $0x8,%edi
  803a3b:	48 b8 87 35 80 00 00 	movabs $0x803587,%rax
  803a42:	00 00 00 
  803a45:	ff d0                	callq  *%rax
}
  803a47:	5d                   	pop    %rbp
  803a48:	c3                   	retq   

0000000000803a49 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803a49:	55                   	push   %rbp
  803a4a:	48 89 e5             	mov    %rsp,%rbp
  803a4d:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803a54:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803a5b:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803a62:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803a69:	be 00 00 00 00       	mov    $0x0,%esi
  803a6e:	48 89 c7             	mov    %rax,%rdi
  803a71:	48 b8 0e 36 80 00 00 	movabs $0x80360e,%rax
  803a78:	00 00 00 
  803a7b:	ff d0                	callq  *%rax
  803a7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803a80:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a84:	79 28                	jns    803aae <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803a86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a89:	89 c6                	mov    %eax,%esi
  803a8b:	48 bf 5a 5b 80 00 00 	movabs $0x805b5a,%rdi
  803a92:	00 00 00 
  803a95:	b8 00 00 00 00       	mov    $0x0,%eax
  803a9a:	48 ba 81 0b 80 00 00 	movabs $0x800b81,%rdx
  803aa1:	00 00 00 
  803aa4:	ff d2                	callq  *%rdx
		return fd_src;
  803aa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aa9:	e9 74 01 00 00       	jmpq   803c22 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803aae:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803ab5:	be 01 01 00 00       	mov    $0x101,%esi
  803aba:	48 89 c7             	mov    %rax,%rdi
  803abd:	48 b8 0e 36 80 00 00 	movabs $0x80360e,%rax
  803ac4:	00 00 00 
  803ac7:	ff d0                	callq  *%rax
  803ac9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803acc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803ad0:	79 39                	jns    803b0b <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803ad2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ad5:	89 c6                	mov    %eax,%esi
  803ad7:	48 bf 70 5b 80 00 00 	movabs $0x805b70,%rdi
  803ade:	00 00 00 
  803ae1:	b8 00 00 00 00       	mov    $0x0,%eax
  803ae6:	48 ba 81 0b 80 00 00 	movabs $0x800b81,%rdx
  803aed:	00 00 00 
  803af0:	ff d2                	callq  *%rdx
		close(fd_src);
  803af2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803af5:	89 c7                	mov    %eax,%edi
  803af7:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  803afe:	00 00 00 
  803b01:	ff d0                	callq  *%rax
		return fd_dest;
  803b03:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b06:	e9 17 01 00 00       	jmpq   803c22 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803b0b:	eb 74                	jmp    803b81 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803b0d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803b10:	48 63 d0             	movslq %eax,%rdx
  803b13:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803b1a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b1d:	48 89 ce             	mov    %rcx,%rsi
  803b20:	89 c7                	mov    %eax,%edi
  803b22:	48 b8 82 32 80 00 00 	movabs $0x803282,%rax
  803b29:	00 00 00 
  803b2c:	ff d0                	callq  *%rax
  803b2e:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803b31:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803b35:	79 4a                	jns    803b81 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803b37:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803b3a:	89 c6                	mov    %eax,%esi
  803b3c:	48 bf 8a 5b 80 00 00 	movabs $0x805b8a,%rdi
  803b43:	00 00 00 
  803b46:	b8 00 00 00 00       	mov    $0x0,%eax
  803b4b:	48 ba 81 0b 80 00 00 	movabs $0x800b81,%rdx
  803b52:	00 00 00 
  803b55:	ff d2                	callq  *%rdx
			close(fd_src);
  803b57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b5a:	89 c7                	mov    %eax,%edi
  803b5c:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  803b63:	00 00 00 
  803b66:	ff d0                	callq  *%rax
			close(fd_dest);
  803b68:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b6b:	89 c7                	mov    %eax,%edi
  803b6d:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  803b74:	00 00 00 
  803b77:	ff d0                	callq  *%rax
			return write_size;
  803b79:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803b7c:	e9 a1 00 00 00       	jmpq   803c22 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803b81:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803b88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b8b:	ba 00 02 00 00       	mov    $0x200,%edx
  803b90:	48 89 ce             	mov    %rcx,%rsi
  803b93:	89 c7                	mov    %eax,%edi
  803b95:	48 b8 38 31 80 00 00 	movabs $0x803138,%rax
  803b9c:	00 00 00 
  803b9f:	ff d0                	callq  *%rax
  803ba1:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803ba4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803ba8:	0f 8f 5f ff ff ff    	jg     803b0d <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803bae:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803bb2:	79 47                	jns    803bfb <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803bb4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803bb7:	89 c6                	mov    %eax,%esi
  803bb9:	48 bf 9d 5b 80 00 00 	movabs $0x805b9d,%rdi
  803bc0:	00 00 00 
  803bc3:	b8 00 00 00 00       	mov    $0x0,%eax
  803bc8:	48 ba 81 0b 80 00 00 	movabs $0x800b81,%rdx
  803bcf:	00 00 00 
  803bd2:	ff d2                	callq  *%rdx
		close(fd_src);
  803bd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bd7:	89 c7                	mov    %eax,%edi
  803bd9:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  803be0:	00 00 00 
  803be3:	ff d0                	callq  *%rax
		close(fd_dest);
  803be5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803be8:	89 c7                	mov    %eax,%edi
  803bea:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  803bf1:	00 00 00 
  803bf4:	ff d0                	callq  *%rax
		return read_size;
  803bf6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803bf9:	eb 27                	jmp    803c22 <copy+0x1d9>
	}
	close(fd_src);
  803bfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bfe:	89 c7                	mov    %eax,%edi
  803c00:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  803c07:	00 00 00 
  803c0a:	ff d0                	callq  *%rax
	close(fd_dest);
  803c0c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c0f:	89 c7                	mov    %eax,%edi
  803c11:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  803c18:	00 00 00 
  803c1b:	ff d0                	callq  *%rax
	return 0;
  803c1d:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803c22:	c9                   	leaveq 
  803c23:	c3                   	retq   

0000000000803c24 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803c24:	55                   	push   %rbp
  803c25:	48 89 e5             	mov    %rsp,%rbp
  803c28:	48 83 ec 20          	sub    $0x20,%rsp
  803c2c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803c2f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c33:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c36:	48 89 d6             	mov    %rdx,%rsi
  803c39:	89 c7                	mov    %eax,%edi
  803c3b:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  803c42:	00 00 00 
  803c45:	ff d0                	callq  *%rax
  803c47:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c4e:	79 05                	jns    803c55 <fd2sockid+0x31>
		return r;
  803c50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c53:	eb 24                	jmp    803c79 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803c55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c59:	8b 10                	mov    (%rax),%edx
  803c5b:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803c62:	00 00 00 
  803c65:	8b 00                	mov    (%rax),%eax
  803c67:	39 c2                	cmp    %eax,%edx
  803c69:	74 07                	je     803c72 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803c6b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803c70:	eb 07                	jmp    803c79 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803c72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c76:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803c79:	c9                   	leaveq 
  803c7a:	c3                   	retq   

0000000000803c7b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803c7b:	55                   	push   %rbp
  803c7c:	48 89 e5             	mov    %rsp,%rbp
  803c7f:	48 83 ec 20          	sub    $0x20,%rsp
  803c83:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803c86:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803c8a:	48 89 c7             	mov    %rax,%rdi
  803c8d:	48 b8 6e 2c 80 00 00 	movabs $0x802c6e,%rax
  803c94:	00 00 00 
  803c97:	ff d0                	callq  *%rax
  803c99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ca0:	78 26                	js     803cc8 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803ca2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ca6:	ba 07 04 00 00       	mov    $0x407,%edx
  803cab:	48 89 c6             	mov    %rax,%rsi
  803cae:	bf 00 00 00 00       	mov    $0x0,%edi
  803cb3:	48 b8 65 20 80 00 00 	movabs $0x802065,%rax
  803cba:	00 00 00 
  803cbd:	ff d0                	callq  *%rax
  803cbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cc6:	79 16                	jns    803cde <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803cc8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ccb:	89 c7                	mov    %eax,%edi
  803ccd:	48 b8 88 41 80 00 00 	movabs $0x804188,%rax
  803cd4:	00 00 00 
  803cd7:	ff d0                	callq  *%rax
		return r;
  803cd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cdc:	eb 3a                	jmp    803d18 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803cde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce2:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803ce9:	00 00 00 
  803cec:	8b 12                	mov    (%rdx),%edx
  803cee:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803cf0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803cfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cff:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803d02:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803d05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d09:	48 89 c7             	mov    %rax,%rdi
  803d0c:	48 b8 20 2c 80 00 00 	movabs $0x802c20,%rax
  803d13:	00 00 00 
  803d16:	ff d0                	callq  *%rax
}
  803d18:	c9                   	leaveq 
  803d19:	c3                   	retq   

0000000000803d1a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803d1a:	55                   	push   %rbp
  803d1b:	48 89 e5             	mov    %rsp,%rbp
  803d1e:	48 83 ec 30          	sub    $0x30,%rsp
  803d22:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d25:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d29:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d2d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d30:	89 c7                	mov    %eax,%edi
  803d32:	48 b8 24 3c 80 00 00 	movabs $0x803c24,%rax
  803d39:	00 00 00 
  803d3c:	ff d0                	callq  *%rax
  803d3e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d41:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d45:	79 05                	jns    803d4c <accept+0x32>
		return r;
  803d47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d4a:	eb 3b                	jmp    803d87 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803d4c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803d50:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803d54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d57:	48 89 ce             	mov    %rcx,%rsi
  803d5a:	89 c7                	mov    %eax,%edi
  803d5c:	48 b8 65 40 80 00 00 	movabs $0x804065,%rax
  803d63:	00 00 00 
  803d66:	ff d0                	callq  *%rax
  803d68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d6f:	79 05                	jns    803d76 <accept+0x5c>
		return r;
  803d71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d74:	eb 11                	jmp    803d87 <accept+0x6d>
	return alloc_sockfd(r);
  803d76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d79:	89 c7                	mov    %eax,%edi
  803d7b:	48 b8 7b 3c 80 00 00 	movabs $0x803c7b,%rax
  803d82:	00 00 00 
  803d85:	ff d0                	callq  *%rax
}
  803d87:	c9                   	leaveq 
  803d88:	c3                   	retq   

0000000000803d89 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803d89:	55                   	push   %rbp
  803d8a:	48 89 e5             	mov    %rsp,%rbp
  803d8d:	48 83 ec 20          	sub    $0x20,%rsp
  803d91:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d94:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d98:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d9b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d9e:	89 c7                	mov    %eax,%edi
  803da0:	48 b8 24 3c 80 00 00 	movabs $0x803c24,%rax
  803da7:	00 00 00 
  803daa:	ff d0                	callq  *%rax
  803dac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803daf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803db3:	79 05                	jns    803dba <bind+0x31>
		return r;
  803db5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803db8:	eb 1b                	jmp    803dd5 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803dba:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803dbd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803dc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dc4:	48 89 ce             	mov    %rcx,%rsi
  803dc7:	89 c7                	mov    %eax,%edi
  803dc9:	48 b8 e4 40 80 00 00 	movabs $0x8040e4,%rax
  803dd0:	00 00 00 
  803dd3:	ff d0                	callq  *%rax
}
  803dd5:	c9                   	leaveq 
  803dd6:	c3                   	retq   

0000000000803dd7 <shutdown>:

int
shutdown(int s, int how)
{
  803dd7:	55                   	push   %rbp
  803dd8:	48 89 e5             	mov    %rsp,%rbp
  803ddb:	48 83 ec 20          	sub    $0x20,%rsp
  803ddf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803de2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803de5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803de8:	89 c7                	mov    %eax,%edi
  803dea:	48 b8 24 3c 80 00 00 	movabs $0x803c24,%rax
  803df1:	00 00 00 
  803df4:	ff d0                	callq  *%rax
  803df6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803df9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dfd:	79 05                	jns    803e04 <shutdown+0x2d>
		return r;
  803dff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e02:	eb 16                	jmp    803e1a <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803e04:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803e07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e0a:	89 d6                	mov    %edx,%esi
  803e0c:	89 c7                	mov    %eax,%edi
  803e0e:	48 b8 48 41 80 00 00 	movabs $0x804148,%rax
  803e15:	00 00 00 
  803e18:	ff d0                	callq  *%rax
}
  803e1a:	c9                   	leaveq 
  803e1b:	c3                   	retq   

0000000000803e1c <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803e1c:	55                   	push   %rbp
  803e1d:	48 89 e5             	mov    %rsp,%rbp
  803e20:	48 83 ec 10          	sub    $0x10,%rsp
  803e24:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803e28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e2c:	48 89 c7             	mov    %rax,%rdi
  803e2f:	48 b8 ec 4d 80 00 00 	movabs $0x804dec,%rax
  803e36:	00 00 00 
  803e39:	ff d0                	callq  *%rax
  803e3b:	83 f8 01             	cmp    $0x1,%eax
  803e3e:	75 17                	jne    803e57 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803e40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e44:	8b 40 0c             	mov    0xc(%rax),%eax
  803e47:	89 c7                	mov    %eax,%edi
  803e49:	48 b8 88 41 80 00 00 	movabs $0x804188,%rax
  803e50:	00 00 00 
  803e53:	ff d0                	callq  *%rax
  803e55:	eb 05                	jmp    803e5c <devsock_close+0x40>
	else
		return 0;
  803e57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e5c:	c9                   	leaveq 
  803e5d:	c3                   	retq   

0000000000803e5e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803e5e:	55                   	push   %rbp
  803e5f:	48 89 e5             	mov    %rsp,%rbp
  803e62:	48 83 ec 20          	sub    $0x20,%rsp
  803e66:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e69:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e6d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803e70:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e73:	89 c7                	mov    %eax,%edi
  803e75:	48 b8 24 3c 80 00 00 	movabs $0x803c24,%rax
  803e7c:	00 00 00 
  803e7f:	ff d0                	callq  *%rax
  803e81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e88:	79 05                	jns    803e8f <connect+0x31>
		return r;
  803e8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e8d:	eb 1b                	jmp    803eaa <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803e8f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803e92:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803e96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e99:	48 89 ce             	mov    %rcx,%rsi
  803e9c:	89 c7                	mov    %eax,%edi
  803e9e:	48 b8 b5 41 80 00 00 	movabs $0x8041b5,%rax
  803ea5:	00 00 00 
  803ea8:	ff d0                	callq  *%rax
}
  803eaa:	c9                   	leaveq 
  803eab:	c3                   	retq   

0000000000803eac <listen>:

int
listen(int s, int backlog)
{
  803eac:	55                   	push   %rbp
  803ead:	48 89 e5             	mov    %rsp,%rbp
  803eb0:	48 83 ec 20          	sub    $0x20,%rsp
  803eb4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803eb7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803eba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ebd:	89 c7                	mov    %eax,%edi
  803ebf:	48 b8 24 3c 80 00 00 	movabs $0x803c24,%rax
  803ec6:	00 00 00 
  803ec9:	ff d0                	callq  *%rax
  803ecb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ece:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ed2:	79 05                	jns    803ed9 <listen+0x2d>
		return r;
  803ed4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ed7:	eb 16                	jmp    803eef <listen+0x43>
	return nsipc_listen(r, backlog);
  803ed9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803edc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803edf:	89 d6                	mov    %edx,%esi
  803ee1:	89 c7                	mov    %eax,%edi
  803ee3:	48 b8 19 42 80 00 00 	movabs $0x804219,%rax
  803eea:	00 00 00 
  803eed:	ff d0                	callq  *%rax
}
  803eef:	c9                   	leaveq 
  803ef0:	c3                   	retq   

0000000000803ef1 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803ef1:	55                   	push   %rbp
  803ef2:	48 89 e5             	mov    %rsp,%rbp
  803ef5:	48 83 ec 20          	sub    $0x20,%rsp
  803ef9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803efd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803f01:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803f05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f09:	89 c2                	mov    %eax,%edx
  803f0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f0f:	8b 40 0c             	mov    0xc(%rax),%eax
  803f12:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803f16:	b9 00 00 00 00       	mov    $0x0,%ecx
  803f1b:	89 c7                	mov    %eax,%edi
  803f1d:	48 b8 59 42 80 00 00 	movabs $0x804259,%rax
  803f24:	00 00 00 
  803f27:	ff d0                	callq  *%rax
}
  803f29:	c9                   	leaveq 
  803f2a:	c3                   	retq   

0000000000803f2b <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803f2b:	55                   	push   %rbp
  803f2c:	48 89 e5             	mov    %rsp,%rbp
  803f2f:	48 83 ec 20          	sub    $0x20,%rsp
  803f33:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803f37:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803f3b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803f3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f43:	89 c2                	mov    %eax,%edx
  803f45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f49:	8b 40 0c             	mov    0xc(%rax),%eax
  803f4c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803f50:	b9 00 00 00 00       	mov    $0x0,%ecx
  803f55:	89 c7                	mov    %eax,%edi
  803f57:	48 b8 25 43 80 00 00 	movabs $0x804325,%rax
  803f5e:	00 00 00 
  803f61:	ff d0                	callq  *%rax
}
  803f63:	c9                   	leaveq 
  803f64:	c3                   	retq   

0000000000803f65 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803f65:	55                   	push   %rbp
  803f66:	48 89 e5             	mov    %rsp,%rbp
  803f69:	48 83 ec 10          	sub    $0x10,%rsp
  803f6d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803f71:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803f75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f79:	48 be b8 5b 80 00 00 	movabs $0x805bb8,%rsi
  803f80:	00 00 00 
  803f83:	48 89 c7             	mov    %rax,%rdi
  803f86:	48 b8 36 17 80 00 00 	movabs $0x801736,%rax
  803f8d:	00 00 00 
  803f90:	ff d0                	callq  *%rax
	return 0;
  803f92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f97:	c9                   	leaveq 
  803f98:	c3                   	retq   

0000000000803f99 <socket>:

int
socket(int domain, int type, int protocol)
{
  803f99:	55                   	push   %rbp
  803f9a:	48 89 e5             	mov    %rsp,%rbp
  803f9d:	48 83 ec 20          	sub    $0x20,%rsp
  803fa1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803fa4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803fa7:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803faa:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803fad:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803fb0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fb3:	89 ce                	mov    %ecx,%esi
  803fb5:	89 c7                	mov    %eax,%edi
  803fb7:	48 b8 dd 43 80 00 00 	movabs $0x8043dd,%rax
  803fbe:	00 00 00 
  803fc1:	ff d0                	callq  *%rax
  803fc3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fc6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fca:	79 05                	jns    803fd1 <socket+0x38>
		return r;
  803fcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fcf:	eb 11                	jmp    803fe2 <socket+0x49>
	return alloc_sockfd(r);
  803fd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fd4:	89 c7                	mov    %eax,%edi
  803fd6:	48 b8 7b 3c 80 00 00 	movabs $0x803c7b,%rax
  803fdd:	00 00 00 
  803fe0:	ff d0                	callq  *%rax
}
  803fe2:	c9                   	leaveq 
  803fe3:	c3                   	retq   

0000000000803fe4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803fe4:	55                   	push   %rbp
  803fe5:	48 89 e5             	mov    %rsp,%rbp
  803fe8:	48 83 ec 10          	sub    $0x10,%rsp
  803fec:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803fef:	48 b8 0c 80 80 00 00 	movabs $0x80800c,%rax
  803ff6:	00 00 00 
  803ff9:	8b 00                	mov    (%rax),%eax
  803ffb:	85 c0                	test   %eax,%eax
  803ffd:	75 1d                	jne    80401c <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803fff:	bf 02 00 00 00       	mov    $0x2,%edi
  804004:	48 b8 9e 2b 80 00 00 	movabs $0x802b9e,%rax
  80400b:	00 00 00 
  80400e:	ff d0                	callq  *%rax
  804010:	48 ba 0c 80 80 00 00 	movabs $0x80800c,%rdx
  804017:	00 00 00 
  80401a:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80401c:	48 b8 0c 80 80 00 00 	movabs $0x80800c,%rax
  804023:	00 00 00 
  804026:	8b 00                	mov    (%rax),%eax
  804028:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80402b:	b9 07 00 00 00       	mov    $0x7,%ecx
  804030:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  804037:	00 00 00 
  80403a:	89 c7                	mov    %eax,%edi
  80403c:	48 b8 3c 2b 80 00 00 	movabs $0x802b3c,%rax
  804043:	00 00 00 
  804046:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  804048:	ba 00 00 00 00       	mov    $0x0,%edx
  80404d:	be 00 00 00 00       	mov    $0x0,%esi
  804052:	bf 00 00 00 00       	mov    $0x0,%edi
  804057:	48 b8 36 2a 80 00 00 	movabs $0x802a36,%rax
  80405e:	00 00 00 
  804061:	ff d0                	callq  *%rax
}
  804063:	c9                   	leaveq 
  804064:	c3                   	retq   

0000000000804065 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804065:	55                   	push   %rbp
  804066:	48 89 e5             	mov    %rsp,%rbp
  804069:	48 83 ec 30          	sub    $0x30,%rsp
  80406d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804070:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804074:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  804078:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80407f:	00 00 00 
  804082:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804085:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  804087:	bf 01 00 00 00       	mov    $0x1,%edi
  80408c:	48 b8 e4 3f 80 00 00 	movabs $0x803fe4,%rax
  804093:	00 00 00 
  804096:	ff d0                	callq  *%rax
  804098:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80409b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80409f:	78 3e                	js     8040df <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8040a1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040a8:	00 00 00 
  8040ab:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8040af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040b3:	8b 40 10             	mov    0x10(%rax),%eax
  8040b6:	89 c2                	mov    %eax,%edx
  8040b8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8040bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040c0:	48 89 ce             	mov    %rcx,%rsi
  8040c3:	48 89 c7             	mov    %rax,%rdi
  8040c6:	48 b8 5a 1a 80 00 00 	movabs $0x801a5a,%rax
  8040cd:	00 00 00 
  8040d0:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8040d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040d6:	8b 50 10             	mov    0x10(%rax),%edx
  8040d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040dd:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8040df:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8040e2:	c9                   	leaveq 
  8040e3:	c3                   	retq   

00000000008040e4 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8040e4:	55                   	push   %rbp
  8040e5:	48 89 e5             	mov    %rsp,%rbp
  8040e8:	48 83 ec 10          	sub    $0x10,%rsp
  8040ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8040ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8040f3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8040f6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040fd:	00 00 00 
  804100:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804103:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  804105:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804108:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80410c:	48 89 c6             	mov    %rax,%rsi
  80410f:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  804116:	00 00 00 
  804119:	48 b8 5a 1a 80 00 00 	movabs $0x801a5a,%rax
  804120:	00 00 00 
  804123:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  804125:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80412c:	00 00 00 
  80412f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804132:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  804135:	bf 02 00 00 00       	mov    $0x2,%edi
  80413a:	48 b8 e4 3f 80 00 00 	movabs $0x803fe4,%rax
  804141:	00 00 00 
  804144:	ff d0                	callq  *%rax
}
  804146:	c9                   	leaveq 
  804147:	c3                   	retq   

0000000000804148 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  804148:	55                   	push   %rbp
  804149:	48 89 e5             	mov    %rsp,%rbp
  80414c:	48 83 ec 10          	sub    $0x10,%rsp
  804150:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804153:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  804156:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80415d:	00 00 00 
  804160:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804163:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  804165:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80416c:	00 00 00 
  80416f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804172:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  804175:	bf 03 00 00 00       	mov    $0x3,%edi
  80417a:	48 b8 e4 3f 80 00 00 	movabs $0x803fe4,%rax
  804181:	00 00 00 
  804184:	ff d0                	callq  *%rax
}
  804186:	c9                   	leaveq 
  804187:	c3                   	retq   

0000000000804188 <nsipc_close>:

int
nsipc_close(int s)
{
  804188:	55                   	push   %rbp
  804189:	48 89 e5             	mov    %rsp,%rbp
  80418c:	48 83 ec 10          	sub    $0x10,%rsp
  804190:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  804193:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80419a:	00 00 00 
  80419d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8041a0:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8041a2:	bf 04 00 00 00       	mov    $0x4,%edi
  8041a7:	48 b8 e4 3f 80 00 00 	movabs $0x803fe4,%rax
  8041ae:	00 00 00 
  8041b1:	ff d0                	callq  *%rax
}
  8041b3:	c9                   	leaveq 
  8041b4:	c3                   	retq   

00000000008041b5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8041b5:	55                   	push   %rbp
  8041b6:	48 89 e5             	mov    %rsp,%rbp
  8041b9:	48 83 ec 10          	sub    $0x10,%rsp
  8041bd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8041c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8041c4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8041c7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041ce:	00 00 00 
  8041d1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8041d4:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8041d6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8041d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041dd:	48 89 c6             	mov    %rax,%rsi
  8041e0:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8041e7:	00 00 00 
  8041ea:	48 b8 5a 1a 80 00 00 	movabs $0x801a5a,%rax
  8041f1:	00 00 00 
  8041f4:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8041f6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041fd:	00 00 00 
  804200:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804203:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  804206:	bf 05 00 00 00       	mov    $0x5,%edi
  80420b:	48 b8 e4 3f 80 00 00 	movabs $0x803fe4,%rax
  804212:	00 00 00 
  804215:	ff d0                	callq  *%rax
}
  804217:	c9                   	leaveq 
  804218:	c3                   	retq   

0000000000804219 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  804219:	55                   	push   %rbp
  80421a:	48 89 e5             	mov    %rsp,%rbp
  80421d:	48 83 ec 10          	sub    $0x10,%rsp
  804221:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804224:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  804227:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80422e:	00 00 00 
  804231:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804234:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  804236:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80423d:	00 00 00 
  804240:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804243:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  804246:	bf 06 00 00 00       	mov    $0x6,%edi
  80424b:	48 b8 e4 3f 80 00 00 	movabs $0x803fe4,%rax
  804252:	00 00 00 
  804255:	ff d0                	callq  *%rax
}
  804257:	c9                   	leaveq 
  804258:	c3                   	retq   

0000000000804259 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  804259:	55                   	push   %rbp
  80425a:	48 89 e5             	mov    %rsp,%rbp
  80425d:	48 83 ec 30          	sub    $0x30,%rsp
  804261:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804264:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804268:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80426b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80426e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804275:	00 00 00 
  804278:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80427b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80427d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804284:	00 00 00 
  804287:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80428a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80428d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804294:	00 00 00 
  804297:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80429a:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80429d:	bf 07 00 00 00       	mov    $0x7,%edi
  8042a2:	48 b8 e4 3f 80 00 00 	movabs $0x803fe4,%rax
  8042a9:	00 00 00 
  8042ac:	ff d0                	callq  *%rax
  8042ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042b5:	78 69                	js     804320 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8042b7:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8042be:	7f 08                	jg     8042c8 <nsipc_recv+0x6f>
  8042c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042c3:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8042c6:	7e 35                	jle    8042fd <nsipc_recv+0xa4>
  8042c8:	48 b9 bf 5b 80 00 00 	movabs $0x805bbf,%rcx
  8042cf:	00 00 00 
  8042d2:	48 ba d4 5b 80 00 00 	movabs $0x805bd4,%rdx
  8042d9:	00 00 00 
  8042dc:	be 61 00 00 00       	mov    $0x61,%esi
  8042e1:	48 bf e9 5b 80 00 00 	movabs $0x805be9,%rdi
  8042e8:	00 00 00 
  8042eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8042f0:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  8042f7:	00 00 00 
  8042fa:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8042fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804300:	48 63 d0             	movslq %eax,%rdx
  804303:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804307:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  80430e:	00 00 00 
  804311:	48 89 c7             	mov    %rax,%rdi
  804314:	48 b8 5a 1a 80 00 00 	movabs $0x801a5a,%rax
  80431b:	00 00 00 
  80431e:	ff d0                	callq  *%rax
	}

	return r;
  804320:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804323:	c9                   	leaveq 
  804324:	c3                   	retq   

0000000000804325 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804325:	55                   	push   %rbp
  804326:	48 89 e5             	mov    %rsp,%rbp
  804329:	48 83 ec 20          	sub    $0x20,%rsp
  80432d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804330:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804334:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804337:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80433a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804341:	00 00 00 
  804344:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804347:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  804349:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  804350:	7e 35                	jle    804387 <nsipc_send+0x62>
  804352:	48 b9 f5 5b 80 00 00 	movabs $0x805bf5,%rcx
  804359:	00 00 00 
  80435c:	48 ba d4 5b 80 00 00 	movabs $0x805bd4,%rdx
  804363:	00 00 00 
  804366:	be 6c 00 00 00       	mov    $0x6c,%esi
  80436b:	48 bf e9 5b 80 00 00 	movabs $0x805be9,%rdi
  804372:	00 00 00 
  804375:	b8 00 00 00 00       	mov    $0x0,%eax
  80437a:	49 b8 48 09 80 00 00 	movabs $0x800948,%r8
  804381:	00 00 00 
  804384:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804387:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80438a:	48 63 d0             	movslq %eax,%rdx
  80438d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804391:	48 89 c6             	mov    %rax,%rsi
  804394:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  80439b:	00 00 00 
  80439e:	48 b8 5a 1a 80 00 00 	movabs $0x801a5a,%rax
  8043a5:	00 00 00 
  8043a8:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8043aa:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043b1:	00 00 00 
  8043b4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8043b7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8043ba:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043c1:	00 00 00 
  8043c4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8043c7:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8043ca:	bf 08 00 00 00       	mov    $0x8,%edi
  8043cf:	48 b8 e4 3f 80 00 00 	movabs $0x803fe4,%rax
  8043d6:	00 00 00 
  8043d9:	ff d0                	callq  *%rax
}
  8043db:	c9                   	leaveq 
  8043dc:	c3                   	retq   

00000000008043dd <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8043dd:	55                   	push   %rbp
  8043de:	48 89 e5             	mov    %rsp,%rbp
  8043e1:	48 83 ec 10          	sub    $0x10,%rsp
  8043e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8043e8:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8043eb:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8043ee:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043f5:	00 00 00 
  8043f8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8043fb:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8043fd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804404:	00 00 00 
  804407:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80440a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80440d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804414:	00 00 00 
  804417:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80441a:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80441d:	bf 09 00 00 00       	mov    $0x9,%edi
  804422:	48 b8 e4 3f 80 00 00 	movabs $0x803fe4,%rax
  804429:	00 00 00 
  80442c:	ff d0                	callq  *%rax
}
  80442e:	c9                   	leaveq 
  80442f:	c3                   	retq   

0000000000804430 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804430:	55                   	push   %rbp
  804431:	48 89 e5             	mov    %rsp,%rbp
  804434:	53                   	push   %rbx
  804435:	48 83 ec 38          	sub    $0x38,%rsp
  804439:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80443d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804441:	48 89 c7             	mov    %rax,%rdi
  804444:	48 b8 6e 2c 80 00 00 	movabs $0x802c6e,%rax
  80444b:	00 00 00 
  80444e:	ff d0                	callq  *%rax
  804450:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804453:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804457:	0f 88 bf 01 00 00    	js     80461c <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80445d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804461:	ba 07 04 00 00       	mov    $0x407,%edx
  804466:	48 89 c6             	mov    %rax,%rsi
  804469:	bf 00 00 00 00       	mov    $0x0,%edi
  80446e:	48 b8 65 20 80 00 00 	movabs $0x802065,%rax
  804475:	00 00 00 
  804478:	ff d0                	callq  *%rax
  80447a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80447d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804481:	0f 88 95 01 00 00    	js     80461c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804487:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80448b:	48 89 c7             	mov    %rax,%rdi
  80448e:	48 b8 6e 2c 80 00 00 	movabs $0x802c6e,%rax
  804495:	00 00 00 
  804498:	ff d0                	callq  *%rax
  80449a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80449d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8044a1:	0f 88 5d 01 00 00    	js     804604 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8044a7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044ab:	ba 07 04 00 00       	mov    $0x407,%edx
  8044b0:	48 89 c6             	mov    %rax,%rsi
  8044b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8044b8:	48 b8 65 20 80 00 00 	movabs $0x802065,%rax
  8044bf:	00 00 00 
  8044c2:	ff d0                	callq  *%rax
  8044c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8044c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8044cb:	0f 88 33 01 00 00    	js     804604 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8044d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044d5:	48 89 c7             	mov    %rax,%rdi
  8044d8:	48 b8 43 2c 80 00 00 	movabs $0x802c43,%rax
  8044df:	00 00 00 
  8044e2:	ff d0                	callq  *%rax
  8044e4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8044e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044ec:	ba 07 04 00 00       	mov    $0x407,%edx
  8044f1:	48 89 c6             	mov    %rax,%rsi
  8044f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8044f9:	48 b8 65 20 80 00 00 	movabs $0x802065,%rax
  804500:	00 00 00 
  804503:	ff d0                	callq  *%rax
  804505:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804508:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80450c:	79 05                	jns    804513 <pipe+0xe3>
		goto err2;
  80450e:	e9 d9 00 00 00       	jmpq   8045ec <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804513:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804517:	48 89 c7             	mov    %rax,%rdi
  80451a:	48 b8 43 2c 80 00 00 	movabs $0x802c43,%rax
  804521:	00 00 00 
  804524:	ff d0                	callq  *%rax
  804526:	48 89 c2             	mov    %rax,%rdx
  804529:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80452d:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804533:	48 89 d1             	mov    %rdx,%rcx
  804536:	ba 00 00 00 00       	mov    $0x0,%edx
  80453b:	48 89 c6             	mov    %rax,%rsi
  80453e:	bf 00 00 00 00       	mov    $0x0,%edi
  804543:	48 b8 b5 20 80 00 00 	movabs $0x8020b5,%rax
  80454a:	00 00 00 
  80454d:	ff d0                	callq  *%rax
  80454f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804552:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804556:	79 1b                	jns    804573 <pipe+0x143>
		goto err3;
  804558:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804559:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80455d:	48 89 c6             	mov    %rax,%rsi
  804560:	bf 00 00 00 00       	mov    $0x0,%edi
  804565:	48 b8 10 21 80 00 00 	movabs $0x802110,%rax
  80456c:	00 00 00 
  80456f:	ff d0                	callq  *%rax
  804571:	eb 79                	jmp    8045ec <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804573:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804577:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80457e:	00 00 00 
  804581:	8b 12                	mov    (%rdx),%edx
  804583:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804585:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804589:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804590:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804594:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80459b:	00 00 00 
  80459e:	8b 12                	mov    (%rdx),%edx
  8045a0:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8045a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8045a6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8045ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045b1:	48 89 c7             	mov    %rax,%rdi
  8045b4:	48 b8 20 2c 80 00 00 	movabs $0x802c20,%rax
  8045bb:	00 00 00 
  8045be:	ff d0                	callq  *%rax
  8045c0:	89 c2                	mov    %eax,%edx
  8045c2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8045c6:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8045c8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8045cc:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8045d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8045d4:	48 89 c7             	mov    %rax,%rdi
  8045d7:	48 b8 20 2c 80 00 00 	movabs $0x802c20,%rax
  8045de:	00 00 00 
  8045e1:	ff d0                	callq  *%rax
  8045e3:	89 03                	mov    %eax,(%rbx)
	return 0;
  8045e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8045ea:	eb 33                	jmp    80461f <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8045ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8045f0:	48 89 c6             	mov    %rax,%rsi
  8045f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8045f8:	48 b8 10 21 80 00 00 	movabs $0x802110,%rax
  8045ff:	00 00 00 
  804602:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804604:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804608:	48 89 c6             	mov    %rax,%rsi
  80460b:	bf 00 00 00 00       	mov    $0x0,%edi
  804610:	48 b8 10 21 80 00 00 	movabs $0x802110,%rax
  804617:	00 00 00 
  80461a:	ff d0                	callq  *%rax
err:
	return r;
  80461c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80461f:	48 83 c4 38          	add    $0x38,%rsp
  804623:	5b                   	pop    %rbx
  804624:	5d                   	pop    %rbp
  804625:	c3                   	retq   

0000000000804626 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804626:	55                   	push   %rbp
  804627:	48 89 e5             	mov    %rsp,%rbp
  80462a:	53                   	push   %rbx
  80462b:	48 83 ec 28          	sub    $0x28,%rsp
  80462f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804633:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804637:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80463e:	00 00 00 
  804641:	48 8b 00             	mov    (%rax),%rax
  804644:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80464a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80464d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804651:	48 89 c7             	mov    %rax,%rdi
  804654:	48 b8 ec 4d 80 00 00 	movabs $0x804dec,%rax
  80465b:	00 00 00 
  80465e:	ff d0                	callq  *%rax
  804660:	89 c3                	mov    %eax,%ebx
  804662:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804666:	48 89 c7             	mov    %rax,%rdi
  804669:	48 b8 ec 4d 80 00 00 	movabs $0x804dec,%rax
  804670:	00 00 00 
  804673:	ff d0                	callq  *%rax
  804675:	39 c3                	cmp    %eax,%ebx
  804677:	0f 94 c0             	sete   %al
  80467a:	0f b6 c0             	movzbl %al,%eax
  80467d:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804680:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804687:	00 00 00 
  80468a:	48 8b 00             	mov    (%rax),%rax
  80468d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804693:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804696:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804699:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80469c:	75 05                	jne    8046a3 <_pipeisclosed+0x7d>
			return ret;
  80469e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8046a1:	eb 4f                	jmp    8046f2 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8046a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8046a6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8046a9:	74 42                	je     8046ed <_pipeisclosed+0xc7>
  8046ab:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8046af:	75 3c                	jne    8046ed <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8046b1:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8046b8:	00 00 00 
  8046bb:	48 8b 00             	mov    (%rax),%rax
  8046be:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8046c4:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8046c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8046ca:	89 c6                	mov    %eax,%esi
  8046cc:	48 bf 06 5c 80 00 00 	movabs $0x805c06,%rdi
  8046d3:	00 00 00 
  8046d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8046db:	49 b8 81 0b 80 00 00 	movabs $0x800b81,%r8
  8046e2:	00 00 00 
  8046e5:	41 ff d0             	callq  *%r8
	}
  8046e8:	e9 4a ff ff ff       	jmpq   804637 <_pipeisclosed+0x11>
  8046ed:	e9 45 ff ff ff       	jmpq   804637 <_pipeisclosed+0x11>
}
  8046f2:	48 83 c4 28          	add    $0x28,%rsp
  8046f6:	5b                   	pop    %rbx
  8046f7:	5d                   	pop    %rbp
  8046f8:	c3                   	retq   

00000000008046f9 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8046f9:	55                   	push   %rbp
  8046fa:	48 89 e5             	mov    %rsp,%rbp
  8046fd:	48 83 ec 30          	sub    $0x30,%rsp
  804701:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804704:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804708:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80470b:	48 89 d6             	mov    %rdx,%rsi
  80470e:	89 c7                	mov    %eax,%edi
  804710:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  804717:	00 00 00 
  80471a:	ff d0                	callq  *%rax
  80471c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80471f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804723:	79 05                	jns    80472a <pipeisclosed+0x31>
		return r;
  804725:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804728:	eb 31                	jmp    80475b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80472a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80472e:	48 89 c7             	mov    %rax,%rdi
  804731:	48 b8 43 2c 80 00 00 	movabs $0x802c43,%rax
  804738:	00 00 00 
  80473b:	ff d0                	callq  *%rax
  80473d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804741:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804745:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804749:	48 89 d6             	mov    %rdx,%rsi
  80474c:	48 89 c7             	mov    %rax,%rdi
  80474f:	48 b8 26 46 80 00 00 	movabs $0x804626,%rax
  804756:	00 00 00 
  804759:	ff d0                	callq  *%rax
}
  80475b:	c9                   	leaveq 
  80475c:	c3                   	retq   

000000000080475d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80475d:	55                   	push   %rbp
  80475e:	48 89 e5             	mov    %rsp,%rbp
  804761:	48 83 ec 40          	sub    $0x40,%rsp
  804765:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804769:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80476d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804771:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804775:	48 89 c7             	mov    %rax,%rdi
  804778:	48 b8 43 2c 80 00 00 	movabs $0x802c43,%rax
  80477f:	00 00 00 
  804782:	ff d0                	callq  *%rax
  804784:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804788:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80478c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804790:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804797:	00 
  804798:	e9 92 00 00 00       	jmpq   80482f <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80479d:	eb 41                	jmp    8047e0 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80479f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8047a4:	74 09                	je     8047af <devpipe_read+0x52>
				return i;
  8047a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047aa:	e9 92 00 00 00       	jmpq   804841 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8047af:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8047b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047b7:	48 89 d6             	mov    %rdx,%rsi
  8047ba:	48 89 c7             	mov    %rax,%rdi
  8047bd:	48 b8 26 46 80 00 00 	movabs $0x804626,%rax
  8047c4:	00 00 00 
  8047c7:	ff d0                	callq  *%rax
  8047c9:	85 c0                	test   %eax,%eax
  8047cb:	74 07                	je     8047d4 <devpipe_read+0x77>
				return 0;
  8047cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8047d2:	eb 6d                	jmp    804841 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8047d4:	48 b8 27 20 80 00 00 	movabs $0x802027,%rax
  8047db:	00 00 00 
  8047de:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8047e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047e4:	8b 10                	mov    (%rax),%edx
  8047e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047ea:	8b 40 04             	mov    0x4(%rax),%eax
  8047ed:	39 c2                	cmp    %eax,%edx
  8047ef:	74 ae                	je     80479f <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8047f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8047f9:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8047fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804801:	8b 00                	mov    (%rax),%eax
  804803:	99                   	cltd   
  804804:	c1 ea 1b             	shr    $0x1b,%edx
  804807:	01 d0                	add    %edx,%eax
  804809:	83 e0 1f             	and    $0x1f,%eax
  80480c:	29 d0                	sub    %edx,%eax
  80480e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804812:	48 98                	cltq   
  804814:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804819:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80481b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80481f:	8b 00                	mov    (%rax),%eax
  804821:	8d 50 01             	lea    0x1(%rax),%edx
  804824:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804828:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80482a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80482f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804833:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804837:	0f 82 60 ff ff ff    	jb     80479d <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80483d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804841:	c9                   	leaveq 
  804842:	c3                   	retq   

0000000000804843 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804843:	55                   	push   %rbp
  804844:	48 89 e5             	mov    %rsp,%rbp
  804847:	48 83 ec 40          	sub    $0x40,%rsp
  80484b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80484f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804853:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804857:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80485b:	48 89 c7             	mov    %rax,%rdi
  80485e:	48 b8 43 2c 80 00 00 	movabs $0x802c43,%rax
  804865:	00 00 00 
  804868:	ff d0                	callq  *%rax
  80486a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80486e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804872:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804876:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80487d:	00 
  80487e:	e9 8e 00 00 00       	jmpq   804911 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804883:	eb 31                	jmp    8048b6 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804885:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804889:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80488d:	48 89 d6             	mov    %rdx,%rsi
  804890:	48 89 c7             	mov    %rax,%rdi
  804893:	48 b8 26 46 80 00 00 	movabs $0x804626,%rax
  80489a:	00 00 00 
  80489d:	ff d0                	callq  *%rax
  80489f:	85 c0                	test   %eax,%eax
  8048a1:	74 07                	je     8048aa <devpipe_write+0x67>
				return 0;
  8048a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8048a8:	eb 79                	jmp    804923 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8048aa:	48 b8 27 20 80 00 00 	movabs $0x802027,%rax
  8048b1:	00 00 00 
  8048b4:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8048b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048ba:	8b 40 04             	mov    0x4(%rax),%eax
  8048bd:	48 63 d0             	movslq %eax,%rdx
  8048c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048c4:	8b 00                	mov    (%rax),%eax
  8048c6:	48 98                	cltq   
  8048c8:	48 83 c0 20          	add    $0x20,%rax
  8048cc:	48 39 c2             	cmp    %rax,%rdx
  8048cf:	73 b4                	jae    804885 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8048d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048d5:	8b 40 04             	mov    0x4(%rax),%eax
  8048d8:	99                   	cltd   
  8048d9:	c1 ea 1b             	shr    $0x1b,%edx
  8048dc:	01 d0                	add    %edx,%eax
  8048de:	83 e0 1f             	and    $0x1f,%eax
  8048e1:	29 d0                	sub    %edx,%eax
  8048e3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8048e7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8048eb:	48 01 ca             	add    %rcx,%rdx
  8048ee:	0f b6 0a             	movzbl (%rdx),%ecx
  8048f1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8048f5:	48 98                	cltq   
  8048f7:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8048fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048ff:	8b 40 04             	mov    0x4(%rax),%eax
  804902:	8d 50 01             	lea    0x1(%rax),%edx
  804905:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804909:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80490c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804911:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804915:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804919:	0f 82 64 ff ff ff    	jb     804883 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80491f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804923:	c9                   	leaveq 
  804924:	c3                   	retq   

0000000000804925 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804925:	55                   	push   %rbp
  804926:	48 89 e5             	mov    %rsp,%rbp
  804929:	48 83 ec 20          	sub    $0x20,%rsp
  80492d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804931:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804935:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804939:	48 89 c7             	mov    %rax,%rdi
  80493c:	48 b8 43 2c 80 00 00 	movabs $0x802c43,%rax
  804943:	00 00 00 
  804946:	ff d0                	callq  *%rax
  804948:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80494c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804950:	48 be 19 5c 80 00 00 	movabs $0x805c19,%rsi
  804957:	00 00 00 
  80495a:	48 89 c7             	mov    %rax,%rdi
  80495d:	48 b8 36 17 80 00 00 	movabs $0x801736,%rax
  804964:	00 00 00 
  804967:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804969:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80496d:	8b 50 04             	mov    0x4(%rax),%edx
  804970:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804974:	8b 00                	mov    (%rax),%eax
  804976:	29 c2                	sub    %eax,%edx
  804978:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80497c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804982:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804986:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80498d:	00 00 00 
	stat->st_dev = &devpipe;
  804990:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804994:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  80499b:	00 00 00 
  80499e:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8049a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8049aa:	c9                   	leaveq 
  8049ab:	c3                   	retq   

00000000008049ac <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8049ac:	55                   	push   %rbp
  8049ad:	48 89 e5             	mov    %rsp,%rbp
  8049b0:	48 83 ec 10          	sub    $0x10,%rsp
  8049b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8049b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049bc:	48 89 c6             	mov    %rax,%rsi
  8049bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8049c4:	48 b8 10 21 80 00 00 	movabs $0x802110,%rax
  8049cb:	00 00 00 
  8049ce:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8049d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049d4:	48 89 c7             	mov    %rax,%rdi
  8049d7:	48 b8 43 2c 80 00 00 	movabs $0x802c43,%rax
  8049de:	00 00 00 
  8049e1:	ff d0                	callq  *%rax
  8049e3:	48 89 c6             	mov    %rax,%rsi
  8049e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8049eb:	48 b8 10 21 80 00 00 	movabs $0x802110,%rax
  8049f2:	00 00 00 
  8049f5:	ff d0                	callq  *%rax
}
  8049f7:	c9                   	leaveq 
  8049f8:	c3                   	retq   

00000000008049f9 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8049f9:	55                   	push   %rbp
  8049fa:	48 89 e5             	mov    %rsp,%rbp
  8049fd:	48 83 ec 20          	sub    $0x20,%rsp
  804a01:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804a04:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a07:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804a0a:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804a0e:	be 01 00 00 00       	mov    $0x1,%esi
  804a13:	48 89 c7             	mov    %rax,%rdi
  804a16:	48 b8 1d 1f 80 00 00 	movabs $0x801f1d,%rax
  804a1d:	00 00 00 
  804a20:	ff d0                	callq  *%rax
}
  804a22:	c9                   	leaveq 
  804a23:	c3                   	retq   

0000000000804a24 <getchar>:

int
getchar(void)
{
  804a24:	55                   	push   %rbp
  804a25:	48 89 e5             	mov    %rsp,%rbp
  804a28:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804a2c:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804a30:	ba 01 00 00 00       	mov    $0x1,%edx
  804a35:	48 89 c6             	mov    %rax,%rsi
  804a38:	bf 00 00 00 00       	mov    $0x0,%edi
  804a3d:	48 b8 38 31 80 00 00 	movabs $0x803138,%rax
  804a44:	00 00 00 
  804a47:	ff d0                	callq  *%rax
  804a49:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804a4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a50:	79 05                	jns    804a57 <getchar+0x33>
		return r;
  804a52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a55:	eb 14                	jmp    804a6b <getchar+0x47>
	if (r < 1)
  804a57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a5b:	7f 07                	jg     804a64 <getchar+0x40>
		return -E_EOF;
  804a5d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804a62:	eb 07                	jmp    804a6b <getchar+0x47>
	return c;
  804a64:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804a68:	0f b6 c0             	movzbl %al,%eax
}
  804a6b:	c9                   	leaveq 
  804a6c:	c3                   	retq   

0000000000804a6d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804a6d:	55                   	push   %rbp
  804a6e:	48 89 e5             	mov    %rsp,%rbp
  804a71:	48 83 ec 20          	sub    $0x20,%rsp
  804a75:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804a78:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804a7c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a7f:	48 89 d6             	mov    %rdx,%rsi
  804a82:	89 c7                	mov    %eax,%edi
  804a84:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  804a8b:	00 00 00 
  804a8e:	ff d0                	callq  *%rax
  804a90:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a97:	79 05                	jns    804a9e <iscons+0x31>
		return r;
  804a99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a9c:	eb 1a                	jmp    804ab8 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804a9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804aa2:	8b 10                	mov    (%rax),%edx
  804aa4:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804aab:	00 00 00 
  804aae:	8b 00                	mov    (%rax),%eax
  804ab0:	39 c2                	cmp    %eax,%edx
  804ab2:	0f 94 c0             	sete   %al
  804ab5:	0f b6 c0             	movzbl %al,%eax
}
  804ab8:	c9                   	leaveq 
  804ab9:	c3                   	retq   

0000000000804aba <opencons>:

int
opencons(void)
{
  804aba:	55                   	push   %rbp
  804abb:	48 89 e5             	mov    %rsp,%rbp
  804abe:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804ac2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804ac6:	48 89 c7             	mov    %rax,%rdi
  804ac9:	48 b8 6e 2c 80 00 00 	movabs $0x802c6e,%rax
  804ad0:	00 00 00 
  804ad3:	ff d0                	callq  *%rax
  804ad5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804ad8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804adc:	79 05                	jns    804ae3 <opencons+0x29>
		return r;
  804ade:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ae1:	eb 5b                	jmp    804b3e <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804ae3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ae7:	ba 07 04 00 00       	mov    $0x407,%edx
  804aec:	48 89 c6             	mov    %rax,%rsi
  804aef:	bf 00 00 00 00       	mov    $0x0,%edi
  804af4:	48 b8 65 20 80 00 00 	movabs $0x802065,%rax
  804afb:	00 00 00 
  804afe:	ff d0                	callq  *%rax
  804b00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804b03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b07:	79 05                	jns    804b0e <opencons+0x54>
		return r;
  804b09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b0c:	eb 30                	jmp    804b3e <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804b0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b12:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804b19:	00 00 00 
  804b1c:	8b 12                	mov    (%rdx),%edx
  804b1e:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804b20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b24:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804b2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b2f:	48 89 c7             	mov    %rax,%rdi
  804b32:	48 b8 20 2c 80 00 00 	movabs $0x802c20,%rax
  804b39:	00 00 00 
  804b3c:	ff d0                	callq  *%rax
}
  804b3e:	c9                   	leaveq 
  804b3f:	c3                   	retq   

0000000000804b40 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804b40:	55                   	push   %rbp
  804b41:	48 89 e5             	mov    %rsp,%rbp
  804b44:	48 83 ec 30          	sub    $0x30,%rsp
  804b48:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804b4c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804b50:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804b54:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804b59:	75 07                	jne    804b62 <devcons_read+0x22>
		return 0;
  804b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  804b60:	eb 4b                	jmp    804bad <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804b62:	eb 0c                	jmp    804b70 <devcons_read+0x30>
		sys_yield();
  804b64:	48 b8 27 20 80 00 00 	movabs $0x802027,%rax
  804b6b:	00 00 00 
  804b6e:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804b70:	48 b8 67 1f 80 00 00 	movabs $0x801f67,%rax
  804b77:	00 00 00 
  804b7a:	ff d0                	callq  *%rax
  804b7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804b7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b83:	74 df                	je     804b64 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804b85:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b89:	79 05                	jns    804b90 <devcons_read+0x50>
		return c;
  804b8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b8e:	eb 1d                	jmp    804bad <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804b90:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804b94:	75 07                	jne    804b9d <devcons_read+0x5d>
		return 0;
  804b96:	b8 00 00 00 00       	mov    $0x0,%eax
  804b9b:	eb 10                	jmp    804bad <devcons_read+0x6d>
	*(char*)vbuf = c;
  804b9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ba0:	89 c2                	mov    %eax,%edx
  804ba2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804ba6:	88 10                	mov    %dl,(%rax)
	return 1;
  804ba8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804bad:	c9                   	leaveq 
  804bae:	c3                   	retq   

0000000000804baf <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804baf:	55                   	push   %rbp
  804bb0:	48 89 e5             	mov    %rsp,%rbp
  804bb3:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804bba:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804bc1:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804bc8:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804bcf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804bd6:	eb 76                	jmp    804c4e <devcons_write+0x9f>
		m = n - tot;
  804bd8:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804bdf:	89 c2                	mov    %eax,%edx
  804be1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804be4:	29 c2                	sub    %eax,%edx
  804be6:	89 d0                	mov    %edx,%eax
  804be8:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804beb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804bee:	83 f8 7f             	cmp    $0x7f,%eax
  804bf1:	76 07                	jbe    804bfa <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804bf3:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804bfa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804bfd:	48 63 d0             	movslq %eax,%rdx
  804c00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c03:	48 63 c8             	movslq %eax,%rcx
  804c06:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804c0d:	48 01 c1             	add    %rax,%rcx
  804c10:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804c17:	48 89 ce             	mov    %rcx,%rsi
  804c1a:	48 89 c7             	mov    %rax,%rdi
  804c1d:	48 b8 5a 1a 80 00 00 	movabs $0x801a5a,%rax
  804c24:	00 00 00 
  804c27:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804c29:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804c2c:	48 63 d0             	movslq %eax,%rdx
  804c2f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804c36:	48 89 d6             	mov    %rdx,%rsi
  804c39:	48 89 c7             	mov    %rax,%rdi
  804c3c:	48 b8 1d 1f 80 00 00 	movabs $0x801f1d,%rax
  804c43:	00 00 00 
  804c46:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804c48:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804c4b:	01 45 fc             	add    %eax,-0x4(%rbp)
  804c4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c51:	48 98                	cltq   
  804c53:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804c5a:	0f 82 78 ff ff ff    	jb     804bd8 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804c60:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804c63:	c9                   	leaveq 
  804c64:	c3                   	retq   

0000000000804c65 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804c65:	55                   	push   %rbp
  804c66:	48 89 e5             	mov    %rsp,%rbp
  804c69:	48 83 ec 08          	sub    $0x8,%rsp
  804c6d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804c71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804c76:	c9                   	leaveq 
  804c77:	c3                   	retq   

0000000000804c78 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804c78:	55                   	push   %rbp
  804c79:	48 89 e5             	mov    %rsp,%rbp
  804c7c:	48 83 ec 10          	sub    $0x10,%rsp
  804c80:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804c84:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804c88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c8c:	48 be 25 5c 80 00 00 	movabs $0x805c25,%rsi
  804c93:	00 00 00 
  804c96:	48 89 c7             	mov    %rax,%rdi
  804c99:	48 b8 36 17 80 00 00 	movabs $0x801736,%rax
  804ca0:	00 00 00 
  804ca3:	ff d0                	callq  *%rax
	return 0;
  804ca5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804caa:	c9                   	leaveq 
  804cab:	c3                   	retq   

0000000000804cac <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804cac:	55                   	push   %rbp
  804cad:	48 89 e5             	mov    %rsp,%rbp
  804cb0:	48 83 ec 10          	sub    $0x10,%rsp
  804cb4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804cb8:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804cbf:	00 00 00 
  804cc2:	48 8b 00             	mov    (%rax),%rax
  804cc5:	48 85 c0             	test   %rax,%rax
  804cc8:	0f 85 84 00 00 00    	jne    804d52 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  804cce:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804cd5:	00 00 00 
  804cd8:	48 8b 00             	mov    (%rax),%rax
  804cdb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804ce1:	ba 07 00 00 00       	mov    $0x7,%edx
  804ce6:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804ceb:	89 c7                	mov    %eax,%edi
  804ced:	48 b8 65 20 80 00 00 	movabs $0x802065,%rax
  804cf4:	00 00 00 
  804cf7:	ff d0                	callq  *%rax
  804cf9:	85 c0                	test   %eax,%eax
  804cfb:	79 2a                	jns    804d27 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  804cfd:	48 ba 30 5c 80 00 00 	movabs $0x805c30,%rdx
  804d04:	00 00 00 
  804d07:	be 23 00 00 00       	mov    $0x23,%esi
  804d0c:	48 bf 57 5c 80 00 00 	movabs $0x805c57,%rdi
  804d13:	00 00 00 
  804d16:	b8 00 00 00 00       	mov    $0x0,%eax
  804d1b:	48 b9 48 09 80 00 00 	movabs $0x800948,%rcx
  804d22:	00 00 00 
  804d25:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  804d27:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804d2e:	00 00 00 
  804d31:	48 8b 00             	mov    (%rax),%rax
  804d34:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804d3a:	48 be 65 4d 80 00 00 	movabs $0x804d65,%rsi
  804d41:	00 00 00 
  804d44:	89 c7                	mov    %eax,%edi
  804d46:	48 b8 ef 21 80 00 00 	movabs $0x8021ef,%rax
  804d4d:	00 00 00 
  804d50:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  804d52:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804d59:	00 00 00 
  804d5c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804d60:	48 89 10             	mov    %rdx,(%rax)
}
  804d63:	c9                   	leaveq 
  804d64:	c3                   	retq   

0000000000804d65 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804d65:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804d68:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  804d6f:	00 00 00 
call *%rax
  804d72:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  804d74:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804d7b:	00 
	movq 152(%rsp), %rcx  //Load RSP
  804d7c:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804d83:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  804d84:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  804d88:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  804d8b:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804d92:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  804d93:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  804d97:	4c 8b 3c 24          	mov    (%rsp),%r15
  804d9b:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804da0:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804da5:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804daa:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804daf:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804db4:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804db9:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804dbe:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804dc3:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804dc8:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804dcd:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804dd2:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804dd7:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804ddc:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804de1:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  804de5:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  804de9:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  804dea:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  804deb:	c3                   	retq   

0000000000804dec <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804dec:	55                   	push   %rbp
  804ded:	48 89 e5             	mov    %rsp,%rbp
  804df0:	48 83 ec 18          	sub    $0x18,%rsp
  804df4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804df8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804dfc:	48 c1 e8 15          	shr    $0x15,%rax
  804e00:	48 89 c2             	mov    %rax,%rdx
  804e03:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804e0a:	01 00 00 
  804e0d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804e11:	83 e0 01             	and    $0x1,%eax
  804e14:	48 85 c0             	test   %rax,%rax
  804e17:	75 07                	jne    804e20 <pageref+0x34>
		return 0;
  804e19:	b8 00 00 00 00       	mov    $0x0,%eax
  804e1e:	eb 53                	jmp    804e73 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804e20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804e24:	48 c1 e8 0c          	shr    $0xc,%rax
  804e28:	48 89 c2             	mov    %rax,%rdx
  804e2b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804e32:	01 00 00 
  804e35:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804e39:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804e3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804e41:	83 e0 01             	and    $0x1,%eax
  804e44:	48 85 c0             	test   %rax,%rax
  804e47:	75 07                	jne    804e50 <pageref+0x64>
		return 0;
  804e49:	b8 00 00 00 00       	mov    $0x0,%eax
  804e4e:	eb 23                	jmp    804e73 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804e50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804e54:	48 c1 e8 0c          	shr    $0xc,%rax
  804e58:	48 89 c2             	mov    %rax,%rdx
  804e5b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804e62:	00 00 00 
  804e65:	48 c1 e2 04          	shl    $0x4,%rdx
  804e69:	48 01 d0             	add    %rdx,%rax
  804e6c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804e70:	0f b7 c0             	movzwl %ax,%eax
}
  804e73:	c9                   	leaveq 
  804e74:	c3                   	retq   

0000000000804e75 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  804e75:	55                   	push   %rbp
  804e76:	48 89 e5             	mov    %rsp,%rbp
  804e79:	48 83 ec 20          	sub    $0x20,%rsp
  804e7d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  804e81:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804e85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804e89:	48 89 d6             	mov    %rdx,%rsi
  804e8c:	48 89 c7             	mov    %rax,%rdi
  804e8f:	48 b8 ab 4e 80 00 00 	movabs $0x804eab,%rax
  804e96:	00 00 00 
  804e99:	ff d0                	callq  *%rax
  804e9b:	85 c0                	test   %eax,%eax
  804e9d:	74 05                	je     804ea4 <inet_addr+0x2f>
    return (val.s_addr);
  804e9f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804ea2:	eb 05                	jmp    804ea9 <inet_addr+0x34>
  }
  return (INADDR_NONE);
  804ea4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  804ea9:	c9                   	leaveq 
  804eaa:	c3                   	retq   

0000000000804eab <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  804eab:	55                   	push   %rbp
  804eac:	48 89 e5             	mov    %rsp,%rbp
  804eaf:	48 83 ec 40          	sub    $0x40,%rsp
  804eb3:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  804eb7:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  804ebb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804ebf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  c = *cp;
  804ec3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804ec7:	0f b6 00             	movzbl (%rax),%eax
  804eca:	0f be c0             	movsbl %al,%eax
  804ecd:	89 45 f4             	mov    %eax,-0xc(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  804ed0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804ed3:	3c 2f                	cmp    $0x2f,%al
  804ed5:	76 07                	jbe    804ede <inet_aton+0x33>
  804ed7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804eda:	3c 39                	cmp    $0x39,%al
  804edc:	76 0a                	jbe    804ee8 <inet_aton+0x3d>
      return (0);
  804ede:	b8 00 00 00 00       	mov    $0x0,%eax
  804ee3:	e9 68 02 00 00       	jmpq   805150 <inet_aton+0x2a5>
    val = 0;
  804ee8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    base = 10;
  804eef:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    if (c == '0') {
  804ef6:	83 7d f4 30          	cmpl   $0x30,-0xc(%rbp)
  804efa:	75 40                	jne    804f3c <inet_aton+0x91>
      c = *++cp;
  804efc:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804f01:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804f05:	0f b6 00             	movzbl (%rax),%eax
  804f08:	0f be c0             	movsbl %al,%eax
  804f0b:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if (c == 'x' || c == 'X') {
  804f0e:	83 7d f4 78          	cmpl   $0x78,-0xc(%rbp)
  804f12:	74 06                	je     804f1a <inet_aton+0x6f>
  804f14:	83 7d f4 58          	cmpl   $0x58,-0xc(%rbp)
  804f18:	75 1b                	jne    804f35 <inet_aton+0x8a>
        base = 16;
  804f1a:	c7 45 f8 10 00 00 00 	movl   $0x10,-0x8(%rbp)
        c = *++cp;
  804f21:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804f26:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804f2a:	0f b6 00             	movzbl (%rax),%eax
  804f2d:	0f be c0             	movsbl %al,%eax
  804f30:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804f33:	eb 07                	jmp    804f3c <inet_aton+0x91>
      } else
        base = 8;
  804f35:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  804f3c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804f3f:	3c 2f                	cmp    $0x2f,%al
  804f41:	76 2f                	jbe    804f72 <inet_aton+0xc7>
  804f43:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804f46:	3c 39                	cmp    $0x39,%al
  804f48:	77 28                	ja     804f72 <inet_aton+0xc7>
        val = (val * base) + (int)(c - '0');
  804f4a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804f4d:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  804f51:	89 c2                	mov    %eax,%edx
  804f53:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804f56:	01 d0                	add    %edx,%eax
  804f58:	83 e8 30             	sub    $0x30,%eax
  804f5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  804f5e:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804f63:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804f67:	0f b6 00             	movzbl (%rax),%eax
  804f6a:	0f be c0             	movsbl %al,%eax
  804f6d:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else if (base == 16 && isxdigit(c)) {
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
  804f70:	eb ca                	jmp    804f3c <inet_aton+0x91>
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  804f72:	83 7d f8 10          	cmpl   $0x10,-0x8(%rbp)
  804f76:	75 72                	jne    804fea <inet_aton+0x13f>
  804f78:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804f7b:	3c 2f                	cmp    $0x2f,%al
  804f7d:	76 07                	jbe    804f86 <inet_aton+0xdb>
  804f7f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804f82:	3c 39                	cmp    $0x39,%al
  804f84:	76 1c                	jbe    804fa2 <inet_aton+0xf7>
  804f86:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804f89:	3c 60                	cmp    $0x60,%al
  804f8b:	76 07                	jbe    804f94 <inet_aton+0xe9>
  804f8d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804f90:	3c 66                	cmp    $0x66,%al
  804f92:	76 0e                	jbe    804fa2 <inet_aton+0xf7>
  804f94:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804f97:	3c 40                	cmp    $0x40,%al
  804f99:	76 4f                	jbe    804fea <inet_aton+0x13f>
  804f9b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804f9e:	3c 46                	cmp    $0x46,%al
  804fa0:	77 48                	ja     804fea <inet_aton+0x13f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  804fa2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804fa5:	c1 e0 04             	shl    $0x4,%eax
  804fa8:	89 c2                	mov    %eax,%edx
  804faa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804fad:	8d 48 0a             	lea    0xa(%rax),%ecx
  804fb0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804fb3:	3c 60                	cmp    $0x60,%al
  804fb5:	76 0e                	jbe    804fc5 <inet_aton+0x11a>
  804fb7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804fba:	3c 7a                	cmp    $0x7a,%al
  804fbc:	77 07                	ja     804fc5 <inet_aton+0x11a>
  804fbe:	b8 61 00 00 00       	mov    $0x61,%eax
  804fc3:	eb 05                	jmp    804fca <inet_aton+0x11f>
  804fc5:	b8 41 00 00 00       	mov    $0x41,%eax
  804fca:	29 c1                	sub    %eax,%ecx
  804fcc:	89 c8                	mov    %ecx,%eax
  804fce:	09 d0                	or     %edx,%eax
  804fd0:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  804fd3:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804fd8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804fdc:	0f b6 00             	movzbl (%rax),%eax
  804fdf:	0f be c0             	movsbl %al,%eax
  804fe2:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else
        break;
    }
  804fe5:	e9 52 ff ff ff       	jmpq   804f3c <inet_aton+0x91>
    if (c == '.') {
  804fea:	83 7d f4 2e          	cmpl   $0x2e,-0xc(%rbp)
  804fee:	75 40                	jne    805030 <inet_aton+0x185>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  804ff0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804ff4:	48 83 c0 0c          	add    $0xc,%rax
  804ff8:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  804ffc:	72 0a                	jb     805008 <inet_aton+0x15d>
        return (0);
  804ffe:	b8 00 00 00 00       	mov    $0x0,%eax
  805003:	e9 48 01 00 00       	jmpq   805150 <inet_aton+0x2a5>
      *pp++ = val;
  805008:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80500c:	48 8d 50 04          	lea    0x4(%rax),%rdx
  805010:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  805014:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805017:	89 10                	mov    %edx,(%rax)
      c = *++cp;
  805019:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  80501e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805022:	0f b6 00             	movzbl (%rax),%eax
  805025:	0f be c0             	movsbl %al,%eax
  805028:	89 45 f4             	mov    %eax,-0xc(%rbp)
    } else
      break;
  }
  80502b:	e9 a0 fe ff ff       	jmpq   804ed0 <inet_aton+0x25>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  805030:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  805031:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  805035:	74 3c                	je     805073 <inet_aton+0x1c8>
  805037:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80503a:	3c 1f                	cmp    $0x1f,%al
  80503c:	76 2b                	jbe    805069 <inet_aton+0x1be>
  80503e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805041:	84 c0                	test   %al,%al
  805043:	78 24                	js     805069 <inet_aton+0x1be>
  805045:	83 7d f4 20          	cmpl   $0x20,-0xc(%rbp)
  805049:	74 28                	je     805073 <inet_aton+0x1c8>
  80504b:	83 7d f4 0c          	cmpl   $0xc,-0xc(%rbp)
  80504f:	74 22                	je     805073 <inet_aton+0x1c8>
  805051:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  805055:	74 1c                	je     805073 <inet_aton+0x1c8>
  805057:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  80505b:	74 16                	je     805073 <inet_aton+0x1c8>
  80505d:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  805061:	74 10                	je     805073 <inet_aton+0x1c8>
  805063:	83 7d f4 0b          	cmpl   $0xb,-0xc(%rbp)
  805067:	74 0a                	je     805073 <inet_aton+0x1c8>
    return (0);
  805069:	b8 00 00 00 00       	mov    $0x0,%eax
  80506e:	e9 dd 00 00 00       	jmpq   805150 <inet_aton+0x2a5>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  805073:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805077:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80507b:	48 29 c2             	sub    %rax,%rdx
  80507e:	48 89 d0             	mov    %rdx,%rax
  805081:	48 c1 f8 02          	sar    $0x2,%rax
  805085:	83 c0 01             	add    $0x1,%eax
  805088:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  switch (n) {
  80508b:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  80508f:	0f 87 98 00 00 00    	ja     80512d <inet_aton+0x282>
  805095:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  805098:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80509f:	00 
  8050a0:	48 b8 68 5c 80 00 00 	movabs $0x805c68,%rax
  8050a7:	00 00 00 
  8050aa:	48 01 d0             	add    %rdx,%rax
  8050ad:	48 8b 00             	mov    (%rax),%rax
  8050b0:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  8050b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8050b7:	e9 94 00 00 00       	jmpq   805150 <inet_aton+0x2a5>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  8050bc:	81 7d fc ff ff ff 00 	cmpl   $0xffffff,-0x4(%rbp)
  8050c3:	76 0a                	jbe    8050cf <inet_aton+0x224>
      return (0);
  8050c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8050ca:	e9 81 00 00 00       	jmpq   805150 <inet_aton+0x2a5>
    val |= parts[0] << 24;
  8050cf:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8050d2:	c1 e0 18             	shl    $0x18,%eax
  8050d5:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8050d8:	eb 53                	jmp    80512d <inet_aton+0x282>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  8050da:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%rbp)
  8050e1:	76 07                	jbe    8050ea <inet_aton+0x23f>
      return (0);
  8050e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8050e8:	eb 66                	jmp    805150 <inet_aton+0x2a5>
    val |= (parts[0] << 24) | (parts[1] << 16);
  8050ea:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8050ed:	c1 e0 18             	shl    $0x18,%eax
  8050f0:	89 c2                	mov    %eax,%edx
  8050f2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8050f5:	c1 e0 10             	shl    $0x10,%eax
  8050f8:	09 d0                	or     %edx,%eax
  8050fa:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8050fd:	eb 2e                	jmp    80512d <inet_aton+0x282>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  8050ff:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
  805106:	76 07                	jbe    80510f <inet_aton+0x264>
      return (0);
  805108:	b8 00 00 00 00       	mov    $0x0,%eax
  80510d:	eb 41                	jmp    805150 <inet_aton+0x2a5>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  80510f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  805112:	c1 e0 18             	shl    $0x18,%eax
  805115:	89 c2                	mov    %eax,%edx
  805117:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80511a:	c1 e0 10             	shl    $0x10,%eax
  80511d:	09 c2                	or     %eax,%edx
  80511f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  805122:	c1 e0 08             	shl    $0x8,%eax
  805125:	09 d0                	or     %edx,%eax
  805127:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80512a:	eb 01                	jmp    80512d <inet_aton+0x282>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  80512c:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  80512d:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  805132:	74 17                	je     80514b <inet_aton+0x2a0>
    addr->s_addr = htonl(val);
  805134:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805137:	89 c7                	mov    %eax,%edi
  805139:	48 b8 c9 52 80 00 00 	movabs $0x8052c9,%rax
  805140:	00 00 00 
  805143:	ff d0                	callq  *%rax
  805145:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  805149:	89 02                	mov    %eax,(%rdx)
  return (1);
  80514b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  805150:	c9                   	leaveq 
  805151:	c3                   	retq   

0000000000805152 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  805152:	55                   	push   %rbp
  805153:	48 89 e5             	mov    %rsp,%rbp
  805156:	48 83 ec 30          	sub    $0x30,%rsp
  80515a:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80515d:	8b 45 d0             	mov    -0x30(%rbp),%eax
  805160:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  805163:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80516a:	00 00 00 
  80516d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  805171:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  805175:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  805179:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  80517d:	e9 e0 00 00 00       	jmpq   805262 <inet_ntoa+0x110>
    i = 0;
  805182:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  805186:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80518a:	0f b6 08             	movzbl (%rax),%ecx
  80518d:	0f b6 d1             	movzbl %cl,%edx
  805190:	89 d0                	mov    %edx,%eax
  805192:	c1 e0 02             	shl    $0x2,%eax
  805195:	01 d0                	add    %edx,%eax
  805197:	c1 e0 03             	shl    $0x3,%eax
  80519a:	01 d0                	add    %edx,%eax
  80519c:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8051a3:	01 d0                	add    %edx,%eax
  8051a5:	66 c1 e8 08          	shr    $0x8,%ax
  8051a9:	c0 e8 03             	shr    $0x3,%al
  8051ac:	88 45 ed             	mov    %al,-0x13(%rbp)
  8051af:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  8051b3:	89 d0                	mov    %edx,%eax
  8051b5:	c1 e0 02             	shl    $0x2,%eax
  8051b8:	01 d0                	add    %edx,%eax
  8051ba:	01 c0                	add    %eax,%eax
  8051bc:	29 c1                	sub    %eax,%ecx
  8051be:	89 c8                	mov    %ecx,%eax
  8051c0:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  8051c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8051c7:	0f b6 00             	movzbl (%rax),%eax
  8051ca:	0f b6 d0             	movzbl %al,%edx
  8051cd:	89 d0                	mov    %edx,%eax
  8051cf:	c1 e0 02             	shl    $0x2,%eax
  8051d2:	01 d0                	add    %edx,%eax
  8051d4:	c1 e0 03             	shl    $0x3,%eax
  8051d7:	01 d0                	add    %edx,%eax
  8051d9:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8051e0:	01 d0                	add    %edx,%eax
  8051e2:	66 c1 e8 08          	shr    $0x8,%ax
  8051e6:	89 c2                	mov    %eax,%edx
  8051e8:	c0 ea 03             	shr    $0x3,%dl
  8051eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8051ef:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  8051f1:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  8051f5:	8d 50 01             	lea    0x1(%rax),%edx
  8051f8:	88 55 ee             	mov    %dl,-0x12(%rbp)
  8051fb:	0f b6 c0             	movzbl %al,%eax
  8051fe:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  805202:	83 c2 30             	add    $0x30,%edx
  805205:	48 98                	cltq   
  805207:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    } while(*ap);
  80520b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80520f:	0f b6 00             	movzbl (%rax),%eax
  805212:	84 c0                	test   %al,%al
  805214:	0f 85 6c ff ff ff    	jne    805186 <inet_ntoa+0x34>
    while(i--)
  80521a:	eb 1a                	jmp    805236 <inet_ntoa+0xe4>
      *rp++ = inv[i];
  80521c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805220:	48 8d 50 01          	lea    0x1(%rax),%rdx
  805224:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  805228:	0f b6 55 ee          	movzbl -0x12(%rbp),%edx
  80522c:	48 63 d2             	movslq %edx,%rdx
  80522f:	0f b6 54 15 e0       	movzbl -0x20(%rbp,%rdx,1),%edx
  805234:	88 10                	mov    %dl,(%rax)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  805236:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  80523a:	8d 50 ff             	lea    -0x1(%rax),%edx
  80523d:	88 55 ee             	mov    %dl,-0x12(%rbp)
  805240:	84 c0                	test   %al,%al
  805242:	75 d8                	jne    80521c <inet_ntoa+0xca>
      *rp++ = inv[i];
    *rp++ = '.';
  805244:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805248:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80524c:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  805250:	c6 00 2e             	movb   $0x2e,(%rax)
    ap++;
  805253:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  805258:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80525c:	83 c0 01             	add    $0x1,%eax
  80525f:	88 45 ef             	mov    %al,-0x11(%rbp)
  805262:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  805266:	0f 86 16 ff ff ff    	jbe    805182 <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  80526c:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  805271:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805275:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  805278:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80527f:	00 00 00 
}
  805282:	c9                   	leaveq 
  805283:	c3                   	retq   

0000000000805284 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  805284:	55                   	push   %rbp
  805285:	48 89 e5             	mov    %rsp,%rbp
  805288:	48 83 ec 04          	sub    $0x4,%rsp
  80528c:	89 f8                	mov    %edi,%eax
  80528e:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  805292:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  805296:	c1 e0 08             	shl    $0x8,%eax
  805299:	89 c2                	mov    %eax,%edx
  80529b:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  80529f:	66 c1 e8 08          	shr    $0x8,%ax
  8052a3:	09 d0                	or     %edx,%eax
}
  8052a5:	c9                   	leaveq 
  8052a6:	c3                   	retq   

00000000008052a7 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8052a7:	55                   	push   %rbp
  8052a8:	48 89 e5             	mov    %rsp,%rbp
  8052ab:	48 83 ec 08          	sub    $0x8,%rsp
  8052af:	89 f8                	mov    %edi,%eax
  8052b1:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  8052b5:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8052b9:	89 c7                	mov    %eax,%edi
  8052bb:	48 b8 84 52 80 00 00 	movabs $0x805284,%rax
  8052c2:	00 00 00 
  8052c5:	ff d0                	callq  *%rax
}
  8052c7:	c9                   	leaveq 
  8052c8:	c3                   	retq   

00000000008052c9 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8052c9:	55                   	push   %rbp
  8052ca:	48 89 e5             	mov    %rsp,%rbp
  8052cd:	48 83 ec 04          	sub    $0x4,%rsp
  8052d1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  8052d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8052d7:	c1 e0 18             	shl    $0x18,%eax
  8052da:	89 c2                	mov    %eax,%edx
    ((n & 0xff00) << 8) |
  8052dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8052df:	25 00 ff 00 00       	and    $0xff00,%eax
  8052e4:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8052e7:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  8052e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8052ec:	25 00 00 ff 00       	and    $0xff0000,%eax
  8052f1:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8052f5:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8052f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8052fa:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8052fd:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  8052ff:	c9                   	leaveq 
  805300:	c3                   	retq   

0000000000805301 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  805301:	55                   	push   %rbp
  805302:	48 89 e5             	mov    %rsp,%rbp
  805305:	48 83 ec 08          	sub    $0x8,%rsp
  805309:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  80530c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80530f:	89 c7                	mov    %eax,%edi
  805311:	48 b8 c9 52 80 00 00 	movabs $0x8052c9,%rax
  805318:	00 00 00 
  80531b:	ff d0                	callq  *%rax
}
  80531d:	c9                   	leaveq 
  80531e:	c3                   	retq   
