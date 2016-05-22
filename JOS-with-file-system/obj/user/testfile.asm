
obj/user/testfile.debug:     file format elf64-x86-64


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
  80003c:	e8 39 0c 00 00       	callq  800c7a <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	extern union Fsipc fsipcbuf;
	envid_t fsenv;
	
	strcpy(fsipcbuf.open.req_path, path);
  800052:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800056:	48 89 c6             	mov    %rax,%rsi
  800059:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  800060:	00 00 00 
  800063:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  80006a:	00 00 00 
  80006d:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80006f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800076:	00 00 00 
  800079:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80007c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	fsenv = ipc_find_env(ENV_TYPE_FS);
  800082:	bf 01 00 00 00       	mov    $0x1,%edi
  800087:	48 b8 1a 28 80 00 00 	movabs $0x80281a,%rax
  80008e:	00 00 00 
  800091:	ff d0                	callq  *%rax
  800093:	89 45 fc             	mov    %eax,-0x4(%rbp)
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800096:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800099:	b9 07 00 00 00       	mov    $0x7,%ecx
  80009e:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8000a5:	00 00 00 
  8000a8:	be 01 00 00 00       	mov    $0x1,%esi
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	48 b8 b8 27 80 00 00 	movabs $0x8027b8,%rax
  8000b6:	00 00 00 
  8000b9:	ff d0                	callq  *%rax
	return ipc_recv(NULL, FVA, NULL);
  8000bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c0:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8000c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8000ca:	48 b8 b2 26 80 00 00 	movabs $0x8026b2,%rax
  8000d1:	00 00 00 
  8000d4:	ff d0                	callq  *%rax
}
  8000d6:	c9                   	leaveq 
  8000d7:	c3                   	retq   

00000000008000d8 <umain>:

void
umain(int argc, char **argv)
{
  8000d8:	55                   	push   %rbp
  8000d9:	48 89 e5             	mov    %rsp,%rbp
  8000dc:	53                   	push   %rbx
  8000dd:	48 81 ec 18 03 00 00 	sub    $0x318,%rsp
  8000e4:	89 bd 2c fd ff ff    	mov    %edi,-0x2d4(%rbp)
  8000ea:	48 89 b5 20 fd ff ff 	mov    %rsi,-0x2e0(%rbp)
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8000f1:	be 00 00 00 00       	mov    $0x0,%esi
  8000f6:	48 bf 06 40 80 00 00 	movabs $0x804006,%rdi
  8000fd:	00 00 00 
  800100:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800107:	00 00 00 
  80010a:	ff d0                	callq  *%rax
  80010c:	48 98                	cltq   
  80010e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800112:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800117:	79 39                	jns    800152 <umain+0x7a>
  800119:	48 83 7d e0 f4       	cmpq   $0xfffffffffffffff4,-0x20(%rbp)
  80011e:	74 32                	je     800152 <umain+0x7a>
		panic("serve_open /not-found: %e", r);
  800120:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800124:	48 89 c1             	mov    %rax,%rcx
  800127:	48 ba 11 40 80 00 00 	movabs $0x804011,%rdx
  80012e:	00 00 00 
  800131:	be 20 00 00 00       	mov    $0x20,%esi
  800136:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  80013d:	00 00 00 
  800140:	b8 00 00 00 00       	mov    $0x0,%eax
  800145:	49 b8 28 0d 80 00 00 	movabs $0x800d28,%r8
  80014c:	00 00 00 
  80014f:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800152:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800157:	78 2a                	js     800183 <umain+0xab>
		panic("serve_open /not-found succeeded!");
  800159:	48 ba 40 40 80 00 00 	movabs $0x804040,%rdx
  800160:	00 00 00 
  800163:	be 22 00 00 00       	mov    $0x22,%esi
  800168:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  80016f:	00 00 00 
  800172:	b8 00 00 00 00       	mov    $0x0,%eax
  800177:	48 b9 28 0d 80 00 00 	movabs $0x800d28,%rcx
  80017e:	00 00 00 
  800181:	ff d1                	callq  *%rcx

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  800183:	be 00 00 00 00       	mov    $0x0,%esi
  800188:	48 bf 61 40 80 00 00 	movabs $0x804061,%rdi
  80018f:	00 00 00 
  800192:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800199:	00 00 00 
  80019c:	ff d0                	callq  *%rax
  80019e:	48 98                	cltq   
  8001a0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8001a4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8001a9:	79 32                	jns    8001dd <umain+0x105>
		panic("serve_open /newmotd: %e", r);
  8001ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001af:	48 89 c1             	mov    %rax,%rcx
  8001b2:	48 ba 6a 40 80 00 00 	movabs $0x80406a,%rdx
  8001b9:	00 00 00 
  8001bc:	be 25 00 00 00       	mov    $0x25,%esi
  8001c1:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  8001c8:	00 00 00 
  8001cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d0:	49 b8 28 0d 80 00 00 	movabs $0x800d28,%r8
  8001d7:	00 00 00 
  8001da:	41 ff d0             	callq  *%r8
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8001dd:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001e2:	8b 00                	mov    (%rax),%eax
  8001e4:	83 f8 66             	cmp    $0x66,%eax
  8001e7:	75 18                	jne    800201 <umain+0x129>
  8001e9:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001ee:	8b 40 04             	mov    0x4(%rax),%eax
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	75 0c                	jne    800201 <umain+0x129>
  8001f5:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001fa:	8b 40 08             	mov    0x8(%rax),%eax
  8001fd:	85 c0                	test   %eax,%eax
  8001ff:	74 2a                	je     80022b <umain+0x153>
		panic("serve_open did not fill struct Fd correctly\n");
  800201:	48 ba 88 40 80 00 00 	movabs $0x804088,%rdx
  800208:	00 00 00 
  80020b:	be 27 00 00 00       	mov    $0x27,%esi
  800210:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  800217:	00 00 00 
  80021a:	b8 00 00 00 00       	mov    $0x0,%eax
  80021f:	48 b9 28 0d 80 00 00 	movabs $0x800d28,%rcx
  800226:	00 00 00 
  800229:	ff d1                	callq  *%rcx
	cprintf("serve_open is good\n");
  80022b:	48 bf b5 40 80 00 00 	movabs $0x8040b5,%rdi
  800232:	00 00 00 
  800235:	b8 00 00 00 00       	mov    $0x0,%eax
  80023a:	48 ba 61 0f 80 00 00 	movabs $0x800f61,%rdx
  800241:	00 00 00 
  800244:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  800246:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  80024d:	00 00 00 
  800250:	48 8b 40 28          	mov    0x28(%rax),%rax
  800254:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80025b:	48 89 d6             	mov    %rdx,%rsi
  80025e:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800263:	ff d0                	callq  *%rax
  800265:	48 98                	cltq   
  800267:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80026b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800270:	79 32                	jns    8002a4 <umain+0x1cc>
		panic("file_stat: %e", r);
  800272:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800276:	48 89 c1             	mov    %rax,%rcx
  800279:	48 ba c9 40 80 00 00 	movabs $0x8040c9,%rdx
  800280:	00 00 00 
  800283:	be 2b 00 00 00       	mov    $0x2b,%esi
  800288:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  80028f:	00 00 00 
  800292:	b8 00 00 00 00       	mov    $0x0,%eax
  800297:	49 b8 28 0d 80 00 00 	movabs $0x800d28,%r8
  80029e:	00 00 00 
  8002a1:	41 ff d0             	callq  *%r8
	if (strlen(msg) != st.st_size)
  8002a4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002ab:	00 00 00 
  8002ae:	48 8b 00             	mov    (%rax),%rax
  8002b1:	48 89 c7             	mov    %rax,%rdi
  8002b4:	48 b8 aa 1a 80 00 00 	movabs $0x801aaa,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
  8002c0:	8b 55 b0             	mov    -0x50(%rbp),%edx
  8002c3:	39 d0                	cmp    %edx,%eax
  8002c5:	74 51                	je     800318 <umain+0x240>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8002c7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002ce:	00 00 00 
  8002d1:	48 8b 00             	mov    (%rax),%rax
  8002d4:	48 89 c7             	mov    %rax,%rdi
  8002d7:	48 b8 aa 1a 80 00 00 	movabs $0x801aaa,%rax
  8002de:	00 00 00 
  8002e1:	ff d0                	callq  *%rax
  8002e3:	89 c2                	mov    %eax,%edx
  8002e5:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8002e8:	41 89 d0             	mov    %edx,%r8d
  8002eb:	89 c1                	mov    %eax,%ecx
  8002ed:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  8002f4:	00 00 00 
  8002f7:	be 2d 00 00 00       	mov    $0x2d,%esi
  8002fc:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  800303:	00 00 00 
  800306:	b8 00 00 00 00       	mov    $0x0,%eax
  80030b:	49 b9 28 0d 80 00 00 	movabs $0x800d28,%r9
  800312:	00 00 00 
  800315:	41 ff d1             	callq  *%r9
	cprintf("file_stat is good\n");
  800318:	48 bf fe 40 80 00 00 	movabs $0x8040fe,%rdi
  80031f:	00 00 00 
  800322:	b8 00 00 00 00       	mov    $0x0,%eax
  800327:	48 ba 61 0f 80 00 00 	movabs $0x800f61,%rdx
  80032e:	00 00 00 
  800331:	ff d2                	callq  *%rdx

	memset(buf, 0, sizeof buf);
  800333:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  80033a:	ba 00 02 00 00       	mov    $0x200,%edx
  80033f:	be 00 00 00 00       	mov    $0x0,%esi
  800344:	48 89 c7             	mov    %rax,%rdi
  800347:	48 b8 af 1d 80 00 00 	movabs $0x801daf,%rax
  80034e:	00 00 00 
  800351:	ff d0                	callq  *%rax
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800353:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  80035a:	00 00 00 
  80035d:	48 8b 40 10          	mov    0x10(%rax),%rax
  800361:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800368:	ba 00 02 00 00       	mov    $0x200,%edx
  80036d:	48 89 ce             	mov    %rcx,%rsi
  800370:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800375:	ff d0                	callq  *%rax
  800377:	48 98                	cltq   
  800379:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80037d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800382:	79 32                	jns    8003b6 <umain+0x2de>
		panic("file_read: %e", r);
  800384:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800388:	48 89 c1             	mov    %rax,%rcx
  80038b:	48 ba 11 41 80 00 00 	movabs $0x804111,%rdx
  800392:	00 00 00 
  800395:	be 32 00 00 00       	mov    $0x32,%esi
  80039a:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  8003a1:	00 00 00 
  8003a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a9:	49 b8 28 0d 80 00 00 	movabs $0x800d28,%r8
  8003b0:	00 00 00 
  8003b3:	41 ff d0             	callq  *%r8
	if (strcmp(buf, msg) != 0)
  8003b6:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003bd:	00 00 00 
  8003c0:	48 8b 10             	mov    (%rax),%rdx
  8003c3:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8003ca:	48 89 d6             	mov    %rdx,%rsi
  8003cd:	48 89 c7             	mov    %rax,%rdi
  8003d0:	48 b8 78 1c 80 00 00 	movabs $0x801c78,%rax
  8003d7:	00 00 00 
  8003da:	ff d0                	callq  *%rax
  8003dc:	85 c0                	test   %eax,%eax
  8003de:	74 2a                	je     80040a <umain+0x332>
		panic("file_read returned wrong data");
  8003e0:	48 ba 1f 41 80 00 00 	movabs $0x80411f,%rdx
  8003e7:	00 00 00 
  8003ea:	be 34 00 00 00       	mov    $0x34,%esi
  8003ef:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  8003f6:	00 00 00 
  8003f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fe:	48 b9 28 0d 80 00 00 	movabs $0x800d28,%rcx
  800405:	00 00 00 
  800408:	ff d1                	callq  *%rcx
	cprintf("file_read is good\n");
  80040a:	48 bf 3d 41 80 00 00 	movabs $0x80413d,%rdi
  800411:	00 00 00 
  800414:	b8 00 00 00 00       	mov    $0x0,%eax
  800419:	48 ba 61 0f 80 00 00 	movabs $0x800f61,%rdx
  800420:	00 00 00 
  800423:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_close(FVA)) < 0)
  800425:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  80042c:	00 00 00 
  80042f:	48 8b 40 20          	mov    0x20(%rax),%rax
  800433:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800438:	ff d0                	callq  *%rax
  80043a:	48 98                	cltq   
  80043c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800440:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800445:	79 32                	jns    800479 <umain+0x3a1>
		panic("file_close: %e", r);
  800447:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80044b:	48 89 c1             	mov    %rax,%rcx
  80044e:	48 ba 50 41 80 00 00 	movabs $0x804150,%rdx
  800455:	00 00 00 
  800458:	be 38 00 00 00       	mov    $0x38,%esi
  80045d:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  800464:	00 00 00 
  800467:	b8 00 00 00 00       	mov    $0x0,%eax
  80046c:	49 b8 28 0d 80 00 00 	movabs $0x800d28,%r8
  800473:	00 00 00 
  800476:	41 ff d0             	callq  *%r8
	cprintf("file_close is good\n");
  800479:	48 bf 5f 41 80 00 00 	movabs $0x80415f,%rdi
  800480:	00 00 00 
  800483:	b8 00 00 00 00       	mov    $0x0,%eax
  800488:	48 ba 61 0f 80 00 00 	movabs $0x800f61,%rdx
  80048f:	00 00 00 
  800492:	ff d2                	callq  *%rdx

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  800494:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  800499:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80049d:	48 8b 00             	mov    (%rax),%rax
  8004a0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004a4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	sys_page_unmap(0, FVA);
  8004a8:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8004ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8004b2:	48 b8 f0 24 80 00 00 	movabs $0x8024f0,%rax
  8004b9:	00 00 00 
  8004bc:	ff d0                	callq  *%rax

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8004be:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  8004c5:	00 00 00 
  8004c8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8004cc:	48 8d b5 30 fd ff ff 	lea    -0x2d0(%rbp),%rsi
  8004d3:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
  8004d7:	ba 00 02 00 00       	mov    $0x200,%edx
  8004dc:	48 89 cf             	mov    %rcx,%rdi
  8004df:	ff d0                	callq  *%rax
  8004e1:	48 98                	cltq   
  8004e3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8004e7:	48 83 7d e0 fd       	cmpq   $0xfffffffffffffffd,-0x20(%rbp)
  8004ec:	74 32                	je     800520 <umain+0x448>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  8004ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004f2:	48 89 c1             	mov    %rax,%rcx
  8004f5:	48 ba 78 41 80 00 00 	movabs $0x804178,%rdx
  8004fc:	00 00 00 
  8004ff:	be 43 00 00 00       	mov    $0x43,%esi
  800504:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  80050b:	00 00 00 
  80050e:	b8 00 00 00 00       	mov    $0x0,%eax
  800513:	49 b8 28 0d 80 00 00 	movabs $0x800d28,%r8
  80051a:	00 00 00 
  80051d:	41 ff d0             	callq  *%r8
	cprintf("stale fileid is good\n");
  800520:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  800527:	00 00 00 
  80052a:	b8 00 00 00 00       	mov    $0x0,%eax
  80052f:	48 ba 61 0f 80 00 00 	movabs $0x800f61,%rdx
  800536:	00 00 00 
  800539:	ff d2                	callq  *%rdx

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  80053b:	be 02 01 00 00       	mov    $0x102,%esi
  800540:	48 bf c5 41 80 00 00 	movabs $0x8041c5,%rdi
  800547:	00 00 00 
  80054a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800551:	00 00 00 
  800554:	ff d0                	callq  *%rax
  800556:	48 98                	cltq   
  800558:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80055c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800561:	79 32                	jns    800595 <umain+0x4bd>
		panic("serve_open /new-file: %e", r);
  800563:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800567:	48 89 c1             	mov    %rax,%rcx
  80056a:	48 ba cf 41 80 00 00 	movabs $0x8041cf,%rdx
  800571:	00 00 00 
  800574:	be 48 00 00 00       	mov    $0x48,%esi
  800579:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  800580:	00 00 00 
  800583:	b8 00 00 00 00       	mov    $0x0,%eax
  800588:	49 b8 28 0d 80 00 00 	movabs $0x800d28,%r8
  80058f:	00 00 00 
  800592:	41 ff d0             	callq  *%r8

	cprintf("xopen new file worked devfile %p, dev_write %p, msg %p, FVA %p\n", devfile, devfile.dev_write, msg, FVA);
  800595:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80059c:	00 00 00 
  80059f:	48 8b 10             	mov    (%rax),%rdx
  8005a2:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  8005a9:	00 00 00 
  8005ac:	48 8b 70 18          	mov    0x18(%rax),%rsi
  8005b0:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  8005b7:	00 00 00 
  8005ba:	48 8b 08             	mov    (%rax),%rcx
  8005bd:	48 89 0c 24          	mov    %rcx,(%rsp)
  8005c1:	48 8b 48 08          	mov    0x8(%rax),%rcx
  8005c5:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  8005ca:	48 8b 48 10          	mov    0x10(%rax),%rcx
  8005ce:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  8005d3:	48 8b 48 18          	mov    0x18(%rax),%rcx
  8005d7:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  8005dc:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8005e0:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  8005e5:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8005e9:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  8005ee:	48 8b 40 30          	mov    0x30(%rax),%rax
  8005f2:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8005f7:	b9 00 c0 cc cc       	mov    $0xccccc000,%ecx
  8005fc:	48 bf e8 41 80 00 00 	movabs $0x8041e8,%rdi
  800603:	00 00 00 
  800606:	b8 00 00 00 00       	mov    $0x0,%eax
  80060b:	49 b8 61 0f 80 00 00 	movabs $0x800f61,%r8
  800612:	00 00 00 
  800615:	41 ff d0             	callq  *%r8

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800618:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  80061f:	00 00 00 
  800622:	48 8b 58 18          	mov    0x18(%rax),%rbx
  800626:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80062d:	00 00 00 
  800630:	48 8b 00             	mov    (%rax),%rax
  800633:	48 89 c7             	mov    %rax,%rdi
  800636:	48 b8 aa 1a 80 00 00 	movabs $0x801aaa,%rax
  80063d:	00 00 00 
  800640:	ff d0                	callq  *%rax
  800642:	48 63 d0             	movslq %eax,%rdx
  800645:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80064c:	00 00 00 
  80064f:	48 8b 00             	mov    (%rax),%rax
  800652:	48 89 c6             	mov    %rax,%rsi
  800655:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  80065a:	ff d3                	callq  *%rbx
  80065c:	48 98                	cltq   
  80065e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800662:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800669:	00 00 00 
  80066c:	48 8b 00             	mov    (%rax),%rax
  80066f:	48 89 c7             	mov    %rax,%rdi
  800672:	48 b8 aa 1a 80 00 00 	movabs $0x801aaa,%rax
  800679:	00 00 00 
  80067c:	ff d0                	callq  *%rax
  80067e:	48 98                	cltq   
  800680:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
  800684:	74 32                	je     8006b8 <umain+0x5e0>
		panic("file_write: %e", r);
  800686:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80068a:	48 89 c1             	mov    %rax,%rcx
  80068d:	48 ba 28 42 80 00 00 	movabs $0x804228,%rdx
  800694:	00 00 00 
  800697:	be 4d 00 00 00       	mov    $0x4d,%esi
  80069c:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  8006a3:	00 00 00 
  8006a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ab:	49 b8 28 0d 80 00 00 	movabs $0x800d28,%r8
  8006b2:	00 00 00 
  8006b5:	41 ff d0             	callq  *%r8
	cprintf("file_write is good\n");
  8006b8:	48 bf 37 42 80 00 00 	movabs $0x804237,%rdi
  8006bf:	00 00 00 
  8006c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c7:	48 ba 61 0f 80 00 00 	movabs $0x800f61,%rdx
  8006ce:	00 00 00 
  8006d1:	ff d2                	callq  *%rdx

	FVA->fd_offset = 0;
  8006d3:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8006d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	memset(buf, 0, sizeof buf);
  8006df:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8006e6:	ba 00 02 00 00       	mov    $0x200,%edx
  8006eb:	be 00 00 00 00       	mov    $0x0,%esi
  8006f0:	48 89 c7             	mov    %rax,%rdi
  8006f3:	48 b8 af 1d 80 00 00 	movabs $0x801daf,%rax
  8006fa:	00 00 00 
  8006fd:	ff d0                	callq  *%rax
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8006ff:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  800706:	00 00 00 
  800709:	48 8b 40 10          	mov    0x10(%rax),%rax
  80070d:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800714:	ba 00 02 00 00       	mov    $0x200,%edx
  800719:	48 89 ce             	mov    %rcx,%rsi
  80071c:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800721:	ff d0                	callq  *%rax
  800723:	48 98                	cltq   
  800725:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800729:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80072e:	79 32                	jns    800762 <umain+0x68a>
		panic("file_read after file_write: %e", r);
  800730:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800734:	48 89 c1             	mov    %rax,%rcx
  800737:	48 ba 50 42 80 00 00 	movabs $0x804250,%rdx
  80073e:	00 00 00 
  800741:	be 53 00 00 00       	mov    $0x53,%esi
  800746:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  80074d:	00 00 00 
  800750:	b8 00 00 00 00       	mov    $0x0,%eax
  800755:	49 b8 28 0d 80 00 00 	movabs $0x800d28,%r8
  80075c:	00 00 00 
  80075f:	41 ff d0             	callq  *%r8
	if (r != strlen(msg))
  800762:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800769:	00 00 00 
  80076c:	48 8b 00             	mov    (%rax),%rax
  80076f:	48 89 c7             	mov    %rax,%rdi
  800772:	48 b8 aa 1a 80 00 00 	movabs $0x801aaa,%rax
  800779:	00 00 00 
  80077c:	ff d0                	callq  *%rax
  80077e:	48 98                	cltq   
  800780:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  800784:	74 32                	je     8007b8 <umain+0x6e0>
		panic("file_read after file_write returned wrong length: %d", r);
  800786:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80078a:	48 89 c1             	mov    %rax,%rcx
  80078d:	48 ba 70 42 80 00 00 	movabs $0x804270,%rdx
  800794:	00 00 00 
  800797:	be 55 00 00 00       	mov    $0x55,%esi
  80079c:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  8007a3:	00 00 00 
  8007a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ab:	49 b8 28 0d 80 00 00 	movabs $0x800d28,%r8
  8007b2:	00 00 00 
  8007b5:	41 ff d0             	callq  *%r8
	if (strcmp(buf, msg) != 0)
  8007b8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8007bf:	00 00 00 
  8007c2:	48 8b 10             	mov    (%rax),%rdx
  8007c5:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8007cc:	48 89 d6             	mov    %rdx,%rsi
  8007cf:	48 89 c7             	mov    %rax,%rdi
  8007d2:	48 b8 78 1c 80 00 00 	movabs $0x801c78,%rax
  8007d9:	00 00 00 
  8007dc:	ff d0                	callq  *%rax
  8007de:	85 c0                	test   %eax,%eax
  8007e0:	74 2a                	je     80080c <umain+0x734>
		panic("file_read after file_write returned wrong data");
  8007e2:	48 ba a8 42 80 00 00 	movabs $0x8042a8,%rdx
  8007e9:	00 00 00 
  8007ec:	be 57 00 00 00       	mov    $0x57,%esi
  8007f1:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  8007f8:	00 00 00 
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800800:	48 b9 28 0d 80 00 00 	movabs $0x800d28,%rcx
  800807:	00 00 00 
  80080a:	ff d1                	callq  *%rcx
	cprintf("file_read after file_write is good\n");
  80080c:	48 bf d8 42 80 00 00 	movabs $0x8042d8,%rdi
  800813:	00 00 00 
  800816:	b8 00 00 00 00       	mov    $0x0,%eax
  80081b:	48 ba 61 0f 80 00 00 	movabs $0x800f61,%rdx
  800822:	00 00 00 
  800825:	ff d2                	callq  *%rdx

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800827:	be 00 00 00 00       	mov    $0x0,%esi
  80082c:	48 bf 06 40 80 00 00 	movabs $0x804006,%rdi
  800833:	00 00 00 
  800836:	48 b8 8a 32 80 00 00 	movabs $0x80328a,%rax
  80083d:	00 00 00 
  800840:	ff d0                	callq  *%rax
  800842:	48 98                	cltq   
  800844:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800848:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80084d:	79 39                	jns    800888 <umain+0x7b0>
  80084f:	48 83 7d e0 f4       	cmpq   $0xfffffffffffffff4,-0x20(%rbp)
  800854:	74 32                	je     800888 <umain+0x7b0>
		panic("open /not-found: %e", r);
  800856:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80085a:	48 89 c1             	mov    %rax,%rcx
  80085d:	48 ba fc 42 80 00 00 	movabs $0x8042fc,%rdx
  800864:	00 00 00 
  800867:	be 5c 00 00 00       	mov    $0x5c,%esi
  80086c:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  800873:	00 00 00 
  800876:	b8 00 00 00 00       	mov    $0x0,%eax
  80087b:	49 b8 28 0d 80 00 00 	movabs $0x800d28,%r8
  800882:	00 00 00 
  800885:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800888:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80088d:	78 2a                	js     8008b9 <umain+0x7e1>
		panic("open /not-found succeeded!");
  80088f:	48 ba 10 43 80 00 00 	movabs $0x804310,%rdx
  800896:	00 00 00 
  800899:	be 5e 00 00 00       	mov    $0x5e,%esi
  80089e:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  8008a5:	00 00 00 
  8008a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ad:	48 b9 28 0d 80 00 00 	movabs $0x800d28,%rcx
  8008b4:	00 00 00 
  8008b7:	ff d1                	callq  *%rcx

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  8008b9:	be 00 00 00 00       	mov    $0x0,%esi
  8008be:	48 bf 61 40 80 00 00 	movabs $0x804061,%rdi
  8008c5:	00 00 00 
  8008c8:	48 b8 8a 32 80 00 00 	movabs $0x80328a,%rax
  8008cf:	00 00 00 
  8008d2:	ff d0                	callq  *%rax
  8008d4:	48 98                	cltq   
  8008d6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8008da:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8008df:	79 32                	jns    800913 <umain+0x83b>
		panic("open /newmotd: %e", r);
  8008e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008e5:	48 89 c1             	mov    %rax,%rcx
  8008e8:	48 ba 2b 43 80 00 00 	movabs $0x80432b,%rdx
  8008ef:	00 00 00 
  8008f2:	be 61 00 00 00       	mov    $0x61,%esi
  8008f7:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  8008fe:	00 00 00 
  800901:	b8 00 00 00 00       	mov    $0x0,%eax
  800906:	49 b8 28 0d 80 00 00 	movabs $0x800d28,%r8
  80090d:	00 00 00 
  800910:	41 ff d0             	callq  *%r8
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800913:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800917:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80091d:	48 c1 e0 0c          	shl    $0xc,%rax
  800921:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  800925:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800929:	8b 00                	mov    (%rax),%eax
  80092b:	83 f8 66             	cmp    $0x66,%eax
  80092e:	75 16                	jne    800946 <umain+0x86e>
  800930:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800934:	8b 40 04             	mov    0x4(%rax),%eax
  800937:	85 c0                	test   %eax,%eax
  800939:	75 0b                	jne    800946 <umain+0x86e>
  80093b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80093f:	8b 40 08             	mov    0x8(%rax),%eax
  800942:	85 c0                	test   %eax,%eax
  800944:	74 2a                	je     800970 <umain+0x898>
		panic("open did not fill struct Fd correctly\n");
  800946:	48 ba 40 43 80 00 00 	movabs $0x804340,%rdx
  80094d:	00 00 00 
  800950:	be 64 00 00 00       	mov    $0x64,%esi
  800955:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  80095c:	00 00 00 
  80095f:	b8 00 00 00 00       	mov    $0x0,%eax
  800964:	48 b9 28 0d 80 00 00 	movabs $0x800d28,%rcx
  80096b:	00 00 00 
  80096e:	ff d1                	callq  *%rcx
	cprintf("open is good\n");
  800970:	48 bf 67 43 80 00 00 	movabs $0x804367,%rdi
  800977:	00 00 00 
  80097a:	b8 00 00 00 00       	mov    $0x0,%eax
  80097f:	48 ba 61 0f 80 00 00 	movabs $0x800f61,%rdx
  800986:	00 00 00 
  800989:	ff d2                	callq  *%rdx

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  80098b:	be 01 01 00 00       	mov    $0x101,%esi
  800990:	48 bf 75 43 80 00 00 	movabs $0x804375,%rdi
  800997:	00 00 00 
  80099a:	48 b8 8a 32 80 00 00 	movabs $0x80328a,%rax
  8009a1:	00 00 00 
  8009a4:	ff d0                	callq  *%rax
  8009a6:	48 98                	cltq   
  8009a8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8009ac:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8009b1:	79 32                	jns    8009e5 <umain+0x90d>
		panic("creat /big: %e", f);
  8009b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8009b7:	48 89 c1             	mov    %rax,%rcx
  8009ba:	48 ba 7a 43 80 00 00 	movabs $0x80437a,%rdx
  8009c1:	00 00 00 
  8009c4:	be 69 00 00 00       	mov    $0x69,%esi
  8009c9:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  8009d0:	00 00 00 
  8009d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d8:	49 b8 28 0d 80 00 00 	movabs $0x800d28,%r8
  8009df:	00 00 00 
  8009e2:	41 ff d0             	callq  *%r8
	memset(buf, 0, sizeof(buf));
  8009e5:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8009ec:	ba 00 02 00 00       	mov    $0x200,%edx
  8009f1:	be 00 00 00 00       	mov    $0x0,%esi
  8009f6:	48 89 c7             	mov    %rax,%rdi
  8009f9:	48 b8 af 1d 80 00 00 	movabs $0x801daf,%rax
  800a00:	00 00 00 
  800a03:	ff d0                	callq  *%rax
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800a05:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800a0c:	00 
  800a0d:	e9 82 00 00 00       	jmpq   800a94 <umain+0x9bc>
		*(int*)buf = i;
  800a12:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800a19:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1d:	89 10                	mov    %edx,(%rax)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  800a1f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a23:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800a2a:	ba 00 02 00 00       	mov    $0x200,%edx
  800a2f:	48 89 ce             	mov    %rcx,%rsi
  800a32:	89 c7                	mov    %eax,%edi
  800a34:	48 b8 fe 2e 80 00 00 	movabs $0x802efe,%rax
  800a3b:	00 00 00 
  800a3e:	ff d0                	callq  *%rax
  800a40:	48 98                	cltq   
  800a42:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800a46:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800a4b:	79 39                	jns    800a86 <umain+0x9ae>
			panic("write /big@%d: %e", i, r);
  800a4d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800a51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a55:	49 89 d0             	mov    %rdx,%r8
  800a58:	48 89 c1             	mov    %rax,%rcx
  800a5b:	48 ba 89 43 80 00 00 	movabs $0x804389,%rdx
  800a62:	00 00 00 
  800a65:	be 6e 00 00 00       	mov    $0x6e,%esi
  800a6a:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  800a71:	00 00 00 
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
  800a79:	49 b9 28 0d 80 00 00 	movabs $0x800d28,%r9
  800a80:	00 00 00 
  800a83:	41 ff d1             	callq  *%r9

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800a86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8a:	48 05 00 02 00 00    	add    $0x200,%rax
  800a90:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800a94:	48 81 7d e8 ff df 01 	cmpq   $0x1dfff,-0x18(%rbp)
  800a9b:	00 
  800a9c:	0f 8e 70 ff ff ff    	jle    800a12 <umain+0x93a>
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  800aa2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800aa6:	89 c7                	mov    %eax,%edi
  800aa8:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  800aaf:	00 00 00 
  800ab2:	ff d0                	callq  *%rax

	if ((f = open("/big", O_RDONLY)) < 0)
  800ab4:	be 00 00 00 00       	mov    $0x0,%esi
  800ab9:	48 bf 75 43 80 00 00 	movabs $0x804375,%rdi
  800ac0:	00 00 00 
  800ac3:	48 b8 8a 32 80 00 00 	movabs $0x80328a,%rax
  800aca:	00 00 00 
  800acd:	ff d0                	callq  *%rax
  800acf:	48 98                	cltq   
  800ad1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ad5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800ada:	79 32                	jns    800b0e <umain+0xa36>
		panic("open /big: %e", f);
  800adc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ae0:	48 89 c1             	mov    %rax,%rcx
  800ae3:	48 ba 9b 43 80 00 00 	movabs $0x80439b,%rdx
  800aea:	00 00 00 
  800aed:	be 73 00 00 00       	mov    $0x73,%esi
  800af2:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  800af9:	00 00 00 
  800afc:	b8 00 00 00 00       	mov    $0x0,%eax
  800b01:	49 b8 28 0d 80 00 00 	movabs $0x800d28,%r8
  800b08:	00 00 00 
  800b0b:	41 ff d0             	callq  *%r8
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800b0e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800b15:	00 
  800b16:	e9 1a 01 00 00       	jmpq   800c35 <umain+0xb5d>
		*(int*)buf = i;
  800b1b:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800b22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b26:	89 10                	mov    %edx,(%rax)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800b28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800b2c:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800b33:	ba 00 02 00 00       	mov    $0x200,%edx
  800b38:	48 89 ce             	mov    %rcx,%rsi
  800b3b:	89 c7                	mov    %eax,%edi
  800b3d:	48 b8 89 2e 80 00 00 	movabs $0x802e89,%rax
  800b44:	00 00 00 
  800b47:	ff d0                	callq  *%rax
  800b49:	48 98                	cltq   
  800b4b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800b4f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800b54:	79 39                	jns    800b8f <umain+0xab7>
			panic("read /big@%d: %e", i, r);
  800b56:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b5e:	49 89 d0             	mov    %rdx,%r8
  800b61:	48 89 c1             	mov    %rax,%rcx
  800b64:	48 ba a9 43 80 00 00 	movabs $0x8043a9,%rdx
  800b6b:	00 00 00 
  800b6e:	be 77 00 00 00       	mov    $0x77,%esi
  800b73:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  800b7a:	00 00 00 
  800b7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b82:	49 b9 28 0d 80 00 00 	movabs $0x800d28,%r9
  800b89:	00 00 00 
  800b8c:	41 ff d1             	callq  *%r9
		if (r != sizeof(buf))
  800b8f:	48 81 7d e0 00 02 00 	cmpq   $0x200,-0x20(%rbp)
  800b96:	00 
  800b97:	74 3f                	je     800bd8 <umain+0xb00>
			panic("read /big from %d returned %d < %d bytes",
  800b99:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba1:	41 b9 00 02 00 00    	mov    $0x200,%r9d
  800ba7:	49 89 d0             	mov    %rdx,%r8
  800baa:	48 89 c1             	mov    %rax,%rcx
  800bad:	48 ba c0 43 80 00 00 	movabs $0x8043c0,%rdx
  800bb4:	00 00 00 
  800bb7:	be 7a 00 00 00       	mov    $0x7a,%esi
  800bbc:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  800bc3:	00 00 00 
  800bc6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bcb:	49 ba 28 0d 80 00 00 	movabs $0x800d28,%r10
  800bd2:	00 00 00 
  800bd5:	41 ff d2             	callq  *%r10
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800bd8:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800bdf:	8b 00                	mov    (%rax),%eax
  800be1:	48 98                	cltq   
  800be3:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800be7:	74 3e                	je     800c27 <umain+0xb4f>
			panic("read /big from %d returned bad data %d",
  800be9:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800bf0:	8b 10                	mov    (%rax),%edx
  800bf2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf6:	41 89 d0             	mov    %edx,%r8d
  800bf9:	48 89 c1             	mov    %rax,%rcx
  800bfc:	48 ba f0 43 80 00 00 	movabs $0x8043f0,%rdx
  800c03:	00 00 00 
  800c06:	be 7d 00 00 00       	mov    $0x7d,%esi
  800c0b:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  800c12:	00 00 00 
  800c15:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1a:	49 b9 28 0d 80 00 00 	movabs $0x800d28,%r9
  800c21:	00 00 00 
  800c24:	41 ff d1             	callq  *%r9
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800c27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c2b:	48 05 00 02 00 00    	add    $0x200,%rax
  800c31:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800c35:	48 81 7d e8 ff df 01 	cmpq   $0x1dfff,-0x18(%rbp)
  800c3c:	00 
  800c3d:	0f 8e d8 fe ff ff    	jle    800b1b <umain+0xa43>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  800c43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c47:	89 c7                	mov    %eax,%edi
  800c49:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  800c50:	00 00 00 
  800c53:	ff d0                	callq  *%rax
	cprintf("large file is good\n");
  800c55:	48 bf 17 44 80 00 00 	movabs $0x804417,%rdi
  800c5c:	00 00 00 
  800c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c64:	48 ba 61 0f 80 00 00 	movabs $0x800f61,%rdx
  800c6b:	00 00 00 
  800c6e:	ff d2                	callq  *%rdx
}
  800c70:	48 81 c4 18 03 00 00 	add    $0x318,%rsp
  800c77:	5b                   	pop    %rbx
  800c78:	5d                   	pop    %rbp
  800c79:	c3                   	retq   

0000000000800c7a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800c7a:	55                   	push   %rbp
  800c7b:	48 89 e5             	mov    %rsp,%rbp
  800c7e:	48 83 ec 10          	sub    $0x10,%rsp
  800c82:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c85:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800c89:	48 b8 c9 23 80 00 00 	movabs $0x8023c9,%rax
  800c90:	00 00 00 
  800c93:	ff d0                	callq  *%rax
  800c95:	25 ff 03 00 00       	and    $0x3ff,%eax
  800c9a:	48 63 d0             	movslq %eax,%rdx
  800c9d:	48 89 d0             	mov    %rdx,%rax
  800ca0:	48 c1 e0 03          	shl    $0x3,%rax
  800ca4:	48 01 d0             	add    %rdx,%rax
  800ca7:	48 c1 e0 05          	shl    $0x5,%rax
  800cab:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800cb2:	00 00 00 
  800cb5:	48 01 c2             	add    %rax,%rdx
  800cb8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800cbf:	00 00 00 
  800cc2:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800cc5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cc9:	7e 14                	jle    800cdf <libmain+0x65>
		binaryname = argv[0];
  800ccb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ccf:	48 8b 10             	mov    (%rax),%rdx
  800cd2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800cd9:	00 00 00 
  800cdc:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800cdf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ce3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ce6:	48 89 d6             	mov    %rdx,%rsi
  800ce9:	89 c7                	mov    %eax,%edi
  800ceb:	48 b8 d8 00 80 00 00 	movabs $0x8000d8,%rax
  800cf2:	00 00 00 
  800cf5:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800cf7:	48 b8 05 0d 80 00 00 	movabs $0x800d05,%rax
  800cfe:	00 00 00 
  800d01:	ff d0                	callq  *%rax
}
  800d03:	c9                   	leaveq 
  800d04:	c3                   	retq   

