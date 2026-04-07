# AGENTS.md — Flutter App Development Rules

## 🧠 Project Context

This is a **Flutter application** built using **Clean Architecture** principles with a focus on scalability, maintainability, and performance.

---

## ⚙️ Tech Stack

* Flutter (latest stable)
* Dart
* State Management: GetX / Bloc (project dependent)
* Networking: Dio / http
* Local Storage: Hive / SharedPreferences / SQLite
* Dependency Injection: GetIt (if used)

---

## 📁 Architecture Rules (STRICT)

Follow **Clean Architecture**:

lib/
├── core/              # Common utilities, constants, themes, services
├── data/              # Models, APIs, repositories (implementation)
├── domain/            # Entities, repositories (abstract), use cases
├── presentation/      # UI (screens, widgets, controllers/blocs)

### Rules:

* ❌ UI must NOT access data layer directly
* ❌ No business logic inside widgets
* ❌ No API calls inside UI
* ✅ Use UseCases between UI and repositories
* ✅ Repository interfaces must be in domain layer
* ✅ Implementation must be in data layer

---

## 🧩 State Management Rules

### If using GetX:

* Use Controllers only for UI logic
* Avoid business logic inside Controllers
* Use separate service/usecase layer

### If using Bloc:

* Keep Bloc lean (delegate logic to UseCases)
* States must be immutable
* Avoid large monolithic blocs

---

## 🧱 Code Style Rules

* Follow Dart lint rules (`flutter_lints`)
* Use `const` wherever possible
* Prefer `final` over `var`
* Avoid deeply nested widgets (extract components)
* Use meaningful naming (no abbreviations like `cnt`, `obj`)

---

## 🎯 UI/UX Rules

* Follow Material 3 guidelines
* Maintain consistent spacing (8px grid system)
* Responsive design is REQUIRED (mobile + tablet + web)
* Avoid hardcoded sizes — use MediaQuery / LayoutBuilder

---

## 🌐 Networking Rules

* All API calls must go through a **network service layer**

* Handle:

  * Timeouts
  * Error mapping
  * Response parsing

* NEVER:

  * Call API directly in UI
  * Parse JSON inside widgets

---

## 💾 Data & Models

* Use separate:

  * DTO (API models)
  * Domain entities

* NEVER expose DTOs to UI

---

## 🔐 Error Handling

* Use Result/Either pattern (preferred)
* Avoid throwing raw exceptions to UI
* Map errors to user-friendly messages

---

## 🧪 Testing Rules

* Write:

  * Unit tests for UseCases
  * Widget tests for UI
* Avoid testing UI with business logic

---

## 🚀 Performance Rules

* Avoid unnecessary rebuilds
* Use const widgets
* Use ListView.builder for lists
* Avoid heavy computation on main thread

---

## 🧹 Code Smells (AI MUST AVOID)

* ❌ Massive Widgets (>300 lines)
* ❌ God Controllers / Blocs
* ❌ Tight coupling between layers
* ❌ Hardcoded strings/colors
* ❌ Duplicate logic

---

## 🧰 Commands

* Run app:
  flutter run

* Build APK:
  flutter build apk

* Build Web:
  flutter build web

* Analyze:
  flutter analyze

* Test:
  flutter test

---

## 📌 AI Behavior Rules

When generating code:

* ALWAYS:

  * Follow Clean Architecture
  * Split code into layers
  * Write reusable widgets
  * Keep files small and modular

* NEVER:

  * Dump everything into one file
  * Mix UI + API + logic
  * Ignore existing project structure

* PREFER:

  * Production-ready code over demo code
  * Readability over cleverness

---

## 📦 Folder Naming Conventions

* snake_case for folders
* feature-based structure preferred:

presentation/
└── auth/
├── login_screen.dart
├── auth_controller.dart
└── widgets/

---

## 🔄 Scalability Rules

* Every feature must be isolated
* Avoid global state unless necessary
* Use dependency injection

---

## 📣 Final Instruction

This is NOT a prototype project.

All generated code must be:

* Scalable
* Maintainable
* Production-ready

Avoid shortcuts and quick hacks.
