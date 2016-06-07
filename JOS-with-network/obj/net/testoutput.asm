
obj/net/testoutput:     file format elf64-x86-64


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
  80003c:	e8 a8 03 00 00       	callq  8003e9 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


    void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 83 ec 28          	sub    $0x28,%rsp
  80004c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80004f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    envid_t ns_envid = sys_getenvid();
  800053:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  80005a:	00 00 00 
  80005d:	ff d0                	callq  *%rax
  80005f:	89 45 e8             	mov    %eax,-0x18(%rbp)
    int i, r;

    binaryname = "testoutput";
  800062:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800069:	00 00 00 
  80006c:	48 bb e0 49 80 00 00 	movabs $0x8049e0,%rbx
  800073:	00 00 00 
  800076:	48 89 18             	mov    %rbx,(%rax)

    output_envid = fork();
  800079:	48 b8 d4 22 80 00 00 	movabs $0x8022d4,%rax
  800080:	00 00 00 
  800083:	ff d0                	callq  *%rax
  800085:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80008c:	00 00 00 
  80008f:	89 02                	mov    %eax,(%rdx)
    if (output_envid < 0)
  800091:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800098:	00 00 00 
  80009b:	8b 00                	mov    (%rax),%eax
  80009d:	85 c0                	test   %eax,%eax
  80009f:	79 2a                	jns    8000cb <umain+0x88>
        panic("error forking");
  8000a1:	48 ba eb 49 80 00 00 	movabs $0x8049eb,%rdx
  8000a8:	00 00 00 
  8000ab:	be 16 00 00 00       	mov    $0x16,%esi
  8000b0:	48 bf f9 49 80 00 00 	movabs $0x8049f9,%rdi
  8000b7:	00 00 00 
  8000ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bf:	48 b9 97 04 80 00 00 	movabs $0x800497,%rcx
  8000c6:	00 00 00 
  8000c9:	ff d1                	callq  *%rcx
    else if (output_envid == 0) {
  8000cb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8000d2:	00 00 00 
  8000d5:	8b 00                	mov    (%rax),%eax
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	75 16                	jne    8000f1 <umain+0xae>
        output(ns_envid);
  8000db:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8000de:	89 c7                	mov    %eax,%edi
  8000e0:	48 b8 8d 03 80 00 00 	movabs $0x80038d,%rax
  8000e7:	00 00 00 
  8000ea:	ff d0                	callq  *%rax
        return;
  8000ec:	e9 50 01 00 00       	jmpq   800241 <umain+0x1fe>
    }

    for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  8000f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8000f8:	e9 1b 01 00 00       	jmpq   800218 <umain+0x1d5>
        if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  8000fd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800104:	00 00 00 
  800107:	48 8b 00             	mov    (%rax),%rax
  80010a:	ba 07 00 00 00       	mov    $0x7,%edx
  80010f:	48 89 c6             	mov    %rax,%rsi
  800112:	bf 00 00 00 00       	mov    $0x0,%edi
  800117:	48 b8 b4 1b 80 00 00 	movabs $0x801bb4,%rax
  80011e:	00 00 00 
  800121:	ff d0                	callq  *%rax
  800123:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  800126:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80012a:	79 30                	jns    80015c <umain+0x119>
            panic("sys_page_alloc: %e", r);
  80012c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80012f:	89 c1                	mov    %eax,%ecx
  800131:	48 ba 0a 4a 80 00 00 	movabs $0x804a0a,%rdx
  800138:	00 00 00 
  80013b:	be 1e 00 00 00       	mov    $0x1e,%esi
  800140:	48 bf f9 49 80 00 00 	movabs $0x8049f9,%rdi
  800147:	00 00 00 
  80014a:	b8 00 00 00 00       	mov    $0x0,%eax
  80014f:	49 b8 97 04 80 00 00 	movabs $0x800497,%r8
  800156:	00 00 00 
  800159:	41 ff d0             	callq  *%r8
        pkt->jp_len = snprintf(pkt->jp_data,
  80015c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800163:	00 00 00 
  800166:	48 8b 18             	mov    (%rax),%rbx
  800169:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800170:	00 00 00 
  800173:	48 8b 00             	mov    (%rax),%rax
  800176:	48 8d 78 04          	lea    0x4(%rax),%rdi
  80017a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80017d:	89 c1                	mov    %eax,%ecx
  80017f:	48 ba 1d 4a 80 00 00 	movabs $0x804a1d,%rdx
  800186:	00 00 00 
  800189:	be fc 0f 00 00       	mov    $0xffc,%esi
  80018e:	b8 00 00 00 00       	mov    $0x0,%eax
  800193:	49 b8 38 11 80 00 00 	movabs $0x801138,%r8
  80019a:	00 00 00 
  80019d:	41 ff d0             	callq  *%r8
  8001a0:	89 03                	mov    %eax,(%rbx)
                PGSIZE - sizeof(pkt->jp_len),
                "Packet %02d", i);
        cprintf("Transmitting packet %d\n", i);
  8001a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001a5:	89 c6                	mov    %eax,%esi
  8001a7:	48 bf 29 4a 80 00 00 	movabs $0x804a29,%rdi
  8001ae:	00 00 00 
  8001b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b6:	48 ba d0 06 80 00 00 	movabs $0x8006d0,%rdx
  8001bd:	00 00 00 
  8001c0:	ff d2                	callq  *%rdx
        ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8001c2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8001c9:	00 00 00 
  8001cc:	48 8b 10             	mov    (%rax),%rdx
  8001cf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8001d6:	00 00 00 
  8001d9:	8b 00                	mov    (%rax),%eax
  8001db:	b9 07 00 00 00       	mov    $0x7,%ecx
  8001e0:	be 0b 00 00 00       	mov    $0xb,%esi
  8001e5:	89 c7                	mov    %eax,%edi
  8001e7:	48 b8 8b 26 80 00 00 	movabs $0x80268b,%rax
  8001ee:	00 00 00 
  8001f1:	ff d0                	callq  *%rax
        sys_page_unmap(0, pkt);
  8001f3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8001fa:	00 00 00 
  8001fd:	48 8b 00             	mov    (%rax),%rax
  800200:	48 89 c6             	mov    %rax,%rsi
  800203:	bf 00 00 00 00       	mov    $0x0,%edi
  800208:	48 b8 5f 1c 80 00 00 	movabs $0x801c5f,%rax
  80020f:	00 00 00 
  800212:	ff d0                	callq  *%rax
    else if (output_envid == 0) {
        output(ns_envid);
        return;
    }

    for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  800214:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  800218:	83 7d ec 09          	cmpl   $0x9,-0x14(%rbp)
  80021c:	0f 8e db fe ff ff    	jle    8000fd <umain+0xba>
        ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
        sys_page_unmap(0, pkt);
    }

    // Spin for a while, just in case IPC's or packets need to be flushed
    for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  800222:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  800229:	eb 10                	jmp    80023b <umain+0x1f8>
        sys_yield();
  80022b:	48 b8 76 1b 80 00 00 	movabs $0x801b76,%rax
  800232:	00 00 00 
  800235:	ff d0                	callq  *%rax
        ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
        sys_page_unmap(0, pkt);
    }

    // Spin for a while, just in case IPC's or packets need to be flushed
    for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  800237:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  80023b:	83 7d ec 13          	cmpl   $0x13,-0x14(%rbp)
  80023f:	7e ea                	jle    80022b <umain+0x1e8>
        sys_yield();
}
  800241:	48 83 c4 28          	add    $0x28,%rsp
  800245:	5b                   	pop    %rbx
  800246:	5d                   	pop    %rbp
  800247:	c3                   	retq   

0000000000800248 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800248:	55                   	push   %rbp
  800249:	48 89 e5             	mov    %rsp,%rbp
  80024c:	53                   	push   %rbx
  80024d:	48 83 ec 28          	sub    $0x28,%rsp
  800251:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800254:	89 75 d8             	mov    %esi,-0x28(%rbp)
    int r;
    uint32_t stop = sys_time_msec() + initial_to;
  800257:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  80025e:	00 00 00 
  800261:	ff d0                	callq  *%rax
  800263:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800266:	01 d0                	add    %edx,%eax
  800268:	89 45 ec             	mov    %eax,-0x14(%rbp)

    binaryname = "ns_timer";
  80026b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800272:	00 00 00 
  800275:	48 bb 48 4a 80 00 00 	movabs $0x804a48,%rbx
  80027c:	00 00 00 
  80027f:	48 89 18             	mov    %rbx,(%rax)

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800282:	eb 0c                	jmp    800290 <timer+0x48>
            sys_yield();
  800284:	48 b8 76 1b 80 00 00 	movabs $0x801b76,%rax
  80028b:	00 00 00 
  80028e:	ff d0                	callq  *%rax
    uint32_t stop = sys_time_msec() + initial_to;

    binaryname = "ns_timer";

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800290:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  800297:	00 00 00 
  80029a:	ff d0                	callq  *%rax
  80029c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80029f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002a2:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8002a5:	73 06                	jae    8002ad <timer+0x65>
  8002a7:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002ab:	79 d7                	jns    800284 <timer+0x3c>
            sys_yield();
        }
        if (r < 0)
  8002ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002b1:	79 30                	jns    8002e3 <timer+0x9b>
            panic("sys_time_msec: %e", r);
  8002b3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002b6:	89 c1                	mov    %eax,%ecx
  8002b8:	48 ba 51 4a 80 00 00 	movabs $0x804a51,%rdx
  8002bf:	00 00 00 
  8002c2:	be 0f 00 00 00       	mov    $0xf,%esi
  8002c7:	48 bf 63 4a 80 00 00 	movabs $0x804a63,%rdi
  8002ce:	00 00 00 
  8002d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d6:	49 b8 97 04 80 00 00 	movabs $0x800497,%r8
  8002dd:	00 00 00 
  8002e0:	41 ff d0             	callq  *%r8

        ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8002e3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8002e6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f0:	be 0c 00 00 00       	mov    $0xc,%esi
  8002f5:	89 c7                	mov    %eax,%edi
  8002f7:	48 b8 8b 26 80 00 00 	movabs $0x80268b,%rax
  8002fe:	00 00 00 
  800301:	ff d0                	callq  *%rax

        while (1) {
            uint32_t to, whom;
            to = ipc_recv((int32_t *) &whom, 0, 0);
  800303:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800307:	ba 00 00 00 00       	mov    $0x0,%edx
  80030c:	be 00 00 00 00       	mov    $0x0,%esi
  800311:	48 89 c7             	mov    %rax,%rdi
  800314:	48 b8 85 25 80 00 00 	movabs $0x802585,%rax
  80031b:	00 00 00 
  80031e:	ff d0                	callq  *%rax
  800320:	89 45 e4             	mov    %eax,-0x1c(%rbp)

            if (whom != ns_envid) {
  800323:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800326:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800329:	39 c2                	cmp    %eax,%edx
  80032b:	74 22                	je     80034f <timer+0x107>
                cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  80032d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800330:	89 c6                	mov    %eax,%esi
  800332:	48 bf 70 4a 80 00 00 	movabs $0x804a70,%rdi
  800339:	00 00 00 
  80033c:	b8 00 00 00 00       	mov    $0x0,%eax
  800341:	48 ba d0 06 80 00 00 	movabs $0x8006d0,%rdx
  800348:	00 00 00 
  80034b:	ff d2                	callq  *%rdx
                continue;
            }

            stop = sys_time_msec() + to;
            break;
        }
  80034d:	eb b4                	jmp    800303 <timer+0xbb>
            if (whom != ns_envid) {
                cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
                continue;
            }

            stop = sys_time_msec() + to;
  80034f:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  800356:	00 00 00 
  800359:	ff d0                	callq  *%rax
  80035b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80035e:	01 d0                	add    %edx,%eax
  800360:	89 45 ec             	mov    %eax,-0x14(%rbp)
            break;
        }
    }
  800363:	90                   	nop
    uint32_t stop = sys_time_msec() + initial_to;

    binaryname = "ns_timer";

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800364:	e9 27 ff ff ff       	jmpq   800290 <timer+0x48>

0000000000800369 <input>:

extern union Nsipc nsipcbuf;

    void
input(envid_t ns_envid)
{
  800369:	55                   	push   %rbp
  80036a:	48 89 e5             	mov    %rsp,%rbp
  80036d:	48 83 ec 04          	sub    $0x4,%rsp
  800371:	89 7d fc             	mov    %edi,-0x4(%rbp)
    binaryname = "ns_input";
  800374:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80037b:	00 00 00 
  80037e:	48 ba ab 4a 80 00 00 	movabs $0x804aab,%rdx
  800385:	00 00 00 
  800388:	48 89 10             	mov    %rdx,(%rax)
    // 	- read a packet from the device driver
    //	- send it to the network server
    // Hint: When you IPC a page to the network server, it will be
    // reading from it for a while, so don't immediately receive
    // another packet in to the same physical page.
}
  80038b:	c9                   	leaveq 
  80038c:	c3                   	retq   

000000000080038d <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  80038d:	55                   	push   %rbp
  80038e:	48 89 e5             	mov    %rsp,%rbp
  800391:	48 83 ec 20          	sub    $0x20,%rsp
  800395:	89 7d ec             	mov    %edi,-0x14(%rbp)
    binaryname = "ns_output";
  800398:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80039f:	00 00 00 
  8003a2:	48 ba b4 4a 80 00 00 	movabs $0x804ab4,%rdx
  8003a9:	00 00 00 
  8003ac:	48 89 10             	mov    %rdx,(%rax)

    // LAB 6: Your code here:
    // 	- read a packet from the network server
    //	- send the packet to the device driver
	void* buf = NULL;
  8003af:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8003b6:	00 
	size_t len = 0;
  8003b7:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8003be:	00 
	sys_net_tx((void*)nsipcbuf.send.req_buf, nsipcbuf.send.req_size);
  8003bf:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8003c6:	00 00 00 
  8003c9:	8b 40 04             	mov    0x4(%rax),%eax
  8003cc:	48 98                	cltq   
  8003ce:	48 89 c6             	mov    %rax,%rsi
  8003d1:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  8003d8:	00 00 00 
  8003db:	48 b8 21 1e 80 00 00 	movabs $0x801e21,%rax
  8003e2:	00 00 00 
  8003e5:	ff d0                	callq  *%rax
}
  8003e7:	c9                   	leaveq 
  8003e8:	c3                   	retq   

00000000008003e9 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8003e9:	55                   	push   %rbp
  8003ea:	48 89 e5             	mov    %rsp,%rbp
  8003ed:	48 83 ec 10          	sub    $0x10,%rsp
  8003f1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8003f8:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  8003ff:	00 00 00 
  800402:	ff d0                	callq  *%rax
  800404:	25 ff 03 00 00       	and    $0x3ff,%eax
  800409:	48 63 d0             	movslq %eax,%rdx
  80040c:	48 89 d0             	mov    %rdx,%rax
  80040f:	48 c1 e0 03          	shl    $0x3,%rax
  800413:	48 01 d0             	add    %rdx,%rax
  800416:	48 c1 e0 05          	shl    $0x5,%rax
  80041a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800421:	00 00 00 
  800424:	48 01 c2             	add    %rax,%rdx
  800427:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80042e:	00 00 00 
  800431:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800434:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800438:	7e 14                	jle    80044e <libmain+0x65>
		binaryname = argv[0];
  80043a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80043e:	48 8b 10             	mov    (%rax),%rdx
  800441:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800448:	00 00 00 
  80044b:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80044e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800452:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800455:	48 89 d6             	mov    %rdx,%rsi
  800458:	89 c7                	mov    %eax,%edi
  80045a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800461:	00 00 00 
  800464:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800466:	48 b8 74 04 80 00 00 	movabs $0x800474,%rax
  80046d:	00 00 00 
  800470:	ff d0                	callq  *%rax
}
  800472:	c9                   	leaveq 
  800473:	c3                   	retq   

0000000000800474 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800474:	55                   	push   %rbp
  800475:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800478:	48 b8 b0 2a 80 00 00 	movabs $0x802ab0,%rax
  80047f:	00 00 00 
  800482:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800484:	bf 00 00 00 00       	mov    $0x0,%edi
  800489:	48 b8 f4 1a 80 00 00 	movabs $0x801af4,%rax
  800490:	00 00 00 
  800493:	ff d0                	callq  *%rax

}
  800495:	5d                   	pop    %rbp
  800496:	c3                   	retq   

0000000000800497 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800497:	55                   	push   %rbp
  800498:	48 89 e5             	mov    %rsp,%rbp
  80049b:	53                   	push   %rbx
  80049c:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8004a3:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8004aa:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8004b0:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8004b7:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8004be:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8004c5:	84 c0                	test   %al,%al
  8004c7:	74 23                	je     8004ec <_panic+0x55>
  8004c9:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8004d0:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8004d4:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8004d8:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8004dc:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8004e0:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8004e4:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8004e8:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8004ec:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8004f3:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8004fa:	00 00 00 
  8004fd:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800504:	00 00 00 
  800507:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80050b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800512:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800519:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800520:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800527:	00 00 00 
  80052a:	48 8b 18             	mov    (%rax),%rbx
  80052d:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  800534:	00 00 00 
  800537:	ff d0                	callq  *%rax
  800539:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80053f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800546:	41 89 c8             	mov    %ecx,%r8d
  800549:	48 89 d1             	mov    %rdx,%rcx
  80054c:	48 89 da             	mov    %rbx,%rdx
  80054f:	89 c6                	mov    %eax,%esi
  800551:	48 bf c8 4a 80 00 00 	movabs $0x804ac8,%rdi
  800558:	00 00 00 
  80055b:	b8 00 00 00 00       	mov    $0x0,%eax
  800560:	49 b9 d0 06 80 00 00 	movabs $0x8006d0,%r9
  800567:	00 00 00 
  80056a:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80056d:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800574:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80057b:	48 89 d6             	mov    %rdx,%rsi
  80057e:	48 89 c7             	mov    %rax,%rdi
  800581:	48 b8 24 06 80 00 00 	movabs $0x800624,%rax
  800588:	00 00 00 
  80058b:	ff d0                	callq  *%rax
	cprintf("\n");
  80058d:	48 bf eb 4a 80 00 00 	movabs $0x804aeb,%rdi
  800594:	00 00 00 
  800597:	b8 00 00 00 00       	mov    $0x0,%eax
  80059c:	48 ba d0 06 80 00 00 	movabs $0x8006d0,%rdx
  8005a3:	00 00 00 
  8005a6:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005a8:	cc                   	int3   
  8005a9:	eb fd                	jmp    8005a8 <_panic+0x111>

00000000008005ab <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8005ab:	55                   	push   %rbp
  8005ac:	48 89 e5             	mov    %rsp,%rbp
  8005af:	48 83 ec 10          	sub    $0x10,%rsp
  8005b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8005b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8005ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005be:	8b 00                	mov    (%rax),%eax
  8005c0:	8d 48 01             	lea    0x1(%rax),%ecx
  8005c3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005c7:	89 0a                	mov    %ecx,(%rdx)
  8005c9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8005cc:	89 d1                	mov    %edx,%ecx
  8005ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005d2:	48 98                	cltq   
  8005d4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8005d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005dc:	8b 00                	mov    (%rax),%eax
  8005de:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005e3:	75 2c                	jne    800611 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8005e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005e9:	8b 00                	mov    (%rax),%eax
  8005eb:	48 98                	cltq   
  8005ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005f1:	48 83 c2 08          	add    $0x8,%rdx
  8005f5:	48 89 c6             	mov    %rax,%rsi
  8005f8:	48 89 d7             	mov    %rdx,%rdi
  8005fb:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  800602:	00 00 00 
  800605:	ff d0                	callq  *%rax
        b->idx = 0;
  800607:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80060b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800611:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800615:	8b 40 04             	mov    0x4(%rax),%eax
  800618:	8d 50 01             	lea    0x1(%rax),%edx
  80061b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80061f:	89 50 04             	mov    %edx,0x4(%rax)
}
  800622:	c9                   	leaveq 
  800623:	c3                   	retq   

0000000000800624 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800624:	55                   	push   %rbp
  800625:	48 89 e5             	mov    %rsp,%rbp
  800628:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80062f:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800636:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80063d:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800644:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80064b:	48 8b 0a             	mov    (%rdx),%rcx
  80064e:	48 89 08             	mov    %rcx,(%rax)
  800651:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800655:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800659:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80065d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800661:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800668:	00 00 00 
    b.cnt = 0;
  80066b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800672:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800675:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80067c:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800683:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80068a:	48 89 c6             	mov    %rax,%rsi
  80068d:	48 bf ab 05 80 00 00 	movabs $0x8005ab,%rdi
  800694:	00 00 00 
  800697:	48 b8 83 0a 80 00 00 	movabs $0x800a83,%rax
  80069e:	00 00 00 
  8006a1:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8006a3:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8006a9:	48 98                	cltq   
  8006ab:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8006b2:	48 83 c2 08          	add    $0x8,%rdx
  8006b6:	48 89 c6             	mov    %rax,%rsi
  8006b9:	48 89 d7             	mov    %rdx,%rdi
  8006bc:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  8006c3:	00 00 00 
  8006c6:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8006c8:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8006ce:	c9                   	leaveq 
  8006cf:	c3                   	retq   

00000000008006d0 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8006d0:	55                   	push   %rbp
  8006d1:	48 89 e5             	mov    %rsp,%rbp
  8006d4:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8006db:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8006e2:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8006e9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8006f0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8006f7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8006fe:	84 c0                	test   %al,%al
  800700:	74 20                	je     800722 <cprintf+0x52>
  800702:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800706:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80070a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80070e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800712:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800716:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80071a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80071e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800722:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800729:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800730:	00 00 00 
  800733:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80073a:	00 00 00 
  80073d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800741:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800748:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80074f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800756:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80075d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800764:	48 8b 0a             	mov    (%rdx),%rcx
  800767:	48 89 08             	mov    %rcx,(%rax)
  80076a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80076e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800772:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800776:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80077a:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800781:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800788:	48 89 d6             	mov    %rdx,%rsi
  80078b:	48 89 c7             	mov    %rax,%rdi
  80078e:	48 b8 24 06 80 00 00 	movabs $0x800624,%rax
  800795:	00 00 00 
  800798:	ff d0                	callq  *%rax
  80079a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8007a0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8007a6:	c9                   	leaveq 
  8007a7:	c3                   	retq   

00000000008007a8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007a8:	55                   	push   %rbp
  8007a9:	48 89 e5             	mov    %rsp,%rbp
  8007ac:	53                   	push   %rbx
  8007ad:	48 83 ec 38          	sub    $0x38,%rsp
  8007b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8007b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8007bd:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8007c0:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8007c4:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007c8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8007cb:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8007cf:	77 3b                	ja     80080c <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007d1:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8007d4:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8007d8:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8007db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007df:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e4:	48 f7 f3             	div    %rbx
  8007e7:	48 89 c2             	mov    %rax,%rdx
  8007ea:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8007ed:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8007f0:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8007f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f8:	41 89 f9             	mov    %edi,%r9d
  8007fb:	48 89 c7             	mov    %rax,%rdi
  8007fe:	48 b8 a8 07 80 00 00 	movabs $0x8007a8,%rax
  800805:	00 00 00 
  800808:	ff d0                	callq  *%rax
  80080a:	eb 1e                	jmp    80082a <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80080c:	eb 12                	jmp    800820 <printnum+0x78>
			putch(padc, putdat);
  80080e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800812:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800815:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800819:	48 89 ce             	mov    %rcx,%rsi
  80081c:	89 d7                	mov    %edx,%edi
  80081e:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800820:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800824:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800828:	7f e4                	jg     80080e <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80082a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80082d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800831:	ba 00 00 00 00       	mov    $0x0,%edx
  800836:	48 f7 f1             	div    %rcx
  800839:	48 89 d0             	mov    %rdx,%rax
  80083c:	48 ba f0 4c 80 00 00 	movabs $0x804cf0,%rdx
  800843:	00 00 00 
  800846:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80084a:	0f be d0             	movsbl %al,%edx
  80084d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800851:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800855:	48 89 ce             	mov    %rcx,%rsi
  800858:	89 d7                	mov    %edx,%edi
  80085a:	ff d0                	callq  *%rax
}
  80085c:	48 83 c4 38          	add    $0x38,%rsp
  800860:	5b                   	pop    %rbx
  800861:	5d                   	pop    %rbp
  800862:	c3                   	retq   

0000000000800863 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800863:	55                   	push   %rbp
  800864:	48 89 e5             	mov    %rsp,%rbp
  800867:	48 83 ec 1c          	sub    $0x1c,%rsp
  80086b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80086f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800872:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800876:	7e 52                	jle    8008ca <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800878:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087c:	8b 00                	mov    (%rax),%eax
  80087e:	83 f8 30             	cmp    $0x30,%eax
  800881:	73 24                	jae    8008a7 <getuint+0x44>
  800883:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800887:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80088b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088f:	8b 00                	mov    (%rax),%eax
  800891:	89 c0                	mov    %eax,%eax
  800893:	48 01 d0             	add    %rdx,%rax
  800896:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80089a:	8b 12                	mov    (%rdx),%edx
  80089c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80089f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a3:	89 0a                	mov    %ecx,(%rdx)
  8008a5:	eb 17                	jmp    8008be <getuint+0x5b>
  8008a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ab:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008af:	48 89 d0             	mov    %rdx,%rax
  8008b2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ba:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008be:	48 8b 00             	mov    (%rax),%rax
  8008c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008c5:	e9 a3 00 00 00       	jmpq   80096d <getuint+0x10a>
	else if (lflag)
  8008ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008ce:	74 4f                	je     80091f <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8008d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d4:	8b 00                	mov    (%rax),%eax
  8008d6:	83 f8 30             	cmp    $0x30,%eax
  8008d9:	73 24                	jae    8008ff <getuint+0x9c>
  8008db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008df:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e7:	8b 00                	mov    (%rax),%eax
  8008e9:	89 c0                	mov    %eax,%eax
  8008eb:	48 01 d0             	add    %rdx,%rax
  8008ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f2:	8b 12                	mov    (%rdx),%edx
  8008f4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008fb:	89 0a                	mov    %ecx,(%rdx)
  8008fd:	eb 17                	jmp    800916 <getuint+0xb3>
  8008ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800903:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800907:	48 89 d0             	mov    %rdx,%rax
  80090a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80090e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800912:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800916:	48 8b 00             	mov    (%rax),%rax
  800919:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80091d:	eb 4e                	jmp    80096d <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80091f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800923:	8b 00                	mov    (%rax),%eax
  800925:	83 f8 30             	cmp    $0x30,%eax
  800928:	73 24                	jae    80094e <getuint+0xeb>
  80092a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800932:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800936:	8b 00                	mov    (%rax),%eax
  800938:	89 c0                	mov    %eax,%eax
  80093a:	48 01 d0             	add    %rdx,%rax
  80093d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800941:	8b 12                	mov    (%rdx),%edx
  800943:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800946:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80094a:	89 0a                	mov    %ecx,(%rdx)
  80094c:	eb 17                	jmp    800965 <getuint+0x102>
  80094e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800952:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800956:	48 89 d0             	mov    %rdx,%rax
  800959:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80095d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800961:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800965:	8b 00                	mov    (%rax),%eax
  800967:	89 c0                	mov    %eax,%eax
  800969:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80096d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800971:	c9                   	leaveq 
  800972:	c3                   	retq   

