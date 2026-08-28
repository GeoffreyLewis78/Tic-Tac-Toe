# Tic-Tac-Toe

A Tic-Tac-Toe game built with SwiftUI.

## About

This project was created as a SwiftUI learning exercise, focusing on state management, game logic, animations, and basic AI behaviour.

The player controls **X** while the AI controls **O**. The game automatically detects wins, draws, and handles AI turns with a short delay for a more natural gameplay experience.

## Features

- Human vs AI gameplay
- Win detection
- Draw detection
- Winning line highlighting
- Animated game board interactions
- AI thinking delay
- Live game status updates
- Reset and replay functionality
- SwiftUI-based user interface

## AI Behaviour

The AI follows a simple rule-based strategy:

1. Take a winning move if available.
2. Block the player's winning move.
3. Take the centre square if available.
4. Choose a corner square.
5. Choose a side square.

This approach provides a reasonably challenging opponent while keeping the implementation straightforward and easy to understand.

## Technologies Used

- Swift
- SwiftUI
- Xcode

## Project Structure

- `ContentView.swift` - User interface, game logic, and AI behaviour
- `TicTacToeApp.swift` - Application entry point

## Current Status

✅ Working and playable

The game currently includes a complete single-player experience against a basic AI opponent with visual feedback, animations, win detection, and draw handling.

## Future Improvements

Potential enhancements include:

- Minimax AI implementation
- Multiple difficulty levels
- Score tracking
- Sound effects
- Improved visual styling
- Dark mode enhancements
- Local multiplayer mode
- Additional animations and effects

## Learning Goals

This project was built to explore:

- SwiftUI views and layouts
- State management using `@State`
- Grid-based interfaces with `LazyVGrid`
- Game logic implementation
- Animation in SwiftUI
- Basic AI decision making

---

Created as part of a SwiftUI learning journey.
