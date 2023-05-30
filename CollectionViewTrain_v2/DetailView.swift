//
//  DetailView.swift
//  CollectionViewTrain_v2
//
//  Created by Daiki Takano on 2023/05/22.
//

import SwiftUI

import SwiftUI

struct DetailView: View {
    var card: Card
    
    var body: some View {
        VStack {
            Text(card.title)
            //Text(card.id)
        }
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView()
//    }
//}
