GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' 

progress() {
    local progress=$1
    local total=$2
    local percent=$(( 100 * progress / total ))
    printf "\rProgress: ${YELLOW}[%-50s]${NC} %d%%" $(printf "#%.0s" $(seq 1 $(( percent / 2 )))) $percent
}

run_test() {
    local case=$1
    local expected_streak=$2
    local expected_lives=$3
    local total_cases=$4
    local current_case=$5

    python3 main.py "input/Enregistrement.csv" "output/result_case_$case.csv"
    local results=$(tail -n 1 output/result_case_$case.csv)
    IFS=',' read -r -a array <<< "$results"
    local streak=${array[6]}
    local lives=${array[7]}

    if [ "$streak" -eq "$expected_streak" ] && [ "$lives" -eq "$expected_lives" ]; then
        echo -e "\nTest case $case ${GREEN}réussi!${NC}"
    else
        echo -e "\nTest case $case ${RED}échoué.${NC}"
        echo "Série attendue: $expected_streak, vies attendues: $expected_lives"
        echo "Série obtenue: $streak, vies obtenues: $lives"
    fi

    progress $current_case $total_cases
}

echo "Running dynamic tests"

total_cases=5
current_case=0

run_test 1 1 2 $total_cases $((++current_case))
run_test 2 1 2 $total_cases $((++current_case))
run_test 3 0 1 $total_cases $((++current_case))
run_test 4 5 2 $total_cases $((++current_case))
run_test 5 0 2 $total_cases $((++current_case))

echo -e "\nTests terminés."