0000000000800973 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800973:	55                   	push   %rbp
  800974:	48 89 e5             	mov    %rsp,%rbp
  800977:	48 83 ec 1c          	sub    $0x1c,%rsp
  80097b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80097f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800982:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800986:	7e 52                	jle    8009da <getint+0x67>
		x=va_arg(*ap, long long);
  800988:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098c:	8b 00                	mov    (%rax),%eax
  80098e:	83 f8 30             	cmp    $0x30,%eax
  800991:	73 24                	jae    8009b7 <getint+0x44>
  800993:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800997:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80099b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099f:	8b 00                	mov    (%rax),%eax
  8009a1:	89 c0                	mov    %eax,%eax
  8009a3:	48 01 d0             	add    %rdx,%rax
  8009a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009aa:	8b 12                	mov    (%rdx),%edx
  8009ac:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b3:	89 0a                	mov    %ecx,(%rdx)
  8009b5:	eb 17                	jmp    8009ce <getint+0x5b>
  8009b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009bf:	48 89 d0             	mov    %rdx,%rax
  8009c2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ca:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ce:	48 8b 00             	mov    (%rax),%rax
  8009d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009d5:	e9 a3 00 00 00       	jmpq   800a7d <getint+0x10a>
	else if (lflag)
  8009da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8009de:	74 4f                	je     800a2f <getint+0xbc>
		x=va_arg(*ap, long);
  8009e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e4:	8b 00                	mov    (%rax),%eax
  8009e6:	83 f8 30             	cmp    $0x30,%eax
  8009e9:	73 24                	jae    800a0f <getint+0x9c>
  8009eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ef:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f7:	8b 00                	mov    (%rax),%eax
  8009f9:	89 c0                	mov    %eax,%eax
  8009fb:	48 01 d0             	add    %rdx,%rax
  8009fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a02:	8b 12                	mov    (%rdx),%edx
  800a04:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a07:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a0b:	89 0a                	mov    %ecx,(%rdx)
  800a0d:	eb 17                	jmp    800a26 <getint+0xb3>
  800a0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a13:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a17:	48 89 d0             	mov    %rdx,%rax
  800a1a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a1e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a22:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a26:	48 8b 00             	mov    (%rax),%rax
  800a29:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a2d:	eb 4e                	jmp    800a7d <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800a2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a33:	8b 00                	mov    (%rax),%eax
  800a35:	83 f8 30             	cmp    $0x30,%eax
  800a38:	73 24                	jae    800a5e <getint+0xeb>
  800a3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a46:	8b 00                	mov    (%rax),%eax
  800a48:	89 c0                	mov    %eax,%eax
  800a4a:	48 01 d0             	add    %rdx,%rax
  800a4d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a51:	8b 12                	mov    (%rdx),%edx
  800a53:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a56:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a5a:	89 0a                	mov    %ecx,(%rdx)
  800a5c:	eb 17                	jmp    800a75 <getint+0x102>
  800a5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a62:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a66:	48 89 d0             	mov    %rdx,%rax
  800a69:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a6d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a71:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a75:	8b 00                	mov    (%rax),%eax
  800a77:	48 98                	cltq   
  800a79:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a81:	c9                   	leaveq 
  800a82:	c3                   	retq   

0000000000800a83 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a83:	55                   	push   %rbp
  800a84:	48 89 e5             	mov    %rsp,%rbp
  800a87:	41 54                	push   %r12
  800a89:	53                   	push   %rbx
  800a8a:	48 83 ec 60          	sub    $0x60,%rsp
  800a8e:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a92:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a96:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a9a:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a9e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800aa2:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800aa6:	48 8b 0a             	mov    (%rdx),%rcx
  800aa9:	48 89 08             	mov    %rcx,(%rax)
  800aac:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ab0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ab4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ab8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800abc:	eb 17                	jmp    800ad5 <vprintfmt+0x52>
			if (ch == '\0')
  800abe:	85 db                	test   %ebx,%ebx
  800ac0:	0f 84 cc 04 00 00    	je     800f92 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800ac6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ace:	48 89 d6             	mov    %rdx,%rsi
  800ad1:	89 df                	mov    %ebx,%edi
  800ad3:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ad5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ad9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800add:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ae1:	0f b6 00             	movzbl (%rax),%eax
  800ae4:	0f b6 d8             	movzbl %al,%ebx
  800ae7:	83 fb 25             	cmp    $0x25,%ebx
  800aea:	75 d2                	jne    800abe <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800aec:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800af0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800af7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800afe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b05:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b0c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b10:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b14:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b18:	0f b6 00             	movzbl (%rax),%eax
  800b1b:	0f b6 d8             	movzbl %al,%ebx
  800b1e:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b21:	83 f8 55             	cmp    $0x55,%eax
  800b24:	0f 87 34 04 00 00    	ja     800f5e <vprintfmt+0x4db>
  800b2a:	89 c0                	mov    %eax,%eax
  800b2c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b33:	00 
  800b34:	48 b8 18 4d 80 00 00 	movabs $0x804d18,%rax
  800b3b:	00 00 00 
  800b3e:	48 01 d0             	add    %rdx,%rax
  800b41:	48 8b 00             	mov    (%rax),%rax
  800b44:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800b46:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800b4a:	eb c0                	jmp    800b0c <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b4c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800b50:	eb ba                	jmp    800b0c <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b52:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800b59:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800b5c:	89 d0                	mov    %edx,%eax
  800b5e:	c1 e0 02             	shl    $0x2,%eax
  800b61:	01 d0                	add    %edx,%eax
  800b63:	01 c0                	add    %eax,%eax
  800b65:	01 d8                	add    %ebx,%eax
  800b67:	83 e8 30             	sub    $0x30,%eax
  800b6a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b6d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b71:	0f b6 00             	movzbl (%rax),%eax
  800b74:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b77:	83 fb 2f             	cmp    $0x2f,%ebx
  800b7a:	7e 0c                	jle    800b88 <vprintfmt+0x105>
  800b7c:	83 fb 39             	cmp    $0x39,%ebx
  800b7f:	7f 07                	jg     800b88 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b81:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b86:	eb d1                	jmp    800b59 <vprintfmt+0xd6>
			goto process_precision;
  800b88:	eb 58                	jmp    800be2 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800b8a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b8d:	83 f8 30             	cmp    $0x30,%eax
  800b90:	73 17                	jae    800ba9 <vprintfmt+0x126>
  800b92:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b96:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b99:	89 c0                	mov    %eax,%eax
  800b9b:	48 01 d0             	add    %rdx,%rax
  800b9e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ba1:	83 c2 08             	add    $0x8,%edx
  800ba4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ba7:	eb 0f                	jmp    800bb8 <vprintfmt+0x135>
  800ba9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bad:	48 89 d0             	mov    %rdx,%rax
  800bb0:	48 83 c2 08          	add    $0x8,%rdx
  800bb4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bb8:	8b 00                	mov    (%rax),%eax
  800bba:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800bbd:	eb 23                	jmp    800be2 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800bbf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bc3:	79 0c                	jns    800bd1 <vprintfmt+0x14e>
				width = 0;
  800bc5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800bcc:	e9 3b ff ff ff       	jmpq   800b0c <vprintfmt+0x89>
  800bd1:	e9 36 ff ff ff       	jmpq   800b0c <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800bd6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800bdd:	e9 2a ff ff ff       	jmpq   800b0c <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800be2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800be6:	79 12                	jns    800bfa <vprintfmt+0x177>
				width = precision, precision = -1;
  800be8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800beb:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800bee:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800bf5:	e9 12 ff ff ff       	jmpq   800b0c <vprintfmt+0x89>
  800bfa:	e9 0d ff ff ff       	jmpq   800b0c <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800bff:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c03:	e9 04 ff ff ff       	jmpq   800b0c <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c08:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c0b:	83 f8 30             	cmp    $0x30,%eax
  800c0e:	73 17                	jae    800c27 <vprintfmt+0x1a4>
  800c10:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c14:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c17:	89 c0                	mov    %eax,%eax
  800c19:	48 01 d0             	add    %rdx,%rax
  800c1c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c1f:	83 c2 08             	add    $0x8,%edx
  800c22:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c25:	eb 0f                	jmp    800c36 <vprintfmt+0x1b3>
  800c27:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c2b:	48 89 d0             	mov    %rdx,%rax
  800c2e:	48 83 c2 08          	add    $0x8,%rdx
  800c32:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c36:	8b 10                	mov    (%rax),%edx
  800c38:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c40:	48 89 ce             	mov    %rcx,%rsi
  800c43:	89 d7                	mov    %edx,%edi
  800c45:	ff d0                	callq  *%rax
			break;
  800c47:	e9 40 03 00 00       	jmpq   800f8c <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800c4c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c4f:	83 f8 30             	cmp    $0x30,%eax
  800c52:	73 17                	jae    800c6b <vprintfmt+0x1e8>
  800c54:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c58:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c5b:	89 c0                	mov    %eax,%eax
  800c5d:	48 01 d0             	add    %rdx,%rax
  800c60:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c63:	83 c2 08             	add    $0x8,%edx
  800c66:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c69:	eb 0f                	jmp    800c7a <vprintfmt+0x1f7>
  800c6b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c6f:	48 89 d0             	mov    %rdx,%rax
  800c72:	48 83 c2 08          	add    $0x8,%rdx
  800c76:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c7a:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c7c:	85 db                	test   %ebx,%ebx
  800c7e:	79 02                	jns    800c82 <vprintfmt+0x1ff>
				err = -err;
  800c80:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c82:	83 fb 15             	cmp    $0x15,%ebx
  800c85:	7f 16                	jg     800c9d <vprintfmt+0x21a>
  800c87:	48 b8 40 4c 80 00 00 	movabs $0x804c40,%rax
  800c8e:	00 00 00 
  800c91:	48 63 d3             	movslq %ebx,%rdx
  800c94:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c98:	4d 85 e4             	test   %r12,%r12
  800c9b:	75 2e                	jne    800ccb <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800c9d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ca1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca5:	89 d9                	mov    %ebx,%ecx
  800ca7:	48 ba 01 4d 80 00 00 	movabs $0x804d01,%rdx
  800cae:	00 00 00 
  800cb1:	48 89 c7             	mov    %rax,%rdi
  800cb4:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb9:	49 b8 9b 0f 80 00 00 	movabs $0x800f9b,%r8
  800cc0:	00 00 00 
  800cc3:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cc6:	e9 c1 02 00 00       	jmpq   800f8c <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ccb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ccf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd3:	4c 89 e1             	mov    %r12,%rcx
  800cd6:	48 ba 0a 4d 80 00 00 	movabs $0x804d0a,%rdx
  800cdd:	00 00 00 
  800ce0:	48 89 c7             	mov    %rax,%rdi
  800ce3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce8:	49 b8 9b 0f 80 00 00 	movabs $0x800f9b,%r8
  800cef:	00 00 00 
  800cf2:	41 ff d0             	callq  *%r8
			break;
  800cf5:	e9 92 02 00 00       	jmpq   800f8c <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800cfa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cfd:	83 f8 30             	cmp    $0x30,%eax
  800d00:	73 17                	jae    800d19 <vprintfmt+0x296>
  800d02:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d06:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d09:	89 c0                	mov    %eax,%eax
  800d0b:	48 01 d0             	add    %rdx,%rax
  800d0e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d11:	83 c2 08             	add    $0x8,%edx
  800d14:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d17:	eb 0f                	jmp    800d28 <vprintfmt+0x2a5>
  800d19:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d1d:	48 89 d0             	mov    %rdx,%rax
  800d20:	48 83 c2 08          	add    $0x8,%rdx
  800d24:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d28:	4c 8b 20             	mov    (%rax),%r12
  800d2b:	4d 85 e4             	test   %r12,%r12
  800d2e:	75 0a                	jne    800d3a <vprintfmt+0x2b7>
				p = "(null)";
  800d30:	49 bc 0d 4d 80 00 00 	movabs $0x804d0d,%r12
  800d37:	00 00 00 
			if (width > 0 && padc != '-')
  800d3a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d3e:	7e 3f                	jle    800d7f <vprintfmt+0x2fc>
  800d40:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d44:	74 39                	je     800d7f <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d46:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d49:	48 98                	cltq   
  800d4b:	48 89 c6             	mov    %rax,%rsi
  800d4e:	4c 89 e7             	mov    %r12,%rdi
  800d51:	48 b8 47 12 80 00 00 	movabs $0x801247,%rax
  800d58:	00 00 00 
  800d5b:	ff d0                	callq  *%rax
  800d5d:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800d60:	eb 17                	jmp    800d79 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800d62:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800d66:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d6a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d6e:	48 89 ce             	mov    %rcx,%rsi
  800d71:	89 d7                	mov    %edx,%edi
  800d73:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d75:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d79:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d7d:	7f e3                	jg     800d62 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d7f:	eb 37                	jmp    800db8 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800d81:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d85:	74 1e                	je     800da5 <vprintfmt+0x322>
  800d87:	83 fb 1f             	cmp    $0x1f,%ebx
  800d8a:	7e 05                	jle    800d91 <vprintfmt+0x30e>
  800d8c:	83 fb 7e             	cmp    $0x7e,%ebx
  800d8f:	7e 14                	jle    800da5 <vprintfmt+0x322>
					putch('?', putdat);
  800d91:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d95:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d99:	48 89 d6             	mov    %rdx,%rsi
  800d9c:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800da1:	ff d0                	callq  *%rax
  800da3:	eb 0f                	jmp    800db4 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800da5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800da9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dad:	48 89 d6             	mov    %rdx,%rsi
  800db0:	89 df                	mov    %ebx,%edi
  800db2:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800db4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800db8:	4c 89 e0             	mov    %r12,%rax
  800dbb:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800dbf:	0f b6 00             	movzbl (%rax),%eax
  800dc2:	0f be d8             	movsbl %al,%ebx
  800dc5:	85 db                	test   %ebx,%ebx
  800dc7:	74 10                	je     800dd9 <vprintfmt+0x356>
  800dc9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800dcd:	78 b2                	js     800d81 <vprintfmt+0x2fe>
  800dcf:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800dd3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800dd7:	79 a8                	jns    800d81 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dd9:	eb 16                	jmp    800df1 <vprintfmt+0x36e>
				putch(' ', putdat);
  800ddb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ddf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de3:	48 89 d6             	mov    %rdx,%rsi
  800de6:	bf 20 00 00 00       	mov    $0x20,%edi
  800deb:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ded:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800df1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800df5:	7f e4                	jg     800ddb <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800df7:	e9 90 01 00 00       	jmpq   800f8c <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800dfc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e00:	be 03 00 00 00       	mov    $0x3,%esi
  800e05:	48 89 c7             	mov    %rax,%rdi
  800e08:	48 b8 73 09 80 00 00 	movabs $0x800973,%rax
  800e0f:	00 00 00 
  800e12:	ff d0                	callq  *%rax
  800e14:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e1c:	48 85 c0             	test   %rax,%rax
  800e1f:	79 1d                	jns    800e3e <vprintfmt+0x3bb>
				putch('-', putdat);
  800e21:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e25:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e29:	48 89 d6             	mov    %rdx,%rsi
  800e2c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e31:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e37:	48 f7 d8             	neg    %rax
  800e3a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e3e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e45:	e9 d5 00 00 00       	jmpq   800f1f <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800e4a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e4e:	be 03 00 00 00       	mov    $0x3,%esi
  800e53:	48 89 c7             	mov    %rax,%rdi
  800e56:	48 b8 63 08 80 00 00 	movabs $0x800863,%rax
  800e5d:	00 00 00 
  800e60:	ff d0                	callq  *%rax
  800e62:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e66:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e6d:	e9 ad 00 00 00       	jmpq   800f1f <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800e72:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800e75:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e79:	89 d6                	mov    %edx,%esi
  800e7b:	48 89 c7             	mov    %rax,%rdi
  800e7e:	48 b8 73 09 80 00 00 	movabs $0x800973,%rax
  800e85:	00 00 00 
  800e88:	ff d0                	callq  *%rax
  800e8a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800e8e:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800e95:	e9 85 00 00 00       	jmpq   800f1f <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800e9a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e9e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea2:	48 89 d6             	mov    %rdx,%rsi
  800ea5:	bf 30 00 00 00       	mov    $0x30,%edi
  800eaa:	ff d0                	callq  *%rax
			putch('x', putdat);
  800eac:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eb0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eb4:	48 89 d6             	mov    %rdx,%rsi
  800eb7:	bf 78 00 00 00       	mov    $0x78,%edi
  800ebc:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ebe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ec1:	83 f8 30             	cmp    $0x30,%eax
  800ec4:	73 17                	jae    800edd <vprintfmt+0x45a>
  800ec6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800eca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ecd:	89 c0                	mov    %eax,%eax
  800ecf:	48 01 d0             	add    %rdx,%rax
  800ed2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ed5:	83 c2 08             	add    $0x8,%edx
  800ed8:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800edb:	eb 0f                	jmp    800eec <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800edd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ee1:	48 89 d0             	mov    %rdx,%rax
  800ee4:	48 83 c2 08          	add    $0x8,%rdx
  800ee8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800eec:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800eef:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ef3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800efa:	eb 23                	jmp    800f1f <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800efc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f00:	be 03 00 00 00       	mov    $0x3,%esi
  800f05:	48 89 c7             	mov    %rax,%rdi
  800f08:	48 b8 63 08 80 00 00 	movabs $0x800863,%rax
  800f0f:	00 00 00 
  800f12:	ff d0                	callq  *%rax
  800f14:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f18:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f1f:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f24:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f27:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f2a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f2e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f36:	45 89 c1             	mov    %r8d,%r9d
  800f39:	41 89 f8             	mov    %edi,%r8d
  800f3c:	48 89 c7             	mov    %rax,%rdi
  800f3f:	48 b8 a8 07 80 00 00 	movabs $0x8007a8,%rax
  800f46:	00 00 00 
  800f49:	ff d0                	callq  *%rax
			break;
  800f4b:	eb 3f                	jmp    800f8c <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f4d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f51:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f55:	48 89 d6             	mov    %rdx,%rsi
  800f58:	89 df                	mov    %ebx,%edi
  800f5a:	ff d0                	callq  *%rax
			break;
  800f5c:	eb 2e                	jmp    800f8c <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f5e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f62:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f66:	48 89 d6             	mov    %rdx,%rsi
  800f69:	bf 25 00 00 00       	mov    $0x25,%edi
  800f6e:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f70:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f75:	eb 05                	jmp    800f7c <vprintfmt+0x4f9>
  800f77:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f7c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f80:	48 83 e8 01          	sub    $0x1,%rax
  800f84:	0f b6 00             	movzbl (%rax),%eax
  800f87:	3c 25                	cmp    $0x25,%al
  800f89:	75 ec                	jne    800f77 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800f8b:	90                   	nop
		}
	}
  800f8c:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f8d:	e9 43 fb ff ff       	jmpq   800ad5 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f92:	48 83 c4 60          	add    $0x60,%rsp
  800f96:	5b                   	pop    %rbx
  800f97:	41 5c                	pop    %r12
  800f99:	5d                   	pop    %rbp
  800f9a:	c3                   	retq   

0000000000800f9b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f9b:	55                   	push   %rbp
  800f9c:	48 89 e5             	mov    %rsp,%rbp
  800f9f:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800fa6:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800fad:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800fb4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fbb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fc2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fc9:	84 c0                	test   %al,%al
  800fcb:	74 20                	je     800fed <printfmt+0x52>
  800fcd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fd1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fd5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fd9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fdd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fe1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fe5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fe9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fed:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800ff4:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800ffb:	00 00 00 
  800ffe:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801005:	00 00 00 
  801008:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80100c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801013:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80101a:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801021:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801028:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80102f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801036:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80103d:	48 89 c7             	mov    %rax,%rdi
  801040:	48 b8 83 0a 80 00 00 	movabs $0x800a83,%rax
  801047:	00 00 00 
  80104a:	ff d0                	callq  *%rax
	va_end(ap);
}
  80104c:	c9                   	leaveq 
  80104d:	c3                   	retq   

000000000080104e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80104e:	55                   	push   %rbp
  80104f:	48 89 e5             	mov    %rsp,%rbp
  801052:	48 83 ec 10          	sub    $0x10,%rsp
  801056:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801059:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80105d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801061:	8b 40 10             	mov    0x10(%rax),%eax
  801064:	8d 50 01             	lea    0x1(%rax),%edx
  801067:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80106b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80106e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801072:	48 8b 10             	mov    (%rax),%rdx
  801075:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801079:	48 8b 40 08          	mov    0x8(%rax),%rax
  80107d:	48 39 c2             	cmp    %rax,%rdx
  801080:	73 17                	jae    801099 <sprintputch+0x4b>
		*b->buf++ = ch;
  801082:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801086:	48 8b 00             	mov    (%rax),%rax
  801089:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80108d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801091:	48 89 0a             	mov    %rcx,(%rdx)
  801094:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801097:	88 10                	mov    %dl,(%rax)
}
  801099:	c9                   	leaveq 
  80109a:	c3                   	retq   

000000000080109b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80109b:	55                   	push   %rbp
  80109c:	48 89 e5             	mov    %rsp,%rbp
  80109f:	48 83 ec 50          	sub    $0x50,%rsp
  8010a3:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8010a7:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8010aa:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8010ae:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8010b2:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8010b6:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8010ba:	48 8b 0a             	mov    (%rdx),%rcx
  8010bd:	48 89 08             	mov    %rcx,(%rax)
  8010c0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010c4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010c8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010cc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010d0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8010d4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8010d8:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8010db:	48 98                	cltq   
  8010dd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8010e1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8010e5:	48 01 d0             	add    %rdx,%rax
  8010e8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8010ec:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8010f3:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8010f8:	74 06                	je     801100 <vsnprintf+0x65>
  8010fa:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8010fe:	7f 07                	jg     801107 <vsnprintf+0x6c>
		return -E_INVAL;
  801100:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801105:	eb 2f                	jmp    801136 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801107:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80110b:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80110f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801113:	48 89 c6             	mov    %rax,%rsi
  801116:	48 bf 4e 10 80 00 00 	movabs $0x80104e,%rdi
  80111d:	00 00 00 
  801120:	48 b8 83 0a 80 00 00 	movabs $0x800a83,%rax
  801127:	00 00 00 
  80112a:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80112c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801130:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801133:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801136:	c9                   	leaveq 
  801137:	c3                   	retq   

0000000000801138 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801138:	55                   	push   %rbp
  801139:	48 89 e5             	mov    %rsp,%rbp
  80113c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801143:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80114a:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801150:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801157:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80115e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801165:	84 c0                	test   %al,%al
  801167:	74 20                	je     801189 <snprintf+0x51>
  801169:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80116d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801171:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801175:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801179:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80117d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801181:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801185:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801189:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801190:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801197:	00 00 00 
  80119a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8011a1:	00 00 00 
  8011a4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8011a8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8011af:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8011b6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8011bd:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8011c4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8011cb:	48 8b 0a             	mov    (%rdx),%rcx
  8011ce:	48 89 08             	mov    %rcx,(%rax)
  8011d1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011d5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011d9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011dd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8011e1:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8011e8:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8011ef:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8011f5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8011fc:	48 89 c7             	mov    %rax,%rdi
  8011ff:	48 b8 9b 10 80 00 00 	movabs $0x80109b,%rax
  801206:	00 00 00 
  801209:	ff d0                	callq  *%rax
  80120b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801211:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801217:	c9                   	leaveq 
  801218:	c3                   	retq   

0000000000801219 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801219:	55                   	push   %rbp
  80121a:	48 89 e5             	mov    %rsp,%rbp
  80121d:	48 83 ec 18          	sub    $0x18,%rsp
  801221:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801225:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80122c:	eb 09                	jmp    801237 <strlen+0x1e>
		n++;
  80122e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801232:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801237:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80123b:	0f b6 00             	movzbl (%rax),%eax
  80123e:	84 c0                	test   %al,%al
  801240:	75 ec                	jne    80122e <strlen+0x15>
		n++;
	return n;
  801242:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801245:	c9                   	leaveq 
  801246:	c3                   	retq   

0000000000801247 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801247:	55                   	push   %rbp
  801248:	48 89 e5             	mov    %rsp,%rbp
  80124b:	48 83 ec 20          	sub    $0x20,%rsp
  80124f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801253:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801257:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80125e:	eb 0e                	jmp    80126e <strnlen+0x27>
		n++;
  801260:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801264:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801269:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80126e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801273:	74 0b                	je     801280 <strnlen+0x39>
  801275:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801279:	0f b6 00             	movzbl (%rax),%eax
  80127c:	84 c0                	test   %al,%al
  80127e:	75 e0                	jne    801260 <strnlen+0x19>
		n++;
	return n;
  801280:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801283:	c9                   	leaveq 
  801284:	c3                   	retq   

0000000000801285 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801285:	55                   	push   %rbp
  801286:	48 89 e5             	mov    %rsp,%rbp
  801289:	48 83 ec 20          	sub    $0x20,%rsp
  80128d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801291:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801295:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801299:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80129d:	90                   	nop
  80129e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012a6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012aa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012ae:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012b2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012b6:	0f b6 12             	movzbl (%rdx),%edx
  8012b9:	88 10                	mov    %dl,(%rax)
  8012bb:	0f b6 00             	movzbl (%rax),%eax
  8012be:	84 c0                	test   %al,%al
  8012c0:	75 dc                	jne    80129e <strcpy+0x19>
		/* do nothing */;
	return ret;
  8012c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012c6:	c9                   	leaveq 
  8012c7:	c3                   	retq   

00000000008012c8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8012c8:	55                   	push   %rbp
  8012c9:	48 89 e5             	mov    %rsp,%rbp
  8012cc:	48 83 ec 20          	sub    $0x20,%rsp
  8012d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8012d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012dc:	48 89 c7             	mov    %rax,%rdi
  8012df:	48 b8 19 12 80 00 00 	movabs $0x801219,%rax
  8012e6:	00 00 00 
  8012e9:	ff d0                	callq  *%rax
  8012eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8012ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012f1:	48 63 d0             	movslq %eax,%rdx
  8012f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f8:	48 01 c2             	add    %rax,%rdx
  8012fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012ff:	48 89 c6             	mov    %rax,%rsi
  801302:	48 89 d7             	mov    %rdx,%rdi
  801305:	48 b8 85 12 80 00 00 	movabs $0x801285,%rax
  80130c:	00 00 00 
  80130f:	ff d0                	callq  *%rax
	return dst;
  801311:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801315:	c9                   	leaveq 
  801316:	c3                   	retq   

