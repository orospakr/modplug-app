//
//  Cropped.swift
//  ModPlug
//
//  Created by Andrew Clunis on 2019-12-01.
//  Copyright © 2019 Andrew Clunis. All rights reserved.
//

import SwiftUI

struct Cropped: ViewModifier {
    var coordinates: CGRect
    
    func body(content: Content) -> some View {
        content
            .padding(
                // "position the viewport" using negative paddings on the leading and top edges.
                EdgeInsets(
                    top: self.coordinates.minY * -1,
                    leading: self.coordinates.minX * -1,
                    bottom: 0,
                    trailing: 0
                )
            )
            // and clip the desired size using frame. this is the part where the top-left origin is effectively applied.
            .frame(width: coordinates.width, height: coordinates.height, alignment: .topLeading)
            .clipped()
    }
}

extension View {
    /// The origin of the coordinate space is in the top left, iOS-style.
    func croppedTo(_ coordinates: CGRect) -> some View {
        return self.modifier(Cropped(coordinates: coordinates))
    }
}

struct CroppedImage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Image("MODPLUG.EXE_2_LCDSCREEN")
                .interpolation(.none)
                .previewDisplayName("Entire thing")
            
            Image("MODPLUG.EXE_2_LCDSCREEN")
                .interpolation(.none)
                .croppedTo(CGRect.init(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 20, height: 10)))
                .previewDisplayName("MIN")
            
            Image("MODPLUG.EXE_2_LCDSCREEN")
                .interpolation(.none)
                .croppedTo(CGRect.init(origin: CGPoint(x: 345, y: 75), size: CGSize(width: 18, height: 10)))
                .previewDisplayName("HQ")
        }
        .previewLayout(.sizeThatFits)
    }
}
