# 📱 Kanban - Flutter App

🛠️ Technical Stack
    Flutter 3.35.5

    State Management: Riverpod

    Local Storage: Hive

    Networking: Firebase (Firebase Auth and Clous Firestore)

    UI: Custom widgets with Material 3 design

📦 Packages Used
    hooks_riverpod - State management

    hive_flutter - Local storage

    cloud_firestore - Remote storage

    firebase_auth - User Authentication

🏗️ Project Structure
    lib/
    ├── core/
    │   ├── constants/
    │   ├── di/
    |   ├── errors/
    |   ├── routes/
    │   └── theme/
    |   ├── utis/
    ├── data/
    │   ├── data_sources/
    │           ├── local_data_sources
    │           └── remote_data_sources/
    │   ├── models/
    │   └── repositories_impl/
    ├── domain/
    │   ├── entities/
    │   ├── repositories/
    │   └── usecases/
    ├── presentation/
    │   ├── screens/
    │   ├── widgets/
    │   └── states/ 
    ├── app.dart/
    └── main.dart            