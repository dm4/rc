define reg
    if $BITS == 32
        printf "[1;33meax[0m: 0x%08x  ", $eax
        printf "[1;33mebx[0m: 0x%08x  ", $ebx
        printf "[1;33mecx[0m: 0x%08x  ", $ecx
        printf "\n"
        printf "[1;33medx[0m: 0x%08x  ", $edx
        printf "[1;33mesi[0m: 0x%08x  ", $esi
        printf "[1;33medi[0m: 0x%08x  ", $edi
        printf "\n"
        printf "[1;33mesp[0m: 0x%08x  ", $esp
        printf "[1;33mebp[0m: 0x%08x  ", $ebp
        printf "[1;33meip[0m: 0x%08x  ", $eip
        printf "\n"
    else
        printf "[1;33mrax[0m: 0x%016llx  ", $rax
        printf "[1;33mrbx[0m: 0x%016llx  ", $rbx
        printf "[1;33mrcx[0m: 0x%016llx  ", $rcx
        printf "\n"
        printf "[1;33mrdx[0m: 0x%016llx  ", $rdx
        printf "[1;33mrsi[0m: 0x%016llx  ", $rsi
        printf "[1;33mrdi[0m: 0x%016llx  ", $rdi
        printf "\n"
        printf "[1;33mrsp[0m: 0x%016llx  ", $rsp
        printf "[1;33mrbp[0m: 0x%016llx  ", $rbp
        printf "[1;33mrip[0m: 0x%016llx  ", $rip
        printf "\n"
    end
end

define stack
    if $BITS == 32
        x/16wx $esp
    else
        x/8gx $rsp
    end
end

define setup
    set disassembly-flavor intel
    # detect 32 or 64 bits
    if(sizeof(void*) == 8)
        set $BITS = 64
    else
        set $BITS = 32
    end
end

define context
    printf "[1;32m==============================================================================[0m\n"
    # display register
    reg
    printf "[1;32m==============================================================================[0m\n"
    # display stack
    stack
    printf "[1;32m==============================================================================[0m\n"
    # display code
    x/5i $pc
    printf "[1;32m==============================================================================[0m\n"
end


define hook-run
    setup
end

define hook-file
    setup
end

define hook-core-file
    setup
end

define hook-stop
    context
end