0000000000801317 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801317:	55                   	push   %rbp
  801318:	48 89 e5             	mov    %rsp,%rbp
  80131b:	48 83 ec 28          	sub    $0x28,%rsp
  80131f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801323:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801327:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80132b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801333:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80133a:	00 
  80133b:	eb 2a                	jmp    801367 <strncpy+0x50>
		*dst++ = *src;
  80133d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801341:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801345:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801349:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80134d:	0f b6 12             	movzbl (%rdx),%edx
  801350:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801352:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801356:	0f b6 00             	movzbl (%rax),%eax
  801359:	84 c0                	test   %al,%al
  80135b:	74 05                	je     801362 <strncpy+0x4b>
			src++;
  80135d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801362:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801367:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80136f:	72 cc                	jb     80133d <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801371:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801375:	c9                   	leaveq 
  801376:	c3                   	retq   

0000000000801377 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801377:	55                   	push   %rbp
  801378:	48 89 e5             	mov    %rsp,%rbp
  80137b:	48 83 ec 28          	sub    $0x28,%rsp
  80137f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801383:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801387:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80138b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80138f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801393:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801398:	74 3d                	je     8013d7 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80139a:	eb 1d                	jmp    8013b9 <strlcpy+0x42>
			*dst++ = *src++;
  80139c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013a4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013a8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013ac:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013b0:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8013b4:	0f b6 12             	movzbl (%rdx),%edx
  8013b7:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013b9:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8013be:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013c3:	74 0b                	je     8013d0 <strlcpy+0x59>
  8013c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013c9:	0f b6 00             	movzbl (%rax),%eax
  8013cc:	84 c0                	test   %al,%al
  8013ce:	75 cc                	jne    80139c <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8013d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d4:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8013d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013df:	48 29 c2             	sub    %rax,%rdx
  8013e2:	48 89 d0             	mov    %rdx,%rax
}
  8013e5:	c9                   	leaveq 
  8013e6:	c3                   	retq   

00000000008013e7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013e7:	55                   	push   %rbp
  8013e8:	48 89 e5             	mov    %rsp,%rbp
  8013eb:	48 83 ec 10          	sub    $0x10,%rsp
  8013ef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8013f7:	eb 0a                	jmp    801403 <strcmp+0x1c>
		p++, q++;
  8013f9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013fe:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801403:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801407:	0f b6 00             	movzbl (%rax),%eax
  80140a:	84 c0                	test   %al,%al
  80140c:	74 12                	je     801420 <strcmp+0x39>
  80140e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801412:	0f b6 10             	movzbl (%rax),%edx
  801415:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801419:	0f b6 00             	movzbl (%rax),%eax
  80141c:	38 c2                	cmp    %al,%dl
  80141e:	74 d9                	je     8013f9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801420:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801424:	0f b6 00             	movzbl (%rax),%eax
  801427:	0f b6 d0             	movzbl %al,%edx
  80142a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142e:	0f b6 00             	movzbl (%rax),%eax
  801431:	0f b6 c0             	movzbl %al,%eax
  801434:	29 c2                	sub    %eax,%edx
  801436:	89 d0                	mov    %edx,%eax
}
  801438:	c9                   	leaveq 
  801439:	c3                   	retq   

000000000080143a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80143a:	55                   	push   %rbp
  80143b:	48 89 e5             	mov    %rsp,%rbp
  80143e:	48 83 ec 18          	sub    $0x18,%rsp
  801442:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801446:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80144a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80144e:	eb 0f                	jmp    80145f <strncmp+0x25>
		n--, p++, q++;
  801450:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801455:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80145a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80145f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801464:	74 1d                	je     801483 <strncmp+0x49>
  801466:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146a:	0f b6 00             	movzbl (%rax),%eax
  80146d:	84 c0                	test   %al,%al
  80146f:	74 12                	je     801483 <strncmp+0x49>
  801471:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801475:	0f b6 10             	movzbl (%rax),%edx
  801478:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147c:	0f b6 00             	movzbl (%rax),%eax
  80147f:	38 c2                	cmp    %al,%dl
  801481:	74 cd                	je     801450 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801483:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801488:	75 07                	jne    801491 <strncmp+0x57>
		return 0;
  80148a:	b8 00 00 00 00       	mov    $0x0,%eax
  80148f:	eb 18                	jmp    8014a9 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801491:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801495:	0f b6 00             	movzbl (%rax),%eax
  801498:	0f b6 d0             	movzbl %al,%edx
  80149b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149f:	0f b6 00             	movzbl (%rax),%eax
  8014a2:	0f b6 c0             	movzbl %al,%eax
  8014a5:	29 c2                	sub    %eax,%edx
  8014a7:	89 d0                	mov    %edx,%eax
}
  8014a9:	c9                   	leaveq 
  8014aa:	c3                   	retq   

00000000008014ab <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014ab:	55                   	push   %rbp
  8014ac:	48 89 e5             	mov    %rsp,%rbp
  8014af:	48 83 ec 0c          	sub    $0xc,%rsp
  8014b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014b7:	89 f0                	mov    %esi,%eax
  8014b9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8014bc:	eb 17                	jmp    8014d5 <strchr+0x2a>
		if (*s == c)
  8014be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c2:	0f b6 00             	movzbl (%rax),%eax
  8014c5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014c8:	75 06                	jne    8014d0 <strchr+0x25>
			return (char *) s;
  8014ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ce:	eb 15                	jmp    8014e5 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014d0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d9:	0f b6 00             	movzbl (%rax),%eax
  8014dc:	84 c0                	test   %al,%al
  8014de:	75 de                	jne    8014be <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8014e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e5:	c9                   	leaveq 
  8014e6:	c3                   	retq   

00000000008014e7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014e7:	55                   	push   %rbp
  8014e8:	48 89 e5             	mov    %rsp,%rbp
  8014eb:	48 83 ec 0c          	sub    $0xc,%rsp
  8014ef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014f3:	89 f0                	mov    %esi,%eax
  8014f5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8014f8:	eb 13                	jmp    80150d <strfind+0x26>
		if (*s == c)
  8014fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fe:	0f b6 00             	movzbl (%rax),%eax
  801501:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801504:	75 02                	jne    801508 <strfind+0x21>
			break;
  801506:	eb 10                	jmp    801518 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801508:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80150d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801511:	0f b6 00             	movzbl (%rax),%eax
  801514:	84 c0                	test   %al,%al
  801516:	75 e2                	jne    8014fa <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801518:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80151c:	c9                   	leaveq 
  80151d:	c3                   	retq   

000000000080151e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80151e:	55                   	push   %rbp
  80151f:	48 89 e5             	mov    %rsp,%rbp
  801522:	48 83 ec 18          	sub    $0x18,%rsp
  801526:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80152a:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80152d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801531:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801536:	75 06                	jne    80153e <memset+0x20>
		return v;
  801538:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153c:	eb 69                	jmp    8015a7 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80153e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801542:	83 e0 03             	and    $0x3,%eax
  801545:	48 85 c0             	test   %rax,%rax
  801548:	75 48                	jne    801592 <memset+0x74>
  80154a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80154e:	83 e0 03             	and    $0x3,%eax
  801551:	48 85 c0             	test   %rax,%rax
  801554:	75 3c                	jne    801592 <memset+0x74>
		c &= 0xFF;
  801556:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80155d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801560:	c1 e0 18             	shl    $0x18,%eax
  801563:	89 c2                	mov    %eax,%edx
  801565:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801568:	c1 e0 10             	shl    $0x10,%eax
  80156b:	09 c2                	or     %eax,%edx
  80156d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801570:	c1 e0 08             	shl    $0x8,%eax
  801573:	09 d0                	or     %edx,%eax
  801575:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801578:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80157c:	48 c1 e8 02          	shr    $0x2,%rax
  801580:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801583:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801587:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80158a:	48 89 d7             	mov    %rdx,%rdi
  80158d:	fc                   	cld    
  80158e:	f3 ab                	rep stos %eax,%es:(%rdi)
  801590:	eb 11                	jmp    8015a3 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801592:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801596:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801599:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80159d:	48 89 d7             	mov    %rdx,%rdi
  8015a0:	fc                   	cld    
  8015a1:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8015a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015a7:	c9                   	leaveq 
  8015a8:	c3                   	retq   

00000000008015a9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8015a9:	55                   	push   %rbp
  8015aa:	48 89 e5             	mov    %rsp,%rbp
  8015ad:	48 83 ec 28          	sub    $0x28,%rsp
  8015b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8015bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8015c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8015cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d1:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8015d5:	0f 83 88 00 00 00    	jae    801663 <memmove+0xba>
  8015db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015df:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015e3:	48 01 d0             	add    %rdx,%rax
  8015e6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8015ea:	76 77                	jbe    801663 <memmove+0xba>
		s += n;
  8015ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f0:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8015f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f8:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801600:	83 e0 03             	and    $0x3,%eax
  801603:	48 85 c0             	test   %rax,%rax
  801606:	75 3b                	jne    801643 <memmove+0x9a>
  801608:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160c:	83 e0 03             	and    $0x3,%eax
  80160f:	48 85 c0             	test   %rax,%rax
  801612:	75 2f                	jne    801643 <memmove+0x9a>
  801614:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801618:	83 e0 03             	and    $0x3,%eax
  80161b:	48 85 c0             	test   %rax,%rax
  80161e:	75 23                	jne    801643 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801620:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801624:	48 83 e8 04          	sub    $0x4,%rax
  801628:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80162c:	48 83 ea 04          	sub    $0x4,%rdx
  801630:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801634:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801638:	48 89 c7             	mov    %rax,%rdi
  80163b:	48 89 d6             	mov    %rdx,%rsi
  80163e:	fd                   	std    
  80163f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801641:	eb 1d                	jmp    801660 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801643:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801647:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80164b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80164f:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801653:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801657:	48 89 d7             	mov    %rdx,%rdi
  80165a:	48 89 c1             	mov    %rax,%rcx
  80165d:	fd                   	std    
  80165e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801660:	fc                   	cld    
  801661:	eb 57                	jmp    8016ba <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801663:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801667:	83 e0 03             	and    $0x3,%eax
  80166a:	48 85 c0             	test   %rax,%rax
  80166d:	75 36                	jne    8016a5 <memmove+0xfc>
  80166f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801673:	83 e0 03             	and    $0x3,%eax
  801676:	48 85 c0             	test   %rax,%rax
  801679:	75 2a                	jne    8016a5 <memmove+0xfc>
  80167b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167f:	83 e0 03             	and    $0x3,%eax
  801682:	48 85 c0             	test   %rax,%rax
  801685:	75 1e                	jne    8016a5 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801687:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168b:	48 c1 e8 02          	shr    $0x2,%rax
  80168f:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801692:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801696:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80169a:	48 89 c7             	mov    %rax,%rdi
  80169d:	48 89 d6             	mov    %rdx,%rsi
  8016a0:	fc                   	cld    
  8016a1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016a3:	eb 15                	jmp    8016ba <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8016a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016ad:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016b1:	48 89 c7             	mov    %rax,%rdi
  8016b4:	48 89 d6             	mov    %rdx,%rsi
  8016b7:	fc                   	cld    
  8016b8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8016ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016be:	c9                   	leaveq 
  8016bf:	c3                   	retq   

00000000008016c0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8016c0:	55                   	push   %rbp
  8016c1:	48 89 e5             	mov    %rsp,%rbp
  8016c4:	48 83 ec 18          	sub    $0x18,%rsp
  8016c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8016d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8016d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016d8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8016dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e0:	48 89 ce             	mov    %rcx,%rsi
  8016e3:	48 89 c7             	mov    %rax,%rdi
  8016e6:	48 b8 a9 15 80 00 00 	movabs $0x8015a9,%rax
  8016ed:	00 00 00 
  8016f0:	ff d0                	callq  *%rax
}
  8016f2:	c9                   	leaveq 
  8016f3:	c3                   	retq   

00000000008016f4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8016f4:	55                   	push   %rbp
  8016f5:	48 89 e5             	mov    %rsp,%rbp
  8016f8:	48 83 ec 28          	sub    $0x28,%rsp
  8016fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801700:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801704:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801708:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80170c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801710:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801714:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801718:	eb 36                	jmp    801750 <memcmp+0x5c>
		if (*s1 != *s2)
  80171a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80171e:	0f b6 10             	movzbl (%rax),%edx
  801721:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801725:	0f b6 00             	movzbl (%rax),%eax
  801728:	38 c2                	cmp    %al,%dl
  80172a:	74 1a                	je     801746 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80172c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801730:	0f b6 00             	movzbl (%rax),%eax
  801733:	0f b6 d0             	movzbl %al,%edx
  801736:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80173a:	0f b6 00             	movzbl (%rax),%eax
  80173d:	0f b6 c0             	movzbl %al,%eax
  801740:	29 c2                	sub    %eax,%edx
  801742:	89 d0                	mov    %edx,%eax
  801744:	eb 20                	jmp    801766 <memcmp+0x72>
		s1++, s2++;
  801746:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80174b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801750:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801754:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801758:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80175c:	48 85 c0             	test   %rax,%rax
  80175f:	75 b9                	jne    80171a <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801761:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801766:	c9                   	leaveq 
  801767:	c3                   	retq   

0000000000801768 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801768:	55                   	push   %rbp
  801769:	48 89 e5             	mov    %rsp,%rbp
  80176c:	48 83 ec 28          	sub    $0x28,%rsp
  801770:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801774:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801777:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80177b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801783:	48 01 d0             	add    %rdx,%rax
  801786:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80178a:	eb 15                	jmp    8017a1 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80178c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801790:	0f b6 10             	movzbl (%rax),%edx
  801793:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801796:	38 c2                	cmp    %al,%dl
  801798:	75 02                	jne    80179c <memfind+0x34>
			break;
  80179a:	eb 0f                	jmp    8017ab <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80179c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8017a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017a5:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8017a9:	72 e1                	jb     80178c <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8017ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017af:	c9                   	leaveq 
  8017b0:	c3                   	retq   

00000000008017b1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8017b1:	55                   	push   %rbp
  8017b2:	48 89 e5             	mov    %rsp,%rbp
  8017b5:	48 83 ec 34          	sub    $0x34,%rsp
  8017b9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017bd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8017c1:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8017c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8017cb:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8017d2:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017d3:	eb 05                	jmp    8017da <strtol+0x29>
		s++;
  8017d5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017de:	0f b6 00             	movzbl (%rax),%eax
  8017e1:	3c 20                	cmp    $0x20,%al
  8017e3:	74 f0                	je     8017d5 <strtol+0x24>
  8017e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e9:	0f b6 00             	movzbl (%rax),%eax
  8017ec:	3c 09                	cmp    $0x9,%al
  8017ee:	74 e5                	je     8017d5 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f4:	0f b6 00             	movzbl (%rax),%eax
  8017f7:	3c 2b                	cmp    $0x2b,%al
  8017f9:	75 07                	jne    801802 <strtol+0x51>
		s++;
  8017fb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801800:	eb 17                	jmp    801819 <strtol+0x68>
	else if (*s == '-')
  801802:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801806:	0f b6 00             	movzbl (%rax),%eax
  801809:	3c 2d                	cmp    $0x2d,%al
  80180b:	75 0c                	jne    801819 <strtol+0x68>
		s++, neg = 1;
  80180d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801812:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801819:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80181d:	74 06                	je     801825 <strtol+0x74>
  80181f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801823:	75 28                	jne    80184d <strtol+0x9c>
  801825:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801829:	0f b6 00             	movzbl (%rax),%eax
  80182c:	3c 30                	cmp    $0x30,%al
  80182e:	75 1d                	jne    80184d <strtol+0x9c>
  801830:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801834:	48 83 c0 01          	add    $0x1,%rax
  801838:	0f b6 00             	movzbl (%rax),%eax
  80183b:	3c 78                	cmp    $0x78,%al
  80183d:	75 0e                	jne    80184d <strtol+0x9c>
		s += 2, base = 16;
  80183f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801844:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80184b:	eb 2c                	jmp    801879 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80184d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801851:	75 19                	jne    80186c <strtol+0xbb>
  801853:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801857:	0f b6 00             	movzbl (%rax),%eax
  80185a:	3c 30                	cmp    $0x30,%al
  80185c:	75 0e                	jne    80186c <strtol+0xbb>
		s++, base = 8;
  80185e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801863:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80186a:	eb 0d                	jmp    801879 <strtol+0xc8>
	else if (base == 0)
  80186c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801870:	75 07                	jne    801879 <strtol+0xc8>
		base = 10;
  801872:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801879:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187d:	0f b6 00             	movzbl (%rax),%eax
  801880:	3c 2f                	cmp    $0x2f,%al
  801882:	7e 1d                	jle    8018a1 <strtol+0xf0>
  801884:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801888:	0f b6 00             	movzbl (%rax),%eax
  80188b:	3c 39                	cmp    $0x39,%al
  80188d:	7f 12                	jg     8018a1 <strtol+0xf0>
			dig = *s - '0';
  80188f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801893:	0f b6 00             	movzbl (%rax),%eax
  801896:	0f be c0             	movsbl %al,%eax
  801899:	83 e8 30             	sub    $0x30,%eax
  80189c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80189f:	eb 4e                	jmp    8018ef <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8018a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a5:	0f b6 00             	movzbl (%rax),%eax
  8018a8:	3c 60                	cmp    $0x60,%al
  8018aa:	7e 1d                	jle    8018c9 <strtol+0x118>
  8018ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b0:	0f b6 00             	movzbl (%rax),%eax
  8018b3:	3c 7a                	cmp    $0x7a,%al
  8018b5:	7f 12                	jg     8018c9 <strtol+0x118>
			dig = *s - 'a' + 10;
  8018b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018bb:	0f b6 00             	movzbl (%rax),%eax
  8018be:	0f be c0             	movsbl %al,%eax
  8018c1:	83 e8 57             	sub    $0x57,%eax
  8018c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018c7:	eb 26                	jmp    8018ef <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8018c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018cd:	0f b6 00             	movzbl (%rax),%eax
  8018d0:	3c 40                	cmp    $0x40,%al
  8018d2:	7e 48                	jle    80191c <strtol+0x16b>
  8018d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d8:	0f b6 00             	movzbl (%rax),%eax
  8018db:	3c 5a                	cmp    $0x5a,%al
  8018dd:	7f 3d                	jg     80191c <strtol+0x16b>
			dig = *s - 'A' + 10;
  8018df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e3:	0f b6 00             	movzbl (%rax),%eax
  8018e6:	0f be c0             	movsbl %al,%eax
  8018e9:	83 e8 37             	sub    $0x37,%eax
  8018ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8018ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018f2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8018f5:	7c 02                	jl     8018f9 <strtol+0x148>
			break;
  8018f7:	eb 23                	jmp    80191c <strtol+0x16b>
		s++, val = (val * base) + dig;
  8018f9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018fe:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801901:	48 98                	cltq   
  801903:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801908:	48 89 c2             	mov    %rax,%rdx
  80190b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80190e:	48 98                	cltq   
  801910:	48 01 d0             	add    %rdx,%rax
  801913:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801917:	e9 5d ff ff ff       	jmpq   801879 <strtol+0xc8>

	if (endptr)
  80191c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801921:	74 0b                	je     80192e <strtol+0x17d>
		*endptr = (char *) s;
  801923:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801927:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80192b:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80192e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801932:	74 09                	je     80193d <strtol+0x18c>
  801934:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801938:	48 f7 d8             	neg    %rax
  80193b:	eb 04                	jmp    801941 <strtol+0x190>
  80193d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801941:	c9                   	leaveq 
  801942:	c3                   	retq   

0000000000801943 <strstr>:

char * strstr(const char *in, const char *str)
{
  801943:	55                   	push   %rbp
  801944:	48 89 e5             	mov    %rsp,%rbp
  801947:	48 83 ec 30          	sub    $0x30,%rsp
  80194b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80194f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801953:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801957:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80195b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80195f:	0f b6 00             	movzbl (%rax),%eax
  801962:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801965:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801969:	75 06                	jne    801971 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80196b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80196f:	eb 6b                	jmp    8019dc <strstr+0x99>

	len = strlen(str);
  801971:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801975:	48 89 c7             	mov    %rax,%rdi
  801978:	48 b8 19 12 80 00 00 	movabs $0x801219,%rax
  80197f:	00 00 00 
  801982:	ff d0                	callq  *%rax
  801984:	48 98                	cltq   
  801986:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80198a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80198e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801992:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801996:	0f b6 00             	movzbl (%rax),%eax
  801999:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80199c:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8019a0:	75 07                	jne    8019a9 <strstr+0x66>
				return (char *) 0;
  8019a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a7:	eb 33                	jmp    8019dc <strstr+0x99>
		} while (sc != c);
  8019a9:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8019ad:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8019b0:	75 d8                	jne    80198a <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8019b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019b6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8019ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019be:	48 89 ce             	mov    %rcx,%rsi
  8019c1:	48 89 c7             	mov    %rax,%rdi
  8019c4:	48 b8 3a 14 80 00 00 	movabs $0x80143a,%rax
  8019cb:	00 00 00 
  8019ce:	ff d0                	callq  *%rax
  8019d0:	85 c0                	test   %eax,%eax
  8019d2:	75 b6                	jne    80198a <strstr+0x47>

	return (char *) (in - 1);
  8019d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d8:	48 83 e8 01          	sub    $0x1,%rax
}
  8019dc:	c9                   	leaveq 
  8019dd:	c3                   	retq   

00000000008019de <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8019de:	55                   	push   %rbp
  8019df:	48 89 e5             	mov    %rsp,%rbp
  8019e2:	53                   	push   %rbx
  8019e3:	48 83 ec 48          	sub    $0x48,%rsp
  8019e7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8019ea:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8019ed:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019f1:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8019f5:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8019f9:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019fd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a00:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801a04:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801a08:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801a0c:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801a10:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801a14:	4c 89 c3             	mov    %r8,%rbx
  801a17:	cd 30                	int    $0x30
  801a19:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801a1d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801a21:	74 3e                	je     801a61 <syscall+0x83>
  801a23:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a28:	7e 37                	jle    801a61 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a2a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a2e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a31:	49 89 d0             	mov    %rdx,%r8
  801a34:	89 c1                	mov    %eax,%ecx
  801a36:	48 ba c8 4f 80 00 00 	movabs $0x804fc8,%rdx
  801a3d:	00 00 00 
  801a40:	be 23 00 00 00       	mov    $0x23,%esi
  801a45:	48 bf e5 4f 80 00 00 	movabs $0x804fe5,%rdi
  801a4c:	00 00 00 
  801a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a54:	49 b9 97 04 80 00 00 	movabs $0x800497,%r9
  801a5b:	00 00 00 
  801a5e:	41 ff d1             	callq  *%r9

	return ret;
  801a61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a65:	48 83 c4 48          	add    $0x48,%rsp
  801a69:	5b                   	pop    %rbx
  801a6a:	5d                   	pop    %rbp
  801a6b:	c3                   	retq   

0000000000801a6c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a6c:	55                   	push   %rbp
  801a6d:	48 89 e5             	mov    %rsp,%rbp
  801a70:	48 83 ec 20          	sub    $0x20,%rsp
  801a74:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a78:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a80:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a84:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a8b:	00 
  801a8c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a92:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a98:	48 89 d1             	mov    %rdx,%rcx
  801a9b:	48 89 c2             	mov    %rax,%rdx
  801a9e:	be 00 00 00 00       	mov    $0x0,%esi
  801aa3:	bf 00 00 00 00       	mov    $0x0,%edi
  801aa8:	48 b8 de 19 80 00 00 	movabs $0x8019de,%rax
  801aaf:	00 00 00 
  801ab2:	ff d0                	callq  *%rax
}
  801ab4:	c9                   	leaveq 
  801ab5:	c3                   	retq   

0000000000801ab6 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ab6:	55                   	push   %rbp
  801ab7:	48 89 e5             	mov    %rsp,%rbp
  801aba:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801abe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ac5:	00 
  801ac6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801acc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ad7:	ba 00 00 00 00       	mov    $0x0,%edx
  801adc:	be 00 00 00 00       	mov    $0x0,%esi
  801ae1:	bf 01 00 00 00       	mov    $0x1,%edi
  801ae6:	48 b8 de 19 80 00 00 	movabs $0x8019de,%rax
  801aed:	00 00 00 
  801af0:	ff d0                	callq  *%rax
}
  801af2:	c9                   	leaveq 
  801af3:	c3                   	retq   

0000000000801af4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801af4:	55                   	push   %rbp
  801af5:	48 89 e5             	mov    %rsp,%rbp
  801af8:	48 83 ec 10          	sub    $0x10,%rsp
  801afc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801aff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b02:	48 98                	cltq   
  801b04:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b0b:	00 
  801b0c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b12:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b18:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b1d:	48 89 c2             	mov    %rax,%rdx
  801b20:	be 01 00 00 00       	mov    $0x1,%esi
  801b25:	bf 03 00 00 00       	mov    $0x3,%edi
  801b2a:	48 b8 de 19 80 00 00 	movabs $0x8019de,%rax
  801b31:	00 00 00 
  801b34:	ff d0                	callq  *%rax
}
  801b36:	c9                   	leaveq 
  801b37:	c3                   	retq   

0000000000801b38 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801b38:	55                   	push   %rbp
  801b39:	48 89 e5             	mov    %rsp,%rbp
  801b3c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801b40:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b47:	00 
  801b48:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b4e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b54:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b59:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5e:	be 00 00 00 00       	mov    $0x0,%esi
  801b63:	bf 02 00 00 00       	mov    $0x2,%edi
  801b68:	48 b8 de 19 80 00 00 	movabs $0x8019de,%rax
  801b6f:	00 00 00 
  801b72:	ff d0                	callq  *%rax
}
  801b74:	c9                   	leaveq 
  801b75:	c3                   	retq   

0000000000801b76 <sys_yield>:

void
sys_yield(void)
{
  801b76:	55                   	push   %rbp
  801b77:	48 89 e5             	mov    %rsp,%rbp
  801b7a:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b7e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b85:	00 
  801b86:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b8c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b92:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b97:	ba 00 00 00 00       	mov    $0x0,%edx
  801b9c:	be 00 00 00 00       	mov    $0x0,%esi
  801ba1:	bf 0b 00 00 00       	mov    $0xb,%edi
  801ba6:	48 b8 de 19 80 00 00 	movabs $0x8019de,%rax
  801bad:	00 00 00 
  801bb0:	ff d0                	callq  *%rax
}
  801bb2:	c9                   	leaveq 
  801bb3:	c3                   	retq   

