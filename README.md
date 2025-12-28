![Project Image](Historia.png)





## Table of Contents
- [App Description](#app-description)
- [Concept Deep Dive: Isolates & Asynch queues](#concept-deep-dive-isolates--asynch-queues)
- [System Overview](#system-overview)
- [Architecture Diagrams](#architecture-diagrams)
- [Internal System Workflow](#internal-system-workflow)
- [Applying The Isolates Concept in the Implementation](#applying-the-isolates-concept-in-the-implementation)
- [Design Decisions and Trade-offs](#design-decisions-and-tradeoffs)
- [Setup Instructions](#setup-instructions)
- [License](#license)
- [Author Info](#author-info)

---
## App Description
Users explore content by selecting a geographical region on an interactive map and a corresponding time period, after which relevant historical events and characters are presented

---

## Concept Deep Dive: Isolates & Asynch queues
 ### Overview 

 Dart is a single threaded programming language, which means all operations/code inside your program will be running in a single thread(thread is basically a set of instructions) called *mutator thread*, one at a time, one after another. In dart we use the term *isolate* which is by itself a thread, but differ in fact that isolates don't share memory, each one has its own **isolated** memory

 The operations in dart represent lines of codes, but in flutter it may represent other commands like rendering some components etc

 These operations represent *events* issued by the app running in the isolate, one event coming after another will create something called *event queue*

 Dart will always scan these events **synchronously**, aka **line by line** in the order they arrive, however the **processing** might be synchronous or asynchronous

 These events are processed by something called **an Event Loop** which has an event handler that will process them one after another, if one of the events sepecifies that it will deliver its content in the *future* then its still gonna be scanned and put await until its content arrives, meanwhile the next event is processed and so on

 This achieves ***asynchronousy** in dart making it possible to tackle events with undetermined completion time and treating the next ones in one single isolate in order to avoid freezing our app

 ### Isolates

 In case of heavy or large computations, **one isolate** can't do it alone and will face heavy load which is gonna cause whats called UI jank and our app will freeze or may even be unresponsive

 In this case, we can write code to **spawn** another helper isolate that's gonna do the heavy work while, simultaneously, the main isolate processes the rest of the events

 This achieves **parallelism** which allows using multiple isolates that can help us handle large computations while also maintaining a smooth UI

 ### Downsides

 While its powerful, unfortunately this comes at the cost of **ressources** as each isolate has its own memory, so its pretty expensive ressource wise, adding to that,it may increase complexity, as the only way two isolates can communicate is via sendPort and ReceivePort



--- 

## System Overview

The application is a mobile, client–server system composed of a Flutter-based client and a Django-based backend

The client is responsible for user interaction and data presentation, while the backend handles data storage and querying. The backend relies on a relational database to persist structured historical data related to events and people

The client communicates with the backend to request data, and the backend responds by providing the relevant records from the database. This architecture ensures a clear separation between presentation, data processing, and data management layers

---

## Architecture Diagrams
### High Level Architecture Diagram
```mermaid
flowchart LR
    User[User]

    MobileApp[Mobile App - Flutter]
    Backend[Backend Server - Django]
    DB[(Database)]

    User --> MobileApp

    MobileApp -->|HTTPS Requests| Backend
    Backend -->|Responses| MobileApp

    Backend -->|Read Write| DB
```
### User flow diagram
```mermaid
flowchart TD
    Start([Start])

    MapSelection([Select Region on Map])
    TimeSelection([Select Time Period])
    ShowResults([Display Events & Characters *characters not implemented yet*])

    End([End])

    Start --> MapSelection
    MapSelection --> TimeSelection
    TimeSelection --> ShowResults
    ShowResults --> End


```
---

## Internal System Workflow
### Backend Data Modeling and Data Ingestion :
The backend was implemented using **Django** and is responsible for managing the app's data

Two main models were created : 
- **Event**
- **Person**

The required data was initially provided through two CSV files. Custom django scripts were created to parse these files and directly instantiate model objects. By leveraging django's ORM, these objects were automatically stored in the database

Data retrieval is performed through django queries based on specific criteria, ex:  
For *event*, filtering is based on country and place name 


---

## Applying The Isolates Concept in the Implementation

--- 


## Design Decisions and Trade-offs
 ### UI Design System
 We adopted **Material 3** as the base design system (a google's design system) to ensure visual consistency and alignment with modern android design guidelines. However, relying only on predefined components limited flexibility for certain interaction patterns.To address this, we combined material 3 components with custom flutter widgets, allowing us to preserve design coherence while tailoring specific UI elements to the application's functional needs
 The trade-off here was an increase in UI implementation complexity in exchange for better control over user experience

 ### Map provider Selection
 The application uses **OpenStreetMap** instead of proprietary map solutions (aka google maps), this decision was taken due to the need for an open-source, cost-free mapping solution along with geolocator to get the location of the user



---


## Setup Instructions


---

## License



[Back To The Top](#read-me-template)

---

## Author Info



