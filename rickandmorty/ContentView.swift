//
//  ContentView.swift
//  rickandmorty
//
//  Created by Baba Yaga on 26/12/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm: RMViewModel
    
    init(viewModel: RMViewModel) {
        self._vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(vm.characters, id: \.id) { character in
                        ZStack {
                            NavigationLink(value: character){
                                CharacterRowView(character: character)
                                    .padding(.horizontal)
                                    .onAppear() {
                                        if character.id == vm.characters.last?.id {
                                            vm.loadNextPage()
                                        }
                                    }
                            }
     
                        }
                    }
                }
                .navigationDestination(for: Character.self){ value in
                    CharacterDetailView(character: value)
                }
                .scrollTargetLayout()
            }
            .task(id: vm.currentPage) {
                await vm.fetchCharacters()
            }
            .navigationTitle("Characters")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Rick and Morty")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
        }
    }
}

#Preview {
    ContentView(viewModel: RMViewModel())
}