0000000000801bb4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801bb4:	55                   	push   %rbp
  801bb5:	48 89 e5             	mov    %rsp,%rbp
  801bb8:	48 83 ec 20          	sub    $0x20,%rsp
  801bbc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bbf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bc3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801bc6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bc9:	48 63 c8             	movslq %eax,%rcx
  801bcc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bd3:	48 98                	cltq   
  801bd5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bdc:	00 
  801bdd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801be3:	49 89 c8             	mov    %rcx,%r8
  801be6:	48 89 d1             	mov    %rdx,%rcx
  801be9:	48 89 c2             	mov    %rax,%rdx
  801bec:	be 01 00 00 00       	mov    $0x1,%esi
  801bf1:	bf 04 00 00 00       	mov    $0x4,%edi
  801bf6:	48 b8 de 19 80 00 00 	movabs $0x8019de,%rax
  801bfd:	00 00 00 
  801c00:	ff d0                	callq  *%rax
}
  801c02:	c9                   	leaveq 
  801c03:	c3                   	retq   

0000000000801c04 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801c04:	55                   	push   %rbp
  801c05:	48 89 e5             	mov    %rsp,%rbp
  801c08:	48 83 ec 30          	sub    $0x30,%rsp
  801c0c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c0f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c13:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801c16:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c1a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801c1e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c21:	48 63 c8             	movslq %eax,%rcx
  801c24:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c28:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c2b:	48 63 f0             	movslq %eax,%rsi
  801c2e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c35:	48 98                	cltq   
  801c37:	48 89 0c 24          	mov    %rcx,(%rsp)
  801c3b:	49 89 f9             	mov    %rdi,%r9
  801c3e:	49 89 f0             	mov    %rsi,%r8
  801c41:	48 89 d1             	mov    %rdx,%rcx
  801c44:	48 89 c2             	mov    %rax,%rdx
  801c47:	be 01 00 00 00       	mov    $0x1,%esi
  801c4c:	bf 05 00 00 00       	mov    $0x5,%edi
  801c51:	48 b8 de 19 80 00 00 	movabs $0x8019de,%rax
  801c58:	00 00 00 
  801c5b:	ff d0                	callq  *%rax
}
  801c5d:	c9                   	leaveq 
  801c5e:	c3                   	retq   

0000000000801c5f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801c5f:	55                   	push   %rbp
  801c60:	48 89 e5             	mov    %rsp,%rbp
  801c63:	48 83 ec 20          	sub    $0x20,%rsp
  801c67:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c6a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c6e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c75:	48 98                	cltq   
  801c77:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c7e:	00 
  801c7f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c85:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c8b:	48 89 d1             	mov    %rdx,%rcx
  801c8e:	48 89 c2             	mov    %rax,%rdx
  801c91:	be 01 00 00 00       	mov    $0x1,%esi
  801c96:	bf 06 00 00 00       	mov    $0x6,%edi
  801c9b:	48 b8 de 19 80 00 00 	movabs $0x8019de,%rax
  801ca2:	00 00 00 
  801ca5:	ff d0                	callq  *%rax
}
  801ca7:	c9                   	leaveq 
  801ca8:	c3                   	retq   

0000000000801ca9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ca9:	55                   	push   %rbp
  801caa:	48 89 e5             	mov    %rsp,%rbp
  801cad:	48 83 ec 10          	sub    $0x10,%rsp
  801cb1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cb4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801cb7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cba:	48 63 d0             	movslq %eax,%rdx
  801cbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cc0:	48 98                	cltq   
  801cc2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cc9:	00 
  801cca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cd0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cd6:	48 89 d1             	mov    %rdx,%rcx
  801cd9:	48 89 c2             	mov    %rax,%rdx
  801cdc:	be 01 00 00 00       	mov    $0x1,%esi
  801ce1:	bf 08 00 00 00       	mov    $0x8,%edi
  801ce6:	48 b8 de 19 80 00 00 	movabs $0x8019de,%rax
  801ced:	00 00 00 
  801cf0:	ff d0                	callq  *%rax
}
  801cf2:	c9                   	leaveq 
  801cf3:	c3                   	retq   

0000000000801cf4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801cf4:	55                   	push   %rbp
  801cf5:	48 89 e5             	mov    %rsp,%rbp
  801cf8:	48 83 ec 20          	sub    $0x20,%rsp
  801cfc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801d03:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d0a:	48 98                	cltq   
  801d0c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d13:	00 
  801d14:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d1a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d20:	48 89 d1             	mov    %rdx,%rcx
  801d23:	48 89 c2             	mov    %rax,%rdx
  801d26:	be 01 00 00 00       	mov    $0x1,%esi
  801d2b:	bf 09 00 00 00       	mov    $0x9,%edi
  801d30:	48 b8 de 19 80 00 00 	movabs $0x8019de,%rax
  801d37:	00 00 00 
  801d3a:	ff d0                	callq  *%rax
}
  801d3c:	c9                   	leaveq 
  801d3d:	c3                   	retq   

0000000000801d3e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801d3e:	55                   	push   %rbp
  801d3f:	48 89 e5             	mov    %rsp,%rbp
  801d42:	48 83 ec 20          	sub    $0x20,%rsp
  801d46:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d49:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801d4d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d54:	48 98                	cltq   
  801d56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d5d:	00 
  801d5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d6a:	48 89 d1             	mov    %rdx,%rcx
  801d6d:	48 89 c2             	mov    %rax,%rdx
  801d70:	be 01 00 00 00       	mov    $0x1,%esi
  801d75:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d7a:	48 b8 de 19 80 00 00 	movabs $0x8019de,%rax
  801d81:	00 00 00 
  801d84:	ff d0                	callq  *%rax
}
  801d86:	c9                   	leaveq 
  801d87:	c3                   	retq   

0000000000801d88 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d88:	55                   	push   %rbp
  801d89:	48 89 e5             	mov    %rsp,%rbp
  801d8c:	48 83 ec 20          	sub    $0x20,%rsp
  801d90:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d93:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d97:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d9b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801da1:	48 63 f0             	movslq %eax,%rsi
  801da4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801da8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dab:	48 98                	cltq   
  801dad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801db1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db8:	00 
  801db9:	49 89 f1             	mov    %rsi,%r9
  801dbc:	49 89 c8             	mov    %rcx,%r8
  801dbf:	48 89 d1             	mov    %rdx,%rcx
  801dc2:	48 89 c2             	mov    %rax,%rdx
  801dc5:	be 00 00 00 00       	mov    $0x0,%esi
  801dca:	bf 0c 00 00 00       	mov    $0xc,%edi
  801dcf:	48 b8 de 19 80 00 00 	movabs $0x8019de,%rax
  801dd6:	00 00 00 
  801dd9:	ff d0                	callq  *%rax
}
  801ddb:	c9                   	leaveq 
  801ddc:	c3                   	retq   

0000000000801ddd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ddd:	55                   	push   %rbp
  801dde:	48 89 e5             	mov    %rsp,%rbp
  801de1:	48 83 ec 10          	sub    $0x10,%rsp
  801de5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801de9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ded:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801df4:	00 
  801df5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dfb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e01:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e06:	48 89 c2             	mov    %rax,%rdx
  801e09:	be 01 00 00 00       	mov    $0x1,%esi
  801e0e:	bf 0d 00 00 00       	mov    $0xd,%edi
  801e13:	48 b8 de 19 80 00 00 	movabs $0x8019de,%rax
  801e1a:	00 00 00 
  801e1d:	ff d0                	callq  *%rax
}
  801e1f:	c9                   	leaveq 
  801e20:	c3                   	retq   

0000000000801e21 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801e21:	55                   	push   %rbp
  801e22:	48 89 e5             	mov    %rsp,%rbp
  801e25:	48 83 ec 20          	sub    $0x20,%rsp
  801e29:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e2d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801e31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e35:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e39:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e40:	00 
  801e41:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e47:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e4d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e52:	89 c6                	mov    %eax,%esi
  801e54:	bf 0f 00 00 00       	mov    $0xf,%edi
  801e59:	48 b8 de 19 80 00 00 	movabs $0x8019de,%rax
  801e60:	00 00 00 
  801e63:	ff d0                	callq  *%rax
}
  801e65:	c9                   	leaveq 
  801e66:	c3                   	retq   

0000000000801e67 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801e67:	55                   	push   %rbp
  801e68:	48 89 e5             	mov    %rsp,%rbp
  801e6b:	48 83 ec 20          	sub    $0x20,%rsp
  801e6f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e73:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801e77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e7b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e7f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e86:	00 
  801e87:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e8d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e93:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e98:	89 c6                	mov    %eax,%esi
  801e9a:	bf 10 00 00 00       	mov    $0x10,%edi
  801e9f:	48 b8 de 19 80 00 00 	movabs $0x8019de,%rax
  801ea6:	00 00 00 
  801ea9:	ff d0                	callq  *%rax
}
  801eab:	c9                   	leaveq 
  801eac:	c3                   	retq   

0000000000801ead <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801ead:	55                   	push   %rbp
  801eae:	48 89 e5             	mov    %rsp,%rbp
  801eb1:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801eb5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ebc:	00 
  801ebd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ec3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ec9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ece:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed3:	be 00 00 00 00       	mov    $0x0,%esi
  801ed8:	bf 0e 00 00 00       	mov    $0xe,%edi
  801edd:	48 b8 de 19 80 00 00 	movabs $0x8019de,%rax
  801ee4:	00 00 00 
  801ee7:	ff d0                	callq  *%rax
}
  801ee9:	c9                   	leaveq 
  801eea:	c3                   	retq   

0000000000801eeb <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801eeb:	55                   	push   %rbp
  801eec:	48 89 e5             	mov    %rsp,%rbp
  801eef:	48 83 ec 30          	sub    $0x30,%rsp
  801ef3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801ef7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801efb:	48 8b 00             	mov    (%rax),%rax
  801efe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801f02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f06:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f0a:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801f0d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f10:	83 e0 02             	and    $0x2,%eax
  801f13:	85 c0                	test   %eax,%eax
  801f15:	75 4d                	jne    801f64 <pgfault+0x79>
  801f17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f1b:	48 c1 e8 0c          	shr    $0xc,%rax
  801f1f:	48 89 c2             	mov    %rax,%rdx
  801f22:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f29:	01 00 00 
  801f2c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f30:	25 00 08 00 00       	and    $0x800,%eax
  801f35:	48 85 c0             	test   %rax,%rax
  801f38:	74 2a                	je     801f64 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801f3a:	48 ba f8 4f 80 00 00 	movabs $0x804ff8,%rdx
  801f41:	00 00 00 
  801f44:	be 23 00 00 00       	mov    $0x23,%esi
  801f49:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  801f50:	00 00 00 
  801f53:	b8 00 00 00 00       	mov    $0x0,%eax
  801f58:	48 b9 97 04 80 00 00 	movabs $0x800497,%rcx
  801f5f:	00 00 00 
  801f62:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801f64:	ba 07 00 00 00       	mov    $0x7,%edx
  801f69:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f6e:	bf 00 00 00 00       	mov    $0x0,%edi
  801f73:	48 b8 b4 1b 80 00 00 	movabs $0x801bb4,%rax
  801f7a:	00 00 00 
  801f7d:	ff d0                	callq  *%rax
  801f7f:	85 c0                	test   %eax,%eax
  801f81:	0f 85 cd 00 00 00    	jne    802054 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801f87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f8b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801f8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f93:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801f99:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801f9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fa1:	ba 00 10 00 00       	mov    $0x1000,%edx
  801fa6:	48 89 c6             	mov    %rax,%rsi
  801fa9:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801fae:	48 b8 a9 15 80 00 00 	movabs $0x8015a9,%rax
  801fb5:	00 00 00 
  801fb8:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801fba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fbe:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801fc4:	48 89 c1             	mov    %rax,%rcx
  801fc7:	ba 00 00 00 00       	mov    $0x0,%edx
  801fcc:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fd1:	bf 00 00 00 00       	mov    $0x0,%edi
  801fd6:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  801fdd:	00 00 00 
  801fe0:	ff d0                	callq  *%rax
  801fe2:	85 c0                	test   %eax,%eax
  801fe4:	79 2a                	jns    802010 <pgfault+0x125>
				panic("Page map at temp address failed");
  801fe6:	48 ba 38 50 80 00 00 	movabs $0x805038,%rdx
  801fed:	00 00 00 
  801ff0:	be 30 00 00 00       	mov    $0x30,%esi
  801ff5:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  801ffc:	00 00 00 
  801fff:	b8 00 00 00 00       	mov    $0x0,%eax
  802004:	48 b9 97 04 80 00 00 	movabs $0x800497,%rcx
  80200b:	00 00 00 
  80200e:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  802010:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802015:	bf 00 00 00 00       	mov    $0x0,%edi
  80201a:	48 b8 5f 1c 80 00 00 	movabs $0x801c5f,%rax
  802021:	00 00 00 
  802024:	ff d0                	callq  *%rax
  802026:	85 c0                	test   %eax,%eax
  802028:	79 54                	jns    80207e <pgfault+0x193>
				panic("Page unmap from temp location failed");
  80202a:	48 ba 58 50 80 00 00 	movabs $0x805058,%rdx
  802031:	00 00 00 
  802034:	be 32 00 00 00       	mov    $0x32,%esi
  802039:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  802040:	00 00 00 
  802043:	b8 00 00 00 00       	mov    $0x0,%eax
  802048:	48 b9 97 04 80 00 00 	movabs $0x800497,%rcx
  80204f:	00 00 00 
  802052:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  802054:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  80205b:	00 00 00 
  80205e:	be 34 00 00 00       	mov    $0x34,%esi
  802063:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  80206a:	00 00 00 
  80206d:	b8 00 00 00 00       	mov    $0x0,%eax
  802072:	48 b9 97 04 80 00 00 	movabs $0x800497,%rcx
  802079:	00 00 00 
  80207c:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  80207e:	c9                   	leaveq 
  80207f:	c3                   	retq   

0000000000802080 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802080:	55                   	push   %rbp
  802081:	48 89 e5             	mov    %rsp,%rbp
  802084:	48 83 ec 20          	sub    $0x20,%rsp
  802088:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80208b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  80208e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802095:	01 00 00 
  802098:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80209b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80209f:	25 07 0e 00 00       	and    $0xe07,%eax
  8020a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  8020a7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020aa:	48 c1 e0 0c          	shl    $0xc,%rax
  8020ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  8020b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020b5:	25 00 04 00 00       	and    $0x400,%eax
  8020ba:	85 c0                	test   %eax,%eax
  8020bc:	74 57                	je     802115 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8020be:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8020c1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8020c5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020cc:	41 89 f0             	mov    %esi,%r8d
  8020cf:	48 89 c6             	mov    %rax,%rsi
  8020d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8020d7:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  8020de:	00 00 00 
  8020e1:	ff d0                	callq  *%rax
  8020e3:	85 c0                	test   %eax,%eax
  8020e5:	0f 8e 52 01 00 00    	jle    80223d <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  8020eb:	48 ba b2 50 80 00 00 	movabs $0x8050b2,%rdx
  8020f2:	00 00 00 
  8020f5:	be 4e 00 00 00       	mov    $0x4e,%esi
  8020fa:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  802101:	00 00 00 
  802104:	b8 00 00 00 00       	mov    $0x0,%eax
  802109:	48 b9 97 04 80 00 00 	movabs $0x800497,%rcx
  802110:	00 00 00 
  802113:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  802115:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802118:	83 e0 02             	and    $0x2,%eax
  80211b:	85 c0                	test   %eax,%eax
  80211d:	75 10                	jne    80212f <duppage+0xaf>
  80211f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802122:	25 00 08 00 00       	and    $0x800,%eax
  802127:	85 c0                	test   %eax,%eax
  802129:	0f 84 bb 00 00 00    	je     8021ea <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  80212f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802132:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  802137:	80 cc 08             	or     $0x8,%ah
  80213a:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80213d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802140:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802144:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802147:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80214b:	41 89 f0             	mov    %esi,%r8d
  80214e:	48 89 c6             	mov    %rax,%rsi
  802151:	bf 00 00 00 00       	mov    $0x0,%edi
  802156:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  80215d:	00 00 00 
  802160:	ff d0                	callq  *%rax
  802162:	85 c0                	test   %eax,%eax
  802164:	7e 2a                	jle    802190 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  802166:	48 ba b2 50 80 00 00 	movabs $0x8050b2,%rdx
  80216d:	00 00 00 
  802170:	be 55 00 00 00       	mov    $0x55,%esi
  802175:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  80217c:	00 00 00 
  80217f:	b8 00 00 00 00       	mov    $0x0,%eax
  802184:	48 b9 97 04 80 00 00 	movabs $0x800497,%rcx
  80218b:	00 00 00 
  80218e:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802190:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802193:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802197:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80219b:	41 89 c8             	mov    %ecx,%r8d
  80219e:	48 89 d1             	mov    %rdx,%rcx
  8021a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8021a6:	48 89 c6             	mov    %rax,%rsi
  8021a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ae:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  8021b5:	00 00 00 
  8021b8:	ff d0                	callq  *%rax
  8021ba:	85 c0                	test   %eax,%eax
  8021bc:	7e 2a                	jle    8021e8 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  8021be:	48 ba b2 50 80 00 00 	movabs $0x8050b2,%rdx
  8021c5:	00 00 00 
  8021c8:	be 57 00 00 00       	mov    $0x57,%esi
  8021cd:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  8021d4:	00 00 00 
  8021d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021dc:	48 b9 97 04 80 00 00 	movabs $0x800497,%rcx
  8021e3:	00 00 00 
  8021e6:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8021e8:	eb 53                	jmp    80223d <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8021ea:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8021ed:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8021f1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021f8:	41 89 f0             	mov    %esi,%r8d
  8021fb:	48 89 c6             	mov    %rax,%rsi
  8021fe:	bf 00 00 00 00       	mov    $0x0,%edi
  802203:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  80220a:	00 00 00 
  80220d:	ff d0                	callq  *%rax
  80220f:	85 c0                	test   %eax,%eax
  802211:	7e 2a                	jle    80223d <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802213:	48 ba b2 50 80 00 00 	movabs $0x8050b2,%rdx
  80221a:	00 00 00 
  80221d:	be 5b 00 00 00       	mov    $0x5b,%esi
  802222:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  802229:	00 00 00 
  80222c:	b8 00 00 00 00       	mov    $0x0,%eax
  802231:	48 b9 97 04 80 00 00 	movabs $0x800497,%rcx
  802238:	00 00 00 
  80223b:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  80223d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802242:	c9                   	leaveq 
  802243:	c3                   	retq   

0000000000802244 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  802244:	55                   	push   %rbp
  802245:	48 89 e5             	mov    %rsp,%rbp
  802248:	48 83 ec 18          	sub    $0x18,%rsp
  80224c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  802250:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802254:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  802258:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80225c:	48 c1 e8 27          	shr    $0x27,%rax
  802260:	48 89 c2             	mov    %rax,%rdx
  802263:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80226a:	01 00 00 
  80226d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802271:	83 e0 01             	and    $0x1,%eax
  802274:	48 85 c0             	test   %rax,%rax
  802277:	74 51                	je     8022ca <pt_is_mapped+0x86>
  802279:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80227d:	48 c1 e0 0c          	shl    $0xc,%rax
  802281:	48 c1 e8 1e          	shr    $0x1e,%rax
  802285:	48 89 c2             	mov    %rax,%rdx
  802288:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80228f:	01 00 00 
  802292:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802296:	83 e0 01             	and    $0x1,%eax
  802299:	48 85 c0             	test   %rax,%rax
  80229c:	74 2c                	je     8022ca <pt_is_mapped+0x86>
  80229e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022a2:	48 c1 e0 0c          	shl    $0xc,%rax
  8022a6:	48 c1 e8 15          	shr    $0x15,%rax
  8022aa:	48 89 c2             	mov    %rax,%rdx
  8022ad:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022b4:	01 00 00 
  8022b7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022bb:	83 e0 01             	and    $0x1,%eax
  8022be:	48 85 c0             	test   %rax,%rax
  8022c1:	74 07                	je     8022ca <pt_is_mapped+0x86>
  8022c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c8:	eb 05                	jmp    8022cf <pt_is_mapped+0x8b>
  8022ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cf:	83 e0 01             	and    $0x1,%eax
}
  8022d2:	c9                   	leaveq 
  8022d3:	c3                   	retq   

00000000008022d4 <fork>:

envid_t
fork(void)
{
  8022d4:	55                   	push   %rbp
  8022d5:	48 89 e5             	mov    %rsp,%rbp
  8022d8:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  8022dc:	48 bf eb 1e 80 00 00 	movabs $0x801eeb,%rdi
  8022e3:	00 00 00 
  8022e6:	48 b8 fb 47 80 00 00 	movabs $0x8047fb,%rax
  8022ed:	00 00 00 
  8022f0:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8022f2:	b8 07 00 00 00       	mov    $0x7,%eax
  8022f7:	cd 30                	int    $0x30
  8022f9:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8022fc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8022ff:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  802302:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802306:	79 30                	jns    802338 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802308:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80230b:	89 c1                	mov    %eax,%ecx
  80230d:	48 ba d0 50 80 00 00 	movabs $0x8050d0,%rdx
  802314:	00 00 00 
  802317:	be 86 00 00 00       	mov    $0x86,%esi
  80231c:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  802323:	00 00 00 
  802326:	b8 00 00 00 00       	mov    $0x0,%eax
  80232b:	49 b8 97 04 80 00 00 	movabs $0x800497,%r8
  802332:	00 00 00 
  802335:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802338:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80233c:	75 46                	jne    802384 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80233e:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  802345:	00 00 00 
  802348:	ff d0                	callq  *%rax
  80234a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80234f:	48 63 d0             	movslq %eax,%rdx
  802352:	48 89 d0             	mov    %rdx,%rax
  802355:	48 c1 e0 03          	shl    $0x3,%rax
  802359:	48 01 d0             	add    %rdx,%rax
  80235c:	48 c1 e0 05          	shl    $0x5,%rax
  802360:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802367:	00 00 00 
  80236a:	48 01 c2             	add    %rax,%rdx
  80236d:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  802374:	00 00 00 
  802377:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80237a:	b8 00 00 00 00       	mov    $0x0,%eax
  80237f:	e9 d1 01 00 00       	jmpq   802555 <fork+0x281>
	}
	uint64_t ad = 0;
  802384:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80238b:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80238c:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  802391:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802395:	e9 df 00 00 00       	jmpq   802479 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  80239a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80239e:	48 c1 e8 27          	shr    $0x27,%rax
  8023a2:	48 89 c2             	mov    %rax,%rdx
  8023a5:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8023ac:	01 00 00 
  8023af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023b3:	83 e0 01             	and    $0x1,%eax
  8023b6:	48 85 c0             	test   %rax,%rax
  8023b9:	0f 84 9e 00 00 00    	je     80245d <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8023bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023c3:	48 c1 e8 1e          	shr    $0x1e,%rax
  8023c7:	48 89 c2             	mov    %rax,%rdx
  8023ca:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8023d1:	01 00 00 
  8023d4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023d8:	83 e0 01             	and    $0x1,%eax
  8023db:	48 85 c0             	test   %rax,%rax
  8023de:	74 73                	je     802453 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  8023e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023e4:	48 c1 e8 15          	shr    $0x15,%rax
  8023e8:	48 89 c2             	mov    %rax,%rdx
  8023eb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023f2:	01 00 00 
  8023f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023f9:	83 e0 01             	and    $0x1,%eax
  8023fc:	48 85 c0             	test   %rax,%rax
  8023ff:	74 48                	je     802449 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802401:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802405:	48 c1 e8 0c          	shr    $0xc,%rax
  802409:	48 89 c2             	mov    %rax,%rdx
  80240c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802413:	01 00 00 
  802416:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80241a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80241e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802422:	83 e0 01             	and    $0x1,%eax
  802425:	48 85 c0             	test   %rax,%rax
  802428:	74 47                	je     802471 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  80242a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80242e:	48 c1 e8 0c          	shr    $0xc,%rax
  802432:	89 c2                	mov    %eax,%edx
  802434:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802437:	89 d6                	mov    %edx,%esi
  802439:	89 c7                	mov    %eax,%edi
  80243b:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  802442:	00 00 00 
  802445:	ff d0                	callq  *%rax
  802447:	eb 28                	jmp    802471 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  802449:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802450:	00 
  802451:	eb 1e                	jmp    802471 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802453:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  80245a:	40 
  80245b:	eb 14                	jmp    802471 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  80245d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802461:	48 c1 e8 27          	shr    $0x27,%rax
  802465:	48 83 c0 01          	add    $0x1,%rax
  802469:	48 c1 e0 27          	shl    $0x27,%rax
  80246d:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802471:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802478:	00 
  802479:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802480:	00 
  802481:	0f 87 13 ff ff ff    	ja     80239a <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802487:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80248a:	ba 07 00 00 00       	mov    $0x7,%edx
  80248f:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802494:	89 c7                	mov    %eax,%edi
  802496:	48 b8 b4 1b 80 00 00 	movabs $0x801bb4,%rax
  80249d:	00 00 00 
  8024a0:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8024a2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024a5:	ba 07 00 00 00       	mov    $0x7,%edx
  8024aa:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8024af:	89 c7                	mov    %eax,%edi
  8024b1:	48 b8 b4 1b 80 00 00 	movabs $0x801bb4,%rax
  8024b8:	00 00 00 
  8024bb:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8024bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024c0:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8024c6:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8024cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8024d0:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8024d5:	89 c7                	mov    %eax,%edi
  8024d7:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  8024de:	00 00 00 
  8024e1:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8024e3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024e8:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8024ed:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8024f2:	48 b8 a9 15 80 00 00 	movabs $0x8015a9,%rax
  8024f9:	00 00 00 
  8024fc:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8024fe:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802503:	bf 00 00 00 00       	mov    $0x0,%edi
  802508:	48 b8 5f 1c 80 00 00 	movabs $0x801c5f,%rax
  80250f:	00 00 00 
  802512:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802514:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80251b:	00 00 00 
  80251e:	48 8b 00             	mov    (%rax),%rax
  802521:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802528:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80252b:	48 89 d6             	mov    %rdx,%rsi
  80252e:	89 c7                	mov    %eax,%edi
  802530:	48 b8 3e 1d 80 00 00 	movabs $0x801d3e,%rax
  802537:	00 00 00 
  80253a:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  80253c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80253f:	be 02 00 00 00       	mov    $0x2,%esi
  802544:	89 c7                	mov    %eax,%edi
  802546:	48 b8 a9 1c 80 00 00 	movabs $0x801ca9,%rax
  80254d:	00 00 00 
  802550:	ff d0                	callq  *%rax

	return envid;
  802552:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802555:	c9                   	leaveq 
  802556:	c3                   	retq   

