MIT License

Copyright (c) 2026

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

### THIRD-PARTY LIBRARIES AND LICENSES

This package includes bundled shared libraries in the `lib/` directory.

#### GNU C Library (glibc)
The libraries `libc.so.6`, `libm.so.6`, `libpthread.so.0`, `libdl.so.2`, and `ld-linux-aarch64.so.1` are part of the **GNU C Library (glibc)**.
- **License:** GNU Lesser General Public License (LGPL) version 2.1 or later.
- **Source:** You can obtain the source code for glibc at https://www.gnu.org/software/libc/

#### GCC Runtime Library
The library `libgcc_s.so.1` and `libstdc++.so.6` are part of the **GCC compiler collection**.
- **License:** GNU General Public License (GPL) version 3 with the Runtime Library Exception.
- **Source:** https://gcc.gnu.org/

#### Geekbench 6
This patch does NOT include the Geekbench 6 binaries themselves. It is designed to patch the official binaries provided by **Primate Labs**. Geekbench 6 is proprietary software and is subject to its own Terms of Service and Licensing agreements.

---
AI-assisted with **gemini-cli**.
