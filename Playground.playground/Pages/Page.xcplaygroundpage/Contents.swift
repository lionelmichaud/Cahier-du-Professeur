//: [Previous](@previous)

import Foundation

var schoolStore = SchoolStore.exemple
print("\n** schoolStore **")
print(String(describing: schoolStore))

var classeStore = ClasseStore.exemple
print("\n** classeStore **")
print(String(describing: classeStore))

var eleveStore = EleveStore.exemple
print("\n** eleveStore **")
print(String(describing: eleveStore))

var colleStore = ColleStore.exemple
print("\n** colleStore **")
print(String(describing: colleStore))

var observationStore = ObservationStore.exemple
print("\n** observationStore **")
print(String(describing: observationStore))

var school = School.exemple
print(String(describing: school))

var classe = Classe.exemple
let schoolManager = SchoolManager()
schoolManager.ajouter(classe: classe,
                             aSchool: school)
print(String(describing: school))

var eleve = Eleve.exemple
let classeManager = ClasseManager()
classeManager.ajouter(eleve: eleve,
                      aClasse: classe)
print(String(describing: school))

var observ = Observation.exemple
let observationManager = ObservationManager()
observationManager.ajouter(observ: observ,
                           aEleve: eleve)
print(String(describing: school))

var colle = Colle.exemple
let colleManager = ColleManager()
colleManager.ajouter(colle: colle,
                     aEleve: eleve)
print(String(describing: school))

colleManager.retirer(colle: colle,
                     deEleve: eleve)
print(String(describing: school))

observationManager.retirer(observ: observ,
                           deEleve: eleve)
print(String(describing: school))

classeManager.retirer(eleve: eleve,
                      deClasse: classe)
print(String(describing: school))

schoolManager.retirer(classe: classe,
                             deSchool: school)
print(String(describing: school))

//: [Next](@next)
