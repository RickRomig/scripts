# is_laptop
### Purpose
Check if the system is a laptop by checking for `/proc/acpi/button/lid/`.
### Arguments
None
### Returns
TRUE (0) if the system is a laptop, otherwise returns FALSE (1).
### Usage
```bash
is_laptop && do_something
```
### Notes
