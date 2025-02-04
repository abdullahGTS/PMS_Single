package com.example.pms

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.ebe.ebeunifiedlibrary.factory.ITransAPI
import com.ebe.ebeunifiedlibrary.factory.TransAPIFactory
import com.ebe.ebeunifiedlibrary.message.SaleMsg
import com.ebe.ebeunifiedlibrary.message.VoidMsg
import com.ebe.ebeunifiedlibrary.message.SettleMsg
import com.ebe.ebeunifiedlibrary.message.ReprintTransMsg
import android.os.Bundle
import android.widget.Toast
import android.content.Intent
import com.pax.dal.IDAL
import com.pax.dal.IPrinter
import com.pax.neptunelite.api.NeptuneLiteUser
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Base64
import com.pax.dal.entity.ETermInfoKey
// for service implmentation
import android.app.Service
import android.os.IBinder
import android.util.Log
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.os.Build
// for restart device implmentation
import android.content.BroadcastReceiver
import android.content.Context
// fo wifi
import android.net.wifi.WifiManager
import android.os.Looper
import androidx.core.app.NotificationCompat
import androidx.annotation.RequiresApi
import android.os.Handler

class MainActivity: FlutterActivity(){
    private val CHANNEL = "com.example.pms/method"
    private lateinit var transAPI: ITransAPI
    private lateinit var neptuneLiteUser: NeptuneLiteUser
    private lateinit var dal: IDAL
    private lateinit var printer: IPrinter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Initialize the transAPI
        transAPI = TransAPIFactory.createTransAPI()
        try {
            neptuneLiteUser = NeptuneLiteUser.getInstance()
            dal = neptuneLiteUser.getDal(applicationContext)
            printer = dal.getPrinter()
        } catch (e: Exception) {
            e.printStackTrace()
        }

