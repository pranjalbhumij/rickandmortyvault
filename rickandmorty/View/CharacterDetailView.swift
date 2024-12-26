//
//  SwiftUIView.swift
//  rickandmorty
//
//  Created by Baba Yaga on 26/12/24.
//

import SwiftUI

struct CharacterDetailView: View {
    @State var character: Character
    @StateObject var viewModel = CharacterViewModel()

    let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 6)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: character.image) { image in
                    image.resizable()
                        .frame(height:300)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }

                Text("Name: \(character.name!)").font(.headline)
                Text("Gender: \(character.gender!)").font(.subheadline)
                Text("Species: \(character.species!)").font(.subheadline)
                Text("Status: \(character.status!)").font(.subheadline)

                Text("Episodes:")
                    .font(.subheadline)
                if viewModel.episodeNames.isEmpty {
                    Text("Loading episodes...")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(viewModel.episodeNames, id: \.self) { episodeName in
                            Text(episodeName)
                                .font(.caption2)
                                .padding(4)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }

                Text("Location: \(character.location!.name!)").font(.subheadline)
                Text("Origin: \(character.origin!.name!)").font(.subheadline)
                Text("Created: \(character.created!)").font(.subheadline)

                Spacer()
            }
            .padding()
        }
        .task {
            await viewModel.fetchEpisodeNames(from: character.episode!)
        }
    }
}


#Preview {
    CharacterDetailView(character: ModelData.character.results![0])
}
