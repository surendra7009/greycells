# Fix missing annotation classes for Razorpay
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }

# Razorpay SDK keep rules
#-keep class com.razorpay.** { *; }
#-dontwarn com.razorpay.**
