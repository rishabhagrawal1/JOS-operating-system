
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
  800070:	48 b8 60 41 80 00 00 	movabs $0x804160,%rax
  800077:	00 00 00 
  80007a:	eb 0a                	jmp    800086 <umain+0x43>
  80007c:	48 b8 67 41 80 00 00 	movabs $0x804167,%rax
  800083:	00 00 00 
  800086:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800089:	48 89 c2             	mov    %rax,%rdx
  80008c:	89 ce                	mov    %ecx,%esi
  80008e:	48 bf 6d 41 80 00 00 	movabs $0x80416d,%rdi
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
  80010c:	48 ba 7f 41 80 00 00 	movabs $0x80417f,%rdx
  800113:	00 00 00 
  800116:	be 20 00 00 00       	mov    $0x20,%esi
  80011b:	48 bf 92 41 80 00 00 	movabs $0x804192,%rdi
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
  80016a:	48 ba a2 41 80 00 00 	movabs $0x8041a2,%rdx
  800171:	00 00 00 
  800174:	be 22 00 00 00       	mov    $0x22,%esi
  800179:	48 bf 92 41 80 00 00 	movabs $0x804192,%rdi
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
  8001d6:	48 ba b3 41 80 00 00 	movabs $0x8041b3,%rdx
  8001dd:	00 00 00 
  8001e0:	be 25 00 00 00       	mov    $0x25,%esi
  8001e5:	48 bf 92 41 80 00 00 	movabs $0x804192,%rdi
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
  800226:	48 ba c6 41 80 00 00 	movabs $0x8041c6,%rdx
  80022d:	00 00 00 
  800230:	be 37 00 00 00       	mov    $0x37,%esi
  800235:	48 bf 92 41 80 00 00 	movabs $0x804192,%rdi
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
  800286:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
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
  8002d1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
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
  80032d:	48 ba d6 41 80 00 00 	movabs $0x8041d6,%rdx
  800334:	00 00 00 
  800337:	be 4c 00 00 00       	mov    $0x4c,%esi
  80033c:	48 bf 92 41 80 00 00 	movabs $0x804192,%rdi
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
  80039b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
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
  8003b5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
  8003ec:	48 b8 a0 21 80 00 00 	movabs $0x8021a0,%rax
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
  800494:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
  8004c5:	48 bf f8 41 80 00 00 	movabs $0x8041f8,%rdi
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
  800501:	48 bf 1b 42 80 00 00 	movabs $0x80421b,%rdi
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
  8007b0:	48 ba 10 44 80 00 00 	movabs $0x804410,%rdx
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
  800aa8:	48 b8 38 44 80 00 00 	movabs $0x804438,%rax
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
  800bf6:	83 fb 15             	cmp    $0x15,%ebx
  800bf9:	7f 16                	jg     800c11 <vprintfmt+0x21a>
  800bfb:	48 b8 60 43 80 00 00 	movabs $0x804360,%rax
  800c02:	00 00 00 
  800c05:	48 63 d3             	movslq %ebx,%rdx
  800c08:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c0c:	4d 85 e4             	test   %r12,%r12
  800c0f:	75 2e                	jne    800c3f <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800c11:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c15:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c19:	89 d9                	mov    %ebx,%ecx
  800c1b:	48 ba 21 44 80 00 00 	movabs $0x804421,%rdx
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
  800c4a:	48 ba 2a 44 80 00 00 	movabs $0x80442a,%rdx
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
  800ca4:	49 bc 2d 44 80 00 00 	movabs $0x80442d,%r12
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
  8019aa:	48 ba e8 46 80 00 00 	movabs $0x8046e8,%rdx
  8019b1:	00 00 00 
  8019b4:	be 23 00 00 00       	mov    $0x23,%esi
  8019b9:	48 bf 05 47 80 00 00 	movabs $0x804705,%rdi
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

0000000000801d95 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801d95:	55                   	push   %rbp
  801d96:	48 89 e5             	mov    %rsp,%rbp
  801d99:	48 83 ec 20          	sub    $0x20,%rsp
  801d9d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801da1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801da5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801da9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db4:	00 
  801db5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dbb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dc1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dc6:	89 c6                	mov    %eax,%esi
  801dc8:	bf 0f 00 00 00       	mov    $0xf,%edi
  801dcd:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801dd4:	00 00 00 
  801dd7:	ff d0                	callq  *%rax
}
  801dd9:	c9                   	leaveq 
  801dda:	c3                   	retq   

0000000000801ddb <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801ddb:	55                   	push   %rbp
  801ddc:	48 89 e5             	mov    %rsp,%rbp
  801ddf:	48 83 ec 20          	sub    $0x20,%rsp
  801de3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801de7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801deb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801def:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801df3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dfa:	00 
  801dfb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e01:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e07:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e0c:	89 c6                	mov    %eax,%esi
  801e0e:	bf 10 00 00 00       	mov    $0x10,%edi
  801e13:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801e1a:	00 00 00 
  801e1d:	ff d0                	callq  *%rax
}
  801e1f:	c9                   	leaveq 
  801e20:	c3                   	retq   

0000000000801e21 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801e21:	55                   	push   %rbp
  801e22:	48 89 e5             	mov    %rsp,%rbp
  801e25:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801e29:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e30:	00 
  801e31:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e37:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e42:	ba 00 00 00 00       	mov    $0x0,%edx
  801e47:	be 00 00 00 00       	mov    $0x0,%esi
  801e4c:	bf 0e 00 00 00       	mov    $0xe,%edi
  801e51:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801e58:	00 00 00 
  801e5b:	ff d0                	callq  *%rax
}
  801e5d:	c9                   	leaveq 
  801e5e:	c3                   	retq   

0000000000801e5f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e5f:	55                   	push   %rbp
  801e60:	48 89 e5             	mov    %rsp,%rbp
  801e63:	48 83 ec 08          	sub    $0x8,%rsp
  801e67:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e6b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e6f:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e76:	ff ff ff 
  801e79:	48 01 d0             	add    %rdx,%rax
  801e7c:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e80:	c9                   	leaveq 
  801e81:	c3                   	retq   

0000000000801e82 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e82:	55                   	push   %rbp
  801e83:	48 89 e5             	mov    %rsp,%rbp
  801e86:	48 83 ec 08          	sub    $0x8,%rsp
  801e8a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801e8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e92:	48 89 c7             	mov    %rax,%rdi
  801e95:	48 b8 5f 1e 80 00 00 	movabs $0x801e5f,%rax
  801e9c:	00 00 00 
  801e9f:	ff d0                	callq  *%rax
  801ea1:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ea7:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801eab:	c9                   	leaveq 
  801eac:	c3                   	retq   

0000000000801ead <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ead:	55                   	push   %rbp
  801eae:	48 89 e5             	mov    %rsp,%rbp
  801eb1:	48 83 ec 18          	sub    $0x18,%rsp
  801eb5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801eb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ec0:	eb 6b                	jmp    801f2d <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801ec2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ec5:	48 98                	cltq   
  801ec7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ecd:	48 c1 e0 0c          	shl    $0xc,%rax
  801ed1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801ed5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ed9:	48 c1 e8 15          	shr    $0x15,%rax
  801edd:	48 89 c2             	mov    %rax,%rdx
  801ee0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ee7:	01 00 00 
  801eea:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eee:	83 e0 01             	and    $0x1,%eax
  801ef1:	48 85 c0             	test   %rax,%rax
  801ef4:	74 21                	je     801f17 <fd_alloc+0x6a>
  801ef6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801efa:	48 c1 e8 0c          	shr    $0xc,%rax
  801efe:	48 89 c2             	mov    %rax,%rdx
  801f01:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f08:	01 00 00 
  801f0b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f0f:	83 e0 01             	and    $0x1,%eax
  801f12:	48 85 c0             	test   %rax,%rax
  801f15:	75 12                	jne    801f29 <fd_alloc+0x7c>
			*fd_store = fd;
  801f17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f1b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f1f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f22:	b8 00 00 00 00       	mov    $0x0,%eax
  801f27:	eb 1a                	jmp    801f43 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f29:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f2d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f31:	7e 8f                	jle    801ec2 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f37:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801f3e:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f43:	c9                   	leaveq 
  801f44:	c3                   	retq   

0000000000801f45 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f45:	55                   	push   %rbp
  801f46:	48 89 e5             	mov    %rsp,%rbp
  801f49:	48 83 ec 20          	sub    $0x20,%rsp
  801f4d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f50:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f54:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f58:	78 06                	js     801f60 <fd_lookup+0x1b>
  801f5a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f5e:	7e 07                	jle    801f67 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f65:	eb 6c                	jmp    801fd3 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f67:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f6a:	48 98                	cltq   
  801f6c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f72:	48 c1 e0 0c          	shl    $0xc,%rax
  801f76:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f7e:	48 c1 e8 15          	shr    $0x15,%rax
  801f82:	48 89 c2             	mov    %rax,%rdx
  801f85:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f8c:	01 00 00 
  801f8f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f93:	83 e0 01             	and    $0x1,%eax
  801f96:	48 85 c0             	test   %rax,%rax
  801f99:	74 21                	je     801fbc <fd_lookup+0x77>
  801f9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f9f:	48 c1 e8 0c          	shr    $0xc,%rax
  801fa3:	48 89 c2             	mov    %rax,%rdx
  801fa6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fad:	01 00 00 
  801fb0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fb4:	83 e0 01             	and    $0x1,%eax
  801fb7:	48 85 c0             	test   %rax,%rax
  801fba:	75 07                	jne    801fc3 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fbc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fc1:	eb 10                	jmp    801fd3 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801fc3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fc7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801fcb:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801fce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd3:	c9                   	leaveq 
  801fd4:	c3                   	retq   

0000000000801fd5 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801fd5:	55                   	push   %rbp
  801fd6:	48 89 e5             	mov    %rsp,%rbp
  801fd9:	48 83 ec 30          	sub    $0x30,%rsp
  801fdd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801fe1:	89 f0                	mov    %esi,%eax
  801fe3:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801fe6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fea:	48 89 c7             	mov    %rax,%rdi
  801fed:	48 b8 5f 1e 80 00 00 	movabs $0x801e5f,%rax
  801ff4:	00 00 00 
  801ff7:	ff d0                	callq  *%rax
  801ff9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ffd:	48 89 d6             	mov    %rdx,%rsi
  802000:	89 c7                	mov    %eax,%edi
  802002:	48 b8 45 1f 80 00 00 	movabs $0x801f45,%rax
  802009:	00 00 00 
  80200c:	ff d0                	callq  *%rax
  80200e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802011:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802015:	78 0a                	js     802021 <fd_close+0x4c>
	    || fd != fd2)
  802017:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80201b:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80201f:	74 12                	je     802033 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802021:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802025:	74 05                	je     80202c <fd_close+0x57>
  802027:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80202a:	eb 05                	jmp    802031 <fd_close+0x5c>
  80202c:	b8 00 00 00 00       	mov    $0x0,%eax
  802031:	eb 69                	jmp    80209c <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802033:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802037:	8b 00                	mov    (%rax),%eax
  802039:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80203d:	48 89 d6             	mov    %rdx,%rsi
  802040:	89 c7                	mov    %eax,%edi
  802042:	48 b8 9e 20 80 00 00 	movabs $0x80209e,%rax
  802049:	00 00 00 
  80204c:	ff d0                	callq  *%rax
  80204e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802051:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802055:	78 2a                	js     802081 <fd_close+0xac>
		if (dev->dev_close)
  802057:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80205b:	48 8b 40 20          	mov    0x20(%rax),%rax
  80205f:	48 85 c0             	test   %rax,%rax
  802062:	74 16                	je     80207a <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802064:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802068:	48 8b 40 20          	mov    0x20(%rax),%rax
  80206c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802070:	48 89 d7             	mov    %rdx,%rdi
  802073:	ff d0                	callq  *%rax
  802075:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802078:	eb 07                	jmp    802081 <fd_close+0xac>
		else
			r = 0;
  80207a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802081:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802085:	48 89 c6             	mov    %rax,%rsi
  802088:	bf 00 00 00 00       	mov    $0x0,%edi
  80208d:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  802094:	00 00 00 
  802097:	ff d0                	callq  *%rax
	return r;
  802099:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80209c:	c9                   	leaveq 
  80209d:	c3                   	retq   

000000000080209e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80209e:	55                   	push   %rbp
  80209f:	48 89 e5             	mov    %rsp,%rbp
  8020a2:	48 83 ec 20          	sub    $0x20,%rsp
  8020a6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8020ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020b4:	eb 41                	jmp    8020f7 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8020b6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020bd:	00 00 00 
  8020c0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020c3:	48 63 d2             	movslq %edx,%rdx
  8020c6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ca:	8b 00                	mov    (%rax),%eax
  8020cc:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8020cf:	75 22                	jne    8020f3 <dev_lookup+0x55>
			*dev = devtab[i];
  8020d1:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020d8:	00 00 00 
  8020db:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020de:	48 63 d2             	movslq %edx,%rdx
  8020e1:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8020e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020e9:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8020ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f1:	eb 60                	jmp    802153 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8020f3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020f7:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020fe:	00 00 00 
  802101:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802104:	48 63 d2             	movslq %edx,%rdx
  802107:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80210b:	48 85 c0             	test   %rax,%rax
  80210e:	75 a6                	jne    8020b6 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802110:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802117:	00 00 00 
  80211a:	48 8b 00             	mov    (%rax),%rax
  80211d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802123:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802126:	89 c6                	mov    %eax,%esi
  802128:	48 bf 18 47 80 00 00 	movabs $0x804718,%rdi
  80212f:	00 00 00 
  802132:	b8 00 00 00 00       	mov    $0x0,%eax
  802137:	48 b9 44 06 80 00 00 	movabs $0x800644,%rcx
  80213e:	00 00 00 
  802141:	ff d1                	callq  *%rcx
	*dev = 0;
  802143:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802147:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80214e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802153:	c9                   	leaveq 
  802154:	c3                   	retq   

