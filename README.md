# 🎬 Cinec Movie Booking App  

![License: Proprietary](https://img.shields.io/badge/license-Proprietary-red.svg)  
![Flutter](https://img.shields.io/badge/Flutter-Framework-blue.svg)  
![Firebase](https://img.shields.io/badge/Firebase-Backend-orange.svg)  

A modern, cross-platform **movie ticket booking application** built with **Flutter** and **Firebase**.  
Cinec provides a **seamless user experience** for browsing movies, selecting seats, and managing bookings in **real time**.  

---

## ✨ Features

- 🔒 **Secure Authentication** – Sign up and log in with Email/Password or Google Sign-In  
- 🎥 **Dynamic Movie Listings** – Browse movies with details like genre, duration, and synopsis  
- 📅 **Showtime & Seat Selection** – Choose showtimes and pick preferred seats with a **visual map**  
- 🎟️ **Real-time Booking** – Instantly view available and reserved seats  
- 📜 **Booking History** – Manage all past and upcoming tickets in one place  
- 📱 **Responsive UI** – Beautiful **dark-themed UI**, optimized for mobile and tablet devices  

---

---

## ⚙️ Tech Stack

- **Framework:** Flutter  
- **Backend:** Firebase  
- **Authentication:** Firebase Auth (Email/Password + Google Sign-In)  
- **Database:** Firestore (Real-time NoSQL)  
- **State Management:** Provider  
- **UI/UX:** Google Fonts, Custom Widgets & Animations  

---

## 📂 Project Structure

```text
.
├── lib/
│   ├── main.dart             # App entry point & routing
│   ├── models/               # Data models (Movie, Booking)
│   ├── screens/              # UI screens (login, home, booking, etc.)
│   ├── services/             # Backend services (Auth, Movie, Booking)
│   └── firebase_options.dart # Firebase configuration
├── pubspec.yaml              # Project dependencies
└── README.md

```

## 🚀 Getting Started
✅ Prerequisites
Install Flutter SDK

```
Install Firebase CLI:
```

```
npm install -g firebase-tools
```

⚡ Installation
Clone the repository

```
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
```

## Install dependencies

```
flutter pub get
```

## Firebase Setup

** Create a Firebase project in Firebase Console

** Enable Firestore and Firebase Authentication (Email/Password + Google Sign-In)

** Configure Firebase in Flutter:

```
flutterfire configure
```
This generates the lib/firebase_options.dart file

Run the app

```
flutter run
```

## 📚 Database Schema (Firestore)

```
users
Document ID: User UID

Fields: name, email, createdAt, photoUrl

Subcollection: bookings – user-specific booking history

movies
Document ID: Unique movie ID

Fields: title, genre, duration, synopsis, posterImage, showtimes (list)

Subcollection: showtimes

showtimes (nested under movies)
Document ID: Formatted string (e.g., "10_00_AM")

Subcollection: bookings – seat reservations

bookings
Document ID: Auto-generated booking ID

Fields: userId, movieTitle, showtime, seats, bookingDate

```

## 🤝 Contributing
Contributions are welcome under strict guidelines:

Please open an issue first for feature requests or bug reports

Pull requests will be reviewed by the author before approval


## 📝 License

```
This project is Proprietary Software.

Copyright (c) 2025 P. Kanishka Miuraj

All rights reserved.

This software and associated documentation files (the "Software") are the
exclusive property of the copyright holder. Unauthorized copying, distribution,
modification, or use of this software, in whole or in part, is strictly
prohibited without prior written permission from the copyright holder.

The Software is provided "AS IS", without warranty of any kind, express or
implied, including but not limited to the warranties of merchantability,
fitness for a particular purpose and noninfringement. In no event shall the
author be liable for any claim, damages or other liability, whether in an
action of contract, tort or otherwise, arising from, out of or in connection
with the Software or the use or other dealings in the Software.

```

## 👨‍💻 Author
P. Kanishka Miuraj Pathirathna
📌 Developer of Cinec Movie Booking App
