//
//  RecipeViewController.swift
//  MyCookBook
//
//  Created by SQLI51107 on 14/01/2016.
//  Copyright © 2016 MARQUET. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift
import AKPickerView_Swift

class RecipeViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate,UITextViewDelegate, AKPickerViewDataSource, AKPickerViewDelegate {
    
    var titleViewController:String = String()    
    var recipeDetail:Recipe = Recipe()
    var imagePicker: UIImagePickerController!
    var imageLocation:String = String()
    var newRecipe:Bool = false
    var checkPicker:Bool = false

    @IBOutlet var pickerView: AKPickerView!
    @IBOutlet weak var cuissonTime: UITextField!
    @IBOutlet weak var preparationTime: UITextField!
    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var ingredientsDetail: UITextView!
    @IBOutlet weak var titleRecipeDetail: UITextField!
    @IBOutlet weak var preparationRecipeDetail: UITextView!
    @IBOutlet weak var nb_personne: UITextField!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var btnTakePhoto: UIButton!
    
    let titles = [" ", "Mes entrées", "Mes plats", "Mes desserts", "Mes apéros"]
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = recipeDetail.title
        
        if(newRecipe == false){
            loadInfo()
        }
        
        ingredientsDetail.editable = false
        preparationRecipeDetail.editable = false
        
        popupView.hidden = true
        popupView.layer.cornerRadius = 5;
        popupView.layer.masksToBounds = true
        
        self.preparationRecipeDetail.delegate = self
        self.ingredientsDetail.delegate = self
        self.cuissonTime.delegate = self
        self.preparationTime.delegate = self
        self.titleRecipeDetail.delegate = self
        self.nb_personne.delegate = self
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.font = UIFont(name: "HelveticaNeue-Light", size: 20)!
        self.pickerView.highlightedFont = UIFont(name: "HelveticaNeue", size: 20)!
        self.pickerView.pickerViewStyle = .Wheel
        self.pickerView.maskDisabled = false
        self.pickerView.reloadData()
        
        //Disable user interaction
        self.editionOff()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
// MARK: - loadInfo
    
    func loadInfo(){
        PhotoManager.sharedInstance.retrieveImageWithIdentifer(recipeDetail.image, completion: { (image) -> Void in
            self.imageRecipe.image = image
        })
        titleRecipeDetail.text = recipeDetail.title
        
        let modifiedIngredient = recipeDetail.ingredients.stringByReplacingOccurrencesOfString(", ", withString: "\n", options: NSStringCompareOptions.LiteralSearch, range: nil)
        ingredientsDetail.text = modifiedIngredient
        preparationRecipeDetail.text = recipeDetail.preparation
        self.nb_personne.text = recipeDetail.nb_personne
        self.preparationTime.text = recipeDetail.tps_preparation
        self.cuissonTime.text = recipeDetail.tps_cuisson
        self.checkPicker = true
        self.pickerView.selectItem(Int(recipeDetail.categorie)!)
        self.imageLocation = recipeDetail.image
    }

// MARK: - TextField Delegate

    func textFieldDidEndEditing(textField: UITextField) {
        if(textField == self.preparationTime){
            if(newRecipe){
                recipeDetail.tps_preparation = self.preparationTime.text!
            }
            else{
                self.updatePropertyInDB(KeyFieldConstants.tps_preparationKey)
            }
        }
        else if(textField == self.cuissonTime){
            if(newRecipe){
                 recipeDetail.tps_cuisson = self.cuissonTime.text!
            }
            else{
                self.updatePropertyInDB(KeyFieldConstants.tps_cuissonKey)
            }
        }
        else if(textField == self.nb_personne){
            if(newRecipe){
                recipeDetail.nb_personne = self.nb_personne.text!
            }
            else{
                self.updatePropertyInDB(KeyFieldConstants.nb_personneKey)
            }
        }
        else if(textField == self.titleRecipeDetail){
            if(newRecipe){
                recipeDetail.title = self.titleRecipeDetail.text!
            }
            else{
                self.updatePropertyInDB(KeyFieldConstants.titleKey)
            }
        }
    }
    
// MARK: -  TextView Delegate
    func textViewDidEndEditing(textView: UITextView) {
        if(textView == self.ingredientsDetail){
            if(newRecipe){
               recipeDetail.ingredients = self.ingredientsDetail.text
            }
            else{
                self.updatePropertyInDB(KeyFieldConstants.ingredientsKey)
            }
        }
        else if(textView == self.preparationRecipeDetail){
            if(newRecipe){
                recipeDetail.preparation = self.preparationRecipeDetail.text
            }
            else{
                self.updatePropertyInDB(KeyFieldConstants.preparationKey)
            }
        }
    }
    
// MARK: - IBAction
    
    @IBAction func backController(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func pressEdit(sender: AnyObject) {
        if(!ingredientsDetail.editable){
            editBtn.setImage(UIImage(named: "edit-validated"), forState: UIControlState.Normal)
            self.editionOn()
        }
        else{
            editBtn.setImage(UIImage(named: "edit-unvalidated"), forState: UIControlState.Normal)
            self.updatePropertyInDB(KeyFieldConstants.imageKey)
            self.editionOff()
            if(checkDataBeforeSave() && self.checkPicker){
                if(!newRecipe){
                    self.updateRecipe()
                }
                else{
                    self.postRecipe()
                }
            }
            else{
                if(!self.checkPicker){
                    self.displayAlert("La catégorie n'est pas renseignée")
                }
                else if(self.preparationRecipeDetail.text == ""){
                    self.displayAlert("Le champ préparation n'est pas renseigné")
                }
                else if(self.ingredientsDetail.text == ""){
                    self.displayAlert("Le champ ingrédients n'est pas renseigné")
                }
                else if(self.titleRecipeDetail.text == ""){
                    self.displayAlert("Le champ titre n'est pas renseigné")
                }
            }
        }
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
// MARK: - Take Photo methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        let image: UIImage  = info[UIImagePickerControllerOriginalImage]as! UIImage
        imageRecipe.image = image
        PhotoManager.sharedInstance.saveImage(image) { (imageLocation) -> Void in
            self.imageLocation = imageLocation
        }
    }

// MARK: - Popup
    
    func showSavePopup() {
        //  PopUpView.hidden = true
        UIView.animateWithDuration(2.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.popupView.alpha = 0.0
            }, completion: nil)
    }

// MARK: - DB Update & WS
    
