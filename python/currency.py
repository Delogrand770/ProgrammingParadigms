#import urllib.request
#import xml.dom.minidom

from urllib.request import urlopen
from xml.dom.minidom import parseString

def get_rate( code ):
    #response = urllib.request.urlopen( 'http://www.ecb.int/stats/eurofxref/eurofxref-daily.xml' )
    #print( response.read() )
    #dom = xml.dom.minidom.parseString( response.read() )
    #print( dom.toxml() )
    
    response = urlopen( 'http://www.ecb.int/stats/eurofxref/eurofxref-daily.xml' )
    dom = parseString( response.read() )

    cubes = dom.getElementsByTagName( 'Cube' )
    #print( len(cubes) )

    for cube in cubes:
        #print( cube.getAttribute( 'currency' ) )
        if ( cube.getAttribute( 'currency') == code ):
            #print( cube.getAttribute( 'rate' ) )
            return float( cube.getAttribute( 'rate' ) )

    #raise Exception( "Currency code " + code + " not found." )
    raise LookupError( "Currency code " + code + " not found." )

def convert( amount, code ):
    return amount / get_rate( code )

def convert2( amount, code ):
    return amount / get_rate2( code )

def toxml():
    response = urlopen( 'http://www.ecb.int/stats/eurofxref/eurofxref-daily.xml' )
    dom = parseString( response.read() )

    file = open( 'rates.xml', 'w' )
    #file.write( 'This is a test' )
    file.write( '<?xml version="1.0" encoding="UTF-8"?>\n' )
    file.write( '<rates>\n' )

    cubes = dom.getElementsByTagName( 'Cube' )
    for cube in cubes:
        if ( len( cube.getAttribute( 'currency' ) ) > 0 ):
            file.write( '\t<currency> \n' )
            file.write( '\t\t<code>%s</code> \n' % cube.getAttribute( 'currency' ) )
            file.write( '\t\t<rate>%s</rate> \n' % cube.getAttribute( 'rate' ) )
            file.write( '\t</currency> \n' )
    
    file.write( '</rates>' )
    file.close()

def get_rate2( code ):
    file = open( 'rates.xml', 'r' )
    #print( file.read() )

    #lineNumber = 1
    #for line in file:
    #    print( '{0:3d}: {line}'.format( lineNumber, line = line ), end = '' )
    #    lineNumber += 1

    dom = parseString( file.read() )

    for currency in dom.getElementsByTagName( 'currency' ):
        #help( currency )
        #print( currency.getElementsByTagName( 'code' )[0].firstChild.nodeValue,
        #    currency.getElementsByTagName( 'rate' )[0].firstChild.data )

        if ( currency.getElementsByTagName( 'code' )[0].firstChild.nodeValue == code):
            return float( currency.getElementsByTagName( 'rate' )[0].firstChild.data )

        
        raise LookupError( "Currency code " + code + " not found." )
    
