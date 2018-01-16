# -*- coding: utf-8 -*-

#############
# Exercice 1
#############

def factoriel(n):
    """
    Calcul la factorielle de n

    Exemple:

        >>> [ factoriel(i) for i in range(5) ]
        [1, 1, 2, 6, 24]
    """
    if n==0:
        return 1
    return n*factoriel(n-1)

############
# Exercice 2
############

def suite_exo_2(n):
    """
    Calcul le nième élément de la suite définie par:
        u_0 = 3
        u_n = 2 . u_{n-1} + 1

    Exemple:

        >>> [suite_exo_2(i) for i in range(5)]
        [3, 7, 15, 31, 63]
    """
    if n == 0:
        return 3
    return 2*suite_exo_2(n-1) + 1

############
# Exercice 3
############
def suite_exo3(n):
    """
    Retour la valeur de la suite définie par
    u_0 = 0
    u_1 = 1
    u_{n+2} = 2. u_{n+1} - u_{n} + 1

    Exemple:

        >>> [suite_exo3(i) for i in range(5)]
        [0, 1, 3, 6, 10]
    """
    if n==0:
        return 0
    if n==1:
        return 1
    return 2*suite_exo3(n-1) - suite_exo3(n-2) + 1

#############
# Exercice 4
#############

def binomial(n, k):
    """
        Renvoie la valeur du binomial (n,k).

        Exemples:
            >>> n = 0; [ binomial(n,n-i) for i in range(n+1) ]
            [1]
            >>> n = 1; [ binomial(n,n-i) for i in range(n+1) ]
            [1, 1]
            >>> n = 2; [ binomial(n,n-i) for i in range(n+1) ]
            [1, 2, 1]
            >>> n = 3; [ binomial(n,n-i) for i in range(n+1) ]
            [1, 3, 3, 1]
            >>> n = 4; [ binomial(n,n-i) for i in range(n+1) ]
            [1, 4, 6, 4, 1]
    """
    if k == 0 or k == n:
        return 1
    return binomial(n-1,k-1) + binomial(n-1,k)


#############
# Exercice 5
#############

def recherche_rec(T, e, idx):
    if idx >= len(T):
        return None
    if T[idx] == e:
        return idx
    return recherche_rec(T, e, idx+1)

def recherche(T, e):
    """
        Renvoie l'index du premier élément e dans le tableau T, et None sinon.

        Exemples:
            >>> recherche([4,2,5,2,4,10,5], 5)
            2
            >>> recherche([4,2,5,2,4,10,5], 9)
            >>> recherche([4,2,5,2,4,10,5], 10)
            5
    """
    return recherche_rec(T, e, 0)


#############
# Exercice 7
#############

from turtle import *

def flocon_rec( distance, n ):
    if n==0:
        forward(distance)
    else:
        flocon_rec( distance/3.0, n-1 )
        left(60)
        flocon_rec( distance/3.0, n-1 )
        right(120)
        flocon_rec( distance/3.0, n-1 )
        left(60)
        flocon_rec( distance/3.0, n-1 )

def flocon( size=100, n=3 ):
    """
    Dessine un flocon de von Koch

    INPUT: 
        size : la taille du flocon
        n : la profondeur de la récursion
    """
    flocon_rec( size, n )
    right(120)
    flocon_rec( size, n )
    right(120)
    flocon_rec( size, n )
    right(120)



#############
# Exercice 8
#############

from turtle import *
from math import sqrt
speed(0)

def dragon(size, n, go_to_left):
    if n == 0:
        forward(size)
        return
    if go_to_left:
        angle = 45
    else:
        angle = -45
    left(angle)
    dragon( ( sqrt(2.0)/2.0 )*size, n-1, True )
    right(2*angle)
    dragon( ( sqrt(2.0)/2.0 )*size, n-1, False )
    left(angle)

def dragon_rec(size=100, n=10):
    dragon(size, n, go_to_left=True)

