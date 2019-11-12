import UIKit

final class LoadingViewManager: NSObject {
    private var loadingView = LoadingView()
    private weak var delegate: LoadingViewDelegate?

    init(delegate: LoadingViewDelegate?) {
        self.delegate = delegate
    }

    func showLoading(superView: UIView) {
        setupView(inSuperview: superView)

        loadingView.labelLoading.text = "Loading"
        loadingView.buttonTryAgain.isHidden = true
        loadingView.buttonTryAgain.isUserInteractionEnabled = false
        loadingView.activityIndicator.startAnimating()
    }

    func showError(superView: UIView, message: String) {
        setupView(inSuperview: superView)
        
        loadingView.labelLoading.text = message
        loadingView.activityIndicator.stopAnimating()
        loadingView.buttonTryAgain.isHidden = false
        loadingView.buttonTryAgain.isUserInteractionEnabled = true
    }

    private func setupView(inSuperview superView: UIView) {
        removeLoading()
        
        superView.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        loadingView.leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        loadingView.rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        loadingView.buttonTryAgain.addTarget(self, action: #selector(didTapTryAgain), for: .touchUpInside)
    }

    @objc
    private func didTapTryAgain() {
        delegate?.didTapTryAgain()
    }
    
    func removeLoading() {
        loadingView.removeFromSuperview()
    }
}
