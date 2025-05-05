# ngon_mang_di


### 🏗️ Application architecture (Flutter Clean Architecture)

The project follows a Clean Architecture approach combined with Riverpod for efficient state management.

This structure ensures scalability, testability, and maintainability, making it easier to develop and expand the app over time 🔄.
```Console

├───common                               # Shared utilities and reusable components
│   ├───bloc                             # Global state management using BLoC
│   │   ├───authentication               # Authentication BLoC (for Know has login before)
│   │   └───theme                        # Theme management BLoC
│   ├───helpers                          # Helper functions and utilities
│   └───widgets                          # Reusable Custom UI components
│       ├───appbar         
│       ├───button         
│       ├───footer                 
│       ├─── ...
├───core                                 # Core functionality and configurations
│   ├───api                              # API-related functionalities
│   ├───configs                          # Application-wide configurations
│   │   ├───assets                       # Asset management
│   │   └───theme                        # Theme settings (Color font)
│   ├───constants                        # Constant values
│   ├───enum                             # Enum definitions
│   ├───local                            # Local storage management
│   └───usecase           
├───data                                 # Data layer (models, repositories, data sources)
│   ├───models                           # Data models (DTO)
│   │   ├───auth          
│   │   ├───booking       
│   │   ├───cast          
│   │   ├───cinema        
│   │   ├─── ...     
│   ├───repository                       # Repository layer for data fetching
│   │   ├───all_movie     
│   │   ├───auth          
│   │   ├───authentication 
│   │   ├─── ...     
│   └───sources                          # Data sources (API, local storage, etc.)
│       ├───all_movie   
│       ├───auth          
│       ├───authentication 
│       ├─── ...       
├───domain                               # Domain layer (business logic, entities, use cases)
│   ├───entities                         # Core business entities ()
│   │   ├───auth          
│   │   ├───booking      
│   │   ├───cast        
│   │   ├───cinema        
│   │   ├─── ...    
│   ├───repository                       # Abstract repository interfaces
│   │   ├───all_movie    
│   │   ├───auth         
│   │   ├───authentication 
│   │   ├─── ...     
│   │   └───tickets       
│   └───usecase                          # Business logic use cases
│       ├───all_movie    
│       ├───authentication 
│       ├───booking_time  
│       ├─── ...        
└───presentation                         # Presentation layer (UI and state management)
    ├───about_page                       # About screen
    │   ├───bloc                         # BLoC for About page
    │   └───widgets                      # UI components
    ├───all_movies       
    │   ├───bloc         
    │   └───widgets     
    ├───all_tickets          
    ├───booking          
    │   ├───booking_seat_slot 
    │   ├───booking_seat_type 
    │   ├───booking_time_slot 
    │   └───model        
    ├───home                 
    ├───intro            
    ├───login                 
    ├───movie_detail     
    ├───register         
    ├───splash  