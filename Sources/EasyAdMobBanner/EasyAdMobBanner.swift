//
//  EasyAdMobBanner.swift
//
//
//  Created by Chen Hai Teng on 3/6/24.
//

import SwiftUI
import UIKit
import Combine
import GoogleMobileAds

// Prefix: EasyAdMob
/// Delegate methods for receiving width update messages.
protocol EasyAdMobBannerWidthDelegate: AnyObject {
    func bannerViewController(_ bannerViewController: EasyAdMobBannerViewController, didAppear width: CGFloat)
    func bannerViewController(_ bannerViewController: EasyAdMobBannerViewController, didUpdate width: CGFloat)
}

class EasyAdMobBannerViewController: UIViewController {
  weak var bannerWidthDelegate: EasyAdMobBannerWidthDelegate?

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    // Tell the delegate the initial ad width.
      bannerWidthDelegate?.bannerViewController(
      self, didAppear: view.frame.inset(by: view.safeAreaInsets).size.width)
  }

  override func viewWillTransition(
    to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator
  ) {
    coordinator.animate(alongsideTransition: nil) { _ in
      // Notify the delegate of ad width changes.
      self.bannerWidthDelegate?.bannerViewController(
        self, didUpdate: self.view.frame.inset(by: self.view.safeAreaInsets).size.width)
    }
  }
}

struct EasyBannerRepresentable: UIViewControllerRepresentable {
    
    @State private var viewWidth: CGFloat = .zero
    private let bannerView = GADBannerView()
    private let adUnitID: String
    @State var adSize: CGSize = .zero
    
    init(_ adUnitID: String) {
        debugPrint("banner adUnit: \(adUnitID)")
        self.adUnitID = adUnitID
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let bannerViewController = EasyAdMobBannerViewController()
        bannerView.adUnitID = self.adUnitID
        bannerView.rootViewController = bannerViewController
        bannerViewController.view.addSubview(bannerView)
        bannerViewController.bannerWidthDelegate = context.coordinator
        bannerView.delegate = context.coordinator
        return bannerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard viewWidth != .zero else { return }
        // Request a banner ad with the updated viewWidth.
        loadAd(with: viewWidth)
        updateAdSize()
    }
    
    func updateAdSize() {
        DispatchQueue.main.async {
            adSize = bannerView.adSize.size
            _ = preference(key: AdSizeKey.self, value: adSize)
        }
    }
    
    func loadAd(with width: CGFloat) {
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(width)
        bannerView.load(GADRequest())
    }
    
    func makeCoordinator() -> Coordinator {
        EasyBannerRepresentable.Coordinator(self)
    }
    
    internal class Coordinator: NSObject, GADBannerViewDelegate, EasyAdMobBannerWidthDelegate {
        let parent: EasyBannerRepresentable
        init(_ parent: EasyBannerRepresentable) {
            self.parent = parent
        }
        
        func bannerViewController(_ bannerViewController: EasyAdMobBannerViewController, didAppear width: CGFloat) {
            parent.viewWidth = width
            parent.loadAd(with: width)
            parent.updateAdSize()
        }
        
        func bannerViewController(_ bannerViewController: EasyAdMobBannerViewController, didUpdate width: CGFloat) {
            parent.viewWidth = width
        }
        
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            debugPrint("\(#function) called")
        }
        
        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            debugPrint("\(#function) called")
        }
        
        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
            debugPrint("\(#function) called")
        }
        
        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
            debugPrint("\(#function) called")
        }
        
        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
            debugPrint("\(#function) called")
        }
        
        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
            debugPrint("\(#function) called")
        }
        
        func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
            debugPrint("\(#function) called")
        }
    }
}

struct AdSizeKey : PreferenceKey {
    
    public static func defaultSize() -> CGSize {
        var adSize: GADAdSize
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            adSize = GADAdSizeFullBanner
        case .phone:
            adSize = GADAdSizeBanner
        default:
            adSize = GADAdSizeBanner
        }
        return adSize.size
    }
    
    static var defaultValue: CGSize = defaultSize()
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        debugPrint("[adSize] nextValue: \(nextValue())")
        defaultValue = nextValue()
        debugPrint("[adSize] update nextValue: \(defaultValue)")
    }
}

public struct EasyAdMobBanner : View {
    @State private var size: CGSize = .zero
    let ad_unit_id: String
    public var body: some View {
        EasyBannerRepresentable(ad_unit_id).frame(width: size.width, height: size.height).onPreferenceChange(AdSizeKey.self) { newSize in
            size = newSize
        }
    }
    
    public init(_ ad_unit_id: String) {
        self.ad_unit_id = ad_unit_id
    }
}
