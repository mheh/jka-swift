/// This file holds the `printf` subset Raven's game code prints through: `%i`, `%d`, `%s`, `%f`, with an optional `-` flag, a width, and a precision.
/// A ported body passes its arguments as `[any FormatArg]`, and the callers `va`, `Com_sprintf`, and `Com_Printf` build that array.
/// The port is by hand, so the semantics are ours and the tests can hold them, and no Foundation call decides them.

// MARK: - FormatArg

/// The three shapes the formatter accepts from an argument.
/// Raven's `printf` arguments are all integers, floating values, or text, so the protocol below reduces each one to a case here.
///
/// - `integer`: a whole number, for `%i` and `%d`.
/// - `floating`: a fractional number, for `%f`.
/// - `text`: a character string, for `%s`.
public enum FormatValue {
    case integer(Int64)
    case floating(Double)
    case text(String)
}

/// A value a ported body can pass to `va`, `Com_sprintf`, or `Com_Printf`.
/// The formatter reads the value through `formatValue` alone, and it matches that case against the specifier.
public protocol FormatArg {
    var formatValue: FormatValue { get }
}

// MARK: - Conformances

extension Int32: FormatArg {
    public var formatValue: FormatValue { .integer(Int64(self)) }
}

extension Int: FormatArg {
    public var formatValue: FormatValue { .integer(Int64(self)) }
}

extension Float: FormatArg {
    public var formatValue: FormatValue { .floating(Double(self)) }
}

extension Double: FormatArg {
    public var formatValue: FormatValue { .floating(self) }
}

extension String: FormatArg {
    public var formatValue: FormatValue { .text(self) }
}

extension CharBuf: FormatArg {
    public var formatValue: FormatValue { .text(String(self)) }
}

extension PooledString: FormatArg {
    public var formatValue: FormatValue { .text(self.string) }
}

/// Raven's `qboolean` under `%i` or `%d`, which C reads as its `int`, 0 or 1.
/// A `Bool` under `%s` traps, as every integer does.
extension Bool: FormatArg {
    public var formatValue: FormatValue { .integer(self ? 1 : 0) }
}

// MARK: - format

/// This prints `fmt` with `args` substituted, Raven's `printf` over the specifiers the game uses.
/// A specifier outside `%[-][width][.precision](i|d|s|f)`, an argument of the wrong shape, or a missing argument traps, so a new shape surfaces at once instead of printing wrong text.
public func format(_ fmt: String, _ args: [any FormatArg]) -> String {
    let characters = Array(fmt)
    var out = ""
    var index = 0
    var nextArg = 0

    while index < characters.count {
        let character = characters[index]
        if character != "%" {
            out.append(character)
            index += 1
            continue
        }

        index += 1
        precondition(index < characters.count, "format: the format string ends inside a specifier")

        // A doubled percent prints one percent and takes no argument.
        if characters[index] == "%" {
            out.append("%")
            index += 1
            continue
        }

        var leftAlign = false
        while index < characters.count, characters[index] == "-" {
            leftAlign = true
            index += 1
        }

        var width = 0
        while index < characters.count, let digit = asciiDigit(characters[index]) {
            width = width * 10 + digit
            index += 1
        }

        var precision: Int?
        if index < characters.count, characters[index] == "." {
            index += 1
            var places = 0
            while index < characters.count, let digit = asciiDigit(characters[index]) {
                places = places * 10 + digit
                index += 1
            }
            precision = places
        }

        precondition(index < characters.count, "format: the format string ends inside a specifier")
        let conversion = characters[index]
        index += 1

        precondition(nextArg < args.count, "format: too few arguments for \(fmt)")
        let value = args[nextArg].formatValue
        nextArg += 1

        switch conversion {
        case "i", "d":
            guard case .integer(let number) = value else {
                preconditionFailure("format: %\(conversion) needs an integer argument")
            }
            out += pad(
                String(number),
                width: width,
                leftAlign: leftAlign
            )

        case "s":
            guard case .text(let text) = value else {
                preconditionFailure("format: %s needs a text argument")
            }
            let cut = precision.map { String(text.prefix($0)) } ?? text
            out += pad(
                cut,
                width: width,
                leftAlign: leftAlign
            )

        case "c":
            guard case .integer(let number) = value else {
                preconditionFailure("format: %c needs an integer argument")
            }
            let scalar = UnicodeScalar(UInt8(truncatingIfNeeded: number))
            out += pad(
                String(Character(scalar)),
                width: width,
                leftAlign: leftAlign
            )

        case "f":
            guard case .floating(let number) = value else {
                preconditionFailure("format: %f needs a floating argument")
            }
            let fixed = fixedText(number, precision: precision ?? 6)
            out += pad(
                fixed,
                width: width,
                leftAlign: leftAlign
            )

        default:
            preconditionFailure("format: %\(conversion) is not a specifier this port supports")
        }
    }

    return out
}

