# Examples
#### Lua
```
@title - defines a title shown in top left corner of the keyboard
@allow_to_walk - defines if player can walk while not typing any text
@maxlen - defines max possible length of text in textarea
@type - defines what type of keyboard to show (default: text, possible types: text, small_text, number)
```
```lua
-- Async
exports.mmkeyboard:Show(@title, @allow_to_walk, @maxlen, function(text)
    print(text)
end, @type)

exports.mmkeyboard:Show("Type in some text:", false, 255, function(text)
    print(text)
end, "text")

--Sync
exports.mmkeyboard:ShowSync(@title, @allow_to_walk, @maxlen, @type)

local text = exports.mmkeyboard:ShowSync("Type in some text:", false, 255, "text")
print(text)
```
![](https://i.imgur.com/T8ZgxvA.gif)
