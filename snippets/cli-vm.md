# Command line creation - KVM-QEMU VM
```bash
virt-install --name=archlinux \
--vcpus=2 \
--memory=4092 \
--cdrom=/path/to/iso \
--disk_size=20 \
--os_variants=archlinux
```