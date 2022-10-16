//
//  Fakes.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 16/04/2022.
//

import Foundation

struct TestEnvir {
    static var schoolStore : SchoolStore!
    static var classeStore : ClasseStore!
    static var eleveStore  : EleveStore!
    static var observStore : ObservationStore!
    static var colleStore  : ColleStore!
    static var group       : GroupOfEleves!

    static func populateWithFakes(
        schoolStore : SchoolStore,
        classeStore : ClasseStore,
        eleveStore  : EleveStore,
        observStore : ObservationStore,
        colleStore  : ColleStore) {
            let etabManager   = SchoolManager()
            let classeManager = ClasseManager()
            let eleveManager  = EleveManager()
            var school = School.exemple
            let ressource = Ressource.exemple
            var classe = Classe.exemple
            var eleve  = Eleve.exemple
            var observ = Observation.exemple
            var colle  = Colle.exemple
            let exam   = Exam(elevesId: [eleve.id])

            // ajouter un examen à la classe
            classe.exams.append(exam)

            // ajouter une ressource à l'établissement
            school.ressources.append(ressource)

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

            // ajouter une observation à une élève
            eleveManager.ajouter(observation : &observ,
                                 aEleve      : &eleve,
                                 observStore : observStore)
            // ajouter une colle à une élève
            eleveManager.ajouter(colle       : &colle,
                                 aEleve      : &eleve,
                                 colleStore: colleStore)
            // ajouter l'élève à son store
            eleveStore.add(eleve)
            // ajouter l'observation à son store
            observStore.add(observ)
            // ajouter la colle à son store
            colleStore.add(colle)
        }
    
    static func createFakes() {
        schoolStore = SchoolStore()
        classeStore = ClasseStore()
        eleveStore  = EleveStore()
        observStore = ObservationStore()
        colleStore  = ColleStore()

        let etabManager   = SchoolManager()
        let classeManager = ClasseManager()
        let eleveManager  = EleveManager()
        var school    = School.exemple
        let ressource = Ressource.exemple
        var classe    = Classe.exemple
        var eleve     = Eleve.exemple
        var observ    = Observation.exemple
        var colle     = Colle.exemple
        let exam      = Exam(elevesId: [eleve.id])
        group = GroupOfEleves(number: 1, elevesID: [eleve.id])

        // ajouter un examen à la classe
        classe.exams.append(exam)

        // ajouter une ressource à l'établissement
        school.ressources.append(ressource)

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

        // ajouter une observation à une élève
        eleveManager.ajouter(observation : &observ,
                             aEleve      : &eleve,
                             observStore : observStore)
        // ajouter une colle à une élève
        eleveManager.ajouter(colle       : &colle,
                             aEleve      : &eleve,
                             colleStore: colleStore)
        // ajouter l'élève à son store
        eleveStore.add(eleve)
        // ajouter l'observation à son store
        observStore.add(observ)
        // ajouter la colle à son store
        colleStore.add(colle)
    }
}
