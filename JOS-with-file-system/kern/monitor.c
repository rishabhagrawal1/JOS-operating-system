// Simple command-line kernel monitor useful for
// controlling the kernel and exploring the system interactively.

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/assert.h>
#include <inc/x86.h>

#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/dwarf.h>
#include <kern/kdebug.h>
#include <kern/dwarf_api.h>
#include <kern/trap.h>

#define CMDBUF_SIZE	80	// enough for one VGA text line


struct Command {
	const char *name;
	const char *desc;
	// return -1 to force monitor to exit
	int (*func)(int argc, char** argv, struct Trapframe* tf);
};

static struct Command commands[] = {
	{ "help", "Display this list of commands", mon_help },
	{ "kerninfo", "Display information about the kernel", mon_kerninfo },
	{ "backtrace", "Display backtrace of stack", mon_backtrace },
};
#define NCOMMANDS (sizeof(commands)/sizeof(commands[0]))

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	cprintf("%d",sizeof(int));	
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}

void printArgList(uint64_t* prbp, struct Ripdebuginfo *info)
{
	uint64_t* tprbp = (uint64_t*)(prbp - 4);
	int numberArg = info->rip_fn_narg;
	int i = 0;
	uint64_t size = 0;
	if(numberArg <= 0)
	{
		cprintf("\n");
		return;
	}
	
	while(numberArg > 0)
	{
		//cprintf("size of argument %d is %d %x",i, info->size_fn_arg[i],*prbp);
		size = info->size_fn_arg[i];
		cprintf(" ");
		switch(size)
		{
			case 1:
				cprintf("%016x",*((char*)tprbp -1));
				tprbp = (uint64_t*)((char*)tprbp - 1);
				break;
			case 4:
				cprintf("%016x",*((int*)tprbp -1));
				tprbp = (uint64_t*)((int*)tprbp - 1);
				break;
			case 8:
				cprintf("%016x",*(tprbp -1));
				tprbp = tprbp - 1;
				break;
			default:
				break;
		}
		i++;
		numberArg--;
	}
	cprintf("\n");
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	// Your code here.
	uint64_t rbp = 0x0;
	uint64_t rip = 0x0;
	uint64_t* prbp = NULL;

	struct Ripdebuginfo info;

	cprintf("Stack backtrace:\n");
	rbp = read_rbp();
	read_rip(rip);
	if(rbp == 0x0 || rip == 0x0)
	{
		cprintf("Not able to show backtrace");
		return -1;
	}
	prbp = (uint64_t*)(rbp);

	cprintf("    rbp %016x  rip %016x\n", prbp, rip);
	debuginfo_rip(rip ,&info);
	
	cprintf("        %s:%d: ",info.rip_file, info.rip_line);
	cprintf("%.*s+%016x",info.rip_fn_namelen, info.rip_fn_name, (rip - info.rip_fn_addr));
	cprintf(" args:%d", info.rip_fn_narg);
	printArgList(prbp, &info);

	while(prbp && *(prbp) != 0x0 && *(prbp+1) != 0x0)
	{
		cprintf("    rbp %016x  rip %016x\n",*(prbp),*((prbp) +1));
		debuginfo_rip(*(prbp+1) ,&info);

		cprintf("        %s:%d: ",info.rip_file, info.rip_line);
		cprintf("%.*s+%016x",info.rip_fn_namelen, info.rip_fn_name, (rip - info.rip_fn_addr));
		cprintf(" args:%d", info.rip_fn_narg);
		printArgList((uint64_t*)(*(prbp)), &info);
		
		prbp = (uint64_t*)(*(prbp)); 
	}
	return 0;
}



/***** Kernel monitor command interpreter *****/

#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}

void
monitor(struct Trapframe *tf)
{
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");

	if (tf != NULL)
		print_trapframe(tf);

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
