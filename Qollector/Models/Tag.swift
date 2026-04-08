import Foundation
import SwiftData

@Model
final class Tag {
    var name: String
    var normalizedName: String
    var colorTokenRawValue: String
    @Relationship(inverse: \RecordItem.tags) var records: [RecordItem]

    init(name: String, normalizedName: String, colorToken: VinylColorToken = .mint) {
        self.name = name
        self.normalizedName = normalizedName
        self.colorTokenRawValue = colorToken.rawValue
        self.records = []
    }

    var colorToken: VinylColorToken {
        get { VinylColorToken(rawValue: colorTokenRawValue) ?? .mint }
        set { colorTokenRawValue = newValue.rawValue }
    }
}

