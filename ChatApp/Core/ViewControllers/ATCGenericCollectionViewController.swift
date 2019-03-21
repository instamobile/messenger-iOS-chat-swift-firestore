//
//  ATCGenericCollectionViewController.swift
//  ShoppingApp
//
//  Created by Florian Marcu on 10/15/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import UIKit

protocol ATCGenericFirebaseParsable {
    init(key: String, jsonDict: [String: Any])
}

protocol ATCGenericJSONParsable {
    init(jsonDict: [String: Any])
}

protocol ATCGenericBaseModel: ATCGenericJSONParsable, CustomStringConvertible {
}

protocol ATCGenericCollectionViewControllerDataSourceDelegate: class {
    func genericCollectionViewControllerDataSource(_ dataSource: ATCGenericCollectionViewControllerDataSource, didLoadFirst objects: [ATCGenericBaseModel])
    func genericCollectionViewControllerDataSource(_ dataSource: ATCGenericCollectionViewControllerDataSource, didLoadBottom objects: [ATCGenericBaseModel])
    func genericCollectionViewControllerDataSource(_ dataSource: ATCGenericCollectionViewControllerDataSource, didLoadTop objects: [ATCGenericBaseModel])
}

protocol ATCGenericCollectionViewScrollDelegate: class {
    func genericScrollView(_ scrollView: UIScrollView, didScrollToPage page: Int)
}

protocol ATCGenericCollectionViewControllerDataSource: class {
    var delegate: ATCGenericCollectionViewControllerDataSourceDelegate? {get set}

    func object(at index: Int) -> ATCGenericBaseModel?
    func numberOfObjects() -> Int

    func loadFirst()
    func loadBottom()
    func loadTop()
}

protocol ATCGenericCollectionRowAdapter: class {
    func configure(cell: UICollectionViewCell, with object: ATCGenericBaseModel)
    func cellClass() -> UICollectionViewCell.Type
    func size(containerBounds: CGRect, object: ATCGenericBaseModel) -> CGSize
}

class ATCAdapterStore {
    fileprivate var store = [String: ATCGenericCollectionRowAdapter]()

    func add(adapter: ATCGenericCollectionRowAdapter, for classString: String) {
        store[classString] = adapter
    }

    func adapter(for classString: String) -> ATCGenericCollectionRowAdapter? {
        return store[classString]
    }
}

struct ATCGenericCollectionViewControllerConfiguration {
    let pullToRefreshEnabled: Bool
    let pullToRefreshTintColor: UIColor
    let collectionViewBackgroundColor: UIColor
    let collectionViewLayout: ATCCollectionViewFlowLayout
    let collectionPagingEnabled: Bool
    let hideScrollIndicators: Bool
    let hidesNavigationBar: Bool
    let headerNibName: String?
    let scrollEnabled: Bool
    let uiConfig: ATCUIGenericConfigurationProtocol
}

typealias ATCollectionViewSelectionBlock = (UINavigationController?, ATCGenericBaseModel) -> Void

/* A generic view controller, that encapsulates:
 * - fetching data from a data store (over the network, firebase, local cache, etc)
 * - adapting a model type to a cell type
 * - persisiting data on disk
 * - manages pagination
 */
class ATCGenericCollectionViewController: UICollectionViewController {
    var genericDataSource: ATCGenericCollectionViewControllerDataSource? {
        didSet {
            genericDataSource?.delegate = self
        }
    }

    weak var scrollDelegate: ATCGenericCollectionViewScrollDelegate?

    fileprivate var adapterStore = ATCAdapterStore()
    let configuration: ATCGenericCollectionViewControllerConfiguration

    fileprivate lazy var refreshControl = UIRefreshControl()
    fileprivate lazy var activityIndicator = UIActivityIndicatorView(style: .gray)
    var selectionBlock: ATCollectionViewSelectionBlock?

