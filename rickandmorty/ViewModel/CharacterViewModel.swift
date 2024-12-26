//
//  CharacterViewModel.swift
//  rickandmorty
//
//  Created by Baba Yaga on 26/12/24.
//

import Foundation

class CharacterViewModel: ObservableObject {
    @Published var episodeNames: [String] = []
    
    func fetchEpisodeNames(from urls: [String]) async {
            do {
                let episodes = try await withThrowingTaskGroup(of: (String, String).self) { group -> [(String, String)] in
                    for url in urls {
                        group.addTask {
                            guard let url = URL(string: url) else { throw URLError(.badURL) }
                            let (data, _) = try await URLSession.shared.data(from: url)
                            let episode = try JSONDecoder().decode(Episode.self, from: data)
                            return (url.absoluteString, episode.episode)
                        }
                    }

                    var results: [(String, String)] = []
                    for try await result in group {
                        results.append(result)
                    }
                    return results
                }

                DispatchQueue.main.async {
                    self.episodeNames = episodes.sorted(by: { urls.firstIndex(of: $0.0)! < urls.firstIndex(of: $1.0)! }).map { $0.1 }
                }
            } catch {
                print("Failed to fetch episodes: \(error)")
            }
        }
}