0000000000800d05 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800d05:	55                   	push   %rbp
  800d06:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800d09:	48 b8 dd 2b 80 00 00 	movabs $0x802bdd,%rax
  800d10:	00 00 00 
  800d13:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800d15:	bf 00 00 00 00       	mov    $0x0,%edi
  800d1a:	48 b8 85 23 80 00 00 	movabs $0x802385,%rax
  800d21:	00 00 00 
  800d24:	ff d0                	callq  *%rax

}
  800d26:	5d                   	pop    %rbp
  800d27:	c3                   	retq   

0000000000800d28 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800d28:	55                   	push   %rbp
  800d29:	48 89 e5             	mov    %rsp,%rbp
  800d2c:	53                   	push   %rbx
  800d2d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800d34:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800d3b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800d41:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800d48:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800d4f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800d56:	84 c0                	test   %al,%al
  800d58:	74 23                	je     800d7d <_panic+0x55>
  800d5a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800d61:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800d65:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800d69:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800d6d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800d71:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800d75:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800d79:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800d7d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d84:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800d8b:	00 00 00 
  800d8e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800d95:	00 00 00 
  800d98:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d9c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800da3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800daa:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800db1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800db8:	00 00 00 
  800dbb:	48 8b 18             	mov    (%rax),%rbx
  800dbe:	48 b8 c9 23 80 00 00 	movabs $0x8023c9,%rax
  800dc5:	00 00 00 
  800dc8:	ff d0                	callq  *%rax
  800dca:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800dd0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800dd7:	41 89 c8             	mov    %ecx,%r8d
  800dda:	48 89 d1             	mov    %rdx,%rcx
  800ddd:	48 89 da             	mov    %rbx,%rdx
  800de0:	89 c6                	mov    %eax,%esi
  800de2:	48 bf 38 44 80 00 00 	movabs $0x804438,%rdi
  800de9:	00 00 00 
  800dec:	b8 00 00 00 00       	mov    $0x0,%eax
  800df1:	49 b9 61 0f 80 00 00 	movabs $0x800f61,%r9
  800df8:	00 00 00 
  800dfb:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800dfe:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800e05:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e0c:	48 89 d6             	mov    %rdx,%rsi
  800e0f:	48 89 c7             	mov    %rax,%rdi
  800e12:	48 b8 b5 0e 80 00 00 	movabs $0x800eb5,%rax
  800e19:	00 00 00 
  800e1c:	ff d0                	callq  *%rax
	cprintf("\n");
  800e1e:	48 bf 5b 44 80 00 00 	movabs $0x80445b,%rdi
  800e25:	00 00 00 
  800e28:	b8 00 00 00 00       	mov    $0x0,%eax
  800e2d:	48 ba 61 0f 80 00 00 	movabs $0x800f61,%rdx
  800e34:	00 00 00 
  800e37:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800e39:	cc                   	int3   
  800e3a:	eb fd                	jmp    800e39 <_panic+0x111>

0000000000800e3c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800e3c:	55                   	push   %rbp
  800e3d:	48 89 e5             	mov    %rsp,%rbp
  800e40:	48 83 ec 10          	sub    $0x10,%rsp
  800e44:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e47:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800e4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e4f:	8b 00                	mov    (%rax),%eax
  800e51:	8d 48 01             	lea    0x1(%rax),%ecx
  800e54:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e58:	89 0a                	mov    %ecx,(%rdx)
  800e5a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e5d:	89 d1                	mov    %edx,%ecx
  800e5f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e63:	48 98                	cltq   
  800e65:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800e69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e6d:	8b 00                	mov    (%rax),%eax
  800e6f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e74:	75 2c                	jne    800ea2 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800e76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e7a:	8b 00                	mov    (%rax),%eax
  800e7c:	48 98                	cltq   
  800e7e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e82:	48 83 c2 08          	add    $0x8,%rdx
  800e86:	48 89 c6             	mov    %rax,%rsi
  800e89:	48 89 d7             	mov    %rdx,%rdi
  800e8c:	48 b8 fd 22 80 00 00 	movabs $0x8022fd,%rax
  800e93:	00 00 00 
  800e96:	ff d0                	callq  *%rax
		b->idx = 0;
  800e98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800ea2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea6:	8b 40 04             	mov    0x4(%rax),%eax
  800ea9:	8d 50 01             	lea    0x1(%rax),%edx
  800eac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eb0:	89 50 04             	mov    %edx,0x4(%rax)
}
  800eb3:	c9                   	leaveq 
  800eb4:	c3                   	retq   

0000000000800eb5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800eb5:	55                   	push   %rbp
  800eb6:	48 89 e5             	mov    %rsp,%rbp
  800eb9:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800ec0:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800ec7:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800ece:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800ed5:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800edc:	48 8b 0a             	mov    (%rdx),%rcx
  800edf:	48 89 08             	mov    %rcx,(%rax)
  800ee2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ee6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800eea:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800eee:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800ef2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800ef9:	00 00 00 
	b.cnt = 0;
  800efc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800f03:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800f06:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800f0d:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800f14:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800f1b:	48 89 c6             	mov    %rax,%rsi
  800f1e:	48 bf 3c 0e 80 00 00 	movabs $0x800e3c,%rdi
  800f25:	00 00 00 
  800f28:	48 b8 14 13 80 00 00 	movabs $0x801314,%rax
  800f2f:	00 00 00 
  800f32:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800f34:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800f3a:	48 98                	cltq   
  800f3c:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800f43:	48 83 c2 08          	add    $0x8,%rdx
  800f47:	48 89 c6             	mov    %rax,%rsi
  800f4a:	48 89 d7             	mov    %rdx,%rdi
  800f4d:	48 b8 fd 22 80 00 00 	movabs $0x8022fd,%rax
  800f54:	00 00 00 
  800f57:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800f59:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800f5f:	c9                   	leaveq 
  800f60:	c3                   	retq   

0000000000800f61 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800f61:	55                   	push   %rbp
  800f62:	48 89 e5             	mov    %rsp,%rbp
  800f65:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800f6c:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800f73:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800f7a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f81:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f88:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f8f:	84 c0                	test   %al,%al
  800f91:	74 20                	je     800fb3 <cprintf+0x52>
  800f93:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f97:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f9b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f9f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fa3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fa7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fab:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800faf:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fb3:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800fba:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800fc1:	00 00 00 
  800fc4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fcb:	00 00 00 
  800fce:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fd2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fd9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fe0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fe7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fee:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ff5:	48 8b 0a             	mov    (%rdx),%rcx
  800ff8:	48 89 08             	mov    %rcx,(%rax)
  800ffb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fff:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801003:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801007:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  80100b:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  801012:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801019:	48 89 d6             	mov    %rdx,%rsi
  80101c:	48 89 c7             	mov    %rax,%rdi
  80101f:	48 b8 b5 0e 80 00 00 	movabs $0x800eb5,%rax
  801026:	00 00 00 
  801029:	ff d0                	callq  *%rax
  80102b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  801031:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801037:	c9                   	leaveq 
  801038:	c3                   	retq   

