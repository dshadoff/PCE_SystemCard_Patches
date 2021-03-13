# PC Engine System Card Patches Project

Rather than create separate repositories for each of the projects, this repository will
hold many projects related to patching of the CD System Card.  Unless otherwise specified,
the Japanese CD Super System Card 3.0 will be used as the base for the modifications.

As opposed to "finished products", these patches will more likely (unless otherwise specified)
resemble work-in-progress pieces, but each commit should be fairly solid in terms of stability,
and including a reasonable feature set.

## CD_READ_Log-to-USB

This patch intercepts the call to CD_READ ($00:$E009 on the System Card), and sends details of the
request to the port on a HuUSB board, where the output can be displayed and/or logged by a terminal
program such as TeraTerm.

HuUSB is an interface card detailed in another repo, http://www.github.com/dshadoff/PCE_HuBus_Projects

Note: this currently does not detect whether the HuUSB board is available; if it isn't, accesses
to the CD-ROM may hang (waiting for the HuUSB to be ready).

## Notes:

These patches are assembled using the version of 'PCEAS' from the http://www.github.com/dshadoff/huc
repository, but should assemble by using virtually any version of PCEAS, since I try not to be reliant
on the libraries included in HuC/PCEAS

The version of the System Card which I use as a base (unless otherwise specified) is the Japanese Super
System Card version 3.0, with no headers, and a length of 262,144 bytes, with no other modifications
applied, which should be in the PCE_INCLUDE path with the name "syscard3.pce".


