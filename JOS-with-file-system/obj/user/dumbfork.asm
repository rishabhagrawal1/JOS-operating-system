
obj/user/dumbfork.debug:     file format elf64-x86-64


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
  80003c:	e8 1c 03 00 00       	callq  80035d <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

envid_t dumbfork(void);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	envid_t who;
	int i;

	// fork a child process
	who = dumbfork();
  800052:	48 b8 03 02 80 00 00 	movabs $0x800203,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  800061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800068:	eb 4f                	jmp    8000b9 <umain+0x76>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  80006a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80006e:	74 0c                	je     80007c <umain+0x39>
  800070:	48 b8 c0 36 80 00 00 	movabs $0x8036c0,%rax
  800077:	00 00 00 
  80007a:	eb 0a                	jmp    800086 <umain+0x43>
  80007c:	48 b8 c7 36 80 00 00 	movabs $0x8036c7,%rax
  800083:	00 00 00 
  800086:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800089:	48 89 c2             	mov    %rax,%rdx
  80008c:	89 ce                	mov    %ecx,%esi
  80008e:	48 bf cd 36 80 00 00 	movabs $0x8036cd,%rdi
  800095:	00 00 00 
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	48 b9 44 06 80 00 00 	movabs $0x800644,%rcx
  8000a4:	00 00 00 
  8000a7:	ff d1                	callq  *%rcx
		sys_yield();
  8000a9:	48 b8 ea 1a 80 00 00 	movabs $0x801aea,%rax
  8000b0:	00 00 00 
  8000b3:	ff d0                	callq  *%rax

	// fork a child process
	who = dumbfork();

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  8000b5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8000b9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000bd:	74 07                	je     8000c6 <umain+0x83>
  8000bf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8000c4:	eb 05                	jmp    8000cb <umain+0x88>
  8000c6:	b8 14 00 00 00       	mov    $0x14,%eax
  8000cb:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8000ce:	7f 9a                	jg     80006a <umain+0x27>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
		sys_yield();
	}
}
  8000d0:	c9                   	leaveq 
  8000d1:	c3                   	retq   

00000000008000d2 <duppage>:

void
duppage(envid_t dstenv, void *addr)
{
  8000d2:	55                   	push   %rbp
  8000d3:	48 89 e5             	mov    %rsp,%rbp
  8000d6:	48 83 ec 20          	sub    $0x20,%rsp
  8000da:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8000dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  8000e1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8000e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000e8:	ba 07 00 00 00       	mov    $0x7,%edx
  8000ed:	48 89 ce             	mov    %rcx,%rsi
  8000f0:	89 c7                	mov    %eax,%edi
  8000f2:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  8000f9:	00 00 00 
  8000fc:	ff d0                	callq  *%rax
  8000fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800101:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800105:	79 30                	jns    800137 <duppage+0x65>
		panic("sys_page_alloc: %e", r);
  800107:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80010a:	89 c1                	mov    %eax,%ecx
  80010c:	48 ba df 36 80 00 00 	movabs $0x8036df,%rdx
  800113:	00 00 00 
  800116:	be 20 00 00 00       	mov    $0x20,%esi
  80011b:	48 bf f2 36 80 00 00 	movabs $0x8036f2,%rdi
  800122:	00 00 00 
  800125:	b8 00 00 00 00       	mov    $0x0,%eax
  80012a:	49 b8 0b 04 80 00 00 	movabs $0x80040b,%r8
  800131:	00 00 00 
  800134:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800137:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80013b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80013e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  800144:	b9 00 00 40 00       	mov    $0x400000,%ecx
  800149:	ba 00 00 00 00       	mov    $0x0,%edx
  80014e:	89 c7                	mov    %eax,%edi
  800150:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  800157:	00 00 00 
  80015a:	ff d0                	callq  *%rax
  80015c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80015f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800163:	79 30                	jns    800195 <duppage+0xc3>
		panic("sys_page_map: %e", r);
  800165:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800168:	89 c1                	mov    %eax,%ecx
  80016a:	48 ba 02 37 80 00 00 	movabs $0x803702,%rdx
  800171:	00 00 00 
  800174:	be 22 00 00 00       	mov    $0x22,%esi
  800179:	48 bf f2 36 80 00 00 	movabs $0x8036f2,%rdi
  800180:	00 00 00 
  800183:	b8 00 00 00 00       	mov    $0x0,%eax
  800188:	49 b8 0b 04 80 00 00 	movabs $0x80040b,%r8
  80018f:	00 00 00 
  800192:	41 ff d0             	callq  *%r8
	memmove(UTEMP, addr, PGSIZE);
  800195:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800199:	ba 00 10 00 00       	mov    $0x1000,%edx
  80019e:	48 89 c6             	mov    %rax,%rsi
  8001a1:	bf 00 00 40 00       	mov    $0x400000,%edi
  8001a6:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8001b2:	be 00 00 40 00       	mov    $0x400000,%esi
  8001b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001bc:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
  8001c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001cf:	79 30                	jns    800201 <duppage+0x12f>
		panic("sys_page_unmap: %e", r);
  8001d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001d4:	89 c1                	mov    %eax,%ecx
  8001d6:	48 ba 13 37 80 00 00 	movabs $0x803713,%rdx
  8001dd:	00 00 00 
  8001e0:	be 25 00 00 00       	mov    $0x25,%esi
  8001e5:	48 bf f2 36 80 00 00 	movabs $0x8036f2,%rdi
  8001ec:	00 00 00 
  8001ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f4:	49 b8 0b 04 80 00 00 	movabs $0x80040b,%r8
  8001fb:	00 00 00 
  8001fe:	41 ff d0             	callq  *%r8
}
  800201:	c9                   	leaveq 
  800202:	c3                   	retq   

0000000000800203 <dumbfork>:

envid_t
dumbfork(void)
{
  800203:	55                   	push   %rbp
  800204:	48 89 e5             	mov    %rsp,%rbp
  800207:	48 83 ec 20          	sub    $0x20,%rsp
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80020b:	b8 07 00 00 00       	mov    $0x7,%eax
  800210:	cd 30                	int    $0x30
  800212:	89 45 e8             	mov    %eax,-0x18(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  800215:	8b 45 e8             	mov    -0x18(%rbp),%eax
	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
  800218:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (envid < 0)
  80021b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80021f:	79 30                	jns    800251 <dumbfork+0x4e>
		panic("sys_exofork: %e", envid);
  800221:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800224:	89 c1                	mov    %eax,%ecx
  800226:	48 ba 26 37 80 00 00 	movabs $0x803726,%rdx
  80022d:	00 00 00 
  800230:	be 37 00 00 00       	mov    $0x37,%esi
  800235:	48 bf f2 36 80 00 00 	movabs $0x8036f2,%rdi
  80023c:	00 00 00 
  80023f:	b8 00 00 00 00       	mov    $0x0,%eax
  800244:	49 b8 0b 04 80 00 00 	movabs $0x80040b,%r8
  80024b:	00 00 00 
  80024e:	41 ff d0             	callq  *%r8
	if (envid == 0) {
  800251:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800255:	75 46                	jne    80029d <dumbfork+0x9a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  800257:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  80025e:	00 00 00 
  800261:	ff d0                	callq  *%rax
  800263:	25 ff 03 00 00       	and    $0x3ff,%eax
  800268:	48 63 d0             	movslq %eax,%rdx
  80026b:	48 89 d0             	mov    %rdx,%rax
  80026e:	48 c1 e0 03          	shl    $0x3,%rax
  800272:	48 01 d0             	add    %rdx,%rax
  800275:	48 c1 e0 05          	shl    $0x5,%rax
  800279:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800280:	00 00 00 
  800283:	48 01 c2             	add    %rax,%rdx
  800286:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80028d:	00 00 00 
  800290:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  800293:	b8 00 00 00 00       	mov    $0x0,%eax
  800298:	e9 be 00 00 00       	jmpq   80035b <dumbfork+0x158>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  80029d:	48 c7 45 e0 00 00 80 	movq   $0x800000,-0x20(%rbp)
  8002a4:	00 
  8002a5:	eb 26                	jmp    8002cd <dumbfork+0xca>
		duppage(envid, addr);
  8002a7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8002ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ae:	48 89 d6             	mov    %rdx,%rsi
  8002b1:	89 c7                	mov    %eax,%edi
  8002b3:	48 b8 d2 00 80 00 00 	movabs $0x8000d2,%rax
  8002ba:	00 00 00 
  8002bd:	ff d0                	callq  *%rax
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  8002bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8002c3:	48 05 00 10 00 00    	add    $0x1000,%rax
  8002c9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8002cd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8002d1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8002d8:	00 00 00 
  8002db:	48 39 c2             	cmp    %rax,%rdx
  8002de:	72 c7                	jb     8002a7 <dumbfork+0xa4>
		duppage(envid, addr);

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  8002e0:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8002e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8002e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ec:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8002f2:	48 89 c2             	mov    %rax,%rdx
  8002f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002f8:	48 89 d6             	mov    %rdx,%rsi
  8002fb:	89 c7                	mov    %eax,%edi
  8002fd:	48 b8 d2 00 80 00 00 	movabs $0x8000d2,%rax
  800304:	00 00 00 
  800307:	ff d0                	callq  *%rax

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  800309:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80030c:	be 02 00 00 00       	mov    $0x2,%esi
  800311:	89 c7                	mov    %eax,%edi
  800313:	48 b8 1d 1c 80 00 00 	movabs $0x801c1d,%rax
  80031a:	00 00 00 
  80031d:	ff d0                	callq  *%rax
  80031f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800322:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800326:	79 30                	jns    800358 <dumbfork+0x155>
		panic("sys_env_set_status: %e", r);
  800328:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80032b:	89 c1                	mov    %eax,%ecx
  80032d:	48 ba 36 37 80 00 00 	movabs $0x803736,%rdx
  800334:	00 00 00 
  800337:	be 4c 00 00 00       	mov    $0x4c,%esi
  80033c:	48 bf f2 36 80 00 00 	movabs $0x8036f2,%rdi
  800343:	00 00 00 
  800346:	b8 00 00 00 00       	mov    $0x0,%eax
  80034b:	49 b8 0b 04 80 00 00 	movabs $0x80040b,%r8
  800352:	00 00 00 
  800355:	41 ff d0             	callq  *%r8

	return envid;
  800358:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80035b:	c9                   	leaveq 
  80035c:	c3                   	retq   

000000000080035d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80035d:	55                   	push   %rbp
  80035e:	48 89 e5             	mov    %rsp,%rbp
  800361:	48 83 ec 10          	sub    $0x10,%rsp
  800365:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800368:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80036c:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  800373:	00 00 00 
  800376:	ff d0                	callq  *%rax
  800378:	25 ff 03 00 00       	and    $0x3ff,%eax
  80037d:	48 63 d0             	movslq %eax,%rdx
  800380:	48 89 d0             	mov    %rdx,%rax
  800383:	48 c1 e0 03          	shl    $0x3,%rax
  800387:	48 01 d0             	add    %rdx,%rax
  80038a:	48 c1 e0 05          	shl    $0x5,%rax
  80038e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800395:	00 00 00 
  800398:	48 01 c2             	add    %rax,%rdx
  80039b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8003a2:	00 00 00 
  8003a5:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003ac:	7e 14                	jle    8003c2 <libmain+0x65>
		binaryname = argv[0];
  8003ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b2:	48 8b 10             	mov    (%rax),%rdx
  8003b5:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8003bc:	00 00 00 
  8003bf:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c9:	48 89 d6             	mov    %rdx,%rsi
  8003cc:	89 c7                	mov    %eax,%edi
  8003ce:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003d5:	00 00 00 
  8003d8:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8003da:	48 b8 e8 03 80 00 00 	movabs $0x8003e8,%rax
  8003e1:	00 00 00 
  8003e4:	ff d0                	callq  *%rax
}
  8003e6:	c9                   	leaveq 
  8003e7:	c3                   	retq   

00000000008003e8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003e8:	55                   	push   %rbp
  8003e9:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003ec:	48 b8 d6 20 80 00 00 	movabs $0x8020d6,%rax
  8003f3:	00 00 00 
  8003f6:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8003fd:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  800404:	00 00 00 
  800407:	ff d0                	callq  *%rax

}
  800409:	5d                   	pop    %rbp
  80040a:	c3                   	retq   

000000000080040b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80040b:	55                   	push   %rbp
  80040c:	48 89 e5             	mov    %rsp,%rbp
  80040f:	53                   	push   %rbx
  800410:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800417:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80041e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800424:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80042b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800432:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800439:	84 c0                	test   %al,%al
  80043b:	74 23                	je     800460 <_panic+0x55>
  80043d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800444:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800448:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80044c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800450:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800454:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800458:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80045c:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800460:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800467:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80046e:	00 00 00 
  800471:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800478:	00 00 00 
  80047b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80047f:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800486:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80048d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800494:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80049b:	00 00 00 
  80049e:	48 8b 18             	mov    (%rax),%rbx
  8004a1:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  8004a8:	00 00 00 
  8004ab:	ff d0                	callq  *%rax
  8004ad:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004b3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004ba:	41 89 c8             	mov    %ecx,%r8d
  8004bd:	48 89 d1             	mov    %rdx,%rcx
  8004c0:	48 89 da             	mov    %rbx,%rdx
  8004c3:	89 c6                	mov    %eax,%esi
  8004c5:	48 bf 58 37 80 00 00 	movabs $0x803758,%rdi
  8004cc:	00 00 00 
  8004cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d4:	49 b9 44 06 80 00 00 	movabs $0x800644,%r9
  8004db:	00 00 00 
  8004de:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004e1:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004e8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004ef:	48 89 d6             	mov    %rdx,%rsi
  8004f2:	48 89 c7             	mov    %rax,%rdi
  8004f5:	48 b8 98 05 80 00 00 	movabs $0x800598,%rax
  8004fc:	00 00 00 
  8004ff:	ff d0                	callq  *%rax
	cprintf("\n");
  800501:	48 bf 7b 37 80 00 00 	movabs $0x80377b,%rdi
  800508:	00 00 00 
  80050b:	b8 00 00 00 00       	mov    $0x0,%eax
  800510:	48 ba 44 06 80 00 00 	movabs $0x800644,%rdx
  800517:	00 00 00 
  80051a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80051c:	cc                   	int3   
  80051d:	eb fd                	jmp    80051c <_panic+0x111>

000000000080051f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80051f:	55                   	push   %rbp
  800520:	48 89 e5             	mov    %rsp,%rbp
  800523:	48 83 ec 10          	sub    $0x10,%rsp
  800527:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80052a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80052e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800532:	8b 00                	mov    (%rax),%eax
  800534:	8d 48 01             	lea    0x1(%rax),%ecx
  800537:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80053b:	89 0a                	mov    %ecx,(%rdx)
  80053d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800540:	89 d1                	mov    %edx,%ecx
  800542:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800546:	48 98                	cltq   
  800548:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80054c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800550:	8b 00                	mov    (%rax),%eax
  800552:	3d ff 00 00 00       	cmp    $0xff,%eax
  800557:	75 2c                	jne    800585 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800559:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80055d:	8b 00                	mov    (%rax),%eax
  80055f:	48 98                	cltq   
  800561:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800565:	48 83 c2 08          	add    $0x8,%rdx
  800569:	48 89 c6             	mov    %rax,%rsi
  80056c:	48 89 d7             	mov    %rdx,%rdi
  80056f:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  800576:	00 00 00 
  800579:	ff d0                	callq  *%rax
		b->idx = 0;
  80057b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80057f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800585:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800589:	8b 40 04             	mov    0x4(%rax),%eax
  80058c:	8d 50 01             	lea    0x1(%rax),%edx
  80058f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800593:	89 50 04             	mov    %edx,0x4(%rax)
}
  800596:	c9                   	leaveq 
  800597:	c3                   	retq   

0000000000800598 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800598:	55                   	push   %rbp
  800599:	48 89 e5             	mov    %rsp,%rbp
  80059c:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005a3:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005aa:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8005b1:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005b8:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005bf:	48 8b 0a             	mov    (%rdx),%rcx
  8005c2:	48 89 08             	mov    %rcx,(%rax)
  8005c5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005c9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005cd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005d1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8005d5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005dc:	00 00 00 
	b.cnt = 0;
  8005df:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005e6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8005e9:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005f0:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005f7:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005fe:	48 89 c6             	mov    %rax,%rsi
  800601:	48 bf 1f 05 80 00 00 	movabs $0x80051f,%rdi
  800608:	00 00 00 
  80060b:	48 b8 f7 09 80 00 00 	movabs $0x8009f7,%rax
  800612:	00 00 00 
  800615:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800617:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80061d:	48 98                	cltq   
  80061f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800626:	48 83 c2 08          	add    $0x8,%rdx
  80062a:	48 89 c6             	mov    %rax,%rsi
  80062d:	48 89 d7             	mov    %rdx,%rdi
  800630:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  800637:	00 00 00 
  80063a:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80063c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800642:	c9                   	leaveq 
  800643:	c3                   	retq   

0000000000800644 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800644:	55                   	push   %rbp
  800645:	48 89 e5             	mov    %rsp,%rbp
  800648:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80064f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800656:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80065d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800664:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80066b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800672:	84 c0                	test   %al,%al
  800674:	74 20                	je     800696 <cprintf+0x52>
  800676:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80067a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80067e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800682:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800686:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80068a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80068e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800692:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800696:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80069d:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006a4:	00 00 00 
  8006a7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006ae:	00 00 00 
  8006b1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006b5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006bc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006c3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8006ca:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006d1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006d8:	48 8b 0a             	mov    (%rdx),%rcx
  8006db:	48 89 08             	mov    %rcx,(%rax)
  8006de:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006e2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006e6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006ea:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8006ee:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006f5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006fc:	48 89 d6             	mov    %rdx,%rsi
  8006ff:	48 89 c7             	mov    %rax,%rdi
  800702:	48 b8 98 05 80 00 00 	movabs $0x800598,%rax
  800709:	00 00 00 
  80070c:	ff d0                	callq  *%rax
  80070e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800714:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80071a:	c9                   	leaveq 
  80071b:	c3                   	retq   

000000000080071c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80071c:	55                   	push   %rbp
  80071d:	48 89 e5             	mov    %rsp,%rbp
  800720:	53                   	push   %rbx
  800721:	48 83 ec 38          	sub    $0x38,%rsp
  800725:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800729:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80072d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800731:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800734:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800738:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80073c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80073f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800743:	77 3b                	ja     800780 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800745:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800748:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80074c:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80074f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800753:	ba 00 00 00 00       	mov    $0x0,%edx
  800758:	48 f7 f3             	div    %rbx
  80075b:	48 89 c2             	mov    %rax,%rdx
  80075e:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800761:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800764:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800768:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076c:	41 89 f9             	mov    %edi,%r9d
  80076f:	48 89 c7             	mov    %rax,%rdi
  800772:	48 b8 1c 07 80 00 00 	movabs $0x80071c,%rax
  800779:	00 00 00 
  80077c:	ff d0                	callq  *%rax
  80077e:	eb 1e                	jmp    80079e <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800780:	eb 12                	jmp    800794 <printnum+0x78>
			putch(padc, putdat);
  800782:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800786:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800789:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078d:	48 89 ce             	mov    %rcx,%rsi
  800790:	89 d7                	mov    %edx,%edi
  800792:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800794:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800798:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80079c:	7f e4                	jg     800782 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80079e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8007a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007aa:	48 f7 f1             	div    %rcx
  8007ad:	48 89 d0             	mov    %rdx,%rax
  8007b0:	48 ba 48 39 80 00 00 	movabs $0x803948,%rdx
  8007b7:	00 00 00 
  8007ba:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007be:	0f be d0             	movsbl %al,%edx
  8007c1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c9:	48 89 ce             	mov    %rcx,%rsi
  8007cc:	89 d7                	mov    %edx,%edi
  8007ce:	ff d0                	callq  *%rax
}
  8007d0:	48 83 c4 38          	add    $0x38,%rsp
  8007d4:	5b                   	pop    %rbx
  8007d5:	5d                   	pop    %rbp
  8007d6:	c3                   	retq   

