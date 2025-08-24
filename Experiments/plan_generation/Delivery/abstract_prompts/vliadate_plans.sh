#!/bin/bash

# Configuration
DOMAIN="d_delivery.pddl"
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

# Function to clean plan file for Delivery domain
clean_plan_file() {
    local input_file="$1"
    local output_file="$2"
    
    # Extract any valid PDDL actions (lines with parentheses)
    # For Delivery domain, common actions might be: drive, load, unload, etc.
    grep -E "\([a-zA-Z-]+[[:space:]]+[a-zA-Z0-9?_-]+\)" "$input_file" 2>/dev/null | \
    # Also match actions with multiple parameters
    grep -E "\([a-zA-Z-]+[[:space:]]+[a-zA-Z0-9?_-]+[[:space:]]+[a-zA-Z0-9?_-]+\)" "$input_file" 2>/dev/null | \
    # Remove duplicates and sort
    sort -u | \
    # Convert to lowercase
    tr '[:upper:]' '[:lower:]' | \
    # Clean up formatting
    sed 's/^[[:space:]]*//;s/[[:space:]]*$//' > "$output_file"
    
    # If no actions found with the first pattern, try a more general approach
    if [ ! -s "$output_file" ]; then
        # Extract any line that looks like a PDDL action
        grep -E "\([a-zA-Z]" "$input_file" 2>/dev/null | \
        grep -v "define" | grep -v "problem" | grep -v "domain" | \
        tr '[:upper:]' '[:lower:]' | \
        sed 's/^[[:space:]]*//;s/[[:space:]]*$//' > "$output_file"
    fi
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

# Process each problem file (p1.pddl, p2.pddl, etc.)
for PROBLEM_FILE in "$PROBLEMS_DIR"/p*.pddl; do
    if [ ! -f "$PROBLEM_FILE" ]; then
        continue
    fi
    
    PROBLEM_BASE=$(basename "$PROBLEM_FILE")
    # Extract problem number (e.g., p1.pddl -> 1)
    PROBLEM_NUM=$(echo "$PROBLEM_BASE" | grep -oE 'p([0-9]+)' | grep -oE '[0-9]+')
    
    if [ -n "$PROBLEM_NUM" ]; then
        echo "Processing problem: $PROBLEM_BASE" | tee -a "$LOG_FILE"
        
        # Find all matching plan files (p1_*, p2_*, etc.)
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
            
            echo "  Raw plan content (first 10 lines):" | tee -a "$LOG_FILE"
            head -10 "$PLAN_FILE" | sed 's/^/    /' | tee -a "$LOG_FILE"
            
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
                echo "  Validation output: Plan valid" | tee -a "$LOG_FILE"
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
