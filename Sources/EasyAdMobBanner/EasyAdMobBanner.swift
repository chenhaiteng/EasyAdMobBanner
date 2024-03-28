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
import OSLog

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
        log("\(#function): id: \(adUnitID)")
        self.adUnitID = adUnitID
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        log("\(#function) begin")
        let bannerViewController = EasyAdMobBannerViewController()
        bannerView.adUnitID = self.adUnitID
        bannerView.rootViewController = bannerViewController
        bannerViewController.view.addSubview(bannerView)
        bannerViewController.bannerWidthDelegate = context.coordinator
        bannerView.delegate = context.coordinator
        log("\(#function) end")
        return bannerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        log("\(#function)")
        guard viewWidth != .zero else { return }
        // Request a banner ad with the updated viewWidth.
        loadAd(with: viewWidth)
        updateAdSize()
    }
    
    func updateAdSize() {
        log("\(#function)")
        DispatchQueue.main.async {
            log("\(#function): update ad size to \(bannerView.adSize.size)")
            adSize = bannerView.adSize.size
            _ = preference(key: AdSizeKey.self, value: adSize)
            log("\(#function): trigger preference change")
        }
    }
    
    func loadAd(with width: CGFloat) {
        log("\(#function): width: \(width)")
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
            log("\(#function): width: \(width)")
            parent.viewWidth = width
            parent.loadAd(with: width)
            parent.updateAdSize()
        }
        
        func bannerViewController(_ bannerViewController: EasyAdMobBannerViewController, didUpdate width: CGFloat) {
            log("\(#function): width: \(width)")
            parent.viewWidth = width
        }
        
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            log("\(#function)")
        }
        
        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            log("\(#function): error: \(error)")
        }
        
        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
            log("\(#function)")
        }
        
        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
            log("\(#function)")
        }
        
        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
            log("\(#function)")
        }
        
        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
            log("\(#function)")
        }
        
        func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
            log("\(#function)")
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
        log("Preference Key changed: \(defaultValue)")
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
        log("init banner with unit id \(ad_unit_id)")
    }
    
    /// Works on debug build only. Show debug messages with **EasyAdMob** tag
    /// - Parameter isOn: turn on verbose, default is 'true'
    public static func verbose(_ isOn: Bool = true) {
        _verbose = isOn
    }
}

fileprivate func log(_ message: String) {
    if _verbose {
        if #available(macOS 11.0, iOS 14.0, *) {
            Logger.logger.debug("\(message)")
        } else {
            debugPrint("\(_tag)\(message)")
        }
    }
}
