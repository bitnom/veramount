# veramount
Nim program to auto-mount Veracrypt volumes using keyfiles whenever a flash drive containing keyfiles is mounted. Threw first version together really fast. Work in progress.


I wanted a way to auto-mount my veracrypt volumes whenever I insert a flash drive containing keyfiles (1 keyfile per drive). That way, I can encrypt the flash drive and only ever have to type a password once. First I thought to use crypttab but that doesn't jive with keeping the keyfiles in an encrypted container so I made veramount.

This program will constantly look for a file called keydrive on the first drive specified in mounts.txt. This is how the program knows you've mounted the drive containing the keyfiles. It then uses the mount definitions in mounts.txt to mount your Veracrypt drives. You have to specify their /dev/disk/by-path paths because using /dev/sdx is subject to change on reboot. Use `ls -l /dev/disk/by-path` to figure out what the paths are. After mounting the drives, it will then pool them together in a mergerfs pool. If you don't want that to happen, comment that line out.

Usage: Add program to your startup scripts or something like /etc/rc.d/rc.local. Whatever method you choose.

If you need to recompile: `nim c --d:release veramount.nim`
