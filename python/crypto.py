from math import *

def mr(n, a):
    if n < 3:
        print("n must be >= 3")
    elif a < 2 or a > n - 2:
        print("a must be 2<= a <=n-2")
    else:
        SR = sub_getSR(n)
        print(SR)
    
def sub_getSR(n):
    n = n - 1
    i = 0
    remainder = 2
    true = 1
    while true:
        pow_result = pow(2, i)
        remainder = n / pow_result
        if remainder % 2 != 0 and pow_result * remainder == n and remainder % 1 == 0:
            true = 0
            return [i, remainder]
        i += 1
            

def gcd(a, b):
    result = gcd_work( a, b )
    print("GCD( " + str(a) + ", " + str(b) + " ) = " + str(result[0]))
    if ( result[0] == 1 ):
        print("Inverse of a mod b = " + str( result[3] ))
        print("Inverse of b mod a = " + str( result[4] ))
        
def gdc_work( a, b ):
    
    if ( b==0 ):
        d = a
        x = 1
        y = 0
        return [ d, x, y, x2, y2 ]
    
    x1 = 0
    y1 = 1
    x2 = 1
    y2 = 0
    while b > 0:
        q = floor(a / b)
        r = a - q * b
        x = x2 - q * x1
        y = y2 - q * y1
        a = b
        b = r
        x2 = x1
        x1 = x
        y2 = y1
        y1 = y
    d = a
    x = x2
    y = y2
    return [ d, x, y, x2, y2 ]
        
    
