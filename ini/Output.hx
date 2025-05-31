package ini;

import haxe.ds.StringMap;

@:allow(ini._internal.AstToObject)
class Output {
    var isolatedKeyValuePairs: Any;
    var sections: StringMap<Any>;

    function new(): Void {}

    /**
     * Returns an object holding the values associated with the given section name.
     * If no name is given, an object holding the isolated key value pairs will be returned if existing.
     * @param name Optional section name.
     * @throws String Isolated key-value pairs do not exists.
     * @throws String The requested section does not exist.
     * @return Any
     */
    public function getSection(?name: String): Any {
        if (name == null) {
            if (isolatedKeyValuePairs == null)
                throw 'No isolated key-value pairs found!';
            return isolatedKeyValuePairs;
        }

        var output: Any = null;

        if (sections != null)
            output = sections.get(name);

        if (output == null)
            throw' Section "${name}" does not exist!';

        return output;
    }

    /**
     * Returns the list of section names.
     * If no section exists, `null` will be returned.
     * @return Array<String>
     */
    public function getSectionList(): Array<String> {
        if (sections == null)
            return null;

        return [for (name in sections.keys()) name];
    }

    /**
     * Converts this ini output into a readable structure as a `String`.
     * @return String
     */
    public function toString(): String {
        var isolatedValues: String = null;
        var sectionValues: String = null;

        if (isolatedKeyValuePairs != null) {
            var fields: Array<String> = Reflect.fields(isolatedKeyValuePairs);
            isolatedValues = fields.map(f -> '${f}: ${Reflect.field(isolatedKeyValuePairs, f)}').join(', ');
        }

        if (sections != null) {
            sectionValues = [for (name => value in sections) '${name}: ${value}'].join(", ");
        }

        if (isolatedValues != null && sectionValues != null)
            return "{" + isolatedValues + ", " + sectionValues + "}";

        if (isolatedValues != null)
            return "{" + isolatedValues + "}";

        if (sectionValues != null)
            return "{" + sectionValues + "}";

        return null;
    }
}
