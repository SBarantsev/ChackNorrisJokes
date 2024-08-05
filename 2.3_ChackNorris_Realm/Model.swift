//
//  Model.swift
//  2.3_ChackNorris_Realm
//
//  Created by Sergey on 31.07.2024.
//

import Foundation
import RealmSwift

class Joke: Object {
    @Persisted var id: String = ""
    @Persisted var jokeText: String = ""
    @Persisted var jokeLoadDate: Date = Date()
    @Persisted var jokeCategories: String
    @Persisted var categories = List<Category>()
}

class Category: Object {
    @Persisted var nameCategory: String = ""
    @Persisted(originProperty: "categories") var jokes: LinkingObjects<Joke>
}

