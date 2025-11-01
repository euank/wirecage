^\SIGQUIT: quitSIGQUIT: quit

PC=PC=0x40a60c0x40a60c m= m=00 sigcode= sigcode=128128



goroutine goroutine 11 gp= gp=0xc0000023800xc000002380 m= m=00 mp= mp=0xad3e600xad3e60 [ [syscallsyscall]:
]:
syscall.Syscall6syscall.Syscall6((0xf70xf7, , 0x30x3, , 0x50x7, , 0xc00006c9680xc00006a968, , 0x40x4, , 0xc0000501200xc00004e1b0, , 0x00x0)
)
		/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/syscall/syscall_linux.go/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/syscall/syscall_linux.go::9595 + +0x390x39 fp= fp=0xc00006c8e00xc00006a8e0 sp= sp=0xc00006c8800xc00006a880 pc= pc=0x48eb590x48eb59

internal/syscall/unix.Waitidinternal/syscall/unix.Waitid((0xc00006c9960xc00006a996??, , 0xc00006cac00xc00006aac0??, , 0x604c8b0x604c8b??, , 0xc0000387200x7c1444??, , 0x260xe??)
)
		/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/internal/syscall/unix/waitid_linux.go/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/internal/syscall/unix/waitid_linux.go::1818 + +0x390x39 fp= fp=0xc00006c9380xc00006a938 sp= sp=0xc00006c8e00xc00006a8e0 pc= pc=0x4c55190x4c5519

os.(*Process).pidfdWait.func1os.(*Process).pidfdWait.func1((......)
)
		/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/os/pidfd_linux.go/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/os/pidfd_linux.go::106106

os.ignoringEINTR(os.ignoringEINTR...()
...	)
/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/os/file_posix.go	:/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/os/file_posix.go251:
251
os.(*Process).pidfdWait(os.(*Process).pidfdWait0xc000010138(?0xc000010168)
?	)
/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/os/pidfd_linux.go	:/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/os/pidfd_linux.go105: +SIGQUIT: quit1050x209 +
 fp=0x209PC=0xc00006ca50 fp=0x47a6610xc00006aa50 sp= m= sp=0xc00006c93800xc00006a938 pc= sigcode= pc=0x4cf6491280x4cf649


os.(*Process).waitos.(*Process).wait(
(0xad3e600x7a8aa0goroutine ??0)
)
	 gp=/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/os/exec_unix.go	0xad3000/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/os/exec_unix.go m=:0:27 mp=27 +0xad3e600x25 + [0x25 fp= fp=idle0xc00006ca700xc00006aa70]:
 sp= sp=0xc00006ca500xc00006aa50 pc= pc=0x4cc1a50x4cc1a5

runtime.futexos.(*Process).Wait(os.(*Process).Wait(0xad3fa0..., )
0x80	, /nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/os/exec.go0x0(, :...3580x0)

	, /nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/os/exec.goos/exec.(*Cmd).Wait:0x0358(,
0x00xc000180180os/exec.(*Cmd).Wait)
()
0xc000182180		/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/os/exec/exec.go)
/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/sys_linux_amd64.s:	922:/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/os/exec/exec.go +:5579220x45 + +0x21 fp=0x45 fp=0xc00006aad0 fp=0x7ffe72e837f0 sp=0xc00006cad0 sp=0xc00006aa70 sp=0x7ffe72e837e8 pc=0xc00006ca70 pc= pc=0x6056650x6056650x47a661


os/exec.(*Cmd).Runos/exec.(*Cmd).Run((0xc000182180runtime.futexsleep)
0xc000180180(	)
/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/os/exec/exec.go0x7ffe72e83868	:?/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/os/exec/exec.go626, : +0x414b710x2d626? fp= +, 0xc00006cae80x2d sp=0x172e83898 fp=0xc00006cad0? pc=0xc00006aae80x60434d)

 sp=	0xc00006aad0/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/os_linux.go pc=:0x60434d75
 +0x30main.run fp=(0x7ffe72e83840{ sp=0x84db380x7ffe72e837f0,  pc=0xaf29e00x437db0}main.run
)
(	{/home/esk/dev/wirecage/wgcage.goruntime.notesleep0x84db38:(, 1870xad3fa00xaf29e0 +)
0x7f2}	)
 fp=/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/lock_futex.go	:0xc00006def847/home/esk/dev/wirecage/wgcage.go + sp=:0xc00006cae80x87 pc=147 fp=0x6bbe12 +0x7ffe72e83878
 sp=0x2f250x7ffe72e83840main.main fp= pc=(0xc00006bef80x414287)

	 sp=/home/esk/dev/wirecage/wgcage.go0xc00006aae8: pc=runtime.mPark4820x6be545( +
...0x4c)
main.main fp=	0xc00006df50(/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go sp=)
0xc00006def8: pc=	0x6bf4cc1887/home/esk/dev/wirecage/wgcage.go

:482runtime.stopm +runtime.main0x4c(( fp=)
0xc00006bf50)
 sp=	0xc00006bef8	 pc=/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go0x6bf4cc:
:2907283 + +runtime.main0x28b0x8c( fp= fp=)
0x7ffe72e838a80xc00006dfe0	 sp= sp=0xc00006df50/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go0x7ffe72e83878 pc= pc=:0x43e52b0x44342c283

 +0x28bruntime.goexit fp=(0xc00006bfe0{ sp=}0xc00006bf50)
 pc=	0x43e52b/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s
:runtime.findRunnable1700runtime.goexit( +()
0x1{ fp=	0xc00006dfe8} sp=/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go)
:0xc00006dfe03644	 pc=/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s +:0x4788610xd9c
1700 fp= +0x7ffe72e83a200x1
 sp= fp=goroutine 0x7ffe72e838a80xc00006bfe82 sp= pc= gp=0xc00006bfe00x444efc0xc000002e00 pc=
0x478861 m=nil
runtime.schedule [(force gc (idle))
]:

	goroutine /nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go2runtime.gopark: gp=(40170xc000002e000x0 +? m=nil0xb1 [,  fp=0x0force gc (idle)?0x7ffe72e83a58, ]:
 sp=0x00x7ffe72e83a20?runtime.gopark pc=, (0x00x445ff10x0?
?, , runtime.goexit00x00x0(??0xc0006868c0, )
0x0?	)
?/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go	, :/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go0x0:435?4310 +, 0xce +0x0 fp=0x18?0xc0000a4fa8 fp= sp=)
0x7ffe72e83a70	0xc0000a4f88/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go sp= pc=:0x47102e0x7ffe72e83a58
435 pc= +runtime.goparkunlock0x446db80xce(
... fp=)
0xc0000a2fa8runtime.mcall sp=	(0xc0000a2f88/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go)
 pc=:0x47102e441

/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.sruntime.forcegchelper:runtime.goparkunlock(459)
(	.../nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go +)
:0x4e	 fp=3480x7ffe72e83a88/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go + sp=:0x7ffe72e83a700xb3 pc=441 fp=
0x47682e0xc0000a4fe0runtime.forcegchelper sp=
(0xc0000a4fa8)
 pc=
0x43e873
goroutine /nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.goruntime.goexit:1348( + gp={0xb30xc000002380} fp= m=)
9	 mp=0xc0000a2fe00xc000400008/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s [: sp=1700syscall +0xc0000a2fa8, 0x1 pc= fp=0x43e87330xc0000a4fe8
 sp= minutesruntime.goexit, locked to thread0xc0000a4fe0(]:
{ pc=}0x478861)

syscall.Syscall6	created by (/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.sruntime.init.70xf7: in goroutine 1700,  +10x30x1
,  fp=	0x100xc0000a2fe8/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go, : sp=0xc0002909803360xc0000a2fe0,  + pc=0x40x1a0x478861,

0xc0000501b0created by ,
runtime.init.70x0goroutine  in goroutine )
31
 gp=/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/syscall/syscall_linux.go	:0xc00000334095/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go m=nil: +336 [0x39 +GC sweep wait fp=0x1a0xc0002908f8]:

 sp=runtime.gopark0xc000290898
 pc=(goroutine 0x48eb5930x0
 gp=?0xc000003340internal/syscall/unix.Waitid,  m=nil(0x0 [?0xc0002909aeGC sweep wait, ]:
?0x0, ?runtime.gopark0xc000290ad8(, ?0x00x0?, ?, 0x604c8b, ?0x0, 0x0??0x7c1444, )
?	, 0x0/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go0xe??:)
435,  +	0x00xce?/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/internal/syscall/unix/waitid_linux.go fp=, 0xc0000a5780: sp=180x00xc0000a5760 + pc=?0x390x47102e)
 fp=
0xc000290950	 sp=/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go0xc0002908f8runtime.goparkunlock: pc=(0x4c5519435...
 +)
0xceos.(*Process).pidfdWait.func1 fp=	0xc0000a3780( sp=/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go...:0xc0000a3760441)
 pc=
	0x47102e/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/os/pidfd_linux.goruntime.bgsweep
(:runtime.goparkunlock1060xc00004c080
()
os.ignoringEINTR...	()
/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgcsweep.go...	)
:	276/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/os/file_posix.go/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go +::0x94251441 fp=
0xc0000a57c8
 sp=os.(*Process).pidfdWaitruntime.bgsweep(0xc0000a5780(0xc000010618 pc=0xc00004a0800x4292f4?)

)
		runtime.gcenable.gowrap1/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/os/pidfd_linux.go(:/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgcsweep.go)
105	 +:/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go0x209276 fp=:0xc000290a68 + sp=2040x940xc000290950 + pc= fp=0x4cf6490x25
0xc0000a37c8 fp=os.(*Process).wait0xc0000a57e0 sp= sp=(0xc0000a37800xc0000a57c80x46ea99 pc= pc=0x41d9c5?0x4292f4
)

	runtime.goexit/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/os/exec_unix.go(runtime.gcenable.gowrap1:{27(} +)
)
0x25	 fp=	0xc000290a88/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s sp=::0xc000290a682041700 + pc= +0x4cc1a50x10x25 fp=
0xc0000a57e8 fp= sp=0xc0000a37e0os.(*Process).Wait sp=0xc0000a57e0(0xc0000a37c8 pc= pc=...0x4788610x41d9c5)


	created by /nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/os/exec.goruntime.gcenableruntime.goexit in goroutine (:{1358}

)
os/exec.(*Cmd).Wait		(/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go0xc000180600::)
1700	 +204/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/os/exec/exec.go0x1: +922 fp=0x66 +0xc0000a37e80x45 sp=
0xc0000a37e0 fp= pc=
0x4788610xc000290ae8
 sp=goroutine 0xc000290a88created by  pc=4runtime.gcenable gp=0x6056650xc000003500 in goroutine  m=nil
 [1GC scavenge wait
]:
	runtime.gopark/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go(:0xc00004c080main.run?204, ( +0x843bc00x66?{
, 0x84db380x1
?, , goroutine 0x04?0xaf29e0,  gp=}0xc0000035000xc000003500)
? m=nil)
 [		/home/esk/dev/wirecage/wgcage.go/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.goGC scavenge wait::]:
435472 +runtime.gopark0xce +( fp=0x262b0xc00004a0800xc0000a5f78? fp=,  sp=0xc000291ef80xc0000a5f580x843bc0 sp= pc=?0xc000290ae80x47102e
runtime.goparkunlock(..., )
 pc=0x10x6bdc4b
/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go?main.main, (0x0)
?	, /home/esk/dev/wirecage/wgcage.go0xc000003500:?482)
 +	0x4c/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go fp=:0xc000291f50435 sp= +0xc000291ef8 pc=0x6bf4cc
0xceruntime.main fp=(0xc0000a3f78)
 sp=	0xc0000a3f58/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:283 +0x28b pc= fp=0x47102e0xc000291fe0
 sp=0xc000291f50runtime.goparkunlock pc=(0x43e52b...
)
runtime.goexit	(/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go{:}441)

	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.sruntime.(*scavengerState).park:(17000xad2e00 +)
0x1	 fp=/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgcscavenge.go0xc000291fe8: sp=4250xc000291fe0 + pc=0x490x478861 fp=
0xc0000a3fa8 sp=
0xc0000a3f78goroutine  pc=20x426da9 gp=
0xc000002e00 m=nilruntime.bgscavenge [(force gc (idle)0xc00004a080, )
3	 minutes/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgcscavenge.go]:
:653runtime.gopark +(0x3c0x33446b15adc46 fp=?0xc0000a3fc8,  sp=0x00xc0000a3fa8? pc=, 0x42731c0x0
?runtime.gcenable.gowrap2, (0x0)
?	, /nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go0x0:?205)
 +	0x25/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go fp=:0xc0000a3fe0435 sp= +0xc0000a3fc80xce pc= fp=0x41d9650xc0000a4fa8
 sp=runtime.goexit0xc0000a4f88( pc={0x47102e}
)
	runtime.goparkunlock/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s(:...1700)
 +	0x1/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go fp=:0xc0000a3fe8441 sp=
0xc0000a3fe0 pc=runtime.forcegchelper0x478861(
)
created by 	runtime.gcenable/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go in goroutine :1348
 +	0xb3/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go fp=:0xc0000a4fe0205 sp= +0xc0000a4fa80xa5 pc=
0x43e873

runtime.goexitgoroutine (5{ gp=}0xc000003dc0)
 m=nil	 [/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.sfinalizer wait:]:
1700 +runtime.gopark0x1( fp=0x1b80xc0000a4fe8? sp=, 0xc0000a4fe00xc000002380 pc=?0x478861,
0x1created by ?runtime.init.7,  in goroutine 0x231?
, 	0xc0000a2688/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go?:)
336	 +/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go0x1a:
435
 +goroutine 0xce3 fp= gp=0xc0000a26300xc000003340 sp= m=nil0xc0000a2610 [ pc=GC sweep wait0x47102e]:

runtime.goparkruntime.runfinq((0x1)
?	, /nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mfinal.go0x0:?196,  +0x00x107? fp=, 0xc0000a27e00x0 sp=?0xc0000a2630,  pc=0x00x41c987?
)
runtime.goexit	(/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go{:}435)
 +	0xce/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s fp=::0xc0000a57801700441 sp= +
0x10xc0000a5760 fp=runtime.(*scavengerState).park pc=0xc0000a27e8( sp=0x47102e0xc0000a27e00xad2e00 pc=
)
0x478861	runtime.goparkunlock/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgcscavenge.go
(:...created by 425)
 +runtime.createfing0x49	 fp= in goroutine 0xc0000a5fa8/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go1: sp=441
0xc0000a5f78
 pc=	0x426da9runtime.bgsweep
/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mfinal.go(runtime.bgscavenge:0xc00004c080166()
 +0xc00004c0800x3d
/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgcsweep.go)
:
316	goroutine /nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgcscavenge.go +60xdf: fp= gp=0xc0000a57c86530xc00019e000 sp= +0xc0000a5780 m=nil0x3c [ pc=chan receive0x42933f fp=
]:
0xc0000a5fc8runtime.gcenable.gowrap1 sp=runtime.gopark(0xc0000a5fa8()
 pc=	0x42731c0x0
/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go?:runtime.gcenable.gowrap2204, (0x0 +)
0x25?	,  fp=/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go0x00xc0000a57e0: sp=205?0xc0000a57c8 + pc=, 0x250x41d9c50x0
 fp=?runtime.goexit0xc0000a5fe0, ( sp=0x0{?0xc0000a5fc8})
 pc=	0x41d965)

	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.goruntime.goexit:/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s(:4351700{ + +0x1} fp=0xce)
 fp=0xc0000a57e80xc0000a4718	 sp= sp=/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s0xc0000a57e0: pc=0xc0000a46f81700 pc=0x478861 +0x47102e0x1

 fp=created by 0xc0000a5fe8runtime.gcenable sp= in goroutine 0xc0000a5fe0runtime.chanrecv pc=10x478861
(
	0xc0000481c0created by /nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go, runtime.gcenable:0x0 in goroutine 204,  +10x1
0x66)


/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.gogoroutine ::2054 +664 gp=0xa5 +0xc0000035000x445
 fp= m=nil0xc0000a4790
 sp= [goroutine 0xc0000a47185GC scavenge wait pc= gp=]:
0x40f2650xc000003dc0runtime.gopark
 m=nil( [runtime.chanrecv1finalizer wait0x10000(]:
?0x0, ?runtime.gopark0x843bc0(, ?0x1b80x0, ??0x0, )
0xc000002380?	?, , /nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go0x00x1:?506?, ,  +0x230x00x12? fp=?, 0xc0000a47b8)
0xc0000a4688 sp=?	)
/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go0xc0000a4790	:/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go pc=:4350x40edf2435
 + +0xce0xceruntime.unique_runtime_registerUniqueMapCleanup.func2 fp=( fp=0xc0000a5f780xc0000a4630... sp= sp=)
0xc0000a46100xc0000a5f58 pc=	 pc=0x47102e/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go0x47102e:

1796runtime.runfinqruntime.goparkunlock(
)
(	runtime.unique_runtime_registerUniqueMapCleanup.gowrap1.../nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mfinal.go)
(:	196)
 +/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go	:0x107/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go441 fp=:
17990xc0000a47e0 +runtime.(*scavengerState).park0x2f sp=(0xc0000a4630 fp= pc=0xad2e000xc0000a47e00x41c987)
 sp=
	0xc0000a47b8runtime.goexit/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgcscavenge.go pc=:(0x42090f425{
 +}runtime.goexit0x49)
 fp=	(/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s0xc0000a5fa8{: sp=1700}0xc0000a5f78 +)
 pc=0x1	 fp=0x426da9/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s
0xc0000a47e8: sp=runtime.bgscavenge0xc0000a47e01700 pc=( +0x4788610xc00004c080
0x1)
created by  fp=	0xc0000a47e8runtime.createfing sp=/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgcscavenge.go in goroutine 0xc0000a47e0: pc=16580x478861

 +	created by /nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mfinal.go0x59:unique.runtime_registerUniqueMapCleanup166 fp= + in goroutine 0x3d0xc0000a5fc8
1 sp=

goroutine 0xc0000a5fa8	6/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go pc=: gp=17940xc00019e0000x427339 + m=nil
 [0x79chan receiveruntime.gcenable.gowrap2]:

(runtime.gopark)
(
	0x0rax    /nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go?0xf7, :
205rbx    0x0 +?0x30x25,
 fp=rcx    0x00xc0000a5fe0?0x40a60e sp=
, 0xc0000a5fc8rdx     pc=0x00xc00006a968?0x41d965,

0x0rdi    runtime.goexit?0x3(
)
rsi    	{/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go0x7:}
)
rbp    435	 +0xc00006a870/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s0xce
 fp=:rsp    0xc0000a67181700 sp=0xc00006a8300xc0000a66f8
 + pc=r8     0x10x47102e0xc00004e1b0

 fp=r9     0xc0000a5fe80x0 sp=
0xc0000a5fe0runtime.chanrecvr10    ( pc=0x40xc00004a1c00x478861,

r11    0x0created by , 0x212runtime.gcenable
 in goroutine 0x1r12    )
0xc00004e1b01
/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go
:	664r13    /nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go +0x38:
0x445205 fp=r14     +0xc0000a67900xc000002380 sp=0xa50xc0000a6718
 pc=
r15    0x40f265
0xc000012920
goroutine
runtime.chanrecv1rip    5(0x40a60c gp=0x0
?0xc000003dc0rflags ,  m=nil0x2120x0 [
finalizer wait?cs     , 0x33)
3
 minutes/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.gofs     ]:
0x0:
runtime.gopark506gs     (0x0 +
0x00x12? fp=, 0xc0000a67b80x7d9e90 sp=?0xc0000a6790,  pc=0xa00x40edf2?
, runtime.unique_runtime_registerUniqueMapCleanup.func20xe2(?..., )
0x2000000020	?/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go)
:	1796/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go
:435 +0xce fp=0xc0000a4630 sp=0xc0000a4610 pc=0x47102e
runtime.runfinq()
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mfinal.go:196 +runtime.unique_runtime_registerUniqueMapCleanup.gowrap1(0x107 fp=0xc0000a47e0 sp=0xc0000a4630 pc=0x41c987
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0000a47e8 sp=)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1799 +0x2f fp=0xc0000a67e0 sp=0xc0000a67b8 pc=0x42090f
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0000a67e8 sp=0xc0000a67e0 pc=0x478861
created by unique.runtime_registerUniqueMapCleanup in goroutine 1
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1794 +0x79

rax    0xf7
rbx    0x3
rcx    0x40a60e
rdx    0xc00006c968
rdi    0x3
rsi    0x5
rbp    0xc00006c870
rsp    0xc00006c830
r8     0xc000050120
r9     0x0
r10    0x4
r11    0x212
r12    0xc000050120
r13    0x38
r14    0xc000002380
r15    0x0
rip    0x40a60c
rflags 0x212
cs     0x33
fs     0x0
gs     0x0
0xc0000a47e0 pc=0x478861
created by runtime.createfing in goroutine 1
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mfinal.go:166 +0x3d

