//
//  QollectorTests.swift
//  QollectorTests
//
//  Created by Jake Ferrigan on 4/7/26.
//

import Testing
@testable import Qollector

struct QollectorTests {

    @Test func iconRecipeFactoryIsCaseInsensitive() async throws {
        let first = RecordIconRecipeFactory.makeRecipe(title: "Discovery", artist: "Daft Punk")
        let second = RecordIconRecipeFactory.makeRecipe(title: " discovery ", artist: "DAFT PUNK")

        #expect(first == second)
    }

    @Test func tagNormalizationCollapsesDuplicates() async throws {
        let names = RecordEditor.resolvedTagsPreviewNames(from: "Jazz, jazz,  JAZZ , Favorites")
        #expect(names == ["favorites", "jazz"])
    }

    @Test func starFillMappingSupportsHalfSteps() async throws {
        #expect(starFillStates(for: 1) == [.half, .empty, .empty, .empty, .empty])
        #expect(starFillStates(for: 2) == [.full, .empty, .empty, .empty, .empty])
        #expect(starFillStates(for: 5) == [.full, .full, .half, .empty, .empty])
        #expect(starFillStates(for: 9) == [.full, .full, .full, .full, .half])
        #expect(starFillStates(for: 10) == [.full, .full, .full, .full, .full])
    }

    @Test func starRatingClampsOutOfRangeValues() async throws {
        #expect(StarRatingValue.clamped(-4) == 1)
        #expect(StarRatingValue.clamped(17) == 10)
        #expect(starFillStates(for: -4) == [.half, .empty, .empty, .empty, .empty])
        #expect(starFillStates(for: 17) == [.full, .full, .full, .full, .full])
    }

    @Test func ratingLabelsMatchStoredValue() async throws {
        #expect(StarRatingValue.tenPointLabel(for: 3) == "3/10")
        #expect(StarRatingValue.accessibilityLabel(for: 3) == "1.5 stars")
    }

    private func starFillStates(for ratingValue: Int) -> [StarFillState] {
        (1...StarRatingValue.starCount).map { StarRatingValue.fillState(for: $0, ratingValue: ratingValue) }
    }

}
