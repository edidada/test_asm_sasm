# Builds the project.
# Default toolchain is the SASM-shipped NASM + MinGW64 (MSVCRT) gcc.
# Use -Toolchain UCRT64 to build with a local MSYS2 UCRT64 toolchain
# (matches the CI environment). It falls back to tools on PATH.
[CmdletBinding()]
param(
    [ValidateSet('SASM', 'UCRT64')]
    [string]$Toolchain = 'SASM'
)

$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$src      = Join-Path $ScriptDir 'src\main.asm'
$buildDir = Join-Path $ScriptDir 'build'
$obj      = Join-Path $buildDir 'main.obj'
$exe      = Join-Path $buildDir 'main.exe'

switch ($Toolchain) {
    'SASM' {
        $nasmCandidates = @('C:\Program Files (x86)\SASM\NASM\nasm.exe')
        $gccCandidates  = @('C:\Program Files (x86)\SASM\MinGW64\bin\gcc.exe')
        $label = 'SASM (MinGW64 / MSVCRT)'
    }
    'UCRT64' {
        $nasmCandidates = @('C:\msys64\ucrt64\bin\nasm.exe')
        $gccCandidates  = @('C:\msys64\ucrt64\bin\gcc.exe')
        $label = 'MSYS2 UCRT64'
    }
}

function Resolve-Tool {
    param($name, $candidates)
    foreach ($c in $candidates) {
        if ($c -and (Test-Path $c)) { return $c }
    }
    $cmd = Get-Command $name -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Path }
    throw "Cannot locate tool: $name (searched: $($candidates -join ', '))"
}

$nasm = Resolve-Tool 'nasm' $nasmCandidates
$gcc  = Resolve-Tool 'gcc'  $gccCandidates

Write-Host "Toolchain: $label"
Write-Host "Using nasm: $nasm"
Write-Host "Using gcc : $gcc"

New-Item -ItemType Directory -Force -Path $buildDir | Out-Null

& $nasm -f win64 $src -o $obj
if ($LASTEXITCODE -ne 0) { throw "nasm failed with exit code $LASTEXITCODE" }

& $gcc $obj -o $exe
if ($LASTEXITCODE -ne 0) { throw "gcc failed with exit code $LASTEXITCODE" }

Write-Host "Build OK -> $exe"
& $exe
if ($LASTEXITCODE -ne 0) { throw "program exited with code $LASTEXITCODE" }
Write-Host "Run OK"
