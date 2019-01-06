
import UIKit

class canvasMarker: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imgPicture: UIImageView?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var btnMarker: UIButton!
    
    var objPeopleList = PeopleList()

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "canvasMarker", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    public func setUpView() {
        self.imgPicture?.cornerRadius = (self.imgPicture?.frame.size.width)! / 2
        self.imgPicture?.layer.masksToBounds = true
        
        contentView.cornerRadius = 8
        contentView.layer.shadowOffset = CGSize(width: 0, height: 7)
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.masksToBounds = true
    }
}
