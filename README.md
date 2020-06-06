School lines are out of scope for the project.  
Lines not mentioned here have been tested and appear to work correctly

## TO DO:
- Integration of scheduled update and notification of changes

## Bugs related to the current timetables (06.2020)
- 29/M29, M30, M35, M42: last timeslot incorrect due to mispelling
- E2, E4: weekend time row is delayed, generates a lot of mistakes
- E4b, E7, M11, M14: Empty columns generates some bad timeslots

## Lines that need manual work:
- **28**: due to combination with 21 in weekends
- *32*: weekend has 2 variants, it is encoded in the graph as colored background (lost during conversion)
- 33, 40, trolleys & trams have intervals, needs different solution
- **33b**: multiple routes, chaotic timetable
- *46* (a): has different routes
- _**E2**_ (a): weekend route different
- _**E3**_: due to grouping of E3 and 3 lines, we generate timetables only for the ends (i.e. start of 3, end of E3)
- **E4** has a shitlot of variants, needs manual verification of individual pages
- *M11* the first timeslot starts from the second station
- **M22** also has a shitlod of variants, needs manual reverse engineering of bus routes and timetables
- _**M35**_: one timeslot only during school (currently ignored by script). The line had a variant, due to this, the b side doesn't generate a timetable.
- **M36, M41, M44, M46, M47, M48** have variants
- *M49*: school specific timeslots
- **V1** should be created manually, the end station is in the middle, so the routes should relate to that (catedrala mitropolitană)

**Bold lines need complete manual creation of timetable**  
_**Mixed lines produce correct data partially**_  
*Italic lines need minimal intervention on output*