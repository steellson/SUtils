//  Created by Andrew Steellson on 02.04.2025.

#if canImport(UIKit)
import UIKit

/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``
/// `` ☩   UIImage +   ☩ ``
/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``

public extension UIImage {
    ///
    public func resizeImage(
        targetSize: CGSize,
        useTargetSize: Bool = false,
        propotionallyWidth: Bool = false
    ) -> UIImage? {
        let newSize: CGSize

        if useTargetSize {
            newSize = targetSize
        } else {
            let widthRatio  = targetSize.width / size.width
            let heightRatio = if propotionallyWidth {
                targetSize.width / size.width
            } else {
                targetSize.height / size.height
            }
            let isWidthRatingGreater = widthRatio > heightRatio
            let targetRatio = isWidthRatingGreater ? heightRatio : widthRatio
            newSize = CGSize(
                width: size.width * targetRatio,
                height: size.height * targetRatio
            )
        }

        return UIGraphicsImageRenderer(size: newSize).image {
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

    ///
    public func imageWithColor(color1: UIColor) -> UIImage {
        return UIGraphicsImageRenderer(
            size: size,
            format: imageRendererFormat
        ).image { context in
            color1.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }

    ///
    public func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
            .integral
            .size
        let renderer = UIGraphicsImageRenderer(size: rotatedSize)
        let rotatedImage = renderer.image { context in
            let divider = 2.0
            let origin = CGPoint(
                x: rotatedSize.width / divider,
                y: rotatedSize.height / divider
            )

            context.cgContext.translateBy(x: origin.x, y: origin.y)
            context.cgContext.rotate(by: radians)

            draw(
                in: CGRect(
                    x: -origin.x,
                    y: -origin.y,
                    width: size.width,
                    height: size.height
                )
            )
        }
        return rotatedImage
    }

    ///
    public func scaleImage(scaleFactor: CGFloat) -> UIImage {
        let newSize = CGSize(
            width: width * scaleFactor,
            height: height * scaleFactor
        )
        return UIGraphicsImageRenderer(size: newSize).image { context in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
#endif
