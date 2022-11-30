#!/bin/bash

# set -x

function vm_get_value() {
    local entry="$1";
    local value=$(echo "${entry}" | awk -F'=' '{print $2}');

    value=$(echo "${value}" | sed 's/\(^[ ]*\)//gi');
    echo "${value}";
}

function run_vm_file() {
    local vm_file="$1";
    local -a qemu_params=();

    local vm_net_id="mynet0";
    local vm_net_spec="-nic user,model=virtio-net-pci"
    local vm_net_extra="";

    # dynamic parameters
    local vm_launch_disk="";
    local vm_machine="q35";
    local vm_cpu="host";
    local vm_memory="";
    local vm_cpus="";
    local vm_display="curses";
    local vm_vga="virtio";
    local vm_accel="hvf";
    local vm_disk="";
    local vm_cdrom_arg="";
    local vm_bios="UEFI";
    local vm_boot_order="menu=on";
    local vm_name_arg="";
    local vm_vnc="";

    qemu_system="qemu-system-x86_64";
    if [ $# -gt 1 ]; then
        qemu_system="$2";
    fi

    if [ -z "${vm_file}" ]; then
        echo;
        echo "usage:";
        echo "    qemu-launch.sh VM_FILE";
        echo;        
        return 1;
    elif [ ! -f "${vm_file}" ]; then
        echo "'${vm_file}' is not a valid file.";
        return 1;
    fi

    # Enable acceleration
    qemu_params+=("-enable-kvm");

    # Add default NIC
    # qemu_params+=("-net nic,model=virtio");

    while IFS= read -r line
    do
        # Left trim ${line}
        line=$(echo -n "${line}" | sed 's/^[ ]*//gi');

        if [[ "${line}" =~ ^#.*$ ]]; then
            continue;
        fi

        current_value=`vm_get_value "${line}"`;
        case "${line}" in
        name*)
            qemu_params+=("-name ${current_value}");
        ;;

        memory*)
            qemu_params+=("-m ${current_value}");
        ;;

        cpus*)
            qemu_params+=("-smp ${current_value}");
        ;;

        disk*)
            vm_launch_disk="${current_value}";
        ;;

        vga*)
            qemu_params+=("-vga {current_value}");
        ;;

        cdrom*)
            qemu_params+=("-cdrom ${current_value}");
        ;;

        vnclisten*)
            if grep -s "[0-9\.]*\:\d*" <<< "${current_value}"; then
                qemu_params+=("-vnc ${current_value}");
            else
                qemu_params+=("-vnc 127.0.0.1:${current_value}");
            fi
        ;;

        display*)
            qemu_params+=("-display ${current_value}");
        ;;

        bios*)
            qemu_params+=("-bios ${current_value}");
        ;;

        boot_menu*)
            if eval "${current_value}"; then
                qemu_params+=("-boot menu=on");
            fi
        ;;

        boot_order*)
            qemu_params+=("-boot order=${current_value}");
        ;;

        background*)
            if eval "${current_value}"; then
                qemu_params+=("-daemonize");
            fi
        ;;

        machine_type*)
            vm_machine=${current_value};
        ;;

        accel*)
            vm_accel=${current_value};
        ;;

        ip_subnet*)
            vm_net_spec="${vm_net_spec},net=${current_value}";
        ;;

        net_id*)
            vm_net_spec="${vm_net_spec},id=${current_value}";
        ;;

        ssh_local_port*)
            vm_net_spec="${vm_net_spec},hostfwd=tcp::${current_value}-:22";
        ;;

        *)
            echo "unknown entry '${line}'" >&2;
        ;;
        esac
    done < "${vm_file}";

    # Add NIC specification
    qemu_params+=("${vm_net_spec}");

    # add acceleration
    qemu_params+=("-machine type=${vm_machine},accel=${vm_accel}");
    
    # Now running qemu
    echo ${qemu_system} ${qemu_params[@]} ${vm_launch_disk};
    ${qemu_system} ${qemu_params[@]} ${vm_launch_disk};
}

run_vm_file "$@"

