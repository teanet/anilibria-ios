import UIKit

// MARK: - View Controller

final class OtherViewController: BaseViewController {
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var authButton: UIButton!
    @IBOutlet var linksStakView: UIStackView!

    var handler: OtherEventHandler!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.handler.didLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Actions

    @IBAction func loginLogOutAction(_ sender: Any) {
        self.handler.loginOrLogout()
    }

    @IBAction func historyAction(_ sender: Any) {
        self.handler.history()
    }

    @IBAction func teamAction(_ sender: Any) {
        self.handler.team()
    }

    @IBAction func donateAction(_ sender: Any) {
        self.handler.donate()
    }

    @IBAction func settingsAction(_ sender: Any) {
        self.handler.settings()
    }
}

extension OtherViewController: OtherViewBehavior {
    func set(user: User?) {
        self.userNameLabel.text = user?.name ?? L10n.Common.guest
        let title = user == nil ? L10n.Buttons.signIn : L10n.Buttons.signOut
        self.authButton.setTitle(title, for: .normal)
    }

    func set(links: [LinkData]) {
        let views = links.lazy.compactMap { item -> LinkView? in
            let view = LinkView.fromNib()
            view?.configure(item)
            view?.setTap { [weak self] in
                self?.handler.tap(link: $0)
            }
            return view
        }
        for view in views {
            self.linksStakView.addArrangedSubview(view)
        }
    }
}
