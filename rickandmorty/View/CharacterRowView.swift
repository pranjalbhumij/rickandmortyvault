//
//  CharacterRowView.swift
//  rickandmorty
//
//  Created by Baba Yaga on 26/12/24.
//

import SwiftUI

struct CharacterRowView: View {
    @State var character: Character
    
    var body: some View {
        HStack {
            AsyncImage(url: character.image!) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .frame(width: 100, height: 100)
            } placeholder: {
                ProgressView()
            }
            Text(character.name!)
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.3)
                .truncationMode(.tail)
            Spacer()
        }
    }
}

#Preview {
    return CharacterRowView(character: ModelData.character.results![0])
}
