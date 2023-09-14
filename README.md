Building a watchOS app using SwiftUI with a simple CloudKit usage is an exciting venture. Here's a step-by-step guide to build a basic watchOS app that fetches data from CloudKit and displays it in a list.

### 1. Setting Up CloudKit

1. Open Xcode and create a new watchOS app with SwiftUI as its interface.
2. In the project settings, enable the iCloud capability and check CloudKit.
3. Open your CloudKit dashboard through the Xcode menu under `Product > Open CloudKit Dashboard`.
4. Create a new record type. Name it "Item" and add a field "name" of type `String`.

### 2. Fetching Data from CloudKit

Firstly, let's create a model for our item:

```swift
struct Item {
    var id: String
    var name: String
}
```

Then, create a helper class to fetch the data:

```swift
import CloudKit

class CloudKitHelper {

    let publicDatabase = CKContainer.default().publicCloudDatabase
    let privateDatabase = CKContainer.default().privateCloudDatabase

    func fetchItems(completion: @escaping ([Item]) -> ()) {
        let query = CKQuery(recordType: "Item", predicate: NSPredicate(value: true))

        publicDatabase.fetch(withQuery: query, inZoneWith: nil, desiredKeys: ["name"], resultsLimit: 50) { result in
            switch result {
            case .success(let data):
                let items = data.matchResults.compactMap { (recordID, recordResult) -> Item? in
                    switch recordResult {
                    case .success(let record):
                        let name = record["name"] as? String ?? ""
                        return Item(id: record.recordID.recordName, name: name)
                    case .failure:
                        return nil
                    }
                }

                DispatchQueue.main.async {
                    completion(items)
                }

            case .failure(let error):
                // Handle the error appropriately
                print("Error fetching records: \(error)")
            }
        }
    }
}
```

### 3. Displaying in SwiftUI

Now, let's create our SwiftUI view:

```swift
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
```

### 4. Test Your App

1. Before you run, ensure you're logged into iCloud on your simulator or physical device.
2. Run your app on the watchOS simulator.
3. Use CloudKit Dashboard to create new "Item" records.
4. Your app should display those records when it's run.

Note: This example assumes a simple structure and doesn't handle potential errors or issues with CloudKit. In a real-world app, you'd need to incorporate error handling, pagination (if there's a lot of data), and possibly a way to refresh data, among other features.
