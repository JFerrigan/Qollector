//
//  VinylCollectorTests.swift
//  VinylCollectorTests
//
//  Created by Jake Ferrigan on 4/7/26.
//

import Testing
@testable import VinylCollector

struct VinylCollectorTests {

    @Test func iconRecipeFactoryIsCaseInsensitive() async throws {
        let first = RecordIconRecipeFactory.makeRecipe(title: "Discovery", artist: "Daft Punk")
        let second = RecordIconRecipeFactory.makeRecipe(title: " discovery ", artist: "DAFT PUNK")

        #expect(first == second)
    }

    @Test func tagNormalizationCollapsesDuplicates() async throws {
        let names = RecordEditor.resolvedTagsPreviewNames(from: "Jazz, jazz,  JAZZ , Favorites")
        #expect(names == ["favorites", "jazz"])
    }

}
