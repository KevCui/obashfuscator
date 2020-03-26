obashfuscate
============

obashfuscate aims to obfuscate Bash scripts: make script unreadable at first glance and still keep it executable without losing any functionalities.

## Why?

Why not... Maybe for fun? You might tell me the reason if it's somehow useful.

## Dependency

No dependency for normal mode (base64 encoding). However, for extended mode, [bash-obfuscate](https://github.com/willshiao/node-bash-obfuscate) is required.

## Usage

```bash
Usage:
  ./obashfuscate.sh -f <bash_script> [-n <num>] [-e]

Options:
  -f <bash_script>   Input script to obfuscate
  -n <num>           Optional, num of times for base64 encoding
                     If not set, 1 by default
  -e                 Optional, extended mode
                     Use bash-obfuscate on top, by default not
  -h | --help        Display this help message
```

### Example

- Normal mode, with base64 encoding 1 time:

```bash
~$ cat try_me.sh
#!/usr/bin/bash
echo "Hello, world!"
~$ ./obashfuscate.sh -f try_me.sh
~$ cat try_me_obfuscated.sh
bash -c "$(base64 -d <<< "IyEvdXNyL2Jpbi9iYXNoCmVjaG8gIkhlbGxvLCB3b3JsZCEiCg==")" bash "$@"
```

- Normal mode, with base64 encoding 5 times:

```bash
~$ ./obashfuscate.sh -f try_me.sh -n 5
~$ cat try_me_obfuscated.sh
bash -c "$(base64 -d <<< "YmFzaCAtYyAiJChiYXNlNjQgLWQgPDw8ICJZbUZ6YUNBdFl5QWlKQ2hpWVhObE5qUWdMV1FnUER3
OElDSlpiVVo2WVVOQmRGbDVRV2xLUTJocFdWaE9iRTVxVVdkTVYxRm5VRVIzCk9FbERTbHBpVlZv
MldWVk9RbVJHYkRWUlYyeExVVEpvY0ZkV2FFOWlSVFZ4VlZka1RWWXhSbTVWUlZJekNrOUZiRVJU
YTNCc1ZsWloKZVZkcldtOVVNbFpXWkROc1ZHSnJTbkJaVmxKelkwWmtWMkZGT1dsTlJUVXdWbTB4
ZDJGR1NqWmhSelZVVmpOU2RrTnRTa2hUYTJocwpVMFp3VGxWVVFrb0taV3hzY1ZScmRHcE5XRUpG
Vld4a2MxSkdjRFpOUkd4S1lWZDBjRk5WWkV0aFIwMTVXakprU21GV1NrSlRWMlIyClVGTkpjRWxw
UW1sWldFNXZTVU5KYTFGRFNVc2lLU0lnWW1GemFDQWlKRUFpQ2c9PSIpIiBiYXNoICIkQCIK")" bash "$@"
```

- Extended mode, with base64 encoding 2 times and then obfuscated by bash-obfuscate:

```bash
~$ ./obashfuscate.sh -f try_me.sh -n 2 -e
~$ cat try_me_obfuscated.sh
z="
";nz=' "$@';Lz='NlNj';Wz='NtVm';Uz='lpWV';Gz=' "Ym';Az='bash';cz='Q0Iz';Xz='phRz';Bz=' -c ';mz='")" ';Jz='AiJC';hz='Iiki';Ez='4 -d';Sz='wySn';bz='eHZM';ez='c1pD';Yz='hnSW';fz='RWlD';gz='Zz09';iz='IGJh';Iz='AtYy';Rz='hOeU';lz='Igo=';Mz='QgLW';Tz='BiaT';Vz='hOb0';az='bGJH';Kz='hiYX';Oz='w8IC';Nz='QgPD';Qz='V2ZF';Zz='to';kz='IiRA';jz='c2gg';Fz=' <<<';oz='"';Pz='JJeU';Dz='ase6';Hz='FzaC';Cz='"$(b';dz='YjNK';
eval "$Az$Bz$Cz$Dz$Ez$Fz$Gz$Hz$Iz$Jz$Kz$Lz$Mz$Nz$Oz$Pz$Qz$Rz$Sz$Tz$Uz$Vz$Wz$Xz$Yz$Zz$z$az$bz$cz$dz$ez$fz$gz$hz$iz$jz$kz$lz$mz$Az$nz$oz"
```

## FAQ

### Bash error "BASH_SOURCE[0]: unbound variable" when executing obfuscated script

If you are using `BASH_SOURCE` and `main` function in your bash script, please remove `BASH_SOURCE` and execute `main` function at the end of the script. Then obfuscate the script again, it will avoid this error.

### Bash error "Argument list too long" when executing obfuscated script

This error will appear when input script size is hug or base64 encoding too many times, the output encoded base64 string is long than [MAX_ARG_STRLEN (131072)](https://www.in-ulm.de/~mascheck/various/argmax/). Split huge size script to several smaller ones or encode less times may help to solve this error.

### Is it easy to deobfuscate?

Yes, it's relatively easy to deobfuscate, if someone knows how the obfuscation works.
