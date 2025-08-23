#!/bin/bash

# =============================================================================
# COMPLETE PROCESSING SCRIPT
# Handles: model execution, output cleaning, and file renaming
# =============================================================================

# Configuration
PROMPT_DIR="./generated_prompts"
OUTPUT_BASE_DIR="./model_outputs"
MODELS=("devstral" "gemma3:1b" "gemma3:4b" "gemma3:12b" "gemma3:27b")
TIMEOUT_SECONDS=120
RENAME_OUTPUT_DIR="./final_plans"  # Optional: separate directory for renamed files

# =============================================================================
# INITIALIZATION
# =============================================================================

# Create output directories
mkdir -p "$OUTPUT_BASE_DIR"
mkdir -p "$RENAME_OUTPUT_DIR"

# Check if prompt directory exists
if [ ! -d "$PROMPT_DIR" ]; then
    echo "ERROR: Prompt directory '$PROMPT_DIR' not found!"
    exit 1
fi

# Check if prompt files exist
if ! ls "$PROMPT_DIR"/NL_p*_prompt.txt 1> /dev/null 2>&1; then
    echo "ERROR: No NL prompt files found in '$PROMPT_DIR'!"
    echo "Available files:"
    ls -la "$PROMPT_DIR/" 2>/dev/null || echo "Directory is empty"
    exit 1
fi

# Check if Ollama is installed
if ! command -v ollama &> /dev/null; then
    echo "ERROR: Ollama is not installed!"
    exit 1
fi

echo "=============================================="
echo "STARTING COMPLETE PROCESSING"
echo "=============================================="
echo "Prompt directory: $PROMPT_DIR"
echo "Output directory: $OUTPUT_BASE_DIR"
echo "Final plans directory: $RENAME_OUTPUT_DIR"
echo "Models: ${MODELS[*]}"
echo "Timeout: ${TIMEOUT_SECONDS} seconds"
echo "=============================================="

# =============================================================================
# FUNCTIONS
# =============================================================================

