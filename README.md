# test_asm_sasm

一个用 SASM 自带工具链（位于 C:\Program Files (x86)\SASM）构建的小型 64 位 NASM 程序：

  - NASM\nasm.exe        - 汇编为 Win64 COFF 目标文件
  - MinGW64\bin\gcc.exe - 链接 C 运行时（x86_64-w64-mingw32，基于旧版 MSVCRT）

本地构建并运行（PowerShell）：

    .\build.ps1

它会汇编 src/main.asm，链接生成 build/main.exe 并运行。
程序会打印一行标题、计算 1 到 100 的累加和（结果应为 5050），最后以退出码 0 结束。

CI（持续集成）：

.github/workflows/build.yml 在 GitHub Actions 上使用等价的 MSYS2 UCRT64
nasm + gcc（mingw-w64-ucrt-x86_64-* 包）复现完全相同的构建，然后运行生成的可执行文件。
UCRT64 使用 UCRT 运行库，兼容性与 UTF-8 locale 支持更好，且避免了已弃用的 MINGW64 环境。
查看运行日志可用：

    gh run watch
