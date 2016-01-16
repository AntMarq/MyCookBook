//
//  ViewController.swift
//  MyCookBook
//
//  Created by Anthony MARQUET on 13/01/2016.
//  Copyright © 2016 MARQUET. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var imgID = 0
    let titleImgEntree:String = "Mes Entrées"
    let titleImgPlat:String = "Mes Plats Principaux"
    let titleImgDessert:String = "Mes Desserts"
    
    @IBOutlet weak var imgEntree: UIImageView!
    @IBOutlet weak var imgDessert: UIImageView!
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addGestureToImageView(imgEntree)
        addGestureToImageView(imgDessert)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func imageTapped(sender: UITapGestureRecognizer)
    {
      // self.imgID = img.tag
        if sender.view?.tag == 1{
            imgID = 1
        }
        else if sender.view?.tag == 2{
            imgID = 2
        }
        else if sender.view?.tag == 3{
            imgID = 3
        }
        else if sender.view?.tag == 4{
            imgID = 4
        }
        self.performSegueWithIdentifier("HomeToRecipe", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "HomeToRecipe"
        {
            if let destinationVC = segue.destinationViewController as? RecipeViewController{
                if imgID == 1{
                    destinationVC.titleViewController = self.titleImgEntree
                }
                else if imgID == 2{
                    destinationVC.titleViewController = self.titleImgPlat
                }
                else if imgID == 3{
                    destinationVC.titleViewController = self.titleImgDessert
                }
            }
        }
        else{
            print("coucou")
        }
    }
    
    func addGestureToImageView(img:UIImageView){
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        img.addGestureRecognizer(tapGestureRecognizer);
    }
    
    func backController(){
        navigationController?.popViewControllerAnimated(true)
    }
   

}