00000000008007d7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007d7:	55                   	push   %rbp
  8007d8:	48 89 e5             	mov    %rsp,%rbp
  8007db:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007e3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007e6:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007ea:	7e 52                	jle    80083e <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f0:	8b 00                	mov    (%rax),%eax
  8007f2:	83 f8 30             	cmp    $0x30,%eax
  8007f5:	73 24                	jae    80081b <getuint+0x44>
  8007f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800803:	8b 00                	mov    (%rax),%eax
  800805:	89 c0                	mov    %eax,%eax
  800807:	48 01 d0             	add    %rdx,%rax
  80080a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080e:	8b 12                	mov    (%rdx),%edx
  800810:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800813:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800817:	89 0a                	mov    %ecx,(%rdx)
  800819:	eb 17                	jmp    800832 <getuint+0x5b>
  80081b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800823:	48 89 d0             	mov    %rdx,%rax
  800826:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80082a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800832:	48 8b 00             	mov    (%rax),%rax
  800835:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800839:	e9 a3 00 00 00       	jmpq   8008e1 <getuint+0x10a>
	else if (lflag)
  80083e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800842:	74 4f                	je     800893 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800844:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800848:	8b 00                	mov    (%rax),%eax
  80084a:	83 f8 30             	cmp    $0x30,%eax
  80084d:	73 24                	jae    800873 <getuint+0x9c>
  80084f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800853:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800857:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085b:	8b 00                	mov    (%rax),%eax
  80085d:	89 c0                	mov    %eax,%eax
  80085f:	48 01 d0             	add    %rdx,%rax
  800862:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800866:	8b 12                	mov    (%rdx),%edx
  800868:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80086b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086f:	89 0a                	mov    %ecx,(%rdx)
  800871:	eb 17                	jmp    80088a <getuint+0xb3>
  800873:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800877:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80087b:	48 89 d0             	mov    %rdx,%rax
  80087e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800882:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800886:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80088a:	48 8b 00             	mov    (%rax),%rax
  80088d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800891:	eb 4e                	jmp    8008e1 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800893:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800897:	8b 00                	mov    (%rax),%eax
  800899:	83 f8 30             	cmp    $0x30,%eax
  80089c:	73 24                	jae    8008c2 <getuint+0xeb>
  80089e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008aa:	8b 00                	mov    (%rax),%eax
  8008ac:	89 c0                	mov    %eax,%eax
  8008ae:	48 01 d0             	add    %rdx,%rax
  8008b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b5:	8b 12                	mov    (%rdx),%edx
  8008b7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008be:	89 0a                	mov    %ecx,(%rdx)
  8008c0:	eb 17                	jmp    8008d9 <getuint+0x102>
  8008c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008ca:	48 89 d0             	mov    %rdx,%rax
  8008cd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008d9:	8b 00                	mov    (%rax),%eax
  8008db:	89 c0                	mov    %eax,%eax
  8008dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008e5:	c9                   	leaveq 
  8008e6:	c3                   	retq   

00000000008008e7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008e7:	55                   	push   %rbp
  8008e8:	48 89 e5             	mov    %rsp,%rbp
  8008eb:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008f3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008f6:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008fa:	7e 52                	jle    80094e <getint+0x67>
		x=va_arg(*ap, long long);
  8008fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800900:	8b 00                	mov    (%rax),%eax
  800902:	83 f8 30             	cmp    $0x30,%eax
  800905:	73 24                	jae    80092b <getint+0x44>
  800907:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80090f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800913:	8b 00                	mov    (%rax),%eax
  800915:	89 c0                	mov    %eax,%eax
  800917:	48 01 d0             	add    %rdx,%rax
  80091a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091e:	8b 12                	mov    (%rdx),%edx
  800920:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800923:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800927:	89 0a                	mov    %ecx,(%rdx)
  800929:	eb 17                	jmp    800942 <getint+0x5b>
  80092b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800933:	48 89 d0             	mov    %rdx,%rax
  800936:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80093a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800942:	48 8b 00             	mov    (%rax),%rax
  800945:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800949:	e9 a3 00 00 00       	jmpq   8009f1 <getint+0x10a>
	else if (lflag)
  80094e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800952:	74 4f                	je     8009a3 <getint+0xbc>
		x=va_arg(*ap, long);
  800954:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800958:	8b 00                	mov    (%rax),%eax
  80095a:	83 f8 30             	cmp    $0x30,%eax
  80095d:	73 24                	jae    800983 <getint+0x9c>
  80095f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800963:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800967:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096b:	8b 00                	mov    (%rax),%eax
  80096d:	89 c0                	mov    %eax,%eax
  80096f:	48 01 d0             	add    %rdx,%rax
  800972:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800976:	8b 12                	mov    (%rdx),%edx
  800978:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80097b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097f:	89 0a                	mov    %ecx,(%rdx)
  800981:	eb 17                	jmp    80099a <getint+0xb3>
  800983:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800987:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80098b:	48 89 d0             	mov    %rdx,%rax
  80098e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800992:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800996:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80099a:	48 8b 00             	mov    (%rax),%rax
  80099d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009a1:	eb 4e                	jmp    8009f1 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a7:	8b 00                	mov    (%rax),%eax
  8009a9:	83 f8 30             	cmp    $0x30,%eax
  8009ac:	73 24                	jae    8009d2 <getint+0xeb>
  8009ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ba:	8b 00                	mov    (%rax),%eax
  8009bc:	89 c0                	mov    %eax,%eax
  8009be:	48 01 d0             	add    %rdx,%rax
  8009c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c5:	8b 12                	mov    (%rdx),%edx
  8009c7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ce:	89 0a                	mov    %ecx,(%rdx)
  8009d0:	eb 17                	jmp    8009e9 <getint+0x102>
  8009d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009da:	48 89 d0             	mov    %rdx,%rax
  8009dd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009e9:	8b 00                	mov    (%rax),%eax
  8009eb:	48 98                	cltq   
  8009ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009f5:	c9                   	leaveq 
  8009f6:	c3                   	retq   

00000000008009f7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009f7:	55                   	push   %rbp
  8009f8:	48 89 e5             	mov    %rsp,%rbp
  8009fb:	41 54                	push   %r12
  8009fd:	53                   	push   %rbx
  8009fe:	48 83 ec 60          	sub    $0x60,%rsp
  800a02:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a06:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a0a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a0e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a12:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a16:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a1a:	48 8b 0a             	mov    (%rdx),%rcx
  800a1d:	48 89 08             	mov    %rcx,(%rax)
  800a20:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a24:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a28:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a2c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a30:	eb 17                	jmp    800a49 <vprintfmt+0x52>
			if (ch == '\0')
  800a32:	85 db                	test   %ebx,%ebx
  800a34:	0f 84 cc 04 00 00    	je     800f06 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800a3a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a3e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a42:	48 89 d6             	mov    %rdx,%rsi
  800a45:	89 df                	mov    %ebx,%edi
  800a47:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a49:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a4d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a51:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a55:	0f b6 00             	movzbl (%rax),%eax
  800a58:	0f b6 d8             	movzbl %al,%ebx
  800a5b:	83 fb 25             	cmp    $0x25,%ebx
  800a5e:	75 d2                	jne    800a32 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a60:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a64:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a6b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a72:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a79:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a80:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a84:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a88:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a8c:	0f b6 00             	movzbl (%rax),%eax
  800a8f:	0f b6 d8             	movzbl %al,%ebx
  800a92:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a95:	83 f8 55             	cmp    $0x55,%eax
  800a98:	0f 87 34 04 00 00    	ja     800ed2 <vprintfmt+0x4db>
  800a9e:	89 c0                	mov    %eax,%eax
  800aa0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800aa7:	00 
  800aa8:	48 b8 70 39 80 00 00 	movabs $0x803970,%rax
  800aaf:	00 00 00 
  800ab2:	48 01 d0             	add    %rdx,%rax
  800ab5:	48 8b 00             	mov    (%rax),%rax
  800ab8:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800aba:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800abe:	eb c0                	jmp    800a80 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ac0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800ac4:	eb ba                	jmp    800a80 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800acd:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ad0:	89 d0                	mov    %edx,%eax
  800ad2:	c1 e0 02             	shl    $0x2,%eax
  800ad5:	01 d0                	add    %edx,%eax
  800ad7:	01 c0                	add    %eax,%eax
  800ad9:	01 d8                	add    %ebx,%eax
  800adb:	83 e8 30             	sub    $0x30,%eax
  800ade:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ae1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ae5:	0f b6 00             	movzbl (%rax),%eax
  800ae8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800aeb:	83 fb 2f             	cmp    $0x2f,%ebx
  800aee:	7e 0c                	jle    800afc <vprintfmt+0x105>
  800af0:	83 fb 39             	cmp    $0x39,%ebx
  800af3:	7f 07                	jg     800afc <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800af5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800afa:	eb d1                	jmp    800acd <vprintfmt+0xd6>
			goto process_precision;
  800afc:	eb 58                	jmp    800b56 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800afe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b01:	83 f8 30             	cmp    $0x30,%eax
  800b04:	73 17                	jae    800b1d <vprintfmt+0x126>
  800b06:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b0a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0d:	89 c0                	mov    %eax,%eax
  800b0f:	48 01 d0             	add    %rdx,%rax
  800b12:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b15:	83 c2 08             	add    $0x8,%edx
  800b18:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b1b:	eb 0f                	jmp    800b2c <vprintfmt+0x135>
  800b1d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b21:	48 89 d0             	mov    %rdx,%rax
  800b24:	48 83 c2 08          	add    $0x8,%rdx
  800b28:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b2c:	8b 00                	mov    (%rax),%eax
  800b2e:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b31:	eb 23                	jmp    800b56 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b33:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b37:	79 0c                	jns    800b45 <vprintfmt+0x14e>
				width = 0;
  800b39:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b40:	e9 3b ff ff ff       	jmpq   800a80 <vprintfmt+0x89>
  800b45:	e9 36 ff ff ff       	jmpq   800a80 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b4a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b51:	e9 2a ff ff ff       	jmpq   800a80 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b56:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b5a:	79 12                	jns    800b6e <vprintfmt+0x177>
				width = precision, precision = -1;
  800b5c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b5f:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b62:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b69:	e9 12 ff ff ff       	jmpq   800a80 <vprintfmt+0x89>
  800b6e:	e9 0d ff ff ff       	jmpq   800a80 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b73:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b77:	e9 04 ff ff ff       	jmpq   800a80 <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b7c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b7f:	83 f8 30             	cmp    $0x30,%eax
  800b82:	73 17                	jae    800b9b <vprintfmt+0x1a4>
  800b84:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b88:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b8b:	89 c0                	mov    %eax,%eax
  800b8d:	48 01 d0             	add    %rdx,%rax
  800b90:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b93:	83 c2 08             	add    $0x8,%edx
  800b96:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b99:	eb 0f                	jmp    800baa <vprintfmt+0x1b3>
  800b9b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b9f:	48 89 d0             	mov    %rdx,%rax
  800ba2:	48 83 c2 08          	add    $0x8,%rdx
  800ba6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800baa:	8b 10                	mov    (%rax),%edx
  800bac:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bb0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb4:	48 89 ce             	mov    %rcx,%rsi
  800bb7:	89 d7                	mov    %edx,%edi
  800bb9:	ff d0                	callq  *%rax
			break;
  800bbb:	e9 40 03 00 00       	jmpq   800f00 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800bc0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc3:	83 f8 30             	cmp    $0x30,%eax
  800bc6:	73 17                	jae    800bdf <vprintfmt+0x1e8>
  800bc8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bcc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bcf:	89 c0                	mov    %eax,%eax
  800bd1:	48 01 d0             	add    %rdx,%rax
  800bd4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd7:	83 c2 08             	add    $0x8,%edx
  800bda:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bdd:	eb 0f                	jmp    800bee <vprintfmt+0x1f7>
  800bdf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be3:	48 89 d0             	mov    %rdx,%rax
  800be6:	48 83 c2 08          	add    $0x8,%rdx
  800bea:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bee:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bf0:	85 db                	test   %ebx,%ebx
  800bf2:	79 02                	jns    800bf6 <vprintfmt+0x1ff>
				err = -err;
  800bf4:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bf6:	83 fb 10             	cmp    $0x10,%ebx
  800bf9:	7f 16                	jg     800c11 <vprintfmt+0x21a>
  800bfb:	48 b8 c0 38 80 00 00 	movabs $0x8038c0,%rax
  800c02:	00 00 00 
  800c05:	48 63 d3             	movslq %ebx,%rdx
  800c08:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c0c:	4d 85 e4             	test   %r12,%r12
  800c0f:	75 2e                	jne    800c3f <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800c11:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c15:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c19:	89 d9                	mov    %ebx,%ecx
  800c1b:	48 ba 59 39 80 00 00 	movabs $0x803959,%rdx
  800c22:	00 00 00 
  800c25:	48 89 c7             	mov    %rax,%rdi
  800c28:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2d:	49 b8 0f 0f 80 00 00 	movabs $0x800f0f,%r8
  800c34:	00 00 00 
  800c37:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c3a:	e9 c1 02 00 00       	jmpq   800f00 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c3f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c43:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c47:	4c 89 e1             	mov    %r12,%rcx
  800c4a:	48 ba 62 39 80 00 00 	movabs $0x803962,%rdx
  800c51:	00 00 00 
  800c54:	48 89 c7             	mov    %rax,%rdi
  800c57:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5c:	49 b8 0f 0f 80 00 00 	movabs $0x800f0f,%r8
  800c63:	00 00 00 
  800c66:	41 ff d0             	callq  *%r8
			break;
  800c69:	e9 92 02 00 00       	jmpq   800f00 <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c6e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c71:	83 f8 30             	cmp    $0x30,%eax
  800c74:	73 17                	jae    800c8d <vprintfmt+0x296>
  800c76:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c7a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7d:	89 c0                	mov    %eax,%eax
  800c7f:	48 01 d0             	add    %rdx,%rax
  800c82:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c85:	83 c2 08             	add    $0x8,%edx
  800c88:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c8b:	eb 0f                	jmp    800c9c <vprintfmt+0x2a5>
  800c8d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c91:	48 89 d0             	mov    %rdx,%rax
  800c94:	48 83 c2 08          	add    $0x8,%rdx
  800c98:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c9c:	4c 8b 20             	mov    (%rax),%r12
  800c9f:	4d 85 e4             	test   %r12,%r12
  800ca2:	75 0a                	jne    800cae <vprintfmt+0x2b7>
				p = "(null)";
  800ca4:	49 bc 65 39 80 00 00 	movabs $0x803965,%r12
  800cab:	00 00 00 
			if (width > 0 && padc != '-')
  800cae:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cb2:	7e 3f                	jle    800cf3 <vprintfmt+0x2fc>
  800cb4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cb8:	74 39                	je     800cf3 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cba:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cbd:	48 98                	cltq   
  800cbf:	48 89 c6             	mov    %rax,%rsi
  800cc2:	4c 89 e7             	mov    %r12,%rdi
  800cc5:	48 b8 bb 11 80 00 00 	movabs $0x8011bb,%rax
  800ccc:	00 00 00 
  800ccf:	ff d0                	callq  *%rax
  800cd1:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cd4:	eb 17                	jmp    800ced <vprintfmt+0x2f6>
					putch(padc, putdat);
  800cd6:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cda:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cde:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce2:	48 89 ce             	mov    %rcx,%rsi
  800ce5:	89 d7                	mov    %edx,%edi
  800ce7:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ce9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ced:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cf1:	7f e3                	jg     800cd6 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cf3:	eb 37                	jmp    800d2c <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800cf5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cf9:	74 1e                	je     800d19 <vprintfmt+0x322>
  800cfb:	83 fb 1f             	cmp    $0x1f,%ebx
  800cfe:	7e 05                	jle    800d05 <vprintfmt+0x30e>
  800d00:	83 fb 7e             	cmp    $0x7e,%ebx
  800d03:	7e 14                	jle    800d19 <vprintfmt+0x322>
					putch('?', putdat);
  800d05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d0d:	48 89 d6             	mov    %rdx,%rsi
  800d10:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d15:	ff d0                	callq  *%rax
  800d17:	eb 0f                	jmp    800d28 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800d19:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d21:	48 89 d6             	mov    %rdx,%rsi
  800d24:	89 df                	mov    %ebx,%edi
  800d26:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d28:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d2c:	4c 89 e0             	mov    %r12,%rax
  800d2f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d33:	0f b6 00             	movzbl (%rax),%eax
  800d36:	0f be d8             	movsbl %al,%ebx
  800d39:	85 db                	test   %ebx,%ebx
  800d3b:	74 10                	je     800d4d <vprintfmt+0x356>
  800d3d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d41:	78 b2                	js     800cf5 <vprintfmt+0x2fe>
  800d43:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d47:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d4b:	79 a8                	jns    800cf5 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d4d:	eb 16                	jmp    800d65 <vprintfmt+0x36e>
				putch(' ', putdat);
  800d4f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d53:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d57:	48 89 d6             	mov    %rdx,%rsi
  800d5a:	bf 20 00 00 00       	mov    $0x20,%edi
  800d5f:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d61:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d65:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d69:	7f e4                	jg     800d4f <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d6b:	e9 90 01 00 00       	jmpq   800f00 <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d70:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d74:	be 03 00 00 00       	mov    $0x3,%esi
  800d79:	48 89 c7             	mov    %rax,%rdi
  800d7c:	48 b8 e7 08 80 00 00 	movabs $0x8008e7,%rax
  800d83:	00 00 00 
  800d86:	ff d0                	callq  *%rax
  800d88:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d90:	48 85 c0             	test   %rax,%rax
  800d93:	79 1d                	jns    800db2 <vprintfmt+0x3bb>
				putch('-', putdat);
  800d95:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d99:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9d:	48 89 d6             	mov    %rdx,%rsi
  800da0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800da5:	ff d0                	callq  *%rax
				num = -(long long) num;
  800da7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dab:	48 f7 d8             	neg    %rax
  800dae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800db2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800db9:	e9 d5 00 00 00       	jmpq   800e93 <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800dbe:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dc2:	be 03 00 00 00       	mov    $0x3,%esi
  800dc7:	48 89 c7             	mov    %rax,%rdi
  800dca:	48 b8 d7 07 80 00 00 	movabs $0x8007d7,%rax
  800dd1:	00 00 00 
  800dd4:	ff d0                	callq  *%rax
  800dd6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800dda:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800de1:	e9 ad 00 00 00       	jmpq   800e93 <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800de6:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800de9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ded:	89 d6                	mov    %edx,%esi
  800def:	48 89 c7             	mov    %rax,%rdi
  800df2:	48 b8 e7 08 80 00 00 	movabs $0x8008e7,%rax
  800df9:	00 00 00 
  800dfc:	ff d0                	callq  *%rax
  800dfe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800e02:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800e09:	e9 85 00 00 00       	jmpq   800e93 <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  800e0e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e16:	48 89 d6             	mov    %rdx,%rsi
  800e19:	bf 30 00 00 00       	mov    $0x30,%edi
  800e1e:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e20:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e24:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e28:	48 89 d6             	mov    %rdx,%rsi
  800e2b:	bf 78 00 00 00       	mov    $0x78,%edi
  800e30:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e32:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e35:	83 f8 30             	cmp    $0x30,%eax
  800e38:	73 17                	jae    800e51 <vprintfmt+0x45a>
  800e3a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e3e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e41:	89 c0                	mov    %eax,%eax
  800e43:	48 01 d0             	add    %rdx,%rax
  800e46:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e49:	83 c2 08             	add    $0x8,%edx
  800e4c:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e4f:	eb 0f                	jmp    800e60 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800e51:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e55:	48 89 d0             	mov    %rdx,%rax
  800e58:	48 83 c2 08          	add    $0x8,%rdx
  800e5c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e60:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e63:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e67:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e6e:	eb 23                	jmp    800e93 <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e70:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e74:	be 03 00 00 00       	mov    $0x3,%esi
  800e79:	48 89 c7             	mov    %rax,%rdi
  800e7c:	48 b8 d7 07 80 00 00 	movabs $0x8007d7,%rax
  800e83:	00 00 00 
  800e86:	ff d0                	callq  *%rax
  800e88:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e8c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e93:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e98:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e9b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e9e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ea2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ea6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eaa:	45 89 c1             	mov    %r8d,%r9d
  800ead:	41 89 f8             	mov    %edi,%r8d
  800eb0:	48 89 c7             	mov    %rax,%rdi
  800eb3:	48 b8 1c 07 80 00 00 	movabs $0x80071c,%rax
  800eba:	00 00 00 
  800ebd:	ff d0                	callq  *%rax
			break;
  800ebf:	eb 3f                	jmp    800f00 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ec1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ec5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ec9:	48 89 d6             	mov    %rdx,%rsi
  800ecc:	89 df                	mov    %ebx,%edi
  800ece:	ff d0                	callq  *%rax
			break;
  800ed0:	eb 2e                	jmp    800f00 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ed2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ed6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eda:	48 89 d6             	mov    %rdx,%rsi
  800edd:	bf 25 00 00 00       	mov    $0x25,%edi
  800ee2:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ee4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ee9:	eb 05                	jmp    800ef0 <vprintfmt+0x4f9>
  800eeb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ef0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ef4:	48 83 e8 01          	sub    $0x1,%rax
  800ef8:	0f b6 00             	movzbl (%rax),%eax
  800efb:	3c 25                	cmp    $0x25,%al
  800efd:	75 ec                	jne    800eeb <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800eff:	90                   	nop
		}
	}
  800f00:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f01:	e9 43 fb ff ff       	jmpq   800a49 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800f06:	48 83 c4 60          	add    $0x60,%rsp
  800f0a:	5b                   	pop    %rbx
  800f0b:	41 5c                	pop    %r12
  800f0d:	5d                   	pop    %rbp
  800f0e:	c3                   	retq   

