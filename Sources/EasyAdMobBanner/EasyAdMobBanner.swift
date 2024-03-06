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


fileprivate var _verbose: Bool = false
fileprivate let _tag = "[EasyAdMob] "
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
        if _verbose {
            debugPrint(_tag+"Init UIViewControllerRepresentable with unit ID: \(adUnitID)")
        }
        self.adUnitID = adUnitID
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        if _verbose {
            debugPrint(_tag + "\(#function) called")
        }
        let bannerViewController = EasyAdMobBannerViewController()
        bannerView.adUnitID = self.adUnitID
        bannerView.rootViewController = bannerViewController
        bannerViewController.view.addSubview(bannerView)
        bannerViewController.bannerWidthDelegate = context.coordinator
        bannerView.delegate = context.coordinator
        if _verbose {
            debugPrint(_tag + "\(#function) finish")
        }
        return bannerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard viewWidth != .zero else { return }
        // Request a banner ad with the updated viewWidth.
        loadAd(with: viewWidth)
        updateAdSize()
    }
    
    func updateAdSize() {
        if _verbose {
            debugPrint(_tag + "\(#function)")
        }
        DispatchQueue.main.async {
            if _verbose {
                debugPrint(_tag + "\(#function) update ad size to \(bannerView.adSize.size)")
            }
            adSize = bannerView.adSize.size
            _ = preference(key: AdSizeKey.self, value: adSize)
            if _verbose {
                debugPrint(_tag + "\(#function) trigger preference change")
            }
        }
    }
    
    func loadAd(with width: CGFloat) {
        if _verbose {
            debugPrint(_tag + "\(#function)")
        }
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
            if _verbose {
                debugPrint(_tag + "\(#function)")
            }
            parent.viewWidth = width
            parent.loadAd(with: width)
            parent.updateAdSize()
        }
        
        func bannerViewController(_ bannerViewController: EasyAdMobBannerViewController, didUpdate width: CGFloat) {
            if _verbose {
                debugPrint(_tag + "\(#function)")
            }
            parent.viewWidth = width
        }
        
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            if _verbose {
                debugPrint(_tag + "\(#function)")
            }
        }
        
        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            if _verbose {
                debugPrint(_tag + "\(#function)")
            }
        }
        
        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
            if _verbose {
                debugPrint(_tag + "\(#function)")
            }
        }
        
        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
            if _verbose {
                debugPrint(_tag + "\(#function)")
            }
        }
        
        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
            if _verbose {
                debugPrint(_tag + "\(#function)")
            }
        }
        
        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
            if _verbose {
                debugPrint(_tag + "\(#function)")
            }
        }
        
        func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
            if _verbose {
                debugPrint(_tag + "\(#function)")
            }
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
        defaultValue = nextValue()
        if _verbose {
            debugPrint(_tag+"Preference Key changed: \(defaultValue)")
        }
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
    
    /// Create a google ad banner that adjust its size automatically by adSize
    /// - Parameters:
    ///   - ad_unit_id: The ad unit id that display on this banner
    public init(_ ad_unit_id: String) {
        self.ad_unit_id = ad_unit_id
        if _verbose {
            debugPrint(_tag+"init banner with unit id \(ad_unit_id)")
        }
    }
    
    /// Works on debug build only. Show debug messages with **EasyAdMob** tag
    /// - Parameter isOn: turn on verbose, default is 'true'
    public static func verbose(_ isOn: Bool = true) {
        _verbose = isOn
    }
}