0000000000801039 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801039:	55                   	push   %rbp
  80103a:	48 89 e5             	mov    %rsp,%rbp
  80103d:	53                   	push   %rbx
  80103e:	48 83 ec 38          	sub    $0x38,%rsp
  801042:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801046:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80104a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80104e:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  801051:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  801055:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801059:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80105c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801060:	77 3b                	ja     80109d <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801062:	8b 45 d0             	mov    -0x30(%rbp),%eax
  801065:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  801069:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80106c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801070:	ba 00 00 00 00       	mov    $0x0,%edx
  801075:	48 f7 f3             	div    %rbx
  801078:	48 89 c2             	mov    %rax,%rdx
  80107b:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80107e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801081:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  801085:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801089:	41 89 f9             	mov    %edi,%r9d
  80108c:	48 89 c7             	mov    %rax,%rdi
  80108f:	48 b8 39 10 80 00 00 	movabs $0x801039,%rax
  801096:	00 00 00 
  801099:	ff d0                	callq  *%rax
  80109b:	eb 1e                	jmp    8010bb <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80109d:	eb 12                	jmp    8010b1 <printnum+0x78>
			putch(padc, putdat);
  80109f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8010a3:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8010a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010aa:	48 89 ce             	mov    %rcx,%rsi
  8010ad:	89 d7                	mov    %edx,%edi
  8010af:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010b1:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8010b5:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8010b9:	7f e4                	jg     80109f <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010bb:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8010be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c7:	48 f7 f1             	div    %rcx
  8010ca:	48 89 d0             	mov    %rdx,%rax
  8010cd:	48 ba 28 46 80 00 00 	movabs $0x804628,%rdx
  8010d4:	00 00 00 
  8010d7:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8010db:	0f be d0             	movsbl %al,%edx
  8010de:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8010e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e6:	48 89 ce             	mov    %rcx,%rsi
  8010e9:	89 d7                	mov    %edx,%edi
  8010eb:	ff d0                	callq  *%rax
}
  8010ed:	48 83 c4 38          	add    $0x38,%rsp
  8010f1:	5b                   	pop    %rbx
  8010f2:	5d                   	pop    %rbp
  8010f3:	c3                   	retq   

00000000008010f4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8010f4:	55                   	push   %rbp
  8010f5:	48 89 e5             	mov    %rsp,%rbp
  8010f8:	48 83 ec 1c          	sub    $0x1c,%rsp
  8010fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801100:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  801103:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801107:	7e 52                	jle    80115b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  801109:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110d:	8b 00                	mov    (%rax),%eax
  80110f:	83 f8 30             	cmp    $0x30,%eax
  801112:	73 24                	jae    801138 <getuint+0x44>
  801114:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801118:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80111c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801120:	8b 00                	mov    (%rax),%eax
  801122:	89 c0                	mov    %eax,%eax
  801124:	48 01 d0             	add    %rdx,%rax
  801127:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80112b:	8b 12                	mov    (%rdx),%edx
  80112d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801130:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801134:	89 0a                	mov    %ecx,(%rdx)
  801136:	eb 17                	jmp    80114f <getuint+0x5b>
  801138:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801140:	48 89 d0             	mov    %rdx,%rax
  801143:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801147:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80114b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80114f:	48 8b 00             	mov    (%rax),%rax
  801152:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801156:	e9 a3 00 00 00       	jmpq   8011fe <getuint+0x10a>
	else if (lflag)
  80115b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80115f:	74 4f                	je     8011b0 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  801161:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801165:	8b 00                	mov    (%rax),%eax
  801167:	83 f8 30             	cmp    $0x30,%eax
  80116a:	73 24                	jae    801190 <getuint+0x9c>
  80116c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801170:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801174:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801178:	8b 00                	mov    (%rax),%eax
  80117a:	89 c0                	mov    %eax,%eax
  80117c:	48 01 d0             	add    %rdx,%rax
  80117f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801183:	8b 12                	mov    (%rdx),%edx
  801185:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801188:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80118c:	89 0a                	mov    %ecx,(%rdx)
  80118e:	eb 17                	jmp    8011a7 <getuint+0xb3>
  801190:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801194:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801198:	48 89 d0             	mov    %rdx,%rax
  80119b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80119f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011a3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8011a7:	48 8b 00             	mov    (%rax),%rax
  8011aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8011ae:	eb 4e                	jmp    8011fe <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8011b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b4:	8b 00                	mov    (%rax),%eax
  8011b6:	83 f8 30             	cmp    $0x30,%eax
  8011b9:	73 24                	jae    8011df <getuint+0xeb>
  8011bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011bf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8011c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c7:	8b 00                	mov    (%rax),%eax
  8011c9:	89 c0                	mov    %eax,%eax
  8011cb:	48 01 d0             	add    %rdx,%rax
  8011ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011d2:	8b 12                	mov    (%rdx),%edx
  8011d4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8011d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011db:	89 0a                	mov    %ecx,(%rdx)
  8011dd:	eb 17                	jmp    8011f6 <getuint+0x102>
  8011df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8011e7:	48 89 d0             	mov    %rdx,%rax
  8011ea:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8011ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011f2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8011f6:	8b 00                	mov    (%rax),%eax
  8011f8:	89 c0                	mov    %eax,%eax
  8011fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8011fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801202:	c9                   	leaveq 
  801203:	c3                   	retq   

0000000000801204 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801204:	55                   	push   %rbp
  801205:	48 89 e5             	mov    %rsp,%rbp
  801208:	48 83 ec 1c          	sub    $0x1c,%rsp
  80120c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801210:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  801213:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801217:	7e 52                	jle    80126b <getint+0x67>
		x=va_arg(*ap, long long);
  801219:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121d:	8b 00                	mov    (%rax),%eax
  80121f:	83 f8 30             	cmp    $0x30,%eax
  801222:	73 24                	jae    801248 <getint+0x44>
  801224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801228:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80122c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801230:	8b 00                	mov    (%rax),%eax
  801232:	89 c0                	mov    %eax,%eax
  801234:	48 01 d0             	add    %rdx,%rax
  801237:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80123b:	8b 12                	mov    (%rdx),%edx
  80123d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801240:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801244:	89 0a                	mov    %ecx,(%rdx)
  801246:	eb 17                	jmp    80125f <getint+0x5b>
  801248:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801250:	48 89 d0             	mov    %rdx,%rax
  801253:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801257:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80125b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80125f:	48 8b 00             	mov    (%rax),%rax
  801262:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801266:	e9 a3 00 00 00       	jmpq   80130e <getint+0x10a>
	else if (lflag)
  80126b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80126f:	74 4f                	je     8012c0 <getint+0xbc>
		x=va_arg(*ap, long);
  801271:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801275:	8b 00                	mov    (%rax),%eax
  801277:	83 f8 30             	cmp    $0x30,%eax
  80127a:	73 24                	jae    8012a0 <getint+0x9c>
  80127c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801280:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801284:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801288:	8b 00                	mov    (%rax),%eax
  80128a:	89 c0                	mov    %eax,%eax
  80128c:	48 01 d0             	add    %rdx,%rax
  80128f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801293:	8b 12                	mov    (%rdx),%edx
  801295:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801298:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80129c:	89 0a                	mov    %ecx,(%rdx)
  80129e:	eb 17                	jmp    8012b7 <getint+0xb3>
  8012a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8012a8:	48 89 d0             	mov    %rdx,%rax
  8012ab:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8012af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012b3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8012b7:	48 8b 00             	mov    (%rax),%rax
  8012ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8012be:	eb 4e                	jmp    80130e <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8012c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c4:	8b 00                	mov    (%rax),%eax
  8012c6:	83 f8 30             	cmp    $0x30,%eax
  8012c9:	73 24                	jae    8012ef <getint+0xeb>
  8012cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012cf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8012d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d7:	8b 00                	mov    (%rax),%eax
  8012d9:	89 c0                	mov    %eax,%eax
  8012db:	48 01 d0             	add    %rdx,%rax
  8012de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012e2:	8b 12                	mov    (%rdx),%edx
  8012e4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8012e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012eb:	89 0a                	mov    %ecx,(%rdx)
  8012ed:	eb 17                	jmp    801306 <getint+0x102>
  8012ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8012f7:	48 89 d0             	mov    %rdx,%rax
  8012fa:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8012fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801302:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801306:	8b 00                	mov    (%rax),%eax
  801308:	48 98                	cltq   
  80130a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80130e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801312:	c9                   	leaveq 
  801313:	c3                   	retq   

0000000000801314 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801314:	55                   	push   %rbp
  801315:	48 89 e5             	mov    %rsp,%rbp
  801318:	41 54                	push   %r12
  80131a:	53                   	push   %rbx
  80131b:	48 83 ec 60          	sub    $0x60,%rsp
  80131f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  801323:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  801327:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80132b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80132f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801333:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  801337:	48 8b 0a             	mov    (%rdx),%rcx
  80133a:	48 89 08             	mov    %rcx,(%rax)
  80133d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801341:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801345:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801349:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80134d:	eb 17                	jmp    801366 <vprintfmt+0x52>
			if (ch == '\0')
  80134f:	85 db                	test   %ebx,%ebx
  801351:	0f 84 cc 04 00 00    	je     801823 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  801357:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80135b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80135f:	48 89 d6             	mov    %rdx,%rsi
  801362:	89 df                	mov    %ebx,%edi
  801364:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801366:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80136a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80136e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801372:	0f b6 00             	movzbl (%rax),%eax
  801375:	0f b6 d8             	movzbl %al,%ebx
  801378:	83 fb 25             	cmp    $0x25,%ebx
  80137b:	75 d2                	jne    80134f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80137d:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801381:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801388:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80138f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801396:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80139d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8013a1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013a5:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8013a9:	0f b6 00             	movzbl (%rax),%eax
  8013ac:	0f b6 d8             	movzbl %al,%ebx
  8013af:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8013b2:	83 f8 55             	cmp    $0x55,%eax
  8013b5:	0f 87 34 04 00 00    	ja     8017ef <vprintfmt+0x4db>
  8013bb:	89 c0                	mov    %eax,%eax
  8013bd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8013c4:	00 
  8013c5:	48 b8 50 46 80 00 00 	movabs $0x804650,%rax
  8013cc:	00 00 00 
  8013cf:	48 01 d0             	add    %rdx,%rax
  8013d2:	48 8b 00             	mov    (%rax),%rax
  8013d5:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8013d7:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8013db:	eb c0                	jmp    80139d <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8013dd:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8013e1:	eb ba                	jmp    80139d <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8013e3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8013ea:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8013ed:	89 d0                	mov    %edx,%eax
  8013ef:	c1 e0 02             	shl    $0x2,%eax
  8013f2:	01 d0                	add    %edx,%eax
  8013f4:	01 c0                	add    %eax,%eax
  8013f6:	01 d8                	add    %ebx,%eax
  8013f8:	83 e8 30             	sub    $0x30,%eax
  8013fb:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8013fe:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801402:	0f b6 00             	movzbl (%rax),%eax
  801405:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801408:	83 fb 2f             	cmp    $0x2f,%ebx
  80140b:	7e 0c                	jle    801419 <vprintfmt+0x105>
  80140d:	83 fb 39             	cmp    $0x39,%ebx
  801410:	7f 07                	jg     801419 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801412:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801417:	eb d1                	jmp    8013ea <vprintfmt+0xd6>
			goto process_precision;
  801419:	eb 58                	jmp    801473 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80141b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80141e:	83 f8 30             	cmp    $0x30,%eax
  801421:	73 17                	jae    80143a <vprintfmt+0x126>
  801423:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801427:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80142a:	89 c0                	mov    %eax,%eax
  80142c:	48 01 d0             	add    %rdx,%rax
  80142f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801432:	83 c2 08             	add    $0x8,%edx
  801435:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801438:	eb 0f                	jmp    801449 <vprintfmt+0x135>
  80143a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80143e:	48 89 d0             	mov    %rdx,%rax
  801441:	48 83 c2 08          	add    $0x8,%rdx
  801445:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801449:	8b 00                	mov    (%rax),%eax
  80144b:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80144e:	eb 23                	jmp    801473 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  801450:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801454:	79 0c                	jns    801462 <vprintfmt+0x14e>
				width = 0;
  801456:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80145d:	e9 3b ff ff ff       	jmpq   80139d <vprintfmt+0x89>
  801462:	e9 36 ff ff ff       	jmpq   80139d <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801467:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80146e:	e9 2a ff ff ff       	jmpq   80139d <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  801473:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801477:	79 12                	jns    80148b <vprintfmt+0x177>
				width = precision, precision = -1;
  801479:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80147c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80147f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801486:	e9 12 ff ff ff       	jmpq   80139d <vprintfmt+0x89>
  80148b:	e9 0d ff ff ff       	jmpq   80139d <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801490:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801494:	e9 04 ff ff ff       	jmpq   80139d <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801499:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80149c:	83 f8 30             	cmp    $0x30,%eax
  80149f:	73 17                	jae    8014b8 <vprintfmt+0x1a4>
  8014a1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8014a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014a8:	89 c0                	mov    %eax,%eax
  8014aa:	48 01 d0             	add    %rdx,%rax
  8014ad:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8014b0:	83 c2 08             	add    $0x8,%edx
  8014b3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8014b6:	eb 0f                	jmp    8014c7 <vprintfmt+0x1b3>
  8014b8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8014bc:	48 89 d0             	mov    %rdx,%rax
  8014bf:	48 83 c2 08          	add    $0x8,%rdx
  8014c3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8014c7:	8b 10                	mov    (%rax),%edx
  8014c9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8014cd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014d1:	48 89 ce             	mov    %rcx,%rsi
  8014d4:	89 d7                	mov    %edx,%edi
  8014d6:	ff d0                	callq  *%rax
			break;
  8014d8:	e9 40 03 00 00       	jmpq   80181d <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8014dd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014e0:	83 f8 30             	cmp    $0x30,%eax
  8014e3:	73 17                	jae    8014fc <vprintfmt+0x1e8>
  8014e5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8014e9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014ec:	89 c0                	mov    %eax,%eax
  8014ee:	48 01 d0             	add    %rdx,%rax
  8014f1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8014f4:	83 c2 08             	add    $0x8,%edx
  8014f7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8014fa:	eb 0f                	jmp    80150b <vprintfmt+0x1f7>
  8014fc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801500:	48 89 d0             	mov    %rdx,%rax
  801503:	48 83 c2 08          	add    $0x8,%rdx
  801507:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80150b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80150d:	85 db                	test   %ebx,%ebx
  80150f:	79 02                	jns    801513 <vprintfmt+0x1ff>
				err = -err;
  801511:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801513:	83 fb 10             	cmp    $0x10,%ebx
  801516:	7f 16                	jg     80152e <vprintfmt+0x21a>
  801518:	48 b8 a0 45 80 00 00 	movabs $0x8045a0,%rax
  80151f:	00 00 00 
  801522:	48 63 d3             	movslq %ebx,%rdx
  801525:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801529:	4d 85 e4             	test   %r12,%r12
  80152c:	75 2e                	jne    80155c <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80152e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801532:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801536:	89 d9                	mov    %ebx,%ecx
  801538:	48 ba 39 46 80 00 00 	movabs $0x804639,%rdx
  80153f:	00 00 00 
  801542:	48 89 c7             	mov    %rax,%rdi
  801545:	b8 00 00 00 00       	mov    $0x0,%eax
  80154a:	49 b8 2c 18 80 00 00 	movabs $0x80182c,%r8
  801551:	00 00 00 
  801554:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801557:	e9 c1 02 00 00       	jmpq   80181d <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80155c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801560:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801564:	4c 89 e1             	mov    %r12,%rcx
  801567:	48 ba 42 46 80 00 00 	movabs $0x804642,%rdx
  80156e:	00 00 00 
  801571:	48 89 c7             	mov    %rax,%rdi
  801574:	b8 00 00 00 00       	mov    $0x0,%eax
  801579:	49 b8 2c 18 80 00 00 	movabs $0x80182c,%r8
  801580:	00 00 00 
  801583:	41 ff d0             	callq  *%r8
			break;
  801586:	e9 92 02 00 00       	jmpq   80181d <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80158b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80158e:	83 f8 30             	cmp    $0x30,%eax
  801591:	73 17                	jae    8015aa <vprintfmt+0x296>
  801593:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801597:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80159a:	89 c0                	mov    %eax,%eax
  80159c:	48 01 d0             	add    %rdx,%rax
  80159f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8015a2:	83 c2 08             	add    $0x8,%edx
  8015a5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8015a8:	eb 0f                	jmp    8015b9 <vprintfmt+0x2a5>
  8015aa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8015ae:	48 89 d0             	mov    %rdx,%rax
  8015b1:	48 83 c2 08          	add    $0x8,%rdx
  8015b5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8015b9:	4c 8b 20             	mov    (%rax),%r12
  8015bc:	4d 85 e4             	test   %r12,%r12
  8015bf:	75 0a                	jne    8015cb <vprintfmt+0x2b7>
				p = "(null)";
  8015c1:	49 bc 45 46 80 00 00 	movabs $0x804645,%r12
  8015c8:	00 00 00 
			if (width > 0 && padc != '-')
  8015cb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8015cf:	7e 3f                	jle    801610 <vprintfmt+0x2fc>
  8015d1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8015d5:	74 39                	je     801610 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8015d7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8015da:	48 98                	cltq   
  8015dc:	48 89 c6             	mov    %rax,%rsi
  8015df:	4c 89 e7             	mov    %r12,%rdi
  8015e2:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  8015e9:	00 00 00 
  8015ec:	ff d0                	callq  *%rax
  8015ee:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8015f1:	eb 17                	jmp    80160a <vprintfmt+0x2f6>
					putch(padc, putdat);
  8015f3:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8015f7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8015fb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015ff:	48 89 ce             	mov    %rcx,%rsi
  801602:	89 d7                	mov    %edx,%edi
  801604:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801606:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80160a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80160e:	7f e3                	jg     8015f3 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801610:	eb 37                	jmp    801649 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  801612:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801616:	74 1e                	je     801636 <vprintfmt+0x322>
  801618:	83 fb 1f             	cmp    $0x1f,%ebx
  80161b:	7e 05                	jle    801622 <vprintfmt+0x30e>
  80161d:	83 fb 7e             	cmp    $0x7e,%ebx
  801620:	7e 14                	jle    801636 <vprintfmt+0x322>
					putch('?', putdat);
  801622:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801626:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80162a:	48 89 d6             	mov    %rdx,%rsi
  80162d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801632:	ff d0                	callq  *%rax
  801634:	eb 0f                	jmp    801645 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  801636:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80163a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80163e:	48 89 d6             	mov    %rdx,%rsi
  801641:	89 df                	mov    %ebx,%edi
  801643:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801645:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801649:	4c 89 e0             	mov    %r12,%rax
  80164c:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801650:	0f b6 00             	movzbl (%rax),%eax
  801653:	0f be d8             	movsbl %al,%ebx
  801656:	85 db                	test   %ebx,%ebx
  801658:	74 10                	je     80166a <vprintfmt+0x356>
  80165a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80165e:	78 b2                	js     801612 <vprintfmt+0x2fe>
  801660:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801664:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801668:	79 a8                	jns    801612 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80166a:	eb 16                	jmp    801682 <vprintfmt+0x36e>
				putch(' ', putdat);
  80166c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801670:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801674:	48 89 d6             	mov    %rdx,%rsi
  801677:	bf 20 00 00 00       	mov    $0x20,%edi
  80167c:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80167e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801682:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801686:	7f e4                	jg     80166c <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  801688:	e9 90 01 00 00       	jmpq   80181d <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80168d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801691:	be 03 00 00 00       	mov    $0x3,%esi
  801696:	48 89 c7             	mov    %rax,%rdi
  801699:	48 b8 04 12 80 00 00 	movabs $0x801204,%rax
  8016a0:	00 00 00 
  8016a3:	ff d0                	callq  *%rax
  8016a5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8016a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ad:	48 85 c0             	test   %rax,%rax
  8016b0:	79 1d                	jns    8016cf <vprintfmt+0x3bb>
				putch('-', putdat);
  8016b2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8016b6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8016ba:	48 89 d6             	mov    %rdx,%rsi
  8016bd:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8016c2:	ff d0                	callq  *%rax
				num = -(long long) num;
  8016c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016c8:	48 f7 d8             	neg    %rax
  8016cb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8016cf:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8016d6:	e9 d5 00 00 00       	jmpq   8017b0 <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8016db:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8016df:	be 03 00 00 00       	mov    $0x3,%esi
  8016e4:	48 89 c7             	mov    %rax,%rdi
  8016e7:	48 b8 f4 10 80 00 00 	movabs $0x8010f4,%rax
  8016ee:	00 00 00 
  8016f1:	ff d0                	callq  *%rax
  8016f3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8016f7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8016fe:	e9 ad 00 00 00       	jmpq   8017b0 <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  801703:	8b 55 e0             	mov    -0x20(%rbp),%edx
  801706:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80170a:	89 d6                	mov    %edx,%esi
  80170c:	48 89 c7             	mov    %rax,%rdi
  80170f:	48 b8 04 12 80 00 00 	movabs $0x801204,%rax
  801716:	00 00 00 
  801719:	ff d0                	callq  *%rax
  80171b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  80171f:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801726:	e9 85 00 00 00       	jmpq   8017b0 <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  80172b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80172f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801733:	48 89 d6             	mov    %rdx,%rsi
  801736:	bf 30 00 00 00       	mov    $0x30,%edi
  80173b:	ff d0                	callq  *%rax
			putch('x', putdat);
  80173d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801741:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801745:	48 89 d6             	mov    %rdx,%rsi
  801748:	bf 78 00 00 00       	mov    $0x78,%edi
  80174d:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80174f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801752:	83 f8 30             	cmp    $0x30,%eax
  801755:	73 17                	jae    80176e <vprintfmt+0x45a>
  801757:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80175b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80175e:	89 c0                	mov    %eax,%eax
  801760:	48 01 d0             	add    %rdx,%rax
  801763:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801766:	83 c2 08             	add    $0x8,%edx
  801769:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80176c:	eb 0f                	jmp    80177d <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  80176e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801772:	48 89 d0             	mov    %rdx,%rax
  801775:	48 83 c2 08          	add    $0x8,%rdx
  801779:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80177d:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801780:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801784:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80178b:	eb 23                	jmp    8017b0 <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80178d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801791:	be 03 00 00 00       	mov    $0x3,%esi
  801796:	48 89 c7             	mov    %rax,%rdi
  801799:	48 b8 f4 10 80 00 00 	movabs $0x8010f4,%rax
  8017a0:	00 00 00 
  8017a3:	ff d0                	callq  *%rax
  8017a5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8017a9:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8017b0:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8017b5:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8017b8:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8017bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017bf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8017c3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8017c7:	45 89 c1             	mov    %r8d,%r9d
  8017ca:	41 89 f8             	mov    %edi,%r8d
  8017cd:	48 89 c7             	mov    %rax,%rdi
  8017d0:	48 b8 39 10 80 00 00 	movabs $0x801039,%rax
  8017d7:	00 00 00 
  8017da:	ff d0                	callq  *%rax
			break;
  8017dc:	eb 3f                	jmp    80181d <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8017de:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8017e2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8017e6:	48 89 d6             	mov    %rdx,%rsi
  8017e9:	89 df                	mov    %ebx,%edi
  8017eb:	ff d0                	callq  *%rax
			break;
  8017ed:	eb 2e                	jmp    80181d <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8017ef:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8017f3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8017f7:	48 89 d6             	mov    %rdx,%rsi
  8017fa:	bf 25 00 00 00       	mov    $0x25,%edi
  8017ff:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801801:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801806:	eb 05                	jmp    80180d <vprintfmt+0x4f9>
  801808:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80180d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801811:	48 83 e8 01          	sub    $0x1,%rax
  801815:	0f b6 00             	movzbl (%rax),%eax
  801818:	3c 25                	cmp    $0x25,%al
  80181a:	75 ec                	jne    801808 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  80181c:	90                   	nop
		}
	}
  80181d:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80181e:	e9 43 fb ff ff       	jmpq   801366 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  801823:	48 83 c4 60          	add    $0x60,%rsp
  801827:	5b                   	pop    %rbx
  801828:	41 5c                	pop    %r12
  80182a:	5d                   	pop    %rbp
  80182b:	c3                   	retq   

