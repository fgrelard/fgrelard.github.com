def create_list():
    """
    >>> L = create_list()
    >>> L
    {'end': None, 'first': None}
    """
    return {'first':None, 'end':None}

def push_front(l, e):
    """
    >>> L = create_list()
    >>> push_front(L, 3)
    >>> push_front(L, 4)
    >>> L
    {'end': None, 'first': {'value': 4, 'next': {'value': 3, 'next': None}}}
    """
    l['first'] = {'value':e, 'next':l['first']}

def first( l ):
    """
    >>> L = create_list()
    >>> push_front(L, 3)
    >>> push_front(L, 4)
    >>> first(L)
    {'value': 4, 'next': {'value': 3, 'next': None}}
    """
    return l['first']

def end( l ):
    """
    >>> L = create_list()
    >>> push_front(L, 3)
    >>> push_front(L, 4)
    >>> end(L)
    """
    return l['end']

def next( l, cell ):
    """
    >>> L = create_list()
    >>> push_front(L, 3)
    >>> push_front(L, 4)
    >>> cell = first(L)
    >>> next(L, cell)
    {'value': 3, 'next': None}
    """
    return cell['next']

def value( l, cell ):
    """
    >>> L = create_list()
    >>> push_front(L, 3)
    >>> push_front(L, 4)
    >>> cell = first(L)
    >>> value(L, cell)
    4
    """
    return cell['value']


def push_back(l, e):
    """
    Add an element to the end of the list.
    >>> L = create_list()
    >>> push_back(L, 5)
    >>> L
    {'end': None, 'first': {'value': 5, 'next': None}}
    """
    itb = first(l)
    if (itb == None):
        push_front(l, e)
    else:
        while (next(l, itb) != None):
            itb = next(l, itb)
        itb['next'] = {'value': e, 'next': itb['next']}


def insert( l, cell, e ):
    """
    Create a new cell containing the element e and insert this cell in
    the list just after the cell \texttt{cell
    >>> L = create_list()
    >>> push_front(L, 3)
    >>> push_front(L, 4)
    >>> insert(L, first(L), 7)
    >>> L
    {'end': None, 'first': {'value': 4, 'next': {'value': 7, 'next': {'value': 3, 'next': None}}}}
    """
    itb = first(l)
    while (itb != cell):
        itb = next(l, itb)
    itb['next'] = {'value': e, 'next': itb['next']}

def copy( l ):
    """
    Return a copy of the list l
    >>> L = create_list()
    >>> push_front(L, 3)
    >>> Lp = copy(L)
    >>> push_front(L, 4)
    >>> L != Lp
    True
    """
    Lp = create_list()
    itb = first(l)
    while (itb != None):
        push_back(Lp, value(l, itb))
        itb = next(l, itb)
    return Lp

def middle(l):
    """
    return the element which is in the middle of the list.
    >>> L = create_list()
    >>> push_front(L, 3)
    >>> push_front(L, 4)
    >>> push_back(L, 5)
    >>> middle(L)
    {'value': 3, 'next': {'value': 5, 'next': None}}
    """
    s = size(l)
    mid  = s//2
    itb = first(l)
    i = 0
    while (itb != None):
        if (i == mid):
            return itb
        i += 1
        itb = next(l, itb)
    return None

def size(l):
    """
    return the number of elements in the list.
    >>> L = create_list()
    >>> push_front(L, 3)
    >>> push_front(L, 4)
    >>> push_back(L, 4)
    >>> size(L)
    3
    """
    s = 0;
    itb = first(l)
    while (itb != None):
        s += 1
        itb = next(l, itb)
    return s

def transfert( l1, l2 ):
    """
    Move all elements belonging to L2 into L1.
    L2 empty at end funct
    >>> L = create_list()
    >>> push_front(L, 3)
    >>> push_front(L, 4)
    >>> push_back(L, 5)
    >>> L2 = create_list()
    >>> push_front(L2, 7)
    >>> transfert(L2, L)
    >>> L2
    {'end': None, 'first': {'value': 7, 'next': {'value': 4, 'next': {'value': 3, 'next': {'value': 5, 'next': None}}}}}
    """
    itb = first(l2)
    while (itb != None):
        push_back(l1, value(l2, itb))
        itb = next(l2, itb)

def search_element(l,e):
    """
    return the first cell containing e or the cell at the end of the list.
    >>> L = create_list()
    >>> push_front(L, 3)
    >>> push_front(L, 4)
    >>> push_back(L, 5)
    >>> search_element(L, 4)
    {'value': 4, 'next': {'value': 3, 'next': {'value': 5, 'next': None}}}
    >>> search_element(L, 2)
    """
    itb = first(l)
    while (itb != None):
        if (value(l, itb) == e):
            return itb
        itb = next(l, itb)
    return None


if __name__ == "__main__":
    import doctest
    doctest.testmod()
