Title: The Text Editing Kata - VS Code Edition
Date: 2018-05-01 21:55
Modified: 2018-05-01 21:55
Category: Posts
tags: vscode,editing
cover: static/imgs/default_page_imagev2.jpg
summary: Using Visual Studio Code to do the Text Editing Kata - https://code.joejag.com/2016/text-editing-kata.html
status: draft



Ok, here's the recording of the best I could come up with in VS Code.  Note that this does require the `change-case` extension: https://marketplace.visualstudio.com/items?itemName=wmaurer.change-case


IMG HERE

Ok, that's hard to follow, but this is the gist of what I did.  Note that some shortcut keys may be different, because
I've remapped a bunch of keys, and installed the Sublime Keymap extension

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
* paste, then enter to put newline between each & have alternating line cursors
* go to end of line, and enter to add the extra blank line
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
