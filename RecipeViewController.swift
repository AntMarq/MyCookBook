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

class RecipeViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate,UITextViewDelegate {
    
    var titleViewController:String = String()    
    var recipeDetail:Recipe = Recipe()
    var imagePicker: UIImagePickerController!
    var imageLocation:String = String()

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
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = recipeDetail.title
        
        popupView.hidden = true
        popupView.layer.cornerRadius = 5;
        popupView.layer.masksToBounds = true
        
        imageRecipe.image = UIImage(named: recipeDetail.image)
        titleRecipeDetail.text = recipeDetail.title
        
        let modifiedIngredient = recipeDetail.ingredients.stringByReplacingOccurrencesOfString(", ", withString: "\n", options: NSStringCompareOptions.LiteralSearch, range: nil)
        ingredientsDetail.editable = false
        preparationRecipeDetail.editable = false
        ingredientsDetail.text = modifiedIngredient
        preparationRecipeDetail.text = recipeDetail.preparation
        self.nb_personne.text = recipeDetail.nb_personne
        self.preparationTime.text = recipeDetail.tps_preparation
        self.cuissonTime.text = recipeDetail.tps_cuisson
        
        self.preparationRecipeDetail.delegate = self
        self.ingredientsDetail.delegate = self
        self.cuissonTime.delegate = self
        self.preparationTime.delegate = self
        self.titleRecipeDetail.delegate = self
        self.nb_personne.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backController(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func pressEdit(sender: AnyObject) {
        if(!ingredientsDetail.editable){
            editBtn.setImage(UIImage(named: "edit-validated"), forState: UIControlState.Normal)
            ingredientsDetail.editable = true
            preparationRecipeDetail.editable = true
            btnTakePhoto.hidden = false
        }
        else{
            editBtn.setImage(UIImage(named: "edit-unvalidated"), forState: UIControlState.Normal)
            ingredientsDetail.editable = false
            preparationRecipeDetail.editable = false
            btnTakePhoto.hidden = true
        }
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if(textField == self.preparationTime){
            self.updatePropertyInDB(KeyFieldConstants.tps_preparationKey)
        }
        else if(textField == self.cuissonTime){
            self.updatePropertyInDB(KeyFieldConstants.tps_cuissonKey)
        }
        else if(textField == self.nb_personne){
            self.updatePropertyInDB(KeyFieldConstants.nb_personneKey)
        }
        else if(textField == self.titleRecipeDetail){
            self.updatePropertyInDB(KeyFieldConstants.titleKey)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if(textView == self.ingredientsDetail){
            self.updatePropertyInDB(KeyFieldConstants.ingredientsKey)
        }
        else if(textView == self.preparationRecipeDetail){
            self.updatePropertyInDB(KeyFieldConstants.preparationKey)
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        let image: UIImage  = info[UIImagePickerControllerOriginalImage]as! UIImage
        
        
        /*UIImageWriteToSavedPhotosAlbum(image, self,
            "image:didFinishSavingWithError:contextInfo:", nil)*/
        
        imageRecipe.image = image
        
        PhotoManager.sharedInstance.saveImage(image) { (imageLocation) -> Void in
            self.imageLocation = imageLocation
            self.updatePropertyInDB(KeyFieldConstants.imageKey)
        }
        
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
    }
    
    func updatePropertyInDB(keyField:String){
        if(keyField == KeyFieldConstants.imageKey && self.imageLocation != ""){
            /*dispatch_async(dispatch_queue_create("background", nil)) {
                RealmManager.SharedInstance.updateDataWithKey(self.recipeDetail, propertyNeedUpdate: self.imageLocation, keyField: keyField)
            }*/
            
            PhotoManager.sharedInstance.retrieveImageWithIdentifer(self.imageLocation, completion: { (image) -> Void in
                self.imageRecipe.image = image
            })
        }
        else if(keyField == KeyFieldConstants.ingredientsKey){
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
        
        AlamofireManager.SharedInstance.putRecipe(self.recipeDetail) { (success) -> Void in
            if(success){
                self.popupView.hidden = false
                self.popupView.alpha = 2.0
                _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update"), userInfo: nil, repeats: false)
            }
        }
    }
    
    func update() {
        //  PopUpView.hidden = true
        UIView.animateWithDuration(2.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.popupView.alpha = 0.0
            }, completion: nil)
        
    }
}
