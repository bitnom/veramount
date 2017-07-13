import
    strutils,
    os,
    osproc

var
    procMounts:string
    lineSplit:seq[string]
    keyDrive:string
    keyFile:string
    keyInserted:bool = false
    mounted:bool = false
    fired:bool = false

while true:
    if not mounted:
        procMounts = readFile("/proc/mounts")
        for line in lines "mounts.txt":
            lineSplit = line.split("=")
            if lineSplit.len() == 2:
                keyDrive = lineSplit[1]
                keyFile = keyDrive & "/keydrive"
                if keyFile.existsFile():
                    keyInserted = true
                else:
                    keyInserted = false
            lineSplit = line.splitWhitespace()
            if lineSplit.len() == 3 and keyInserted:
                discard startProcess("veracrypt -t --non-interactive --mount -k " & keyDrive & "/" & lineSplit[0] & " " & lineSplit[1] & " " & lineSplit[2], "/usr/bin", [], nil, {poEvalCommand})
                fired = true
                mounted = true
                echo "veracrypt -t --non-interactive --mount -k " & keyDrive & "/" & lineSplit[0] & " " & lineSplit[1] & " " & lineSplit[2]
                sleep(3000)
        if fired:
            discard startProcess("mergerfs -o defaults,allow_other,use_ino,moveonenospc=true /media/pool\\* /media/merger", "/usr/bin", [], nil, {poEvalCommand})
            fired = false
    sleep(1000)
