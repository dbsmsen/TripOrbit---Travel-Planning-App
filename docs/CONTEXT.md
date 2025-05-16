# TripOrbit - Travel Planning App

A comprehensive travel planning application built with Flutter that helps users plan trips, discover destinations, and explore services around their travel location. The app features AI-driven recommendations, group travel capabilities, and seamless integration with various travel services.

## Tech Stack
- Frontend: Flutter, Dart
- Backend/Database: Supabase
- UI Framework: Flutter
- AI Processing: DeepSeek
- **State Management**: Riverpod/Provider/Bloc
- **Backend**: Supabase
- **Maps**: Google Maps API/MapBox
- **Authentication**: Supabase Auth

## Table of Contents
- [Core Features](#core-features)
- [Screen Flow](#screen-flow)
- [Technical Architecture](#technical-architecture)
- [Development Guidelines](#development-guidelines)

## Core Features

### 1. Onboarding Experience
- Animated walkthrough showcasing key features:
  - Trip planning capabilities
  - Tourist spot discovery
  - Bike rentals and flight bookings
  - Group travel functionality
- Skip and Next navigation options

### 2. Authentication System
- Multiple sign-in methods:
  - Email/Password authentication
  - Phone number (OTP-based)
  - Google Sign-In integration
- New user registration with:
  - Full name
  - Email address
  - Phone number
  - Password
  - OTP verification

### 3. Home Screen
- Destination search functionality
- AI-powered travel data integration
- Display of:
  - Tourist attractions
  - Bike rental options
  - Nearby accommodations and dining
- Bottom navigation for module access

### 4. Map Integration
- Real-time location tracking
- Points of interest visualization
- Service location mapping:
  - Tourist spots
  - Hotels
  - Restaurants
  - Bike rental stations

### 5. Group Travel Features
- Group creation and management
- Invite system via codes/links
- Collaborative features:
  - Group chat
  - Shared itineraries
  - Member location tracking

### 6. Flight Booking
- Multi-source flight comparison
- Search functionality:
  - Route selection
  - Date picking
  - Price comparison
  - Duration and airline information

### 7. AI-Powered Suggestions
- Personalized recommendations:
  - Nearby attractions
  - Trending destinations
  - User preference-based suggestions

### 8. User Profile Management
- Profile information display
- Personal details editing
- Trip history viewing
- Secure logout functionality

## Extended Features

### Travel Budget Planner
- Budget estimation tools
- Expense tracking
- Spending analytics

### Daily Schedule Generator
- Automated itinerary creation
- Day-wise activity planning
- Customizable schedules

### Language Translator
- Real-time translation
- Voice support
- Offline phrase storage

### Weather Integration
- 7-day forecasts
- Weather-based recommendations
- Travel alerts

### API Integrations
- Skyscanner API
- Yelp API
- Zomato API
- Google Places API
- OpenWeatherMap
- Google Translate API

## Database Schema

### Users Table
```sql
users (
  id: uuid PRIMARY KEY,
  email: text UNIQUE NOT NULL,
  full_name: text NOT NULL,
  phone_number: text,
  avatar_url: text,
  created_at: timestamp with time zone DEFAULT now(),
  updated_at: timestamp with time zone DEFAULT now(),
  preferences: jsonb,
  last_login: timestamp with time zone
)
```

### Trips Table
```sql
trips (
  id: uuid PRIMARY KEY,
  user_id: uuid REFERENCES users(id),
  title: text NOT NULL,
  description: text,
  start_date: date NOT NULL,
  end_date: date NOT NULL,
  destination: text NOT NULL,
  status: text CHECK (status IN ('planned', 'ongoing', 'completed', 'cancelled')),
  created_at: timestamp with time zone DEFAULT now(),
  updated_at: timestamp with time zone DEFAULT now(),
  budget: decimal,
  currency: text DEFAULT 'USD'
)
```

### Trip_Members Table
```sql
trip_members (
  id: uuid PRIMARY KEY,
  trip_id: uuid REFERENCES trips(id),
  user_id: uuid REFERENCES users(id),
  role: text CHECK (role IN ('owner', 'member', 'viewer')),
  joined_at: timestamp with time zone DEFAULT now(),
  UNIQUE(trip_id, user_id)
)
```

### Itineraries Table
```sql
itineraries (
  id: uuid PRIMARY KEY,
  trip_id: uuid REFERENCES trips(id),
  day_number: integer NOT NULL,
  date: date NOT NULL,
  notes: text,
  created_at: timestamp with time zone DEFAULT now(),
  updated_at: timestamp with time zone DEFAULT now()
)
```

### Activities Table
```sql
activities (
  id: uuid PRIMARY KEY,
  itinerary_id: uuid REFERENCES itineraries(id),
  title: text NOT NULL,
  description: text,
  start_time: time,
  end_time: time,
  location: text,
  cost: decimal,
  booking_reference: text,
  status: text CHECK (status IN ('planned', 'confirmed', 'cancelled')),
  created_at: timestamp with time zone DEFAULT now(),
  updated_at: timestamp with time zone DEFAULT now()
)
```

### Expenses Table
```sql
expenses (
  id: uuid PRIMARY KEY,
  trip_id: uuid REFERENCES trips(id),
  user_id: uuid REFERENCES users(id),
  category: text NOT NULL,
  amount: decimal NOT NULL,
  currency: text DEFAULT 'USD',
  date: date NOT NULL,
  description: text,
  receipt_url: text,
  created_at: timestamp with time zone DEFAULT now(),
  updated_at: timestamp with time zone DEFAULT now()
)
```

### Reviews Table
```sql
reviews (
  id: uuid PRIMARY KEY,
  user_id: uuid REFERENCES users(id),
  trip_id: uuid REFERENCES trips(id),
  rating: integer CHECK (rating >= 1 AND rating <= 5),
  comment: text,
  created_at: timestamp with time zone DEFAULT now(),
  updated_at: timestamp with time zone DEFAULT now()
)
```

### Saved_Places Table
```sql
saved_places (
  id: uuid PRIMARY KEY,
  user_id: uuid REFERENCES users(id),
  name: text NOT NULL,
  place_id: text NOT NULL,
  location: geography(POINT),
  category: text,
  notes: text,
  created_at: timestamp with time zone DEFAULT now(),
  updated_at: timestamp with time zone DEFAULT now()
)
```

## Project Structure

```
trip_orbit/
├── android/                 # Android-specific files
├── ios/                    # iOS-specific files
├── lib/
│   ├── core/              # Core functionality
│   │   ├── constants/     # App-wide constants
│   │   ├── errors/        # Error handling
│   │   ├── network/       # Network related code
│   │   ├── theme/         # App theme and styling
│   │   └── utils/         # Utility functions
│   │
│   ├── data/              # Data layer
│   │   ├── datasources/   # Data sources (local/remote)
│   │   ├── models/        # Data models
│   │   └── repositories/  # Repository implementations
│   │
│   ├── domain/            # Business logic layer
│   │   ├── entities/      # Business objects
│   │   ├── repositories/  # Repository interfaces
│   │   └── usecases/      # Use cases
│   │
│   ├── presentation/      # UI layer
│   │   ├── screens/       # Screen widgets
│   │   │   ├── auth/      # Authentication screens
│   │   │   ├── home/      # Home screen
│   │   │   ├── trips/     # Trip-related screens
│   │   │   ├── profile/   # Profile screens
│   │   │   └── settings/  # Settings screens
│   │   │
│   │   ├── widgets/       # Reusable widgets
│   │   │   ├── common/    # Common widgets
│   │   │   ├── forms/     # Form widgets
│   │   │   └── cards/     # Card widgets
│   │   │
│   │   └── providers/     # State management
│   │
│   ├── services/          # External services
│   │   ├── api/          # API clients
│   │   ├── location/     # Location services
│   │   ├── storage/      # Storage services
│   │   └── analytics/    # Analytics services
│   │
│   └── main.dart         # App entry point
│
├── test/                 # Test files
│   ├── unit/            # Unit tests
│   ├── widget/          # Widget tests
│   └── integration/     # Integration tests
│
├── assets/              # Static assets
│   ├── images/         # Image assets
│   ├── fonts/          # Font files
│   └── icons/          # Icon assets
│
├── docs/               # Documentation
│   ├── api/           # API documentation
│   ├── architecture/  # Architecture docs
│   └── guides/        # Development guides
│
├── .github/           # GitHub specific files
├── .vscode/          # VS Code settings
├── pubspec.yaml      # Flutter dependencies
└── README.md         # Project documentation
```

### Key Directories Explained

#### Core
- Contains app-wide functionality and utilities
- Houses constants, error handling, and theme configuration
- Manages network connectivity and common utilities

#### Data
- Implements data access layer
- Contains models and repository implementations
- Manages local and remote data sources

#### Domain
- Contains business logic
- Defines entities and repository interfaces
- Implements use cases for features

#### Presentation
- Manages UI components
- Organizes screens and widgets
- Handles state management

#### Services
- Integrates external services
- Manages API clients
- Handles location, storage, and analytics

## Development Guidelines

### UI/UX Principles
- Prioritize intuitive navigation
- Implement smooth animations
- Ensure responsive design
- Maintain consistent branding

### Security Considerations
- Secure user data storage
- Implement proper authentication
- Follow data protection guidelines
- Regular security audits

### Performance Optimization
- Implement efficient caching
- Optimize map rendering
- Minimize API calls
- Handle offline functionality

### Best Practices
- Follow Flutter coding standards
- Implement proper error handling
- Maintain comprehensive documentation
- Regular code reviews and testing

## Development Roadmap

### Phase 1: Project Setup and Authentication (Week 1)
1. **Initial Setup**
   - Create Flutter project
   - Set up Supabase project
   - Configure development environment
   - Initialize Git repository

2. **Authentication Implementation**
   - Set up Supabase Auth
   - Implement email/password authentication
   - Add Google Sign-In
   - Create phone authentication
   - Build login and registration screens
   - Implement password reset flow

### Phase 2: Core Features - Part 1 (Week 2)
1. **User Profile**
   - Create profile screen
   - Implement profile editing
   - Add avatar upload functionality
   - Set up user preferences

2. **Home Screen**
   - Design and implement main dashboard
   - Add search functionality
   - Create destination cards
   - Implement navigation drawer

3. **Map Integration**
   - Set up Google Maps
   - Implement location services
   - Add place markers
   - Create location search

### Phase 3: Trip Management (Week 3)
1. **Trip Creation**
   - Build trip creation flow
   - Implement date selection
   - Add destination search
   - Create trip details screen

2. **Itinerary Management**
   - Design itinerary interface
   - Implement day-by-day planning
   - Add activity scheduling
   - Create drag-and-drop functionality

3. **Group Features**
   - Implement group creation
   - Add member invitation system
   - Create group chat
   - Build member management

### Phase 4: Core Features - Part 2 (Week 4)
1. **Budget Management**
   - Create expense tracking
   - Implement budget planning
   - Add expense categories
   - Build expense reports

2. **Reviews and Ratings**
   - Implement review system
   - Add rating functionality
   - Create review display
   - Build user feedback system

3. **Saved Places**
   - Implement place saving
   - Create favorites system
   - Add place categories
   - Build place details view

### Phase 5: Advanced Features (Week 5)
1. **AI Integration**
   - Set up DeepSeek integration
   - Implement recommendation system
   - Add smart itinerary suggestions
   - Create personalized content

2. **Weather Integration**
   - Add weather API
   - Implement weather forecasts
   - Create weather alerts
   - Build weather-based suggestions

3. **Language Translation**
   - Implement translation service
   - Add offline phrase storage
   - Create translation UI
   - Build voice support

### Phase 6: Testing and Optimization (Week 6)
1. **Testing**
   - Write unit tests
   - Implement widget tests
   - Perform integration testing
   - Conduct user acceptance testing

2. **Performance Optimization**
   - Optimize image loading
   - Implement caching
   - Reduce API calls
   - Optimize database queries

3. **UI/UX Refinement**
   - Polish animations
   - Improve responsiveness
   - Enhance accessibility
   - Optimize for different screen sizes

### Phase 7: Deployment and Launch (Week 7)
1. **Final Preparations**
   - Complete documentation
   - Prepare app store assets
   - Create marketing materials
   - Set up analytics

2. **Deployment**
   - Configure production environment
   - Set up CI/CD pipeline
   - Deploy backend services
   - Prepare app store submissions

3. **Launch**
   - Submit to app stores
   - Monitor initial feedback
   - Address critical issues
   - Plan post-launch updates

## Development Guidelines for Each Phase

### Before Starting Each Phase
1. Review requirements and acceptance criteria
2. Set up necessary development environment
3. Create feature branches
4. Update documentation

### During Development
1. Follow Flutter best practices
2. Write clean, documented code
3. Implement proper error handling
4. Add logging for debugging
5. Create unit tests for new features

### After Completing Each Phase
1. Conduct code review
2. Run test suite
3. Update documentation
4. Merge to development branch
5. Deploy to staging environment

## Testing Strategy

### Unit Testing
- Test individual components
- Verify business logic
- Check error handling
- Validate data transformations

### Widget Testing
- Test UI components
- Verify user interactions
- Check responsive design
- Validate state management

### Integration Testing
- Test feature workflows
- Verify API integration
- Check data persistence
- Validate third-party services

### Performance Testing
- Measure load times
- Check memory usage
- Verify API response times
- Test offline functionality

## Quality Assurance Checklist

### Code Quality
- [ ] Follows Flutter style guide
- [ ] Proper error handling
- [ ] Comprehensive documentation
- [ ] Clean architecture principles

### UI/UX
- [ ] Consistent design language
- [ ] Responsive layout
- [ ] Accessibility support
- [ ] Smooth animations

### Performance
- [ ] Fast load times
- [ ] Efficient API calls
- [ ] Proper caching
- [ ] Memory optimization

### Security
- [ ] Secure authentication
- [ ] Data encryption
- [ ] API security
- [ ] Input validation

---

*This documentation serves as a comprehensive guide for developers implementing the TripOrbit travel planning application. Regular updates and modifications may be required as the project evolves.*
