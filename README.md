VIKit
=====

Tools for VIs and LabVIEW Development
-------------------------------------

### Tool list

* **VIBuildProject** -- builds a LabVIEW project.
* **VIPreCommitSnipDiagram** -- mirrors LabVIEW source as VI snippets as part of `git commit`. 
* **VIQueryBuildSpecs** -- prints all of the build specifications in a LabVIEW project.
* **VIQueryVersion** -- prints what LabVIEW version a LabVIEW file was written in.
* **VISnipDiagram** -- creates VI snippets from a VI or folder.

### Usage

* **VIBuildProject** -- builds a LabVIEW project.

>```
$ VIBuildProject.sh --project 'C:\path\to\VIKit.lvproj'
>
$ VIBuildProject.sh --project 'C:\path\to\VIKit.lvproj' --target 'VIKit.dll@My Computer'
>
$ VIBuildProject.sh --project 'C:\path\to\VIKit.lvproj' --lv-version 2014
```

* **VIPreCommitSnipDiagram** -- mirrors LabVIEW source as VI snippets as part of `git commit`. 

>```
$ VIPreCommitSnipDiagram.sh install "relative/path/to/labview/source" "relative/path/to/snippet/mirror"
```

* **VIQueryBuildSpecs** -- prints all of the build specifications in a LabVIEW project.

>```
$ VIQueryBuildSpecs.exe 'C:\path\to\VIKit.lvproj'
My Computer     VIKit.dll       DLL
```

* **VIQueryVersion** -- prints what LabVIEW version a LabVIEW file was written in.

>```
$ VIQueryVersion.exe 'C:\path\to\VIQueryVersion.vi'
13.0
>
$ VIQueryVersion.exe 'C:\path\to\VIKit.lvproj'
13.0
```

* **VISnipDiagram** -- creates VI snippets from a VI or folder.

>```
$ VISnipDiagram.sh --vi 'C:\path\to\VIQueryVersion.vi' --png 'C:\path\to\VIQueryVersion.png'
>
$ VISnipDiagram.sh --vi 'C:\path\to\vi\source' --png 'C:\path\to\snippet\mirror' --lv-version 2014
```

Getting Started
---------------

* These instructions assume you have MinGW installed.
* Unpack the distribution:
```
$ tar -xzf VIKit.tar.gz
```
* Build the tools:
```
$ cd VIKit
$ make
gcc -std=c99 VIQueryVersion.c -o VIQueryVersion.exe -lVIKit -LVIKit
.
.
.
```
* Install the tools:
```
$ make install DEST='/path/to/your/bin'
```
* Enable VI auto-snippets-on-git-commit for a repository ([like VIKit has](http://github.com/wireddown/VIKit/tree/master/source/lv-snippet)):
```
$ cd /path/to/your/git/repository
$ VIPreCommitSnipDiagram.sh install "relative/path/to/labview/source" "relative/path/to/snippet/mirror"
$ VISnipDiagram.sh --vi 'C:\full\path\to\labview\source' --png 'C:\full\path\to\snippet\mirror' --lv-version 2014
$ git add 'C:\full\path\to\snippet\mirror'
$ git commit -m "Adding VI snippet mirror"
```

Requirements
------------

* Windows XP or later
* [LabVIEW 2013 Run-Time Engine](http://www.ni.com/download/labview-run-time-engine-2013-sp1/4539/en/)
* `VIBuildProject.sh` requires a LabVIEW IDE with [Application Builder](http://sine.ni.com/nips/cds/view/p/lang/en/nid/210593)
* `VISnipDiagram.sh` requires a LabVIEW IDE