goroutine 6 gp=0xc00019e000 m=nil [chan receive]:
runtime.gopark(0xc0000ea320?, 0xc000319110?, 0x60?, 0x6f?, 0x517428?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000136f18 sp=0xc000136ef8 pc=0x47102e
runtime.chanrecv(0xc00004a1c0, 0x0, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000136f90 sp=0xc000136f18 pc=0x40f265
runtime.chanrecv1(0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:506 +0x12 fp=0xc000136fb8 sp=0xc000136f90 pc=0x40edf2
runtime.unique_runtime_registerUniqueMapCleanup.func2(...)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1796
runtime.unique_runtime_registerUniqueMapCleanup.gowrap1()
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1799 +0x2f fp=0xc000136fe0 sp=0xc000136fb8 pc=0x42090f
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000136fe8 sp=0xc000136fe0 pc=0x478861
created by unique.runtime_registerUniqueMapCleanup in goroutine 1
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1794 +0x79

goroutine 7 gp=0xc00019e1c0 m=nil [select, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0000a6eb0 sp=0xc0000a6e90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc000037520, 0x1, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0000a6ef0 sp=0xc0000a6eb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc000037520, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc0000a6f18 sp=0xc0000a6ef0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc000037508, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0000a6fc0 sp=0xc0000a6f18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0000a6fe0 sp=0xc0000a6fc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0000a6fe8 sp=0xc0000a6fe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 8 gp=0xc00019e380 m=nil [select, 3 minutes]:
runtime.gopark(0xc001bf9ec8?, 0x5ef8e5?, 0x0?, 0xe7?, 0xc001bf9f08?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0003c1eb0 sp=0xc0003c1e90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc0000375b0, 0x1, 0xe5?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0003c1ef0 sp=0xc0003c1eb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc0000375b0, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc0003c1f18 sp=0xc0003c1ef0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc000037598, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0003c1fc0 sp=0xc0003c1f18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0003c1fe0 sp=0xc0003c1fc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0003c1fe8 sp=0xc0003c1fe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 9 gp=0xc00019e540 m=nil [select, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0000a7eb0 sp=0xc0000a7e90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc000037640, 0x1, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0000a7ef0 sp=0xc0000a7eb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc000037640, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc0000a7f18 sp=0xc0000a7ef0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc000037628, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0000a7fc0 sp=0xc0000a7f18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0000a7fe0 sp=0xc0000a7fc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0000a7fe8 sp=0xc0000a7fe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 10 gp=0xc00019e700 m=nil [select, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0000a06b0 sp=0xc0000a0690 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc0000376d0, 0x1, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0000a06f0 sp=0xc0000a06b0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc0000376d0, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc0000a0718 sp=0xc0000a06f0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc0000376b8, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0000a07c0 sp=0xc0000a0718 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0000a07e0 sp=0xc0000a07c0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0000a07e8 sp=0xc0000a07e0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 11 gp=0xc00019e8c0 m=nil [select, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0000a0eb0 sp=0xc0000a0e90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc000037760, 0x1, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0000a0ef0 sp=0xc0000a0eb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc000037760, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc0000a0f18 sp=0xc0000a0ef0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc000037748, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0000a0fc0 sp=0xc0000a0f18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0000a0fe0 sp=0xc0000a0fc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0000a0fe8 sp=0xc0000a0fe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 12 gp=0xc00019ea80 m=nil [select, 3 minutes]:
runtime.gopark(0xc00001dec8?, 0x5ef8e5?, 0x0?, 0x4a?, 0xc00001df08?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc001d0deb0 sp=0xc001d0de90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc0000377f0, 0x1, 0xd0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc001d0def0 sp=0xc001d0deb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc0000377f0, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc001d0df18 sp=0xc001d0def0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc0000377d8, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc001d0dfc0 sp=0xc001d0df18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc001d0dfe0 sp=0xc001d0dfc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc001d0dfe8 sp=0xc001d0dfe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 13 gp=0xc00019ec40 m=nil [select, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0000a1eb0 sp=0xc0000a1e90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc000037880, 0x1, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0000a1ef0 sp=0xc0000a1eb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc000037880, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc0000a1f18 sp=0xc0000a1ef0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc000037868, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0000a1fc0 sp=0xc0000a1f18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0000a1fe0 sp=0xc0000a1fc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0000a1fe8 sp=0xc0000a1fe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 14 gp=0xc00019ee00 m=nil [select, 3 minutes]:
runtime.gopark(0xc001d8dec8?, 0x5ef8e5?, 0x0?, 0x8f?, 0xc001d8df08?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000447eb0 sp=0xc000447e90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc000037910, 0x1, 0xd7?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc000447ef0 sp=0xc000447eb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc000037910, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc000447f18 sp=0xc000447ef0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc0000378f8, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc000447fc0 sp=0xc000447f18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc000447fe0 sp=0xc000447fc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000447fe8 sp=0xc000447fe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 15 gp=0xc00019efc0 m=nil [select, 3 minutes]:
runtime.gopark(0xc001865ec8?, 0x5ef8e5?, 0x0?, 0xe7?, 0xc001865f08?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc001d0feb0 sp=0xc001d0fe90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc0000379a0, 0x1, 0xde?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc001d0fef0 sp=0xc001d0feb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc0000379a0, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc001d0ff18 sp=0xc001d0fef0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc000037988, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc001d0ffc0 sp=0xc001d0ff18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc001d0ffe0 sp=0xc001d0ffc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc001d0ffe8 sp=0xc001d0ffe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 16 gp=0xc00019f180 m=nil [select, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0000a36b0 sp=0xc0000a3690 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc000037a30, 0x1, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0000a36f0 sp=0xc0000a36b0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc000037a30, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc0000a3718 sp=0xc0000a36f0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc000037a18, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0000a37c0 sp=0xc0000a3718 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0000a37e0 sp=0xc0000a37c0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0000a37e8 sp=0xc0000a37e0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 18 gp=0xc00019f340 m=nil [select, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0000a3eb0 sp=0xc0000a3e90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc000037ac0, 0x1, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0000a3ef0 sp=0xc0000a3eb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc000037ac0, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc0000a3f18 sp=0xc0000a3ef0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc000037aa8, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0000a3fc0 sp=0xc0000a3f18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0000a3fe0 sp=0xc0000a3fc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0000a3fe8 sp=0xc0000a3fe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 19 gp=0xc00019f500 m=nil [select, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0001e46b0 sp=0xc0001e4690 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc000037b50, 0x1, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0001e46f0 sp=0xc0001e46b0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc000037b50, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc0001e4718 sp=0xc0001e46f0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc000037b38, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0001e47c0 sp=0xc0001e4718 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0001e47e0 sp=0xc0001e47c0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0001e47e8 sp=0xc0001e47e0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 20 gp=0xc00019f6c0 m=nil [select, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0001e4eb0 sp=0xc0001e4e90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc000037be0, 0x1, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0001e4ef0 sp=0xc0001e4eb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc000037be0, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc0001e4f18 sp=0xc0001e4ef0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc000037bc8, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0001e4fc0 sp=0xc0001e4f18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0001e4fe0 sp=0xc0001e4fc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0001e4fe8 sp=0xc0001e4fe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 21 gp=0xc00019f880 m=nil [select, 3 minutes]:
runtime.gopark(0xc000349ec8?, 0x5ef8e5?, 0x0?, 0x42?, 0xc000349f08?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc001d8deb0 sp=0xc001d8de90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc000037c70, 0x1, 0xd0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc001d8def0 sp=0xc001d8deb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc000037c70, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc001d8df18 sp=0xc001d8def0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc000037c58, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc001d8dfc0 sp=0xc001d8df18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc001d8dfe0 sp=0xc001d8dfc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc001d8dfe8 sp=0xc001d8dfe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 22 gp=0xc00019fa40 m=nil [select, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0001e5eb0 sp=0xc0001e5e90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc000037d00, 0x1, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0001e5ef0 sp=0xc0001e5eb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc000037d00, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc0001e5f18 sp=0xc0001e5ef0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc000037ce8, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0001e5fc0 sp=0xc0001e5f18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0001e5fe0 sp=0xc0001e5fc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0001e5fe8 sp=0xc0001e5fe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 23 gp=0xc00019fc00 m=nil [select, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0001e66b0 sp=0xc0001e6690 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc000037d90, 0x1, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0001e66f0 sp=0xc0001e66b0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc000037d90, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc0001e6718 sp=0xc0001e66f0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc000037d78, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0001e67c0 sp=0xc0001e6718 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0001e67e0 sp=0xc0001e67c0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0001e67e8 sp=0xc0001e67e0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 24 gp=0xc00019fdc0 m=nil [select, 3 minutes]:
runtime.gopark(0xc0000b4fb0?, 0x2?, 0xc0?, 0x25?, 0xc0000b4f94?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0000b4e20 sp=0xc0000b4e00 pc=0x47102e
runtime.selectgo(0xc0000b4fb0, 0xc0000b4f90, 0x0?, 0x0, 0x0?, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/select.go:351 +0x837 fp=0xc0000b4f58 sp=0xc0000b4e20 pc=0x450bf7
go.euank.com/wireguard/ratelimiter.(*Ratelimiter).Init.func1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/ratelimiter/ratelimiter.go:68 +0x8f fp=0xc0000b4fe0 sp=0xc0000b4f58 pc=0x69ce8f
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0000b4fe8 sp=0xc0000b4fe0 pc=0x478861
created by go.euank.com/wireguard/ratelimiter.(*Ratelimiter).Init in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/ratelimiter/ratelimiter.go:64 +0x147

goroutine 25 gp=0xc0001fa000 m=nil [sync.WaitGroup.Wait, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x80?, 0x1?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0001e76f8 sp=0xc0001e76d8 pc=0x47102e
runtime.goparkunlock(...)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:441
runtime.semacquire1(0xc000010418, 0x0, 0x1, 0x0, 0x18)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/sema.go:188 +0x21d fp=0xc0001e7760 sp=0xc0001e76f8 pc=0x451c9d
sync.runtime_SemacquireWaitGroup(0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/sema.go:110 +0x25 fp=0xc0001e7798 sp=0xc0001e7760 pc=0x4726e5
sync.(*WaitGroup).Wait(0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/sync/waitgroup.go:118 +0x48 fp=0xc0001e77c0 sp=0xc0001e7798 pc=0x481de8
go.euank.com/wireguard/device.newHandshakeQueue.func1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/channels.go:68 +0x25 fp=0xc0001e77e0 sp=0xc0001e77c0 pc=0x6a1065
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0001e77e8 sp=0xc0001e77e0 pc=0x478861
created by go.euank.com/wireguard/device.newHandshakeQueue in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/channels.go:67 +0xa5

goroutine 26 gp=0xc0001fa1c0 m=nil [sync.WaitGroup.Wait, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0xe0?, 0x1?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0001e7ef8 sp=0xc0001e7ed8 pc=0x47102e
runtime.goparkunlock(...)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:441
runtime.semacquire1(0xc000010430, 0x0, 0x1, 0x0, 0x18)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/sema.go:188 +0x21d fp=0xc0001e7f60 sp=0xc0001e7ef8 pc=0x451c9d
sync.runtime_SemacquireWaitGroup(0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/sema.go:110 +0x25 fp=0xc0001e7f98 sp=0xc0001e7f60 pc=0x4726e5
sync.(*WaitGroup).Wait(0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/sync/waitgroup.go:118 +0x48 fp=0xc0001e7fc0 sp=0xc0001e7f98 pc=0x481de8
go.euank.com/wireguard/device.newOutboundQueue.func1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/channels.go:32 +0x25 fp=0xc0001e7fe0 sp=0xc0001e7fc0 pc=0x6a0e65
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0001e7fe8 sp=0xc0001e7fe0 pc=0x478861
created by go.euank.com/wireguard/device.newOutboundQueue in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/channels.go:31 +0xa5

goroutine 27 gp=0xc0001fa380 m=nil [sync.WaitGroup.Wait, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x40?, 0x2?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0001e06f8 sp=0xc0001e06d8 pc=0x47102e
runtime.goparkunlock(...)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:441
runtime.semacquire1(0xc000010448, 0x0, 0x1, 0x0, 0x18)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/sema.go:188 +0x21d fp=0xc0001e0760 sp=0xc0001e06f8 pc=0x451c9d
sync.runtime_SemacquireWaitGroup(0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/sema.go:110 +0x25 fp=0xc0001e0798 sp=0xc0001e0760 pc=0x4726e5
sync.(*WaitGroup).Wait(0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/sync/waitgroup.go:118 +0x48 fp=0xc0001e07c0 sp=0xc0001e0798 pc=0x481de8
go.euank.com/wireguard/device.newInboundQueue.func1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/channels.go:50 +0x25 fp=0xc0001e07e0 sp=0xc0001e07c0 pc=0x6a0f65
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0001e07e8 sp=0xc0001e07e0 pc=0x478861
created by go.euank.com/wireguard/device.newInboundQueue in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/channels.go:49 +0xa5

goroutine 28 gp=0xc0001fa540 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x5b0?, 0xffff?, 0x0?, 0x0?, 0xc000283e50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000283dc0 sp=0xc000283da0 pc=0x47102e
runtime.chanrecv(0xc000191c00, 0xc000283f40, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000283e38 sp=0xc000283dc0 pc=0x40f265
runtime.chanrecv2(0xc001d30010?, 0x590?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000283e60 sp=0xc000283e38 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineEncryption(0xc0001ea008, 0x1)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/send.go:451 +0x1c5 fp=0xc000283fc0 sp=0xc000283e60 pc=0x6b1745
go.euank.com/wireguard/device.NewDevice.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x25 fp=0xc000283fe0 sp=0xc000283fc0 pc=0x6a42a5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000283fe8 sp=0xc000283fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x385

goroutine 29 gp=0xc0001fa700 m=nil [chan receive, 3 minutes]:
runtime.gopark(0xffef?, 0xc001082010?, 0x10?, 0x20?, 0xc0000b5e88?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0000b5df8 sp=0xc0000b5dd8 pc=0x47102e
runtime.chanrecv(0xc000191c70, 0xc0000b5f48, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc0000b5e70 sp=0xc0000b5df8 pc=0x40f265
runtime.chanrecv2(0xc001082010?, 0x180?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc0000b5e98 sp=0xc0000b5e70 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineDecryption(0xc0001ea008, 0x1)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:244 +0x1c5 fp=0xc0000b5fc0 sp=0xc0000b5e98 pc=0x6ad3a5
go.euank.com/wireguard/device.NewDevice.gowrap2()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x25 fp=0xc0000b5fe0 sp=0xc0000b5fc0 pc=0x6a4245
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0000b5fe8 sp=0xc0000b5fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x3ca

goroutine 30 gp=0xc0001fa8c0 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x0?, 0xc0002cc488?, 0xa0?, 0x43?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000282c40 sp=0xc000282c20 pc=0x47102e
runtime.chanrecv(0xc000191b90, 0xc0003bdf20, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000282cb8 sp=0xc000282c40 pc=0x40f265
runtime.chanrecv2(0xc000191a40?, 0x70f360?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000282ce0 sp=0xc000282cb8 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineHandshake(0xc0001ea008, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:278 +0x17e fp=0xc000282fc0 sp=0xc000282ce0 pc=0x6ad7be
go.euank.com/wireguard/device.NewDevice.gowrap3()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x25 fp=0xc000282fe0 sp=0xc000282fc0 pc=0x6a41e5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000282fe8 sp=0xc000282fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x31b

goroutine 31 gp=0xc0001faa80 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x5b0?, 0xffff?, 0x0?, 0xa0?, 0xc000392e50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000392dc0 sp=0xc000392da0 pc=0x47102e
runtime.chanrecv(0xc000191c00, 0xc000392f40, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000392e38 sp=0xc000392dc0 pc=0x40f265
runtime.chanrecv2(0xc001c2a010?, 0x590?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000392e60 sp=0xc000392e38 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineEncryption(0xc0001ea008, 0x2)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/send.go:451 +0x1c5 fp=0xc000392fc0 sp=0xc000392e60 pc=0x6b1745
go.euank.com/wireguard/device.NewDevice.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x25 fp=0xc000392fe0 sp=0xc000392fc0 pc=0x6a42a5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000392fe8 sp=0xc000392fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x385

goroutine 32 gp=0xc0001fac40 m=nil [chan receive, 3 minutes]:
runtime.gopark(0xffef?, 0xc001dac010?, 0x10?, 0xc0?, 0xc000284e88?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000284df8 sp=0xc000284dd8 pc=0x47102e
runtime.chanrecv(0xc000191c70, 0xc000284f48, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000284e70 sp=0xc000284df8 pc=0x40f265
runtime.chanrecv2(0xc001dac010?, 0x50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000284e98 sp=0xc000284e70 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineDecryption(0xc0001ea008, 0x2)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:244 +0x1c5 fp=0xc000284fc0 sp=0xc000284e98 pc=0x6ad3a5
go.euank.com/wireguard/device.NewDevice.gowrap2()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x25 fp=0xc000284fe0 sp=0xc000284fc0 pc=0x6a4245
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000284fe8 sp=0xc000284fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x3ca

goroutine 33 gp=0xc0001fae00 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0000b6c40 sp=0xc0000b6c20 pc=0x47102e
runtime.chanrecv(0xc000191b90, 0xc000299f20, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc0000b6cb8 sp=0xc0000b6c40 pc=0x40f265
runtime.chanrecv2(0xc000068530?, 0x84db38?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc0000b6ce0 sp=0xc0000b6cb8 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineHandshake(0xc0001ea008, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:278 +0x17e fp=0xc0000b6fc0 sp=0xc0000b6ce0 pc=0x6ad7be
go.euank.com/wireguard/device.NewDevice.gowrap3()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x25 fp=0xc0000b6fe0 sp=0xc0000b6fc0 pc=0x6a41e5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0000b6fe8 sp=0xc0000b6fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x31b

goroutine 34 gp=0xc0001fafc0 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x60?, 0xffff?, 0x0?, 0xa0?, 0xc000396e50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000396dc0 sp=0xc000396da0 pc=0x47102e
runtime.chanrecv(0xc000191c00, 0xc000396f40, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000396e38 sp=0xc000396dc0 pc=0x40f265
runtime.chanrecv2(0xc001c3a010?, 0x40?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000396e60 sp=0xc000396e38 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineEncryption(0xc0001ea008, 0x3)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/send.go:451 +0x1c5 fp=0xc000396fc0 sp=0xc000396e60 pc=0x6b1745
go.euank.com/wireguard/device.NewDevice.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x25 fp=0xc000396fe0 sp=0xc000396fc0 pc=0x6a42a5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000396fe8 sp=0xc000396fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x385

goroutine 35 gp=0xc0001fb180 m=nil [chan receive, 3 minutes]:
runtime.gopark(0xffef?, 0xc001d20010?, 0x10?, 0x0?, 0xc000285e88?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000285df8 sp=0xc000285dd8 pc=0x47102e
runtime.chanrecv(0xc000191c70, 0xc000285f48, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000285e70 sp=0xc000285df8 pc=0x40f265
runtime.chanrecv2(0xc001d20010?, 0x50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000285e98 sp=0xc000285e70 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineDecryption(0xc0001ea008, 0x3)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:244 +0x1c5 fp=0xc000285fc0 sp=0xc000285e98 pc=0x6ad3a5
go.euank.com/wireguard/device.NewDevice.gowrap2()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x25 fp=0xc000285fe0 sp=0xc000285fc0 pc=0x6a4245
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000285fe8 sp=0xc000285fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x3ca

goroutine 36 gp=0xc0001fb340 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0000b7c40 sp=0xc0000b7c20 pc=0x47102e
runtime.chanrecv(0xc000191b90, 0xc0002a3f20, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc0000b7cb8 sp=0xc0000b7c40 pc=0x40f265
runtime.chanrecv2(0xc000068530?, 0x84db38?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc0000b7ce0 sp=0xc0000b7cb8 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineHandshake(0xc0001ea008, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:278 +0x17e fp=0xc0000b7fc0 sp=0xc0000b7ce0 pc=0x6ad7be
go.euank.com/wireguard/device.NewDevice.gowrap3()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x25 fp=0xc0000b7fe0 sp=0xc0000b7fc0 pc=0x6a41e5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0000b7fe8 sp=0xc0000b7fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x31b

goroutine 37 gp=0xc0001fb500 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x60?, 0xffff?, 0x0?, 0xa0?, 0xc000397e50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000397dc0 sp=0xc000397da0 pc=0x47102e
runtime.chanrecv(0xc000191c00, 0xc000397f40, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000397e38 sp=0xc000397dc0 pc=0x40f265
runtime.chanrecv2(0xc001c2a010?, 0x40?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000397e60 sp=0xc000397e38 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineEncryption(0xc0001ea008, 0x4)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/send.go:451 +0x1c5 fp=0xc000397fc0 sp=0xc000397e60 pc=0x6b1745
go.euank.com/wireguard/device.NewDevice.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x25 fp=0xc000397fe0 sp=0xc000397fc0 pc=0x6a42a5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000397fe8 sp=0xc000397fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x385

goroutine 38 gp=0xc0001fb6c0 m=nil [chan receive, 3 minutes]:
runtime.gopark(0xffef?, 0x0?, 0x0?, 0x0?, 0xad8c40?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc00034edf8 sp=0xc00034edd8 pc=0x47102e
runtime.chanrecv(0xc000191c70, 0xc00034ef48, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc00034ee70 sp=0xc00034edf8 pc=0x40f265
runtime.chanrecv2(0xc001082010?, 0x50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc00034ee98 sp=0xc00034ee70 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineDecryption(0xc0001ea008, 0x4)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:244 +0x1c5 fp=0xc00034efc0 sp=0xc00034ee98 pc=0x6ad3a5
go.euank.com/wireguard/device.NewDevice.gowrap2()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x25 fp=0xc00034efe0 sp=0xc00034efc0 pc=0x6a4245
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc00034efe8 sp=0xc00034efe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x3ca

goroutine 39 gp=0xc0001fb880 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000138c40 sp=0xc000138c20 pc=0x47102e
runtime.chanrecv(0xc000191b90, 0xc00039bf20, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000138cb8 sp=0xc000138c40 pc=0x40f265
runtime.chanrecv2(0xc000068530?, 0x84db38?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000138ce0 sp=0xc000138cb8 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineHandshake(0xc0001ea008, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:278 +0x17e fp=0xc000138fc0 sp=0xc000138ce0 pc=0x6ad7be
go.euank.com/wireguard/device.NewDevice.gowrap3()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x25 fp=0xc000138fe0 sp=0xc000138fc0 pc=0x6a41e5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000138fe8 sp=0xc000138fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x31b

goroutine 40 gp=0xc0001fba40 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x60?, 0xffff?, 0x0?, 0x0?, 0xc000398e50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000398dc0 sp=0xc000398da0 pc=0x47102e
runtime.chanrecv(0xc000191c00, 0xc000398f40, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000398e38 sp=0xc000398dc0 pc=0x40f265
runtime.chanrecv2(0xc001d20010?, 0x40?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000398e60 sp=0xc000398e38 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineEncryption(0xc0001ea008, 0x5)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/send.go:451 +0x1c5 fp=0xc000398fc0 sp=0xc000398e60 pc=0x6b1745
go.euank.com/wireguard/device.NewDevice.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x25 fp=0xc000398fe0 sp=0xc000398fc0 pc=0x6a42a5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000398fe8 sp=0xc000398fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x385

goroutine 41 gp=0xc0001fbc00 m=nil [chan receive, 3 minutes]:
runtime.gopark(0xffef?, 0xc001c3a010?, 0x10?, 0xa0?, 0xc000288e88?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000288df8 sp=0xc000288dd8 pc=0x47102e
runtime.chanrecv(0xc000191c70, 0xc000288f48, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000288e70 sp=0xc000288df8 pc=0x40f265
runtime.chanrecv2(0xc001c3a010?, 0x10?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000288e98 sp=0xc000288e70 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineDecryption(0xc0001ea008, 0x5)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:244 +0x1c5 fp=0xc000288fc0 sp=0xc000288e98 pc=0x6ad3a5
go.euank.com/wireguard/device.NewDevice.gowrap2()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x25 fp=0xc000288fe0 sp=0xc000288fc0 pc=0x6a4245
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000288fe8 sp=0xc000288fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x3ca

goroutine 42 gp=0xc0001fbdc0 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000399c40 sp=0xc000399c20 pc=0x47102e
runtime.chanrecv(0xc000191b90, 0xc0002a9f20, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000399cb8 sp=0xc000399c40 pc=0x40f265
runtime.chanrecv2(0xc000068530?, 0x84db38?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000399ce0 sp=0xc000399cb8 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineHandshake(0xc0001ea008, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:278 +0x17e fp=0xc000399fc0 sp=0xc000399ce0 pc=0x6ad7be
go.euank.com/wireguard/device.NewDevice.gowrap3()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x25 fp=0xc000399fe0 sp=0xc000399fc0 pc=0x6a41e5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000399fe8 sp=0xc000399fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x31b

goroutine 43 gp=0xc0001fe000 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x60?, 0xffff?, 0x0?, 0x80?, 0xc000289e50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000289dc0 sp=0xc000289da0 pc=0x47102e
runtime.chanrecv(0xc000191c00, 0xc000289f40, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000289e38 sp=0xc000289dc0 pc=0x40f265
runtime.chanrecv2(0xc001d48010?, 0x40?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000289e60 sp=0xc000289e38 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineEncryption(0xc0001ea008, 0x6)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/send.go:451 +0x1c5 fp=0xc000289fc0 sp=0xc000289e60 pc=0x6b1745
go.euank.com/wireguard/device.NewDevice.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x25 fp=0xc000289fe0 sp=0xc000289fc0 pc=0x6a42a5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000289fe8 sp=0xc000289fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x385

goroutine 44 gp=0xc0001fe1c0 m=nil [chan receive, 3 minutes]:
runtime.gopark(0xffef?, 0xc001c3a010?, 0x10?, 0xa0?, 0xc00034ae88?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc00034adf8 sp=0xc00034add8 pc=0x47102e
runtime.chanrecv(0xc000191c70, 0xc00034af48, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc00034ae70 sp=0xc00034adf8 pc=0x40f265
runtime.chanrecv2(0xc001c3a010?, 0x50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc00034ae98 sp=0xc00034ae70 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineDecryption(0xc0001ea008, 0x6)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:244 +0x1c5 fp=0xc00034afc0 sp=0xc00034ae98 pc=0x6ad3a5
go.euank.com/wireguard/device.NewDevice.gowrap2()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x25 fp=0xc00034afe0 sp=0xc00034afc0 pc=0x6a4245
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc00034afe8 sp=0xc00034afe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x3ca

goroutine 45 gp=0xc0001fe380 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000134c40 sp=0xc000134c20 pc=0x47102e
runtime.chanrecv(0xc000191b90, 0xc00032bf20, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000134cb8 sp=0xc000134c40 pc=0x40f265
runtime.chanrecv2(0xc000068530?, 0x84db38?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000134ce0 sp=0xc000134cb8 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineHandshake(0xc0001ea008, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:278 +0x17e fp=0xc000134fc0 sp=0xc000134ce0 pc=0x6ad7be
go.euank.com/wireguard/device.NewDevice.gowrap3()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x25 fp=0xc000134fe0 sp=0xc000134fc0 pc=0x6a41e5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000134fe8 sp=0xc000134fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x31b

goroutine 46 gp=0xc0001fe540 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x60?, 0xffff?, 0x0?, 0xc0?, 0xc00034fe50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc00034fdc0 sp=0xc00034fda0 pc=0x47102e
runtime.chanrecv(0xc000191c00, 0xc00034ff40, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc00034fe38 sp=0xc00034fdc0 pc=0x40f265
runtime.chanrecv2(0xc001dac010?, 0x40?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc00034fe60 sp=0xc00034fe38 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineEncryption(0xc0001ea008, 0x7)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/send.go:451 +0x1c5 fp=0xc00034ffc0 sp=0xc00034fe60 pc=0x6b1745
go.euank.com/wireguard/device.NewDevice.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x25 fp=0xc00034ffe0 sp=0xc00034ffc0 pc=0x6a42a5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc00034ffe8 sp=0xc00034ffe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x385

goroutine 47 gp=0xc0001fe700 m=nil [chan receive, 3 minutes]:
runtime.gopark(0xffef?, 0xc001082010?, 0x10?, 0x20?, 0xc000350e88?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000350df8 sp=0xc000350dd8 pc=0x47102e
runtime.chanrecv(0xc000191c70, 0xc000350f48, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000350e70 sp=0xc000350df8 pc=0x40f265
runtime.chanrecv2(0xc001082010?, 0x10?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000350e98 sp=0xc000350e70 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineDecryption(0xc0001ea008, 0x7)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:244 +0x1c5 fp=0xc000350fc0 sp=0xc000350e98 pc=0x6ad3a5
go.euank.com/wireguard/device.NewDevice.gowrap2()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x25 fp=0xc000350fe0 sp=0xc000350fc0 pc=0x6a4245
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000350fe8 sp=0xc000350fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x3ca

goroutine 48 gp=0xc0001fe8c0 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000351c40 sp=0xc000351c20 pc=0x47102e
runtime.chanrecv(0xc000191b90, 0xc000329f20, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000351cb8 sp=0xc000351c40 pc=0x40f265
runtime.chanrecv2(0xc000068530?, 0x84db38?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000351ce0 sp=0xc000351cb8 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineHandshake(0xc0001ea008, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:278 +0x17e fp=0xc000351fc0 sp=0xc000351ce0 pc=0x6ad7be
go.euank.com/wireguard/device.NewDevice.gowrap3()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x25 fp=0xc000351fe0 sp=0xc000351fc0 pc=0x6a41e5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000351fe8 sp=0xc000351fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x31b

goroutine 49 gp=0xc0001fea80 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x5b0?, 0xffff?, 0x0?, 0xe0?, 0xc0000bbe50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0000bbdc0 sp=0xc0000bbda0 pc=0x47102e
runtime.chanrecv(0xc000191c00, 0xc0000bbf40, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc0000bbe38 sp=0xc0000bbdc0 pc=0x40f265
runtime.chanrecv2(0xc001c5e010?, 0x590?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc0000bbe60 sp=0xc0000bbe38 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineEncryption(0xc0001ea008, 0x8)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/send.go:451 +0x1c5 fp=0xc0000bbfc0 sp=0xc0000bbe60 pc=0x6b1745
go.euank.com/wireguard/device.NewDevice.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x25 fp=0xc0000bbfe0 sp=0xc0000bbfc0 pc=0x6a42a5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0000bbfe8 sp=0xc0000bbfe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x385

goroutine 50 gp=0xc0001fec40 m=nil [chan receive, 3 minutes]:
runtime.gopark(0xffef?, 0xc001dbc010?, 0x10?, 0xc0?, 0xc000356e88?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000356df8 sp=0xc000356dd8 pc=0x47102e
runtime.chanrecv(0xc000191c70, 0xc000356f48, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000356e70 sp=0xc000356df8 pc=0x40f265
runtime.chanrecv2(0xc001dbc010?, 0x50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000356e98 sp=0xc000356e70 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineDecryption(0xc0001ea008, 0x8)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:244 +0x1c5 fp=0xc000356fc0 sp=0xc000356e98 pc=0x6ad3a5
go.euank.com/wireguard/device.NewDevice.gowrap2()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x25 fp=0xc000356fe0 sp=0xc000356fc0 pc=0x6a4245
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000356fe8 sp=0xc000356fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x3ca

goroutine 51 gp=0xc0001fee00 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc00034bc40 sp=0xc00034bc20 pc=0x47102e
runtime.chanrecv(0xc000191b90, 0xc00029df20, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc00034bcb8 sp=0xc00034bc40 pc=0x40f265
runtime.chanrecv2(0xc000068530?, 0x84db38?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc00034bce0 sp=0xc00034bcb8 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineHandshake(0xc0001ea008, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:278 +0x17e fp=0xc00034bfc0 sp=0xc00034bce0 pc=0x6ad7be
go.euank.com/wireguard/device.NewDevice.gowrap3()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x25 fp=0xc00034bfe0 sp=0xc00034bfc0 pc=0x6a41e5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc00034bfe8 sp=0xc00034bfe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x31b

goroutine 52 gp=0xc0001fefc0 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x5b0?, 0xffff?, 0x0?, 0xa0?, 0xc0003c4e50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0003c4dc0 sp=0xc0003c4da0 pc=0x47102e
runtime.chanrecv(0xc000191c00, 0xc0003c4f40, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc0003c4e38 sp=0xc0003c4dc0 pc=0x40f265
runtime.chanrecv2(0xc001c3a010?, 0x590?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc0003c4e60 sp=0xc0003c4e38 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineEncryption(0xc0001ea008, 0x9)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/send.go:451 +0x1c5 fp=0xc0003c4fc0 sp=0xc0003c4e60 pc=0x6b1745
go.euank.com/wireguard/device.NewDevice.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x25 fp=0xc0003c4fe0 sp=0xc0003c4fc0 pc=0x6a42a5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0003c4fe8 sp=0xc0003c4fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x385

goroutine 53 gp=0xc0001ff180 m=nil [chan receive, 3 minutes]:
runtime.gopark(0xffef?, 0xc001d30010?, 0x10?, 0x0?, 0xc000393e88?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000393df8 sp=0xc000393dd8 pc=0x47102e
runtime.chanrecv(0xc000191c70, 0xc000393f48, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000393e70 sp=0xc000393df8 pc=0x40f265
runtime.chanrecv2(0xc001d30010?, 0x50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000393e98 sp=0xc000393e70 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineDecryption(0xc0001ea008, 0x9)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:244 +0x1c5 fp=0xc000393fc0 sp=0xc000393e98 pc=0x6ad3a5
go.euank.com/wireguard/device.NewDevice.gowrap2()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x25 fp=0xc000393fe0 sp=0xc000393fc0 pc=0x6a4245
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000393fe8 sp=0xc000393fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x3ca

goroutine 54 gp=0xc0001ff340 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc00034cc40 sp=0xc00034cc20 pc=0x47102e
runtime.chanrecv(0xc000191b90, 0xc0002a7f20, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc00034ccb8 sp=0xc00034cc40 pc=0x40f265
runtime.chanrecv2(0xc000068530?, 0x84db38?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc00034cce0 sp=0xc00034ccb8 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineHandshake(0xc0001ea008, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:278 +0x17e fp=0xc00034cfc0 sp=0xc00034cce0 pc=0x6ad7be
go.euank.com/wireguard/device.NewDevice.gowrap3()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x25 fp=0xc00034cfe0 sp=0xc00034cfc0 pc=0x6a41e5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc00034cfe8 sp=0xc00034cfe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x31b

goroutine 55 gp=0xc0001ff500 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x60?, 0xffff?, 0x0?, 0xa0?, 0xc00034de50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc00034ddc0 sp=0xc00034dda0 pc=0x47102e
runtime.chanrecv(0xc000191c00, 0xc00034df40, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc00034de38 sp=0xc00034ddc0 pc=0x40f265
runtime.chanrecv2(0xc001c3a010?, 0x40?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc00034de60 sp=0xc00034de38 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineEncryption(0xc0001ea008, 0xa)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/send.go:451 +0x1c5 fp=0xc00034dfc0 sp=0xc00034de60 pc=0x6b1745
go.euank.com/wireguard/device.NewDevice.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x25 fp=0xc00034dfe0 sp=0xc00034dfc0 pc=0x6a42a5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc00034dfe8 sp=0xc00034dfe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x385

goroutine 56 gp=0xc0001ff6c0 m=nil [chan receive, 3 minutes]:
runtime.gopark(0xffef?, 0xc001d20010?, 0x10?, 0x0?, 0xc000394e88?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000394df8 sp=0xc000394dd8 pc=0x47102e
runtime.chanrecv(0xc000191c70, 0xc000394f48, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000394e70 sp=0xc000394df8 pc=0x40f265
runtime.chanrecv2(0xc001d20010?, 0x180?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000394e98 sp=0xc000394e70 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineDecryption(0xc0001ea008, 0xa)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:244 +0x1c5 fp=0xc000394fc0 sp=0xc000394e98 pc=0x6ad3a5
go.euank.com/wireguard/device.NewDevice.gowrap2()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x25 fp=0xc000394fe0 sp=0xc000394fc0 pc=0x6a4245
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000394fe8 sp=0xc000394fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x3ca

goroutine 57 gp=0xc0001ff880 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0003c8c40 sp=0xc0003c8c20 pc=0x47102e
runtime.chanrecv(0xc000191b90, 0xc0002b7f20, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc0003c8cb8 sp=0xc0003c8c40 pc=0x40f265
runtime.chanrecv2(0xc000068530?, 0x84db38?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc0003c8ce0 sp=0xc0003c8cb8 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineHandshake(0xc0001ea008, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:278 +0x17e fp=0xc0003c8fc0 sp=0xc0003c8ce0 pc=0x6ad7be
go.euank.com/wireguard/device.NewDevice.gowrap3()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x25 fp=0xc0003c8fe0 sp=0xc0003c8fc0 pc=0x6a41e5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0003c8fe8 sp=0xc0003c8fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x31b

goroutine 58 gp=0xc0001ffa40 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x60?, 0xffff?, 0x0?, 0xa0?, 0xc000395e50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000395dc0 sp=0xc000395da0 pc=0x47102e
runtime.chanrecv(0xc000191c00, 0xc000395f40, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000395e38 sp=0xc000395dc0 pc=0x40f265
runtime.chanrecv2(0xc001c2a010?, 0x40?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000395e60 sp=0xc000395e38 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineEncryption(0xc0001ea008, 0xb)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/send.go:451 +0x1c5 fp=0xc000395fc0 sp=0xc000395e60 pc=0x6b1745
go.euank.com/wireguard/device.NewDevice.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x25 fp=0xc000395fe0 sp=0xc000395fc0 pc=0x6a42a5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000395fe8 sp=0xc000395fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x385

goroutine 59 gp=0xc0001ffc00 m=nil [chan receive, 3 minutes]:
runtime.gopark(0xffef?, 0xc00036a010?, 0x10?, 0xa0?, 0xc00043ee88?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc00043edf8 sp=0xc00043edd8 pc=0x47102e
runtime.chanrecv(0xc000191c70, 0xc00043ef48, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc00043ee70 sp=0xc00043edf8 pc=0x40f265
runtime.chanrecv2(0xc00036a010?, 0x50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc00043ee98 sp=0xc00043ee70 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineDecryption(0xc0001ea008, 0xb)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:244 +0x1c5 fp=0xc00043efc0 sp=0xc00043ee98 pc=0x6ad3a5
go.euank.com/wireguard/device.NewDevice.gowrap2()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x25 fp=0xc00043efe0 sp=0xc00043efc0 pc=0x6a4245
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc00043efe8 sp=0xc00043efe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x3ca

goroutine 60 gp=0xc0001ffdc0 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000352c40 sp=0xc000352c20 pc=0x47102e
runtime.chanrecv(0xc000191b90, 0xc000127f20, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000352cb8 sp=0xc000352c40 pc=0x40f265
~/de/wirecage main ?2 ❯ 0xc000068530?, 0x84db38?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:                                               3511 +0x12 fp=0xc000352ce0 sp=0xc000352cb8 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineHandshake(0xc0001ea008, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:278 +0x17e fp=0xc000352fc0 sp=0xc000352ce0 pc=0x6ad7be
go.euank.com/wireguard/device.NewDevice.gowrap3()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x25 fp=0xc000352fe0 sp=0xc000352fc0 pc=0x6a41e5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000352fe8 sp=0xc000352fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x31b

goroutine 61 gp=0xc00021e000 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x60?, 0x0?, 0x0?, 0x0?, 0xad8680?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000357dc0 sp=0xc000357da0 pc=0x47102e
runtime.chanrecv(0xc000191c00, 0xc000357f40, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000357e38 sp=0xc000357dc0 pc=0x40f265
runtime.chanrecv2(0xc001d30010?, 0x40?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000357e60 sp=0xc000357e38 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineEncryption(0xc0001ea008, 0xc)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/send.go:451 +0x1c5 fp=0xc000357fc0 sp=0xc000357e60 pc=0x6b1745
go.euank.com/wireguard/device.NewDevice.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x25 fp=0xc000357fe0 sp=0xc000357fc0 pc=0x6a42a5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000357fe8 sp=0xc000357fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x385

goroutine 62 gp=0xc00021e1c0 m=nil [chan receive, 3 minutes]:
runtime.gopark(0xffef?, 0xc001dac010?, 0x10?, 0xc0?, 0xc000358e88?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000358df8 sp=0xc000358dd8 pc=0x47102e
runtime.chanrecv(0xc000191c70, 0xc000358f48, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000358e70 sp=0xc000358df8 pc=0x40f265
runtime.chanrecv2(0xc001dac010?, 0x180?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000358e98 sp=0xc000358e70 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineDecryption(0xc0001ea008, 0xc)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:244 +0x1c5 fp=0xc000358fc0 sp=0xc000358e98 pc=0x6ad3a5
go.euank.com/wireguard/device.NewDevice.gowrap2()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x25 fp=0xc000358fe0 sp=0xc000358fc0 pc=0x6a4245
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000358fe8 sp=0xc000358fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x3ca

goroutine 63 gp=0xc00021e380 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000359c40 sp=0xc000359c20 pc=0x47102e
runtime.chanrecv(0xc000191b90, 0xc000235f20, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000359cb8 sp=0xc000359c40 pc=0x40f265
runtime.chanrecv2(0xc000068530?, 0x84db38?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000359ce0 sp=0xc000359cb8 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineHandshake(0xc0001ea008, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:278 +0x17e fp=0xc000359fc0 sp=0xc000359ce0 pc=0x6ad7be
go.euank.com/wireguard/device.NewDevice.gowrap3()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x25 fp=0xc000359fe0 sp=0xc000359fc0 pc=0x6a41e5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000359fe8 sp=0xc000359fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x31b

goroutine 64 gp=0xc00021e540 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x60?, 0xffff?, 0x0?, 0xe0?, 0xc000353e50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000353dc0 sp=0xc000353da0 pc=0x47102e
runtime.chanrecv(0xc000191c00, 0xc000353f40, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000353e38 sp=0xc000353dc0 pc=0x40f265
runtime.chanrecv2(0xc00023e010?, 0x40?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000353e60 sp=0xc000353e38 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineEncryption(0xc0001ea008, 0xd)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/send.go:451 +0x1c5 fp=0xc000353fc0 sp=0xc000353e60 pc=0x6b1745
go.euank.com/wireguard/device.NewDevice.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x25 fp=0xc000353fe0 sp=0xc000353fc0 pc=0x6a42a5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000353fe8 sp=0xc000353fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x385

goroutine 65 gp=0xc00021e700 m=nil [chan receive, 3 minutes]:
runtime.gopark(0xffef?, 0xc00023e010?, 0x10?, 0xe0?, 0xc000442e88?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000442df8 sp=0xc000442dd8 pc=0x47102e
runtime.chanrecv(0xc000191c70, 0xc000442f48, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000442e70 sp=0xc000442df8 pc=0x40f265
runtime.chanrecv2(0xc00023e010?, 0x59c?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000442e98 sp=0xc000442e70 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineDecryption(0xc0001ea008, 0xd)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:244 +0x1c5 fp=0xc000442fc0 sp=0xc000442e98 pc=0x6ad3a5
go.euank.com/wireguard/device.NewDevice.gowrap2()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x25 fp=0xc000442fe0 sp=0xc000442fc0 pc=0x6a4245
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000442fe8 sp=0xc000442fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x3ca

goroutine 66 gp=0xc00021e8c0 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000354c40 sp=0xc000354c20 pc=0x47102e
runtime.chanrecv(0xc000191b90, 0xc000415f20, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000354cb8 sp=0xc000354c40 pc=0x40f265
runtime.chanrecv2(0xc000068530?, 0x84db38?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000354ce0 sp=0xc000354cb8 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineHandshake(0xc0001ea008, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:278 +0x17e fp=0xc000354fc0 sp=0xc000354ce0 pc=0x6ad7be
go.euank.com/wireguard/device.NewDevice.gowrap3()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x25 fp=0xc000354fe0 sp=0xc000354fc0 pc=0x6a41e5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000354fe8 sp=0xc000354fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x31b

goroutine 67 gp=0xc00021ea80 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x60?, 0xffff?, 0x0?, 0xc0?, 0xc000355e50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000355dc0 sp=0xc000355da0 pc=0x47102e
runtime.chanrecv(0xc000191c00, 0xc000355f40, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000355e38 sp=0xc000355dc0 pc=0x40f265
runtime.chanrecv2(0xc001dac010?, 0x40?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000355e60 sp=0xc000355e38 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineEncryption(0xc0001ea008, 0xe)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/send.go:451 +0x1c5 fp=0xc000355fc0 sp=0xc000355e60 pc=0x6b1745
go.euank.com/wireguard/device.NewDevice.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x25 fp=0xc000355fe0 sp=0xc000355fc0 pc=0x6a42a5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000355fe8 sp=0xc000355fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x385

goroutine 68 gp=0xc00021ec40 m=nil [chan receive, 3 minutes]:
runtime.gopark(0xffef?, 0x0?, 0x0?, 0x0?, 0xad8640?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc00043adf8 sp=0xc00043add8 pc=0x47102e
runtime.chanrecv(0xc000191c70, 0xc00043af48, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc00043ae70 sp=0xc00043adf8 pc=0x40f265
runtime.chanrecv2(0xc001c5e010?, 0x50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc00043ae98 sp=0xc00043ae70 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineDecryption(0xc0001ea008, 0xe)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:244 +0x1c5 fp=0xc00043afc0 sp=0xc00043ae98 pc=0x6ad3a5
go.euank.com/wireguard/device.NewDevice.gowrap2()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x25 fp=0xc00043afe0 sp=0xc00043afc0 pc=0x6a4245
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc00043afe8 sp=0xc00043afe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x3ca

goroutine 69 gp=0xc00021ee00 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc00043fc40 sp=0xc00043fc20 pc=0x47102e
runtime.chanrecv(0xc000191b90, 0xc0002bbf20, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc00043fcb8 sp=0xc00043fc40 pc=0x40f265
runtime.chanrecv2(0xc000068530?, 0x84db38?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc00043fce0 sp=0xc00043fcb8 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineHandshake(0xc0001ea008, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:278 +0x17e fp=0xc00043ffc0 sp=0xc00043fce0 pc=0x6ad7be
go.euank.com/wireguard/device.NewDevice.gowrap3()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x25 fp=0xc00043ffe0 sp=0xc00043ffc0 pc=0x6a41e5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc00043ffe8 sp=0xc00043ffe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x31b

goroutine 70 gp=0xc00021efc0 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x60?, 0xffff?, 0x0?, 0x20?, 0xc000440e50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000440dc0 sp=0xc000440da0 pc=0x47102e
runtime.chanrecv(0xc000191c00, 0xc000440f40, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000440e38 sp=0xc000440dc0 pc=0x40f265
runtime.chanrecv2(0xc001082010?, 0x40?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000440e60 sp=0xc000440e38 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineEncryption(0xc0001ea008, 0xf)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/send.go:451 +0x1c5 fp=0xc000440fc0 sp=0xc000440e60 pc=0x6b1745
go.euank.com/wireguard/device.NewDevice.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x25 fp=0xc000440fe0 sp=0xc000440fc0 pc=0x6a42a5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000440fe8 sp=0xc000440fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x385

goroutine 71 gp=0xc00021f180 m=nil [chan receive, 3 minutes]:
runtime.gopark(0xffef?, 0xc0003ec010?, 0x10?, 0xc0?, 0xc000441e88?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000441df8 sp=0xc000441dd8 pc=0x47102e
runtime.chanrecv(0xc000191c70, 0xc000441f48, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000441e70 sp=0xc000441df8 pc=0x40f265
runtime.chanrecv2(0xc0003ec010?, 0x50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000441e98 sp=0xc000441e70 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineDecryption(0xc0001ea008, 0xf)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:244 +0x1c5 fp=0xc000441fc0 sp=0xc000441e98 pc=0x6ad3a5
go.euank.com/wireguard/device.NewDevice.gowrap2()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x25 fp=0xc000441fe0 sp=0xc000441fc0 pc=0x6a4245
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000441fe8 sp=0xc000441fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x3ca

goroutine 72 gp=0xc00021f340 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc00043bc40 sp=0xc00043bc20 pc=0x47102e
runtime.chanrecv(0xc000191b90, 0xc0001c1f20, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc00043bcb8 sp=0xc00043bc40 pc=0x40f265
runtime.chanrecv2(0xc000068530?, 0x84db38?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc00043bce0 sp=0xc00043bcb8 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineHandshake(0xc0001ea008, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:278 +0x17e fp=0xc00043bfc0 sp=0xc00043bce0 pc=0x6ad7be
go.euank.com/wireguard/device.NewDevice.gowrap3()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x25 fp=0xc00043bfe0 sp=0xc00043bfc0 pc=0x6a41e5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc00043bfe8 sp=0xc00043bfe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x31b

goroutine 73 gp=0xc00021f500 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x60?, 0xffff?, 0x0?, 0x0?, 0xc000446e50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000446dc0 sp=0xc000446da0 pc=0x47102e
runtime.chanrecv(0xc000191c00, 0xc000446f40, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000446e38 sp=0xc000446dc0 pc=0x40f265
runtime.chanrecv2(0xc001d30010?, 0x40?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000446e60 sp=0xc000446e38 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineEncryption(0xc0001ea008, 0x10)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/send.go:451 +0x1c5 fp=0xc000446fc0 sp=0xc000446e60 pc=0x6b1745
go.euank.com/wireguard/device.NewDevice.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x25 fp=0xc000446fe0 sp=0xc000446fc0 pc=0x6a42a5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000446fe8 sp=0xc000446fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:317 +0x385

goroutine 74 gp=0xc00021f6c0 m=nil [chan receive, 3 minutes]:
runtime.gopark(0xffef?, 0x0?, 0x0?, 0x0?, 0xad8e40?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc00043cdf8 sp=0xc00043cdd8 pc=0x47102e
runtime.chanrecv(0xc000191c70, 0xc00043cf48, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc00043ce70 sp=0xc00043cdf8 pc=0x40f265
runtime.chanrecv2(0xc001d30010?, 0x59c?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc00043ce98 sp=0xc00043ce70 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineDecryption(0xc0001ea008, 0x10)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:244 +0x1c5 fp=0xc00043cfc0 sp=0xc00043ce98 pc=0x6ad3a5
go.euank.com/wireguard/device.NewDevice.gowrap2()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x25 fp=0xc00043cfe0 sp=0xc00043cfc0 pc=0x6a4245
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc00043cfe8 sp=0xc00043cfe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:318 +0x3ca

goroutine 75 gp=0xc00021f880 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc00043dc40 sp=0xc00043dc20 pc=0x47102e
runtime.chanrecv(0xc000191b90, 0xc000239f20, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc00043dcb8 sp=0xc00043dc40 pc=0x40f265
runtime.chanrecv2(0xc000068530?, 0x84db38?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc00043dce0 sp=0xc00043dcb8 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineHandshake(0xc0001ea008, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:278 +0x17e fp=0xc00043dfc0 sp=0xc00043dce0 pc=0x6ad7be
go.euank.com/wireguard/device.NewDevice.gowrap3()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x25 fp=0xc00043dfe0 sp=0xc00043dfc0 pc=0x6a41e5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc00043dfe8 sp=0xc00043dfe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:319 +0x31b

goroutine 76 gp=0xc00021fa40 m=nil [chan receive, 3 minutes]:
runtime.gopark(0xc000191dc0?, 0xc0003c9cb8?, 0xa5?, 0x6b?, 0xc0003c9d18?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0003c9c50 sp=0xc0003c9c30 pc=0x47102e
runtime.chanrecv(0xc00004b030, 0xc0003c9d10, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc0003c9cc8 sp=0xc0003c9c50 pc=0x40f265
runtime.chanrecv2(0xff?, 0x408d71?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc0003c9cf0 sp=0xc0003c9cc8 pc=0x40ee12
go.euank.com/wireguard/tun/netstack.(*netTun).Read(0xc000186388?, {0xc00023a008, 0x80, 0xfffffffffffffffc?}, {0xc0001c5800, 0x80, 0x0?}, 0x10)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/tun/netstack/tun.go:123 +0x45 fp=0xc0003c9d28 sp=0xc0003c9cf0 pc=0x6ba985
go.euank.com/wireguard/device.(*Device).RoutineReadFromTUN(0xc0001ea008)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/send.go:247 +0x2f8 fp=0xc0003c9fc8 sp=0xc0003c9d28 pc=0x6b0458
go.euank.com/wireguard/device.NewDevice.gowrap4()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:324 +0x25 fp=0xc0003c9fe0 sp=0xc0003c9fc8 pc=0x6a4185
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0003c9fe8 sp=0xc0003c9fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:324 +0x46c

goroutine 77 gp=0xc00021fc00 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x845d60?, 0x724900?, 0x20?, 0x81?, 0x712ea0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000445da8 sp=0xc000445d88 pc=0x47102e
runtime.chanrecv(0xc000052240, 0xc0003a1ea0, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000445e20 sp=0xc000445da8 pc=0x40f265
runtime.chanrecv2(0xc0001ea008?, 0x84db38?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000445e48 sp=0xc000445e20 pc=0x40ee12
go.euank.com/wireguard/device.(*Device).RoutineTUNEventReader(0xc0001ea008, {0x84db38, 0xaf29e0})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/tun.go:19 +0xa5 fp=0xc000445fb8 sp=0xc000445e48 pc=0x6b4645
go.euank.com/wireguard/device.NewDevice.gowrap5()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:325 +0x28 fp=0xc000445fe0 sp=0xc000445fb8 pc=0x6a4128
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000445fe8 sp=0xc000445fe0 pc=0x478861
created by go.euank.com/wireguard/device.NewDevice in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:325 +0x4cc

goroutine 82 gp=0xc000302380 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x4749e9?, 0x3342ec7f27caf?, 0x28?, 0x6e?, 0x499408?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000286dc0 sp=0xc000286da0 pc=0x47102e
runtime.chanrecv(0xc000191ce0, 0xc000286f88, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc000286e38 sp=0xc000286dc0 pc=0x40f265
runtime.chanrecv2(0xc000186388?, 0xc0000c4420?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc000286e60 sp=0xc000286e38 pc=0x40ee12
go.euank.com/wireguard/device.(*Peer).RoutineSequentialSender(0xc000186388, 0x80)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/send.go:492 +0x125 fp=0xc000286fc0 sp=0xc000286e60 pc=0x6b1c05
go.euank.com/wireguard/device.(*Peer).Start.gowrap2()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/peer.go:211 +0x25 fp=0xc000286fe0 sp=0xc000286fc0 pc=0x6aaec5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000286fe8 sp=0xc000286fe0 pc=0x478861
created by go.euank.com/wireguard/device.(*Peer).Start in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/peer.go:211 +0x2a5

goroutine 83 gp=0xc000302540 m=nil [chan receive, 3 minutes]:
runtime.gopark(0x48101d?, 0xc000119aa0?, 0x60?, 0xf3?, 0xc000021e10?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc001d0bdd0 sp=0xc001d0bdb0 pc=0x47102e
runtime.chanrecv(0xc000191d50, 0xc000021f50, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:664 +0x445 fp=0xc001d0be48 sp=0xc001d0bdd0 pc=0x40f265
runtime.chanrecv2(0xc0001ea008?, 0xc0003b2640?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/chan.go:511 +0x12 fp=0xc001d0be70 sp=0xc001d0be48 pc=0x40ee12
go.euank.com/wireguard/device.(*Peer).RoutineSequentialReceiver(0xc000186388, 0x80)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:442 +0x197 fp=0xc001d0bfc0 sp=0xc001d0be70 pc=0x6ae637
go.euank.com/wireguard/device.(*Peer).Start.gowrap3()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/peer.go:212 +0x25 fp=0xc001d0bfe0 sp=0xc001d0bfc0 pc=0x6aae65
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc001d0bfe8 sp=0xc001d0bfe0 pc=0x478861
created by go.euank.com/wireguard/device.(*Peer).Start in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/peer.go:212 +0x2f0

goroutine 98 gp=0xc000382380 m=4 mp=0xc0000ab808 [syscall, 3 minutes]:
syscall.Syscall6(0x10f, 0xc00065fe78, 0x2, 0x0, 0x0, 0x0, 0x0)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/syscall/syscall_linux.go:95 +0x39 fp=0xc00065fd18 sp=0xc00065fcb8 pc=0x48eb59
syscall.Syscall6(0x10f, 0xc00065fe78, 0x2, 0x0, 0x0, 0x0, 0x0)
	<autogenerated>:1 +0x3d fp=0xc00065fd60 sp=0xc00065fd18 pc=0x48f57d
golang.org/x/sys/unix.ppoll(0xc00065fdf8?, 0x4c7225?, 0x0?, 0xc00065fe48?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/golang.org/x/sys@v0.32.0/unix/zsyscall_linux.go:138 +0x52 fp=0xc00065fde0 sp=0xc00065fd60 pc=0x54b272
golang.org/x/sys/unix.Ppoll({0xc00065fe78?, 0x54afc7?, 0x0?}, 0x0?, 0x4c7200?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/golang.org/x/sys@v0.32.0/unix/syscall_linux.go:158 +0x38 fp=0xc00065fe10 sp=0xc00065fde0 pc=0x5490b8
golang.org/x/sys/unix.Poll({0xc00065fe78?, 0x843e80?, 0xc00065fe98?}, 0x69d62b?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/golang.org/x/sys@v0.32.0/unix/syscall_linux.go:167 +0x87 fp=0xc00065fe58 sp=0xc00065fe10 pc=0x549187
go.euank.com/wireguard/rwcancel.(*RWCancel).ReadyRead(0xc0003b4030?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/rwcancel/rwcancel.go:51 +0x88 fp=0xc00065fea8 sp=0xc00065fe58 pc=0x69d708
go.euank.com/wireguard/device.(*Device).routineRouteListener(0xc0001ea008, {0x84f428?, 0xc00018e510?}, 0x7, 0xc0003b4030)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/sticky_linux.go:69 +0x1be fp=0xc00066ffa8 sp=0xc00065fea8 pc=0x6b26be
go.euank.com/wireguard/device.(*Device).startRouteListener.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/sticky_linux.go:45 +0x30 fp=0xc00066ffe0 sp=0xc00066ffa8 pc=0x6b24d0
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc00066ffe8 sp=0xc00066ffe0 pc=0x478861
created by go.euank.com/wireguard/device.(*Device).startRouteListener in goroutine 77
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/sticky_linux.go:45 +0xe5

goroutine 99 gp=0xc000382540 m=nil [IO wait, 3 minutes]:
runtime.gopark(0xc0003a4700?, 0xc00013a8d8?, 0x58?, 0x9?, 0x680378?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc00013a888 sp=0xc00013a868 pc=0x47102e
runtime.netpollblock(0xc0003b6e9c?, 0x846dc0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/netpoll.go:575 +0xf7 fp=0xc00013a8c0 sp=0xc00013a888 pc=0x437097
internal/poll.runtime_pollWait(0x7f30898806d0, 0x72)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/netpoll.go:351 +0x85 fp=0xc00013a8e0 sp=0xc00013a8c0 pc=0x46fe05
internal/poll.(*pollDesc).wait(0xc0003a4080?, 0x0?, 0x0)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/internal/poll/fd_poll_runtime.go:84 +0x27 fp=0xc00013a908 sp=0xc00013a8e0 pc=0x4c6827
internal/poll.(*pollDesc).waitRead(...)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/internal/poll/fd_poll_runtime.go:89
internal/poll.(*FD).RawRead(0xc0003a4080, 0xc0002ca150)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/internal/poll/fd_unix.go:717 +0x125 fp=0xc00013a968 sp=0xc00013a908 pc=0x4c7f85
net.(*rawConn).Read(0xc0003ac028, 0xc0003a4700?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/net/rawconn.go:44 +0x36 fp=0xc00013a9a0 sp=0xc00013a968 pc=0x538fb6
golang.org/x/net/internal/socket.(*syscaller).recvmmsg(0xc00018e828, {0x84cf90?, 0xc0003ac028?}, {0xc0003a4700?, 0x7da7c8?, 0x0?}, 0x7da7c8?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/golang.org/x/net@v0.39.0/internal/socket/mmsghdr_unix.go:120 +0x70 fp=0xc00013a9d0 sp=0xc00013a9a0 pc=0x6807b0
golang.org/x/net/internal/socket.(*Conn).recvMsgs(0xc0003b2020, {0xc000237b58, 0x2, 0x2}, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/golang.org/x/net@v0.39.0/internal/socket/rawconn_mmsg.go:24 +0x165 fp=0xc00013aa90 sp=0xc00013a9d0 pc=0x6813a5
golang.org/x/net/internal/socket.(*Conn).RecvMsgs(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/golang.org/x/net@v0.39.0/internal/socket/socket.go:267
golang.org/x/net/ipv4.(*payloadHandler).ReadBatch(0xc0003b0060, {0xc000237b58?, 0xc00013ab38?, 0x414b71?}, 0x40e86c?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/golang.org/x/net@v0.39.0/ipv4/batch.go:80 +0x57 fp=0xc00013ab00 sp=0xc00013aa90 pc=0x682f97
go.euank.com/wireguard/conn.(*StdNetBind).receiveIP(0xc00018e510, {0x848020, 0xc0003b0050}, 0xff?, 0x1, {0xc0002c6c88, 0x80, 0xc00013ae30?}, {0xc0002b3000, 0x80, ...}, ...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/conn/bind_std.go:249 +0x1d7 fp=0xc00013abc8 sp=0xc00013ab00 pc=0x685917
go.euank.com/wireguard/conn.(*StdNetBind).Open.(*StdNetBind).makeReceiveIPv4.func1({0xc0002c6c88?, 0xc00013adc0?, 0xc000186388?}, {0xc0002b3000?, 0x12751edf5f?, 0xad2d80?}, {0xc0002ce008?, 0x2?, 0x2?})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/conn/bind_std.go:287 +0x75 fp=0xc00013ac48 sp=0xc00013abc8 pc=0x685475
go.euank.com/wireguard/device.(*Device).RoutineReceiveIncoming(0xc0001ea008, 0x80, 0xc0003a21e0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:110 +0x3e4 fp=0xc00013afb8 sp=0xc00013ac48 pc=0x6ac484
go.euank.com/wireguard/device.(*Device).BindUpdate.gowrap2()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:526 +0x28 fp=0xc00013afe0 sp=0xc00013afb8 pc=0x6a53e8
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc00013afe8 sp=0xc00013afe0 pc=0x478861
created by go.euank.com/wireguard/device.(*Device).BindUpdate in goroutine 77
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:526 +0x3ee

goroutine 100 gp=0xc000382700 m=nil [IO wait, 3 minutes]:
runtime.gopark(0xc000130000?, 0xc0001358d8?, 0x58?, 0x9?, 0x680378?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000135888 sp=0xc000135868 pc=0x47102e
runtime.netpollblock(0xc00013201c?, 0x846dc0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/netpoll.go:575 +0xf7 fp=0xc0001358c0 sp=0xc000135888 pc=0x437097
internal/poll.runtime_pollWait(0x7f30898805b8, 0x72)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/netpoll.go:351 +0x85 fp=0xc0001358e0 sp=0xc0001358c0 pc=0x46fe05
internal/poll.(*pollDesc).wait(0xc0003a4100?, 0x0?, 0x0)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/internal/poll/fd_poll_runtime.go:84 +0x27 fp=0xc000135908 sp=0xc0001358e0 pc=0x4c6827
internal/poll.(*pollDesc).waitRead(...)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/internal/poll/fd_poll_runtime.go:89
internal/poll.(*FD).RawRead(0xc0003a4100, 0xc00011e010)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/internal/poll/fd_unix.go:717 +0x125 fp=0xc000135968 sp=0xc000135908 pc=0x4c7f85
net.(*rawConn).Read(0xc0003ac040, 0xc000130000?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/net/rawconn.go:44 +0x36 fp=0xc0001359a0 sp=0xc000135968 pc=0x538fb6
golang.org/x/net/internal/socket.(*syscaller).recvmmsg(0xc0003360d8, {0x84cf90?, 0xc0003ac040?}, {0xc000130000?, 0x7da7c8?, 0x0?}, 0x7f3089c12f30?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/golang.org/x/net@v0.39.0/internal/socket/mmsghdr_unix.go:120 +0x70 fp=0xc0001359d0 sp=0xc0001359a0 pc=0x6807b0
golang.org/x/net/internal/socket.(*Conn).recvMsgs(0xc0003b2040, {0xc00012cb58, 0x2, 0x2}, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/golang.org/x/net@v0.39.0/internal/socket/rawconn_mmsg.go:24 +0x165 fp=0xc000135a90 sp=0xc0001359d0 pc=0x6813a5
golang.org/x/net/internal/socket.(*Conn).RecvMsgs(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/golang.org/x/net@v0.39.0/internal/socket/socket.go:267
golang.org/x/net/ipv6.(*payloadHandler).ReadBatch(0xc0003b00b0, {0xc00012cb58?, 0x0?, 0xffff?}, 0xc000382701?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/golang.org/x/net@v0.39.0/ipv6/batch.go:71 +0x57 fp=0xc000135b00 sp=0xc000135a90 pc=0x683ad7
go.euank.com/wireguard/conn.(*StdNetBind).receiveIP(0xc00018e510, {0x848000, 0xc0003b00a0}, 0xc000135c38?, 0x1, {0xc000426008, 0x80, 0x96?}, {0xc00042a000, 0x80, ...}, ...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/conn/bind_std.go:249 +0x1d7 fp=0xc000135bc8 sp=0xc000135b00 pc=0x685917
go.euank.com/wireguard/conn.(*StdNetBind).Open.(*StdNetBind).makeReceiveIPv6.func2({0xc000426008?, 0x84db38?, 0xaf29e0?}, {0xc00042a000?, 0x7cd88d?, 0x23?}, {0xc00042c008?, 0x2?, 0x2?})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/conn/bind_std.go:293 +0x75 fp=0xc000135c48 sp=0xc000135bc8 pc=0x685395
go.euank.com/wireguard/device.(*Device).RoutineReceiveIncoming(0xc0001ea008, 0x80, 0xc0003a2210)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/receive.go:110 +0x3e4 fp=0xc000135fb8 sp=0xc000135c48 pc=0x6ac484
go.euank.com/wireguard/device.(*Device).BindUpdate.gowrap2()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:526 +0x28 fp=0xc000135fe0 sp=0xc000135fb8 pc=0x6a53e8
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000135fe8 sp=0xc000135fe0 pc=0x478861
created by go.euank.com/wireguard/device.(*Device).BindUpdate in goroutine 77
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/go.euank.com/wireguard@v0.0.0-20250428152637-4a880d3d9334/device/device.go:526 +0x3ee

goroutine 78 gp=0xc00021fdc0 m=nil [GC worker (idle), 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000220f38 sp=0xc000220f18 pc=0x47102e
runtime.gcBgMarkWorker(0xc00004b180)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1423 +0xe9 fp=0xc000220fc8 sp=0xc000220f38 pc=0x41fc29
runtime.gcBgMarkStartWorkers.gowrap1()
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x25 fp=0xc000220fe0 sp=0xc000220fc8 pc=0x41fb05
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000220fe8 sp=0xc000220fe0 pc=0x478861
created by runtime.gcBgMarkStartWorkers in goroutine 76
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x105

goroutine 79 gp=0xc00027e000 m=nil [GC worker (idle), 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000220738 sp=0xc000220718 pc=0x47102e
runtime.gcBgMarkWorker(0xc00004b180)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1423 +0xe9 fp=0xc0002207c8 sp=0xc000220738 pc=0x41fc29
runtime.gcBgMarkStartWorkers.gowrap1()
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x25 fp=0xc0002207e0 sp=0xc0002207c8 pc=0x41fb05
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0002207e8 sp=0xc0002207e0 pc=0x478861
created by runtime.gcBgMarkStartWorkers in goroutine 76
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x105

goroutine 80 gp=0xc00027e1c0 m=nil [GC worker (idle), 3 minutes]:
runtime.gopark(0x0?, 0xc000068530?, 0x0?, 0x0?, 0x712ea0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000227f38 sp=0xc000227f18 pc=0x47102e
runtime.gcBgMarkWorker(0xc00004b180)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1423 +0xe9 fp=0xc000227fc8 sp=0xc000227f38 pc=0x41fc29
runtime.gcBgMarkStartWorkers.gowrap1()
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x25 fp=0xc000227fe0 sp=0xc000227fc8 pc=0x41fb05
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000227fe8 sp=0xc000227fe0 pc=0x478861
created by runtime.gcBgMarkStartWorkers in goroutine 76
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x105

goroutine 81 gp=0xc00027e380 m=nil [GC worker (idle), 3 minutes]:
runtime.gopark(0xc000068530?, 0x0?, 0xa0?, 0x2e?, 0x845dc0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000227738 sp=0xc000227718 pc=0x47102e
runtime.gcBgMarkWorker(0xc00004b180)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1423 +0xe9 fp=0xc0002277c8 sp=0xc000227738 pc=0x41fc29
runtime.gcBgMarkStartWorkers.gowrap1()
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x25 fp=0xc0002277e0 sp=0xc0002277c8 pc=0x41fb05
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0002277e8 sp=0xc0002277e0 pc=0x478861
created by runtime.gcBgMarkStartWorkers in goroutine 76
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x105

goroutine 114 gp=0xc00027e540 m=nil [GC worker (idle), 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000226f38 sp=0xc000226f18 pc=0x47102e
runtime.gcBgMarkWorker(0xc00004b180)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1423 +0xe9 fp=0xc000226fc8 sp=0xc000226f38 pc=0x41fc29
runtime.gcBgMarkStartWorkers.gowrap1()
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x25 fp=0xc000226fe0 sp=0xc000226fc8 pc=0x41fb05
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000226fe8 sp=0xc000226fe0 pc=0x478861
created by runtime.gcBgMarkStartWorkers in goroutine 76
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x105

goroutine 115 gp=0xc00027e700 m=nil [GC worker (idle), 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000221738 sp=0xc000221718 pc=0x47102e
runtime.gcBgMarkWorker(0xc00004b180)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1423 +0xe9 fp=0xc0002217c8 sp=0xc000221738 pc=0x41fc29
runtime.gcBgMarkStartWorkers.gowrap1()
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x25 fp=0xc0002217e0 sp=0xc0002217c8 pc=0x41fb05
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0002217e8 sp=0xc0002217e0 pc=0x478861
created by runtime.gcBgMarkStartWorkers in goroutine 76
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x105

goroutine 116 gp=0xc00027e8c0 m=nil [GC worker (idle), 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000221f38 sp=0xc000221f18 pc=0x47102e
runtime.gcBgMarkWorker(0xc00004b180)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1423 +0xe9 fp=0xc000221fc8 sp=0xc000221f38 pc=0x41fc29
runtime.gcBgMarkStartWorkers.gowrap1()
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x25 fp=0xc000221fe0 sp=0xc000221fc8 pc=0x41fb05
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000221fe8 sp=0xc000221fe0 pc=0x478861
created by runtime.gcBgMarkStartWorkers in goroutine 76
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x105

goroutine 117 gp=0xc00027ea80 m=nil [GC worker (idle), 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000222738 sp=0xc000222718 pc=0x47102e
runtime.gcBgMarkWorker(0xc00004b180)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1423 +0xe9 fp=0xc0002227c8 sp=0xc000222738 pc=0x41fc29
runtime.gcBgMarkStartWorkers.gowrap1()
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x25 fp=0xc0002227e0 sp=0xc0002227c8 pc=0x41fb05
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0002227e8 sp=0xc0002227e0 pc=0x478861
created by runtime.gcBgMarkStartWorkers in goroutine 76
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x105

goroutine 118 gp=0xc00027ec40 m=nil [GC worker (idle), 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000222f38 sp=0xc000222f18 pc=0x47102e
runtime.gcBgMarkWorker(0xc00004b180)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1423 +0xe9 fp=0xc000222fc8 sp=0xc000222f38 pc=0x41fc29
runtime.gcBgMarkStartWorkers.gowrap1()
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x25 fp=0xc000222fe0 sp=0xc000222fc8 pc=0x41fb05
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000222fe8 sp=0xc000222fe0 pc=0x478861
created by runtime.gcBgMarkStartWorkers in goroutine 76
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x105

goroutine 119 gp=0xc00027ee00 m=nil [GC worker (idle), 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000223738 sp=0xc000223718 pc=0x47102e
runtime.gcBgMarkWorker(0xc00004b180)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1423 +0xe9 fp=0xc0002237c8 sp=0xc000223738 pc=0x41fc29
runtime.gcBgMarkStartWorkers.gowrap1()
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x25 fp=0xc0002237e0 sp=0xc0002237c8 pc=0x41fb05
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0002237e8 sp=0xc0002237e0 pc=0x478861
created by runtime.gcBgMarkStartWorkers in goroutine 76
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x105

goroutine 120 gp=0xc00027efc0 m=nil [GC worker (idle), 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000223f38 sp=0xc000223f18 pc=0x47102e
runtime.gcBgMarkWorker(0xc00004b180)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1423 +0xe9 fp=0xc000223fc8 sp=0xc000223f38 pc=0x41fc29
runtime.gcBgMarkStartWorkers.gowrap1()
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x25 fp=0xc000223fe0 sp=0xc000223fc8 pc=0x41fb05
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000223fe8 sp=0xc000223fe0 pc=0x478861
created by runtime.gcBgMarkStartWorkers in goroutine 76
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x105

goroutine 121 gp=0xc00027f180 m=nil [GC worker (idle), 3 minutes]:
runtime.gopark(0x33446b15f0aff?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000674738 sp=0xc000674718 pc=0x47102e
runtime.gcBgMarkWorker(0xc00004b180)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1423 +0xe9 fp=0xc0006747c8 sp=0xc000674738 pc=0x41fc29
runtime.gcBgMarkStartWorkers.gowrap1()
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x25 fp=0xc0006747e0 sp=0xc0006747c8 pc=0x41fb05
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0006747e8 sp=0xc0006747e0 pc=0x478861
created by runtime.gcBgMarkStartWorkers in goroutine 76
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x105

goroutine 122 gp=0xc00027f340 m=nil [GC worker (idle), 3 minutes]:
runtime.gopark(0x33446b15f09e7?, 0x1?, 0xf4?, 0x56?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000674f38 sp=0xc000674f18 pc=0x47102e
runtime.gcBgMarkWorker(0xc00004b180)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1423 +0xe9 fp=0xc000674fc8 sp=0xc000674f38 pc=0x41fc29
runtime.gcBgMarkStartWorkers.gowrap1()
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x25 fp=0xc000674fe0 sp=0xc000674fc8 pc=0x41fb05
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000674fe8 sp=0xc000674fe0 pc=0x478861
created by runtime.gcBgMarkStartWorkers in goroutine 76
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x105

goroutine 123 gp=0xc00027f500 m=nil [GC worker (idle), 3 minutes]:
runtime.gopark(0x33446b15f09a1?, 0x1?, 0xf9?, 0x8b?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000675738 sp=0xc000675718 pc=0x47102e
runtime.gcBgMarkWorker(0xc00004b180)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1423 +0xe9 fp=0xc0006757c8 sp=0xc000675738 pc=0x41fc29
runtime.gcBgMarkStartWorkers.gowrap1()
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x25 fp=0xc0006757e0 sp=0xc0006757c8 pc=0x41fb05
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0006757e8 sp=0xc0006757e0 pc=0x478861
created by runtime.gcBgMarkStartWorkers in goroutine 76
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x105

goroutine 124 gp=0xc00027f6c0 m=nil [GC worker (idle), 3 minutes]:
runtime.gopark(0x33420c282badc?, 0x1?, 0xaa?, 0x9?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000675f38 sp=0xc000675f18 pc=0x47102e
runtime.gcBgMarkWorker(0xc00004b180)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1423 +0xe9 fp=0xc000675fc8 sp=0xc000675f38 pc=0x41fc29
runtime.gcBgMarkStartWorkers.gowrap1()
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x25 fp=0xc000675fe0 sp=0xc000675fc8 pc=0x41fb05
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000675fe8 sp=0xc000675fe0 pc=0x478861
created by runtime.gcBgMarkStartWorkers in goroutine 76
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x105

goroutine 125 gp=0xc00027f880 m=nil [GC worker (idle), 3 minutes]:
runtime.gopark(0x33446b15f0ec9?, 0x1?, 0x5e?, 0x29?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000676738 sp=0xc000676718 pc=0x47102e
runtime.gcBgMarkWorker(0xc00004b180)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1423 +0xe9 fp=0xc0006767c8 sp=0xc000676738 pc=0x41fc29
runtime.gcBgMarkStartWorkers.gowrap1()
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x25 fp=0xc0006767e0 sp=0xc0006767c8 pc=0x41fb05
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0006767e8 sp=0xc0006767e0 pc=0x478861
created by runtime.gcBgMarkStartWorkers in goroutine 76
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/mgc.go:1339 +0x105

goroutine 130 gp=0xc00027fdc0 m=nil [select, 3 minutes]:
runtime.gopark(0xc00067bec8?, 0x5ef8e5?, 0x0?, 0x47?, 0xc00067bf08?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0000b9eb0 sp=0xc0000b9e90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc0001e9520, 0x1, 0xd7?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0000b9ef0 sp=0xc0000b9eb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc0001e9520, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc0000b9f18 sp=0xc0000b9ef0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc0001e9508, 0x2?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0000b9fc0 sp=0xc0000b9f18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0000b9fe0 sp=0xc0000b9fc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0000b9fe8 sp=0xc0000b9fe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 131 gp=0xc000102700 m=nil [select, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0001e26b0 sp=0xc0001e2690 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc0001e95b0, 0x1, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0001e26f0 sp=0xc0001e26b0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc0001e95b0, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc0001e2718 sp=0xc0001e26f0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc0001e9598, 0x2?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0001e27c0 sp=0xc0001e2718 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0001e27e0 sp=0xc0001e27c0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0001e27e8 sp=0xc0001e27e0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 132 gp=0xc0001028c0 m=nil [select, 3 minutes]:
runtime.gopark(0xc0003bfec8?, 0x5ef8e5?, 0x0?, 0xc7?, 0xc0003bff08?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0003caeb0 sp=0xc0003cae90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc0001e9640, 0x1, 0xde?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0003caef0 sp=0xc0003caeb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc0001e9640, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc0003caf18 sp=0xc0003caef0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc0001e9628, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0003cafc0 sp=0xc0003caf18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0003cafe0 sp=0xc0003cafc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0003cafe8 sp=0xc0003cafe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 133 gp=0xc000102a80 m=nil [select, 3 minutes]:
runtime.gopark(0xfffffffffffffffc?, 0x7ce271?, 0x24?, 0x0?, 0xc0001e1750?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0001e16b0 sp=0xc0001e1690 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc0001e96d0, 0x1, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0001e16f0 sp=0xc0001e16b0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc0001e96d0, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc0001e1718 sp=0xc0001e16f0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc0001e96b8, 0x1?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0001e17c0 sp=0xc0001e1718 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0001e17e0 sp=0xc0001e17c0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0001e17e8 sp=0xc0001e17e0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 134 gp=0xc000102c40 m=nil [select, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0001e0eb0 sp=0xc0001e0e90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc0001e9760, 0x1, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0001e0ef0 sp=0xc0001e0eb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc0001e9760, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc0001e0f18 sp=0xc0001e0ef0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc0001e9748, 0x1?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0001e0fc0 sp=0xc0001e0f18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0001e0fe0 sp=0xc0001e0fc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0001e0fe8 sp=0xc0001e0fe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 135 gp=0xc000102e00 m=nil [select, 3 minutes]:
runtime.gopark(0x1?, 0xc0001e6ef8?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0001e6eb0 sp=0xc0001e6e90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc0001e97f0, 0x1, 0x6f?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0001e6ef0 sp=0xc0001e6eb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc0001e97f0, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc0001e6f18 sp=0xc0001e6ef0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc0001e97d8, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0001e6fc0 sp=0xc0001e6f18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0001e6fe0 sp=0xc0001e6fc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0001e6fe8 sp=0xc0001e6fe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 136 gp=0xc000102fc0 m=nil [select, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0001e3eb0 sp=0xc0001e3e90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc0001e9880, 0x1, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0001e3ef0 sp=0xc0001e3eb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc0001e9880, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc0001e3f18 sp=0xc0001e3ef0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc0001e9868, 0x3?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0001e3fc0 sp=0xc0001e3f18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0001e3fe0 sp=0xc0001e3fc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0001e3fe8 sp=0xc0001e3fe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 137 gp=0xc000103180 m=nil [select, 3 minutes]:
runtime.gopark(0xc0000a66d0?, 0x416f06?, 0x0?, 0xe0?, 0x75fba0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0000a66b0 sp=0xc0000a6690 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc0001e9910, 0x1, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0000a66f0 sp=0xc0000a66b0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc0001e9910, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc0000a6718 sp=0xc0000a66f0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc0001e98f8, 0x7da738?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0000a67c0 sp=0xc0000a6718 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0000a67e0 sp=0xc0000a67c0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0000a67e8 sp=0xc0000a67e0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 138 gp=0xc000103340 m=nil [select, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0006776b0 sp=0xc000677690 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc0001e99a0, 0x1, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0006776f0 sp=0xc0006776b0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc0001e99a0, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc000677718 sp=0xc0006776f0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc0001e9988, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0006777c0 sp=0xc000677718 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0006777e0 sp=0xc0006777c0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0006777e8 sp=0xc0006777e0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 139 gp=0xc000103500 m=nil [select, 3 minutes]:
runtime.gopark(0x0?, 0x0?, 0x0?, 0x0?, 0x0?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000677eb0 sp=0xc000677e90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc0001e9a30, 0x1, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc000677ef0 sp=0xc000677eb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc0001e9a30, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc000677f18 sp=0xc000677ef0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc0001e9a18, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc000677fc0 sp=0xc000677f18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc000677fe0 sp=0xc000677fc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000677fe8 sp=0xc000677fe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 140 gp=0xc0001036c0 m=nil [select, 3 minutes]:
runtime.gopark(0xc0003c1ec8?, 0x5ef8e5?, 0x0?, 0x43?, 0xc0003c1f08?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000287eb0 sp=0xc000287e90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc0001e9ac0, 0x1, 0xc9?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc000287ef0 sp=0xc000287eb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc0001e9ac0, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc000287f18 sp=0xc000287ef0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc0001e9aa8, 0xf?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc000287fc0 sp=0xc000287f18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc000287fe0 sp=0xc000287fc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000287fe8 sp=0xc000287fe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 141 gp=0xc000103880 m=nil [select, 3 minutes]:
runtime.gopark(0xc000679ec8?, 0x5ef8e5?, 0x0?, 0x46?, 0xc000679f08?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc00017beb0 sp=0xc00017be90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc0001e9b50, 0x1, 0xd7?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc00017bef0 sp=0xc00017beb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc0001e9b50, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc00017bf18 sp=0xc00017bef0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc0001e9b38, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc00017bfc0 sp=0xc00017bf18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc00017bfe0 sp=0xc00017bfc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc00017bfe8 sp=0xc00017bfe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 142 gp=0xc000103a40 m=nil [select, 3 minutes]:
runtime.gopark(0xfffffffffffffffc?, 0x7ce271?, 0x24?, 0x0?, 0xc000226750?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0002266b0 sp=0xc000226690 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc0001e9be0, 0x1, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0002266f0 sp=0xc0002266b0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc0001e9be0, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc000226718 sp=0xc0002266f0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc0001e9bc8, 0xf?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0002267c0 sp=0xc000226718 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0002267e0 sp=0xc0002267c0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0002267e8 sp=0xc0002267e0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 143 gp=0xc000103c00 m=nil [select, 3 minutes]:
runtime.gopark(0xc000021ec8?, 0x5ef8e5?, 0x0?, 0x81?, 0xc000021f08?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc001ddaeb0 sp=0xc001ddae90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc0001e9c70, 0x1, 0xc9?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc001ddaef0 sp=0xc001ddaeb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc0001e9c70, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc001ddaf18 sp=0xc001ddaef0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc0001e9c58, 0xe?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc001ddafc0 sp=0xc001ddaf18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc001ddafe0 sp=0xc001ddafc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc001ddafe8 sp=0xc001ddafe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 144 gp=0xc000103dc0 m=nil [select, 3 minutes]:
runtime.gopark(0xfffffffffffffffc?, 0x7ce271?, 0x24?, 0x0?, 0xc000224f50?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc000224eb0 sp=0xc000224e90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc0001e9d00, 0x1, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc000224ef0 sp=0xc000224eb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc0001e9d00, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc000224f18 sp=0xc000224ef0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc0001e9ce8, 0xe?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc000224fc0 sp=0xc000224f18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc000224fe0 sp=0xc000224fc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc000224fe8 sp=0xc000224fe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 145 gp=0xc000302700 m=nil [select, 3 minutes]:
runtime.gopark(0xc00067dec8?, 0x5ef8e5?, 0x0?, 0xc0?, 0xc00067df08?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0003c5eb0 sp=0xc0003c5e90 pc=0x47102e
gvisor.dev/gvisor/pkg/sync.Gopark(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sync/runtime_unsafe.go:33
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).nextWaker(0xc0001e9d90, 0x1, 0xc2?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:210 +0x79 fp=0xc0003c5ef0 sp=0xc0003c5eb0 pc=0x5c62b9
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).fetch(0xc0001e9d90, 0x1, 0x0)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:257 +0x2b fp=0xc0003c5f18 sp=0xc0003c5ef0 pc=0x5c63ab
gvisor.dev/gvisor/pkg/sleep.(*Sleeper).Fetch(...)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/sleep/sleep_unsafe.go:280
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*processor).start(0xc0001e9d78, 0x0?)
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:291 +0xa9 fp=0xc0003c5fc0 sp=0xc0003c5f18 pc=0x5dc529
gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked.gowrap1()
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x25 fp=0xc0003c5fe0 sp=0xc0003c5fc0 pc=0x5dcce5
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0003c5fe8 sp=0xc0003c5fe0 pc=0x478861
created by gvisor.dev/gvisor/pkg/tcpip/transport/tcp.(*dispatcher).startLocked in goroutine 1
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/transport/tcp/dispatcher.go:406 +0x3d

goroutine 167 gp=0xc000686380 m=nil [select, 3 minutes]:
runtime.gopark(0xc001d07c48?, 0x2?, 0x8?, 0x21?, 0xc001d07ac4?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0003c3838 sp=0xc0003c3818 pc=0x47102e
runtime.selectgo(0xc0003c3c48, 0xc001d07ac0, 0x0?, 0x0, 0x0?, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/select.go:351 +0x837 fp=0xc0003c3970 sp=0xc0003c3838 pc=0x450bf7
gvisor.dev/gvisor/pkg/tcpip/adapters/gonet.commonRead({0xc0014ea000, 0x8000, 0x8000}, {0x852558, 0xc00037ce08}, 0xc0000e7c20, 0xc0002c2000, 0x0, {0x8471c0, 0xc000292a80})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/adapters/gonet/gonet.go:323 +0x6df fp=0xc0003c3dd0 sp=0xc0003c3970 pc=0x5ffb7f
gvisor.dev/gvisor/pkg/tcpip/adapters/gonet.(*TCPConn).Read(0xc000292a80, {0xc0014ea000, 0x8000, 0x8000})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/adapters/gonet/gonet.go:352 +0x105 fp=0xc0003c3e80 sp=0xc0003c3dd0 pc=0x5ffe25
io.copyBuffer({0x7f3040599618, 0xc000292720}, {0x7f3040599638, 0xc000292a80}, {0x0, 0x0, 0x0})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/io/io.go:429 +0x190 fp=0xc0003c3ef8 sp=0xc0003c3e80 pc=0x4c31b0
io.Copy(...)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/io/io.go:388
main.proxyBytes({0x7f3040599618?, 0xc000292720?}, {0x7f3040599638?, 0xc000292a80?})
	/home/esk/dev/wirecage/wgproxy.go:94 +0x48 fp=0xc0003c3fb0 sp=0xc0003c3ef8 pc=0x6c0508
main.(*wireguardProxy).ProxyConn.gowrap1()
	/home/esk/dev/wirecage/wgproxy.go:88 +0x2c fp=0xc0003c3fe0 sp=0xc0003c3fb0 pc=0x6c048c
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0003c3fe8 sp=0xc0003c3fe0 pc=0x478861
created by main.(*wireguardProxy).ProxyConn in goroutine 163
	/home/esk/dev/wirecage/wgproxy.go:88 +0x4a7

goroutine 127 gp=0xc000402540 m=nil [select, 3 minutes]:
runtime.gopark(0xc00017fc48?, 0x2?, 0x9c?, 0x62?, 0xc00017fac4?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc00017f838 sp=0xc00017f818 pc=0x47102e
runtime.selectgo(0xc00017fc48, 0xc00017fac0, 0x0?, 0x0, 0x0?, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/select.go:351 +0x837 fp=0xc00017f970 sp=0xc00017f838 pc=0x450bf7
gvisor.dev/gvisor/pkg/tcpip/adapters/gonet.commonRead({0xc00013c000, 0x8000, 0x8000}, {0x852558, 0xc0000ed508}, 0xc0002945a0, 0xc0002c21c0, 0x0, {0x8471c0, 0xc0000d2f00})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/adapters/gonet/gonet.go:323 +0x6df fp=0xc00017fdd0 sp=0xc00017f970 pc=0x5ffb7f
gvisor.dev/gvisor/pkg/tcpip/adapters/gonet.(*TCPConn).Read(0xc0000d2f00, {0xc00013c000, 0x8000, 0x8000})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/adapters/gonet/gonet.go:352 +0x105 fp=0xc00017fe80 sp=0xc00017fdd0 pc=0x5ffe25
io.copyBuffer({0x7f3040599618, 0xc0000d2660}, {0x7f3040599638, 0xc0000d2f00}, {0x0, 0x0, 0x0})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/io/io.go:429 +0x190 fp=0xc00017fef8 sp=0xc00017fe80 pc=0x4c31b0
io.Copy(...)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/io/io.go:388
main.proxyBytes({0x7f3040599618?, 0xc0000d2660?}, {0x7f3040599638?, 0xc0000d2f00?})
	/home/esk/dev/wirecage/wgproxy.go:94 +0x48 fp=0xc00017ffb0 sp=0xc00017fef8 pc=0x6c0508
main.(*wireguardProxy).ProxyConn.gowrap1()
	/home/esk/dev/wirecage/wgproxy.go:88 +0x2c fp=0xc00017ffe0 sp=0xc00017ffb0 pc=0x6c048c
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc00017ffe8 sp=0xc00017ffe0 pc=0x478861
created by main.(*wireguardProxy).ProxyConn in goroutine 126
	/home/esk/dev/wirecage/wgproxy.go:88 +0x4a7

goroutine 128 gp=0xc000402700 m=nil [select, 3 minutes]:
runtime.gopark(0xc000345c48?, 0x2?, 0x1?, 0x0?, 0xc000345ac4?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc00067f838 sp=0xc00067f818 pc=0x47102e
runtime.selectgo(0xc00067fc48, 0xc000345ac0, 0x0?, 0x0, 0x0?, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/select.go:351 +0x837 fp=0xc00067f970 sp=0xc00067f838 pc=0x450bf7
gvisor.dev/gvisor/pkg/tcpip/adapters/gonet.commonRead({0xc001c56000, 0x8000, 0x8000}, {0x852558, 0xc0000ec708}, 0xc0002943f0, 0xc0002c2070, 0x0, {0x8471c0, 0xc0000d2660})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/adapters/gonet/gonet.go:323 +0x6df fp=0xc00067fdd0 sp=0xc00067f970 pc=0x5ffb7f
gvisor.dev/gvisor/pkg/tcpip/adapters/gonet.(*TCPConn).Read(0xc0000d2660, {0xc001c56000, 0x8000, 0x8000})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/adapters/gonet/gonet.go:352 +0x105 fp=0xc00067fe80 sp=0xc00067fdd0 pc=0x5ffe25
io.copyBuffer({0x7f3040599618, 0xc0000d2f00}, {0x7f3040599638, 0xc0000d2660}, {0x0, 0x0, 0x0})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/io/io.go:429 +0x190 fp=0xc00067fef8 sp=0xc00067fe80 pc=0x4c31b0
io.Copy(...)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/io/io.go:388
main.proxyBytes({0x7f3040599618?, 0xc0000d2f00?}, {0x7f3040599638?, 0xc0000d2660?})
	/home/esk/dev/wirecage/wgproxy.go:94 +0x48 fp=0xc00067ffb0 sp=0xc00067fef8 pc=0x6c0508
main.(*wireguardProxy).ProxyConn.gowrap2()
	/home/esk/dev/wirecage/wgproxy.go:89 +0x2c fp=0xc00067ffe0 sp=0xc00067ffb0 pc=0x6c042c
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc00067ffe8 sp=0xc00067ffe0 pc=0x478861
created by main.(*wireguardProxy).ProxyConn in goroutine 126
	/home/esk/dev/wirecage/wgproxy.go:89 +0x565

goroutine 165 gp=0xc000383340 m=nil [select, 3 minutes]:
runtime.gopark(0xc001c9dc48?, 0x2?, 0x0?, 0x0?, 0xc001c9dac4?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc001d09838 sp=0xc001d09818 pc=0x47102e
runtime.selectgo(0xc001d09c48, 0xc001c9dac0, 0x0?, 0x0, 0x0?, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/select.go:351 +0x837 fp=0xc001d09970 sp=0xc001d09838 pc=0x450bf7
gvisor.dev/gvisor/pkg/tcpip/adapters/gonet.commonRead({0xc001c8a000, 0x8000, 0x8000}, {0x852558, 0xc00068c008}, 0xc0001191a0, 0xc0001989a0, 0x0, {0x8471c0, 0xc000111080})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/adapters/gonet/gonet.go:323 +0x6df fp=0xc001d09dd0 sp=0xc001d09970 pc=0x5ffb7f
gvisor.dev/gvisor/pkg/tcpip/adapters/gonet.(*TCPConn).Read(0xc000111080, {0xc001c8a000, 0x8000, 0x8000})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/adapters/gonet/gonet.go:352 +0x105 fp=0xc001d09e80 sp=0xc001d09dd0 pc=0x5ffe25
io.copyBuffer({0x7f3040599618, 0xc000110fc0}, {0x7f3040599638, 0xc000111080}, {0x0, 0x0, 0x0})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/io/io.go:429 +0x190 fp=0xc001d09ef8 sp=0xc001d09e80 pc=0x4c31b0
io.Copy(...)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/io/io.go:388
main.proxyBytes({0x7f3040599618?, 0xc000110fc0?}, {0x7f3040599638?, 0xc000111080?})
	/home/esk/dev/wirecage/wgproxy.go:94 +0x48 fp=0xc001d09fb0 sp=0xc001d09ef8 pc=0x6c0508
main.(*wireguardProxy).ProxyConn.gowrap1()
	/home/esk/dev/wirecage/wgproxy.go:88 +0x2c fp=0xc001d09fe0 sp=0xc001d09fb0 pc=0x6c048c
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc001d09fe8 sp=0xc001d09fe0 pc=0x478861
created by main.(*wireguardProxy).ProxyConn in goroutine 178
	/home/esk/dev/wirecage/wgproxy.go:88 +0x4a7

goroutine 166 gp=0xc000383500 m=nil [select, 3 minutes]:
runtime.gopark(0xc00006dc48?, 0x2?, 0x9c?, 0x62?, 0xc00006dac4?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc001da1838 sp=0xc001da1818 pc=0x47102e
runtime.selectgo(0xc001da1c48, 0xc00006dac0, 0x0?, 0x0, 0x0?, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/select.go:351 +0x837 fp=0xc001da1970 sp=0xc001da1838 pc=0x450bf7
gvisor.dev/gvisor/pkg/tcpip/adapters/gonet.commonRead({0xc001d18000, 0x8000, 0x8000}, {0x852558, 0xc00037c008}, 0xc0000e7980, 0xc000198620, 0x0, {0x8471c0, 0xc000110fc0})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/adapters/gonet/gonet.go:323 +0x6df fp=0xc001da1dd0 sp=0xc001da1970 pc=0x5ffb7f
gvisor.dev/gvisor/pkg/tcpip/adapters/gonet.(*TCPConn).Read(0xc000110fc0, {0xc001d18000, 0x8000, 0x8000})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/adapters/gonet/gonet.go:352 +0x105 fp=0xc001da1e80 sp=0xc001da1dd0 pc=0x5ffe25
io.copyBuffer({0x7f3040599618, 0xc000111080}, {0x7f3040599638, 0xc000110fc0}, {0x0, 0x0, 0x0})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/io/io.go:429 +0x190 fp=0xc001da1ef8 sp=0xc001da1e80 pc=0x4c31b0
io.Copy(...)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/io/io.go:388
main.proxyBytes({0x7f3040599618?, 0xc000111080?}, {0x7f3040599638?, 0xc000110fc0?})
	/home/esk/dev/wirecage/wgproxy.go:94 +0x48 fp=0xc001da1fb0 sp=0xc001da1ef8 pc=0x6c0508
main.(*wireguardProxy).ProxyConn.gowrap2()
	/home/esk/dev/wirecage/wgproxy.go:89 +0x2c fp=0xc001da1fe0 sp=0xc001da1fb0 pc=0x6c042c
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc001da1fe8 sp=0xc001da1fe0 pc=0x478861
created by main.(*wireguardProxy).ProxyConn in goroutine 178
	/home/esk/dev/wirecage/wgproxy.go:89 +0x565

goroutine 181 gp=0xc0004028c0 m=nil [select, 3 minutes]:
runtime.gopark(0xc001c99c48?, 0x2?, 0xc0?, 0x25?, 0xc001c99ac4?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc00067d838 sp=0xc00067d818 pc=0x47102e
runtime.selectgo(0xc00067dc48, 0xc001c99ac0, 0x0?, 0x0, 0x0?, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/select.go:351 +0x837 fp=0xc00067d970 sp=0xc00067d838 pc=0x450bf7
gvisor.dev/gvisor/pkg/tcpip/adapters/gonet.commonRead({0xc0014e2000, 0x8000, 0x8000}, {0x852558, 0xc00068ce08}, 0xc000119500, 0xc000338000, 0x0, {0x8471c0, 0xc000110ba0})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/adapters/gonet/gonet.go:323 +0x6df fp=0xc00067ddd0 sp=0xc00067d970 pc=0x5ffb7f
gvisor.dev/gvisor/pkg/tcpip/adapters/gonet.(*TCPConn).Read(0xc000110ba0, {0xc0014e2000, 0x8000, 0x8000})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/adapters/gonet/gonet.go:352 +0x105 fp=0xc00067de80 sp=0xc00067ddd0 pc=0x5ffe25
io.copyBuffer({0x7f3040599618, 0xc000111020}, {0x7f3040599638, 0xc000110ba0}, {0x0, 0x0, 0x0})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/io/io.go:429 +0x190 fp=0xc00067def8 sp=0xc00067de80 pc=0x4c31b0
io.Copy(...)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/io/io.go:388
main.proxyBytes({0x7f3040599618?, 0xc000111020?}, {0x7f3040599638?, 0xc000110ba0?})
	/home/esk/dev/wirecage/wgproxy.go:94 +0x48 fp=0xc00067dfb0 sp=0xc00067def8 pc=0x6c0508
main.(*wireguardProxy).ProxyConn.gowrap1()
	/home/esk/dev/wirecage/wgproxy.go:88 +0x2c fp=0xc00067dfe0 sp=0xc00067dfb0 pc=0x6c048c
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc00067dfe8 sp=0xc00067dfe0 pc=0x478861
created by main.(*wireguardProxy).ProxyConn in goroutine 179
	/home/esk/dev/wirecage/wgproxy.go:88 +0x4a7

goroutine 182 gp=0xc000402a80 m=nil [select, 3 minutes]:
runtime.gopark(0xc000345c48?, 0x2?, 0x78?, 0x2a?, 0xc000345ac4?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc001d8b838 sp=0xc001d8b818 pc=0x47102e
runtime.selectgo(0xc001d8bc48, 0xc000345ac0, 0x0?, 0x0, 0x0?, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/select.go:351 +0x837 fp=0xc001d8b970 sp=0xc001d8b838 pc=0x450bf7
gvisor.dev/gvisor/pkg/tcpip/adapters/gonet.commonRead({0xc000410000, 0x8000, 0x8000}, {0x852558, 0xc00037c708}, 0xc0000e7a40, 0xc0001987e0, 0x0, {0x8471c0, 0xc000111020})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/adapters/gonet/gonet.go:323 +0x6df fp=0xc001d8bdd0 sp=0xc001d8b970 pc=0x5ffb7f
gvisor.dev/gvisor/pkg/tcpip/adapters/gonet.(*TCPConn).Read(0xc000111020, {0xc000410000, 0x8000, 0x8000})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/adapters/gonet/gonet.go:352 +0x105 fp=0xc001d8be80 sp=0xc001d8bdd0 pc=0x5ffe25
io.copyBuffer({0x7f3040599618, 0xc000110ba0}, {0x7f3040599638, 0xc000111020}, {0x0, 0x0, 0x0})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/io/io.go:429 +0x190 fp=0xc001d8bef8 sp=0xc001d8be80 pc=0x4c31b0
io.Copy(...)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/io/io.go:388
main.proxyBytes({0x7f3040599618?, 0xc000110ba0?}, {0x7f3040599638?, 0xc000111020?})
	/home/esk/dev/wirecage/wgproxy.go:94 +0x48 fp=0xc001d8bfb0 sp=0xc001d8bef8 pc=0x6c0508
main.(*wireguardProxy).ProxyConn.gowrap2()
	/home/esk/dev/wirecage/wgproxy.go:89 +0x2c fp=0xc001d8bfe0 sp=0xc001d8bfb0 pc=0x6c042c
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc001d8bfe8 sp=0xc001d8bfe0 pc=0x478861
created by main.(*wireguardProxy).ProxyConn in goroutine 179
	/home/esk/dev/wirecage/wgproxy.go:89 +0x565

goroutine 168 gp=0xc0003836c0 m=nil [select, 3 minutes]:
runtime.gopark(0xc001869c48?, 0x2?, 0x9c?, 0x62?, 0xc001869ac4?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc001d8f838 sp=0xc001d8f818 pc=0x47102e
runtime.selectgo(0xc001d8fc48, 0xc001869ac0, 0x0?, 0x0, 0x0?, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/select.go:351 +0x837 fp=0xc001d8f970 sp=0xc001d8f838 pc=0x450bf7
gvisor.dev/gvisor/pkg/tcpip/adapters/gonet.commonRead({0xc00041e000, 0x8000, 0x8000}, {0x852558, 0xc00068c708}, 0xc000119410, 0xc0003380e0, 0x0, {0x8471c0, 0xc000292720})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/adapters/gonet/gonet.go:323 +0x6df fp=0xc001d8fdd0 sp=0xc001d8f970 pc=0x5ffb7f
gvisor.dev/gvisor/pkg/tcpip/adapters/gonet.(*TCPConn).Read(0xc000292720, {0xc00041e000, 0x8000, 0x8000})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/adapters/gonet/gonet.go:352 +0x105 fp=0xc001d8fe80 sp=0xc001d8fdd0 pc=0x5ffe25
io.copyBuffer({0x7f3040599618, 0xc000292a80}, {0x7f3040599638, 0xc000292720}, {0x0, 0x0, 0x0})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/io/io.go:429 +0x190 fp=0xc001d8fef8 sp=0xc001d8fe80 pc=0x4c31b0
io.Copy(...)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/io/io.go:388
main.proxyBytes({0x7f3040599618?, 0xc000292a80?}, {0x7f3040599638?, 0xc000292720?})
	/home/esk/dev/wirecage/wgproxy.go:94 +0x48 fp=0xc001d8ffb0 sp=0xc001d8fef8 pc=0x6c0508
main.(*wireguardProxy).ProxyConn.gowrap2()
	/home/esk/dev/wirecage/wgproxy.go:89 +0x2c fp=0xc001d8ffe0 sp=0xc001d8ffb0 pc=0x6c042c
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc001d8ffe8 sp=0xc001d8ffe0 pc=0x478861
created by main.(*wireguardProxy).ProxyConn in goroutine 163
	/home/esk/dev/wirecage/wgproxy.go:89 +0x565

goroutine 184 gp=0xc000402c40 m=nil [select, 3 minutes]:
runtime.gopark(0xc001961c48?, 0x2?, 0x78?, 0x2a?, 0xc001961ac4?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc001d71838 sp=0xc001d71818 pc=0x47102e
runtime.selectgo(0xc001d71c48, 0xc001961ac0, 0x0?, 0x0, 0x0?, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/select.go:351 +0x837 fp=0xc001d71970 sp=0xc001d71838 pc=0x450bf7
gvisor.dev/gvisor/pkg/tcpip/adapters/gonet.commonRead({0xc00186a000, 0x8000, 0x8000}, {0x852558, 0xc0000edc08}, 0xc000294ae0, 0xc0002c2380, 0x0, {0x8471c0, 0xc0000d2fc0})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/adapters/gonet/gonet.go:323 +0x6df fp=0xc001d71dd0 sp=0xc001d71970 pc=0x5ffb7f
gvisor.dev/gvisor/pkg/tcpip/adapters/gonet.(*TCPConn).Read(0xc0000d2fc0, {0xc00186a000, 0x8000, 0x8000})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/adapters/gonet/gonet.go:352 +0x105 fp=0xc001d71e80 sp=0xc001d71dd0 pc=0x5ffe25
io.copyBuffer({0x7f3040599618, 0xc000110c60}, {0x7f3040599638, 0xc0000d2fc0}, {0x0, 0x0, 0x0})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/io/io.go:429 +0x190 fp=0xc001d71ef8 sp=0xc001d71e80 pc=0x4c31b0
io.Copy(...)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/io/io.go:388
main.proxyBytes({0x7f3040599618?, 0xc000110c60?}, {0x7f3040599638?, 0xc0000d2fc0?})
	/home/esk/dev/wirecage/wgproxy.go:94 +0x48 fp=0xc001d71fb0 sp=0xc001d71ef8 pc=0x6c0508
main.(*wireguardProxy).ProxyConn.gowrap2()
	/home/esk/dev/wirecage/wgproxy.go:89 +0x2c fp=0xc001d71fe0 sp=0xc001d71fb0 pc=0x6c042c
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc001d71fe8 sp=0xc001d71fe0 pc=0x478861
created by main.(*wireguardProxy).ProxyConn in goroutine 129
	/home/esk/dev/wirecage/wgproxy.go:89 +0x565

goroutine 186 gp=0xc000402e00 m=nil [select, 3 minutes]:
runtime.gopark(0xc00195dc48?, 0x2?, 0x0?, 0x0?, 0xc00195dac4?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc0003bd838 sp=0xc0003bd818 pc=0x47102e
runtime.selectgo(0xc0003bdc48, 0xc00195dac0, 0x0?, 0x0, 0x0?, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/select.go:351 +0x837 fp=0xc0003bd970 sp=0xc0003bd838 pc=0x450bf7
gvisor.dev/gvisor/pkg/tcpip/adapters/gonet.commonRead({0xc001a54000, 0x8000, 0x8000}, {0x852558, 0xc00037d508}, 0xc001c80090, 0xc0003382a0, 0x0, {0x8471c0, 0xc000292840})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/adapters/gonet/gonet.go:323 +0x6df fp=0xc0003bddd0 sp=0xc0003bd970 pc=0x5ffb7f
gvisor.dev/gvisor/pkg/tcpip/adapters/gonet.(*TCPConn).Read(0xc000292840, {0xc001a54000, 0x8000, 0x8000})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/adapters/gonet/gonet.go:352 +0x105 fp=0xc0003bde80 sp=0xc0003bddd0 pc=0x5ffe25
io.copyBuffer({0x7f3040599618, 0xc000110d20}, {0x7f3040599638, 0xc000292840}, {0x0, 0x0, 0x0})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/io/io.go:429 +0x190 fp=0xc0003bdef8 sp=0xc0003bde80 pc=0x4c31b0
io.Copy(...)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/io/io.go:388
main.proxyBytes({0x7f3040599618?, 0xc000110d20?}, {0x7f3040599638?, 0xc000292840?})
	/home/esk/dev/wirecage/wgproxy.go:94 +0x48 fp=0xc0003bdfb0 sp=0xc0003bdef8 pc=0x6c0508
main.(*wireguardProxy).ProxyConn.gowrap2()
	/home/esk/dev/wirecage/wgproxy.go:89 +0x2c fp=0xc0003bdfe0 sp=0xc0003bdfb0 pc=0x6c042c
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc0003bdfe8 sp=0xc0003bdfe0 pc=0x478861
created by main.(*wireguardProxy).ProxyConn in goroutine 180
	/home/esk/dev/wirecage/wgproxy.go:89 +0x565

goroutine 170 gp=0xc000383880 m=nil [select, 3 minutes]:
runtime.gopark(0xc001bf5c48?, 0x2?, 0x0?, 0x0?, 0xc001bf5ac4?)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/proc.go:435 +0xce fp=0xc001d6d838 sp=0xc001d6d818 pc=0x47102e
runtime.selectgo(0xc001d6dc48, 0xc001bf5ac0, 0x0?, 0x0, 0x0?, 0x1)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/select.go:351 +0x837 fp=0xc001d6d970 sp=0xc001d6d838 pc=0x450bf7
gvisor.dev/gvisor/pkg/tcpip/adapters/gonet.commonRead({0xc001c00000, 0x8000, 0x8000}, {0x852558, 0xc00068d508}, 0xc000119740, 0xc0003383f0, 0x0, {0x8471c0, 0xc000292900})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/adapters/gonet/gonet.go:323 +0x6df fp=0xc001d6ddd0 sp=0xc001d6d970 pc=0x5ffb7f
gvisor.dev/gvisor/pkg/tcpip/adapters/gonet.(*TCPConn).Read(0xc000292900, {0xc001c00000, 0x8000, 0x8000})
	/home/esk/dev/wirecage/.devenv/state/go/pkg/mod/gvisor.dev/gvisor@v0.0.0-20250421234849-d561420079a1/pkg/tcpip/adapters/gonet/gonet.go:352 +0x105 fp=0xc001d6de80 sp=0xc001d6ddd0 pc=0x5ffe25
io.copyBuffer({0x7f3040599618, 0xc0000d2780}, {0x7f3040599638, 0xc000292900}, {0x0, 0x0, 0x0})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/io/io.go:429 +0x190 fp=0xc001d6def8 sp=0xc001d6de80 pc=0x4c31b0
io.Copy(...)
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/io/io.go:388
main.proxyBytes({0x7f3040599618?, 0xc0000d2780?}, {0x7f3040599638?, 0xc000292900?})
	/home/esk/dev/wirecage/wgproxy.go:94 +0x48 fp=0xc001d6dfb0 sp=0xc001d6def8 pc=0x6c0508
main.(*wireguardProxy).ProxyConn.gowrap2()
	/home/esk/dev/wirecage/wgproxy.go:89 +0x2c fp=0xc001d6dfe0 sp=0xc001d6dfb0 pc=0x6c042c
runtime.goexit({})
	/nix/store/rv9g1p18w52vip6652svdgy138wgx7dj-go-1.24.2/share/go/src/runtime/asm_amd64.s:1700 +0x1 fp=0xc001d6dfe8 sp=0xc001d6dfe0 pc=0x478861
created by main.(*wireguardProxy).ProxyConn in goroutine 164
	/home/esk/dev/wirecage/wgproxy.go:89 +0x565

rax    0xca
rbx    0x0
rcx    0x47a663
rdx    0x0
rdi    0xad3fa0
rsi    0x80
rbp    0x7ffe72e83830
rsp    0x7ffe72e837e8
r8     0x0
r9     0x0
r10    0x0
r11    0x286
r12    0x63
r13    0x1
r14    0xad3000
r15    0x1
rip    0x47a661
rflags 0x286
cs     0x33
fs     0x0
gs     0x0
