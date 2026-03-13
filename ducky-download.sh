#!/bin/bash 

#shellcheck disable=all

#NOTE: This is done with the assumption that the owners of Hak5 will not issue a takedown request for a copyright infringment 
#Run at your own risk. I do not endorse any unethical behavior regarding the actual physical manual. This is for a digital PDF and I don't think it's even sold in this form 

#You can manually download a free copy here: https://shop.hak5.org/products/usb-rubber-ducky-e-book?srsltid=AfmBOoqYed-cFYrUBBfwFhIuVfM_7KLXx0fB6xCCaSbctgYuGHiQwl0w

#Tested on Kubuntu using Ubuntu kernel. Version: 
# 6.14.0-37-generic #37~24.04.1-Ubuntu SMP PREEMPT_DYNAMIC Thu Nov 20 10:25:38 UTC 2 x86_64 x86_64 x86_64 GNU/Linux

#   curl -L -O "$filesource"  || echo 'error'

while :
do
filesource="https://libgen.la/get.php?md5=8638619c05f6042d1b70b3658a2dba7b&key=L2DB0W9DMNOLOX4O"
 #filesource="https://libgen.la/get.php?md5=8638619c05f6042d1b70b3658a2dba7b&key=WYLTVT5U83ADZXHV"
 if curl -fL -O -C - --retry 50 --retry-delay 5 --retry-all-errors "$filesource"; then
        echo "Download complete!"
        break
    else
        echo "Download failed, retrying in 5s..."
        sleep 5
    fi
done

rename_file() {
  mv -v get.php Rubber_Ducky.pdf
}

rename_file 

xdg-open Rubber_Ducky.pdf