    init(configuration: ATCGenericCollectionViewControllerConfiguration, selectionBlock: ATCollectionViewSelectionBlock? = nil) {
        self.configuration = configuration
        self.selectionBlock = selectionBlock
        let layout = configuration.collectionViewLayout
        super.init(collectionViewLayout: layout)
        layout.delegate = self
        self.use(adapter: ATCCarouselAdapter(uiConfig: configuration.uiConfig), for: "ATCCarouselViewModel")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        print("home view controller did load")
        super.viewDidLoad()
        guard let collectionView = collectionView else {
            fatalError()
        }

        collectionView.backgroundColor = configuration.collectionViewBackgroundColor
        collectionView.isPagingEnabled = configuration.collectionPagingEnabled
        collectionView.isScrollEnabled = configuration.scrollEnabled
        registerReuseIdentifiers()
        if configuration.pullToRefreshEnabled {
            collectionView.addSubview(refreshControl)
            refreshControl.tintColor = configuration.pullToRefreshTintColor
            refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        }
        if configuration.hideScrollIndicators {
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
        }
        activityIndicator.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.minY + 50)
        collectionView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        genericDataSource?.loadFirst()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (configuration.hidesNavigationBar) {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (configuration.hidesNavigationBar) {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }

    func use(adapter: ATCGenericCollectionRowAdapter, for classString: String) {
        adapterStore.add(adapter: adapter, for: classString)
    }

    // MARK: - Private

    private func registerReuseIdentifiers() {
        adapterStore.store.forEach { (key, adapter) in
            collectionView?.register(UINib(nibName: String(describing: adapter.cellClass()), bundle: nil), forCellWithReuseIdentifier: key)
        }
        if let headerNib = configuration.headerNibName {
            collectionView?.register(UINib(nibName: headerNib, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerNib)
        }
    }

    private func size(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize {
        if let adapter = self.adapter(at: indexPath), let object = genericDataSource?.object(at: indexPath.row) {
            return adapter.size(containerBounds: collectionView.bounds, object: object)
        }
        return .zero
    }

    private func adapter(at indexPath: IndexPath) -> ATCGenericCollectionRowAdapter? {
        if let object = genericDataSource?.object(at: indexPath.row) {
            let stringClass = String(describing: type(of: object))
            if let adapter = adapterStore.adapter(for: stringClass) {
                return adapter
            }
        }
        return nil
    }

    @objc func didPullToRefresh() {
        genericDataSource?.loadTop()
    }
}

extension ATCGenericCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let object = genericDataSource?.object(at: indexPath.row) {
            let stringClass = String(describing: type(of: object))
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: stringClass, for: indexPath)
            if let adapter = adapterStore.adapter(for: stringClass) {
                adapter.configure(cell: cell, with: object)
            }
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectionBlock = selectionBlock,
            let object = genericDataSource?.object(at: indexPath.row) {
            var navController = self.navigationController
            if (navController == nil) {
                navController = self.parent?.navigationController
            }
            if (navController == nil) {
                navController = self.parent?.parent?.navigationController
            }
            selectionBlock(navController, object)
        }
    }

    override open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assert(genericDataSource != nil)
        return genericDataSource?.numberOfObjects() ?? 0
    }

    override open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 1 >= (genericDataSource?.numberOfObjects() ?? 0) {
            genericDataSource?.loadBottom()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            let id = configuration.headerNibName ?? "header"
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath)
        } else if (kind == UICollectionView.elementKindSectionFooter) {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
        }
        fatalError()
    }
}

extension ATCGenericCollectionViewController {
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        if w != 0 {
            let page = Int(ceil(x/w))
            scrollDelegate?.genericScrollView(scrollView, didScrollToPage: page)
        }
    }
}

extension ATCGenericCollectionViewController: ATCLiquidLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath, width: CGFloat) -> CGFloat {
        return self.size(collectionView: collectionView, indexPath: indexPath).height
    }

    func collectionViewCellWidth(collectionView: UICollectionView) -> CGFloat {
        return self.size(collectionView: collectionView, indexPath: IndexPath(row: 0, section: 0)).width
    }
}

extension ATCGenericCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.size(collectionView: collectionView, indexPath: indexPath)
    }
}

extension ATCGenericCollectionViewController: ATCGenericCollectionViewControllerDataSourceDelegate {
    func genericCollectionViewControllerDataSource(_ dataSource: ATCGenericCollectionViewControllerDataSource, didLoadFirst objects: [ATCGenericBaseModel]) {
        activityIndicator.stopAnimating()
        self.reloadCollectionView()
    }

    func genericCollectionViewControllerDataSource(_ dataSource: ATCGenericCollectionViewControllerDataSource, didLoadBottom objects: [ATCGenericBaseModel]) {
        let offset = dataSource.numberOfObjects() - objects.count
        self.collectionView?.performBatchUpdates({
            let indexPaths = (0 ..< objects.count).map({ IndexPath(row: offset + $0, section: 0)})
            self.collectionView?.insertItems(at: indexPaths)
        }, completion: nil)
    }

    func genericCollectionViewControllerDataSource(_ dataSource: ATCGenericCollectionViewControllerDataSource, didLoadTop objects: [ATCGenericBaseModel]) {
        if (configuration.pullToRefreshEnabled) {
            refreshControl.endRefreshing()
        }
        self.reloadCollectionView()
    }

    private func reloadCollectionView() {
        assert(Thread.isMainThread)
        self.collectionView?.reloadData()
        self.collectionView?.collectionViewLayout.invalidateLayout()
        if let parent = self.parent as? ATCGenericCollectionViewController {
            parent.reloadCollectionView()
        }
    }
}
