//
//  CaptureSaver.swift
//  Nitro
//
//  Created by Luke Chambers on 7/5/20.
//

import Foundation
import SwiftUI

class CaptureSaver: NSObject {
    private var done = 0
    private var error = false
    
    private func saveCapture(of uiImages: [UIImage?]) -> Bool {
        let images = uiImages.filter { $0 != nil }
        for image in images {
            UIImageWriteToSavedPhotosAlbum(
                image!, self, #selector(saveError), nil
            )
        }
        
        while done < uiImages.count { continue }
        
        let success = !error
        done = 0
        error = false
        
        return success
    }
    
    @objc func saveError(
        _ image: UIImage,
        didFinishSavingWithError error: Error?,
        contextInfo: UnsafeRawPointer
    ) {
        self.error = error != nil
        done += 1
    }
    
    func saveBoth(from ntrStream: NtrStream?) -> Bool {
        return saveCapture(of: [
            ntrStream!.uiTopImage,
            ntrStream!.uiBottomImage
        ])
    }
    
    func saveTop(from ntrStream: NtrStream?) -> Bool {
        return saveCapture(of: [ntrStream!.uiTopImage])
    }
    
    func saveBottom(from ntrStream: NtrStream?) -> Bool {
        return saveCapture(of: [ntrStream!.uiBottomImage])
    }
}
