# PDDL Domain Similarity Analysis
## Logistics Domain Final Scores

### Action-Level Similarity
| Action   | Score | Key Issues                                                                 |
|----------|-------|----------------------------------------------------------------------------|
| load     | 0.33  | Missing vehicle location check, no clear effects                           |
| unload   | 0.33  | Missing vehicle location precondition, no effect differentiation           |
| drive    | 0.80  | Best matching action but missing `(not (at ?t ?from))` effect              |
| fly      | 0.33  | Extra location predicates, missing critical effect                         |

Overall: 0.45

### Domain-Level Issues
1. **Structural Problems**:
   - ❌ Missing domain definition
   - ❌ No type declarations
   - ❌ No requirements specification

2. **Pattern Errors**:
   - All actions miss parameter typing
   - Most effects improperly implemented

```mermaid
pie
    title Similarity Distribution
    "Structural Compliance" : 15
    "Action Logic" : 45
    "Parameter Typing" : 25
    "Effect Completeness" : 15