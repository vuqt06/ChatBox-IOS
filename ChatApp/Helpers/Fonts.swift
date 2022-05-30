//
//  Fonts.swift
//  ChatApp
//
//  Created by Vu Trinh on 5/27/22.
//

import Foundation
import SwiftUI

extension Font {
    public static var bodyParagraph: Font {
        return Font.custom("LexendDeca-Regular", size: 14)
    }
    
    public static var button: Font {
        return Font.custom("LexendDeca-Semibold", size: 14)
    }
    
    public static var smallText: Font {
        return Font.custom("LexendDeca-Regular", size: 10)
    }
    
    public static var tabBar: Font {
        return Font.custom("LexendDeca-Regular", size: 12)
    }
    
    public static var settings: Font {
        return Font.custom("LexendDeca-Regular", size: 12)
    }
    
    public static var titleText: Font {
        return Font.custom("LexendDeca-Bold", size: 23)
    }
    
    public static var pageTitle: Font {
        return Font.custom("LexendDeca-Semibold", size: 33)
    }
    
    public static var chatHeading: Font {
        return Font.custom("LexendDeca-Semibold", size: 19)
    }
}
