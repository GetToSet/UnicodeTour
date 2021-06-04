/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import UIKit
import SwiftUI

final class RichTextDescriptionUIView: UITextView, UITextViewDelegate {

  var descriptionText: String = "" {
    didSet {
      if descriptionText != oldValue {
        reformatLinks()
      }
    }
  }

  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    commonInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  private func commonInit() {
    delegate = self

    // Make sure link is clickable
    isEditable = false
    isSelectable = true

    // Remove all paddings
    textContainerInset = .zero
    textContainer.lineFragmentPadding = 0

    backgroundColor = .clear

    reformatLinks()
  }

  private func reformatLinks() {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
    attributedText = descriptionText.formatLinks(
      baseAttributes: [
        .paragraphStyle: paragraphStyle,
        .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
      ]
    )
  }

}

struct RichTextDescriptionView: UIViewRepresentable {

  final class Coordiantor: NSObject, UITextViewDelegate {

    var parent: RichTextDescriptionView
    var linkHander: ((URL) -> Void)? = nil

    init(_ parent: RichTextDescriptionView) {
      self.parent = parent
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//      print(URL)
      linkHander?(URL)
      return false
    }

  }

  var descriptionText: String
  var linkHander: ((URL) -> Void)? = nil

  func makeCoordinator() -> Coordiantor {
    return Coordiantor(self)
  }

  func makeUIView(context: Context) -> RichTextDescriptionUIView {
    let view = RichTextDescriptionUIView()
    view.delegate = context.coordinator
    return view
  }

  func updateUIView(_ uiView: RichTextDescriptionUIView, context: Context) {
    uiView.descriptionText = descriptionText
    context.coordinator.linkHander = linkHander
  }

}
