package ini._internal;

import ini.Ast;
import ini.Output;
import haxe.ds.StringMap;

using StringTools;

class AstToObject {
    @:allow(ini.Ini) function new(): Void {}

    public function parse(ast: Ast): Output {
        if (ast == null)
            throw "Cannot parse null ast";

        var output: Output = new Output();
        addToOutput(output, ast);
        return output;
    }

    function addToOutput(output: Output, ast: Ast): Void {
        switch (ast) {
            case ABlock(a):
                for (entry in a)
                    addToOutput(output, entry);
            
            case ASection(name, values):
                if (output.sections == null)
                    output.sections = new StringMap();

                output.sections.set(name, buildObject(values));
            
            case AKeyValuePair(name, v):
                if (output.isolatedKeyValuePairs == null)
                    output.isolatedKeyValuePairs = {};

                addFieldToObject(output.isolatedKeyValuePairs, name, v);
        }
    }

    function buildObject(values: Array<Ast>): Any {
        var output: Any = {};

        for (value in values) {
            switch (value) {
                case AKeyValuePair(name, v):
                    addFieldToObject(output, name, v);
                default:
                    throw "Cannot apply expression " + Std.string(value) + " to output";
            }
        }

        return output;
    }

    function addFieldToObject(object: Any, name: String, const: Const): Void {
        Reflect.setField(object, name, const.toValue());
    }
}
