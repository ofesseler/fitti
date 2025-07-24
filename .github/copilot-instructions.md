# Copilot Instructions for Fitti

## Project Overview
- **Fitti** is a modular Flutter app for workout tracking. It supports creating, editing, and removing workouts and exercises, with local data management and JSON import/export.
- The codebase is organized for maintainability and testability, with a focus on clear UI logic and robust input validation.

## Architecture & Key Patterns
- **Screens** (`lib/screens/`): Main UI flows, e.g., `WorkoutScreen` manages workout creation and editing.
- **Widgets** (`lib/widgets/`): Reusable UI components, e.g., `ExerciseCard` for exercise input, with error feedback.
- **Domain Models** (`lib/domain/`): Core data structures (`Workout`, `Exercise`, `WorkoutListModel`).
- **State Management**: Uses Provider (`WorkoutListModel`) for app-wide state.
- **Validation**: Input validation and error feedback are handled in parent screens and passed to widgets as errorText.
- **Testing** (`test/`): Widget and logic tests are required for all features. Tests expect UI elements to have tooltips (e.g., 'Add Exercise', 'Remove Exercise') for reliable selection.

## Developer Workflows
- **Build & Run**: Use `flutter run` for local development. For iOS, specify the simulator with `flutter run -d <device-id>`.
- **Testing**: Run all tests with `flutter test`. Tests are expected to pass before commit.
- **Stepwise Commits**: Commit after every meaningful change. Run tests before each commit.
- **Validation**: All user input (exercise name, reps, weight) must be validated and errors surfaced in the UI.
- **Dialogs**: Use confirmation dialogs for destructive actions (e.g., removing exercises).

## Project-Specific Conventions
- **Error Handling**: Error messages for invalid input are managed in parent screens and passed to widgets as parameters (e.g., `nameError`, `repsError`, `weightError`).
- **Widget Keys**: Use unique keys for dynamic widgets (e.g., `ValueKey('exercise_card_${exercise.id}')`).
- **Tooltips**: All interactive buttons (add/remove) must have tooltips for testability.
- **Controllers**: Exercise input fields use `ExerciseControllers` for managing text state.
- **Provider Usage**: Always access `WorkoutListModel` via Provider in screens.

## Integration & External Dependencies
- **Flutter**: Core framework.
- **Provider**: State management.
- **flutter_test**: Testing framework.

## Examples
- See `lib/screens/workout_screen.dart` for validation, error feedback, and dialog patterns.
- See `test/workout_screen_controller_test.dart` for widget test structure and tooltip usage.

---

If you are unsure about a pattern or workflow, check the relevant file in `lib/screens/`, `lib/widgets/`, or `test/` for concrete examples. When adding new features, follow the modular, test-driven, and validation-focused approach demonstrated in the current codebase.
