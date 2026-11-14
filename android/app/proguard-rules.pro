# Disable aggressive R8 bytecode optimization to prevent runtime crashes in Flutter plugins while retaining full obfuscation
-dontoptimize

# Flutter Engine and Embeddings
-keep class io.flutter.** { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**
-dontwarn io.flutter.plugin.**

# App Package & MainActivity
-keep class com.eafmicroservice.student_books.** { *; }

# Flutter Community Plus plugins (connectivity_plus, device_info_plus, package_info_plus, share_plus)
-keep class dev.fluttercommunity.plus.** { *; }

# Flutter standard plugins
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugins.urllauncher.** { *; }
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class io.flutter.plugins.webviewflutter.** { *; }

# JNI & FFI (Dart interop)
-keep class com.github.dart_lang.jni.** { *; }
-dontwarn com.github.dart_lang.jni.**

# Google Mobile Ads (AdMob)
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.android.gms.internal.ads.** { *; }
-keep class com.google.ads.** { *; }

# AndroidX WorkManager & Room (used by Google Mobile Ads SDK for background work)
-keep class androidx.work.** { *; }
-keep class androidx.work.impl.** { *; }
-keep class * extends androidx.work.Worker { *; }
-keep class * extends androidx.work.ListenableWorker { *; }
-keep class androidx.room.** { *; }
-keep class * extends androidx.room.RoomDatabase {
    public <init>();
    *;
}
-dontwarn androidx.room.**
-dontwarn androidx.work.**

# AndroidX Startup
-keep class androidx.startup.** { *; }
-keep class * extends androidx.startup.Initializer { *; }

# Syncfusion PDF Viewer
-keep class com.syncfusion.** { *; }
-dontwarn com.syncfusion.**

# Play Core - missing classes referenced by Flutter engine
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# General Flutter & Kotlin reflection rules
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod
-keepattributes SourceFile,LineNumberTable
