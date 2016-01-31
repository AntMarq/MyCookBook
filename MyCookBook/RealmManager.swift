//
//  RealmManager.swift
//  myGymSwift
//
//  Created by julien gimenez on 29/11/2015.
//  Copyright © 2015 julien gimenez. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

class RealmManager: NSObject {

    let realm = try! Realm()
    
    static let SharedInstance = RealmManager()
    
    func writeRecipesInDB(result: JSON, needUpdate: Bool, completion:(bool:Bool)->Void) {
        for object in result {
            let recipeResult = self.generateRecipes(object.1)
            getRecipeWithId(recipeResult.id, completion: { (recipe) -> Void in
                if (recipe.count==0){
                    self.writeData(recipeResult)
                }
                else if(recipe.count == 1){
                    self.updateData(recipeResult)
                }
            })
        }
        completion(bool: true)
    }
    
    //Mapping => creation d'objet
    func generateRecipes(dictionary: JSON) -> Recipe {
        return Recipe().setData(dictionary)
    }
    
    //DB => recherche d'un objet similaire
    func getRecipeWithId(_id: String, completion: (description: Results<(Recipe)>) -> Void) {
        completion(description: realm.objects(Recipe).filter("id = %@", _id))
    }
    
    //DB => ecriture en base
    func writeData(object:Object){
        try! self.realm.write {
            self.realm.add(object)
        }
    }
    
    func updateData(object:Object){
        try! realm.write {
            realm.add(object, update: true)
        }
    }
    
    //Print all db recipe
    func getAllRecipes() -> Results<(Recipe)> {
        return realm.objects(Recipe)
    }
    
    //Get DB Recipes
    func getAllRecipeFromDB(completion: (news: Array<Recipe>) -> Void) {
        completion(news: Array<Recipe>(realm.objects(Recipe)))
    }
    
    // MARK: - Generateur d'objets
    
