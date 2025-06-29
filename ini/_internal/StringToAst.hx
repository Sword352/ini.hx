package ini._internal;

import ini.Ast.Const;
import haxe.ds.StringMap;

using StringTools;

class StringToAst {
    @:allow(ini.Ini)
    function new(): Void {}

    var charIdx: Int = 0;
    var currLine: Int = 1;

    var buffer: Array<Ast>;
    var state: State;

    // prevents duplicates
    var registeredSections: Array<String>;
    var registeredKeys: StringMap<Array<String>>;
    var registeredIsolatedKeys: Array<String>;

    var pendingSectionName: String;
    var sectionValues: Array<Ast>;

    var pendingKey: String;
    var pendingValue: String;

    public function parse(content: String): Ast {
        registeredSections = [];
        registeredKeys = new StringMap();
        registeredIsolatedKeys = [];

        var output: Ast = ABlock(buffer = []);

        while (charIdx < content.length) {
            var currChar: Int = content.fastCodeAt(charIdx++);

            switch (currChar) {
                case '['.code if (state == null):
                    startReadingSection();
                
                case ']'.code if (state == ReadingSection):
                    stopReadingSection();

                case '='.code if (state == ReadingKey):
                    stopReadingKey();
                    startReadingValue();

                case "#".code | ";".code if (state != ReadingSection):
                    if (state != null) {
                        switch (state) {
                            // case ReadingSection:
                                // throwError("Cannot write comment next to section name");
                            case ReadingKey:
                                throwError("Cannot write comment next to key");
                            case ReadingValue:
                                stopReadingValue();
                            default:
                        }
                    }
                    
                    state = ReadingComment;

                case " ".code if (state == null):
                    // ignore space

                case "\r".code:
                
                case "\n".code:
                    checkNewline();
                    currLine++;
                
                default:
                    if (state == ReadingComment)
                        continue;

                    if (state == null)
                        startReadingKey();

                    var charLiteral: String = String.fromCharCode(currChar);

                    switch (state) {
                        case ReadingSection:
                            pendingSectionName += charLiteral;
                        case ReadingKey:
                            pendingKey += charLiteral;
                        case ReadingValue:
                            pendingValue += charLiteral;
                        default:
                    }
            }
        }

        checkNewline();

        return output;
    }

    function startReadingSection():Void {
        pendingSectionName = "";
        state = ReadingSection;
    }

    function stopReadingSection(): Void {
        if (registeredSections.contains(pendingSectionName))
            throwError('Duplicate section "${pendingSectionName}" found');

        buffer.push(ASection(pendingSectionName, sectionValues = []));
        registeredSections.push(pendingSectionName);

        // pendingSectionName = null;
        state = null;
    }

    function startReadingKey(): Void {
        pendingKey = "";
        state = ReadingKey;
    }

    function stopReadingKey(): Void {
        pendingKey = pendingKey.trim();

        // check duplicate
        if (pendingSectionName == null) {
            if (registeredIsolatedKeys.contains(pendingKey))
                throwError('Duplicate key "${pendingKey}" found');
            registeredIsolatedKeys.push(pendingKey);
        } else {
            var keys: Array<String> = registeredKeys.get(pendingSectionName);
            if (keys != null) {
                if (keys.contains(pendingKey))
                    throwError('Duplicate key "${pendingKey}" found in section "${pendingSectionName}"');
                keys.push(pendingKey);
            } else {
                registeredKeys.set(pendingSectionName, [pendingKey]);
            }
        }
    }

    function startReadingValue(): Void {
        pendingValue = "";
        state = ReadingValue;
    }

    function stopReadingValue(): Void {
        pendingValue = pendingValue.trim();

        var astEntry: Ast = AKeyValuePair(pendingKey, Const.fromString(pendingValue));

        if (sectionValues != null)
            sectionValues.push(astEntry);
        else
            buffer.push(astEntry);

        pendingKey = null;
        pendingValue = null;
        state = null;
    }

    function checkNewline(): Void {
        if (state == null)
            return;

        switch (state) {
            case ReadingSection:
                throwError("Unterminated section name");
            case ReadingKey:
                throwError("Unterminated key");
            case ReadingValue:
                stopReadingValue();
            case ReadingComment:
                // finish reading comment
                state = null;
        }
    }

    inline function throwError(message: String): Void {
        throw message + ' (char ${charIdx}, line ${currLine})';
    }
}

private enum State {
    ReadingSection;
    ReadingKey;
    ReadingValue;
    ReadingComment;
}
