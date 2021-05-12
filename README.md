# Project Title
### Safeyou
[![SafeYouPlayStore](https://play-lh.googleusercontent.com/AnIs0TtPU4CpZ9u7wn7WrGTFUcdtOekBZ2DZes5cB0Ie5fcTx-mq25x99vfIasgZZKg=s360-rw)](https://play.google.com/store/apps/details?id=fambox.pro)

# Offered By
Impact Innovations Institute LLC
# Website
## [Safeyou official website](https://safeyou.space/)
# Safe YOU mobile App description
Safe YOU is a multifunctional safety app for mobile device users and a web platform for different stakeholders (NGOs, Governmental organizations, individual specialists), who provide support services to women to prevent and protect them in case violence. Available currently in Armenia and Georgia the App permits the users to send free alert SMS with their geolocation to up-to 7 prechosen contacts, including the Police.

#### How to start using the App

The first step is to choose the country and the preferred language available in the given country, then to proceed to the registration using mobile phone number.
To register users should fill-in the necessary information: name, surname, birth date- this information will not be available to other users, they will only see the nickname, created by the user during registration.
After registration, a **tutorial** page is shown to the users explaining each function of the App.

#### App features
**Choosing Emergency Contacts:** In the **Support section** users can select up to three personal contacts, three support contacts from the service provider organizations listed the Network section of the App, as well as enable the Police contact function.

**Help Function:** By pressing and holding the green button for three seconds the App will simultaneously send a free alert SMS with the user’s geo-location to up to 7 previously chosen contacts.

**Audio Recording:** Pressing and holding the green button for three seconds also enables the audio recording function for one minute. The audio record is kept in the recordings’ library and can be sent to service providers and the police or deleted at any time.

**Network:** In the **Network section** of the app the users can find relevant information, such as contact details, hotlines, mapped location, website and social media links on nearby women's rights NGOs, governmental organizations, and individual specialists, supporting women in different ways. 

**Forums:** In the **Forums section** of the App users can engage in anonymous peer-to-peer discussions in topicals chat rooms and get consultation from women support organizations, as well as verified consultants such as lawyers, psychologists, doctors, and other counselors who are identifiable by a special badge. 

**Security functions:** To enable safe usage of the App for users, who want to hide the App from others, Dual PIN and Camouflage functions are developed.

**User Profile:** In the **Profile section** of the App the users can add/edit a profile picture, edit their data filled-in during the registration, as well as send consultancy request. 

**Consultancy Request:** The App also provides possibility to upgrade the ordinary user profile status to a verified consultant, by undergoing a procedure of submitting consultancy request in the Profile section of the App.

**Notifications:** The App provides in App notifications for forum discussions, it also has a function of push notifications, which can be enabled or disabled from by the users from the menu of the App.


# Used programming language
+ Java
+ Kotlin

# Instalation
Clone this repository and import into Android Studio
```bash
git clone 
```
# Build Config
```bash
compileSdkVersion 30
    buildToolsVersion '29.0.3'
    defaultConfig {
        applicationId "fambox.pro"
        minSdkVersion 21
        targetSdkVersion 30
        versionCode 16
        versionName "2.2.3"
    }...
```
# Java Version
```bash
compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }...
```
# Kotlin Version
```bash
buildscript {
    ext.kotlin_version = '1.4.20'
    repositories {
      ........
    }
}
```
# Connecting Socket 
+ https://safeyou.space:3000/forum/readme

# Build variants
Use the Android Studio Build Variants button to choose between **production** and **staging** flavors combined with debug and release build types

# Used technologies
+ REST API
+ Retrofit2 
+ RxJava
+ Socket IO
+ Google MAP, Location
+ Firebase Core, FCM
