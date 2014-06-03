# Chaos

A hackable text editor for the 22nd century.

![chaos.png](https://raw.githubusercontent.com/sdegutis/chaos/master/chaos.png)

## How's it different?

### Written in itself

The entire text editor is written in Lua!

- Cursor(s?)
- Buffer storage
- Buffer drawing
- File representation
- Panes/splits
- Basically everything

So you can easily extend *every single aspect* of the text editor, with full control. The only part not written in Lua is the part that draws the characters super fast, which leads me to the next feature...

### Just a grid of characters

It's just a grid of fixed-width text. That's it. There's no fancy GUI to manipulate. This has some very clear advantages over text editors with fancy rendering engines.

- Extremely efficient on resources

  Draws fast as nightning, with a negligible re-drawing cost. Super low on memory. Isn't going to burn out your new laptop's CPU, and isn't going to run sluggishly on your 3-year-old desktop computer.

- Dead-simple graphics API

  It's super easy to write code that draws exactly the kind of thing you want to, within the limitations. Anyone can hack on the rendering internals, since it lacks the complexity of WebKit. And it's [not going to look ugly again every 6 months](http://en.wikipedia.org/wiki/Planned_obsolescence), unlike *every website*.

This does have its trade-offs, that's true: you can't read your code in Arial since the font must be monospace, you can't do super fancy CSS-17 animation tricks, and you can't draw rounded rectangles. But it's quite a worthwhile trade-off to get this level of simplicity, and all its accompanying benefits.

## Want to help out?

Chaos is still in early development, and lacking important functionality. If you want to help bring Chaos to maturity, see the issues page on Github.
