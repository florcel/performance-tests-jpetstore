#!/bin/bash
set -e
JMETER_HOME=${JMETER_HOME:-"/opt/apache-jmeter-5.6.3"}
TEST_PLAN="test-plans/jpetstore_jmeter_testplan.jmx"
RESULTS="results/results.jtl"
"$JMETER_HOME/bin/jmeter" -n -t "$TEST_PLAN" -l "$RESULTS"
"$JMETER_HOME/bin/jmeter" -g "$RESULTS" -o results/report
echo "Abrir: results/report/index.html"
