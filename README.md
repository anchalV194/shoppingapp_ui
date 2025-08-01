# 🛒 Shopping App UI

![Flutter](https://img.shields.io/badge/Flutter-v3.16-blue?logo=flutter)
![Build](https://img.shields.io/badge/build-passing-brightgreen)
![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web-blue)

> A clean and modern UI for a shopping app built using Flutter. Includes product listing, cart functionality, signup/login flow, and checkout experience.

---

## ✨ Features

- 🏠 **Landing/Home Page** with product grid
- 🔍 **Search Bar** and **Category Filters**
- 🛍️ **Add to Cart** functionality
- 🧾 **Cart Page** with quantity controls and price breakdown
- 🧾 **Checkout Page** with:
  - Address section
  - Payment selection
  - Place Order button
- 🔐 **Login & Signup Pages**
- 🌙 Light/Dark Theme using `theme_provider.dart`
- 📦 Preloaded assets (e.g. images of products like iPhone, T-shirt, Sofa)

---

## 📂 Folder Structure

```text
lib/
├── main.dart                # Entry point
├── landing_page.dart        # Main landing page
├── login_page.dart          # Login UI
├── signup_page.dart         # Signup UI
├── theme_provider.dart      # Theme toggle logic
├── assets/                  # Images: sofa, watch, iphone, etc.
