---

# **Event Management and Booking Platform**  

## **Overview**  

This **Event Management and Booking Platform** is designed for both event organizers and attendees, offering seamless event creation, management, and participation. It includes real-time ticket booking, advanced analytics, and an interactive user experience. Built with **Flutter** for the frontend, **Firebase** for the backend, and a **local SQL database** for offline storage, it ensures a robust and efficient solution.  

---

## 🚀 **Project Overview**  

The platform provides a comprehensive solution for event and booking management by enabling:  
- **Organizers** to create, manage, and update events.  
- **Attendees** to browse events, book tickets, and view event details.  
- Real-time booking and payment integrations for smooth transactions.  
- Advanced analytics for organizers to track event performance and engagement.  

---

## 🎯 **Key Features**  

### **Level 1: Foundational System – Event Management**  

#### Event Management:  
- Create, update, and delete events.  
- Filter events by **date**, **location**, **category**, and more.  
- Store event details such as title, description, location, date, time, category, ticket price, and organizer information.  

#### User Authentication:  
- Secure login using **Firebase Authentication** (email/password).  
- Role-based access control:  
  - **Admin**: Full access to all data.  
  - **Organizer**: Manage their own events.  
  - **User**: Browse events and book tickets.  

---

### **Level 2: Real-Time Ticket Booking System**  

#### Booking System:  
- Real-time ticket booking with integrated payment gateway.  
- Smooth transactions for event bookings.  

---

## 🛠️ **Technical Stack**  

### **Frontend**  
- **Flutter**: Cross-platform mobile development.  

### **Backend**  
- **Firebase**: Firestore, Authentication, and Storage.  

### **Database**  
- **Local SQL**: Offline storage using `sqflite`.  

### **Authentication**  
- **Firebase Authentication**: Email/Password, Google Sign-In.  

### **Payment Integration**  
- **Razorpay**: Payment gateway integration.  

---

## 🧑‍💻 **Requirements**  

### **Backend Requirements**  

#### Firebase Authentication:  
- Secure user authentication using **Firebase Authentication**.  
- Supported authentication types: **Email/Password**.  
- Real-time data syncing between the app and Firestore.  

#### Local SQL Database (Offline Storage):  
- Store event details, user data, and session information locally.  
- Sync data with Firebase when the app is online.  

#### Firebase Storage:  
- Store event-related media (e.g., images, documents).  

---

### **Frontend Requirements**  

#### Flutter UI:  
- Design a responsive and interactive UI for Android and iOS.  
- Enable event browsing by **category**, **location**, and filters.  
- Provide functionality for viewing event details and booking tickets.  
- Allow organizers to manage and create events.  

#### User Authentication:  
- Provide login and registration pages for secure access.  

#### Offline Functionality:  
- Store event and user data locally using SQL.  
- Sync data with Firebase upon reconnection.  

---

## 📚 **Setup Instructions**  

### **Backend Setup (Firebase)**  
1. Create a Firebase project:  
   - Visit the [Firebase Console](https://console.firebase.google.com/) and create a project.  
   - Enable Firestore, Authentication, and Firebase Storage.  
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS), and add them to respective platform folders.  

---

### **Frontend Setup (Flutter)**  

1. Clone the repository:  
   ```bash  
   git clone https://github.com/your-username/event-management-platform  
   cd event-management-platform  
   ```  

2. Install dependencies:  
   ```bash  
   flutter pub get  
   ```  

3. Configure Firebase for Flutter:  
   - Follow the [Firebase setup for Flutter](https://firebase.google.com/docs/flutter/setup).  
   - Add Firebase SDKs for **Firestore**, **Authentication**, and **Firebase Storage**.  

4. Run the app:  
   ```bash  
   flutter run  
   ```  

---

### **Local SQL Database Setup (Offline Storage)**  

1. Set up the SQL database using the `sqflite` package:  
   - Configure tables to store event and user data.  

2. Implement offline-to-online sync logic:  
   - Ensure data syncs with Firebase when the app is back online.  

---

## 🎯 **Deliverables**  

1. **Working Backend**:  
   - Firebase Firestore for event data.  
   - Firebase Authentication for secure user access.  
   - Firebase Storage for media.  

2. **Frontend Application**:  
   - A Flutter-based app with responsive UI and real-time ticket booking.  

3. **Local SQL Database**:  
   - Offline data storage for events and users.  

4. **Payment Integration**:  
   - Integration with Razorpay for booking payments.  

---

## 👥 **Authors**  

- **Pralhad** – [GitHub](https://github.com/Pralha17)  

---

## 📚 **Resources**  

- [**Flutter Documentation**](https://docs.flutter.dev/)  
- [**Firebase Documentation**](https://firebase.google.com/docs/)  
- [**SQL Documentation (sqflite)**](https://pub.dev/packages/sqflite)  

--- 

## 🎥 **Demo Video**

Watch the app demo here: [Event Management Platform Demo](https://drive.google.com/file/d/16sr9xOkraMGijH0cVcbGLV9nObkJlZmU/view?usp=drive_link)

