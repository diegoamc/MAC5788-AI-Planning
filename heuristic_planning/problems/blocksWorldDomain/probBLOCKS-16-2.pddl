(define (problem BLOCKS-16-2)
(:domain BLOCKS)
(:objects K - block I - block G - block N - block P - block A - block D - block M - block C - block B - block H - block F - block O - block J - block L - block E - block)
(:INIT ( and (CLEAR E) (CLEAR L) (ONTABLE J) (ONTABLE O) (ON E F) (ON F H) (ON H B)
 (ON B C) (ON C M) (ON M D) (ON D A) (ON A P) (ON P N) (ON N G) (ON G I)
 (ON I K) (ON K J) (ON L O) (HANDEMPTY)) )
(:goal (AND (ON I D) (ON D H) (ON H F) (ON F B) (ON B K) (ON K J) (ON J G)
            (ON G E) (ON E C) (ON C L) (ON L M) (ON M N) (ON N A) (ON A P)
            (ON P O)))
)
