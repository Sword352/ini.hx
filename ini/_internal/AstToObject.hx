package ini._internal;

import ini.Ast;
import ini.Output;

using StringTools;

class AstToObject {
    @:allow(ini.Ini)
    function new(): Void {}

    public function parse(ast: Ast): Output {
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
                Reflect.setField(output, name, buildObject(values));
            
            case AKeyValuePair(name, v):
                addConstToObject(output, name, v);
        }
    }

    function buildObject(values: Array<Ast>): Any {
        var output: Any = {};

        for (value in values) {
            switch (value) {
                case AKeyValuePair(name, v):
                    addConstToObject(output, name, v);
                default:
                    throw "Cannot apply expression " + Std.string(value) + " to output";
            }
        }

        return output;
    }

    function addConstToObject(object: Any, name: String, const: Const): Void {
        Reflect.setField(object, name, const.toValue());
    }
}
