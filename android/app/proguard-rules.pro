# — Flutter engine —
-keep class io.flutter.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.**

# — Flame game engine —
-keep class dev.flameengine.** { *; }
-dontwarn dev.flameengine.**

# — Forge2D / Box2D physics —
-keep class org.jbox2d.** { *; }
-dontwarn org.jbox2d.**

# — Google Play Billing Library 6 (in_app_purchase) —
-keep class com.android.billingclient.** { *; }
-dontwarn com.android.billingclient.**

# — Firebase —
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# — Kotlin coroutines / reflection —
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions
-keepattributes InnerClasses
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }
-dontwarn kotlin.**
-dontwarn kotlinx.**

# — SharedPreferences / EncryptedSharedPreferences —
-keep class androidx.security.crypto.** { *; }
-dontwarn androidx.security.crypto.**