0000000000800f0f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f0f:	55                   	push   %rbp
  800f10:	48 89 e5             	mov    %rsp,%rbp
  800f13:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f1a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f21:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f28:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f2f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f36:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f3d:	84 c0                	test   %al,%al
  800f3f:	74 20                	je     800f61 <printfmt+0x52>
  800f41:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f45:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f49:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f4d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f51:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f55:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f59:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f5d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f61:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f68:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f6f:	00 00 00 
  800f72:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f79:	00 00 00 
  800f7c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f80:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f87:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f8e:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f95:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f9c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fa3:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800faa:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fb1:	48 89 c7             	mov    %rax,%rdi
  800fb4:	48 b8 f7 09 80 00 00 	movabs $0x8009f7,%rax
  800fbb:	00 00 00 
  800fbe:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fc0:	c9                   	leaveq 
  800fc1:	c3                   	retq   

0000000000800fc2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fc2:	55                   	push   %rbp
  800fc3:	48 89 e5             	mov    %rsp,%rbp
  800fc6:	48 83 ec 10          	sub    $0x10,%rsp
  800fca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fcd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd5:	8b 40 10             	mov    0x10(%rax),%eax
  800fd8:	8d 50 01             	lea    0x1(%rax),%edx
  800fdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fdf:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fe2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe6:	48 8b 10             	mov    (%rax),%rdx
  800fe9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fed:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ff1:	48 39 c2             	cmp    %rax,%rdx
  800ff4:	73 17                	jae    80100d <sprintputch+0x4b>
		*b->buf++ = ch;
  800ff6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ffa:	48 8b 00             	mov    (%rax),%rax
  800ffd:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801001:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801005:	48 89 0a             	mov    %rcx,(%rdx)
  801008:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80100b:	88 10                	mov    %dl,(%rax)
}
  80100d:	c9                   	leaveq 
  80100e:	c3                   	retq   

000000000080100f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80100f:	55                   	push   %rbp
  801010:	48 89 e5             	mov    %rsp,%rbp
  801013:	48 83 ec 50          	sub    $0x50,%rsp
  801017:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80101b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80101e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801022:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801026:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80102a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80102e:	48 8b 0a             	mov    (%rdx),%rcx
  801031:	48 89 08             	mov    %rcx,(%rax)
  801034:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801038:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80103c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801040:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801044:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801048:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80104c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80104f:	48 98                	cltq   
  801051:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801055:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801059:	48 01 d0             	add    %rdx,%rax
  80105c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801060:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801067:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80106c:	74 06                	je     801074 <vsnprintf+0x65>
  80106e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801072:	7f 07                	jg     80107b <vsnprintf+0x6c>
		return -E_INVAL;
  801074:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801079:	eb 2f                	jmp    8010aa <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80107b:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80107f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801083:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801087:	48 89 c6             	mov    %rax,%rsi
  80108a:	48 bf c2 0f 80 00 00 	movabs $0x800fc2,%rdi
  801091:	00 00 00 
  801094:	48 b8 f7 09 80 00 00 	movabs $0x8009f7,%rax
  80109b:	00 00 00 
  80109e:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010a0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010a4:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010a7:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010aa:	c9                   	leaveq 
  8010ab:	c3                   	retq   

00000000008010ac <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010ac:	55                   	push   %rbp
  8010ad:	48 89 e5             	mov    %rsp,%rbp
  8010b0:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010b7:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010be:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010c4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010cb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010d2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010d9:	84 c0                	test   %al,%al
  8010db:	74 20                	je     8010fd <snprintf+0x51>
  8010dd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010e1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010e5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010e9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010ed:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010f1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010f5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010f9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010fd:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801104:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80110b:	00 00 00 
  80110e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801115:	00 00 00 
  801118:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80111c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801123:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80112a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801131:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801138:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80113f:	48 8b 0a             	mov    (%rdx),%rcx
  801142:	48 89 08             	mov    %rcx,(%rax)
  801145:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801149:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80114d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801151:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801155:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80115c:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801163:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801169:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801170:	48 89 c7             	mov    %rax,%rdi
  801173:	48 b8 0f 10 80 00 00 	movabs $0x80100f,%rax
  80117a:	00 00 00 
  80117d:	ff d0                	callq  *%rax
  80117f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801185:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80118b:	c9                   	leaveq 
  80118c:	c3                   	retq   

000000000080118d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80118d:	55                   	push   %rbp
  80118e:	48 89 e5             	mov    %rsp,%rbp
  801191:	48 83 ec 18          	sub    $0x18,%rsp
  801195:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801199:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011a0:	eb 09                	jmp    8011ab <strlen+0x1e>
		n++;
  8011a2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011a6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011af:	0f b6 00             	movzbl (%rax),%eax
  8011b2:	84 c0                	test   %al,%al
  8011b4:	75 ec                	jne    8011a2 <strlen+0x15>
		n++;
	return n;
  8011b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011b9:	c9                   	leaveq 
  8011ba:	c3                   	retq   

00000000008011bb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011bb:	55                   	push   %rbp
  8011bc:	48 89 e5             	mov    %rsp,%rbp
  8011bf:	48 83 ec 20          	sub    $0x20,%rsp
  8011c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011d2:	eb 0e                	jmp    8011e2 <strnlen+0x27>
		n++;
  8011d4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011d8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011dd:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011e2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011e7:	74 0b                	je     8011f4 <strnlen+0x39>
  8011e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ed:	0f b6 00             	movzbl (%rax),%eax
  8011f0:	84 c0                	test   %al,%al
  8011f2:	75 e0                	jne    8011d4 <strnlen+0x19>
		n++;
	return n;
  8011f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011f7:	c9                   	leaveq 
  8011f8:	c3                   	retq   

00000000008011f9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011f9:	55                   	push   %rbp
  8011fa:	48 89 e5             	mov    %rsp,%rbp
  8011fd:	48 83 ec 20          	sub    $0x20,%rsp
  801201:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801205:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801209:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801211:	90                   	nop
  801212:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801216:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80121a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80121e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801222:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801226:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80122a:	0f b6 12             	movzbl (%rdx),%edx
  80122d:	88 10                	mov    %dl,(%rax)
  80122f:	0f b6 00             	movzbl (%rax),%eax
  801232:	84 c0                	test   %al,%al
  801234:	75 dc                	jne    801212 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801236:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80123a:	c9                   	leaveq 
  80123b:	c3                   	retq   

000000000080123c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80123c:	55                   	push   %rbp
  80123d:	48 89 e5             	mov    %rsp,%rbp
  801240:	48 83 ec 20          	sub    $0x20,%rsp
  801244:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801248:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80124c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801250:	48 89 c7             	mov    %rax,%rdi
  801253:	48 b8 8d 11 80 00 00 	movabs $0x80118d,%rax
  80125a:	00 00 00 
  80125d:	ff d0                	callq  *%rax
  80125f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801262:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801265:	48 63 d0             	movslq %eax,%rdx
  801268:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126c:	48 01 c2             	add    %rax,%rdx
  80126f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801273:	48 89 c6             	mov    %rax,%rsi
  801276:	48 89 d7             	mov    %rdx,%rdi
  801279:	48 b8 f9 11 80 00 00 	movabs $0x8011f9,%rax
  801280:	00 00 00 
  801283:	ff d0                	callq  *%rax
	return dst;
  801285:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801289:	c9                   	leaveq 
  80128a:	c3                   	retq   

000000000080128b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80128b:	55                   	push   %rbp
  80128c:	48 89 e5             	mov    %rsp,%rbp
  80128f:	48 83 ec 28          	sub    $0x28,%rsp
  801293:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801297:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80129b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80129f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012a7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012ae:	00 
  8012af:	eb 2a                	jmp    8012db <strncpy+0x50>
		*dst++ = *src;
  8012b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012b9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012bd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012c1:	0f b6 12             	movzbl (%rdx),%edx
  8012c4:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012ca:	0f b6 00             	movzbl (%rax),%eax
  8012cd:	84 c0                	test   %al,%al
  8012cf:	74 05                	je     8012d6 <strncpy+0x4b>
			src++;
  8012d1:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012d6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012df:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012e3:	72 cc                	jb     8012b1 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012e9:	c9                   	leaveq 
  8012ea:	c3                   	retq   

00000000008012eb <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012eb:	55                   	push   %rbp
  8012ec:	48 89 e5             	mov    %rsp,%rbp
  8012ef:	48 83 ec 28          	sub    $0x28,%rsp
  8012f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012fb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801303:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801307:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80130c:	74 3d                	je     80134b <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80130e:	eb 1d                	jmp    80132d <strlcpy+0x42>
			*dst++ = *src++;
  801310:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801314:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801318:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80131c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801320:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801324:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801328:	0f b6 12             	movzbl (%rdx),%edx
  80132b:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80132d:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801332:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801337:	74 0b                	je     801344 <strlcpy+0x59>
  801339:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80133d:	0f b6 00             	movzbl (%rax),%eax
  801340:	84 c0                	test   %al,%al
  801342:	75 cc                	jne    801310 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801344:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801348:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80134b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80134f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801353:	48 29 c2             	sub    %rax,%rdx
  801356:	48 89 d0             	mov    %rdx,%rax
}
  801359:	c9                   	leaveq 
  80135a:	c3                   	retq   

000000000080135b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80135b:	55                   	push   %rbp
  80135c:	48 89 e5             	mov    %rsp,%rbp
  80135f:	48 83 ec 10          	sub    $0x10,%rsp
  801363:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801367:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80136b:	eb 0a                	jmp    801377 <strcmp+0x1c>
		p++, q++;
  80136d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801372:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801377:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137b:	0f b6 00             	movzbl (%rax),%eax
  80137e:	84 c0                	test   %al,%al
  801380:	74 12                	je     801394 <strcmp+0x39>
  801382:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801386:	0f b6 10             	movzbl (%rax),%edx
  801389:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80138d:	0f b6 00             	movzbl (%rax),%eax
  801390:	38 c2                	cmp    %al,%dl
  801392:	74 d9                	je     80136d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801394:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801398:	0f b6 00             	movzbl (%rax),%eax
  80139b:	0f b6 d0             	movzbl %al,%edx
  80139e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a2:	0f b6 00             	movzbl (%rax),%eax
  8013a5:	0f b6 c0             	movzbl %al,%eax
  8013a8:	29 c2                	sub    %eax,%edx
  8013aa:	89 d0                	mov    %edx,%eax
}
  8013ac:	c9                   	leaveq 
  8013ad:	c3                   	retq   

00000000008013ae <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013ae:	55                   	push   %rbp
  8013af:	48 89 e5             	mov    %rsp,%rbp
  8013b2:	48 83 ec 18          	sub    $0x18,%rsp
  8013b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013be:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013c2:	eb 0f                	jmp    8013d3 <strncmp+0x25>
		n--, p++, q++;
  8013c4:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013c9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013ce:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013d3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013d8:	74 1d                	je     8013f7 <strncmp+0x49>
  8013da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013de:	0f b6 00             	movzbl (%rax),%eax
  8013e1:	84 c0                	test   %al,%al
  8013e3:	74 12                	je     8013f7 <strncmp+0x49>
  8013e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e9:	0f b6 10             	movzbl (%rax),%edx
  8013ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f0:	0f b6 00             	movzbl (%rax),%eax
  8013f3:	38 c2                	cmp    %al,%dl
  8013f5:	74 cd                	je     8013c4 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8013f7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013fc:	75 07                	jne    801405 <strncmp+0x57>
		return 0;
  8013fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801403:	eb 18                	jmp    80141d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801405:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801409:	0f b6 00             	movzbl (%rax),%eax
  80140c:	0f b6 d0             	movzbl %al,%edx
  80140f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801413:	0f b6 00             	movzbl (%rax),%eax
  801416:	0f b6 c0             	movzbl %al,%eax
  801419:	29 c2                	sub    %eax,%edx
  80141b:	89 d0                	mov    %edx,%eax
}
  80141d:	c9                   	leaveq 
  80141e:	c3                   	retq   

000000000080141f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80141f:	55                   	push   %rbp
  801420:	48 89 e5             	mov    %rsp,%rbp
  801423:	48 83 ec 0c          	sub    $0xc,%rsp
  801427:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80142b:	89 f0                	mov    %esi,%eax
  80142d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801430:	eb 17                	jmp    801449 <strchr+0x2a>
		if (*s == c)
  801432:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801436:	0f b6 00             	movzbl (%rax),%eax
  801439:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80143c:	75 06                	jne    801444 <strchr+0x25>
			return (char *) s;
  80143e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801442:	eb 15                	jmp    801459 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801444:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801449:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144d:	0f b6 00             	movzbl (%rax),%eax
  801450:	84 c0                	test   %al,%al
  801452:	75 de                	jne    801432 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801454:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801459:	c9                   	leaveq 
  80145a:	c3                   	retq   

000000000080145b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80145b:	55                   	push   %rbp
  80145c:	48 89 e5             	mov    %rsp,%rbp
  80145f:	48 83 ec 0c          	sub    $0xc,%rsp
  801463:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801467:	89 f0                	mov    %esi,%eax
  801469:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80146c:	eb 13                	jmp    801481 <strfind+0x26>
		if (*s == c)
  80146e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801472:	0f b6 00             	movzbl (%rax),%eax
  801475:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801478:	75 02                	jne    80147c <strfind+0x21>
			break;
  80147a:	eb 10                	jmp    80148c <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80147c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801481:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801485:	0f b6 00             	movzbl (%rax),%eax
  801488:	84 c0                	test   %al,%al
  80148a:	75 e2                	jne    80146e <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80148c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801490:	c9                   	leaveq 
  801491:	c3                   	retq   

0000000000801492 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801492:	55                   	push   %rbp
  801493:	48 89 e5             	mov    %rsp,%rbp
  801496:	48 83 ec 18          	sub    $0x18,%rsp
  80149a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80149e:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014a1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014a5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014aa:	75 06                	jne    8014b2 <memset+0x20>
		return v;
  8014ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b0:	eb 69                	jmp    80151b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b6:	83 e0 03             	and    $0x3,%eax
  8014b9:	48 85 c0             	test   %rax,%rax
  8014bc:	75 48                	jne    801506 <memset+0x74>
  8014be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c2:	83 e0 03             	and    $0x3,%eax
  8014c5:	48 85 c0             	test   %rax,%rax
  8014c8:	75 3c                	jne    801506 <memset+0x74>
		c &= 0xFF;
  8014ca:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014d4:	c1 e0 18             	shl    $0x18,%eax
  8014d7:	89 c2                	mov    %eax,%edx
  8014d9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014dc:	c1 e0 10             	shl    $0x10,%eax
  8014df:	09 c2                	or     %eax,%edx
  8014e1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014e4:	c1 e0 08             	shl    $0x8,%eax
  8014e7:	09 d0                	or     %edx,%eax
  8014e9:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8014ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f0:	48 c1 e8 02          	shr    $0x2,%rax
  8014f4:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014f7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014fe:	48 89 d7             	mov    %rdx,%rdi
  801501:	fc                   	cld    
  801502:	f3 ab                	rep stos %eax,%es:(%rdi)
  801504:	eb 11                	jmp    801517 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801506:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80150a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80150d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801511:	48 89 d7             	mov    %rdx,%rdi
  801514:	fc                   	cld    
  801515:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801517:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80151b:	c9                   	leaveq 
  80151c:	c3                   	retq   

