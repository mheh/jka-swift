import Foundation

/// This type reads the Oracle goldens and fixtures out of `Bundle.module`.
/// We keep the file lookup in one place, so a test names a golden or a fixture by its relative path and nothing else.
public enum OracleData {
    /// This reads `Oracle/golden/<name>.txt` as UTF-8 text.
    public static func golden(_ name: String) throws -> String {
        try self.text(at: "golden/\(name).txt")
    }

    /// This reads `Oracle/fixtures/<path>` as UTF-8 text.
    public static func fixture(_ path: String) throws -> String {
        try self.text(at: "fixtures/\(path)")
    }

    /// This reads `Oracle/fixtures/<path>` as raw bytes, for a binary fixture.
    public static func fixtureData(_ path: String) throws -> Data {
        try Data(contentsOf: self.url(at: "fixtures/\(path)"))
    }
}

// MARK: - Resolution

extension OracleData {
    private static func text(at relativePath: String) throws -> String {
        try String(contentsOf: self.url(at: relativePath), encoding: .utf8)
    }

    private static func url(at relativePath: String) throws -> URL {
        let url = Bundle.module.resourceURL?
            .appendingPathComponent("Oracle", isDirectory: true)
            .appendingPathComponent(relativePath, isDirectory: false)
        guard let url, FileManager.default.fileExists(atPath: url.path) else {
            throw OracleDataError.missing(relativePath)
        }
        return url
    }
}

/// This is the error `OracleData` throws when a golden or a fixture is missing.
///
/// - `missing`: the bundle has no file at this relative path under `Oracle/`.
public enum OracleDataError: Error, Equatable {
    case missing(String)
}