   /* func startFeed(){
        for var index = 0; index < 6; ++index {
            RealmManager.SharedInstance.feedDataBaseWithFile(index)
        }
    }
    
    // Remplissage de la base de données avec les stubs
    func feedDataBaseWithFile(key: NSInteger) {
        
        returnFileAndObject(key) { (stub, keyStub) -> Void in
            
            self.groupsFromFile(stub, object: keyStub) { (result) -> Void in
                
                switch key {
                    
                case ModelsConstants.stub_sessions:
                    self.writeSessionsInDB(result)
                    print(self.getAllSessions())
                case ModelsConstants.stub_teachers:
                    self.writeTeachersInDB(result)
                    //print(self.getAllTeachers())
                /*case ModelsConstants.stub_sports:
                    self.writeSportsInDB(result)
                    //print(self.getAllSports())*/
                /*case ModelsConstants.stub_sportsDescription:
                    self.writeSportsDescriptionsInDB(result)
                    //print(self.getAllSportsDescriptions())*/
                case ModelsConstants.stub_objectives:
                    self.writeObjectivesInDB(result)
                    //print(self.getAllObjectives())
                /*case ModelsConstants.stub_news:
                    self.writeNewsInDB(result)
                    //print(self.getAllNews())*/
                default:
                    print("no stub for key %@",key)
                }
            }
        }
    }*/
    
    /*func writeDataFromWS(key: NSInteger,json:JSON, completion:(bool:Bool) -> Void) {
        
            switch key {
                
            case ModelsConstants.stub_sessions:
                self.writeSessionsInDB(json)
                //print(self.getAllSessions())
            case ModelsConstants.stub_teachers:
                self.writeTeachersInDB(json)
                //print(self.getAllTeachers())
            case ModelsConstants.stub_sports:
                self.writeSportsInDB(json)
                completion(bool: true)
                //print(self.getAllSports())
            case ModelsConstants.stub_sportsDescription:
                self.writeSportsDescriptionsInDB(json)
                completion(bool: true)
                //print(self.getAllSportsDescriptions())
            case ModelsConstants.stub_objectives:
                self.writeObjectivesInDB(json)
                //print(self.getAllObjectives())
            case ModelsConstants.stub_news:
                self.writeNewsInDB(json)
                completion(bool: true)
                //print(self.getAllNews())
            default:
                //print("no ws for key %@",key)
                completion(bool: false)
            }
    }

    // MARK: - Ecriture d'objets dans la DB

    func writeSessionsInDB(result: JSON) {
        for object in result {
            let newObject = self.generateSession(object.1)
            getSessionWithId(newObject.id, completion: { (new) -> Void in
                if (new.count==0){
                    self.writeData(newObject)
                }
            })
        }
    }
    
    func writeTeachersInDB(result: JSON) {
        for object in result {
            let newObject = self.generateTeacher(object.1)
            getTeacherWithId(newObject.id, completion: { (new) -> Void in
                if (new.count==0){
                    self.writeData(newObject)
                }
            })
        }
    }
    
    func writeSportsInDB(result: JSON) {
        for object in result {
            let newObject = self.generateSport(object.1)
            getSportWithId(newObject.id, completion: { (new) -> Void in
                if (new.count==0){
                    self.writeData(newObject)
                }
            })
        }
    }
    
    
    
    func writeObjectivesInDB(result: JSON) {
        for object in result {
            let newObject = self.generateObjectives(object.1)
            getObjectivesWithId(newObject.id, completion: { (new) -> Void in
                if (new.count==0){
                    self.writeData(newObject)
                }
            })
        }
    }
    
    func writeNewsInDB(result: JSON) {
        for object in result {
            let newObject = self.generateNews(object.1)
            getNewsWithId(newObject.id, completion: { (new) -> Void in
                if (new.count==0){
                    self.writeData(newObject)
                }
            })
        }
    }
    
    func writeData(object:Object){
        try! self.realm.write {
            self.realm.add(object)
        }
    }
    
    // MARK: - Génération d'objets

    func generateSession(dictionary: JSON) -> SessionModel {
        return SessionModel().setData(dictionary)
    }
    
    func generateTeacher(dictionary: JSON) -> TeacherModel {
        return TeacherModel().setData(dictionary)
    }
    
    func generateSport(dictionary: JSON) -> SportModel {
        return SportModel().setData(dictionary)
    }
    
    func generateSportDescription(dictionary: JSON) -> SportDescriptionModel {
        return SportDescriptionModel().setData(dictionary)
    }
    
    func generateObjectives(dictionary: JSON) -> ObjectiveModel {
        return ObjectiveModel().setData(dictionary)
    }
    
    func generateNews(dictionary: JSON) -> NewsModel {
        return NewsModel().setData(dictionary)
    }
    
    // MARK: - Récupération d'objets
    
    func getAllTeachers() -> Results<(TeacherModel)> {
        return realm.objects(TeacherModel)
    }
    
    func getAllSessions() -> Results<(SessionModel)> {
        return realm.objects(SessionModel)
    }
    
    func getAllSports() -> Results<(SportModel)> {
        return realm.objects(SportModel)
    }
    
    func getAllSportsDescriptions() -> Results<(SportDescriptionModel)> {
        return realm.objects(SportDescriptionModel)
    }
    
    func getAllSportsFromDB(completion: (sports: Array<(SportObject)>) -> Void) {
        let sports = realm.objects(SportModel)
        var sportsArray: Array<SportObject> = Array<SportObject>()

        for sport in sports {
            let sportObject = SportObject()
            
            sportObject.setSportForCell(sport, completion: { (sportObject) -> Void in
                
                sportsArray.append(sportObject)
                
            })
        }
        completion(sports: sportsArray)
    }
    
    func getAllObjectives()->Results<(ObjectiveModel)>{
        return realm.objects(ObjectiveModel)
    }
    
    func getAllNewsFromDB(completion: (news: Array<NewsObject>) -> Void) {
        let news = realm.objects(NewsModel)
        var newsArray: Array<NewsObject> = Array<NewsObject>()
        
        for new in news {
            let newsObject = NewsObject()
            
            newsObject.setNewsForCell(new, completion: { (newsObject) -> Void in
                newsArray.append(newsObject)
            })
        }
        completion(news: newsArray)
    }
    
    // MARK : - Recherches
    
    func isSessionWithDate(date: NSDate, completion: (sessions: Results<(SessionModel)>) -> Void) {
        completion(sessions: realm.objects(SessionModel).filter(ModelsConstants.kGetDay, date))
    }
    
    func getSessionWithId(_id: String, completion: (session: Results<(SessionModel)>) -> Void) {
        completion(session: realm.objects(SessionModel).filter(ModelsConstants.kGetId, _id))
    }
    
    func getSportWithId(_id: String, completion: (sport: Results<(SportModel)>) -> Void) {
        completion(sport: realm.objects(SportModel).filter(ModelsConstants.kGetId, _id))
    }
    
    func getTeacherWithId(_id: String, completion: (teacher: Results<(TeacherModel)>) -> Void) {
        completion(teacher: realm.objects(TeacherModel).filter(ModelsConstants.kGetId, _id))
    }
    
    func getSportDescriptionWithId(_id: String, completion: (description: Results<(SportDescriptionModel)>) -> Void) {
        completion(description: realm.objects(SportDescriptionModel).filter(ModelsConstants.kGetKey_sport, _id))
    }
    
    func getObjectivesWithId(_id: String, completion: (objectives: Results<(ObjectiveModel)>) -> Void) {
        completion(objectives: realm.objects(ObjectiveModel).filter(ModelsConstants.kGetId, _id))
    }
    
    func getObjectivesWithSportId(sport_id: String, completion: (objectives: Results<(ObjectiveModel)>) -> Void) {
        completion(objectives: realm.objects(ObjectiveModel).filter(ModelsConstants.kGetSportId, sport_id))
    }
    
    func getNewsWithId(news_id: String, completion: (news: Results<(NewsModel)>) -> Void) {
        completion(news: realm.objects(NewsModel).filter(ModelsConstants.kGetId, news_id))
    }
    
    // MARK: - Suppression de la base de données

    func cleanDb() {
        try! realm.write {
            self.realm.deleteAll()
        }
    }
    
    // MARK: - Traitement JSON

    func returnFileAndObject(keyStubDetection: NSInteger, completion: (stub: String, keyStub: String) -> Void) {
        
        switch keyStubDetection{
            
        case ModelsConstants.stub_sessions:
            completion(stub: ModelsConstants.kSessionsStub, keyStub: ModelsConstants.kSessionsObject);
        case ModelsConstants.stub_teachers:
            completion(stub: ModelsConstants.kTeachersStub, keyStub: ModelsConstants.kTeachersObject);
        case ModelsConstants.stub_sports:
            completion(stub: ModelsConstants.kSportsStub, keyStub: ModelsConstants.kSportsObject);
        case ModelsConstants.stub_sportsDescription:
            completion(stub: ModelsConstants.kSportsDescritpionsStub, keyStub: ModelsConstants.kSportsDescriptionsObject);
        case ModelsConstants.stub_objectives:
            completion(stub: ModelsConstants.kObjectivesStub, keyStub: ModelsConstants.kObjectivesObject);
        case ModelsConstants.stub_news:
            completion(stub: ModelsConstants.kNewsStub, keyStub: ModelsConstants.kNewsObject);
        default:
            completion(stub: "", keyStub: "");
        }
    }
    
    // Transformation d'un stub en data JSON
    func groupsFromFile(fileName: String, object: String, completion: (result: JSON) -> Void) {
        
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: ModelsConstants.kJsonExtension)
        let dataJson = NSData(contentsOfFile: path!)
        let json = JSON(data: dataJson!)
        completion(result: json[object])
    }*/
    
}
