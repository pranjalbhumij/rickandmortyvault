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
    
    var body: some View {
        VStack (alignment: .leading) {
            AsyncImage(url: character.image) { image in
                image.resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            Text("Name: \(character.name!)").font(.headline)
            Text("Gender: \(character.gender!)").font(.subheadline)
            Text("Species: \(character.species!)").font(.subheadline)
            Text("Status: \(character.status!)").font(.subheadline)
            HStack {
                Text("Episode: ")
                ForEach(viewModel.episodeNames, id: \.self) { episodeName in
                                    Text(episodeName)
                                        .font(.subheadline)
                                }
            }
            Text("Location: \(character.location!.name!)").font(.subheadline)
            Text("Origin: \(character.origin!.name!)").font(.subheadline)
            Text("Type: \(character.type!)").font(.subheadline)
            Text("Created: \(character.created!)").font(.subheadline)
            Spacer()
        }.padding()
            .task {
                await viewModel.fetchEpisodeNames(from: character.episode!)
            }
    }
}

#Preview {
    CharacterDetailView(character: ModelData.character.results![0])
}
