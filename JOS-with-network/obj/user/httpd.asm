
obj/user/httpd.debug:     file format elf64-x86-64


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
  80003c:	e8 f0 08 00 00       	callq  800931 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <die>:
	{404, "Not Found"},
};

static void
die(char *m)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	cprintf("%s\n", m);
  80004f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800053:	48 89 c6             	mov    %rax,%rsi
  800056:	48 bf bc 51 80 00 00 	movabs $0x8051bc,%rdi
  80005d:	00 00 00 
  800060:	b8 00 00 00 00       	mov    $0x0,%eax
  800065:	48 ba 18 0c 80 00 00 	movabs $0x800c18,%rdx
  80006c:	00 00 00 
  80006f:	ff d2                	callq  *%rdx
	exit();
  800071:	48 b8 bc 09 80 00 00 	movabs $0x8009bc,%rax
  800078:	00 00 00 
  80007b:	ff d0                	callq  *%rax
}
  80007d:	c9                   	leaveq 
  80007e:	c3                   	retq   

000000000080007f <req_free>:

static void
req_free(struct http_request *req)
{
  80007f:	55                   	push   %rbp
  800080:	48 89 e5             	mov    %rsp,%rbp
  800083:	48 83 ec 10          	sub    $0x10,%rsp
  800087:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	free(req->url);
  80008b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80008f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800093:	48 89 c7             	mov    %rax,%rdi
  800096:	48 b8 5f 40 80 00 00 	movabs $0x80405f,%rax
  80009d:	00 00 00 
  8000a0:	ff d0                	callq  *%rax
	free(req->version);
  8000a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000a6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8000aa:	48 89 c7             	mov    %rax,%rdi
  8000ad:	48 b8 5f 40 80 00 00 	movabs $0x80405f,%rax
  8000b4:	00 00 00 
  8000b7:	ff d0                	callq  *%rax
}
  8000b9:	c9                   	leaveq 
  8000ba:	c3                   	retq   

00000000008000bb <send_header>:

