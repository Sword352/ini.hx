package ini;

import ini._internal.*;

class Ini {
    /**
     * Builds an object based on raw ini content (`String`).
     * @param content Raw ini content to make the object from.
     * @return Output
     */
    public static inline function parse(content: String): Output {
        return parseObject(parseAst(content));
    }

    /**
     * Converts ini `String` into ini `Ast`.
     * @param content `String` to convert.
     * @return Ast
     */
    public static function parseAst(content: String): Ast {
        if (content == null)
            throw "Cannot parse null ini document";
        return new StringToAst().parse(content);
    }

    /**
     * Converts ini `Ast` into ini output.
     * @param ast `Ast` to convert.
     * @return Output
     */
    public static function parseObject(ast: Ast): Output {
        if (ast == null)
            throw "Cannot convert null ini ast into object";
        return new AstToObject().parse(ast);
    }

    /**
     * Converts ini `Ast` into raw ini `String`.
     * @param ast `Ast` to convert.
     * @return String
     */
    public static function write(ast: Ast): String {
        if (ast == null)
            throw "Cannot convert null ini AST into string";
        return new Writer().write(ast);
    }
}
