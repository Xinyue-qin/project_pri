#!/bin/bash

# Configuration Variables - PLEASE MODIFY THIS PATH!
DOMAIN_FILE="./D_blocksworld.pddl"        # Path to your PDDL domain file
OUTPUT_DIR="./generated_prompts"               # Output folder for generated prompts

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Check if domain file exists
if [ ! -f "$DOMAIN_FILE" ]; then
    echo "ERROR: Domain file '$DOMAIN_FILE' not found!"
    exit 1
fi

# Check if prompt files exist in current directory
if ! ls ./NL_*.txt 1> /dev/null 2>&1; then
    echo "ERROR: No prompt files (NL_*.txt) found in current directory!"
    exit 1
fi

# Read domain file content
DOMAIN_CONTENT=$(cat "$DOMAIN_FILE")

# Process each prompt file in current directory
for PROBLEM_FILE in ./NL_*.txt; do
    # Get base filename without path and extension (e.g., prompts_p1)
    BASE_NAME=$(basename "$PROBLEM_FILE" .txt)
    
    # Define output file path
    OUTPUT_FILE="$OUTPUT_DIR/${BASE_NAME}_prompt.txt"
    
    # Read problem description content
    PROBLEM_CONTENT=$(cat "$PROBLEM_FILE")
    
    # Define the template with proper newline handling for macOS
    TEMPLATE=$'Given a PDDL domain and a PDDL problem natural language description, come up with the plan associated with the problem. The domain describes the possible actions and their effects, while the problem description details the specific scenario to be solved. Do not generate anything but the correct plan.\n\nDomain PDDL:\n[PDDL domain]\n\nProblem description:\n[PDDL problem description]\n\nPlan:\n'
    
    # Replace placeholders in the template
    # First replace domain content (may contain multiple lines)
    PROMPT_CONTENT="${TEMPLATE/\[PDDL domain\]/$DOMAIN_CONTENT}"
    # Then replace problem content
    PROMPT_CONTENT="${PROMPT_CONTENT/\[PDDL problem description\]/$PROBLEM_CONTENT}"
    
    # Write content to output file
    echo "$PROMPT_CONTENT" > "$OUTPUT_FILE"
    
    echo "Generated: $OUTPUT_FILE"
done

echo "All prompt files have been generated in: $OUTPUT_DIR"
echo "Process completed successfully!"
