# PDDL Domain Similarity Analysis Report
## Logistics Domain: Gold Standard vs LLM Generated

### 1. Structural Comparison
| Component          | Gold Standard | LLM Generated | Status       |
|--------------------|---------------|---------------|--------------|
| Requirements       | `:strips :typing` | `:strips :typing` | ✅ Exact  |
| Types              | 6 types       | 6 types (+ordering) | ✅ Equivalent |
| Predicates         | 3 predicates | 4 predicates (+airport) | ⚠️ Modified |

### 2. Action Similarity Scores

#### 📦 load Action
**Similarity Score**: 0.92  
**Changes**:
- 🔄 `?o - object` → `?p - package` (specialization)
- ✅ Preconditions/effects logically identical
- 🔄 Effect order changed (no semantic impact)

---

#### 📤 unload Action  
**Similarity Score**: 0.92  
**Changes**:
- 🔄 `?o - object` → `?p - package`
- ✅ Perfect logical match otherwise

---

#### 🚛 drive Action
**Similarity Score**: 0.65  
**Key Changes**:
- 🔄 `?t - truck` → `?v - vehicle` (generalization)
- ➕ Added `(= ?from ?c) (= ?to ?c)` (redundant)
- ➖ Removed implicit city-location binding

---

#### ✈️ fly Action  
**Similarity Score**: 0.70  
**Key Changes**:
- 🔄 `?p - airplane` → `?v - vehicle` (generalization)
- ➕ Added `(airport ?from)` and `(airport ?to)`
- ➖ Removed airport type constraint

### 3. Composite Metrics
| Metric                | Score |
|-----------------------|-------|
| Average Action Score  | 0.80  |
| Structure Similarity  | 0.95  |
| Semantic Accuracy     | 0.75  |

```mermaid
pie
    title Change Distribution
    "Parameter Specialization" : 30
    "Type Generalization" : 40
    "Added Constraints" : 20
    "Removed Constraints" : 10


Final Assessment
Overall Similarity: 0.80
Strengths:

✅ Core loading/unloading preserved

✅ Added explicit airport validation

Weaknesses:

⚠️ Over-generalized vehicle types

⚠️ Redundant drive constraints

Verification Checklist:

Validate vehicle generalization

Test airport predicate usage

Verify drive action constraints