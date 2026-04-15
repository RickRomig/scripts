# binary-i386.md
## Message during update:
Skipping acquire of configured file 'main/binary-i386' as repository "https://dl.google.com/linux/chrome-stable/deb stable InRelease" doesn't support architecture 'i386'
## Steps to resolve:
1. Confirm using 64-bit with multiarch enabled.
`$ dpkg --print-foreign-architectures` If result shows 'i386', then 32-bit support has been added.
2. Confirim native 64-bit architecture.
`$ dpkg --print-architecture` If amd64, then native architecture is 64-bit.
3. Show packages using 32-bit.
`$ dpkg --get-selections | grep 386` If nothing displayed, no 32-bit applications.
4. If no 32-bit applications, remove 32-bit support.
`$ sudo dpkg --remove-architecture i386 | grep i386; echo ${PIPESTATUS[@]}`
## Miscelleanous
Adding `[arch=amd64] to line is old source list format` works. I'm not sure it's applicable to the new format.