000000000080182c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80182c:	55                   	push   %rbp
  80182d:	48 89 e5             	mov    %rsp,%rbp
  801830:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801837:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80183e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801845:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80184c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801853:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80185a:	84 c0                	test   %al,%al
  80185c:	74 20                	je     80187e <printfmt+0x52>
  80185e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801862:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801866:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80186a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80186e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801872:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801876:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80187a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80187e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801885:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80188c:	00 00 00 
  80188f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801896:	00 00 00 
  801899:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80189d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8018a4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8018ab:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8018b2:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8018b9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8018c0:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8018c7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8018ce:	48 89 c7             	mov    %rax,%rdi
  8018d1:	48 b8 14 13 80 00 00 	movabs $0x801314,%rax
  8018d8:	00 00 00 
  8018db:	ff d0                	callq  *%rax
	va_end(ap);
}
  8018dd:	c9                   	leaveq 
  8018de:	c3                   	retq   

00000000008018df <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8018df:	55                   	push   %rbp
  8018e0:	48 89 e5             	mov    %rsp,%rbp
  8018e3:	48 83 ec 10          	sub    $0x10,%rsp
  8018e7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8018ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018f2:	8b 40 10             	mov    0x10(%rax),%eax
  8018f5:	8d 50 01             	lea    0x1(%rax),%edx
  8018f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018fc:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8018ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801903:	48 8b 10             	mov    (%rax),%rdx
  801906:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80190a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80190e:	48 39 c2             	cmp    %rax,%rdx
  801911:	73 17                	jae    80192a <sprintputch+0x4b>
		*b->buf++ = ch;
  801913:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801917:	48 8b 00             	mov    (%rax),%rax
  80191a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80191e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801922:	48 89 0a             	mov    %rcx,(%rdx)
  801925:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801928:	88 10                	mov    %dl,(%rax)
}
  80192a:	c9                   	leaveq 
  80192b:	c3                   	retq   

000000000080192c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80192c:	55                   	push   %rbp
  80192d:	48 89 e5             	mov    %rsp,%rbp
  801930:	48 83 ec 50          	sub    $0x50,%rsp
  801934:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801938:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80193b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80193f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801943:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801947:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80194b:	48 8b 0a             	mov    (%rdx),%rcx
  80194e:	48 89 08             	mov    %rcx,(%rax)
  801951:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801955:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801959:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80195d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801961:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801965:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801969:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80196c:	48 98                	cltq   
  80196e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801972:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801976:	48 01 d0             	add    %rdx,%rax
  801979:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80197d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801984:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801989:	74 06                	je     801991 <vsnprintf+0x65>
  80198b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80198f:	7f 07                	jg     801998 <vsnprintf+0x6c>
		return -E_INVAL;
  801991:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801996:	eb 2f                	jmp    8019c7 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801998:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80199c:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8019a0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8019a4:	48 89 c6             	mov    %rax,%rsi
  8019a7:	48 bf df 18 80 00 00 	movabs $0x8018df,%rdi
  8019ae:	00 00 00 
  8019b1:	48 b8 14 13 80 00 00 	movabs $0x801314,%rax
  8019b8:	00 00 00 
  8019bb:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8019bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019c1:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8019c4:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8019c7:	c9                   	leaveq 
  8019c8:	c3                   	retq   

00000000008019c9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8019c9:	55                   	push   %rbp
  8019ca:	48 89 e5             	mov    %rsp,%rbp
  8019cd:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8019d4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8019db:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8019e1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8019e8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8019ef:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8019f6:	84 c0                	test   %al,%al
  8019f8:	74 20                	je     801a1a <snprintf+0x51>
  8019fa:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8019fe:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801a02:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801a06:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801a0a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801a0e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801a12:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801a16:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801a1a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801a21:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801a28:	00 00 00 
  801a2b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801a32:	00 00 00 
  801a35:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801a39:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801a40:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801a47:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801a4e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801a55:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801a5c:	48 8b 0a             	mov    (%rdx),%rcx
  801a5f:	48 89 08             	mov    %rcx,(%rax)
  801a62:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801a66:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801a6a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801a6e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801a72:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801a79:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801a80:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801a86:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801a8d:	48 89 c7             	mov    %rax,%rdi
  801a90:	48 b8 2c 19 80 00 00 	movabs $0x80192c,%rax
  801a97:	00 00 00 
  801a9a:	ff d0                	callq  *%rax
  801a9c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801aa2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801aa8:	c9                   	leaveq 
  801aa9:	c3                   	retq   

0000000000801aaa <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801aaa:	55                   	push   %rbp
  801aab:	48 89 e5             	mov    %rsp,%rbp
  801aae:	48 83 ec 18          	sub    $0x18,%rsp
  801ab2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801ab6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801abd:	eb 09                	jmp    801ac8 <strlen+0x1e>
		n++;
  801abf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801ac3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801ac8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801acc:	0f b6 00             	movzbl (%rax),%eax
  801acf:	84 c0                	test   %al,%al
  801ad1:	75 ec                	jne    801abf <strlen+0x15>
		n++;
	return n;
  801ad3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ad6:	c9                   	leaveq 
  801ad7:	c3                   	retq   

0000000000801ad8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801ad8:	55                   	push   %rbp
  801ad9:	48 89 e5             	mov    %rsp,%rbp
  801adc:	48 83 ec 20          	sub    $0x20,%rsp
  801ae0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ae4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801ae8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801aef:	eb 0e                	jmp    801aff <strnlen+0x27>
		n++;
  801af1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801af5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801afa:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801aff:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801b04:	74 0b                	je     801b11 <strnlen+0x39>
  801b06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b0a:	0f b6 00             	movzbl (%rax),%eax
  801b0d:	84 c0                	test   %al,%al
  801b0f:	75 e0                	jne    801af1 <strnlen+0x19>
		n++;
	return n;
  801b11:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801b14:	c9                   	leaveq 
  801b15:	c3                   	retq   

0000000000801b16 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b16:	55                   	push   %rbp
  801b17:	48 89 e5             	mov    %rsp,%rbp
  801b1a:	48 83 ec 20          	sub    $0x20,%rsp
  801b1e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b22:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801b26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b2a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801b2e:	90                   	nop
  801b2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b33:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b37:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b3b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801b3f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801b43:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801b47:	0f b6 12             	movzbl (%rdx),%edx
  801b4a:	88 10                	mov    %dl,(%rax)
  801b4c:	0f b6 00             	movzbl (%rax),%eax
  801b4f:	84 c0                	test   %al,%al
  801b51:	75 dc                	jne    801b2f <strcpy+0x19>
		/* do nothing */;
	return ret;
  801b53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b57:	c9                   	leaveq 
  801b58:	c3                   	retq   

0000000000801b59 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801b59:	55                   	push   %rbp
  801b5a:	48 89 e5             	mov    %rsp,%rbp
  801b5d:	48 83 ec 20          	sub    $0x20,%rsp
  801b61:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b65:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801b69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b6d:	48 89 c7             	mov    %rax,%rdi
  801b70:	48 b8 aa 1a 80 00 00 	movabs $0x801aaa,%rax
  801b77:	00 00 00 
  801b7a:	ff d0                	callq  *%rax
  801b7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801b7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b82:	48 63 d0             	movslq %eax,%rdx
  801b85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b89:	48 01 c2             	add    %rax,%rdx
  801b8c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b90:	48 89 c6             	mov    %rax,%rsi
  801b93:	48 89 d7             	mov    %rdx,%rdi
  801b96:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  801b9d:	00 00 00 
  801ba0:	ff d0                	callq  *%rax
	return dst;
  801ba2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801ba6:	c9                   	leaveq 
  801ba7:	c3                   	retq   

0000000000801ba8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801ba8:	55                   	push   %rbp
  801ba9:	48 89 e5             	mov    %rsp,%rbp
  801bac:	48 83 ec 28          	sub    $0x28,%rsp
  801bb0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bb4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801bb8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801bbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bc0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801bc4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801bcb:	00 
  801bcc:	eb 2a                	jmp    801bf8 <strncpy+0x50>
		*dst++ = *src;
  801bce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bd2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801bd6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bda:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801bde:	0f b6 12             	movzbl (%rdx),%edx
  801be1:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801be3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801be7:	0f b6 00             	movzbl (%rax),%eax
  801bea:	84 c0                	test   %al,%al
  801bec:	74 05                	je     801bf3 <strncpy+0x4b>
			src++;
  801bee:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801bf3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801bf8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bfc:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801c00:	72 cc                	jb     801bce <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801c02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801c06:	c9                   	leaveq 
  801c07:	c3                   	retq   

0000000000801c08 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801c08:	55                   	push   %rbp
  801c09:	48 89 e5             	mov    %rsp,%rbp
  801c0c:	48 83 ec 28          	sub    $0x28,%rsp
  801c10:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c14:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c18:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801c1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c20:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801c24:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801c29:	74 3d                	je     801c68 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801c2b:	eb 1d                	jmp    801c4a <strlcpy+0x42>
			*dst++ = *src++;
  801c2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c31:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c35:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c39:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801c3d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801c41:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801c45:	0f b6 12             	movzbl (%rdx),%edx
  801c48:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801c4a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801c4f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801c54:	74 0b                	je     801c61 <strlcpy+0x59>
  801c56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c5a:	0f b6 00             	movzbl (%rax),%eax
  801c5d:	84 c0                	test   %al,%al
  801c5f:	75 cc                	jne    801c2d <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801c61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c65:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801c68:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c70:	48 29 c2             	sub    %rax,%rdx
  801c73:	48 89 d0             	mov    %rdx,%rax
}
  801c76:	c9                   	leaveq 
  801c77:	c3                   	retq   

0000000000801c78 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c78:	55                   	push   %rbp
  801c79:	48 89 e5             	mov    %rsp,%rbp
  801c7c:	48 83 ec 10          	sub    $0x10,%rsp
  801c80:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c84:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801c88:	eb 0a                	jmp    801c94 <strcmp+0x1c>
		p++, q++;
  801c8a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c8f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801c94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c98:	0f b6 00             	movzbl (%rax),%eax
  801c9b:	84 c0                	test   %al,%al
  801c9d:	74 12                	je     801cb1 <strcmp+0x39>
  801c9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ca3:	0f b6 10             	movzbl (%rax),%edx
  801ca6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801caa:	0f b6 00             	movzbl (%rax),%eax
  801cad:	38 c2                	cmp    %al,%dl
  801caf:	74 d9                	je     801c8a <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801cb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb5:	0f b6 00             	movzbl (%rax),%eax
  801cb8:	0f b6 d0             	movzbl %al,%edx
  801cbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cbf:	0f b6 00             	movzbl (%rax),%eax
  801cc2:	0f b6 c0             	movzbl %al,%eax
  801cc5:	29 c2                	sub    %eax,%edx
  801cc7:	89 d0                	mov    %edx,%eax
}
  801cc9:	c9                   	leaveq 
  801cca:	c3                   	retq   

0000000000801ccb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801ccb:	55                   	push   %rbp
  801ccc:	48 89 e5             	mov    %rsp,%rbp
  801ccf:	48 83 ec 18          	sub    $0x18,%rsp
  801cd3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cd7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cdb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801cdf:	eb 0f                	jmp    801cf0 <strncmp+0x25>
		n--, p++, q++;
  801ce1:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801ce6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801ceb:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801cf0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801cf5:	74 1d                	je     801d14 <strncmp+0x49>
  801cf7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cfb:	0f b6 00             	movzbl (%rax),%eax
  801cfe:	84 c0                	test   %al,%al
  801d00:	74 12                	je     801d14 <strncmp+0x49>
  801d02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d06:	0f b6 10             	movzbl (%rax),%edx
  801d09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d0d:	0f b6 00             	movzbl (%rax),%eax
  801d10:	38 c2                	cmp    %al,%dl
  801d12:	74 cd                	je     801ce1 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801d14:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801d19:	75 07                	jne    801d22 <strncmp+0x57>
		return 0;
  801d1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d20:	eb 18                	jmp    801d3a <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d26:	0f b6 00             	movzbl (%rax),%eax
  801d29:	0f b6 d0             	movzbl %al,%edx
  801d2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d30:	0f b6 00             	movzbl (%rax),%eax
  801d33:	0f b6 c0             	movzbl %al,%eax
  801d36:	29 c2                	sub    %eax,%edx
  801d38:	89 d0                	mov    %edx,%eax
}
  801d3a:	c9                   	leaveq 
  801d3b:	c3                   	retq   

0000000000801d3c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d3c:	55                   	push   %rbp
  801d3d:	48 89 e5             	mov    %rsp,%rbp
  801d40:	48 83 ec 0c          	sub    $0xc,%rsp
  801d44:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d48:	89 f0                	mov    %esi,%eax
  801d4a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801d4d:	eb 17                	jmp    801d66 <strchr+0x2a>
		if (*s == c)
  801d4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d53:	0f b6 00             	movzbl (%rax),%eax
  801d56:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801d59:	75 06                	jne    801d61 <strchr+0x25>
			return (char *) s;
  801d5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d5f:	eb 15                	jmp    801d76 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801d61:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d6a:	0f b6 00             	movzbl (%rax),%eax
  801d6d:	84 c0                	test   %al,%al
  801d6f:	75 de                	jne    801d4f <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801d71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d76:	c9                   	leaveq 
  801d77:	c3                   	retq   

0000000000801d78 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801d78:	55                   	push   %rbp
  801d79:	48 89 e5             	mov    %rsp,%rbp
  801d7c:	48 83 ec 0c          	sub    $0xc,%rsp
  801d80:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d84:	89 f0                	mov    %esi,%eax
  801d86:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801d89:	eb 13                	jmp    801d9e <strfind+0x26>
		if (*s == c)
  801d8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d8f:	0f b6 00             	movzbl (%rax),%eax
  801d92:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801d95:	75 02                	jne    801d99 <strfind+0x21>
			break;
  801d97:	eb 10                	jmp    801da9 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801d99:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801da2:	0f b6 00             	movzbl (%rax),%eax
  801da5:	84 c0                	test   %al,%al
  801da7:	75 e2                	jne    801d8b <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801da9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801dad:	c9                   	leaveq 
  801dae:	c3                   	retq   

0000000000801daf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801daf:	55                   	push   %rbp
  801db0:	48 89 e5             	mov    %rsp,%rbp
  801db3:	48 83 ec 18          	sub    $0x18,%rsp
  801db7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dbb:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801dbe:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801dc2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801dc7:	75 06                	jne    801dcf <memset+0x20>
		return v;
  801dc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dcd:	eb 69                	jmp    801e38 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801dcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dd3:	83 e0 03             	and    $0x3,%eax
  801dd6:	48 85 c0             	test   %rax,%rax
  801dd9:	75 48                	jne    801e23 <memset+0x74>
  801ddb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ddf:	83 e0 03             	and    $0x3,%eax
  801de2:	48 85 c0             	test   %rax,%rax
  801de5:	75 3c                	jne    801e23 <memset+0x74>
		c &= 0xFF;
  801de7:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801dee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801df1:	c1 e0 18             	shl    $0x18,%eax
  801df4:	89 c2                	mov    %eax,%edx
  801df6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801df9:	c1 e0 10             	shl    $0x10,%eax
  801dfc:	09 c2                	or     %eax,%edx
  801dfe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e01:	c1 e0 08             	shl    $0x8,%eax
  801e04:	09 d0                	or     %edx,%eax
  801e06:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801e09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e0d:	48 c1 e8 02          	shr    $0x2,%rax
  801e11:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801e14:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e18:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e1b:	48 89 d7             	mov    %rdx,%rdi
  801e1e:	fc                   	cld    
  801e1f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801e21:	eb 11                	jmp    801e34 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801e23:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e27:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e2a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e2e:	48 89 d7             	mov    %rdx,%rdi
  801e31:	fc                   	cld    
  801e32:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801e34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801e38:	c9                   	leaveq 
  801e39:	c3                   	retq   

0000000000801e3a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801e3a:	55                   	push   %rbp
  801e3b:	48 89 e5             	mov    %rsp,%rbp
  801e3e:	48 83 ec 28          	sub    $0x28,%rsp
  801e42:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801e46:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801e4a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801e4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e52:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801e56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e5a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801e5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e62:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801e66:	0f 83 88 00 00 00    	jae    801ef4 <memmove+0xba>
  801e6c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e70:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e74:	48 01 d0             	add    %rdx,%rax
  801e77:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801e7b:	76 77                	jbe    801ef4 <memmove+0xba>
		s += n;
  801e7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e81:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801e85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e89:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801e8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e91:	83 e0 03             	and    $0x3,%eax
  801e94:	48 85 c0             	test   %rax,%rax
  801e97:	75 3b                	jne    801ed4 <memmove+0x9a>
  801e99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e9d:	83 e0 03             	and    $0x3,%eax
  801ea0:	48 85 c0             	test   %rax,%rax
  801ea3:	75 2f                	jne    801ed4 <memmove+0x9a>
  801ea5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea9:	83 e0 03             	and    $0x3,%eax
  801eac:	48 85 c0             	test   %rax,%rax
  801eaf:	75 23                	jne    801ed4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801eb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eb5:	48 83 e8 04          	sub    $0x4,%rax
  801eb9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ebd:	48 83 ea 04          	sub    $0x4,%rdx
  801ec1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801ec5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801ec9:	48 89 c7             	mov    %rax,%rdi
  801ecc:	48 89 d6             	mov    %rdx,%rsi
  801ecf:	fd                   	std    
  801ed0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801ed2:	eb 1d                	jmp    801ef1 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801ed4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ed8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801edc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ee0:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801ee4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee8:	48 89 d7             	mov    %rdx,%rdi
  801eeb:	48 89 c1             	mov    %rax,%rcx
  801eee:	fd                   	std    
  801eef:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801ef1:	fc                   	cld    
  801ef2:	eb 57                	jmp    801f4b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801ef4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ef8:	83 e0 03             	and    $0x3,%eax
  801efb:	48 85 c0             	test   %rax,%rax
  801efe:	75 36                	jne    801f36 <memmove+0xfc>
  801f00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f04:	83 e0 03             	and    $0x3,%eax
  801f07:	48 85 c0             	test   %rax,%rax
  801f0a:	75 2a                	jne    801f36 <memmove+0xfc>
  801f0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f10:	83 e0 03             	and    $0x3,%eax
  801f13:	48 85 c0             	test   %rax,%rax
  801f16:	75 1e                	jne    801f36 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801f18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f1c:	48 c1 e8 02          	shr    $0x2,%rax
  801f20:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801f23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f27:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f2b:	48 89 c7             	mov    %rax,%rdi
  801f2e:	48 89 d6             	mov    %rdx,%rsi
  801f31:	fc                   	cld    
  801f32:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801f34:	eb 15                	jmp    801f4b <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801f36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f3a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f3e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801f42:	48 89 c7             	mov    %rax,%rdi
  801f45:	48 89 d6             	mov    %rdx,%rsi
  801f48:	fc                   	cld    
  801f49:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801f4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801f4f:	c9                   	leaveq 
  801f50:	c3                   	retq   

0000000000801f51 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801f51:	55                   	push   %rbp
  801f52:	48 89 e5             	mov    %rsp,%rbp
  801f55:	48 83 ec 18          	sub    $0x18,%rsp
  801f59:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f5d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f61:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801f65:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f69:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f71:	48 89 ce             	mov    %rcx,%rsi
  801f74:	48 89 c7             	mov    %rax,%rdi
  801f77:	48 b8 3a 1e 80 00 00 	movabs $0x801e3a,%rax
  801f7e:	00 00 00 
  801f81:	ff d0                	callq  *%rax
}
  801f83:	c9                   	leaveq 
  801f84:	c3                   	retq   

0000000000801f85 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801f85:	55                   	push   %rbp
  801f86:	48 89 e5             	mov    %rsp,%rbp
  801f89:	48 83 ec 28          	sub    $0x28,%rsp
  801f8d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801f91:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801f95:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801f99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f9d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801fa1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fa5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801fa9:	eb 36                	jmp    801fe1 <memcmp+0x5c>
		if (*s1 != *s2)
  801fab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801faf:	0f b6 10             	movzbl (%rax),%edx
  801fb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fb6:	0f b6 00             	movzbl (%rax),%eax
  801fb9:	38 c2                	cmp    %al,%dl
  801fbb:	74 1a                	je     801fd7 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801fbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc1:	0f b6 00             	movzbl (%rax),%eax
  801fc4:	0f b6 d0             	movzbl %al,%edx
  801fc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fcb:	0f b6 00             	movzbl (%rax),%eax
  801fce:	0f b6 c0             	movzbl %al,%eax
  801fd1:	29 c2                	sub    %eax,%edx
  801fd3:	89 d0                	mov    %edx,%eax
  801fd5:	eb 20                	jmp    801ff7 <memcmp+0x72>
		s1++, s2++;
  801fd7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801fdc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801fe1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fe5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801fe9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801fed:	48 85 c0             	test   %rax,%rax
  801ff0:	75 b9                	jne    801fab <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801ff2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ff7:	c9                   	leaveq 
  801ff8:	c3                   	retq   

0000000000801ff9 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801ff9:	55                   	push   %rbp
  801ffa:	48 89 e5             	mov    %rsp,%rbp
  801ffd:	48 83 ec 28          	sub    $0x28,%rsp
  802001:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802005:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  802008:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80200c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802010:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802014:	48 01 d0             	add    %rdx,%rax
  802017:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80201b:	eb 15                	jmp    802032 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80201d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802021:	0f b6 10             	movzbl (%rax),%edx
  802024:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802027:	38 c2                	cmp    %al,%dl
  802029:	75 02                	jne    80202d <memfind+0x34>
			break;
  80202b:	eb 0f                	jmp    80203c <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80202d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802032:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802036:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80203a:	72 e1                	jb     80201d <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80203c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802040:	c9                   	leaveq 
  802041:	c3                   	retq   

