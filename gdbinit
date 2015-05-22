define reg
    if $BITS == 32
        printf "eax: 0x%08x  ", $eax
        printf "ebx: 0x%08x  ", $ebx
        printf "ecx: 0x%08x  ", $ecx
        printf "\n"
        printf "edx: 0x%08x  ", $edx
        printf "esi: 0x%08x  ", $esi
        printf "edi: 0x%08x  ", $edi
        printf "\n"
        printf "esp: 0x%08x  ", $esp
        printf "ebp: 0x%08x  ", $ebp
        printf "eip: 0x%08x  ", $eip
        printf "\n"
    else
        printf "\e[1;33mrax[0m: 0x%016llx  ", $rax
        printf "\e[1;33mrbx[0m: 0x%016llx  ", $rbx
        printf "\e[1;33mrcx[0m: 0x%016llx  ", $rcx
        printf "\n"
        printf "\e[1;33mrdx[0m: 0x%016llx  ", $rdx
        printf "\e[1;33mrsi[0m: 0x%016llx  ", $rsi
        printf "\e[1;33mrdi[0m: 0x%016llx  ", $rdi
        printf "\n"
        printf "\e[1;33mrsp[0m: 0x%016llx  ", $rsp
        printf "\e[1;33mrbp[0m: 0x%016llx  ", $rbp
        printf "\e[1;33mrip[0m: 0x%016llx  ", $rip
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
    printf "==============================================================================\n"
    # display register
    reg
    printf "==============================================================================\n"
    # display stack
    stack
    printf "==============================================================================\n"
    # display code
    x/5i $pc
    printf "==============================================================================\n"
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