0000000000802557 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802557:	55                   	push   %rbp
  802558:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80255b:	48 ba e8 50 80 00 00 	movabs $0x8050e8,%rdx
  802562:	00 00 00 
  802565:	be bf 00 00 00       	mov    $0xbf,%esi
  80256a:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  802571:	00 00 00 
  802574:	b8 00 00 00 00       	mov    $0x0,%eax
  802579:	48 b9 97 04 80 00 00 	movabs $0x800497,%rcx
  802580:	00 00 00 
  802583:	ff d1                	callq  *%rcx

0000000000802585 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802585:	55                   	push   %rbp
  802586:	48 89 e5             	mov    %rsp,%rbp
  802589:	48 83 ec 30          	sub    $0x30,%rsp
  80258d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802591:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802595:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  802599:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8025a0:	00 00 00 
  8025a3:	48 8b 00             	mov    (%rax),%rax
  8025a6:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8025ac:	85 c0                	test   %eax,%eax
  8025ae:	75 3c                	jne    8025ec <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8025b0:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  8025b7:	00 00 00 
  8025ba:	ff d0                	callq  *%rax
  8025bc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8025c1:	48 63 d0             	movslq %eax,%rdx
  8025c4:	48 89 d0             	mov    %rdx,%rax
  8025c7:	48 c1 e0 03          	shl    $0x3,%rax
  8025cb:	48 01 d0             	add    %rdx,%rax
  8025ce:	48 c1 e0 05          	shl    $0x5,%rax
  8025d2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8025d9:	00 00 00 
  8025dc:	48 01 c2             	add    %rax,%rdx
  8025df:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8025e6:	00 00 00 
  8025e9:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8025ec:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8025f1:	75 0e                	jne    802601 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  8025f3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8025fa:	00 00 00 
  8025fd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  802601:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802605:	48 89 c7             	mov    %rax,%rdi
  802608:	48 b8 dd 1d 80 00 00 	movabs $0x801ddd,%rax
  80260f:	00 00 00 
  802612:	ff d0                	callq  *%rax
  802614:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  802617:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80261b:	79 19                	jns    802636 <ipc_recv+0xb1>
		*from_env_store = 0;
  80261d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802621:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  802627:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80262b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  802631:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802634:	eb 53                	jmp    802689 <ipc_recv+0x104>
	}
	if(from_env_store)
  802636:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80263b:	74 19                	je     802656 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  80263d:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  802644:	00 00 00 
  802647:	48 8b 00             	mov    (%rax),%rax
  80264a:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802650:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802654:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  802656:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80265b:	74 19                	je     802676 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  80265d:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  802664:	00 00 00 
  802667:	48 8b 00             	mov    (%rax),%rax
  80266a:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802670:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802674:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  802676:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80267d:	00 00 00 
  802680:	48 8b 00             	mov    (%rax),%rax
  802683:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  802689:	c9                   	leaveq 
  80268a:	c3                   	retq   

000000000080268b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80268b:	55                   	push   %rbp
  80268c:	48 89 e5             	mov    %rsp,%rbp
  80268f:	48 83 ec 30          	sub    $0x30,%rsp
  802693:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802696:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802699:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80269d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8026a0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8026a5:	75 0e                	jne    8026b5 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8026a7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8026ae:	00 00 00 
  8026b1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8026b5:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8026b8:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8026bb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026c2:	89 c7                	mov    %eax,%edi
  8026c4:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  8026cb:	00 00 00 
  8026ce:	ff d0                	callq  *%rax
  8026d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8026d3:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8026d7:	75 0c                	jne    8026e5 <ipc_send+0x5a>
			sys_yield();
  8026d9:	48 b8 76 1b 80 00 00 	movabs $0x801b76,%rax
  8026e0:	00 00 00 
  8026e3:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8026e5:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8026e9:	74 ca                	je     8026b5 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8026eb:	c9                   	leaveq 
  8026ec:	c3                   	retq   

00000000008026ed <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8026ed:	55                   	push   %rbp
  8026ee:	48 89 e5             	mov    %rsp,%rbp
  8026f1:	48 83 ec 14          	sub    $0x14,%rsp
  8026f5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8026f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026ff:	eb 5e                	jmp    80275f <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802701:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802708:	00 00 00 
  80270b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80270e:	48 63 d0             	movslq %eax,%rdx
  802711:	48 89 d0             	mov    %rdx,%rax
  802714:	48 c1 e0 03          	shl    $0x3,%rax
  802718:	48 01 d0             	add    %rdx,%rax
  80271b:	48 c1 e0 05          	shl    $0x5,%rax
  80271f:	48 01 c8             	add    %rcx,%rax
  802722:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802728:	8b 00                	mov    (%rax),%eax
  80272a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80272d:	75 2c                	jne    80275b <ipc_find_env+0x6e>
			return envs[i].env_id;
  80272f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802736:	00 00 00 
  802739:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80273c:	48 63 d0             	movslq %eax,%rdx
  80273f:	48 89 d0             	mov    %rdx,%rax
  802742:	48 c1 e0 03          	shl    $0x3,%rax
  802746:	48 01 d0             	add    %rdx,%rax
  802749:	48 c1 e0 05          	shl    $0x5,%rax
  80274d:	48 01 c8             	add    %rcx,%rax
  802750:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802756:	8b 40 08             	mov    0x8(%rax),%eax
  802759:	eb 12                	jmp    80276d <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80275b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80275f:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802766:	7e 99                	jle    802701 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802768:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80276d:	c9                   	leaveq 
  80276e:	c3                   	retq   

000000000080276f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80276f:	55                   	push   %rbp
  802770:	48 89 e5             	mov    %rsp,%rbp
  802773:	48 83 ec 08          	sub    $0x8,%rsp
  802777:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80277b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80277f:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802786:	ff ff ff 
  802789:	48 01 d0             	add    %rdx,%rax
  80278c:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802790:	c9                   	leaveq 
  802791:	c3                   	retq   

0000000000802792 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802792:	55                   	push   %rbp
  802793:	48 89 e5             	mov    %rsp,%rbp
  802796:	48 83 ec 08          	sub    $0x8,%rsp
  80279a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80279e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027a2:	48 89 c7             	mov    %rax,%rdi
  8027a5:	48 b8 6f 27 80 00 00 	movabs $0x80276f,%rax
  8027ac:	00 00 00 
  8027af:	ff d0                	callq  *%rax
  8027b1:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8027b7:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8027bb:	c9                   	leaveq 
  8027bc:	c3                   	retq   

00000000008027bd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8027bd:	55                   	push   %rbp
  8027be:	48 89 e5             	mov    %rsp,%rbp
  8027c1:	48 83 ec 18          	sub    $0x18,%rsp
  8027c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8027c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027d0:	eb 6b                	jmp    80283d <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8027d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027d5:	48 98                	cltq   
  8027d7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027dd:	48 c1 e0 0c          	shl    $0xc,%rax
  8027e1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8027e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027e9:	48 c1 e8 15          	shr    $0x15,%rax
  8027ed:	48 89 c2             	mov    %rax,%rdx
  8027f0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8027f7:	01 00 00 
  8027fa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027fe:	83 e0 01             	and    $0x1,%eax
  802801:	48 85 c0             	test   %rax,%rax
  802804:	74 21                	je     802827 <fd_alloc+0x6a>
  802806:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80280a:	48 c1 e8 0c          	shr    $0xc,%rax
  80280e:	48 89 c2             	mov    %rax,%rdx
  802811:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802818:	01 00 00 
  80281b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80281f:	83 e0 01             	and    $0x1,%eax
  802822:	48 85 c0             	test   %rax,%rax
  802825:	75 12                	jne    802839 <fd_alloc+0x7c>
			*fd_store = fd;
  802827:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80282b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80282f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802832:	b8 00 00 00 00       	mov    $0x0,%eax
  802837:	eb 1a                	jmp    802853 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802839:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80283d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802841:	7e 8f                	jle    8027d2 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802843:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802847:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80284e:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802853:	c9                   	leaveq 
  802854:	c3                   	retq   

0000000000802855 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802855:	55                   	push   %rbp
  802856:	48 89 e5             	mov    %rsp,%rbp
  802859:	48 83 ec 20          	sub    $0x20,%rsp
  80285d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802860:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802864:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802868:	78 06                	js     802870 <fd_lookup+0x1b>
  80286a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80286e:	7e 07                	jle    802877 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802870:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802875:	eb 6c                	jmp    8028e3 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802877:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80287a:	48 98                	cltq   
  80287c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802882:	48 c1 e0 0c          	shl    $0xc,%rax
  802886:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80288a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80288e:	48 c1 e8 15          	shr    $0x15,%rax
  802892:	48 89 c2             	mov    %rax,%rdx
  802895:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80289c:	01 00 00 
  80289f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028a3:	83 e0 01             	and    $0x1,%eax
  8028a6:	48 85 c0             	test   %rax,%rax
  8028a9:	74 21                	je     8028cc <fd_lookup+0x77>
  8028ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028af:	48 c1 e8 0c          	shr    $0xc,%rax
  8028b3:	48 89 c2             	mov    %rax,%rdx
  8028b6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028bd:	01 00 00 
  8028c0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028c4:	83 e0 01             	and    $0x1,%eax
  8028c7:	48 85 c0             	test   %rax,%rax
  8028ca:	75 07                	jne    8028d3 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8028cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028d1:	eb 10                	jmp    8028e3 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8028d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028d7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8028db:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8028de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028e3:	c9                   	leaveq 
  8028e4:	c3                   	retq   

00000000008028e5 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8028e5:	55                   	push   %rbp
  8028e6:	48 89 e5             	mov    %rsp,%rbp
  8028e9:	48 83 ec 30          	sub    $0x30,%rsp
  8028ed:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8028f1:	89 f0                	mov    %esi,%eax
  8028f3:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8028f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028fa:	48 89 c7             	mov    %rax,%rdi
  8028fd:	48 b8 6f 27 80 00 00 	movabs $0x80276f,%rax
  802904:	00 00 00 
  802907:	ff d0                	callq  *%rax
  802909:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80290d:	48 89 d6             	mov    %rdx,%rsi
  802910:	89 c7                	mov    %eax,%edi
  802912:	48 b8 55 28 80 00 00 	movabs $0x802855,%rax
  802919:	00 00 00 
  80291c:	ff d0                	callq  *%rax
  80291e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802921:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802925:	78 0a                	js     802931 <fd_close+0x4c>
	    || fd != fd2)
  802927:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80292b:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80292f:	74 12                	je     802943 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802931:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802935:	74 05                	je     80293c <fd_close+0x57>
  802937:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80293a:	eb 05                	jmp    802941 <fd_close+0x5c>
  80293c:	b8 00 00 00 00       	mov    $0x0,%eax
  802941:	eb 69                	jmp    8029ac <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802943:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802947:	8b 00                	mov    (%rax),%eax
  802949:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80294d:	48 89 d6             	mov    %rdx,%rsi
  802950:	89 c7                	mov    %eax,%edi
  802952:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  802959:	00 00 00 
  80295c:	ff d0                	callq  *%rax
  80295e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802961:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802965:	78 2a                	js     802991 <fd_close+0xac>
		if (dev->dev_close)
  802967:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80296b:	48 8b 40 20          	mov    0x20(%rax),%rax
  80296f:	48 85 c0             	test   %rax,%rax
  802972:	74 16                	je     80298a <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802974:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802978:	48 8b 40 20          	mov    0x20(%rax),%rax
  80297c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802980:	48 89 d7             	mov    %rdx,%rdi
  802983:	ff d0                	callq  *%rax
  802985:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802988:	eb 07                	jmp    802991 <fd_close+0xac>
		else
			r = 0;
  80298a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802991:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802995:	48 89 c6             	mov    %rax,%rsi
  802998:	bf 00 00 00 00       	mov    $0x0,%edi
  80299d:	48 b8 5f 1c 80 00 00 	movabs $0x801c5f,%rax
  8029a4:	00 00 00 
  8029a7:	ff d0                	callq  *%rax
	return r;
  8029a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029ac:	c9                   	leaveq 
  8029ad:	c3                   	retq   

00000000008029ae <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8029ae:	55                   	push   %rbp
  8029af:	48 89 e5             	mov    %rsp,%rbp
  8029b2:	48 83 ec 20          	sub    $0x20,%rsp
  8029b6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8029bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029c4:	eb 41                	jmp    802a07 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8029c6:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8029cd:	00 00 00 
  8029d0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8029d3:	48 63 d2             	movslq %edx,%rdx
  8029d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029da:	8b 00                	mov    (%rax),%eax
  8029dc:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8029df:	75 22                	jne    802a03 <dev_lookup+0x55>
			*dev = devtab[i];
  8029e1:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8029e8:	00 00 00 
  8029eb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8029ee:	48 63 d2             	movslq %edx,%rdx
  8029f1:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8029f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029f9:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8029fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802a01:	eb 60                	jmp    802a63 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802a03:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a07:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802a0e:	00 00 00 
  802a11:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a14:	48 63 d2             	movslq %edx,%rdx
  802a17:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a1b:	48 85 c0             	test   %rax,%rax
  802a1e:	75 a6                	jne    8029c6 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802a20:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  802a27:	00 00 00 
  802a2a:	48 8b 00             	mov    (%rax),%rax
  802a2d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a33:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802a36:	89 c6                	mov    %eax,%esi
  802a38:	48 bf 00 51 80 00 00 	movabs $0x805100,%rdi
  802a3f:	00 00 00 
  802a42:	b8 00 00 00 00       	mov    $0x0,%eax
  802a47:	48 b9 d0 06 80 00 00 	movabs $0x8006d0,%rcx
  802a4e:	00 00 00 
  802a51:	ff d1                	callq  *%rcx
	*dev = 0;
  802a53:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a57:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802a5e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802a63:	c9                   	leaveq 
  802a64:	c3                   	retq   

0000000000802a65 <close>:

int
close(int fdnum)
{
  802a65:	55                   	push   %rbp
  802a66:	48 89 e5             	mov    %rsp,%rbp
  802a69:	48 83 ec 20          	sub    $0x20,%rsp
  802a6d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a70:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a74:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a77:	48 89 d6             	mov    %rdx,%rsi
  802a7a:	89 c7                	mov    %eax,%edi
  802a7c:	48 b8 55 28 80 00 00 	movabs $0x802855,%rax
  802a83:	00 00 00 
  802a86:	ff d0                	callq  *%rax
  802a88:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a8f:	79 05                	jns    802a96 <close+0x31>
		return r;
  802a91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a94:	eb 18                	jmp    802aae <close+0x49>
	else
		return fd_close(fd, 1);
  802a96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a9a:	be 01 00 00 00       	mov    $0x1,%esi
  802a9f:	48 89 c7             	mov    %rax,%rdi
  802aa2:	48 b8 e5 28 80 00 00 	movabs $0x8028e5,%rax
  802aa9:	00 00 00 
  802aac:	ff d0                	callq  *%rax
}
  802aae:	c9                   	leaveq 
  802aaf:	c3                   	retq   

0000000000802ab0 <close_all>:

void
close_all(void)
{
  802ab0:	55                   	push   %rbp
  802ab1:	48 89 e5             	mov    %rsp,%rbp
  802ab4:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802ab8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802abf:	eb 15                	jmp    802ad6 <close_all+0x26>
		close(i);
  802ac1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac4:	89 c7                	mov    %eax,%edi
  802ac6:	48 b8 65 2a 80 00 00 	movabs $0x802a65,%rax
  802acd:	00 00 00 
  802ad0:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802ad2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ad6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802ada:	7e e5                	jle    802ac1 <close_all+0x11>
		close(i);
}
  802adc:	c9                   	leaveq 
  802add:	c3                   	retq   

0000000000802ade <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802ade:	55                   	push   %rbp
  802adf:	48 89 e5             	mov    %rsp,%rbp
  802ae2:	48 83 ec 40          	sub    $0x40,%rsp
  802ae6:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802ae9:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802aec:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802af0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802af3:	48 89 d6             	mov    %rdx,%rsi
  802af6:	89 c7                	mov    %eax,%edi
  802af8:	48 b8 55 28 80 00 00 	movabs $0x802855,%rax
  802aff:	00 00 00 
  802b02:	ff d0                	callq  *%rax
  802b04:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b0b:	79 08                	jns    802b15 <dup+0x37>
		return r;
  802b0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b10:	e9 70 01 00 00       	jmpq   802c85 <dup+0x1a7>
	close(newfdnum);
  802b15:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b18:	89 c7                	mov    %eax,%edi
  802b1a:	48 b8 65 2a 80 00 00 	movabs $0x802a65,%rax
  802b21:	00 00 00 
  802b24:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802b26:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b29:	48 98                	cltq   
  802b2b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b31:	48 c1 e0 0c          	shl    $0xc,%rax
  802b35:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802b39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b3d:	48 89 c7             	mov    %rax,%rdi
  802b40:	48 b8 92 27 80 00 00 	movabs $0x802792,%rax
  802b47:	00 00 00 
  802b4a:	ff d0                	callq  *%rax
  802b4c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802b50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b54:	48 89 c7             	mov    %rax,%rdi
  802b57:	48 b8 92 27 80 00 00 	movabs $0x802792,%rax
  802b5e:	00 00 00 
  802b61:	ff d0                	callq  *%rax
  802b63:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802b67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b6b:	48 c1 e8 15          	shr    $0x15,%rax
  802b6f:	48 89 c2             	mov    %rax,%rdx
  802b72:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b79:	01 00 00 
  802b7c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b80:	83 e0 01             	and    $0x1,%eax
  802b83:	48 85 c0             	test   %rax,%rax
  802b86:	74 73                	je     802bfb <dup+0x11d>
  802b88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b8c:	48 c1 e8 0c          	shr    $0xc,%rax
  802b90:	48 89 c2             	mov    %rax,%rdx
  802b93:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b9a:	01 00 00 
  802b9d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ba1:	83 e0 01             	and    $0x1,%eax
  802ba4:	48 85 c0             	test   %rax,%rax
  802ba7:	74 52                	je     802bfb <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802ba9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bad:	48 c1 e8 0c          	shr    $0xc,%rax
  802bb1:	48 89 c2             	mov    %rax,%rdx
  802bb4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802bbb:	01 00 00 
  802bbe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bc2:	25 07 0e 00 00       	and    $0xe07,%eax
  802bc7:	89 c1                	mov    %eax,%ecx
  802bc9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802bcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd1:	41 89 c8             	mov    %ecx,%r8d
  802bd4:	48 89 d1             	mov    %rdx,%rcx
  802bd7:	ba 00 00 00 00       	mov    $0x0,%edx
  802bdc:	48 89 c6             	mov    %rax,%rsi
  802bdf:	bf 00 00 00 00       	mov    $0x0,%edi
  802be4:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  802beb:	00 00 00 
  802bee:	ff d0                	callq  *%rax
  802bf0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bf3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bf7:	79 02                	jns    802bfb <dup+0x11d>
			goto err;
  802bf9:	eb 57                	jmp    802c52 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802bfb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bff:	48 c1 e8 0c          	shr    $0xc,%rax
  802c03:	48 89 c2             	mov    %rax,%rdx
  802c06:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c0d:	01 00 00 
  802c10:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c14:	25 07 0e 00 00       	and    $0xe07,%eax
  802c19:	89 c1                	mov    %eax,%ecx
  802c1b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c1f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c23:	41 89 c8             	mov    %ecx,%r8d
  802c26:	48 89 d1             	mov    %rdx,%rcx
  802c29:	ba 00 00 00 00       	mov    $0x0,%edx
  802c2e:	48 89 c6             	mov    %rax,%rsi
  802c31:	bf 00 00 00 00       	mov    $0x0,%edi
  802c36:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  802c3d:	00 00 00 
  802c40:	ff d0                	callq  *%rax
  802c42:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c45:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c49:	79 02                	jns    802c4d <dup+0x16f>
		goto err;
  802c4b:	eb 05                	jmp    802c52 <dup+0x174>

	return newfdnum;
  802c4d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c50:	eb 33                	jmp    802c85 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802c52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c56:	48 89 c6             	mov    %rax,%rsi
  802c59:	bf 00 00 00 00       	mov    $0x0,%edi
  802c5e:	48 b8 5f 1c 80 00 00 	movabs $0x801c5f,%rax
  802c65:	00 00 00 
  802c68:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802c6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c6e:	48 89 c6             	mov    %rax,%rsi
  802c71:	bf 00 00 00 00       	mov    $0x0,%edi
  802c76:	48 b8 5f 1c 80 00 00 	movabs $0x801c5f,%rax
  802c7d:	00 00 00 
  802c80:	ff d0                	callq  *%rax
	return r;
  802c82:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c85:	c9                   	leaveq 
  802c86:	c3                   	retq   

0000000000802c87 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802c87:	55                   	push   %rbp
  802c88:	48 89 e5             	mov    %rsp,%rbp
  802c8b:	48 83 ec 40          	sub    $0x40,%rsp
  802c8f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c92:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c96:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c9a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c9e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ca1:	48 89 d6             	mov    %rdx,%rsi
  802ca4:	89 c7                	mov    %eax,%edi
  802ca6:	48 b8 55 28 80 00 00 	movabs $0x802855,%rax
  802cad:	00 00 00 
  802cb0:	ff d0                	callq  *%rax
  802cb2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cb5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cb9:	78 24                	js     802cdf <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802cbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cbf:	8b 00                	mov    (%rax),%eax
  802cc1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cc5:	48 89 d6             	mov    %rdx,%rsi
  802cc8:	89 c7                	mov    %eax,%edi
  802cca:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  802cd1:	00 00 00 
  802cd4:	ff d0                	callq  *%rax
  802cd6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cd9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cdd:	79 05                	jns    802ce4 <read+0x5d>
		return r;
  802cdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce2:	eb 76                	jmp    802d5a <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802ce4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce8:	8b 40 08             	mov    0x8(%rax),%eax
  802ceb:	83 e0 03             	and    $0x3,%eax
  802cee:	83 f8 01             	cmp    $0x1,%eax
  802cf1:	75 3a                	jne    802d2d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802cf3:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  802cfa:	00 00 00 
  802cfd:	48 8b 00             	mov    (%rax),%rax
  802d00:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d06:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d09:	89 c6                	mov    %eax,%esi
  802d0b:	48 bf 1f 51 80 00 00 	movabs $0x80511f,%rdi
  802d12:	00 00 00 
  802d15:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1a:	48 b9 d0 06 80 00 00 	movabs $0x8006d0,%rcx
  802d21:	00 00 00 
  802d24:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802d26:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d2b:	eb 2d                	jmp    802d5a <read+0xd3>
	}
	if (!dev->dev_read)
  802d2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d31:	48 8b 40 10          	mov    0x10(%rax),%rax
  802d35:	48 85 c0             	test   %rax,%rax
  802d38:	75 07                	jne    802d41 <read+0xba>
		return -E_NOT_SUPP;
  802d3a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d3f:	eb 19                	jmp    802d5a <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802d41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d45:	48 8b 40 10          	mov    0x10(%rax),%rax
  802d49:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802d4d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d51:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802d55:	48 89 cf             	mov    %rcx,%rdi
  802d58:	ff d0                	callq  *%rax
}
  802d5a:	c9                   	leaveq 
  802d5b:	c3                   	retq   

0000000000802d5c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802d5c:	55                   	push   %rbp
  802d5d:	48 89 e5             	mov    %rsp,%rbp
  802d60:	48 83 ec 30          	sub    $0x30,%rsp
  802d64:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d67:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d6b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d76:	eb 49                	jmp    802dc1 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802d78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d7b:	48 98                	cltq   
  802d7d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d81:	48 29 c2             	sub    %rax,%rdx
  802d84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d87:	48 63 c8             	movslq %eax,%rcx
  802d8a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d8e:	48 01 c1             	add    %rax,%rcx
  802d91:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d94:	48 89 ce             	mov    %rcx,%rsi
  802d97:	89 c7                	mov    %eax,%edi
  802d99:	48 b8 87 2c 80 00 00 	movabs $0x802c87,%rax
  802da0:	00 00 00 
  802da3:	ff d0                	callq  *%rax
  802da5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802da8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802dac:	79 05                	jns    802db3 <readn+0x57>
			return m;
  802dae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802db1:	eb 1c                	jmp    802dcf <readn+0x73>
		if (m == 0)
  802db3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802db7:	75 02                	jne    802dbb <readn+0x5f>
			break;
  802db9:	eb 11                	jmp    802dcc <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802dbb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dbe:	01 45 fc             	add    %eax,-0x4(%rbp)
  802dc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc4:	48 98                	cltq   
  802dc6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802dca:	72 ac                	jb     802d78 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802dcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802dcf:	c9                   	leaveq 
  802dd0:	c3                   	retq   

0000000000802dd1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802dd1:	55                   	push   %rbp
  802dd2:	48 89 e5             	mov    %rsp,%rbp
  802dd5:	48 83 ec 40          	sub    $0x40,%rsp
  802dd9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ddc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802de0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802de4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802de8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802deb:	48 89 d6             	mov    %rdx,%rsi
  802dee:	89 c7                	mov    %eax,%edi
  802df0:	48 b8 55 28 80 00 00 	movabs $0x802855,%rax
  802df7:	00 00 00 
  802dfa:	ff d0                	callq  *%rax
  802dfc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e03:	78 24                	js     802e29 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e09:	8b 00                	mov    (%rax),%eax
  802e0b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e0f:	48 89 d6             	mov    %rdx,%rsi
  802e12:	89 c7                	mov    %eax,%edi
  802e14:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  802e1b:	00 00 00 
  802e1e:	ff d0                	callq  *%rax
  802e20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e27:	79 05                	jns    802e2e <write+0x5d>
		return r;
  802e29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e2c:	eb 75                	jmp    802ea3 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e32:	8b 40 08             	mov    0x8(%rax),%eax
  802e35:	83 e0 03             	and    $0x3,%eax
  802e38:	85 c0                	test   %eax,%eax
  802e3a:	75 3a                	jne    802e76 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802e3c:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  802e43:	00 00 00 
  802e46:	48 8b 00             	mov    (%rax),%rax
  802e49:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e4f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e52:	89 c6                	mov    %eax,%esi
  802e54:	48 bf 3b 51 80 00 00 	movabs $0x80513b,%rdi
  802e5b:	00 00 00 
  802e5e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e63:	48 b9 d0 06 80 00 00 	movabs $0x8006d0,%rcx
  802e6a:	00 00 00 
  802e6d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802e6f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e74:	eb 2d                	jmp    802ea3 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802e76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e7a:	48 8b 40 18          	mov    0x18(%rax),%rax
  802e7e:	48 85 c0             	test   %rax,%rax
  802e81:	75 07                	jne    802e8a <write+0xb9>
		return -E_NOT_SUPP;
  802e83:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e88:	eb 19                	jmp    802ea3 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802e8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e8e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802e92:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802e96:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e9a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802e9e:	48 89 cf             	mov    %rcx,%rdi
  802ea1:	ff d0                	callq  *%rax
}
  802ea3:	c9                   	leaveq 
  802ea4:	c3                   	retq   

