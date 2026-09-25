# Quizzical

**Quizzical** is a beautiful, feature-rich quiz application built with Flutter. Test your knowledge across a wide variety of categories, customize your quiz experience, and review your performance—all within a modern, responsive, and customizable user interface.

## 📱 Screenshots
*(Consider adding screenshots here)*

## ✨ Key Features

- **Dynamic Quiz Generation**: Fetch questions from a remote API with various difficulty levels and question types.
- **Category Selection**: Choose from a wide range of topics (e.g., General Knowledge, Science, Sports, History, etc.).
- **Customizable Quizzes**: Configure the number of questions, difficulty level, and question type before starting.
- **Interactive Quiz Screen**: An engaging UI with smooth animations to answer questions with real-time feedback.
- **Detailed Results**: View a comprehensive breakdown of your performance after each quiz, including correct and incorrect answers.
- **Dark & Light Mode**: Seamlessly switch between dark and light themes for a comfortable viewing experience.
- **State Management**: Robust state management implemented using the `provider` package.
- **Beautiful Typography**: Clean and modern text styling utilizing Google Fonts (Nunito).

## 🛠 Tech Stack & Architecture

- **Framework:** [Flutter](https://flutter.dev/)
- **State Management:** [Provider](https://pub.dev/packages/provider)
- **Typography:** [Google Fonts](https://pub.dev/packages/google_fonts)
- **Architecture Pattern:** MVVM (Model-View-ViewModel) approach with Providers handling the business logic.

### Directory Structure

```text
lib/
├── models/         # Data structures (Category, Question, History)
├── providers/      # State management (QuizProvider)
├── screens/        # UI screens (Welcome, Config, Quiz, Results)
├── services/       # External APIs and network calls (ApiService)
├── widgets/        # Custom reusable UI components
└── main.dart       # Application entry point
```

## 🚀 Getting Started

Follow these steps to get a local copy up and running.

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Version 3.x or above)
- An IDE (VS Code, Android Studio, or IntelliJ)
- A connected device or an emulator/simulator.

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   ```

2. **Navigate to the project directory:**
   ```bash
   cd simple_test_app
   ```

3. **Fetch the dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.
