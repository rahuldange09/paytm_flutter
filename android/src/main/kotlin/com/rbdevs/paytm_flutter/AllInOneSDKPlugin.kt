package com.rbdevs.paytm_flutter
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import com.paytm.pgsdk.PaytmOrder
import com.paytm.pgsdk.PaytmPaymentTransactionCallback
import com.paytm.pgsdk.TransactionManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
 
class AllInOneSDKPlugin(var activity: Activity, var call: MethodCall, var result: MethodChannel.Result) {
    private val REQ_CODE = 0
    init {
            if (call.method == "startTransaction") {
                startTransaction()
            }else{
                result.notImplemented()
            }
    }
    private fun startTransaction() {
        val arg = call.arguments as Map<*, *>
            val mid = arg["mid"] as String
            val orderId = arg["orderId"] as String
            val amount = arg["amount"] as String
            val txnToken = arg["txnToken"] as String
            val callbackUrl = arg["callbackUrl"] as String
            val isStaging = arg["isStaging"] as Boolean
            
            initiateTransaction(mid, orderId, amount, txnToken, callbackUrl, isStaging)
    }
    private fun initiateTransaction(mid: String, orderId: String, amount: String, txnToken: String, callbackUrl: String?, isStaging: Boolean) {
        var host = "https://securegw.paytm.in/"
        if (isStaging) {
            host = "https://securegw-stage.paytm.in/"
        }
        val paytmOrder = PaytmOrder(orderId, mid, txnToken, amount, callbackUrl)
        val transactionManager = TransactionManager(paytmOrder, object : PaytmPaymentTransactionCallback {
            override fun onTransactionResponse(bundle: Bundle) {
        // Return in both cases if transaction is success or failure
                setResult(bundle.toString(), true)
            }
            override fun networkNotAvailable() {
                setResult("networkNotAvailable", false)
            }
            override fun onErrorProceed(s: String) {
                setResult(s, false)
            }
            override fun clientAuthenticationFailed(s: String) {
                setResult(s, false)
            }
            override fun someUIErrorOccurred(s: String) {
                setResult(s, false)
            }
            override fun onErrorLoadingWebPage(iniErrorCode: Int, inErrorMessage: String, inFailingUrl: String) {
                setResult(inErrorMessage, false)
            }
            override fun onBackPressedCancelTransaction() {
                setResult("onBackPressedCancelTransaction", false)
            }
            override fun onTransactionCancel(s: String, bundle: Bundle) {
                setResult("$s $bundle", false)
            }
        })
        transactionManager.setShowPaymentUrl(host + "theia/api/v1/showPaymentPage")
        transactionManager.startTransaction(activity, REQ_CODE)
    }
    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == REQ_CODE && data != null) {
            val message = data.getStringExtra("nativeSdkForMerchantMessage")
            val response = data.getStringExtra("response")
    // data.getStringExtra("nativeSdkForMerchantMessage") this return message if transaction was stopped by users
    // data.getStringExtra("response") this returns the shared response if the transaction was successful or failure.
            if(response !=null &&  response.isNotEmpty()){
                setResult(response,true)
            }else{
                setResult(message!!,false)
            }
        }
    }
    private fun setResult(message: String, isSuccess: Boolean) {
        if (isSuccess) {
            result.success(message)
        } else {
            result.error("0", message, null)
        }
    }
}