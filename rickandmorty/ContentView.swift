//
//  ContentView.swift
//  rickandmorty
//
//  Created by Baba Yaga on 26/12/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm: RMViewModel
    @State private var showMoveToTopButton = false
    
    init(viewModel: RMViewModel) {
        self._vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ZStack {
                    mainScrollView()
                    if showMoveToTopButton {
                        moveToTopButton(proxy: proxy)
                    }
                }
                .navigationTitle("Characters")
                .toolbar {
                    ToolbarItem(placement: .principal){
                        toolbarContent
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func mainScrollView() -> some View {
        ScrollView {
            GeometryReader { geometry in
                Color.clear
                    .onChange(of: geometry.frame(in: .global).minY) { oldOffset, newOffset in
                        showMoveToTopButton = newOffset < -200
                    }
            }
            .frame(height: 0)
            
            characterList
                .navigationDestination(for: Character.self) { character in
                    CharacterDetailView(character: character)
                }
        }
        .task(id: vm.currentPage) {
            await vm.fetchCharacters()
        }
    }
    
    private var characterList: some View {
        LazyVStack {
            ForEach(vm.characters, id: \.id) { character in
                characterRow(character)
                    .id(character.id)
            }
        }
    }
    
    private func characterRow(_ character: Character) -> some View {
        ZStack {
            NavigationLink(value: character) {
                CharacterRowView(character: character)
                    .padding(.horizontal)
                    .onAppear {
                        if character.id == vm.characters.last?.id {
                            vm.loadNextPage()
                        }
                    }
            }
        }
    }
    
    private func moveToTopButton(proxy: ScrollViewProxy) -> some View {
        Button("Move to Top") {
            withAnimation(.easeIn(duration: 1.0)) {
                proxy.scrollTo(vm.characters.first?.id ?? 1)
            }
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(Capsule())
        .shadow(radius: 5)
        .transition(.opacity)
        .animation(.easeInOut, value: showMoveToTopButton)
        .position(x: UIScreen.main.bounds.width - 80, y: UIScreen.main.bounds.height - 200)
    }
    
    private var toolbarContent: some View {
        Text("Rick and Morty")
            .font(.headline)
            .multilineTextAlignment(.center)
            .lineLimit(2)
    }
}




#Preview {
    ContentView(viewModel: RMViewModel())
}
