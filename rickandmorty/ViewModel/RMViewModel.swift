//
//  RestClient.swift
//  rickandmorty
//
//  Created by Baba Yaga on 26/12/24.
//

import Foundation

class RMViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var currentPage = 1
    private var totalPages = 1
    var isLoading = false
    
    func fetchCharacters() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await URLSession.shared.data(from: URL(string: "https://rickandmortyapi.com/api/character/?page=\(currentPage)")!)
            let decodedData = try JSONDecoder().decode(CharacterResponse.self, from: response.0)
            characters.append(contentsOf: decodedData.results!)
            totalPages = decodedData.info.pages
        } catch {
            print (error)
        }
    }
    
    func getEpisode(id: String) async -> Episode {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string:"https://rickandmortyapi.com/api/episode/\(id)")!)
            return try JSONDecoder().decode(Episode.self, from: data)
        } catch {
            print (error)
            fatalError()
        }
    }
    
    func loadNextPage() {
        if canLoadMore() {
            currentPage += 1
        }
    }
    
    func canLoadMore() -> Bool {
        return currentPage <= totalPages
    }
}
