//
//  ModelData.swift
//  rickandmorty
//
//  Created by Baba Yaga on 26/12/24.
//

import Foundation

class ModelData {
    static var character: CharacterResponse = load()
}

func load<T: Decodable>() -> T {
    guard let file = Bundle.main.url(forResource: "character_data.json", withExtension: nil) else {
        fatalError("failed to load file")
    }
    do {
        let data = try Data(contentsOf: file)
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    } catch {
        fatalError("failed to decode: \(error)")
    }
}