0000000000802ea5 <seek>:

int
seek(int fdnum, off_t offset)
{
  802ea5:	55                   	push   %rbp
  802ea6:	48 89 e5             	mov    %rsp,%rbp
  802ea9:	48 83 ec 18          	sub    $0x18,%rsp
  802ead:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802eb0:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802eb3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802eb7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802eba:	48 89 d6             	mov    %rdx,%rsi
  802ebd:	89 c7                	mov    %eax,%edi
  802ebf:	48 b8 55 28 80 00 00 	movabs $0x802855,%rax
  802ec6:	00 00 00 
  802ec9:	ff d0                	callq  *%rax
  802ecb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ece:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ed2:	79 05                	jns    802ed9 <seek+0x34>
		return r;
  802ed4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed7:	eb 0f                	jmp    802ee8 <seek+0x43>
	fd->fd_offset = offset;
  802ed9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802edd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ee0:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802ee3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ee8:	c9                   	leaveq 
  802ee9:	c3                   	retq   

0000000000802eea <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802eea:	55                   	push   %rbp
  802eeb:	48 89 e5             	mov    %rsp,%rbp
  802eee:	48 83 ec 30          	sub    $0x30,%rsp
  802ef2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ef5:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ef8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802efc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802eff:	48 89 d6             	mov    %rdx,%rsi
  802f02:	89 c7                	mov    %eax,%edi
  802f04:	48 b8 55 28 80 00 00 	movabs $0x802855,%rax
  802f0b:	00 00 00 
  802f0e:	ff d0                	callq  *%rax
  802f10:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f17:	78 24                	js     802f3d <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f1d:	8b 00                	mov    (%rax),%eax
  802f1f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f23:	48 89 d6             	mov    %rdx,%rsi
  802f26:	89 c7                	mov    %eax,%edi
  802f28:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  802f2f:	00 00 00 
  802f32:	ff d0                	callq  *%rax
  802f34:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f3b:	79 05                	jns    802f42 <ftruncate+0x58>
		return r;
  802f3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f40:	eb 72                	jmp    802fb4 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f46:	8b 40 08             	mov    0x8(%rax),%eax
  802f49:	83 e0 03             	and    $0x3,%eax
  802f4c:	85 c0                	test   %eax,%eax
  802f4e:	75 3a                	jne    802f8a <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802f50:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  802f57:	00 00 00 
  802f5a:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802f5d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f63:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f66:	89 c6                	mov    %eax,%esi
  802f68:	48 bf 58 51 80 00 00 	movabs $0x805158,%rdi
  802f6f:	00 00 00 
  802f72:	b8 00 00 00 00       	mov    $0x0,%eax
  802f77:	48 b9 d0 06 80 00 00 	movabs $0x8006d0,%rcx
  802f7e:	00 00 00 
  802f81:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802f83:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f88:	eb 2a                	jmp    802fb4 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802f8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f8e:	48 8b 40 30          	mov    0x30(%rax),%rax
  802f92:	48 85 c0             	test   %rax,%rax
  802f95:	75 07                	jne    802f9e <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802f97:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f9c:	eb 16                	jmp    802fb4 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802f9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fa2:	48 8b 40 30          	mov    0x30(%rax),%rax
  802fa6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802faa:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802fad:	89 ce                	mov    %ecx,%esi
  802faf:	48 89 d7             	mov    %rdx,%rdi
  802fb2:	ff d0                	callq  *%rax
}
  802fb4:	c9                   	leaveq 
  802fb5:	c3                   	retq   

0000000000802fb6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802fb6:	55                   	push   %rbp
  802fb7:	48 89 e5             	mov    %rsp,%rbp
  802fba:	48 83 ec 30          	sub    $0x30,%rsp
  802fbe:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802fc1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802fc5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802fc9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802fcc:	48 89 d6             	mov    %rdx,%rsi
  802fcf:	89 c7                	mov    %eax,%edi
  802fd1:	48 b8 55 28 80 00 00 	movabs $0x802855,%rax
  802fd8:	00 00 00 
  802fdb:	ff d0                	callq  *%rax
  802fdd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fe0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe4:	78 24                	js     80300a <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802fe6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fea:	8b 00                	mov    (%rax),%eax
  802fec:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ff0:	48 89 d6             	mov    %rdx,%rsi
  802ff3:	89 c7                	mov    %eax,%edi
  802ff5:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  802ffc:	00 00 00 
  802fff:	ff d0                	callq  *%rax
  803001:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803004:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803008:	79 05                	jns    80300f <fstat+0x59>
		return r;
  80300a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300d:	eb 5e                	jmp    80306d <fstat+0xb7>
	if (!dev->dev_stat)
  80300f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803013:	48 8b 40 28          	mov    0x28(%rax),%rax
  803017:	48 85 c0             	test   %rax,%rax
  80301a:	75 07                	jne    803023 <fstat+0x6d>
		return -E_NOT_SUPP;
  80301c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803021:	eb 4a                	jmp    80306d <fstat+0xb7>
	stat->st_name[0] = 0;
  803023:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803027:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80302a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80302e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803035:	00 00 00 
	stat->st_isdir = 0;
  803038:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80303c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803043:	00 00 00 
	stat->st_dev = dev;
  803046:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80304a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80304e:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803055:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803059:	48 8b 40 28          	mov    0x28(%rax),%rax
  80305d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803061:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803065:	48 89 ce             	mov    %rcx,%rsi
  803068:	48 89 d7             	mov    %rdx,%rdi
  80306b:	ff d0                	callq  *%rax
}
  80306d:	c9                   	leaveq 
  80306e:	c3                   	retq   

000000000080306f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80306f:	55                   	push   %rbp
  803070:	48 89 e5             	mov    %rsp,%rbp
  803073:	48 83 ec 20          	sub    $0x20,%rsp
  803077:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80307b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80307f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803083:	be 00 00 00 00       	mov    $0x0,%esi
  803088:	48 89 c7             	mov    %rax,%rdi
  80308b:	48 b8 5d 31 80 00 00 	movabs $0x80315d,%rax
  803092:	00 00 00 
  803095:	ff d0                	callq  *%rax
  803097:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80309a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80309e:	79 05                	jns    8030a5 <stat+0x36>
		return fd;
  8030a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a3:	eb 2f                	jmp    8030d4 <stat+0x65>
	r = fstat(fd, stat);
  8030a5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8030a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ac:	48 89 d6             	mov    %rdx,%rsi
  8030af:	89 c7                	mov    %eax,%edi
  8030b1:	48 b8 b6 2f 80 00 00 	movabs $0x802fb6,%rax
  8030b8:	00 00 00 
  8030bb:	ff d0                	callq  *%rax
  8030bd:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8030c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c3:	89 c7                	mov    %eax,%edi
  8030c5:	48 b8 65 2a 80 00 00 	movabs $0x802a65,%rax
  8030cc:	00 00 00 
  8030cf:	ff d0                	callq  *%rax
	return r;
  8030d1:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8030d4:	c9                   	leaveq 
  8030d5:	c3                   	retq   

00000000008030d6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8030d6:	55                   	push   %rbp
  8030d7:	48 89 e5             	mov    %rsp,%rbp
  8030da:	48 83 ec 10          	sub    $0x10,%rsp
  8030de:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8030e1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8030e5:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8030ec:	00 00 00 
  8030ef:	8b 00                	mov    (%rax),%eax
  8030f1:	85 c0                	test   %eax,%eax
  8030f3:	75 1d                	jne    803112 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8030f5:	bf 01 00 00 00       	mov    $0x1,%edi
  8030fa:	48 b8 ed 26 80 00 00 	movabs $0x8026ed,%rax
  803101:	00 00 00 
  803104:	ff d0                	callq  *%rax
  803106:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  80310d:	00 00 00 
  803110:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803112:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803119:	00 00 00 
  80311c:	8b 00                	mov    (%rax),%eax
  80311e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803121:	b9 07 00 00 00       	mov    $0x7,%ecx
  803126:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  80312d:	00 00 00 
  803130:	89 c7                	mov    %eax,%edi
  803132:	48 b8 8b 26 80 00 00 	movabs $0x80268b,%rax
  803139:	00 00 00 
  80313c:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80313e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803142:	ba 00 00 00 00       	mov    $0x0,%edx
  803147:	48 89 c6             	mov    %rax,%rsi
  80314a:	bf 00 00 00 00       	mov    $0x0,%edi
  80314f:	48 b8 85 25 80 00 00 	movabs $0x802585,%rax
  803156:	00 00 00 
  803159:	ff d0                	callq  *%rax
}
  80315b:	c9                   	leaveq 
  80315c:	c3                   	retq   

000000000080315d <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80315d:	55                   	push   %rbp
  80315e:	48 89 e5             	mov    %rsp,%rbp
  803161:	48 83 ec 30          	sub    $0x30,%rsp
  803165:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803169:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80316c:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  803173:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80317a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  803181:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803186:	75 08                	jne    803190 <open+0x33>
	{
		return r;
  803188:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318b:	e9 f2 00 00 00       	jmpq   803282 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  803190:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803194:	48 89 c7             	mov    %rax,%rdi
  803197:	48 b8 19 12 80 00 00 	movabs $0x801219,%rax
  80319e:	00 00 00 
  8031a1:	ff d0                	callq  *%rax
  8031a3:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8031a6:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8031ad:	7e 0a                	jle    8031b9 <open+0x5c>
	{
		return -E_BAD_PATH;
  8031af:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8031b4:	e9 c9 00 00 00       	jmpq   803282 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8031b9:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8031c0:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8031c1:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8031c5:	48 89 c7             	mov    %rax,%rdi
  8031c8:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  8031cf:	00 00 00 
  8031d2:	ff d0                	callq  *%rax
  8031d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031db:	78 09                	js     8031e6 <open+0x89>
  8031dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031e1:	48 85 c0             	test   %rax,%rax
  8031e4:	75 08                	jne    8031ee <open+0x91>
		{
			return r;
  8031e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e9:	e9 94 00 00 00       	jmpq   803282 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8031ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031f2:	ba 00 04 00 00       	mov    $0x400,%edx
  8031f7:	48 89 c6             	mov    %rax,%rsi
  8031fa:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803201:	00 00 00 
  803204:	48 b8 17 13 80 00 00 	movabs $0x801317,%rax
  80320b:	00 00 00 
  80320e:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  803210:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803217:	00 00 00 
  80321a:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80321d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  803223:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803227:	48 89 c6             	mov    %rax,%rsi
  80322a:	bf 01 00 00 00       	mov    $0x1,%edi
  80322f:	48 b8 d6 30 80 00 00 	movabs $0x8030d6,%rax
  803236:	00 00 00 
  803239:	ff d0                	callq  *%rax
  80323b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80323e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803242:	79 2b                	jns    80326f <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  803244:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803248:	be 00 00 00 00       	mov    $0x0,%esi
  80324d:	48 89 c7             	mov    %rax,%rdi
  803250:	48 b8 e5 28 80 00 00 	movabs $0x8028e5,%rax
  803257:	00 00 00 
  80325a:	ff d0                	callq  *%rax
  80325c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80325f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803263:	79 05                	jns    80326a <open+0x10d>
			{
				return d;
  803265:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803268:	eb 18                	jmp    803282 <open+0x125>
			}
			return r;
  80326a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80326d:	eb 13                	jmp    803282 <open+0x125>
		}	
		return fd2num(fd_store);
  80326f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803273:	48 89 c7             	mov    %rax,%rdi
  803276:	48 b8 6f 27 80 00 00 	movabs $0x80276f,%rax
  80327d:	00 00 00 
  803280:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  803282:	c9                   	leaveq 
  803283:	c3                   	retq   

0000000000803284 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803284:	55                   	push   %rbp
  803285:	48 89 e5             	mov    %rsp,%rbp
  803288:	48 83 ec 10          	sub    $0x10,%rsp
  80328c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803290:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803294:	8b 50 0c             	mov    0xc(%rax),%edx
  803297:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80329e:	00 00 00 
  8032a1:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8032a3:	be 00 00 00 00       	mov    $0x0,%esi
  8032a8:	bf 06 00 00 00       	mov    $0x6,%edi
  8032ad:	48 b8 d6 30 80 00 00 	movabs $0x8030d6,%rax
  8032b4:	00 00 00 
  8032b7:	ff d0                	callq  *%rax
}
  8032b9:	c9                   	leaveq 
  8032ba:	c3                   	retq   

00000000008032bb <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8032bb:	55                   	push   %rbp
  8032bc:	48 89 e5             	mov    %rsp,%rbp
  8032bf:	48 83 ec 30          	sub    $0x30,%rsp
  8032c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032cb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8032cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8032d6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8032db:	74 07                	je     8032e4 <devfile_read+0x29>
  8032dd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8032e2:	75 07                	jne    8032eb <devfile_read+0x30>
		return -E_INVAL;
  8032e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8032e9:	eb 77                	jmp    803362 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8032eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032ef:	8b 50 0c             	mov    0xc(%rax),%edx
  8032f2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032f9:	00 00 00 
  8032fc:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8032fe:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803305:	00 00 00 
  803308:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80330c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  803310:	be 00 00 00 00       	mov    $0x0,%esi
  803315:	bf 03 00 00 00       	mov    $0x3,%edi
  80331a:	48 b8 d6 30 80 00 00 	movabs $0x8030d6,%rax
  803321:	00 00 00 
  803324:	ff d0                	callq  *%rax
  803326:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803329:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80332d:	7f 05                	jg     803334 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80332f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803332:	eb 2e                	jmp    803362 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  803334:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803337:	48 63 d0             	movslq %eax,%rdx
  80333a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80333e:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803345:	00 00 00 
  803348:	48 89 c7             	mov    %rax,%rdi
  80334b:	48 b8 a9 15 80 00 00 	movabs $0x8015a9,%rax
  803352:	00 00 00 
  803355:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803357:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80335b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80335f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803362:	c9                   	leaveq 
  803363:	c3                   	retq   

0000000000803364 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803364:	55                   	push   %rbp
  803365:	48 89 e5             	mov    %rsp,%rbp
  803368:	48 83 ec 30          	sub    $0x30,%rsp
  80336c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803370:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803374:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  803378:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80337f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803384:	74 07                	je     80338d <devfile_write+0x29>
  803386:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80338b:	75 08                	jne    803395 <devfile_write+0x31>
		return r;
  80338d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803390:	e9 9a 00 00 00       	jmpq   80342f <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803395:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803399:	8b 50 0c             	mov    0xc(%rax),%edx
  80339c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033a3:	00 00 00 
  8033a6:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8033a8:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8033af:	00 
  8033b0:	76 08                	jbe    8033ba <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8033b2:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8033b9:	00 
	}
	fsipcbuf.write.req_n = n;
  8033ba:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033c1:	00 00 00 
  8033c4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8033c8:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8033cc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8033d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033d4:	48 89 c6             	mov    %rax,%rsi
  8033d7:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  8033de:	00 00 00 
  8033e1:	48 b8 a9 15 80 00 00 	movabs $0x8015a9,%rax
  8033e8:	00 00 00 
  8033eb:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8033ed:	be 00 00 00 00       	mov    $0x0,%esi
  8033f2:	bf 04 00 00 00       	mov    $0x4,%edi
  8033f7:	48 b8 d6 30 80 00 00 	movabs $0x8030d6,%rax
  8033fe:	00 00 00 
  803401:	ff d0                	callq  *%rax
  803403:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803406:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80340a:	7f 20                	jg     80342c <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80340c:	48 bf 7e 51 80 00 00 	movabs $0x80517e,%rdi
  803413:	00 00 00 
  803416:	b8 00 00 00 00       	mov    $0x0,%eax
  80341b:	48 ba d0 06 80 00 00 	movabs $0x8006d0,%rdx
  803422:	00 00 00 
  803425:	ff d2                	callq  *%rdx
		return r;
  803427:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80342a:	eb 03                	jmp    80342f <devfile_write+0xcb>
	}
	return r;
  80342c:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80342f:	c9                   	leaveq 
  803430:	c3                   	retq   

0000000000803431 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803431:	55                   	push   %rbp
  803432:	48 89 e5             	mov    %rsp,%rbp
  803435:	48 83 ec 20          	sub    $0x20,%rsp
  803439:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80343d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803441:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803445:	8b 50 0c             	mov    0xc(%rax),%edx
  803448:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80344f:	00 00 00 
  803452:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803454:	be 00 00 00 00       	mov    $0x0,%esi
  803459:	bf 05 00 00 00       	mov    $0x5,%edi
  80345e:	48 b8 d6 30 80 00 00 	movabs $0x8030d6,%rax
  803465:	00 00 00 
  803468:	ff d0                	callq  *%rax
  80346a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80346d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803471:	79 05                	jns    803478 <devfile_stat+0x47>
		return r;
  803473:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803476:	eb 56                	jmp    8034ce <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803478:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80347c:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803483:	00 00 00 
  803486:	48 89 c7             	mov    %rax,%rdi
  803489:	48 b8 85 12 80 00 00 	movabs $0x801285,%rax
  803490:	00 00 00 
  803493:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803495:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80349c:	00 00 00 
  80349f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8034a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034a9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8034af:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8034b6:	00 00 00 
  8034b9:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8034bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034c3:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8034c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034ce:	c9                   	leaveq 
  8034cf:	c3                   	retq   

00000000008034d0 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8034d0:	55                   	push   %rbp
  8034d1:	48 89 e5             	mov    %rsp,%rbp
  8034d4:	48 83 ec 10          	sub    $0x10,%rsp
  8034d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034dc:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8034df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034e3:	8b 50 0c             	mov    0xc(%rax),%edx
  8034e6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8034ed:	00 00 00 
  8034f0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8034f2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8034f9:	00 00 00 
  8034fc:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8034ff:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803502:	be 00 00 00 00       	mov    $0x0,%esi
  803507:	bf 02 00 00 00       	mov    $0x2,%edi
  80350c:	48 b8 d6 30 80 00 00 	movabs $0x8030d6,%rax
  803513:	00 00 00 
  803516:	ff d0                	callq  *%rax
}
  803518:	c9                   	leaveq 
  803519:	c3                   	retq   

000000000080351a <remove>:

// Delete a file
int
remove(const char *path)
{
  80351a:	55                   	push   %rbp
  80351b:	48 89 e5             	mov    %rsp,%rbp
  80351e:	48 83 ec 10          	sub    $0x10,%rsp
  803522:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803526:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80352a:	48 89 c7             	mov    %rax,%rdi
  80352d:	48 b8 19 12 80 00 00 	movabs $0x801219,%rax
  803534:	00 00 00 
  803537:	ff d0                	callq  *%rax
  803539:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80353e:	7e 07                	jle    803547 <remove+0x2d>
		return -E_BAD_PATH;
  803540:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803545:	eb 33                	jmp    80357a <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803547:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80354b:	48 89 c6             	mov    %rax,%rsi
  80354e:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803555:	00 00 00 
  803558:	48 b8 85 12 80 00 00 	movabs $0x801285,%rax
  80355f:	00 00 00 
  803562:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803564:	be 00 00 00 00       	mov    $0x0,%esi
  803569:	bf 07 00 00 00       	mov    $0x7,%edi
  80356e:	48 b8 d6 30 80 00 00 	movabs $0x8030d6,%rax
  803575:	00 00 00 
  803578:	ff d0                	callq  *%rax
}
  80357a:	c9                   	leaveq 
  80357b:	c3                   	retq   

000000000080357c <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80357c:	55                   	push   %rbp
  80357d:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803580:	be 00 00 00 00       	mov    $0x0,%esi
  803585:	bf 08 00 00 00       	mov    $0x8,%edi
  80358a:	48 b8 d6 30 80 00 00 	movabs $0x8030d6,%rax
  803591:	00 00 00 
  803594:	ff d0                	callq  *%rax
}
  803596:	5d                   	pop    %rbp
  803597:	c3                   	retq   

0000000000803598 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803598:	55                   	push   %rbp
  803599:	48 89 e5             	mov    %rsp,%rbp
  80359c:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8035a3:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8035aa:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8035b1:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8035b8:	be 00 00 00 00       	mov    $0x0,%esi
  8035bd:	48 89 c7             	mov    %rax,%rdi
  8035c0:	48 b8 5d 31 80 00 00 	movabs $0x80315d,%rax
  8035c7:	00 00 00 
  8035ca:	ff d0                	callq  *%rax
  8035cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8035cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035d3:	79 28                	jns    8035fd <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8035d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d8:	89 c6                	mov    %eax,%esi
  8035da:	48 bf 9a 51 80 00 00 	movabs $0x80519a,%rdi
  8035e1:	00 00 00 
  8035e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8035e9:	48 ba d0 06 80 00 00 	movabs $0x8006d0,%rdx
  8035f0:	00 00 00 
  8035f3:	ff d2                	callq  *%rdx
		return fd_src;
  8035f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f8:	e9 74 01 00 00       	jmpq   803771 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8035fd:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803604:	be 01 01 00 00       	mov    $0x101,%esi
  803609:	48 89 c7             	mov    %rax,%rdi
  80360c:	48 b8 5d 31 80 00 00 	movabs $0x80315d,%rax
  803613:	00 00 00 
  803616:	ff d0                	callq  *%rax
  803618:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80361b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80361f:	79 39                	jns    80365a <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803621:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803624:	89 c6                	mov    %eax,%esi
  803626:	48 bf b0 51 80 00 00 	movabs $0x8051b0,%rdi
  80362d:	00 00 00 
  803630:	b8 00 00 00 00       	mov    $0x0,%eax
  803635:	48 ba d0 06 80 00 00 	movabs $0x8006d0,%rdx
  80363c:	00 00 00 
  80363f:	ff d2                	callq  *%rdx
		close(fd_src);
  803641:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803644:	89 c7                	mov    %eax,%edi
  803646:	48 b8 65 2a 80 00 00 	movabs $0x802a65,%rax
  80364d:	00 00 00 
  803650:	ff d0                	callq  *%rax
		return fd_dest;
  803652:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803655:	e9 17 01 00 00       	jmpq   803771 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80365a:	eb 74                	jmp    8036d0 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80365c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80365f:	48 63 d0             	movslq %eax,%rdx
  803662:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803669:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80366c:	48 89 ce             	mov    %rcx,%rsi
  80366f:	89 c7                	mov    %eax,%edi
  803671:	48 b8 d1 2d 80 00 00 	movabs $0x802dd1,%rax
  803678:	00 00 00 
  80367b:	ff d0                	callq  *%rax
  80367d:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803680:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803684:	79 4a                	jns    8036d0 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803686:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803689:	89 c6                	mov    %eax,%esi
  80368b:	48 bf ca 51 80 00 00 	movabs $0x8051ca,%rdi
  803692:	00 00 00 
  803695:	b8 00 00 00 00       	mov    $0x0,%eax
  80369a:	48 ba d0 06 80 00 00 	movabs $0x8006d0,%rdx
  8036a1:	00 00 00 
  8036a4:	ff d2                	callq  *%rdx
			close(fd_src);
  8036a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a9:	89 c7                	mov    %eax,%edi
  8036ab:	48 b8 65 2a 80 00 00 	movabs $0x802a65,%rax
  8036b2:	00 00 00 
  8036b5:	ff d0                	callq  *%rax
			close(fd_dest);
  8036b7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036ba:	89 c7                	mov    %eax,%edi
  8036bc:	48 b8 65 2a 80 00 00 	movabs $0x802a65,%rax
  8036c3:	00 00 00 
  8036c6:	ff d0                	callq  *%rax
			return write_size;
  8036c8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8036cb:	e9 a1 00 00 00       	jmpq   803771 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8036d0:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8036d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036da:	ba 00 02 00 00       	mov    $0x200,%edx
  8036df:	48 89 ce             	mov    %rcx,%rsi
  8036e2:	89 c7                	mov    %eax,%edi
  8036e4:	48 b8 87 2c 80 00 00 	movabs $0x802c87,%rax
  8036eb:	00 00 00 
  8036ee:	ff d0                	callq  *%rax
  8036f0:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8036f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8036f7:	0f 8f 5f ff ff ff    	jg     80365c <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8036fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803701:	79 47                	jns    80374a <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803703:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803706:	89 c6                	mov    %eax,%esi
  803708:	48 bf dd 51 80 00 00 	movabs $0x8051dd,%rdi
  80370f:	00 00 00 
  803712:	b8 00 00 00 00       	mov    $0x0,%eax
  803717:	48 ba d0 06 80 00 00 	movabs $0x8006d0,%rdx
  80371e:	00 00 00 
  803721:	ff d2                	callq  *%rdx
		close(fd_src);
  803723:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803726:	89 c7                	mov    %eax,%edi
  803728:	48 b8 65 2a 80 00 00 	movabs $0x802a65,%rax
  80372f:	00 00 00 
  803732:	ff d0                	callq  *%rax
		close(fd_dest);
  803734:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803737:	89 c7                	mov    %eax,%edi
  803739:	48 b8 65 2a 80 00 00 	movabs $0x802a65,%rax
  803740:	00 00 00 
  803743:	ff d0                	callq  *%rax
		return read_size;
  803745:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803748:	eb 27                	jmp    803771 <copy+0x1d9>
	}
	close(fd_src);
  80374a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80374d:	89 c7                	mov    %eax,%edi
  80374f:	48 b8 65 2a 80 00 00 	movabs $0x802a65,%rax
  803756:	00 00 00 
  803759:	ff d0                	callq  *%rax
	close(fd_dest);
  80375b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80375e:	89 c7                	mov    %eax,%edi
  803760:	48 b8 65 2a 80 00 00 	movabs $0x802a65,%rax
  803767:	00 00 00 
  80376a:	ff d0                	callq  *%rax
	return 0;
  80376c:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803771:	c9                   	leaveq 
  803772:	c3                   	retq   

0000000000803773 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803773:	55                   	push   %rbp
  803774:	48 89 e5             	mov    %rsp,%rbp
  803777:	48 83 ec 20          	sub    $0x20,%rsp
  80377b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80377e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803782:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803785:	48 89 d6             	mov    %rdx,%rsi
  803788:	89 c7                	mov    %eax,%edi
  80378a:	48 b8 55 28 80 00 00 	movabs $0x802855,%rax
  803791:	00 00 00 
  803794:	ff d0                	callq  *%rax
  803796:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803799:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80379d:	79 05                	jns    8037a4 <fd2sockid+0x31>
		return r;
  80379f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a2:	eb 24                	jmp    8037c8 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8037a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037a8:	8b 10                	mov    (%rax),%edx
  8037aa:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8037b1:	00 00 00 
  8037b4:	8b 00                	mov    (%rax),%eax
  8037b6:	39 c2                	cmp    %eax,%edx
  8037b8:	74 07                	je     8037c1 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8037ba:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8037bf:	eb 07                	jmp    8037c8 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8037c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c5:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8037c8:	c9                   	leaveq 
  8037c9:	c3                   	retq   

