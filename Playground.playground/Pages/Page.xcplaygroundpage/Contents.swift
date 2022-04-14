//: [Previous](@previous)

import Foundation

var etablissementStore = EtablissementStore.exemple
print("\n** etablissementStore **")
print(String(describing: etablissementStore))

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

var etablissement = Etablissement.exemple
print(String(describing: etablissement))

var classe = Classe.exemple
let etablissementManager = EtablissementManager()
etablissementManager.ajouter(classe: classe,
                             aEtablissement: etablissement)
print(String(describing: etablissement))

var eleve = Eleve.exemple
let classeManager = ClasseManager()
classeManager.ajouter(eleve: eleve,
                      aClasse: classe)
print(String(describing: etablissement))

var observ = Observation.exemple
let observationManager = ObservationManager()
observationManager.ajouter(observ: observ,
                           aEleve: eleve)
print(String(describing: etablissement))

var colle = Colle.exemple
let colleManager = ColleManager()
colleManager.ajouter(colle: colle,
                     aEleve: eleve)
print(String(describing: etablissement))

colleManager.retirer(colle: colle,
                     deEleve: eleve)
print(String(describing: etablissement))

observationManager.retirer(observ: observ,
                           deEleve: eleve)
print(String(describing: etablissement))

classeManager.retirer(eleve: eleve,
                      deClasse: classe)
print(String(describing: etablissement))

etablissementManager.retirer(classe: classe,
                             deEtablissement: etablissement)
print(String(describing: etablissement))

//: [Next](@next)