0000000000802155 <close>:

int
close(int fdnum)
{
  802155:	55                   	push   %rbp
  802156:	48 89 e5             	mov    %rsp,%rbp
  802159:	48 83 ec 20          	sub    $0x20,%rsp
  80215d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802160:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802164:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802167:	48 89 d6             	mov    %rdx,%rsi
  80216a:	89 c7                	mov    %eax,%edi
  80216c:	48 b8 45 1f 80 00 00 	movabs $0x801f45,%rax
  802173:	00 00 00 
  802176:	ff d0                	callq  *%rax
  802178:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80217b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80217f:	79 05                	jns    802186 <close+0x31>
		return r;
  802181:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802184:	eb 18                	jmp    80219e <close+0x49>
	else
		return fd_close(fd, 1);
  802186:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80218a:	be 01 00 00 00       	mov    $0x1,%esi
  80218f:	48 89 c7             	mov    %rax,%rdi
  802192:	48 b8 d5 1f 80 00 00 	movabs $0x801fd5,%rax
  802199:	00 00 00 
  80219c:	ff d0                	callq  *%rax
}
  80219e:	c9                   	leaveq 
  80219f:	c3                   	retq   

00000000008021a0 <close_all>:

void
close_all(void)
{
  8021a0:	55                   	push   %rbp
  8021a1:	48 89 e5             	mov    %rsp,%rbp
  8021a4:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021af:	eb 15                	jmp    8021c6 <close_all+0x26>
		close(i);
  8021b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021b4:	89 c7                	mov    %eax,%edi
  8021b6:	48 b8 55 21 80 00 00 	movabs $0x802155,%rax
  8021bd:	00 00 00 
  8021c0:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8021c2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021c6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021ca:	7e e5                	jle    8021b1 <close_all+0x11>
		close(i);
}
  8021cc:	c9                   	leaveq 
  8021cd:	c3                   	retq   

00000000008021ce <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8021ce:	55                   	push   %rbp
  8021cf:	48 89 e5             	mov    %rsp,%rbp
  8021d2:	48 83 ec 40          	sub    $0x40,%rsp
  8021d6:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8021d9:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8021dc:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8021e0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8021e3:	48 89 d6             	mov    %rdx,%rsi
  8021e6:	89 c7                	mov    %eax,%edi
  8021e8:	48 b8 45 1f 80 00 00 	movabs $0x801f45,%rax
  8021ef:	00 00 00 
  8021f2:	ff d0                	callq  *%rax
  8021f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021fb:	79 08                	jns    802205 <dup+0x37>
		return r;
  8021fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802200:	e9 70 01 00 00       	jmpq   802375 <dup+0x1a7>
	close(newfdnum);
  802205:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802208:	89 c7                	mov    %eax,%edi
  80220a:	48 b8 55 21 80 00 00 	movabs $0x802155,%rax
  802211:	00 00 00 
  802214:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802216:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802219:	48 98                	cltq   
  80221b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802221:	48 c1 e0 0c          	shl    $0xc,%rax
  802225:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802229:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80222d:	48 89 c7             	mov    %rax,%rdi
  802230:	48 b8 82 1e 80 00 00 	movabs $0x801e82,%rax
  802237:	00 00 00 
  80223a:	ff d0                	callq  *%rax
  80223c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802240:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802244:	48 89 c7             	mov    %rax,%rdi
  802247:	48 b8 82 1e 80 00 00 	movabs $0x801e82,%rax
  80224e:	00 00 00 
  802251:	ff d0                	callq  *%rax
  802253:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802257:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225b:	48 c1 e8 15          	shr    $0x15,%rax
  80225f:	48 89 c2             	mov    %rax,%rdx
  802262:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802269:	01 00 00 
  80226c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802270:	83 e0 01             	and    $0x1,%eax
  802273:	48 85 c0             	test   %rax,%rax
  802276:	74 73                	je     8022eb <dup+0x11d>
  802278:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80227c:	48 c1 e8 0c          	shr    $0xc,%rax
  802280:	48 89 c2             	mov    %rax,%rdx
  802283:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80228a:	01 00 00 
  80228d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802291:	83 e0 01             	and    $0x1,%eax
  802294:	48 85 c0             	test   %rax,%rax
  802297:	74 52                	je     8022eb <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802299:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80229d:	48 c1 e8 0c          	shr    $0xc,%rax
  8022a1:	48 89 c2             	mov    %rax,%rdx
  8022a4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022ab:	01 00 00 
  8022ae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022b2:	25 07 0e 00 00       	and    $0xe07,%eax
  8022b7:	89 c1                	mov    %eax,%ecx
  8022b9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c1:	41 89 c8             	mov    %ecx,%r8d
  8022c4:	48 89 d1             	mov    %rdx,%rcx
  8022c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8022cc:	48 89 c6             	mov    %rax,%rsi
  8022cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d4:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  8022db:	00 00 00 
  8022de:	ff d0                	callq  *%rax
  8022e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e7:	79 02                	jns    8022eb <dup+0x11d>
			goto err;
  8022e9:	eb 57                	jmp    802342 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8022eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022ef:	48 c1 e8 0c          	shr    $0xc,%rax
  8022f3:	48 89 c2             	mov    %rax,%rdx
  8022f6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022fd:	01 00 00 
  802300:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802304:	25 07 0e 00 00       	and    $0xe07,%eax
  802309:	89 c1                	mov    %eax,%ecx
  80230b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80230f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802313:	41 89 c8             	mov    %ecx,%r8d
  802316:	48 89 d1             	mov    %rdx,%rcx
  802319:	ba 00 00 00 00       	mov    $0x0,%edx
  80231e:	48 89 c6             	mov    %rax,%rsi
  802321:	bf 00 00 00 00       	mov    $0x0,%edi
  802326:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  80232d:	00 00 00 
  802330:	ff d0                	callq  *%rax
  802332:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802335:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802339:	79 02                	jns    80233d <dup+0x16f>
		goto err;
  80233b:	eb 05                	jmp    802342 <dup+0x174>

	return newfdnum;
  80233d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802340:	eb 33                	jmp    802375 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802342:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802346:	48 89 c6             	mov    %rax,%rsi
  802349:	bf 00 00 00 00       	mov    $0x0,%edi
  80234e:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  802355:	00 00 00 
  802358:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80235a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80235e:	48 89 c6             	mov    %rax,%rsi
  802361:	bf 00 00 00 00       	mov    $0x0,%edi
  802366:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  80236d:	00 00 00 
  802370:	ff d0                	callq  *%rax
	return r;
  802372:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802375:	c9                   	leaveq 
  802376:	c3                   	retq   

0000000000802377 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802377:	55                   	push   %rbp
  802378:	48 89 e5             	mov    %rsp,%rbp
  80237b:	48 83 ec 40          	sub    $0x40,%rsp
  80237f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802382:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802386:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80238a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80238e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802391:	48 89 d6             	mov    %rdx,%rsi
  802394:	89 c7                	mov    %eax,%edi
  802396:	48 b8 45 1f 80 00 00 	movabs $0x801f45,%rax
  80239d:	00 00 00 
  8023a0:	ff d0                	callq  *%rax
  8023a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023a9:	78 24                	js     8023cf <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023af:	8b 00                	mov    (%rax),%eax
  8023b1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023b5:	48 89 d6             	mov    %rdx,%rsi
  8023b8:	89 c7                	mov    %eax,%edi
  8023ba:	48 b8 9e 20 80 00 00 	movabs $0x80209e,%rax
  8023c1:	00 00 00 
  8023c4:	ff d0                	callq  *%rax
  8023c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023cd:	79 05                	jns    8023d4 <read+0x5d>
		return r;
  8023cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d2:	eb 76                	jmp    80244a <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8023d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d8:	8b 40 08             	mov    0x8(%rax),%eax
  8023db:	83 e0 03             	and    $0x3,%eax
  8023de:	83 f8 01             	cmp    $0x1,%eax
  8023e1:	75 3a                	jne    80241d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8023e3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8023ea:	00 00 00 
  8023ed:	48 8b 00             	mov    (%rax),%rax
  8023f0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023f6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023f9:	89 c6                	mov    %eax,%esi
  8023fb:	48 bf 37 47 80 00 00 	movabs $0x804737,%rdi
  802402:	00 00 00 
  802405:	b8 00 00 00 00       	mov    $0x0,%eax
  80240a:	48 b9 44 06 80 00 00 	movabs $0x800644,%rcx
  802411:	00 00 00 
  802414:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802416:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80241b:	eb 2d                	jmp    80244a <read+0xd3>
	}
	if (!dev->dev_read)
  80241d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802421:	48 8b 40 10          	mov    0x10(%rax),%rax
  802425:	48 85 c0             	test   %rax,%rax
  802428:	75 07                	jne    802431 <read+0xba>
		return -E_NOT_SUPP;
  80242a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80242f:	eb 19                	jmp    80244a <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802431:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802435:	48 8b 40 10          	mov    0x10(%rax),%rax
  802439:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80243d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802441:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802445:	48 89 cf             	mov    %rcx,%rdi
  802448:	ff d0                	callq  *%rax
}
  80244a:	c9                   	leaveq 
  80244b:	c3                   	retq   

000000000080244c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80244c:	55                   	push   %rbp
  80244d:	48 89 e5             	mov    %rsp,%rbp
  802450:	48 83 ec 30          	sub    $0x30,%rsp
  802454:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802457:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80245b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80245f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802466:	eb 49                	jmp    8024b1 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802468:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80246b:	48 98                	cltq   
  80246d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802471:	48 29 c2             	sub    %rax,%rdx
  802474:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802477:	48 63 c8             	movslq %eax,%rcx
  80247a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80247e:	48 01 c1             	add    %rax,%rcx
  802481:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802484:	48 89 ce             	mov    %rcx,%rsi
  802487:	89 c7                	mov    %eax,%edi
  802489:	48 b8 77 23 80 00 00 	movabs $0x802377,%rax
  802490:	00 00 00 
  802493:	ff d0                	callq  *%rax
  802495:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802498:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80249c:	79 05                	jns    8024a3 <readn+0x57>
			return m;
  80249e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024a1:	eb 1c                	jmp    8024bf <readn+0x73>
		if (m == 0)
  8024a3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024a7:	75 02                	jne    8024ab <readn+0x5f>
			break;
  8024a9:	eb 11                	jmp    8024bc <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024ab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024ae:	01 45 fc             	add    %eax,-0x4(%rbp)
  8024b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b4:	48 98                	cltq   
  8024b6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8024ba:	72 ac                	jb     802468 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8024bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024bf:	c9                   	leaveq 
  8024c0:	c3                   	retq   

00000000008024c1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8024c1:	55                   	push   %rbp
  8024c2:	48 89 e5             	mov    %rsp,%rbp
  8024c5:	48 83 ec 40          	sub    $0x40,%rsp
  8024c9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024cc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024d0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024d4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024d8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024db:	48 89 d6             	mov    %rdx,%rsi
  8024de:	89 c7                	mov    %eax,%edi
  8024e0:	48 b8 45 1f 80 00 00 	movabs $0x801f45,%rax
  8024e7:	00 00 00 
  8024ea:	ff d0                	callq  *%rax
  8024ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f3:	78 24                	js     802519 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024f9:	8b 00                	mov    (%rax),%eax
  8024fb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024ff:	48 89 d6             	mov    %rdx,%rsi
  802502:	89 c7                	mov    %eax,%edi
  802504:	48 b8 9e 20 80 00 00 	movabs $0x80209e,%rax
  80250b:	00 00 00 
  80250e:	ff d0                	callq  *%rax
  802510:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802513:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802517:	79 05                	jns    80251e <write+0x5d>
		return r;
  802519:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80251c:	eb 75                	jmp    802593 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80251e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802522:	8b 40 08             	mov    0x8(%rax),%eax
  802525:	83 e0 03             	and    $0x3,%eax
  802528:	85 c0                	test   %eax,%eax
  80252a:	75 3a                	jne    802566 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80252c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802533:	00 00 00 
  802536:	48 8b 00             	mov    (%rax),%rax
  802539:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80253f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802542:	89 c6                	mov    %eax,%esi
  802544:	48 bf 53 47 80 00 00 	movabs $0x804753,%rdi
  80254b:	00 00 00 
  80254e:	b8 00 00 00 00       	mov    $0x0,%eax
  802553:	48 b9 44 06 80 00 00 	movabs $0x800644,%rcx
  80255a:	00 00 00 
  80255d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80255f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802564:	eb 2d                	jmp    802593 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802566:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80256a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80256e:	48 85 c0             	test   %rax,%rax
  802571:	75 07                	jne    80257a <write+0xb9>
		return -E_NOT_SUPP;
  802573:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802578:	eb 19                	jmp    802593 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80257a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802582:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802586:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80258a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80258e:	48 89 cf             	mov    %rcx,%rdi
  802591:	ff d0                	callq  *%rax
}
  802593:	c9                   	leaveq 
  802594:	c3                   	retq   

0000000000802595 <seek>:

