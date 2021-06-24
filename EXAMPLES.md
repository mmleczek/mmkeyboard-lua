# Examples
#### Lua
```
@title - defines a title shown in top left corner of the keyboard
@allow_to_walk - defines if player can walk while not typing any text
@maxlen - defines max possible length of text in textarea
```
```lua
exports.mmkeyboard:Show(@title, @allow_to_walk, @maxlen, function(text)
    print(text)
end)

exports.mmkeyboard:Show("Type in some text:", false, 255, function(text)
    print(text)
end)```
![myimage-alt-tag](https://i.imgur.com/FB6Y4gB.jpg)