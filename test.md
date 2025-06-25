# Prompt and result for the action generation (put-down) for the BLOCKS domain
```diff
- Task Signature = [input: NL instruction, PDDL domain predicates; output: PDDL action]
```

**Prompt**:
Given a description of an action in some domain, convert it to Planning Domain Definition Language (PDDL) action. You may only use the allowed predicates for each action. 

Allowed Predicates: - (handempty) : the hand is empty. - (holding ?x - block): block x is held. - (clear ?x - block): block x is clear. - (on ?x - block ?y - block) : block x is on block y. - (ontable ?x - block): block x is on the table. 

Input: The action, “put-down” will have the hand put down a block. 

PDDL Action:

**Result of devstral**: (ollama run devstral)

Sure! Here's how you can define the "put-down" action in PDDL using the 
allowed predicates:

```pddl
(:action put-down
    :parameters (?x - block)
    :precondition (holding ?x)
    :effect (and
              (not (holding ?x))
              (handempty)
              (ontable ?x)
            )
)
```

Explanation:
- Parameters: The action takes one parameter, `?x`, which represents a 
block.
- Precondition: The hand must be holding the block (`(holding ?x)`).
- Effect: After performing the action, the block is no longer being held 
by the hand (`(not (holding ?x))`), the hand becomes empty 
(`(handempty)`), and the block is now on the table (`(ontable ?x)`).


**Result of Gemma3:**

... Sure! Here's how you can define the "put-down" action in PDDL using the allo
... wed predicates:
```pddl
(action put-down)
  :parameters (block ?x)   //syntax problem?
  :precondition (and (handempty) (holding ?x - block)) 
  :effect (and (handempty) (not (holding ?x - block)) (ontable ?x - 
block))
```
(gemma3)

**Result of gemma3:1b (1B parameter model): ollama run gemma3:1b-it-qat**
```pddl
put-down(hand, block)
```

**Result of gemma3:4b (4B parameter model): ollama run gemma3:4b-it-qat**
```pddl
(action put-down
  :parameters (?x - block)
  :precondition (and (handempty) (holding ?x - block))
  :effect (and (handempty) (not (holding ?x - block)) (ontable ?x - block))
```

**Result of gemma3:12b (12B parameter model): ollama run gemma3:12b-it-qat**
```pddl
(:action put-down
  :parameters (?x - block)
  :precondition (and (holding ?x))
  :effect (and (handempty) (clear ?x) (ontable ?x) (not (holding ?x))))
```

**Result of Gemma3:27b-it-qat (27B parameter model):** (ollama run gemma3:27b-it-qat)
```pddl
(action put-down
  :parameters (?x - block)
  :precondition (holding ?x)
  :effect (and (handempty) (ontable ?x) (not (holding ?x)))
)
```
---

# Problem generation in blocksworld domain (init=holding one)
```diff
- Task Signature = [input: NL instruction, PDDL domain; output: PDDL problem]
```
**Prompt**

Provide me with the complete, valid problem PDDL file that describes the following planning problem directly without further explanations or texts.
The domain for the planning problem is:

(define (domain blocksworld) (:requirements :strips) (:predicates (arm-empty) (clear ?x) (holding ?x) (on ?x ?y) (on-table ?x)) (:action pickup :parameters (?ob) :precondition (and (clear ?ob) (on-table ?ob) (arm-empty)) :effect (and (holding ?ob) (not (clear ?ob)) (not (ontable ?ob)) (not (arm-empty))) ) (:action putdown :parameters (?ob) :precondition (holding ?ob) :effect (and (clear ?ob) (arm-empty) (on-table ?ob) (not (holding ?ob))) ) (:action stack :parameters (?ob ?underob) :precondition (and (clear ?underob) (holding ?ob)) :effect (and (arm-empty) (clear ?ob) (on ?ob ?underob) (not (clear ?underob)) (not (holding ?ob))) ) (:action unstack :parameters (?ob ?underob) :precondition (and (on ?ob ?underob) (clear ?ob)
(arm-empty)) :effect (and (holding ?ob) (clear ?underob) (not (on ?ob ?underob)) (not (clear ?ob)) (not (arm-empty))) ))

Planning problem:

You have 17 blocks. You are holding b1. b2 is clear. b2 is on the table. b3 is clear. b3 is on the table. b4 is clear. b4 is on the table. b5 is clear. b5 is on the table. b6 is clear. b6 is on the table. b7 is clear. b7 is on the table. b8 is clear. b8 is on the table. b9 is clear. b9 is on
the table. b10 is clear. b10 is on the table. b11 is clear. b11 is on the table. b12 is clear. b12 is on the table. b13 is clear. b13 is on the table. b14 is clear. b14 is on the table. b15 is clear. b15 is on the table. b16 is clear. b16 is on the table. b17 is clear. b17 is on the table.
Your goal is to stack the blocks into a towers of heights 1, 1, 1, 2, 3, 9.

Problem PDDL:

**Result of devstral**: (ollama run devstral)
```pddl
(define (problem blocksworld-17-blocks) (:domain blocksworld) (:objects b1 
b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 b17)
(:init
    (arm-empty)
    (holding b1)
    (clear b2) (on-table b2)
    (clear b3) (on-table b3)
    (clear b4) (on-table b4)
    (clear b5) (on-table b5)
    (clear b6) (on-table b6)
    (clear b7) (on-table b7)
    (clear b8) (on-table b8)
    (clear b9) (on-table b9)
    (clear b10) (on-table b10)
    (clear b11) (on-table b11)
    (clear b12) (on-table b12)
    (clear b13) (on-table b13)
    (clear b14) (on-table b14)
    (clear b15) (on-table b15)
    (clear b16) (on-table b16)
    (clear b17) (on-table b17)
)
(:goal
    (and
        (or (and (on b2 b3) (on b4 b5) (on b6 b7) (on b8 b9) (on b10 b11)) 
; towers of height 2
            (and (on b2 b3) (on b4 b6) (on b5 b7) (on b8 b10) (on b9 
b11)))
        (or (and (on b12 b13) (on b14 b15) (on b16 b17)) ; towers of 
height 3
            (and (on b12 b14) (on b13 b15) (on b16 b17)))
        (or (and (on b10 b11) (on b12 b13) (on b14 b15)) ; tower of height 
9
            (and (on b10 b12) (on b11 b13) (on b14 b17)))
    )
)
```

**Result of Gemma3:**


**Result of gemma3:1b (1B parameter model): ollama run gemma3:1b-it-qat**


**Result of gemma3:4b (4B parameter model): ollama run gemma3:4b-it-qat**

**Result of gemma3:12b (12B parameter model): ollama run gemma3:12b-it-qat**

**Result of Gemma3:27b-it-qat (27B parameter model):** (ollama run gemma3:27b-it-qat)
---

# Plan generation in blocksworld domain (init=on table, goal=tower)
```diff
- Task Signature = [input: PDDL domain, PDDL problem; output: Plan]
```
**Prompt**

Given a PDDL domain and a PDDL problem file, come up with the plan associated with the problem. The domain describes the possible actions and their effects, while the problem file details the specific scenario to be solved. Do not generate anything but the correct plan.

Domain PDDL:

(define (domain blocksworld) (:requirements :strips) (:predicates (arm-empty) (clear ?x)(holding ?x) (on ?x ?y) (on-table ?x)) (:action pickup :parameters (?ob) :precondition (and (clear ?ob) (on-table ?ob) (arm-empty)) :effect (and (holding ?ob) (not (clear ?ob)) (not (ontable ?ob)) (not (arm-empty)))) (:action putdown :parameters (?ob) :precondition (holding ?ob) :effect (and (clear ?ob) (arm-empty) (on-table ?ob) (not (holding ?ob))) ) (:action stack :parameters (?ob ?underob) :precondition (and (clear ?underob) (holding ?ob)) :effect (and (arm-empty) (clear ?ob) (on ?ob ?underob) (not (clear ?underob)) (not (holding ?ob))) ) (:action unstack :parameters (?ob ?underob) :precondition (and (on ?ob ?underob) (clear ?ob)
(arm-empty)) :effect (and (holding ?ob) (clear ?underob) (not (on ?ob ?underob)) (not (clear ?ob)) (not (arm-empty))) ))

Problem PDDL:

(define (problem on table to tower 1 1 1 1 3 13)(:domain blocksworld)(:requirements :strips)(:objects b1 b10 b11 b12 b13 b14 b15 b16 b17 b18 b19 b2 b20 b3 b4 b5 b6 b7 b8 b9)(:init (arm-empty) (clear b1) (clear b10) (clear b11) (clear b12) (clear b13) (clear b14) (clear b15) (clear b16) (clear b17) (clear b18) (clear b19) (clear b2) (clear b20) (clear b3) (clear b4) (clear b5) (clear b6) (clear b7) (clear b8) (clear b9) (on-table b1) (on-table b10) (on-table b11) (on-table b12) (on-table b13) (on-table b14) (on-table b15) (on-table b16) (on-table b17) (on-table b18) (on-table b19) (on-table b2) (on-table b20) (on-table b3) (ontable b4) (on-table b5) (on-table b6) (on-table b7) (on-table b8) (on-table b9))(:goal (and (arm-empty) (clear b1) (on-table b1) (clear b2) (on-table b2) (clear b3) (on-table b3) (clear b4) (on-table b4) (clear b5) (on b5 b6) (on b6 b7) (on-table b7) (clear b8) (on b8 b9) (on b9 b10) (on b10 b11) (on b11 b12) (on b12 b13) (on b13 b14) (on b14 b15) (on b15 b16) (on b16 b17) (on b17 b18) (on b18 b19) (on b19 b20) (on-table b20))))

Plan:

**Result of devstral**: (ollama run devstral)


**Result of Gemma3:**


**Result of gemma3:1b (1B parameter model): ollama run gemma3:1b-it-qat**


**Result of gemma3:4b (4B parameter model): ollama run gemma3:4b-it-qat**

**Result of gemma3:12b (12B parameter model): ollama run gemma3:12b-it-qat**

**Result of Gemma3:27b-it-qat (27B parameter model):** (ollama run gemma3:27b-it-qat)