00000000008037ca <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8037ca:	55                   	push   %rbp
  8037cb:	48 89 e5             	mov    %rsp,%rbp
  8037ce:	48 83 ec 20          	sub    $0x20,%rsp
  8037d2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8037d5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8037d9:	48 89 c7             	mov    %rax,%rdi
  8037dc:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  8037e3:	00 00 00 
  8037e6:	ff d0                	callq  *%rax
  8037e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037ef:	78 26                	js     803817 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8037f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037f5:	ba 07 04 00 00       	mov    $0x407,%edx
  8037fa:	48 89 c6             	mov    %rax,%rsi
  8037fd:	bf 00 00 00 00       	mov    $0x0,%edi
  803802:	48 b8 b4 1b 80 00 00 	movabs $0x801bb4,%rax
  803809:	00 00 00 
  80380c:	ff d0                	callq  *%rax
  80380e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803811:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803815:	79 16                	jns    80382d <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803817:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80381a:	89 c7                	mov    %eax,%edi
  80381c:	48 b8 d7 3c 80 00 00 	movabs $0x803cd7,%rax
  803823:	00 00 00 
  803826:	ff d0                	callq  *%rax
		return r;
  803828:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80382b:	eb 3a                	jmp    803867 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80382d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803831:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803838:	00 00 00 
  80383b:	8b 12                	mov    (%rdx),%edx
  80383d:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80383f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803843:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80384a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80384e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803851:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803854:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803858:	48 89 c7             	mov    %rax,%rdi
  80385b:	48 b8 6f 27 80 00 00 	movabs $0x80276f,%rax
  803862:	00 00 00 
  803865:	ff d0                	callq  *%rax
}
  803867:	c9                   	leaveq 
  803868:	c3                   	retq   

0000000000803869 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803869:	55                   	push   %rbp
  80386a:	48 89 e5             	mov    %rsp,%rbp
  80386d:	48 83 ec 30          	sub    $0x30,%rsp
  803871:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803874:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803878:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80387c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80387f:	89 c7                	mov    %eax,%edi
  803881:	48 b8 73 37 80 00 00 	movabs $0x803773,%rax
  803888:	00 00 00 
  80388b:	ff d0                	callq  *%rax
  80388d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803890:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803894:	79 05                	jns    80389b <accept+0x32>
		return r;
  803896:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803899:	eb 3b                	jmp    8038d6 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80389b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80389f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8038a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038a6:	48 89 ce             	mov    %rcx,%rsi
  8038a9:	89 c7                	mov    %eax,%edi
  8038ab:	48 b8 b4 3b 80 00 00 	movabs $0x803bb4,%rax
  8038b2:	00 00 00 
  8038b5:	ff d0                	callq  *%rax
  8038b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038be:	79 05                	jns    8038c5 <accept+0x5c>
		return r;
  8038c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c3:	eb 11                	jmp    8038d6 <accept+0x6d>
	return alloc_sockfd(r);
  8038c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c8:	89 c7                	mov    %eax,%edi
  8038ca:	48 b8 ca 37 80 00 00 	movabs $0x8037ca,%rax
  8038d1:	00 00 00 
  8038d4:	ff d0                	callq  *%rax
}
  8038d6:	c9                   	leaveq 
  8038d7:	c3                   	retq   

00000000008038d8 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8038d8:	55                   	push   %rbp
  8038d9:	48 89 e5             	mov    %rsp,%rbp
  8038dc:	48 83 ec 20          	sub    $0x20,%rsp
  8038e0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038e7:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038ed:	89 c7                	mov    %eax,%edi
  8038ef:	48 b8 73 37 80 00 00 	movabs $0x803773,%rax
  8038f6:	00 00 00 
  8038f9:	ff d0                	callq  *%rax
  8038fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803902:	79 05                	jns    803909 <bind+0x31>
		return r;
  803904:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803907:	eb 1b                	jmp    803924 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803909:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80390c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803910:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803913:	48 89 ce             	mov    %rcx,%rsi
  803916:	89 c7                	mov    %eax,%edi
  803918:	48 b8 33 3c 80 00 00 	movabs $0x803c33,%rax
  80391f:	00 00 00 
  803922:	ff d0                	callq  *%rax
}
  803924:	c9                   	leaveq 
  803925:	c3                   	retq   

0000000000803926 <shutdown>:

int
shutdown(int s, int how)
{
  803926:	55                   	push   %rbp
  803927:	48 89 e5             	mov    %rsp,%rbp
  80392a:	48 83 ec 20          	sub    $0x20,%rsp
  80392e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803931:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803934:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803937:	89 c7                	mov    %eax,%edi
  803939:	48 b8 73 37 80 00 00 	movabs $0x803773,%rax
  803940:	00 00 00 
  803943:	ff d0                	callq  *%rax
  803945:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803948:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80394c:	79 05                	jns    803953 <shutdown+0x2d>
		return r;
  80394e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803951:	eb 16                	jmp    803969 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803953:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803956:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803959:	89 d6                	mov    %edx,%esi
  80395b:	89 c7                	mov    %eax,%edi
  80395d:	48 b8 97 3c 80 00 00 	movabs $0x803c97,%rax
  803964:	00 00 00 
  803967:	ff d0                	callq  *%rax
}
  803969:	c9                   	leaveq 
  80396a:	c3                   	retq   

000000000080396b <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80396b:	55                   	push   %rbp
  80396c:	48 89 e5             	mov    %rsp,%rbp
  80396f:	48 83 ec 10          	sub    $0x10,%rsp
  803973:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803977:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80397b:	48 89 c7             	mov    %rax,%rdi
  80397e:	48 b8 3b 49 80 00 00 	movabs $0x80493b,%rax
  803985:	00 00 00 
  803988:	ff d0                	callq  *%rax
  80398a:	83 f8 01             	cmp    $0x1,%eax
  80398d:	75 17                	jne    8039a6 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80398f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803993:	8b 40 0c             	mov    0xc(%rax),%eax
  803996:	89 c7                	mov    %eax,%edi
  803998:	48 b8 d7 3c 80 00 00 	movabs $0x803cd7,%rax
  80399f:	00 00 00 
  8039a2:	ff d0                	callq  *%rax
  8039a4:	eb 05                	jmp    8039ab <devsock_close+0x40>
	else
		return 0;
  8039a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039ab:	c9                   	leaveq 
  8039ac:	c3                   	retq   

00000000008039ad <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8039ad:	55                   	push   %rbp
  8039ae:	48 89 e5             	mov    %rsp,%rbp
  8039b1:	48 83 ec 20          	sub    $0x20,%rsp
  8039b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039bc:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8039bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039c2:	89 c7                	mov    %eax,%edi
  8039c4:	48 b8 73 37 80 00 00 	movabs $0x803773,%rax
  8039cb:	00 00 00 
  8039ce:	ff d0                	callq  *%rax
  8039d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039d7:	79 05                	jns    8039de <connect+0x31>
		return r;
  8039d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039dc:	eb 1b                	jmp    8039f9 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8039de:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8039e1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8039e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039e8:	48 89 ce             	mov    %rcx,%rsi
  8039eb:	89 c7                	mov    %eax,%edi
  8039ed:	48 b8 04 3d 80 00 00 	movabs $0x803d04,%rax
  8039f4:	00 00 00 
  8039f7:	ff d0                	callq  *%rax
}
  8039f9:	c9                   	leaveq 
  8039fa:	c3                   	retq   

00000000008039fb <listen>:

int
listen(int s, int backlog)
{
  8039fb:	55                   	push   %rbp
  8039fc:	48 89 e5             	mov    %rsp,%rbp
  8039ff:	48 83 ec 20          	sub    $0x20,%rsp
  803a03:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a06:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a09:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a0c:	89 c7                	mov    %eax,%edi
  803a0e:	48 b8 73 37 80 00 00 	movabs $0x803773,%rax
  803a15:	00 00 00 
  803a18:	ff d0                	callq  *%rax
  803a1a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a21:	79 05                	jns    803a28 <listen+0x2d>
		return r;
  803a23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a26:	eb 16                	jmp    803a3e <listen+0x43>
	return nsipc_listen(r, backlog);
  803a28:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a2e:	89 d6                	mov    %edx,%esi
  803a30:	89 c7                	mov    %eax,%edi
  803a32:	48 b8 68 3d 80 00 00 	movabs $0x803d68,%rax
  803a39:	00 00 00 
  803a3c:	ff d0                	callq  *%rax
}
  803a3e:	c9                   	leaveq 
  803a3f:	c3                   	retq   

0000000000803a40 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803a40:	55                   	push   %rbp
  803a41:	48 89 e5             	mov    %rsp,%rbp
  803a44:	48 83 ec 20          	sub    $0x20,%rsp
  803a48:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a4c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a50:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803a54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a58:	89 c2                	mov    %eax,%edx
  803a5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a5e:	8b 40 0c             	mov    0xc(%rax),%eax
  803a61:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803a65:	b9 00 00 00 00       	mov    $0x0,%ecx
  803a6a:	89 c7                	mov    %eax,%edi
  803a6c:	48 b8 a8 3d 80 00 00 	movabs $0x803da8,%rax
  803a73:	00 00 00 
  803a76:	ff d0                	callq  *%rax
}
  803a78:	c9                   	leaveq 
  803a79:	c3                   	retq   

0000000000803a7a <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803a7a:	55                   	push   %rbp
  803a7b:	48 89 e5             	mov    %rsp,%rbp
  803a7e:	48 83 ec 20          	sub    $0x20,%rsp
  803a82:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a86:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a8a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803a8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a92:	89 c2                	mov    %eax,%edx
  803a94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a98:	8b 40 0c             	mov    0xc(%rax),%eax
  803a9b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803a9f:	b9 00 00 00 00       	mov    $0x0,%ecx
  803aa4:	89 c7                	mov    %eax,%edi
  803aa6:	48 b8 74 3e 80 00 00 	movabs $0x803e74,%rax
  803aad:	00 00 00 
  803ab0:	ff d0                	callq  *%rax
}
  803ab2:	c9                   	leaveq 
  803ab3:	c3                   	retq   

0000000000803ab4 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803ab4:	55                   	push   %rbp
  803ab5:	48 89 e5             	mov    %rsp,%rbp
  803ab8:	48 83 ec 10          	sub    $0x10,%rsp
  803abc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ac0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803ac4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ac8:	48 be f8 51 80 00 00 	movabs $0x8051f8,%rsi
  803acf:	00 00 00 
  803ad2:	48 89 c7             	mov    %rax,%rdi
  803ad5:	48 b8 85 12 80 00 00 	movabs $0x801285,%rax
  803adc:	00 00 00 
  803adf:	ff d0                	callq  *%rax
	return 0;
  803ae1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ae6:	c9                   	leaveq 
  803ae7:	c3                   	retq   

0000000000803ae8 <socket>:

int
socket(int domain, int type, int protocol)
{
  803ae8:	55                   	push   %rbp
  803ae9:	48 89 e5             	mov    %rsp,%rbp
  803aec:	48 83 ec 20          	sub    $0x20,%rsp
  803af0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803af3:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803af6:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803af9:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803afc:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803aff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b02:	89 ce                	mov    %ecx,%esi
  803b04:	89 c7                	mov    %eax,%edi
  803b06:	48 b8 2c 3f 80 00 00 	movabs $0x803f2c,%rax
  803b0d:	00 00 00 
  803b10:	ff d0                	callq  *%rax
  803b12:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b19:	79 05                	jns    803b20 <socket+0x38>
		return r;
  803b1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b1e:	eb 11                	jmp    803b31 <socket+0x49>
	return alloc_sockfd(r);
  803b20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b23:	89 c7                	mov    %eax,%edi
  803b25:	48 b8 ca 37 80 00 00 	movabs $0x8037ca,%rax
  803b2c:	00 00 00 
  803b2f:	ff d0                	callq  *%rax
}
  803b31:	c9                   	leaveq 
  803b32:	c3                   	retq   

0000000000803b33 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803b33:	55                   	push   %rbp
  803b34:	48 89 e5             	mov    %rsp,%rbp
  803b37:	48 83 ec 10          	sub    $0x10,%rsp
  803b3b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803b3e:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803b45:	00 00 00 
  803b48:	8b 00                	mov    (%rax),%eax
  803b4a:	85 c0                	test   %eax,%eax
  803b4c:	75 1d                	jne    803b6b <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803b4e:	bf 02 00 00 00       	mov    $0x2,%edi
  803b53:	48 b8 ed 26 80 00 00 	movabs $0x8026ed,%rax
  803b5a:	00 00 00 
  803b5d:	ff d0                	callq  *%rax
  803b5f:	48 ba 08 80 80 00 00 	movabs $0x808008,%rdx
  803b66:	00 00 00 
  803b69:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803b6b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803b72:	00 00 00 
  803b75:	8b 00                	mov    (%rax),%eax
  803b77:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803b7a:	b9 07 00 00 00       	mov    $0x7,%ecx
  803b7f:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803b86:	00 00 00 
  803b89:	89 c7                	mov    %eax,%edi
  803b8b:	48 b8 8b 26 80 00 00 	movabs $0x80268b,%rax
  803b92:	00 00 00 
  803b95:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803b97:	ba 00 00 00 00       	mov    $0x0,%edx
  803b9c:	be 00 00 00 00       	mov    $0x0,%esi
  803ba1:	bf 00 00 00 00       	mov    $0x0,%edi
  803ba6:	48 b8 85 25 80 00 00 	movabs $0x802585,%rax
  803bad:	00 00 00 
  803bb0:	ff d0                	callq  *%rax
}
  803bb2:	c9                   	leaveq 
  803bb3:	c3                   	retq   

0000000000803bb4 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803bb4:	55                   	push   %rbp
  803bb5:	48 89 e5             	mov    %rsp,%rbp
  803bb8:	48 83 ec 30          	sub    $0x30,%rsp
  803bbc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803bbf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bc3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803bc7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bce:	00 00 00 
  803bd1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803bd4:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803bd6:	bf 01 00 00 00       	mov    $0x1,%edi
  803bdb:	48 b8 33 3b 80 00 00 	movabs $0x803b33,%rax
  803be2:	00 00 00 
  803be5:	ff d0                	callq  *%rax
  803be7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bee:	78 3e                	js     803c2e <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803bf0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bf7:	00 00 00 
  803bfa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803bfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c02:	8b 40 10             	mov    0x10(%rax),%eax
  803c05:	89 c2                	mov    %eax,%edx
  803c07:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803c0b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c0f:	48 89 ce             	mov    %rcx,%rsi
  803c12:	48 89 c7             	mov    %rax,%rdi
  803c15:	48 b8 a9 15 80 00 00 	movabs $0x8015a9,%rax
  803c1c:	00 00 00 
  803c1f:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803c21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c25:	8b 50 10             	mov    0x10(%rax),%edx
  803c28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c2c:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803c2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c31:	c9                   	leaveq 
  803c32:	c3                   	retq   

0000000000803c33 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803c33:	55                   	push   %rbp
  803c34:	48 89 e5             	mov    %rsp,%rbp
  803c37:	48 83 ec 10          	sub    $0x10,%rsp
  803c3b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c3e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c42:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803c45:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c4c:	00 00 00 
  803c4f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c52:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803c54:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c5b:	48 89 c6             	mov    %rax,%rsi
  803c5e:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803c65:	00 00 00 
  803c68:	48 b8 a9 15 80 00 00 	movabs $0x8015a9,%rax
  803c6f:	00 00 00 
  803c72:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803c74:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c7b:	00 00 00 
  803c7e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c81:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803c84:	bf 02 00 00 00       	mov    $0x2,%edi
  803c89:	48 b8 33 3b 80 00 00 	movabs $0x803b33,%rax
  803c90:	00 00 00 
  803c93:	ff d0                	callq  *%rax
}
  803c95:	c9                   	leaveq 
  803c96:	c3                   	retq   

0000000000803c97 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803c97:	55                   	push   %rbp
  803c98:	48 89 e5             	mov    %rsp,%rbp
  803c9b:	48 83 ec 10          	sub    $0x10,%rsp
  803c9f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ca2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803ca5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cac:	00 00 00 
  803caf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803cb2:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803cb4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cbb:	00 00 00 
  803cbe:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cc1:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803cc4:	bf 03 00 00 00       	mov    $0x3,%edi
  803cc9:	48 b8 33 3b 80 00 00 	movabs $0x803b33,%rax
  803cd0:	00 00 00 
  803cd3:	ff d0                	callq  *%rax
}
  803cd5:	c9                   	leaveq 
  803cd6:	c3                   	retq   

0000000000803cd7 <nsipc_close>:

int
nsipc_close(int s)
{
  803cd7:	55                   	push   %rbp
  803cd8:	48 89 e5             	mov    %rsp,%rbp
  803cdb:	48 83 ec 10          	sub    $0x10,%rsp
  803cdf:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803ce2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ce9:	00 00 00 
  803cec:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803cef:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803cf1:	bf 04 00 00 00       	mov    $0x4,%edi
  803cf6:	48 b8 33 3b 80 00 00 	movabs $0x803b33,%rax
  803cfd:	00 00 00 
  803d00:	ff d0                	callq  *%rax
}
  803d02:	c9                   	leaveq 
  803d03:	c3                   	retq   

0000000000803d04 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803d04:	55                   	push   %rbp
  803d05:	48 89 e5             	mov    %rsp,%rbp
  803d08:	48 83 ec 10          	sub    $0x10,%rsp
  803d0c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d0f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d13:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803d16:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d1d:	00 00 00 
  803d20:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d23:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803d25:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d2c:	48 89 c6             	mov    %rax,%rsi
  803d2f:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803d36:	00 00 00 
  803d39:	48 b8 a9 15 80 00 00 	movabs $0x8015a9,%rax
  803d40:	00 00 00 
  803d43:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803d45:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d4c:	00 00 00 
  803d4f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d52:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803d55:	bf 05 00 00 00       	mov    $0x5,%edi
  803d5a:	48 b8 33 3b 80 00 00 	movabs $0x803b33,%rax
  803d61:	00 00 00 
  803d64:	ff d0                	callq  *%rax
}
  803d66:	c9                   	leaveq 
  803d67:	c3                   	retq   

0000000000803d68 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803d68:	55                   	push   %rbp
  803d69:	48 89 e5             	mov    %rsp,%rbp
  803d6c:	48 83 ec 10          	sub    $0x10,%rsp
  803d70:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d73:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803d76:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d7d:	00 00 00 
  803d80:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d83:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803d85:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d8c:	00 00 00 
  803d8f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d92:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803d95:	bf 06 00 00 00       	mov    $0x6,%edi
  803d9a:	48 b8 33 3b 80 00 00 	movabs $0x803b33,%rax
  803da1:	00 00 00 
  803da4:	ff d0                	callq  *%rax
}
  803da6:	c9                   	leaveq 
  803da7:	c3                   	retq   

0000000000803da8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803da8:	55                   	push   %rbp
  803da9:	48 89 e5             	mov    %rsp,%rbp
  803dac:	48 83 ec 30          	sub    $0x30,%rsp
  803db0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803db3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803db7:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803dba:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803dbd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dc4:	00 00 00 
  803dc7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803dca:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803dcc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dd3:	00 00 00 
  803dd6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803dd9:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803ddc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803de3:	00 00 00 
  803de6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803de9:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803dec:	bf 07 00 00 00       	mov    $0x7,%edi
  803df1:	48 b8 33 3b 80 00 00 	movabs $0x803b33,%rax
  803df8:	00 00 00 
  803dfb:	ff d0                	callq  *%rax
  803dfd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e04:	78 69                	js     803e6f <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803e06:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803e0d:	7f 08                	jg     803e17 <nsipc_recv+0x6f>
  803e0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e12:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803e15:	7e 35                	jle    803e4c <nsipc_recv+0xa4>
  803e17:	48 b9 ff 51 80 00 00 	movabs $0x8051ff,%rcx
  803e1e:	00 00 00 
  803e21:	48 ba 14 52 80 00 00 	movabs $0x805214,%rdx
  803e28:	00 00 00 
  803e2b:	be 61 00 00 00       	mov    $0x61,%esi
  803e30:	48 bf 29 52 80 00 00 	movabs $0x805229,%rdi
  803e37:	00 00 00 
  803e3a:	b8 00 00 00 00       	mov    $0x0,%eax
  803e3f:	49 b8 97 04 80 00 00 	movabs $0x800497,%r8
  803e46:	00 00 00 
  803e49:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803e4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e4f:	48 63 d0             	movslq %eax,%rdx
  803e52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e56:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803e5d:	00 00 00 
  803e60:	48 89 c7             	mov    %rax,%rdi
  803e63:	48 b8 a9 15 80 00 00 	movabs $0x8015a9,%rax
  803e6a:	00 00 00 
  803e6d:	ff d0                	callq  *%rax
	}

	return r;
  803e6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e72:	c9                   	leaveq 
  803e73:	c3                   	retq   

0000000000803e74 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803e74:	55                   	push   %rbp
  803e75:	48 89 e5             	mov    %rsp,%rbp
  803e78:	48 83 ec 20          	sub    $0x20,%rsp
  803e7c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e7f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e83:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803e86:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803e89:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e90:	00 00 00 
  803e93:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e96:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803e98:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803e9f:	7e 35                	jle    803ed6 <nsipc_send+0x62>
  803ea1:	48 b9 35 52 80 00 00 	movabs $0x805235,%rcx
  803ea8:	00 00 00 
  803eab:	48 ba 14 52 80 00 00 	movabs $0x805214,%rdx
  803eb2:	00 00 00 
  803eb5:	be 6c 00 00 00       	mov    $0x6c,%esi
  803eba:	48 bf 29 52 80 00 00 	movabs $0x805229,%rdi
  803ec1:	00 00 00 
  803ec4:	b8 00 00 00 00       	mov    $0x0,%eax
  803ec9:	49 b8 97 04 80 00 00 	movabs $0x800497,%r8
  803ed0:	00 00 00 
  803ed3:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803ed6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ed9:	48 63 d0             	movslq %eax,%rdx
  803edc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ee0:	48 89 c6             	mov    %rax,%rsi
  803ee3:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803eea:	00 00 00 
  803eed:	48 b8 a9 15 80 00 00 	movabs $0x8015a9,%rax
  803ef4:	00 00 00 
  803ef7:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803ef9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f00:	00 00 00 
  803f03:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f06:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803f09:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f10:	00 00 00 
  803f13:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f16:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803f19:	bf 08 00 00 00       	mov    $0x8,%edi
  803f1e:	48 b8 33 3b 80 00 00 	movabs $0x803b33,%rax
  803f25:	00 00 00 
  803f28:	ff d0                	callq  *%rax
}
  803f2a:	c9                   	leaveq 
  803f2b:	c3                   	retq   

0000000000803f2c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803f2c:	55                   	push   %rbp
  803f2d:	48 89 e5             	mov    %rsp,%rbp
  803f30:	48 83 ec 10          	sub    $0x10,%rsp
  803f34:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f37:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803f3a:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803f3d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f44:	00 00 00 
  803f47:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f4a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803f4c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f53:	00 00 00 
  803f56:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f59:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803f5c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f63:	00 00 00 
  803f66:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803f69:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803f6c:	bf 09 00 00 00       	mov    $0x9,%edi
  803f71:	48 b8 33 3b 80 00 00 	movabs $0x803b33,%rax
  803f78:	00 00 00 
  803f7b:	ff d0                	callq  *%rax
}
  803f7d:	c9                   	leaveq 
  803f7e:	c3                   	retq   

0000000000803f7f <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803f7f:	55                   	push   %rbp
  803f80:	48 89 e5             	mov    %rsp,%rbp
  803f83:	53                   	push   %rbx
  803f84:	48 83 ec 38          	sub    $0x38,%rsp
  803f88:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803f8c:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803f90:	48 89 c7             	mov    %rax,%rdi
  803f93:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  803f9a:	00 00 00 
  803f9d:	ff d0                	callq  *%rax
  803f9f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fa2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fa6:	0f 88 bf 01 00 00    	js     80416b <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803fac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fb0:	ba 07 04 00 00       	mov    $0x407,%edx
  803fb5:	48 89 c6             	mov    %rax,%rsi
  803fb8:	bf 00 00 00 00       	mov    $0x0,%edi
  803fbd:	48 b8 b4 1b 80 00 00 	movabs $0x801bb4,%rax
  803fc4:	00 00 00 
  803fc7:	ff d0                	callq  *%rax
  803fc9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fcc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fd0:	0f 88 95 01 00 00    	js     80416b <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803fd6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803fda:	48 89 c7             	mov    %rax,%rdi
  803fdd:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  803fe4:	00 00 00 
  803fe7:	ff d0                	callq  *%rax
  803fe9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fec:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ff0:	0f 88 5d 01 00 00    	js     804153 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ff6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ffa:	ba 07 04 00 00       	mov    $0x407,%edx
  803fff:	48 89 c6             	mov    %rax,%rsi
  804002:	bf 00 00 00 00       	mov    $0x0,%edi
  804007:	48 b8 b4 1b 80 00 00 	movabs $0x801bb4,%rax
  80400e:	00 00 00 
  804011:	ff d0                	callq  *%rax
  804013:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804016:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80401a:	0f 88 33 01 00 00    	js     804153 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804020:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804024:	48 89 c7             	mov    %rax,%rdi
  804027:	48 b8 92 27 80 00 00 	movabs $0x802792,%rax
  80402e:	00 00 00 
  804031:	ff d0                	callq  *%rax
  804033:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804037:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80403b:	ba 07 04 00 00       	mov    $0x407,%edx
  804040:	48 89 c6             	mov    %rax,%rsi
  804043:	bf 00 00 00 00       	mov    $0x0,%edi
  804048:	48 b8 b4 1b 80 00 00 	movabs $0x801bb4,%rax
  80404f:	00 00 00 
  804052:	ff d0                	callq  *%rax
  804054:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804057:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80405b:	79 05                	jns    804062 <pipe+0xe3>
		goto err2;
  80405d:	e9 d9 00 00 00       	jmpq   80413b <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804062:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804066:	48 89 c7             	mov    %rax,%rdi
  804069:	48 b8 92 27 80 00 00 	movabs $0x802792,%rax
  804070:	00 00 00 
  804073:	ff d0                	callq  *%rax
  804075:	48 89 c2             	mov    %rax,%rdx
  804078:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80407c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804082:	48 89 d1             	mov    %rdx,%rcx
  804085:	ba 00 00 00 00       	mov    $0x0,%edx
  80408a:	48 89 c6             	mov    %rax,%rsi
  80408d:	bf 00 00 00 00       	mov    $0x0,%edi
  804092:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  804099:	00 00 00 
  80409c:	ff d0                	callq  *%rax
  80409e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8040a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8040a5:	79 1b                	jns    8040c2 <pipe+0x143>
		goto err3;
  8040a7:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8040a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040ac:	48 89 c6             	mov    %rax,%rsi
  8040af:	bf 00 00 00 00       	mov    $0x0,%edi
  8040b4:	48 b8 5f 1c 80 00 00 	movabs $0x801c5f,%rax
  8040bb:	00 00 00 
  8040be:	ff d0                	callq  *%rax
  8040c0:	eb 79                	jmp    80413b <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8040c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040c6:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8040cd:	00 00 00 
  8040d0:	8b 12                	mov    (%rdx),%edx
  8040d2:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8040d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040d8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8040df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040e3:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8040ea:	00 00 00 
  8040ed:	8b 12                	mov    (%rdx),%edx
  8040ef:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8040f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040f5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8040fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804100:	48 89 c7             	mov    %rax,%rdi
  804103:	48 b8 6f 27 80 00 00 	movabs $0x80276f,%rax
  80410a:	00 00 00 
  80410d:	ff d0                	callq  *%rax
  80410f:	89 c2                	mov    %eax,%edx
  804111:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804115:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804117:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80411b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80411f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804123:	48 89 c7             	mov    %rax,%rdi
  804126:	48 b8 6f 27 80 00 00 	movabs $0x80276f,%rax
  80412d:	00 00 00 
  804130:	ff d0                	callq  *%rax
  804132:	89 03                	mov    %eax,(%rbx)
	return 0;
  804134:	b8 00 00 00 00       	mov    $0x0,%eax
  804139:	eb 33                	jmp    80416e <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80413b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80413f:	48 89 c6             	mov    %rax,%rsi
  804142:	bf 00 00 00 00       	mov    $0x0,%edi
  804147:	48 b8 5f 1c 80 00 00 	movabs $0x801c5f,%rax
  80414e:	00 00 00 
  804151:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804153:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804157:	48 89 c6             	mov    %rax,%rsi
  80415a:	bf 00 00 00 00       	mov    $0x0,%edi
  80415f:	48 b8 5f 1c 80 00 00 	movabs $0x801c5f,%rax
  804166:	00 00 00 
  804169:	ff d0                	callq  *%rax
