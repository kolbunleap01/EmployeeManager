# Employee Manager

Employee Manager is a Flutter mobile app for authenticated product browsing and employee administration. It demonstrates GetX state management and navigation, Dio REST communication, repository-based data access, JWT session persistence, form validation, and responsive Material 3 UI.

## Features

- JWT login with the DummyJSON demo account
- Secure access-token and user persistence with `flutter_secure_storage`
- Automatic session restore and logout
- Products loaded from `/products` with image caching, ratings, empty/error states, and pull-to-refresh
- Employees loaded from `/users` with add, edit, delete confirmation, and pull-to-refresh
- User-friendly network, timeout, server, invalid-response, and unauthorized error messages
- Reactive loading states and reusable UI widgets
- Blue and white Material 3 theme with mobile and wider-screen form layouts

## Architecture

The app follows this flow:

```text
View -> GetX Controller -> Repository -> API Provider -> Dio ApiClient -> REST API
```

- Views contain presentation only.
- GetX controllers own reactive state, validation coordination, navigation, and user feedback.
- Repositories provide the data-access boundary used by controllers.
- Providers contain endpoint-specific requests and model conversion.
- `ApiClient` isolates base URL configuration, JWT headers, timeout handling, and 401 handling.
- `StorageService` owns secure session persistence.

## Folder Structure

```text
lib/
├── app/                 # bindings, routes, and theme
├── core/                # constants, exceptions, services, utilities
├── data/                # models, providers, repositories
├── modules/             # auth, home, products, employees
└── shared/              # reusable widgets
```

## Installation

Requirements:

- Flutter 3.47 or newer
- Dart 3.13 or newer
- Android SDK for APK builds

Install dependencies:

```bash
flutter pub get
```

## Demo Login

```text
Username: emilys
Password: emilyspass
```

## API Endpoints

Base URL: `https://dummyjson.com`

- `POST /auth/login`
- `GET /products`
- `GET /users`
- `POST /users/add`
- `PUT /users/{id}`
- `DELETE /users/{id}`

The API client sends the required authenticated header as `Authz: Bearer <JWT_TOKEN>`. To replace the backend, update `lib/core/constants/api_constants.dart` and adapt the provider/model mapping if the response shape changes.

DummyJSON employee create, update, and delete operations are simulated by the API. The app updates its visible employee list after successful mutations, but those changes are not persisted by DummyJSON.

## Run The App

```bash
flutter run
```

## Testing

Run all tests:

```bash
flutter test
```

The test suite covers email and required-field validation, employee and product JSON parsing, login controller validation/state, and employee-form validation state.

## Build An APK

```bash
flutter build apk --debug
```

The debug APK is generated at `build/app/outputs/flutter-apk/app-debug.apk`.

## Screenshots

Screenshots can be added here after running the app on an emulator or physical device.