000000000080151d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80151d:	55                   	push   %rbp
  80151e:	48 89 e5             	mov    %rsp,%rbp
  801521:	48 83 ec 28          	sub    $0x28,%rsp
  801525:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801529:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80152d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801531:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801535:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801539:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80153d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801541:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801545:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801549:	0f 83 88 00 00 00    	jae    8015d7 <memmove+0xba>
  80154f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801553:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801557:	48 01 d0             	add    %rdx,%rax
  80155a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80155e:	76 77                	jbe    8015d7 <memmove+0xba>
		s += n;
  801560:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801564:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801568:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801570:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801574:	83 e0 03             	and    $0x3,%eax
  801577:	48 85 c0             	test   %rax,%rax
  80157a:	75 3b                	jne    8015b7 <memmove+0x9a>
  80157c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801580:	83 e0 03             	and    $0x3,%eax
  801583:	48 85 c0             	test   %rax,%rax
  801586:	75 2f                	jne    8015b7 <memmove+0x9a>
  801588:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158c:	83 e0 03             	and    $0x3,%eax
  80158f:	48 85 c0             	test   %rax,%rax
  801592:	75 23                	jne    8015b7 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801594:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801598:	48 83 e8 04          	sub    $0x4,%rax
  80159c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015a0:	48 83 ea 04          	sub    $0x4,%rdx
  8015a4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015a8:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015ac:	48 89 c7             	mov    %rax,%rdi
  8015af:	48 89 d6             	mov    %rdx,%rsi
  8015b2:	fd                   	std    
  8015b3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015b5:	eb 1d                	jmp    8015d4 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015bb:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c3:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cb:	48 89 d7             	mov    %rdx,%rdi
  8015ce:	48 89 c1             	mov    %rax,%rcx
  8015d1:	fd                   	std    
  8015d2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015d4:	fc                   	cld    
  8015d5:	eb 57                	jmp    80162e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015db:	83 e0 03             	and    $0x3,%eax
  8015de:	48 85 c0             	test   %rax,%rax
  8015e1:	75 36                	jne    801619 <memmove+0xfc>
  8015e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e7:	83 e0 03             	and    $0x3,%eax
  8015ea:	48 85 c0             	test   %rax,%rax
  8015ed:	75 2a                	jne    801619 <memmove+0xfc>
  8015ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f3:	83 e0 03             	and    $0x3,%eax
  8015f6:	48 85 c0             	test   %rax,%rax
  8015f9:	75 1e                	jne    801619 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ff:	48 c1 e8 02          	shr    $0x2,%rax
  801603:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801606:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80160e:	48 89 c7             	mov    %rax,%rdi
  801611:	48 89 d6             	mov    %rdx,%rsi
  801614:	fc                   	cld    
  801615:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801617:	eb 15                	jmp    80162e <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801619:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80161d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801621:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801625:	48 89 c7             	mov    %rax,%rdi
  801628:	48 89 d6             	mov    %rdx,%rsi
  80162b:	fc                   	cld    
  80162c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80162e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801632:	c9                   	leaveq 
  801633:	c3                   	retq   

0000000000801634 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801634:	55                   	push   %rbp
  801635:	48 89 e5             	mov    %rsp,%rbp
  801638:	48 83 ec 18          	sub    $0x18,%rsp
  80163c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801640:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801644:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801648:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80164c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801650:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801654:	48 89 ce             	mov    %rcx,%rsi
  801657:	48 89 c7             	mov    %rax,%rdi
  80165a:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  801661:	00 00 00 
  801664:	ff d0                	callq  *%rax
}
  801666:	c9                   	leaveq 
  801667:	c3                   	retq   

0000000000801668 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801668:	55                   	push   %rbp
  801669:	48 89 e5             	mov    %rsp,%rbp
  80166c:	48 83 ec 28          	sub    $0x28,%rsp
  801670:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801674:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801678:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80167c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801680:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801684:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801688:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80168c:	eb 36                	jmp    8016c4 <memcmp+0x5c>
		if (*s1 != *s2)
  80168e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801692:	0f b6 10             	movzbl (%rax),%edx
  801695:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801699:	0f b6 00             	movzbl (%rax),%eax
  80169c:	38 c2                	cmp    %al,%dl
  80169e:	74 1a                	je     8016ba <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a4:	0f b6 00             	movzbl (%rax),%eax
  8016a7:	0f b6 d0             	movzbl %al,%edx
  8016aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ae:	0f b6 00             	movzbl (%rax),%eax
  8016b1:	0f b6 c0             	movzbl %al,%eax
  8016b4:	29 c2                	sub    %eax,%edx
  8016b6:	89 d0                	mov    %edx,%eax
  8016b8:	eb 20                	jmp    8016da <memcmp+0x72>
		s1++, s2++;
  8016ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016bf:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016cc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016d0:	48 85 c0             	test   %rax,%rax
  8016d3:	75 b9                	jne    80168e <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016da:	c9                   	leaveq 
  8016db:	c3                   	retq   

00000000008016dc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016dc:	55                   	push   %rbp
  8016dd:	48 89 e5             	mov    %rsp,%rbp
  8016e0:	48 83 ec 28          	sub    $0x28,%rsp
  8016e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016e8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016f7:	48 01 d0             	add    %rdx,%rax
  8016fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8016fe:	eb 15                	jmp    801715 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801700:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801704:	0f b6 10             	movzbl (%rax),%edx
  801707:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80170a:	38 c2                	cmp    %al,%dl
  80170c:	75 02                	jne    801710 <memfind+0x34>
			break;
  80170e:	eb 0f                	jmp    80171f <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801710:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801715:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801719:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80171d:	72 e1                	jb     801700 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80171f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801723:	c9                   	leaveq 
  801724:	c3                   	retq   

0000000000801725 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801725:	55                   	push   %rbp
  801726:	48 89 e5             	mov    %rsp,%rbp
  801729:	48 83 ec 34          	sub    $0x34,%rsp
  80172d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801731:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801735:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801738:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80173f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801746:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801747:	eb 05                	jmp    80174e <strtol+0x29>
		s++;
  801749:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80174e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801752:	0f b6 00             	movzbl (%rax),%eax
  801755:	3c 20                	cmp    $0x20,%al
  801757:	74 f0                	je     801749 <strtol+0x24>
  801759:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175d:	0f b6 00             	movzbl (%rax),%eax
  801760:	3c 09                	cmp    $0x9,%al
  801762:	74 e5                	je     801749 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801764:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801768:	0f b6 00             	movzbl (%rax),%eax
  80176b:	3c 2b                	cmp    $0x2b,%al
  80176d:	75 07                	jne    801776 <strtol+0x51>
		s++;
  80176f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801774:	eb 17                	jmp    80178d <strtol+0x68>
	else if (*s == '-')
  801776:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177a:	0f b6 00             	movzbl (%rax),%eax
  80177d:	3c 2d                	cmp    $0x2d,%al
  80177f:	75 0c                	jne    80178d <strtol+0x68>
		s++, neg = 1;
  801781:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801786:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80178d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801791:	74 06                	je     801799 <strtol+0x74>
  801793:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801797:	75 28                	jne    8017c1 <strtol+0x9c>
  801799:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179d:	0f b6 00             	movzbl (%rax),%eax
  8017a0:	3c 30                	cmp    $0x30,%al
  8017a2:	75 1d                	jne    8017c1 <strtol+0x9c>
  8017a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a8:	48 83 c0 01          	add    $0x1,%rax
  8017ac:	0f b6 00             	movzbl (%rax),%eax
  8017af:	3c 78                	cmp    $0x78,%al
  8017b1:	75 0e                	jne    8017c1 <strtol+0x9c>
		s += 2, base = 16;
  8017b3:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017b8:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017bf:	eb 2c                	jmp    8017ed <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017c1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017c5:	75 19                	jne    8017e0 <strtol+0xbb>
  8017c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cb:	0f b6 00             	movzbl (%rax),%eax
  8017ce:	3c 30                	cmp    $0x30,%al
  8017d0:	75 0e                	jne    8017e0 <strtol+0xbb>
		s++, base = 8;
  8017d2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017d7:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017de:	eb 0d                	jmp    8017ed <strtol+0xc8>
	else if (base == 0)
  8017e0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017e4:	75 07                	jne    8017ed <strtol+0xc8>
		base = 10;
  8017e6:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f1:	0f b6 00             	movzbl (%rax),%eax
  8017f4:	3c 2f                	cmp    $0x2f,%al
  8017f6:	7e 1d                	jle    801815 <strtol+0xf0>
  8017f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fc:	0f b6 00             	movzbl (%rax),%eax
  8017ff:	3c 39                	cmp    $0x39,%al
  801801:	7f 12                	jg     801815 <strtol+0xf0>
			dig = *s - '0';
  801803:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801807:	0f b6 00             	movzbl (%rax),%eax
  80180a:	0f be c0             	movsbl %al,%eax
  80180d:	83 e8 30             	sub    $0x30,%eax
  801810:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801813:	eb 4e                	jmp    801863 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801815:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801819:	0f b6 00             	movzbl (%rax),%eax
  80181c:	3c 60                	cmp    $0x60,%al
  80181e:	7e 1d                	jle    80183d <strtol+0x118>
  801820:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801824:	0f b6 00             	movzbl (%rax),%eax
  801827:	3c 7a                	cmp    $0x7a,%al
  801829:	7f 12                	jg     80183d <strtol+0x118>
			dig = *s - 'a' + 10;
  80182b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182f:	0f b6 00             	movzbl (%rax),%eax
  801832:	0f be c0             	movsbl %al,%eax
  801835:	83 e8 57             	sub    $0x57,%eax
  801838:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80183b:	eb 26                	jmp    801863 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80183d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801841:	0f b6 00             	movzbl (%rax),%eax
  801844:	3c 40                	cmp    $0x40,%al
  801846:	7e 48                	jle    801890 <strtol+0x16b>
  801848:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184c:	0f b6 00             	movzbl (%rax),%eax
  80184f:	3c 5a                	cmp    $0x5a,%al
  801851:	7f 3d                	jg     801890 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801853:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801857:	0f b6 00             	movzbl (%rax),%eax
  80185a:	0f be c0             	movsbl %al,%eax
  80185d:	83 e8 37             	sub    $0x37,%eax
  801860:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801863:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801866:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801869:	7c 02                	jl     80186d <strtol+0x148>
			break;
  80186b:	eb 23                	jmp    801890 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80186d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801872:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801875:	48 98                	cltq   
  801877:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80187c:	48 89 c2             	mov    %rax,%rdx
  80187f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801882:	48 98                	cltq   
  801884:	48 01 d0             	add    %rdx,%rax
  801887:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80188b:	e9 5d ff ff ff       	jmpq   8017ed <strtol+0xc8>

	if (endptr)
  801890:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801895:	74 0b                	je     8018a2 <strtol+0x17d>
		*endptr = (char *) s;
  801897:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80189b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80189f:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018a6:	74 09                	je     8018b1 <strtol+0x18c>
  8018a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ac:	48 f7 d8             	neg    %rax
  8018af:	eb 04                	jmp    8018b5 <strtol+0x190>
  8018b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018b5:	c9                   	leaveq 
  8018b6:	c3                   	retq   

00000000008018b7 <strstr>:

char * strstr(const char *in, const char *str)
{
  8018b7:	55                   	push   %rbp
  8018b8:	48 89 e5             	mov    %rsp,%rbp
  8018bb:	48 83 ec 30          	sub    $0x30,%rsp
  8018bf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018c3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8018c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018cb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018cf:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018d3:	0f b6 00             	movzbl (%rax),%eax
  8018d6:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8018d9:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018dd:	75 06                	jne    8018e5 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8018df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e3:	eb 6b                	jmp    801950 <strstr+0x99>

    len = strlen(str);
  8018e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018e9:	48 89 c7             	mov    %rax,%rdi
  8018ec:	48 b8 8d 11 80 00 00 	movabs $0x80118d,%rax
  8018f3:	00 00 00 
  8018f6:	ff d0                	callq  *%rax
  8018f8:	48 98                	cltq   
  8018fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8018fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801902:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801906:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80190a:	0f b6 00             	movzbl (%rax),%eax
  80190d:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801910:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801914:	75 07                	jne    80191d <strstr+0x66>
                return (char *) 0;
  801916:	b8 00 00 00 00       	mov    $0x0,%eax
  80191b:	eb 33                	jmp    801950 <strstr+0x99>
        } while (sc != c);
  80191d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801921:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801924:	75 d8                	jne    8018fe <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801926:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80192a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80192e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801932:	48 89 ce             	mov    %rcx,%rsi
  801935:	48 89 c7             	mov    %rax,%rdi
  801938:	48 b8 ae 13 80 00 00 	movabs $0x8013ae,%rax
  80193f:	00 00 00 
  801942:	ff d0                	callq  *%rax
  801944:	85 c0                	test   %eax,%eax
  801946:	75 b6                	jne    8018fe <strstr+0x47>

    return (char *) (in - 1);
  801948:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194c:	48 83 e8 01          	sub    $0x1,%rax
}
  801950:	c9                   	leaveq 
  801951:	c3                   	retq   

0000000000801952 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801952:	55                   	push   %rbp
  801953:	48 89 e5             	mov    %rsp,%rbp
  801956:	53                   	push   %rbx
  801957:	48 83 ec 48          	sub    $0x48,%rsp
  80195b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80195e:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801961:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801965:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801969:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80196d:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801971:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801974:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801978:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80197c:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801980:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801984:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801988:	4c 89 c3             	mov    %r8,%rbx
  80198b:	cd 30                	int    $0x30
  80198d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801991:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801995:	74 3e                	je     8019d5 <syscall+0x83>
  801997:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80199c:	7e 37                	jle    8019d5 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80199e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019a2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019a5:	49 89 d0             	mov    %rdx,%r8
  8019a8:	89 c1                	mov    %eax,%ecx
  8019aa:	48 ba 20 3c 80 00 00 	movabs $0x803c20,%rdx
  8019b1:	00 00 00 
  8019b4:	be 23 00 00 00       	mov    $0x23,%esi
  8019b9:	48 bf 3d 3c 80 00 00 	movabs $0x803c3d,%rdi
  8019c0:	00 00 00 
  8019c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c8:	49 b9 0b 04 80 00 00 	movabs $0x80040b,%r9
  8019cf:	00 00 00 
  8019d2:	41 ff d1             	callq  *%r9

	return ret;
  8019d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019d9:	48 83 c4 48          	add    $0x48,%rsp
  8019dd:	5b                   	pop    %rbx
  8019de:	5d                   	pop    %rbp
  8019df:	c3                   	retq   

00000000008019e0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019e0:	55                   	push   %rbp
  8019e1:	48 89 e5             	mov    %rsp,%rbp
  8019e4:	48 83 ec 20          	sub    $0x20,%rsp
  8019e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019ec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019f8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ff:	00 
  801a00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a06:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0c:	48 89 d1             	mov    %rdx,%rcx
  801a0f:	48 89 c2             	mov    %rax,%rdx
  801a12:	be 00 00 00 00       	mov    $0x0,%esi
  801a17:	bf 00 00 00 00       	mov    $0x0,%edi
  801a1c:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801a23:	00 00 00 
  801a26:	ff d0                	callq  *%rax
}
  801a28:	c9                   	leaveq 
  801a29:	c3                   	retq   

0000000000801a2a <sys_cgetc>:

int
sys_cgetc(void)
{
  801a2a:	55                   	push   %rbp
  801a2b:	48 89 e5             	mov    %rsp,%rbp
  801a2e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a32:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a39:	00 
  801a3a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a40:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a46:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a50:	be 00 00 00 00       	mov    $0x0,%esi
  801a55:	bf 01 00 00 00       	mov    $0x1,%edi
  801a5a:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801a61:	00 00 00 
  801a64:	ff d0                	callq  *%rax
}
  801a66:	c9                   	leaveq 
  801a67:	c3                   	retq   

0000000000801a68 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a68:	55                   	push   %rbp
  801a69:	48 89 e5             	mov    %rsp,%rbp
  801a6c:	48 83 ec 10          	sub    $0x10,%rsp
  801a70:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a76:	48 98                	cltq   
  801a78:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a7f:	00 
  801a80:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a86:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a91:	48 89 c2             	mov    %rax,%rdx
  801a94:	be 01 00 00 00       	mov    $0x1,%esi
  801a99:	bf 03 00 00 00       	mov    $0x3,%edi
  801a9e:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801aa5:	00 00 00 
  801aa8:	ff d0                	callq  *%rax
}
  801aaa:	c9                   	leaveq 
  801aab:	c3                   	retq   

0000000000801aac <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801aac:	55                   	push   %rbp
  801aad:	48 89 e5             	mov    %rsp,%rbp
  801ab0:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ab4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801abb:	00 
  801abc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801acd:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad2:	be 00 00 00 00       	mov    $0x0,%esi
  801ad7:	bf 02 00 00 00       	mov    $0x2,%edi
  801adc:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801ae3:	00 00 00 
  801ae6:	ff d0                	callq  *%rax
}
  801ae8:	c9                   	leaveq 
  801ae9:	c3                   	retq   

0000000000801aea <sys_yield>:

void
sys_yield(void)
{
  801aea:	55                   	push   %rbp
  801aeb:	48 89 e5             	mov    %rsp,%rbp
  801aee:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801af2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af9:	00 
  801afa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b00:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b06:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b0b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b10:	be 00 00 00 00       	mov    $0x0,%esi
  801b15:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b1a:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801b21:	00 00 00 
  801b24:	ff d0                	callq  *%rax
}
  801b26:	c9                   	leaveq 
  801b27:	c3                   	retq   

0000000000801b28 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b28:	55                   	push   %rbp
  801b29:	48 89 e5             	mov    %rsp,%rbp
  801b2c:	48 83 ec 20          	sub    $0x20,%rsp
  801b30:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b33:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b37:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b3d:	48 63 c8             	movslq %eax,%rcx
  801b40:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b47:	48 98                	cltq   
  801b49:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b50:	00 
  801b51:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b57:	49 89 c8             	mov    %rcx,%r8
  801b5a:	48 89 d1             	mov    %rdx,%rcx
  801b5d:	48 89 c2             	mov    %rax,%rdx
  801b60:	be 01 00 00 00       	mov    $0x1,%esi
  801b65:	bf 04 00 00 00       	mov    $0x4,%edi
  801b6a:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801b71:	00 00 00 
  801b74:	ff d0                	callq  *%rax
}
  801b76:	c9                   	leaveq 
  801b77:	c3                   	retq   

0000000000801b78 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b78:	55                   	push   %rbp
  801b79:	48 89 e5             	mov    %rsp,%rbp
  801b7c:	48 83 ec 30          	sub    $0x30,%rsp
  801b80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b87:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b8a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b8e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b92:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b95:	48 63 c8             	movslq %eax,%rcx
  801b98:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b9c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b9f:	48 63 f0             	movslq %eax,%rsi
  801ba2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ba6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ba9:	48 98                	cltq   
  801bab:	48 89 0c 24          	mov    %rcx,(%rsp)
  801baf:	49 89 f9             	mov    %rdi,%r9
  801bb2:	49 89 f0             	mov    %rsi,%r8
  801bb5:	48 89 d1             	mov    %rdx,%rcx
  801bb8:	48 89 c2             	mov    %rax,%rdx
  801bbb:	be 01 00 00 00       	mov    $0x1,%esi
  801bc0:	bf 05 00 00 00       	mov    $0x5,%edi
  801bc5:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801bcc:	00 00 00 
  801bcf:	ff d0                	callq  *%rax
}
  801bd1:	c9                   	leaveq 
  801bd2:	c3                   	retq   

