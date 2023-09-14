//  CloudKitHelper.swift

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
