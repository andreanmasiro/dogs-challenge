## Dogs App

This repository contains an example of a simple and scalable architecture. 

### Components

* Client: Responsible for talking with external http server
* Gateway: Responsible for fetching domain data
* Interactor: Responsible for handling business logic
* ViewController
  * Builds a scene view hierarchy
  * Fetches data from where it is provided
  * Binds view models to its views
* Coordinator: Responsible for a flow of navigation

View controller has a little bit too many responbilities at a glance,
but since this is a small project I think it is fine this way. If we
were to scale this project, we could split its responsibilities this way:

* View: would build the view hierarchy
* ViewController: would bind view models to view and notify events
* Controller: would fetch data from where it is provided and transform it into viewmodels to bind it to the view controller