0000000000801bd3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bd3:	55                   	push   %rbp
  801bd4:	48 89 e5             	mov    %rsp,%rbp
  801bd7:	48 83 ec 20          	sub    $0x20,%rsp
  801bdb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bde:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801be2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801be6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801be9:	48 98                	cltq   
  801beb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bf2:	00 
  801bf3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bf9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bff:	48 89 d1             	mov    %rdx,%rcx
  801c02:	48 89 c2             	mov    %rax,%rdx
  801c05:	be 01 00 00 00       	mov    $0x1,%esi
  801c0a:	bf 06 00 00 00       	mov    $0x6,%edi
  801c0f:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801c16:	00 00 00 
  801c19:	ff d0                	callq  *%rax
}
  801c1b:	c9                   	leaveq 
  801c1c:	c3                   	retq   

0000000000801c1d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c1d:	55                   	push   %rbp
  801c1e:	48 89 e5             	mov    %rsp,%rbp
  801c21:	48 83 ec 10          	sub    $0x10,%rsp
  801c25:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c28:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c2b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c2e:	48 63 d0             	movslq %eax,%rdx
  801c31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c34:	48 98                	cltq   
  801c36:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c3d:	00 
  801c3e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c44:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c4a:	48 89 d1             	mov    %rdx,%rcx
  801c4d:	48 89 c2             	mov    %rax,%rdx
  801c50:	be 01 00 00 00       	mov    $0x1,%esi
  801c55:	bf 08 00 00 00       	mov    $0x8,%edi
  801c5a:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801c61:	00 00 00 
  801c64:	ff d0                	callq  *%rax
}
  801c66:	c9                   	leaveq 
  801c67:	c3                   	retq   

0000000000801c68 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c68:	55                   	push   %rbp
  801c69:	48 89 e5             	mov    %rsp,%rbp
  801c6c:	48 83 ec 20          	sub    $0x20,%rsp
  801c70:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c73:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c77:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c7e:	48 98                	cltq   
  801c80:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c87:	00 
  801c88:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c8e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c94:	48 89 d1             	mov    %rdx,%rcx
  801c97:	48 89 c2             	mov    %rax,%rdx
  801c9a:	be 01 00 00 00       	mov    $0x1,%esi
  801c9f:	bf 09 00 00 00       	mov    $0x9,%edi
  801ca4:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801cab:	00 00 00 
  801cae:	ff d0                	callq  *%rax
}
  801cb0:	c9                   	leaveq 
  801cb1:	c3                   	retq   

0000000000801cb2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801cb2:	55                   	push   %rbp
  801cb3:	48 89 e5             	mov    %rsp,%rbp
  801cb6:	48 83 ec 20          	sub    $0x20,%rsp
  801cba:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cbd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801cc1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cc8:	48 98                	cltq   
  801cca:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cd1:	00 
  801cd2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cd8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cde:	48 89 d1             	mov    %rdx,%rcx
  801ce1:	48 89 c2             	mov    %rax,%rdx
  801ce4:	be 01 00 00 00       	mov    $0x1,%esi
  801ce9:	bf 0a 00 00 00       	mov    $0xa,%edi
  801cee:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801cf5:	00 00 00 
  801cf8:	ff d0                	callq  *%rax
}
  801cfa:	c9                   	leaveq 
  801cfb:	c3                   	retq   

0000000000801cfc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801cfc:	55                   	push   %rbp
  801cfd:	48 89 e5             	mov    %rsp,%rbp
  801d00:	48 83 ec 20          	sub    $0x20,%rsp
  801d04:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d07:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d0b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d0f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d15:	48 63 f0             	movslq %eax,%rsi
  801d18:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d1f:	48 98                	cltq   
  801d21:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d25:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d2c:	00 
  801d2d:	49 89 f1             	mov    %rsi,%r9
  801d30:	49 89 c8             	mov    %rcx,%r8
  801d33:	48 89 d1             	mov    %rdx,%rcx
  801d36:	48 89 c2             	mov    %rax,%rdx
  801d39:	be 00 00 00 00       	mov    $0x0,%esi
  801d3e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d43:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801d4a:	00 00 00 
  801d4d:	ff d0                	callq  *%rax
}
  801d4f:	c9                   	leaveq 
  801d50:	c3                   	retq   

0000000000801d51 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d51:	55                   	push   %rbp
  801d52:	48 89 e5             	mov    %rsp,%rbp
  801d55:	48 83 ec 10          	sub    $0x10,%rsp
  801d59:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d61:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d68:	00 
  801d69:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d6f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d75:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d7a:	48 89 c2             	mov    %rax,%rdx
  801d7d:	be 01 00 00 00       	mov    $0x1,%esi
  801d82:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d87:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801d8e:	00 00 00 
  801d91:	ff d0                	callq  *%rax
}
  801d93:	c9                   	leaveq 
  801d94:	c3                   	retq   

0000000000801d95 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d95:	55                   	push   %rbp
  801d96:	48 89 e5             	mov    %rsp,%rbp
  801d99:	48 83 ec 08          	sub    $0x8,%rsp
  801d9d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801da1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801da5:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801dac:	ff ff ff 
  801daf:	48 01 d0             	add    %rdx,%rax
  801db2:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801db6:	c9                   	leaveq 
  801db7:	c3                   	retq   

0000000000801db8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801db8:	55                   	push   %rbp
  801db9:	48 89 e5             	mov    %rsp,%rbp
  801dbc:	48 83 ec 08          	sub    $0x8,%rsp
  801dc0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801dc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc8:	48 89 c7             	mov    %rax,%rdi
  801dcb:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  801dd2:	00 00 00 
  801dd5:	ff d0                	callq  *%rax
  801dd7:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ddd:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801de1:	c9                   	leaveq 
  801de2:	c3                   	retq   

0000000000801de3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801de3:	55                   	push   %rbp
  801de4:	48 89 e5             	mov    %rsp,%rbp
  801de7:	48 83 ec 18          	sub    $0x18,%rsp
  801deb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801def:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801df6:	eb 6b                	jmp    801e63 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801df8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dfb:	48 98                	cltq   
  801dfd:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e03:	48 c1 e0 0c          	shl    $0xc,%rax
  801e07:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e0f:	48 c1 e8 15          	shr    $0x15,%rax
  801e13:	48 89 c2             	mov    %rax,%rdx
  801e16:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e1d:	01 00 00 
  801e20:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e24:	83 e0 01             	and    $0x1,%eax
  801e27:	48 85 c0             	test   %rax,%rax
  801e2a:	74 21                	je     801e4d <fd_alloc+0x6a>
  801e2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e30:	48 c1 e8 0c          	shr    $0xc,%rax
  801e34:	48 89 c2             	mov    %rax,%rdx
  801e37:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e3e:	01 00 00 
  801e41:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e45:	83 e0 01             	and    $0x1,%eax
  801e48:	48 85 c0             	test   %rax,%rax
  801e4b:	75 12                	jne    801e5f <fd_alloc+0x7c>
			*fd_store = fd;
  801e4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e51:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e55:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e58:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5d:	eb 1a                	jmp    801e79 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e5f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e63:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e67:	7e 8f                	jle    801df8 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e6d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e74:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e79:	c9                   	leaveq 
  801e7a:	c3                   	retq   

0000000000801e7b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e7b:	55                   	push   %rbp
  801e7c:	48 89 e5             	mov    %rsp,%rbp
  801e7f:	48 83 ec 20          	sub    $0x20,%rsp
  801e83:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e86:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e8a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e8e:	78 06                	js     801e96 <fd_lookup+0x1b>
  801e90:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e94:	7e 07                	jle    801e9d <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e96:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e9b:	eb 6c                	jmp    801f09 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e9d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ea0:	48 98                	cltq   
  801ea2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ea8:	48 c1 e0 0c          	shl    $0xc,%rax
  801eac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801eb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eb4:	48 c1 e8 15          	shr    $0x15,%rax
  801eb8:	48 89 c2             	mov    %rax,%rdx
  801ebb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ec2:	01 00 00 
  801ec5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ec9:	83 e0 01             	and    $0x1,%eax
  801ecc:	48 85 c0             	test   %rax,%rax
  801ecf:	74 21                	je     801ef2 <fd_lookup+0x77>
  801ed1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ed5:	48 c1 e8 0c          	shr    $0xc,%rax
  801ed9:	48 89 c2             	mov    %rax,%rdx
  801edc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ee3:	01 00 00 
  801ee6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eea:	83 e0 01             	and    $0x1,%eax
  801eed:	48 85 c0             	test   %rax,%rax
  801ef0:	75 07                	jne    801ef9 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ef2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ef7:	eb 10                	jmp    801f09 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801ef9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801efd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f01:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f09:	c9                   	leaveq 
  801f0a:	c3                   	retq   

0000000000801f0b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f0b:	55                   	push   %rbp
  801f0c:	48 89 e5             	mov    %rsp,%rbp
  801f0f:	48 83 ec 30          	sub    $0x30,%rsp
  801f13:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f17:	89 f0                	mov    %esi,%eax
  801f19:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f20:	48 89 c7             	mov    %rax,%rdi
  801f23:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  801f2a:	00 00 00 
  801f2d:	ff d0                	callq  *%rax
  801f2f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f33:	48 89 d6             	mov    %rdx,%rsi
  801f36:	89 c7                	mov    %eax,%edi
  801f38:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  801f3f:	00 00 00 
  801f42:	ff d0                	callq  *%rax
  801f44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f4b:	78 0a                	js     801f57 <fd_close+0x4c>
	    || fd != fd2)
  801f4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f51:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f55:	74 12                	je     801f69 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f57:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f5b:	74 05                	je     801f62 <fd_close+0x57>
  801f5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f60:	eb 05                	jmp    801f67 <fd_close+0x5c>
  801f62:	b8 00 00 00 00       	mov    $0x0,%eax
  801f67:	eb 69                	jmp    801fd2 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f69:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f6d:	8b 00                	mov    (%rax),%eax
  801f6f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f73:	48 89 d6             	mov    %rdx,%rsi
  801f76:	89 c7                	mov    %eax,%edi
  801f78:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  801f7f:	00 00 00 
  801f82:	ff d0                	callq  *%rax
  801f84:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f87:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f8b:	78 2a                	js     801fb7 <fd_close+0xac>
		if (dev->dev_close)
  801f8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f91:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f95:	48 85 c0             	test   %rax,%rax
  801f98:	74 16                	je     801fb0 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f9e:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fa2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fa6:	48 89 d7             	mov    %rdx,%rdi
  801fa9:	ff d0                	callq  *%rax
  801fab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fae:	eb 07                	jmp    801fb7 <fd_close+0xac>
		else
			r = 0;
  801fb0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801fb7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fbb:	48 89 c6             	mov    %rax,%rsi
  801fbe:	bf 00 00 00 00       	mov    $0x0,%edi
  801fc3:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  801fca:	00 00 00 
  801fcd:	ff d0                	callq  *%rax
	return r;
  801fcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801fd2:	c9                   	leaveq 
  801fd3:	c3                   	retq   

0000000000801fd4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801fd4:	55                   	push   %rbp
  801fd5:	48 89 e5             	mov    %rsp,%rbp
  801fd8:	48 83 ec 20          	sub    $0x20,%rsp
  801fdc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fdf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801fe3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fea:	eb 41                	jmp    80202d <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801fec:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801ff3:	00 00 00 
  801ff6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ff9:	48 63 d2             	movslq %edx,%rdx
  801ffc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802000:	8b 00                	mov    (%rax),%eax
  802002:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802005:	75 22                	jne    802029 <dev_lookup+0x55>
			*dev = devtab[i];
  802007:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80200e:	00 00 00 
  802011:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802014:	48 63 d2             	movslq %edx,%rdx
  802017:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80201b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80201f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802022:	b8 00 00 00 00       	mov    $0x0,%eax
  802027:	eb 60                	jmp    802089 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802029:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80202d:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802034:	00 00 00 
  802037:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80203a:	48 63 d2             	movslq %edx,%rdx
  80203d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802041:	48 85 c0             	test   %rax,%rax
  802044:	75 a6                	jne    801fec <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802046:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80204d:	00 00 00 
  802050:	48 8b 00             	mov    (%rax),%rax
  802053:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802059:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80205c:	89 c6                	mov    %eax,%esi
  80205e:	48 bf 50 3c 80 00 00 	movabs $0x803c50,%rdi
  802065:	00 00 00 
  802068:	b8 00 00 00 00       	mov    $0x0,%eax
  80206d:	48 b9 44 06 80 00 00 	movabs $0x800644,%rcx
  802074:	00 00 00 
  802077:	ff d1                	callq  *%rcx
	*dev = 0;
  802079:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80207d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802084:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802089:	c9                   	leaveq 
  80208a:	c3                   	retq   

000000000080208b <close>:

int
close(int fdnum)
{
  80208b:	55                   	push   %rbp
  80208c:	48 89 e5             	mov    %rsp,%rbp
  80208f:	48 83 ec 20          	sub    $0x20,%rsp
  802093:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802096:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80209a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80209d:	48 89 d6             	mov    %rdx,%rsi
  8020a0:	89 c7                	mov    %eax,%edi
  8020a2:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  8020a9:	00 00 00 
  8020ac:	ff d0                	callq  *%rax
  8020ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020b5:	79 05                	jns    8020bc <close+0x31>
		return r;
  8020b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ba:	eb 18                	jmp    8020d4 <close+0x49>
	else
		return fd_close(fd, 1);
  8020bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020c0:	be 01 00 00 00       	mov    $0x1,%esi
  8020c5:	48 89 c7             	mov    %rax,%rdi
  8020c8:	48 b8 0b 1f 80 00 00 	movabs $0x801f0b,%rax
  8020cf:	00 00 00 
  8020d2:	ff d0                	callq  *%rax
}
  8020d4:	c9                   	leaveq 
  8020d5:	c3                   	retq   

00000000008020d6 <close_all>:

void
close_all(void)
{
  8020d6:	55                   	push   %rbp
  8020d7:	48 89 e5             	mov    %rsp,%rbp
  8020da:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8020de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020e5:	eb 15                	jmp    8020fc <close_all+0x26>
		close(i);
  8020e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ea:	89 c7                	mov    %eax,%edi
  8020ec:	48 b8 8b 20 80 00 00 	movabs $0x80208b,%rax
  8020f3:	00 00 00 
  8020f6:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8020f8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020fc:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802100:	7e e5                	jle    8020e7 <close_all+0x11>
		close(i);
}
  802102:	c9                   	leaveq 
  802103:	c3                   	retq   

0000000000802104 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802104:	55                   	push   %rbp
  802105:	48 89 e5             	mov    %rsp,%rbp
  802108:	48 83 ec 40          	sub    $0x40,%rsp
  80210c:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80210f:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802112:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802116:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802119:	48 89 d6             	mov    %rdx,%rsi
  80211c:	89 c7                	mov    %eax,%edi
  80211e:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  802125:	00 00 00 
  802128:	ff d0                	callq  *%rax
  80212a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80212d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802131:	79 08                	jns    80213b <dup+0x37>
		return r;
  802133:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802136:	e9 70 01 00 00       	jmpq   8022ab <dup+0x1a7>
	close(newfdnum);
  80213b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80213e:	89 c7                	mov    %eax,%edi
  802140:	48 b8 8b 20 80 00 00 	movabs $0x80208b,%rax
  802147:	00 00 00 
  80214a:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80214c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80214f:	48 98                	cltq   
  802151:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802157:	48 c1 e0 0c          	shl    $0xc,%rax
  80215b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80215f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802163:	48 89 c7             	mov    %rax,%rdi
  802166:	48 b8 b8 1d 80 00 00 	movabs $0x801db8,%rax
  80216d:	00 00 00 
  802170:	ff d0                	callq  *%rax
  802172:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802176:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80217a:	48 89 c7             	mov    %rax,%rdi
  80217d:	48 b8 b8 1d 80 00 00 	movabs $0x801db8,%rax
  802184:	00 00 00 
  802187:	ff d0                	callq  *%rax
  802189:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80218d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802191:	48 c1 e8 15          	shr    $0x15,%rax
  802195:	48 89 c2             	mov    %rax,%rdx
  802198:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80219f:	01 00 00 
  8021a2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021a6:	83 e0 01             	and    $0x1,%eax
  8021a9:	48 85 c0             	test   %rax,%rax
  8021ac:	74 73                	je     802221 <dup+0x11d>
  8021ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b2:	48 c1 e8 0c          	shr    $0xc,%rax
  8021b6:	48 89 c2             	mov    %rax,%rdx
  8021b9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021c0:	01 00 00 
  8021c3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c7:	83 e0 01             	and    $0x1,%eax
  8021ca:	48 85 c0             	test   %rax,%rax
  8021cd:	74 52                	je     802221 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8021cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d3:	48 c1 e8 0c          	shr    $0xc,%rax
  8021d7:	48 89 c2             	mov    %rax,%rdx
  8021da:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021e1:	01 00 00 
  8021e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021e8:	25 07 0e 00 00       	and    $0xe07,%eax
  8021ed:	89 c1                	mov    %eax,%ecx
  8021ef:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f7:	41 89 c8             	mov    %ecx,%r8d
  8021fa:	48 89 d1             	mov    %rdx,%rcx
  8021fd:	ba 00 00 00 00       	mov    $0x0,%edx
  802202:	48 89 c6             	mov    %rax,%rsi
  802205:	bf 00 00 00 00       	mov    $0x0,%edi
  80220a:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  802211:	00 00 00 
  802214:	ff d0                	callq  *%rax
  802216:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802219:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80221d:	79 02                	jns    802221 <dup+0x11d>
			goto err;
  80221f:	eb 57                	jmp    802278 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802221:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802225:	48 c1 e8 0c          	shr    $0xc,%rax
  802229:	48 89 c2             	mov    %rax,%rdx
  80222c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802233:	01 00 00 
  802236:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80223a:	25 07 0e 00 00       	and    $0xe07,%eax
  80223f:	89 c1                	mov    %eax,%ecx
  802241:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802245:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802249:	41 89 c8             	mov    %ecx,%r8d
  80224c:	48 89 d1             	mov    %rdx,%rcx
  80224f:	ba 00 00 00 00       	mov    $0x0,%edx
  802254:	48 89 c6             	mov    %rax,%rsi
  802257:	bf 00 00 00 00       	mov    $0x0,%edi
  80225c:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  802263:	00 00 00 
  802266:	ff d0                	callq  *%rax
  802268:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80226b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80226f:	79 02                	jns    802273 <dup+0x16f>
		goto err;
  802271:	eb 05                	jmp    802278 <dup+0x174>

	return newfdnum;
  802273:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802276:	eb 33                	jmp    8022ab <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802278:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80227c:	48 89 c6             	mov    %rax,%rsi
  80227f:	bf 00 00 00 00       	mov    $0x0,%edi
  802284:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  80228b:	00 00 00 
  80228e:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802290:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802294:	48 89 c6             	mov    %rax,%rsi
  802297:	bf 00 00 00 00       	mov    $0x0,%edi
  80229c:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  8022a3:	00 00 00 
  8022a6:	ff d0                	callq  *%rax
	return r;
  8022a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022ab:	c9                   	leaveq 
  8022ac:	c3                   	retq   

