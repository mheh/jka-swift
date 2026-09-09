/// This traps on an unported function, and names the Raven subject and its oracle cite.
/// Rule 14 pairs every call with a `// TODO: Port <subject>` marker on the line above.
public func portMissing(_ subject: String, source: String) -> Never {
    fatalError("TODO: Port \(subject), source: \(source)")
}
