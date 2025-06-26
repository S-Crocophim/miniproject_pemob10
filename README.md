# Cold Room Monitoring App

A modern, cross-platform mobile application built with Flutter and Firebase for real-time monitoring of cold storage facilities. This app provides a comprehensive dashboard for employees and managers to ensure product integrity and operational efficiency.

## ✨ Features

- **Real-time Monitoring**: View live data for temperature, humidity, and door status for multiple cold rooms.
- **Firebase Integration**: Securely backed by Firebase for authentication and a real-time database (Cloud Firestore).
- **Dynamic Theming**: Switch between a sleek Light Mode and a modern Dark Mode, with the user's preference saved across sessions.
- **Glassmorphism UI**: A beautiful, modern user interface inspired by glassmorphism, featuring blurred backgrounds and gradient colors.
- **Slot Management**: Visually manage storage slots within each cold room, updating their status (`available`, `occupied`, `inProcess`).
- **Employee Verification**: Securely update slot statuses by requiring a valid Employee ID, which is verified against a Firestore database.
- **Activity Logging**: All slot status changes are automatically logged with a timestamp and the responsible employee's ID for accountability.
- **Contextual History**: View a detailed activity log for a specific room directly from its detail page.
- **CCTV Viewing**: Integrated video player to view live CCTV feeds for added security.
- **Forgot Password**: A secure, email-based password reset functionality powered by Firebase Auth.

## 🛠️ Tech Stack & Architecture

- **Framework**: [Flutter](https://flutter.dev/)
- **Backend-as-a-Service**: [Firebase](https://firebase.google.com/)
  - **Authentication**: Firebase Authentication (Email/Password)
  - **Database**: Cloud Firestore
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Architecture**: MVVM-like (Model-View-ViewModel) pattern using Providers.
- **Key Packages**:
  - `firebase_core`, `firebase_auth`, `cloud_firestore`
  - `provider`
  - `fl_chart` for data visualization
  - `video_player` for CCTV streaming
  - `shared_preferences` for theme persistence
  - `intl` for date formatting

## ⚙️ Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

- You need to have [Flutter](https://flutter.dev/docs/get-started/install) installed on your system.
- A configured Firebase project.

### 1. Clone the Repository

```sh
git clone https://github.com/your_username/your_repository_name.git
cd your_repository_name
```

### 2. Set Up Firebase

This project requires a Firebase project to run.

1.  Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
2.  Enable **Authentication** (with Email/Password sign-in method) and **Cloud Firestore** (start in test mode for development).
3.  Follow the [FlutterFire CLI documentation](https://firebase.flutter.dev/docs/cli) to configure your app. Run the following command in the project root:
    ```sh
    flutterfire configure
    ```
    This will generate the `firebase_options.dart` file with your project's credentials.
4.  **Populate Firestore with initial data**:
    -   Create a collection named `employees` and add a few documents with `name` and `role` fields. Use the Employee ID (e.g., `EMP-001`) as the Document ID.
    -   Create a collection named `cold_rooms` and add sample room data.
    -   Within each `cold_room` document, create a sub-collection named `slots` and add documents for each slot (e.g., `A1`, `A2`) with a `status` field (`available`, `occupied`, or `inProcess`).

### 3. Install Dependencies

```sh
flutter pub get
```

### 4. Run the Application

```sh
flutter run
```

The app should now build and run on your connected device or emulator.

## 🤝 How to Contribute

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE.txt` for more information.

---
