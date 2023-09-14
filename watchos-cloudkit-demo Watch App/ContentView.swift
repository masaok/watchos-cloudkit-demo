//
//  ContentView.swift
//  watchos-cloudkit-demo Watch App
//

import SwiftUI

struct ContentView: View {
    
    @State private var items: [Item] = []
    let cloudKitHelper = CloudKitHelper()
    
    var body: some View {
        List(items, id: \.id) { item in
            Text(item.name)
        }
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        cloudKitHelper.fetchItems { fetchedItems in
            items = fetchedItems
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
