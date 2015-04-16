### _MSRect.pl_
M/S Log Rectifier
=================
Cabrillo log checker for its compliance to 10 minutes QSY rules
of Multi SingleTX categories in CQ WW contests

rin fukuda, jg1vgx@jarl.com
ver 0.01 - Apr 2015

WARNING
-------
This program is NOT intended for the purpose of post-contest rubber-clocking or log massaging.
If you find you have violated the band change rules, mark the QSOs as X-QSOs or consider submitting your log in less restrictive categories such as multi-multi.

Requirements
------------
You need a Perl package to run this script. If you are on Windows, ActivePerl (http://www.activestates.com/) is a good option. 

Limitations
-----------
Currently, only band change violation is checked. (Whether QSOs made on mult transmitter is really a new mult is NOT checked.)

How to Use
----------
1. Prepare your Multi/Single contest log in a Cabrillo format. Column positions, especially for the last TX#, should be strictly observed, otherwise this script won't work. Headers (before the QSO: section) and footers (after the QSO: section, usually END-OF-LOG: only) can contain any length of lines.
Information about Cabrillo format is available here.
http://www.kkn.net/~trey/cabrillo/qso-template.html

2. Start the script, such as:

    ```
    > perl MSRect.pl
    ```
    
    then, enter the file name of the Cabrillo log.
    Results will be printed on the screen output and as well as 'report.txt' file created in the same folder. Additionally, separate logs for Run and Mult transmitters are created - 'RunQSOs.txt' and 'MultQSOs.txt' - in which QSYs are tagged and intervals are calculated. 

Version History
---------------
0.01 - Apr 2015
- Initial working version.
