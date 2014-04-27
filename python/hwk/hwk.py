#Documentation: I did not recieve help on this assignment.

# Needed for using web resources
from urllib.request import urlopen
from xml.dom.minidom import parseString

# Needed for starting external programs
from subprocess import Popen
from os import getcwd

def weather( code ):
    toxml( get_location( code ), get_weather( code ) )
    Popen( "C:/Program Files (x86)/Google/Google Earth/client/googleearth.exe" + ' "' + getcwd() + '"\\google_data.kml' )

def get_location( code ):
    response = urlopen( "http://where.yahooapis.com/geocode?q=" + code )
    dom = parseString( response.read() )
    lat = dom.getElementsByTagName( 'latitude' )[0].firstChild.nodeValue
    long = dom.getElementsByTagName( 'longitude' )[0].firstChild.nodeValue
    city = dom.getElementsByTagName( 'city' )[0].firstChild.nodeValue
    return [city, long, lat]

def get_weather( code ):
    response = urlopen( "http://weather.yahooapis.com/forecastrss?q=" + code )
    dom = parseString( response.read() )

    #split( "<a" )[0] is used to trim off the yahoo ad stuff from the html data
    return dom.getElementsByTagName( 'description' )[1].firstChild.nodeValue.split( "<a" )[0]

def toxml( location, weather ):
    file = open( 'google_data.kml', 'w' )
    file.write( '<?xml version="1.0" encoding="UTF-8"?>\n' )
    file.write( '<kml xmlns="http://www.opengis.net/kml/2.2">\n' )
    file.write( '\t<Placemark>\n' )
    file.write( '\t\t<name>' + location[0] + '</name>\n' )
    file.write( '\t\t<description>\n\t\t\t<![CDATA[' )
    file.write( weather )   
    file.write( '\t\t\t]]>\n\t\t</description>\n' )
    file.write( '\t\t<Point>\n' )
    file.write( '\t\t\t<coordinates>' + location[1] + ', ' + location[2] + ', 0</coordinates>\n' )
    file.write( '\t\t</Point>\n' )
    file.write( '\t</Placemark>\n' )
    file.write( '</kml>' )
    file.close()
