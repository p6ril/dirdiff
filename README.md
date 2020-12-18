# dirdiff

`dirdiff` is a simple command line bash script that compares the files in 2 directories.

It works either by comparing file sizes and modification times or by comparing file checksums.

The default option is to work with file sizes and modification times as it's fast and efficient.

Working with checksums can be more accurate but very long when dealing with large files.

```
USAGE: dirdiff.sh [options] <directory path 1> <directory path 2>
       shows the files that are not in sync between both directories.

OPTIONS: -t or --time difference based on size and timestamp (default, fast)
         -c or --checksum difference based on MD5 checksum calculation
```