int
seek(int fdnum, off_t offset)
{
  802595:	55                   	push   %rbp
  802596:	48 89 e5             	mov    %rsp,%rbp
  802599:	48 83 ec 18          	sub    $0x18,%rsp
  80259d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025a0:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025a3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025aa:	48 89 d6             	mov    %rdx,%rsi
  8025ad:	89 c7                	mov    %eax,%edi
  8025af:	48 b8 45 1f 80 00 00 	movabs $0x801f45,%rax
  8025b6:	00 00 00 
  8025b9:	ff d0                	callq  *%rax
  8025bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025c2:	79 05                	jns    8025c9 <seek+0x34>
		return r;
  8025c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025c7:	eb 0f                	jmp    8025d8 <seek+0x43>
	fd->fd_offset = offset;
  8025c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025cd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8025d0:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8025d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d8:	c9                   	leaveq 
  8025d9:	c3                   	retq   

00000000008025da <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8025da:	55                   	push   %rbp
  8025db:	48 89 e5             	mov    %rsp,%rbp
  8025de:	48 83 ec 30          	sub    $0x30,%rsp
  8025e2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025e5:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025e8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025ec:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025ef:	48 89 d6             	mov    %rdx,%rsi
  8025f2:	89 c7                	mov    %eax,%edi
  8025f4:	48 b8 45 1f 80 00 00 	movabs $0x801f45,%rax
  8025fb:	00 00 00 
  8025fe:	ff d0                	callq  *%rax
  802600:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802603:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802607:	78 24                	js     80262d <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802609:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80260d:	8b 00                	mov    (%rax),%eax
  80260f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802613:	48 89 d6             	mov    %rdx,%rsi
  802616:	89 c7                	mov    %eax,%edi
  802618:	48 b8 9e 20 80 00 00 	movabs $0x80209e,%rax
  80261f:	00 00 00 
  802622:	ff d0                	callq  *%rax
  802624:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802627:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80262b:	79 05                	jns    802632 <ftruncate+0x58>
		return r;
  80262d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802630:	eb 72                	jmp    8026a4 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802632:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802636:	8b 40 08             	mov    0x8(%rax),%eax
  802639:	83 e0 03             	and    $0x3,%eax
  80263c:	85 c0                	test   %eax,%eax
  80263e:	75 3a                	jne    80267a <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802640:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802647:	00 00 00 
  80264a:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80264d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802653:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802656:	89 c6                	mov    %eax,%esi
  802658:	48 bf 70 47 80 00 00 	movabs $0x804770,%rdi
  80265f:	00 00 00 
  802662:	b8 00 00 00 00       	mov    $0x0,%eax
  802667:	48 b9 44 06 80 00 00 	movabs $0x800644,%rcx
  80266e:	00 00 00 
  802671:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802673:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802678:	eb 2a                	jmp    8026a4 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80267a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80267e:	48 8b 40 30          	mov    0x30(%rax),%rax
  802682:	48 85 c0             	test   %rax,%rax
  802685:	75 07                	jne    80268e <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802687:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80268c:	eb 16                	jmp    8026a4 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80268e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802692:	48 8b 40 30          	mov    0x30(%rax),%rax
  802696:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80269a:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80269d:	89 ce                	mov    %ecx,%esi
  80269f:	48 89 d7             	mov    %rdx,%rdi
  8026a2:	ff d0                	callq  *%rax
}
  8026a4:	c9                   	leaveq 
  8026a5:	c3                   	retq   

00000000008026a6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8026a6:	55                   	push   %rbp
  8026a7:	48 89 e5             	mov    %rsp,%rbp
  8026aa:	48 83 ec 30          	sub    $0x30,%rsp
  8026ae:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026b1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026b5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026b9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026bc:	48 89 d6             	mov    %rdx,%rsi
  8026bf:	89 c7                	mov    %eax,%edi
  8026c1:	48 b8 45 1f 80 00 00 	movabs $0x801f45,%rax
  8026c8:	00 00 00 
  8026cb:	ff d0                	callq  *%rax
  8026cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d4:	78 24                	js     8026fa <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026da:	8b 00                	mov    (%rax),%eax
  8026dc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026e0:	48 89 d6             	mov    %rdx,%rsi
  8026e3:	89 c7                	mov    %eax,%edi
  8026e5:	48 b8 9e 20 80 00 00 	movabs $0x80209e,%rax
  8026ec:	00 00 00 
  8026ef:	ff d0                	callq  *%rax
  8026f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f8:	79 05                	jns    8026ff <fstat+0x59>
		return r;
  8026fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026fd:	eb 5e                	jmp    80275d <fstat+0xb7>
	if (!dev->dev_stat)
  8026ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802703:	48 8b 40 28          	mov    0x28(%rax),%rax
  802707:	48 85 c0             	test   %rax,%rax
  80270a:	75 07                	jne    802713 <fstat+0x6d>
		return -E_NOT_SUPP;
  80270c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802711:	eb 4a                	jmp    80275d <fstat+0xb7>
	stat->st_name[0] = 0;
  802713:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802717:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80271a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80271e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802725:	00 00 00 
	stat->st_isdir = 0;
  802728:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80272c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802733:	00 00 00 
	stat->st_dev = dev;
  802736:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80273a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80273e:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802745:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802749:	48 8b 40 28          	mov    0x28(%rax),%rax
  80274d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802751:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802755:	48 89 ce             	mov    %rcx,%rsi
  802758:	48 89 d7             	mov    %rdx,%rdi
  80275b:	ff d0                	callq  *%rax
}
  80275d:	c9                   	leaveq 
  80275e:	c3                   	retq   

000000000080275f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80275f:	55                   	push   %rbp
  802760:	48 89 e5             	mov    %rsp,%rbp
  802763:	48 83 ec 20          	sub    $0x20,%rsp
  802767:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80276b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80276f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802773:	be 00 00 00 00       	mov    $0x0,%esi
  802778:	48 89 c7             	mov    %rax,%rdi
  80277b:	48 b8 4d 28 80 00 00 	movabs $0x80284d,%rax
  802782:	00 00 00 
  802785:	ff d0                	callq  *%rax
  802787:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80278a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80278e:	79 05                	jns    802795 <stat+0x36>
		return fd;
  802790:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802793:	eb 2f                	jmp    8027c4 <stat+0x65>
	r = fstat(fd, stat);
  802795:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802799:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80279c:	48 89 d6             	mov    %rdx,%rsi
  80279f:	89 c7                	mov    %eax,%edi
  8027a1:	48 b8 a6 26 80 00 00 	movabs $0x8026a6,%rax
  8027a8:	00 00 00 
  8027ab:	ff d0                	callq  *%rax
  8027ad:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8027b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b3:	89 c7                	mov    %eax,%edi
  8027b5:	48 b8 55 21 80 00 00 	movabs $0x802155,%rax
  8027bc:	00 00 00 
  8027bf:	ff d0                	callq  *%rax
	return r;
  8027c1:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8027c4:	c9                   	leaveq 
  8027c5:	c3                   	retq   

00000000008027c6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8027c6:	55                   	push   %rbp
  8027c7:	48 89 e5             	mov    %rsp,%rbp
  8027ca:	48 83 ec 10          	sub    $0x10,%rsp
  8027ce:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027d1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8027d5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027dc:	00 00 00 
  8027df:	8b 00                	mov    (%rax),%eax
  8027e1:	85 c0                	test   %eax,%eax
  8027e3:	75 1d                	jne    802802 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8027e5:	bf 01 00 00 00       	mov    $0x1,%edi
  8027ea:	48 b8 53 40 80 00 00 	movabs $0x804053,%rax
  8027f1:	00 00 00 
  8027f4:	ff d0                	callq  *%rax
  8027f6:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8027fd:	00 00 00 
  802800:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802802:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802809:	00 00 00 
  80280c:	8b 00                	mov    (%rax),%eax
  80280e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802811:	b9 07 00 00 00       	mov    $0x7,%ecx
  802816:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80281d:	00 00 00 
  802820:	89 c7                	mov    %eax,%edi
  802822:	48 b8 f1 3f 80 00 00 	movabs $0x803ff1,%rax
  802829:	00 00 00 
  80282c:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80282e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802832:	ba 00 00 00 00       	mov    $0x0,%edx
  802837:	48 89 c6             	mov    %rax,%rsi
  80283a:	bf 00 00 00 00       	mov    $0x0,%edi
  80283f:	48 b8 eb 3e 80 00 00 	movabs $0x803eeb,%rax
  802846:	00 00 00 
  802849:	ff d0                	callq  *%rax
}
  80284b:	c9                   	leaveq 
  80284c:	c3                   	retq   

000000000080284d <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80284d:	55                   	push   %rbp
  80284e:	48 89 e5             	mov    %rsp,%rbp
  802851:	48 83 ec 30          	sub    $0x30,%rsp
  802855:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802859:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80285c:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802863:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80286a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802871:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802876:	75 08                	jne    802880 <open+0x33>
	{
		return r;
  802878:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80287b:	e9 f2 00 00 00       	jmpq   802972 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802880:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802884:	48 89 c7             	mov    %rax,%rdi
  802887:	48 b8 8d 11 80 00 00 	movabs $0x80118d,%rax
  80288e:	00 00 00 
  802891:	ff d0                	callq  *%rax
  802893:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802896:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  80289d:	7e 0a                	jle    8028a9 <open+0x5c>
	{
		return -E_BAD_PATH;
  80289f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8028a4:	e9 c9 00 00 00       	jmpq   802972 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8028a9:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8028b0:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8028b1:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8028b5:	48 89 c7             	mov    %rax,%rdi
  8028b8:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  8028bf:	00 00 00 
  8028c2:	ff d0                	callq  *%rax
  8028c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028cb:	78 09                	js     8028d6 <open+0x89>
  8028cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d1:	48 85 c0             	test   %rax,%rax
  8028d4:	75 08                	jne    8028de <open+0x91>
		{
			return r;
  8028d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d9:	e9 94 00 00 00       	jmpq   802972 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8028de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028e2:	ba 00 04 00 00       	mov    $0x400,%edx
  8028e7:	48 89 c6             	mov    %rax,%rsi
  8028ea:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8028f1:	00 00 00 
  8028f4:	48 b8 8b 12 80 00 00 	movabs $0x80128b,%rax
  8028fb:	00 00 00 
  8028fe:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802900:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802907:	00 00 00 
  80290a:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80290d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802913:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802917:	48 89 c6             	mov    %rax,%rsi
  80291a:	bf 01 00 00 00       	mov    $0x1,%edi
  80291f:	48 b8 c6 27 80 00 00 	movabs $0x8027c6,%rax
  802926:	00 00 00 
  802929:	ff d0                	callq  *%rax
  80292b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80292e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802932:	79 2b                	jns    80295f <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802934:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802938:	be 00 00 00 00       	mov    $0x0,%esi
  80293d:	48 89 c7             	mov    %rax,%rdi
  802940:	48 b8 d5 1f 80 00 00 	movabs $0x801fd5,%rax
  802947:	00 00 00 
  80294a:	ff d0                	callq  *%rax
  80294c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80294f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802953:	79 05                	jns    80295a <open+0x10d>
			{
				return d;
  802955:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802958:	eb 18                	jmp    802972 <open+0x125>
			}
			return r;
  80295a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295d:	eb 13                	jmp    802972 <open+0x125>
		}	
		return fd2num(fd_store);
  80295f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802963:	48 89 c7             	mov    %rax,%rdi
  802966:	48 b8 5f 1e 80 00 00 	movabs $0x801e5f,%rax
  80296d:	00 00 00 
  802970:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802972:	c9                   	leaveq 
  802973:	c3                   	retq   

0000000000802974 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802974:	55                   	push   %rbp
  802975:	48 89 e5             	mov    %rsp,%rbp
  802978:	48 83 ec 10          	sub    $0x10,%rsp
  80297c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802980:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802984:	8b 50 0c             	mov    0xc(%rax),%edx
  802987:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80298e:	00 00 00 
  802991:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802993:	be 00 00 00 00       	mov    $0x0,%esi
  802998:	bf 06 00 00 00       	mov    $0x6,%edi
  80299d:	48 b8 c6 27 80 00 00 	movabs $0x8027c6,%rax
  8029a4:	00 00 00 
  8029a7:	ff d0                	callq  *%rax
}
  8029a9:	c9                   	leaveq 
  8029aa:	c3                   	retq   

00000000008029ab <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8029ab:	55                   	push   %rbp
  8029ac:	48 89 e5             	mov    %rsp,%rbp
  8029af:	48 83 ec 30          	sub    $0x30,%rsp
  8029b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029bb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8029bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8029c6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8029cb:	74 07                	je     8029d4 <devfile_read+0x29>
  8029cd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8029d2:	75 07                	jne    8029db <devfile_read+0x30>
		return -E_INVAL;
  8029d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029d9:	eb 77                	jmp    802a52 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8029db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029df:	8b 50 0c             	mov    0xc(%rax),%edx
  8029e2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029e9:	00 00 00 
  8029ec:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8029ee:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029f5:	00 00 00 
  8029f8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029fc:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802a00:	be 00 00 00 00       	mov    $0x0,%esi
  802a05:	bf 03 00 00 00       	mov    $0x3,%edi
  802a0a:	48 b8 c6 27 80 00 00 	movabs $0x8027c6,%rax
  802a11:	00 00 00 
  802a14:	ff d0                	callq  *%rax
  802a16:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a1d:	7f 05                	jg     802a24 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802a1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a22:	eb 2e                	jmp    802a52 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802a24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a27:	48 63 d0             	movslq %eax,%rdx
  802a2a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a2e:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a35:	00 00 00 
  802a38:	48 89 c7             	mov    %rax,%rdi
  802a3b:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  802a42:	00 00 00 
  802a45:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802a47:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a4b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802a4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802a52:	c9                   	leaveq 
  802a53:	c3                   	retq   

0000000000802a54 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802a54:	55                   	push   %rbp
  802a55:	48 89 e5             	mov    %rsp,%rbp
  802a58:	48 83 ec 30          	sub    $0x30,%rsp
  802a5c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a60:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a64:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802a68:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802a6f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802a74:	74 07                	je     802a7d <devfile_write+0x29>
  802a76:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802a7b:	75 08                	jne    802a85 <devfile_write+0x31>
		return r;
  802a7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a80:	e9 9a 00 00 00       	jmpq   802b1f <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802a85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a89:	8b 50 0c             	mov    0xc(%rax),%edx
  802a8c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a93:	00 00 00 
  802a96:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802a98:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802a9f:	00 
  802aa0:	76 08                	jbe    802aaa <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802aa2:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802aa9:	00 
	}
	fsipcbuf.write.req_n = n;
  802aaa:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ab1:	00 00 00 
  802ab4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ab8:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802abc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ac0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ac4:	48 89 c6             	mov    %rax,%rsi
  802ac7:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802ace:	00 00 00 
  802ad1:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  802ad8:	00 00 00 
  802adb:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802add:	be 00 00 00 00       	mov    $0x0,%esi
  802ae2:	bf 04 00 00 00       	mov    $0x4,%edi
  802ae7:	48 b8 c6 27 80 00 00 	movabs $0x8027c6,%rax
  802aee:	00 00 00 
  802af1:	ff d0                	callq  *%rax
  802af3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802afa:	7f 20                	jg     802b1c <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802afc:	48 bf 96 47 80 00 00 	movabs $0x804796,%rdi
  802b03:	00 00 00 
  802b06:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0b:	48 ba 44 06 80 00 00 	movabs $0x800644,%rdx
  802b12:	00 00 00 
  802b15:	ff d2                	callq  *%rdx
		return r;
  802b17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1a:	eb 03                	jmp    802b1f <devfile_write+0xcb>
	}
	return r;
  802b1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802b1f:	c9                   	leaveq 
  802b20:	c3                   	retq   

