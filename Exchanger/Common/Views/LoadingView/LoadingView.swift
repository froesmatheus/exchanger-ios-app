import UIKit

final class LoadingView: UIView {
    private var contentView: UIView!
    
    @IBOutlet private(set) var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private(set) var labelLoading: UILabel!
    @IBOutlet private(set) var buttonTryAgain: UIButton!
    
    override func awakeFromNib() {
        buttonTryAgain.isHidden = true
        buttonTryAgain.isUserInteractionEnabled = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView = instantiateXIB()
        
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(contentView)
    }
    
    func instantiateXIB() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let view = (nib.instantiate(withOwner: self, options: nil).first as? UIView) else {
            fatalError("Error instantiating \(String(describing: type(of: self)))")
        }

        return view
    }
}
