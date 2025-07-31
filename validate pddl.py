import os
import re
import subprocess
import tempfile
from typing import Tuple, Optional, List, Dict
from dataclasses import dataclass

@dataclass
class PDDLValidationResult:
    is_valid: bool
    message: str
    fixed_domain: Optional[str] = None
    error_location: Optional[Tuple[int, int]] = None

class PDDLProcessor:
    def __init__(self, fast_downward_path: str):
        self.fd_path = fast_downward_path
        self.last_plan = None
        self.last_validation = None

    def _write_temp_files(self, domain: str, problem: str) -> Tuple[str, str]:
        """创建临时PDDL文件"""
        with tempfile.NamedTemporaryFile(mode='w', suffix='.pddl', delete=False) as domain_file:
            domain_file.write(domain)
        with tempfile.NamedTemporaryFile(mode='w', suffix='.pddl', delete=False) as problem_file:
            problem_file.write(problem)
        return domain_file.name, problem_file.name

    def _cleanup_temp_files(self, *files):
        """清理临时文件"""
        for f in files:
            try:
                if os.path.exists(f):
                    os.remove(f)
            except:
                pass

    def visualize_pddl_structure(self, pddl_content: str) -> Dict:
        """分析PDDL结构"""
        if not pddl_content:
            return {
                'parentheses_balance': 0,
                'sections': [],
                'actions': [],
                'errors': ['Empty PDDL content']
            }

        analysis = {
            'parentheses_balance': 0,
            'sections': [],
            'actions': [],
            'errors': []
        }

        lines = pddl_content.split('\n')
        current_section = None

        for line_num, line in enumerate(lines, 1):
            analysis['parentheses_balance'] += line.count('(')
            analysis['parentheses_balance'] -= line.count(')')

            section_match = re.match(r'\s*\(\:([a-z-]+)', line)
            if section_match:
                current_section = section_match.group(1)
                analysis['sections'].append({
                    'name': current_section,
                    'line': line_num,
                    'valid': True
                })

            action_match = re.match(r'\s*\(\:action\s+([\w-]+)', line)
            if action_match:
                analysis['actions'].append({
                    'name': action_match.group(1),
                    'line': line_num,
                    'parameters': None,
                    'preconditions': None,
                    'effects': None
                })

        # 验证domain定义
        if not any(s['name'] == 'domain' for s in analysis['sections']):
            analysis['errors'].append("Missing required section: :domain")

        if analysis['parentheses_balance'] != 0:
            analysis['errors'].append(
                f"Unbalanced parentheses (difference: {analysis['parentheses_balance']})"
            )

        return analysis

    def fix_pddl_syntax(self, domain: str) -> str:
        """修复PDDL语法"""
        if not domain:
            return domain

        # 确保domain定义完整
        if not re.search(r'\(define\s+\(domain\s+\w+\)', domain):
            domain = f"(define (domain blocksworld)\n{domain}"

        # 修复括号平衡
        open_paren = domain.count('(')
        close_paren = domain.count(')')
        
        if close_paren > open_paren:
            domain = re.sub(r'\)+\s*$', '', domain, count=close_paren-open_paren)
        elif open_paren > close_paren:
            domain += '\n' + ')' * (open_paren - close_paren)

        return domain

    def validate_pddl(self, domain: str, problem: str) -> PDDLValidationResult:
        """验证PDDL文件"""
        if not domain:
            return PDDLValidationResult(False, "Empty domain content")

        analysis = self.visualize_pddl_structure(domain)
        if analysis['errors']:
            fixed_domain = self.fix_pddl_syntax(domain)
            return PDDLValidationResult(
                False,
                "Structure errors:\n" + "\n".join(analysis['errors']),
                fixed_domain,
                (1, 1)
            )

        fixed_domain = self.fix_pddl_syntax(domain)
        domain_path, problem_path = self._write_temp_files(fixed_domain, problem)

        try:
            result = subprocess.run(
                [self.fd_path, "--validate", domain_path, problem_path],
                capture_output=True,
                text=True,
                timeout=30
            )

            if result.returncode == 0:
                self.last_validation = PDDLValidationResult(True, "PDDL syntax valid", fixed_domain)
                return self.last_validation
            else:
                error_line = 1
                error_char = 1
                error_msg = result.stderr

                line_match = re.search(r'line (\d+)', error_msg)
                char_match = re.search(r'column (\d+)', error_msg)
                if line_match:
                    error_line = int(line_match.group(1))
                    if char_match:
                        error_char = int(char_match.group(1))

                self.last_validation = PDDLValidationResult(
                    False,
                    error_msg,
                    fixed_domain,
                    (error_line, error_char)
                )
                return self.last_validation

        except subprocess.TimeoutExpired:
            self.last_validation = PDDLValidationResult(False, "Validation timeout", fixed_domain)
            return self.last_validation
        finally:
            self._cleanup_temp_files(domain_path, problem_path)

# 使用示例
if __name__ == "__main__":
    FD_PATH = "/path/to/fast-downward.py"
    
    # 示例有问题的PDDL
    DOMAIN_WITH_ERRORS = """
    (:requirements :strips)
    (:predicates (on ?x ?y) (ontable ?x) (clear ?x) (handempty
    
    (:action pick-up
      :parameters (?x)
      :precondition (and (ontable ?x) (clear ?x) (handempty))
      :effect (and (not (ontable ?x)) 
                   (not (clear ?x)) 
                   (not (handempty)) 
                   (holding ?x)))
    """
    
    PROBLEM = """
    (define (problem test)
      (:domain blocksworld)
      (:objects A B)
      (:init (ontable A) (ontable B) (clear A) (clear B) (handempty))
      (:goal (on A B)))
    """
    
    processor = PDDLProcessor(FD_PATH)
    
    print("=== 初始验证 ===")
    validation = processor.validate_pddl(DOMAIN_WITH_ERRORS, PROBLEM)
    
    if not validation.is_valid:
        print(f"验证失败: {validation.message}")
        if validation.fixed_domain:
            print("\n=== 修复后的领域文件 ===")
            print(validation.fixed_domain)
            
            print("\n=== 重新验证 ===")
            revalidation = processor.validate_pddl(validation.fixed_domain, PROBLEM)
            print(f"验证结果: {'成功' if revalidation.is_valid else '失败'}")
            if not revalidation.is_valid:
                print(f"错误信息: {revalidation.message}")