static int
send_header(struct http_request *req, int code)
{
  8000bb:	55                   	push   %rbp
  8000bc:	48 89 e5             	mov    %rsp,%rbp
  8000bf:	48 83 ec 20          	sub    $0x20,%rsp
  8000c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8000c7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	struct responce_header *h = headers;
  8000ca:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8000d1:	00 00 00 
  8000d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (h->code != 0 && h->header!= 0) {
  8000d8:	eb 12                	jmp    8000ec <send_header+0x31>
		if (h->code == code)
  8000da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000de:	8b 00                	mov    (%rax),%eax
  8000e0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8000e3:	75 02                	jne    8000e7 <send_header+0x2c>
			break;
  8000e5:	eb 1c                	jmp    800103 <send_header+0x48>
		h++;
  8000e7:	48 83 45 f8 10       	addq   $0x10,-0x8(%rbp)

static int
send_header(struct http_request *req, int code)
{
	struct responce_header *h = headers;
	while (h->code != 0 && h->header!= 0) {
  8000ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f0:	8b 00                	mov    (%rax),%eax
  8000f2:	85 c0                	test   %eax,%eax
  8000f4:	74 0d                	je     800103 <send_header+0x48>
  8000f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000fa:	48 8b 40 08          	mov    0x8(%rax),%rax
  8000fe:	48 85 c0             	test   %rax,%rax
  800101:	75 d7                	jne    8000da <send_header+0x1f>
		if (h->code == code)
			break;
		h++;
	}

	if (h->code == 0)
  800103:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800107:	8b 00                	mov    (%rax),%eax
  800109:	85 c0                	test   %eax,%eax
  80010b:	75 07                	jne    800114 <send_header+0x59>
		return -1;
  80010d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800112:	eb 5f                	jmp    800173 <send_header+0xb8>

	int len = strlen(h->header);
  800114:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800118:	48 8b 40 08          	mov    0x8(%rax),%rax
  80011c:	48 89 c7             	mov    %rax,%rdi
  80011f:	48 b8 61 17 80 00 00 	movabs $0x801761,%rax
  800126:	00 00 00 
  800129:	ff d0                	callq  *%rax
  80012b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (write(req->sock, h->header, len) != len) {
  80012e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800131:	48 63 d0             	movslq %eax,%rdx
  800134:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800138:	48 8b 48 08          	mov    0x8(%rax),%rcx
  80013c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800140:	8b 00                	mov    (%rax),%eax
  800142:	48 89 ce             	mov    %rcx,%rsi
  800145:	89 c7                	mov    %eax,%edi
  800147:	48 b8 95 2a 80 00 00 	movabs $0x802a95,%rax
  80014e:	00 00 00 
  800151:	ff d0                	callq  *%rax
  800153:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  800156:	74 16                	je     80016e <send_header+0xb3>
		die("Failed to send bytes to client");
  800158:	48 bf c0 51 80 00 00 	movabs $0x8051c0,%rdi
  80015f:	00 00 00 
  800162:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800169:	00 00 00 
  80016c:	ff d0                	callq  *%rax
	}

	return 0;
  80016e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800173:	c9                   	leaveq 
  800174:	c3                   	retq   

0000000000800175 <send_data>:

static int
send_data(struct http_request *req, int fd)
{
  800175:	55                   	push   %rbp
  800176:	48 89 e5             	mov    %rsp,%rbp
  800179:	48 83 ec 10          	sub    $0x10,%rsp
  80017d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800181:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// LAB 6: Your code here.
	panic("send_data not implemented");
  800184:	48 ba df 51 80 00 00 	movabs $0x8051df,%rdx
  80018b:	00 00 00 
  80018e:	be 50 00 00 00       	mov    $0x50,%esi
  800193:	48 bf f9 51 80 00 00 	movabs $0x8051f9,%rdi
  80019a:	00 00 00 
  80019d:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a2:	48 b9 df 09 80 00 00 	movabs $0x8009df,%rcx
  8001a9:	00 00 00 
  8001ac:	ff d1                	callq  *%rcx

00000000008001ae <send_size>:
}

static int
send_size(struct http_request *req, off_t size)
{
  8001ae:	55                   	push   %rbp
  8001af:	48 89 e5             	mov    %rsp,%rbp
  8001b2:	48 83 ec 60          	sub    $0x60,%rsp
  8001b6:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8001ba:	89 75 a4             	mov    %esi,-0x5c(%rbp)
	char buf[64];
	int r;

	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
  8001bd:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  8001c0:	48 63 d0             	movslq %eax,%rdx
  8001c3:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8001c7:	48 89 d1             	mov    %rdx,%rcx
  8001ca:	48 ba 06 52 80 00 00 	movabs $0x805206,%rdx
  8001d1:	00 00 00 
  8001d4:	be 40 00 00 00       	mov    $0x40,%esi
  8001d9:	48 89 c7             	mov    %rax,%rdi
  8001dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e1:	49 b8 80 16 80 00 00 	movabs $0x801680,%r8
  8001e8:	00 00 00 
  8001eb:	41 ff d0             	callq  *%r8
  8001ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r > 63)
  8001f1:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%rbp)
  8001f5:	7e 2a                	jle    800221 <send_size+0x73>
		panic("buffer too small!");
  8001f7:	48 ba 1c 52 80 00 00 	movabs $0x80521c,%rdx
  8001fe:	00 00 00 
  800201:	be 5b 00 00 00       	mov    $0x5b,%esi
  800206:	48 bf f9 51 80 00 00 	movabs $0x8051f9,%rdi
  80020d:	00 00 00 
  800210:	b8 00 00 00 00       	mov    $0x0,%eax
  800215:	48 b9 df 09 80 00 00 	movabs $0x8009df,%rcx
  80021c:	00 00 00 
  80021f:	ff d1                	callq  *%rcx

	if (write(req->sock, buf, r) != r)
  800221:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800224:	48 63 d0             	movslq %eax,%rdx
  800227:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80022b:	8b 00                	mov    (%rax),%eax
  80022d:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
  800231:	48 89 ce             	mov    %rcx,%rsi
  800234:	89 c7                	mov    %eax,%edi
  800236:	48 b8 95 2a 80 00 00 	movabs $0x802a95,%rax
  80023d:	00 00 00 
  800240:	ff d0                	callq  *%rax
  800242:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800245:	74 07                	je     80024e <send_size+0xa0>
		return -1;
  800247:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80024c:	eb 05                	jmp    800253 <send_size+0xa5>

	return 0;
  80024e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800253:	c9                   	leaveq 
  800254:	c3                   	retq   

0000000000800255 <mime_type>:

static const char*
mime_type(const char *file)
{
  800255:	55                   	push   %rbp
  800256:	48 89 e5             	mov    %rsp,%rbp
  800259:	48 83 ec 08          	sub    $0x8,%rsp
  80025d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	//TODO: for now only a single mime type
	return "text/html";
  800261:	48 b8 2e 52 80 00 00 	movabs $0x80522e,%rax
  800268:	00 00 00 
}
  80026b:	c9                   	leaveq 
  80026c:	c3                   	retq   

000000000080026d <send_content_type>:

static int
send_content_type(struct http_request *req)
{
  80026d:	55                   	push   %rbp
  80026e:	48 89 e5             	mov    %rsp,%rbp
  800271:	48 81 ec a0 00 00 00 	sub    $0xa0,%rsp
  800278:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
	char buf[128];
	int r;
	const char *type;

	type = mime_type(req->url);
  80027f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800286:	48 8b 40 08          	mov    0x8(%rax),%rax
  80028a:	48 89 c7             	mov    %rax,%rdi
  80028d:	48 b8 55 02 80 00 00 	movabs $0x800255,%rax
  800294:	00 00 00 
  800297:	ff d0                	callq  *%rax
  800299:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!type)
  80029d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8002a2:	75 0a                	jne    8002ae <send_content_type+0x41>
		return -1;
  8002a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8002a9:	e9 9d 00 00 00       	jmpq   80034b <send_content_type+0xde>

	r = snprintf(buf, 128, "Content-Type: %s\r\n", type);
  8002ae:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8002b2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8002b9:	48 89 d1             	mov    %rdx,%rcx
  8002bc:	48 ba 38 52 80 00 00 	movabs $0x805238,%rdx
  8002c3:	00 00 00 
  8002c6:	be 80 00 00 00       	mov    $0x80,%esi
  8002cb:	48 89 c7             	mov    %rax,%rdi
  8002ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d3:	49 b8 80 16 80 00 00 	movabs $0x801680,%r8
  8002da:	00 00 00 
  8002dd:	41 ff d0             	callq  *%r8
  8002e0:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (r > 127)
  8002e3:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  8002e7:	7e 2a                	jle    800313 <send_content_type+0xa6>
		panic("buffer too small!");
  8002e9:	48 ba 1c 52 80 00 00 	movabs $0x80521c,%rdx
  8002f0:	00 00 00 
  8002f3:	be 77 00 00 00       	mov    $0x77,%esi
  8002f8:	48 bf f9 51 80 00 00 	movabs $0x8051f9,%rdi
  8002ff:	00 00 00 
  800302:	b8 00 00 00 00       	mov    $0x0,%eax
  800307:	48 b9 df 09 80 00 00 	movabs $0x8009df,%rcx
  80030e:	00 00 00 
  800311:	ff d1                	callq  *%rcx

	if (write(req->sock, buf, r) != r)
  800313:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800316:	48 63 d0             	movslq %eax,%rdx
  800319:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800320:	8b 00                	mov    (%rax),%eax
  800322:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
  800329:	48 89 ce             	mov    %rcx,%rsi
  80032c:	89 c7                	mov    %eax,%edi
  80032e:	48 b8 95 2a 80 00 00 	movabs $0x802a95,%rax
  800335:	00 00 00 
  800338:	ff d0                	callq  *%rax
  80033a:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80033d:	74 07                	je     800346 <send_content_type+0xd9>
		return -1;
  80033f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800344:	eb 05                	jmp    80034b <send_content_type+0xde>

	return 0;
  800346:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80034b:	c9                   	leaveq 
  80034c:	c3                   	retq   

000000000080034d <send_header_fin>:

static int
send_header_fin(struct http_request *req)
{
  80034d:	55                   	push   %rbp
  80034e:	48 89 e5             	mov    %rsp,%rbp
  800351:	48 83 ec 20          	sub    $0x20,%rsp
  800355:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	const char *fin = "\r\n";
  800359:	48 b8 4b 52 80 00 00 	movabs $0x80524b,%rax
  800360:	00 00 00 
  800363:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	int fin_len = strlen(fin);
  800367:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80036b:	48 89 c7             	mov    %rax,%rdi
  80036e:	48 b8 61 17 80 00 00 	movabs $0x801761,%rax
  800375:	00 00 00 
  800378:	ff d0                	callq  *%rax
  80037a:	89 45 f4             	mov    %eax,-0xc(%rbp)

	if (write(req->sock, fin, fin_len) != fin_len)
  80037d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800380:	48 63 d0             	movslq %eax,%rdx
  800383:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800387:	8b 00                	mov    (%rax),%eax
  800389:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80038d:	48 89 ce             	mov    %rcx,%rsi
  800390:	89 c7                	mov    %eax,%edi
  800392:	48 b8 95 2a 80 00 00 	movabs $0x802a95,%rax
  800399:	00 00 00 
  80039c:	ff d0                	callq  *%rax
  80039e:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8003a1:	74 07                	je     8003aa <send_header_fin+0x5d>
		return -1;
  8003a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8003a8:	eb 05                	jmp    8003af <send_header_fin+0x62>

	return 0;
  8003aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003af:	c9                   	leaveq 
  8003b0:	c3                   	retq   

00000000008003b1 <http_request_parse>:

// given a request, this function creates a struct http_request
static int
http_request_parse(struct http_request *req, char *request)
{
  8003b1:	55                   	push   %rbp
  8003b2:	48 89 e5             	mov    %rsp,%rbp
  8003b5:	48 83 ec 30          	sub    $0x30,%rsp
  8003b9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8003bd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	const char *url;
	const char *version;
	int url_len, version_len;

	if (!req)
  8003c1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8003c6:	75 0a                	jne    8003d2 <http_request_parse+0x21>
		return -1;
  8003c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8003cd:	e9 57 01 00 00       	jmpq   800529 <http_request_parse+0x178>

	if (strncmp(request, "GET ", 4) != 0)
  8003d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8003d6:	ba 04 00 00 00       	mov    $0x4,%edx
  8003db:	48 be 4e 52 80 00 00 	movabs $0x80524e,%rsi
  8003e2:	00 00 00 
  8003e5:	48 89 c7             	mov    %rax,%rdi
  8003e8:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  8003ef:	00 00 00 
  8003f2:	ff d0                	callq  *%rax
  8003f4:	85 c0                	test   %eax,%eax
  8003f6:	74 0a                	je     800402 <http_request_parse+0x51>
		return -E_BAD_REQ;
  8003f8:	b8 18 fc ff ff       	mov    $0xfffffc18,%eax
  8003fd:	e9 27 01 00 00       	jmpq   800529 <http_request_parse+0x178>

	// skip GET
	request += 4;
  800402:	48 83 45 d0 04       	addq   $0x4,-0x30(%rbp)

	// get the url
	url = request;
  800407:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80040b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (*request && *request != ' ')
  80040f:	eb 05                	jmp    800416 <http_request_parse+0x65>
		request++;
  800411:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	// skip GET
	request += 4;

	// get the url
	url = request;
	while (*request && *request != ' ')
  800416:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80041a:	0f b6 00             	movzbl (%rax),%eax
  80041d:	84 c0                	test   %al,%al
  80041f:	74 0b                	je     80042c <http_request_parse+0x7b>
  800421:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800425:	0f b6 00             	movzbl (%rax),%eax
  800428:	3c 20                	cmp    $0x20,%al
  80042a:	75 e5                	jne    800411 <http_request_parse+0x60>
		request++;
	url_len = request - url;
  80042c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800430:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800434:	48 29 c2             	sub    %rax,%rdx
  800437:	48 89 d0             	mov    %rdx,%rax
  80043a:	89 45 f4             	mov    %eax,-0xc(%rbp)

	req->url = malloc(url_len + 1);
  80043d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800440:	83 c0 01             	add    $0x1,%eax
  800443:	48 98                	cltq   
  800445:	48 89 c7             	mov    %rax,%rdi
  800448:	48 b8 e1 3c 80 00 00 	movabs $0x803ce1,%rax
  80044f:	00 00 00 
  800452:	ff d0                	callq  *%rax
  800454:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800458:	48 89 42 08          	mov    %rax,0x8(%rdx)
	memmove(req->url, url, url_len);
  80045c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80045f:	48 63 d0             	movslq %eax,%rdx
  800462:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800466:	48 8b 40 08          	mov    0x8(%rax),%rax
  80046a:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80046e:	48 89 ce             	mov    %rcx,%rsi
  800471:	48 89 c7             	mov    %rax,%rdi
  800474:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  80047b:	00 00 00 
  80047e:	ff d0                	callq  *%rax
	req->url[url_len] = '\0';
  800480:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800484:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800488:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80048b:	48 98                	cltq   
  80048d:	48 01 d0             	add    %rdx,%rax
  800490:	c6 00 00             	movb   $0x0,(%rax)

	// skip space
	request++;
  800493:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)

	version = request;
  800498:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80049c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	while (*request && *request != '\n')
  8004a0:	eb 05                	jmp    8004a7 <http_request_parse+0xf6>
		request++;
  8004a2:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)

	// skip space
	request++;

	version = request;
	while (*request && *request != '\n')
  8004a7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004ab:	0f b6 00             	movzbl (%rax),%eax
  8004ae:	84 c0                	test   %al,%al
  8004b0:	74 0b                	je     8004bd <http_request_parse+0x10c>
  8004b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004b6:	0f b6 00             	movzbl (%rax),%eax
  8004b9:	3c 0a                	cmp    $0xa,%al
  8004bb:	75 e5                	jne    8004a2 <http_request_parse+0xf1>
		request++;
	version_len = request - version;
  8004bd:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c5:	48 29 c2             	sub    %rax,%rdx
  8004c8:	48 89 d0             	mov    %rdx,%rax
  8004cb:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	req->version = malloc(version_len + 1);
  8004ce:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004d1:	83 c0 01             	add    $0x1,%eax
  8004d4:	48 98                	cltq   
  8004d6:	48 89 c7             	mov    %rax,%rdi
  8004d9:	48 b8 e1 3c 80 00 00 	movabs $0x803ce1,%rax
  8004e0:	00 00 00 
  8004e3:	ff d0                	callq  *%rax
  8004e5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004e9:	48 89 42 10          	mov    %rax,0x10(%rdx)
	memmove(req->version, version, version_len);
  8004ed:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004f0:	48 63 d0             	movslq %eax,%rdx
  8004f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004f7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8004fb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004ff:	48 89 ce             	mov    %rcx,%rsi
  800502:	48 89 c7             	mov    %rax,%rdi
  800505:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  80050c:	00 00 00 
  80050f:	ff d0                	callq  *%rax
	req->version[version_len] = '\0';
  800511:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800515:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800519:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80051c:	48 98                	cltq   
  80051e:	48 01 d0             	add    %rdx,%rax
  800521:	c6 00 00             	movb   $0x0,(%rax)

	// no entity parsing

	return 0;
  800524:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800529:	c9                   	leaveq 
  80052a:	c3                   	retq   

000000000080052b <send_error>:

static int
send_error(struct http_request *req, int code)
{
  80052b:	55                   	push   %rbp
  80052c:	48 89 e5             	mov    %rsp,%rbp
  80052f:	48 81 ec 30 02 00 00 	sub    $0x230,%rsp
  800536:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80053d:	89 b5 e4 fd ff ff    	mov    %esi,-0x21c(%rbp)
	char buf[512];
	int r;

	struct error_messages *e = errors;
  800543:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80054a:	00 00 00 
  80054d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->code != 0 && e->msg != 0) {
  800551:	eb 15                	jmp    800568 <send_error+0x3d>
		if (e->code == code)
  800553:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800557:	8b 00                	mov    (%rax),%eax
  800559:	3b 85 e4 fd ff ff    	cmp    -0x21c(%rbp),%eax
  80055f:	75 02                	jne    800563 <send_error+0x38>
			break;
  800561:	eb 1c                	jmp    80057f <send_error+0x54>
		e++;
  800563:	48 83 45 f8 10       	addq   $0x10,-0x8(%rbp)
{
	char buf[512];
	int r;

	struct error_messages *e = errors;
	while (e->code != 0 && e->msg != 0) {
  800568:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80056c:	8b 00                	mov    (%rax),%eax
  80056e:	85 c0                	test   %eax,%eax
  800570:	74 0d                	je     80057f <send_error+0x54>
  800572:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800576:	48 8b 40 08          	mov    0x8(%rax),%rax
  80057a:	48 85 c0             	test   %rax,%rax
  80057d:	75 d4                	jne    800553 <send_error+0x28>
		if (e->code == code)
			break;
		e++;
	}

	if (e->code == 0)
  80057f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800583:	8b 00                	mov    (%rax),%eax
  800585:	85 c0                	test   %eax,%eax
  800587:	75 0a                	jne    800593 <send_error+0x68>
		return -1;
  800589:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80058e:	e9 8e 00 00 00       	jmpq   800621 <send_error+0xf6>

	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  800593:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800597:	48 8b 48 08          	mov    0x8(%rax),%rcx
  80059b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80059f:	8b 38                	mov    (%rax),%edi
  8005a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005a5:	48 8b 70 08          	mov    0x8(%rax),%rsi
  8005a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005ad:	8b 10                	mov    (%rax),%edx
  8005af:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  8005b6:	48 89 0c 24          	mov    %rcx,(%rsp)
  8005ba:	41 89 f9             	mov    %edi,%r9d
  8005bd:	49 89 f0             	mov    %rsi,%r8
  8005c0:	89 d1                	mov    %edx,%ecx
  8005c2:	48 ba 58 52 80 00 00 	movabs $0x805258,%rdx
  8005c9:	00 00 00 
  8005cc:	be 00 02 00 00       	mov    $0x200,%esi
  8005d1:	48 89 c7             	mov    %rax,%rdi
  8005d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d9:	49 ba 80 16 80 00 00 	movabs $0x801680,%r10
  8005e0:	00 00 00 
  8005e3:	41 ff d2             	callq  *%r10
  8005e6:	89 45 f4             	mov    %eax,-0xc(%rbp)
		     "Content-type: text/html\r\n"
		     "\r\n"
		     "<html><body><p>%d - %s</p></body></html>\r\n",
		     e->code, e->msg, e->code, e->msg);

	if (write(req->sock, buf, r) != r)
  8005e9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8005ec:	48 63 d0             	movslq %eax,%rdx
  8005ef:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8005f6:	8b 00                	mov    (%rax),%eax
  8005f8:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8005ff:	48 89 ce             	mov    %rcx,%rsi
  800602:	89 c7                	mov    %eax,%edi
  800604:	48 b8 95 2a 80 00 00 	movabs $0x802a95,%rax
  80060b:	00 00 00 
  80060e:	ff d0                	callq  *%rax
  800610:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  800613:	74 07                	je     80061c <send_error+0xf1>
		return -1;
  800615:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80061a:	eb 05                	jmp    800621 <send_error+0xf6>

	return 0;
  80061c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800621:	c9                   	leaveq 
  800622:	c3                   	retq   

0000000000800623 <send_file>:

static int
send_file(struct http_request *req)
{
  800623:	55                   	push   %rbp
  800624:	48 89 e5             	mov    %rsp,%rbp
  800627:	48 83 ec 20          	sub    $0x20,%rsp
  80062b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;
	off_t file_size = -1;
  80062f:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	// if the file does not exist, send a 404 error using send_error
	// if the file is a directory, send a 404 error using send_error
	// set file_size to the size of the file

	// LAB 6: Your code here.
	panic("send_file not implemented");
  800636:	48 ba d3 52 80 00 00 	movabs $0x8052d3,%rdx
  80063d:	00 00 00 
  800640:	be e2 00 00 00       	mov    $0xe2,%esi
  800645:	48 bf f9 51 80 00 00 	movabs $0x8051f9,%rdi
  80064c:	00 00 00 
  80064f:	b8 00 00 00 00       	mov    $0x0,%eax
  800654:	48 b9 df 09 80 00 00 	movabs $0x8009df,%rcx
  80065b:	00 00 00 
  80065e:	ff d1                	callq  *%rcx

0000000000800660 <handle_client>:
	return r;
}

static void
handle_client(int sock)
{
  800660:	55                   	push   %rbp
  800661:	48 89 e5             	mov    %rsp,%rbp
  800664:	48 81 ec 40 02 00 00 	sub    $0x240,%rsp
  80066b:	89 bd cc fd ff ff    	mov    %edi,-0x234(%rbp)
	struct http_request con_d;
	int r;
	char buffer[BUFFSIZE];
	int received = -1;
  800671:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	struct http_request *req = &con_d;
  800678:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80067c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (1)
	{
		// Receive message
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  800680:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  800687:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  80068d:	ba 00 02 00 00       	mov    $0x200,%edx
  800692:	48 89 ce             	mov    %rcx,%rsi
  800695:	89 c7                	mov    %eax,%edi
  800697:	48 b8 4b 29 80 00 00 	movabs $0x80294b,%rax
  80069e:	00 00 00 
  8006a1:	ff d0                	callq  *%rax
  8006a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8006a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8006aa:	79 2a                	jns    8006d6 <handle_client+0x76>
			panic("failed to read");
  8006ac:	48 ba ed 52 80 00 00 	movabs $0x8052ed,%rdx
  8006b3:	00 00 00 
  8006b6:	be 04 01 00 00       	mov    $0x104,%esi
  8006bb:	48 bf f9 51 80 00 00 	movabs $0x8051f9,%rdi
  8006c2:	00 00 00 
  8006c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ca:	48 b9 df 09 80 00 00 	movabs $0x8009df,%rcx
  8006d1:	00 00 00 
  8006d4:	ff d1                	callq  *%rcx

		memset(req, 0, sizeof(req));
  8006d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006da:	ba 08 00 00 00       	mov    $0x8,%edx
  8006df:	be 00 00 00 00       	mov    $0x0,%esi
  8006e4:	48 89 c7             	mov    %rax,%rdi
  8006e7:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  8006ee:	00 00 00 
  8006f1:	ff d0                	callq  *%rax

		req->sock = sock;
  8006f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006f7:	8b 95 cc fd ff ff    	mov    -0x234(%rbp),%edx
  8006fd:	89 10                	mov    %edx,(%rax)

		r = http_request_parse(req, buffer);
  8006ff:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  800706:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80070a:	48 89 d6             	mov    %rdx,%rsi
  80070d:	48 89 c7             	mov    %rax,%rdi
  800710:	48 b8 b1 03 80 00 00 	movabs $0x8003b1,%rax
  800717:	00 00 00 
  80071a:	ff d0                	callq  *%rax
  80071c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (r == -E_BAD_REQ)
  80071f:	81 7d ec 18 fc ff ff 	cmpl   $0xfffffc18,-0x14(%rbp)
  800726:	75 1a                	jne    800742 <handle_client+0xe2>
			send_error(req, 400);
  800728:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80072c:	be 90 01 00 00       	mov    $0x190,%esi
  800731:	48 89 c7             	mov    %rax,%rdi
  800734:	48 b8 2b 05 80 00 00 	movabs $0x80052b,%rax
  80073b:	00 00 00 
  80073e:	ff d0                	callq  *%rax
  800740:	eb 43                	jmp    800785 <handle_client+0x125>
		else if (r < 0)
  800742:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800746:	79 2a                	jns    800772 <handle_client+0x112>
			panic("parse failed");
  800748:	48 ba fc 52 80 00 00 	movabs $0x8052fc,%rdx
  80074f:	00 00 00 
  800752:	be 0e 01 00 00       	mov    $0x10e,%esi
  800757:	48 bf f9 51 80 00 00 	movabs $0x8051f9,%rdi
  80075e:	00 00 00 
  800761:	b8 00 00 00 00       	mov    $0x0,%eax
  800766:	48 b9 df 09 80 00 00 	movabs $0x8009df,%rcx
  80076d:	00 00 00 
  800770:	ff d1                	callq  *%rcx
		else
			send_file(req);
  800772:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800776:	48 89 c7             	mov    %rax,%rdi
  800779:	48 b8 23 06 80 00 00 	movabs $0x800623,%rax
  800780:	00 00 00 
  800783:	ff d0                	callq  *%rax

		req_free(req);
  800785:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800789:	48 89 c7             	mov    %rax,%rdi
  80078c:	48 b8 7f 00 80 00 00 	movabs $0x80007f,%rax
  800793:	00 00 00 
  800796:	ff d0                	callq  *%rax

		// no keep alive
		break;
  800798:	90                   	nop
	}

	close(sock);
  800799:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  80079f:	89 c7                	mov    %eax,%edi
  8007a1:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  8007a8:	00 00 00 
  8007ab:	ff d0                	callq  *%rax
}
  8007ad:	c9                   	leaveq 
  8007ae:	c3                   	retq   

00000000008007af <umain>:

void
umain(int argc, char **argv)
{
  8007af:	55                   	push   %rbp
  8007b0:	48 89 e5             	mov    %rsp,%rbp
  8007b3:	53                   	push   %rbx
  8007b4:	48 83 ec 58          	sub    $0x58,%rsp
  8007b8:	89 7d ac             	mov    %edi,-0x54(%rbp)
  8007bb:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
	int serversock, clientsock;
	struct sockaddr_in server, client;

	binaryname = "jhttpd";
  8007bf:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8007c6:	00 00 00 
  8007c9:	48 bb 09 53 80 00 00 	movabs $0x805309,%rbx
  8007d0:	00 00 00 
  8007d3:	48 89 18             	mov    %rbx,(%rax)

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8007d6:	ba 06 00 00 00       	mov    $0x6,%edx
  8007db:	be 01 00 00 00       	mov    $0x1,%esi
  8007e0:	bf 02 00 00 00       	mov    $0x2,%edi
  8007e5:	48 b8 ac 37 80 00 00 	movabs $0x8037ac,%rax
  8007ec:	00 00 00 
  8007ef:	ff d0                	callq  *%rax
  8007f1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8007f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8007f8:	79 16                	jns    800810 <umain+0x61>
		die("Failed to create socket");
  8007fa:	48 bf 10 53 80 00 00 	movabs $0x805310,%rdi
  800801:	00 00 00 
  800804:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80080b:	00 00 00 
  80080e:	ff d0                	callq  *%rax

	// Construct the server sockaddr_in structure
	memset(&server, 0, sizeof(server));		// Clear struct
  800810:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800814:	ba 10 00 00 00       	mov    $0x10,%edx
  800819:	be 00 00 00 00       	mov    $0x0,%esi
  80081e:	48 89 c7             	mov    %rax,%rdi
  800821:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  800828:	00 00 00 
  80082b:	ff d0                	callq  *%rax
	server.sin_family = AF_INET;			// Internet/IP
  80082d:	c6 45 d1 02          	movb   $0x2,-0x2f(%rbp)
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// IP address
  800831:	bf 00 00 00 00       	mov    $0x0,%edi
  800836:	48 b8 10 51 80 00 00 	movabs $0x805110,%rax
  80083d:	00 00 00 
  800840:	ff d0                	callq  *%rax
  800842:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	server.sin_port = htons(PORT);			// server port
  800845:	bf 50 00 00 00       	mov    $0x50,%edi
  80084a:	48 b8 cb 50 80 00 00 	movabs $0x8050cb,%rax
  800851:	00 00 00 
  800854:	ff d0                	callq  *%rax
  800856:	66 89 45 d2          	mov    %ax,-0x2e(%rbp)

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &server,
  80085a:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  80085e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800861:	ba 10 00 00 00       	mov    $0x10,%edx
  800866:	48 89 ce             	mov    %rcx,%rsi
  800869:	89 c7                	mov    %eax,%edi
  80086b:	48 b8 9c 35 80 00 00 	movabs $0x80359c,%rax
  800872:	00 00 00 
  800875:	ff d0                	callq  *%rax
  800877:	85 c0                	test   %eax,%eax
  800879:	79 16                	jns    800891 <umain+0xe2>
		 sizeof(server)) < 0)
	{
		die("Failed to bind the server socket");
  80087b:	48 bf 28 53 80 00 00 	movabs $0x805328,%rdi
  800882:	00 00 00 
  800885:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80088c:	00 00 00 
  80088f:	ff d0                	callq  *%rax
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800891:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800894:	be 05 00 00 00       	mov    $0x5,%esi
  800899:	89 c7                	mov    %eax,%edi
  80089b:	48 b8 bf 36 80 00 00 	movabs $0x8036bf,%rax
  8008a2:	00 00 00 
  8008a5:	ff d0                	callq  *%rax
  8008a7:	85 c0                	test   %eax,%eax
  8008a9:	79 16                	jns    8008c1 <umain+0x112>
		die("Failed to listen on server socket");
  8008ab:	48 bf 50 53 80 00 00 	movabs $0x805350,%rdi
  8008b2:	00 00 00 
  8008b5:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8008bc:	00 00 00 
  8008bf:	ff d0                	callq  *%rax

	cprintf("Waiting for http connections...\n");
  8008c1:	48 bf 78 53 80 00 00 	movabs $0x805378,%rdi
  8008c8:	00 00 00 
  8008cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d0:	48 ba 18 0c 80 00 00 	movabs $0x800c18,%rdx
  8008d7:	00 00 00 
  8008da:	ff d2                	callq  *%rdx

	while (1) {
		unsigned int clientlen = sizeof(client);
  8008dc:	c7 45 bc 10 00 00 00 	movl   $0x10,-0x44(%rbp)
		// Wait for client connection
		if ((clientsock = accept(serversock,
  8008e3:	48 8d 55 bc          	lea    -0x44(%rbp),%rdx
  8008e7:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
  8008eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008ee:	48 89 ce             	mov    %rcx,%rsi
  8008f1:	89 c7                	mov    %eax,%edi
  8008f3:	48 b8 2d 35 80 00 00 	movabs $0x80352d,%rax
  8008fa:	00 00 00 
  8008fd:	ff d0                	callq  *%rax
  8008ff:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800902:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800906:	79 16                	jns    80091e <umain+0x16f>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  800908:	48 bf a0 53 80 00 00 	movabs $0x8053a0,%rdi
  80090f:	00 00 00 
  800912:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800919:	00 00 00 
  80091c:	ff d0                	callq  *%rax
		}
		handle_client(clientsock);
  80091e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800921:	89 c7                	mov    %eax,%edi
  800923:	48 b8 60 06 80 00 00 	movabs $0x800660,%rax
  80092a:	00 00 00 
  80092d:	ff d0                	callq  *%rax
	}
  80092f:	eb ab                	jmp    8008dc <umain+0x12d>

0000000000800931 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800931:	55                   	push   %rbp
  800932:	48 89 e5             	mov    %rsp,%rbp
  800935:	48 83 ec 10          	sub    $0x10,%rsp
  800939:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80093c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800940:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  800947:	00 00 00 
  80094a:	ff d0                	callq  *%rax
  80094c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800951:	48 63 d0             	movslq %eax,%rdx
  800954:	48 89 d0             	mov    %rdx,%rax
  800957:	48 c1 e0 03          	shl    $0x3,%rax
  80095b:	48 01 d0             	add    %rdx,%rax
  80095e:	48 c1 e0 05          	shl    $0x5,%rax
  800962:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800969:	00 00 00 
  80096c:	48 01 c2             	add    %rax,%rdx
  80096f:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  800976:	00 00 00 
  800979:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80097c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800980:	7e 14                	jle    800996 <libmain+0x65>
		binaryname = argv[0];
  800982:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800986:	48 8b 10             	mov    (%rax),%rdx
  800989:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800990:	00 00 00 
  800993:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800996:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80099a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80099d:	48 89 d6             	mov    %rdx,%rsi
  8009a0:	89 c7                	mov    %eax,%edi
  8009a2:	48 b8 af 07 80 00 00 	movabs $0x8007af,%rax
  8009a9:	00 00 00 
  8009ac:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8009ae:	48 b8 bc 09 80 00 00 	movabs $0x8009bc,%rax
  8009b5:	00 00 00 
  8009b8:	ff d0                	callq  *%rax
}
  8009ba:	c9                   	leaveq 
  8009bb:	c3                   	retq   

00000000008009bc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8009bc:	55                   	push   %rbp
  8009bd:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8009c0:	48 b8 74 27 80 00 00 	movabs $0x802774,%rax
  8009c7:	00 00 00 
  8009ca:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8009cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8009d1:	48 b8 3c 20 80 00 00 	movabs $0x80203c,%rax
  8009d8:	00 00 00 
  8009db:	ff d0                	callq  *%rax

}
  8009dd:	5d                   	pop    %rbp
  8009de:	c3                   	retq   

00000000008009df <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8009df:	55                   	push   %rbp
  8009e0:	48 89 e5             	mov    %rsp,%rbp
  8009e3:	53                   	push   %rbx
  8009e4:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8009eb:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8009f2:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8009f8:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8009ff:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800a06:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800a0d:	84 c0                	test   %al,%al
  800a0f:	74 23                	je     800a34 <_panic+0x55>
  800a11:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800a18:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800a1c:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800a20:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800a24:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800a28:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800a2c:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800a30:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800a34:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800a3b:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800a42:	00 00 00 
  800a45:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800a4c:	00 00 00 
  800a4f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800a53:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800a5a:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800a61:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a68:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800a6f:	00 00 00 
  800a72:	48 8b 18             	mov    (%rax),%rbx
  800a75:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  800a7c:	00 00 00 
  800a7f:	ff d0                	callq  *%rax
  800a81:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800a87:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800a8e:	41 89 c8             	mov    %ecx,%r8d
  800a91:	48 89 d1             	mov    %rdx,%rcx
  800a94:	48 89 da             	mov    %rbx,%rdx
  800a97:	89 c6                	mov    %eax,%esi
  800a99:	48 bf d0 53 80 00 00 	movabs $0x8053d0,%rdi
  800aa0:	00 00 00 
  800aa3:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa8:	49 b9 18 0c 80 00 00 	movabs $0x800c18,%r9
  800aaf:	00 00 00 
  800ab2:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800ab5:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800abc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ac3:	48 89 d6             	mov    %rdx,%rsi
  800ac6:	48 89 c7             	mov    %rax,%rdi
  800ac9:	48 b8 6c 0b 80 00 00 	movabs $0x800b6c,%rax
  800ad0:	00 00 00 
  800ad3:	ff d0                	callq  *%rax
	cprintf("\n");
  800ad5:	48 bf f3 53 80 00 00 	movabs $0x8053f3,%rdi
  800adc:	00 00 00 
  800adf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae4:	48 ba 18 0c 80 00 00 	movabs $0x800c18,%rdx
  800aeb:	00 00 00 
  800aee:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800af0:	cc                   	int3   
  800af1:	eb fd                	jmp    800af0 <_panic+0x111>

0000000000800af3 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800af3:	55                   	push   %rbp
  800af4:	48 89 e5             	mov    %rsp,%rbp
  800af7:	48 83 ec 10          	sub    $0x10,%rsp
  800afb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800afe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800b02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b06:	8b 00                	mov    (%rax),%eax
  800b08:	8d 48 01             	lea    0x1(%rax),%ecx
  800b0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800b0f:	89 0a                	mov    %ecx,(%rdx)
  800b11:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800b14:	89 d1                	mov    %edx,%ecx
  800b16:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800b1a:	48 98                	cltq   
  800b1c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800b20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b24:	8b 00                	mov    (%rax),%eax
  800b26:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b2b:	75 2c                	jne    800b59 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800b2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b31:	8b 00                	mov    (%rax),%eax
  800b33:	48 98                	cltq   
  800b35:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800b39:	48 83 c2 08          	add    $0x8,%rdx
  800b3d:	48 89 c6             	mov    %rax,%rsi
  800b40:	48 89 d7             	mov    %rdx,%rdi
  800b43:	48 b8 b4 1f 80 00 00 	movabs $0x801fb4,%rax
  800b4a:	00 00 00 
  800b4d:	ff d0                	callq  *%rax
        b->idx = 0;
  800b4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b53:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800b59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b5d:	8b 40 04             	mov    0x4(%rax),%eax
  800b60:	8d 50 01             	lea    0x1(%rax),%edx
  800b63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b67:	89 50 04             	mov    %edx,0x4(%rax)
}
  800b6a:	c9                   	leaveq 
  800b6b:	c3                   	retq   

0000000000800b6c <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800b6c:	55                   	push   %rbp
  800b6d:	48 89 e5             	mov    %rsp,%rbp
  800b70:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800b77:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800b7e:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800b85:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800b8c:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800b93:	48 8b 0a             	mov    (%rdx),%rcx
  800b96:	48 89 08             	mov    %rcx,(%rax)
  800b99:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b9d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ba1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ba5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800ba9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800bb0:	00 00 00 
    b.cnt = 0;
  800bb3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800bba:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800bbd:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800bc4:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800bcb:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800bd2:	48 89 c6             	mov    %rax,%rsi
  800bd5:	48 bf f3 0a 80 00 00 	movabs $0x800af3,%rdi
  800bdc:	00 00 00 
  800bdf:	48 b8 cb 0f 80 00 00 	movabs $0x800fcb,%rax
  800be6:	00 00 00 
  800be9:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800beb:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800bf1:	48 98                	cltq   
  800bf3:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800bfa:	48 83 c2 08          	add    $0x8,%rdx
  800bfe:	48 89 c6             	mov    %rax,%rsi
  800c01:	48 89 d7             	mov    %rdx,%rdi
  800c04:	48 b8 b4 1f 80 00 00 	movabs $0x801fb4,%rax
  800c0b:	00 00 00 
  800c0e:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800c10:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800c16:	c9                   	leaveq 
  800c17:	c3                   	retq   

0000000000800c18 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800c18:	55                   	push   %rbp
  800c19:	48 89 e5             	mov    %rsp,%rbp
  800c1c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800c23:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800c2a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800c31:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c38:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c3f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c46:	84 c0                	test   %al,%al
  800c48:	74 20                	je     800c6a <cprintf+0x52>
  800c4a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c4e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c52:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c56:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c5a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c5e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c62:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c66:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c6a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800c71:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800c78:	00 00 00 
  800c7b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800c82:	00 00 00 
  800c85:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c89:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800c90:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c97:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800c9e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ca5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800cac:	48 8b 0a             	mov    (%rdx),%rcx
  800caf:	48 89 08             	mov    %rcx,(%rax)
  800cb2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800cb6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cba:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cbe:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800cc2:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800cc9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800cd0:	48 89 d6             	mov    %rdx,%rsi
  800cd3:	48 89 c7             	mov    %rax,%rdi
  800cd6:	48 b8 6c 0b 80 00 00 	movabs $0x800b6c,%rax
  800cdd:	00 00 00 
  800ce0:	ff d0                	callq  *%rax
  800ce2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800ce8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800cee:	c9                   	leaveq 
  800cef:	c3                   	retq   

0000000000800cf0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800cf0:	55                   	push   %rbp
  800cf1:	48 89 e5             	mov    %rsp,%rbp
  800cf4:	53                   	push   %rbx
  800cf5:	48 83 ec 38          	sub    $0x38,%rsp
  800cf9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800cfd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800d01:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800d05:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800d08:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800d0c:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d10:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800d13:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800d17:	77 3b                	ja     800d54 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d19:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800d1c:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800d20:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800d23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800d27:	ba 00 00 00 00       	mov    $0x0,%edx
  800d2c:	48 f7 f3             	div    %rbx
  800d2f:	48 89 c2             	mov    %rax,%rdx
  800d32:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800d35:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800d38:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800d3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d40:	41 89 f9             	mov    %edi,%r9d
  800d43:	48 89 c7             	mov    %rax,%rdi
  800d46:	48 b8 f0 0c 80 00 00 	movabs $0x800cf0,%rax
  800d4d:	00 00 00 
  800d50:	ff d0                	callq  *%rax
  800d52:	eb 1e                	jmp    800d72 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d54:	eb 12                	jmp    800d68 <printnum+0x78>
			putch(padc, putdat);
  800d56:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800d5a:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800d5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d61:	48 89 ce             	mov    %rcx,%rsi
  800d64:	89 d7                	mov    %edx,%edi
  800d66:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d68:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800d6c:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800d70:	7f e4                	jg     800d56 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d72:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800d75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800d79:	ba 00 00 00 00       	mov    $0x0,%edx
  800d7e:	48 f7 f1             	div    %rcx
  800d81:	48 89 d0             	mov    %rdx,%rax
  800d84:	48 ba f0 55 80 00 00 	movabs $0x8055f0,%rdx
  800d8b:	00 00 00 
  800d8e:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800d92:	0f be d0             	movsbl %al,%edx
  800d95:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800d99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d9d:	48 89 ce             	mov    %rcx,%rsi
  800da0:	89 d7                	mov    %edx,%edi
  800da2:	ff d0                	callq  *%rax
}
  800da4:	48 83 c4 38          	add    $0x38,%rsp
  800da8:	5b                   	pop    %rbx
  800da9:	5d                   	pop    %rbp
  800daa:	c3                   	retq   

0000000000800dab <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800dab:	55                   	push   %rbp
  800dac:	48 89 e5             	mov    %rsp,%rbp
  800daf:	48 83 ec 1c          	sub    $0x1c,%rsp
  800db3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800db7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800dba:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800dbe:	7e 52                	jle    800e12 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800dc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc4:	8b 00                	mov    (%rax),%eax
  800dc6:	83 f8 30             	cmp    $0x30,%eax
  800dc9:	73 24                	jae    800def <getuint+0x44>
  800dcb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dcf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800dd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd7:	8b 00                	mov    (%rax),%eax
  800dd9:	89 c0                	mov    %eax,%eax
  800ddb:	48 01 d0             	add    %rdx,%rax
  800dde:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800de2:	8b 12                	mov    (%rdx),%edx
  800de4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800de7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800deb:	89 0a                	mov    %ecx,(%rdx)
  800ded:	eb 17                	jmp    800e06 <getuint+0x5b>
  800def:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800df7:	48 89 d0             	mov    %rdx,%rax
  800dfa:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800dfe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e02:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e06:	48 8b 00             	mov    (%rax),%rax
  800e09:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e0d:	e9 a3 00 00 00       	jmpq   800eb5 <getuint+0x10a>
	else if (lflag)
  800e12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800e16:	74 4f                	je     800e67 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800e18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e1c:	8b 00                	mov    (%rax),%eax
  800e1e:	83 f8 30             	cmp    $0x30,%eax
  800e21:	73 24                	jae    800e47 <getuint+0x9c>
  800e23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e27:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e2f:	8b 00                	mov    (%rax),%eax
  800e31:	89 c0                	mov    %eax,%eax
  800e33:	48 01 d0             	add    %rdx,%rax
  800e36:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e3a:	8b 12                	mov    (%rdx),%edx
  800e3c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e3f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e43:	89 0a                	mov    %ecx,(%rdx)
  800e45:	eb 17                	jmp    800e5e <getuint+0xb3>
  800e47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e4b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e4f:	48 89 d0             	mov    %rdx,%rax
  800e52:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e56:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e5a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e5e:	48 8b 00             	mov    (%rax),%rax
  800e61:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e65:	eb 4e                	jmp    800eb5 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800e67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e6b:	8b 00                	mov    (%rax),%eax
  800e6d:	83 f8 30             	cmp    $0x30,%eax
  800e70:	73 24                	jae    800e96 <getuint+0xeb>
  800e72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e76:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e7e:	8b 00                	mov    (%rax),%eax
  800e80:	89 c0                	mov    %eax,%eax
  800e82:	48 01 d0             	add    %rdx,%rax
  800e85:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e89:	8b 12                	mov    (%rdx),%edx
  800e8b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e8e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e92:	89 0a                	mov    %ecx,(%rdx)
  800e94:	eb 17                	jmp    800ead <getuint+0x102>
  800e96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e9e:	48 89 d0             	mov    %rdx,%rax
  800ea1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ea5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ea9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ead:	8b 00                	mov    (%rax),%eax
  800eaf:	89 c0                	mov    %eax,%eax
  800eb1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800eb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800eb9:	c9                   	leaveq 
  800eba:	c3                   	retq   

0000000000800ebb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ebb:	55                   	push   %rbp
  800ebc:	48 89 e5             	mov    %rsp,%rbp
  800ebf:	48 83 ec 1c          	sub    $0x1c,%rsp
  800ec3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ec7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800eca:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ece:	7e 52                	jle    800f22 <getint+0x67>
		x=va_arg(*ap, long long);
  800ed0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed4:	8b 00                	mov    (%rax),%eax
  800ed6:	83 f8 30             	cmp    $0x30,%eax
  800ed9:	73 24                	jae    800eff <getint+0x44>
  800edb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800edf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ee3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee7:	8b 00                	mov    (%rax),%eax
  800ee9:	89 c0                	mov    %eax,%eax
  800eeb:	48 01 d0             	add    %rdx,%rax
  800eee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ef2:	8b 12                	mov    (%rdx),%edx
  800ef4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ef7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800efb:	89 0a                	mov    %ecx,(%rdx)
  800efd:	eb 17                	jmp    800f16 <getint+0x5b>
  800eff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f03:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f07:	48 89 d0             	mov    %rdx,%rax
  800f0a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f0e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f12:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f16:	48 8b 00             	mov    (%rax),%rax
  800f19:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f1d:	e9 a3 00 00 00       	jmpq   800fc5 <getint+0x10a>
	else if (lflag)
  800f22:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800f26:	74 4f                	je     800f77 <getint+0xbc>
		x=va_arg(*ap, long);
  800f28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f2c:	8b 00                	mov    (%rax),%eax
  800f2e:	83 f8 30             	cmp    $0x30,%eax
  800f31:	73 24                	jae    800f57 <getint+0x9c>
  800f33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f37:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3f:	8b 00                	mov    (%rax),%eax
  800f41:	89 c0                	mov    %eax,%eax
  800f43:	48 01 d0             	add    %rdx,%rax
  800f46:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f4a:	8b 12                	mov    (%rdx),%edx
  800f4c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f4f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f53:	89 0a                	mov    %ecx,(%rdx)
  800f55:	eb 17                	jmp    800f6e <getint+0xb3>
  800f57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f5f:	48 89 d0             	mov    %rdx,%rax
  800f62:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f66:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f6a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f6e:	48 8b 00             	mov    (%rax),%rax
  800f71:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f75:	eb 4e                	jmp    800fc5 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800f77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7b:	8b 00                	mov    (%rax),%eax
  800f7d:	83 f8 30             	cmp    $0x30,%eax
  800f80:	73 24                	jae    800fa6 <getint+0xeb>
  800f82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f86:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f8e:	8b 00                	mov    (%rax),%eax
  800f90:	89 c0                	mov    %eax,%eax
  800f92:	48 01 d0             	add    %rdx,%rax
  800f95:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f99:	8b 12                	mov    (%rdx),%edx
  800f9b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f9e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fa2:	89 0a                	mov    %ecx,(%rdx)
  800fa4:	eb 17                	jmp    800fbd <getint+0x102>
  800fa6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800faa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800fae:	48 89 d0             	mov    %rdx,%rax
  800fb1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800fb5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fb9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800fbd:	8b 00                	mov    (%rax),%eax
  800fbf:	48 98                	cltq   
  800fc1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800fc5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fc9:	c9                   	leaveq 
  800fca:	c3                   	retq   

0000000000800fcb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800fcb:	55                   	push   %rbp
  800fcc:	48 89 e5             	mov    %rsp,%rbp
  800fcf:	41 54                	push   %r12
  800fd1:	53                   	push   %rbx
  800fd2:	48 83 ec 60          	sub    $0x60,%rsp
  800fd6:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800fda:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800fde:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800fe2:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800fe6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fea:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800fee:	48 8b 0a             	mov    (%rdx),%rcx
  800ff1:	48 89 08             	mov    %rcx,(%rax)
  800ff4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ff8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ffc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801000:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801004:	eb 17                	jmp    80101d <vprintfmt+0x52>
			if (ch == '\0')
  801006:	85 db                	test   %ebx,%ebx
  801008:	0f 84 cc 04 00 00    	je     8014da <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80100e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801012:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801016:	48 89 d6             	mov    %rdx,%rsi
  801019:	89 df                	mov    %ebx,%edi
  80101b:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80101d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801021:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801025:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801029:	0f b6 00             	movzbl (%rax),%eax
  80102c:	0f b6 d8             	movzbl %al,%ebx
  80102f:	83 fb 25             	cmp    $0x25,%ebx
  801032:	75 d2                	jne    801006 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801034:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801038:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80103f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801046:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80104d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801054:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801058:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80105c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801060:	0f b6 00             	movzbl (%rax),%eax
  801063:	0f b6 d8             	movzbl %al,%ebx
  801066:	8d 43 dd             	lea    -0x23(%rbx),%eax
  801069:	83 f8 55             	cmp    $0x55,%eax
  80106c:	0f 87 34 04 00 00    	ja     8014a6 <vprintfmt+0x4db>
  801072:	89 c0                	mov    %eax,%eax
  801074:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80107b:	00 
  80107c:	48 b8 18 56 80 00 00 	movabs $0x805618,%rax
  801083:	00 00 00 
  801086:	48 01 d0             	add    %rdx,%rax
  801089:	48 8b 00             	mov    (%rax),%rax
  80108c:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80108e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  801092:	eb c0                	jmp    801054 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801094:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  801098:	eb ba                	jmp    801054 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80109a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8010a1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8010a4:	89 d0                	mov    %edx,%eax
  8010a6:	c1 e0 02             	shl    $0x2,%eax
  8010a9:	01 d0                	add    %edx,%eax
  8010ab:	01 c0                	add    %eax,%eax
  8010ad:	01 d8                	add    %ebx,%eax
  8010af:	83 e8 30             	sub    $0x30,%eax
  8010b2:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8010b5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8010b9:	0f b6 00             	movzbl (%rax),%eax
  8010bc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8010bf:	83 fb 2f             	cmp    $0x2f,%ebx
  8010c2:	7e 0c                	jle    8010d0 <vprintfmt+0x105>
  8010c4:	83 fb 39             	cmp    $0x39,%ebx
  8010c7:	7f 07                	jg     8010d0 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8010c9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8010ce:	eb d1                	jmp    8010a1 <vprintfmt+0xd6>
			goto process_precision;
  8010d0:	eb 58                	jmp    80112a <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8010d2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010d5:	83 f8 30             	cmp    $0x30,%eax
  8010d8:	73 17                	jae    8010f1 <vprintfmt+0x126>
  8010da:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8010de:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010e1:	89 c0                	mov    %eax,%eax
  8010e3:	48 01 d0             	add    %rdx,%rax
  8010e6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8010e9:	83 c2 08             	add    $0x8,%edx
  8010ec:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8010ef:	eb 0f                	jmp    801100 <vprintfmt+0x135>
  8010f1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8010f5:	48 89 d0             	mov    %rdx,%rax
  8010f8:	48 83 c2 08          	add    $0x8,%rdx
  8010fc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801100:	8b 00                	mov    (%rax),%eax
  801102:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801105:	eb 23                	jmp    80112a <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  801107:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80110b:	79 0c                	jns    801119 <vprintfmt+0x14e>
				width = 0;
  80110d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801114:	e9 3b ff ff ff       	jmpq   801054 <vprintfmt+0x89>
  801119:	e9 36 ff ff ff       	jmpq   801054 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80111e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801125:	e9 2a ff ff ff       	jmpq   801054 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80112a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80112e:	79 12                	jns    801142 <vprintfmt+0x177>
				width = precision, precision = -1;
  801130:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801133:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801136:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80113d:	e9 12 ff ff ff       	jmpq   801054 <vprintfmt+0x89>
  801142:	e9 0d ff ff ff       	jmpq   801054 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801147:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80114b:	e9 04 ff ff ff       	jmpq   801054 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801150:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801153:	83 f8 30             	cmp    $0x30,%eax
  801156:	73 17                	jae    80116f <vprintfmt+0x1a4>
  801158:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80115c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80115f:	89 c0                	mov    %eax,%eax
  801161:	48 01 d0             	add    %rdx,%rax
  801164:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801167:	83 c2 08             	add    $0x8,%edx
  80116a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80116d:	eb 0f                	jmp    80117e <vprintfmt+0x1b3>
  80116f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801173:	48 89 d0             	mov    %rdx,%rax
  801176:	48 83 c2 08          	add    $0x8,%rdx
  80117a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80117e:	8b 10                	mov    (%rax),%edx
  801180:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801184:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801188:	48 89 ce             	mov    %rcx,%rsi
  80118b:	89 d7                	mov    %edx,%edi
  80118d:	ff d0                	callq  *%rax
			break;
  80118f:	e9 40 03 00 00       	jmpq   8014d4 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  801194:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801197:	83 f8 30             	cmp    $0x30,%eax
  80119a:	73 17                	jae    8011b3 <vprintfmt+0x1e8>
  80119c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8011a0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011a3:	89 c0                	mov    %eax,%eax
  8011a5:	48 01 d0             	add    %rdx,%rax
  8011a8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8011ab:	83 c2 08             	add    $0x8,%edx
  8011ae:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8011b1:	eb 0f                	jmp    8011c2 <vprintfmt+0x1f7>
  8011b3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8011b7:	48 89 d0             	mov    %rdx,%rax
  8011ba:	48 83 c2 08          	add    $0x8,%rdx
  8011be:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8011c2:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8011c4:	85 db                	test   %ebx,%ebx
  8011c6:	79 02                	jns    8011ca <vprintfmt+0x1ff>
				err = -err;
  8011c8:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8011ca:	83 fb 15             	cmp    $0x15,%ebx
  8011cd:	7f 16                	jg     8011e5 <vprintfmt+0x21a>
  8011cf:	48 b8 40 55 80 00 00 	movabs $0x805540,%rax
  8011d6:	00 00 00 
  8011d9:	48 63 d3             	movslq %ebx,%rdx
  8011dc:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8011e0:	4d 85 e4             	test   %r12,%r12
  8011e3:	75 2e                	jne    801213 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8011e5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8011e9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011ed:	89 d9                	mov    %ebx,%ecx
  8011ef:	48 ba 01 56 80 00 00 	movabs $0x805601,%rdx
  8011f6:	00 00 00 
  8011f9:	48 89 c7             	mov    %rax,%rdi
  8011fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801201:	49 b8 e3 14 80 00 00 	movabs $0x8014e3,%r8
  801208:	00 00 00 
  80120b:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80120e:	e9 c1 02 00 00       	jmpq   8014d4 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801213:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801217:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80121b:	4c 89 e1             	mov    %r12,%rcx
  80121e:	48 ba 0a 56 80 00 00 	movabs $0x80560a,%rdx
  801225:	00 00 00 
  801228:	48 89 c7             	mov    %rax,%rdi
  80122b:	b8 00 00 00 00       	mov    $0x0,%eax
  801230:	49 b8 e3 14 80 00 00 	movabs $0x8014e3,%r8
  801237:	00 00 00 
  80123a:	41 ff d0             	callq  *%r8
			break;
  80123d:	e9 92 02 00 00       	jmpq   8014d4 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801242:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801245:	83 f8 30             	cmp    $0x30,%eax
  801248:	73 17                	jae    801261 <vprintfmt+0x296>
  80124a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80124e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801251:	89 c0                	mov    %eax,%eax
  801253:	48 01 d0             	add    %rdx,%rax
  801256:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801259:	83 c2 08             	add    $0x8,%edx
  80125c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80125f:	eb 0f                	jmp    801270 <vprintfmt+0x2a5>
  801261:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801265:	48 89 d0             	mov    %rdx,%rax
  801268:	48 83 c2 08          	add    $0x8,%rdx
  80126c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801270:	4c 8b 20             	mov    (%rax),%r12
  801273:	4d 85 e4             	test   %r12,%r12
  801276:	75 0a                	jne    801282 <vprintfmt+0x2b7>
				p = "(null)";
  801278:	49 bc 0d 56 80 00 00 	movabs $0x80560d,%r12
  80127f:	00 00 00 
			if (width > 0 && padc != '-')
  801282:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801286:	7e 3f                	jle    8012c7 <vprintfmt+0x2fc>
  801288:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80128c:	74 39                	je     8012c7 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80128e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801291:	48 98                	cltq   
  801293:	48 89 c6             	mov    %rax,%rsi
  801296:	4c 89 e7             	mov    %r12,%rdi
  801299:	48 b8 8f 17 80 00 00 	movabs $0x80178f,%rax
  8012a0:	00 00 00 
  8012a3:	ff d0                	callq  *%rax
  8012a5:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8012a8:	eb 17                	jmp    8012c1 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8012aa:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8012ae:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8012b2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012b6:	48 89 ce             	mov    %rcx,%rsi
  8012b9:	89 d7                	mov    %edx,%edi
  8012bb:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012bd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8012c1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8012c5:	7f e3                	jg     8012aa <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012c7:	eb 37                	jmp    801300 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8012c9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8012cd:	74 1e                	je     8012ed <vprintfmt+0x322>
  8012cf:	83 fb 1f             	cmp    $0x1f,%ebx
  8012d2:	7e 05                	jle    8012d9 <vprintfmt+0x30e>
  8012d4:	83 fb 7e             	cmp    $0x7e,%ebx
  8012d7:	7e 14                	jle    8012ed <vprintfmt+0x322>
					putch('?', putdat);
  8012d9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012dd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012e1:	48 89 d6             	mov    %rdx,%rsi
  8012e4:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8012e9:	ff d0                	callq  *%rax
  8012eb:	eb 0f                	jmp    8012fc <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8012ed:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012f1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012f5:	48 89 d6             	mov    %rdx,%rsi
  8012f8:	89 df                	mov    %ebx,%edi
  8012fa:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012fc:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801300:	4c 89 e0             	mov    %r12,%rax
  801303:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801307:	0f b6 00             	movzbl (%rax),%eax
  80130a:	0f be d8             	movsbl %al,%ebx
  80130d:	85 db                	test   %ebx,%ebx
  80130f:	74 10                	je     801321 <vprintfmt+0x356>
  801311:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801315:	78 b2                	js     8012c9 <vprintfmt+0x2fe>
  801317:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80131b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80131f:	79 a8                	jns    8012c9 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801321:	eb 16                	jmp    801339 <vprintfmt+0x36e>
				putch(' ', putdat);
  801323:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801327:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80132b:	48 89 d6             	mov    %rdx,%rsi
  80132e:	bf 20 00 00 00       	mov    $0x20,%edi
  801333:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801335:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801339:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80133d:	7f e4                	jg     801323 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80133f:	e9 90 01 00 00       	jmpq   8014d4 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801344:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801348:	be 03 00 00 00       	mov    $0x3,%esi
  80134d:	48 89 c7             	mov    %rax,%rdi
  801350:	48 b8 bb 0e 80 00 00 	movabs $0x800ebb,%rax
  801357:	00 00 00 
  80135a:	ff d0                	callq  *%rax
  80135c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801360:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801364:	48 85 c0             	test   %rax,%rax
  801367:	79 1d                	jns    801386 <vprintfmt+0x3bb>
				putch('-', putdat);
  801369:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80136d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801371:	48 89 d6             	mov    %rdx,%rsi
  801374:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801379:	ff d0                	callq  *%rax
				num = -(long long) num;
  80137b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80137f:	48 f7 d8             	neg    %rax
  801382:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801386:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80138d:	e9 d5 00 00 00       	jmpq   801467 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801392:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801396:	be 03 00 00 00       	mov    $0x3,%esi
  80139b:	48 89 c7             	mov    %rax,%rdi
  80139e:	48 b8 ab 0d 80 00 00 	movabs $0x800dab,%rax
  8013a5:	00 00 00 
  8013a8:	ff d0                	callq  *%rax
  8013aa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8013ae:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8013b5:	e9 ad 00 00 00       	jmpq   801467 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  8013ba:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8013bd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8013c1:	89 d6                	mov    %edx,%esi
  8013c3:	48 89 c7             	mov    %rax,%rdi
  8013c6:	48 b8 bb 0e 80 00 00 	movabs $0x800ebb,%rax
  8013cd:	00 00 00 
  8013d0:	ff d0                	callq  *%rax
  8013d2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8013d6:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8013dd:	e9 85 00 00 00       	jmpq   801467 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  8013e2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013e6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013ea:	48 89 d6             	mov    %rdx,%rsi
  8013ed:	bf 30 00 00 00       	mov    $0x30,%edi
  8013f2:	ff d0                	callq  *%rax
			putch('x', putdat);
  8013f4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013f8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013fc:	48 89 d6             	mov    %rdx,%rsi
  8013ff:	bf 78 00 00 00       	mov    $0x78,%edi
  801404:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801406:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801409:	83 f8 30             	cmp    $0x30,%eax
  80140c:	73 17                	jae    801425 <vprintfmt+0x45a>
  80140e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801412:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801415:	89 c0                	mov    %eax,%eax
  801417:	48 01 d0             	add    %rdx,%rax
  80141a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80141d:	83 c2 08             	add    $0x8,%edx
  801420:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801423:	eb 0f                	jmp    801434 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  801425:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801429:	48 89 d0             	mov    %rdx,%rax
  80142c:	48 83 c2 08          	add    $0x8,%rdx
  801430:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801434:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801437:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80143b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801442:	eb 23                	jmp    801467 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801444:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801448:	be 03 00 00 00       	mov    $0x3,%esi
  80144d:	48 89 c7             	mov    %rax,%rdi
  801450:	48 b8 ab 0d 80 00 00 	movabs $0x800dab,%rax
  801457:	00 00 00 
  80145a:	ff d0                	callq  *%rax
  80145c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801460:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801467:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80146c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80146f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801472:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801476:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80147a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80147e:	45 89 c1             	mov    %r8d,%r9d
  801481:	41 89 f8             	mov    %edi,%r8d
  801484:	48 89 c7             	mov    %rax,%rdi
  801487:	48 b8 f0 0c 80 00 00 	movabs $0x800cf0,%rax
  80148e:	00 00 00 
  801491:	ff d0                	callq  *%rax
			break;
  801493:	eb 3f                	jmp    8014d4 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801495:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801499:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80149d:	48 89 d6             	mov    %rdx,%rsi
  8014a0:	89 df                	mov    %ebx,%edi
  8014a2:	ff d0                	callq  *%rax
			break;
  8014a4:	eb 2e                	jmp    8014d4 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014a6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014aa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014ae:	48 89 d6             	mov    %rdx,%rsi
  8014b1:	bf 25 00 00 00       	mov    $0x25,%edi
  8014b6:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014b8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8014bd:	eb 05                	jmp    8014c4 <vprintfmt+0x4f9>
  8014bf:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8014c4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8014c8:	48 83 e8 01          	sub    $0x1,%rax
  8014cc:	0f b6 00             	movzbl (%rax),%eax
  8014cf:	3c 25                	cmp    $0x25,%al
  8014d1:	75 ec                	jne    8014bf <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8014d3:	90                   	nop
		}
	}
  8014d4:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8014d5:	e9 43 fb ff ff       	jmpq   80101d <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8014da:	48 83 c4 60          	add    $0x60,%rsp
  8014de:	5b                   	pop    %rbx
  8014df:	41 5c                	pop    %r12
  8014e1:	5d                   	pop    %rbp
  8014e2:	c3                   	retq   

