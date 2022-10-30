//
//  JsonCodableArray.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 03/05/2022.
//

import SwiftUI
import AppFoundation
import FileAndFolder
import Files

protocol Ordered {
    static func < (lhs: Self, rhs: Self) -> Bool
}

public final class JsonCodableArray<E>: ObservableObject, JsonCodableToFolderP where
E: Codable,
E: Identifiable,
E: CustomStringConvertible {

    private enum CodingKeys: String, CodingKey {
        case items
    }

    // MARK: - Type Properties

    static var exemple: JsonCodableArray {
        JsonCodableArray()
    }

    // MARK: - Type Methods

    public static func loadFromJSON(for aClass: AnyClass) -> JsonCodableArray {
        let classBundle = Bundle(for: aClass)
        return classBundle.loadFromJSON(JsonCodableArray.self,
                                        from                 : String(describing: E.self) + ".json",
                                        dateDecodingStrategy : .iso8601,
                                        keyDecodingStrategy  : .useDefaultKeys)
    }

    public static func loadFromJSON(fromBundle bundle: Bundle) -> JsonCodableArray {
        return bundle.loadFromJSON(JsonCodableArray.self,
                                   from                 : String(describing: E.self) + ".json",
                                   dateDecodingStrategy : .iso8601,
                                   keyDecodingStrategy  : .useDefaultKeys)
    }

    // MARK: - Properties

    @Published
    public var items: [E] = [ ]

    public var nbOfItems: Int {
        items.count
    }

    // MARK: - Subscript

    /// Permet de sauvegarder l'objet au moment de l'affectation d'une nouvelle valeur
    public subscript(idx: Int) -> E {
        get {
            return items[idx]
        }
        set(newValue) {
            items[idx] = newValue
            saveAsJSON()
        }
    }

    // MARK: - Initializers

    /// Initialiser à vide
    public init() { }

    /// Initialiser à partir d'un fichier JSON portant le nom de la Class `E`
    /// contenu dans le dossier `fromFolder` du répertoire `Documents`.
    ///
    /// Si fromFolder = nil alors les fichiers JSON sont cherchés à la racines du répertoire `Documents`
    ///
    /// - Parameter fromFolder: dossier du répertoire `Documents` où se trouve le fichier JSON à utiliser
    ///
    public convenience init(fromFolder: Folder?) {
        var folder: Folder

        if let fromFolder {
            folder = fromFolder

        } else if let documentsFolder = Folder.documents {
            folder = documentsFolder

        } else {
            self.init()
            AppState.shared.initError = .failedToLoadUserData
            return
        }
        do {
            // charger les données JSON
            try self.init(fromFile             : String(describing: E.self) + ".json",
                          fromFolder           : folder,
                          dateDecodingStrategy : .iso8601,
                          keyDecodingStrategy  : .useDefaultKeys)
        } catch {
            AppState.shared.initError = .failedToLoadUserData
            self.init()
        }
    }

    // MARK: - Methods

    func clear() {
        self.items = []
        saveAsJSON()
    }

    /// Initialiser à partir d'un fichier JSON portant le nom de la Class `E`
    /// contenu dans le dossier `fromFolder` du répertoire `Documents`.
    ///
    /// Si fromFolder = nil alors les fichiers JSON sont cherchés à la racines du répertoire `Documents`
    ///
    /// - Parameter fromFolder: dossier du répertoire `Documents` où se trouve le fichier JSON à utiliser
    ///
    public func loadFromJSON(fromFolder: Folder?) throws {
        var folder: Folder

        if let fromFolder {
            folder = fromFolder

        } else if let documentsFolder = Folder.documents {
            folder = documentsFolder

        } else {
            throw FileError.failedToReadFile
        }

        do {
            // charger les données JSON
            let copy = try self.loadFromJSON(fromFile             : String(describing: E.self) + ".json",
                                             fromFolder           : folder,
                                             dateDecodingStrategy : .iso8601,
                                             keyDecodingStrategy  : .useDefaultKeys)
            self.items = copy.items
        } catch {
            throw FileError.failedToReadFile
        }
    }

    /// Enregistrer au format JSON dans un fichier JSON portant le nom de la Class `E`
    /// dans le folder nommé `toFolder` du répertoire `Documents`
    /// - Parameters:
    ///   - toFolder: nom du dossier du répertoire `Documents`
    public func saveAsJSON() {
        // encode to JSON file
        if let documentsFolder = Folder.documents {
            do {
                try saveAsJSON(toFile               : String(describing: E.self) + ".json",
                               toFolder             : documentsFolder,
                               dateEncodingStrategy : .iso8601,
                               keyEncodingStrategy  : .useDefaultKeys)
            } catch {
                print("Failed to save object to \(String(describing: E.self) + ".json")")
            }
        }
    }

    public func storeItemsToBundleOf(aClass: AnyClass) {
        let bundle = Bundle(for: aClass)
        // encode to JSON file
        bundle.saveAsJSON(self,
                          to                   : String(describing: E.self) + ".json",
                          dateEncodingStrategy : .iso8601,
                          keyEncodingStrategy  : .useDefaultKeys)
    }

    public func move(from indexes   : IndexSet,
                     to destination : Int) {
        items.move(fromOffsets: indexes, toOffset: destination)
        saveAsJSON()
    }

    public func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        saveAsJSON()
    }

    public func add(_ item: E) {
        items.insert(item, at: 0)
        saveAsJSON()
    }

    /// Met à jour l'item de `self.items` dont l'`id` est le même que celui de `updatedItem`
    public func update(with updatedItem: E) {
        if let index = items.firstIndex(where: { $0.id == updatedItem.id }) {
            items[index] = updatedItem
            saveAsJSON()
        }
    }

    /// Met à jour tous les item de `self.items` dont l'`id` est le même que celui
    /// d'un des éléments de`updatedItems`
    public func update(with updatedItems: [E]) {
        for updatedItem in updatedItems {
            if let index = self.items.firstIndex(where: { $0.id == updatedItem.id }) {
                self.items[index] = updatedItem
            }
        }
        saveAsJSON()
    }

    /// True si un `item` existe déjà avec le même ID
    public func contains(_ item: E) -> Bool {
        items.contains(where: { item.id == $0.id})
    }

    /// True si un `item` existe déjà avec le même ID
    /// - Parameter ID: ID de l'item
    public func contains(_ ID: E.ID) -> Bool {
        items.contains(where: { ID == $0.id})
    }

    public func item(withID ID: E.ID) -> E? {
        items.first(where: { ID == $0.id})
    }

    public func itemBinding(withID ID: E.ID) -> Binding<E>? {
        if self.contains(ID) {
            return Binding<E>(
                get: {
                    self.items.first(where: { ID == $0.id})!
                },
                set: { item in
                    self.update(with: item)
                }
            )
        } else {
            return nil
        }
    }
}

extension JsonCodableArray: CustomStringConvertible {
    public var description: String {
        var str = ""
        items.forEach { item in
            str += (String(describing: item) + "\n")
        }
        return str
    }
}

extension JsonCodableArray where E: Ordered {

    /// Insérer un l'ID d'un nouvel `item` dans une liste d'IDs `itemsID`
    /// en respectant la relation d'oredre `<` définie pour les élèves.
    /// - Parameters:
    ///   - item: nouvel item à insérer
    ///   - itemsID: une liste d'IDs d'item
    func insert(item         : E,
                `in` itemsID : inout [E.ID]) {
        guard itemsID.isNotEmpty else {
            itemsID = [item.id]
            return
        }

        guard let index = itemsID.firstIndex(where: {
            guard let c0 = self.item(withID: $0) else {
                return false
            }
            return item < c0
        }) else {
            itemsID.append(item.id)
            return
        }
        itemsID.insert(item.id, at: index)
    }

    func add(_ item: E) {
        items.append(item)
        items.sort(by: <)
        saveAsJSON()
    }

    func sort() {
        items.sort(by: <)
    }
}
