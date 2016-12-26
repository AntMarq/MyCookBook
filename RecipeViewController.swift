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
    @IBOutlet weak var btnChoosePhotoInAlbum: UIButton!
    
    @IBOutlet weak var infoView: UIView!
    let titles = [" ", "Mes entrées", "Mes plats", "Mes desserts", "Mes apéros"]
    let placeholderPreparation = "Ma nouvelle préparation..."
    let placeholderIngrédients = "Mes ingrédients..."
    let placeholderTitle = "MON TITRE"
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(newRecipe == false){
            loadInfo()
        }
        else{
            navigationItem.title = "Nouvelle Recette"
        }
        self.setViewsParameters()
        //Disable user interaction
        self.editionOff()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: - Views Parameters
    func setViewsParameters(){
        popupView.isHidden = true
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
        self.pickerView.pickerViewStyle = .wheel
        self.pickerView.maskDisabled = false
        self.pickerView.reloadData()
    }

    
// MARK: - loadInfo
    
    func loadInfo(){
        navigationItem.title = recipeDetail.title
        titleRecipeDetail.text = recipeDetail.title
        let modifiedIngredient = recipeDetail.ingredients.replacingOccurrences(of: ", ", with: "\n", options: NSString.CompareOptions.literal, range: nil)
        ingredientsDetail.text = modifiedIngredient
        preparationRecipeDetail.text = recipeDetail.preparation
        self.nb_personne.text = recipeDetail.nb_personne
        self.preparationTime.text = recipeDetail.tps_preparation
        self.cuissonTime.text = recipeDetail.tps_cuisson
        self.checkPicker = true
        self.pickerView.selectItem(Int(recipeDetail.categorie)!)
        self.imageLocation = recipeDetail.imagePath
        self.imageRecipe.image = AlamofireManager.SharedInstance.cachedImage(recipeDetail.imagePath)
    }

// MARK: - TextField Delegate

    func textFieldDidEndEditing(_ textField: UITextField) {
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
                navigationItem.title = recipeDetail.title
            }
            else{
                self.updatePropertyInDB(KeyFieldConstants.titleKey)
            }
        }
    }
    
// MARK: -  TextView Delegate
    
    func textViewDidEndEditing(_ textView: UITextView) {
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
    
    @IBAction func backController(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pressEdit(_ sender: AnyObject) {
        if(!ingredientsDetail.isEditable){
            editBtn.setImage(UIImage(named: "edit-validated"), for: UIControlState())
            self.editionOn()
        }
        else{
            editBtn.setImage(UIImage(named: "edit-unvalidated"), for: UIControlState())
            self.imageLocation = self.titleRecipeDetail.text!+".jpg"
            self.updatePropertyInDB(KeyFieldConstants.imageKey)
            self.editionOff()
            if(displayMessageForAlertView() == "" && self.checkPicker){
                if(!self.newRecipe){
                    self.updateRecipe()
                }
                else{
                    self.postRecipe()
                }
                
                if((self.imageRecipe.image) != nil){
                    AlamofireManager.SharedInstance.uploadImageRecipeNetwork(self.recipeDetail.title, image: self.imageRecipe.image!, completion: { (success) -> Void in
                        print("Image uplaod")
                    })
                }
            }
            else{
                self.displayAlert(self.displayMessageForAlertView())
            }
        }
    }
    
    @IBAction func takePhoto(_ sender: AnyObject) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.popover
        present(imagePicker, animated: true, completion: nil)
        let presentationController:UIPopoverPresentationController = imagePicker.popoverPresentationController!
        presentationController.sourceView = self.imageRecipe
        presentationController.sourceRect = CGRect(x: 0, y: (self.imageRecipe.frame.size.height/2)-1 ,width: self.imageRecipe.frame.size.width ,height: self.imageRecipe.frame.size.height);
        
    }
    
// MARK: - Take Photo methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        let image: UIImage  = info[UIImagePickerControllerOriginalImage]as! UIImage
        imageRecipe.image = image
    }