00000000008014e3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8014e3:	55                   	push   %rbp
  8014e4:	48 89 e5             	mov    %rsp,%rbp
  8014e7:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8014ee:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8014f5:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8014fc:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801503:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80150a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801511:	84 c0                	test   %al,%al
  801513:	74 20                	je     801535 <printfmt+0x52>
  801515:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801519:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80151d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801521:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801525:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801529:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80152d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801531:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801535:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80153c:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801543:	00 00 00 
  801546:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80154d:	00 00 00 
  801550:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801554:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80155b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801562:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801569:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801570:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801577:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80157e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801585:	48 89 c7             	mov    %rax,%rdi
  801588:	48 b8 cb 0f 80 00 00 	movabs $0x800fcb,%rax
  80158f:	00 00 00 
  801592:	ff d0                	callq  *%rax
	va_end(ap);
}
  801594:	c9                   	leaveq 
  801595:	c3                   	retq   

0000000000801596 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801596:	55                   	push   %rbp
  801597:	48 89 e5             	mov    %rsp,%rbp
  80159a:	48 83 ec 10          	sub    $0x10,%rsp
  80159e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8015a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8015a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a9:	8b 40 10             	mov    0x10(%rax),%eax
  8015ac:	8d 50 01             	lea    0x1(%rax),%edx
  8015af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b3:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8015b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ba:	48 8b 10             	mov    (%rax),%rdx
  8015bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015c1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8015c5:	48 39 c2             	cmp    %rax,%rdx
  8015c8:	73 17                	jae    8015e1 <sprintputch+0x4b>
		*b->buf++ = ch;
  8015ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ce:	48 8b 00             	mov    (%rax),%rax
  8015d1:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8015d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015d9:	48 89 0a             	mov    %rcx,(%rdx)
  8015dc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8015df:	88 10                	mov    %dl,(%rax)
}
  8015e1:	c9                   	leaveq 
  8015e2:	c3                   	retq   

00000000008015e3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8015e3:	55                   	push   %rbp
  8015e4:	48 89 e5             	mov    %rsp,%rbp
  8015e7:	48 83 ec 50          	sub    $0x50,%rsp
  8015eb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8015ef:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8015f2:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8015f6:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8015fa:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8015fe:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801602:	48 8b 0a             	mov    (%rdx),%rcx
  801605:	48 89 08             	mov    %rcx,(%rax)
  801608:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80160c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801610:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801614:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801618:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80161c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801620:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801623:	48 98                	cltq   
  801625:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801629:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80162d:	48 01 d0             	add    %rdx,%rax
  801630:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801634:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80163b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801640:	74 06                	je     801648 <vsnprintf+0x65>
  801642:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801646:	7f 07                	jg     80164f <vsnprintf+0x6c>
		return -E_INVAL;
  801648:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80164d:	eb 2f                	jmp    80167e <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80164f:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801653:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801657:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80165b:	48 89 c6             	mov    %rax,%rsi
  80165e:	48 bf 96 15 80 00 00 	movabs $0x801596,%rdi
  801665:	00 00 00 
  801668:	48 b8 cb 0f 80 00 00 	movabs $0x800fcb,%rax
  80166f:	00 00 00 
  801672:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801674:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801678:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80167b:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80167e:	c9                   	leaveq 
  80167f:	c3                   	retq   

0000000000801680 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801680:	55                   	push   %rbp
  801681:	48 89 e5             	mov    %rsp,%rbp
  801684:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80168b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801692:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801698:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80169f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8016a6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8016ad:	84 c0                	test   %al,%al
  8016af:	74 20                	je     8016d1 <snprintf+0x51>
  8016b1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8016b5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8016b9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8016bd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8016c1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8016c5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8016c9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8016cd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8016d1:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8016d8:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8016df:	00 00 00 
  8016e2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8016e9:	00 00 00 
  8016ec:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8016f0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8016f7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8016fe:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801705:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80170c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801713:	48 8b 0a             	mov    (%rdx),%rcx
  801716:	48 89 08             	mov    %rcx,(%rax)
  801719:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80171d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801721:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801725:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801729:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801730:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801737:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80173d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801744:	48 89 c7             	mov    %rax,%rdi
  801747:	48 b8 e3 15 80 00 00 	movabs $0x8015e3,%rax
  80174e:	00 00 00 
  801751:	ff d0                	callq  *%rax
  801753:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801759:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80175f:	c9                   	leaveq 
  801760:	c3                   	retq   

0000000000801761 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801761:	55                   	push   %rbp
  801762:	48 89 e5             	mov    %rsp,%rbp
  801765:	48 83 ec 18          	sub    $0x18,%rsp
  801769:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80176d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801774:	eb 09                	jmp    80177f <strlen+0x1e>
		n++;
  801776:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80177a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80177f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801783:	0f b6 00             	movzbl (%rax),%eax
  801786:	84 c0                	test   %al,%al
  801788:	75 ec                	jne    801776 <strlen+0x15>
		n++;
	return n;
  80178a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80178d:	c9                   	leaveq 
  80178e:	c3                   	retq   

000000000080178f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80178f:	55                   	push   %rbp
  801790:	48 89 e5             	mov    %rsp,%rbp
  801793:	48 83 ec 20          	sub    $0x20,%rsp
  801797:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80179b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80179f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8017a6:	eb 0e                	jmp    8017b6 <strnlen+0x27>
		n++;
  8017a8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8017ac:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8017b1:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8017b6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8017bb:	74 0b                	je     8017c8 <strnlen+0x39>
  8017bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017c1:	0f b6 00             	movzbl (%rax),%eax
  8017c4:	84 c0                	test   %al,%al
  8017c6:	75 e0                	jne    8017a8 <strnlen+0x19>
		n++;
	return n;
  8017c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8017cb:	c9                   	leaveq 
  8017cc:	c3                   	retq   

00000000008017cd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8017cd:	55                   	push   %rbp
  8017ce:	48 89 e5             	mov    %rsp,%rbp
  8017d1:	48 83 ec 20          	sub    $0x20,%rsp
  8017d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8017dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8017e5:	90                   	nop
  8017e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017ea:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017ee:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8017f2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8017f6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8017fa:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8017fe:	0f b6 12             	movzbl (%rdx),%edx
  801801:	88 10                	mov    %dl,(%rax)
  801803:	0f b6 00             	movzbl (%rax),%eax
  801806:	84 c0                	test   %al,%al
  801808:	75 dc                	jne    8017e6 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80180a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80180e:	c9                   	leaveq 
  80180f:	c3                   	retq   

0000000000801810 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801810:	55                   	push   %rbp
  801811:	48 89 e5             	mov    %rsp,%rbp
  801814:	48 83 ec 20          	sub    $0x20,%rsp
  801818:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80181c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801820:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801824:	48 89 c7             	mov    %rax,%rdi
  801827:	48 b8 61 17 80 00 00 	movabs $0x801761,%rax
  80182e:	00 00 00 
  801831:	ff d0                	callq  *%rax
  801833:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801836:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801839:	48 63 d0             	movslq %eax,%rdx
  80183c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801840:	48 01 c2             	add    %rax,%rdx
  801843:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801847:	48 89 c6             	mov    %rax,%rsi
  80184a:	48 89 d7             	mov    %rdx,%rdi
  80184d:	48 b8 cd 17 80 00 00 	movabs $0x8017cd,%rax
  801854:	00 00 00 
  801857:	ff d0                	callq  *%rax
	return dst;
  801859:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80185d:	c9                   	leaveq 
  80185e:	c3                   	retq   

000000000080185f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80185f:	55                   	push   %rbp
  801860:	48 89 e5             	mov    %rsp,%rbp
  801863:	48 83 ec 28          	sub    $0x28,%rsp
  801867:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80186b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80186f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801873:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801877:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80187b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801882:	00 
  801883:	eb 2a                	jmp    8018af <strncpy+0x50>
		*dst++ = *src;
  801885:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801889:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80188d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801891:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801895:	0f b6 12             	movzbl (%rdx),%edx
  801898:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80189a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80189e:	0f b6 00             	movzbl (%rax),%eax
  8018a1:	84 c0                	test   %al,%al
  8018a3:	74 05                	je     8018aa <strncpy+0x4b>
			src++;
  8018a5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8018aa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018b3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8018b7:	72 cc                	jb     801885 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8018b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018bd:	c9                   	leaveq 
  8018be:	c3                   	retq   

00000000008018bf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8018bf:	55                   	push   %rbp
  8018c0:	48 89 e5             	mov    %rsp,%rbp
  8018c3:	48 83 ec 28          	sub    $0x28,%rsp
  8018c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018cb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8018cf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8018d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8018db:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8018e0:	74 3d                	je     80191f <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8018e2:	eb 1d                	jmp    801901 <strlcpy+0x42>
			*dst++ = *src++;
  8018e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018e8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018ec:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8018f0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8018f4:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8018f8:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8018fc:	0f b6 12             	movzbl (%rdx),%edx
  8018ff:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801901:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801906:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80190b:	74 0b                	je     801918 <strlcpy+0x59>
  80190d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801911:	0f b6 00             	movzbl (%rax),%eax
  801914:	84 c0                	test   %al,%al
  801916:	75 cc                	jne    8018e4 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801918:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80191c:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80191f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801923:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801927:	48 29 c2             	sub    %rax,%rdx
  80192a:	48 89 d0             	mov    %rdx,%rax
}
  80192d:	c9                   	leaveq 
  80192e:	c3                   	retq   

000000000080192f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80192f:	55                   	push   %rbp
  801930:	48 89 e5             	mov    %rsp,%rbp
  801933:	48 83 ec 10          	sub    $0x10,%rsp
  801937:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80193b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80193f:	eb 0a                	jmp    80194b <strcmp+0x1c>
		p++, q++;
  801941:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801946:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80194b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80194f:	0f b6 00             	movzbl (%rax),%eax
  801952:	84 c0                	test   %al,%al
  801954:	74 12                	je     801968 <strcmp+0x39>
  801956:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80195a:	0f b6 10             	movzbl (%rax),%edx
  80195d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801961:	0f b6 00             	movzbl (%rax),%eax
  801964:	38 c2                	cmp    %al,%dl
  801966:	74 d9                	je     801941 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801968:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80196c:	0f b6 00             	movzbl (%rax),%eax
  80196f:	0f b6 d0             	movzbl %al,%edx
  801972:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801976:	0f b6 00             	movzbl (%rax),%eax
  801979:	0f b6 c0             	movzbl %al,%eax
  80197c:	29 c2                	sub    %eax,%edx
  80197e:	89 d0                	mov    %edx,%eax
}
  801980:	c9                   	leaveq 
  801981:	c3                   	retq   

0000000000801982 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801982:	55                   	push   %rbp
  801983:	48 89 e5             	mov    %rsp,%rbp
  801986:	48 83 ec 18          	sub    $0x18,%rsp
  80198a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80198e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801992:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801996:	eb 0f                	jmp    8019a7 <strncmp+0x25>
		n--, p++, q++;
  801998:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80199d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019a2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8019a7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019ac:	74 1d                	je     8019cb <strncmp+0x49>
  8019ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019b2:	0f b6 00             	movzbl (%rax),%eax
  8019b5:	84 c0                	test   %al,%al
  8019b7:	74 12                	je     8019cb <strncmp+0x49>
  8019b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019bd:	0f b6 10             	movzbl (%rax),%edx
  8019c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019c4:	0f b6 00             	movzbl (%rax),%eax
  8019c7:	38 c2                	cmp    %al,%dl
  8019c9:	74 cd                	je     801998 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8019cb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019d0:	75 07                	jne    8019d9 <strncmp+0x57>
		return 0;
  8019d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d7:	eb 18                	jmp    8019f1 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8019d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019dd:	0f b6 00             	movzbl (%rax),%eax
  8019e0:	0f b6 d0             	movzbl %al,%edx
  8019e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019e7:	0f b6 00             	movzbl (%rax),%eax
  8019ea:	0f b6 c0             	movzbl %al,%eax
  8019ed:	29 c2                	sub    %eax,%edx
  8019ef:	89 d0                	mov    %edx,%eax
}
  8019f1:	c9                   	leaveq 
  8019f2:	c3                   	retq   

00000000008019f3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8019f3:	55                   	push   %rbp
  8019f4:	48 89 e5             	mov    %rsp,%rbp
  8019f7:	48 83 ec 0c          	sub    $0xc,%rsp
  8019fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019ff:	89 f0                	mov    %esi,%eax
  801a01:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801a04:	eb 17                	jmp    801a1d <strchr+0x2a>
		if (*s == c)
  801a06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a0a:	0f b6 00             	movzbl (%rax),%eax
  801a0d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801a10:	75 06                	jne    801a18 <strchr+0x25>
			return (char *) s;
  801a12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a16:	eb 15                	jmp    801a2d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a18:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a21:	0f b6 00             	movzbl (%rax),%eax
  801a24:	84 c0                	test   %al,%al
  801a26:	75 de                	jne    801a06 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801a28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a2d:	c9                   	leaveq 
  801a2e:	c3                   	retq   

0000000000801a2f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a2f:	55                   	push   %rbp
  801a30:	48 89 e5             	mov    %rsp,%rbp
  801a33:	48 83 ec 0c          	sub    $0xc,%rsp
  801a37:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a3b:	89 f0                	mov    %esi,%eax
  801a3d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801a40:	eb 13                	jmp    801a55 <strfind+0x26>
		if (*s == c)
  801a42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a46:	0f b6 00             	movzbl (%rax),%eax
  801a49:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801a4c:	75 02                	jne    801a50 <strfind+0x21>
			break;
  801a4e:	eb 10                	jmp    801a60 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801a50:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a59:	0f b6 00             	movzbl (%rax),%eax
  801a5c:	84 c0                	test   %al,%al
  801a5e:	75 e2                	jne    801a42 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801a60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801a64:	c9                   	leaveq 
  801a65:	c3                   	retq   

0000000000801a66 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801a66:	55                   	push   %rbp
  801a67:	48 89 e5             	mov    %rsp,%rbp
  801a6a:	48 83 ec 18          	sub    $0x18,%rsp
  801a6e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a72:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801a75:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801a79:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a7e:	75 06                	jne    801a86 <memset+0x20>
		return v;
  801a80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a84:	eb 69                	jmp    801aef <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801a86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a8a:	83 e0 03             	and    $0x3,%eax
  801a8d:	48 85 c0             	test   %rax,%rax
  801a90:	75 48                	jne    801ada <memset+0x74>
  801a92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a96:	83 e0 03             	and    $0x3,%eax
  801a99:	48 85 c0             	test   %rax,%rax
  801a9c:	75 3c                	jne    801ada <memset+0x74>
		c &= 0xFF;
  801a9e:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801aa5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801aa8:	c1 e0 18             	shl    $0x18,%eax
  801aab:	89 c2                	mov    %eax,%edx
  801aad:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ab0:	c1 e0 10             	shl    $0x10,%eax
  801ab3:	09 c2                	or     %eax,%edx
  801ab5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ab8:	c1 e0 08             	shl    $0x8,%eax
  801abb:	09 d0                	or     %edx,%eax
  801abd:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801ac0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ac4:	48 c1 e8 02          	shr    $0x2,%rax
  801ac8:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801acb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801acf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ad2:	48 89 d7             	mov    %rdx,%rdi
  801ad5:	fc                   	cld    
  801ad6:	f3 ab                	rep stos %eax,%es:(%rdi)
  801ad8:	eb 11                	jmp    801aeb <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801ada:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ade:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ae1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ae5:	48 89 d7             	mov    %rdx,%rdi
  801ae8:	fc                   	cld    
  801ae9:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801aeb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801aef:	c9                   	leaveq 
  801af0:	c3                   	retq   

0000000000801af1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801af1:	55                   	push   %rbp
  801af2:	48 89 e5             	mov    %rsp,%rbp
  801af5:	48 83 ec 28          	sub    $0x28,%rsp
  801af9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801afd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b01:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801b05:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b09:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801b0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b11:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801b15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b19:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801b1d:	0f 83 88 00 00 00    	jae    801bab <memmove+0xba>
  801b23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b27:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b2b:	48 01 d0             	add    %rdx,%rax
  801b2e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801b32:	76 77                	jbe    801bab <memmove+0xba>
		s += n;
  801b34:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b38:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801b3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b40:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801b44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b48:	83 e0 03             	and    $0x3,%eax
  801b4b:	48 85 c0             	test   %rax,%rax
  801b4e:	75 3b                	jne    801b8b <memmove+0x9a>
  801b50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b54:	83 e0 03             	and    $0x3,%eax
  801b57:	48 85 c0             	test   %rax,%rax
  801b5a:	75 2f                	jne    801b8b <memmove+0x9a>
  801b5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b60:	83 e0 03             	and    $0x3,%eax
  801b63:	48 85 c0             	test   %rax,%rax
  801b66:	75 23                	jne    801b8b <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801b68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b6c:	48 83 e8 04          	sub    $0x4,%rax
  801b70:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b74:	48 83 ea 04          	sub    $0x4,%rdx
  801b78:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801b7c:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801b80:	48 89 c7             	mov    %rax,%rdi
  801b83:	48 89 d6             	mov    %rdx,%rsi
  801b86:	fd                   	std    
  801b87:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801b89:	eb 1d                	jmp    801ba8 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801b8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b8f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801b93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b97:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801b9b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b9f:	48 89 d7             	mov    %rdx,%rdi
  801ba2:	48 89 c1             	mov    %rax,%rcx
  801ba5:	fd                   	std    
  801ba6:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801ba8:	fc                   	cld    
  801ba9:	eb 57                	jmp    801c02 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801bab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801baf:	83 e0 03             	and    $0x3,%eax
  801bb2:	48 85 c0             	test   %rax,%rax
  801bb5:	75 36                	jne    801bed <memmove+0xfc>
  801bb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bbb:	83 e0 03             	and    $0x3,%eax
  801bbe:	48 85 c0             	test   %rax,%rax
  801bc1:	75 2a                	jne    801bed <memmove+0xfc>
  801bc3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bc7:	83 e0 03             	and    $0x3,%eax
  801bca:	48 85 c0             	test   %rax,%rax
  801bcd:	75 1e                	jne    801bed <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801bcf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bd3:	48 c1 e8 02          	shr    $0x2,%rax
  801bd7:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801bda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bde:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801be2:	48 89 c7             	mov    %rax,%rdi
  801be5:	48 89 d6             	mov    %rdx,%rsi
  801be8:	fc                   	cld    
  801be9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801beb:	eb 15                	jmp    801c02 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801bed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bf1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bf5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801bf9:	48 89 c7             	mov    %rax,%rdi
  801bfc:	48 89 d6             	mov    %rdx,%rsi
  801bff:	fc                   	cld    
  801c00:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801c02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c06:	c9                   	leaveq 
  801c07:	c3                   	retq   

0000000000801c08 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801c08:	55                   	push   %rbp
  801c09:	48 89 e5             	mov    %rsp,%rbp
  801c0c:	48 83 ec 18          	sub    $0x18,%rsp
  801c10:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c14:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c18:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801c1c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c20:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801c24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c28:	48 89 ce             	mov    %rcx,%rsi
  801c2b:	48 89 c7             	mov    %rax,%rdi
  801c2e:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  801c35:	00 00 00 
  801c38:	ff d0                	callq  *%rax
}
  801c3a:	c9                   	leaveq 
  801c3b:	c3                   	retq   

0000000000801c3c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801c3c:	55                   	push   %rbp
  801c3d:	48 89 e5             	mov    %rsp,%rbp
  801c40:	48 83 ec 28          	sub    $0x28,%rsp
  801c44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c48:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c4c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801c50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c54:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801c58:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c5c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801c60:	eb 36                	jmp    801c98 <memcmp+0x5c>
		if (*s1 != *s2)
  801c62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c66:	0f b6 10             	movzbl (%rax),%edx
  801c69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c6d:	0f b6 00             	movzbl (%rax),%eax
  801c70:	38 c2                	cmp    %al,%dl
  801c72:	74 1a                	je     801c8e <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801c74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c78:	0f b6 00             	movzbl (%rax),%eax
  801c7b:	0f b6 d0             	movzbl %al,%edx
  801c7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c82:	0f b6 00             	movzbl (%rax),%eax
  801c85:	0f b6 c0             	movzbl %al,%eax
  801c88:	29 c2                	sub    %eax,%edx
  801c8a:	89 d0                	mov    %edx,%eax
  801c8c:	eb 20                	jmp    801cae <memcmp+0x72>
		s1++, s2++;
  801c8e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c93:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801c98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c9c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801ca0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ca4:	48 85 c0             	test   %rax,%rax
  801ca7:	75 b9                	jne    801c62 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801ca9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cae:	c9                   	leaveq 
  801caf:	c3                   	retq   

0000000000801cb0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801cb0:	55                   	push   %rbp
  801cb1:	48 89 e5             	mov    %rsp,%rbp
  801cb4:	48 83 ec 28          	sub    $0x28,%rsp
  801cb8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801cbc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801cbf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801cc3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cc7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801ccb:	48 01 d0             	add    %rdx,%rax
  801cce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801cd2:	eb 15                	jmp    801ce9 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801cd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cd8:	0f b6 10             	movzbl (%rax),%edx
  801cdb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801cde:	38 c2                	cmp    %al,%dl
  801ce0:	75 02                	jne    801ce4 <memfind+0x34>
			break;
  801ce2:	eb 0f                	jmp    801cf3 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801ce4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801ce9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ced:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801cf1:	72 e1                	jb     801cd4 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801cf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801cf7:	c9                   	leaveq 
  801cf8:	c3                   	retq   

0000000000801cf9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801cf9:	55                   	push   %rbp
  801cfa:	48 89 e5             	mov    %rsp,%rbp
  801cfd:	48 83 ec 34          	sub    $0x34,%rsp
  801d01:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801d05:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801d09:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801d0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801d13:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801d1a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801d1b:	eb 05                	jmp    801d22 <strtol+0x29>
		s++;
  801d1d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801d22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d26:	0f b6 00             	movzbl (%rax),%eax
  801d29:	3c 20                	cmp    $0x20,%al
  801d2b:	74 f0                	je     801d1d <strtol+0x24>
  801d2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d31:	0f b6 00             	movzbl (%rax),%eax
  801d34:	3c 09                	cmp    $0x9,%al
  801d36:	74 e5                	je     801d1d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801d38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d3c:	0f b6 00             	movzbl (%rax),%eax
  801d3f:	3c 2b                	cmp    $0x2b,%al
  801d41:	75 07                	jne    801d4a <strtol+0x51>
		s++;
  801d43:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d48:	eb 17                	jmp    801d61 <strtol+0x68>
	else if (*s == '-')
  801d4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d4e:	0f b6 00             	movzbl (%rax),%eax
  801d51:	3c 2d                	cmp    $0x2d,%al
  801d53:	75 0c                	jne    801d61 <strtol+0x68>
		s++, neg = 1;
  801d55:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d5a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801d61:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801d65:	74 06                	je     801d6d <strtol+0x74>
  801d67:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801d6b:	75 28                	jne    801d95 <strtol+0x9c>
  801d6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d71:	0f b6 00             	movzbl (%rax),%eax
  801d74:	3c 30                	cmp    $0x30,%al
  801d76:	75 1d                	jne    801d95 <strtol+0x9c>
  801d78:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d7c:	48 83 c0 01          	add    $0x1,%rax
  801d80:	0f b6 00             	movzbl (%rax),%eax
  801d83:	3c 78                	cmp    $0x78,%al
  801d85:	75 0e                	jne    801d95 <strtol+0x9c>
		s += 2, base = 16;
  801d87:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801d8c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801d93:	eb 2c                	jmp    801dc1 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801d95:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801d99:	75 19                	jne    801db4 <strtol+0xbb>
  801d9b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d9f:	0f b6 00             	movzbl (%rax),%eax
  801da2:	3c 30                	cmp    $0x30,%al
  801da4:	75 0e                	jne    801db4 <strtol+0xbb>
		s++, base = 8;
  801da6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801dab:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801db2:	eb 0d                	jmp    801dc1 <strtol+0xc8>
	else if (base == 0)
  801db4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801db8:	75 07                	jne    801dc1 <strtol+0xc8>
		base = 10;
  801dba:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801dc1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dc5:	0f b6 00             	movzbl (%rax),%eax
  801dc8:	3c 2f                	cmp    $0x2f,%al
  801dca:	7e 1d                	jle    801de9 <strtol+0xf0>
  801dcc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dd0:	0f b6 00             	movzbl (%rax),%eax
  801dd3:	3c 39                	cmp    $0x39,%al
  801dd5:	7f 12                	jg     801de9 <strtol+0xf0>
			dig = *s - '0';
  801dd7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ddb:	0f b6 00             	movzbl (%rax),%eax
  801dde:	0f be c0             	movsbl %al,%eax
  801de1:	83 e8 30             	sub    $0x30,%eax
  801de4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801de7:	eb 4e                	jmp    801e37 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801de9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ded:	0f b6 00             	movzbl (%rax),%eax
  801df0:	3c 60                	cmp    $0x60,%al
  801df2:	7e 1d                	jle    801e11 <strtol+0x118>
  801df4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801df8:	0f b6 00             	movzbl (%rax),%eax
  801dfb:	3c 7a                	cmp    $0x7a,%al
  801dfd:	7f 12                	jg     801e11 <strtol+0x118>
			dig = *s - 'a' + 10;
  801dff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e03:	0f b6 00             	movzbl (%rax),%eax
  801e06:	0f be c0             	movsbl %al,%eax
  801e09:	83 e8 57             	sub    $0x57,%eax
  801e0c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801e0f:	eb 26                	jmp    801e37 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801e11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e15:	0f b6 00             	movzbl (%rax),%eax
  801e18:	3c 40                	cmp    $0x40,%al
  801e1a:	7e 48                	jle    801e64 <strtol+0x16b>
  801e1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e20:	0f b6 00             	movzbl (%rax),%eax
  801e23:	3c 5a                	cmp    $0x5a,%al
  801e25:	7f 3d                	jg     801e64 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801e27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e2b:	0f b6 00             	movzbl (%rax),%eax
  801e2e:	0f be c0             	movsbl %al,%eax
  801e31:	83 e8 37             	sub    $0x37,%eax
  801e34:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801e37:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e3a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801e3d:	7c 02                	jl     801e41 <strtol+0x148>
			break;
  801e3f:	eb 23                	jmp    801e64 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801e41:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e46:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801e49:	48 98                	cltq   
  801e4b:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801e50:	48 89 c2             	mov    %rax,%rdx
  801e53:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e56:	48 98                	cltq   
  801e58:	48 01 d0             	add    %rdx,%rax
  801e5b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801e5f:	e9 5d ff ff ff       	jmpq   801dc1 <strtol+0xc8>

	if (endptr)
  801e64:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801e69:	74 0b                	je     801e76 <strtol+0x17d>
		*endptr = (char *) s;
  801e6b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e6f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801e73:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801e76:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e7a:	74 09                	je     801e85 <strtol+0x18c>
  801e7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e80:	48 f7 d8             	neg    %rax
  801e83:	eb 04                	jmp    801e89 <strtol+0x190>
  801e85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801e89:	c9                   	leaveq 
  801e8a:	c3                   	retq   

