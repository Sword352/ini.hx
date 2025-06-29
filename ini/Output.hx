package ini;

@:forward
abstract Output(Dynamic) {
    @:allow(ini._internal.AstToObject)
    function new(): Void {
        this = {};
    }

    @:deprecated("Use dot access or reflection instead")
    public function getSection(?name: String): Dynamic {
        if (name == null)
            return this;

        if (Reflect.hasField(this, name)) {
            var property: Any = Reflect.getProperty(this, name);
            if (Type.typeof(property) == TObject)
                return property;
        }

        throw 'Section "${name}" does not exist!';
    }

    @:deprecated("Use Reflect.fields instead")
    public function getSectionList(): Array<String> {
        var output: Array<String> = [];

        for (field in Reflect.fields(this)) {
            var property: Any = Reflect.getProperty(this, field);
            if (Type.typeof(property) == TObject)
                output.push(field);
        }

        return output;
    }

    public function toString(): String {
        return Std.string(this);
    }
}
