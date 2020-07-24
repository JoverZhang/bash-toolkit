# bash-toolkit

- **Maintained by**:
    [Jover Zhang](https://www.joverzhang.com) < joverzh@gmail.com >

# List
+ common
    + [cecho.bash](#commoncechobash)

+ docker
    + [listenDog.sh](#dockerlistendogsh)

# Summary

### common/cecho.bash
> author: GNU  
> url: https://bytefreaks.net/gnulinux/bash/cecho-a-function-to-print-using-different-colors-in-bash

The following function prints a text using custom color  
-c or --color define the color for the print. See the array colors for the available options.  
-n or --noline directs the system not to print a new line after the content.  
Last argument is the message to be printed.  

E.g:
```shell script
source common/cecho.bash
cecho -c red 'Hello cecho.bash'
```

### docker/listenDog.sh
> author: Jover Zhang  
> url: https://github.com/JoverZhang/bash-toolkit/blob/master/docker/listenDog.sh
```shell script
Usage:
  listenDog.sh [OPTIONS] <LISTENS_NAME> <CALLBACK_CMD>

Listens file(or directory), execute callback command when the file(or directory) updated.

LISTENS_NAME:          file(or directory) to be listens
CALLBACK_CMD:          callback command. When NAME updated to be executed

Options:
  -i, --interval       Set interval of listening (default 0.1s)
```

E.g:
```shell script
./listenDog.sh ./target/$PACKAGE.jar java -jar ./target/$PACKAGE.jar
```