# Enhanced cleaning function
clean_output() {
    sed '
        # Remove ANSI escape sequences
        s/\x1B\[[0-9;]*[mK]//g;
        s/\x1B\[[?0-9;]*[hl]//g;
        s/\x1B\[[0-9;]*[JK]//g;
        s/\x1B\[[0-9;]*[ABCDEFG]//g;
        
        # Remove control characters
        s/[[:cntrl:]]//g;
        s/\r//g;
        
        # Clean up content
        /^$/d;
        s/^[[:space:]]*//;
        s/[[:space:]]*$//;
        s/\x1B//g;
        
        # Remove progress indicators
        s/^[⠙⠹⠸⠼⠴⠦⠧⠇⠏⠋]*//g;
        s/\[[0-9]*G//g;
        s/\[[0-9]*[hl]//g;
    '
}

# Function to run model with timeout
run_model_with_timeout() {
    local model="$1"
    local prompt_content="$2"
    local output_file="$3"
    
    # Run in background
    (
        ollama run "$model" "$prompt_content" > "$output_file" 2>&1
    ) &
    
    local pid=$!
    local waited=0
    
    # Wait with progress monitoring
    while kill -0 $pid 2>/dev/null && [ $waited -lt $TIMEOUT_SECONDS ]; do
        sleep 5
        waited=$((waited + 5))
        
        if [ $((waited % 30)) -eq 0 ]; then
            echo "    ⏱️  Still processing... (${waited}s)"
        fi
    done
    
    # Handle timeout
    if kill -0 $pid 2>/dev/null; then
        echo "    ⚠️  Timeout after ${TIMEOUT_SECONDS}s, terminating..."
        kill $pid 2>/dev/null
        wait $pid 2>/dev/null
        echo "Process terminated due to timeout after ${TIMEOUT_SECONDS} seconds" >> "$output_file"
        return 124
    else
        wait $pid
        return $?
    fi
}

# Function to process a single model with a single prompt
process_single_model() {
    local model="$1"
    local prompt_file="$2"
    
    local model_clean=$(echo "$model" | sed 's/:/_/g; s/\//_/g')
    local base_name=$(basename "$prompt_file" .txt)
    local output_dir="$OUTPUT_BASE_DIR/$model_clean"
    
    mkdir -p "$output_dir"
    
    local raw_file="$output_dir/${base_name}_raw.txt"
    local clean_file="$output_dir/${base_name}_clean.txt"
    local log_file="$output_dir/processing_log.txt"
    
    echo "  🚀 Processing: $base_name with $model"
    
    # Read prompt content
    local prompt_content=$(cat "$prompt_file")
    
    # Run model with timeout
    local start_time=$(date +%s)
    run_model_with_timeout "$model" "$prompt_content" "$raw_file"
    local exit_code=$?
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    # Clean the output
    if [ -f "$raw_file" ]; then
        cat "$raw_file" | clean_output > "$clean_file"
    else
        echo "No output generated" > "$clean_file"
    fi
    
    # Log results
    {
        echo "[$(date)] Processed $base_name with $model"
        echo "  Duration: ${duration}s"
        echo "  Exit code: $exit_code"
        echo "  Raw lines: $(wc -l < "$raw_file" 2>/dev/null || echo 0)"
        echo "  Clean lines: $(wc -l < "$clean_file" 2>/dev/null || echo 0)"
        case $exit_code in
            124) echo "  STATUS: TIMEOUT" ;;
            0)   echo "  STATUS: SUCCESS" ;;
            *)   echo "  STATUS: ERROR" ;;
        esac
        echo "----------------------------------------"
    } >> "$log_file" 2>/dev/null || {
        # Create log file if it doesn't exist
        echo "[$(date)] Created log file" > "$log_file"
        cat <<EOF >> "$log_file"
[$(date)] Processed $base_name with $model
  Duration: ${duration}s
  Exit code: $exit_code
  Raw lines: $(wc -l < "$raw_file" 2>/dev/null || echo 0)
  Clean lines: $(wc -l < "$clean_file" 2>/dev/null || echo 0)
  STATUS: $(case $exit_code in 124) echo "TIMEOUT" ;; 0) echo "SUCCESS" ;; *) echo "ERROR" ;; esac)
----------------------------------------
EOF
    }
    
    # Print summary
    case $exit_code in
        124)
            echo "    ⚠️  TIMEOUT after ${duration}s"
            ;;
        0)
            echo "    ✅ SUCCESS in ${duration}s ($(wc -l < "$clean_file") lines)"
            ;;
        *)
            echo "    ❌ ERROR in ${duration}s (code: $exit_code)"
            ;;
    esac
    
    return $exit_code
}

