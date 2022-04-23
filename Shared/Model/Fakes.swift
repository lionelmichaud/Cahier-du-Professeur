//
//  Fakes.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 16/04/2022.
//

import Foundation

struct TestEnvir {
    static var schoolStore   : SchoolStore!
    static var classeStore : ClasseStore!
    static var eleveStore  : EleveStore!
    static var observStore : ObservationStore!
    static var colleStore  : ColleStore!

    static func populateWithFakes(
        schoolStore   : SchoolStore,
        classeStore : ClasseStore,
        eleveStore  : EleveStore,
        observStore : ObservationStore,
        colleStore  : ColleStore) {
            let etabManager   = SchoolManager()
            let classeManager = ClasseManager()
            var classe = Classe.exemple
            var school = School.exemple
            var eleve  = Eleve.exemple

            // ajouter une classe à l'établissement
            etabManager.ajouter(classe      : &classe,
                                aSchool     : &school,
                                classeStore : classeStore)
            // ajouter l'établissement à son store
            schoolStore.add(school)

            // ajouter un élève à la classe
            classeManager.ajouter(eleve      : &eleve,
                                  aClasse    : &classe,
                                  eleveStore : eleveStore)
            // ajouter la classe à son store
            classeStore.add(classe)

            // ajouter l'élève à son store
            eleveStore.add(eleve)
        }
    
    static func createFakes() {
        schoolStore = SchoolStore()
        classeStore = ClasseStore()
        eleveStore  = EleveStore()
        observStore = ObservationStore()
        colleStore  = ColleStore()

        let etabManager   = SchoolManager()
        let classeManager = ClasseManager()
        var classe = Classe.exemple
        var school = School.exemple
        var eleve  = Eleve.exemple

        // ajouter une classe à l'établissement
        etabManager.ajouter(classe      : &classe,
                            aSchool     : &school,
                            classeStore : classeStore)
        // ajouter l'établissement à son store
        schoolStore.add(school)

        // ajouter un élève à la classe
        classeManager.ajouter(eleve      : &eleve,
                             aClasse     : &classe,
                             eleveStore  : eleveStore)
        // ajouter la classe à son store
        classeStore.add(classe)

        // ajouter l'élève à son store
        eleveStore.add(eleve)
    }
}