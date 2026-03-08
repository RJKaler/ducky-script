#!/bin/bash -ex

#NOTE - THIS IS A TEMPLATE. YOU HAVE TO MANUALLY EXTRACT THE URL FOR THE DOWNLOAD. IF YOU DON'T KNOW HOW TO DO THAT, WELL, SORRY... 
#shellcheck disable=all

#NOTE: This is done with the assumption that the owners of Hak5 will not issue a takedown request for a copyright infringment
#Run at your own risk. I do not endorse any unethical behavior regarding the actual physical manual. This is for a digital PDF and I don't think it's even sold in this form

#You can manually download a free copy here: https://shop.hak5.org/products/usb-rubber-ducky-e-book?srsltid=AfmBOoqYed-cFYrUBBfwFhIuVfM_7KLXx0fB6xCCaSbctgYuGHiQwl0w

#Tested on Kubuntu using Ubuntu kernel. Version:
# 6.14.0-37-generic #37~24.04.1-Ubuntu SMP PREEMPT_DYNAMIC Thu Nov 20 10:25:38 UTC 2 x86_64 x86_64 x86_64 GNU/Linux



#   curl -L -O "$filesource"  || echo 'error'

while read -rep "Enter destination dir for download: " dir_target
do
  if [[ -d "$dir_target" ]]; then
    pushd "$dir_target" &>/dev/null &&
    break
  else
    echo "Dir does not exist! Try again..."
  fi
done

echo "Currently in $PWD"

filesource="https://libgen.la/get.php?md5=8638619c05f6042d1b70b3658a2dba7b&key=NHQYGDAJLBM61S9F"
until curl -fL -O -C - --retry 50 --retry-delay 5 --retry-all-errors "$filesource"
do
        sleep 8
        echo "waiting for download..."
done

rename_file() {
  mv -v get.php Rubber_Ducky.pdf
}

rename_file

xdg-open "$dir_target"/Rubber_Ducky.pdf
