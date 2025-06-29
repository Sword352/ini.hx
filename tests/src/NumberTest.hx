package;

import ini.Ini;
import ini.Output;

import massive.munit.Assert;

using Reflect;

class NumberTest {
    var ini: Output;

    @Before
    public function setup(): Void {
        ini = Ini.parse([
            "integer = 123",
            "decimal = 123.123",
            "negative_integer = -123",
            "explicit_plus_sign = +123",
            "exponent = 123e2",
            "negative_exponent = 123E-2",
            "leading_decimal_point = .123",
            "trailing_decimal_point = 123."
        ].join("\n"));
    }

    @Test
    public function test(): Void {
        assertNumber("integer", 123);
        assertNumber("decimal", 123.123);
        assertNumber("negative_integer", -123);
        assertNumber("explicit_plus_sign", 123);
        assertNumber("exponent", 123e2);
        assertNumber("negative_exponent", 123E-2);
        assertNumber("leading_decimal_point", 0.123);
        assertNumber("trailing_decimal_point", 123.0);
    }

    function assertNumber(key: String, expected: Float): Void {
        var value: Any = ini.getSection().getProperty(key);

        Assert.isTrue(value is Float, key + " hasn't been parsed as a Float");
        Assert.areEqual(expected, value);
    }
}
