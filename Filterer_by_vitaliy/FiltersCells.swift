//
//  Filters.swift
//  Filterer_by_vitaliy
//
//  Created by Vitaliy Timoshenko on 3/23/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

//-----------------------------------

class ImageProcessor {
    var processedImage: RGBAImage
    
    required init(theImage: UIImage) {
        //converting image to RGBAImage during initialization
        self.processedImage = RGBAImage(image: theImage)!
    }
    
    func applySetOfFilters(filters: [(name: String, threshold: Int, power: Int)]) -> UIImage {
        for currentFilter in filters {
            switch currentFilter.name {
            case "EnhanceBrightness" : filterEnhanceBrightness(currentFilter.threshold, power: currentFilter.power)
            case "HighlightRed" : filterHighlightRed(currentFilter.threshold, power: currentFilter.power)
            case "HighlightGreen" : filterHighlightGreen(currentFilter.threshold, power: currentFilter.power)
            case "HighlightBlue" : filterHighlightBlue(currentFilter.threshold, power: currentFilter.power)
            default : print("error: proper filter for label \(currentFilter.name) not found")
            }
        }
        return self.toUIImage()
    }
    
    func applyDefaultFilter (chosenFilter: String) -> UIImage {
        let default_filters: [String: [(name: String, threshold: Int, power: Int)]] =
            [
                "RedFace": [("HighlightRed", 170, 300),("EnhanceBrightness", 500, 25)],
                "GreenNature": [("HighlighGreen", 170, 300),("HighlightRed", 200, 150)],
                "OutstandingBrightness": [("EnhanceBrightness", 500, 25),("EnhanceBrightness", 500, 25),("HighlightBlue", 200, 150)]
        ]
        return self.applySetOfFilters(default_filters[chosenFilter]!)
    }
    
    func toUIImage () -> UIImage {
        return self.processedImage.toUIImage()!
    }
    
    // here goes a set of filters
    // all filters recieve two parameters: "threshold" and "power"
    // if the sum of pixels is less then "threshold" - they won't be affected, "threshold" can be between 0 and 255
    // and the ones that are brighter than "threshold" will be increased by "power", where "power" can be from 1 to 100
    
    func filterEnhanceBrightness(threshold: Int, power: Int)
        // this filter will enhance image by increasing brightness of pixels
    {
        for row in 0..<processedImage.height {
            for column in 0..<processedImage.width {
                let index = row * processedImage.width + column
                var pixel = processedImage.pixels[index] //accessing particular pixel in the processedImage
                let pixelbrightness = (Int(pixel.green) + Int(pixel.red) + Int(pixel.blue))
                
                if (pixelbrightness > threshold) //max sum of pixels is 765
                {
                    pixel.green = UInt8(min(255, (Int(pixel.green) + Int((Double(pixel.green) * (Double(power) / 100))))))
                    pixel.red = UInt8(min(255, (Int(pixel.red) + Int((Double(pixel.red) * (Double(power) / 100))))))
                    pixel.blue = UInt8(min(255, (Int(pixel.blue) + Int((Double(pixel.blue) * (Double(power) / 100))))))
                }
                processedImage.pixels[index] = pixel
            }
        }
    }
    
    func filterHighlightRed(threshold: Int, power: Int)
        // this filter will boost red colors
    {
        for row in 0..<processedImage.height {
            for column in 0..<processedImage.width {
                let index = row * processedImage.width + column
                var pixel = processedImage.pixels[index] //accessing particular pixel in the processedImage
                let nonredbrightness = Int(pixel.green) + Int(pixel.blue)
                let redbrightness = Int(pixel.red)
                
                if (redbrightness > threshold  // working only on pixels that already have particular redness
                    && nonredbrightness > 50) // trying to keep black as much as possible
                {
                    pixel.red = UInt8(min(255, (Int(pixel.red) + Int((Double(pixel.red) * (Double(power) / 100))))))
                }
                processedImage.pixels[index] = pixel
            }
        }
    }
    
    func filterHighlightGreen(threshold: Int, power: Int)
        // this filter will boost green colors
    {
        for row in 0..<processedImage.height
        {
            for column in 0..<processedImage.width
            {
                let index = row * processedImage.width + column
                var pixel = processedImage.pixels[index] //accessing particular pixel in the processedImage
                let nongreenbrightness = Int(pixel.red) + Int(pixel.blue)
                let greenbrightness = Int(pixel.green)
                if (greenbrightness > threshold  // working only on pixels that already have particular redness
                    && nongreenbrightness > 50) // trying to keep black as much as possible
                {
                    pixel.green = UInt8(min(255, (Int(pixel.green) + Int((Double(pixel.green) * (Double(power) / 100))))))
                }
                processedImage.pixels[index] = pixel
            }
        }
    }
    
    func filterHighlightBlue(threshold: Int, power: Int)
        // this filter will boost blue colors
    {
        for row in 0..<processedImage.height
        {
            for column in 0..<processedImage.width
            {
                let index = row * processedImage.width + column
                var pixel = processedImage.pixels[index] //accessing particular pixel in the processedImage
                let nonbluebrightness = Int(pixel.green) + Int(pixel.red)
                let bluebrightness = Int(pixel.blue)
                if (bluebrightness > threshold  // working only on pixels that already have particular redness
                    && nonbluebrightness > 50) // trying to keep black as much as possible
                {
                    pixel.blue = UInt8(min(255, (Int(pixel.blue) + Int((Double(pixel.blue) * (Double(power) / 100))))))
                }
                processedImage.pixels[index] = pixel
            }
        }
    }
}




//-----------------------------------------
// setting different types of predefined filters
// by creating a set of Tuples (https://medium.com/swift-programming/swift-tuple-328aecff50e7#.wx23u3ui3)

typealias Filter = (name: String, threshold: Int, power: Int)
let brighter_f: Filter = ("EnhanceBrightness", 500, 25)
let weak_red_f: Filter = ("HighlightRed", 200, 150)
let aggressive_red_f: Filter = ("HighlightRed", 170, 200)
let weak_green_f: Filter = ("HighlightGreen", 200, 150)
let agressive_green_f: Filter = ("HighlightGreen", 170, 200)
let weak_blue_f: Filter = ("HighlightBlue", 200, 150)
let agressive_blue_f: Filter = ("HighlightBlue", 170, 200)

//-----------------------------------------
// working with the image here by applying the necessary set of filters directly to the UIImage
// ImageProcessor takes UIImage as input and converts it to RGBAImage by itself in its initializer
// the applySetOfFilters method automatically converts image back to UIImage

// applying a couple of filters from the set of predefined filters
// let brighterImage = ImageProcessor(theImage: inImage).applySetOfFilters([brighter_f,weak_red_f])

//applying a default filter defined in the ImageProcessor class
// let imageWithDefaultFilter = ImageProcessor(theImage: inImage).applyDefaultFilter("RedFace")
    