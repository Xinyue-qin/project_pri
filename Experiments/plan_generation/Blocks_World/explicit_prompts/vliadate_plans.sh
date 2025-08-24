#!/bin/bash

# Configuration
DOMAIN="D_blocksworld.pddl"
PROBLEMS_DIR="problems"
PLANS_DIR="final_plans"
VALIDATOR="validate"
RESULTS_FILE="validation_results.txt"
LOG_FILE="validation_log.txt"

# Clear previous results
echo "=== Fast Downward Plan Validation Results ===" > "$RESULTS_FILE"
echo "=== Validation Log ===" > "$LOG_FILE"
echo "Validation started at: $(date)" | tee -a "$LOG_FILE" "$RESULTS_FILE"

# Check if validator exists
if ! command -v $VALIDATOR &> /dev/null; then
    echo "ERROR: Validator '$VALIDATOR' not found in PATH!" | tee -a "$LOG_FILE" "$RESULTS_FILE"
    echo "Please install validate: sudo apt-get install validate" | tee -a "$LOG_FILE" "$RESULTS_FILE"
    exit 1
fi

# Check if files and directories exist
if [ ! -f "$DOMAIN" ]; then
    echo "ERROR: Domain file '$DOMAIN' not found!" | tee -a "$LOG_FILE" "$RESULTS_FILE"
    exit 1
fi

if [ ! -d "$PROBLEMS_DIR" ]; then
    echo "ERROR: Problems directory '$PROBLEMS_DIR' not found!" | tee -a "$LOG_FILE" "$RESULTS_FILE"
    exit 1
fi

if [ ! -d "$PLANS_DIR" ]; then
    echo "ERROR: Plans directory '$PLANS_DIR' not found!" | tee -a "$LOG_FILE" "$RESULTS_FILE"
    exit 1
fi

# Function to clean plan file
clean_plan_file() {
    local input_file="$1"
    local output_file="$2"
    
    # Extract valid PDDL actions
    grep -E "^(\([a-zA-Z-]+\s+[a-zA-Z0-9?]+\)|\([a-zA-Z-]+\s+[a-zA-Z0-9?]+\s+[a-zA-Z0-9?]+\))" "$input_file" 2>/dev/null | \
    tr '[:upper:]' '[:lower:]' | \
    sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | \
    grep -E "^(\(pickup|\(putdown|\(stack|\(unstack)" > "$output_file"
}

# Counters for results
total_plans=0
valid_plans=0
invalid_plans=0
empty_plans=0

echo "Starting validation process..." | tee -a "$LOG_FILE"
echo "" >> "$RESULTS_FILE"
echo "Problem File | Plan File | Status | Action Count" >> "$RESULTS_FILE"
echo "------------ | --------- | ------ | ------------" >> "$RESULTS_FILE"

