//
//  Recipe.swift
//  MyCookBook
//
//  Created by Anthony MARQUET on 16/01/2016.
//  Copyright © 2016 MARQUET. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Recipe: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    dynamic var id = ""
    dynamic var title = ""
    dynamic var image = ""
    dynamic var date = ""
    dynamic var preparation = ""
    dynamic var ingredients = ""
    dynamic var tps_preparation = ""
    dynamic var tps_cuisson = ""
    dynamic var categorie = ""
    dynamic var nb_personne = ""
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    func setData(dictionary: JSON) -> Recipe{
        
        id                 = dictionary["id"].stringValue
        title              = dictionary["title"].stringValue
        categorie          = dictionary["categorie"].stringValue
        
        //Gestion  image : Si image non présente dans l'appel WS, on entre en base l'image par de la catégorie corespodnante
        if(dictionary["image"].stringValue == ""){
            if(categorie == "1"){
                image          = "placeholder_categorie1"
            }
            else{
                image          = "placeholder_categorie2"
            }
        }
        else{
            image          = dictionary["image"].stringValue
        }
        //Fin gestion image
        date               = dictionary["day"].stringValue
        preparation        = dictionary["preparation"].stringValue
        ingredients        = dictionary["ingredients"].stringValue
        tps_preparation    = dictionary["tps_preparation"].stringValue
        tps_cuisson        = dictionary["tps_cuisson"].stringValue
        nb_personne        = dictionary["nb_personne"].stringValue

        return self
    }
}
