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
    
    func mapper(objectMapping:Recipe) -> Recipe{
        let recipeObject = Recipe()
        recipeObject.id = objectMapping.id
        recipeObject.title = objectMapping.title
        recipeObject.ingredients = objectMapping.ingredients
        recipeObject.preparation = objectMapping.preparation
        recipeObject.image = objectMapping.image
        
        return recipeObject
    }
    
    
    func setData(dictionary: JSON) -> Recipe{
        
        id                 = dictionary["id"].stringValue
        title              = dictionary["title"].stringValue
        image              = dictionary["image"].stringValue
        date               = dictionary["day"].stringValue
        preparation        = dictionary["preparation"].stringValue
        ingredients        = dictionary["ingredients"].stringValue
        tps_preparation    = dictionary["tps_preparation"].stringValue
        tps_cuisson        = dictionary["tps_cuisson"].stringValue
        categorie          = dictionary["categorie"].stringValue
        nb_personne        = dictionary["nb_personne"].stringValue

        return self
    }
}
