//
//  ContentView.swift
//  CollectionViewTrain_v2
//
//  Created by Daiki Takano on 2023/05/22.
//

import SwiftUI
import SwiftUISnapDraggingModifier

struct ContentView: View {
    // 1. Number of items will be display in row
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    // 2. Fixed height of card
    let height: CGFloat = 180
    // 3. Get mock cards data
    let cards: [Card] = MockStore.cards
    
    var isLeftItem: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                // 4. Populate into grid
                
                LazyVGrid(columns: columns, spacing: 36) {
                    ForEach(cards) { card in
                        NavigationLink(
                            destination: DetailView(card: card),
                            label: {
                                CardView(title: card.title)
                                    .frame(height: height)
                                    .modifier(
                                        SnapDraggingModifier(
                                            axis: [.horizontal],
                                            horizontalBoundary: .init(min: 0, max: .infinity, bandLength: 60),
                                            handler: .init(
                                                onStartDragging: {
                                                    
                                                },
                                                
                                                onEndDragging: { velocity, offset, contentSize in
                                                    
                                                    print(
                                                    """
                                                        Velocity: \(velocity),
                                                        Offset: \(offset),
                                                        contentSize: \(contentSize)
                                                    """)
                                                    
                                                    if velocity.dx < -50 || offset.width > contentSize.width {
                                                        print("remove")
                                                        return .init(width: -contentSize.width-220, height: 0)
                                                    } else {
                                                        print("stay")
                                                        return .zero
                                                    }
                                                    
                                                })
                                        )
                                    )
                            })
                    }
                }
                .padding()
            }
            .refreshable {
                await Task.sleep(1000000000)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

let people = ["girl", "boy"]

struct CardView: View {
    let title: String
    var body: some View {
        VStack {
            Image(people[Int.random(in: 0..<2)])
                .resizable()
                .aspectRatio(contentMode: .fit)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 5)
                        .foregroundColor(.random)
                }
            Text(title)
                .font(.title2)
        }
        
    }
}

struct Card: Identifiable {
    let id = UUID()
    let title: String
}

struct MockStore {
    static var cards = [
        Card(title: "Italy"),
        Card(title: "England"),
        Card(title: "Portugal"),
        Card(title: "Belgium"),
        Card(title: "Germany"),
        Card(title: "Mexico"),
        Card(title: "Canada"),
        Card(title: "Italy"),
        Card(title: "England"),
        Card(title: "Portugal"),
        Card(title: "Belgium"),
        Card(title: "Germany"),
        Card(title: "Mexico"),
        Card(title: "Canada"),
        Card(title: "England"),
        Card(title: "Portugal"),
        Card(title: "Belgium"),
        Card(title: "Germany"),
        Card(title: "Mexico"),
        Card(title: "Canada"),
    ]
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

struct RefreshableModifier: ViewModifier {
    let action: @Sendable () async -> Void
    
    func body(content: Content) -> some View {
        List {
            HStack {
                Spacer()
                content
                Spacer()
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
        }
        .refreshable (action: action)
        .listStyle(PlainListStyle())
    }
}

extension ScrollView {
    func refreshable(action: @escaping @Sendable () async -> Void) -> some View {
        modifier(RefreshableModifier(action: action))
    }
}