0000000000802042 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802042:	55                   	push   %rbp
  802043:	48 89 e5             	mov    %rsp,%rbp
  802046:	48 83 ec 34          	sub    $0x34,%rsp
  80204a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80204e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802052:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  802055:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80205c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  802063:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802064:	eb 05                	jmp    80206b <strtol+0x29>
		s++;
  802066:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80206b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80206f:	0f b6 00             	movzbl (%rax),%eax
  802072:	3c 20                	cmp    $0x20,%al
  802074:	74 f0                	je     802066 <strtol+0x24>
  802076:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80207a:	0f b6 00             	movzbl (%rax),%eax
  80207d:	3c 09                	cmp    $0x9,%al
  80207f:	74 e5                	je     802066 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  802081:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802085:	0f b6 00             	movzbl (%rax),%eax
  802088:	3c 2b                	cmp    $0x2b,%al
  80208a:	75 07                	jne    802093 <strtol+0x51>
		s++;
  80208c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802091:	eb 17                	jmp    8020aa <strtol+0x68>
	else if (*s == '-')
  802093:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802097:	0f b6 00             	movzbl (%rax),%eax
  80209a:	3c 2d                	cmp    $0x2d,%al
  80209c:	75 0c                	jne    8020aa <strtol+0x68>
		s++, neg = 1;
  80209e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8020a3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8020aa:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8020ae:	74 06                	je     8020b6 <strtol+0x74>
  8020b0:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8020b4:	75 28                	jne    8020de <strtol+0x9c>
  8020b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020ba:	0f b6 00             	movzbl (%rax),%eax
  8020bd:	3c 30                	cmp    $0x30,%al
  8020bf:	75 1d                	jne    8020de <strtol+0x9c>
  8020c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020c5:	48 83 c0 01          	add    $0x1,%rax
  8020c9:	0f b6 00             	movzbl (%rax),%eax
  8020cc:	3c 78                	cmp    $0x78,%al
  8020ce:	75 0e                	jne    8020de <strtol+0x9c>
		s += 2, base = 16;
  8020d0:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8020d5:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8020dc:	eb 2c                	jmp    80210a <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8020de:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8020e2:	75 19                	jne    8020fd <strtol+0xbb>
  8020e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020e8:	0f b6 00             	movzbl (%rax),%eax
  8020eb:	3c 30                	cmp    $0x30,%al
  8020ed:	75 0e                	jne    8020fd <strtol+0xbb>
		s++, base = 8;
  8020ef:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8020f4:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8020fb:	eb 0d                	jmp    80210a <strtol+0xc8>
	else if (base == 0)
  8020fd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802101:	75 07                	jne    80210a <strtol+0xc8>
		base = 10;
  802103:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80210a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80210e:	0f b6 00             	movzbl (%rax),%eax
  802111:	3c 2f                	cmp    $0x2f,%al
  802113:	7e 1d                	jle    802132 <strtol+0xf0>
  802115:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802119:	0f b6 00             	movzbl (%rax),%eax
  80211c:	3c 39                	cmp    $0x39,%al
  80211e:	7f 12                	jg     802132 <strtol+0xf0>
			dig = *s - '0';
  802120:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802124:	0f b6 00             	movzbl (%rax),%eax
  802127:	0f be c0             	movsbl %al,%eax
  80212a:	83 e8 30             	sub    $0x30,%eax
  80212d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802130:	eb 4e                	jmp    802180 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  802132:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802136:	0f b6 00             	movzbl (%rax),%eax
  802139:	3c 60                	cmp    $0x60,%al
  80213b:	7e 1d                	jle    80215a <strtol+0x118>
  80213d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802141:	0f b6 00             	movzbl (%rax),%eax
  802144:	3c 7a                	cmp    $0x7a,%al
  802146:	7f 12                	jg     80215a <strtol+0x118>
			dig = *s - 'a' + 10;
  802148:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80214c:	0f b6 00             	movzbl (%rax),%eax
  80214f:	0f be c0             	movsbl %al,%eax
  802152:	83 e8 57             	sub    $0x57,%eax
  802155:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802158:	eb 26                	jmp    802180 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80215a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80215e:	0f b6 00             	movzbl (%rax),%eax
  802161:	3c 40                	cmp    $0x40,%al
  802163:	7e 48                	jle    8021ad <strtol+0x16b>
  802165:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802169:	0f b6 00             	movzbl (%rax),%eax
  80216c:	3c 5a                	cmp    $0x5a,%al
  80216e:	7f 3d                	jg     8021ad <strtol+0x16b>
			dig = *s - 'A' + 10;
  802170:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802174:	0f b6 00             	movzbl (%rax),%eax
  802177:	0f be c0             	movsbl %al,%eax
  80217a:	83 e8 37             	sub    $0x37,%eax
  80217d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  802180:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802183:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  802186:	7c 02                	jl     80218a <strtol+0x148>
			break;
  802188:	eb 23                	jmp    8021ad <strtol+0x16b>
		s++, val = (val * base) + dig;
  80218a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80218f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802192:	48 98                	cltq   
  802194:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  802199:	48 89 c2             	mov    %rax,%rdx
  80219c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80219f:	48 98                	cltq   
  8021a1:	48 01 d0             	add    %rdx,%rax
  8021a4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8021a8:	e9 5d ff ff ff       	jmpq   80210a <strtol+0xc8>

	if (endptr)
  8021ad:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8021b2:	74 0b                	je     8021bf <strtol+0x17d>
		*endptr = (char *) s;
  8021b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021b8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8021bc:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8021bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021c3:	74 09                	je     8021ce <strtol+0x18c>
  8021c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021c9:	48 f7 d8             	neg    %rax
  8021cc:	eb 04                	jmp    8021d2 <strtol+0x190>
  8021ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8021d2:	c9                   	leaveq 
  8021d3:	c3                   	retq   

00000000008021d4 <strstr>:

char * strstr(const char *in, const char *str)
{
  8021d4:	55                   	push   %rbp
  8021d5:	48 89 e5             	mov    %rsp,%rbp
  8021d8:	48 83 ec 30          	sub    $0x30,%rsp
  8021dc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8021e0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8021e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021e8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8021ec:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8021f0:	0f b6 00             	movzbl (%rax),%eax
  8021f3:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8021f6:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8021fa:	75 06                	jne    802202 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8021fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802200:	eb 6b                	jmp    80226d <strstr+0x99>

    len = strlen(str);
  802202:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802206:	48 89 c7             	mov    %rax,%rdi
  802209:	48 b8 aa 1a 80 00 00 	movabs $0x801aaa,%rax
  802210:	00 00 00 
  802213:	ff d0                	callq  *%rax
  802215:	48 98                	cltq   
  802217:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80221b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80221f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802223:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802227:	0f b6 00             	movzbl (%rax),%eax
  80222a:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  80222d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  802231:	75 07                	jne    80223a <strstr+0x66>
                return (char *) 0;
  802233:	b8 00 00 00 00       	mov    $0x0,%eax
  802238:	eb 33                	jmp    80226d <strstr+0x99>
        } while (sc != c);
  80223a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80223e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  802241:	75 d8                	jne    80221b <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  802243:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802247:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80224b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80224f:	48 89 ce             	mov    %rcx,%rsi
  802252:	48 89 c7             	mov    %rax,%rdi
  802255:	48 b8 cb 1c 80 00 00 	movabs $0x801ccb,%rax
  80225c:	00 00 00 
  80225f:	ff d0                	callq  *%rax
  802261:	85 c0                	test   %eax,%eax
  802263:	75 b6                	jne    80221b <strstr+0x47>

    return (char *) (in - 1);
  802265:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802269:	48 83 e8 01          	sub    $0x1,%rax
}
  80226d:	c9                   	leaveq 
  80226e:	c3                   	retq   

000000000080226f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80226f:	55                   	push   %rbp
  802270:	48 89 e5             	mov    %rsp,%rbp
  802273:	53                   	push   %rbx
  802274:	48 83 ec 48          	sub    $0x48,%rsp
  802278:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80227b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80227e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802282:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802286:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80228a:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80228e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802291:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802295:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  802299:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80229d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8022a1:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8022a5:	4c 89 c3             	mov    %r8,%rbx
  8022a8:	cd 30                	int    $0x30
  8022aa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8022ae:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8022b2:	74 3e                	je     8022f2 <syscall+0x83>
  8022b4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8022b9:	7e 37                	jle    8022f2 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8022bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022bf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022c2:	49 89 d0             	mov    %rdx,%r8
  8022c5:	89 c1                	mov    %eax,%ecx
  8022c7:	48 ba 00 49 80 00 00 	movabs $0x804900,%rdx
  8022ce:	00 00 00 
  8022d1:	be 23 00 00 00       	mov    $0x23,%esi
  8022d6:	48 bf 1d 49 80 00 00 	movabs $0x80491d,%rdi
  8022dd:	00 00 00 
  8022e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e5:	49 b9 28 0d 80 00 00 	movabs $0x800d28,%r9
  8022ec:	00 00 00 
  8022ef:	41 ff d1             	callq  *%r9

	return ret;
  8022f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8022f6:	48 83 c4 48          	add    $0x48,%rsp
  8022fa:	5b                   	pop    %rbx
  8022fb:	5d                   	pop    %rbp
  8022fc:	c3                   	retq   

00000000008022fd <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8022fd:	55                   	push   %rbp
  8022fe:	48 89 e5             	mov    %rsp,%rbp
  802301:	48 83 ec 20          	sub    $0x20,%rsp
  802305:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802309:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80230d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802311:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802315:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80231c:	00 
  80231d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802323:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802329:	48 89 d1             	mov    %rdx,%rcx
  80232c:	48 89 c2             	mov    %rax,%rdx
  80232f:	be 00 00 00 00       	mov    $0x0,%esi
  802334:	bf 00 00 00 00       	mov    $0x0,%edi
  802339:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  802340:	00 00 00 
  802343:	ff d0                	callq  *%rax
}
  802345:	c9                   	leaveq 
  802346:	c3                   	retq   

0000000000802347 <sys_cgetc>:

int
sys_cgetc(void)
{
  802347:	55                   	push   %rbp
  802348:	48 89 e5             	mov    %rsp,%rbp
  80234b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80234f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802356:	00 
  802357:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80235d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802363:	b9 00 00 00 00       	mov    $0x0,%ecx
  802368:	ba 00 00 00 00       	mov    $0x0,%edx
  80236d:	be 00 00 00 00       	mov    $0x0,%esi
  802372:	bf 01 00 00 00       	mov    $0x1,%edi
  802377:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  80237e:	00 00 00 
  802381:	ff d0                	callq  *%rax
}
  802383:	c9                   	leaveq 
  802384:	c3                   	retq   

0000000000802385 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802385:	55                   	push   %rbp
  802386:	48 89 e5             	mov    %rsp,%rbp
  802389:	48 83 ec 10          	sub    $0x10,%rsp
  80238d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802390:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802393:	48 98                	cltq   
  802395:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80239c:	00 
  80239d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023a3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023a9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023ae:	48 89 c2             	mov    %rax,%rdx
  8023b1:	be 01 00 00 00       	mov    $0x1,%esi
  8023b6:	bf 03 00 00 00       	mov    $0x3,%edi
  8023bb:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  8023c2:	00 00 00 
  8023c5:	ff d0                	callq  *%rax
}
  8023c7:	c9                   	leaveq 
  8023c8:	c3                   	retq   

00000000008023c9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8023c9:	55                   	push   %rbp
  8023ca:	48 89 e5             	mov    %rsp,%rbp
  8023cd:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8023d1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023d8:	00 
  8023d9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023df:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8023ef:	be 00 00 00 00       	mov    $0x0,%esi
  8023f4:	bf 02 00 00 00       	mov    $0x2,%edi
  8023f9:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  802400:	00 00 00 
  802403:	ff d0                	callq  *%rax
}
  802405:	c9                   	leaveq 
  802406:	c3                   	retq   

0000000000802407 <sys_yield>:

void
sys_yield(void)
{
  802407:	55                   	push   %rbp
  802408:	48 89 e5             	mov    %rsp,%rbp
  80240b:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80240f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802416:	00 
  802417:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80241d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802423:	b9 00 00 00 00       	mov    $0x0,%ecx
  802428:	ba 00 00 00 00       	mov    $0x0,%edx
  80242d:	be 00 00 00 00       	mov    $0x0,%esi
  802432:	bf 0b 00 00 00       	mov    $0xb,%edi
  802437:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  80243e:	00 00 00 
  802441:	ff d0                	callq  *%rax
}
  802443:	c9                   	leaveq 
  802444:	c3                   	retq   

0000000000802445 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802445:	55                   	push   %rbp
  802446:	48 89 e5             	mov    %rsp,%rbp
  802449:	48 83 ec 20          	sub    $0x20,%rsp
  80244d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802450:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802454:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802457:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80245a:	48 63 c8             	movslq %eax,%rcx
  80245d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802461:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802464:	48 98                	cltq   
  802466:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80246d:	00 
  80246e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802474:	49 89 c8             	mov    %rcx,%r8
  802477:	48 89 d1             	mov    %rdx,%rcx
  80247a:	48 89 c2             	mov    %rax,%rdx
  80247d:	be 01 00 00 00       	mov    $0x1,%esi
  802482:	bf 04 00 00 00       	mov    $0x4,%edi
  802487:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  80248e:	00 00 00 
  802491:	ff d0                	callq  *%rax
}
  802493:	c9                   	leaveq 
  802494:	c3                   	retq   

0000000000802495 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802495:	55                   	push   %rbp
  802496:	48 89 e5             	mov    %rsp,%rbp
  802499:	48 83 ec 30          	sub    $0x30,%rsp
  80249d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8024a4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8024a7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8024ab:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8024af:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8024b2:	48 63 c8             	movslq %eax,%rcx
  8024b5:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8024b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024bc:	48 63 f0             	movslq %eax,%rsi
  8024bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024c6:	48 98                	cltq   
  8024c8:	48 89 0c 24          	mov    %rcx,(%rsp)
  8024cc:	49 89 f9             	mov    %rdi,%r9
  8024cf:	49 89 f0             	mov    %rsi,%r8
  8024d2:	48 89 d1             	mov    %rdx,%rcx
  8024d5:	48 89 c2             	mov    %rax,%rdx
  8024d8:	be 01 00 00 00       	mov    $0x1,%esi
  8024dd:	bf 05 00 00 00       	mov    $0x5,%edi
  8024e2:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  8024e9:	00 00 00 
  8024ec:	ff d0                	callq  *%rax
}
  8024ee:	c9                   	leaveq 
  8024ef:	c3                   	retq   

00000000008024f0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8024f0:	55                   	push   %rbp
  8024f1:	48 89 e5             	mov    %rsp,%rbp
  8024f4:	48 83 ec 20          	sub    $0x20,%rsp
  8024f8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024fb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8024ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802503:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802506:	48 98                	cltq   
  802508:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80250f:	00 
  802510:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802516:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80251c:	48 89 d1             	mov    %rdx,%rcx
  80251f:	48 89 c2             	mov    %rax,%rdx
  802522:	be 01 00 00 00       	mov    $0x1,%esi
  802527:	bf 06 00 00 00       	mov    $0x6,%edi
  80252c:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  802533:	00 00 00 
  802536:	ff d0                	callq  *%rax
}
  802538:	c9                   	leaveq 
  802539:	c3                   	retq   

000000000080253a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80253a:	55                   	push   %rbp
  80253b:	48 89 e5             	mov    %rsp,%rbp
  80253e:	48 83 ec 10          	sub    $0x10,%rsp
  802542:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802545:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802548:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80254b:	48 63 d0             	movslq %eax,%rdx
  80254e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802551:	48 98                	cltq   
  802553:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80255a:	00 
  80255b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802561:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802567:	48 89 d1             	mov    %rdx,%rcx
  80256a:	48 89 c2             	mov    %rax,%rdx
  80256d:	be 01 00 00 00       	mov    $0x1,%esi
  802572:	bf 08 00 00 00       	mov    $0x8,%edi
  802577:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  80257e:	00 00 00 
  802581:	ff d0                	callq  *%rax
}
  802583:	c9                   	leaveq 
  802584:	c3                   	retq   

0000000000802585 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802585:	55                   	push   %rbp
  802586:	48 89 e5             	mov    %rsp,%rbp
  802589:	48 83 ec 20          	sub    $0x20,%rsp
  80258d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802590:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802594:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802598:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80259b:	48 98                	cltq   
  80259d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8025a4:	00 
  8025a5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8025ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8025b1:	48 89 d1             	mov    %rdx,%rcx
  8025b4:	48 89 c2             	mov    %rax,%rdx
  8025b7:	be 01 00 00 00       	mov    $0x1,%esi
  8025bc:	bf 09 00 00 00       	mov    $0x9,%edi
  8025c1:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  8025c8:	00 00 00 
  8025cb:	ff d0                	callq  *%rax
}
  8025cd:	c9                   	leaveq 
  8025ce:	c3                   	retq   

00000000008025cf <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8025cf:	55                   	push   %rbp
  8025d0:	48 89 e5             	mov    %rsp,%rbp
  8025d3:	48 83 ec 20          	sub    $0x20,%rsp
  8025d7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8025de:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e5:	48 98                	cltq   
  8025e7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8025ee:	00 
  8025ef:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8025f5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8025fb:	48 89 d1             	mov    %rdx,%rcx
  8025fe:	48 89 c2             	mov    %rax,%rdx
  802601:	be 01 00 00 00       	mov    $0x1,%esi
  802606:	bf 0a 00 00 00       	mov    $0xa,%edi
  80260b:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  802612:	00 00 00 
  802615:	ff d0                	callq  *%rax
}
  802617:	c9                   	leaveq 
  802618:	c3                   	retq   

0000000000802619 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802619:	55                   	push   %rbp
  80261a:	48 89 e5             	mov    %rsp,%rbp
  80261d:	48 83 ec 20          	sub    $0x20,%rsp
  802621:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802624:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802628:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80262c:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80262f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802632:	48 63 f0             	movslq %eax,%rsi
  802635:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802639:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80263c:	48 98                	cltq   
  80263e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802642:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802649:	00 
  80264a:	49 89 f1             	mov    %rsi,%r9
  80264d:	49 89 c8             	mov    %rcx,%r8
  802650:	48 89 d1             	mov    %rdx,%rcx
  802653:	48 89 c2             	mov    %rax,%rdx
  802656:	be 00 00 00 00       	mov    $0x0,%esi
  80265b:	bf 0c 00 00 00       	mov    $0xc,%edi
  802660:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  802667:	00 00 00 
  80266a:	ff d0                	callq  *%rax
}
  80266c:	c9                   	leaveq 
  80266d:	c3                   	retq   

000000000080266e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80266e:	55                   	push   %rbp
  80266f:	48 89 e5             	mov    %rsp,%rbp
  802672:	48 83 ec 10          	sub    $0x10,%rsp
  802676:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80267a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80267e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802685:	00 
  802686:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80268c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802692:	b9 00 00 00 00       	mov    $0x0,%ecx
  802697:	48 89 c2             	mov    %rax,%rdx
  80269a:	be 01 00 00 00       	mov    $0x1,%esi
  80269f:	bf 0d 00 00 00       	mov    $0xd,%edi
  8026a4:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  8026ab:	00 00 00 
  8026ae:	ff d0                	callq  *%rax
}
  8026b0:	c9                   	leaveq 
  8026b1:	c3                   	retq   

00000000008026b2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8026b2:	55                   	push   %rbp
  8026b3:	48 89 e5             	mov    %rsp,%rbp
  8026b6:	48 83 ec 30          	sub    $0x30,%rsp
  8026ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8026c6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8026cd:	00 00 00 
  8026d0:	48 8b 00             	mov    (%rax),%rax
  8026d3:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8026d9:	85 c0                	test   %eax,%eax
  8026db:	75 3c                	jne    802719 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8026dd:	48 b8 c9 23 80 00 00 	movabs $0x8023c9,%rax
  8026e4:	00 00 00 
  8026e7:	ff d0                	callq  *%rax
  8026e9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8026ee:	48 63 d0             	movslq %eax,%rdx
  8026f1:	48 89 d0             	mov    %rdx,%rax
  8026f4:	48 c1 e0 03          	shl    $0x3,%rax
  8026f8:	48 01 d0             	add    %rdx,%rax
  8026fb:	48 c1 e0 05          	shl    $0x5,%rax
  8026ff:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802706:	00 00 00 
  802709:	48 01 c2             	add    %rax,%rdx
  80270c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802713:	00 00 00 
  802716:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  802719:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80271e:	75 0e                	jne    80272e <ipc_recv+0x7c>
		pg = (void*) UTOP;
  802720:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802727:	00 00 00 
  80272a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  80272e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802732:	48 89 c7             	mov    %rax,%rdi
  802735:	48 b8 6e 26 80 00 00 	movabs $0x80266e,%rax
  80273c:	00 00 00 
  80273f:	ff d0                	callq  *%rax
  802741:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  802744:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802748:	79 19                	jns    802763 <ipc_recv+0xb1>
		*from_env_store = 0;
  80274a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80274e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  802754:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802758:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  80275e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802761:	eb 53                	jmp    8027b6 <ipc_recv+0x104>
	}
	if(from_env_store)
  802763:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802768:	74 19                	je     802783 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  80276a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802771:	00 00 00 
  802774:	48 8b 00             	mov    (%rax),%rax
  802777:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80277d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802781:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  802783:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802788:	74 19                	je     8027a3 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  80278a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802791:	00 00 00 
  802794:	48 8b 00             	mov    (%rax),%rax
  802797:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80279d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027a1:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8027a3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8027aa:	00 00 00 
  8027ad:	48 8b 00             	mov    (%rax),%rax
  8027b0:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8027b6:	c9                   	leaveq 
  8027b7:	c3                   	retq   

00000000008027b8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8027b8:	55                   	push   %rbp
  8027b9:	48 89 e5             	mov    %rsp,%rbp
  8027bc:	48 83 ec 30          	sub    $0x30,%rsp
  8027c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027c3:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8027c6:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8027ca:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8027cd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8027d2:	75 0e                	jne    8027e2 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8027d4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8027db:	00 00 00 
  8027de:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8027e2:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8027e5:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8027e8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027ef:	89 c7                	mov    %eax,%edi
  8027f1:	48 b8 19 26 80 00 00 	movabs $0x802619,%rax
  8027f8:	00 00 00 
  8027fb:	ff d0                	callq  *%rax
  8027fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  802800:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802804:	75 0c                	jne    802812 <ipc_send+0x5a>
			sys_yield();
  802806:	48 b8 07 24 80 00 00 	movabs $0x802407,%rax
  80280d:	00 00 00 
  802810:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  802812:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802816:	74 ca                	je     8027e2 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  802818:	c9                   	leaveq 
  802819:	c3                   	retq   

