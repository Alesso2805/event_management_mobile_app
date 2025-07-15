# Keep Stripe classes
-keep class com.stripe.android.** { *; }
-dontwarn com.stripe.android.**

# Keep classes that might be referenced by Stripe
-keep class com.reactnativestripesdk.** { *; }
-dontwarn com.reactnativestripesdk.**

# Keep classes related to push provisioning
-keep class com.stripe.android.pushProvisioning.** { *; }
-dontwarn com.stripe.android.pushProvisioning.**

# General rules for reflection
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Keep Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }

# Keep Firebase classes if using Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Keep Google Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Keep OkHttp and Retrofit classes
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }
-dontwarn okhttp3.**
-dontwarn retrofit2.**

# Keep JSON parsing classes
-keep class com.google.gson.** { *; }
-keep class com.fasterxml.jackson.** { *; }
-dontwarn com.google.gson.**
-dontwarn com.fasterxml.jackson.**
