#!/bin/bash


# davanti: bootloader, decompressore per gzip
# dietro: il kernel e altra roba poco identificata
#  |--- davanti --- | ---      ---      gzip      ---      --- |   <- la rom finale
#                   | --- cpio della root --- | --- dietro --- |   <- dentro il gzip
                       

echo "Faccio archivio cpio"
 
 
cd ./src/cpio-root
find . -print | cpio -ov > ../../__blob.cpio
cd ../../

 
echo "Faccio il dentro del gzip"
 
cat __blob.cpio src/dietro > __dentro_gzip


echo "Creo il gzip"

cat __dentro_gzip | gzip --best > __gzippato



echo "Creo la rom finale"

cat src/davanti  __gzippato src/dietro_gzip > __firmware

echo "Metto il padding giusto"

#dd if=0xff.blob of=nuovo_blob bs=1 count=0 seek=8388608 
cp src/0xff.blob nuovo_blob
dd if=__firmware of=nuovo_blob conv=notrunc
