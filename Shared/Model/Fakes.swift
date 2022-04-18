//
//  Fakes.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 16/04/2022.
//

import Foundation

struct TestEnvir {
    static var etabStore  : EtablissementStore!
    static var classStore : ClasseStore!
    static var eleveStore : EleveStore!
    static var obsStore   : ObservationStore!
    static var colStore   : ColleStore!

    static func populateWithFakes(
        etabStore  : EtablissementStore,
        classStore : ClasseStore,
        eleveStore : EleveStore,
        obsStore   : ObservationStore,
        colStore   : ColleStore) {
            let etabManager = EtablissementManager()
            // ajouter une classe à l'établissement
            etabManager.ajouter(classe: Classe.exemple, aEtablissement: &Etablissement.exemple)
            // ajouter l'établissement à son store
            etabStore.add(Etablissement.exemple)
            // ajouter la classe à son store
            classStore.add(Classe.exemple)
        }
    
    static func createFakes() {
        etabStore  = EtablissementStore()
        classStore = ClasseStore()
        eleveStore = EleveStore()
        obsStore   = ObservationStore()
        colStore   = ColleStore()

        let etabManager = EtablissementManager()
        // ajouter une classe à l'établissement
        etabManager.ajouter(classe: Classe.exemple, aEtablissement: &Etablissement.exemple)
        // ajouter l'établissement à son store
        etabStore.add(Etablissement.exemple)
        // ajouter la classe à son store
        classStore.add(Classe.exemple)
    }
}
