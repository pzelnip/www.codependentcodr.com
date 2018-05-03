Title: The Text Editing Kata - VS Code Edition
Date: 2018-05-01 21:55
Modified: 2018-05-01 21:55
Category: Posts
tags: vscode,editing
cover: static/imgs/default_page_imagev2.jpg
summary: Using Visual Studio Code to do the Text Editing Kata
status: published

I recently stumbled across [this article](https://code.joejag.com/2016/text-editing-kata.html)
which had a challenge/kata to do some funky text
editing to convert a list of strings into some specially formatted HTML.  The idea is
take input like:

```text
Basic Price
Discount
Sub total
... etc ...
```

And produce:

```html
<dt runat="server" id="dtBasicPrice">Basic Price</dt>
<dd runat="server" id="ddBasicPrice"></dd>

<dt runat="server" id="dtDiscount">Discount</dt>
<dd runat="server" id="ddDiscount"></dd>

<dt runat="server" id="dtSubTotal">Sub total</dt>
<dd runat="server" id="ddSubTotal"></dd>

.... etc ....
```

That is, for each line produce a `<dt>` and `<dd>` tag, with the `id` of those tags being
the text, but with the text coverted to title case (first character following a space
capitalized) and spaces removed.

My first attempt was literally just typing each line manually using no shortcuts other than
copy & paste.  It took me just over 10 minutes to do the entire list of 24 lines.

There has to be a better way.  I saw some
[discussion](https://www.reddit.com/r/programming/comments/5860hx/the_text_editing_kata/)
using Sublime, Vi, Emacs, and other editors, but all seemed a bit beyond me.

I then thought and thought, and Googled & Googled, and tried various tricks and ideas.

Eventually I came up with a technique with which I did the entire exercise in just over a
minute. Here's a recording of it, note that this does require the `change-case` extension:
<https://marketplace.visualstudio.com/items?itemName=wmaurer.change-case>

<!-- markdownlint-disable MD033 -->
<video autoplay loop controls>
  <source src="/static/vids/textKata480p.mp4" type="video/mp4">
  <img src="/static/imgs/textKata.gif">
</video>
<!-- markdownlint-enable MD033 -->

Ok, that's hard to follow, but this is the gist of what I did.  Note that some shortcut
keys may be different for you, because
I've remapped a bunch of keys, and installed the
[Sublime Text Keymap extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.sublime-keybindings)

* Command palette (`⌘+p`), pick "Trim Trailing Whitespace"
* Select all lines (`⌘+a`), and copy (`⌘+c`)
* Open new buffer (`⌘+n`) and paste (`⌘+v`)
* Spit view (`⌘+v`), and close the left hand version of the 2nd buffer
* Go to 2nd buffer, select all lines, command palette, then pick "Change Case title"
    * this requires the `change-case` extension
* Find & replace (`⌘+shift+f`), search for single blank space & replace with nothing
    * make sure "Use Regular Expression" is turned on
* Go back to 1st buffer
* select all, multiline edit (`⌘+shift+l`), copy
* paste, then `enter` to put newline between each & have alternating line cursors
* go to end of line, and `enter` to add the extra blank line
* *without deselecting* go to 2nd buffer, select all & copy
* go back to 1st buffer, go to start of line, paste
* manually type `">` to close the opening tag
* go to end of line, and add the closing `</dt>` tag
* go to start of line, and manually type `<dt runat="server" id="dt`
    * this finishes the `<dt>` tag lines
* *without deselecting* go down one line, and go to start of line
* highlight to end of line & paste
* manually type `"></dd>`
* go to start of line & manually add `<dd runat="server" id="dd`
* profit!

Or, you could just write a little Python script to do it:

```python
import fileinput

def process_line(line):
    line = line.strip()
    idline = line.title().replace(" ", "")
    return f"""<dt runat="server" id="dt{idline}">{line}</dt>
<dd runat="server" id="dd{idline}"></dd>
"""

for line in fileinput.input():
    print(process_line(line))
```

This was a fun, albeit contrived editor example that really stretched my knowledge of how to wrangle text
with VS Code.
