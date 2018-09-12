//
//  ATCLiquidCollectionViewLayout.swift
//  NewsReader
//
//  Created by Florian Marcu on 3/21/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import UIKit

public protocol ATCLiquidLayoutDelegate: class {
    func collectionView(collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath, width: CGFloat) -> CGFloat
    func collectionViewCellWidth(collectionView: UICollectionView) -> CGFloat
}

public class ATCLiquidCollectionViewLayout: ATCCollectionViewFlowLayout {

    fileprivate let cellPadding: CGFloat
    var cachedWidth: CGFloat = 0.0

    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    fileprivate var contentHeight: CGFloat  = 0.0
    fileprivate var contentWidth: CGFloat {
        if let collectionView = collectionView {
            let insets = collectionView.contentInset
            return collectionView.bounds.width - (insets.left + insets.right)
        }
        return 0
    }
    fileprivate var numberOfItems = 0

    init(cellPadding: CGFloat = 0.0) {
        self.cellPadding = cellPadding
        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override public func prepare() {
        guard let collectionView = collectionView, let delegate = delegate else { return }

        let cellWidth = delegate.collectionViewCellWidth(collectionView: collectionView)

        let numberOfColumns = cellWidth > 0 ? Int(contentWidth / cellWidth) : 1 // #3
        let totalSpaceWidth = contentWidth - CGFloat(numberOfColumns) * cellWidth
        let horizontalPadding = totalSpaceWidth / CGFloat(numberOfColumns + 1)
        let numberOfItems = collectionView.numberOfItems(inSection: 0)

        if (contentWidth != cachedWidth || self.numberOfItems != numberOfItems) { // #1
            cache = []
            contentHeight = 0
            self.numberOfItems = numberOfItems
        }

        if cache.isEmpty { // #2
            cachedWidth = contentWidth
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * cellWidth + CGFloat(column + 1) * horizontalPadding)
            }
            var column = 0
            var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)

            for row in 0 ..< numberOfItems {

                let indexPath = IndexPath(row: row, section: 0)

                let cellHeight = delegate.collectionView(collectionView: collectionView, heightForCellAtIndexPath: indexPath, width: cellWidth)
                let height = cellPadding +  cellHeight + cellPadding
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: cellWidth, height: height)
                let insetFrame = frame.insetBy(dx: 0, dy: cellPadding)

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath as IndexPath) // #4
                attributes.frame = insetFrame // #5
                cache.append(attributes) // #6

                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height

                if column >= (numberOfColumns - 1) {
                    column = 0
                } else {
                    column = column + 1
                }
            }
        }
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()

        for attributes in cache { // #7
            if attributes.frame.intersects(rect) { // #8
                layoutAttributes.append(attributes) // #9
            }
        }
        return layoutAttributes
    }

    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.row < cache.count {
            return cache[indexPath.row]
        }
        return nil
    }
}
