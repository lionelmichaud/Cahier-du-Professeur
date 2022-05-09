//
//  JsonCodableArray.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 03/05/2022.
//

import Foundation
import AppFoundation
import FileAndFolder
import Files

protocol Ordered {
    static func < (lhs: Self, rhs: Self) -> Bool
}

public final class JsonCodableArray<E>: ObservableObject, JsonCodableToFolderP where
E: Codable,
E: Identifiable,
E: CustomStringConvertible,
E.ID == UUID {

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

        if let fromFolder = fromFolder {
            folder = fromFolder

        } else if let documentsFolder = Folder.documents {
            folder = documentsFolder

        } else {
            self.init()
            return
        }
        do {
            // charger les données JSON
            try self.init(fromFile             : String(describing: E.self) + ".json",
                          fromFolder           : folder,
                          dateDecodingStrategy : .iso8601,
                          keyDecodingStrategy  : .useDefaultKeys)
        } catch {
            self.init()
        }
    }

    // MARK: - Methods

    func clear() {
        self.items = [ ]
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

        if let fromFolder = fromFolder {
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

    public func update(with item : E,
                       at index  : Int) {
        items[index] = item
        saveAsJSON()
    }

    /// True si une classe existe déjà avec le même ID
    /// - Parameter item: Classe
    public func isPresent(_ item: E) -> Bool {
        items.contains(where: { item.id == $0.id})
    }

    /// True si une classe existe déjà avec le même ID
    /// - Parameter ID: ID de la Calsse
    public func isPresent(_ ID: UUID) -> Bool {
        items.contains(where: { ID == $0.id})
    }

    public func item(withID ID: UUID) -> E? {
        items.first(where: { ID == $0.id})
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
                `in` itemsID : inout [UUID]) {
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

}