err:
	return r;
  80416b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80416e:	48 83 c4 38          	add    $0x38,%rsp
  804172:	5b                   	pop    %rbx
  804173:	5d                   	pop    %rbp
  804174:	c3                   	retq   

0000000000804175 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804175:	55                   	push   %rbp
  804176:	48 89 e5             	mov    %rsp,%rbp
  804179:	53                   	push   %rbx
  80417a:	48 83 ec 28          	sub    $0x28,%rsp
  80417e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804182:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804186:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80418d:	00 00 00 
  804190:	48 8b 00             	mov    (%rax),%rax
  804193:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804199:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80419c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041a0:	48 89 c7             	mov    %rax,%rdi
  8041a3:	48 b8 3b 49 80 00 00 	movabs $0x80493b,%rax
  8041aa:	00 00 00 
  8041ad:	ff d0                	callq  *%rax
  8041af:	89 c3                	mov    %eax,%ebx
  8041b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041b5:	48 89 c7             	mov    %rax,%rdi
  8041b8:	48 b8 3b 49 80 00 00 	movabs $0x80493b,%rax
  8041bf:	00 00 00 
  8041c2:	ff d0                	callq  *%rax
  8041c4:	39 c3                	cmp    %eax,%ebx
  8041c6:	0f 94 c0             	sete   %al
  8041c9:	0f b6 c0             	movzbl %al,%eax
  8041cc:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8041cf:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8041d6:	00 00 00 
  8041d9:	48 8b 00             	mov    (%rax),%rax
  8041dc:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8041e2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8041e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041e8:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8041eb:	75 05                	jne    8041f2 <_pipeisclosed+0x7d>
			return ret;
  8041ed:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8041f0:	eb 4f                	jmp    804241 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8041f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041f5:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8041f8:	74 42                	je     80423c <_pipeisclosed+0xc7>
  8041fa:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8041fe:	75 3c                	jne    80423c <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804200:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  804207:	00 00 00 
  80420a:	48 8b 00             	mov    (%rax),%rax
  80420d:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804213:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804216:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804219:	89 c6                	mov    %eax,%esi
  80421b:	48 bf 46 52 80 00 00 	movabs $0x805246,%rdi
  804222:	00 00 00 
  804225:	b8 00 00 00 00       	mov    $0x0,%eax
  80422a:	49 b8 d0 06 80 00 00 	movabs $0x8006d0,%r8
  804231:	00 00 00 
  804234:	41 ff d0             	callq  *%r8
	}
  804237:	e9 4a ff ff ff       	jmpq   804186 <_pipeisclosed+0x11>
  80423c:	e9 45 ff ff ff       	jmpq   804186 <_pipeisclosed+0x11>
}
  804241:	48 83 c4 28          	add    $0x28,%rsp
  804245:	5b                   	pop    %rbx
  804246:	5d                   	pop    %rbp
  804247:	c3                   	retq   

0000000000804248 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804248:	55                   	push   %rbp
  804249:	48 89 e5             	mov    %rsp,%rbp
  80424c:	48 83 ec 30          	sub    $0x30,%rsp
  804250:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804253:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804257:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80425a:	48 89 d6             	mov    %rdx,%rsi
  80425d:	89 c7                	mov    %eax,%edi
  80425f:	48 b8 55 28 80 00 00 	movabs $0x802855,%rax
  804266:	00 00 00 
  804269:	ff d0                	callq  *%rax
  80426b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80426e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804272:	79 05                	jns    804279 <pipeisclosed+0x31>
		return r;
  804274:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804277:	eb 31                	jmp    8042aa <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804279:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80427d:	48 89 c7             	mov    %rax,%rdi
  804280:	48 b8 92 27 80 00 00 	movabs $0x802792,%rax
  804287:	00 00 00 
  80428a:	ff d0                	callq  *%rax
  80428c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804290:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804294:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804298:	48 89 d6             	mov    %rdx,%rsi
  80429b:	48 89 c7             	mov    %rax,%rdi
  80429e:	48 b8 75 41 80 00 00 	movabs $0x804175,%rax
  8042a5:	00 00 00 
  8042a8:	ff d0                	callq  *%rax
}
  8042aa:	c9                   	leaveq 
  8042ab:	c3                   	retq   

00000000008042ac <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8042ac:	55                   	push   %rbp
  8042ad:	48 89 e5             	mov    %rsp,%rbp
  8042b0:	48 83 ec 40          	sub    $0x40,%rsp
  8042b4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8042b8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8042bc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8042c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042c4:	48 89 c7             	mov    %rax,%rdi
  8042c7:	48 b8 92 27 80 00 00 	movabs $0x802792,%rax
  8042ce:	00 00 00 
  8042d1:	ff d0                	callq  *%rax
  8042d3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8042d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042db:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8042df:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8042e6:	00 
  8042e7:	e9 92 00 00 00       	jmpq   80437e <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8042ec:	eb 41                	jmp    80432f <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8042ee:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8042f3:	74 09                	je     8042fe <devpipe_read+0x52>
				return i;
  8042f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042f9:	e9 92 00 00 00       	jmpq   804390 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8042fe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804302:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804306:	48 89 d6             	mov    %rdx,%rsi
  804309:	48 89 c7             	mov    %rax,%rdi
  80430c:	48 b8 75 41 80 00 00 	movabs $0x804175,%rax
  804313:	00 00 00 
  804316:	ff d0                	callq  *%rax
  804318:	85 c0                	test   %eax,%eax
  80431a:	74 07                	je     804323 <devpipe_read+0x77>
				return 0;
  80431c:	b8 00 00 00 00       	mov    $0x0,%eax
  804321:	eb 6d                	jmp    804390 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804323:	48 b8 76 1b 80 00 00 	movabs $0x801b76,%rax
  80432a:	00 00 00 
  80432d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80432f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804333:	8b 10                	mov    (%rax),%edx
  804335:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804339:	8b 40 04             	mov    0x4(%rax),%eax
  80433c:	39 c2                	cmp    %eax,%edx
  80433e:	74 ae                	je     8042ee <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804340:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804344:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804348:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80434c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804350:	8b 00                	mov    (%rax),%eax
  804352:	99                   	cltd   
  804353:	c1 ea 1b             	shr    $0x1b,%edx
  804356:	01 d0                	add    %edx,%eax
  804358:	83 e0 1f             	and    $0x1f,%eax
  80435b:	29 d0                	sub    %edx,%eax
  80435d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804361:	48 98                	cltq   
  804363:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804368:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80436a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80436e:	8b 00                	mov    (%rax),%eax
  804370:	8d 50 01             	lea    0x1(%rax),%edx
  804373:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804377:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804379:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80437e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804382:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804386:	0f 82 60 ff ff ff    	jb     8042ec <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80438c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804390:	c9                   	leaveq 
  804391:	c3                   	retq   

0000000000804392 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804392:	55                   	push   %rbp
  804393:	48 89 e5             	mov    %rsp,%rbp
  804396:	48 83 ec 40          	sub    $0x40,%rsp
  80439a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80439e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8043a2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8043a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043aa:	48 89 c7             	mov    %rax,%rdi
  8043ad:	48 b8 92 27 80 00 00 	movabs $0x802792,%rax
  8043b4:	00 00 00 
  8043b7:	ff d0                	callq  *%rax
  8043b9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8043bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043c1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8043c5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8043cc:	00 
  8043cd:	e9 8e 00 00 00       	jmpq   804460 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8043d2:	eb 31                	jmp    804405 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8043d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8043d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043dc:	48 89 d6             	mov    %rdx,%rsi
  8043df:	48 89 c7             	mov    %rax,%rdi
  8043e2:	48 b8 75 41 80 00 00 	movabs $0x804175,%rax
  8043e9:	00 00 00 
  8043ec:	ff d0                	callq  *%rax
  8043ee:	85 c0                	test   %eax,%eax
  8043f0:	74 07                	je     8043f9 <devpipe_write+0x67>
				return 0;
  8043f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8043f7:	eb 79                	jmp    804472 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8043f9:	48 b8 76 1b 80 00 00 	movabs $0x801b76,%rax
  804400:	00 00 00 
  804403:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804405:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804409:	8b 40 04             	mov    0x4(%rax),%eax
  80440c:	48 63 d0             	movslq %eax,%rdx
  80440f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804413:	8b 00                	mov    (%rax),%eax
  804415:	48 98                	cltq   
  804417:	48 83 c0 20          	add    $0x20,%rax
  80441b:	48 39 c2             	cmp    %rax,%rdx
  80441e:	73 b4                	jae    8043d4 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804420:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804424:	8b 40 04             	mov    0x4(%rax),%eax
  804427:	99                   	cltd   
  804428:	c1 ea 1b             	shr    $0x1b,%edx
  80442b:	01 d0                	add    %edx,%eax
  80442d:	83 e0 1f             	and    $0x1f,%eax
  804430:	29 d0                	sub    %edx,%eax
  804432:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804436:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80443a:	48 01 ca             	add    %rcx,%rdx
  80443d:	0f b6 0a             	movzbl (%rdx),%ecx
  804440:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804444:	48 98                	cltq   
  804446:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80444a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80444e:	8b 40 04             	mov    0x4(%rax),%eax
  804451:	8d 50 01             	lea    0x1(%rax),%edx
  804454:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804458:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80445b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804460:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804464:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804468:	0f 82 64 ff ff ff    	jb     8043d2 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80446e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804472:	c9                   	leaveq 
  804473:	c3                   	retq   

0000000000804474 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804474:	55                   	push   %rbp
  804475:	48 89 e5             	mov    %rsp,%rbp
  804478:	48 83 ec 20          	sub    $0x20,%rsp
  80447c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804480:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804484:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804488:	48 89 c7             	mov    %rax,%rdi
  80448b:	48 b8 92 27 80 00 00 	movabs $0x802792,%rax
  804492:	00 00 00 
  804495:	ff d0                	callq  *%rax
  804497:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80449b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80449f:	48 be 59 52 80 00 00 	movabs $0x805259,%rsi
  8044a6:	00 00 00 
  8044a9:	48 89 c7             	mov    %rax,%rdi
  8044ac:	48 b8 85 12 80 00 00 	movabs $0x801285,%rax
  8044b3:	00 00 00 
  8044b6:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8044b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044bc:	8b 50 04             	mov    0x4(%rax),%edx
  8044bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044c3:	8b 00                	mov    (%rax),%eax
  8044c5:	29 c2                	sub    %eax,%edx
  8044c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044cb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8044d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044d5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8044dc:	00 00 00 
	stat->st_dev = &devpipe;
  8044df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044e3:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  8044ea:	00 00 00 
  8044ed:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8044f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044f9:	c9                   	leaveq 
  8044fa:	c3                   	retq   

00000000008044fb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8044fb:	55                   	push   %rbp
  8044fc:	48 89 e5             	mov    %rsp,%rbp
  8044ff:	48 83 ec 10          	sub    $0x10,%rsp
  804503:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804507:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80450b:	48 89 c6             	mov    %rax,%rsi
  80450e:	bf 00 00 00 00       	mov    $0x0,%edi
  804513:	48 b8 5f 1c 80 00 00 	movabs $0x801c5f,%rax
  80451a:	00 00 00 
  80451d:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80451f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804523:	48 89 c7             	mov    %rax,%rdi
  804526:	48 b8 92 27 80 00 00 	movabs $0x802792,%rax
  80452d:	00 00 00 
  804530:	ff d0                	callq  *%rax
  804532:	48 89 c6             	mov    %rax,%rsi
  804535:	bf 00 00 00 00       	mov    $0x0,%edi
  80453a:	48 b8 5f 1c 80 00 00 	movabs $0x801c5f,%rax
  804541:	00 00 00 
  804544:	ff d0                	callq  *%rax
}
  804546:	c9                   	leaveq 
  804547:	c3                   	retq   

0000000000804548 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804548:	55                   	push   %rbp
  804549:	48 89 e5             	mov    %rsp,%rbp
  80454c:	48 83 ec 20          	sub    $0x20,%rsp
  804550:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804553:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804556:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804559:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80455d:	be 01 00 00 00       	mov    $0x1,%esi
  804562:	48 89 c7             	mov    %rax,%rdi
  804565:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  80456c:	00 00 00 
  80456f:	ff d0                	callq  *%rax
}
  804571:	c9                   	leaveq 
  804572:	c3                   	retq   

0000000000804573 <getchar>:

int
getchar(void)
{
  804573:	55                   	push   %rbp
  804574:	48 89 e5             	mov    %rsp,%rbp
  804577:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80457b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80457f:	ba 01 00 00 00       	mov    $0x1,%edx
  804584:	48 89 c6             	mov    %rax,%rsi
  804587:	bf 00 00 00 00       	mov    $0x0,%edi
  80458c:	48 b8 87 2c 80 00 00 	movabs $0x802c87,%rax
  804593:	00 00 00 
  804596:	ff d0                	callq  *%rax
  804598:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80459b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80459f:	79 05                	jns    8045a6 <getchar+0x33>
		return r;
  8045a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045a4:	eb 14                	jmp    8045ba <getchar+0x47>
	if (r < 1)
  8045a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045aa:	7f 07                	jg     8045b3 <getchar+0x40>
		return -E_EOF;
  8045ac:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8045b1:	eb 07                	jmp    8045ba <getchar+0x47>
	return c;
  8045b3:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8045b7:	0f b6 c0             	movzbl %al,%eax
}
  8045ba:	c9                   	leaveq 
  8045bb:	c3                   	retq   

00000000008045bc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8045bc:	55                   	push   %rbp
  8045bd:	48 89 e5             	mov    %rsp,%rbp
  8045c0:	48 83 ec 20          	sub    $0x20,%rsp
  8045c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8045c7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8045cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045ce:	48 89 d6             	mov    %rdx,%rsi
  8045d1:	89 c7                	mov    %eax,%edi
  8045d3:	48 b8 55 28 80 00 00 	movabs $0x802855,%rax
  8045da:	00 00 00 
  8045dd:	ff d0                	callq  *%rax
  8045df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045e6:	79 05                	jns    8045ed <iscons+0x31>
		return r;
  8045e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045eb:	eb 1a                	jmp    804607 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8045ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045f1:	8b 10                	mov    (%rax),%edx
  8045f3:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  8045fa:	00 00 00 
  8045fd:	8b 00                	mov    (%rax),%eax
  8045ff:	39 c2                	cmp    %eax,%edx
  804601:	0f 94 c0             	sete   %al
  804604:	0f b6 c0             	movzbl %al,%eax
}
  804607:	c9                   	leaveq 
  804608:	c3                   	retq   

0000000000804609 <opencons>:

int
opencons(void)
{
  804609:	55                   	push   %rbp
  80460a:	48 89 e5             	mov    %rsp,%rbp
  80460d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804611:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804615:	48 89 c7             	mov    %rax,%rdi
  804618:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  80461f:	00 00 00 
  804622:	ff d0                	callq  *%rax
  804624:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804627:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80462b:	79 05                	jns    804632 <opencons+0x29>
		return r;
  80462d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804630:	eb 5b                	jmp    80468d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804632:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804636:	ba 07 04 00 00       	mov    $0x407,%edx
  80463b:	48 89 c6             	mov    %rax,%rsi
  80463e:	bf 00 00 00 00       	mov    $0x0,%edi
  804643:	48 b8 b4 1b 80 00 00 	movabs $0x801bb4,%rax
  80464a:	00 00 00 
  80464d:	ff d0                	callq  *%rax
  80464f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804652:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804656:	79 05                	jns    80465d <opencons+0x54>
		return r;
  804658:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80465b:	eb 30                	jmp    80468d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80465d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804661:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804668:	00 00 00 
  80466b:	8b 12                	mov    (%rdx),%edx
  80466d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80466f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804673:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80467a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80467e:	48 89 c7             	mov    %rax,%rdi
  804681:	48 b8 6f 27 80 00 00 	movabs $0x80276f,%rax
  804688:	00 00 00 
  80468b:	ff d0                	callq  *%rax
}
  80468d:	c9                   	leaveq 
  80468e:	c3                   	retq   

000000000080468f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80468f:	55                   	push   %rbp
  804690:	48 89 e5             	mov    %rsp,%rbp
  804693:	48 83 ec 30          	sub    $0x30,%rsp
  804697:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80469b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80469f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8046a3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8046a8:	75 07                	jne    8046b1 <devcons_read+0x22>
		return 0;
  8046aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8046af:	eb 4b                	jmp    8046fc <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8046b1:	eb 0c                	jmp    8046bf <devcons_read+0x30>
		sys_yield();
  8046b3:	48 b8 76 1b 80 00 00 	movabs $0x801b76,%rax
  8046ba:	00 00 00 
  8046bd:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8046bf:	48 b8 b6 1a 80 00 00 	movabs $0x801ab6,%rax
  8046c6:	00 00 00 
  8046c9:	ff d0                	callq  *%rax
  8046cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046d2:	74 df                	je     8046b3 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8046d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046d8:	79 05                	jns    8046df <devcons_read+0x50>
		return c;
  8046da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046dd:	eb 1d                	jmp    8046fc <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8046df:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8046e3:	75 07                	jne    8046ec <devcons_read+0x5d>
		return 0;
  8046e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8046ea:	eb 10                	jmp    8046fc <devcons_read+0x6d>
	*(char*)vbuf = c;
  8046ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046ef:	89 c2                	mov    %eax,%edx
  8046f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046f5:	88 10                	mov    %dl,(%rax)
	return 1;
  8046f7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8046fc:	c9                   	leaveq 
  8046fd:	c3                   	retq   

00000000008046fe <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8046fe:	55                   	push   %rbp
  8046ff:	48 89 e5             	mov    %rsp,%rbp
  804702:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804709:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804710:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804717:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80471e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804725:	eb 76                	jmp    80479d <devcons_write+0x9f>
		m = n - tot;
  804727:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80472e:	89 c2                	mov    %eax,%edx
  804730:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804733:	29 c2                	sub    %eax,%edx
  804735:	89 d0                	mov    %edx,%eax
  804737:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80473a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80473d:	83 f8 7f             	cmp    $0x7f,%eax
  804740:	76 07                	jbe    804749 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804742:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804749:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80474c:	48 63 d0             	movslq %eax,%rdx
  80474f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804752:	48 63 c8             	movslq %eax,%rcx
  804755:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80475c:	48 01 c1             	add    %rax,%rcx
  80475f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804766:	48 89 ce             	mov    %rcx,%rsi
  804769:	48 89 c7             	mov    %rax,%rdi
  80476c:	48 b8 a9 15 80 00 00 	movabs $0x8015a9,%rax
  804773:	00 00 00 
  804776:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804778:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80477b:	48 63 d0             	movslq %eax,%rdx
  80477e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804785:	48 89 d6             	mov    %rdx,%rsi
  804788:	48 89 c7             	mov    %rax,%rdi
  80478b:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  804792:	00 00 00 
  804795:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804797:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80479a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80479d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047a0:	48 98                	cltq   
  8047a2:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8047a9:	0f 82 78 ff ff ff    	jb     804727 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8047af:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8047b2:	c9                   	leaveq 
  8047b3:	c3                   	retq   

00000000008047b4 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8047b4:	55                   	push   %rbp
  8047b5:	48 89 e5             	mov    %rsp,%rbp
  8047b8:	48 83 ec 08          	sub    $0x8,%rsp
  8047bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8047c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8047c5:	c9                   	leaveq 
  8047c6:	c3                   	retq   

00000000008047c7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8047c7:	55                   	push   %rbp
  8047c8:	48 89 e5             	mov    %rsp,%rbp
  8047cb:	48 83 ec 10          	sub    $0x10,%rsp
  8047cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8047d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8047d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047db:	48 be 65 52 80 00 00 	movabs $0x805265,%rsi
  8047e2:	00 00 00 
  8047e5:	48 89 c7             	mov    %rax,%rdi
  8047e8:	48 b8 85 12 80 00 00 	movabs $0x801285,%rax
  8047ef:	00 00 00 
  8047f2:	ff d0                	callq  *%rax
	return 0;
  8047f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8047f9:	c9                   	leaveq 
  8047fa:	c3                   	retq   

00000000008047fb <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8047fb:	55                   	push   %rbp
  8047fc:	48 89 e5             	mov    %rsp,%rbp
  8047ff:	48 83 ec 10          	sub    $0x10,%rsp
  804803:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804807:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80480e:	00 00 00 
  804811:	48 8b 00             	mov    (%rax),%rax
  804814:	48 85 c0             	test   %rax,%rax
  804817:	0f 85 84 00 00 00    	jne    8048a1 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  80481d:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  804824:	00 00 00 
  804827:	48 8b 00             	mov    (%rax),%rax
  80482a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804830:	ba 07 00 00 00       	mov    $0x7,%edx
  804835:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80483a:	89 c7                	mov    %eax,%edi
  80483c:	48 b8 b4 1b 80 00 00 	movabs $0x801bb4,%rax
  804843:	00 00 00 
  804846:	ff d0                	callq  *%rax
  804848:	85 c0                	test   %eax,%eax
  80484a:	79 2a                	jns    804876 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  80484c:	48 ba 70 52 80 00 00 	movabs $0x805270,%rdx
  804853:	00 00 00 
  804856:	be 23 00 00 00       	mov    $0x23,%esi
  80485b:	48 bf 97 52 80 00 00 	movabs $0x805297,%rdi
  804862:	00 00 00 
  804865:	b8 00 00 00 00       	mov    $0x0,%eax
  80486a:	48 b9 97 04 80 00 00 	movabs $0x800497,%rcx
  804871:	00 00 00 
  804874:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  804876:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80487d:	00 00 00 
  804880:	48 8b 00             	mov    (%rax),%rax
  804883:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804889:	48 be b4 48 80 00 00 	movabs $0x8048b4,%rsi
  804890:	00 00 00 
  804893:	89 c7                	mov    %eax,%edi
  804895:	48 b8 3e 1d 80 00 00 	movabs $0x801d3e,%rax
  80489c:	00 00 00 
  80489f:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  8048a1:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8048a8:	00 00 00 
  8048ab:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8048af:	48 89 10             	mov    %rdx,(%rax)
}
  8048b2:	c9                   	leaveq 
  8048b3:	c3                   	retq   

00000000008048b4 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8048b4:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8048b7:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  8048be:	00 00 00 
call *%rax
  8048c1:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  8048c3:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8048ca:	00 
	movq 152(%rsp), %rcx  //Load RSP
  8048cb:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  8048d2:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  8048d3:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  8048d7:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  8048da:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  8048e1:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  8048e2:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  8048e6:	4c 8b 3c 24          	mov    (%rsp),%r15
  8048ea:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8048ef:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8048f4:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8048f9:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8048fe:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804903:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804908:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80490d:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804912:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804917:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80491c:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804921:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804926:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80492b:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804930:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  804934:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  804938:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  804939:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80493a:	c3                   	retq   

000000000080493b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80493b:	55                   	push   %rbp
  80493c:	48 89 e5             	mov    %rsp,%rbp
  80493f:	48 83 ec 18          	sub    $0x18,%rsp
  804943:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804947:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80494b:	48 c1 e8 15          	shr    $0x15,%rax
  80494f:	48 89 c2             	mov    %rax,%rdx
  804952:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804959:	01 00 00 
  80495c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804960:	83 e0 01             	and    $0x1,%eax
  804963:	48 85 c0             	test   %rax,%rax
  804966:	75 07                	jne    80496f <pageref+0x34>
		return 0;
  804968:	b8 00 00 00 00       	mov    $0x0,%eax
  80496d:	eb 53                	jmp    8049c2 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80496f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804973:	48 c1 e8 0c          	shr    $0xc,%rax
  804977:	48 89 c2             	mov    %rax,%rdx
  80497a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804981:	01 00 00 
  804984:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804988:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80498c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804990:	83 e0 01             	and    $0x1,%eax
  804993:	48 85 c0             	test   %rax,%rax
  804996:	75 07                	jne    80499f <pageref+0x64>
		return 0;
  804998:	b8 00 00 00 00       	mov    $0x0,%eax
  80499d:	eb 23                	jmp    8049c2 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80499f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049a3:	48 c1 e8 0c          	shr    $0xc,%rax
  8049a7:	48 89 c2             	mov    %rax,%rdx
  8049aa:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8049b1:	00 00 00 
  8049b4:	48 c1 e2 04          	shl    $0x4,%rdx
  8049b8:	48 01 d0             	add    %rdx,%rax
  8049bb:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8049bf:	0f b7 c0             	movzwl %ax,%eax
}
  8049c2:	c9                   	leaveq 
  8049c3:	c3                   	retq   
