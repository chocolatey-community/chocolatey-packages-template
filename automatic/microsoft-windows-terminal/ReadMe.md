# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@7d924f094e0faea8c264d6b973e7388c5f3a9ac8/icons/microsoft-windows-terminal.png" width="48" height="48"/> [microsoft-windows-terminal](https://community.chocolatey.org/packages/microsoft-windows-terminal)

## Terminal & Console Overview

Please take a few minutes to review the overview below before diving into the code:

### Windows Terminal

Windows Terminal is a new, modern, feature-rich, productive terminal application for command-line users. It includes many of the features most frequently requested by the Windows command-line community including support for tabs, rich text, globalization, configurability, theming & styling, and more.

The Terminal will also need to meet our goals and measures to ensure it remains fast, and efficient, and doesn't consume vast amounts of memory or power.

### The Windows console host

The Windows console host, `conhost.exe`, is Windows' original command-line user experience. It implements Windows' command-line infrastructure, and is responsible for hosting the Windows Console API, input engine, rendering engine, and user preferences. The console host code in this repository is the actual source from which the `conhost.exe` in Windows itself is built.

Console's primary goal is to remain backwards-compatible with existing console subsystem applications.

Since assuming ownership of the Windows command-line in 2014, the team has added several new features to the Console, including window transparency, line-based selection, support for [ANSI / Virtual Terminal sequences](https://en.wikipedia.org/wiki/ANSI_escape_code), [24-bit color](https://devblogs.microsoft.com/commandline/24-bit-color-in-the-windows-console/), a [Pseudoconsole ("ConPTY")](https://devblogs.microsoft.com/commandline/windows-command-line-introducing-the-windows-pseudo-console-conpty/), and more.

However, because the Console's primary goal is to maintain backward compatibility, we've been unable to add many of the features the community has been asking for, and which we've been wanting to add for the last several years--like tabs!

These limitations led us to create the new Windows Terminal.

### Shared Components

While overhauling the Console, we've modernized its codebase considerably. We've cleanly separated logical entities into modules and classes, introduced some key extensibility points, replaced several old, home-grown collections and containers with safer, more efficient [STL containers](https://docs.microsoft.com/en-us/cpp/standard-library/stl-containers?view=vs-2019), and made the code simpler and safer by using Microsoft's [WIL](https://github.com/Microsoft/wil) header library.

This overhaul work resulted in the creation of several key components that would be useful for any terminal implementation on Windows, including a new DirectWrite-based text layout and rendering engine, a text buffer capable of storing both UTF-16 and UTF-8, and a VT parser/emitter.

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know the package is no longer updating correctly.