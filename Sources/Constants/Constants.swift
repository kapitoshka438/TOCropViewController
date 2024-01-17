//
//  Constants.swift
//
//
//  Created by Miniakhmetov Eduard on 17.01.2024.
//

import Foundation

/**
 The shape of the cropping region of this crop view controller
*/
internal enum TOCropViewCroppingStyle: Int {
    case default    // The regular, rectangular crop box
    case circular   // A fixed, circular crop box
}

/**
 Preset values of the most common aspect ratios that can be used to quickly configure
 the crop view controller.
 */
internal enum TOCropViewControllerAspectRatioPreset: Int {
    case presetOriginal
    case presetSquare
    case preset3x2
    case preset5x3
    case preset4x3
    case preset5x4
    case preset7x5
    case preset16x9
    case presetCustom
}

/**
 Whether the control toolbar is placed at the bottom or the top
 */
internal enum TOCropViewControllerToolbarPosition: Int {
    case bottom // Bar is placed along the bottom in portrait
    case top    // Bar is placed along the top in portrait (Respects the status bar)
}
