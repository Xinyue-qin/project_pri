# PDDL Domain Similarity Analysis
## Delivery Domain: Gold Standard vs LLM Generated

### 1. Domain Structure Comparison
| Component          | Gold Standard | LLM Generated | Status |
|--------------------|---------------|---------------|--------|
| Domain Definition  | ✅ Present    | ✅ Present    | Exact  |
| Requirements       | `:strips :typing` | `:strips :typing` | Exact |
| Types             | ✅ Defined    | ✅ Defined    | Exact  |
| Predicates        | ✅ 7 defined  | ✅ 7 defined  | Exact  |

*Note*: Perfect structural match (1.00 similarity)

### 2. Action Similarity Scores

#### 📌 pick-up Action
**Similarity Score**: 0.83  
**Preconditions**: ✅ Exact match  
**Effects**: 
- ✅ Preserves `(has ?a ?p)` and `(not (in ?p ?l))`
- ➕ Adds `(not (available ?a))`  
**Impact**: Changes agent availability semantics

---

#### 🚛 move Action  
**Similarity Score**: 0.83  
**Preconditions**: ✅ Exact match  
**Effects**:
- ✅ Preserves core movement effects
- ➕ Adds `(not (available ?a))`  
**Impact**: Consistent with pick-up's availability change

---

#### 📭 drop-off Action
**Similarity Score**: 0.63  
**Preconditions**: 
- ➕ Adds `(available ?a)` check  
**Effects**:
- ✅ Keeps `(delivered ?p)` and `(not (has ?a ?p))`
- ➖ Missing `(in ?p ?l)` 
- ➕ Adds `(not (available ?a))`  
**Impact**: Most significant deviation


Composite Scores
Action	Similarity Score	Key Changes
pick-up	0.83	Added agent unavailability
move	0.83	Added agent unavailability
drop-off	0.63	Added unavailability, missing package location
Overall Domain Similarity: 0.76
Interpretation: High similarity with consistent deviation in agent availability management.


### 3. Composite Metrics

| Metric                | Score |
|-----------------------|-------|
| Average Action Similarity | 0.76 |
| Structure Similarity  | 1.00  |
| Effect Consistency    | 0.70  |

```mermaid
pie
    title Similarity Distribution
    "Perfect Matches" : 60
    "Added Effects" : 35
    "Missing Effects" : 5


