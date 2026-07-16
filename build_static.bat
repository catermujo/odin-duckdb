@echo off

setlocal EnableDelayedExpansion

set "VENDOR_WINDOWS_ARCH=%VSCMD_ARG_TGT_ARCH%"
if not defined VENDOR_WINDOWS_ARCH set "VENDOR_WINDOWS_ARCH=%PROCESSOR_ARCHITECTURE%"
if /I "%VENDOR_WINDOWS_ARCH%"=="AMD64" set "VENDOR_WINDOWS_ARCH=x64"
if /I "%VENDOR_WINDOWS_ARCH%"=="ARM64" set "VENDOR_WINDOWS_ARCH=arm64"
if /I "%VENDOR_WINDOWS_ARCH%"=="X86" set "VENDOR_WINDOWS_ARCH=x64"

set "BASE=%~dp0"
set "SOURCE_DIR=%BASE%duckdb"
set "BUILD_DIR=%BASE%build_static_%VENDOR_WINDOWS_ARCH%"
set "OUTPUT_DIR=%BASE%windows_%VENDOR_WINDOWS_ARCH%"

if not exist "%SOURCE_DIR%" (
    git clone --revision 71f0c7a0bf10f60087b7bd42f524ae556c5a1967 --depth=1 --no-tags https://github.com/duckdb/duckdb.git "%SOURCE_DIR%" || exit /b 1
)

py -3 "%BASE%generate_bindings.py" || exit /b 1
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

echo Configuring static build...
cmake -A %VENDOR_WINDOWS_ARCH% -S "%SOURCE_DIR%" -B "%BUILD_DIR%" -DCMAKE_BUILD_TYPE=Release -DBUILD_SHELL=OFF -DBUILD_UNITTESTS=OFF -DENABLE_UNITTEST_CPP_TESTS=OFF -DBUILD_BENCHMARKS=OFF -DDISABLE_BUILTIN_EXTENSIONS=ON || exit /b 1

echo Building static project...
cmake --build "%BUILD_DIR%" --target duckdb_static duckdb_generated_extension_loader core_functions_extension --config Release || exit /b 1

lib.exe /OUT:"%BUILD_DIR%\duckdb_static_combined.lib" "%BUILD_DIR%\src\Release\duckdb_static.lib" "%BUILD_DIR%\extension\Release\duckdb_generated_extension_loader.lib" "%BUILD_DIR%\extension\core_functions\Release\core_functions_extension.lib" || exit /b 1
copy /y "%BUILD_DIR%\duckdb_static_combined.lib" "%OUTPUT_DIR%\duckdb.lib" >nul || exit /b 1

echo Static build completed successfully!
exit /b 0
