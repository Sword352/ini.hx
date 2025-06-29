package ini._internal;

class Writer {
    @:allow(ini.Ini)
    function new(): Void {}

    public function write(ast: Ast): String {        
        var buf: StringBuf = new StringBuf();
        writeString(ast, buf);
        return buf.toString();
    }

    function writeString(ast: Ast, buf: StringBuf): Void {
        switch (ast) {
            case ABlock(a):
                for (entry in a)
                    writeString(entry, buf);
            case ASection(name, values):
                buf.add("[");
                buf.add(name);
                buf.add("]");
                buf.add("\n");
                for (value in values)
                    writeString(value, buf);
            case AKeyValuePair(name, v):
                buf.add(name);
                buf.add(" = ");
                buf.add(Std.string(v.toValue()));
                buf.add("\n");
        }
    }
}