00000000008022ad <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022ad:	55                   	push   %rbp
  8022ae:	48 89 e5             	mov    %rsp,%rbp
  8022b1:	48 83 ec 40          	sub    $0x40,%rsp
  8022b5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022b8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022bc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022c0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022c4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022c7:	48 89 d6             	mov    %rdx,%rsi
  8022ca:	89 c7                	mov    %eax,%edi
  8022cc:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  8022d3:	00 00 00 
  8022d6:	ff d0                	callq  *%rax
  8022d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022df:	78 24                	js     802305 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e5:	8b 00                	mov    (%rax),%eax
  8022e7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022eb:	48 89 d6             	mov    %rdx,%rsi
  8022ee:	89 c7                	mov    %eax,%edi
  8022f0:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  8022f7:	00 00 00 
  8022fa:	ff d0                	callq  *%rax
  8022fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802303:	79 05                	jns    80230a <read+0x5d>
		return r;
  802305:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802308:	eb 76                	jmp    802380 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80230a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230e:	8b 40 08             	mov    0x8(%rax),%eax
  802311:	83 e0 03             	and    $0x3,%eax
  802314:	83 f8 01             	cmp    $0x1,%eax
  802317:	75 3a                	jne    802353 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802319:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802320:	00 00 00 
  802323:	48 8b 00             	mov    (%rax),%rax
  802326:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80232c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80232f:	89 c6                	mov    %eax,%esi
  802331:	48 bf 6f 3c 80 00 00 	movabs $0x803c6f,%rdi
  802338:	00 00 00 
  80233b:	b8 00 00 00 00       	mov    $0x0,%eax
  802340:	48 b9 44 06 80 00 00 	movabs $0x800644,%rcx
  802347:	00 00 00 
  80234a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80234c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802351:	eb 2d                	jmp    802380 <read+0xd3>
	}
	if (!dev->dev_read)
  802353:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802357:	48 8b 40 10          	mov    0x10(%rax),%rax
  80235b:	48 85 c0             	test   %rax,%rax
  80235e:	75 07                	jne    802367 <read+0xba>
		return -E_NOT_SUPP;
  802360:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802365:	eb 19                	jmp    802380 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802367:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80236b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80236f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802373:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802377:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80237b:	48 89 cf             	mov    %rcx,%rdi
  80237e:	ff d0                	callq  *%rax
}
  802380:	c9                   	leaveq 
  802381:	c3                   	retq   

0000000000802382 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802382:	55                   	push   %rbp
  802383:	48 89 e5             	mov    %rsp,%rbp
  802386:	48 83 ec 30          	sub    $0x30,%rsp
  80238a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80238d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802391:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802395:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80239c:	eb 49                	jmp    8023e7 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80239e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a1:	48 98                	cltq   
  8023a3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023a7:	48 29 c2             	sub    %rax,%rdx
  8023aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ad:	48 63 c8             	movslq %eax,%rcx
  8023b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023b4:	48 01 c1             	add    %rax,%rcx
  8023b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023ba:	48 89 ce             	mov    %rcx,%rsi
  8023bd:	89 c7                	mov    %eax,%edi
  8023bf:	48 b8 ad 22 80 00 00 	movabs $0x8022ad,%rax
  8023c6:	00 00 00 
  8023c9:	ff d0                	callq  *%rax
  8023cb:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8023ce:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023d2:	79 05                	jns    8023d9 <readn+0x57>
			return m;
  8023d4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023d7:	eb 1c                	jmp    8023f5 <readn+0x73>
		if (m == 0)
  8023d9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023dd:	75 02                	jne    8023e1 <readn+0x5f>
			break;
  8023df:	eb 11                	jmp    8023f2 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023e1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023e4:	01 45 fc             	add    %eax,-0x4(%rbp)
  8023e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ea:	48 98                	cltq   
  8023ec:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8023f0:	72 ac                	jb     80239e <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8023f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023f5:	c9                   	leaveq 
  8023f6:	c3                   	retq   

00000000008023f7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8023f7:	55                   	push   %rbp
  8023f8:	48 89 e5             	mov    %rsp,%rbp
  8023fb:	48 83 ec 40          	sub    $0x40,%rsp
  8023ff:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802402:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802406:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80240a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80240e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802411:	48 89 d6             	mov    %rdx,%rsi
  802414:	89 c7                	mov    %eax,%edi
  802416:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  80241d:	00 00 00 
  802420:	ff d0                	callq  *%rax
  802422:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802425:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802429:	78 24                	js     80244f <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80242b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80242f:	8b 00                	mov    (%rax),%eax
  802431:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802435:	48 89 d6             	mov    %rdx,%rsi
  802438:	89 c7                	mov    %eax,%edi
  80243a:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  802441:	00 00 00 
  802444:	ff d0                	callq  *%rax
  802446:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802449:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80244d:	79 05                	jns    802454 <write+0x5d>
		return r;
  80244f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802452:	eb 75                	jmp    8024c9 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802454:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802458:	8b 40 08             	mov    0x8(%rax),%eax
  80245b:	83 e0 03             	and    $0x3,%eax
  80245e:	85 c0                	test   %eax,%eax
  802460:	75 3a                	jne    80249c <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802462:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802469:	00 00 00 
  80246c:	48 8b 00             	mov    (%rax),%rax
  80246f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802475:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802478:	89 c6                	mov    %eax,%esi
  80247a:	48 bf 8b 3c 80 00 00 	movabs $0x803c8b,%rdi
  802481:	00 00 00 
  802484:	b8 00 00 00 00       	mov    $0x0,%eax
  802489:	48 b9 44 06 80 00 00 	movabs $0x800644,%rcx
  802490:	00 00 00 
  802493:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802495:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80249a:	eb 2d                	jmp    8024c9 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80249c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024a0:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024a4:	48 85 c0             	test   %rax,%rax
  8024a7:	75 07                	jne    8024b0 <write+0xb9>
		return -E_NOT_SUPP;
  8024a9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024ae:	eb 19                	jmp    8024c9 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8024b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b4:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024b8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024bc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024c0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024c4:	48 89 cf             	mov    %rcx,%rdi
  8024c7:	ff d0                	callq  *%rax
}
  8024c9:	c9                   	leaveq 
  8024ca:	c3                   	retq   

00000000008024cb <seek>:

int
seek(int fdnum, off_t offset)
{
  8024cb:	55                   	push   %rbp
  8024cc:	48 89 e5             	mov    %rsp,%rbp
  8024cf:	48 83 ec 18          	sub    $0x18,%rsp
  8024d3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024d6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024d9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024e0:	48 89 d6             	mov    %rdx,%rsi
  8024e3:	89 c7                	mov    %eax,%edi
  8024e5:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  8024ec:	00 00 00 
  8024ef:	ff d0                	callq  *%rax
  8024f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f8:	79 05                	jns    8024ff <seek+0x34>
		return r;
  8024fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024fd:	eb 0f                	jmp    80250e <seek+0x43>
	fd->fd_offset = offset;
  8024ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802503:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802506:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802509:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80250e:	c9                   	leaveq 
  80250f:	c3                   	retq   

0000000000802510 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802510:	55                   	push   %rbp
  802511:	48 89 e5             	mov    %rsp,%rbp
  802514:	48 83 ec 30          	sub    $0x30,%rsp
  802518:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80251b:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80251e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802522:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802525:	48 89 d6             	mov    %rdx,%rsi
  802528:	89 c7                	mov    %eax,%edi
  80252a:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  802531:	00 00 00 
  802534:	ff d0                	callq  *%rax
  802536:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802539:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80253d:	78 24                	js     802563 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80253f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802543:	8b 00                	mov    (%rax),%eax
  802545:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802549:	48 89 d6             	mov    %rdx,%rsi
  80254c:	89 c7                	mov    %eax,%edi
  80254e:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  802555:	00 00 00 
  802558:	ff d0                	callq  *%rax
  80255a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80255d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802561:	79 05                	jns    802568 <ftruncate+0x58>
		return r;
  802563:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802566:	eb 72                	jmp    8025da <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802568:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80256c:	8b 40 08             	mov    0x8(%rax),%eax
  80256f:	83 e0 03             	and    $0x3,%eax
  802572:	85 c0                	test   %eax,%eax
  802574:	75 3a                	jne    8025b0 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802576:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80257d:	00 00 00 
  802580:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802583:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802589:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80258c:	89 c6                	mov    %eax,%esi
  80258e:	48 bf a8 3c 80 00 00 	movabs $0x803ca8,%rdi
  802595:	00 00 00 
  802598:	b8 00 00 00 00       	mov    $0x0,%eax
  80259d:	48 b9 44 06 80 00 00 	movabs $0x800644,%rcx
  8025a4:	00 00 00 
  8025a7:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8025a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025ae:	eb 2a                	jmp    8025da <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8025b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b4:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025b8:	48 85 c0             	test   %rax,%rax
  8025bb:	75 07                	jne    8025c4 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8025bd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025c2:	eb 16                	jmp    8025da <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8025c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025c8:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025d0:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8025d3:	89 ce                	mov    %ecx,%esi
  8025d5:	48 89 d7             	mov    %rdx,%rdi
  8025d8:	ff d0                	callq  *%rax
}
  8025da:	c9                   	leaveq 
  8025db:	c3                   	retq   

00000000008025dc <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8025dc:	55                   	push   %rbp
  8025dd:	48 89 e5             	mov    %rsp,%rbp
  8025e0:	48 83 ec 30          	sub    $0x30,%rsp
  8025e4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025e7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025eb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025ef:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025f2:	48 89 d6             	mov    %rdx,%rsi
  8025f5:	89 c7                	mov    %eax,%edi
  8025f7:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  8025fe:	00 00 00 
  802601:	ff d0                	callq  *%rax
  802603:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802606:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80260a:	78 24                	js     802630 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80260c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802610:	8b 00                	mov    (%rax),%eax
  802612:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802616:	48 89 d6             	mov    %rdx,%rsi
  802619:	89 c7                	mov    %eax,%edi
  80261b:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  802622:	00 00 00 
  802625:	ff d0                	callq  *%rax
  802627:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80262a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80262e:	79 05                	jns    802635 <fstat+0x59>
		return r;
  802630:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802633:	eb 5e                	jmp    802693 <fstat+0xb7>
	if (!dev->dev_stat)
  802635:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802639:	48 8b 40 28          	mov    0x28(%rax),%rax
  80263d:	48 85 c0             	test   %rax,%rax
  802640:	75 07                	jne    802649 <fstat+0x6d>
		return -E_NOT_SUPP;
  802642:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802647:	eb 4a                	jmp    802693 <fstat+0xb7>
	stat->st_name[0] = 0;
  802649:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80264d:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802650:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802654:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80265b:	00 00 00 
	stat->st_isdir = 0;
  80265e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802662:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802669:	00 00 00 
	stat->st_dev = dev;
  80266c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802670:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802674:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80267b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80267f:	48 8b 40 28          	mov    0x28(%rax),%rax
  802683:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802687:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80268b:	48 89 ce             	mov    %rcx,%rsi
  80268e:	48 89 d7             	mov    %rdx,%rdi
  802691:	ff d0                	callq  *%rax
}
  802693:	c9                   	leaveq 
  802694:	c3                   	retq   

0000000000802695 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802695:	55                   	push   %rbp
  802696:	48 89 e5             	mov    %rsp,%rbp
  802699:	48 83 ec 20          	sub    $0x20,%rsp
  80269d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a9:	be 00 00 00 00       	mov    $0x0,%esi
  8026ae:	48 89 c7             	mov    %rax,%rdi
  8026b1:	48 b8 83 27 80 00 00 	movabs $0x802783,%rax
  8026b8:	00 00 00 
  8026bb:	ff d0                	callq  *%rax
  8026bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c4:	79 05                	jns    8026cb <stat+0x36>
		return fd;
  8026c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026c9:	eb 2f                	jmp    8026fa <stat+0x65>
	r = fstat(fd, stat);
  8026cb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026d2:	48 89 d6             	mov    %rdx,%rsi
  8026d5:	89 c7                	mov    %eax,%edi
  8026d7:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  8026de:	00 00 00 
  8026e1:	ff d0                	callq  *%rax
  8026e3:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8026e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e9:	89 c7                	mov    %eax,%edi
  8026eb:	48 b8 8b 20 80 00 00 	movabs $0x80208b,%rax
  8026f2:	00 00 00 
  8026f5:	ff d0                	callq  *%rax
	return r;
  8026f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8026fa:	c9                   	leaveq 
  8026fb:	c3                   	retq   

00000000008026fc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8026fc:	55                   	push   %rbp
  8026fd:	48 89 e5             	mov    %rsp,%rbp
  802700:	48 83 ec 10          	sub    $0x10,%rsp
  802704:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802707:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80270b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802712:	00 00 00 
  802715:	8b 00                	mov    (%rax),%eax
  802717:	85 c0                	test   %eax,%eax
  802719:	75 1d                	jne    802738 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80271b:	bf 01 00 00 00       	mov    $0x1,%edi
  802720:	48 b8 a2 35 80 00 00 	movabs $0x8035a2,%rax
  802727:	00 00 00 
  80272a:	ff d0                	callq  *%rax
  80272c:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802733:	00 00 00 
  802736:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802738:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80273f:	00 00 00 
  802742:	8b 00                	mov    (%rax),%eax
  802744:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802747:	b9 07 00 00 00       	mov    $0x7,%ecx
  80274c:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802753:	00 00 00 
  802756:	89 c7                	mov    %eax,%edi
  802758:	48 b8 40 35 80 00 00 	movabs $0x803540,%rax
  80275f:	00 00 00 
  802762:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802764:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802768:	ba 00 00 00 00       	mov    $0x0,%edx
  80276d:	48 89 c6             	mov    %rax,%rsi
  802770:	bf 00 00 00 00       	mov    $0x0,%edi
  802775:	48 b8 3a 34 80 00 00 	movabs $0x80343a,%rax
  80277c:	00 00 00 
  80277f:	ff d0                	callq  *%rax
}
  802781:	c9                   	leaveq 
  802782:	c3                   	retq   

0000000000802783 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802783:	55                   	push   %rbp
  802784:	48 89 e5             	mov    %rsp,%rbp
  802787:	48 83 ec 30          	sub    $0x30,%rsp
  80278b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80278f:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802792:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802799:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8027a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8027a7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8027ac:	75 08                	jne    8027b6 <open+0x33>
	{
		return r;
  8027ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b1:	e9 f2 00 00 00       	jmpq   8028a8 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8027b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027ba:	48 89 c7             	mov    %rax,%rdi
  8027bd:	48 b8 8d 11 80 00 00 	movabs $0x80118d,%rax
  8027c4:	00 00 00 
  8027c7:	ff d0                	callq  *%rax
  8027c9:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8027cc:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8027d3:	7e 0a                	jle    8027df <open+0x5c>
	{
		return -E_BAD_PATH;
  8027d5:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8027da:	e9 c9 00 00 00       	jmpq   8028a8 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8027df:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8027e6:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8027e7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8027eb:	48 89 c7             	mov    %rax,%rdi
  8027ee:	48 b8 e3 1d 80 00 00 	movabs $0x801de3,%rax
  8027f5:	00 00 00 
  8027f8:	ff d0                	callq  *%rax
  8027fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802801:	78 09                	js     80280c <open+0x89>
  802803:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802807:	48 85 c0             	test   %rax,%rax
  80280a:	75 08                	jne    802814 <open+0x91>
		{
			return r;
  80280c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80280f:	e9 94 00 00 00       	jmpq   8028a8 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802814:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802818:	ba 00 04 00 00       	mov    $0x400,%edx
  80281d:	48 89 c6             	mov    %rax,%rsi
  802820:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802827:	00 00 00 
  80282a:	48 b8 8b 12 80 00 00 	movabs $0x80128b,%rax
  802831:	00 00 00 
  802834:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802836:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80283d:	00 00 00 
  802840:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802843:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802849:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80284d:	48 89 c6             	mov    %rax,%rsi
  802850:	bf 01 00 00 00       	mov    $0x1,%edi
  802855:	48 b8 fc 26 80 00 00 	movabs $0x8026fc,%rax
  80285c:	00 00 00 
  80285f:	ff d0                	callq  *%rax
  802861:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802864:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802868:	79 2b                	jns    802895 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  80286a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80286e:	be 00 00 00 00       	mov    $0x0,%esi
  802873:	48 89 c7             	mov    %rax,%rdi
  802876:	48 b8 0b 1f 80 00 00 	movabs $0x801f0b,%rax
  80287d:	00 00 00 
  802880:	ff d0                	callq  *%rax
  802882:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802885:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802889:	79 05                	jns    802890 <open+0x10d>
			{
				return d;
  80288b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80288e:	eb 18                	jmp    8028a8 <open+0x125>
			}
			return r;
  802890:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802893:	eb 13                	jmp    8028a8 <open+0x125>
		}	
		return fd2num(fd_store);
  802895:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802899:	48 89 c7             	mov    %rax,%rdi
  80289c:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  8028a3:	00 00 00 
  8028a6:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8028a8:	c9                   	leaveq 
  8028a9:	c3                   	retq   

00000000008028aa <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8028aa:	55                   	push   %rbp
  8028ab:	48 89 e5             	mov    %rsp,%rbp
  8028ae:	48 83 ec 10          	sub    $0x10,%rsp
  8028b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8028b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028ba:	8b 50 0c             	mov    0xc(%rax),%edx
  8028bd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028c4:	00 00 00 
  8028c7:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8028c9:	be 00 00 00 00       	mov    $0x0,%esi
  8028ce:	bf 06 00 00 00       	mov    $0x6,%edi
  8028d3:	48 b8 fc 26 80 00 00 	movabs $0x8026fc,%rax
  8028da:	00 00 00 
  8028dd:	ff d0                	callq  *%rax
}
  8028df:	c9                   	leaveq 
  8028e0:	c3                   	retq   

00000000008028e1 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8028e1:	55                   	push   %rbp
  8028e2:	48 89 e5             	mov    %rsp,%rbp
  8028e5:	48 83 ec 30          	sub    $0x30,%rsp
  8028e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028ed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028f1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8028f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8028fc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802901:	74 07                	je     80290a <devfile_read+0x29>
  802903:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802908:	75 07                	jne    802911 <devfile_read+0x30>
		return -E_INVAL;
  80290a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80290f:	eb 77                	jmp    802988 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802911:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802915:	8b 50 0c             	mov    0xc(%rax),%edx
  802918:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80291f:	00 00 00 
  802922:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802924:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80292b:	00 00 00 
  80292e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802932:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802936:	be 00 00 00 00       	mov    $0x0,%esi
  80293b:	bf 03 00 00 00       	mov    $0x3,%edi
  802940:	48 b8 fc 26 80 00 00 	movabs $0x8026fc,%rax
  802947:	00 00 00 
  80294a:	ff d0                	callq  *%rax
  80294c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80294f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802953:	7f 05                	jg     80295a <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802955:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802958:	eb 2e                	jmp    802988 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80295a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295d:	48 63 d0             	movslq %eax,%rdx
  802960:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802964:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80296b:	00 00 00 
  80296e:	48 89 c7             	mov    %rax,%rdi
  802971:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  802978:	00 00 00 
  80297b:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  80297d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802981:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802985:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802988:	c9                   	leaveq 
  802989:	c3                   	retq   

000000000080298a <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80298a:	55                   	push   %rbp
  80298b:	48 89 e5             	mov    %rsp,%rbp
  80298e:	48 83 ec 30          	sub    $0x30,%rsp
  802992:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802996:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80299a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80299e:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8029a5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8029aa:	74 07                	je     8029b3 <devfile_write+0x29>
  8029ac:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8029b1:	75 08                	jne    8029bb <devfile_write+0x31>
		return r;
  8029b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b6:	e9 9a 00 00 00       	jmpq   802a55 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8029bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029bf:	8b 50 0c             	mov    0xc(%rax),%edx
  8029c2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029c9:	00 00 00 
  8029cc:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8029ce:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8029d5:	00 
  8029d6:	76 08                	jbe    8029e0 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8029d8:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8029df:	00 
	}
	fsipcbuf.write.req_n = n;
  8029e0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029e7:	00 00 00 
  8029ea:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029ee:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8029f2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029fa:	48 89 c6             	mov    %rax,%rsi
  8029fd:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802a04:	00 00 00 
  802a07:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  802a0e:	00 00 00 
  802a11:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802a13:	be 00 00 00 00       	mov    $0x0,%esi
  802a18:	bf 04 00 00 00       	mov    $0x4,%edi
  802a1d:	48 b8 fc 26 80 00 00 	movabs $0x8026fc,%rax
  802a24:	00 00 00 
  802a27:	ff d0                	callq  *%rax
  802a29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a30:	7f 20                	jg     802a52 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802a32:	48 bf ce 3c 80 00 00 	movabs $0x803cce,%rdi
  802a39:	00 00 00 
  802a3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a41:	48 ba 44 06 80 00 00 	movabs $0x800644,%rdx
  802a48:	00 00 00 
  802a4b:	ff d2                	callq  *%rdx
		return r;
  802a4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a50:	eb 03                	jmp    802a55 <devfile_write+0xcb>
	}
	return r;
  802a52:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802a55:	c9                   	leaveq 
  802a56:	c3                   	retq   

