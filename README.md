# rizzupmyass
plugin to rizz up your ass map in [Quaver](https://github.com/Quaver),
the ultimate community-driven and open-source competitive rhythm game.

an alternative, stripped down clone of [amoguSV](https://github.com/kloi34/amoguSV)
and, by extension, somewhat worse version of [plumoguSV](https://github.com/ESV-Sweetplum/plumoguSV).

note for users:
- the widgets where you need to double click to enter values (e.g. rizz or fizz) you can actually click-drag for minor adjustments
- the text on the graph is the current selected timing group

guide to slang (assming you're already familiar with amoguSV or plumoguSV):
- eaz = ease
- funz = function
- rizz = ???
- fizz = ???
- ptz = points
- gayz = gaze
- bizz = business
- sbizz = still business
- avz = average (SV)
- dizz = distance
- savz = still average (SV)
- sdizz = still distance
- tarz = target

secret sauce keyboard shortcuts:
- `t` : place svs between selected notes
- `n` : delete svs between selected notes
- `b` : set current timing group to the single selected note's timing group
- `alt + b` : prepare a single selected note as an x timing group

basically, when a note is in x timing group, it will sit offscreen below the hit receptor
at -200 msx (or whatever number is hardcoded) until it needs to get hit.
this makes the note invisible the whole time.
to show the note, you can first select the note's timing group,
then place svs using an x still (x sbizz) to show the note onscreen.
this is useful for note animation because you can move notes at the end of the map
into their own x timing groups and show them at any time during the map.
just remember that the notes become invisible, so make sure you use an x still
to show them right before they need to get hit.
