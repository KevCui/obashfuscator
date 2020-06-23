# obashfuscator

> obashfuscator obfuscates Bash script.

## Table of Contents

- [obashfuscator](#obashfuscator)
  - [Why?](#why)
  - [Features](#features)
  - [Dependency](#dependency)
  - [Usage](#usage)
    - [Examples](#examples)
      !/usr/bin/bash])
  - [FAQ](#faq)
    - [Bash error "BASH_SOURCE[0]: unbound variable" when executing obfuscated script](#bash-error-bash_source0-unbound-variable-when-executing-obfuscated-script)
    - [Bash error "Argument list too long" when executing obfuscated script](#bash-error-argument-list-too-long-when-executing-obfuscated-script)
    - [Is it easy to deobfuscate?](#is-it-easy-to-deobfuscate)

## Why?

Why not... Maybe for fun? You might tell me the reason if it's somehow useful.

## Features

- Make Bash script unreadable at first glance
- Keep obfuscated script executable, without losing any functionalities
- Integrate two methods for obfuscation: base64 mode and extended mode (using bash-obfuscate)

## Dependency

- Normal mode (base64 encoding): No dependency
- Extended mode: [bash-obfuscate](https://github.com/willshiao/node-bash-obfuscate)

## Usage

```
Usage:
  ./obashfuscator.sh -f <bash_script> [-n <num>] [-e]

Options:
  -f <bash_script>   Input script to obfuscate
  -n <num>           Optional, num of times for base64 encoding
                     If not set, 1 by default
  -e                 Optional, extended mode
                     Use bash-obfuscate on top, by default not
  -h | --help        Display this help message
```

### Examples

- Normal mode, with base64 encoding 1 time:

```bash
~$ cat try_me.sh
#!/usr/bin/bash
echo "Hello, world!"
~$ ./obashfuscator.sh -f try_me.sh
~$ cat try_me_obfuscated.sh
bash -c "$(base64 -d <<< "\
IyEvdXNyL2Jpbi9iYXNoCmVjaG8gIkhlbGxvLCB3b3JsZCEiCg==")" bash "$@"
```

- Normal mode, with base64 encoding 5 times:

```bash
~$ ./obashfuscator.sh -f try_me.sh -n 5
~$ cat try_me_obfuscated.sh
bash -c "$(base64 -d <<< "\
YmFzaCAtYyAiJChiYXNlNjQgLWQgPDw8ICJcClltRnphQ0F0WXlBaUpDaGlZWE5sTmpRZ0xXUWdQ
RHc4SUNKY0NsbHRSbnBoUTBGMFdYbEJhVXBEYUdsWldFNXNUbXBSWjB4WFVXZFEKUkhjNFNVTktZ
ME5zYkhSU2JuQm9VVEJHTUZkWWJFSmhWWEJFWVVkc1dsZEZOWE5VYlhCU1dqQjRXRlZYWkZFS1Vr
aGpORk5WVGt0WgpNRTV5WWtSV1UxZEdjSEpXTUZVeFRsWlNSVk5yZEdwU01IQjNWREZrYzFkc1pF
Wk9XRnBTVFdwR1dGbFhNVWRUUlRsSVdrVnZTMWxVClNtOWpNV3h5V2tSU2F3cGhNMmhGVlZkd1Qy
RlZNSGRqU0hCWVlUQTFSMWxXVms5aWJFSlZUVWhDU21GWGRIQlRWV1JMWVVkTmVWb3kKWkVwaFZr
cENVMWRrZGxCVGEybExVMGxuV1cxR2VtRkRRV2xLUlVGcENrTm5QVDBwSWlraUlHSmhjMmdnSWlS
QUlnbz0pIikiIGJhc2ggIiRAIgo=")" bash "$@"
```

- Extended mode, with base64 encoding 2 times and then obfuscated by bash-obfuscate:

```bash
~$ ./obashfuscator.sh -f try_me.sh -n 2 -e
~$ cat try_me_obfuscated.sh
z="
";nz=' "$@';Lz='NlNj';Wz='NtVm';Uz='lpWV';Gz=' "Ym';Az='bash';cz='Q0Iz';Xz='phRz';Bz=' -c ';mz='")" ';Jz='AiJC';hz='Iiki';Ez='4 -d';Sz='wySn';bz='eHZM';ez='c1pD';Yz='hnSW';fz='RWlD';gz='Zz09';iz='IGJh';Iz='AtYy';Rz='hOeU';lz='Igo=';Mz='QgLW';Tz='BiaT';Vz='hOb0';az='bGJH';Kz='hiYX';Oz='w8IC';Nz='QgPD';Qz='V2ZF';Zz='to';kz='IiRA';jz='c2gg';Fz=' <<<';oz='"';Pz='JJeU';Dz='ase6';Hz='FzaC';Cz='"$(b';dz='YjNK';
eval "$Az$Bz$Cz$Dz$Ez$Fz$Gz$Hz$Iz$Jz$Kz$Lz$Mz$Nz$Oz$Pz$Qz$Rz$Sz$Tz$Uz$Vz$Wz$Xz$Yz$Zz$z$az$bz$cz$dz$ez$fz$gz$hz$iz$jz$kz$lz$mz$Az$nz$oz"
```

## FAQ

### Bash error "BASH_SOURCE[0]: unbound variable" when executing obfuscated script

If you are using `BASH_SOURCE` and `main` function in your bash script, please remove `BASH_SOURCE` and execute `main` function at the end of the script. Then obfuscate the script again, it will avoid this error.

### Bash error "Argument list too long" when executing obfuscated script

This error will appear when the output encoded base64 string is longer than [MAX_ARG_STRLEN (131072)](https://www.in-ulm.de/~mascheck/various/argmax/). It's usually caused by the huge input script size or too many times of base64 encoding. Split huge size script to several smaller ones or encode fewer times may help to solve this error.

### Is it easy to deobfuscate?

Yes, it's relatively easy to deobfuscate, if someone knows how the obfuscation works.
