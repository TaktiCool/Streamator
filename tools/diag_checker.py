#!/usr/bin/env python3

import fnmatch
import os
import ntpath
import sys
import argparse

ignored = []

toCheck = ["diag_log", "systemchat", "hint", "hintsilent"]

def check_sqf_syntax(filepath):
    bad_count_file = 0
    with open(filepath, 'r', encoding='utf-8', errors='ignore') as file:
        content = file.read()
        for check in toCheck:
            start = 0
            while True:
                start = content.find(check, start, len(content))
                if (start == -1):
                    break;
                else:
                    start += len(check)
                    bad_count_file += 1
                    print("WARNING: {0} Contains Debug type {1}".format(filepath, check));
                pass
            pass
        return bad_count_file;

def main():
    print("Checking for Diag/Debug Messages")

    sqf_list = []
    bad_count = 0

    parser = argparse.ArgumentParser()
    parser.add_argument('-m','--module', help='only search specified module addon folder', required=False, default="")
    args = parser.parse_args()

    # Allow running from root directory as well as from inside the tools directory
    rootDir = "../addons"
    if (os.path.exists("addons")):
        rootDir = "addons"

    for root, dirnames, filenames in os.walk(rootDir + '/' + args.module):
        if root not in ignored or dirnames not in ignored or filenames not in ignored:
            for filename in fnmatch.filter(filenames, '*.sqf'):
                sqf_list.append(os.path.join(root, filename))

    for filename in sqf_list:
        bad_count = bad_count + check_sqf_syntax(filename)


    print("------\nChecked {0} files\nErrors detected: {1}".format(len(sqf_list), bad_count))
    if (bad_count == 0):
        print("Diag validation PASSED")
    else:
        print("Diag validation FAILED")

    return bad_count


if __name__ == "__main__":
    sys.exit(main())