0000000000801e8b <strstr>:

char * strstr(const char *in, const char *str)
{
  801e8b:	55                   	push   %rbp
  801e8c:	48 89 e5             	mov    %rsp,%rbp
  801e8f:	48 83 ec 30          	sub    $0x30,%rsp
  801e93:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e97:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801e9b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e9f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ea3:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801ea7:	0f b6 00             	movzbl (%rax),%eax
  801eaa:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801ead:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801eb1:	75 06                	jne    801eb9 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801eb3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eb7:	eb 6b                	jmp    801f24 <strstr+0x99>

	len = strlen(str);
  801eb9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ebd:	48 89 c7             	mov    %rax,%rdi
  801ec0:	48 b8 61 17 80 00 00 	movabs $0x801761,%rax
  801ec7:	00 00 00 
  801eca:	ff d0                	callq  *%rax
  801ecc:	48 98                	cltq   
  801ece:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801ed2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801eda:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ede:	0f b6 00             	movzbl (%rax),%eax
  801ee1:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801ee4:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801ee8:	75 07                	jne    801ef1 <strstr+0x66>
				return (char *) 0;
  801eea:	b8 00 00 00 00       	mov    $0x0,%eax
  801eef:	eb 33                	jmp    801f24 <strstr+0x99>
		} while (sc != c);
  801ef1:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801ef5:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801ef8:	75 d8                	jne    801ed2 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801efa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801efe:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801f02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f06:	48 89 ce             	mov    %rcx,%rsi
  801f09:	48 89 c7             	mov    %rax,%rdi
  801f0c:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801f13:	00 00 00 
  801f16:	ff d0                	callq  *%rax
  801f18:	85 c0                	test   %eax,%eax
  801f1a:	75 b6                	jne    801ed2 <strstr+0x47>

	return (char *) (in - 1);
  801f1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f20:	48 83 e8 01          	sub    $0x1,%rax
}
  801f24:	c9                   	leaveq 
  801f25:	c3                   	retq   

0000000000801f26 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801f26:	55                   	push   %rbp
  801f27:	48 89 e5             	mov    %rsp,%rbp
  801f2a:	53                   	push   %rbx
  801f2b:	48 83 ec 48          	sub    $0x48,%rsp
  801f2f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801f32:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801f35:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801f39:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801f3d:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801f41:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f45:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801f48:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801f4c:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801f50:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801f54:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801f58:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801f5c:	4c 89 c3             	mov    %r8,%rbx
  801f5f:	cd 30                	int    $0x30
  801f61:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801f65:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801f69:	74 3e                	je     801fa9 <syscall+0x83>
  801f6b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801f70:	7e 37                	jle    801fa9 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801f72:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f76:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801f79:	49 89 d0             	mov    %rdx,%r8
  801f7c:	89 c1                	mov    %eax,%ecx
  801f7e:	48 ba c8 58 80 00 00 	movabs $0x8058c8,%rdx
  801f85:	00 00 00 
  801f88:	be 23 00 00 00       	mov    $0x23,%esi
  801f8d:	48 bf e5 58 80 00 00 	movabs $0x8058e5,%rdi
  801f94:	00 00 00 
  801f97:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9c:	49 b9 df 09 80 00 00 	movabs $0x8009df,%r9
  801fa3:	00 00 00 
  801fa6:	41 ff d1             	callq  *%r9

	return ret;
  801fa9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801fad:	48 83 c4 48          	add    $0x48,%rsp
  801fb1:	5b                   	pop    %rbx
  801fb2:	5d                   	pop    %rbp
  801fb3:	c3                   	retq   

0000000000801fb4 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801fb4:	55                   	push   %rbp
  801fb5:	48 89 e5             	mov    %rsp,%rbp
  801fb8:	48 83 ec 20          	sub    $0x20,%rsp
  801fbc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801fc0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801fc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fcc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fd3:	00 
  801fd4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fda:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fe0:	48 89 d1             	mov    %rdx,%rcx
  801fe3:	48 89 c2             	mov    %rax,%rdx
  801fe6:	be 00 00 00 00       	mov    $0x0,%esi
  801feb:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff0:	48 b8 26 1f 80 00 00 	movabs $0x801f26,%rax
  801ff7:	00 00 00 
  801ffa:	ff d0                	callq  *%rax
}
  801ffc:	c9                   	leaveq 
  801ffd:	c3                   	retq   

0000000000801ffe <sys_cgetc>:

int
sys_cgetc(void)
{
  801ffe:	55                   	push   %rbp
  801fff:	48 89 e5             	mov    %rsp,%rbp
  802002:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802006:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80200d:	00 
  80200e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802014:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80201a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80201f:	ba 00 00 00 00       	mov    $0x0,%edx
  802024:	be 00 00 00 00       	mov    $0x0,%esi
  802029:	bf 01 00 00 00       	mov    $0x1,%edi
  80202e:	48 b8 26 1f 80 00 00 	movabs $0x801f26,%rax
  802035:	00 00 00 
  802038:	ff d0                	callq  *%rax
}
  80203a:	c9                   	leaveq 
  80203b:	c3                   	retq   

000000000080203c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80203c:	55                   	push   %rbp
  80203d:	48 89 e5             	mov    %rsp,%rbp
  802040:	48 83 ec 10          	sub    $0x10,%rsp
  802044:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802047:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80204a:	48 98                	cltq   
  80204c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802053:	00 
  802054:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80205a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802060:	b9 00 00 00 00       	mov    $0x0,%ecx
  802065:	48 89 c2             	mov    %rax,%rdx
  802068:	be 01 00 00 00       	mov    $0x1,%esi
  80206d:	bf 03 00 00 00       	mov    $0x3,%edi
  802072:	48 b8 26 1f 80 00 00 	movabs $0x801f26,%rax
  802079:	00 00 00 
  80207c:	ff d0                	callq  *%rax
}
  80207e:	c9                   	leaveq 
  80207f:	c3                   	retq   

0000000000802080 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802080:	55                   	push   %rbp
  802081:	48 89 e5             	mov    %rsp,%rbp
  802084:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802088:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80208f:	00 
  802090:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802096:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80209c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8020a6:	be 00 00 00 00       	mov    $0x0,%esi
  8020ab:	bf 02 00 00 00       	mov    $0x2,%edi
  8020b0:	48 b8 26 1f 80 00 00 	movabs $0x801f26,%rax
  8020b7:	00 00 00 
  8020ba:	ff d0                	callq  *%rax
}
  8020bc:	c9                   	leaveq 
  8020bd:	c3                   	retq   

00000000008020be <sys_yield>:

void
sys_yield(void)
{
  8020be:	55                   	push   %rbp
  8020bf:	48 89 e5             	mov    %rsp,%rbp
  8020c2:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8020c6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020cd:	00 
  8020ce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020da:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020df:	ba 00 00 00 00       	mov    $0x0,%edx
  8020e4:	be 00 00 00 00       	mov    $0x0,%esi
  8020e9:	bf 0b 00 00 00       	mov    $0xb,%edi
  8020ee:	48 b8 26 1f 80 00 00 	movabs $0x801f26,%rax
  8020f5:	00 00 00 
  8020f8:	ff d0                	callq  *%rax
}
  8020fa:	c9                   	leaveq 
  8020fb:	c3                   	retq   

00000000008020fc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8020fc:	55                   	push   %rbp
  8020fd:	48 89 e5             	mov    %rsp,%rbp
  802100:	48 83 ec 20          	sub    $0x20,%rsp
  802104:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802107:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80210b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80210e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802111:	48 63 c8             	movslq %eax,%rcx
  802114:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802118:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80211b:	48 98                	cltq   
  80211d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802124:	00 
  802125:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80212b:	49 89 c8             	mov    %rcx,%r8
  80212e:	48 89 d1             	mov    %rdx,%rcx
  802131:	48 89 c2             	mov    %rax,%rdx
  802134:	be 01 00 00 00       	mov    $0x1,%esi
  802139:	bf 04 00 00 00       	mov    $0x4,%edi
  80213e:	48 b8 26 1f 80 00 00 	movabs $0x801f26,%rax
  802145:	00 00 00 
  802148:	ff d0                	callq  *%rax
}
  80214a:	c9                   	leaveq 
  80214b:	c3                   	retq   

000000000080214c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80214c:	55                   	push   %rbp
  80214d:	48 89 e5             	mov    %rsp,%rbp
  802150:	48 83 ec 30          	sub    $0x30,%rsp
  802154:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802157:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80215b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80215e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802162:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802166:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802169:	48 63 c8             	movslq %eax,%rcx
  80216c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802170:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802173:	48 63 f0             	movslq %eax,%rsi
  802176:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80217a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80217d:	48 98                	cltq   
  80217f:	48 89 0c 24          	mov    %rcx,(%rsp)
  802183:	49 89 f9             	mov    %rdi,%r9
  802186:	49 89 f0             	mov    %rsi,%r8
  802189:	48 89 d1             	mov    %rdx,%rcx
  80218c:	48 89 c2             	mov    %rax,%rdx
  80218f:	be 01 00 00 00       	mov    $0x1,%esi
  802194:	bf 05 00 00 00       	mov    $0x5,%edi
  802199:	48 b8 26 1f 80 00 00 	movabs $0x801f26,%rax
  8021a0:	00 00 00 
  8021a3:	ff d0                	callq  *%rax
}
  8021a5:	c9                   	leaveq 
  8021a6:	c3                   	retq   

00000000008021a7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8021a7:	55                   	push   %rbp
  8021a8:	48 89 e5             	mov    %rsp,%rbp
  8021ab:	48 83 ec 20          	sub    $0x20,%rsp
  8021af:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021b2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8021b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021bd:	48 98                	cltq   
  8021bf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021c6:	00 
  8021c7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021cd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021d3:	48 89 d1             	mov    %rdx,%rcx
  8021d6:	48 89 c2             	mov    %rax,%rdx
  8021d9:	be 01 00 00 00       	mov    $0x1,%esi
  8021de:	bf 06 00 00 00       	mov    $0x6,%edi
  8021e3:	48 b8 26 1f 80 00 00 	movabs $0x801f26,%rax
  8021ea:	00 00 00 
  8021ed:	ff d0                	callq  *%rax
}
  8021ef:	c9                   	leaveq 
  8021f0:	c3                   	retq   

00000000008021f1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8021f1:	55                   	push   %rbp
  8021f2:	48 89 e5             	mov    %rsp,%rbp
  8021f5:	48 83 ec 10          	sub    $0x10,%rsp
  8021f9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021fc:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8021ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802202:	48 63 d0             	movslq %eax,%rdx
  802205:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802208:	48 98                	cltq   
  80220a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802211:	00 
  802212:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802218:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80221e:	48 89 d1             	mov    %rdx,%rcx
  802221:	48 89 c2             	mov    %rax,%rdx
  802224:	be 01 00 00 00       	mov    $0x1,%esi
  802229:	bf 08 00 00 00       	mov    $0x8,%edi
  80222e:	48 b8 26 1f 80 00 00 	movabs $0x801f26,%rax
  802235:	00 00 00 
  802238:	ff d0                	callq  *%rax
}
  80223a:	c9                   	leaveq 
  80223b:	c3                   	retq   

000000000080223c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80223c:	55                   	push   %rbp
  80223d:	48 89 e5             	mov    %rsp,%rbp
  802240:	48 83 ec 20          	sub    $0x20,%rsp
  802244:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802247:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80224b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80224f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802252:	48 98                	cltq   
  802254:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80225b:	00 
  80225c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802262:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802268:	48 89 d1             	mov    %rdx,%rcx
  80226b:	48 89 c2             	mov    %rax,%rdx
  80226e:	be 01 00 00 00       	mov    $0x1,%esi
  802273:	bf 09 00 00 00       	mov    $0x9,%edi
  802278:	48 b8 26 1f 80 00 00 	movabs $0x801f26,%rax
  80227f:	00 00 00 
  802282:	ff d0                	callq  *%rax
}
  802284:	c9                   	leaveq 
  802285:	c3                   	retq   

0000000000802286 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802286:	55                   	push   %rbp
  802287:	48 89 e5             	mov    %rsp,%rbp
  80228a:	48 83 ec 20          	sub    $0x20,%rsp
  80228e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802291:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802295:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802299:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80229c:	48 98                	cltq   
  80229e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022a5:	00 
  8022a6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022b2:	48 89 d1             	mov    %rdx,%rcx
  8022b5:	48 89 c2             	mov    %rax,%rdx
  8022b8:	be 01 00 00 00       	mov    $0x1,%esi
  8022bd:	bf 0a 00 00 00       	mov    $0xa,%edi
  8022c2:	48 b8 26 1f 80 00 00 	movabs $0x801f26,%rax
  8022c9:	00 00 00 
  8022cc:	ff d0                	callq  *%rax
}
  8022ce:	c9                   	leaveq 
  8022cf:	c3                   	retq   

00000000008022d0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8022d0:	55                   	push   %rbp
  8022d1:	48 89 e5             	mov    %rsp,%rbp
  8022d4:	48 83 ec 20          	sub    $0x20,%rsp
  8022d8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8022df:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8022e3:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8022e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022e9:	48 63 f0             	movslq %eax,%rsi
  8022ec:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022f3:	48 98                	cltq   
  8022f5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022f9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802300:	00 
  802301:	49 89 f1             	mov    %rsi,%r9
  802304:	49 89 c8             	mov    %rcx,%r8
  802307:	48 89 d1             	mov    %rdx,%rcx
  80230a:	48 89 c2             	mov    %rax,%rdx
  80230d:	be 00 00 00 00       	mov    $0x0,%esi
  802312:	bf 0c 00 00 00       	mov    $0xc,%edi
  802317:	48 b8 26 1f 80 00 00 	movabs $0x801f26,%rax
  80231e:	00 00 00 
  802321:	ff d0                	callq  *%rax
}
  802323:	c9                   	leaveq 
  802324:	c3                   	retq   

0000000000802325 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802325:	55                   	push   %rbp
  802326:	48 89 e5             	mov    %rsp,%rbp
  802329:	48 83 ec 10          	sub    $0x10,%rsp
  80232d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802331:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802335:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80233c:	00 
  80233d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802343:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802349:	b9 00 00 00 00       	mov    $0x0,%ecx
  80234e:	48 89 c2             	mov    %rax,%rdx
  802351:	be 01 00 00 00       	mov    $0x1,%esi
  802356:	bf 0d 00 00 00       	mov    $0xd,%edi
  80235b:	48 b8 26 1f 80 00 00 	movabs $0x801f26,%rax
  802362:	00 00 00 
  802365:	ff d0                	callq  *%rax
}
  802367:	c9                   	leaveq 
  802368:	c3                   	retq   

0000000000802369 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  802369:	55                   	push   %rbp
  80236a:	48 89 e5             	mov    %rsp,%rbp
  80236d:	48 83 ec 20          	sub    $0x20,%rsp
  802371:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802375:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  802379:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80237d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802381:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802388:	00 
  802389:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80238f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802395:	b9 00 00 00 00       	mov    $0x0,%ecx
  80239a:	89 c6                	mov    %eax,%esi
  80239c:	bf 0f 00 00 00       	mov    $0xf,%edi
  8023a1:	48 b8 26 1f 80 00 00 	movabs $0x801f26,%rax
  8023a8:	00 00 00 
  8023ab:	ff d0                	callq  *%rax
}
  8023ad:	c9                   	leaveq 
  8023ae:	c3                   	retq   

00000000008023af <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  8023af:	55                   	push   %rbp
  8023b0:	48 89 e5             	mov    %rsp,%rbp
  8023b3:	48 83 ec 20          	sub    $0x20,%rsp
  8023b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023bb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  8023bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023c3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023c7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023ce:	00 
  8023cf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023d5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023db:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023e0:	89 c6                	mov    %eax,%esi
  8023e2:	bf 10 00 00 00       	mov    $0x10,%edi
  8023e7:	48 b8 26 1f 80 00 00 	movabs $0x801f26,%rax
  8023ee:	00 00 00 
  8023f1:	ff d0                	callq  *%rax
}
  8023f3:	c9                   	leaveq 
  8023f4:	c3                   	retq   

00000000008023f5 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8023f5:	55                   	push   %rbp
  8023f6:	48 89 e5             	mov    %rsp,%rbp
  8023f9:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8023fd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802404:	00 
  802405:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80240b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802411:	b9 00 00 00 00       	mov    $0x0,%ecx
  802416:	ba 00 00 00 00       	mov    $0x0,%edx
  80241b:	be 00 00 00 00       	mov    $0x0,%esi
  802420:	bf 0e 00 00 00       	mov    $0xe,%edi
  802425:	48 b8 26 1f 80 00 00 	movabs $0x801f26,%rax
  80242c:	00 00 00 
  80242f:	ff d0                	callq  *%rax
}
  802431:	c9                   	leaveq 
  802432:	c3                   	retq   

0000000000802433 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802433:	55                   	push   %rbp
  802434:	48 89 e5             	mov    %rsp,%rbp
  802437:	48 83 ec 08          	sub    $0x8,%rsp
  80243b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80243f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802443:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80244a:	ff ff ff 
  80244d:	48 01 d0             	add    %rdx,%rax
  802450:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802454:	c9                   	leaveq 
  802455:	c3                   	retq   

0000000000802456 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802456:	55                   	push   %rbp
  802457:	48 89 e5             	mov    %rsp,%rbp
  80245a:	48 83 ec 08          	sub    $0x8,%rsp
  80245e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802462:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802466:	48 89 c7             	mov    %rax,%rdi
  802469:	48 b8 33 24 80 00 00 	movabs $0x802433,%rax
  802470:	00 00 00 
  802473:	ff d0                	callq  *%rax
  802475:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80247b:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80247f:	c9                   	leaveq 
  802480:	c3                   	retq   

0000000000802481 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802481:	55                   	push   %rbp
  802482:	48 89 e5             	mov    %rsp,%rbp
  802485:	48 83 ec 18          	sub    $0x18,%rsp
  802489:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80248d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802494:	eb 6b                	jmp    802501 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802496:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802499:	48 98                	cltq   
  80249b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024a1:	48 c1 e0 0c          	shl    $0xc,%rax
  8024a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8024a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ad:	48 c1 e8 15          	shr    $0x15,%rax
  8024b1:	48 89 c2             	mov    %rax,%rdx
  8024b4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024bb:	01 00 00 
  8024be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024c2:	83 e0 01             	and    $0x1,%eax
  8024c5:	48 85 c0             	test   %rax,%rax
  8024c8:	74 21                	je     8024eb <fd_alloc+0x6a>
  8024ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ce:	48 c1 e8 0c          	shr    $0xc,%rax
  8024d2:	48 89 c2             	mov    %rax,%rdx
  8024d5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024dc:	01 00 00 
  8024df:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024e3:	83 e0 01             	and    $0x1,%eax
  8024e6:	48 85 c0             	test   %rax,%rax
  8024e9:	75 12                	jne    8024fd <fd_alloc+0x7c>
			*fd_store = fd;
  8024eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024f3:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8024f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fb:	eb 1a                	jmp    802517 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8024fd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802501:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802505:	7e 8f                	jle    802496 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802507:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80250b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802512:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802517:	c9                   	leaveq 
  802518:	c3                   	retq   

0000000000802519 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802519:	55                   	push   %rbp
  80251a:	48 89 e5             	mov    %rsp,%rbp
  80251d:	48 83 ec 20          	sub    $0x20,%rsp
  802521:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802524:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802528:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80252c:	78 06                	js     802534 <fd_lookup+0x1b>
  80252e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802532:	7e 07                	jle    80253b <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802534:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802539:	eb 6c                	jmp    8025a7 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80253b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80253e:	48 98                	cltq   
  802540:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802546:	48 c1 e0 0c          	shl    $0xc,%rax
  80254a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80254e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802552:	48 c1 e8 15          	shr    $0x15,%rax
  802556:	48 89 c2             	mov    %rax,%rdx
  802559:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802560:	01 00 00 
  802563:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802567:	83 e0 01             	and    $0x1,%eax
  80256a:	48 85 c0             	test   %rax,%rax
  80256d:	74 21                	je     802590 <fd_lookup+0x77>
  80256f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802573:	48 c1 e8 0c          	shr    $0xc,%rax
  802577:	48 89 c2             	mov    %rax,%rdx
  80257a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802581:	01 00 00 
  802584:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802588:	83 e0 01             	and    $0x1,%eax
  80258b:	48 85 c0             	test   %rax,%rax
  80258e:	75 07                	jne    802597 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802590:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802595:	eb 10                	jmp    8025a7 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802597:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80259b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80259f:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8025a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a7:	c9                   	leaveq 
  8025a8:	c3                   	retq   

00000000008025a9 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8025a9:	55                   	push   %rbp
  8025aa:	48 89 e5             	mov    %rsp,%rbp
  8025ad:	48 83 ec 30          	sub    $0x30,%rsp
  8025b1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8025b5:	89 f0                	mov    %esi,%eax
  8025b7:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8025ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025be:	48 89 c7             	mov    %rax,%rdi
  8025c1:	48 b8 33 24 80 00 00 	movabs $0x802433,%rax
  8025c8:	00 00 00 
  8025cb:	ff d0                	callq  *%rax
  8025cd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025d1:	48 89 d6             	mov    %rdx,%rsi
  8025d4:	89 c7                	mov    %eax,%edi
  8025d6:	48 b8 19 25 80 00 00 	movabs $0x802519,%rax
  8025dd:	00 00 00 
  8025e0:	ff d0                	callq  *%rax
  8025e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e9:	78 0a                	js     8025f5 <fd_close+0x4c>
	    || fd != fd2)
  8025eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ef:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8025f3:	74 12                	je     802607 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8025f5:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8025f9:	74 05                	je     802600 <fd_close+0x57>
  8025fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025fe:	eb 05                	jmp    802605 <fd_close+0x5c>
  802600:	b8 00 00 00 00       	mov    $0x0,%eax
  802605:	eb 69                	jmp    802670 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802607:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80260b:	8b 00                	mov    (%rax),%eax
  80260d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802611:	48 89 d6             	mov    %rdx,%rsi
  802614:	89 c7                	mov    %eax,%edi
  802616:	48 b8 72 26 80 00 00 	movabs $0x802672,%rax
  80261d:	00 00 00 
  802620:	ff d0                	callq  *%rax
  802622:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802625:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802629:	78 2a                	js     802655 <fd_close+0xac>
		if (dev->dev_close)
  80262b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80262f:	48 8b 40 20          	mov    0x20(%rax),%rax
  802633:	48 85 c0             	test   %rax,%rax
  802636:	74 16                	je     80264e <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802638:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80263c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802640:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802644:	48 89 d7             	mov    %rdx,%rdi
  802647:	ff d0                	callq  *%rax
  802649:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80264c:	eb 07                	jmp    802655 <fd_close+0xac>
		else
			r = 0;
  80264e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802655:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802659:	48 89 c6             	mov    %rax,%rsi
  80265c:	bf 00 00 00 00       	mov    $0x0,%edi
  802661:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  802668:	00 00 00 
  80266b:	ff d0                	callq  *%rax
	return r;
  80266d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802670:	c9                   	leaveq 
  802671:	c3                   	retq   

0000000000802672 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802672:	55                   	push   %rbp
  802673:	48 89 e5             	mov    %rsp,%rbp
  802676:	48 83 ec 20          	sub    $0x20,%rsp
  80267a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80267d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802681:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802688:	eb 41                	jmp    8026cb <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80268a:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  802691:	00 00 00 
  802694:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802697:	48 63 d2             	movslq %edx,%rdx
  80269a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80269e:	8b 00                	mov    (%rax),%eax
  8026a0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8026a3:	75 22                	jne    8026c7 <dev_lookup+0x55>
			*dev = devtab[i];
  8026a5:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8026ac:	00 00 00 
  8026af:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026b2:	48 63 d2             	movslq %edx,%rdx
  8026b5:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8026b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026bd:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8026c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c5:	eb 60                	jmp    802727 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8026c7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026cb:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8026d2:	00 00 00 
  8026d5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026d8:	48 63 d2             	movslq %edx,%rdx
  8026db:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026df:	48 85 c0             	test   %rax,%rax
  8026e2:	75 a6                	jne    80268a <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8026e4:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8026eb:	00 00 00 
  8026ee:	48 8b 00             	mov    (%rax),%rax
  8026f1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026f7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8026fa:	89 c6                	mov    %eax,%esi
  8026fc:	48 bf f8 58 80 00 00 	movabs $0x8058f8,%rdi
  802703:	00 00 00 
  802706:	b8 00 00 00 00       	mov    $0x0,%eax
  80270b:	48 b9 18 0c 80 00 00 	movabs $0x800c18,%rcx
  802712:	00 00 00 
  802715:	ff d1                	callq  *%rcx
	*dev = 0;
  802717:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80271b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802722:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802727:	c9                   	leaveq 
  802728:	c3                   	retq   

0000000000802729 <close>:

int
close(int fdnum)
{
  802729:	55                   	push   %rbp
  80272a:	48 89 e5             	mov    %rsp,%rbp
  80272d:	48 83 ec 20          	sub    $0x20,%rsp
  802731:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802734:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802738:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80273b:	48 89 d6             	mov    %rdx,%rsi
  80273e:	89 c7                	mov    %eax,%edi
  802740:	48 b8 19 25 80 00 00 	movabs $0x802519,%rax
  802747:	00 00 00 
  80274a:	ff d0                	callq  *%rax
  80274c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80274f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802753:	79 05                	jns    80275a <close+0x31>
		return r;
  802755:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802758:	eb 18                	jmp    802772 <close+0x49>
	else
		return fd_close(fd, 1);
  80275a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80275e:	be 01 00 00 00       	mov    $0x1,%esi
  802763:	48 89 c7             	mov    %rax,%rdi
  802766:	48 b8 a9 25 80 00 00 	movabs $0x8025a9,%rax
  80276d:	00 00 00 
  802770:	ff d0                	callq  *%rax
}
  802772:	c9                   	leaveq 
  802773:	c3                   	retq   

0000000000802774 <close_all>:

void
close_all(void)
{
  802774:	55                   	push   %rbp
  802775:	48 89 e5             	mov    %rsp,%rbp
  802778:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80277c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802783:	eb 15                	jmp    80279a <close_all+0x26>
		close(i);
  802785:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802788:	89 c7                	mov    %eax,%edi
  80278a:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  802791:	00 00 00 
  802794:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802796:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80279a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80279e:	7e e5                	jle    802785 <close_all+0x11>
		close(i);
}
  8027a0:	c9                   	leaveq 
  8027a1:	c3                   	retq   

00000000008027a2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8027a2:	55                   	push   %rbp
  8027a3:	48 89 e5             	mov    %rsp,%rbp
  8027a6:	48 83 ec 40          	sub    $0x40,%rsp
  8027aa:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8027ad:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8027b0:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8027b4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8027b7:	48 89 d6             	mov    %rdx,%rsi
  8027ba:	89 c7                	mov    %eax,%edi
  8027bc:	48 b8 19 25 80 00 00 	movabs $0x802519,%rax
  8027c3:	00 00 00 
  8027c6:	ff d0                	callq  *%rax
  8027c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027cf:	79 08                	jns    8027d9 <dup+0x37>
		return r;
  8027d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027d4:	e9 70 01 00 00       	jmpq   802949 <dup+0x1a7>
	close(newfdnum);
  8027d9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027dc:	89 c7                	mov    %eax,%edi
  8027de:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  8027e5:	00 00 00 
  8027e8:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8027ea:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027ed:	48 98                	cltq   
  8027ef:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027f5:	48 c1 e0 0c          	shl    $0xc,%rax
  8027f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8027fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802801:	48 89 c7             	mov    %rax,%rdi
  802804:	48 b8 56 24 80 00 00 	movabs $0x802456,%rax
  80280b:	00 00 00 
  80280e:	ff d0                	callq  *%rax
  802810:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802814:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802818:	48 89 c7             	mov    %rax,%rdi
  80281b:	48 b8 56 24 80 00 00 	movabs $0x802456,%rax
  802822:	00 00 00 
  802825:	ff d0                	callq  *%rax
  802827:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80282b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80282f:	48 c1 e8 15          	shr    $0x15,%rax
  802833:	48 89 c2             	mov    %rax,%rdx
  802836:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80283d:	01 00 00 
  802840:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802844:	83 e0 01             	and    $0x1,%eax
  802847:	48 85 c0             	test   %rax,%rax
  80284a:	74 73                	je     8028bf <dup+0x11d>
  80284c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802850:	48 c1 e8 0c          	shr    $0xc,%rax
  802854:	48 89 c2             	mov    %rax,%rdx
  802857:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80285e:	01 00 00 
  802861:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802865:	83 e0 01             	and    $0x1,%eax
  802868:	48 85 c0             	test   %rax,%rax
  80286b:	74 52                	je     8028bf <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80286d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802871:	48 c1 e8 0c          	shr    $0xc,%rax
  802875:	48 89 c2             	mov    %rax,%rdx
  802878:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80287f:	01 00 00 
  802882:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802886:	25 07 0e 00 00       	and    $0xe07,%eax
  80288b:	89 c1                	mov    %eax,%ecx
  80288d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802891:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802895:	41 89 c8             	mov    %ecx,%r8d
  802898:	48 89 d1             	mov    %rdx,%rcx
  80289b:	ba 00 00 00 00       	mov    $0x0,%edx
  8028a0:	48 89 c6             	mov    %rax,%rsi
  8028a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8028a8:	48 b8 4c 21 80 00 00 	movabs $0x80214c,%rax
  8028af:	00 00 00 
  8028b2:	ff d0                	callq  *%rax
  8028b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028bb:	79 02                	jns    8028bf <dup+0x11d>
			goto err;
  8028bd:	eb 57                	jmp    802916 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8028bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028c3:	48 c1 e8 0c          	shr    $0xc,%rax
  8028c7:	48 89 c2             	mov    %rax,%rdx
  8028ca:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028d1:	01 00 00 
  8028d4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028d8:	25 07 0e 00 00       	and    $0xe07,%eax
  8028dd:	89 c1                	mov    %eax,%ecx
  8028df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028e7:	41 89 c8             	mov    %ecx,%r8d
  8028ea:	48 89 d1             	mov    %rdx,%rcx
  8028ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8028f2:	48 89 c6             	mov    %rax,%rsi
  8028f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8028fa:	48 b8 4c 21 80 00 00 	movabs $0x80214c,%rax
  802901:	00 00 00 
  802904:	ff d0                	callq  *%rax
  802906:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802909:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80290d:	79 02                	jns    802911 <dup+0x16f>
		goto err;
  80290f:	eb 05                	jmp    802916 <dup+0x174>

	return newfdnum;
  802911:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802914:	eb 33                	jmp    802949 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802916:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80291a:	48 89 c6             	mov    %rax,%rsi
  80291d:	bf 00 00 00 00       	mov    $0x0,%edi
  802922:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  802929:	00 00 00 
  80292c:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80292e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802932:	48 89 c6             	mov    %rax,%rsi
  802935:	bf 00 00 00 00       	mov    $0x0,%edi
  80293a:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  802941:	00 00 00 
  802944:	ff d0                	callq  *%rax
	return r;
  802946:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802949:	c9                   	leaveq 
  80294a:	c3                   	retq   

