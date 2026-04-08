import Foundation

extension RecordEditor {
    static func resolvedTagsPreviewNames(from tagsText: String) -> [String] {
        tagsText
            .split(separator: ",")
            .map { normalizedTagName(String($0)) }
            .filter { !$0.isEmpty }
            .reduce(into: Set<String>()) { result, name in
                result.insert(name)
            }
            .sorted()
    }
}

