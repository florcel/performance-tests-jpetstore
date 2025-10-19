@echo off
setlocal
if "%JMETER_HOME%"=="" set JMETER_HOME=C:\apache-jmeter-5.6.3
set TEST_PLAN=test-plans\jpetstore_jmeter_testplan.jmx
set RESULTS=results\results.jtl
"%JMETER_HOME%\bin\jmeter" -n -t "%TEST_PLAN%" -l "%RESULTS%"
"%JMETER_HOME%\bin\jmeter" -g "%RESULTS%" -o results\report
start "" results\report\index.html
endlocal