000000000080294b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80294b:	55                   	push   %rbp
  80294c:	48 89 e5             	mov    %rsp,%rbp
  80294f:	48 83 ec 40          	sub    $0x40,%rsp
  802953:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802956:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80295a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80295e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802962:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802965:	48 89 d6             	mov    %rdx,%rsi
  802968:	89 c7                	mov    %eax,%edi
  80296a:	48 b8 19 25 80 00 00 	movabs $0x802519,%rax
  802971:	00 00 00 
  802974:	ff d0                	callq  *%rax
  802976:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802979:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80297d:	78 24                	js     8029a3 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80297f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802983:	8b 00                	mov    (%rax),%eax
  802985:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802989:	48 89 d6             	mov    %rdx,%rsi
  80298c:	89 c7                	mov    %eax,%edi
  80298e:	48 b8 72 26 80 00 00 	movabs $0x802672,%rax
  802995:	00 00 00 
  802998:	ff d0                	callq  *%rax
  80299a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80299d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029a1:	79 05                	jns    8029a8 <read+0x5d>
		return r;
  8029a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a6:	eb 76                	jmp    802a1e <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8029a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ac:	8b 40 08             	mov    0x8(%rax),%eax
  8029af:	83 e0 03             	and    $0x3,%eax
  8029b2:	83 f8 01             	cmp    $0x1,%eax
  8029b5:	75 3a                	jne    8029f1 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8029b7:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8029be:	00 00 00 
  8029c1:	48 8b 00             	mov    (%rax),%rax
  8029c4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029ca:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029cd:	89 c6                	mov    %eax,%esi
  8029cf:	48 bf 17 59 80 00 00 	movabs $0x805917,%rdi
  8029d6:	00 00 00 
  8029d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029de:	48 b9 18 0c 80 00 00 	movabs $0x800c18,%rcx
  8029e5:	00 00 00 
  8029e8:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8029ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029ef:	eb 2d                	jmp    802a1e <read+0xd3>
	}
	if (!dev->dev_read)
  8029f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029f5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8029f9:	48 85 c0             	test   %rax,%rax
  8029fc:	75 07                	jne    802a05 <read+0xba>
		return -E_NOT_SUPP;
  8029fe:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a03:	eb 19                	jmp    802a1e <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802a05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a09:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a0d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a11:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a15:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a19:	48 89 cf             	mov    %rcx,%rdi
  802a1c:	ff d0                	callq  *%rax
}
  802a1e:	c9                   	leaveq 
  802a1f:	c3                   	retq   

0000000000802a20 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802a20:	55                   	push   %rbp
  802a21:	48 89 e5             	mov    %rsp,%rbp
  802a24:	48 83 ec 30          	sub    $0x30,%rsp
  802a28:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a2b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a2f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a3a:	eb 49                	jmp    802a85 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802a3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3f:	48 98                	cltq   
  802a41:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a45:	48 29 c2             	sub    %rax,%rdx
  802a48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a4b:	48 63 c8             	movslq %eax,%rcx
  802a4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a52:	48 01 c1             	add    %rax,%rcx
  802a55:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a58:	48 89 ce             	mov    %rcx,%rsi
  802a5b:	89 c7                	mov    %eax,%edi
  802a5d:	48 b8 4b 29 80 00 00 	movabs $0x80294b,%rax
  802a64:	00 00 00 
  802a67:	ff d0                	callq  *%rax
  802a69:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802a6c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a70:	79 05                	jns    802a77 <readn+0x57>
			return m;
  802a72:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a75:	eb 1c                	jmp    802a93 <readn+0x73>
		if (m == 0)
  802a77:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a7b:	75 02                	jne    802a7f <readn+0x5f>
			break;
  802a7d:	eb 11                	jmp    802a90 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a7f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a82:	01 45 fc             	add    %eax,-0x4(%rbp)
  802a85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a88:	48 98                	cltq   
  802a8a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a8e:	72 ac                	jb     802a3c <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802a90:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a93:	c9                   	leaveq 
  802a94:	c3                   	retq   

0000000000802a95 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802a95:	55                   	push   %rbp
  802a96:	48 89 e5             	mov    %rsp,%rbp
  802a99:	48 83 ec 40          	sub    $0x40,%rsp
  802a9d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802aa0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802aa4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802aa8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802aac:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802aaf:	48 89 d6             	mov    %rdx,%rsi
  802ab2:	89 c7                	mov    %eax,%edi
  802ab4:	48 b8 19 25 80 00 00 	movabs $0x802519,%rax
  802abb:	00 00 00 
  802abe:	ff d0                	callq  *%rax
  802ac0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ac3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ac7:	78 24                	js     802aed <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ac9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802acd:	8b 00                	mov    (%rax),%eax
  802acf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ad3:	48 89 d6             	mov    %rdx,%rsi
  802ad6:	89 c7                	mov    %eax,%edi
  802ad8:	48 b8 72 26 80 00 00 	movabs $0x802672,%rax
  802adf:	00 00 00 
  802ae2:	ff d0                	callq  *%rax
  802ae4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ae7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aeb:	79 05                	jns    802af2 <write+0x5d>
		return r;
  802aed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af0:	eb 75                	jmp    802b67 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802af2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af6:	8b 40 08             	mov    0x8(%rax),%eax
  802af9:	83 e0 03             	and    $0x3,%eax
  802afc:	85 c0                	test   %eax,%eax
  802afe:	75 3a                	jne    802b3a <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802b00:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802b07:	00 00 00 
  802b0a:	48 8b 00             	mov    (%rax),%rax
  802b0d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b13:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b16:	89 c6                	mov    %eax,%esi
  802b18:	48 bf 33 59 80 00 00 	movabs $0x805933,%rdi
  802b1f:	00 00 00 
  802b22:	b8 00 00 00 00       	mov    $0x0,%eax
  802b27:	48 b9 18 0c 80 00 00 	movabs $0x800c18,%rcx
  802b2e:	00 00 00 
  802b31:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b33:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b38:	eb 2d                	jmp    802b67 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802b3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b3e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b42:	48 85 c0             	test   %rax,%rax
  802b45:	75 07                	jne    802b4e <write+0xb9>
		return -E_NOT_SUPP;
  802b47:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b4c:	eb 19                	jmp    802b67 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802b4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b52:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b56:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b5a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b5e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b62:	48 89 cf             	mov    %rcx,%rdi
  802b65:	ff d0                	callq  *%rax
}
  802b67:	c9                   	leaveq 
  802b68:	c3                   	retq   

0000000000802b69 <seek>:

int
seek(int fdnum, off_t offset)
{
  802b69:	55                   	push   %rbp
  802b6a:	48 89 e5             	mov    %rsp,%rbp
  802b6d:	48 83 ec 18          	sub    $0x18,%rsp
  802b71:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b74:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b77:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b7b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b7e:	48 89 d6             	mov    %rdx,%rsi
  802b81:	89 c7                	mov    %eax,%edi
  802b83:	48 b8 19 25 80 00 00 	movabs $0x802519,%rax
  802b8a:	00 00 00 
  802b8d:	ff d0                	callq  *%rax
  802b8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b96:	79 05                	jns    802b9d <seek+0x34>
		return r;
  802b98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b9b:	eb 0f                	jmp    802bac <seek+0x43>
	fd->fd_offset = offset;
  802b9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ba4:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802ba7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bac:	c9                   	leaveq 
  802bad:	c3                   	retq   

0000000000802bae <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802bae:	55                   	push   %rbp
  802baf:	48 89 e5             	mov    %rsp,%rbp
  802bb2:	48 83 ec 30          	sub    $0x30,%rsp
  802bb6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bb9:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bbc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bc0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bc3:	48 89 d6             	mov    %rdx,%rsi
  802bc6:	89 c7                	mov    %eax,%edi
  802bc8:	48 b8 19 25 80 00 00 	movabs $0x802519,%rax
  802bcf:	00 00 00 
  802bd2:	ff d0                	callq  *%rax
  802bd4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bd7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bdb:	78 24                	js     802c01 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be1:	8b 00                	mov    (%rax),%eax
  802be3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802be7:	48 89 d6             	mov    %rdx,%rsi
  802bea:	89 c7                	mov    %eax,%edi
  802bec:	48 b8 72 26 80 00 00 	movabs $0x802672,%rax
  802bf3:	00 00 00 
  802bf6:	ff d0                	callq  *%rax
  802bf8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bfb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bff:	79 05                	jns    802c06 <ftruncate+0x58>
		return r;
  802c01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c04:	eb 72                	jmp    802c78 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c0a:	8b 40 08             	mov    0x8(%rax),%eax
  802c0d:	83 e0 03             	and    $0x3,%eax
  802c10:	85 c0                	test   %eax,%eax
  802c12:	75 3a                	jne    802c4e <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802c14:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802c1b:	00 00 00 
  802c1e:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c21:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c27:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c2a:	89 c6                	mov    %eax,%esi
  802c2c:	48 bf 50 59 80 00 00 	movabs $0x805950,%rdi
  802c33:	00 00 00 
  802c36:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3b:	48 b9 18 0c 80 00 00 	movabs $0x800c18,%rcx
  802c42:	00 00 00 
  802c45:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802c47:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c4c:	eb 2a                	jmp    802c78 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802c4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c52:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c56:	48 85 c0             	test   %rax,%rax
  802c59:	75 07                	jne    802c62 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802c5b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c60:	eb 16                	jmp    802c78 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802c62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c66:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c6a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c6e:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802c71:	89 ce                	mov    %ecx,%esi
  802c73:	48 89 d7             	mov    %rdx,%rdi
  802c76:	ff d0                	callq  *%rax
}
  802c78:	c9                   	leaveq 
  802c79:	c3                   	retq   

0000000000802c7a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802c7a:	55                   	push   %rbp
  802c7b:	48 89 e5             	mov    %rsp,%rbp
  802c7e:	48 83 ec 30          	sub    $0x30,%rsp
  802c82:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c85:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c89:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c8d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c90:	48 89 d6             	mov    %rdx,%rsi
  802c93:	89 c7                	mov    %eax,%edi
  802c95:	48 b8 19 25 80 00 00 	movabs $0x802519,%rax
  802c9c:	00 00 00 
  802c9f:	ff d0                	callq  *%rax
  802ca1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca8:	78 24                	js     802cce <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802caa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cae:	8b 00                	mov    (%rax),%eax
  802cb0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cb4:	48 89 d6             	mov    %rdx,%rsi
  802cb7:	89 c7                	mov    %eax,%edi
  802cb9:	48 b8 72 26 80 00 00 	movabs $0x802672,%rax
  802cc0:	00 00 00 
  802cc3:	ff d0                	callq  *%rax
  802cc5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cc8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ccc:	79 05                	jns    802cd3 <fstat+0x59>
		return r;
  802cce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd1:	eb 5e                	jmp    802d31 <fstat+0xb7>
	if (!dev->dev_stat)
  802cd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cd7:	48 8b 40 28          	mov    0x28(%rax),%rax
  802cdb:	48 85 c0             	test   %rax,%rax
  802cde:	75 07                	jne    802ce7 <fstat+0x6d>
		return -E_NOT_SUPP;
  802ce0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ce5:	eb 4a                	jmp    802d31 <fstat+0xb7>
	stat->st_name[0] = 0;
  802ce7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ceb:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802cee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cf2:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802cf9:	00 00 00 
	stat->st_isdir = 0;
  802cfc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d00:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d07:	00 00 00 
	stat->st_dev = dev;
  802d0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d0e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d12:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802d19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d1d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d21:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d25:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d29:	48 89 ce             	mov    %rcx,%rsi
  802d2c:	48 89 d7             	mov    %rdx,%rdi
  802d2f:	ff d0                	callq  *%rax
}
  802d31:	c9                   	leaveq 
  802d32:	c3                   	retq   

0000000000802d33 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802d33:	55                   	push   %rbp
  802d34:	48 89 e5             	mov    %rsp,%rbp
  802d37:	48 83 ec 20          	sub    $0x20,%rsp
  802d3b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d3f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802d43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d47:	be 00 00 00 00       	mov    $0x0,%esi
  802d4c:	48 89 c7             	mov    %rax,%rdi
  802d4f:	48 b8 21 2e 80 00 00 	movabs $0x802e21,%rax
  802d56:	00 00 00 
  802d59:	ff d0                	callq  *%rax
  802d5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d62:	79 05                	jns    802d69 <stat+0x36>
		return fd;
  802d64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d67:	eb 2f                	jmp    802d98 <stat+0x65>
	r = fstat(fd, stat);
  802d69:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d70:	48 89 d6             	mov    %rdx,%rsi
  802d73:	89 c7                	mov    %eax,%edi
  802d75:	48 b8 7a 2c 80 00 00 	movabs $0x802c7a,%rax
  802d7c:	00 00 00 
  802d7f:	ff d0                	callq  *%rax
  802d81:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802d84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d87:	89 c7                	mov    %eax,%edi
  802d89:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  802d90:	00 00 00 
  802d93:	ff d0                	callq  *%rax
	return r;
  802d95:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802d98:	c9                   	leaveq 
  802d99:	c3                   	retq   

0000000000802d9a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802d9a:	55                   	push   %rbp
  802d9b:	48 89 e5             	mov    %rsp,%rbp
  802d9e:	48 83 ec 10          	sub    $0x10,%rsp
  802da2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802da5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802da9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802db0:	00 00 00 
  802db3:	8b 00                	mov    (%rax),%eax
  802db5:	85 c0                	test   %eax,%eax
  802db7:	75 1d                	jne    802dd6 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802db9:	bf 01 00 00 00       	mov    $0x1,%edi
  802dbe:	48 b8 b1 4b 80 00 00 	movabs $0x804bb1,%rax
  802dc5:	00 00 00 
  802dc8:	ff d0                	callq  *%rax
  802dca:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802dd1:	00 00 00 
  802dd4:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802dd6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ddd:	00 00 00 
  802de0:	8b 00                	mov    (%rax),%eax
  802de2:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802de5:	b9 07 00 00 00       	mov    $0x7,%ecx
  802dea:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802df1:	00 00 00 
  802df4:	89 c7                	mov    %eax,%edi
  802df6:	48 b8 4f 4b 80 00 00 	movabs $0x804b4f,%rax
  802dfd:	00 00 00 
  802e00:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802e02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e06:	ba 00 00 00 00       	mov    $0x0,%edx
  802e0b:	48 89 c6             	mov    %rax,%rsi
  802e0e:	bf 00 00 00 00       	mov    $0x0,%edi
  802e13:	48 b8 49 4a 80 00 00 	movabs $0x804a49,%rax
  802e1a:	00 00 00 
  802e1d:	ff d0                	callq  *%rax
}
  802e1f:	c9                   	leaveq 
  802e20:	c3                   	retq   

0000000000802e21 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802e21:	55                   	push   %rbp
  802e22:	48 89 e5             	mov    %rsp,%rbp
  802e25:	48 83 ec 30          	sub    $0x30,%rsp
  802e29:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e2d:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802e30:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802e37:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802e3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802e45:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802e4a:	75 08                	jne    802e54 <open+0x33>
	{
		return r;
  802e4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4f:	e9 f2 00 00 00       	jmpq   802f46 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802e54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e58:	48 89 c7             	mov    %rax,%rdi
  802e5b:	48 b8 61 17 80 00 00 	movabs $0x801761,%rax
  802e62:	00 00 00 
  802e65:	ff d0                	callq  *%rax
  802e67:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802e6a:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802e71:	7e 0a                	jle    802e7d <open+0x5c>
	{
		return -E_BAD_PATH;
  802e73:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e78:	e9 c9 00 00 00       	jmpq   802f46 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802e7d:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802e84:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802e85:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802e89:	48 89 c7             	mov    %rax,%rdi
  802e8c:	48 b8 81 24 80 00 00 	movabs $0x802481,%rax
  802e93:	00 00 00 
  802e96:	ff d0                	callq  *%rax
  802e98:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e9f:	78 09                	js     802eaa <open+0x89>
  802ea1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea5:	48 85 c0             	test   %rax,%rax
  802ea8:	75 08                	jne    802eb2 <open+0x91>
		{
			return r;
  802eaa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ead:	e9 94 00 00 00       	jmpq   802f46 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802eb2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eb6:	ba 00 04 00 00       	mov    $0x400,%edx
  802ebb:	48 89 c6             	mov    %rax,%rsi
  802ebe:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802ec5:	00 00 00 
  802ec8:	48 b8 5f 18 80 00 00 	movabs $0x80185f,%rax
  802ecf:	00 00 00 
  802ed2:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802ed4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802edb:	00 00 00 
  802ede:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802ee1:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802ee7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eeb:	48 89 c6             	mov    %rax,%rsi
  802eee:	bf 01 00 00 00       	mov    $0x1,%edi
  802ef3:	48 b8 9a 2d 80 00 00 	movabs $0x802d9a,%rax
  802efa:	00 00 00 
  802efd:	ff d0                	callq  *%rax
  802eff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f06:	79 2b                	jns    802f33 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802f08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f0c:	be 00 00 00 00       	mov    $0x0,%esi
  802f11:	48 89 c7             	mov    %rax,%rdi
  802f14:	48 b8 a9 25 80 00 00 	movabs $0x8025a9,%rax
  802f1b:	00 00 00 
  802f1e:	ff d0                	callq  *%rax
  802f20:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802f23:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f27:	79 05                	jns    802f2e <open+0x10d>
			{
				return d;
  802f29:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f2c:	eb 18                	jmp    802f46 <open+0x125>
			}
			return r;
  802f2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f31:	eb 13                	jmp    802f46 <open+0x125>
		}	
		return fd2num(fd_store);
  802f33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f37:	48 89 c7             	mov    %rax,%rdi
  802f3a:	48 b8 33 24 80 00 00 	movabs $0x802433,%rax
  802f41:	00 00 00 
  802f44:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802f46:	c9                   	leaveq 
  802f47:	c3                   	retq   

0000000000802f48 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802f48:	55                   	push   %rbp
  802f49:	48 89 e5             	mov    %rsp,%rbp
  802f4c:	48 83 ec 10          	sub    $0x10,%rsp
  802f50:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f58:	8b 50 0c             	mov    0xc(%rax),%edx
  802f5b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f62:	00 00 00 
  802f65:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802f67:	be 00 00 00 00       	mov    $0x0,%esi
  802f6c:	bf 06 00 00 00       	mov    $0x6,%edi
  802f71:	48 b8 9a 2d 80 00 00 	movabs $0x802d9a,%rax
  802f78:	00 00 00 
  802f7b:	ff d0                	callq  *%rax
}
  802f7d:	c9                   	leaveq 
  802f7e:	c3                   	retq   

0000000000802f7f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802f7f:	55                   	push   %rbp
  802f80:	48 89 e5             	mov    %rsp,%rbp
  802f83:	48 83 ec 30          	sub    $0x30,%rsp
  802f87:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f8b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f8f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802f93:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802f9a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802f9f:	74 07                	je     802fa8 <devfile_read+0x29>
  802fa1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802fa6:	75 07                	jne    802faf <devfile_read+0x30>
		return -E_INVAL;
  802fa8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fad:	eb 77                	jmp    803026 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802faf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fb3:	8b 50 0c             	mov    0xc(%rax),%edx
  802fb6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fbd:	00 00 00 
  802fc0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802fc2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fc9:	00 00 00 
  802fcc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fd0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802fd4:	be 00 00 00 00       	mov    $0x0,%esi
  802fd9:	bf 03 00 00 00       	mov    $0x3,%edi
  802fde:	48 b8 9a 2d 80 00 00 	movabs $0x802d9a,%rax
  802fe5:	00 00 00 
  802fe8:	ff d0                	callq  *%rax
  802fea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ff1:	7f 05                	jg     802ff8 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802ff3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff6:	eb 2e                	jmp    803026 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802ff8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ffb:	48 63 d0             	movslq %eax,%rdx
  802ffe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803002:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803009:	00 00 00 
  80300c:	48 89 c7             	mov    %rax,%rdi
  80300f:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  803016:	00 00 00 
  803019:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  80301b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80301f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803023:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803026:	c9                   	leaveq 
  803027:	c3                   	retq   

0000000000803028 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803028:	55                   	push   %rbp
  803029:	48 89 e5             	mov    %rsp,%rbp
  80302c:	48 83 ec 30          	sub    $0x30,%rsp
  803030:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803034:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803038:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80303c:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  803043:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803048:	74 07                	je     803051 <devfile_write+0x29>
  80304a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80304f:	75 08                	jne    803059 <devfile_write+0x31>
		return r;
  803051:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803054:	e9 9a 00 00 00       	jmpq   8030f3 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803059:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80305d:	8b 50 0c             	mov    0xc(%rax),%edx
  803060:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803067:	00 00 00 
  80306a:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80306c:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803073:	00 
  803074:	76 08                	jbe    80307e <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  803076:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80307d:	00 
	}
	fsipcbuf.write.req_n = n;
  80307e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803085:	00 00 00 
  803088:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80308c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  803090:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803094:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803098:	48 89 c6             	mov    %rax,%rsi
  80309b:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  8030a2:	00 00 00 
  8030a5:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  8030ac:	00 00 00 
  8030af:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8030b1:	be 00 00 00 00       	mov    $0x0,%esi
  8030b6:	bf 04 00 00 00       	mov    $0x4,%edi
  8030bb:	48 b8 9a 2d 80 00 00 	movabs $0x802d9a,%rax
  8030c2:	00 00 00 
  8030c5:	ff d0                	callq  *%rax
  8030c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ce:	7f 20                	jg     8030f0 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8030d0:	48 bf 76 59 80 00 00 	movabs $0x805976,%rdi
  8030d7:	00 00 00 
  8030da:	b8 00 00 00 00       	mov    $0x0,%eax
  8030df:	48 ba 18 0c 80 00 00 	movabs $0x800c18,%rdx
  8030e6:	00 00 00 
  8030e9:	ff d2                	callq  *%rdx
		return r;
  8030eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ee:	eb 03                	jmp    8030f3 <devfile_write+0xcb>
	}
	return r;
  8030f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8030f3:	c9                   	leaveq 
  8030f4:	c3                   	retq   

00000000008030f5 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8030f5:	55                   	push   %rbp
  8030f6:	48 89 e5             	mov    %rsp,%rbp
  8030f9:	48 83 ec 20          	sub    $0x20,%rsp
  8030fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803101:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803105:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803109:	8b 50 0c             	mov    0xc(%rax),%edx
  80310c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803113:	00 00 00 
  803116:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803118:	be 00 00 00 00       	mov    $0x0,%esi
  80311d:	bf 05 00 00 00       	mov    $0x5,%edi
  803122:	48 b8 9a 2d 80 00 00 	movabs $0x802d9a,%rax
  803129:	00 00 00 
  80312c:	ff d0                	callq  *%rax
  80312e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803131:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803135:	79 05                	jns    80313c <devfile_stat+0x47>
		return r;
  803137:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313a:	eb 56                	jmp    803192 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80313c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803140:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803147:	00 00 00 
  80314a:	48 89 c7             	mov    %rax,%rdi
  80314d:	48 b8 cd 17 80 00 00 	movabs $0x8017cd,%rax
  803154:	00 00 00 
  803157:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803159:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803160:	00 00 00 
  803163:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803169:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80316d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803173:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80317a:	00 00 00 
  80317d:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803183:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803187:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80318d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803192:	c9                   	leaveq 
  803193:	c3                   	retq   

0000000000803194 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803194:	55                   	push   %rbp
  803195:	48 89 e5             	mov    %rsp,%rbp
  803198:	48 83 ec 10          	sub    $0x10,%rsp
  80319c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031a0:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8031a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031a7:	8b 50 0c             	mov    0xc(%rax),%edx
  8031aa:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031b1:	00 00 00 
  8031b4:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8031b6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031bd:	00 00 00 
  8031c0:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8031c3:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8031c6:	be 00 00 00 00       	mov    $0x0,%esi
  8031cb:	bf 02 00 00 00       	mov    $0x2,%edi
  8031d0:	48 b8 9a 2d 80 00 00 	movabs $0x802d9a,%rax
  8031d7:	00 00 00 
  8031da:	ff d0                	callq  *%rax
}
  8031dc:	c9                   	leaveq 
  8031dd:	c3                   	retq   

00000000008031de <remove>:

// Delete a file
int
remove(const char *path)
{
  8031de:	55                   	push   %rbp
  8031df:	48 89 e5             	mov    %rsp,%rbp
  8031e2:	48 83 ec 10          	sub    $0x10,%rsp
  8031e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8031ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031ee:	48 89 c7             	mov    %rax,%rdi
  8031f1:	48 b8 61 17 80 00 00 	movabs $0x801761,%rax
  8031f8:	00 00 00 
  8031fb:	ff d0                	callq  *%rax
  8031fd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803202:	7e 07                	jle    80320b <remove+0x2d>
		return -E_BAD_PATH;
  803204:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803209:	eb 33                	jmp    80323e <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80320b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80320f:	48 89 c6             	mov    %rax,%rsi
  803212:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803219:	00 00 00 
  80321c:	48 b8 cd 17 80 00 00 	movabs $0x8017cd,%rax
  803223:	00 00 00 
  803226:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803228:	be 00 00 00 00       	mov    $0x0,%esi
  80322d:	bf 07 00 00 00       	mov    $0x7,%edi
  803232:	48 b8 9a 2d 80 00 00 	movabs $0x802d9a,%rax
  803239:	00 00 00 
  80323c:	ff d0                	callq  *%rax
}
  80323e:	c9                   	leaveq 
  80323f:	c3                   	retq   

0000000000803240 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803240:	55                   	push   %rbp
  803241:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803244:	be 00 00 00 00       	mov    $0x0,%esi
  803249:	bf 08 00 00 00       	mov    $0x8,%edi
  80324e:	48 b8 9a 2d 80 00 00 	movabs $0x802d9a,%rax
  803255:	00 00 00 
  803258:	ff d0                	callq  *%rax
}
  80325a:	5d                   	pop    %rbp
  80325b:	c3                   	retq   

000000000080325c <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80325c:	55                   	push   %rbp
  80325d:	48 89 e5             	mov    %rsp,%rbp
  803260:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803267:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80326e:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803275:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80327c:	be 00 00 00 00       	mov    $0x0,%esi
  803281:	48 89 c7             	mov    %rax,%rdi
  803284:	48 b8 21 2e 80 00 00 	movabs $0x802e21,%rax
  80328b:	00 00 00 
  80328e:	ff d0                	callq  *%rax
  803290:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803293:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803297:	79 28                	jns    8032c1 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803299:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80329c:	89 c6                	mov    %eax,%esi
  80329e:	48 bf 92 59 80 00 00 	movabs $0x805992,%rdi
  8032a5:	00 00 00 
  8032a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ad:	48 ba 18 0c 80 00 00 	movabs $0x800c18,%rdx
  8032b4:	00 00 00 
  8032b7:	ff d2                	callq  *%rdx
		return fd_src;
  8032b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032bc:	e9 74 01 00 00       	jmpq   803435 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8032c1:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8032c8:	be 01 01 00 00       	mov    $0x101,%esi
  8032cd:	48 89 c7             	mov    %rax,%rdi
  8032d0:	48 b8 21 2e 80 00 00 	movabs $0x802e21,%rax
  8032d7:	00 00 00 
  8032da:	ff d0                	callq  *%rax
  8032dc:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8032df:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8032e3:	79 39                	jns    80331e <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8032e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032e8:	89 c6                	mov    %eax,%esi
  8032ea:	48 bf a8 59 80 00 00 	movabs $0x8059a8,%rdi
  8032f1:	00 00 00 
  8032f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8032f9:	48 ba 18 0c 80 00 00 	movabs $0x800c18,%rdx
  803300:	00 00 00 
  803303:	ff d2                	callq  *%rdx
		close(fd_src);
  803305:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803308:	89 c7                	mov    %eax,%edi
  80330a:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  803311:	00 00 00 
  803314:	ff d0                	callq  *%rax
		return fd_dest;
  803316:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803319:	e9 17 01 00 00       	jmpq   803435 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80331e:	eb 74                	jmp    803394 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803320:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803323:	48 63 d0             	movslq %eax,%rdx
  803326:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80332d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803330:	48 89 ce             	mov    %rcx,%rsi
  803333:	89 c7                	mov    %eax,%edi
  803335:	48 b8 95 2a 80 00 00 	movabs $0x802a95,%rax
  80333c:	00 00 00 
  80333f:	ff d0                	callq  *%rax
  803341:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803344:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803348:	79 4a                	jns    803394 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80334a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80334d:	89 c6                	mov    %eax,%esi
  80334f:	48 bf c2 59 80 00 00 	movabs $0x8059c2,%rdi
  803356:	00 00 00 
  803359:	b8 00 00 00 00       	mov    $0x0,%eax
  80335e:	48 ba 18 0c 80 00 00 	movabs $0x800c18,%rdx
  803365:	00 00 00 
  803368:	ff d2                	callq  *%rdx
			close(fd_src);
  80336a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80336d:	89 c7                	mov    %eax,%edi
  80336f:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  803376:	00 00 00 
  803379:	ff d0                	callq  *%rax
			close(fd_dest);
  80337b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80337e:	89 c7                	mov    %eax,%edi
  803380:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  803387:	00 00 00 
  80338a:	ff d0                	callq  *%rax
			return write_size;
  80338c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80338f:	e9 a1 00 00 00       	jmpq   803435 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803394:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80339b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80339e:	ba 00 02 00 00       	mov    $0x200,%edx
  8033a3:	48 89 ce             	mov    %rcx,%rsi
  8033a6:	89 c7                	mov    %eax,%edi
  8033a8:	48 b8 4b 29 80 00 00 	movabs $0x80294b,%rax
  8033af:	00 00 00 
  8033b2:	ff d0                	callq  *%rax
  8033b4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8033b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033bb:	0f 8f 5f ff ff ff    	jg     803320 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8033c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033c5:	79 47                	jns    80340e <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8033c7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033ca:	89 c6                	mov    %eax,%esi
  8033cc:	48 bf d5 59 80 00 00 	movabs $0x8059d5,%rdi
  8033d3:	00 00 00 
  8033d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8033db:	48 ba 18 0c 80 00 00 	movabs $0x800c18,%rdx
  8033e2:	00 00 00 
  8033e5:	ff d2                	callq  *%rdx
		close(fd_src);
  8033e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ea:	89 c7                	mov    %eax,%edi
  8033ec:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  8033f3:	00 00 00 
  8033f6:	ff d0                	callq  *%rax
		close(fd_dest);
  8033f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033fb:	89 c7                	mov    %eax,%edi
  8033fd:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  803404:	00 00 00 
  803407:	ff d0                	callq  *%rax
		return read_size;
  803409:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80340c:	eb 27                	jmp    803435 <copy+0x1d9>
	}
	close(fd_src);
  80340e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803411:	89 c7                	mov    %eax,%edi
  803413:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  80341a:	00 00 00 
  80341d:	ff d0                	callq  *%rax
	close(fd_dest);
  80341f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803422:	89 c7                	mov    %eax,%edi
  803424:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  80342b:	00 00 00 
  80342e:	ff d0                	callq  *%rax
	return 0;
  803430:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803435:	c9                   	leaveq 
  803436:	c3                   	retq   