// MARK: - DB Update & WS
    
    func updatePropertyInDB(_ keyField:String){
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
        else if(keyField == KeyFieldConstants.imageKey){
            RealmManager.SharedInstance.updateDataWithKey(self.recipeDetail, propertyNeedUpdate: self.imageLocation, keyField:keyField)
        }
    }
    
    func updateRecipe(){
        AlamofireManager.SharedInstance.putRecipe(self.recipeDetail) { (success) -> Void in
            if(success){
                self.popupView.isHidden = false
                self.popupView.alpha = 2.0
                _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: Selector("showSavePopup"), userInfo: nil, repeats: false)
            }
        }
    }
    
    func postRecipe(){
        if(self.recipeDetail.date == ""){
            let todaysDate:Date = Date()
            let dateFormatter:DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateInFormat:String = dateFormatter.string(from: todaysDate)
            self.recipeDetail.date = dateInFormat
        }
        AlamofireManager.SharedInstance.postRecipe(self.recipeDetail) { (success) -> Void in
            if(success){
                self.newRecipe = true
                self.popupView.isHidden = false
                self.popupView.alpha = 2.0
                _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: Selector("showSavePopup"), userInfo: nil, repeats: false)
            }
        }
    }
    
// MARK: - PickerView delegate
 
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return self.titles.count
    }
    
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        self.checkPicker = false
        if(item != 0){
            RealmManager.SharedInstance.updateDataWithKey(self.recipeDetail, propertyNeedUpdate:String(item), keyField:KeyFieldConstants.categoryKey)
            self.checkPicker = true
        }
    }
    
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        return self.titles[item] 
    }
    
    func pickerView(_ pickerView: AKPickerView, imageForItem item: Int) -> UIImage {
        return UIImage(named: self.titles[item] )!
    }

// MARK: - AlertView
    
    func displayAlert(_ message:String){
        let alert = UIAlertController(title: "Information", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
// MARK: - Toast Android is the best ;)
    
    func showSavePopup() {
        //  PopUpView.hidden = true
        UIView.animate(withDuration: 2.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.popupView.alpha = 0.0
            }, completion: nil)
    }
    
// MARK: - UserInteraction
    
    func editionOff(){
        ingredientsDetail.isEditable = false
        preparationRecipeDetail.isEditable = false
        btnTakePhoto.isHidden = true
        btnChoosePhotoInAlbum.isHidden = true
        titleRecipeDetail.isUserInteractionEnabled = false
        nb_personne.isUserInteractionEnabled = false
        preparationTime.isUserInteractionEnabled = false
        cuissonTime.isUserInteractionEnabled = false
        self.pickerView.isUserInteractionEnabled = false
    }
    
    func editionOn(){
        ingredientsDetail.isEditable = true
        preparationRecipeDetail.isEditable = true
        btnTakePhoto.isHidden = false
        btnChoosePhotoInAlbum.isHidden = false
        titleRecipeDetail.isUserInteractionEnabled = true
        nb_personne.isUserInteractionEnabled = true
        preparationTime.isUserInteractionEnabled = true
        cuissonTime.isUserInteractionEnabled = true
        self.pickerView.isUserInteractionEnabled = true
    }
    
// MARK: - Utility
    
    func displayMessageForAlertView()->String{
        var errorMessage:String = ""
        if(!self.checkPicker){
            errorMessage = "\n La catégorie n'est pas renseignée.\n "
        }
        if(self.preparationRecipeDetail.text == "" || self.preparationRecipeDetail.text == placeholderPreparation){
            errorMessage += "Le champ préparation n'est pas renseigné.\n"
        }
        if(self.ingredientsDetail.text == "" || self.ingredientsDetail.text == placeholderIngrédients){
            errorMessage += "Le champ ingrédients n'est pas renseigné.\n"
        }
        if(self.titleRecipeDetail.text == "" || self.titleRecipeDetail.text == placeholderTitle){
            errorMessage += "Le champ titre n'est pas renseigné.\n"
        }
        return errorMessage
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    
}
