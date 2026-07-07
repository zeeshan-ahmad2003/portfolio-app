# _ZA✨ Portfolio App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![Express](https://img.shields.io/badge/Express-000000?style=for-the-badge&logo=express&logoColor=white)
![JWT](https://img.shields.io/badge/JWT-000000?style=for-the-badge&logo=jsonwebtokens&logoColor=white)

A production-ready **Flutter mobile portfolio app** built during the Codiora Software House internship. Features JWT authentication, live REST API integration, offline caching, and a premium dark navy + cyan design system.

</div>

## 📱 Screenshots

| Login | Home | Projects | Contact |
|-------|------|----------|---------|
| JWT auth with error handling | Profile, skills, social links | Search, filter by category | Email, phone, social media |

## ✨ Features

### 🔐 Authentication
- JWT login/logout with token stored in SharedPreferences
- Auto-login on app relaunch
- Secure session management with token blacklist on backend

### 🏠 Home Screen
- Animated hero section with profile photo
- Live skill bars fetched from API
- GitHub, LinkedIn, Portfolio links
- Offline banner when showing cached data

### 👤 Profile Screen
- View and edit profile (name, bio, email, phone)
- Pick and upload profile photo from gallery
- Education, experience, and skills sections
- Logout with confirmation dialog

### 🗂️ Projects Screen
- Projects fetched from REST API
- Real-time search by title or technology
- Filter by category (Flutter, Python, AI/ML)
- Offline fallback with cached data banner

### 📬 Contact Screen
- Live contact data from API
- Tap to call/email, long-press to copy
- Social media links (GitHub, LinkedIn, Portfolio)
- Availability badge

### 📡 Offline Support
- All API data cached locally via SharedPreferences
- App works fully without internet using last saved data
- Offline banner shown on Home, Projects, and Contact screens
- Cache cleared automatically on logout

## 🛠️ Technologies Used

| Layer | Technology |
|-------|------------|
| Mobile App | Flutter 3.x, Dart |
| State Management | setState + StatefulWidget |
| Local Storage | shared_preferences |
| HTTP Client | http package |
| Image Picker | image_picker |
| URL Launcher | url_launcher |
| Backend | Node.js, Express.js |
| Auth | JWT, bcrypt |
| File Upload | Multer |

## 📁 Project Structure