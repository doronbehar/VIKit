#!/bin/bash
#
# VISharedFunctions.sh
# Copyright 2014 Joe Friedrichsen
# Licensed under the Apache License, Version 2.0

set -e

# sed RegEx to replace / with \ in a path
ToWindowsSeparators='s/\//\\/g'

# sed RegEx to replace \ with / in a path
ToBashSeparators='s/\\/\//g'

# sed RegEx to make a path suitable for Windows (C: instead of /c)
ToWindowsRoot='s/^\/\([a-z]\)/\U\1:/'

# sed RegEx to make a path suitable for Bash (/c instead of C:)
ToBashRoot='s/^\([a-z]\):/\/\L\1/'

function ToWindowsPath
{
   echo "$1" | sed -e "${ToWindowsRoot}" | sed -e "${ToWindowsSeparators}"
}

function ToBashPath
{
   echo "$1" | sed -e "${ToBashRoot}" | sed -e "${ToBashSeparators}"
}

function ExitWithError
{
   echo >&2 "ERROR: $1"
   exit 1;
}

# Return the year-based LabVIEW release associated with the file version in $1
function YearForFileVersion
{
   case "$1" in
      9.0)  echo 2009 ;;
      10.0) echo 2010 ;;
      11.0) echo 2011 ;;
      12.0) echo 2012 ;;
      13.0) echo 2013 ;;
      14.0) echo 2014 ;;
      *) ExitWithError "Unknown LabVIEW file version: $1." ;;
   esac
}

# Quit if a LabVIEW instance is running for year version in $1
function AssertCanRunVIs
{
   local LabviewYear
   LabviewYear="$1"

   if $(ps -W | grep -q "LabVIEW ${LabviewYear}"); then
      ExitWithError "Cannot run VI while LabVIEW ${LabviewYear} is running."
   fi
}

# Return the Windows path for LabVIEW.exe with year version in $1
function FindLabviewExecutable
{
   local LabviewYear
   local LabviewPath

   LabviewYear=$1
   if test -x "/c/Program Files/National Instruments/LabVIEW ${LabviewYear}/LabVIEW.exe"; then
      LabviewPath="/c/Program Files/National Instruments/LabVIEW ${LabviewYear}/LabVIEW.exe"
   elif test -x "/c/Program Files (x86)/National Instruments/LabVIEW ${LabviewYear}/LabVIEW.exe"; then
      LabviewPath="/c/Program Files (x86)/National Instruments/LabVIEW ${LabviewYear}/LabVIEW.exe"
   else
      ExitWithError "LabVIEW ${LabviewYear} is not installed."
   fi

   AssertCanRunVIs "${LabviewYear}"
   echo $(ToWindowsPath "${LabviewPath}")
}

# Return the Windows path for the LabVIEW version used for file path in $1
function DetectLabviewVersion
{
   local VIQueryVersion
   local CanDetectLabview
   local FilePath
   local FileVersion
   local FileYear
   local LabviewPath

   VIQueryVersion=VIQueryVersion
   CanDetectLabview=$(which ${VIQueryVersion} 2>/dev/null)

   if test -n "${CanDetectLabview}"; then
      FilePath=$(ToWindowsPath "$1")
      FileVersion=$(${VIQueryVersion} "${FilePath}")
      FileYear=$(YearForFileVersion "${FileVersion}")
      LabviewPath=$(FindLabviewExecutable "${FileYear}")

      if test -n "${LabviewPath}"; then
         echo $(ToWindowsPath "${LabviewPath}")
      else
         ExitWithError "${FilePath} is written in LabVIEW ${FileYear}."
      fi
   else
      ExitWithError "Cannot find ${VIQueryVersion} in your path. Is it installed, or do you need to build it by hand?"
   fi
}

# Return the path to a VI named $1 by searching the system's PATH
function FindRunnableVI
{
   local Runnable
   local RunnablePath

   Runnable="$1"
   DefaultIFS="${IFS}"
   IFS=":"
   for path in $PATH; do
      if test -f "${path}/${Runnable}"; then
         RunnablePath="${path}/${Runnable}"
         break
      fi
   done
   IFS="${DefaultIFS}"

   if test -z "${RunnablePath}"; then
      ExitWithError "Could not find ${Runnable} in your path."
   fi
   
   echo $(ToWindowsPath ${RunnablePath})
}

function CallLabview
{
   local LabviewPath
   local RunnerPath

   LabviewPath="$1"
   RunnerPath="$2"
   shift
   shift

   echo "${LabviewPath}" "${RunnerPath}" -- $@
   "${LabviewPath}" "${RunnerPath}" -- $@
}

