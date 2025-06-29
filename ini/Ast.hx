package ini;

enum Ast {
    ABlock(a: Array<Ast>);
    ASection(name: String, values: Array<Ast>);
    AKeyValuePair(name: String, v: Const);
}

abstract Const(ConstImpl) from ConstImpl {
    /**
     * Retrieves the value from this `Const`.
     * @return Any
     */
    public function toValue(): Any {
        return switch (this) {
            case CString(v): v;
            case CNumber(v): v;
            case CBool(v): v;
        }
    }

    /**
     * Returns a `Const` based on the given `String`.
     * @param string `String` to make the const from.
     * @return Const
     */
    public static function fromString(string: String): Const {
        static final NUMBER_REGEX: EReg = new EReg("^(?:[+-]?(?:(?:[1-9]\\d*|0)(?:\\.\\d*)?|\\.\\d+)(?:[Ee][+-]?\\d+)?)$", "");

        if (string == "true")
            return CBool(true);

        if (string == "false")
            return CBool(false);

        if (NUMBER_REGEX.match(string))
            return CNumber(Std.parseFloat(string));

        return CString(string);
    }
}

private enum ConstImpl {
    CString(v: String);
    CNumber(v: Float);
    CBool(v: Bool);
}
