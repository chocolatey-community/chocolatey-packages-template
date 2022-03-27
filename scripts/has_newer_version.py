#!/usr/bin/env python3
import argparse
from distutils.version import LooseVersion

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('current_version')
    parser.add_argument('release_version')
    args = parser.parse_args()

    if LooseVersion(args.current_version) < LooseVersion(args.release_version):
        print("true")
    else:
        print("false")