// MARK: - Padding

/// This reads one ASCII digit, and gives `nil` for every other character.
private func asciiDigit(_ character: Character) -> Int? {
    guard character.isASCII, character.isNumber else { return nil }
    return character.wholeNumberValue
}

/// This pads `text` with spaces up to `width`, on the left, or on the right when the `-` flag is set.
/// Text at or past the width passes through whole, because C's width is a minimum and never truncates.
private func pad(_ text: String, width: Int, leftAlign: Bool) -> String {
    let deficit = width - text.count
    guard deficit > 0 else { return text }
    let spaces = String(repeating: " ", count: deficit)
    return leftAlign ? text + spaces : spaces + text
}

// MARK: - Fixed-point text

/// This prints `value` with exactly `precision` places after the point, C's `%f`.
/// The digits come from the double's exact value and round half away from zero, so `2.675` prints as `2.67` the way C prints it.
private func fixedText(_ value: Double, precision: Int) -> String {
    if value.isNaN {
        return "nan"
    }
    if value.isInfinite {
        return value.sign == .minus ? "-inf" : "inf"
    }

    let sign = value.sign == .minus ? "-" : ""
    var (digits, scale) = exactDecimalDigits(of: value.magnitude)

    // A value under 1 has fewer digits than its scale, and the high zeros must be there before the rounding reads a digit.
    while digits.count <= scale {
        digits.append(0)
    }

    if scale > precision {
        let drop = scale - precision
        // The first dropped digit decides the rounding, and a 5 with any tail rounds away from zero.
        let roundUp = digits[drop - 1] >= 5
        digits.removeFirst(drop)
        scale = precision
        if roundUp {
            carryOne(into: &digits)
        }
    } else if scale < precision {
        digits.insert(
            contentsOf: repeatElement(0, count: precision - scale),
            at: 0
        )
        scale = precision
    }

    // The integer part needs one digit of its own, even when the value is under 1.
    while digits.count <= scale {
        digits.append(0)
    }

    let wholeDigits = digits[scale...].reversed()
    let fractionDigits = digits[..<scale].reversed()
    var text = sign
    for digit in wholeDigits {
        text.append(Character(UnicodeScalar(UInt8(ascii: "0") + digit)))
    }
    if precision > 0 {
        text.append(".")
        for digit in fractionDigits {
            text.append(Character(UnicodeScalar(UInt8(ascii: "0") + digit)))
        }
    }
    return text
}

/// This adds one to the low digit, and carries through the higher digits.
private func carryOne(into digits: inout [UInt8]) {
    var position = 0
    var carry: UInt8 = 1
    while carry > 0 {
        if position == digits.count {
            digits.append(0)
        }
        let sum = digits[position] + carry
        digits[position] = sum % 10
        carry = sum / 10
        position += 1
    }
}

/// This gives a positive double's exact decimal digits, low digit first, with the count of digits that sit after the point.
/// A double is `m * 2^e`, and for a negative `e` that is `m * 5^-e` scaled by `10^e`, so the expansion stays exact and needs no division.
private func exactDecimalDigits(of magnitude: Double) -> (digits: [UInt8], scale: Int) {
    let fraction = magnitude.significandBitPattern
    let biasedExponent = magnitude.exponentBitPattern

    var mantissa: UInt64
    var exponent: Int
    if biasedExponent == 0 {
        // A subnormal value, and a zero, carry no implicit leading bit.
        mantissa = fraction
        exponent = -1074
    } else {
        mantissa = fraction | (UInt64(1) << 52)
        exponent = Int(biasedExponent) - 1075
    }

    var digits = decimalDigits(of: mantissa)
    if exponent >= 0 {
        for _ in 0..<exponent {
            digits = multiply(digits, by: 2)
        }
        return (digits, 0)
    }

    let scale = -exponent
    for _ in 0..<scale {
        digits = multiply(digits, by: 5)
    }
    return (digits, scale)
}

/// This spreads a 64-bit value over decimal digits, low digit first.
private func decimalDigits(of value: UInt64) -> [UInt8] {
    guard value > 0 else { return [0] }
    var digits: [UInt8] = []
    var rest = value
    while rest > 0 {
        digits.append(UInt8(rest % 10))
        rest /= 10
    }
    return digits
}

/// This multiplies a low-digit-first decimal number by a one-digit factor.
private func multiply(_ digits: [UInt8], by factor: Int) -> [UInt8] {
    var result: [UInt8] = []
    result.reserveCapacity(digits.count + 1)
    var carry = 0
    for digit in digits {
        let product = Int(digit) * factor + carry
        result.append(UInt8(product % 10))
        carry = product / 10
    }
    while carry > 0 {
        result.append(UInt8(carry % 10))
        carry /= 10
    }
    return result
}