        // Check if the app was launched after a reboot
        if (intent?.action == Intent.ACTION_BOOT_COMPLETED) {
            Log.d("MainActivity", "App launched after device boot")
            // Start the background service if needed
            val serviceIntent = Intent(this, CombinedForegroundService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(serviceIntent)
            } else {
                startService(serviceIntent)
            }
        }
    }
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        startCombinedForegroundService()
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startTrans" -> {
                    try {
                        val amount = call.argument<Number>("amount")?.toLong() ?: 0L // Handle as Number
                        val ecrRefNo = call.argument<String>("ecrRefNo")?.toString() ?: "" // Handle as Number
                        println("Received amount: $amount")
                        if (amount <= 0) {
                            result.error("INVALID_AMOUNT", "Amount must be greater than zero", null)
                            return@setMethodCallHandler
                        }
                        val request = SaleMsg.Request()
                        request.setAmount(amount)
                        request.setEcrRefNo(ecrRefNo)

                        // Start the transaction
                        transAPI.startTrans(this, request)
                        result.success("Transaction started!")
                        println("startTrans method called with amount $amount")
                    } catch (e: Exception) {
                        println("Error calling startTrans: ${e.message}")
                        result.error("UNAVAILABLE", "Error calling startTrans", null)
                    }
                }
                "voidTrans"->{
                    try {
                        // Use a static value for stan (e.g., '000005')
                        val stan = call.argument<Number>("stan")?.toLong() ?: 0L // Handle as Number
                        val ecrRefNo = call.argument<String>("ecrRefNo")?.toString() ?: ""

                        // Set required parameters for the void transaction (Only stan)
                        val request = VoidMsg.Request()
                        request.setEcrRef(ecrRefNo)

                        // Use the static stan value here

                        // Start the void transaction (without additional parameters)
                        transAPI.startTrans(this, request)


                        // Send success response back to Flutter
                        result.success("Void transaction started with STAN: $stan")
                    } catch (e: Exception) {
                        // Handle any errors during the transaction
                        result.error("UNAVAILABLE", "Error voiding transaction: ${e.message}", null)
                    }
                }
                "reprintTransMsg"->{
                    try {
                        // Use a static value for stan (e.g., '000005')
                        val ecrRef = call.argument<String>("ecrRef")?.toString() ?: ""
                        val voucherNo = call.argument<Int>("voucherNo") ?: 0

                        // Set required parameters for the void transaction (Only stan)
                        val request = ReprintTransMsg.Request()
                        request.setEcrRefNo(ecrRef)
                        request.setVoucherNo(voucherNo)
                        // Use the static stan value here

                        // Start the void transaction (without additional parameters)
                        transAPI.startTrans(this, request)


                        // Send success response back to Flutter
                        result.success("Void transaction started with STAN:")
                    } catch (e: Exception) {
                        // Handle any errors during the transaction
                        result.error("UNAVAILABLE", "Error voiding transaction: ${e.message}", null)
                    }
                }
                "settlementTrans"->{
                    try {
                        // Use a static value for stan (e.g., '000005')
                        // Set required parameters for the void transaction (Only stan)
                        val request = SettleMsg.Request()

                        // Use the static stan value here

                        // Start the void transaction (without additional parameters)
                        transAPI.startTrans(this, request)


                        // Send success response back to Flutter
                        result.success("Void transaction started with STAN:")
                    } catch (e: Exception) {
                        // Handle any errors during the transaction
                        result.error("UNAVAILABLE", "Error voiding transaction: ${e.message}", null)
                    }
                }
                "printReceipt" -> {
                    val receiptContent = call.argument<List<String>>("receiptContent") ?: emptyList()
                    val image = call.argument<String>("image") ?: ""
                    println("Received receipt content: $receiptContent")
                    val contentToPrint = receiptContent.joinToString("\n")
                    val bitmap = decodeBase64ToBitmap(image)
                    printer.init() // Initialize the printer
                    // Print the logo/image if available
                    if (bitmap != null) {
                        printer.printBitmap(bitmap)
                    }
                    // Split the content into manageable chunks based on buffer size
                    val maxBufferSize = 2048
                    val chunks = splitContentByBuffer(contentToPrint, maxBufferSize)
                    for (chunk in chunks) {
                        printer.printStr(chunk, null) // Print each chunk
                    }
                    // printer.printBitmap(bitmap)
                    // printer.printStr(contentToPrint, null) // Print the string
                    printer.step(10) // Print the string
                    printer.start() // Start the printing job
                    result.success("Printed successfully") // Notify Flutter of success
                }
                "getSerialNumber" -> {
                    try {
                        val info = dal.getSys().getTermInfo()
                        val serialNumber = info[ETermInfoKey.SN] ?: "N/A"
                        result.success(serialNumber)
                    } catch (e: Exception) {
                        result.error("UNAVAILABLE", "Error fetching serial number", null)
                    }
                }
                "startService" -> {
                    // Start the foreground service
                    val intent = Intent(this, CombinedForegroundService::class.java)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success("Foreground Service started")
                }
                "enableWifi" -> {
                    val wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
                    if (!wifiManager.isWifiEnabled) {
                        wifiManager.isWifiEnabled = true
                    }
                    result.success(wifiManager.isWifiEnabled)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
        println("Flutter Engine configured") // Debug log to confirm engine setup
    }
    // private fun initializePrinter() {
    //     try {
    //         if (!::neptuneLiteUser.isInitialized) {
    //             neptuneLiteUser = NeptuneLiteUser.getInstance()
    //         }
    
    //         if (!::dal.isInitialized) {
    //             dal = neptuneLiteUser.getDal(applicationContext)
    //         }
    
    //         if (!::printer.isInitialized || printer == null) {
    //             printer = dal.getPrinter()
    //         }
    
    //         if (printer == null) {
    //             throw Exception("Failed to initialize printer. Printer object is null.")
    //         }
    
    //         println("Printer initialized successfully.")
    //     } catch (e: Exception) {
    //         e.printStackTrace()
    //         println("Error during printer reinitialization: ${e.message}")
    //         // Optionally notify the user
    //         Toast.makeText(this, "Printer reinitialization failed: ${e.message}", Toast.LENGTH_LONG).show()
    //     }
    // }    
    private fun splitContentByBuffer(content: String, maxBufferSize: Int): List<String> {
        val chunks = mutableListOf<String>()
        var currentBuffer = StringBuilder()
    
        for (line in content.split("\n")) {
            val lineBytes = line.toByteArray(Charsets.UTF_8).size
    
            if (currentBuffer.length + lineBytes > maxBufferSize) {
                // Add the current buffer to chunks
                chunks.add(currentBuffer.toString())
                // Reset the buffer
                currentBuffer = StringBuilder()
            }
    
            // Append the line to the buffer
            currentBuffer.append(line).append("\n")
        }
    
        // Add any remaining content
        if (currentBuffer.isNotEmpty()) {
            chunks.add(currentBuffer.toString())
        }
    
        return chunks
    }
    fun decodeBase64ToBitmap(base64Image: String): Bitmap? {
        return try {
            // Decode base64 string to byte array
            val decodedBytes = Base64.decode(base64Image, Base64.DEFAULT)
            // Convert byte array to Bitmap
            BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.size)
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        try {
            // Extract response object
            val baseResponse = transAPI.onResult(requestCode, resultCode, data)
    
            when (baseResponse) {
                is SaleMsg.Response -> {
                    // Process SaleMsg.Response
                    val stan = baseResponse.stan ?: "N/A"
                    val amount = baseResponse.amount ?: 0
                    val merchantName = baseResponse.merchantName ?: "Unknown"
                    val cardNo = baseResponse.cardNo ?: "Unknown"
                    val transactionType = baseResponse.transactionType ?: "Unknown"
                    val authCode = baseResponse.authCode ?: "N/A"
                    val transTime = baseResponse.transTime ?: "N/A"
                    val voucherNo = baseResponse.voucherNo ?: "N/A"
                    val ecrRef = baseResponse.ecrRef ?: "N/A"
                    val batchNo = baseResponse.batchNo ?: "N/A"
    
                    // Log the full response
                    println("Transaction Details:")
                    println("STAN: $stan")
                    println("Amount: $amount")
                    println("Merchant Name: $merchantName")
                    println("Card Number: $cardNo")
                    println("Transaction Type: $transactionType")
                    println("Authorization Code: $authCode")
                    println("Transaction Time: $transTime")
                    println("Transaction VoucherNo: $voucherNo")
                    println("Transaction ECRRef: $ecrRef")
                    println("Transaction batchNo: $batchNo")
    
                    // Send the response to Flutter
                    val responseDetails = mapOf(
                        "stan" to stan,
                        "amount" to amount,
                        "merchantName" to merchantName,
                        "cardNo" to cardNo,
                        "transactionType" to transactionType,
                        "authCode" to authCode,
                        "transTime" to transTime,
                        "voucherNo" to voucherNo,
                        "ecrRef" to ecrRef,
                        "batchNo" to batchNo
                    )
                    flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                        MethodChannel(messenger, CHANNEL).invokeMethod("onTransactionResult", responseDetails)
                    }
                }
    
                is VoidMsg.Response -> {
                    // Process VoidMsg.Response
                    val stan = baseResponse.stan ?: "N/A"
                    val amount = baseResponse.amount ?: 0
                    val merchantName = baseResponse.merchantName ?: "Unknown"
                    val cardNo = baseResponse.cardNo ?: "Unknown"
                    val transactionType = baseResponse.transactionType ?: "Unknown"
                    val authCode = baseResponse.authCode ?: "N/A"
                    val transTime = baseResponse.transTime ?: "N/A"
                    val voucherNo = baseResponse.voucherNo ?: "N/A"
                    val ecrRef = baseResponse.ecrRef ?: "N/A"
                    val batchNo = baseResponse.batchNo ?: "N/A"
    
                    // Log the full response
                    println("Void Transaction Details:")
                    println("STAN: $stan")
                    println("Amount: $amount")
                    println("Merchant Name: $merchantName")
                    println("Card Number: $cardNo")
                    println("Transaction Type: $transactionType")
                    println("Authorization Code: $authCode")
                    println("Transaction Time: $transTime")
                    println("Transaction VoucherNo: $voucherNo")
                    println("Transaction ECRRef: $ecrRef")
                    println("Transaction batchNo: $batchNo")
    
                    // Send the response to Flutter
                    val responseDetails = mapOf(
                        "stan" to stan,
                        "amount" to amount,
                        "merchantName" to merchantName,
                        "cardNo" to cardNo,
                        "transactionType" to transactionType,
                        "authCode" to authCode,
                        "transTime" to transTime,
                        "voucherNo" to voucherNo,
                        "ecrRef" to ecrRef,
                        "batchNo" to batchNo
                    )
                    flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                        MethodChannel(messenger, CHANNEL).invokeMethod("onTransactionResult", responseDetails)
                    }
                }

                is SettleMsg.Response -> {
                    // Process VoidMsg.Response
                    val merchantID = baseResponse.merchantID ?: "N/A"
                    val terminalID = baseResponse.terminalID ?: "N/A"
                    val dateTime = baseResponse.dateTime ?: "N/A"
                    val batchNo = baseResponse.batchNo ?: "N/A"
                    val saleTotalAmt = baseResponse.saleTotalAmt ?: "N/A"
                    val saleTotalNum = baseResponse.saleTotalNum ?: "N/A"
                    val refundTotalAmt = baseResponse.refundTotalAmt ?: "N/A"
                    val refundTotalNum = baseResponse.refundTotalNum ?: "N/A"
                    val saleVoidTotalAmt = baseResponse.saleVoidTotalAmt ?: "N/A"
                    val saleVoidTotalNum = baseResponse.saleVoidTotalNum ?: "N/A"
                    val refundVoidTotalAmt = baseResponse.refundVoidTotalAmt ?: "N/A"
                    val refundVoidTotalNum = baseResponse.refundVoidTotalNum ?: "N/A"
                    val authTotalAmt = baseResponse.authTotalAmt ?: "N/A"
                    val authTotalNum = baseResponse.authTotalNum ?: "N/A"
                    val offlineTotalAmt = baseResponse.offlineTotalAmt ?: "N/A"
                    val offlineTotalNum = baseResponse.offlineTotalNum ?: "N/A"
    
                    // Log the full response
                    println("Void Transaction Details:")
                    println("merchantID: $merchantID")
                    println("terminalID: $terminalID")
                    println("dateTime: $dateTime")
                    println("batchNo: $batchNo")
                    println("saleTotalAmt: $saleTotalAmt")
                    println("saleTotalNum: $saleTotalNum")
                    println("refundTotalAmt: $refundTotalAmt")
                    println("refundTotalNum: $refundTotalNum")
                    println("saleVoidTotalAmt: $saleVoidTotalAmt")
                    println("saleVoidTotalNum: $saleVoidTotalNum")
                    println("refundVoidTotalAmt: $refundVoidTotalAmt")
                    println("refundVoidTotalNum: $refundVoidTotalNum")
                    println("authTotalAmt: $authTotalAmt")
                    println("authTotalNum: $authTotalNum")
                    println("offlineTotalAmt: $offlineTotalAmt")
                    println("offlineTotalNum: $offlineTotalNum")
    
                    // Send the response to Flutter
                    val responseDetails = mapOf(
                        "merchantID" to merchantID,
                        "terminalID" to terminalID,
                        "dateTime" to dateTime,
                        "batchNo" to batchNo,
                        "saleTotalAmt" to saleTotalAmt,
                        "saleTotalNum" to saleTotalNum,
                        "refundTotalAmt" to refundTotalAmt,
                        "refundTotalNum" to refundTotalNum,
                        "saleVoidTotalAmt" to saleVoidTotalAmt,
                        "saleVoidTotalNum" to saleVoidTotalNum,
                        "refundVoidTotalAmt" to refundVoidTotalAmt,
                        "refundVoidTotalNum" to refundVoidTotalNum,
                        "authTotalAmt" to authTotalAmt,
                        "authTotalNum" to authTotalNum,
                        "offlineTotalAmt" to offlineTotalAmt,
                        "offlineTotalNum" to offlineTotalNum
                    )
                    flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                        MethodChannel(messenger, CHANNEL).invokeMethod("onTransactionResult", responseDetails)
                    }
                }
    
                else -> {
                    println("Unknown response type")
                    flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                        MethodChannel(messenger, CHANNEL).invokeMethod("onTransactionResult", mapOf("error" to "Unknown response type"))
                    }
                }
            }
        } catch (e: Exception) {
            println("Error processing transaction: ${e.message}")
            flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                MethodChannel(messenger, CHANNEL).invokeMethod("onTransactionResult", mapOf("error" to e.message))
            }
        }
    }
    

    // override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    //     super.onActivityResult(requestCode, resultCode, data)
    //     try {
    //         // Extract response object
    //         val baseResponse = transAPI.onResult(requestCode, resultCode, data)

    //         // Cast to SaleMsg.Response or other expected response type
    //         val response = baseResponse as SaleMsg.Response

    //         // Extract fields
    //         val stan = response.stan ?: "N/A"
    //         val amount = response.amount ?: 0
    //         val merchantName = response.merchantName ?: "Unknown"
    //         val cardNo = response.cardNo ?: "Unknown"
    //         val transactionType = response.transactionType ?: "Unknown"
    //         val authCode = response.authCode ?: "N/A"
    //         val transTime = response.transTime ?: "N/A"
    //         val voucherNo = response.voucherNo ?: "N/A"
    //         val ecrRef = response.ecrRef ?: "N/A"

    //         // Log the full response
    //         println("Transaction Details:")
    //         println("STAN: $stan")
    //         println("Amount: $amount")
    //         println("Merchant Name: $merchantName")
    //         println("Card Number: $cardNo")
    //         println("Transaction Type: $transactionType")
    //         println("Authorization Code: $authCode")
    //         println("Transaction Time: $transTime")
    //         println("Transaction voucherNo: $voucherNo")
    //         println("Transaction ecrRef: $ecrRef")

    //         // Send full response to Flutter
    //         val responseDetails = mapOf(
    //             "stan" to stan,
    //             "amount" to amount,
    //             "merchantName" to merchantName,
    //             "cardNo" to cardNo,
    //             "transactionType" to transactionType,
    //             "authCode" to authCode,
    //             "transTime" to transTime,
    //             "voucherNo" to voucherNo,
    //             "ecrRef" to ecrRef
    //         )
    //         flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
    //             MethodChannel(messenger, CHANNEL).invokeMethod("onTransactionResult", responseDetails)
    //         }
    //     } catch (e: Exception) {
    //         println("Error processing transaction: ${e.message}")
    //         flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
    //             MethodChannel(messenger, CHANNEL).invokeMethod("onTransactionResult", mapOf("error" to e.message))
    //         }
    //     }
    // }
    private fun startCombinedForegroundService() {
        val intent = Intent(this, CombinedForegroundService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
    }
}


class BootCompleteReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        if (intent?.action == Intent.ACTION_BOOT_COMPLETED) {
            Log.d("BootCompleteReceiver", "Device booted, starting app...")

            // Start the MainActivity
            val launchIntent = Intent(context, MainActivity::class.java)
            launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK) // Required for starting an activity from a receiver
            context.startActivity(launchIntent)
        }
    }
}


class CombinedForegroundService : Service() {
    private val CHANNEL_ID = "PMSCombinedServiceChannel"
    private var isRunning = true
    private lateinit var wifiManager: WifiManager

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onCreate() {
        super.onCreate()
        Log.d("CombinedForegroundService", "Service created")
        wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("CombinedForegroundService", "Service started")

        // Create a notification for the foreground service
        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0, notificationIntent, PendingIntent.FLAG_IMMUTABLE
        )

        val notification: Notification = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, CHANNEL_ID)
                .setContentTitle("Payment Management System")
                .setContentText("PMS is running in the background")
                .setSmallIcon(R.mipmap.ic_launcher) // Use your app's icon
                .setContentIntent(pendingIntent)
                .build()
        } else {
            Notification.Builder(this)
                .setContentTitle("Payment Management System")
                .setContentText("PMS is running in the background")
                .setSmallIcon(R.mipmap.ic_launcher) // Use your app's icon
                .setContentIntent(pendingIntent)
                .build()
        }

        // Start the service in the foreground
        startForeground(1, notification)

        // Perform background tasks
        performBackgroundTask()
        checkWifiPeriodically()

        return START_STICKY
    }

    private fun performBackgroundTask() {
        Thread {
            while (isRunning) {
                try {
                    Log.d("CombinedForegroundService", "Background task is running...")
                    Thread.sleep(5000) // Simulate work every 5 seconds
                } catch (e: InterruptedException) {
                    Log.e("CombinedForegroundService", "Background task interrupted", e)
                    break
                } catch (e: Exception) {
                    Log.e("CombinedForegroundService", "Error in background task", e)
                    break
                }
            }
        }.start()
    }

    private fun checkWifiPeriodically() {
        val handler = Handler(Looper.getMainLooper())
        val runnable = object : Runnable {
            override fun run() {
                if (!wifiManager.isWifiEnabled) {
                    wifiManager.isWifiEnabled = true
                    Log.d("CombinedForegroundService", "Wi-Fi was turned off. Enabled again.")
                }
                handler.postDelayed(this, 5000) // Check every 5 seconds
            }
        }
        handler.post(runnable)
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                CHANNEL_ID,
                "PMS Combined Service Channel",
                NotificationManager.IMPORTANCE_LOW
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(serviceChannel)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.d("CombinedForegroundService", "Service destroyed")
    }
}