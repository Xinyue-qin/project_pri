(define (problem blocks-example)
  (:domain blocksworld)  ; 关联到上述领域
  (:objects A B C - block)  ; 定义三个积木对象

  ; 初始状态：所有积木放在桌面上
  (:init
    (ontable A) (ontable B) (ontable C)
    (clear A) (clear B) (clear C)
    (handempty)
  )

  ; 目标状态：A在B上，B在C上（塔式堆叠）
  (:goal (and (on A B) (on B C)))