#############
# Exercice 9
############

def compositions(n):
    """
    Renvoie les compositions de n.

    Exemple:
        >>> compositions(0)
        [[]]
        >>> compositions(1)
        [[1]]
        >>> compositions(2)
        [[1, 1], [2]]
        >>> compositions(3)
        [[1, 1, 1], [1, 2], [2, 1], [3]]
        >>> compositions(4)
        [[1, 1, 1, 1], [1, 1, 2], [1, 2, 1], [1, 3], [2, 1, 1], [2, 2], [3, 1], [4]]
    """
    if n==0:
        return( [[]] )
    res = []
    for i in range(1,n+1):
        for c in compositions( n-i ):
            res.append( [i] + c )
    return res


#############
# Exercice 10
#############

def partitions_bornees(n ,max_part):
    """
    Renvoie les partitions de taille n dont les parts sont plus petites que 
    max_part

    Exemples:
        
        >>> partitions_bornees(4, 2)
        [[2, 2], [2, 1, 1], [1, 1, 1, 1]]
    """
    if n==0:
        return [[]]
    res = []
    for i in range(min(n,max_part), 0, -1):
        for p in partitions_bornees( n-i, i ):
            res.append( [i] + p )
    return res

def partitions(n):
    """
    Renvoie les partitions de n.

    Exemples:

        >>> partitions(0)
        [[]]
        >>> partitions(1)
        [[1]]
        >>> partitions(2)
        [[2], [1, 1]]
        >>> partitions(3)
        [[3], [2, 1], [1, 1, 1]]
        >>> partitions(4)
        [[4], [3, 1], [2, 2], [2, 1, 1], [1, 1, 1, 1]]
    """
    return partitions_bornees( n , n )


#############
# Exercice 12
#############

def permutations( n ):
    """
        Renvoie toutes les permutations de taille n.

        >>> permutations(0)
        [[]]
        >>> permutations(1)
        [[1]]
        >>> permutations(2)
        [[2, 1], [1, 2]]
        >>> permutations(3)
        [[3, 2, 1], [2, 3, 1], [2, 1, 3], [3, 1, 2], [1, 3, 2], [1, 2, 3]]
    """
    if n==0 :
        return [[]]
    res = []
    for p in permutations( n-1 ):
        for position in range(n):
            res.append( p[:position] + [n] + p[position:]  )
    return res


#############
# Exercice 11
#############

def tour_hanoi( taille_tour, depart, arrivee ):
    """
    Résoue le problème des tours de Hanoï.

    Entrée:
        taille_tour : la taille de la tour situé sur la position depart
        depart : la position de départ de la tour (un entier entre 1 et 3)
        arrivée : la position d'arrivée de la tour (un entier entre 1 et 3)

    Exemples:
        >>> tour_hanoi( 0, 1, 3 )
        >>> tour_hanoi( 1, 1, 3 )
        1 -> 3
        >>> tour_hanoi( 2, 1, 3 )
        1 -> 2
        1 -> 3
        2 -> 3
        >>> tour_hanoi( 3, 1, 3 )
        1 -> 3
        1 -> 2
        3 -> 2
        1 -> 3
        2 -> 1
        2 -> 3
        1 -> 3
        >>> tour_hanoi( 4, 1, 3 )
        1 -> 2
        1 -> 3
        2 -> 3
        1 -> 2
        3 -> 1
        3 -> 2
        1 -> 2
        1 -> 3
        2 -> 3
        2 -> 1
        3 -> 1
        2 -> 3
        1 -> 2
        1 -> 3
        2 -> 3
    """
    if taille_tour==0 or depart == arrivee:
        return
    milieu = 6 - depart - arrivee
    tour_hanoi(taille_tour-1, depart, milieu)
    print(str(depart) + " -> " + str(arrivee))
    tour_hanoi(taille_tour-1, milieu, arrivee)


if __name__ == "__main__":
    import doctest
    doctest.testmod() 
