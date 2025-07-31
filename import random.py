import os
import random
import subprocess
import tempfile
from typing import List, Tuple, Dict
from collections import defaultdict
import json
from pathlib import Path

class BlocksworldDatasetCreator:
    def __init__(self, fast_downward_path: str, output_dir: str = "bw_dataset"):
        """
        :param fast_downward_path: Fast-Downward可执行文件路径
        :param output_dir: 输出数据集目录
        """
        self.fd_path = fast_downward_path
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(parents=True, exist_ok=True)
        
        # 预定义领域文件
        self.domain_pddl = """
        (define (domain blocksworld-4ops)
          (:requirements :strips)
          (:types block)
          (:predicates (on ?x ?y) (ontable ?x) (clear ?x) (handempty) (holding ?x))
          
          (:action pick-up
            :parameters (?x)
            :precondition (and (ontable ?x) (clear ?x) (handempty))
            :effect (and (not (ontable ?x)) 
                         (not (clear ?x)) 
                         (not (handempty)) 
                         (holding ?x)))
          
          (:action put-down
            :parameters (?x)
            :precondition (holding ?x)
            :effect (and (not (holding ?x)) 
                         (ontable ?x) 
                         (clear ?x) 
                         (handempty)))
          
          (:action stack
            :parameters (?x ?y)
            :precondition (and (holding ?x) (clear ?y))
            :effect (and (not (holding ?x)) 
                         (not (clear ?y)) 
                         (clear ?x) 
                         (handempty) 
                         (on ?x ?y)))
          
          (:action unstack
            :parameters (?x ?y)
            :precondition (and (on ?x ?y) (clear ?x) (handempty))
            :effect (and (holding ?x) 
                         (clear ?y) 
                         (not (clear ?x)) 
                         (not (handempty)) 
                         (not (on ?x ?y))))
        )"""

    def _generate_random_stacks(self, num_blocks: int) -> List[List[str]]:
        """生成随机积木堆叠配置"""
        blocks = [f"b{i}" for i in range(1, num_blocks+1)]
        random.shuffle(blocks)
        
        stacks = []
        while blocks:
            stack_height = random.randint(1, len(blocks))
            stack = blocks[:stack_height]
            stacks.append(stack)
            blocks = blocks[stack_height:]
        return stacks

    def _create_problem_pddl(self, init_stacks: List[List[str]], 
                           goal_stacks: List[List[str]], 
                           problem_name: str) -> str:
        """生成PDDL问题文件内容"""
        all_blocks = {b for stack in init_stacks + goal_stacks for b in stack}
        sorted_blocks = sorted(all_blocks)
        
        # 生成初始状态
        init_state = []
        for stack in init_stacks:
            if len(stack) == 1:
                init_state.extend([f"(ontable {stack[0]})", f"(clear {stack[0]})"])
            else:
                for i in range(len(stack)-1):
                    init_state.append(f"(on {stack[i]} {stack[i+1]})")
                init_state.append(f"(ontable {stack[-1]})")
                init_state.append(f"(clear {stack[0]})")
        init_state.append("(handempty)")
        
        # 生成目标状态
        goal_state = []
        for stack in goal_stacks:
            if len(stack) == 1:
                goal_state.append(f"(ontable {stack[0]})")
            else:
                for i in range(len(stack)-1):
                    goal_state.append(f"(on {stack[i]} {stack[i+1]})")
                goal_state.append(f"(ontable {stack[-1]})")
        
        return f"""(define (problem {problem_name})
  (:domain blocksworld-4ops)
  (:objects {" ".join(sorted_blocks)})
  (:init
    {"\n    ".join(init_state)}
  )
  (:goal (and
    {"\n    ".join(goal_state)}
  ))
)"""

    def _solve_with_fast_downward(self, problem_pddl: str) -> Tuple[bool, List[str]]:
        """使用Fast-Downward求解问题"""
        with tempfile.TemporaryDirectory() as tmp_dir:
            domain_path = Path(tmp_dir) / "domain.pddl"
            problem_path = Path(tmp_dir) / "problem.pddl"
            plan_path = Path(tmp_dir) / "plan.txt"
            
            # 写入临时文件
            with open(domain_path, "w") as f:
                f.write(self.domain_pddl)
            with open(problem_path, "w") as f:
                f.write(problem_pddl)
            
            # 运行规划器
            try:
                result = subprocess.run(
                    [
                        self.fd_path,
                        "--plan-file", str(plan_path),
                        str(domain_path),
                        str(problem_path),
                        "--search", "astar(lmcut())"
                    ],
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    text=True,
                    timeout=30
                )
                
                if result.returncode == 0 and plan_path.exists():
                    with open(plan_path, "r") as f:
                        plan = [line.strip() for line in f 
                               if line.strip() and not line.startswith(';')]
                    return True, plan
                return False, []
                
            except (subprocess.TimeoutExpired, subprocess.CalledProcessError):
                return False, []

    def generate_problem(self, num_blocks: int, max_attempts: int = 10) -> Dict:
        """生成单个有效的问题实例"""
        for _ in range(max_attempts):
            init_stacks = self._generate_random_stacks(num_blocks)
            goal_stacks = self._generate_random_stacks(num_blocks)
            
            # 确保初始和目标状态不同
            if init_stacks == goal_stacks:
                continue
                
            problem_name = f"bw-{num_blocks}-{random.randint(1000,9999)}"
            problem_pddl = self._create_problem_pddl(init_stacks, goal_stacks, problem_name)
            
            # 求解问题
            solvable, plan = self._solve_with_fast_downward(problem_pddl)
            if solvable:
                return {
                    "problem_name": problem_name,
                    "num_blocks": num_blocks,
                    "init_state": init_stacks,
                    "goal_state": goal_stacks,
                    "pddl": problem_pddl,
                    "plan": plan,
                    "plan_length": len(plan)
                }
        return None

    def create_dataset(self, min_blocks: int = 3, max_blocks: int = 7, 
                      samples_per_size: int = 1000):
        """创建完整数据集"""
        dataset = defaultdict(list)
        stats = defaultdict(int)
        
        for num_blocks in range(min_blocks, max_blocks + 1):
            print(f"\nGenerating {samples_per_size} problems with {num_blocks} blocks...")
            
            for i in range(samples_per_size):
                problem = self.generate_problem(num_blocks)
                if problem:
                    dataset[num_blocks].append(problem)
                    stats[num_blocks] += 1
                    if (i + 1) % 100 == 0:
                        print(f"  Generated {i + 1}/{samples_per_size}")
        
        # 保存数据集
        train_set = []
        val_set = []
        
        for num_blocks, problems in dataset.items():
            split_idx = int(len(problems) * 0.9)  # 90%训练集
            train_set.extend(problems[:split_idx])
            val_set.extend(problems[split_idx:])
        
        # 保存为JSON文件
        with open(self.output_dir / "train.json", "w") as f:
            json.dump(train_set, f, indent=2)
        
        with open(self.output_dir / "val.json", "w") as f:
            json.dump(val_set, f, indent=2)
        
        print("\nDataset statistics:")
        for num_blocks, count in sorted(stats.items()):
            print(f"  {num_blocks} blocks: {count} samples")
        
        return dataset

# 使用示例
if __name__ == "__main__":
    # 配置Fast-Downward路径（根据实际路径修改）
    FD_PATH = "/path/to/fast-downward/fast-downward.py"
    
    # 创建数据集生成器
    creator = BlocksworldDatasetCreator(
        fast_downward_path=FD_PATH,
        output_dir="blocksworld_dataset"
    )
    
    # 生成数据集（3-7个积木，每种规模100个样本）
    dataset = creator.create_dataset(
        min_blocks=3,
        max_blocks=7,
        samples_per_size=100
    )