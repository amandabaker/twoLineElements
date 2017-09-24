# Reading Two-Line Element Sets

This function reads in a file containing a list of two-line element sets and matches the satellite name provided by the user to one of the satellites mentioned in the file. 

See [NORAD Two-Line Element Set Format](http://celestrak.com/NORAD/documentation/tle-fmt.asp) for more information on two-line element sets and their format.

## Usage

In matlab copy this file and call the function as follows:

```matlab
    satellite = readTwoLineElements('fileName.txt', 'satellite-name');
```

where `'fileName.txt'` is replaced with the name of the file holding your TLE data, and `'satellite-name'` is the name of the satellite you are searching for.

The output of the function, `satellite`, is a struct which holds the information fetched from the TLE data file that matched `'satellite-name'`.   

> Note: Extra lines between the satellite name and lines 1 and 2 of the two-line element set will cause this to fail. The function makes the assumption that the TLE data file is formatted as follows:

```
    SATELLITE NAME 1
    1 NNNNNU NNNNNAAA NNNNN.NNNNNNNN +.NNNNNNNN +NNNNN-N +NNNNN-N N NNNNN
    2 NNNNN NNN.NNNN NNN.NNNN NNNNNNN NNN.NNNN NNN.NNNN NN.NNNNNNNNNNNNNN
    SATELLITE NAME 2
    1 NNNNNU NNNNNAAA NNNNN.NNNNNNNN +.NNNNNNNN +NNNNN-N +NNNNN-N N NNNNN
    2 NNNNN NNN.NNNN NNN.NNNN NNNNNNN NNN.NNNN NNN.NNNN NN.NNNNNNNNNNNNNN   
    SATELLITE NAME 3
    ...
```
 