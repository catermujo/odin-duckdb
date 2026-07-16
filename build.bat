@echo off

setlocal EnableDelayedExpansion

set "VENDOR_WINDOWS_ARCH=%VSCMD_ARG_TGT_ARCH%"
if not defined VENDOR_WINDOWS_ARCH set "VENDOR_WINDOWS_ARCH=%PROCESSOR_ARCHITECTURE%"
if /I "%VENDOR_WINDOWS_ARCH%"=="AMD64" set "VENDOR_WINDOWS_ARCH=x64"
if /I "%VENDOR_WINDOWS_ARCH%"=="ARM64" set "VENDOR_WINDOWS_ARCH=arm64"
if /I "%VENDOR_WINDOWS_ARCH%"=="X86" set "VENDOR_WINDOWS_ARCH=x64"

set "BASE=%~dp0"
set "SOURCE_DIR=%BASE%duckdb"
set "BUILD_DIR=%BASE%build_shared_%VENDOR_WINDOWS_ARCH%"
set "OUTPUT_DIR=%BASE%windows_%VENDOR_WINDOWS_ARCH%"

if not exist "%SOURCE_DIR%" (
    git clone --revision 71f0c7a0bf10f60087b7bd42f524ae556c5a1967 --depth=1 --no-tags https://github.com/duckdb/duckdb.git "%SOURCE_DIR%" || exit /b 1
)

py -3 "%BASE%generate_bindings.py" || exit /b 1
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

echo Configuring shared build...
cmake -A %VENDOR_WINDOWS_ARCH% -S "%SOURCE_DIR%" -B "%BUILD_DIR%" -DCMAKE_BUILD_TYPE=Release -DBUILD_SHELL=OFF -DBUILD_UNITTESTS=OFF -DENABLE_UNITTEST_CPP_TESTS=OFF -DBUILD_BENCHMARKS=OFF -DDISABLE_BUILTIN_EXTENSIONS=ON || exit /b 1

echo Building shared project...
cmake --build "%BUILD_DIR%" --target duckdb --config Release || exit /b 1

copy /y "%BUILD_DIR%\src\Release\duckdb.lib" "%OUTPUT_DIR%\duckdb_shared.lib" >nul || exit /b 1
copy /y "%BUILD_DIR%\src\Release\duckdb.dll" "%OUTPUT_DIR%\duckdb.dll" >nul || exit /b 1

echo Shared build completed successfully!
exit /b 0