000000000080281a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80281a:	55                   	push   %rbp
  80281b:	48 89 e5             	mov    %rsp,%rbp
  80281e:	48 83 ec 14          	sub    $0x14,%rsp
  802822:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  802825:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80282c:	eb 5e                	jmp    80288c <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80282e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802835:	00 00 00 
  802838:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80283b:	48 63 d0             	movslq %eax,%rdx
  80283e:	48 89 d0             	mov    %rdx,%rax
  802841:	48 c1 e0 03          	shl    $0x3,%rax
  802845:	48 01 d0             	add    %rdx,%rax
  802848:	48 c1 e0 05          	shl    $0x5,%rax
  80284c:	48 01 c8             	add    %rcx,%rax
  80284f:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802855:	8b 00                	mov    (%rax),%eax
  802857:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80285a:	75 2c                	jne    802888 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80285c:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802863:	00 00 00 
  802866:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802869:	48 63 d0             	movslq %eax,%rdx
  80286c:	48 89 d0             	mov    %rdx,%rax
  80286f:	48 c1 e0 03          	shl    $0x3,%rax
  802873:	48 01 d0             	add    %rdx,%rax
  802876:	48 c1 e0 05          	shl    $0x5,%rax
  80287a:	48 01 c8             	add    %rcx,%rax
  80287d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802883:	8b 40 08             	mov    0x8(%rax),%eax
  802886:	eb 12                	jmp    80289a <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802888:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80288c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802893:	7e 99                	jle    80282e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802895:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80289a:	c9                   	leaveq 
  80289b:	c3                   	retq   

000000000080289c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80289c:	55                   	push   %rbp
  80289d:	48 89 e5             	mov    %rsp,%rbp
  8028a0:	48 83 ec 08          	sub    $0x8,%rsp
  8028a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8028a8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8028ac:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8028b3:	ff ff ff 
  8028b6:	48 01 d0             	add    %rdx,%rax
  8028b9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8028bd:	c9                   	leaveq 
  8028be:	c3                   	retq   

00000000008028bf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8028bf:	55                   	push   %rbp
  8028c0:	48 89 e5             	mov    %rsp,%rbp
  8028c3:	48 83 ec 08          	sub    $0x8,%rsp
  8028c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8028cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028cf:	48 89 c7             	mov    %rax,%rdi
  8028d2:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  8028d9:	00 00 00 
  8028dc:	ff d0                	callq  *%rax
  8028de:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8028e4:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8028e8:	c9                   	leaveq 
  8028e9:	c3                   	retq   

00000000008028ea <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8028ea:	55                   	push   %rbp
  8028eb:	48 89 e5             	mov    %rsp,%rbp
  8028ee:	48 83 ec 18          	sub    $0x18,%rsp
  8028f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8028f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028fd:	eb 6b                	jmp    80296a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8028ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802902:	48 98                	cltq   
  802904:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80290a:	48 c1 e0 0c          	shl    $0xc,%rax
  80290e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802912:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802916:	48 c1 e8 15          	shr    $0x15,%rax
  80291a:	48 89 c2             	mov    %rax,%rdx
  80291d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802924:	01 00 00 
  802927:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80292b:	83 e0 01             	and    $0x1,%eax
  80292e:	48 85 c0             	test   %rax,%rax
  802931:	74 21                	je     802954 <fd_alloc+0x6a>
  802933:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802937:	48 c1 e8 0c          	shr    $0xc,%rax
  80293b:	48 89 c2             	mov    %rax,%rdx
  80293e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802945:	01 00 00 
  802948:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80294c:	83 e0 01             	and    $0x1,%eax
  80294f:	48 85 c0             	test   %rax,%rax
  802952:	75 12                	jne    802966 <fd_alloc+0x7c>
			*fd_store = fd;
  802954:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802958:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80295c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80295f:	b8 00 00 00 00       	mov    $0x0,%eax
  802964:	eb 1a                	jmp    802980 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802966:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80296a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80296e:	7e 8f                	jle    8028ff <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802970:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802974:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80297b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802980:	c9                   	leaveq 
  802981:	c3                   	retq   

0000000000802982 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802982:	55                   	push   %rbp
  802983:	48 89 e5             	mov    %rsp,%rbp
  802986:	48 83 ec 20          	sub    $0x20,%rsp
  80298a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80298d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802991:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802995:	78 06                	js     80299d <fd_lookup+0x1b>
  802997:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80299b:	7e 07                	jle    8029a4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80299d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029a2:	eb 6c                	jmp    802a10 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8029a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029a7:	48 98                	cltq   
  8029a9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8029af:	48 c1 e0 0c          	shl    $0xc,%rax
  8029b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8029b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029bb:	48 c1 e8 15          	shr    $0x15,%rax
  8029bf:	48 89 c2             	mov    %rax,%rdx
  8029c2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029c9:	01 00 00 
  8029cc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029d0:	83 e0 01             	and    $0x1,%eax
  8029d3:	48 85 c0             	test   %rax,%rax
  8029d6:	74 21                	je     8029f9 <fd_lookup+0x77>
  8029d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029dc:	48 c1 e8 0c          	shr    $0xc,%rax
  8029e0:	48 89 c2             	mov    %rax,%rdx
  8029e3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029ea:	01 00 00 
  8029ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029f1:	83 e0 01             	and    $0x1,%eax
  8029f4:	48 85 c0             	test   %rax,%rax
  8029f7:	75 07                	jne    802a00 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8029f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029fe:	eb 10                	jmp    802a10 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802a00:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a04:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a08:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802a0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a10:	c9                   	leaveq 
  802a11:	c3                   	retq   

0000000000802a12 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802a12:	55                   	push   %rbp
  802a13:	48 89 e5             	mov    %rsp,%rbp
  802a16:	48 83 ec 30          	sub    $0x30,%rsp
  802a1a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802a1e:	89 f0                	mov    %esi,%eax
  802a20:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802a23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a27:	48 89 c7             	mov    %rax,%rdi
  802a2a:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  802a31:	00 00 00 
  802a34:	ff d0                	callq  *%rax
  802a36:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a3a:	48 89 d6             	mov    %rdx,%rsi
  802a3d:	89 c7                	mov    %eax,%edi
  802a3f:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  802a46:	00 00 00 
  802a49:	ff d0                	callq  *%rax
  802a4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a52:	78 0a                	js     802a5e <fd_close+0x4c>
	    || fd != fd2)
  802a54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a58:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802a5c:	74 12                	je     802a70 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802a5e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802a62:	74 05                	je     802a69 <fd_close+0x57>
  802a64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a67:	eb 05                	jmp    802a6e <fd_close+0x5c>
  802a69:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6e:	eb 69                	jmp    802ad9 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802a70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a74:	8b 00                	mov    (%rax),%eax
  802a76:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a7a:	48 89 d6             	mov    %rdx,%rsi
  802a7d:	89 c7                	mov    %eax,%edi
  802a7f:	48 b8 db 2a 80 00 00 	movabs $0x802adb,%rax
  802a86:	00 00 00 
  802a89:	ff d0                	callq  *%rax
  802a8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a92:	78 2a                	js     802abe <fd_close+0xac>
		if (dev->dev_close)
  802a94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a98:	48 8b 40 20          	mov    0x20(%rax),%rax
  802a9c:	48 85 c0             	test   %rax,%rax
  802a9f:	74 16                	je     802ab7 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802aa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aa5:	48 8b 40 20          	mov    0x20(%rax),%rax
  802aa9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802aad:	48 89 d7             	mov    %rdx,%rdi
  802ab0:	ff d0                	callq  *%rax
  802ab2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab5:	eb 07                	jmp    802abe <fd_close+0xac>
		else
			r = 0;
  802ab7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802abe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ac2:	48 89 c6             	mov    %rax,%rsi
  802ac5:	bf 00 00 00 00       	mov    $0x0,%edi
  802aca:	48 b8 f0 24 80 00 00 	movabs $0x8024f0,%rax
  802ad1:	00 00 00 
  802ad4:	ff d0                	callq  *%rax
	return r;
  802ad6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ad9:	c9                   	leaveq 
  802ada:	c3                   	retq   

0000000000802adb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802adb:	55                   	push   %rbp
  802adc:	48 89 e5             	mov    %rsp,%rbp
  802adf:	48 83 ec 20          	sub    $0x20,%rsp
  802ae3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ae6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802aea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802af1:	eb 41                	jmp    802b34 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802af3:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802afa:	00 00 00 
  802afd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b00:	48 63 d2             	movslq %edx,%rdx
  802b03:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b07:	8b 00                	mov    (%rax),%eax
  802b09:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802b0c:	75 22                	jne    802b30 <dev_lookup+0x55>
			*dev = devtab[i];
  802b0e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802b15:	00 00 00 
  802b18:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b1b:	48 63 d2             	movslq %edx,%rdx
  802b1e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802b22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b26:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802b29:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2e:	eb 60                	jmp    802b90 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802b30:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b34:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802b3b:	00 00 00 
  802b3e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b41:	48 63 d2             	movslq %edx,%rdx
  802b44:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b48:	48 85 c0             	test   %rax,%rax
  802b4b:	75 a6                	jne    802af3 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802b4d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b54:	00 00 00 
  802b57:	48 8b 00             	mov    (%rax),%rax
  802b5a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b60:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802b63:	89 c6                	mov    %eax,%esi
  802b65:	48 bf 30 49 80 00 00 	movabs $0x804930,%rdi
  802b6c:	00 00 00 
  802b6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b74:	48 b9 61 0f 80 00 00 	movabs $0x800f61,%rcx
  802b7b:	00 00 00 
  802b7e:	ff d1                	callq  *%rcx
	*dev = 0;
  802b80:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b84:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802b8b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802b90:	c9                   	leaveq 
  802b91:	c3                   	retq   

0000000000802b92 <close>:

int
close(int fdnum)
{
  802b92:	55                   	push   %rbp
  802b93:	48 89 e5             	mov    %rsp,%rbp
  802b96:	48 83 ec 20          	sub    $0x20,%rsp
  802b9a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b9d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ba1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ba4:	48 89 d6             	mov    %rdx,%rsi
  802ba7:	89 c7                	mov    %eax,%edi
  802ba9:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  802bb0:	00 00 00 
  802bb3:	ff d0                	callq  *%rax
  802bb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bbc:	79 05                	jns    802bc3 <close+0x31>
		return r;
  802bbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc1:	eb 18                	jmp    802bdb <close+0x49>
	else
		return fd_close(fd, 1);
  802bc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bc7:	be 01 00 00 00       	mov    $0x1,%esi
  802bcc:	48 89 c7             	mov    %rax,%rdi
  802bcf:	48 b8 12 2a 80 00 00 	movabs $0x802a12,%rax
  802bd6:	00 00 00 
  802bd9:	ff d0                	callq  *%rax
}
  802bdb:	c9                   	leaveq 
  802bdc:	c3                   	retq   

0000000000802bdd <close_all>:

void
close_all(void)
{
  802bdd:	55                   	push   %rbp
  802bde:	48 89 e5             	mov    %rsp,%rbp
  802be1:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802be5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bec:	eb 15                	jmp    802c03 <close_all+0x26>
		close(i);
  802bee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf1:	89 c7                	mov    %eax,%edi
  802bf3:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  802bfa:	00 00 00 
  802bfd:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802bff:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802c03:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802c07:	7e e5                	jle    802bee <close_all+0x11>
		close(i);
}
  802c09:	c9                   	leaveq 
  802c0a:	c3                   	retq   

0000000000802c0b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802c0b:	55                   	push   %rbp
  802c0c:	48 89 e5             	mov    %rsp,%rbp
  802c0f:	48 83 ec 40          	sub    $0x40,%rsp
  802c13:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802c16:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802c19:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802c1d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802c20:	48 89 d6             	mov    %rdx,%rsi
  802c23:	89 c7                	mov    %eax,%edi
  802c25:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  802c2c:	00 00 00 
  802c2f:	ff d0                	callq  *%rax
  802c31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c38:	79 08                	jns    802c42 <dup+0x37>
		return r;
  802c3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3d:	e9 70 01 00 00       	jmpq   802db2 <dup+0x1a7>
	close(newfdnum);
  802c42:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c45:	89 c7                	mov    %eax,%edi
  802c47:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  802c4e:	00 00 00 
  802c51:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802c53:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c56:	48 98                	cltq   
  802c58:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802c5e:	48 c1 e0 0c          	shl    $0xc,%rax
  802c62:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802c66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c6a:	48 89 c7             	mov    %rax,%rdi
  802c6d:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  802c74:	00 00 00 
  802c77:	ff d0                	callq  *%rax
  802c79:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802c7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c81:	48 89 c7             	mov    %rax,%rdi
  802c84:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  802c8b:	00 00 00 
  802c8e:	ff d0                	callq  *%rax
  802c90:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802c94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c98:	48 c1 e8 15          	shr    $0x15,%rax
  802c9c:	48 89 c2             	mov    %rax,%rdx
  802c9f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802ca6:	01 00 00 
  802ca9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cad:	83 e0 01             	and    $0x1,%eax
  802cb0:	48 85 c0             	test   %rax,%rax
  802cb3:	74 73                	je     802d28 <dup+0x11d>
  802cb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb9:	48 c1 e8 0c          	shr    $0xc,%rax
  802cbd:	48 89 c2             	mov    %rax,%rdx
  802cc0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cc7:	01 00 00 
  802cca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cce:	83 e0 01             	and    $0x1,%eax
  802cd1:	48 85 c0             	test   %rax,%rax
  802cd4:	74 52                	je     802d28 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802cd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cda:	48 c1 e8 0c          	shr    $0xc,%rax
  802cde:	48 89 c2             	mov    %rax,%rdx
  802ce1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ce8:	01 00 00 
  802ceb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cef:	25 07 0e 00 00       	and    $0xe07,%eax
  802cf4:	89 c1                	mov    %eax,%ecx
  802cf6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cfa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cfe:	41 89 c8             	mov    %ecx,%r8d
  802d01:	48 89 d1             	mov    %rdx,%rcx
  802d04:	ba 00 00 00 00       	mov    $0x0,%edx
  802d09:	48 89 c6             	mov    %rax,%rsi
  802d0c:	bf 00 00 00 00       	mov    $0x0,%edi
  802d11:	48 b8 95 24 80 00 00 	movabs $0x802495,%rax
  802d18:	00 00 00 
  802d1b:	ff d0                	callq  *%rax
  802d1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d24:	79 02                	jns    802d28 <dup+0x11d>
			goto err;
  802d26:	eb 57                	jmp    802d7f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802d28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d2c:	48 c1 e8 0c          	shr    $0xc,%rax
  802d30:	48 89 c2             	mov    %rax,%rdx
  802d33:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d3a:	01 00 00 
  802d3d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d41:	25 07 0e 00 00       	and    $0xe07,%eax
  802d46:	89 c1                	mov    %eax,%ecx
  802d48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d50:	41 89 c8             	mov    %ecx,%r8d
  802d53:	48 89 d1             	mov    %rdx,%rcx
  802d56:	ba 00 00 00 00       	mov    $0x0,%edx
  802d5b:	48 89 c6             	mov    %rax,%rsi
  802d5e:	bf 00 00 00 00       	mov    $0x0,%edi
  802d63:	48 b8 95 24 80 00 00 	movabs $0x802495,%rax
  802d6a:	00 00 00 
  802d6d:	ff d0                	callq  *%rax
  802d6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d76:	79 02                	jns    802d7a <dup+0x16f>
		goto err;
  802d78:	eb 05                	jmp    802d7f <dup+0x174>

	return newfdnum;
  802d7a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d7d:	eb 33                	jmp    802db2 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802d7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d83:	48 89 c6             	mov    %rax,%rsi
  802d86:	bf 00 00 00 00       	mov    $0x0,%edi
  802d8b:	48 b8 f0 24 80 00 00 	movabs $0x8024f0,%rax
  802d92:	00 00 00 
  802d95:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802d97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d9b:	48 89 c6             	mov    %rax,%rsi
  802d9e:	bf 00 00 00 00       	mov    $0x0,%edi
  802da3:	48 b8 f0 24 80 00 00 	movabs $0x8024f0,%rax
  802daa:	00 00 00 
  802dad:	ff d0                	callq  *%rax
	return r;
  802daf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802db2:	c9                   	leaveq 
  802db3:	c3                   	retq   

0000000000802db4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802db4:	55                   	push   %rbp
  802db5:	48 89 e5             	mov    %rsp,%rbp
  802db8:	48 83 ec 40          	sub    $0x40,%rsp
  802dbc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802dbf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802dc3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802dc7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802dcb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802dce:	48 89 d6             	mov    %rdx,%rsi
  802dd1:	89 c7                	mov    %eax,%edi
  802dd3:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  802dda:	00 00 00 
  802ddd:	ff d0                	callq  *%rax
  802ddf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802de2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802de6:	78 24                	js     802e0c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802de8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dec:	8b 00                	mov    (%rax),%eax
  802dee:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802df2:	48 89 d6             	mov    %rdx,%rsi
  802df5:	89 c7                	mov    %eax,%edi
  802df7:	48 b8 db 2a 80 00 00 	movabs $0x802adb,%rax
  802dfe:	00 00 00 
  802e01:	ff d0                	callq  *%rax
  802e03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e0a:	79 05                	jns    802e11 <read+0x5d>
		return r;
  802e0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e0f:	eb 76                	jmp    802e87 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802e11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e15:	8b 40 08             	mov    0x8(%rax),%eax
  802e18:	83 e0 03             	and    $0x3,%eax
  802e1b:	83 f8 01             	cmp    $0x1,%eax
  802e1e:	75 3a                	jne    802e5a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802e20:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802e27:	00 00 00 
  802e2a:	48 8b 00             	mov    (%rax),%rax
  802e2d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e33:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e36:	89 c6                	mov    %eax,%esi
  802e38:	48 bf 4f 49 80 00 00 	movabs $0x80494f,%rdi
  802e3f:	00 00 00 
  802e42:	b8 00 00 00 00       	mov    $0x0,%eax
  802e47:	48 b9 61 0f 80 00 00 	movabs $0x800f61,%rcx
  802e4e:	00 00 00 
  802e51:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802e53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e58:	eb 2d                	jmp    802e87 <read+0xd3>
	}
	if (!dev->dev_read)
  802e5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e5e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802e62:	48 85 c0             	test   %rax,%rax
  802e65:	75 07                	jne    802e6e <read+0xba>
		return -E_NOT_SUPP;
  802e67:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e6c:	eb 19                	jmp    802e87 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802e6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e72:	48 8b 40 10          	mov    0x10(%rax),%rax
  802e76:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802e7a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e7e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802e82:	48 89 cf             	mov    %rcx,%rdi
  802e85:	ff d0                	callq  *%rax
}
  802e87:	c9                   	leaveq 
  802e88:	c3                   	retq   

0000000000802e89 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802e89:	55                   	push   %rbp
  802e8a:	48 89 e5             	mov    %rsp,%rbp
  802e8d:	48 83 ec 30          	sub    $0x30,%rsp
  802e91:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e94:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e98:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ea3:	eb 49                	jmp    802eee <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ea5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea8:	48 98                	cltq   
  802eaa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802eae:	48 29 c2             	sub    %rax,%rdx
  802eb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb4:	48 63 c8             	movslq %eax,%rcx
  802eb7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ebb:	48 01 c1             	add    %rax,%rcx
  802ebe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ec1:	48 89 ce             	mov    %rcx,%rsi
  802ec4:	89 c7                	mov    %eax,%edi
  802ec6:	48 b8 b4 2d 80 00 00 	movabs $0x802db4,%rax
  802ecd:	00 00 00 
  802ed0:	ff d0                	callq  *%rax
  802ed2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802ed5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ed9:	79 05                	jns    802ee0 <readn+0x57>
			return m;
  802edb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ede:	eb 1c                	jmp    802efc <readn+0x73>
		if (m == 0)
  802ee0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ee4:	75 02                	jne    802ee8 <readn+0x5f>
			break;
  802ee6:	eb 11                	jmp    802ef9 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ee8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802eeb:	01 45 fc             	add    %eax,-0x4(%rbp)
  802eee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef1:	48 98                	cltq   
  802ef3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802ef7:	72 ac                	jb     802ea5 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802ef9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802efc:	c9                   	leaveq 
  802efd:	c3                   	retq   

0000000000802efe <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802efe:	55                   	push   %rbp
  802eff:	48 89 e5             	mov    %rsp,%rbp
  802f02:	48 83 ec 40          	sub    $0x40,%rsp
  802f06:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f09:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f0d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f11:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f15:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f18:	48 89 d6             	mov    %rdx,%rsi
  802f1b:	89 c7                	mov    %eax,%edi
  802f1d:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  802f24:	00 00 00 
  802f27:	ff d0                	callq  *%rax
  802f29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f30:	78 24                	js     802f56 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f36:	8b 00                	mov    (%rax),%eax
  802f38:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f3c:	48 89 d6             	mov    %rdx,%rsi
  802f3f:	89 c7                	mov    %eax,%edi
  802f41:	48 b8 db 2a 80 00 00 	movabs $0x802adb,%rax
  802f48:	00 00 00 
  802f4b:	ff d0                	callq  *%rax
  802f4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f54:	79 05                	jns    802f5b <write+0x5d>
		return r;
  802f56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f59:	eb 75                	jmp    802fd0 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f5f:	8b 40 08             	mov    0x8(%rax),%eax
  802f62:	83 e0 03             	and    $0x3,%eax
  802f65:	85 c0                	test   %eax,%eax
  802f67:	75 3a                	jne    802fa3 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802f69:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802f70:	00 00 00 
  802f73:	48 8b 00             	mov    (%rax),%rax
  802f76:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f7c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f7f:	89 c6                	mov    %eax,%esi
  802f81:	48 bf 6b 49 80 00 00 	movabs $0x80496b,%rdi
  802f88:	00 00 00 
  802f8b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f90:	48 b9 61 0f 80 00 00 	movabs $0x800f61,%rcx
  802f97:	00 00 00 
  802f9a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802f9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fa1:	eb 2d                	jmp    802fd0 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802fa3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fa7:	48 8b 40 18          	mov    0x18(%rax),%rax
  802fab:	48 85 c0             	test   %rax,%rax
  802fae:	75 07                	jne    802fb7 <write+0xb9>
		return -E_NOT_SUPP;
  802fb0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802fb5:	eb 19                	jmp    802fd0 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802fb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fbb:	48 8b 40 18          	mov    0x18(%rax),%rax
  802fbf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802fc3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802fc7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802fcb:	48 89 cf             	mov    %rcx,%rdi
  802fce:	ff d0                	callq  *%rax
}
  802fd0:	c9                   	leaveq 
  802fd1:	c3                   	retq   

0000000000802fd2 <seek>:

