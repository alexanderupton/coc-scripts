## Contents

- [coc-scripts](#coc-scripts)
- [coc_rom_generator.sh](#coc_rom_generator.sh)
- [update_coc.sh](#update_coc.sh)


## coc-scripts
MacOS & Linux tools for working with releases from the Coin-Op Collection team.
# Support the Coin-Op Collection team exclusively at https://www.patreon.com/c/atrac17

## coc_rom_generator.sh 
coc_rom_generator.sh aims to provide support for MacOS and Linux users who are unable to utilize the Windows based Batch files and associated PowerShell functions that are provided with Coin-Op Collection releases. All prerequisites defined in the Coin-Op Collection release instructions remain. coc_rom_generator.sh & associated .env files simply replace the .bat files for MacOS and Linux users. 

coc_rom_generator.sh and associated .env files are to be copied into the same directory
that the Coin-Op Collection release zip file was extracted to and relies on the
Coin-Op Collection teams published Python repackaging tool that was included with the release.

mra.mac and mra.linux binaries are provided here as a convenience. Both were compiled from source for the respective target Operating Systems and don't appear to be distributed via common package managers. The mra tool was developed and is maintained by Sebastien Delestaing and can be found https://github.com/sebdel/mra-tools-c

Thank you to the Coin-Op Collection team and Sebastien Delestaing for their tireless efforts that continue to excite and amaze!

<pre>
  coc_rom_generator.sh:v0.01
  Select a ROM to generate:
  1) agallet
  2) ctribe
  3) ddragon3
  4) sailormn
  5) wwfwfest
  Enter your choice (1-5):
</pre>

## update_coc.sh
Update your "_Arcade/_Coin-Op Collection" library directly from the Coin-Op Collection's Github page or downloaded release files.
- Base release and alternatives are supported
- All files are deployed to "/media/fat/_Arcade/_Coin-Op Collection"

  
### update from a downloaded file
<pre>
  /media/fat#  /media/fat/Scripts/update_coc.sh -f /tmp/MiSTerFPGA_CNINJA_20260616.zip

  Launching Update Coin-Op Collection
  Installed: Tatakae Genshijin Joe & Mac (Japan, Ver. 1).mra
  Installed: Caveman Ninja (World, Ver. 1).mra
  Installed: Caveman Ninja (US, Ver. 4).mra
  Installed: cninja_mister.rbf
  Installed: Caveman Ninja (World, Ver. 4).mra
  
</pre>

### update from https://github.com/Coin-OpCollection/Distribution-MiSTerFPGA
Updating from the Coin-Op Collection Github is the default mode.
<pre>
  /media/fat/Scripts/update_coc.sh

Launching Update Coin-Op Collection
  Downloading Coin-Op Collection... done
  Installed: tmnt2_mister_20251012.rbf
  Installed: Teenage Mutant Ninja Turtles - Turtles in Time (4 Players Ver. UEA).mra
  Installed: Teenage Mutant Ninja Turtles - Turtles in Time (4 Players Ver. OAA).mra
  Installed: Teenage Mutant Ninja Turtles - Turtles in Time (4 Players Ver. ADA).mra
  Installed: Teenage Mutant Ninja Turtles - Turtles in Time (2 Players Ver. UDA).mra
  Installed: Teenage Mutant Hero Turtles - Turtles in Time (4 Players Ver. EAA).mra
  Installed: Teenage Mutant Hero Turtles - Turtles in Time (2 Players Ver. EBA).mra
  Installed: Teenage Mutant Ninja Turtles - Turtles in Time (4 Players Ver. UAA).mra
</pre>

### all up to date
<pre>
  /media/fat/Scripts/update_coc.sh

  Launching Update Coin-Op Collection
  Downloading Coin-Op Collection... done
  Complete... No changes
</pre>
