//
//  ViewController.swift
//  Filterer_by_vitaliy
//
//  Created by Vitaliy Timoshenko on 3/23/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

var originalImage = UIImage(named: "scenery.png")! //opening the image
var filteredImage = originalImage
let icon_filter = UIImage(named: "filter_icon") //that will be the icon on filter buttons to preview result

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var label_Original: UILabel!
    @IBOutlet weak var MainImage: UIImageView!
    @IBOutlet weak var FilteredImage: UIImageView!
    
    @IBOutlet weak var button_NewPhoto: UIButton!
    @IBOutlet weak var button_Filter: UIButton!
    @IBOutlet weak var button_Edit: UIButton!
    @IBOutlet weak var button_Compare: UIButton!
    @IBOutlet weak var button_Share: UIButton!
    @IBOutlet weak var slider_threshold: UISlider!
    @IBOutlet weak var slider_power: UISlider!
    
    @IBOutlet var view_Original_label: UIView!
    @IBOutlet var view_Filters: UIView!
    @IBOutlet var view_Edit_Slider: UIView!
    
    @IBOutlet weak var stackview_buttons: UIStackView!
    @IBOutlet weak var light_Button: UIButton!
    @IBOutlet weak var green_Button: UIButton!
    @IBOutlet weak var red_Button: UIButton!
    @IBOutlet weak var blue_Button: UIButton!

    //this is the common filtering parameters to be remembered throughout the app while users makes changes in UI
    var current_filter: (name: String, threshold: Int, power: Int) = ("EnhanceBrightness", 500, 25)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MainImage.image = originalImage
        FilteredImage.image = originalImage
        button_Compare.enabled = false
        button_Edit.enabled = false
        light_Button.setImage(ImageProcessor(theImage: icon_filter!).applySetOfFilters([brighter_f]), forState: .Normal)
        green_Button.setImage(ImageProcessor(theImage: icon_filter!).applySetOfFilters([agressive_green_f]), forState: .Normal)
        red_Button.setImage(ImageProcessor(theImage: icon_filter!).applySetOfFilters([aggressive_red_f]), forState: .Normal)
        blue_Button.setImage(ImageProcessor(theImage: icon_filter!).applySetOfFilters([agressive_blue_f]), forState: .Normal)
    }
    
    @IBAction func on_new_photo(sender: UIButton) {
        drop_additional_views(sender)
        let new_photo_actionSheet = UIAlertController(title: "New Image", message: nil, preferredStyle: .ActionSheet)
        new_photo_actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in self.startCamera() } ))
        new_photo_actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in self.openAlbum() } ))
        new_photo_actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(new_photo_actionSheet, animated: true, completion: nil)
    }
    
    func startCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func openAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            MainImage.image = image
            FilteredImage.image = image
            originalImage = image
            filteredImage = image
            button_Compare.enabled = false
            button_Edit.enabled = false
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func on_tap_Filter(sender: UIButton) {
        if !(sender.selected) {
            drop_additional_views(sender)
            view.addSubview(view_Filters)
            view_Filters.translatesAutoresizingMaskIntoConstraints = false
            let bottom_to_top = view_Filters.bottomAnchor.constraintEqualToAnchor(stackview_buttons.topAnchor)
            NSLayoutConstraint.activateConstraints([bottom_to_top])
            view_Filters.layoutIfNeeded()
            sender.selected = true
        }
        else {
            view_Filters.removeFromSuperview()
            sender.selected = false
        }
    }
    
    @IBAction func on_tap_Light_Filter(sender: AnyObject) {
        current_filter = brighter_f
        filteredImage = ImageProcessor(theImage: originalImage).applySetOfFilters([current_filter])
        view_Filters.removeFromSuperview()
        FilteredImage.image = filteredImage
        button_Compare.enabled = true
        button_Edit.enabled = true
        button_Filter.selected = false
        showFiltered()
    }

    @IBAction func on_tap_Green_Filter(sender: AnyObject) {
        current_filter = agressive_green_f
        filteredImage = ImageProcessor(theImage: originalImage).applySetOfFilters([current_filter])
        view_Filters.removeFromSuperview()
        FilteredImage.image = filteredImage
        button_Compare.enabled = true
        button_Edit.enabled = true
        button_Filter.selected = false
        showFiltered()
    }
    
    @IBAction func on_tap_Red_Filter(sender: AnyObject) {
        current_filter = aggressive_red_f
        filteredImage = ImageProcessor(theImage: originalImage).applySetOfFilters([current_filter])
        view_Filters.removeFromSuperview()
        FilteredImage.image = filteredImage
        button_Compare.enabled = true
        button_Edit.enabled = true
        button_Filter.selected = false
        showFiltered()
    }

    @IBAction func on_tap_Blue_Filter(sender: AnyObject) {
        current_filter = agressive_blue_f
        filteredImage = ImageProcessor(theImage: originalImage).applySetOfFilters([current_filter])
        view_Filters.removeFromSuperview()
        FilteredImage.image = filteredImage
        button_Compare.enabled = true
        button_Edit.enabled = true
        button_Filter.selected = false
        showFiltered()
    }
    
    @IBAction func on_tap_Edit(sender: UIButton) {
        if !(sender.selected) {
            drop_additional_views(sender)
            view.addSubview(view_Edit_Slider)
            slider_threshold.value = Float(current_filter.threshold)
            slider_power.value = Float(current_filter.power)
            view_Edit_Slider.translatesAutoresizingMaskIntoConstraints = false
            let slide_view_left = view_Edit_Slider.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
            let slide_view_right = view_Edit_Slider.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
            let bottom_to_top_slider = view_Edit_Slider.bottomAnchor.constraintEqualToAnchor(stackview_buttons.topAnchor)
            NSLayoutConstraint.activateConstraints([slide_view_left, slide_view_right, bottom_to_top_slider])
            view_Filters.layoutIfNeeded()
            sender.selected = true
        }
        else {
            view_Edit_Slider.removeFromSuperview()
            sender.selected = false
        }
    }
    
    @IBAction func slider_threshold_changed(sender: UISlider) {
        let slider_value = Int(sender.value)
        current_filter.threshold = slider_value
        filteredImage = ImageProcessor(theImage: originalImage).applySetOfFilters([current_filter])
        FilteredImage.image = filteredImage
    }
    
    @IBAction func slider_power_changed(sender: UISlider) {
        let slider_value = Int(sender.value)
        current_filter.power = slider_value
        filteredImage = ImageProcessor(theImage: originalImage).applySetOfFilters([current_filter])
        FilteredImage.image = filteredImage
    }
    
    @IBAction func on_tap_Compare(sender: UIButton) {
        if !(sender.selected) {
            drop_additional_views(sender)
            showOriginal()
            sender.selected = true
        }
        else {
            sender.selected = false
            showFiltered()
        }
    }
    
    @IBAction func on_tap_Share(sender: UIButton) {
        drop_additional_views(sender)
        let activityController = UIActivityViewController(activityItems: [MainImage.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    func showOriginal() {
        if (!button_Compare.selected && button_Compare.enabled) {

            UIView.animateWithDuration(0.5) {
                self.FilteredImage.alpha = 0
                self.MainImage.alpha = 1
            }
            view.addSubview(view_Original_label)
            
            view_Original_label.translatesAutoresizingMaskIntoConstraints = false
            let centerYConstraint = label_Original.centerYAnchor.constraintEqualToAnchor(MainImage.centerYAnchor)
            let centerXConstraint = label_Original.centerXAnchor.constraintEqualToAnchor(MainImage.centerXAnchor)
            NSLayoutConstraint.activateConstraints([centerXConstraint,centerYConstraint])
            view_Original_label.layoutIfNeeded()
        }
    }
    
    func showFiltered() {
        if (!button_Compare.selected && button_Compare.enabled) {
            UIView.animateWithDuration(0.5) {
                self.FilteredImage.alpha = 1
                self.MainImage.alpha = 0
            }
            view_Original_label.removeFromSuperview()
        }
    }
    
    func drop_additional_views(sender: UIButton){
        // This method is used when user taps a button
        // It removes all subviews except the one, which is tied to the button user has just tapped at
        
        if (sender != button_Compare) {
            view_Original_label.removeFromSuperview()
            button_Compare.selected = false
            showFiltered()
        }
        if (sender != button_Edit) {
            button_Edit.selected = false
            view_Edit_Slider.removeFromSuperview()
        }
        if (sender != button_Filter) {
            view_Filters.removeFromSuperview()
            button_Filter.selected = false
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        showOriginal()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        showFiltered()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


