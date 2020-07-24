# bash-toolkit

- **Maintained by**:
    [Jover Zhang](https://www.joverzhang.com) < joverzh@gmail.com >

# List
+ common
    + [cecho.bash](##common/cecho.bash)

+ docker
    + [listenDog.sh](##docker/listenDog.sh)

# Summary

## common/cecho.bash
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

## docker/listenDog.sh
> author: Jover Zhang

The script listens to update for a file. It can execute a callback command when the file updated.
