import Foundation

// generate-tokens
//
// Reads Tokens/tokens.json (the W3C-ish token file) and emits
// Sources/ParadoxTokens/Generated/Tokens.generated.swift.
//
// Run from the repo root:
//   swift run generate-tokens
//
// Output is deterministic (stable key ordering) so diffs are reviewable.

// MARK: - Paths

let fm = FileManager.default
let cwd = fm.currentDirectoryPath
let repoRoot = URL(fileURLWithPath: cwd)
let tokensJSON = repoRoot.appendingPathComponent("Tokens/tokens.json")
let outFile = repoRoot.appendingPathComponent("Sources/ParadoxTokens/Generated/Tokens.generated.swift")

guard fm.fileExists(atPath: tokensJSON.path) else {
    FileHandle.standardError.write(Data("error: \(tokensJSON.path) not found. Run from repo root.\n".utf8))
    exit(2)
}

let data: Data
do {
    data = try Data(contentsOf: tokensJSON)
} catch {
    FileHandle.standardError.write(Data("error: failed to read tokens.json: \(error)\n".utf8))
    exit(2)
}

let root: [String: Any]
do {
    guard let parsed = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        throw NSError(domain: "generate-tokens", code: 1, userInfo: [NSLocalizedDescriptionKey: "tokens.json root must be an object"])
    }
    root = parsed
} catch {
    FileHandle.standardError.write(Data("error: failed to parse tokens.json: \(error)\n".utf8))
    exit(2)
}

// MARK: - Helpers

func camel(_ parts: [String]) -> String {
    guard let first = parts.first?.lowercased() else { return "" }
    let rest = parts.dropFirst().map { $0.prefix(1).uppercased() + $0.dropFirst() }
    return ([first] + rest).joined()
}

func flatten(_ node: [String: Any], path: [String] = []) -> [(name: [String], type: String, value: Any)] {
    var out: [(name: [String], type: String, value: Any)] = []
    let keys = node.keys.sorted()
    for key in keys {
        let v = node[key]!
        if key.hasPrefix("$") { continue } // metadata
        if let dict = v as? [String: Any] {
            if let type = dict["$type"] as? String, let value = dict["$value"] {
                out.append((path + [key], type, value))
            } else {
                out.append(contentsOf: flatten(dict, path: path + [key]))
            }
        }
    }
    return out
}

// MARK: - Emit

var lines: [String] = []
lines.append("// MARK: - Auto-generated. Do not edit by hand.")
lines.append("//")
lines.append("// Source: Tokens/tokens.json")
lines.append("// Generator: swift run generate-tokens")
lines.append("//")
lines.append("// To regenerate:")
lines.append("//   swift run generate-tokens")
lines.append("")

// Colors
let allTokens = flatten(root)
let colorTokens = allTokens.filter { $0.type == "color" }
if !colorTokens.isEmpty {
    lines.append("/// Generated color tokens. Internal to ParadoxTokens — apps should never reference")
    lines.append("/// these directly. Use semantic roles on `ParadoxTheme.color` instead.")
    lines.append("public enum GeneratedColor {")
    lines.append("    public typealias Pair = (light: String, dark: String)")
    lines.append("")
    for token in colorTokens {
        // token.name = ["color", "background", "primary"]
        let varName = camel(Array(token.name.dropFirst()))   // backgroundPrimary
        guard let valDict = token.value as? [String: Any],
              let light = valDict["light"] as? String,
              let dark = valDict["dark"] as? String else { continue }
        lines.append("    public static let \(varName): Pair = (\"\(light)\", \"\(dark)\")")
    }
    lines.append("}")
    lines.append("")
}

// Dimensions: emit grouped by top-level key (spacing, radius)
let dimensionTokens = allTokens.filter { $0.type == "dimension" }
let dimensionGroups = Dictionary(grouping: dimensionTokens, by: { $0.name.first ?? "" })
for groupKey in dimensionGroups.keys.sorted() {
    guard let tokens = dimensionGroups[groupKey] else { continue }
    let enumName = "Generated" + groupKey.prefix(1).uppercased() + groupKey.dropFirst()
    lines.append("/// Generated \(groupKey) tokens.")
    lines.append("public enum \(enumName) {")
    for token in tokens.sorted(by: { $0.name.joined() < $1.name.joined() }) {
        let varName = camel(Array(token.name.dropFirst()))
        let num: Double
        if let n = token.value as? NSNumber { num = n.doubleValue }
        else if let s = token.value as? String, let d = Double(s) { num = d }
        else { continue }
        lines.append("    public static let \(varName): Double = \(num)")
    }
    lines.append("}")
    lines.append("")
}

let output = lines.joined(separator: "\n")
do {
    try output.write(to: outFile, atomically: true, encoding: .utf8)
    print("wrote \(outFile.path) (\(colorTokens.count) colors, \(dimensionTokens.count) dimensions)")
} catch {
    FileHandle.standardError.write(Data("error: failed to write output: \(error)\n".utf8))
    exit(2)
}