    func updatePropertyInDB(keyField:String){
        if(keyField == KeyFieldConstants.ingredientsKey){
            RealmManager.SharedInstance.updateDataWithKey(self.recipeDetail, propertyNeedUpdate: self.ingredientsDetail.text, keyField: keyField)
        }
        else if(keyField == KeyFieldConstants.preparationKey){
            RealmManager.SharedInstance.updateDataWithKey(self.recipeDetail, propertyNeedUpdate: self.preparationRecipeDetail.text, keyField:keyField)
        }
        else if(keyField == KeyFieldConstants.titleKey){
            RealmManager.SharedInstance.updateDataWithKey(self.recipeDetail, propertyNeedUpdate: self.titleRecipeDetail.text!, keyField:keyField)
        }
        else if(keyField == KeyFieldConstants.tps_cuissonKey){
            RealmManager.SharedInstance.updateDataWithKey(self.recipeDetail, propertyNeedUpdate: self.cuissonTime.text!, keyField:keyField)
        }
        else if(keyField == KeyFieldConstants.tps_preparationKey){
            RealmManager.SharedInstance.updateDataWithKey(self.recipeDetail, propertyNeedUpdate: self.preparationTime.text!, keyField:keyField)
        }
        else if(keyField == KeyFieldConstants.nb_personneKey){
            RealmManager.SharedInstance.updateDataWithKey(self.recipeDetail, propertyNeedUpdate: self.nb_personne.text!, keyField:keyField)
        }
        /*else if(keyField == KeyFieldConstants.categoryKey){
            RealmManager.SharedInstance.updateDataWithKey(self.recipeDetail, propertyNeedUpdate: self.category.text!, keyField:keyField)
        }*/
        else if(keyField == KeyFieldConstants.imageKey){
            RealmManager.SharedInstance.updateDataWithKey(self.recipeDetail, propertyNeedUpdate: self.imageLocation, keyField:keyField)
        }
        //self.updateRecipe()
    }
    
   /* func updateImageDB(){
        let realm = try! Realm()
        try! realm.write {
            self.recipeDetail.image = self.imageLocation
        }
        self.updateRecipe()
    }*/
    
    func updateRecipe(){
        AlamofireManager.SharedInstance.putRecipe(self.recipeDetail) { (success) -> Void in
            if(success){
                self.popupView.hidden = false
                self.popupView.alpha = 2.0
                _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("showSavePopup"), userInfo: nil, repeats: false)
            }
        }
    }
    
    func postRecipe(){
        if(self.recipeDetail.date == ""){
            let todaysDate:NSDate = NSDate()
            let dateFormatter:NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateInFormat:String = dateFormatter.stringFromDate(todaysDate)
            self.recipeDetail.date = dateInFormat
        }
        
        self.recipeDetail.image = self.imageLocation
        
        AlamofireManager.SharedInstance.postRecipe(self.recipeDetail) { (success) -> Void in
            if(success){
                self.newRecipe = true
                self.popupView.hidden = false
                self.popupView.alpha = 2.0
                _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("showSavePopup"), userInfo: nil, repeats: false)
            }
        }
    }
    
// MARK: - PickerView delegate
 
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        return self.titles.count
    }
    
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        self.checkPicker = false
        if(item != 0){
            RealmManager.SharedInstance.updateDataWithKey(self.recipeDetail, propertyNeedUpdate:String(item), keyField:KeyFieldConstants.categoryKey)
            self.checkPicker = true
        }
        
        print("Your favorite city is \(self.titles[item])")
    }
    
    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
        return self.titles[item] 
    }
    
    func pickerView(pickerView: AKPickerView, imageForItem item: Int) -> UIImage {
        return UIImage(named: self.titles[item] )!
    }
    
    func checkDataBeforeSave()->Bool{
        var checkData:Bool = false
        if(self.preparationRecipeDetail.text != "" || self.ingredientsDetail.text != "" || self.titleRecipeDetail.text != ""){
            checkData = true
        }
        return checkData
    }
    
    func displayAlert(message:String){
        let alert = UIAlertController(title: "Information", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func editionOff(){
        ingredientsDetail.editable = false
        preparationRecipeDetail.editable = false
        btnTakePhoto.hidden = true
        titleRecipeDetail.userInteractionEnabled = false
        nb_personne.userInteractionEnabled = false
        preparationTime.userInteractionEnabled = false
        cuissonTime.userInteractionEnabled = false
        self.pickerView.userInteractionEnabled = false
    }
    
    func editionOn(){
        ingredientsDetail.editable = true
        preparationRecipeDetail.editable = true
        btnTakePhoto.hidden = false
        titleRecipeDetail.userInteractionEnabled = true
        nb_personne.userInteractionEnabled = true
        preparationTime.userInteractionEnabled = true
        cuissonTime.userInteractionEnabled = true
        self.pickerView.userInteractionEnabled = true
    }
}
