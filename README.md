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
    
    then, enter the file name of the Cabrillo log. Results will be printed on the screen output and in 'report.txt' file created in the same folder.
    Hour summary of QSY counts will be shown in the screen. If excess QSYs had been detected, you will be warned. If you find too many violations, consider submitting your log into Multi/Multi category rather than Multi/Single.

3. The correctly numbered new Cabrillo log will be created as "new_" plus original file name. The original Cabrillo log is untouched. In addition, two report files are created.

- bandchanges.txt: Consecutive QSOs on the same band is treated as one in the program. Change# is a serial number for such bundled QSOs. TX#s assigned for each bundle of QSOs are shown.
- qsy_report.txt: Flow of QSYs for entire contest is shown using text graphics. You can count and confirm that the QSY counts are in fact less than eight times for each TX.

Version History
---------------
0.01 - Apr 2015
- Initial working version.