0000000000802b21 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802b21:	55                   	push   %rbp
  802b22:	48 89 e5             	mov    %rsp,%rbp
  802b25:	48 83 ec 20          	sub    $0x20,%rsp
  802b29:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b2d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802b31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b35:	8b 50 0c             	mov    0xc(%rax),%edx
  802b38:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b3f:	00 00 00 
  802b42:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802b44:	be 00 00 00 00       	mov    $0x0,%esi
  802b49:	bf 05 00 00 00       	mov    $0x5,%edi
  802b4e:	48 b8 c6 27 80 00 00 	movabs $0x8027c6,%rax
  802b55:	00 00 00 
  802b58:	ff d0                	callq  *%rax
  802b5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b61:	79 05                	jns    802b68 <devfile_stat+0x47>
		return r;
  802b63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b66:	eb 56                	jmp    802bbe <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b68:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b6c:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802b73:	00 00 00 
  802b76:	48 89 c7             	mov    %rax,%rdi
  802b79:	48 b8 f9 11 80 00 00 	movabs $0x8011f9,%rax
  802b80:	00 00 00 
  802b83:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b85:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b8c:	00 00 00 
  802b8f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b95:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b99:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b9f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ba6:	00 00 00 
  802ba9:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802baf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bb3:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802bb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bbe:	c9                   	leaveq 
  802bbf:	c3                   	retq   

0000000000802bc0 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802bc0:	55                   	push   %rbp
  802bc1:	48 89 e5             	mov    %rsp,%rbp
  802bc4:	48 83 ec 10          	sub    $0x10,%rsp
  802bc8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802bcc:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802bcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bd3:	8b 50 0c             	mov    0xc(%rax),%edx
  802bd6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bdd:	00 00 00 
  802be0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802be2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802be9:	00 00 00 
  802bec:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802bef:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802bf2:	be 00 00 00 00       	mov    $0x0,%esi
  802bf7:	bf 02 00 00 00       	mov    $0x2,%edi
  802bfc:	48 b8 c6 27 80 00 00 	movabs $0x8027c6,%rax
  802c03:	00 00 00 
  802c06:	ff d0                	callq  *%rax
}
  802c08:	c9                   	leaveq 
  802c09:	c3                   	retq   

0000000000802c0a <remove>:

// Delete a file
int
remove(const char *path)
{
  802c0a:	55                   	push   %rbp
  802c0b:	48 89 e5             	mov    %rsp,%rbp
  802c0e:	48 83 ec 10          	sub    $0x10,%rsp
  802c12:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802c16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c1a:	48 89 c7             	mov    %rax,%rdi
  802c1d:	48 b8 8d 11 80 00 00 	movabs $0x80118d,%rax
  802c24:	00 00 00 
  802c27:	ff d0                	callq  *%rax
  802c29:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c2e:	7e 07                	jle    802c37 <remove+0x2d>
		return -E_BAD_PATH;
  802c30:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c35:	eb 33                	jmp    802c6a <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802c37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c3b:	48 89 c6             	mov    %rax,%rsi
  802c3e:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c45:	00 00 00 
  802c48:	48 b8 f9 11 80 00 00 	movabs $0x8011f9,%rax
  802c4f:	00 00 00 
  802c52:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802c54:	be 00 00 00 00       	mov    $0x0,%esi
  802c59:	bf 07 00 00 00       	mov    $0x7,%edi
  802c5e:	48 b8 c6 27 80 00 00 	movabs $0x8027c6,%rax
  802c65:	00 00 00 
  802c68:	ff d0                	callq  *%rax
}
  802c6a:	c9                   	leaveq 
  802c6b:	c3                   	retq   

0000000000802c6c <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c6c:	55                   	push   %rbp
  802c6d:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c70:	be 00 00 00 00       	mov    $0x0,%esi
  802c75:	bf 08 00 00 00       	mov    $0x8,%edi
  802c7a:	48 b8 c6 27 80 00 00 	movabs $0x8027c6,%rax
  802c81:	00 00 00 
  802c84:	ff d0                	callq  *%rax
}
  802c86:	5d                   	pop    %rbp
  802c87:	c3                   	retq   

0000000000802c88 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802c88:	55                   	push   %rbp
  802c89:	48 89 e5             	mov    %rsp,%rbp
  802c8c:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802c93:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802c9a:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802ca1:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802ca8:	be 00 00 00 00       	mov    $0x0,%esi
  802cad:	48 89 c7             	mov    %rax,%rdi
  802cb0:	48 b8 4d 28 80 00 00 	movabs $0x80284d,%rax
  802cb7:	00 00 00 
  802cba:	ff d0                	callq  *%rax
  802cbc:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802cbf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cc3:	79 28                	jns    802ced <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802cc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc8:	89 c6                	mov    %eax,%esi
  802cca:	48 bf b2 47 80 00 00 	movabs $0x8047b2,%rdi
  802cd1:	00 00 00 
  802cd4:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd9:	48 ba 44 06 80 00 00 	movabs $0x800644,%rdx
  802ce0:	00 00 00 
  802ce3:	ff d2                	callq  *%rdx
		return fd_src;
  802ce5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce8:	e9 74 01 00 00       	jmpq   802e61 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802ced:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802cf4:	be 01 01 00 00       	mov    $0x101,%esi
  802cf9:	48 89 c7             	mov    %rax,%rdi
  802cfc:	48 b8 4d 28 80 00 00 	movabs $0x80284d,%rax
  802d03:	00 00 00 
  802d06:	ff d0                	callq  *%rax
  802d08:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802d0b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d0f:	79 39                	jns    802d4a <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802d11:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d14:	89 c6                	mov    %eax,%esi
  802d16:	48 bf c8 47 80 00 00 	movabs $0x8047c8,%rdi
  802d1d:	00 00 00 
  802d20:	b8 00 00 00 00       	mov    $0x0,%eax
  802d25:	48 ba 44 06 80 00 00 	movabs $0x800644,%rdx
  802d2c:	00 00 00 
  802d2f:	ff d2                	callq  *%rdx
		close(fd_src);
  802d31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d34:	89 c7                	mov    %eax,%edi
  802d36:	48 b8 55 21 80 00 00 	movabs $0x802155,%rax
  802d3d:	00 00 00 
  802d40:	ff d0                	callq  *%rax
		return fd_dest;
  802d42:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d45:	e9 17 01 00 00       	jmpq   802e61 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d4a:	eb 74                	jmp    802dc0 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802d4c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d4f:	48 63 d0             	movslq %eax,%rdx
  802d52:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d59:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d5c:	48 89 ce             	mov    %rcx,%rsi
  802d5f:	89 c7                	mov    %eax,%edi
  802d61:	48 b8 c1 24 80 00 00 	movabs $0x8024c1,%rax
  802d68:	00 00 00 
  802d6b:	ff d0                	callq  *%rax
  802d6d:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802d70:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802d74:	79 4a                	jns    802dc0 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802d76:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d79:	89 c6                	mov    %eax,%esi
  802d7b:	48 bf e2 47 80 00 00 	movabs $0x8047e2,%rdi
  802d82:	00 00 00 
  802d85:	b8 00 00 00 00       	mov    $0x0,%eax
  802d8a:	48 ba 44 06 80 00 00 	movabs $0x800644,%rdx
  802d91:	00 00 00 
  802d94:	ff d2                	callq  *%rdx
			close(fd_src);
  802d96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d99:	89 c7                	mov    %eax,%edi
  802d9b:	48 b8 55 21 80 00 00 	movabs $0x802155,%rax
  802da2:	00 00 00 
  802da5:	ff d0                	callq  *%rax
			close(fd_dest);
  802da7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802daa:	89 c7                	mov    %eax,%edi
  802dac:	48 b8 55 21 80 00 00 	movabs $0x802155,%rax
  802db3:	00 00 00 
  802db6:	ff d0                	callq  *%rax
			return write_size;
  802db8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802dbb:	e9 a1 00 00 00       	jmpq   802e61 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802dc0:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802dc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dca:	ba 00 02 00 00       	mov    $0x200,%edx
  802dcf:	48 89 ce             	mov    %rcx,%rsi
  802dd2:	89 c7                	mov    %eax,%edi
  802dd4:	48 b8 77 23 80 00 00 	movabs $0x802377,%rax
  802ddb:	00 00 00 
  802dde:	ff d0                	callq  *%rax
  802de0:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802de3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802de7:	0f 8f 5f ff ff ff    	jg     802d4c <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802ded:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802df1:	79 47                	jns    802e3a <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802df3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802df6:	89 c6                	mov    %eax,%esi
  802df8:	48 bf f5 47 80 00 00 	movabs $0x8047f5,%rdi
  802dff:	00 00 00 
  802e02:	b8 00 00 00 00       	mov    $0x0,%eax
  802e07:	48 ba 44 06 80 00 00 	movabs $0x800644,%rdx
  802e0e:	00 00 00 
  802e11:	ff d2                	callq  *%rdx
		close(fd_src);
  802e13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e16:	89 c7                	mov    %eax,%edi
  802e18:	48 b8 55 21 80 00 00 	movabs $0x802155,%rax
  802e1f:	00 00 00 
  802e22:	ff d0                	callq  *%rax
		close(fd_dest);
  802e24:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e27:	89 c7                	mov    %eax,%edi
  802e29:	48 b8 55 21 80 00 00 	movabs $0x802155,%rax
  802e30:	00 00 00 
  802e33:	ff d0                	callq  *%rax
		return read_size;
  802e35:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e38:	eb 27                	jmp    802e61 <copy+0x1d9>
	}
	close(fd_src);
  802e3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e3d:	89 c7                	mov    %eax,%edi
  802e3f:	48 b8 55 21 80 00 00 	movabs $0x802155,%rax
  802e46:	00 00 00 
  802e49:	ff d0                	callq  *%rax
	close(fd_dest);
  802e4b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e4e:	89 c7                	mov    %eax,%edi
  802e50:	48 b8 55 21 80 00 00 	movabs $0x802155,%rax
  802e57:	00 00 00 
  802e5a:	ff d0                	callq  *%rax
	return 0;
  802e5c:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802e61:	c9                   	leaveq 
  802e62:	c3                   	retq   

0000000000802e63 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802e63:	55                   	push   %rbp
  802e64:	48 89 e5             	mov    %rsp,%rbp
  802e67:	48 83 ec 20          	sub    $0x20,%rsp
  802e6b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802e6e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e72:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e75:	48 89 d6             	mov    %rdx,%rsi
  802e78:	89 c7                	mov    %eax,%edi
  802e7a:	48 b8 45 1f 80 00 00 	movabs $0x801f45,%rax
  802e81:	00 00 00 
  802e84:	ff d0                	callq  *%rax
  802e86:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e8d:	79 05                	jns    802e94 <fd2sockid+0x31>
		return r;
  802e8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e92:	eb 24                	jmp    802eb8 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802e94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e98:	8b 10                	mov    (%rax),%edx
  802e9a:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802ea1:	00 00 00 
  802ea4:	8b 00                	mov    (%rax),%eax
  802ea6:	39 c2                	cmp    %eax,%edx
  802ea8:	74 07                	je     802eb1 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802eaa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802eaf:	eb 07                	jmp    802eb8 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802eb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb5:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802eb8:	c9                   	leaveq 
  802eb9:	c3                   	retq   