# Function to rename clean files to pX_plan_abs format
rename_to_plan_abs() {
    local source_dir="$1"
    local target_dir="$2"
    
    find "$source_dir" -name "*_clean.txt" | while read clean_file; do
        if [ -f "$clean_file" ]; then
            local base_name=$(basename "$clean_file" _clean.txt)
            local dir_name=$(basename "$(dirname "$clean_file")")
            
            # Extract problem number (e.g., from NL_p1_prompt -> 1)
            local problem_num=$(echo "$base_name" | grep -o 'p[0-9]\+' | grep -o '[0-9]\+' ||
                               echo "$base_name" | grep -o 'NL_p[0-9]\+' | grep -o '[0-9]\+')
            
            if [ -n "$problem_num" ]; then
                # Simplify model name (remove size suffixes)
                local model_simple=$(echo "$dir_name" | sed '
                    s/gemma3_[0-9]\+[a-zA-Z]*/gemma3/;
                    s/devstral/devstral/;
                    s/llama.*/llama/;
                ')
                
                local new_filename="p${problem_num}_plan_abs_${model_simple}.txt"
                local target_file="$target_dir/$new_filename"
                
                # Copy file to target directory
                cp "$clean_file" "$target_file"
                
                echo "    📝 Renamed: $dir_name/$(basename $clean_file) -> $new_filename"
            fi
        fi
    done
}

# =============================================================================
# MAIN PROCESSING
# =============================================================================

# Process each prompt file with each model
echo "📂 PROCESSING PROMPT FILES"
echo "=============================================="

for PROMPT_FILE in "$PROMPT_DIR"/NL_p*_prompt.txt; do
    if [ -f "$PROMPT_FILE" ]; then
        BASE_NAME=$(basename "$PROMPT_FILE" .txt)
        echo "🔷 Processing: $BASE_NAME"
        echo "----------------------------------------------"
        
        for MODEL in "${MODELS[@]}"; do
            process_single_model "$MODEL" "$PROMPT_FILE"
            
            # Add delay between model runs
            sleep 2
        done
        
        echo "----------------------------------------------"
    fi
done

# =============================================================================
# FILE RENAMING
# =============================================================================

echo ""
echo "📝 RENAMING FILES TO pX_plan_abs FORMAT"
echo "=============================================="

# Rename files in original directories
echo "Renaming files in original directories..."
for MODEL in "${MODELS[@]}"; do
    MODEL_CLEAN=$(echo "$MODEL" | sed 's/:/_/g; s/\//_/g')
    MODEL_DIR="$OUTPUT_BASE_DIR/$MODEL_CLEAN"
    
    if [ -d "$MODEL_DIR" ]; then
        echo "Processing: $MODEL_CLEAN"
        rename_to_plan_abs "$MODEL_DIR" "$MODEL_DIR"
    fi
done

# Also copy renamed files to separate directory
echo ""
echo "Copying renamed files to: $RENAME_OUTPUT_DIR"
rename_to_plan_abs "$OUTPUT_BASE_DIR" "$RENAME_OUTPUT_DIR"

# =============================================================================
# FINAL SUMMARY
# =============================================================================

echo ""
echo "=============================================="
echo "🎉 PROCESSING COMPLETED!"
echo "=============================================="

# Create summary report
SUMMARY_FILE="$OUTPUT_BASE_DIR/processing_summary.txt"
{
    echo "COMPLETE PROCESSING SUMMARY"
    echo "==========================="
    echo "Date: $(date)"
    echo "Prompt directory: $PROMPT_DIR"
    echo "Output directory: $OUTPUT_BASE_DIR"
    echo "Final plans directory: $RENAME_OUTPUT_DIR"
    echo "Models processed: ${MODELS[*]}"
    echo ""
    echo "FILES GENERATED:"
    echo "---------------"
    
    for MODEL in "${MODELS[@]}"; do
        MODEL_CLEAN=$(echo "$MODEL" | sed 's/:/_/g; s/\//_/g')
        MODEL_DIR="$OUTPUT_BASE_DIR/$MODEL_CLEAN"
        
        if [ -d "$MODEL_DIR" ]; then
            COUNT=$(find "$MODEL_DIR" -name "p*_plan_abs*.txt" | wc -l)
            echo "  $MODEL_CLEAN: $COUNT plan files"
        fi
    done
    
    echo ""
    echo "TOTAL PLAN FILES: $(find "$OUTPUT_BASE_DIR" -name "p*_plan_abs*.txt" | wc -l)"
    echo "COPIED TO FINAL DIR: $(find "$RENAME_OUTPUT_DIR" -name "p*_plan_abs*.txt" | wc -l)"
    echo ""
    echo "DIRECTORY STRUCTURE:"
    echo "-------------------"
    find "$OUTPUT_BASE_DIR" -type d | sort | head -10 | sed 's/^/  /'
    echo ""
    echo "FINAL PLAN FILES:"
    echo "----------------"
    find "$RENAME_OUTPUT_DIR" -name "p*_plan_abs*.txt" | sort | head -10 | sed 's/^/  /'
    
} > "$SUMMARY_FILE"

echo "📊 Summary report: $SUMMARY_FILE"
echo ""
echo "📍 Final plan files are available in:"
echo "   - Original directories: $OUTPUT_BASE_DIR/*/p*_plan_abs*.txt"
echo "   - Consolidated directory: $RENAME_OUTPUT_DIR/p*_plan_abs*.txt"
echo ""
echo "To view results:"
echo "  ls -la $RENAME_OUTPUT_DIR/"
echo "  head -n 5 $RENAME_OUTPUT_DIR/p1_plan_abs_*.txt"
