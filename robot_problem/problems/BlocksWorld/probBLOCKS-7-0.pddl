(define (problem BLOCKS-7-0)
(:domain BLOCKS)
(:objects C - block F - block A - block B - block G - block D - block E - block)
(:INIT ( and (CLEAR E) (ONTABLE D) (ON E G) (ON G B) (ON B A) (ON A F) (ON F C)
 (ON C D) (HANDEMPTY)) )
(:goal (AND (ON A G) (ON G D) (ON D B) (ON B C) (ON C F) (ON F E)))
)
