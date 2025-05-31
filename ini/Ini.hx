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
    public static inline function parseAst(content: String): Ast {
        return new StringToAst().parse(content);
    }

    /**
     * Converts ini `Ast` into ini output.
     * @param ast `Ast` to convert.
     * @return Output
     */
    public static inline function parseObject(ast: Ast): Output {
        return new AstToObject().parse(ast);
    }

    /**
     * Converts ini `Ast` into raw ini `String`.
     * @param ast `Ast` to convert.
     * @return String
     */
    public static inline function write(ast: Ast): String {
        return new Writer().write(ast);
    }
}