0000000000803437 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803437:	55                   	push   %rbp
  803438:	48 89 e5             	mov    %rsp,%rbp
  80343b:	48 83 ec 20          	sub    $0x20,%rsp
  80343f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803442:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803446:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803449:	48 89 d6             	mov    %rdx,%rsi
  80344c:	89 c7                	mov    %eax,%edi
  80344e:	48 b8 19 25 80 00 00 	movabs $0x802519,%rax
  803455:	00 00 00 
  803458:	ff d0                	callq  *%rax
  80345a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80345d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803461:	79 05                	jns    803468 <fd2sockid+0x31>
		return r;
  803463:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803466:	eb 24                	jmp    80348c <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803468:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80346c:	8b 10                	mov    (%rax),%edx
  80346e:	48 b8 e0 70 80 00 00 	movabs $0x8070e0,%rax
  803475:	00 00 00 
  803478:	8b 00                	mov    (%rax),%eax
  80347a:	39 c2                	cmp    %eax,%edx
  80347c:	74 07                	je     803485 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80347e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803483:	eb 07                	jmp    80348c <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803485:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803489:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80348c:	c9                   	leaveq 
  80348d:	c3                   	retq   

000000000080348e <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80348e:	55                   	push   %rbp
  80348f:	48 89 e5             	mov    %rsp,%rbp
  803492:	48 83 ec 20          	sub    $0x20,%rsp
  803496:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803499:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80349d:	48 89 c7             	mov    %rax,%rdi
  8034a0:	48 b8 81 24 80 00 00 	movabs $0x802481,%rax
  8034a7:	00 00 00 
  8034aa:	ff d0                	callq  *%rax
  8034ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034b3:	78 26                	js     8034db <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8034b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034b9:	ba 07 04 00 00       	mov    $0x407,%edx
  8034be:	48 89 c6             	mov    %rax,%rsi
  8034c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8034c6:	48 b8 fc 20 80 00 00 	movabs $0x8020fc,%rax
  8034cd:	00 00 00 
  8034d0:	ff d0                	callq  *%rax
  8034d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034d9:	79 16                	jns    8034f1 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8034db:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034de:	89 c7                	mov    %eax,%edi
  8034e0:	48 b8 9b 39 80 00 00 	movabs $0x80399b,%rax
  8034e7:	00 00 00 
  8034ea:	ff d0                	callq  *%rax
		return r;
  8034ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ef:	eb 3a                	jmp    80352b <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8034f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034f5:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8034fc:	00 00 00 
  8034ff:	8b 12                	mov    (%rdx),%edx
  803501:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803503:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803507:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80350e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803512:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803515:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803518:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80351c:	48 89 c7             	mov    %rax,%rdi
  80351f:	48 b8 33 24 80 00 00 	movabs $0x802433,%rax
  803526:	00 00 00 
  803529:	ff d0                	callq  *%rax
}
  80352b:	c9                   	leaveq 
  80352c:	c3                   	retq   

000000000080352d <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80352d:	55                   	push   %rbp
  80352e:	48 89 e5             	mov    %rsp,%rbp
  803531:	48 83 ec 30          	sub    $0x30,%rsp
  803535:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803538:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80353c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803540:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803543:	89 c7                	mov    %eax,%edi
  803545:	48 b8 37 34 80 00 00 	movabs $0x803437,%rax
  80354c:	00 00 00 
  80354f:	ff d0                	callq  *%rax
  803551:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803554:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803558:	79 05                	jns    80355f <accept+0x32>
		return r;
  80355a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80355d:	eb 3b                	jmp    80359a <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80355f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803563:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803567:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80356a:	48 89 ce             	mov    %rcx,%rsi
  80356d:	89 c7                	mov    %eax,%edi
  80356f:	48 b8 78 38 80 00 00 	movabs $0x803878,%rax
  803576:	00 00 00 
  803579:	ff d0                	callq  *%rax
  80357b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80357e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803582:	79 05                	jns    803589 <accept+0x5c>
		return r;
  803584:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803587:	eb 11                	jmp    80359a <accept+0x6d>
	return alloc_sockfd(r);
  803589:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80358c:	89 c7                	mov    %eax,%edi
  80358e:	48 b8 8e 34 80 00 00 	movabs $0x80348e,%rax
  803595:	00 00 00 
  803598:	ff d0                	callq  *%rax
}
  80359a:	c9                   	leaveq 
  80359b:	c3                   	retq   

000000000080359c <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80359c:	55                   	push   %rbp
  80359d:	48 89 e5             	mov    %rsp,%rbp
  8035a0:	48 83 ec 20          	sub    $0x20,%rsp
  8035a4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035ab:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035b1:	89 c7                	mov    %eax,%edi
  8035b3:	48 b8 37 34 80 00 00 	movabs $0x803437,%rax
  8035ba:	00 00 00 
  8035bd:	ff d0                	callq  *%rax
  8035bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035c6:	79 05                	jns    8035cd <bind+0x31>
		return r;
  8035c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035cb:	eb 1b                	jmp    8035e8 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8035cd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035d0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8035d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d7:	48 89 ce             	mov    %rcx,%rsi
  8035da:	89 c7                	mov    %eax,%edi
  8035dc:	48 b8 f7 38 80 00 00 	movabs $0x8038f7,%rax
  8035e3:	00 00 00 
  8035e6:	ff d0                	callq  *%rax
}
  8035e8:	c9                   	leaveq 
  8035e9:	c3                   	retq   

00000000008035ea <shutdown>:

int
shutdown(int s, int how)
{
  8035ea:	55                   	push   %rbp
  8035eb:	48 89 e5             	mov    %rsp,%rbp
  8035ee:	48 83 ec 20          	sub    $0x20,%rsp
  8035f2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035f5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035f8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035fb:	89 c7                	mov    %eax,%edi
  8035fd:	48 b8 37 34 80 00 00 	movabs $0x803437,%rax
  803604:	00 00 00 
  803607:	ff d0                	callq  *%rax
  803609:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80360c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803610:	79 05                	jns    803617 <shutdown+0x2d>
		return r;
  803612:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803615:	eb 16                	jmp    80362d <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803617:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80361a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80361d:	89 d6                	mov    %edx,%esi
  80361f:	89 c7                	mov    %eax,%edi
  803621:	48 b8 5b 39 80 00 00 	movabs $0x80395b,%rax
  803628:	00 00 00 
  80362b:	ff d0                	callq  *%rax
}
  80362d:	c9                   	leaveq 
  80362e:	c3                   	retq   

000000000080362f <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80362f:	55                   	push   %rbp
  803630:	48 89 e5             	mov    %rsp,%rbp
  803633:	48 83 ec 10          	sub    $0x10,%rsp
  803637:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80363b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80363f:	48 89 c7             	mov    %rax,%rdi
  803642:	48 b8 33 4c 80 00 00 	movabs $0x804c33,%rax
  803649:	00 00 00 
  80364c:	ff d0                	callq  *%rax
  80364e:	83 f8 01             	cmp    $0x1,%eax
  803651:	75 17                	jne    80366a <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803653:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803657:	8b 40 0c             	mov    0xc(%rax),%eax
  80365a:	89 c7                	mov    %eax,%edi
  80365c:	48 b8 9b 39 80 00 00 	movabs $0x80399b,%rax
  803663:	00 00 00 
  803666:	ff d0                	callq  *%rax
  803668:	eb 05                	jmp    80366f <devsock_close+0x40>
	else
		return 0;
  80366a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80366f:	c9                   	leaveq 
  803670:	c3                   	retq   

0000000000803671 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803671:	55                   	push   %rbp
  803672:	48 89 e5             	mov    %rsp,%rbp
  803675:	48 83 ec 20          	sub    $0x20,%rsp
  803679:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80367c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803680:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803683:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803686:	89 c7                	mov    %eax,%edi
  803688:	48 b8 37 34 80 00 00 	movabs $0x803437,%rax
  80368f:	00 00 00 
  803692:	ff d0                	callq  *%rax
  803694:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803697:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80369b:	79 05                	jns    8036a2 <connect+0x31>
		return r;
  80369d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a0:	eb 1b                	jmp    8036bd <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8036a2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036a5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8036a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ac:	48 89 ce             	mov    %rcx,%rsi
  8036af:	89 c7                	mov    %eax,%edi
  8036b1:	48 b8 c8 39 80 00 00 	movabs $0x8039c8,%rax
  8036b8:	00 00 00 
  8036bb:	ff d0                	callq  *%rax
}
  8036bd:	c9                   	leaveq 
  8036be:	c3                   	retq   

00000000008036bf <listen>:

int
listen(int s, int backlog)
{
  8036bf:	55                   	push   %rbp
  8036c0:	48 89 e5             	mov    %rsp,%rbp
  8036c3:	48 83 ec 20          	sub    $0x20,%rsp
  8036c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036ca:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036d0:	89 c7                	mov    %eax,%edi
  8036d2:	48 b8 37 34 80 00 00 	movabs $0x803437,%rax
  8036d9:	00 00 00 
  8036dc:	ff d0                	callq  *%rax
  8036de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036e5:	79 05                	jns    8036ec <listen+0x2d>
		return r;
  8036e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ea:	eb 16                	jmp    803702 <listen+0x43>
	return nsipc_listen(r, backlog);
  8036ec:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036f2:	89 d6                	mov    %edx,%esi
  8036f4:	89 c7                	mov    %eax,%edi
  8036f6:	48 b8 2c 3a 80 00 00 	movabs $0x803a2c,%rax
  8036fd:	00 00 00 
  803700:	ff d0                	callq  *%rax
}
  803702:	c9                   	leaveq 
  803703:	c3                   	retq   

0000000000803704 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803704:	55                   	push   %rbp
  803705:	48 89 e5             	mov    %rsp,%rbp
  803708:	48 83 ec 20          	sub    $0x20,%rsp
  80370c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803710:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803714:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803718:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80371c:	89 c2                	mov    %eax,%edx
  80371e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803722:	8b 40 0c             	mov    0xc(%rax),%eax
  803725:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803729:	b9 00 00 00 00       	mov    $0x0,%ecx
  80372e:	89 c7                	mov    %eax,%edi
  803730:	48 b8 6c 3a 80 00 00 	movabs $0x803a6c,%rax
  803737:	00 00 00 
  80373a:	ff d0                	callq  *%rax
}
  80373c:	c9                   	leaveq 
  80373d:	c3                   	retq   

000000000080373e <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80373e:	55                   	push   %rbp
  80373f:	48 89 e5             	mov    %rsp,%rbp
  803742:	48 83 ec 20          	sub    $0x20,%rsp
  803746:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80374a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80374e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803752:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803756:	89 c2                	mov    %eax,%edx
  803758:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80375c:	8b 40 0c             	mov    0xc(%rax),%eax
  80375f:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803763:	b9 00 00 00 00       	mov    $0x0,%ecx
  803768:	89 c7                	mov    %eax,%edi
  80376a:	48 b8 38 3b 80 00 00 	movabs $0x803b38,%rax
  803771:	00 00 00 
  803774:	ff d0                	callq  *%rax
}
  803776:	c9                   	leaveq 
  803777:	c3                   	retq   

0000000000803778 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803778:	55                   	push   %rbp
  803779:	48 89 e5             	mov    %rsp,%rbp
  80377c:	48 83 ec 10          	sub    $0x10,%rsp
  803780:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803784:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803788:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80378c:	48 be f0 59 80 00 00 	movabs $0x8059f0,%rsi
  803793:	00 00 00 
  803796:	48 89 c7             	mov    %rax,%rdi
  803799:	48 b8 cd 17 80 00 00 	movabs $0x8017cd,%rax
  8037a0:	00 00 00 
  8037a3:	ff d0                	callq  *%rax
	return 0;
  8037a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037aa:	c9                   	leaveq 
  8037ab:	c3                   	retq   

00000000008037ac <socket>:

int
socket(int domain, int type, int protocol)
{
  8037ac:	55                   	push   %rbp
  8037ad:	48 89 e5             	mov    %rsp,%rbp
  8037b0:	48 83 ec 20          	sub    $0x20,%rsp
  8037b4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037b7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8037ba:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8037bd:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8037c0:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8037c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037c6:	89 ce                	mov    %ecx,%esi
  8037c8:	89 c7                	mov    %eax,%edi
  8037ca:	48 b8 f0 3b 80 00 00 	movabs $0x803bf0,%rax
  8037d1:	00 00 00 
  8037d4:	ff d0                	callq  *%rax
  8037d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037dd:	79 05                	jns    8037e4 <socket+0x38>
		return r;
  8037df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e2:	eb 11                	jmp    8037f5 <socket+0x49>
	return alloc_sockfd(r);
  8037e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e7:	89 c7                	mov    %eax,%edi
  8037e9:	48 b8 8e 34 80 00 00 	movabs $0x80348e,%rax
  8037f0:	00 00 00 
  8037f3:	ff d0                	callq  *%rax
}
  8037f5:	c9                   	leaveq 
  8037f6:	c3                   	retq   

00000000008037f7 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8037f7:	55                   	push   %rbp
  8037f8:	48 89 e5             	mov    %rsp,%rbp
  8037fb:	48 83 ec 10          	sub    $0x10,%rsp
  8037ff:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803802:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803809:	00 00 00 
  80380c:	8b 00                	mov    (%rax),%eax
  80380e:	85 c0                	test   %eax,%eax
  803810:	75 1d                	jne    80382f <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803812:	bf 02 00 00 00       	mov    $0x2,%edi
  803817:	48 b8 b1 4b 80 00 00 	movabs $0x804bb1,%rax
  80381e:	00 00 00 
  803821:	ff d0                	callq  *%rax
  803823:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  80382a:	00 00 00 
  80382d:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80382f:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803836:	00 00 00 
  803839:	8b 00                	mov    (%rax),%eax
  80383b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80383e:	b9 07 00 00 00       	mov    $0x7,%ecx
  803843:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  80384a:	00 00 00 
  80384d:	89 c7                	mov    %eax,%edi
  80384f:	48 b8 4f 4b 80 00 00 	movabs $0x804b4f,%rax
  803856:	00 00 00 
  803859:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80385b:	ba 00 00 00 00       	mov    $0x0,%edx
  803860:	be 00 00 00 00       	mov    $0x0,%esi
  803865:	bf 00 00 00 00       	mov    $0x0,%edi
  80386a:	48 b8 49 4a 80 00 00 	movabs $0x804a49,%rax
  803871:	00 00 00 
  803874:	ff d0                	callq  *%rax
}
  803876:	c9                   	leaveq 
  803877:	c3                   	retq   

0000000000803878 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803878:	55                   	push   %rbp
  803879:	48 89 e5             	mov    %rsp,%rbp
  80387c:	48 83 ec 30          	sub    $0x30,%rsp
  803880:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803883:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803887:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80388b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803892:	00 00 00 
  803895:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803898:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80389a:	bf 01 00 00 00       	mov    $0x1,%edi
  80389f:	48 b8 f7 37 80 00 00 	movabs $0x8037f7,%rax
  8038a6:	00 00 00 
  8038a9:	ff d0                	callq  *%rax
  8038ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038b2:	78 3e                	js     8038f2 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8038b4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8038bb:	00 00 00 
  8038be:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8038c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038c6:	8b 40 10             	mov    0x10(%rax),%eax
  8038c9:	89 c2                	mov    %eax,%edx
  8038cb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8038cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038d3:	48 89 ce             	mov    %rcx,%rsi
  8038d6:	48 89 c7             	mov    %rax,%rdi
  8038d9:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  8038e0:	00 00 00 
  8038e3:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8038e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038e9:	8b 50 10             	mov    0x10(%rax),%edx
  8038ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038f0:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8038f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8038f5:	c9                   	leaveq 
  8038f6:	c3                   	retq   

00000000008038f7 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8038f7:	55                   	push   %rbp
  8038f8:	48 89 e5             	mov    %rsp,%rbp
  8038fb:	48 83 ec 10          	sub    $0x10,%rsp
  8038ff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803902:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803906:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803909:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803910:	00 00 00 
  803913:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803916:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803918:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80391b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80391f:	48 89 c6             	mov    %rax,%rsi
  803922:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803929:	00 00 00 
  80392c:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  803933:	00 00 00 
  803936:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803938:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80393f:	00 00 00 
  803942:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803945:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803948:	bf 02 00 00 00       	mov    $0x2,%edi
  80394d:	48 b8 f7 37 80 00 00 	movabs $0x8037f7,%rax
  803954:	00 00 00 
  803957:	ff d0                	callq  *%rax
}
  803959:	c9                   	leaveq 
  80395a:	c3                   	retq   

000000000080395b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80395b:	55                   	push   %rbp
  80395c:	48 89 e5             	mov    %rsp,%rbp
  80395f:	48 83 ec 10          	sub    $0x10,%rsp
  803963:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803966:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803969:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803970:	00 00 00 
  803973:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803976:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803978:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80397f:	00 00 00 
  803982:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803985:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803988:	bf 03 00 00 00       	mov    $0x3,%edi
  80398d:	48 b8 f7 37 80 00 00 	movabs $0x8037f7,%rax
  803994:	00 00 00 
  803997:	ff d0                	callq  *%rax
}
  803999:	c9                   	leaveq 
  80399a:	c3                   	retq   

000000000080399b <nsipc_close>:

int
nsipc_close(int s)
{
  80399b:	55                   	push   %rbp
  80399c:	48 89 e5             	mov    %rsp,%rbp
  80399f:	48 83 ec 10          	sub    $0x10,%rsp
  8039a3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8039a6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039ad:	00 00 00 
  8039b0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039b3:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8039b5:	bf 04 00 00 00       	mov    $0x4,%edi
  8039ba:	48 b8 f7 37 80 00 00 	movabs $0x8037f7,%rax
  8039c1:	00 00 00 
  8039c4:	ff d0                	callq  *%rax
}
  8039c6:	c9                   	leaveq 
  8039c7:	c3                   	retq   

00000000008039c8 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8039c8:	55                   	push   %rbp
  8039c9:	48 89 e5             	mov    %rsp,%rbp
  8039cc:	48 83 ec 10          	sub    $0x10,%rsp
  8039d0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039d7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8039da:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039e1:	00 00 00 
  8039e4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039e7:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8039e9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f0:	48 89 c6             	mov    %rax,%rsi
  8039f3:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8039fa:	00 00 00 
  8039fd:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  803a04:	00 00 00 
  803a07:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803a09:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a10:	00 00 00 
  803a13:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a16:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803a19:	bf 05 00 00 00       	mov    $0x5,%edi
  803a1e:	48 b8 f7 37 80 00 00 	movabs $0x8037f7,%rax
  803a25:	00 00 00 
  803a28:	ff d0                	callq  *%rax
}
  803a2a:	c9                   	leaveq 
  803a2b:	c3                   	retq   

0000000000803a2c <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803a2c:	55                   	push   %rbp
  803a2d:	48 89 e5             	mov    %rsp,%rbp
  803a30:	48 83 ec 10          	sub    $0x10,%rsp
  803a34:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a37:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803a3a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a41:	00 00 00 
  803a44:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a47:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803a49:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a50:	00 00 00 
  803a53:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a56:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803a59:	bf 06 00 00 00       	mov    $0x6,%edi
  803a5e:	48 b8 f7 37 80 00 00 	movabs $0x8037f7,%rax
  803a65:	00 00 00 
  803a68:	ff d0                	callq  *%rax
}
  803a6a:	c9                   	leaveq 
  803a6b:	c3                   	retq   

0000000000803a6c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803a6c:	55                   	push   %rbp
  803a6d:	48 89 e5             	mov    %rsp,%rbp
  803a70:	48 83 ec 30          	sub    $0x30,%rsp
  803a74:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a77:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a7b:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803a7e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803a81:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a88:	00 00 00 
  803a8b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a8e:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803a90:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a97:	00 00 00 
  803a9a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a9d:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803aa0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803aa7:	00 00 00 
  803aaa:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803aad:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803ab0:	bf 07 00 00 00       	mov    $0x7,%edi
  803ab5:	48 b8 f7 37 80 00 00 	movabs $0x8037f7,%rax
  803abc:	00 00 00 
  803abf:	ff d0                	callq  *%rax
  803ac1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ac4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ac8:	78 69                	js     803b33 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803aca:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803ad1:	7f 08                	jg     803adb <nsipc_recv+0x6f>
  803ad3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad6:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803ad9:	7e 35                	jle    803b10 <nsipc_recv+0xa4>
  803adb:	48 b9 f7 59 80 00 00 	movabs $0x8059f7,%rcx
  803ae2:	00 00 00 
  803ae5:	48 ba 0c 5a 80 00 00 	movabs $0x805a0c,%rdx
  803aec:	00 00 00 
  803aef:	be 61 00 00 00       	mov    $0x61,%esi
  803af4:	48 bf 21 5a 80 00 00 	movabs $0x805a21,%rdi
  803afb:	00 00 00 
  803afe:	b8 00 00 00 00       	mov    $0x0,%eax
  803b03:	49 b8 df 09 80 00 00 	movabs $0x8009df,%r8
  803b0a:	00 00 00 
  803b0d:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803b10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b13:	48 63 d0             	movslq %eax,%rdx
  803b16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b1a:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803b21:	00 00 00 
  803b24:	48 89 c7             	mov    %rax,%rdi
  803b27:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  803b2e:	00 00 00 
  803b31:	ff d0                	callq  *%rax
	}

	return r;
  803b33:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b36:	c9                   	leaveq 
  803b37:	c3                   	retq   

0000000000803b38 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803b38:	55                   	push   %rbp
  803b39:	48 89 e5             	mov    %rsp,%rbp
  803b3c:	48 83 ec 20          	sub    $0x20,%rsp
  803b40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b47:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803b4a:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803b4d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b54:	00 00 00 
  803b57:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b5a:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803b5c:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803b63:	7e 35                	jle    803b9a <nsipc_send+0x62>
  803b65:	48 b9 2d 5a 80 00 00 	movabs $0x805a2d,%rcx
  803b6c:	00 00 00 
  803b6f:	48 ba 0c 5a 80 00 00 	movabs $0x805a0c,%rdx
  803b76:	00 00 00 
  803b79:	be 6c 00 00 00       	mov    $0x6c,%esi
  803b7e:	48 bf 21 5a 80 00 00 	movabs $0x805a21,%rdi
  803b85:	00 00 00 
  803b88:	b8 00 00 00 00       	mov    $0x0,%eax
  803b8d:	49 b8 df 09 80 00 00 	movabs $0x8009df,%r8
  803b94:	00 00 00 
  803b97:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803b9a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b9d:	48 63 d0             	movslq %eax,%rdx
  803ba0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba4:	48 89 c6             	mov    %rax,%rsi
  803ba7:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803bae:	00 00 00 
  803bb1:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  803bb8:	00 00 00 
  803bbb:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803bbd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bc4:	00 00 00 
  803bc7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bca:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803bcd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bd4:	00 00 00 
  803bd7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803bda:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803bdd:	bf 08 00 00 00       	mov    $0x8,%edi
  803be2:	48 b8 f7 37 80 00 00 	movabs $0x8037f7,%rax
  803be9:	00 00 00 
  803bec:	ff d0                	callq  *%rax
}
  803bee:	c9                   	leaveq 
  803bef:	c3                   	retq   

0000000000803bf0 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803bf0:	55                   	push   %rbp
  803bf1:	48 89 e5             	mov    %rsp,%rbp
  803bf4:	48 83 ec 10          	sub    $0x10,%rsp
  803bf8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bfb:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803bfe:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803c01:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c08:	00 00 00 
  803c0b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c0e:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803c10:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c17:	00 00 00 
  803c1a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c1d:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803c20:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c27:	00 00 00 
  803c2a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803c2d:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803c30:	bf 09 00 00 00       	mov    $0x9,%edi
  803c35:	48 b8 f7 37 80 00 00 	movabs $0x8037f7,%rax
  803c3c:	00 00 00 
  803c3f:	ff d0                	callq  *%rax
}
  803c41:	c9                   	leaveq 
  803c42:	c3                   	retq   

0000000000803c43 <isfree>:
static uint8_t *mend   = (uint8_t*) 0x10000000;
static uint8_t *mptr;