0000000000802a57 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a57:	55                   	push   %rbp
  802a58:	48 89 e5             	mov    %rsp,%rbp
  802a5b:	48 83 ec 20          	sub    $0x20,%rsp
  802a5f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a63:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a6b:	8b 50 0c             	mov    0xc(%rax),%edx
  802a6e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a75:	00 00 00 
  802a78:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a7a:	be 00 00 00 00       	mov    $0x0,%esi
  802a7f:	bf 05 00 00 00       	mov    $0x5,%edi
  802a84:	48 b8 fc 26 80 00 00 	movabs $0x8026fc,%rax
  802a8b:	00 00 00 
  802a8e:	ff d0                	callq  *%rax
  802a90:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a97:	79 05                	jns    802a9e <devfile_stat+0x47>
		return r;
  802a99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a9c:	eb 56                	jmp    802af4 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a9e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aa2:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802aa9:	00 00 00 
  802aac:	48 89 c7             	mov    %rax,%rdi
  802aaf:	48 b8 f9 11 80 00 00 	movabs $0x8011f9,%rax
  802ab6:	00 00 00 
  802ab9:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802abb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ac2:	00 00 00 
  802ac5:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802acb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802acf:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802ad5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802adc:	00 00 00 
  802adf:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802ae5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ae9:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802aef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802af4:	c9                   	leaveq 
  802af5:	c3                   	retq   

0000000000802af6 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802af6:	55                   	push   %rbp
  802af7:	48 89 e5             	mov    %rsp,%rbp
  802afa:	48 83 ec 10          	sub    $0x10,%rsp
  802afe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b02:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b09:	8b 50 0c             	mov    0xc(%rax),%edx
  802b0c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b13:	00 00 00 
  802b16:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802b18:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b1f:	00 00 00 
  802b22:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b25:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b28:	be 00 00 00 00       	mov    $0x0,%esi
  802b2d:	bf 02 00 00 00       	mov    $0x2,%edi
  802b32:	48 b8 fc 26 80 00 00 	movabs $0x8026fc,%rax
  802b39:	00 00 00 
  802b3c:	ff d0                	callq  *%rax
}
  802b3e:	c9                   	leaveq 
  802b3f:	c3                   	retq   

0000000000802b40 <remove>:

// Delete a file
int
remove(const char *path)
{
  802b40:	55                   	push   %rbp
  802b41:	48 89 e5             	mov    %rsp,%rbp
  802b44:	48 83 ec 10          	sub    $0x10,%rsp
  802b48:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802b4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b50:	48 89 c7             	mov    %rax,%rdi
  802b53:	48 b8 8d 11 80 00 00 	movabs $0x80118d,%rax
  802b5a:	00 00 00 
  802b5d:	ff d0                	callq  *%rax
  802b5f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b64:	7e 07                	jle    802b6d <remove+0x2d>
		return -E_BAD_PATH;
  802b66:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b6b:	eb 33                	jmp    802ba0 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802b6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b71:	48 89 c6             	mov    %rax,%rsi
  802b74:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802b7b:	00 00 00 
  802b7e:	48 b8 f9 11 80 00 00 	movabs $0x8011f9,%rax
  802b85:	00 00 00 
  802b88:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802b8a:	be 00 00 00 00       	mov    $0x0,%esi
  802b8f:	bf 07 00 00 00       	mov    $0x7,%edi
  802b94:	48 b8 fc 26 80 00 00 	movabs $0x8026fc,%rax
  802b9b:	00 00 00 
  802b9e:	ff d0                	callq  *%rax
}
  802ba0:	c9                   	leaveq 
  802ba1:	c3                   	retq   

0000000000802ba2 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802ba2:	55                   	push   %rbp
  802ba3:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802ba6:	be 00 00 00 00       	mov    $0x0,%esi
  802bab:	bf 08 00 00 00       	mov    $0x8,%edi
  802bb0:	48 b8 fc 26 80 00 00 	movabs $0x8026fc,%rax
  802bb7:	00 00 00 
  802bba:	ff d0                	callq  *%rax
}
  802bbc:	5d                   	pop    %rbp
  802bbd:	c3                   	retq   

0000000000802bbe <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802bbe:	55                   	push   %rbp
  802bbf:	48 89 e5             	mov    %rsp,%rbp
  802bc2:	53                   	push   %rbx
  802bc3:	48 83 ec 38          	sub    $0x38,%rsp
  802bc7:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802bcb:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802bcf:	48 89 c7             	mov    %rax,%rdi
  802bd2:	48 b8 e3 1d 80 00 00 	movabs $0x801de3,%rax
  802bd9:	00 00 00 
  802bdc:	ff d0                	callq  *%rax
  802bde:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802be1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802be5:	0f 88 bf 01 00 00    	js     802daa <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802beb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bef:	ba 07 04 00 00       	mov    $0x407,%edx
  802bf4:	48 89 c6             	mov    %rax,%rsi
  802bf7:	bf 00 00 00 00       	mov    $0x0,%edi
  802bfc:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  802c03:	00 00 00 
  802c06:	ff d0                	callq  *%rax
  802c08:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c0b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c0f:	0f 88 95 01 00 00    	js     802daa <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802c15:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802c19:	48 89 c7             	mov    %rax,%rdi
  802c1c:	48 b8 e3 1d 80 00 00 	movabs $0x801de3,%rax
  802c23:	00 00 00 
  802c26:	ff d0                	callq  *%rax
  802c28:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c2f:	0f 88 5d 01 00 00    	js     802d92 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c39:	ba 07 04 00 00       	mov    $0x407,%edx
  802c3e:	48 89 c6             	mov    %rax,%rsi
  802c41:	bf 00 00 00 00       	mov    $0x0,%edi
  802c46:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  802c4d:	00 00 00 
  802c50:	ff d0                	callq  *%rax
  802c52:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c55:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c59:	0f 88 33 01 00 00    	js     802d92 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802c5f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c63:	48 89 c7             	mov    %rax,%rdi
  802c66:	48 b8 b8 1d 80 00 00 	movabs $0x801db8,%rax
  802c6d:	00 00 00 
  802c70:	ff d0                	callq  *%rax
  802c72:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c76:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c7a:	ba 07 04 00 00       	mov    $0x407,%edx
  802c7f:	48 89 c6             	mov    %rax,%rsi
  802c82:	bf 00 00 00 00       	mov    $0x0,%edi
  802c87:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  802c8e:	00 00 00 
  802c91:	ff d0                	callq  *%rax
  802c93:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c96:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c9a:	79 05                	jns    802ca1 <pipe+0xe3>
		goto err2;
  802c9c:	e9 d9 00 00 00       	jmpq   802d7a <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ca1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ca5:	48 89 c7             	mov    %rax,%rdi
  802ca8:	48 b8 b8 1d 80 00 00 	movabs $0x801db8,%rax
  802caf:	00 00 00 
  802cb2:	ff d0                	callq  *%rax
  802cb4:	48 89 c2             	mov    %rax,%rdx
  802cb7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cbb:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802cc1:	48 89 d1             	mov    %rdx,%rcx
  802cc4:	ba 00 00 00 00       	mov    $0x0,%edx
  802cc9:	48 89 c6             	mov    %rax,%rsi
  802ccc:	bf 00 00 00 00       	mov    $0x0,%edi
  802cd1:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  802cd8:	00 00 00 
  802cdb:	ff d0                	callq  *%rax
  802cdd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ce0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ce4:	79 1b                	jns    802d01 <pipe+0x143>
		goto err3;
  802ce6:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  802ce7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ceb:	48 89 c6             	mov    %rax,%rsi
  802cee:	bf 00 00 00 00       	mov    $0x0,%edi
  802cf3:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  802cfa:	00 00 00 
  802cfd:	ff d0                	callq  *%rax
  802cff:	eb 79                	jmp    802d7a <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802d01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d05:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802d0c:	00 00 00 
  802d0f:	8b 12                	mov    (%rdx),%edx
  802d11:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802d13:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d17:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802d1e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d22:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802d29:	00 00 00 
  802d2c:	8b 12                	mov    (%rdx),%edx
  802d2e:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802d30:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d34:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802d3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d3f:	48 89 c7             	mov    %rax,%rdi
  802d42:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  802d49:	00 00 00 
  802d4c:	ff d0                	callq  *%rax
  802d4e:	89 c2                	mov    %eax,%edx
  802d50:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802d54:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802d56:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802d5a:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802d5e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d62:	48 89 c7             	mov    %rax,%rdi
  802d65:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  802d6c:	00 00 00 
  802d6f:	ff d0                	callq  *%rax
  802d71:	89 03                	mov    %eax,(%rbx)
	return 0;
  802d73:	b8 00 00 00 00       	mov    $0x0,%eax
  802d78:	eb 33                	jmp    802dad <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  802d7a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d7e:	48 89 c6             	mov    %rax,%rsi
  802d81:	bf 00 00 00 00       	mov    $0x0,%edi
  802d86:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  802d8d:	00 00 00 
  802d90:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  802d92:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d96:	48 89 c6             	mov    %rax,%rsi
  802d99:	bf 00 00 00 00       	mov    $0x0,%edi
  802d9e:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  802da5:	00 00 00 
  802da8:	ff d0                	callq  *%rax
    err:
	return r;
  802daa:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802dad:	48 83 c4 38          	add    $0x38,%rsp
  802db1:	5b                   	pop    %rbx
  802db2:	5d                   	pop    %rbp
  802db3:	c3                   	retq   

0000000000802db4 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802db4:	55                   	push   %rbp
  802db5:	48 89 e5             	mov    %rsp,%rbp
  802db8:	53                   	push   %rbx
  802db9:	48 83 ec 28          	sub    $0x28,%rsp
  802dbd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802dc1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802dc5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802dcc:	00 00 00 
  802dcf:	48 8b 00             	mov    (%rax),%rax
  802dd2:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802dd8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802ddb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ddf:	48 89 c7             	mov    %rax,%rdi
  802de2:	48 b8 24 36 80 00 00 	movabs $0x803624,%rax
  802de9:	00 00 00 
  802dec:	ff d0                	callq  *%rax
  802dee:	89 c3                	mov    %eax,%ebx
  802df0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802df4:	48 89 c7             	mov    %rax,%rdi
  802df7:	48 b8 24 36 80 00 00 	movabs $0x803624,%rax
  802dfe:	00 00 00 
  802e01:	ff d0                	callq  *%rax
  802e03:	39 c3                	cmp    %eax,%ebx
  802e05:	0f 94 c0             	sete   %al
  802e08:	0f b6 c0             	movzbl %al,%eax
  802e0b:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802e0e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802e15:	00 00 00 
  802e18:	48 8b 00             	mov    (%rax),%rax
  802e1b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802e21:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802e24:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e27:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802e2a:	75 05                	jne    802e31 <_pipeisclosed+0x7d>
			return ret;
  802e2c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e2f:	eb 4f                	jmp    802e80 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802e31:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e34:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802e37:	74 42                	je     802e7b <_pipeisclosed+0xc7>
  802e39:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802e3d:	75 3c                	jne    802e7b <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802e3f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802e46:	00 00 00 
  802e49:	48 8b 00             	mov    (%rax),%rax
  802e4c:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802e52:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802e55:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e58:	89 c6                	mov    %eax,%esi
  802e5a:	48 bf ef 3c 80 00 00 	movabs $0x803cef,%rdi
  802e61:	00 00 00 
  802e64:	b8 00 00 00 00       	mov    $0x0,%eax
  802e69:	49 b8 44 06 80 00 00 	movabs $0x800644,%r8
  802e70:	00 00 00 
  802e73:	41 ff d0             	callq  *%r8
	}
  802e76:	e9 4a ff ff ff       	jmpq   802dc5 <_pipeisclosed+0x11>
  802e7b:	e9 45 ff ff ff       	jmpq   802dc5 <_pipeisclosed+0x11>
}
  802e80:	48 83 c4 28          	add    $0x28,%rsp
  802e84:	5b                   	pop    %rbx
  802e85:	5d                   	pop    %rbp
  802e86:	c3                   	retq   

0000000000802e87 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802e87:	55                   	push   %rbp
  802e88:	48 89 e5             	mov    %rsp,%rbp
  802e8b:	48 83 ec 30          	sub    $0x30,%rsp
  802e8f:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e92:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e96:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e99:	48 89 d6             	mov    %rdx,%rsi
  802e9c:	89 c7                	mov    %eax,%edi
  802e9e:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  802ea5:	00 00 00 
  802ea8:	ff d0                	callq  *%rax
  802eaa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ead:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eb1:	79 05                	jns    802eb8 <pipeisclosed+0x31>
		return r;
  802eb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb6:	eb 31                	jmp    802ee9 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802eb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ebc:	48 89 c7             	mov    %rax,%rdi
  802ebf:	48 b8 b8 1d 80 00 00 	movabs $0x801db8,%rax
  802ec6:	00 00 00 
  802ec9:	ff d0                	callq  *%rax
  802ecb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802ecf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ed3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ed7:	48 89 d6             	mov    %rdx,%rsi
  802eda:	48 89 c7             	mov    %rax,%rdi
  802edd:	48 b8 b4 2d 80 00 00 	movabs $0x802db4,%rax
  802ee4:	00 00 00 
  802ee7:	ff d0                	callq  *%rax
}
  802ee9:	c9                   	leaveq 
  802eea:	c3                   	retq   

0000000000802eeb <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802eeb:	55                   	push   %rbp
  802eec:	48 89 e5             	mov    %rsp,%rbp
  802eef:	48 83 ec 40          	sub    $0x40,%rsp
  802ef3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802ef7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802efb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802eff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f03:	48 89 c7             	mov    %rax,%rdi
  802f06:	48 b8 b8 1d 80 00 00 	movabs $0x801db8,%rax
  802f0d:	00 00 00 
  802f10:	ff d0                	callq  *%rax
  802f12:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802f16:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f1a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802f1e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802f25:	00 
  802f26:	e9 92 00 00 00       	jmpq   802fbd <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802f2b:	eb 41                	jmp    802f6e <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802f2d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802f32:	74 09                	je     802f3d <devpipe_read+0x52>
				return i;
  802f34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f38:	e9 92 00 00 00       	jmpq   802fcf <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802f3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f45:	48 89 d6             	mov    %rdx,%rsi
  802f48:	48 89 c7             	mov    %rax,%rdi
  802f4b:	48 b8 b4 2d 80 00 00 	movabs $0x802db4,%rax
  802f52:	00 00 00 
  802f55:	ff d0                	callq  *%rax
  802f57:	85 c0                	test   %eax,%eax
  802f59:	74 07                	je     802f62 <devpipe_read+0x77>
				return 0;
  802f5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f60:	eb 6d                	jmp    802fcf <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802f62:	48 b8 ea 1a 80 00 00 	movabs $0x801aea,%rax
  802f69:	00 00 00 
  802f6c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802f6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f72:	8b 10                	mov    (%rax),%edx
  802f74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f78:	8b 40 04             	mov    0x4(%rax),%eax
  802f7b:	39 c2                	cmp    %eax,%edx
  802f7d:	74 ae                	je     802f2d <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802f7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f83:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f87:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802f8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f8f:	8b 00                	mov    (%rax),%eax
  802f91:	99                   	cltd   
  802f92:	c1 ea 1b             	shr    $0x1b,%edx
  802f95:	01 d0                	add    %edx,%eax
  802f97:	83 e0 1f             	and    $0x1f,%eax
  802f9a:	29 d0                	sub    %edx,%eax
  802f9c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802fa0:	48 98                	cltq   
  802fa2:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802fa7:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802fa9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fad:	8b 00                	mov    (%rax),%eax
  802faf:	8d 50 01             	lea    0x1(%rax),%edx
  802fb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb6:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802fb8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802fbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fc1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802fc5:	0f 82 60 ff ff ff    	jb     802f2b <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802fcb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802fcf:	c9                   	leaveq 
  802fd0:	c3                   	retq   

