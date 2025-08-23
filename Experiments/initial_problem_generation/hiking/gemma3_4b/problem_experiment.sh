#!/bin/bash

# Define problem files and output file prefixes
DOMAIN="d_hiking.pddl"
PROBLEMS=("p1_by_LLMs.pddl" "p2_by_LLMs.pddl" "p3_by_LLMs.pddl" "p4_by_LLMs.pddl" "p5_by_LLMs.pddl")

# Loop through all problems
for i in "${!PROBLEMS[@]}"; do
    PROBLEM="${PROBLEMS[$i]}"
    LOG_FILE="fd_output_p$((i+1)).log"
    PLAN_FILE="plan_p$((i+1)).txt"
    
    echo "Running problem: $PROBLEM"
    echo "Log file: $LOG_FILE"
    echo "Plan file: $PLAN_FILE"
    echo "----------------------------------------"
    
    # Run fastdownward and save log and plan
    fast-downward.py $DOMAIN $PROBLEM --search "astar(lmcut())" > $LOG_FILE 2>&1
    
    # If plan file is generated (usually sas_plan), rename and save it
    if [ -f "sas_plan" ]; then
        mv "sas_plan" $PLAN_FILE
        echo "Plan saved to: $PLAN_FILE"
    else
        echo "No plan file found, problem may be unsolvable or an error occurred"
    fi
    
    echo "Completed problem: $PROBLEM"
    echo "========================================"
done

echo "All problems completed!"
