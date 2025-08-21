#!/bin/bash

MODELS=("devstral" "gemma3:1b" "gemma3:4b" "gemma3:12b" "gemma3:27b")

OUTPUT_DIR="english_results_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUTPUT_DIR"

echo "Starting processing with preserved formatting..."
echo "Models: ${MODELS[*]}"

for PROMPT_FILE in prompts_p*.txt; do
    PROBLEM_NUM=$(echo "$PROMPT_FILE" | grep -o 'p[0-9]')
    PROBLEM_DIR="$OUTPUT_DIR/$PROBLEM_NUM"
    mkdir -p "$PROBLEM_DIR"
    
    echo "Processing: $PROBLEM_NUM"
    cp "$PROMPT_FILE" "$PROBLEM_DIR/"
    
    for MODEL in "${MODELS[@]}"; do
        CLEAN_MODEL=$(echo "$MODEL" | tr ':' '_')
        OUTPUT_FILE="$PROBLEM_DIR/${CLEAN_MODEL}.txt"
        
        echo "  Running model: $MODEL"
        
        # Clean output while preserving formatting
        {
            echo "PROMPT FILE: $PROMPT_FILE"
            echo "PROBLEM: $PROBLEM_NUM"
            echo "MODEL: $MODEL"
            echo "START TIME: $(date)"
            echo "========================================"
            echo ""
            
            ollama run "$MODEL" "$(cat "$PROMPT_FILE")"
            
            echo ""
            echo "========================================"
            echo "END TIME: $(date)"
        } | perl -pe '
            # Remove ANSI escape sequences
            s/\e\[[0-9;]*[a-zA-Z]//g;
            # Remove spinner characters
            s/[\x{2800}-\x{28FF}]//g;
            # Remove control characters except newlines and tabs
            s/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]//g;
        ' > "$OUTPUT_FILE" 2>&1
        
        echo "    Output saved: ${CLEAN_MODEL}.txt"
    done
done

echo "Processing completed successfully!"
echo "Results saved in: $OUTPUT_DIR"
