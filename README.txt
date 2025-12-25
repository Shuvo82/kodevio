Kodevio

A Flutter application that fetches and displays user data from an API, featuring search, pagination, and user details.

How to Run

1. Ensure you have Flutter 3.38.5 or higher installed. If not, follow the official Flutter installation guide (https://flutter.dev/docs/get-started/install).

2. Clone the repository and navigate to the project directory.

3. Install dependencies:
   flutter pub get

4. Run the app on a connected device or emulator:
   flutter run

   For specific platforms:
   - Android: flutter run -d android
   - iOS: flutter run -d ios (macOS only)

Features

- User List: Displays a list of users fetched from an API with pagination.
- Search Functionality: Search users by name or other attributes.
- User Details: View detailed information about each user.
- Loading and Error States: Handles loading indicators and error messages gracefully.
- Dark/Light Theme: Toggle between dark and light themes.
- Responsive Design: Uses ScreenUtil for responsive UI across devices.
- Debug Tools: In debug mode, includes floating buttons for theme toggle and HTTP logs viewing.
- Network Connectivity: Checks connectivity using connectivity_plus.
- Persistent Storage: Uses GetStorage for local data persistence.

Packages Used

- flutter: The Flutter SDK.
- cupertino_icons: Cupertino icons for iOS-style icons.
- get: State management and routing library.
- flutter_screenutil: Responsive design utility.
- connectivity_plus: Network connectivity checking.
- dio: HTTP client for API requests.
- get_storage: Local storage solution.
- google_fonts: Google Fonts integration.
- pretty_dio_logger: HTTP request/response logging.
- http_parser: HTTP parsing utilities.
- flutter_spinkit: Loading spinners.