0000000000802eba <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802eba:	55                   	push   %rbp
  802ebb:	48 89 e5             	mov    %rsp,%rbp
  802ebe:	48 83 ec 20          	sub    $0x20,%rsp
  802ec2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802ec5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802ec9:	48 89 c7             	mov    %rax,%rdi
  802ecc:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  802ed3:	00 00 00 
  802ed6:	ff d0                	callq  *%rax
  802ed8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802edb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802edf:	78 26                	js     802f07 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802ee1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ee5:	ba 07 04 00 00       	mov    $0x407,%edx
  802eea:	48 89 c6             	mov    %rax,%rsi
  802eed:	bf 00 00 00 00       	mov    $0x0,%edi
  802ef2:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  802ef9:	00 00 00 
  802efc:	ff d0                	callq  *%rax
  802efe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f05:	79 16                	jns    802f1d <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802f07:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f0a:	89 c7                	mov    %eax,%edi
  802f0c:	48 b8 c7 33 80 00 00 	movabs $0x8033c7,%rax
  802f13:	00 00 00 
  802f16:	ff d0                	callq  *%rax
		return r;
  802f18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f1b:	eb 3a                	jmp    802f57 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802f1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f21:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802f28:	00 00 00 
  802f2b:	8b 12                	mov    (%rdx),%edx
  802f2d:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802f2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f33:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802f3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f3e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f41:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802f44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f48:	48 89 c7             	mov    %rax,%rdi
  802f4b:	48 b8 5f 1e 80 00 00 	movabs $0x801e5f,%rax
  802f52:	00 00 00 
  802f55:	ff d0                	callq  *%rax
}
  802f57:	c9                   	leaveq 
  802f58:	c3                   	retq   

0000000000802f59 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802f59:	55                   	push   %rbp
  802f5a:	48 89 e5             	mov    %rsp,%rbp
  802f5d:	48 83 ec 30          	sub    $0x30,%rsp
  802f61:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f64:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f68:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f6c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f6f:	89 c7                	mov    %eax,%edi
  802f71:	48 b8 63 2e 80 00 00 	movabs $0x802e63,%rax
  802f78:	00 00 00 
  802f7b:	ff d0                	callq  *%rax
  802f7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f80:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f84:	79 05                	jns    802f8b <accept+0x32>
		return r;
  802f86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f89:	eb 3b                	jmp    802fc6 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802f8b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f8f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f96:	48 89 ce             	mov    %rcx,%rsi
  802f99:	89 c7                	mov    %eax,%edi
  802f9b:	48 b8 a4 32 80 00 00 	movabs $0x8032a4,%rax
  802fa2:	00 00 00 
  802fa5:	ff d0                	callq  *%rax
  802fa7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802faa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fae:	79 05                	jns    802fb5 <accept+0x5c>
		return r;
  802fb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb3:	eb 11                	jmp    802fc6 <accept+0x6d>
	return alloc_sockfd(r);
  802fb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb8:	89 c7                	mov    %eax,%edi
  802fba:	48 b8 ba 2e 80 00 00 	movabs $0x802eba,%rax
  802fc1:	00 00 00 
  802fc4:	ff d0                	callq  *%rax
}
  802fc6:	c9                   	leaveq 
  802fc7:	c3                   	retq   

0000000000802fc8 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802fc8:	55                   	push   %rbp
  802fc9:	48 89 e5             	mov    %rsp,%rbp
  802fcc:	48 83 ec 20          	sub    $0x20,%rsp
  802fd0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fd3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fd7:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fda:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fdd:	89 c7                	mov    %eax,%edi
  802fdf:	48 b8 63 2e 80 00 00 	movabs $0x802e63,%rax
  802fe6:	00 00 00 
  802fe9:	ff d0                	callq  *%rax
  802feb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ff2:	79 05                	jns    802ff9 <bind+0x31>
		return r;
  802ff4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff7:	eb 1b                	jmp    803014 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802ff9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ffc:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803000:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803003:	48 89 ce             	mov    %rcx,%rsi
  803006:	89 c7                	mov    %eax,%edi
  803008:	48 b8 23 33 80 00 00 	movabs $0x803323,%rax
  80300f:	00 00 00 
  803012:	ff d0                	callq  *%rax
}
  803014:	c9                   	leaveq 
  803015:	c3                   	retq   

0000000000803016 <shutdown>:

int
shutdown(int s, int how)
{
  803016:	55                   	push   %rbp
  803017:	48 89 e5             	mov    %rsp,%rbp
  80301a:	48 83 ec 20          	sub    $0x20,%rsp
  80301e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803021:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803024:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803027:	89 c7                	mov    %eax,%edi
  803029:	48 b8 63 2e 80 00 00 	movabs $0x802e63,%rax
  803030:	00 00 00 
  803033:	ff d0                	callq  *%rax
  803035:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803038:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80303c:	79 05                	jns    803043 <shutdown+0x2d>
		return r;
  80303e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803041:	eb 16                	jmp    803059 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803043:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803046:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803049:	89 d6                	mov    %edx,%esi
  80304b:	89 c7                	mov    %eax,%edi
  80304d:	48 b8 87 33 80 00 00 	movabs $0x803387,%rax
  803054:	00 00 00 
  803057:	ff d0                	callq  *%rax
}
  803059:	c9                   	leaveq 
  80305a:	c3                   	retq   

000000000080305b <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80305b:	55                   	push   %rbp
  80305c:	48 89 e5             	mov    %rsp,%rbp
  80305f:	48 83 ec 10          	sub    $0x10,%rsp
  803063:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803067:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80306b:	48 89 c7             	mov    %rax,%rdi
  80306e:	48 b8 d5 40 80 00 00 	movabs $0x8040d5,%rax
  803075:	00 00 00 
  803078:	ff d0                	callq  *%rax
  80307a:	83 f8 01             	cmp    $0x1,%eax
  80307d:	75 17                	jne    803096 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80307f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803083:	8b 40 0c             	mov    0xc(%rax),%eax
  803086:	89 c7                	mov    %eax,%edi
  803088:	48 b8 c7 33 80 00 00 	movabs $0x8033c7,%rax
  80308f:	00 00 00 
  803092:	ff d0                	callq  *%rax
  803094:	eb 05                	jmp    80309b <devsock_close+0x40>
	else
		return 0;
  803096:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80309b:	c9                   	leaveq 
  80309c:	c3                   	retq   

000000000080309d <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80309d:	55                   	push   %rbp
  80309e:	48 89 e5             	mov    %rsp,%rbp
  8030a1:	48 83 ec 20          	sub    $0x20,%rsp
  8030a5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030ac:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8030af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030b2:	89 c7                	mov    %eax,%edi
  8030b4:	48 b8 63 2e 80 00 00 	movabs $0x802e63,%rax
  8030bb:	00 00 00 
  8030be:	ff d0                	callq  *%rax
  8030c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030c7:	79 05                	jns    8030ce <connect+0x31>
		return r;
  8030c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030cc:	eb 1b                	jmp    8030e9 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8030ce:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030d1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8030d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d8:	48 89 ce             	mov    %rcx,%rsi
  8030db:	89 c7                	mov    %eax,%edi
  8030dd:	48 b8 f4 33 80 00 00 	movabs $0x8033f4,%rax
  8030e4:	00 00 00 
  8030e7:	ff d0                	callq  *%rax
}
  8030e9:	c9                   	leaveq 
  8030ea:	c3                   	retq   

00000000008030eb <listen>:

int
listen(int s, int backlog)
{
  8030eb:	55                   	push   %rbp
  8030ec:	48 89 e5             	mov    %rsp,%rbp
  8030ef:	48 83 ec 20          	sub    $0x20,%rsp
  8030f3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030f6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8030f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030fc:	89 c7                	mov    %eax,%edi
  8030fe:	48 b8 63 2e 80 00 00 	movabs $0x802e63,%rax
  803105:	00 00 00 
  803108:	ff d0                	callq  *%rax
  80310a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80310d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803111:	79 05                	jns    803118 <listen+0x2d>
		return r;
  803113:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803116:	eb 16                	jmp    80312e <listen+0x43>
	return nsipc_listen(r, backlog);
  803118:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80311b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80311e:	89 d6                	mov    %edx,%esi
  803120:	89 c7                	mov    %eax,%edi
  803122:	48 b8 58 34 80 00 00 	movabs $0x803458,%rax
  803129:	00 00 00 
  80312c:	ff d0                	callq  *%rax
}
  80312e:	c9                   	leaveq 
  80312f:	c3                   	retq   

0000000000803130 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803130:	55                   	push   %rbp
  803131:	48 89 e5             	mov    %rsp,%rbp
  803134:	48 83 ec 20          	sub    $0x20,%rsp
  803138:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80313c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803140:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803144:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803148:	89 c2                	mov    %eax,%edx
  80314a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80314e:	8b 40 0c             	mov    0xc(%rax),%eax
  803151:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803155:	b9 00 00 00 00       	mov    $0x0,%ecx
  80315a:	89 c7                	mov    %eax,%edi
  80315c:	48 b8 98 34 80 00 00 	movabs $0x803498,%rax
  803163:	00 00 00 
  803166:	ff d0                	callq  *%rax
}
  803168:	c9                   	leaveq 
  803169:	c3                   	retq   

000000000080316a <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80316a:	55                   	push   %rbp
  80316b:	48 89 e5             	mov    %rsp,%rbp
  80316e:	48 83 ec 20          	sub    $0x20,%rsp
  803172:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803176:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80317a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80317e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803182:	89 c2                	mov    %eax,%edx
  803184:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803188:	8b 40 0c             	mov    0xc(%rax),%eax
  80318b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80318f:	b9 00 00 00 00       	mov    $0x0,%ecx
  803194:	89 c7                	mov    %eax,%edi
  803196:	48 b8 64 35 80 00 00 	movabs $0x803564,%rax
  80319d:	00 00 00 
  8031a0:	ff d0                	callq  *%rax
}
  8031a2:	c9                   	leaveq 
  8031a3:	c3                   	retq   

00000000008031a4 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8031a4:	55                   	push   %rbp
  8031a5:	48 89 e5             	mov    %rsp,%rbp
  8031a8:	48 83 ec 10          	sub    $0x10,%rsp
  8031ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8031b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031b8:	48 be 10 48 80 00 00 	movabs $0x804810,%rsi
  8031bf:	00 00 00 
  8031c2:	48 89 c7             	mov    %rax,%rdi
  8031c5:	48 b8 f9 11 80 00 00 	movabs $0x8011f9,%rax
  8031cc:	00 00 00 
  8031cf:	ff d0                	callq  *%rax
	return 0;
  8031d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031d6:	c9                   	leaveq 
  8031d7:	c3                   	retq   

00000000008031d8 <socket>:

int
socket(int domain, int type, int protocol)
{
  8031d8:	55                   	push   %rbp
  8031d9:	48 89 e5             	mov    %rsp,%rbp
  8031dc:	48 83 ec 20          	sub    $0x20,%rsp
  8031e0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031e3:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8031e6:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8031e9:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8031ec:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8031ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031f2:	89 ce                	mov    %ecx,%esi
  8031f4:	89 c7                	mov    %eax,%edi
  8031f6:	48 b8 1c 36 80 00 00 	movabs $0x80361c,%rax
  8031fd:	00 00 00 
  803200:	ff d0                	callq  *%rax
  803202:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803205:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803209:	79 05                	jns    803210 <socket+0x38>
		return r;
  80320b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80320e:	eb 11                	jmp    803221 <socket+0x49>
	return alloc_sockfd(r);
  803210:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803213:	89 c7                	mov    %eax,%edi
  803215:	48 b8 ba 2e 80 00 00 	movabs $0x802eba,%rax
  80321c:	00 00 00 
  80321f:	ff d0                	callq  *%rax
}
  803221:	c9                   	leaveq 
  803222:	c3                   	retq   

0000000000803223 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803223:	55                   	push   %rbp
  803224:	48 89 e5             	mov    %rsp,%rbp
  803227:	48 83 ec 10          	sub    $0x10,%rsp
  80322b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80322e:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803235:	00 00 00 
  803238:	8b 00                	mov    (%rax),%eax
  80323a:	85 c0                	test   %eax,%eax
  80323c:	75 1d                	jne    80325b <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80323e:	bf 02 00 00 00       	mov    $0x2,%edi
  803243:	48 b8 53 40 80 00 00 	movabs $0x804053,%rax
  80324a:	00 00 00 
  80324d:	ff d0                	callq  *%rax
  80324f:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  803256:	00 00 00 
  803259:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80325b:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803262:	00 00 00 
  803265:	8b 00                	mov    (%rax),%eax
  803267:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80326a:	b9 07 00 00 00       	mov    $0x7,%ecx
  80326f:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803276:	00 00 00 
  803279:	89 c7                	mov    %eax,%edi
  80327b:	48 b8 f1 3f 80 00 00 	movabs $0x803ff1,%rax
  803282:	00 00 00 
  803285:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803287:	ba 00 00 00 00       	mov    $0x0,%edx
  80328c:	be 00 00 00 00       	mov    $0x0,%esi
  803291:	bf 00 00 00 00       	mov    $0x0,%edi
  803296:	48 b8 eb 3e 80 00 00 	movabs $0x803eeb,%rax
  80329d:	00 00 00 
  8032a0:	ff d0                	callq  *%rax
}
  8032a2:	c9                   	leaveq 
  8032a3:	c3                   	retq   

