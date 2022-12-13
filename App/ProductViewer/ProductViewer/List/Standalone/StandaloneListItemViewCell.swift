//
//  Copyright © 2022 Target. All rights reserved.
//

import UIKit
import Kingfisher

class StandaloneListItemViewCell: UICollectionViewCell {
    static let reuseIdentifier = "StandaloneListItemViewCell"
    
    //
    lazy var listItemView: StandaloneListItemView = {
        let view = StandaloneListItemView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addAndPinSubview(contentView)
        
        contentView.addAndPinSubview(listItemView)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    /// Override to ensure the collection view item is ready for the next time it's dequeued.
    ///
    /// Any pending image downloads are canceled prior to the cell being reused.
    override func prepareForReuse() {
        super.prepareForReuse()
        
        listItemView.separator.isHidden = false
        listItemView.productImage.kf.cancelDownloadTask()
    }
}
