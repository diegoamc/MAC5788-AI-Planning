(define (problem BLOCKS-9-2)
(:domain BLOCKS)
(:objects B - block I - block C - block E - block D - block A - block G - block F - block H - block)
(:INIT ( and (CLEAR H) (CLEAR F) (ONTABLE G) (ONTABLE F) (ON H A) (ON A D) (ON D E)
 (ON E C) (ON C I) (ON I B) (ON B G) (HANDEMPTY)) )
(:goal (AND (ON F G) (ON G H) (ON H D) (ON D I) (ON I E) (ON E B) (ON B C)
            (ON C A)))
)