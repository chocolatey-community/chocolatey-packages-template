#!/usr/bin/env python3
import argparse
import os
from xml.etree import ElementTree as ET

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Return the version of a nuspec file')
    parser.add_argument('file')
    args = parser.parse_args()

    filename = os.path.abspath(args.file)
    tree = ET.parse(filename)
    root = tree.getroot()
    metadata = root.find("{http://schemas.microsoft.com/packaging/2015/06/nuspec.xsd}metadata")
    versionElement = metadata.find("{http://schemas.microsoft.com/packaging/2015/06/nuspec.xsd}version")

    print(versionElement.text)
