//
//  PayPopupViewController.swift
//  QuizApp
//
//  Created by user on 06/09/2021.
//

import UIKit
import PassKit
import Stripe
import Alamofire

protocol PaymentPopDelegate {
    func payClicked()
    func errorComes()
}

typealias NetworkCompletion = (_ result: Data?,_ error: Error?) -> Void

class PayPopupViewController: BaseViewController {

    var delegate: PaymentPopDelegate?
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func payWithAppleTapped(_ sender: Any) {
        let user = SharedManager.shared.user
        let merchantIdentifier = "merchant.xyz.Codex.OneLeft"
        let paymentRequest  = StripeAPI.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: "US", currency: "USD")
        paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "\(user?.username ?? "")", amount: 0.99)]
        if let applePayContext = STPApplePayContext(paymentRequest: paymentRequest, delegate: self) {
            applePayContext.presentApplePay {
            }
        } else {
            dismiss()
            delegate?.payClicked()
        }
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss()
        delegate?.payClicked()
    }
    
    
}

extension PayPopupViewController : STPApplePayContextDelegate {
    
    func applePayContext(_ context: STPApplePayContext, didCreatePaymentMethod paymentMethod: STPPaymentMethod, paymentInformation: PKPayment, completion: @escaping STPIntentClientSecretCompletionBlock) {
        let encoding = URLEncoding.default
        let params = [
            "amount": "0.99",
            "currency": "USD"
        ]
        let request = Alamofire.request("https://uppi.androidworkshop.net/stripe_api.php?action=create_payment_intent", method: .post, parameters: params, encoding: encoding, headers: [:])
        handleJSONResponse(for: request) { result, error in
            do {
                if let result = result {
                    let json = try JSONSerialization.jsonObject(with: result, options: []) as? [String : Any]
                    let clientSecret = json?["clientSecret"] as? String ?? ""
                    completion(clientSecret, nil)
                }else  {
                    completion(nil, error)
                }
            }
            catch
            {
                completion(nil, error)
            }
        }
    }

    func applePayContext(_ context: STPApplePayContext, didCompleteWith status: STPPaymentStatus, error: Error?) {
          switch status {
        case .success:
              dismiss()
              delegate?.payClicked()
            break
        case .error:
              dismiss()
              delegate?.errorComes()
            break
        case .userCancellation:
              dismiss()
              delegate?.errorComes()
            break
        @unknown default:
            fatalError()
        }
    }
}

extension UIViewController {
    func handleJSONResponse(for request: DataRequest, completion: @escaping NetworkCompletion) {
        request.responseJSON { (response) in
            print(response)
            switch response.result
            {
            case .success(_):
                
#if DEBUG
                if let data = response.data {
                    let responseString = String(data: data, encoding: .utf8)
                    print("\n\nDEBUG RESPONSE::\n \(responseString ?? "Data could not be converted to string")\n\n\n")
                }
#endif
                
                if let data = response.data {
                    completion(data, nil)
                }
                else {
                    completion(nil,nil)
                }
                break
            case .failure(let err):
                completion(nil, err)
            }
        }
    }
}
