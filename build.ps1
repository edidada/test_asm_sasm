# Builds the project with the SASM-shipped NASM + MinGW-w64 gcc.
# Falls back to tools found on PATH (used by CI runners).
$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$src       = Join-Path $ScriptDir 'src\main.asm'
$buildDir  = Join-Path $ScriptDir 'build'
$obj       = Join-Path $buildDir 'main.obj'
$exe       = Join-Path $buildDir 'main.exe'

# Prefer the SASM-shipped toolchain; fall back to PATH.
$SasmNasm = 'C:\Program Files (x86)\SASM\NASM\nasm.exe'
$SasmGcc  = 'C:\Program Files (x86)\SASM\MinGW64\bin\gcc.exe'

function Find-Tool {
    param($name, $sasmPath)
    if ($sasmPath -and (Test-Path $sasmPath)) { return $sasmPath }
    $cmd = Get-Command $name -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Path }
    throw "Cannot locate tool: $name"
}

$nasm = Find-Tool 'nasm' $SasmNasm
$gcc  = Find-Tool 'gcc'  $SasmGcc

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
