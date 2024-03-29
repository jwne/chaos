# Chaos

A hackable text editor for the 22nd century.

![chaos.png](https://raw.githubusercontent.com/sdegutis/chaos/master/chaos.png)

## Written in its own extension API

The entire text editor is written using its own extension API which is
written in Lua!

- Cursor(s?)
- Buffer storage
- Buffer drawing
- File representation
- Panes/splits
- Basically everything

This means there's no difference between the text editor itself and
its extensions/plugins. We can extend *every single aspect* of the
text editor, with full control. The only part written in native code
is the part that draws the characters super fast, which leads me to
the next feature...

## Just a grid of characters

It's just a grid of fixed-width text. That's it. There's no fancy GUI
to manipulate. This has some very clear advantages over text editors
with fancy rendering engines.

#### Extremely efficient on resources

Draws fast as lightning, with a negligible re-drawing cost. Super low
on memory. Isn't going to burn out your new laptop's CPU, and isn't
going to run sluggishly on your 3-year-old desktop computer.

#### Dead-simple graphics API

It's super easy to write code that draws exactly the kind of thing you
want to, within the limitations. Anyone can hack on the rendering
internals, since it lacks the complexity of WebKit. And it's
[not going to look ugly again every 6 months][^1], unlike *every
website*.

#### It doesn't have to be ugly

Foreground and background colors are specified using 6-digit hex
codes, just like in CSS, so you get way more color than you do in
terminal emulators. Plus, there are many aesthetically pleasing
monospace fonts.

#### Simplicity over everything

This does have its trade-offs, that's true: you can't read your code
in Arial since the font must be monospace, you can't do super fancy
CSS-17 animation tricks, and you can't draw rounded rectangles. But
it's quite a worthwhile trade-off to get this level of simplicity, and
all its accompanying benefits.

## How's it different?

#### Compared to terminal-based editors:

* Way more than 256-colors
* Perfectly precise modifier detection
* Modifiers and keys are separate
* Much simpler drawing API

#### Compared to GUI-heavy editors:

* Much simpler drawing API
* Completely customizable

#### Compared to Emacs:

* Uses a mainstream extension language
* Aims to have sane, modern defaults

## Getting started

Because Chaos is still in early development, only the ground-work has
been laid out, and the basic text editing functionality still needs
work. Therefore it's not quite usable at this moment.

## Want to help out?

If you want to help bring Chaos to maturity, see
[the issues page on Github](https://github.com/sdegutis/chaos/issues). Or
you can comment on the relevant
[Hacker News post](https://news.ycombinator.com/item?id=7841168) to
voice your support for the project.

[^1]: http://en.wikipedia.org/wiki/Planned_obsolescence
