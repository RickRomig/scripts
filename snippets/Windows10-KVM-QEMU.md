# Windows 10 on KVM/QEMU

- Youtube URL
https://www.youtube.com/watch?v=ZqBJzrQy7Do
- Windows 10 ISO
https://www.microsoft.com/en-us/software-download/windows10ISO/

**Minimum requirements:**
- 20GB disk space (100 GB)
- 2GB memory (4 GB)

**To get the OEM product key from the PC**
```bash
sudo apt-get install acpica-tools
sudo acpidump -n MSDM
```

**VirtIO drivers (Set up 2nd CD-ROM in Virt-Manager before install.)**
https://docs.fedoraproject.org/en-US/quick-docs/creating-windows-virtual-machines-using-virtio-drivers/index.html

https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md

**SPICE guest tools**
https://www.spice-space.org/download.html