# Process each problem file
for PROBLEM_FILE in "$PROBLEMS_DIR"/*.pddl; do
    if [ ! -f "$PROBLEM_FILE" ]; then
        continue
    fi
    
    PROBLEM_BASE=$(basename "$PROBLEM_FILE")
    # Extract problem number (e.g., P_1_blocks.pddl -> 1)
    PROBLEM_NUM=$(echo "$PROBLEM_BASE" | grep -oE 'P_([0-9])_' | grep -oE '[0-9]' | head -1)
    
    if [ -n "$PROBLEM_NUM" ]; then
        echo "Processing problem: $PROBLEM_BASE" | tee -a "$LOG_FILE"
        
        # Find all matching plan files (p1, p2, etc.)
        PLAN_FILES=()
        for PLAN_FILE in "$PLANS_DIR/p${PROBLEM_NUM}"*.txt; do
            if [ -f "$PLAN_FILE" ]; then
                PLAN_FILES+=("$PLAN_FILE")
            fi
        done
        
        if [ ${#PLAN_FILES[@]} -eq 0 ]; then
            echo "  No plan files found for p$PROBLEM_NUM" | tee -a "$LOG_FILE"
            continue
        fi
        
        for PLAN_FILE in "${PLAN_FILES[@]}"; do
            total_plans=$((total_plans + 1))
            PLAN_BASE=$(basename "$PLAN_FILE")
            
            echo "  Validating plan: $PLAN_BASE" | tee -a "$LOG_FILE"
            
            # Create temporary cleaned plan file
            TEMP_PLAN=$(mktemp)
            clean_plan_file "$PLAN_FILE" "$TEMP_PLAN"
            
            # Count actions in cleaned plan
            action_count=$(wc -l < "$TEMP_PLAN" 2>/dev/null | tr -d ' ' || echo "0")
            
            if [ "$action_count" -eq 0 ]; then
                empty_plans=$((empty_plans + 1))
                echo "  ✗ EMPTY: No valid actions found in $PLAN_BASE" | tee -a "$LOG_FILE"
                echo "$PROBLEM_BASE | $PLAN_BASE | EMPTY | 0" >> "$RESULTS_FILE"
                rm "$TEMP_PLAN"
                continue
            fi
            
            echo "  Cleaned plan ($action_count actions):" | tee -a "$LOG_FILE"
            cat "$TEMP_PLAN" | sed 's/^/    /' | tee -a "$LOG_FILE"
            
            # Execute validation
            echo "  Running: $VALIDATOR \"$DOMAIN\" \"$PROBLEM_FILE\" \"$TEMP_PLAN\"" | tee -a "$LOG_FILE"
            validation_output=$($VALIDATOR "$DOMAIN" "$PROBLEM_FILE" "$TEMP_PLAN" 2>&1)
            validation_result=$?
            
            if [ $validation_result -eq 0 ]; then
                valid_plans=$((valid_plans + 1))
                status="VALID"
                status_symbol="✓"
                echo "  $status_symbol VALID: $PLAN_BASE" | tee -a "$LOG_FILE"
            else
                invalid_plans=$((invalid_plans + 1))
                status="INVALID"
                status_symbol="✗"
                echo "  $status_symbol INVALID: $PLAN_BASE" | tee -a "$LOG_FILE"
                echo "  Validation output: $validation_output" | tee -a "$LOG_FILE"
            fi
            
            # Save to results file
            echo "$PROBLEM_BASE | $PLAN_BASE | $status | $action_count" >> "$RESULTS_FILE"
            
            rm "$TEMP_PLAN"
            echo "  ----------------------------------------" | tee -a "$LOG_FILE"
        done
    else
        echo "Skipping problem: $PROBLEM_BASE (could not extract problem number)" | tee -a "$LOG_FILE"
    fi
done

# Summary
echo "" | tee -a "$LOG_FILE" "$RESULTS_FILE"
echo "=== VALIDATION SUMMARY ===" | tee -a "$LOG_FILE" "$RESULTS_FILE"
echo "Total plans processed: $total_plans" | tee -a "$LOG_FILE" "$RESULTS_FILE"
echo "Valid plans: $valid_plans" | tee -a "$LOG_FILE" "$RESULTS_FILE"
echo "Invalid plans: $invalid_plans" | tee -a "$LOG_FILE" "$RESULTS_FILE"
echo "Empty plans: $empty_plans" | tee -a "$LOG_FILE" "$RESULTS_FILE"

# Calculate success rate safely
if [ $total_plans -gt 0 ]; then
    success_rate=$((valid_plans * 100 / total_plans))
else
    success_rate=0
fi
echo "Validation success rate: $success_rate%" | tee -a "$LOG_FILE" "$RESULTS_FILE"

echo "" | tee -a "$LOG_FILE" "$RESULTS_FILE"
echo "Validation completed at: $(date)" | tee -a "$LOG_FILE" "$RESULTS_FILE"
echo "Results saved to: $RESULTS_FILE" | tee -a "$LOG_FILE"
echo "Detailed log saved to: $LOG_FILE" | tee -a "$LOG_FILE"

echo ""
echo "=== VALIDATION COMPLETED ==="
echo "Check $RESULTS_FILE for summary results"
echo "Check $LOG_FILE for detailed validation log"