00000000008032a4 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8032a4:	55                   	push   %rbp
  8032a5:	48 89 e5             	mov    %rsp,%rbp
  8032a8:	48 83 ec 30          	sub    $0x30,%rsp
  8032ac:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8032b7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032be:	00 00 00 
  8032c1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032c4:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8032c6:	bf 01 00 00 00       	mov    $0x1,%edi
  8032cb:	48 b8 23 32 80 00 00 	movabs $0x803223,%rax
  8032d2:	00 00 00 
  8032d5:	ff d0                	callq  *%rax
  8032d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032de:	78 3e                	js     80331e <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8032e0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032e7:	00 00 00 
  8032ea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8032ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032f2:	8b 40 10             	mov    0x10(%rax),%eax
  8032f5:	89 c2                	mov    %eax,%edx
  8032f7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8032fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032ff:	48 89 ce             	mov    %rcx,%rsi
  803302:	48 89 c7             	mov    %rax,%rdi
  803305:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  80330c:	00 00 00 
  80330f:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803311:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803315:	8b 50 10             	mov    0x10(%rax),%edx
  803318:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80331c:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80331e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803321:	c9                   	leaveq 
  803322:	c3                   	retq   

0000000000803323 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803323:	55                   	push   %rbp
  803324:	48 89 e5             	mov    %rsp,%rbp
  803327:	48 83 ec 10          	sub    $0x10,%rsp
  80332b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80332e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803332:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803335:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80333c:	00 00 00 
  80333f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803342:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803344:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803347:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80334b:	48 89 c6             	mov    %rax,%rsi
  80334e:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803355:	00 00 00 
  803358:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  80335f:	00 00 00 
  803362:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803364:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80336b:	00 00 00 
  80336e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803371:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803374:	bf 02 00 00 00       	mov    $0x2,%edi
  803379:	48 b8 23 32 80 00 00 	movabs $0x803223,%rax
  803380:	00 00 00 
  803383:	ff d0                	callq  *%rax
}
  803385:	c9                   	leaveq 
  803386:	c3                   	retq   

0000000000803387 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803387:	55                   	push   %rbp
  803388:	48 89 e5             	mov    %rsp,%rbp
  80338b:	48 83 ec 10          	sub    $0x10,%rsp
  80338f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803392:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803395:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80339c:	00 00 00 
  80339f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033a2:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8033a4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033ab:	00 00 00 
  8033ae:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033b1:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8033b4:	bf 03 00 00 00       	mov    $0x3,%edi
  8033b9:	48 b8 23 32 80 00 00 	movabs $0x803223,%rax
  8033c0:	00 00 00 
  8033c3:	ff d0                	callq  *%rax
}
  8033c5:	c9                   	leaveq 
  8033c6:	c3                   	retq   

00000000008033c7 <nsipc_close>:

int
nsipc_close(int s)
{
  8033c7:	55                   	push   %rbp
  8033c8:	48 89 e5             	mov    %rsp,%rbp
  8033cb:	48 83 ec 10          	sub    $0x10,%rsp
  8033cf:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8033d2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033d9:	00 00 00 
  8033dc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033df:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8033e1:	bf 04 00 00 00       	mov    $0x4,%edi
  8033e6:	48 b8 23 32 80 00 00 	movabs $0x803223,%rax
  8033ed:	00 00 00 
  8033f0:	ff d0                	callq  *%rax
}
  8033f2:	c9                   	leaveq 
  8033f3:	c3                   	retq   

00000000008033f4 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8033f4:	55                   	push   %rbp
  8033f5:	48 89 e5             	mov    %rsp,%rbp
  8033f8:	48 83 ec 10          	sub    $0x10,%rsp
  8033fc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803403:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803406:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80340d:	00 00 00 
  803410:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803413:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803415:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803418:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80341c:	48 89 c6             	mov    %rax,%rsi
  80341f:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803426:	00 00 00 
  803429:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  803430:	00 00 00 
  803433:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803435:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80343c:	00 00 00 
  80343f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803442:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803445:	bf 05 00 00 00       	mov    $0x5,%edi
  80344a:	48 b8 23 32 80 00 00 	movabs $0x803223,%rax
  803451:	00 00 00 
  803454:	ff d0                	callq  *%rax
}
  803456:	c9                   	leaveq 
  803457:	c3                   	retq   

0000000000803458 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803458:	55                   	push   %rbp
  803459:	48 89 e5             	mov    %rsp,%rbp
  80345c:	48 83 ec 10          	sub    $0x10,%rsp
  803460:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803463:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803466:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80346d:	00 00 00 
  803470:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803473:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803475:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80347c:	00 00 00 
  80347f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803482:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803485:	bf 06 00 00 00       	mov    $0x6,%edi
  80348a:	48 b8 23 32 80 00 00 	movabs $0x803223,%rax
  803491:	00 00 00 
  803494:	ff d0                	callq  *%rax
}
  803496:	c9                   	leaveq 
  803497:	c3                   	retq   

0000000000803498 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803498:	55                   	push   %rbp
  803499:	48 89 e5             	mov    %rsp,%rbp
  80349c:	48 83 ec 30          	sub    $0x30,%rsp
  8034a0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034a3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034a7:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8034aa:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8034ad:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034b4:	00 00 00 
  8034b7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034ba:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8034bc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034c3:	00 00 00 
  8034c6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034c9:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8034cc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034d3:	00 00 00 
  8034d6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8034d9:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8034dc:	bf 07 00 00 00       	mov    $0x7,%edi
  8034e1:	48 b8 23 32 80 00 00 	movabs $0x803223,%rax
  8034e8:	00 00 00 
  8034eb:	ff d0                	callq  *%rax
  8034ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034f4:	78 69                	js     80355f <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8034f6:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8034fd:	7f 08                	jg     803507 <nsipc_recv+0x6f>
  8034ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803502:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803505:	7e 35                	jle    80353c <nsipc_recv+0xa4>
  803507:	48 b9 17 48 80 00 00 	movabs $0x804817,%rcx
  80350e:	00 00 00 
  803511:	48 ba 2c 48 80 00 00 	movabs $0x80482c,%rdx
  803518:	00 00 00 
  80351b:	be 61 00 00 00       	mov    $0x61,%esi
  803520:	48 bf 41 48 80 00 00 	movabs $0x804841,%rdi
  803527:	00 00 00 
  80352a:	b8 00 00 00 00       	mov    $0x0,%eax
  80352f:	49 b8 0b 04 80 00 00 	movabs $0x80040b,%r8
  803536:	00 00 00 
  803539:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80353c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80353f:	48 63 d0             	movslq %eax,%rdx
  803542:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803546:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80354d:	00 00 00 
  803550:	48 89 c7             	mov    %rax,%rdi
  803553:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  80355a:	00 00 00 
  80355d:	ff d0                	callq  *%rax
	}

	return r;
  80355f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803562:	c9                   	leaveq 
  803563:	c3                   	retq   

0000000000803564 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803564:	55                   	push   %rbp
  803565:	48 89 e5             	mov    %rsp,%rbp
  803568:	48 83 ec 20          	sub    $0x20,%rsp
  80356c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80356f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803573:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803576:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803579:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803580:	00 00 00 
  803583:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803586:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803588:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80358f:	7e 35                	jle    8035c6 <nsipc_send+0x62>
  803591:	48 b9 4d 48 80 00 00 	movabs $0x80484d,%rcx
  803598:	00 00 00 
  80359b:	48 ba 2c 48 80 00 00 	movabs $0x80482c,%rdx
  8035a2:	00 00 00 
  8035a5:	be 6c 00 00 00       	mov    $0x6c,%esi
  8035aa:	48 bf 41 48 80 00 00 	movabs $0x804841,%rdi
  8035b1:	00 00 00 
  8035b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b9:	49 b8 0b 04 80 00 00 	movabs $0x80040b,%r8
  8035c0:	00 00 00 
  8035c3:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8035c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035c9:	48 63 d0             	movslq %eax,%rdx
  8035cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035d0:	48 89 c6             	mov    %rax,%rsi
  8035d3:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8035da:	00 00 00 
  8035dd:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  8035e4:	00 00 00 
  8035e7:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8035e9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035f0:	00 00 00 
  8035f3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035f6:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8035f9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803600:	00 00 00 
  803603:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803606:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803609:	bf 08 00 00 00       	mov    $0x8,%edi
  80360e:	48 b8 23 32 80 00 00 	movabs $0x803223,%rax
  803615:	00 00 00 
  803618:	ff d0                	callq  *%rax
}
  80361a:	c9                   	leaveq 
  80361b:	c3                   	retq   

000000000080361c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80361c:	55                   	push   %rbp
  80361d:	48 89 e5             	mov    %rsp,%rbp
  803620:	48 83 ec 10          	sub    $0x10,%rsp
  803624:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803627:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80362a:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80362d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803634:	00 00 00 
  803637:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80363a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80363c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803643:	00 00 00 
  803646:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803649:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80364c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803653:	00 00 00 
  803656:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803659:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80365c:	bf 09 00 00 00       	mov    $0x9,%edi
  803661:	48 b8 23 32 80 00 00 	movabs $0x803223,%rax
  803668:	00 00 00 
  80366b:	ff d0                	callq  *%rax
}
  80366d:	c9                   	leaveq 
  80366e:	c3                   	retq   

000000000080366f <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80366f:	55                   	push   %rbp
  803670:	48 89 e5             	mov    %rsp,%rbp
  803673:	53                   	push   %rbx
  803674:	48 83 ec 38          	sub    $0x38,%rsp
  803678:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80367c:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803680:	48 89 c7             	mov    %rax,%rdi
  803683:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  80368a:	00 00 00 
  80368d:	ff d0                	callq  *%rax
  80368f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803692:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803696:	0f 88 bf 01 00 00    	js     80385b <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80369c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036a0:	ba 07 04 00 00       	mov    $0x407,%edx
  8036a5:	48 89 c6             	mov    %rax,%rsi
  8036a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8036ad:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  8036b4:	00 00 00 
  8036b7:	ff d0                	callq  *%rax
  8036b9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036c0:	0f 88 95 01 00 00    	js     80385b <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8036c6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8036ca:	48 89 c7             	mov    %rax,%rdi
  8036cd:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  8036d4:	00 00 00 
  8036d7:	ff d0                	callq  *%rax
  8036d9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036e0:	0f 88 5d 01 00 00    	js     803843 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036e6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036ea:	ba 07 04 00 00       	mov    $0x407,%edx
  8036ef:	48 89 c6             	mov    %rax,%rsi
  8036f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8036f7:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  8036fe:	00 00 00 
  803701:	ff d0                	callq  *%rax
  803703:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803706:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80370a:	0f 88 33 01 00 00    	js     803843 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803710:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803714:	48 89 c7             	mov    %rax,%rdi
  803717:	48 b8 82 1e 80 00 00 	movabs $0x801e82,%rax
  80371e:	00 00 00 
  803721:	ff d0                	callq  *%rax
  803723:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803727:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80372b:	ba 07 04 00 00       	mov    $0x407,%edx
  803730:	48 89 c6             	mov    %rax,%rsi
  803733:	bf 00 00 00 00       	mov    $0x0,%edi
  803738:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  80373f:	00 00 00 
  803742:	ff d0                	callq  *%rax
  803744:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803747:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80374b:	79 05                	jns    803752 <pipe+0xe3>
		goto err2;
  80374d:	e9 d9 00 00 00       	jmpq   80382b <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803752:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803756:	48 89 c7             	mov    %rax,%rdi
  803759:	48 b8 82 1e 80 00 00 	movabs $0x801e82,%rax
  803760:	00 00 00 
  803763:	ff d0                	callq  *%rax
  803765:	48 89 c2             	mov    %rax,%rdx
  803768:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80376c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803772:	48 89 d1             	mov    %rdx,%rcx
  803775:	ba 00 00 00 00       	mov    $0x0,%edx
  80377a:	48 89 c6             	mov    %rax,%rsi
  80377d:	bf 00 00 00 00       	mov    $0x0,%edi
  803782:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  803789:	00 00 00 
  80378c:	ff d0                	callq  *%rax
  80378e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803791:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803795:	79 1b                	jns    8037b2 <pipe+0x143>
		goto err3;
  803797:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803798:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80379c:	48 89 c6             	mov    %rax,%rsi
  80379f:	bf 00 00 00 00       	mov    $0x0,%edi
  8037a4:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  8037ab:	00 00 00 
  8037ae:	ff d0                	callq  *%rax
  8037b0:	eb 79                	jmp    80382b <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8037b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037b6:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8037bd:	00 00 00 
  8037c0:	8b 12                	mov    (%rdx),%edx
  8037c2:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8037c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037c8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8037cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037d3:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8037da:	00 00 00 
  8037dd:	8b 12                	mov    (%rdx),%edx
  8037df:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8037e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037e5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8037ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037f0:	48 89 c7             	mov    %rax,%rdi
  8037f3:	48 b8 5f 1e 80 00 00 	movabs $0x801e5f,%rax
  8037fa:	00 00 00 
  8037fd:	ff d0                	callq  *%rax
  8037ff:	89 c2                	mov    %eax,%edx
  803801:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803805:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803807:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80380b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80380f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803813:	48 89 c7             	mov    %rax,%rdi
  803816:	48 b8 5f 1e 80 00 00 	movabs $0x801e5f,%rax
  80381d:	00 00 00 
  803820:	ff d0                	callq  *%rax
  803822:	89 03                	mov    %eax,(%rbx)
	return 0;
  803824:	b8 00 00 00 00       	mov    $0x0,%eax
  803829:	eb 33                	jmp    80385e <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80382b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80382f:	48 89 c6             	mov    %rax,%rsi
  803832:	bf 00 00 00 00       	mov    $0x0,%edi
  803837:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  80383e:	00 00 00 
  803841:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803843:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803847:	48 89 c6             	mov    %rax,%rsi
  80384a:	bf 00 00 00 00       	mov    $0x0,%edi
  80384f:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  803856:	00 00 00 
  803859:	ff d0                	callq  *%rax
