//
//  SavedArticlesStore.swift
//  TechBrief
//
//  Created by Maria on 18.11.2025.
//

import Foundation

final class SavedArticlesStore {
    private let key = "savedArticleIDs"
    private let defaults = UserDefaults.standard

    var savedIDs: Set<String> {
        get {
            let array = defaults.stringArray(forKey: key) ?? []
            return Set(array)
        }
        set {
            defaults.set(Array(newValue), forKey: key)
        }
    }

    func toggle(id: String) {
        var ids = savedIDs
        if ids.contains(id) {
            ids.remove(id)
        } else {
            ids.insert(id)
        }
        savedIDs = ids
    }

    func isSaved(_ id: String) -> Bool {
        savedIDs.contains(id)
    }
}
