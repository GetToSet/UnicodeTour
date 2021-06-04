/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation
import CoreText
import UIKit

protocol TraitProcessingContext {

  init(boundingBox: CGRect)
  func process(run: CTRun, range: CFRange, font: CTFont)
  func getTraitAndDestroy() -> RenderingTrait.Mode

}

private struct PathTraitProcessingContext: TraitProcessingContext {

  private let path = CGMutablePath()
  private let boundingBox: CGRect

  init(boundingBox: CGRect) {
    self.boundingBox = boundingBox
  }

  func process(run: CTRun, range: CFRange, font: CTFont) {
    var position = CGPoint()
    CTRunGetPositions(run, range, &position)

    var glyph = CGGlyph()
    CTRunGetGlyphs(run, range, &glyph)
    // Get PATH of outline
    if let letter = CTFontCreatePathForGlyph(font, glyph, nil) {
      path.addPath(
        letter,
        transform: CGAffineTransform(translationX: position.x, y: position.y)
      )
    }
  }

  func getTraitAndDestroy() -> RenderingTrait.Mode {
    var transform = CGAffineTransform(
      translationX: -boundingBox.width / 2 - boundingBox.origin.x,
      y: -boundingBox.height / 2 - boundingBox.origin.y
    )
    let finalPath = path.copy(using: &transform)

    var bezierPath: UIBezierPath? = nil
    if let finalPath = finalPath {
      bezierPath = UIBezierPath(cgPath: finalPath)
    }

    return .bezierPath(bezierPath)
  }

}

private struct ImageTraitProcessingContext: TraitProcessingContext {

  var context: CGContext!
  var contextReady: Bool = false

  var boundingBox: CGRect

  init(boundingBox: CGRect) {
    UIGraphicsBeginImageContextWithOptions(boundingBox.size, false, UIScreen.main.scale)
    self.context = UIGraphicsGetCurrentContext()
    self.contextReady = (context != nil)
    self.boundingBox = boundingBox
    if contextReady {
      context.translateBy(
        x: boundingBox.origin.x,
        y: boundingBox.origin.y + boundingBox.height
      )
      context.scaleBy(x: 1, y: -1)
    }
  }

  func process(run: CTRun, range: CFRange, font: CTFont) {
    if contextReady {
      CTRunDraw(run, context, range)
    }
  }

  func getTraitAndDestroy() -> RenderingTrait.Mode {
    var image: UIImage?
    if contextReady {
      image = UIGraphicsGetImageFromCurrentImageContext()
    }

    UIGraphicsEndImageContext()

    return .image(image)
  }

}

extension String {

  func renderingTrait(size: CGFloat, usesImageMode: Bool) -> RenderingTrait {
    var fontNames = [String]()

    let font = UIFont.cachedbookFont(ofSize: size)

    let attrString = NSAttributedString(
      string: self,
      attributes: [
        NSAttributedString.Key.font: font
      ]
    )

    let line = CTLineCreateWithAttributedString(attrString as CFAttributedString)
    let runArray = CTLineGetGlyphRuns(line) as! [CTRun]

    let boundingBox = CTLineGetBoundsWithOptions(line, [])

    let context: TraitProcessingContext = usesImageMode
      ? ImageTraitProcessingContext(boundingBox: boundingBox)
      : PathTraitProcessingContext(boundingBox: boundingBox)

    // for each RUN
    for run in runArray {
      let attributes = CTRunGetAttributes(run) as! [NSAttributedString.Key: Any]
      let runFont = attributes[.font] as! CTFont
      fontNames.append(CTFontCopyPostScriptName(runFont) as String)

      // for each GLYPH in run
      for runGlyphIndex in 0..<CTRunGetGlyphCount(run) {
        // get Glyph & Glyph-data
        let glyphRange = CFRange(location: runGlyphIndex, length: 1)

        context.process(run: run, range: glyphRange, font: runFont)
      }
    }

    return RenderingTrait(
      mode: context.getTraitAndDestroy(),
      fontNames: fontNames
    )
  }

}
