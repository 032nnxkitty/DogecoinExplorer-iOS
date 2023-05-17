//
//  ScrollableStackView.swift
//  Swift Snippets
//
//  github.com/032nnxkitty
//

import UIKit

class ScrollableStackView: UIScrollView {
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
}

// MARK: - Configuration
extension ScrollableStackView {
    public var spacing: CGFloat {
        get {
            return stackView.spacing
        }
        set {
            stackView.spacing = newValue
        }
    }
    
    public var axis: NSLayoutConstraint.Axis {
        get {
            return stackView.axis
        }
        set {
            stackView.axis = newValue
        }
    }
    
    public func addArrangedSubview(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }
}