0000000000802fd1 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802fd1:	55                   	push   %rbp
  802fd2:	48 89 e5             	mov    %rsp,%rbp
  802fd5:	48 83 ec 40          	sub    $0x40,%rsp
  802fd9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802fdd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802fe1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802fe5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fe9:	48 89 c7             	mov    %rax,%rdi
  802fec:	48 b8 b8 1d 80 00 00 	movabs $0x801db8,%rax
  802ff3:	00 00 00 
  802ff6:	ff d0                	callq  *%rax
  802ff8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802ffc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803000:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803004:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80300b:	00 
  80300c:	e9 8e 00 00 00       	jmpq   80309f <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803011:	eb 31                	jmp    803044 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803013:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803017:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80301b:	48 89 d6             	mov    %rdx,%rsi
  80301e:	48 89 c7             	mov    %rax,%rdi
  803021:	48 b8 b4 2d 80 00 00 	movabs $0x802db4,%rax
  803028:	00 00 00 
  80302b:	ff d0                	callq  *%rax
  80302d:	85 c0                	test   %eax,%eax
  80302f:	74 07                	je     803038 <devpipe_write+0x67>
				return 0;
  803031:	b8 00 00 00 00       	mov    $0x0,%eax
  803036:	eb 79                	jmp    8030b1 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803038:	48 b8 ea 1a 80 00 00 	movabs $0x801aea,%rax
  80303f:	00 00 00 
  803042:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803044:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803048:	8b 40 04             	mov    0x4(%rax),%eax
  80304b:	48 63 d0             	movslq %eax,%rdx
  80304e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803052:	8b 00                	mov    (%rax),%eax
  803054:	48 98                	cltq   
  803056:	48 83 c0 20          	add    $0x20,%rax
  80305a:	48 39 c2             	cmp    %rax,%rdx
  80305d:	73 b4                	jae    803013 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80305f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803063:	8b 40 04             	mov    0x4(%rax),%eax
  803066:	99                   	cltd   
  803067:	c1 ea 1b             	shr    $0x1b,%edx
  80306a:	01 d0                	add    %edx,%eax
  80306c:	83 e0 1f             	and    $0x1f,%eax
  80306f:	29 d0                	sub    %edx,%eax
  803071:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803075:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803079:	48 01 ca             	add    %rcx,%rdx
  80307c:	0f b6 0a             	movzbl (%rdx),%ecx
  80307f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803083:	48 98                	cltq   
  803085:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803089:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80308d:	8b 40 04             	mov    0x4(%rax),%eax
  803090:	8d 50 01             	lea    0x1(%rax),%edx
  803093:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803097:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80309a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80309f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030a3:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8030a7:	0f 82 64 ff ff ff    	jb     803011 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8030ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8030b1:	c9                   	leaveq 
  8030b2:	c3                   	retq   

00000000008030b3 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8030b3:	55                   	push   %rbp
  8030b4:	48 89 e5             	mov    %rsp,%rbp
  8030b7:	48 83 ec 20          	sub    $0x20,%rsp
  8030bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8030c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030c7:	48 89 c7             	mov    %rax,%rdi
  8030ca:	48 b8 b8 1d 80 00 00 	movabs $0x801db8,%rax
  8030d1:	00 00 00 
  8030d4:	ff d0                	callq  *%rax
  8030d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8030da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030de:	48 be 02 3d 80 00 00 	movabs $0x803d02,%rsi
  8030e5:	00 00 00 
  8030e8:	48 89 c7             	mov    %rax,%rdi
  8030eb:	48 b8 f9 11 80 00 00 	movabs $0x8011f9,%rax
  8030f2:	00 00 00 
  8030f5:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8030f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030fb:	8b 50 04             	mov    0x4(%rax),%edx
  8030fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803102:	8b 00                	mov    (%rax),%eax
  803104:	29 c2                	sub    %eax,%edx
  803106:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80310a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803110:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803114:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80311b:	00 00 00 
	stat->st_dev = &devpipe;
  80311e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803122:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  803129:	00 00 00 
  80312c:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803133:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803138:	c9                   	leaveq 
  803139:	c3                   	retq   

000000000080313a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80313a:	55                   	push   %rbp
  80313b:	48 89 e5             	mov    %rsp,%rbp
  80313e:	48 83 ec 10          	sub    $0x10,%rsp
  803142:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803146:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80314a:	48 89 c6             	mov    %rax,%rsi
  80314d:	bf 00 00 00 00       	mov    $0x0,%edi
  803152:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  803159:	00 00 00 
  80315c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80315e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803162:	48 89 c7             	mov    %rax,%rdi
  803165:	48 b8 b8 1d 80 00 00 	movabs $0x801db8,%rax
  80316c:	00 00 00 
  80316f:	ff d0                	callq  *%rax
  803171:	48 89 c6             	mov    %rax,%rsi
  803174:	bf 00 00 00 00       	mov    $0x0,%edi
  803179:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  803180:	00 00 00 
  803183:	ff d0                	callq  *%rax
}
  803185:	c9                   	leaveq 
  803186:	c3                   	retq   

0000000000803187 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803187:	55                   	push   %rbp
  803188:	48 89 e5             	mov    %rsp,%rbp
  80318b:	48 83 ec 20          	sub    $0x20,%rsp
  80318f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803192:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803195:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803198:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80319c:	be 01 00 00 00       	mov    $0x1,%esi
  8031a1:	48 89 c7             	mov    %rax,%rdi
  8031a4:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  8031ab:	00 00 00 
  8031ae:	ff d0                	callq  *%rax
}
  8031b0:	c9                   	leaveq 
  8031b1:	c3                   	retq   

00000000008031b2 <getchar>:

int
getchar(void)
{
  8031b2:	55                   	push   %rbp
  8031b3:	48 89 e5             	mov    %rsp,%rbp
  8031b6:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8031ba:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8031be:	ba 01 00 00 00       	mov    $0x1,%edx
  8031c3:	48 89 c6             	mov    %rax,%rsi
  8031c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8031cb:	48 b8 ad 22 80 00 00 	movabs $0x8022ad,%rax
  8031d2:	00 00 00 
  8031d5:	ff d0                	callq  *%rax
  8031d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8031da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031de:	79 05                	jns    8031e5 <getchar+0x33>
		return r;
  8031e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e3:	eb 14                	jmp    8031f9 <getchar+0x47>
	if (r < 1)
  8031e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031e9:	7f 07                	jg     8031f2 <getchar+0x40>
		return -E_EOF;
  8031eb:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8031f0:	eb 07                	jmp    8031f9 <getchar+0x47>
	return c;
  8031f2:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8031f6:	0f b6 c0             	movzbl %al,%eax
}
  8031f9:	c9                   	leaveq 
  8031fa:	c3                   	retq   

00000000008031fb <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8031fb:	55                   	push   %rbp
  8031fc:	48 89 e5             	mov    %rsp,%rbp
  8031ff:	48 83 ec 20          	sub    $0x20,%rsp
  803203:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803206:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80320a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80320d:	48 89 d6             	mov    %rdx,%rsi
  803210:	89 c7                	mov    %eax,%edi
  803212:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  803219:	00 00 00 
  80321c:	ff d0                	callq  *%rax
  80321e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803221:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803225:	79 05                	jns    80322c <iscons+0x31>
		return r;
  803227:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80322a:	eb 1a                	jmp    803246 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80322c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803230:	8b 10                	mov    (%rax),%edx
  803232:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  803239:	00 00 00 
  80323c:	8b 00                	mov    (%rax),%eax
  80323e:	39 c2                	cmp    %eax,%edx
  803240:	0f 94 c0             	sete   %al
  803243:	0f b6 c0             	movzbl %al,%eax
}
  803246:	c9                   	leaveq 
  803247:	c3                   	retq   

0000000000803248 <opencons>:

int
opencons(void)
{
  803248:	55                   	push   %rbp
  803249:	48 89 e5             	mov    %rsp,%rbp
  80324c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803250:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803254:	48 89 c7             	mov    %rax,%rdi
  803257:	48 b8 e3 1d 80 00 00 	movabs $0x801de3,%rax
  80325e:	00 00 00 
  803261:	ff d0                	callq  *%rax
  803263:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803266:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80326a:	79 05                	jns    803271 <opencons+0x29>
		return r;
  80326c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80326f:	eb 5b                	jmp    8032cc <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803271:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803275:	ba 07 04 00 00       	mov    $0x407,%edx
  80327a:	48 89 c6             	mov    %rax,%rsi
  80327d:	bf 00 00 00 00       	mov    $0x0,%edi
  803282:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  803289:	00 00 00 
  80328c:	ff d0                	callq  *%rax
  80328e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803291:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803295:	79 05                	jns    80329c <opencons+0x54>
		return r;
  803297:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80329a:	eb 30                	jmp    8032cc <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80329c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a0:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8032a7:	00 00 00 
  8032aa:	8b 12                	mov    (%rdx),%edx
  8032ac:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8032ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8032b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032bd:	48 89 c7             	mov    %rax,%rdi
  8032c0:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  8032c7:	00 00 00 
  8032ca:	ff d0                	callq  *%rax
}
  8032cc:	c9                   	leaveq 
  8032cd:	c3                   	retq   

00000000008032ce <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8032ce:	55                   	push   %rbp
  8032cf:	48 89 e5             	mov    %rsp,%rbp
  8032d2:	48 83 ec 30          	sub    $0x30,%rsp
  8032d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032de:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8032e2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8032e7:	75 07                	jne    8032f0 <devcons_read+0x22>
		return 0;
  8032e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ee:	eb 4b                	jmp    80333b <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8032f0:	eb 0c                	jmp    8032fe <devcons_read+0x30>
		sys_yield();
  8032f2:	48 b8 ea 1a 80 00 00 	movabs $0x801aea,%rax
  8032f9:	00 00 00 
  8032fc:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8032fe:	48 b8 2a 1a 80 00 00 	movabs $0x801a2a,%rax
  803305:	00 00 00 
  803308:	ff d0                	callq  *%rax
  80330a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80330d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803311:	74 df                	je     8032f2 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803313:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803317:	79 05                	jns    80331e <devcons_read+0x50>
		return c;
  803319:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80331c:	eb 1d                	jmp    80333b <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80331e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803322:	75 07                	jne    80332b <devcons_read+0x5d>
		return 0;
  803324:	b8 00 00 00 00       	mov    $0x0,%eax
  803329:	eb 10                	jmp    80333b <devcons_read+0x6d>
	*(char*)vbuf = c;
  80332b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80332e:	89 c2                	mov    %eax,%edx
  803330:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803334:	88 10                	mov    %dl,(%rax)
	return 1;
  803336:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80333b:	c9                   	leaveq 
  80333c:	c3                   	retq   

000000000080333d <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80333d:	55                   	push   %rbp
  80333e:	48 89 e5             	mov    %rsp,%rbp
  803341:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803348:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80334f:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803356:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80335d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803364:	eb 76                	jmp    8033dc <devcons_write+0x9f>
		m = n - tot;
  803366:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80336d:	89 c2                	mov    %eax,%edx
  80336f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803372:	29 c2                	sub    %eax,%edx
  803374:	89 d0                	mov    %edx,%eax
  803376:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803379:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80337c:	83 f8 7f             	cmp    $0x7f,%eax
  80337f:	76 07                	jbe    803388 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803381:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803388:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80338b:	48 63 d0             	movslq %eax,%rdx
  80338e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803391:	48 63 c8             	movslq %eax,%rcx
  803394:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80339b:	48 01 c1             	add    %rax,%rcx
  80339e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8033a5:	48 89 ce             	mov    %rcx,%rsi
  8033a8:	48 89 c7             	mov    %rax,%rdi
  8033ab:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  8033b2:	00 00 00 
  8033b5:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8033b7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033ba:	48 63 d0             	movslq %eax,%rdx
  8033bd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8033c4:	48 89 d6             	mov    %rdx,%rsi
  8033c7:	48 89 c7             	mov    %rax,%rdi
  8033ca:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  8033d1:	00 00 00 
  8033d4:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8033d6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033d9:	01 45 fc             	add    %eax,-0x4(%rbp)
  8033dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033df:	48 98                	cltq   
  8033e1:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8033e8:	0f 82 78 ff ff ff    	jb     803366 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8033ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8033f1:	c9                   	leaveq 
  8033f2:	c3                   	retq   

00000000008033f3 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8033f3:	55                   	push   %rbp
  8033f4:	48 89 e5             	mov    %rsp,%rbp
  8033f7:	48 83 ec 08          	sub    $0x8,%rsp
  8033fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8033ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803404:	c9                   	leaveq 
  803405:	c3                   	retq   

0000000000803406 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803406:	55                   	push   %rbp
  803407:	48 89 e5             	mov    %rsp,%rbp
  80340a:	48 83 ec 10          	sub    $0x10,%rsp
  80340e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803412:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803416:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80341a:	48 be 0e 3d 80 00 00 	movabs $0x803d0e,%rsi
  803421:	00 00 00 
  803424:	48 89 c7             	mov    %rax,%rdi
  803427:	48 b8 f9 11 80 00 00 	movabs $0x8011f9,%rax
  80342e:	00 00 00 
  803431:	ff d0                	callq  *%rax
	return 0;
  803433:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803438:	c9                   	leaveq 
  803439:	c3                   	retq   

000000000080343a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80343a:	55                   	push   %rbp
  80343b:	48 89 e5             	mov    %rsp,%rbp
  80343e:	48 83 ec 30          	sub    $0x30,%rsp
  803442:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803446:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80344a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  80344e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803455:	00 00 00 
  803458:	48 8b 00             	mov    (%rax),%rax
  80345b:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803461:	85 c0                	test   %eax,%eax
  803463:	75 3c                	jne    8034a1 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803465:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  80346c:	00 00 00 
  80346f:	ff d0                	callq  *%rax
  803471:	25 ff 03 00 00       	and    $0x3ff,%eax
  803476:	48 63 d0             	movslq %eax,%rdx
  803479:	48 89 d0             	mov    %rdx,%rax
  80347c:	48 c1 e0 03          	shl    $0x3,%rax
  803480:	48 01 d0             	add    %rdx,%rax
  803483:	48 c1 e0 05          	shl    $0x5,%rax
  803487:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80348e:	00 00 00 
  803491:	48 01 c2             	add    %rax,%rdx
  803494:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80349b:	00 00 00 
  80349e:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8034a1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8034a6:	75 0e                	jne    8034b6 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  8034a8:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8034af:	00 00 00 
  8034b2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8034b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034ba:	48 89 c7             	mov    %rax,%rdi
  8034bd:	48 b8 51 1d 80 00 00 	movabs $0x801d51,%rax
  8034c4:	00 00 00 
  8034c7:	ff d0                	callq  *%rax
  8034c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8034cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034d0:	79 19                	jns    8034eb <ipc_recv+0xb1>
		*from_env_store = 0;
  8034d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034d6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8034dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034e0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8034e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034e9:	eb 53                	jmp    80353e <ipc_recv+0x104>
	}
	if(from_env_store)
  8034eb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8034f0:	74 19                	je     80350b <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  8034f2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8034f9:	00 00 00 
  8034fc:	48 8b 00             	mov    (%rax),%rax
  8034ff:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803505:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803509:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80350b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803510:	74 19                	je     80352b <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803512:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803519:	00 00 00 
  80351c:	48 8b 00             	mov    (%rax),%rax
  80351f:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803525:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803529:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  80352b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803532:	00 00 00 
  803535:	48 8b 00             	mov    (%rax),%rax
  803538:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  80353e:	c9                   	leaveq 
  80353f:	c3                   	retq   

0000000000803540 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803540:	55                   	push   %rbp
  803541:	48 89 e5             	mov    %rsp,%rbp
  803544:	48 83 ec 30          	sub    $0x30,%rsp
  803548:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80354b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80354e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803552:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803555:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80355a:	75 0e                	jne    80356a <ipc_send+0x2a>
		pg = (void*)UTOP;
  80355c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803563:	00 00 00 
  803566:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80356a:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80356d:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803570:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803574:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803577:	89 c7                	mov    %eax,%edi
  803579:	48 b8 fc 1c 80 00 00 	movabs $0x801cfc,%rax
  803580:	00 00 00 
  803583:	ff d0                	callq  *%rax
  803585:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803588:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80358c:	75 0c                	jne    80359a <ipc_send+0x5a>
			sys_yield();
  80358e:	48 b8 ea 1a 80 00 00 	movabs $0x801aea,%rax
  803595:	00 00 00 
  803598:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80359a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80359e:	74 ca                	je     80356a <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8035a0:	c9                   	leaveq 
  8035a1:	c3                   	retq   

00000000008035a2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8035a2:	55                   	push   %rbp
  8035a3:	48 89 e5             	mov    %rsp,%rbp
  8035a6:	48 83 ec 14          	sub    $0x14,%rsp
  8035aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8035ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8035b4:	eb 5e                	jmp    803614 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8035b6:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8035bd:	00 00 00 
  8035c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c3:	48 63 d0             	movslq %eax,%rdx
  8035c6:	48 89 d0             	mov    %rdx,%rax
  8035c9:	48 c1 e0 03          	shl    $0x3,%rax
  8035cd:	48 01 d0             	add    %rdx,%rax
  8035d0:	48 c1 e0 05          	shl    $0x5,%rax
  8035d4:	48 01 c8             	add    %rcx,%rax
  8035d7:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8035dd:	8b 00                	mov    (%rax),%eax
  8035df:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8035e2:	75 2c                	jne    803610 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8035e4:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8035eb:	00 00 00 
  8035ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f1:	48 63 d0             	movslq %eax,%rdx
  8035f4:	48 89 d0             	mov    %rdx,%rax
  8035f7:	48 c1 e0 03          	shl    $0x3,%rax
  8035fb:	48 01 d0             	add    %rdx,%rax
  8035fe:	48 c1 e0 05          	shl    $0x5,%rax
  803602:	48 01 c8             	add    %rcx,%rax
  803605:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80360b:	8b 40 08             	mov    0x8(%rax),%eax
  80360e:	eb 12                	jmp    803622 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803610:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803614:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80361b:	7e 99                	jle    8035b6 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80361d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803622:	c9                   	leaveq 
  803623:	c3                   	retq   

0000000000803624 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803624:	55                   	push   %rbp
  803625:	48 89 e5             	mov    %rsp,%rbp
  803628:	48 83 ec 18          	sub    $0x18,%rsp
  80362c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803634:	48 c1 e8 15          	shr    $0x15,%rax
  803638:	48 89 c2             	mov    %rax,%rdx
  80363b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803642:	01 00 00 
  803645:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803649:	83 e0 01             	and    $0x1,%eax
  80364c:	48 85 c0             	test   %rax,%rax
  80364f:	75 07                	jne    803658 <pageref+0x34>
		return 0;
  803651:	b8 00 00 00 00       	mov    $0x0,%eax
  803656:	eb 53                	jmp    8036ab <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803658:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80365c:	48 c1 e8 0c          	shr    $0xc,%rax
  803660:	48 89 c2             	mov    %rax,%rdx
  803663:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80366a:	01 00 00 
  80366d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803671:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803675:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803679:	83 e0 01             	and    $0x1,%eax
  80367c:	48 85 c0             	test   %rax,%rax
  80367f:	75 07                	jne    803688 <pageref+0x64>
		return 0;
  803681:	b8 00 00 00 00       	mov    $0x0,%eax
  803686:	eb 23                	jmp    8036ab <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803688:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80368c:	48 c1 e8 0c          	shr    $0xc,%rax
  803690:	48 89 c2             	mov    %rax,%rdx
  803693:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80369a:	00 00 00 
  80369d:	48 c1 e2 04          	shl    $0x4,%rdx
  8036a1:	48 01 d0             	add    %rdx,%rax
  8036a4:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8036a8:	0f b7 c0             	movzwl %ax,%eax
}
  8036ab:	c9                   	leaveq 
  8036ac:	c3                   	retq   
