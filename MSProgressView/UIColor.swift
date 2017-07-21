//
//  UIColor.swift
//  MSProgressView
//
//  Created by Michael Schloss on 7/20/17.
//  Copyright © 2017 Michael Schloss. All rights reserved.
//

extension UIColor
{
    var lighter : UIColor
    {
        var alpha : CGFloat = 0.0
        var red   : CGFloat = 0.0
        var green : CGFloat = 0.0
        var blue  : CGFloat = 0.0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red: red + 0.1, green: green + 0.1, blue: blue + 0.1, alpha: alpha)
    }
}
