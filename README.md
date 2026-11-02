# test_asm_sasm

一个用 SASM 自带工具链（位于 C:\Program Files (x86)\SASM）构建的小型 64 位 NASM 程序：

  - NASM\nasm.exe        - 汇编为 Win64 COFF 目标文件
  - MinGW64\bin\gcc.exe - 链接 C 运行时（x86_64-w64-mingw32）

本地构建并运行（PowerShell）：

    .\build.ps1

它会汇编 src/main.asm，链接生成 build/main.exe 并运行。
程序会打印一行标题、计算 1 到 100 的累加和（结果应为 5050），最后以退出码 0 结束。

CI（持续集成）：

.github/workflows/build.yml 在 GitHub Actions 上使用等价的 MSYS2 MINGW64
nasm + gcc 复现完全相同的构建，然后运行生成的可执行文件。
查看运行日志可用：

    gh run watch
