# Cd into the computer file address that have domain.pddl and problem.pddl 
## search using `astar(lmcut())` —  A with LM-Cut (Optimal but Slow)* algorithm — A* search
`/Users/qinxinyue/Desktop/CP5106/downward/fast-downward.py domain.pddl problem.pddl --search "astar(lmcut())"`

`/Users/qinxinyue/Desktop/CP5106/downward/fast-downward.py domain.pddl problem.pddl --search "lazy_greedy([ff()])"`


# VAL tools
validate domain.pddl problem.pddl sas_plan

| Command | Purpose |
|-----|-----|
| validate domain.pddl problem.pddl   | Check PDDL syntax   |
| validate -v domain.pddl problem.pddl plan.txt   | Verbose debugging   |

* Verify success: Command — echo $? 
    * Returns 0 → Validation passed
    * Returns 1 → Validation failed (but errors may be hidden)
      
# Enhanced Report (Human-Readable)
/Users/qinxinyue/Desktop/CP5106/downward/fast-downward.py \
    domain.pddl problem.pddl \
    --search "lazy_greedy([ff()])" \
    > full_report.txt 2>&1

# Extract key metrics
grep -E "Plan length|Expanded |Time" full_report.txt > summary.txt




# output file renaming
/Users/qinxinyue/Desktop/CP5106/downward/fast-downward.py domain.pddl problem.pddl --search "lazy_greedy([ff()])" > ${OUTPUT_DIR}/run_${TIMESTAMP}.log 
# Move the automatically generated plan
[ -f sas_plan ] && mv sas_plan ${OUTPUT_DIR}/plan_${TIMESTAMP}.txt


/Users/qinxinyue/Desktop/CP5106/downward/fast-downward.py \
    domain.pddl problem.pddl \
    --search "astar(lmcut())" \
    > ${OUTPUT_DIR}/run_${TIMESTAMP}.log & [ -f sas_plan ] && mv sas_plan ${OUTPUT_DIR}/plan_${TIMESTAMP}.txt


/Users/qinxinyue/Desktop/CP5106/downward/fast-downward.py domain.pddl problem.pddl --search "astar(lmcut())" > ${OUTPUT_DIR}/run_${TIMESTAMP}.log 
