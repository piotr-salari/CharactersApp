# Characters App

## Building & Running the Application

- The project relies on **Swift Package Manager (SPM)** for dependency management, meaning there are no extra steps needed for package installation.
- The app builds and runs smoothly on the simulator. However, if you're deploying to a physical device, you may need to adjust the **Bundle ID**.

## Key Design Decisions and Assumptions:

### 1. Architectural Choices:
- The app follows the **MVVM** (Model-View-ViewModel) architecture pattern.
- **Dependency injection** is used for the service layer to promote testability and flexibility.
- The application takes advantage of modern concurrency features in Swift, such as **async/await** and **Task**.
- **Combine** and **@Published** are used to implement **reactive programming** in the app’s state management.

### 2. Handling Concurrency and State:
- **Task** is utilized to manage asynchronous tasks throughout the app.
- Network requests support **cancellation** to avoid redundant tasks or unnecessary fetches.
- The app maintains `isLoading` and `error` states, providing feedback to users regarding ongoing processes and failures.
- **AsyncStream** is employed to manage and react to changes in character status.

### 3. Service Layer Design:
- An abstract **CharacterServiceInterface** protocol has been created to define the service layer, enabling easier testing and mocking.
- The service layer is flexible and can be swapped or mocked with minimal changes, thanks to dependency injection.

## Solutions to Key Challenges:

### 1. **Challenge: Managing Concurrent Network Requests**
**Solution**: Implemented a mechanism for canceling tasks  
- To avoid multiple overlapping requests, `fetchTask?.cancel()` is used to stop previous network calls.
- The `Task.checkCancellation()` method is used to quickly exit canceled tasks.

### 2. **Challenge: Handling Network Errors Gracefully**
**Solution**: Integrated error and loading states into the view model  
- The view model tracks `error` and `isLoading` states to manage UI updates based on request status.
- During development, errors are logged to the console (though this would be replaced with more sophisticated logging in production).

### 3. **Challenge: Ensuring Testability of Components**
**Solution**: Dependency injection to decouple components  
- Services are injected into view models, making it easier to mock dependencies for unit tests.
- The app’s view models are designed with clear, isolated methods, ensuring they remain simple and easy to test.

## Author:
- **Piotr Salari**
