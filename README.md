# coc-scripts
MacOS & Linux tools for working with releases from the Coin-Op Collection team.
# Support the Coin-Op Collection team exclusively at https://www.patreon.com/c/atrac17

coc_rom_generator.sh aims to provide support for MacOS and Linux users who are unable to utilize the Windows based Batch files and associated PowerShell functions that are provided with Coin-Op Collection releases. All prerequisites defined in the Coin-Op Collection release instructions remain. coc_rom_generator.sh & associated .env files simply replace the .bat files for MacOS and Linux users. 

coc_rom_generator.sh and associated .env files are to be copied into the same directory
that the Coin-Op Collection release zip file was extracted to and relies on the
Coin-Op Collection teams published Python repackaging tool that was included with the release.

mra.mac and mra.linux binaries are provided here as a convenience. Both were compiled from source for the respective target Operating Systems and don't appear to be distributed via common package managers. The mra tool was developed and is maintained by Sebastien Delestaing and can be found https://github.com/sebdel/mra-tools-c

Thank you to the Coin-Op Collection team and Sebastien Delestaing for their tireless efforts that continue to excite and amaze!

<pre>
  coc_rom_generator.sh:v0.01
  Select a ROM to generate:
  1) ctribe
  2) ddragon3
  3) wwfwfest
  Enter your choice (1-3):
</pre>
