# sugarshaker

Been a while since I looked at this, but just did a build now 👎

* Windows - root folder where sugar.s is, used `make.bat sugar`
* Other OSes, may need tweaks to the Makefile, but effectively build `sugar.s` and it should include the rest

Windows = `vasm -m68000 -Ftos -noesc -quiet -no-opt %1.s -o %1.tos`

Mac/Linux = `vasm -m68000 -Ftos -noesc -quiet -no-opt $1.s -o $1.tos`

no need for separate linking step

