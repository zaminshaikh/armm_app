# ARMM Group Investment Platform

![ARMM Group](https://img.shields.io/badge/ARMM-Group-blue?style=flat-square)
![Flutter](https://img.shields.io/badge/Flutter-3.5.3-blue?style=flat-square&logo=flutter)
![React](https://img.shields.io/badge/React-18.3.1-blue?style=flat-square&logo=react)
![Firebase](https://img.shields.io/badge/Firebase-11.2.0-orange?style=flat-square&logo=firebase)
![TypeScript](https://img.shields.io/badge/TypeScript-5.6.3-blue?style=flat-square&logo=typescript)

A comprehensive investment management platform designed for ARMM Group, featuring a cross-platform mobile application and a powerful web-based admin dashboard. The platform enables secure client portfolio management, real-time analytics, and seamless investment tracking.

## 🏗️ Architecture Overview

The ARMM platform consists of three main components:

- **📱 Mobile App** - Flutter-based client application for iOS and Android
- **🌐 Admin Dashboard** - React-based web application for portfolio management
- **☁️ Backend Services** - Firebase Functions for serverless business logic

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Mobile App    │    │ Admin Dashboard │    │ Backend Services│
│   (Flutter)     │    │     (React)     │    │   (Firebase)    │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ • Portfolio View│    │ • Client Mgmt   │    │ • Auth Functions│
│ • Analytics     │    │ • Asset Tracking│    │ • Data Triggers │
│ • Notifications │    │ • Reporting     │    │ • Notifications │
│ • Biometric Auth│    │ • User Admin    │    │ • Scheduled Jobs│
└─────────────────┘    └─────────────────┘    └─────────────────┘
           │                       │                       │
           └───────────────────────┼───────────────────────┘
                                   │
                        ┌─────────────────┐
                        │   Firebase      │
                        │   Firestore     │
                        │   Database      │
                        └─────────────────┘
```

## ✨ Key Features

### 📱 Mobile Application Features

#### 🏠 Dashboard & Portfolio Management
- **Real-time Portfolio Overview** - Live asset values and performance metrics
- **Asset Allocation Charts** - Interactive pie charts showing fund distributions
- **Connected Users Support** - Manage multiple linked accounts from one interface
- **YTD Performance Tracking** - Year-to-date returns and performance analytics

#### 📊 Advanced Analytics
- **Interactive Line Charts** - Historical performance visualization with FL Chart
- **Multi-timeframe Analysis** - Daily, monthly, and yearly performance views
- **Fund-specific Analytics** - Detailed breakdown by investment fund
- **Comparative Analysis** - Performance comparison across different assets

#### 🔔 Activity & Notifications
- **Real-time Activity Feed** - Live updates on transactions and account changes
- **Push Notifications** - Firebase Cloud Messaging for instant alerts
- **Activity Filtering** - Advanced filtering and sorting capabilities
- **Transaction History** - Comprehensive transaction tracking and details

#### 🔐 Security & Authentication
- **Biometric Authentication** - Face ID/Touch ID integration with local_auth
- **Multi-factor Authentication** - Email verification and secure login
- **Social Login Support** - Google Sign-In and Apple Sign-In integration
- **App Lock Security** - Configurable biometric app locking with timing options
- **Session Management** - Secure session handling with automatic timeout

#### 👤 Profile & Settings
- **Document Management** - Secure document upload and viewing with flutter_pdfview
- **Profile Customization** - Personal information and preferences management
- **Settings Control** - Notification preferences, security settings
- **Support Integration** - In-app FAQ and support contact features

### 🌐 Admin Dashboard Features

#### 👥 Client Management
- **Client Database** - Comprehensive client information management
- **Bulk Operations** - Import/export clients via CSV with data validation
- **Client Linking** - Link Firebase Auth users to client profiles
- **Profile Management** - Edit client details, contact information, and preferences

#### 📈 Portfolio Administration
- **Asset Management** - Create, update, and track client assets across funds
- **Performance Monitoring** - Real-time portfolio performance tracking
- **Activity Management** - Monitor and manage client transactions
- **Reporting Tools** - Generate detailed performance and activity reports

#### 📄 Document & Statement Management
- **Statement Generation** - Automated PDF statement creation
- **Document Upload** - Secure document storage and management
- **Version Control** - Track document versions and updates
- **Access Control** - Manage document permissions and visibility

#### 🔧 Administrative Tools
- **User Authentication** - Manage user access and permissions
- **System Monitoring** - Track system performance and usage
- **Data Export** - Export client and performance data
- **Audit Trails** - Comprehensive activity logging and monitoring

### ☁️ Backend Services

#### 🔄 Firebase Functions
- **Authentication Management** - User linking, unlinking, and validation
- **Asset Calculations** - Automated YTD calculations and performance metrics
- **Notification System** - Push notification delivery and management
- **Document Processing** - Automated document upload and processing
- **Scheduled Tasks** - Automated data updates and maintenance jobs

#### 📊 Data Management
- **Real-time Sync** - Live data synchronization across all platforms
- **Data Validation** - Comprehensive input validation and sanitization
- **Backup Systems** - Automated data backup and recovery
- **Performance Optimization** - Query optimization and caching strategies

## 🛠️ Technology Stack

### Mobile App (Flutter)
```yaml
Framework: Flutter 3.5.3
Language: Dart ^3.5.3
State Management: Provider 6.0.3
Database: Cloud Firestore 5.4.3
Authentication: Firebase Auth 5.3.1
Charts: FL Chart 0.69.0
UI/UX: Material Design with Google Fonts
Security: Local Auth 2.2.0 (Biometric)
```

### Admin Dashboard (React)
```json
Framework: React 18.3.1
Language: TypeScript 5.6.3
UI Library: CoreUI Pro 5.9.2
State Management: Redux 5.0.1
Routing: React Router DOM 6.28.0
Charts: Chart.js 4.4.6
Build Tool: Vite 5.4.11
Styling: SCSS with CoreUI themes
```

### Backend Services
```json
Platform: Firebase Functions (Node.js 22)
Language: TypeScript 5.7.3
Database: Cloud Firestore
Storage: Firebase Storage
Authentication: Firebase Auth
Notifications: Firebase Cloud Messaging
Integrations: Notion API 2.2.16
```

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** 3.5.3 or higher
- **Node.js** 22 or higher
- **Firebase CLI** latest version
- **Xcode** (for iOS development)
- **Android Studio** (for Android development)

### Mobile App Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd armm_app
   ```

2. **Navigate to mobile app**
   ```bash
   cd apps/mobile
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Configure Firebase**
   - Add `google-services.json` to `android/app/`
   - Add `GoogleService-Info.plist` to `ios/Runner/`
   - Update `firebase_options.dart` with your project config

5. **Configure assets**
   - Update `assets/config.json` with environment settings
   - Ensure all required icons are in `assets/icons/`

6. **Run the application**
   ```bash
   flutter run
   ```

### Admin Dashboard Setup

1. **Navigate to web dashboard**
   ```bash
   cd apps/web
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Configure Firebase**
   - Update Firebase configuration in environment files
   - Ensure proper authentication rules are set

4. **Start development server**
   ```bash
   npm start
   ```

5. **Build for production**
   ```bash
   npm run build
   ```

### Backend Services Setup

1. **Navigate to functions directory**
   ```bash
   cd services/functions
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Configure environment**
   - Update `config.json` with collection names
   - Set up environment variables for external APIs

4. **Deploy functions**
   ```bash
   npm run deploy
   ```

## 🔧 Configuration

### Firebase Configuration

The platform uses Firebase for:
- **Authentication** - User management and security
- **Firestore Database** - Real-time data storage
- **Cloud Functions** - Serverless backend logic
- **Cloud Storage** - Document and file storage
- **Cloud Messaging** - Push notifications

### Environment Configuration

#### Mobile App (`assets/config.json`)
```json
{
    "FIRESTORE_ACTIVE_USERS_COLLECTION": "users",
    "ASSETS_SUBCOLLECTION": "assets",
    "NOTIFICATIONS_SUBCOLLECTION": "notifications",
    "ACTIVITIES_SUBCOLLECTION": "activities",
    "GRAPHPOINTS_SUBCOLLECTION": "graphpoints",
    "SCHEDULED_ACTIVITIES_COLLECTION": "scheduledActivities",
    "ASSETS_GENERAL_DOC_ID": "general"
}
```

#### Functions Configuration (`services/functions/config.json`)
- Collection names and IDs
- External API configurations
- Notification settings
- Scheduling parameters

## 🔐 Security Features

### Authentication & Authorization
- **Firebase Authentication** with email/password, Google, and Apple Sign-In
- **Biometric Authentication** using device Face ID/Touch ID
- **Multi-factor Authentication** with email verification
- **Session Management** with configurable timeout periods

### Data Security
- **Firestore Security Rules** for data access control
- **End-to-end Encryption** for sensitive data transmission
- **Input Validation** and sanitization across all endpoints
- **Audit Logging** for administrative actions

### Mobile Security
- **App Lock** with biometric authentication
- **Certificate Pinning** for secure API communications
- **Local Data Encryption** for cached sensitive information
- **Jailbreak/Root Detection** for enhanced security

## 📱 Mobile App Screens

### Core Navigation
- **Dashboard** - Portfolio overview and recent activities
- **Analytics** - Performance charts and detailed analysis
- **Activity** - Transaction history and filtering
- **Profile** - User settings and account management
- **Notifications** - Real-time alerts and updates

### Authentication Flow
- **Login/Signup** - Email/password and social authentication
- **Onboarding** - New user setup and preferences
- **Biometric Setup** - Configure Face ID/Touch ID security
- **Email Verification** - Account verification process

### Profile Management
- **Settings** - App preferences and security options
- **Documents** - View and manage personal documents
- **Support** - FAQ, help documentation, and contact
- **Authentication** - Security settings and biometric configuration

## 🌐 Admin Dashboard Views

### Client Management
- **Client Table** - Searchable, sortable client database
- **Client Creation** - Add new clients with validation
- **Client Editing** - Update client information and settings
- **Import/Export** - Bulk client operations via CSV

### Portfolio Management
- **Asset Overview** - Real-time portfolio performance
- **Fund Management** - Track assets across different funds
- **Activity Monitoring** - Client transaction oversight
- **Performance Analytics** - Historical and current metrics

### Document Management
- **Statement Generation** - Create and distribute client statements
- **Document Upload** - Secure file management system
- **Version Control** - Track document changes and updates
- **Access Management** - Control document visibility and permissions

## 🚀 Deployment

### Mobile App Deployment

#### iOS Deployment
1. **Configure signing** in Xcode with proper certificates
2. **Update version** in `pubspec.yaml` and iOS project settings
3. **Build archive** using Xcode or Flutter commands
4. **Upload to App Store Connect** for review and distribution

#### Android Deployment
1. **Generate signed APK/AAB** using Flutter build commands
2. **Update version codes** in `pubspec.yaml` and `build.gradle`
3. **Upload to Google Play Console** for review and distribution
4. **Configure release management** and staged rollouts

### Web Dashboard Deployment
1. **Build production assets** using `npm run build`
2. **Deploy to hosting service** (Firebase Hosting, Vercel, etc.)
3. **Configure environment variables** for production
4. **Set up SSL certificates** and domain configuration

### Backend Services Deployment
1. **Deploy Firebase Functions** using `npm run deploy`
2. **Configure Firestore security rules** for production
3. **Set up monitoring and alerts** for function performance
4. **Configure backup and disaster recovery** procedures

## 📊 Performance & Monitoring

### Mobile App Performance
- **Flutter Performance** profiling and optimization
- **Memory Management** and leak detection
- **Network Optimization** with caching strategies
- **Battery Usage** optimization techniques

### Backend Monitoring
- **Firebase Console** for function monitoring
- **Error Tracking** with detailed logging
- **Performance Metrics** and alerting
- **Cost Monitoring** and optimization

## 🤝 Contributing

### Development Workflow
1. **Fork the repository** and create feature branches
2. **Follow coding standards** and documentation guidelines
3. **Write comprehensive tests** for new features
4. **Submit pull requests** with detailed descriptions

### Code Standards
- **Flutter/Dart** - Follow official Dart style guide
- **React/TypeScript** - Use ESLint and Prettier configurations
- **Firebase Functions** - Follow Google Cloud Functions best practices

## 📄 License

This project is proprietary software owned by ARMM Group. All rights reserved.

## 📞 Support

For technical support and questions:
- **Email**: info@armmgroup.com
- **Documentation**: Internal knowledge base
- **Issues**: Use GitHub issues for bug reports and feature requests

---
