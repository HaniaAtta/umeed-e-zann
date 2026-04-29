# 🏛️ Umeed-e-Zann: Clean Architecture Guide

This document serves as your technical reference for the project's architecture. It is designed to help you explain "The Why" and "The How" during your technical Viva (oral exam).

---

## 1. High-Level Strategy: "Feature-First" Clean Architecture
Unlike a standard "Layer-First" approach where all models are in one place and all screens are in another, we use a **Feature-First** structure.

### Why Feature-First?
*   **Modularity:** Each feature (Safety, Wellness, Marketplace) acts as a mini-app.
*   **Scalability:** Adding a new feature doesn't mess up existing ones.
*   **Organization:** It’s easier for a team of developers to work on different modules without merge conflicts.

---

## 2. Core Project Structure

### `lib/core`
*   **The Foundation:** Contains code used by the entire app but doesn't belong to any specific feature.
*   *Examples:* App Theme, Global Router, Shared Extensions, and SharedPreferences.

### `lib/data` (Root Level)
*   **The Neutral Zone:** Houses "Shared" Data Models and Services.
*   **Purpose:** To prevent "Circular Dependencies." If the *Safety* feature needs a *User* model, it imports it from here instead of importing the *Auth* feature. This keeps features independent.

### `lib/features`
*   **The Modules:** Each sub-folder (e.g., `safety/`) is divided into three layers:
    1.  **Domain:** The Brain (Entities & Use Cases). No imports from outside!
    2.  **Data:** The Source (Models, Repositories, DataSources). This is where Firebase is integrated.
    3.  **Presentation:** The Face (Providers & UI). Where Flutter screens live.

---

## 3. The Layers Explained (The Viva "Gold Mine")

### 🧠 Domain Layer (Entities & Use Cases)
*   **Role:** Defines *what* the app does.
*   **Keywords:** Logic, Business Rules, Platform Independent.
*   **Viva Answer:** *"The Domain layer is the most stable part of the app. It contains the business logic and defines the contracts (Interfaces) that the other layers must follow."*

### 💾 Data Layer (Repositories & Models)
*   **Role:** Handles *how* we get the data.
*   **Keywords:** Firebase, APIs, Serialization (to/from JSON).
*   **Viva Answer:** *"The Data layer implements the repository interfaces from the Domain layer. It handles the mapping between Firestore documents and our internal app entities."*

### 🎨 Presentation Layer (State Management & UI)
*   **Role:** Handles *interacting* with the user.
*   **Keywords:** Provider, Widgets, Context, Reactive UI.
*   **Viva Answer:** *"The Presentation layer uses the Provider package to listen to changes in data and rebuild the UI. It never talks to the database directly; it only talks to Use Cases."*

---

## 4. Key Engineering Concepts to Mention

### 🔁 Dependency Inversion
We don't depend on classes; we depend on **Interfaces**.
*   *Example:* `SafetyRepository` (abstract) vs `SafetyRepositoryImpl` (concrete). 
*   **Benefit:** We can swap Firebase for another database without changing the UI.

### 🧩 SOLID Principles
Mention that the app follows SOLID:
*   **Single Responsibility:** Each class does ONE thing (e.g., `AuthRemoteDataSource` only talks to Firebase Auth).
*   **Open/Closed:** We can add new features by adding new folders, without changing old ones.

---

## 🎯 Final Viva Tip: "Talk like an Engineer"
When asked about a bug or a feature, don't say "I put it in that screen."
**Say:** *"I implemented that logic within a specific **Use Case** in the **Domain Layer** to ensure it remains reusable and testable."*