int
seek(int fdnum, off_t offset)
{
  802fd2:	55                   	push   %rbp
  802fd3:	48 89 e5             	mov    %rsp,%rbp
  802fd6:	48 83 ec 18          	sub    $0x18,%rsp
  802fda:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fdd:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802fe0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fe4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fe7:	48 89 d6             	mov    %rdx,%rsi
  802fea:	89 c7                	mov    %eax,%edi
  802fec:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  802ff3:	00 00 00 
  802ff6:	ff d0                	callq  *%rax
  802ff8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ffb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fff:	79 05                	jns    803006 <seek+0x34>
		return r;
  803001:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803004:	eb 0f                	jmp    803015 <seek+0x43>
	fd->fd_offset = offset;
  803006:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80300a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80300d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803010:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803015:	c9                   	leaveq 
  803016:	c3                   	retq   

0000000000803017 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803017:	55                   	push   %rbp
  803018:	48 89 e5             	mov    %rsp,%rbp
  80301b:	48 83 ec 30          	sub    $0x30,%rsp
  80301f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803022:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803025:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803029:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80302c:	48 89 d6             	mov    %rdx,%rsi
  80302f:	89 c7                	mov    %eax,%edi
  803031:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  803038:	00 00 00 
  80303b:	ff d0                	callq  *%rax
  80303d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803040:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803044:	78 24                	js     80306a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803046:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80304a:	8b 00                	mov    (%rax),%eax
  80304c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803050:	48 89 d6             	mov    %rdx,%rsi
  803053:	89 c7                	mov    %eax,%edi
  803055:	48 b8 db 2a 80 00 00 	movabs $0x802adb,%rax
  80305c:	00 00 00 
  80305f:	ff d0                	callq  *%rax
  803061:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803064:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803068:	79 05                	jns    80306f <ftruncate+0x58>
		return r;
  80306a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80306d:	eb 72                	jmp    8030e1 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80306f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803073:	8b 40 08             	mov    0x8(%rax),%eax
  803076:	83 e0 03             	and    $0x3,%eax
  803079:	85 c0                	test   %eax,%eax
  80307b:	75 3a                	jne    8030b7 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80307d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803084:	00 00 00 
  803087:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80308a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803090:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803093:	89 c6                	mov    %eax,%esi
  803095:	48 bf 88 49 80 00 00 	movabs $0x804988,%rdi
  80309c:	00 00 00 
  80309f:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a4:	48 b9 61 0f 80 00 00 	movabs $0x800f61,%rcx
  8030ab:	00 00 00 
  8030ae:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8030b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030b5:	eb 2a                	jmp    8030e1 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8030b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030bb:	48 8b 40 30          	mov    0x30(%rax),%rax
  8030bf:	48 85 c0             	test   %rax,%rax
  8030c2:	75 07                	jne    8030cb <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8030c4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8030c9:	eb 16                	jmp    8030e1 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8030cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030cf:	48 8b 40 30          	mov    0x30(%rax),%rax
  8030d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030d7:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8030da:	89 ce                	mov    %ecx,%esi
  8030dc:	48 89 d7             	mov    %rdx,%rdi
  8030df:	ff d0                	callq  *%rax
}
  8030e1:	c9                   	leaveq 
  8030e2:	c3                   	retq   

00000000008030e3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8030e3:	55                   	push   %rbp
  8030e4:	48 89 e5             	mov    %rsp,%rbp
  8030e7:	48 83 ec 30          	sub    $0x30,%rsp
  8030eb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8030ee:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030f2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8030f6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8030f9:	48 89 d6             	mov    %rdx,%rsi
  8030fc:	89 c7                	mov    %eax,%edi
  8030fe:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  803105:	00 00 00 
  803108:	ff d0                	callq  *%rax
  80310a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80310d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803111:	78 24                	js     803137 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803113:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803117:	8b 00                	mov    (%rax),%eax
  803119:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80311d:	48 89 d6             	mov    %rdx,%rsi
  803120:	89 c7                	mov    %eax,%edi
  803122:	48 b8 db 2a 80 00 00 	movabs $0x802adb,%rax
  803129:	00 00 00 
  80312c:	ff d0                	callq  *%rax
  80312e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803131:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803135:	79 05                	jns    80313c <fstat+0x59>
		return r;
  803137:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313a:	eb 5e                	jmp    80319a <fstat+0xb7>
	if (!dev->dev_stat)
  80313c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803140:	48 8b 40 28          	mov    0x28(%rax),%rax
  803144:	48 85 c0             	test   %rax,%rax
  803147:	75 07                	jne    803150 <fstat+0x6d>
		return -E_NOT_SUPP;
  803149:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80314e:	eb 4a                	jmp    80319a <fstat+0xb7>
	stat->st_name[0] = 0;
  803150:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803154:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803157:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80315b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803162:	00 00 00 
	stat->st_isdir = 0;
  803165:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803169:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803170:	00 00 00 
	stat->st_dev = dev;
  803173:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803177:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80317b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803182:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803186:	48 8b 40 28          	mov    0x28(%rax),%rax
  80318a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80318e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803192:	48 89 ce             	mov    %rcx,%rsi
  803195:	48 89 d7             	mov    %rdx,%rdi
  803198:	ff d0                	callq  *%rax
}
  80319a:	c9                   	leaveq 
  80319b:	c3                   	retq   

000000000080319c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80319c:	55                   	push   %rbp
  80319d:	48 89 e5             	mov    %rsp,%rbp
  8031a0:	48 83 ec 20          	sub    $0x20,%rsp
  8031a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8031ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031b0:	be 00 00 00 00       	mov    $0x0,%esi
  8031b5:	48 89 c7             	mov    %rax,%rdi
  8031b8:	48 b8 8a 32 80 00 00 	movabs $0x80328a,%rax
  8031bf:	00 00 00 
  8031c2:	ff d0                	callq  *%rax
  8031c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031cb:	79 05                	jns    8031d2 <stat+0x36>
		return fd;
  8031cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d0:	eb 2f                	jmp    803201 <stat+0x65>
	r = fstat(fd, stat);
  8031d2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8031d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d9:	48 89 d6             	mov    %rdx,%rsi
  8031dc:	89 c7                	mov    %eax,%edi
  8031de:	48 b8 e3 30 80 00 00 	movabs $0x8030e3,%rax
  8031e5:	00 00 00 
  8031e8:	ff d0                	callq  *%rax
  8031ea:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8031ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031f0:	89 c7                	mov    %eax,%edi
  8031f2:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  8031f9:	00 00 00 
  8031fc:	ff d0                	callq  *%rax
	return r;
  8031fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803201:	c9                   	leaveq 
  803202:	c3                   	retq   

0000000000803203 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803203:	55                   	push   %rbp
  803204:	48 89 e5             	mov    %rsp,%rbp
  803207:	48 83 ec 10          	sub    $0x10,%rsp
  80320b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80320e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803212:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803219:	00 00 00 
  80321c:	8b 00                	mov    (%rax),%eax
  80321e:	85 c0                	test   %eax,%eax
  803220:	75 1d                	jne    80323f <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803222:	bf 01 00 00 00       	mov    $0x1,%edi
  803227:	48 b8 1a 28 80 00 00 	movabs $0x80281a,%rax
  80322e:	00 00 00 
  803231:	ff d0                	callq  *%rax
  803233:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80323a:	00 00 00 
  80323d:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80323f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803246:	00 00 00 
  803249:	8b 00                	mov    (%rax),%eax
  80324b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80324e:	b9 07 00 00 00       	mov    $0x7,%ecx
  803253:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80325a:	00 00 00 
  80325d:	89 c7                	mov    %eax,%edi
  80325f:	48 b8 b8 27 80 00 00 	movabs $0x8027b8,%rax
  803266:	00 00 00 
  803269:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80326b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80326f:	ba 00 00 00 00       	mov    $0x0,%edx
  803274:	48 89 c6             	mov    %rax,%rsi
  803277:	bf 00 00 00 00       	mov    $0x0,%edi
  80327c:	48 b8 b2 26 80 00 00 	movabs $0x8026b2,%rax
  803283:	00 00 00 
  803286:	ff d0                	callq  *%rax
}
  803288:	c9                   	leaveq 
  803289:	c3                   	retq   

000000000080328a <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80328a:	55                   	push   %rbp
  80328b:	48 89 e5             	mov    %rsp,%rbp
  80328e:	48 83 ec 30          	sub    $0x30,%rsp
  803292:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803296:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  803299:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8032a0:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8032a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8032ae:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8032b3:	75 08                	jne    8032bd <open+0x33>
	{
		return r;
  8032b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b8:	e9 f2 00 00 00       	jmpq   8033af <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8032bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032c1:	48 89 c7             	mov    %rax,%rdi
  8032c4:	48 b8 aa 1a 80 00 00 	movabs $0x801aaa,%rax
  8032cb:	00 00 00 
  8032ce:	ff d0                	callq  *%rax
  8032d0:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8032d3:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8032da:	7e 0a                	jle    8032e6 <open+0x5c>
	{
		return -E_BAD_PATH;
  8032dc:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8032e1:	e9 c9 00 00 00       	jmpq   8033af <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8032e6:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8032ed:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8032ee:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8032f2:	48 89 c7             	mov    %rax,%rdi
  8032f5:	48 b8 ea 28 80 00 00 	movabs $0x8028ea,%rax
  8032fc:	00 00 00 
  8032ff:	ff d0                	callq  *%rax
  803301:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803304:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803308:	78 09                	js     803313 <open+0x89>
  80330a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80330e:	48 85 c0             	test   %rax,%rax
  803311:	75 08                	jne    80331b <open+0x91>
		{
			return r;
  803313:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803316:	e9 94 00 00 00       	jmpq   8033af <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80331b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80331f:	ba 00 04 00 00       	mov    $0x400,%edx
  803324:	48 89 c6             	mov    %rax,%rsi
  803327:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80332e:	00 00 00 
  803331:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  803338:	00 00 00 
  80333b:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  80333d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803344:	00 00 00 
  803347:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80334a:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  803350:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803354:	48 89 c6             	mov    %rax,%rsi
  803357:	bf 01 00 00 00       	mov    $0x1,%edi
  80335c:	48 b8 03 32 80 00 00 	movabs $0x803203,%rax
  803363:	00 00 00 
  803366:	ff d0                	callq  *%rax
  803368:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80336b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80336f:	79 2b                	jns    80339c <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  803371:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803375:	be 00 00 00 00       	mov    $0x0,%esi
  80337a:	48 89 c7             	mov    %rax,%rdi
  80337d:	48 b8 12 2a 80 00 00 	movabs $0x802a12,%rax
  803384:	00 00 00 
  803387:	ff d0                	callq  *%rax
  803389:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80338c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803390:	79 05                	jns    803397 <open+0x10d>
			{
				return d;
  803392:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803395:	eb 18                	jmp    8033af <open+0x125>
			}
			return r;
  803397:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80339a:	eb 13                	jmp    8033af <open+0x125>
		}	
		return fd2num(fd_store);
  80339c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033a0:	48 89 c7             	mov    %rax,%rdi
  8033a3:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  8033aa:	00 00 00 
  8033ad:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8033af:	c9                   	leaveq 
  8033b0:	c3                   	retq   

00000000008033b1 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8033b1:	55                   	push   %rbp
  8033b2:	48 89 e5             	mov    %rsp,%rbp
  8033b5:	48 83 ec 10          	sub    $0x10,%rsp
  8033b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8033bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033c1:	8b 50 0c             	mov    0xc(%rax),%edx
  8033c4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033cb:	00 00 00 
  8033ce:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8033d0:	be 00 00 00 00       	mov    $0x0,%esi
  8033d5:	bf 06 00 00 00       	mov    $0x6,%edi
  8033da:	48 b8 03 32 80 00 00 	movabs $0x803203,%rax
  8033e1:	00 00 00 
  8033e4:	ff d0                	callq  *%rax
}
  8033e6:	c9                   	leaveq 
  8033e7:	c3                   	retq   

00000000008033e8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8033e8:	55                   	push   %rbp
  8033e9:	48 89 e5             	mov    %rsp,%rbp
  8033ec:	48 83 ec 30          	sub    $0x30,%rsp
  8033f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033f8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8033fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  803403:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803408:	74 07                	je     803411 <devfile_read+0x29>
  80340a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80340f:	75 07                	jne    803418 <devfile_read+0x30>
		return -E_INVAL;
  803411:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803416:	eb 77                	jmp    80348f <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803418:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80341c:	8b 50 0c             	mov    0xc(%rax),%edx
  80341f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803426:	00 00 00 
  803429:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80342b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803432:	00 00 00 
  803435:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803439:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80343d:	be 00 00 00 00       	mov    $0x0,%esi
  803442:	bf 03 00 00 00       	mov    $0x3,%edi
  803447:	48 b8 03 32 80 00 00 	movabs $0x803203,%rax
  80344e:	00 00 00 
  803451:	ff d0                	callq  *%rax
  803453:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803456:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80345a:	7f 05                	jg     803461 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80345c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80345f:	eb 2e                	jmp    80348f <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  803461:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803464:	48 63 d0             	movslq %eax,%rdx
  803467:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80346b:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803472:	00 00 00 
  803475:	48 89 c7             	mov    %rax,%rdi
  803478:	48 b8 3a 1e 80 00 00 	movabs $0x801e3a,%rax
  80347f:	00 00 00 
  803482:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803484:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803488:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80348c:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80348f:	c9                   	leaveq 
  803490:	c3                   	retq   

0000000000803491 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803491:	55                   	push   %rbp
  803492:	48 89 e5             	mov    %rsp,%rbp
  803495:	48 83 ec 30          	sub    $0x30,%rsp
  803499:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80349d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8034a5:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8034ac:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8034b1:	74 07                	je     8034ba <devfile_write+0x29>
  8034b3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8034b8:	75 08                	jne    8034c2 <devfile_write+0x31>
		return r;
  8034ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034bd:	e9 9a 00 00 00       	jmpq   80355c <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8034c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034c6:	8b 50 0c             	mov    0xc(%rax),%edx
  8034c9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034d0:	00 00 00 
  8034d3:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8034d5:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8034dc:	00 
  8034dd:	76 08                	jbe    8034e7 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8034df:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8034e6:	00 
	}
	fsipcbuf.write.req_n = n;
  8034e7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034ee:	00 00 00 
  8034f1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8034f5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8034f9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8034fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803501:	48 89 c6             	mov    %rax,%rsi
  803504:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80350b:	00 00 00 
  80350e:	48 b8 3a 1e 80 00 00 	movabs $0x801e3a,%rax
  803515:	00 00 00 
  803518:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80351a:	be 00 00 00 00       	mov    $0x0,%esi
  80351f:	bf 04 00 00 00       	mov    $0x4,%edi
  803524:	48 b8 03 32 80 00 00 	movabs $0x803203,%rax
  80352b:	00 00 00 
  80352e:	ff d0                	callq  *%rax
  803530:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803533:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803537:	7f 20                	jg     803559 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803539:	48 bf ae 49 80 00 00 	movabs $0x8049ae,%rdi
  803540:	00 00 00 
  803543:	b8 00 00 00 00       	mov    $0x0,%eax
  803548:	48 ba 61 0f 80 00 00 	movabs $0x800f61,%rdx
  80354f:	00 00 00 
  803552:	ff d2                	callq  *%rdx
		return r;
  803554:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803557:	eb 03                	jmp    80355c <devfile_write+0xcb>
	}
	return r;
  803559:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80355c:	c9                   	leaveq 
  80355d:	c3                   	retq   

000000000080355e <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80355e:	55                   	push   %rbp
  80355f:	48 89 e5             	mov    %rsp,%rbp
  803562:	48 83 ec 20          	sub    $0x20,%rsp
  803566:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80356a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80356e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803572:	8b 50 0c             	mov    0xc(%rax),%edx
  803575:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80357c:	00 00 00 
  80357f:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803581:	be 00 00 00 00       	mov    $0x0,%esi
  803586:	bf 05 00 00 00       	mov    $0x5,%edi
  80358b:	48 b8 03 32 80 00 00 	movabs $0x803203,%rax
  803592:	00 00 00 
  803595:	ff d0                	callq  *%rax
  803597:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80359a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80359e:	79 05                	jns    8035a5 <devfile_stat+0x47>
		return r;
  8035a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a3:	eb 56                	jmp    8035fb <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8035a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035a9:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8035b0:	00 00 00 
  8035b3:	48 89 c7             	mov    %rax,%rdi
  8035b6:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  8035bd:	00 00 00 
  8035c0:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8035c2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8035c9:	00 00 00 
  8035cc:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8035d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035d6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8035dc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8035e3:	00 00 00 
  8035e6:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8035ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035f0:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8035f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035fb:	c9                   	leaveq 
  8035fc:	c3                   	retq   

00000000008035fd <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8035fd:	55                   	push   %rbp
  8035fe:	48 89 e5             	mov    %rsp,%rbp
  803601:	48 83 ec 10          	sub    $0x10,%rsp
  803605:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803609:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80360c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803610:	8b 50 0c             	mov    0xc(%rax),%edx
  803613:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80361a:	00 00 00 
  80361d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80361f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803626:	00 00 00 
  803629:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80362c:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80362f:	be 00 00 00 00       	mov    $0x0,%esi
  803634:	bf 02 00 00 00       	mov    $0x2,%edi
  803639:	48 b8 03 32 80 00 00 	movabs $0x803203,%rax
  803640:	00 00 00 
  803643:	ff d0                	callq  *%rax
}
  803645:	c9                   	leaveq 
  803646:	c3                   	retq   

0000000000803647 <remove>:

// Delete a file
int
remove(const char *path)
{
  803647:	55                   	push   %rbp
  803648:	48 89 e5             	mov    %rsp,%rbp
  80364b:	48 83 ec 10          	sub    $0x10,%rsp
  80364f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803653:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803657:	48 89 c7             	mov    %rax,%rdi
  80365a:	48 b8 aa 1a 80 00 00 	movabs $0x801aaa,%rax
  803661:	00 00 00 
  803664:	ff d0                	callq  *%rax
  803666:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80366b:	7e 07                	jle    803674 <remove+0x2d>
		return -E_BAD_PATH;
  80366d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803672:	eb 33                	jmp    8036a7 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803674:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803678:	48 89 c6             	mov    %rax,%rsi
  80367b:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803682:	00 00 00 
  803685:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  80368c:	00 00 00 
  80368f:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803691:	be 00 00 00 00       	mov    $0x0,%esi
  803696:	bf 07 00 00 00       	mov    $0x7,%edi
  80369b:	48 b8 03 32 80 00 00 	movabs $0x803203,%rax
  8036a2:	00 00 00 
  8036a5:	ff d0                	callq  *%rax
}
  8036a7:	c9                   	leaveq 
  8036a8:	c3                   	retq   

00000000008036a9 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8036a9:	55                   	push   %rbp
  8036aa:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8036ad:	be 00 00 00 00       	mov    $0x0,%esi
  8036b2:	bf 08 00 00 00       	mov    $0x8,%edi
  8036b7:	48 b8 03 32 80 00 00 	movabs $0x803203,%rax
  8036be:	00 00 00 
  8036c1:	ff d0                	callq  *%rax
}
  8036c3:	5d                   	pop    %rbp
  8036c4:	c3                   	retq   

00000000008036c5 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8036c5:	55                   	push   %rbp
  8036c6:	48 89 e5             	mov    %rsp,%rbp
  8036c9:	53                   	push   %rbx
  8036ca:	48 83 ec 38          	sub    $0x38,%rsp
  8036ce:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8036d2:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8036d6:	48 89 c7             	mov    %rax,%rdi
  8036d9:	48 b8 ea 28 80 00 00 	movabs $0x8028ea,%rax
  8036e0:	00 00 00 
  8036e3:	ff d0                	callq  *%rax
  8036e5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036ec:	0f 88 bf 01 00 00    	js     8038b1 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036f6:	ba 07 04 00 00       	mov    $0x407,%edx
  8036fb:	48 89 c6             	mov    %rax,%rsi
  8036fe:	bf 00 00 00 00       	mov    $0x0,%edi
  803703:	48 b8 45 24 80 00 00 	movabs $0x802445,%rax
  80370a:	00 00 00 
  80370d:	ff d0                	callq  *%rax
  80370f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803712:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803716:	0f 88 95 01 00 00    	js     8038b1 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80371c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803720:	48 89 c7             	mov    %rax,%rdi
  803723:	48 b8 ea 28 80 00 00 	movabs $0x8028ea,%rax
  80372a:	00 00 00 
  80372d:	ff d0                	callq  *%rax
  80372f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803732:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803736:	0f 88 5d 01 00 00    	js     803899 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80373c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803740:	ba 07 04 00 00       	mov    $0x407,%edx
  803745:	48 89 c6             	mov    %rax,%rsi
  803748:	bf 00 00 00 00       	mov    $0x0,%edi
  80374d:	48 b8 45 24 80 00 00 	movabs $0x802445,%rax
  803754:	00 00 00 
  803757:	ff d0                	callq  *%rax
  803759:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80375c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803760:	0f 88 33 01 00 00    	js     803899 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803766:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80376a:	48 89 c7             	mov    %rax,%rdi
  80376d:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  803774:	00 00 00 
  803777:	ff d0                	callq  *%rax
  803779:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80377d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803781:	ba 07 04 00 00       	mov    $0x407,%edx
  803786:	48 89 c6             	mov    %rax,%rsi
  803789:	bf 00 00 00 00       	mov    $0x0,%edi
  80378e:	48 b8 45 24 80 00 00 	movabs $0x802445,%rax
  803795:	00 00 00 
  803798:	ff d0                	callq  *%rax
  80379a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80379d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037a1:	79 05                	jns    8037a8 <pipe+0xe3>
		goto err2;
  8037a3:	e9 d9 00 00 00       	jmpq   803881 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037ac:	48 89 c7             	mov    %rax,%rdi
  8037af:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  8037b6:	00 00 00 
  8037b9:	ff d0                	callq  *%rax
  8037bb:	48 89 c2             	mov    %rax,%rdx
  8037be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037c2:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8037c8:	48 89 d1             	mov    %rdx,%rcx
  8037cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8037d0:	48 89 c6             	mov    %rax,%rsi
  8037d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8037d8:	48 b8 95 24 80 00 00 	movabs $0x802495,%rax
  8037df:	00 00 00 
  8037e2:	ff d0                	callq  *%rax
  8037e4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037eb:	79 1b                	jns    803808 <pipe+0x143>
		goto err3;
  8037ed:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8037ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037f2:	48 89 c6             	mov    %rax,%rsi
  8037f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8037fa:	48 b8 f0 24 80 00 00 	movabs $0x8024f0,%rax
  803801:	00 00 00 
  803804:	ff d0                	callq  *%rax
  803806:	eb 79                	jmp    803881 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803808:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80380c:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803813:	00 00 00 
  803816:	8b 12                	mov    (%rdx),%edx
  803818:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80381a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80381e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803825:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803829:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803830:	00 00 00 
  803833:	8b 12                	mov    (%rdx),%edx
  803835:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803837:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80383b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803842:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803846:	48 89 c7             	mov    %rax,%rdi
  803849:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  803850:	00 00 00 
  803853:	ff d0                	callq  *%rax
  803855:	89 c2                	mov    %eax,%edx
  803857:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80385b:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80385d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803861:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803865:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803869:	48 89 c7             	mov    %rax,%rdi
  80386c:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  803873:	00 00 00 
  803876:	ff d0                	callq  *%rax
  803878:	89 03                	mov    %eax,(%rbx)
	return 0;
  80387a:	b8 00 00 00 00       	mov    $0x0,%eax
  80387f:	eb 33                	jmp    8038b4 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803881:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803885:	48 89 c6             	mov    %rax,%rsi
  803888:	bf 00 00 00 00       	mov    $0x0,%edi
  80388d:	48 b8 f0 24 80 00 00 	movabs $0x8024f0,%rax
  803894:	00 00 00 
  803897:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803899:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80389d:	48 89 c6             	mov    %rax,%rsi
  8038a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8038a5:	48 b8 f0 24 80 00 00 	movabs $0x8024f0,%rax
  8038ac:	00 00 00 
  8038af:	ff d0                	callq  *%rax
    err:
	return r;
  8038b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8038b4:	48 83 c4 38          	add    $0x38,%rsp
  8038b8:	5b                   	pop    %rbx
  8038b9:	5d                   	pop    %rbp
  8038ba:	c3                   	retq   

