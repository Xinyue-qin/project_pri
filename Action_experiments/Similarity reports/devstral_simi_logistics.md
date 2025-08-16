# Action Similarity Analysis - Logistics Domain

## Similarity Formula
The similarity between the generated action and the gold standard is calculated as:

\[
\text{Similarity} = 1 - \frac{|A_{\text{pre}} \Delta A'_{\text{pre}}| + |A_{\text{ef}} \Delta A'_{\text{ef}}|}{|A_{\text{pre}} \cup A'_{\text{pre}}| + |A_{\text{ef}} \cup A'_{\text{ef}}|}
\]

Where:
- \( A_{\text{pre}}, A_{\text{ef}} \): Preconditions and effects in the gold action.
- \( A'_{\text{pre}}, A'_{\text{ef}} \): Preconditions and effects in the LLM-generated action.
- \( \Delta \): Symmetric difference between sets (elements in one set but not the other).
- \( \cup \): Union of sets.

---

## Action-by-Action Similarity Results

### 1. `load` Action
**Gold Preconditions:**  
`(and (at ?v ?l) (at ?o ?l))`  
**Gold Effects:**  
`(and (in ?o ?v) (not (at ?o ?l)))`  

**LLM Preconditions:**  
`(and (at ?o ?l) (at ?v ?l))`  
**LLM Effects:**  
`(and (not (at ?o ?l)) (in ?o ?v))`  

**Calculations:**  
- Precondition Symmetric Difference: None → 0 elements  
- Precondition Union: `(at ?v ?l), (at ?o ?l)` → 2 elements  
- Effect Symmetric Difference: None → 0 elements  
- Effect Union: `(in ?o ?v), (not (at ?o ?l))` → 2 elements  

**Similarity:**  
\[
1 - \frac{0 + 0}{2 + 2} = 1 - 0 = 1.0
\]

---

### 2. `unload` Action
**Gold Preconditions:**  
`(and (in ?o ?v) (at ?v ?l))`  
**Gold Effects:**  
`(and (at ?o ?l) (not (in ?o ?v)))`  

**LLM Preconditions:**  
`(and (in ?o ?v) (at ?v ?l))`  
**LLM Effects:**  
`(and (not (in ?o ?v)) (at ?o ?l))`  

**Calculations:**  
- Precondition Symmetric Difference: None → 0 elements  
- Precondition Union: `(in ?o ?v), (at ?v ?l)` → 2 elements  
- Effect Symmetric Difference: None → 0 elements  
- Effect Union: `(at ?o ?l), (not (in ?o ?v))` → 2 elements  

**Similarity:**  
\[
1 - \frac{0 + 0}{2 + 2} = 1 - 0 = 1.0
\]

---

### 3. `drive` Action
**Gold Preconditions:**  
`(and (at ?t ?from) (loc ?from ?c) (loc ?to ?c))`  
**Gold Effects:**  
`(and (at ?t ?to) (not (at ?t ?from)))`  

**LLM Preconditions:**  
`(and (loc ?from ?c) (loc ?to ?c) (at ?t ?from))`  
**LLM Effects:**  
`(and (not (at ?t ?from)) (at ?t ?to))`  

**Calculations:**  
- Precondition Symmetric Difference: None (order differs but sets are identical) → 0 elements  
- Precondition Union: `(at ?t ?from), (loc ?from ?c), (loc ?to ?c)` → 3 elements  
- Effect Symmetric Difference: None → 0 elements  
- Effect Union: `(at ?t ?to), (not (at ?t ?from))` → 2 elements  

**Similarity:**  
\[
1 - \frac{0 + 0}{3 + 2} = 1 - 0 = 1.0
\]

---

### 4. `fly` Action
**Gold Preconditions:**  
`(at ?p ?from)`  
**Gold Effects:**  
`(and (at ?p ?to) (not (at ?p ?from)))`  

**LLM Preconditions:**  
`(and (at ?a ?from) (loc ?from airport) (loc ?to airport))`  
**LLM Effects:**  
`(and (not (at ?a ?from)) (at ?a ?to))`  

**Calculations:**  
- Precondition Symmetric Difference: `(loc ?from airport), (loc ?to airport)` → 2 elements  
- Precondition Union: `(at ?a ?from), (loc ?from airport), (loc ?to airport)` → 3 elements  
- Effect Symmetric Difference: None → 0 elements  
- Effect Union: `(at ?a ?to), (not (at ?a ?from))` → 2 elements  

**Similarity:**  
\[
1 - \frac{2 + 0}{3 + 2} = 1 - \frac{2}{5} = 0.6
\]

---

## Summary of Similarity Scores
| Action    | Similarity Score |
|-----------|------------------|
| `load`    | 1.0              |
| `unload`  | 1.0              |
| `drive`   | 1.0              |
| `fly`     | 0.6              |

**Overall Average Similarity:**  
\[
\frac{1.0 + 1.0 + 1.0 + 0.6}{4} = 0.9
\]

## Key Observations
1. **Perfect Similarity for Core Actions**:  
   - `load`, `unload`, and `drive` achieve **1.0 similarity** as their preconditions/effects are logically identical to the gold standard (despite minor parameter naming differences like `?p` vs `?o`).  

2. **Partial Deviation in `fly`**:  
   - Lower similarity (0.6) due to **added preconditions** (`(loc ?from airport)` and `(loc ?to airport)`), which restrict the action to airports (a valid but stricter constraint).  
   - Effects remain identical.  

3. **Parameter Typing Differences**:  
   - The LLM uses `?a` for airplane (vs `?p` in gold) and `?o` for package (vs `?p` in gold), but this doesn't affect semantic similarity.  

**Recommendations**:  
- Maintain the stricter airport constraints in `fly` if intentional; otherwise, align with the gold standard's minimal preconditions.  
- Standardize parameter names (e.g., `?p` for packages/airplanes) for consistency.  
- The LLM-generated domain is **highly accurate** (90% average similarity) with only minor deviations.  