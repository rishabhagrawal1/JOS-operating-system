#include <kern/e1000.h>
#include <kern/pci.h>
#include <kern/pmap.h>
#include <inc/string.h>

// LAB 6: Your driver code here

struct tx_desc txDescArr[64];
int tx_desc_head = 0;
int tx_desc_tail = 0;
volatile uint32_t *map_region;


void initializeDescriptors(){
    int i;
    struct PageInfo* page;
    for (i = 0;i<64;i++){
        page = page_alloc(1);
        txDescArr[i].addr = page2pa(page);
        txDescArr[i].cmd = 0x08;
        txDescArr[i].length = E1000_TXD_BUFFER_LENGTH;
        txDescArr[i].status = 0x1;
    }
}

int pci_transmit_packet(const void * src,size_t n){ //Need to check for more parameters
    void * va;
	cprintf("%d\n", n);
    if(n > E1000_TXD_BUFFER_LENGTH || n < 1){
        cprintf("This should not fail\n");
        return -1;
    }
    /*check if free descriptors are available*/
    if(!(txDescArr[tx_desc_tail].status & 0x1)){
        cprintf("Tx Desc is not found [%d] and [%d]\n",txDescArr[tx_desc_tail].status, tx_desc_tail);
        return -1;
    }

    va = page2kva(pa2page(txDescArr[tx_desc_tail].addr));
    //memmove(va, src, n);
    tx_desc_tail++;
    map_region[0x3818 >> 2] = tx_desc_tail;
    if(tx_desc_tail == 64){
    	tx_desc_tail = 0;
    }
    cprintf("We did all we can \n");
    return 0;
}

int
pci_func_attach_E1000(struct pci_func *f)
{
    pci_func_enable(f);
    map_region = (uint32_t *)mmio_map_region(f->reg_base[0] ,(size_t)f->reg_size[0]);
    cprintf("Device status reg is %x\n",map_region[2]);
	map_region[0x3810 >> 2] = 0x0; //TDH set to 0b
	map_region[0x3818 >> 2] = 0x0; //TDT set to 0b

    map_region[0x400 >> 2] = 0x4008A; //TCTL
    map_region[0x410 >> 2] = 0x60200A; //TIPG  /*binary: 00000000011000000010000000001010*/
    map_region[0x3800 >> 2] = PADDR(txDescArr); //TDBAL & TDBAH
    map_region[0x3808 >> 2] = 0x400; //TDLEN set to 1024 = 64*16

    initializeDescriptors();
    cprintf("Trying to send a packet\n");
	//sys_page_map(0,UTEMP,0,UTEMP,PTE_P|PTE_U);

    return 0;
}