00000000008038bb <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8038bb:	55                   	push   %rbp
  8038bc:	48 89 e5             	mov    %rsp,%rbp
  8038bf:	53                   	push   %rbx
  8038c0:	48 83 ec 28          	sub    $0x28,%rsp
  8038c4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038c8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8038cc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8038d3:	00 00 00 
  8038d6:	48 8b 00             	mov    (%rax),%rax
  8038d9:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8038df:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8038e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038e6:	48 89 c7             	mov    %rax,%rdi
  8038e9:	48 b8 41 3f 80 00 00 	movabs $0x803f41,%rax
  8038f0:	00 00 00 
  8038f3:	ff d0                	callq  *%rax
  8038f5:	89 c3                	mov    %eax,%ebx
  8038f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038fb:	48 89 c7             	mov    %rax,%rdi
  8038fe:	48 b8 41 3f 80 00 00 	movabs $0x803f41,%rax
  803905:	00 00 00 
  803908:	ff d0                	callq  *%rax
  80390a:	39 c3                	cmp    %eax,%ebx
  80390c:	0f 94 c0             	sete   %al
  80390f:	0f b6 c0             	movzbl %al,%eax
  803912:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803915:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80391c:	00 00 00 
  80391f:	48 8b 00             	mov    (%rax),%rax
  803922:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803928:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80392b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80392e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803931:	75 05                	jne    803938 <_pipeisclosed+0x7d>
			return ret;
  803933:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803936:	eb 4f                	jmp    803987 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803938:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80393b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80393e:	74 42                	je     803982 <_pipeisclosed+0xc7>
  803940:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803944:	75 3c                	jne    803982 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803946:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80394d:	00 00 00 
  803950:	48 8b 00             	mov    (%rax),%rax
  803953:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803959:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80395c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80395f:	89 c6                	mov    %eax,%esi
  803961:	48 bf cf 49 80 00 00 	movabs $0x8049cf,%rdi
  803968:	00 00 00 
  80396b:	b8 00 00 00 00       	mov    $0x0,%eax
  803970:	49 b8 61 0f 80 00 00 	movabs $0x800f61,%r8
  803977:	00 00 00 
  80397a:	41 ff d0             	callq  *%r8
	}
  80397d:	e9 4a ff ff ff       	jmpq   8038cc <_pipeisclosed+0x11>
  803982:	e9 45 ff ff ff       	jmpq   8038cc <_pipeisclosed+0x11>
}
  803987:	48 83 c4 28          	add    $0x28,%rsp
  80398b:	5b                   	pop    %rbx
  80398c:	5d                   	pop    %rbp
  80398d:	c3                   	retq   

000000000080398e <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80398e:	55                   	push   %rbp
  80398f:	48 89 e5             	mov    %rsp,%rbp
  803992:	48 83 ec 30          	sub    $0x30,%rsp
  803996:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803999:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80399d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8039a0:	48 89 d6             	mov    %rdx,%rsi
  8039a3:	89 c7                	mov    %eax,%edi
  8039a5:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  8039ac:	00 00 00 
  8039af:	ff d0                	callq  *%rax
  8039b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039b8:	79 05                	jns    8039bf <pipeisclosed+0x31>
		return r;
  8039ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039bd:	eb 31                	jmp    8039f0 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8039bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039c3:	48 89 c7             	mov    %rax,%rdi
  8039c6:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  8039cd:	00 00 00 
  8039d0:	ff d0                	callq  *%rax
  8039d2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8039d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039de:	48 89 d6             	mov    %rdx,%rsi
  8039e1:	48 89 c7             	mov    %rax,%rdi
  8039e4:	48 b8 bb 38 80 00 00 	movabs $0x8038bb,%rax
  8039eb:	00 00 00 
  8039ee:	ff d0                	callq  *%rax
}
  8039f0:	c9                   	leaveq 
  8039f1:	c3                   	retq   

00000000008039f2 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8039f2:	55                   	push   %rbp
  8039f3:	48 89 e5             	mov    %rsp,%rbp
  8039f6:	48 83 ec 40          	sub    $0x40,%rsp
  8039fa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039fe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a02:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803a06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a0a:	48 89 c7             	mov    %rax,%rdi
  803a0d:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  803a14:	00 00 00 
  803a17:	ff d0                	callq  *%rax
  803a19:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a1d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a21:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a25:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a2c:	00 
  803a2d:	e9 92 00 00 00       	jmpq   803ac4 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803a32:	eb 41                	jmp    803a75 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803a34:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803a39:	74 09                	je     803a44 <devpipe_read+0x52>
				return i;
  803a3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a3f:	e9 92 00 00 00       	jmpq   803ad6 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803a44:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a4c:	48 89 d6             	mov    %rdx,%rsi
  803a4f:	48 89 c7             	mov    %rax,%rdi
  803a52:	48 b8 bb 38 80 00 00 	movabs $0x8038bb,%rax
  803a59:	00 00 00 
  803a5c:	ff d0                	callq  *%rax
  803a5e:	85 c0                	test   %eax,%eax
  803a60:	74 07                	je     803a69 <devpipe_read+0x77>
				return 0;
  803a62:	b8 00 00 00 00       	mov    $0x0,%eax
  803a67:	eb 6d                	jmp    803ad6 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803a69:	48 b8 07 24 80 00 00 	movabs $0x802407,%rax
  803a70:	00 00 00 
  803a73:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803a75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a79:	8b 10                	mov    (%rax),%edx
  803a7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a7f:	8b 40 04             	mov    0x4(%rax),%eax
  803a82:	39 c2                	cmp    %eax,%edx
  803a84:	74 ae                	je     803a34 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803a86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a8a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a8e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803a92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a96:	8b 00                	mov    (%rax),%eax
  803a98:	99                   	cltd   
  803a99:	c1 ea 1b             	shr    $0x1b,%edx
  803a9c:	01 d0                	add    %edx,%eax
  803a9e:	83 e0 1f             	and    $0x1f,%eax
  803aa1:	29 d0                	sub    %edx,%eax
  803aa3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803aa7:	48 98                	cltq   
  803aa9:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803aae:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803ab0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ab4:	8b 00                	mov    (%rax),%eax
  803ab6:	8d 50 01             	lea    0x1(%rax),%edx
  803ab9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803abd:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803abf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ac4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ac8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803acc:	0f 82 60 ff ff ff    	jb     803a32 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803ad2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803ad6:	c9                   	leaveq 
  803ad7:	c3                   	retq   

0000000000803ad8 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803ad8:	55                   	push   %rbp
  803ad9:	48 89 e5             	mov    %rsp,%rbp
  803adc:	48 83 ec 40          	sub    $0x40,%rsp
  803ae0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ae4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ae8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803aec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803af0:	48 89 c7             	mov    %rax,%rdi
  803af3:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  803afa:	00 00 00 
  803afd:	ff d0                	callq  *%rax
  803aff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803b03:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b07:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803b0b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803b12:	00 
  803b13:	e9 8e 00 00 00       	jmpq   803ba6 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b18:	eb 31                	jmp    803b4b <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803b1a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b22:	48 89 d6             	mov    %rdx,%rsi
  803b25:	48 89 c7             	mov    %rax,%rdi
  803b28:	48 b8 bb 38 80 00 00 	movabs $0x8038bb,%rax
  803b2f:	00 00 00 
  803b32:	ff d0                	callq  *%rax
  803b34:	85 c0                	test   %eax,%eax
  803b36:	74 07                	je     803b3f <devpipe_write+0x67>
				return 0;
  803b38:	b8 00 00 00 00       	mov    $0x0,%eax
  803b3d:	eb 79                	jmp    803bb8 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803b3f:	48 b8 07 24 80 00 00 	movabs $0x802407,%rax
  803b46:	00 00 00 
  803b49:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b4f:	8b 40 04             	mov    0x4(%rax),%eax
  803b52:	48 63 d0             	movslq %eax,%rdx
  803b55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b59:	8b 00                	mov    (%rax),%eax
  803b5b:	48 98                	cltq   
  803b5d:	48 83 c0 20          	add    $0x20,%rax
  803b61:	48 39 c2             	cmp    %rax,%rdx
  803b64:	73 b4                	jae    803b1a <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803b66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b6a:	8b 40 04             	mov    0x4(%rax),%eax
  803b6d:	99                   	cltd   
  803b6e:	c1 ea 1b             	shr    $0x1b,%edx
  803b71:	01 d0                	add    %edx,%eax
  803b73:	83 e0 1f             	and    $0x1f,%eax
  803b76:	29 d0                	sub    %edx,%eax
  803b78:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803b7c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803b80:	48 01 ca             	add    %rcx,%rdx
  803b83:	0f b6 0a             	movzbl (%rdx),%ecx
  803b86:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b8a:	48 98                	cltq   
  803b8c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803b90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b94:	8b 40 04             	mov    0x4(%rax),%eax
  803b97:	8d 50 01             	lea    0x1(%rax),%edx
  803b9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b9e:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803ba1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ba6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803baa:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803bae:	0f 82 64 ff ff ff    	jb     803b18 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803bb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803bb8:	c9                   	leaveq 
  803bb9:	c3                   	retq   

0000000000803bba <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803bba:	55                   	push   %rbp
  803bbb:	48 89 e5             	mov    %rsp,%rbp
  803bbe:	48 83 ec 20          	sub    $0x20,%rsp
  803bc2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bc6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803bca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bce:	48 89 c7             	mov    %rax,%rdi
  803bd1:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  803bd8:	00 00 00 
  803bdb:	ff d0                	callq  *%rax
  803bdd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803be1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803be5:	48 be e2 49 80 00 00 	movabs $0x8049e2,%rsi
  803bec:	00 00 00 
  803bef:	48 89 c7             	mov    %rax,%rdi
  803bf2:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  803bf9:	00 00 00 
  803bfc:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803bfe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c02:	8b 50 04             	mov    0x4(%rax),%edx
  803c05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c09:	8b 00                	mov    (%rax),%eax
  803c0b:	29 c2                	sub    %eax,%edx
  803c0d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c11:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803c17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c1b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803c22:	00 00 00 
	stat->st_dev = &devpipe;
  803c25:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c29:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803c30:	00 00 00 
  803c33:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803c3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c3f:	c9                   	leaveq 
  803c40:	c3                   	retq   

0000000000803c41 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803c41:	55                   	push   %rbp
  803c42:	48 89 e5             	mov    %rsp,%rbp
  803c45:	48 83 ec 10          	sub    $0x10,%rsp
  803c49:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803c4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c51:	48 89 c6             	mov    %rax,%rsi
  803c54:	bf 00 00 00 00       	mov    $0x0,%edi
  803c59:	48 b8 f0 24 80 00 00 	movabs $0x8024f0,%rax
  803c60:	00 00 00 
  803c63:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803c65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c69:	48 89 c7             	mov    %rax,%rdi
  803c6c:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  803c73:	00 00 00 
  803c76:	ff d0                	callq  *%rax
  803c78:	48 89 c6             	mov    %rax,%rsi
  803c7b:	bf 00 00 00 00       	mov    $0x0,%edi
  803c80:	48 b8 f0 24 80 00 00 	movabs $0x8024f0,%rax
  803c87:	00 00 00 
  803c8a:	ff d0                	callq  *%rax
}
  803c8c:	c9                   	leaveq 
  803c8d:	c3                   	retq   

0000000000803c8e <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803c8e:	55                   	push   %rbp
  803c8f:	48 89 e5             	mov    %rsp,%rbp
  803c92:	48 83 ec 20          	sub    $0x20,%rsp
  803c96:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803c99:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c9c:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803c9f:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803ca3:	be 01 00 00 00       	mov    $0x1,%esi
  803ca8:	48 89 c7             	mov    %rax,%rdi
  803cab:	48 b8 fd 22 80 00 00 	movabs $0x8022fd,%rax
  803cb2:	00 00 00 
  803cb5:	ff d0                	callq  *%rax
}
  803cb7:	c9                   	leaveq 
  803cb8:	c3                   	retq   

0000000000803cb9 <getchar>:

int
getchar(void)
{
  803cb9:	55                   	push   %rbp
  803cba:	48 89 e5             	mov    %rsp,%rbp
  803cbd:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803cc1:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803cc5:	ba 01 00 00 00       	mov    $0x1,%edx
  803cca:	48 89 c6             	mov    %rax,%rsi
  803ccd:	bf 00 00 00 00       	mov    $0x0,%edi
  803cd2:	48 b8 b4 2d 80 00 00 	movabs $0x802db4,%rax
  803cd9:	00 00 00 
  803cdc:	ff d0                	callq  *%rax
  803cde:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803ce1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ce5:	79 05                	jns    803cec <getchar+0x33>
		return r;
  803ce7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cea:	eb 14                	jmp    803d00 <getchar+0x47>
	if (r < 1)
  803cec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cf0:	7f 07                	jg     803cf9 <getchar+0x40>
		return -E_EOF;
  803cf2:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803cf7:	eb 07                	jmp    803d00 <getchar+0x47>
	return c;
  803cf9:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803cfd:	0f b6 c0             	movzbl %al,%eax
}
  803d00:	c9                   	leaveq 
  803d01:	c3                   	retq   

0000000000803d02 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803d02:	55                   	push   %rbp
  803d03:	48 89 e5             	mov    %rsp,%rbp
  803d06:	48 83 ec 20          	sub    $0x20,%rsp
  803d0a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d0d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803d11:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d14:	48 89 d6             	mov    %rdx,%rsi
  803d17:	89 c7                	mov    %eax,%edi
  803d19:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  803d20:	00 00 00 
  803d23:	ff d0                	callq  *%rax
  803d25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d2c:	79 05                	jns    803d33 <iscons+0x31>
		return r;
  803d2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d31:	eb 1a                	jmp    803d4d <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803d33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d37:	8b 10                	mov    (%rax),%edx
  803d39:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803d40:	00 00 00 
  803d43:	8b 00                	mov    (%rax),%eax
  803d45:	39 c2                	cmp    %eax,%edx
  803d47:	0f 94 c0             	sete   %al
  803d4a:	0f b6 c0             	movzbl %al,%eax
}
  803d4d:	c9                   	leaveq 
  803d4e:	c3                   	retq   

0000000000803d4f <opencons>:

int
opencons(void)
{
  803d4f:	55                   	push   %rbp
  803d50:	48 89 e5             	mov    %rsp,%rbp
  803d53:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803d57:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803d5b:	48 89 c7             	mov    %rax,%rdi
  803d5e:	48 b8 ea 28 80 00 00 	movabs $0x8028ea,%rax
  803d65:	00 00 00 
  803d68:	ff d0                	callq  *%rax
  803d6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d71:	79 05                	jns    803d78 <opencons+0x29>
		return r;
  803d73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d76:	eb 5b                	jmp    803dd3 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803d78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d7c:	ba 07 04 00 00       	mov    $0x407,%edx
  803d81:	48 89 c6             	mov    %rax,%rsi
  803d84:	bf 00 00 00 00       	mov    $0x0,%edi
  803d89:	48 b8 45 24 80 00 00 	movabs $0x802445,%rax
  803d90:	00 00 00 
  803d93:	ff d0                	callq  *%rax
  803d95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d9c:	79 05                	jns    803da3 <opencons+0x54>
		return r;
  803d9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803da1:	eb 30                	jmp    803dd3 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803da3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803da7:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803dae:	00 00 00 
  803db1:	8b 12                	mov    (%rdx),%edx
  803db3:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803db5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803db9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803dc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dc4:	48 89 c7             	mov    %rax,%rdi
  803dc7:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  803dce:	00 00 00 
  803dd1:	ff d0                	callq  *%rax
}
  803dd3:	c9                   	leaveq 
  803dd4:	c3                   	retq   

0000000000803dd5 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803dd5:	55                   	push   %rbp
  803dd6:	48 89 e5             	mov    %rsp,%rbp
  803dd9:	48 83 ec 30          	sub    $0x30,%rsp
  803ddd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803de1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803de5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803de9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803dee:	75 07                	jne    803df7 <devcons_read+0x22>
		return 0;
  803df0:	b8 00 00 00 00       	mov    $0x0,%eax
  803df5:	eb 4b                	jmp    803e42 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803df7:	eb 0c                	jmp    803e05 <devcons_read+0x30>
		sys_yield();
  803df9:	48 b8 07 24 80 00 00 	movabs $0x802407,%rax
  803e00:	00 00 00 
  803e03:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803e05:	48 b8 47 23 80 00 00 	movabs $0x802347,%rax
  803e0c:	00 00 00 
  803e0f:	ff d0                	callq  *%rax
  803e11:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e18:	74 df                	je     803df9 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803e1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e1e:	79 05                	jns    803e25 <devcons_read+0x50>
		return c;
  803e20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e23:	eb 1d                	jmp    803e42 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803e25:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803e29:	75 07                	jne    803e32 <devcons_read+0x5d>
		return 0;
  803e2b:	b8 00 00 00 00       	mov    $0x0,%eax
  803e30:	eb 10                	jmp    803e42 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803e32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e35:	89 c2                	mov    %eax,%edx
  803e37:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e3b:	88 10                	mov    %dl,(%rax)
	return 1;
  803e3d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803e42:	c9                   	leaveq 
  803e43:	c3                   	retq   

0000000000803e44 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e44:	55                   	push   %rbp
  803e45:	48 89 e5             	mov    %rsp,%rbp
  803e48:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803e4f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803e56:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803e5d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e6b:	eb 76                	jmp    803ee3 <devcons_write+0x9f>
		m = n - tot;
  803e6d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803e74:	89 c2                	mov    %eax,%edx
  803e76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e79:	29 c2                	sub    %eax,%edx
  803e7b:	89 d0                	mov    %edx,%eax
  803e7d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803e80:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e83:	83 f8 7f             	cmp    $0x7f,%eax
  803e86:	76 07                	jbe    803e8f <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803e88:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803e8f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e92:	48 63 d0             	movslq %eax,%rdx
  803e95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e98:	48 63 c8             	movslq %eax,%rcx
  803e9b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803ea2:	48 01 c1             	add    %rax,%rcx
  803ea5:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803eac:	48 89 ce             	mov    %rcx,%rsi
  803eaf:	48 89 c7             	mov    %rax,%rdi
  803eb2:	48 b8 3a 1e 80 00 00 	movabs $0x801e3a,%rax
  803eb9:	00 00 00 
  803ebc:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803ebe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ec1:	48 63 d0             	movslq %eax,%rdx
  803ec4:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ecb:	48 89 d6             	mov    %rdx,%rsi
  803ece:	48 89 c7             	mov    %rax,%rdi
  803ed1:	48 b8 fd 22 80 00 00 	movabs $0x8022fd,%rax
  803ed8:	00 00 00 
  803edb:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803edd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ee0:	01 45 fc             	add    %eax,-0x4(%rbp)
  803ee3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ee6:	48 98                	cltq   
  803ee8:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803eef:	0f 82 78 ff ff ff    	jb     803e6d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803ef5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ef8:	c9                   	leaveq 
  803ef9:	c3                   	retq   

0000000000803efa <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803efa:	55                   	push   %rbp
  803efb:	48 89 e5             	mov    %rsp,%rbp
  803efe:	48 83 ec 08          	sub    $0x8,%rsp
  803f02:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803f06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f0b:	c9                   	leaveq 
  803f0c:	c3                   	retq   

0000000000803f0d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803f0d:	55                   	push   %rbp
  803f0e:	48 89 e5             	mov    %rsp,%rbp
  803f11:	48 83 ec 10          	sub    $0x10,%rsp
  803f15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803f19:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803f1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f21:	48 be ee 49 80 00 00 	movabs $0x8049ee,%rsi
  803f28:	00 00 00 
  803f2b:	48 89 c7             	mov    %rax,%rdi
  803f2e:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  803f35:	00 00 00 
  803f38:	ff d0                	callq  *%rax
	return 0;
  803f3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f3f:	c9                   	leaveq 
  803f40:	c3                   	retq   

0000000000803f41 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803f41:	55                   	push   %rbp
  803f42:	48 89 e5             	mov    %rsp,%rbp
  803f45:	48 83 ec 18          	sub    $0x18,%rsp
  803f49:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803f4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f51:	48 c1 e8 15          	shr    $0x15,%rax
  803f55:	48 89 c2             	mov    %rax,%rdx
  803f58:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f5f:	01 00 00 
  803f62:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f66:	83 e0 01             	and    $0x1,%eax
  803f69:	48 85 c0             	test   %rax,%rax
  803f6c:	75 07                	jne    803f75 <pageref+0x34>
		return 0;
  803f6e:	b8 00 00 00 00       	mov    $0x0,%eax
  803f73:	eb 53                	jmp    803fc8 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803f75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f79:	48 c1 e8 0c          	shr    $0xc,%rax
  803f7d:	48 89 c2             	mov    %rax,%rdx
  803f80:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f87:	01 00 00 
  803f8a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f8e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803f92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f96:	83 e0 01             	and    $0x1,%eax
  803f99:	48 85 c0             	test   %rax,%rax
  803f9c:	75 07                	jne    803fa5 <pageref+0x64>
		return 0;
  803f9e:	b8 00 00 00 00       	mov    $0x0,%eax
  803fa3:	eb 23                	jmp    803fc8 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803fa5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fa9:	48 c1 e8 0c          	shr    $0xc,%rax
  803fad:	48 89 c2             	mov    %rax,%rdx
  803fb0:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803fb7:	00 00 00 
  803fba:	48 c1 e2 04          	shl    $0x4,%rdx
  803fbe:	48 01 d0             	add    %rdx,%rax
  803fc1:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803fc5:	0f b7 c0             	movzwl %ax,%eax
}
  803fc8:	c9                   	leaveq 
  803fc9:	c3                   	retq   
