import UIKit

public final class StubView: UIView {
    @IBOutlet private var iconView: UIImageView! {
        didSet {
            self.iconView.templateImage = image
            self.iconView.tintColor = self.color
        }
    }

    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            self.titleLabel?.text = self.title
        }
    }

    @IBOutlet private var messageLabel: UILabel! {
        didSet {
            self.messageLabel?.text = self.message
        }
    }

    private var image: UIImage?
    private var color: UIColor = .clear

    public var title: String = "" {
        didSet {
            self.titleLabel?.text = self.title
        }
    }

    public var message: String = "" {
        didSet {
            self.messageLabel?.text = self.message
        }
    }

    func set(image: UIImage, color: UIColor) {
        self.image = image
        self.color = color
        self.iconView?.templateImage = image
        self.iconView?.tintColor = color
    }
}
