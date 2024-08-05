//
//  ItemsManager.swift
//  2.3_ChackNorris_Realm
//
//  Created by Sergey on 31.07.2024.
//

import Foundation
import RealmSwift
import KeychainSwift

class ItemsManager {
    
    static let shared = ItemsManager()
    var jokes: [Joke] = []
    var categories: [Category] = []
    
    
    private init() {
        
        let defaultConfig = Realm.Configuration(encryptionKey: getKey(), schemaVersion: 3)
        Realm.Configuration.defaultConfiguration = defaultConfig
            
            fetchFolders()
            fetchCategories()
    }
    
    private func getKey() -> Data {
        if let key = KeychainSwift().getData("RealmKey") {
            return key
        }
        var key = Data(count: 64)
        _ = key.withUnsafeMutableBytes { (pointer: UnsafeMutableRawBufferPointer) in
            SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!) }
        
        KeychainSwift().set(key, forKey: "RealmKey")
        
        return key
    }
    
    func addJoke(joke: JokeCodable) {
        let realm = try! Realm()
        
        try? realm.write {
            let newJoke = Joke()
            
            newJoke.id = joke.id
            newJoke.jokeText = joke.value
            newJoke.jokeLoadDate = Date()
            
            if joke.categories.isEmpty {
                let category = self.getCategory(name: "without category")
                newJoke.categories.append(category)
            } else {
                for jokeName in joke.categories {
                    let category = self.getCategory(name: jokeName)
                    newJoke.categories.append(category)
                }
            }
            realm.add(newJoke)
        }
        fetchFolders()
        fetchCategories()
    }
    
    func fetchFolders() {
        let realm = try! Realm()
        let jokes = realm.objects(Joke.self)
        self.jokes = jokes.map{ $0 }
    }
    
    func deleteFolder(atIndex index: Int) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(jokes[index])
        }
        
        fetchFolders()
        fetchCategories()
    }
    
    func getCategory(name: String) -> Category {
        let realm = try! Realm()
        let categories = realm.objects(Category.self)
        
        if let category = categories.map({ $0 }).filter({$0.nameCategory == name}).first {
            return category
        }
        let category = Category()
        category.nameCategory = name
        
        return category
    }
    
    func fetchCategories() {
        let realm = try! Realm()
        let categories = realm.objects(Category.self)
        self.categories = categories.map{$0}
    }
}

extension ItemsManager {
    var sortedJokes: [Joke] {
        return jokes.sorted(by: {$0.jokeLoadDate > $1.jokeLoadDate})
    }
}


