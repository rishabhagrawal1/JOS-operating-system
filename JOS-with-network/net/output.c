#include "ns.h"
#include <inc/lib.h>

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
    binaryname = "ns_output";

    // LAB 6: Your code here:
    // 	- read a packet from the network server
    //	- send the packet to the device driver
	void* buf = NULL;
	size_t len = 0;
	sys_net_tx((void*)nsipcbuf.send.req_buf, nsipcbuf.send.req_size);
}
