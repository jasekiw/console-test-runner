:: takes argument 1 and 2 as the programs to send test scripts to
:: all tests should be put in the tests directory
@echo off 
:: enable the ability to use !varname! to use dynamic vairables
@setlocal enableextensions enabledelayedexpansion

if "%~1" == "?" (
	call :help
	exit /b
)

if "%~1" == "help" (
	call :help
	exit /b
)

:: check the arguments for the program locations. If none provided it will default to L1.exe and 
if "%~1" == "" (
	set prgm1=L1.exe
) else (
	set prgm1=%1
)

if "%~2" == "" (
	set prgm2=L1Sol.exe
) else (
	set prgm2=%2
)
if "%~3" == "" (
	set testDir=tests
) else (
	set testDir=%3
)

:: check to make sure the input is valid
if not exist %prgm1% (
	echo %prgm1% does not exist! please enter a program that exits
	exit /b
)
:: check to make sure the input is valid
if not exist %prgm2% (
	echo %prgm2% does not exist! please enter a program that exits
	exit /b
)

:: get filenames of each of the input programs and make the output directories off of their names
call :sub %prgm1%
set prgm1OutputDir=TestOutputs\!filename!Output
call :sub %prgm2%
set prgm2OutputDir=TestOutputs\!filename!Output

:: cleans the output directories
if exist TestOutputs rmdir TestOutputs /s /q
:: create the output directories
mkdir %prgm1OutputDir%
mkdir %prgm2OutputDir%


:: loop through the test files and run them through the program
for /r %%i in (%testDir%\*) do (
	call :sub %%i
	%prgm1% < %testDir%\!filename! > %prgm1OutputDir%\!filename!
	%prgm2% < %testDir%\!filename! > %prgm2OutputDir%\!filename!
)

echo Outputs generated in %prgm1OutputDir% and %prgm2OutputDir%
:: main exit point
exit /b


:: FUNCTION
:: filename = #%~nx1
:: sets the filename variable to the filename of the given input
:sub
:: %~nx1 gets the filename of a full path given as an argument
set filename=%~nx1
exit /b
:: END FUNCTION


:: FUNCTION
:: prints out the manual for the program
:help
echo     Runs tests through the given programs. If not programs are given, L1.exe and L1Sol.exe will be used
echo.
echo     RUNTESTS [Program1] [Program2] [testDir]
echo.
echo     Program1    The first program to run tests on.
echo     Program2    The second program to run tests on.
echo     testDir     The folder to find the tests. do not add taling '\'
echo.
echo     All tests should reside under a folder called tests that is in the same directory as this batch file
echo     Output folder names are based on the input program names with Output added at the end. You will find outputs under TestOutputs\*
exit /b
:: END FUNCTION