static int
isfree(void *v, size_t n)
{
  803c43:	55                   	push   %rbp
  803c44:	48 89 e5             	mov    %rsp,%rbp
  803c47:	48 83 ec 20          	sub    $0x20,%rsp
  803c4b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c4f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	uintptr_t va, end_va = (uintptr_t) v + n;
  803c53:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c57:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c5b:	48 01 d0             	add    %rdx,%rax
  803c5e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  803c62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c66:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803c6a:	eb 64                	jmp    803cd0 <isfree+0x8d>
		if (va >= (uintptr_t) mend
  803c6c:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  803c73:	00 00 00 
  803c76:	48 8b 00             	mov    (%rax),%rax
  803c79:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803c7d:	76 42                	jbe    803cc1 <isfree+0x7e>
		    || ((uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  803c7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c83:	48 c1 e8 15          	shr    $0x15,%rax
  803c87:	48 89 c2             	mov    %rax,%rdx
  803c8a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c91:	01 00 00 
  803c94:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c98:	83 e0 01             	and    $0x1,%eax
  803c9b:	48 85 c0             	test   %rax,%rax
  803c9e:	74 28                	je     803cc8 <isfree+0x85>
  803ca0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ca4:	48 c1 e8 0c          	shr    $0xc,%rax
  803ca8:	48 89 c2             	mov    %rax,%rdx
  803cab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803cb2:	01 00 00 
  803cb5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803cb9:	83 e0 01             	and    $0x1,%eax
  803cbc:	48 85 c0             	test   %rax,%rax
  803cbf:	74 07                	je     803cc8 <isfree+0x85>
			return 0;
  803cc1:	b8 00 00 00 00       	mov    $0x0,%eax
  803cc6:	eb 17                	jmp    803cdf <isfree+0x9c>
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  803cc8:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803ccf:	00 
  803cd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cd4:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803cd8:	72 92                	jb     803c6c <isfree+0x29>
		if (va >= (uintptr_t) mend
		    || ((uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
			return 0;
	return 1;
  803cda:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803cdf:	c9                   	leaveq 
  803ce0:	c3                   	retq   

0000000000803ce1 <malloc>:

void*
malloc(size_t n)
{
  803ce1:	55                   	push   %rbp
  803ce2:	48 89 e5             	mov    %rsp,%rbp
  803ce5:	48 83 ec 60          	sub    $0x60,%rsp
  803ce9:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	int i, cont;
	int nwrap;
	uint32_t *ref;
	void *v;

	if (mptr == 0)
  803ced:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803cf4:	00 00 00 
  803cf7:	48 8b 00             	mov    (%rax),%rax
  803cfa:	48 85 c0             	test   %rax,%rax
  803cfd:	75 1a                	jne    803d19 <malloc+0x38>
		mptr = mbegin;
  803cff:	48 b8 18 71 80 00 00 	movabs $0x807118,%rax
  803d06:	00 00 00 
  803d09:	48 8b 10             	mov    (%rax),%rdx
  803d0c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803d13:	00 00 00 
  803d16:	48 89 10             	mov    %rdx,(%rax)

	n = ROUNDUP(n, 4);
  803d19:	48 c7 45 f0 04 00 00 	movq   $0x4,-0x10(%rbp)
  803d20:	00 
  803d21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d25:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803d29:	48 01 d0             	add    %rdx,%rax
  803d2c:	48 83 e8 01          	sub    $0x1,%rax
  803d30:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803d34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d38:	ba 00 00 00 00       	mov    $0x0,%edx
  803d3d:	48 f7 75 f0          	divq   -0x10(%rbp)
  803d41:	48 89 d0             	mov    %rdx,%rax
  803d44:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803d48:	48 29 c2             	sub    %rax,%rdx
  803d4b:	48 89 d0             	mov    %rdx,%rax
  803d4e:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	if (n >= MAXMALLOC)
  803d52:	48 81 7d a8 ff ff 0f 	cmpq   $0xfffff,-0x58(%rbp)
  803d59:	00 
  803d5a:	76 0a                	jbe    803d66 <malloc+0x85>
		return 0;
  803d5c:	b8 00 00 00 00       	mov    $0x0,%eax
  803d61:	e9 f7 02 00 00       	jmpq   80405d <malloc+0x37c>

	if ((uintptr_t) mptr % PGSIZE){
  803d66:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803d6d:	00 00 00 
  803d70:	48 8b 00             	mov    (%rax),%rax
  803d73:	25 ff 0f 00 00       	and    $0xfff,%eax
  803d78:	48 85 c0             	test   %rax,%rax
  803d7b:	0f 84 15 01 00 00    	je     803e96 <malloc+0x1b5>
		/*
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  803d81:	48 c7 45 e0 00 10 00 	movq   $0x1000,-0x20(%rbp)
  803d88:	00 
  803d89:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803d90:	00 00 00 
  803d93:	48 8b 00             	mov    (%rax),%rax
  803d96:	48 89 c2             	mov    %rax,%rdx
  803d99:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d9d:	48 01 d0             	add    %rdx,%rax
  803da0:	48 83 e8 01          	sub    $0x1,%rax
  803da4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803da8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dac:	ba 00 00 00 00       	mov    $0x0,%edx
  803db1:	48 f7 75 e0          	divq   -0x20(%rbp)
  803db5:	48 89 d0             	mov    %rdx,%rax
  803db8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803dbc:	48 29 c2             	sub    %rax,%rdx
  803dbf:	48 89 d0             	mov    %rdx,%rax
  803dc2:	48 83 e8 04          	sub    $0x4,%rax
  803dc6:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  803dca:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803dd1:	00 00 00 
  803dd4:	48 8b 00             	mov    (%rax),%rax
  803dd7:	48 c1 e8 0c          	shr    $0xc,%rax
  803ddb:	48 89 c1             	mov    %rax,%rcx
  803dde:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803de5:	00 00 00 
  803de8:	48 8b 00             	mov    (%rax),%rax
  803deb:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803def:	48 83 c2 03          	add    $0x3,%rdx
  803df3:	48 01 d0             	add    %rdx,%rax
  803df6:	48 c1 e8 0c          	shr    $0xc,%rax
  803dfa:	48 39 c1             	cmp    %rax,%rcx
  803dfd:	75 4a                	jne    803e49 <malloc+0x168>
			(*ref)++;
  803dff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e03:	8b 00                	mov    (%rax),%eax
  803e05:	8d 50 01             	lea    0x1(%rax),%edx
  803e08:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e0c:	89 10                	mov    %edx,(%rax)
			v = mptr;
  803e0e:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803e15:	00 00 00 
  803e18:	48 8b 00             	mov    (%rax),%rax
  803e1b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
			mptr += n;
  803e1f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803e26:	00 00 00 
  803e29:	48 8b 10             	mov    (%rax),%rdx
  803e2c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803e30:	48 01 c2             	add    %rax,%rdx
  803e33:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803e3a:	00 00 00 
  803e3d:	48 89 10             	mov    %rdx,(%rax)
			return v;
  803e40:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e44:	e9 14 02 00 00       	jmpq   80405d <malloc+0x37c>
		}
		/*
		 * stop working on this page and move on.
		 */
		free(mptr);	/* drop reference to this page */
  803e49:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803e50:	00 00 00 
  803e53:	48 8b 00             	mov    (%rax),%rax
  803e56:	48 89 c7             	mov    %rax,%rdi
  803e59:	48 b8 5f 40 80 00 00 	movabs $0x80405f,%rax
  803e60:	00 00 00 
  803e63:	ff d0                	callq  *%rax
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  803e65:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803e6c:	00 00 00 
  803e6f:	48 8b 00             	mov    (%rax),%rax
  803e72:	48 05 00 10 00 00    	add    $0x1000,%rax
  803e78:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803e7c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803e80:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803e86:	48 89 c2             	mov    %rax,%rdx
  803e89:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803e90:	00 00 00 
  803e93:	48 89 10             	mov    %rdx,(%rax)
	 * now we need to find some address space for this chunk.
	 * if it's less than a page we leave it open for allocation.
	 * runs of more than a page can't have ref counts so we
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
  803e96:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	while (1) {
		if (isfree(mptr, n + 4))
  803e9d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803ea1:	48 8d 50 04          	lea    0x4(%rax),%rdx
  803ea5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803eac:	00 00 00 
  803eaf:	48 8b 00             	mov    (%rax),%rax
  803eb2:	48 89 d6             	mov    %rdx,%rsi
  803eb5:	48 89 c7             	mov    %rax,%rdi
  803eb8:	48 b8 43 3c 80 00 00 	movabs $0x803c43,%rax
  803ebf:	00 00 00 
  803ec2:	ff d0                	callq  *%rax
  803ec4:	85 c0                	test   %eax,%eax
  803ec6:	74 0d                	je     803ed5 <malloc+0x1f4>
			break;
  803ec8:	90                   	nop
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  803ec9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ed0:	e9 14 01 00 00       	jmpq   803fe9 <malloc+0x308>
	 */
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
			break;
		mptr += PGSIZE;
  803ed5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803edc:	00 00 00 
  803edf:	48 8b 00             	mov    (%rax),%rax
  803ee2:	48 8d 90 00 10 00 00 	lea    0x1000(%rax),%rdx
  803ee9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803ef0:	00 00 00 
  803ef3:	48 89 10             	mov    %rdx,(%rax)
		if (mptr == mend) {
  803ef6:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803efd:	00 00 00 
  803f00:	48 8b 10             	mov    (%rax),%rdx
  803f03:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  803f0a:	00 00 00 
  803f0d:	48 8b 00             	mov    (%rax),%rax
  803f10:	48 39 c2             	cmp    %rax,%rdx
  803f13:	75 2e                	jne    803f43 <malloc+0x262>
			mptr = mbegin;
  803f15:	48 b8 18 71 80 00 00 	movabs $0x807118,%rax
  803f1c:	00 00 00 
  803f1f:	48 8b 10             	mov    (%rax),%rdx
  803f22:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803f29:	00 00 00 
  803f2c:	48 89 10             	mov    %rdx,(%rax)
			if (++nwrap == 2)
  803f2f:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  803f33:	83 7d f8 02          	cmpl   $0x2,-0x8(%rbp)
  803f37:	75 0a                	jne    803f43 <malloc+0x262>
				return 0;	/* out of address space */
  803f39:	b8 00 00 00 00       	mov    $0x0,%eax
  803f3e:	e9 1a 01 00 00       	jmpq   80405d <malloc+0x37c>
		}
	}
  803f43:	e9 55 ff ff ff       	jmpq   803e9d <malloc+0x1bc>

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  803f48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f4b:	05 00 10 00 00       	add    $0x1000,%eax
  803f50:	48 98                	cltq   
  803f52:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803f56:	48 83 c2 04          	add    $0x4,%rdx
  803f5a:	48 39 d0             	cmp    %rdx,%rax
  803f5d:	73 07                	jae    803f66 <malloc+0x285>
  803f5f:	b8 00 04 00 00       	mov    $0x400,%eax
  803f64:	eb 05                	jmp    803f6b <malloc+0x28a>
  803f66:	b8 00 00 00 00       	mov    $0x0,%eax
  803f6b:	89 45 bc             	mov    %eax,-0x44(%rbp)
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  803f6e:	8b 45 bc             	mov    -0x44(%rbp),%eax
  803f71:	83 c8 07             	or     $0x7,%eax
  803f74:	89 c2                	mov    %eax,%edx
  803f76:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803f7d:	00 00 00 
  803f80:	48 8b 08             	mov    (%rax),%rcx
  803f83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f86:	48 98                	cltq   
  803f88:	48 01 c8             	add    %rcx,%rax
  803f8b:	48 89 c6             	mov    %rax,%rsi
  803f8e:	bf 00 00 00 00       	mov    $0x0,%edi
  803f93:	48 b8 fc 20 80 00 00 	movabs $0x8020fc,%rax
  803f9a:	00 00 00 
  803f9d:	ff d0                	callq  *%rax
  803f9f:	85 c0                	test   %eax,%eax
  803fa1:	79 3f                	jns    803fe2 <malloc+0x301>
			for (; i >= 0; i -= PGSIZE)
  803fa3:	eb 30                	jmp    803fd5 <malloc+0x2f4>
				sys_page_unmap(0, mptr + i);
  803fa5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803fac:	00 00 00 
  803faf:	48 8b 10             	mov    (%rax),%rdx
  803fb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fb5:	48 98                	cltq   
  803fb7:	48 01 d0             	add    %rdx,%rax
  803fba:	48 89 c6             	mov    %rax,%rsi
  803fbd:	bf 00 00 00 00       	mov    $0x0,%edi
  803fc2:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  803fc9:	00 00 00 
  803fcc:	ff d0                	callq  *%rax
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
			for (; i >= 0; i -= PGSIZE)
  803fce:	81 6d fc 00 10 00 00 	subl   $0x1000,-0x4(%rbp)
  803fd5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fd9:	79 ca                	jns    803fa5 <malloc+0x2c4>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
  803fdb:	b8 00 00 00 00       	mov    $0x0,%eax
  803fe0:	eb 7b                	jmp    80405d <malloc+0x37c>
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  803fe2:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803fe9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fec:	48 98                	cltq   
  803fee:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803ff2:	48 83 c2 04          	add    $0x4,%rdx
  803ff6:	48 39 d0             	cmp    %rdx,%rax
  803ff9:	0f 82 49 ff ff ff    	jb     803f48 <malloc+0x267>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
		}
	}

	ref = (uint32_t*) (mptr + i - 4);
  803fff:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804006:	00 00 00 
  804009:	48 8b 00             	mov    (%rax),%rax
  80400c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80400f:	48 63 d2             	movslq %edx,%rdx
  804012:	48 83 ea 04          	sub    $0x4,%rdx
  804016:	48 01 d0             	add    %rdx,%rax
  804019:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	*ref = 2;	/* reference for mptr, reference for returned block */
  80401d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804021:	c7 00 02 00 00 00    	movl   $0x2,(%rax)
	v = mptr;
  804027:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80402e:	00 00 00 
  804031:	48 8b 00             	mov    (%rax),%rax
  804034:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	mptr += n;
  804038:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80403f:	00 00 00 
  804042:	48 8b 10             	mov    (%rax),%rdx
  804045:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804049:	48 01 c2             	add    %rax,%rdx
  80404c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804053:	00 00 00 
  804056:	48 89 10             	mov    %rdx,(%rax)
	return v;
  804059:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
}
  80405d:	c9                   	leaveq 
  80405e:	c3                   	retq   

000000000080405f <free>:

void
free(void *v)
{
  80405f:	55                   	push   %rbp
  804060:	48 89 e5             	mov    %rsp,%rbp
  804063:	48 83 ec 30          	sub    $0x30,%rsp
  804067:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  80406b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804070:	75 05                	jne    804077 <free+0x18>
		return;
  804072:	e9 54 01 00 00       	jmpq   8041cb <free+0x16c>
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  804077:	48 b8 18 71 80 00 00 	movabs $0x807118,%rax
  80407e:	00 00 00 
  804081:	48 8b 00             	mov    (%rax),%rax
  804084:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  804088:	77 13                	ja     80409d <free+0x3e>
  80408a:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804091:	00 00 00 
  804094:	48 8b 00             	mov    (%rax),%rax
  804097:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80409b:	72 35                	jb     8040d2 <free+0x73>
  80409d:	48 b9 40 5a 80 00 00 	movabs $0x805a40,%rcx
  8040a4:	00 00 00 
  8040a7:	48 ba 6e 5a 80 00 00 	movabs $0x805a6e,%rdx
  8040ae:	00 00 00 
  8040b1:	be 7a 00 00 00       	mov    $0x7a,%esi
  8040b6:	48 bf 83 5a 80 00 00 	movabs $0x805a83,%rdi
  8040bd:	00 00 00 
  8040c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8040c5:	49 b8 df 09 80 00 00 	movabs $0x8009df,%r8
  8040cc:	00 00 00 
  8040cf:	41 ff d0             	callq  *%r8

	c = ROUNDDOWN(v, PGSIZE);
  8040d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040d6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8040da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040de:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8040e4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  8040e8:	eb 7b                	jmp    804165 <free+0x106>
		sys_page_unmap(0, c);
  8040ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040ee:	48 89 c6             	mov    %rax,%rsi
  8040f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8040f6:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  8040fd:	00 00 00 
  804100:	ff d0                	callq  *%rax
		c += PGSIZE;
  804102:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  804109:	00 
		assert(mbegin <= c && c < mend);
  80410a:	48 b8 18 71 80 00 00 	movabs $0x807118,%rax
  804111:	00 00 00 
  804114:	48 8b 00             	mov    (%rax),%rax
  804117:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80411b:	77 13                	ja     804130 <free+0xd1>
  80411d:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804124:	00 00 00 
  804127:	48 8b 00             	mov    (%rax),%rax
  80412a:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80412e:	72 35                	jb     804165 <free+0x106>
  804130:	48 b9 90 5a 80 00 00 	movabs $0x805a90,%rcx
  804137:	00 00 00 
  80413a:	48 ba 6e 5a 80 00 00 	movabs $0x805a6e,%rdx
  804141:	00 00 00 
  804144:	be 81 00 00 00       	mov    $0x81,%esi
  804149:	48 bf 83 5a 80 00 00 	movabs $0x805a83,%rdi
  804150:	00 00 00 
  804153:	b8 00 00 00 00       	mov    $0x0,%eax
  804158:	49 b8 df 09 80 00 00 	movabs $0x8009df,%r8
  80415f:	00 00 00 
  804162:	41 ff d0             	callq  *%r8
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);

	c = ROUNDDOWN(v, PGSIZE);

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  804165:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804169:	48 c1 e8 0c          	shr    $0xc,%rax
  80416d:	48 89 c2             	mov    %rax,%rdx
  804170:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804177:	01 00 00 
  80417a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80417e:	25 00 04 00 00       	and    $0x400,%eax
  804183:	48 85 c0             	test   %rax,%rax
  804186:	0f 85 5e ff ff ff    	jne    8040ea <free+0x8b>

	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
  80418c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804190:	48 05 fc 0f 00 00    	add    $0xffc,%rax
  804196:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (--(*ref) == 0)
  80419a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80419e:	8b 00                	mov    (%rax),%eax
  8041a0:	8d 50 ff             	lea    -0x1(%rax),%edx
  8041a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041a7:	89 10                	mov    %edx,(%rax)
  8041a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041ad:	8b 00                	mov    (%rax),%eax
  8041af:	85 c0                	test   %eax,%eax
  8041b1:	75 18                	jne    8041cb <free+0x16c>
		sys_page_unmap(0, c);
  8041b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041b7:	48 89 c6             	mov    %rax,%rsi
  8041ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8041bf:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  8041c6:	00 00 00 
  8041c9:	ff d0                	callq  *%rax
}
  8041cb:	c9                   	leaveq 
  8041cc:	c3                   	retq   

00000000008041cd <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8041cd:	55                   	push   %rbp
  8041ce:	48 89 e5             	mov    %rsp,%rbp
  8041d1:	53                   	push   %rbx
  8041d2:	48 83 ec 38          	sub    $0x38,%rsp
  8041d6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8041da:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8041de:	48 89 c7             	mov    %rax,%rdi
  8041e1:	48 b8 81 24 80 00 00 	movabs $0x802481,%rax
  8041e8:	00 00 00 
  8041eb:	ff d0                	callq  *%rax
  8041ed:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8041f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041f4:	0f 88 bf 01 00 00    	js     8043b9 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8041fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041fe:	ba 07 04 00 00       	mov    $0x407,%edx
  804203:	48 89 c6             	mov    %rax,%rsi
  804206:	bf 00 00 00 00       	mov    $0x0,%edi
  80420b:	48 b8 fc 20 80 00 00 	movabs $0x8020fc,%rax
  804212:	00 00 00 
  804215:	ff d0                	callq  *%rax
  804217:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80421a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80421e:	0f 88 95 01 00 00    	js     8043b9 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804224:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804228:	48 89 c7             	mov    %rax,%rdi
  80422b:	48 b8 81 24 80 00 00 	movabs $0x802481,%rax
  804232:	00 00 00 
  804235:	ff d0                	callq  *%rax
  804237:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80423a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80423e:	0f 88 5d 01 00 00    	js     8043a1 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804244:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804248:	ba 07 04 00 00       	mov    $0x407,%edx
  80424d:	48 89 c6             	mov    %rax,%rsi
  804250:	bf 00 00 00 00       	mov    $0x0,%edi
  804255:	48 b8 fc 20 80 00 00 	movabs $0x8020fc,%rax
  80425c:	00 00 00 
  80425f:	ff d0                	callq  *%rax
  804261:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804264:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804268:	0f 88 33 01 00 00    	js     8043a1 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80426e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804272:	48 89 c7             	mov    %rax,%rdi
  804275:	48 b8 56 24 80 00 00 	movabs $0x802456,%rax
  80427c:	00 00 00 
  80427f:	ff d0                	callq  *%rax
  804281:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804285:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804289:	ba 07 04 00 00       	mov    $0x407,%edx
  80428e:	48 89 c6             	mov    %rax,%rsi
  804291:	bf 00 00 00 00       	mov    $0x0,%edi
  804296:	48 b8 fc 20 80 00 00 	movabs $0x8020fc,%rax
  80429d:	00 00 00 
  8042a0:	ff d0                	callq  *%rax
  8042a2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042a9:	79 05                	jns    8042b0 <pipe+0xe3>
		goto err2;
  8042ab:	e9 d9 00 00 00       	jmpq   804389 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8042b0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042b4:	48 89 c7             	mov    %rax,%rdi
  8042b7:	48 b8 56 24 80 00 00 	movabs $0x802456,%rax
  8042be:	00 00 00 
  8042c1:	ff d0                	callq  *%rax
  8042c3:	48 89 c2             	mov    %rax,%rdx
  8042c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042ca:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8042d0:	48 89 d1             	mov    %rdx,%rcx
  8042d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8042d8:	48 89 c6             	mov    %rax,%rsi
  8042db:	bf 00 00 00 00       	mov    $0x0,%edi
  8042e0:	48 b8 4c 21 80 00 00 	movabs $0x80214c,%rax
  8042e7:	00 00 00 
  8042ea:	ff d0                	callq  *%rax
  8042ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042f3:	79 1b                	jns    804310 <pipe+0x143>
		goto err3;
  8042f5:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8042f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042fa:	48 89 c6             	mov    %rax,%rsi
  8042fd:	bf 00 00 00 00       	mov    $0x0,%edi
  804302:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  804309:	00 00 00 
  80430c:	ff d0                	callq  *%rax
  80430e:	eb 79                	jmp    804389 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804310:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804314:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
  80431b:	00 00 00 
  80431e:	8b 12                	mov    (%rdx),%edx
  804320:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804322:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804326:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80432d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804331:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
  804338:	00 00 00 
  80433b:	8b 12                	mov    (%rdx),%edx
  80433d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80433f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804343:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80434a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80434e:	48 89 c7             	mov    %rax,%rdi
  804351:	48 b8 33 24 80 00 00 	movabs $0x802433,%rax
  804358:	00 00 00 
  80435b:	ff d0                	callq  *%rax
  80435d:	89 c2                	mov    %eax,%edx
  80435f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804363:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804365:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804369:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80436d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804371:	48 89 c7             	mov    %rax,%rdi
  804374:	48 b8 33 24 80 00 00 	movabs $0x802433,%rax
  80437b:	00 00 00 
  80437e:	ff d0                	callq  *%rax
  804380:	89 03                	mov    %eax,(%rbx)
	return 0;
  804382:	b8 00 00 00 00       	mov    $0x0,%eax
  804387:	eb 33                	jmp    8043bc <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804389:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80438d:	48 89 c6             	mov    %rax,%rsi
  804390:	bf 00 00 00 00       	mov    $0x0,%edi
  804395:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  80439c:	00 00 00 
  80439f:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8043a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043a5:	48 89 c6             	mov    %rax,%rsi
  8043a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8043ad:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  8043b4:	00 00 00 
  8043b7:	ff d0                	callq  *%rax
err:
	return r;
  8043b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8043bc:	48 83 c4 38          	add    $0x38,%rsp
  8043c0:	5b                   	pop    %rbx
  8043c1:	5d                   	pop    %rbp
  8043c2:	c3                   	retq   

00000000008043c3 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8043c3:	55                   	push   %rbp
  8043c4:	48 89 e5             	mov    %rsp,%rbp
  8043c7:	53                   	push   %rbx
  8043c8:	48 83 ec 28          	sub    $0x28,%rsp
  8043cc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8043d0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8043d4:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8043db:	00 00 00 
  8043de:	48 8b 00             	mov    (%rax),%rax
  8043e1:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8043e7:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8043ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043ee:	48 89 c7             	mov    %rax,%rdi
  8043f1:	48 b8 33 4c 80 00 00 	movabs $0x804c33,%rax
  8043f8:	00 00 00 
  8043fb:	ff d0                	callq  *%rax
  8043fd:	89 c3                	mov    %eax,%ebx
  8043ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804403:	48 89 c7             	mov    %rax,%rdi
  804406:	48 b8 33 4c 80 00 00 	movabs $0x804c33,%rax
  80440d:	00 00 00 
  804410:	ff d0                	callq  *%rax
  804412:	39 c3                	cmp    %eax,%ebx
  804414:	0f 94 c0             	sete   %al
  804417:	0f b6 c0             	movzbl %al,%eax
  80441a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80441d:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804424:	00 00 00 
  804427:	48 8b 00             	mov    (%rax),%rax
  80442a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804430:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804433:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804436:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804439:	75 05                	jne    804440 <_pipeisclosed+0x7d>
			return ret;
  80443b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80443e:	eb 4f                	jmp    80448f <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  804440:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804443:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804446:	74 42                	je     80448a <_pipeisclosed+0xc7>
  804448:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80444c:	75 3c                	jne    80448a <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80444e:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804455:	00 00 00 
  804458:	48 8b 00             	mov    (%rax),%rax
  80445b:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804461:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804464:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804467:	89 c6                	mov    %eax,%esi
  804469:	48 bf ad 5a 80 00 00 	movabs $0x805aad,%rdi
  804470:	00 00 00 
  804473:	b8 00 00 00 00       	mov    $0x0,%eax
  804478:	49 b8 18 0c 80 00 00 	movabs $0x800c18,%r8
  80447f:	00 00 00 
  804482:	41 ff d0             	callq  *%r8
	}
  804485:	e9 4a ff ff ff       	jmpq   8043d4 <_pipeisclosed+0x11>
  80448a:	e9 45 ff ff ff       	jmpq   8043d4 <_pipeisclosed+0x11>
}
  80448f:	48 83 c4 28          	add    $0x28,%rsp
  804493:	5b                   	pop    %rbx
  804494:	5d                   	pop    %rbp
  804495:	c3                   	retq   

0000000000804496 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804496:	55                   	push   %rbp
  804497:	48 89 e5             	mov    %rsp,%rbp
  80449a:	48 83 ec 30          	sub    $0x30,%rsp
  80449e:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8044a1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8044a5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8044a8:	48 89 d6             	mov    %rdx,%rsi
  8044ab:	89 c7                	mov    %eax,%edi
  8044ad:	48 b8 19 25 80 00 00 	movabs $0x802519,%rax
  8044b4:	00 00 00 
  8044b7:	ff d0                	callq  *%rax
  8044b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044c0:	79 05                	jns    8044c7 <pipeisclosed+0x31>
		return r;
  8044c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044c5:	eb 31                	jmp    8044f8 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8044c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044cb:	48 89 c7             	mov    %rax,%rdi
  8044ce:	48 b8 56 24 80 00 00 	movabs $0x802456,%rax
  8044d5:	00 00 00 
  8044d8:	ff d0                	callq  *%rax
  8044da:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8044de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8044e6:	48 89 d6             	mov    %rdx,%rsi
  8044e9:	48 89 c7             	mov    %rax,%rdi
  8044ec:	48 b8 c3 43 80 00 00 	movabs $0x8043c3,%rax
  8044f3:	00 00 00 
  8044f6:	ff d0                	callq  *%rax
}
  8044f8:	c9                   	leaveq 
  8044f9:	c3                   	retq   

00000000008044fa <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8044fa:	55                   	push   %rbp
  8044fb:	48 89 e5             	mov    %rsp,%rbp
  8044fe:	48 83 ec 40          	sub    $0x40,%rsp
  804502:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804506:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80450a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80450e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804512:	48 89 c7             	mov    %rax,%rdi
  804515:	48 b8 56 24 80 00 00 	movabs $0x802456,%rax
  80451c:	00 00 00 
  80451f:	ff d0                	callq  *%rax
  804521:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804525:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804529:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80452d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804534:	00 
  804535:	e9 92 00 00 00       	jmpq   8045cc <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80453a:	eb 41                	jmp    80457d <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80453c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804541:	74 09                	je     80454c <devpipe_read+0x52>
				return i;
  804543:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804547:	e9 92 00 00 00       	jmpq   8045de <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80454c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804550:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804554:	48 89 d6             	mov    %rdx,%rsi
  804557:	48 89 c7             	mov    %rax,%rdi
  80455a:	48 b8 c3 43 80 00 00 	movabs $0x8043c3,%rax
  804561:	00 00 00 
  804564:	ff d0                	callq  *%rax
  804566:	85 c0                	test   %eax,%eax
  804568:	74 07                	je     804571 <devpipe_read+0x77>
				return 0;
  80456a:	b8 00 00 00 00       	mov    $0x0,%eax
  80456f:	eb 6d                	jmp    8045de <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804571:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  804578:	00 00 00 
  80457b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80457d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804581:	8b 10                	mov    (%rax),%edx
  804583:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804587:	8b 40 04             	mov    0x4(%rax),%eax
  80458a:	39 c2                	cmp    %eax,%edx
  80458c:	74 ae                	je     80453c <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80458e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804592:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804596:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80459a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80459e:	8b 00                	mov    (%rax),%eax
  8045a0:	99                   	cltd   
  8045a1:	c1 ea 1b             	shr    $0x1b,%edx
  8045a4:	01 d0                	add    %edx,%eax
  8045a6:	83 e0 1f             	and    $0x1f,%eax
  8045a9:	29 d0                	sub    %edx,%eax
  8045ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8045af:	48 98                	cltq   
  8045b1:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8045b6:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8045b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045bc:	8b 00                	mov    (%rax),%eax
  8045be:	8d 50 01             	lea    0x1(%rax),%edx
  8045c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045c5:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8045c7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8045cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045d0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8045d4:	0f 82 60 ff ff ff    	jb     80453a <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8045da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8045de:	c9                   	leaveq 
  8045df:	c3                   	retq   

00000000008045e0 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8045e0:	55                   	push   %rbp
  8045e1:	48 89 e5             	mov    %rsp,%rbp
  8045e4:	48 83 ec 40          	sub    $0x40,%rsp
  8045e8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8045ec:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8045f0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8045f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045f8:	48 89 c7             	mov    %rax,%rdi
  8045fb:	48 b8 56 24 80 00 00 	movabs $0x802456,%rax
  804602:	00 00 00 
  804605:	ff d0                	callq  *%rax
  804607:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80460b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80460f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804613:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80461a:	00 
  80461b:	e9 8e 00 00 00       	jmpq   8046ae <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804620:	eb 31                	jmp    804653 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804622:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804626:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80462a:	48 89 d6             	mov    %rdx,%rsi
  80462d:	48 89 c7             	mov    %rax,%rdi
  804630:	48 b8 c3 43 80 00 00 	movabs $0x8043c3,%rax
  804637:	00 00 00 
  80463a:	ff d0                	callq  *%rax
  80463c:	85 c0                	test   %eax,%eax
  80463e:	74 07                	je     804647 <devpipe_write+0x67>
				return 0;
  804640:	b8 00 00 00 00       	mov    $0x0,%eax
  804645:	eb 79                	jmp    8046c0 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804647:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  80464e:	00 00 00 
  804651:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804653:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804657:	8b 40 04             	mov    0x4(%rax),%eax
  80465a:	48 63 d0             	movslq %eax,%rdx
  80465d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804661:	8b 00                	mov    (%rax),%eax
  804663:	48 98                	cltq   
  804665:	48 83 c0 20          	add    $0x20,%rax
  804669:	48 39 c2             	cmp    %rax,%rdx
  80466c:	73 b4                	jae    804622 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80466e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804672:	8b 40 04             	mov    0x4(%rax),%eax
  804675:	99                   	cltd   
  804676:	c1 ea 1b             	shr    $0x1b,%edx
  804679:	01 d0                	add    %edx,%eax
  80467b:	83 e0 1f             	and    $0x1f,%eax
  80467e:	29 d0                	sub    %edx,%eax
  804680:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804684:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804688:	48 01 ca             	add    %rcx,%rdx
  80468b:	0f b6 0a             	movzbl (%rdx),%ecx
  80468e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804692:	48 98                	cltq   
  804694:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804698:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80469c:	8b 40 04             	mov    0x4(%rax),%eax
  80469f:	8d 50 01             	lea    0x1(%rax),%edx
  8046a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046a6:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8046a9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8046ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046b2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8046b6:	0f 82 64 ff ff ff    	jb     804620 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8046bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8046c0:	c9                   	leaveq 
  8046c1:	c3                   	retq   

00000000008046c2 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8046c2:	55                   	push   %rbp
  8046c3:	48 89 e5             	mov    %rsp,%rbp
  8046c6:	48 83 ec 20          	sub    $0x20,%rsp
  8046ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8046ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8046d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046d6:	48 89 c7             	mov    %rax,%rdi
  8046d9:	48 b8 56 24 80 00 00 	movabs $0x802456,%rax
  8046e0:	00 00 00 
  8046e3:	ff d0                	callq  *%rax
  8046e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8046e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046ed:	48 be c0 5a 80 00 00 	movabs $0x805ac0,%rsi
  8046f4:	00 00 00 
  8046f7:	48 89 c7             	mov    %rax,%rdi
  8046fa:	48 b8 cd 17 80 00 00 	movabs $0x8017cd,%rax
  804701:	00 00 00 
  804704:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804706:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80470a:	8b 50 04             	mov    0x4(%rax),%edx
  80470d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804711:	8b 00                	mov    (%rax),%eax
  804713:	29 c2                	sub    %eax,%edx
  804715:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804719:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80471f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804723:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80472a:	00 00 00 
	stat->st_dev = &devpipe;
  80472d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804731:	48 b9 40 71 80 00 00 	movabs $0x807140,%rcx
  804738:	00 00 00 
  80473b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804742:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804747:	c9                   	leaveq 
  804748:	c3                   	retq   

0000000000804749 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804749:	55                   	push   %rbp
  80474a:	48 89 e5             	mov    %rsp,%rbp
  80474d:	48 83 ec 10          	sub    $0x10,%rsp
  804751:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804755:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804759:	48 89 c6             	mov    %rax,%rsi
  80475c:	bf 00 00 00 00       	mov    $0x0,%edi
  804761:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  804768:	00 00 00 
  80476b:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80476d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804771:	48 89 c7             	mov    %rax,%rdi
  804774:	48 b8 56 24 80 00 00 	movabs $0x802456,%rax
  80477b:	00 00 00 
  80477e:	ff d0                	callq  *%rax
  804780:	48 89 c6             	mov    %rax,%rsi
  804783:	bf 00 00 00 00       	mov    $0x0,%edi
  804788:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  80478f:	00 00 00 
  804792:	ff d0                	callq  *%rax
}
  804794:	c9                   	leaveq 
  804795:	c3                   	retq   

0000000000804796 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804796:	55                   	push   %rbp
  804797:	48 89 e5             	mov    %rsp,%rbp
  80479a:	48 83 ec 20          	sub    $0x20,%rsp
  80479e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8047a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8047a4:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8047a7:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8047ab:	be 01 00 00 00       	mov    $0x1,%esi
  8047b0:	48 89 c7             	mov    %rax,%rdi
  8047b3:	48 b8 b4 1f 80 00 00 	movabs $0x801fb4,%rax
  8047ba:	00 00 00 
  8047bd:	ff d0                	callq  *%rax
}
  8047bf:	c9                   	leaveq 
  8047c0:	c3                   	retq   

00000000008047c1 <getchar>:

int
getchar(void)
{
  8047c1:	55                   	push   %rbp
  8047c2:	48 89 e5             	mov    %rsp,%rbp
  8047c5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8047c9:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8047cd:	ba 01 00 00 00       	mov    $0x1,%edx
  8047d2:	48 89 c6             	mov    %rax,%rsi
  8047d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8047da:	48 b8 4b 29 80 00 00 	movabs $0x80294b,%rax
  8047e1:	00 00 00 
  8047e4:	ff d0                	callq  *%rax
  8047e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8047e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047ed:	79 05                	jns    8047f4 <getchar+0x33>
		return r;
  8047ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047f2:	eb 14                	jmp    804808 <getchar+0x47>
	if (r < 1)
  8047f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047f8:	7f 07                	jg     804801 <getchar+0x40>
		return -E_EOF;
  8047fa:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8047ff:	eb 07                	jmp    804808 <getchar+0x47>
	return c;
  804801:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804805:	0f b6 c0             	movzbl %al,%eax
}
  804808:	c9                   	leaveq 
  804809:	c3                   	retq   

000000000080480a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80480a:	55                   	push   %rbp
  80480b:	48 89 e5             	mov    %rsp,%rbp
  80480e:	48 83 ec 20          	sub    $0x20,%rsp
  804812:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804815:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804819:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80481c:	48 89 d6             	mov    %rdx,%rsi
  80481f:	89 c7                	mov    %eax,%edi
  804821:	48 b8 19 25 80 00 00 	movabs $0x802519,%rax
  804828:	00 00 00 
  80482b:	ff d0                	callq  *%rax
  80482d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804830:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804834:	79 05                	jns    80483b <iscons+0x31>
		return r;
  804836:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804839:	eb 1a                	jmp    804855 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80483b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80483f:	8b 10                	mov    (%rax),%edx
  804841:	48 b8 80 71 80 00 00 	movabs $0x807180,%rax
  804848:	00 00 00 
  80484b:	8b 00                	mov    (%rax),%eax
  80484d:	39 c2                	cmp    %eax,%edx
  80484f:	0f 94 c0             	sete   %al
  804852:	0f b6 c0             	movzbl %al,%eax
}
  804855:	c9                   	leaveq 
  804856:	c3                   	retq   

0000000000804857 <opencons>:

int
opencons(void)
{
  804857:	55                   	push   %rbp
  804858:	48 89 e5             	mov    %rsp,%rbp
  80485b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80485f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804863:	48 89 c7             	mov    %rax,%rdi
  804866:	48 b8 81 24 80 00 00 	movabs $0x802481,%rax
  80486d:	00 00 00 
  804870:	ff d0                	callq  *%rax
  804872:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804875:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804879:	79 05                	jns    804880 <opencons+0x29>
		return r;
  80487b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80487e:	eb 5b                	jmp    8048db <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804880:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804884:	ba 07 04 00 00       	mov    $0x407,%edx
  804889:	48 89 c6             	mov    %rax,%rsi
  80488c:	bf 00 00 00 00       	mov    $0x0,%edi
  804891:	48 b8 fc 20 80 00 00 	movabs $0x8020fc,%rax
  804898:	00 00 00 
  80489b:	ff d0                	callq  *%rax
  80489d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8048a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048a4:	79 05                	jns    8048ab <opencons+0x54>
		return r;
  8048a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048a9:	eb 30                	jmp    8048db <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8048ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048af:	48 ba 80 71 80 00 00 	movabs $0x807180,%rdx
  8048b6:	00 00 00 
  8048b9:	8b 12                	mov    (%rdx),%edx
  8048bb:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8048bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048c1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8048c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048cc:	48 89 c7             	mov    %rax,%rdi
  8048cf:	48 b8 33 24 80 00 00 	movabs $0x802433,%rax
  8048d6:	00 00 00 
  8048d9:	ff d0                	callq  *%rax
}
  8048db:	c9                   	leaveq 
  8048dc:	c3                   	retq   

00000000008048dd <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8048dd:	55                   	push   %rbp
  8048de:	48 89 e5             	mov    %rsp,%rbp
  8048e1:	48 83 ec 30          	sub    $0x30,%rsp
  8048e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8048e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8048ed:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8048f1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8048f6:	75 07                	jne    8048ff <devcons_read+0x22>
		return 0;
  8048f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8048fd:	eb 4b                	jmp    80494a <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8048ff:	eb 0c                	jmp    80490d <devcons_read+0x30>
		sys_yield();
  804901:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  804908:	00 00 00 
  80490b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80490d:	48 b8 fe 1f 80 00 00 	movabs $0x801ffe,%rax
  804914:	00 00 00 
  804917:	ff d0                	callq  *%rax
  804919:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80491c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804920:	74 df                	je     804901 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804922:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804926:	79 05                	jns    80492d <devcons_read+0x50>
		return c;
  804928:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80492b:	eb 1d                	jmp    80494a <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80492d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804931:	75 07                	jne    80493a <devcons_read+0x5d>
		return 0;
  804933:	b8 00 00 00 00       	mov    $0x0,%eax
  804938:	eb 10                	jmp    80494a <devcons_read+0x6d>
	*(char*)vbuf = c;
  80493a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80493d:	89 c2                	mov    %eax,%edx
  80493f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804943:	88 10                	mov    %dl,(%rax)
	return 1;
  804945:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80494a:	c9                   	leaveq 
  80494b:	c3                   	retq   

000000000080494c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80494c:	55                   	push   %rbp
  80494d:	48 89 e5             	mov    %rsp,%rbp
  804950:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804957:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80495e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804965:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80496c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804973:	eb 76                	jmp    8049eb <devcons_write+0x9f>
		m = n - tot;
  804975:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80497c:	89 c2                	mov    %eax,%edx
  80497e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804981:	29 c2                	sub    %eax,%edx
  804983:	89 d0                	mov    %edx,%eax
  804985:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804988:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80498b:	83 f8 7f             	cmp    $0x7f,%eax
  80498e:	76 07                	jbe    804997 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804990:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804997:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80499a:	48 63 d0             	movslq %eax,%rdx
  80499d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049a0:	48 63 c8             	movslq %eax,%rcx
  8049a3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8049aa:	48 01 c1             	add    %rax,%rcx
  8049ad:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8049b4:	48 89 ce             	mov    %rcx,%rsi
  8049b7:	48 89 c7             	mov    %rax,%rdi
  8049ba:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  8049c1:	00 00 00 
  8049c4:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8049c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8049c9:	48 63 d0             	movslq %eax,%rdx
  8049cc:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8049d3:	48 89 d6             	mov    %rdx,%rsi
  8049d6:	48 89 c7             	mov    %rax,%rdi
  8049d9:	48 b8 b4 1f 80 00 00 	movabs $0x801fb4,%rax
  8049e0:	00 00 00 
  8049e3:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8049e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8049e8:	01 45 fc             	add    %eax,-0x4(%rbp)
  8049eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049ee:	48 98                	cltq   
  8049f0:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8049f7:	0f 82 78 ff ff ff    	jb     804975 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8049fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804a00:	c9                   	leaveq 
  804a01:	c3                   	retq   

0000000000804a02 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804a02:	55                   	push   %rbp
  804a03:	48 89 e5             	mov    %rsp,%rbp
  804a06:	48 83 ec 08          	sub    $0x8,%rsp
  804a0a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804a0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804a13:	c9                   	leaveq 
  804a14:	c3                   	retq   

0000000000804a15 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804a15:	55                   	push   %rbp
  804a16:	48 89 e5             	mov    %rsp,%rbp
  804a19:	48 83 ec 10          	sub    $0x10,%rsp
  804a1d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804a21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804a25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a29:	48 be cc 5a 80 00 00 	movabs $0x805acc,%rsi
  804a30:	00 00 00 
  804a33:	48 89 c7             	mov    %rax,%rdi
  804a36:	48 b8 cd 17 80 00 00 	movabs $0x8017cd,%rax
  804a3d:	00 00 00 
  804a40:	ff d0                	callq  *%rax
	return 0;
  804a42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804a47:	c9                   	leaveq 
  804a48:	c3                   	retq   

0000000000804a49 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804a49:	55                   	push   %rbp
  804a4a:	48 89 e5             	mov    %rsp,%rbp
  804a4d:	48 83 ec 30          	sub    $0x30,%rsp
  804a51:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804a55:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804a59:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804a5d:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804a64:	00 00 00 
  804a67:	48 8b 00             	mov    (%rax),%rax
  804a6a:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804a70:	85 c0                	test   %eax,%eax
  804a72:	75 3c                	jne    804ab0 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  804a74:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  804a7b:	00 00 00 
  804a7e:	ff d0                	callq  *%rax
  804a80:	25 ff 03 00 00       	and    $0x3ff,%eax
  804a85:	48 63 d0             	movslq %eax,%rdx
  804a88:	48 89 d0             	mov    %rdx,%rax
  804a8b:	48 c1 e0 03          	shl    $0x3,%rax
  804a8f:	48 01 d0             	add    %rdx,%rax
  804a92:	48 c1 e0 05          	shl    $0x5,%rax
  804a96:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804a9d:	00 00 00 
  804aa0:	48 01 c2             	add    %rax,%rdx
  804aa3:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804aaa:	00 00 00 
  804aad:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804ab0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804ab5:	75 0e                	jne    804ac5 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  804ab7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804abe:	00 00 00 
  804ac1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804ac5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804ac9:	48 89 c7             	mov    %rax,%rdi
  804acc:	48 b8 25 23 80 00 00 	movabs $0x802325,%rax
  804ad3:	00 00 00 
  804ad6:	ff d0                	callq  *%rax
  804ad8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804adb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804adf:	79 19                	jns    804afa <ipc_recv+0xb1>
		*from_env_store = 0;
  804ae1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ae5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  804aeb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804aef:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  804af5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804af8:	eb 53                	jmp    804b4d <ipc_recv+0x104>
	}
	if(from_env_store)
  804afa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804aff:	74 19                	je     804b1a <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  804b01:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804b08:	00 00 00 
  804b0b:	48 8b 00             	mov    (%rax),%rax
  804b0e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804b14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b18:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804b1a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804b1f:	74 19                	je     804b3a <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  804b21:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804b28:	00 00 00 
  804b2b:	48 8b 00             	mov    (%rax),%rax
  804b2e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804b34:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b38:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804b3a:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804b41:	00 00 00 
  804b44:	48 8b 00             	mov    (%rax),%rax
  804b47:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804b4d:	c9                   	leaveq 
  804b4e:	c3                   	retq   

0000000000804b4f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804b4f:	55                   	push   %rbp
  804b50:	48 89 e5             	mov    %rsp,%rbp
  804b53:	48 83 ec 30          	sub    $0x30,%rsp
  804b57:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804b5a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804b5d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804b61:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804b64:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804b69:	75 0e                	jne    804b79 <ipc_send+0x2a>
		pg = (void*)UTOP;
  804b6b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804b72:	00 00 00 
  804b75:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804b79:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804b7c:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804b7f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804b83:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804b86:	89 c7                	mov    %eax,%edi
  804b88:	48 b8 d0 22 80 00 00 	movabs $0x8022d0,%rax
  804b8f:	00 00 00 
  804b92:	ff d0                	callq  *%rax
  804b94:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804b97:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804b9b:	75 0c                	jne    804ba9 <ipc_send+0x5a>
			sys_yield();
  804b9d:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  804ba4:	00 00 00 
  804ba7:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804ba9:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804bad:	74 ca                	je     804b79 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  804baf:	c9                   	leaveq 
  804bb0:	c3                   	retq   

0000000000804bb1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804bb1:	55                   	push   %rbp
  804bb2:	48 89 e5             	mov    %rsp,%rbp
  804bb5:	48 83 ec 14          	sub    $0x14,%rsp
  804bb9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804bbc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804bc3:	eb 5e                	jmp    804c23 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804bc5:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804bcc:	00 00 00 
  804bcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804bd2:	48 63 d0             	movslq %eax,%rdx
  804bd5:	48 89 d0             	mov    %rdx,%rax
  804bd8:	48 c1 e0 03          	shl    $0x3,%rax
  804bdc:	48 01 d0             	add    %rdx,%rax
  804bdf:	48 c1 e0 05          	shl    $0x5,%rax
  804be3:	48 01 c8             	add    %rcx,%rax
  804be6:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804bec:	8b 00                	mov    (%rax),%eax
  804bee:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804bf1:	75 2c                	jne    804c1f <ipc_find_env+0x6e>
			return envs[i].env_id;
  804bf3:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804bfa:	00 00 00 
  804bfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c00:	48 63 d0             	movslq %eax,%rdx
  804c03:	48 89 d0             	mov    %rdx,%rax
  804c06:	48 c1 e0 03          	shl    $0x3,%rax
  804c0a:	48 01 d0             	add    %rdx,%rax
  804c0d:	48 c1 e0 05          	shl    $0x5,%rax
  804c11:	48 01 c8             	add    %rcx,%rax
  804c14:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804c1a:	8b 40 08             	mov    0x8(%rax),%eax
  804c1d:	eb 12                	jmp    804c31 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804c1f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804c23:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804c2a:	7e 99                	jle    804bc5 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804c2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804c31:	c9                   	leaveq 
  804c32:	c3                   	retq   

0000000000804c33 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804c33:	55                   	push   %rbp
  804c34:	48 89 e5             	mov    %rsp,%rbp
  804c37:	48 83 ec 18          	sub    $0x18,%rsp
  804c3b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804c3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c43:	48 c1 e8 15          	shr    $0x15,%rax
  804c47:	48 89 c2             	mov    %rax,%rdx
  804c4a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804c51:	01 00 00 
  804c54:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c58:	83 e0 01             	and    $0x1,%eax
  804c5b:	48 85 c0             	test   %rax,%rax
  804c5e:	75 07                	jne    804c67 <pageref+0x34>
		return 0;
  804c60:	b8 00 00 00 00       	mov    $0x0,%eax
  804c65:	eb 53                	jmp    804cba <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804c67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c6b:	48 c1 e8 0c          	shr    $0xc,%rax
  804c6f:	48 89 c2             	mov    %rax,%rdx
  804c72:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804c79:	01 00 00 
  804c7c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c80:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804c84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c88:	83 e0 01             	and    $0x1,%eax
  804c8b:	48 85 c0             	test   %rax,%rax
  804c8e:	75 07                	jne    804c97 <pageref+0x64>
		return 0;
  804c90:	b8 00 00 00 00       	mov    $0x0,%eax
  804c95:	eb 23                	jmp    804cba <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804c97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c9b:	48 c1 e8 0c          	shr    $0xc,%rax
  804c9f:	48 89 c2             	mov    %rax,%rdx
  804ca2:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804ca9:	00 00 00 
  804cac:	48 c1 e2 04          	shl    $0x4,%rdx
  804cb0:	48 01 d0             	add    %rdx,%rax
  804cb3:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804cb7:	0f b7 c0             	movzwl %ax,%eax
}
  804cba:	c9                   	leaveq 
  804cbb:	c3                   	retq   

0000000000804cbc <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  804cbc:	55                   	push   %rbp
  804cbd:	48 89 e5             	mov    %rsp,%rbp
  804cc0:	48 83 ec 20          	sub    $0x20,%rsp
  804cc4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  804cc8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804ccc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804cd0:	48 89 d6             	mov    %rdx,%rsi
  804cd3:	48 89 c7             	mov    %rax,%rdi
  804cd6:	48 b8 f2 4c 80 00 00 	movabs $0x804cf2,%rax
  804cdd:	00 00 00 
  804ce0:	ff d0                	callq  *%rax
  804ce2:	85 c0                	test   %eax,%eax
  804ce4:	74 05                	je     804ceb <inet_addr+0x2f>
    return (val.s_addr);
  804ce6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804ce9:	eb 05                	jmp    804cf0 <inet_addr+0x34>
  }
  return (INADDR_NONE);
  804ceb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  804cf0:	c9                   	leaveq 
  804cf1:	c3                   	retq   

0000000000804cf2 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  804cf2:	55                   	push   %rbp
  804cf3:	48 89 e5             	mov    %rsp,%rbp
  804cf6:	48 83 ec 40          	sub    $0x40,%rsp
  804cfa:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  804cfe:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  804d02:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804d06:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  c = *cp;
  804d0a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804d0e:	0f b6 00             	movzbl (%rax),%eax
  804d11:	0f be c0             	movsbl %al,%eax
  804d14:	89 45 f4             	mov    %eax,-0xc(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  804d17:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804d1a:	3c 2f                	cmp    $0x2f,%al
  804d1c:	76 07                	jbe    804d25 <inet_aton+0x33>
  804d1e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804d21:	3c 39                	cmp    $0x39,%al
  804d23:	76 0a                	jbe    804d2f <inet_aton+0x3d>
      return (0);
  804d25:	b8 00 00 00 00       	mov    $0x0,%eax
  804d2a:	e9 68 02 00 00       	jmpq   804f97 <inet_aton+0x2a5>
    val = 0;
  804d2f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    base = 10;
  804d36:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    if (c == '0') {
  804d3d:	83 7d f4 30          	cmpl   $0x30,-0xc(%rbp)
  804d41:	75 40                	jne    804d83 <inet_aton+0x91>
      c = *++cp;
  804d43:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804d48:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804d4c:	0f b6 00             	movzbl (%rax),%eax
  804d4f:	0f be c0             	movsbl %al,%eax
  804d52:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if (c == 'x' || c == 'X') {
  804d55:	83 7d f4 78          	cmpl   $0x78,-0xc(%rbp)
  804d59:	74 06                	je     804d61 <inet_aton+0x6f>
  804d5b:	83 7d f4 58          	cmpl   $0x58,-0xc(%rbp)
  804d5f:	75 1b                	jne    804d7c <inet_aton+0x8a>
        base = 16;
  804d61:	c7 45 f8 10 00 00 00 	movl   $0x10,-0x8(%rbp)
        c = *++cp;
  804d68:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804d6d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804d71:	0f b6 00             	movzbl (%rax),%eax
  804d74:	0f be c0             	movsbl %al,%eax
  804d77:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804d7a:	eb 07                	jmp    804d83 <inet_aton+0x91>
      } else
        base = 8;
  804d7c:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  804d83:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804d86:	3c 2f                	cmp    $0x2f,%al
  804d88:	76 2f                	jbe    804db9 <inet_aton+0xc7>
  804d8a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804d8d:	3c 39                	cmp    $0x39,%al
  804d8f:	77 28                	ja     804db9 <inet_aton+0xc7>
        val = (val * base) + (int)(c - '0');
  804d91:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804d94:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  804d98:	89 c2                	mov    %eax,%edx
  804d9a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804d9d:	01 d0                	add    %edx,%eax
  804d9f:	83 e8 30             	sub    $0x30,%eax
  804da2:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  804da5:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804daa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804dae:	0f b6 00             	movzbl (%rax),%eax
  804db1:	0f be c0             	movsbl %al,%eax
  804db4:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else if (base == 16 && isxdigit(c)) {
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
  804db7:	eb ca                	jmp    804d83 <inet_aton+0x91>
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  804db9:	83 7d f8 10          	cmpl   $0x10,-0x8(%rbp)
  804dbd:	75 72                	jne    804e31 <inet_aton+0x13f>
  804dbf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804dc2:	3c 2f                	cmp    $0x2f,%al
  804dc4:	76 07                	jbe    804dcd <inet_aton+0xdb>
  804dc6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804dc9:	3c 39                	cmp    $0x39,%al
  804dcb:	76 1c                	jbe    804de9 <inet_aton+0xf7>
  804dcd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804dd0:	3c 60                	cmp    $0x60,%al
  804dd2:	76 07                	jbe    804ddb <inet_aton+0xe9>
  804dd4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804dd7:	3c 66                	cmp    $0x66,%al
  804dd9:	76 0e                	jbe    804de9 <inet_aton+0xf7>
  804ddb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804dde:	3c 40                	cmp    $0x40,%al
  804de0:	76 4f                	jbe    804e31 <inet_aton+0x13f>
  804de2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804de5:	3c 46                	cmp    $0x46,%al
  804de7:	77 48                	ja     804e31 <inet_aton+0x13f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  804de9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804dec:	c1 e0 04             	shl    $0x4,%eax
  804def:	89 c2                	mov    %eax,%edx
  804df1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804df4:	8d 48 0a             	lea    0xa(%rax),%ecx
  804df7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804dfa:	3c 60                	cmp    $0x60,%al
  804dfc:	76 0e                	jbe    804e0c <inet_aton+0x11a>
  804dfe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804e01:	3c 7a                	cmp    $0x7a,%al
  804e03:	77 07                	ja     804e0c <inet_aton+0x11a>
  804e05:	b8 61 00 00 00       	mov    $0x61,%eax
  804e0a:	eb 05                	jmp    804e11 <inet_aton+0x11f>
  804e0c:	b8 41 00 00 00       	mov    $0x41,%eax
  804e11:	29 c1                	sub    %eax,%ecx
  804e13:	89 c8                	mov    %ecx,%eax
  804e15:	09 d0                	or     %edx,%eax
  804e17:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  804e1a:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804e1f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804e23:	0f b6 00             	movzbl (%rax),%eax
  804e26:	0f be c0             	movsbl %al,%eax
  804e29:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else
        break;
    }
  804e2c:	e9 52 ff ff ff       	jmpq   804d83 <inet_aton+0x91>
    if (c == '.') {
  804e31:	83 7d f4 2e          	cmpl   $0x2e,-0xc(%rbp)
  804e35:	75 40                	jne    804e77 <inet_aton+0x185>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  804e37:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804e3b:	48 83 c0 0c          	add    $0xc,%rax
  804e3f:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  804e43:	72 0a                	jb     804e4f <inet_aton+0x15d>
        return (0);
  804e45:	b8 00 00 00 00       	mov    $0x0,%eax
  804e4a:	e9 48 01 00 00       	jmpq   804f97 <inet_aton+0x2a5>
      *pp++ = val;
  804e4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804e53:	48 8d 50 04          	lea    0x4(%rax),%rdx
  804e57:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804e5b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804e5e:	89 10                	mov    %edx,(%rax)
      c = *++cp;
  804e60:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804e65:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804e69:	0f b6 00             	movzbl (%rax),%eax
  804e6c:	0f be c0             	movsbl %al,%eax
  804e6f:	89 45 f4             	mov    %eax,-0xc(%rbp)
    } else
      break;
  }
  804e72:	e9 a0 fe ff ff       	jmpq   804d17 <inet_aton+0x25>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  804e77:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804e78:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  804e7c:	74 3c                	je     804eba <inet_aton+0x1c8>
  804e7e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804e81:	3c 1f                	cmp    $0x1f,%al
  804e83:	76 2b                	jbe    804eb0 <inet_aton+0x1be>
  804e85:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804e88:	84 c0                	test   %al,%al
  804e8a:	78 24                	js     804eb0 <inet_aton+0x1be>
  804e8c:	83 7d f4 20          	cmpl   $0x20,-0xc(%rbp)
  804e90:	74 28                	je     804eba <inet_aton+0x1c8>
  804e92:	83 7d f4 0c          	cmpl   $0xc,-0xc(%rbp)
  804e96:	74 22                	je     804eba <inet_aton+0x1c8>
  804e98:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  804e9c:	74 1c                	je     804eba <inet_aton+0x1c8>
  804e9e:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  804ea2:	74 16                	je     804eba <inet_aton+0x1c8>
  804ea4:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  804ea8:	74 10                	je     804eba <inet_aton+0x1c8>
  804eaa:	83 7d f4 0b          	cmpl   $0xb,-0xc(%rbp)
  804eae:	74 0a                	je     804eba <inet_aton+0x1c8>
    return (0);
  804eb0:	b8 00 00 00 00       	mov    $0x0,%eax
  804eb5:	e9 dd 00 00 00       	jmpq   804f97 <inet_aton+0x2a5>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  804eba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804ebe:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804ec2:	48 29 c2             	sub    %rax,%rdx
  804ec5:	48 89 d0             	mov    %rdx,%rax
  804ec8:	48 c1 f8 02          	sar    $0x2,%rax
  804ecc:	83 c0 01             	add    $0x1,%eax
  804ecf:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  switch (n) {
  804ed2:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  804ed6:	0f 87 98 00 00 00    	ja     804f74 <inet_aton+0x282>
  804edc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804edf:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804ee6:	00 
  804ee7:	48 b8 d8 5a 80 00 00 	movabs $0x805ad8,%rax
  804eee:	00 00 00 
  804ef1:	48 01 d0             	add    %rdx,%rax
  804ef4:	48 8b 00             	mov    (%rax),%rax
  804ef7:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  804ef9:	b8 00 00 00 00       	mov    $0x0,%eax
  804efe:	e9 94 00 00 00       	jmpq   804f97 <inet_aton+0x2a5>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  804f03:	81 7d fc ff ff ff 00 	cmpl   $0xffffff,-0x4(%rbp)
  804f0a:	76 0a                	jbe    804f16 <inet_aton+0x224>
      return (0);
  804f0c:	b8 00 00 00 00       	mov    $0x0,%eax
  804f11:	e9 81 00 00 00       	jmpq   804f97 <inet_aton+0x2a5>
    val |= parts[0] << 24;
  804f16:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804f19:	c1 e0 18             	shl    $0x18,%eax
  804f1c:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  804f1f:	eb 53                	jmp    804f74 <inet_aton+0x282>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  804f21:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%rbp)
  804f28:	76 07                	jbe    804f31 <inet_aton+0x23f>
      return (0);
  804f2a:	b8 00 00 00 00       	mov    $0x0,%eax
  804f2f:	eb 66                	jmp    804f97 <inet_aton+0x2a5>
    val |= (parts[0] << 24) | (parts[1] << 16);
  804f31:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804f34:	c1 e0 18             	shl    $0x18,%eax
  804f37:	89 c2                	mov    %eax,%edx
  804f39:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804f3c:	c1 e0 10             	shl    $0x10,%eax
  804f3f:	09 d0                	or     %edx,%eax
  804f41:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  804f44:	eb 2e                	jmp    804f74 <inet_aton+0x282>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  804f46:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
  804f4d:	76 07                	jbe    804f56 <inet_aton+0x264>
      return (0);
  804f4f:	b8 00 00 00 00       	mov    $0x0,%eax
  804f54:	eb 41                	jmp    804f97 <inet_aton+0x2a5>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  804f56:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804f59:	c1 e0 18             	shl    $0x18,%eax
  804f5c:	89 c2                	mov    %eax,%edx
  804f5e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804f61:	c1 e0 10             	shl    $0x10,%eax
  804f64:	09 c2                	or     %eax,%edx
  804f66:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804f69:	c1 e0 08             	shl    $0x8,%eax
  804f6c:	09 d0                	or     %edx,%eax
  804f6e:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  804f71:	eb 01                	jmp    804f74 <inet_aton+0x282>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  804f73:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  804f74:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  804f79:	74 17                	je     804f92 <inet_aton+0x2a0>
    addr->s_addr = htonl(val);
  804f7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f7e:	89 c7                	mov    %eax,%edi
  804f80:	48 b8 10 51 80 00 00 	movabs $0x805110,%rax
  804f87:	00 00 00 
  804f8a:	ff d0                	callq  *%rax
  804f8c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804f90:	89 02                	mov    %eax,(%rdx)
  return (1);
  804f92:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804f97:	c9                   	leaveq 
  804f98:	c3                   	retq   

0000000000804f99 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  804f99:	55                   	push   %rbp
  804f9a:	48 89 e5             	mov    %rsp,%rbp
  804f9d:	48 83 ec 30          	sub    $0x30,%rsp
  804fa1:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  804fa4:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804fa7:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  804faa:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  804fb1:	00 00 00 
  804fb4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  804fb8:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  804fbc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  804fc0:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  804fc4:	e9 e0 00 00 00       	jmpq   8050a9 <inet_ntoa+0x110>
    i = 0;
  804fc9:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  804fcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804fd1:	0f b6 08             	movzbl (%rax),%ecx
  804fd4:	0f b6 d1             	movzbl %cl,%edx
  804fd7:	89 d0                	mov    %edx,%eax
  804fd9:	c1 e0 02             	shl    $0x2,%eax
  804fdc:	01 d0                	add    %edx,%eax
  804fde:	c1 e0 03             	shl    $0x3,%eax
  804fe1:	01 d0                	add    %edx,%eax
  804fe3:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  804fea:	01 d0                	add    %edx,%eax
  804fec:	66 c1 e8 08          	shr    $0x8,%ax
  804ff0:	c0 e8 03             	shr    $0x3,%al
  804ff3:	88 45 ed             	mov    %al,-0x13(%rbp)
  804ff6:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  804ffa:	89 d0                	mov    %edx,%eax
  804ffc:	c1 e0 02             	shl    $0x2,%eax
  804fff:	01 d0                	add    %edx,%eax
  805001:	01 c0                	add    %eax,%eax
  805003:	29 c1                	sub    %eax,%ecx
  805005:	89 c8                	mov    %ecx,%eax
  805007:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  80500a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80500e:	0f b6 00             	movzbl (%rax),%eax
  805011:	0f b6 d0             	movzbl %al,%edx
  805014:	89 d0                	mov    %edx,%eax
  805016:	c1 e0 02             	shl    $0x2,%eax
  805019:	01 d0                	add    %edx,%eax
  80501b:	c1 e0 03             	shl    $0x3,%eax
  80501e:	01 d0                	add    %edx,%eax
  805020:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  805027:	01 d0                	add    %edx,%eax
  805029:	66 c1 e8 08          	shr    $0x8,%ax
  80502d:	89 c2                	mov    %eax,%edx
  80502f:	c0 ea 03             	shr    $0x3,%dl
  805032:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805036:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  805038:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  80503c:	8d 50 01             	lea    0x1(%rax),%edx
  80503f:	88 55 ee             	mov    %dl,-0x12(%rbp)
  805042:	0f b6 c0             	movzbl %al,%eax
  805045:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  805049:	83 c2 30             	add    $0x30,%edx
  80504c:	48 98                	cltq   
  80504e:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    } while(*ap);
  805052:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805056:	0f b6 00             	movzbl (%rax),%eax
  805059:	84 c0                	test   %al,%al
  80505b:	0f 85 6c ff ff ff    	jne    804fcd <inet_ntoa+0x34>
    while(i--)
  805061:	eb 1a                	jmp    80507d <inet_ntoa+0xe4>
      *rp++ = inv[i];
  805063:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805067:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80506b:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  80506f:	0f b6 55 ee          	movzbl -0x12(%rbp),%edx
  805073:	48 63 d2             	movslq %edx,%rdx
  805076:	0f b6 54 15 e0       	movzbl -0x20(%rbp,%rdx,1),%edx
  80507b:	88 10                	mov    %dl,(%rax)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  80507d:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  805081:	8d 50 ff             	lea    -0x1(%rax),%edx
  805084:	88 55 ee             	mov    %dl,-0x12(%rbp)
  805087:	84 c0                	test   %al,%al
  805089:	75 d8                	jne    805063 <inet_ntoa+0xca>
      *rp++ = inv[i];
    *rp++ = '.';
  80508b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80508f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  805093:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  805097:	c6 00 2e             	movb   $0x2e,(%rax)
    ap++;
  80509a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80509f:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8050a3:	83 c0 01             	add    $0x1,%eax
  8050a6:	88 45 ef             	mov    %al,-0x11(%rbp)
  8050a9:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  8050ad:	0f 86 16 ff ff ff    	jbe    804fc9 <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  8050b3:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  8050b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8050bc:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  8050bf:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8050c6:	00 00 00 
}
  8050c9:	c9                   	leaveq 
  8050ca:	c3                   	retq   

00000000008050cb <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8050cb:	55                   	push   %rbp
  8050cc:	48 89 e5             	mov    %rsp,%rbp
  8050cf:	48 83 ec 04          	sub    $0x4,%rsp
  8050d3:	89 f8                	mov    %edi,%eax
  8050d5:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8050d9:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8050dd:	c1 e0 08             	shl    $0x8,%eax
  8050e0:	89 c2                	mov    %eax,%edx
  8050e2:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8050e6:	66 c1 e8 08          	shr    $0x8,%ax
  8050ea:	09 d0                	or     %edx,%eax
}
  8050ec:	c9                   	leaveq 
  8050ed:	c3                   	retq   

00000000008050ee <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8050ee:	55                   	push   %rbp
  8050ef:	48 89 e5             	mov    %rsp,%rbp
  8050f2:	48 83 ec 08          	sub    $0x8,%rsp
  8050f6:	89 f8                	mov    %edi,%eax
  8050f8:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  8050fc:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  805100:	89 c7                	mov    %eax,%edi
  805102:	48 b8 cb 50 80 00 00 	movabs $0x8050cb,%rax
  805109:	00 00 00 
  80510c:	ff d0                	callq  *%rax
}
  80510e:	c9                   	leaveq 
  80510f:	c3                   	retq   

0000000000805110 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  805110:	55                   	push   %rbp
  805111:	48 89 e5             	mov    %rsp,%rbp
  805114:	48 83 ec 04          	sub    $0x4,%rsp
  805118:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  80511b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80511e:	c1 e0 18             	shl    $0x18,%eax
  805121:	89 c2                	mov    %eax,%edx
    ((n & 0xff00) << 8) |
  805123:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805126:	25 00 ff 00 00       	and    $0xff00,%eax
  80512b:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80512e:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  805130:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805133:	25 00 00 ff 00       	and    $0xff0000,%eax
  805138:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80513c:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  80513e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805141:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  805144:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  805146:	c9                   	leaveq 
  805147:	c3                   	retq   

0000000000805148 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  805148:	55                   	push   %rbp
  805149:	48 89 e5             	mov    %rsp,%rbp
  80514c:	48 83 ec 08          	sub    $0x8,%rsp
  805150:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  805153:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805156:	89 c7                	mov    %eax,%edi
  805158:	48 b8 10 51 80 00 00 	movabs $0x805110,%rax
  80515f:	00 00 00 
  805162:	ff d0                	callq  *%rax
}
  805164:	c9                   	leaveq 
  805165:	c3                   	retq   
