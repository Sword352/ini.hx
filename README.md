# ini.hx

<img src="logo.png" width="150" />

Cross-platform `.ini` parser and writer for Haxe.

## Installation
via haxelib
```
haxelib install ini.hx
```
or via git for latest updates
```
haxelib git ini.hx https://github.com/Sword352/ini.hx.git
```

## Usage
- Parsing ini content
```haxe
package;

class Main {
    public static function main(): Void {
        var document: String = sys.io.File.getContent("myFile.ini");
        var object = ini.Ini.parse(document);

        trace(object); // {message: "Hello, world!", My Section: {sub_value: "Haxe is great!"}}
    }
}
```
```ini
; myFile.ini

message = Hello, world!

[My Section]
sub_value = Haxe is great!
```
- Writing ini content
```haxe
package;

import ini.Ast;

class Main {
    public static function main(): Void {
        var ast: Ast = ABlock([
            AKeyValuePair("isolated_key", CString("Value")),
            ASection("Section Name", [
                AKeyValuePair("boolean_value", CBool(true)),
                AKeyValuePair("number_value", CNumber(1))
            ])
        ]);

        /*
            isolated_key = Value
            [Section Name]
            boolean_value = true
            number_value = 1
        */
        trace(ini.Ini.write(ast));
    }
}
```

## API
- `ini.Ini.parse` converts ini string into object
- `ini.Ini.parseAst` converts ini string into ini ast
- `ini.Ini.parseObject` converts ini ast into object
- `ini.Ini.write` converts ini ast into a readable ini document