err:
	return r;
  80385b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80385e:	48 83 c4 38          	add    $0x38,%rsp
  803862:	5b                   	pop    %rbx
  803863:	5d                   	pop    %rbp
  803864:	c3                   	retq   

0000000000803865 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803865:	55                   	push   %rbp
  803866:	48 89 e5             	mov    %rsp,%rbp
  803869:	53                   	push   %rbx
  80386a:	48 83 ec 28          	sub    $0x28,%rsp
  80386e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803872:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803876:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80387d:	00 00 00 
  803880:	48 8b 00             	mov    (%rax),%rax
  803883:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803889:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80388c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803890:	48 89 c7             	mov    %rax,%rdi
  803893:	48 b8 d5 40 80 00 00 	movabs $0x8040d5,%rax
  80389a:	00 00 00 
  80389d:	ff d0                	callq  *%rax
  80389f:	89 c3                	mov    %eax,%ebx
  8038a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038a5:	48 89 c7             	mov    %rax,%rdi
  8038a8:	48 b8 d5 40 80 00 00 	movabs $0x8040d5,%rax
  8038af:	00 00 00 
  8038b2:	ff d0                	callq  *%rax
  8038b4:	39 c3                	cmp    %eax,%ebx
  8038b6:	0f 94 c0             	sete   %al
  8038b9:	0f b6 c0             	movzbl %al,%eax
  8038bc:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8038bf:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8038c6:	00 00 00 
  8038c9:	48 8b 00             	mov    (%rax),%rax
  8038cc:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8038d2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8038d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038d8:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8038db:	75 05                	jne    8038e2 <_pipeisclosed+0x7d>
			return ret;
  8038dd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8038e0:	eb 4f                	jmp    803931 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8038e2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038e5:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8038e8:	74 42                	je     80392c <_pipeisclosed+0xc7>
  8038ea:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8038ee:	75 3c                	jne    80392c <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8038f0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8038f7:	00 00 00 
  8038fa:	48 8b 00             	mov    (%rax),%rax
  8038fd:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803903:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803906:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803909:	89 c6                	mov    %eax,%esi
  80390b:	48 bf 5e 48 80 00 00 	movabs $0x80485e,%rdi
  803912:	00 00 00 
  803915:	b8 00 00 00 00       	mov    $0x0,%eax
  80391a:	49 b8 44 06 80 00 00 	movabs $0x800644,%r8
  803921:	00 00 00 
  803924:	41 ff d0             	callq  *%r8
	}
  803927:	e9 4a ff ff ff       	jmpq   803876 <_pipeisclosed+0x11>
  80392c:	e9 45 ff ff ff       	jmpq   803876 <_pipeisclosed+0x11>
}
  803931:	48 83 c4 28          	add    $0x28,%rsp
  803935:	5b                   	pop    %rbx
  803936:	5d                   	pop    %rbp
  803937:	c3                   	retq   

0000000000803938 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803938:	55                   	push   %rbp
  803939:	48 89 e5             	mov    %rsp,%rbp
  80393c:	48 83 ec 30          	sub    $0x30,%rsp
  803940:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803943:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803947:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80394a:	48 89 d6             	mov    %rdx,%rsi
  80394d:	89 c7                	mov    %eax,%edi
  80394f:	48 b8 45 1f 80 00 00 	movabs $0x801f45,%rax
  803956:	00 00 00 
  803959:	ff d0                	callq  *%rax
  80395b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80395e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803962:	79 05                	jns    803969 <pipeisclosed+0x31>
		return r;
  803964:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803967:	eb 31                	jmp    80399a <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803969:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80396d:	48 89 c7             	mov    %rax,%rdi
  803970:	48 b8 82 1e 80 00 00 	movabs $0x801e82,%rax
  803977:	00 00 00 
  80397a:	ff d0                	callq  *%rax
  80397c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803980:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803984:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803988:	48 89 d6             	mov    %rdx,%rsi
  80398b:	48 89 c7             	mov    %rax,%rdi
  80398e:	48 b8 65 38 80 00 00 	movabs $0x803865,%rax
  803995:	00 00 00 
  803998:	ff d0                	callq  *%rax
}
  80399a:	c9                   	leaveq 
  80399b:	c3                   	retq   

000000000080399c <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80399c:	55                   	push   %rbp
  80399d:	48 89 e5             	mov    %rsp,%rbp
  8039a0:	48 83 ec 40          	sub    $0x40,%rsp
  8039a4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039a8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039ac:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8039b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039b4:	48 89 c7             	mov    %rax,%rdi
  8039b7:	48 b8 82 1e 80 00 00 	movabs $0x801e82,%rax
  8039be:	00 00 00 
  8039c1:	ff d0                	callq  *%rax
  8039c3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8039c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039cb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8039cf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039d6:	00 
  8039d7:	e9 92 00 00 00       	jmpq   803a6e <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8039dc:	eb 41                	jmp    803a1f <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8039de:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8039e3:	74 09                	je     8039ee <devpipe_read+0x52>
				return i;
  8039e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039e9:	e9 92 00 00 00       	jmpq   803a80 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8039ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039f6:	48 89 d6             	mov    %rdx,%rsi
  8039f9:	48 89 c7             	mov    %rax,%rdi
  8039fc:	48 b8 65 38 80 00 00 	movabs $0x803865,%rax
  803a03:	00 00 00 
  803a06:	ff d0                	callq  *%rax
  803a08:	85 c0                	test   %eax,%eax
  803a0a:	74 07                	je     803a13 <devpipe_read+0x77>
				return 0;
  803a0c:	b8 00 00 00 00       	mov    $0x0,%eax
  803a11:	eb 6d                	jmp    803a80 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803a13:	48 b8 ea 1a 80 00 00 	movabs $0x801aea,%rax
  803a1a:	00 00 00 
  803a1d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803a1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a23:	8b 10                	mov    (%rax),%edx
  803a25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a29:	8b 40 04             	mov    0x4(%rax),%eax
  803a2c:	39 c2                	cmp    %eax,%edx
  803a2e:	74 ae                	je     8039de <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803a30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a34:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a38:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803a3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a40:	8b 00                	mov    (%rax),%eax
  803a42:	99                   	cltd   
  803a43:	c1 ea 1b             	shr    $0x1b,%edx
  803a46:	01 d0                	add    %edx,%eax
  803a48:	83 e0 1f             	and    $0x1f,%eax
  803a4b:	29 d0                	sub    %edx,%eax
  803a4d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a51:	48 98                	cltq   
  803a53:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803a58:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803a5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a5e:	8b 00                	mov    (%rax),%eax
  803a60:	8d 50 01             	lea    0x1(%rax),%edx
  803a63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a67:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a69:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a72:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a76:	0f 82 60 ff ff ff    	jb     8039dc <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803a7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a80:	c9                   	leaveq 
  803a81:	c3                   	retq   

0000000000803a82 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a82:	55                   	push   %rbp
  803a83:	48 89 e5             	mov    %rsp,%rbp
  803a86:	48 83 ec 40          	sub    $0x40,%rsp
  803a8a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a8e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a92:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803a96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a9a:	48 89 c7             	mov    %rax,%rdi
  803a9d:	48 b8 82 1e 80 00 00 	movabs $0x801e82,%rax
  803aa4:	00 00 00 
  803aa7:	ff d0                	callq  *%rax
  803aa9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803aad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ab1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803ab5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803abc:	00 
  803abd:	e9 8e 00 00 00       	jmpq   803b50 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803ac2:	eb 31                	jmp    803af5 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803ac4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ac8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803acc:	48 89 d6             	mov    %rdx,%rsi
  803acf:	48 89 c7             	mov    %rax,%rdi
  803ad2:	48 b8 65 38 80 00 00 	movabs $0x803865,%rax
  803ad9:	00 00 00 
  803adc:	ff d0                	callq  *%rax
  803ade:	85 c0                	test   %eax,%eax
  803ae0:	74 07                	je     803ae9 <devpipe_write+0x67>
				return 0;
  803ae2:	b8 00 00 00 00       	mov    $0x0,%eax
  803ae7:	eb 79                	jmp    803b62 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803ae9:	48 b8 ea 1a 80 00 00 	movabs $0x801aea,%rax
  803af0:	00 00 00 
  803af3:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803af5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803af9:	8b 40 04             	mov    0x4(%rax),%eax
  803afc:	48 63 d0             	movslq %eax,%rdx
  803aff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b03:	8b 00                	mov    (%rax),%eax
  803b05:	48 98                	cltq   
  803b07:	48 83 c0 20          	add    $0x20,%rax
  803b0b:	48 39 c2             	cmp    %rax,%rdx
  803b0e:	73 b4                	jae    803ac4 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803b10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b14:	8b 40 04             	mov    0x4(%rax),%eax
  803b17:	99                   	cltd   
  803b18:	c1 ea 1b             	shr    $0x1b,%edx
  803b1b:	01 d0                	add    %edx,%eax
  803b1d:	83 e0 1f             	and    $0x1f,%eax
  803b20:	29 d0                	sub    %edx,%eax
  803b22:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803b26:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803b2a:	48 01 ca             	add    %rcx,%rdx
  803b2d:	0f b6 0a             	movzbl (%rdx),%ecx
  803b30:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b34:	48 98                	cltq   
  803b36:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803b3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b3e:	8b 40 04             	mov    0x4(%rax),%eax
  803b41:	8d 50 01             	lea    0x1(%rax),%edx
  803b44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b48:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b4b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b54:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b58:	0f 82 64 ff ff ff    	jb     803ac2 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803b5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b62:	c9                   	leaveq 
  803b63:	c3                   	retq   

0000000000803b64 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803b64:	55                   	push   %rbp
  803b65:	48 89 e5             	mov    %rsp,%rbp
  803b68:	48 83 ec 20          	sub    $0x20,%rsp
  803b6c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b70:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803b74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b78:	48 89 c7             	mov    %rax,%rdi
  803b7b:	48 b8 82 1e 80 00 00 	movabs $0x801e82,%rax
  803b82:	00 00 00 
  803b85:	ff d0                	callq  *%rax
  803b87:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803b8b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b8f:	48 be 71 48 80 00 00 	movabs $0x804871,%rsi
  803b96:	00 00 00 
  803b99:	48 89 c7             	mov    %rax,%rdi
  803b9c:	48 b8 f9 11 80 00 00 	movabs $0x8011f9,%rax
  803ba3:	00 00 00 
  803ba6:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803ba8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bac:	8b 50 04             	mov    0x4(%rax),%edx
  803baf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bb3:	8b 00                	mov    (%rax),%eax
  803bb5:	29 c2                	sub    %eax,%edx
  803bb7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bbb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803bc1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bc5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803bcc:	00 00 00 
	stat->st_dev = &devpipe;
  803bcf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bd3:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803bda:	00 00 00 
  803bdd:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803be4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803be9:	c9                   	leaveq 
  803bea:	c3                   	retq   

0000000000803beb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803beb:	55                   	push   %rbp
  803bec:	48 89 e5             	mov    %rsp,%rbp
  803bef:	48 83 ec 10          	sub    $0x10,%rsp
  803bf3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803bf7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bfb:	48 89 c6             	mov    %rax,%rsi
  803bfe:	bf 00 00 00 00       	mov    $0x0,%edi
  803c03:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  803c0a:	00 00 00 
  803c0d:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803c0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c13:	48 89 c7             	mov    %rax,%rdi
  803c16:	48 b8 82 1e 80 00 00 	movabs $0x801e82,%rax
  803c1d:	00 00 00 
  803c20:	ff d0                	callq  *%rax
  803c22:	48 89 c6             	mov    %rax,%rsi
  803c25:	bf 00 00 00 00       	mov    $0x0,%edi
  803c2a:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  803c31:	00 00 00 
  803c34:	ff d0                	callq  *%rax
}
  803c36:	c9                   	leaveq 
  803c37:	c3                   	retq   

0000000000803c38 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803c38:	55                   	push   %rbp
  803c39:	48 89 e5             	mov    %rsp,%rbp
  803c3c:	48 83 ec 20          	sub    $0x20,%rsp
  803c40:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803c43:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c46:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803c49:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803c4d:	be 01 00 00 00       	mov    $0x1,%esi
  803c52:	48 89 c7             	mov    %rax,%rdi
  803c55:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  803c5c:	00 00 00 
  803c5f:	ff d0                	callq  *%rax
}
  803c61:	c9                   	leaveq 
  803c62:	c3                   	retq   

0000000000803c63 <getchar>:

int
getchar(void)
{
  803c63:	55                   	push   %rbp
  803c64:	48 89 e5             	mov    %rsp,%rbp
  803c67:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803c6b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803c6f:	ba 01 00 00 00       	mov    $0x1,%edx
  803c74:	48 89 c6             	mov    %rax,%rsi
  803c77:	bf 00 00 00 00       	mov    $0x0,%edi
  803c7c:	48 b8 77 23 80 00 00 	movabs $0x802377,%rax
  803c83:	00 00 00 
  803c86:	ff d0                	callq  *%rax
  803c88:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803c8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c8f:	79 05                	jns    803c96 <getchar+0x33>
		return r;
  803c91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c94:	eb 14                	jmp    803caa <getchar+0x47>
	if (r < 1)
  803c96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c9a:	7f 07                	jg     803ca3 <getchar+0x40>
		return -E_EOF;
  803c9c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803ca1:	eb 07                	jmp    803caa <getchar+0x47>
	return c;
  803ca3:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803ca7:	0f b6 c0             	movzbl %al,%eax
}
  803caa:	c9                   	leaveq 
  803cab:	c3                   	retq   

0000000000803cac <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803cac:	55                   	push   %rbp
  803cad:	48 89 e5             	mov    %rsp,%rbp
  803cb0:	48 83 ec 20          	sub    $0x20,%rsp
  803cb4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803cb7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803cbb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cbe:	48 89 d6             	mov    %rdx,%rsi
  803cc1:	89 c7                	mov    %eax,%edi
  803cc3:	48 b8 45 1f 80 00 00 	movabs $0x801f45,%rax
  803cca:	00 00 00 
  803ccd:	ff d0                	callq  *%rax
  803ccf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cd2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cd6:	79 05                	jns    803cdd <iscons+0x31>
		return r;
  803cd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cdb:	eb 1a                	jmp    803cf7 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803cdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce1:	8b 10                	mov    (%rax),%edx
  803ce3:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803cea:	00 00 00 
  803ced:	8b 00                	mov    (%rax),%eax
  803cef:	39 c2                	cmp    %eax,%edx
  803cf1:	0f 94 c0             	sete   %al
  803cf4:	0f b6 c0             	movzbl %al,%eax
}
  803cf7:	c9                   	leaveq 
  803cf8:	c3                   	retq   

0000000000803cf9 <opencons>:

int
opencons(void)
{
  803cf9:	55                   	push   %rbp
  803cfa:	48 89 e5             	mov    %rsp,%rbp
  803cfd:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803d01:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803d05:	48 89 c7             	mov    %rax,%rdi
  803d08:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  803d0f:	00 00 00 
  803d12:	ff d0                	callq  *%rax
  803d14:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d1b:	79 05                	jns    803d22 <opencons+0x29>
		return r;
  803d1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d20:	eb 5b                	jmp    803d7d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803d22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d26:	ba 07 04 00 00       	mov    $0x407,%edx
  803d2b:	48 89 c6             	mov    %rax,%rsi
  803d2e:	bf 00 00 00 00       	mov    $0x0,%edi
  803d33:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  803d3a:	00 00 00 
  803d3d:	ff d0                	callq  *%rax
  803d3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d46:	79 05                	jns    803d4d <opencons+0x54>
		return r;
  803d48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d4b:	eb 30                	jmp    803d7d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803d4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d51:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803d58:	00 00 00 
  803d5b:	8b 12                	mov    (%rdx),%edx
  803d5d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803d5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d63:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803d6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d6e:	48 89 c7             	mov    %rax,%rdi
  803d71:	48 b8 5f 1e 80 00 00 	movabs $0x801e5f,%rax
  803d78:	00 00 00 
  803d7b:	ff d0                	callq  *%rax
}
  803d7d:	c9                   	leaveq 
  803d7e:	c3                   	retq   

0000000000803d7f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d7f:	55                   	push   %rbp
  803d80:	48 89 e5             	mov    %rsp,%rbp
  803d83:	48 83 ec 30          	sub    $0x30,%rsp
  803d87:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d8b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d8f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803d93:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d98:	75 07                	jne    803da1 <devcons_read+0x22>
		return 0;
  803d9a:	b8 00 00 00 00       	mov    $0x0,%eax
  803d9f:	eb 4b                	jmp    803dec <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803da1:	eb 0c                	jmp    803daf <devcons_read+0x30>
		sys_yield();
  803da3:	48 b8 ea 1a 80 00 00 	movabs $0x801aea,%rax
  803daa:	00 00 00 
  803dad:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803daf:	48 b8 2a 1a 80 00 00 	movabs $0x801a2a,%rax
  803db6:	00 00 00 
  803db9:	ff d0                	callq  *%rax
  803dbb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dbe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dc2:	74 df                	je     803da3 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803dc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dc8:	79 05                	jns    803dcf <devcons_read+0x50>
		return c;
  803dca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dcd:	eb 1d                	jmp    803dec <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803dcf:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803dd3:	75 07                	jne    803ddc <devcons_read+0x5d>
		return 0;
  803dd5:	b8 00 00 00 00       	mov    $0x0,%eax
  803dda:	eb 10                	jmp    803dec <devcons_read+0x6d>
	*(char*)vbuf = c;
  803ddc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ddf:	89 c2                	mov    %eax,%edx
  803de1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803de5:	88 10                	mov    %dl,(%rax)
	return 1;
  803de7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803dec:	c9                   	leaveq 
  803ded:	c3                   	retq   

0000000000803dee <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803dee:	55                   	push   %rbp
  803def:	48 89 e5             	mov    %rsp,%rbp
  803df2:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803df9:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803e00:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803e07:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e15:	eb 76                	jmp    803e8d <devcons_write+0x9f>
		m = n - tot;
  803e17:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803e1e:	89 c2                	mov    %eax,%edx
  803e20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e23:	29 c2                	sub    %eax,%edx
  803e25:	89 d0                	mov    %edx,%eax
  803e27:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803e2a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e2d:	83 f8 7f             	cmp    $0x7f,%eax
  803e30:	76 07                	jbe    803e39 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803e32:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803e39:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e3c:	48 63 d0             	movslq %eax,%rdx
  803e3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e42:	48 63 c8             	movslq %eax,%rcx
  803e45:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803e4c:	48 01 c1             	add    %rax,%rcx
  803e4f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e56:	48 89 ce             	mov    %rcx,%rsi
  803e59:	48 89 c7             	mov    %rax,%rdi
  803e5c:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  803e63:	00 00 00 
  803e66:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803e68:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e6b:	48 63 d0             	movslq %eax,%rdx
  803e6e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e75:	48 89 d6             	mov    %rdx,%rsi
  803e78:	48 89 c7             	mov    %rax,%rdi
  803e7b:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  803e82:	00 00 00 
  803e85:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e87:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e8a:	01 45 fc             	add    %eax,-0x4(%rbp)
  803e8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e90:	48 98                	cltq   
  803e92:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803e99:	0f 82 78 ff ff ff    	jb     803e17 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803e9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ea2:	c9                   	leaveq 
  803ea3:	c3                   	retq   

0000000000803ea4 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803ea4:	55                   	push   %rbp
  803ea5:	48 89 e5             	mov    %rsp,%rbp
  803ea8:	48 83 ec 08          	sub    $0x8,%rsp
  803eac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803eb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803eb5:	c9                   	leaveq 
  803eb6:	c3                   	retq   

0000000000803eb7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803eb7:	55                   	push   %rbp
  803eb8:	48 89 e5             	mov    %rsp,%rbp
  803ebb:	48 83 ec 10          	sub    $0x10,%rsp
  803ebf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ec3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803ec7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ecb:	48 be 7d 48 80 00 00 	movabs $0x80487d,%rsi
  803ed2:	00 00 00 
  803ed5:	48 89 c7             	mov    %rax,%rdi
  803ed8:	48 b8 f9 11 80 00 00 	movabs $0x8011f9,%rax
  803edf:	00 00 00 
  803ee2:	ff d0                	callq  *%rax
	return 0;
  803ee4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ee9:	c9                   	leaveq 
  803eea:	c3                   	retq   

0000000000803eeb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803eeb:	55                   	push   %rbp
  803eec:	48 89 e5             	mov    %rsp,%rbp
  803eef:	48 83 ec 30          	sub    $0x30,%rsp
  803ef3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ef7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803efb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803eff:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f06:	00 00 00 
  803f09:	48 8b 00             	mov    (%rax),%rax
  803f0c:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803f12:	85 c0                	test   %eax,%eax
  803f14:	75 3c                	jne    803f52 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803f16:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  803f1d:	00 00 00 
  803f20:	ff d0                	callq  *%rax
  803f22:	25 ff 03 00 00       	and    $0x3ff,%eax
  803f27:	48 63 d0             	movslq %eax,%rdx
  803f2a:	48 89 d0             	mov    %rdx,%rax
  803f2d:	48 c1 e0 03          	shl    $0x3,%rax
  803f31:	48 01 d0             	add    %rdx,%rax
  803f34:	48 c1 e0 05          	shl    $0x5,%rax
  803f38:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803f3f:	00 00 00 
  803f42:	48 01 c2             	add    %rax,%rdx
  803f45:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f4c:	00 00 00 
  803f4f:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803f52:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f57:	75 0e                	jne    803f67 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803f59:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f60:	00 00 00 
  803f63:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803f67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f6b:	48 89 c7             	mov    %rax,%rdi
  803f6e:	48 b8 51 1d 80 00 00 	movabs $0x801d51,%rax
  803f75:	00 00 00 
  803f78:	ff d0                	callq  *%rax
  803f7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803f7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f81:	79 19                	jns    803f9c <ipc_recv+0xb1>
		*from_env_store = 0;
  803f83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f87:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803f8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f91:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803f97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f9a:	eb 53                	jmp    803fef <ipc_recv+0x104>
	}
	if(from_env_store)
  803f9c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803fa1:	74 19                	je     803fbc <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803fa3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803faa:	00 00 00 
  803fad:	48 8b 00             	mov    (%rax),%rax
  803fb0:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803fb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fba:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803fbc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803fc1:	74 19                	je     803fdc <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803fc3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803fca:	00 00 00 
  803fcd:	48 8b 00             	mov    (%rax),%rax
  803fd0:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803fd6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fda:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803fdc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803fe3:	00 00 00 
  803fe6:	48 8b 00             	mov    (%rax),%rax
  803fe9:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803fef:	c9                   	leaveq 
  803ff0:	c3                   	retq   

0000000000803ff1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803ff1:	55                   	push   %rbp
  803ff2:	48 89 e5             	mov    %rsp,%rbp
  803ff5:	48 83 ec 30          	sub    $0x30,%rsp
  803ff9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ffc:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803fff:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804003:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804006:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80400b:	75 0e                	jne    80401b <ipc_send+0x2a>
		pg = (void*)UTOP;
  80400d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804014:	00 00 00 
  804017:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80401b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80401e:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804021:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804025:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804028:	89 c7                	mov    %eax,%edi
  80402a:	48 b8 fc 1c 80 00 00 	movabs $0x801cfc,%rax
  804031:	00 00 00 
  804034:	ff d0                	callq  *%rax
  804036:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804039:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80403d:	75 0c                	jne    80404b <ipc_send+0x5a>
			sys_yield();
  80403f:	48 b8 ea 1a 80 00 00 	movabs $0x801aea,%rax
  804046:	00 00 00 
  804049:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80404b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80404f:	74 ca                	je     80401b <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  804051:	c9                   	leaveq 
  804052:	c3                   	retq   

0000000000804053 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804053:	55                   	push   %rbp
  804054:	48 89 e5             	mov    %rsp,%rbp
  804057:	48 83 ec 14          	sub    $0x14,%rsp
  80405b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80405e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804065:	eb 5e                	jmp    8040c5 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804067:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80406e:	00 00 00 
  804071:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804074:	48 63 d0             	movslq %eax,%rdx
  804077:	48 89 d0             	mov    %rdx,%rax
  80407a:	48 c1 e0 03          	shl    $0x3,%rax
  80407e:	48 01 d0             	add    %rdx,%rax
  804081:	48 c1 e0 05          	shl    $0x5,%rax
  804085:	48 01 c8             	add    %rcx,%rax
  804088:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80408e:	8b 00                	mov    (%rax),%eax
  804090:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804093:	75 2c                	jne    8040c1 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804095:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80409c:	00 00 00 
  80409f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040a2:	48 63 d0             	movslq %eax,%rdx
  8040a5:	48 89 d0             	mov    %rdx,%rax
  8040a8:	48 c1 e0 03          	shl    $0x3,%rax
  8040ac:	48 01 d0             	add    %rdx,%rax
  8040af:	48 c1 e0 05          	shl    $0x5,%rax
  8040b3:	48 01 c8             	add    %rcx,%rax
  8040b6:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8040bc:	8b 40 08             	mov    0x8(%rax),%eax
  8040bf:	eb 12                	jmp    8040d3 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8040c1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8040c5:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8040cc:	7e 99                	jle    804067 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8040ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040d3:	c9                   	leaveq 
  8040d4:	c3                   	retq   

00000000008040d5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8040d5:	55                   	push   %rbp
  8040d6:	48 89 e5             	mov    %rsp,%rbp
  8040d9:	48 83 ec 18          	sub    $0x18,%rsp
  8040dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8040e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040e5:	48 c1 e8 15          	shr    $0x15,%rax
  8040e9:	48 89 c2             	mov    %rax,%rdx
  8040ec:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8040f3:	01 00 00 
  8040f6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040fa:	83 e0 01             	and    $0x1,%eax
  8040fd:	48 85 c0             	test   %rax,%rax
  804100:	75 07                	jne    804109 <pageref+0x34>
		return 0;
  804102:	b8 00 00 00 00       	mov    $0x0,%eax
  804107:	eb 53                	jmp    80415c <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804109:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80410d:	48 c1 e8 0c          	shr    $0xc,%rax
  804111:	48 89 c2             	mov    %rax,%rdx
  804114:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80411b:	01 00 00 
  80411e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804122:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804126:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80412a:	83 e0 01             	and    $0x1,%eax
  80412d:	48 85 c0             	test   %rax,%rax
  804130:	75 07                	jne    804139 <pageref+0x64>
		return 0;
  804132:	b8 00 00 00 00       	mov    $0x0,%eax
  804137:	eb 23                	jmp    80415c <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804139:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80413d:	48 c1 e8 0c          	shr    $0xc,%rax
  804141:	48 89 c2             	mov    %rax,%rdx
  804144:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80414b:	00 00 00 
  80414e:	48 c1 e2 04          	shl    $0x4,%rdx
  804152:	48 01 d0             	add    %rdx,%rax
  804155:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804159:	0f b7 c0             	movzwl %ax,%eax
}
  80415c:	c9                   	leaveq 
  80415d:	c3                   	retq   
