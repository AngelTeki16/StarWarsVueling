
# Starwars Vueling

Aplicación iOS que consume la API pública SWAPI para listar personajes del universo Star Wars, permitiendo ver sus películas, soportando modo offline, paginación infinita, búsqueda local y monetización mediante anuncios internos.


## Arquitectura

La aplicación está desarrollada utilizando:

UIKit + Programmatic UI
MVVM + Coordinators
Repository Pattern
Dependency Injection (DependencyContainer)
Core Data para almacenamiento offline

## Funcionalidades principales

Listado de personajes con paginación infinita.
Se consume la API de SWAPI usando un RemoteDataSource que analiza el campo "next" para continuar o detener la paginación.
La paginación es endless scroll, sin librerías externas.

Modo offline (Core Data).
Descarga personajes y películas remotamente.
Guarda automáticamente una copia local en Core Data.
Si no hay conexión, la app utiliza los últimos datos almacenados.
El usuario puede navegar completamente offline.

Detalle del personaje (Films).
Se abre una pantalla coordinada por FilmsCoordinator
Se muestran todas las películas del personaje:
- Nombre
- Director
- Fecha de estreno
Las películas se ordenan por releaseDate

Búsqueda local.

Publicidad interna.
Un protocolo AdsService evita acoplar la app al SDK interno.
El ViewModel inserta objetos .ad dentro del listado.
El ViewController muestra una celda especial PUBLICIDAD.
Desde el icono de tuerca en el navbar, el usuario activa o desactiva la publicidad.

Pruebas Unitarias. 
Pruebas unitarias en viewModel de listado princiapal
Pruebas unitarias para Impl de repository

Conclusión.
Arquitectura limpia y escalable
Uso moderno de Swift Concurrency
Integración de modo offline
Paginación infinita
Búsqueda eficiente
Ads desacoplada
MVVM + C
## Extra:
- El equipo Mobile ha ganado  el  concurso y cree que la app puede ser útil para muchos fans de la franquicia, por lo que han  decidido  publicarla  en las tiendas de aplicaciones y monetizarla. Se ha optado  por  mostrar  anuncios  en la aplicación, concretamente  en  los  listados de los  personajes. Los anuncios son generados  por  un SDK  interno de la compañía al que habrá que llamar  cada  vez que necesitemos  generar un anuncio. Cada X personajes  en  los  listados se quiere  mostrar un anuncio. ¿Qué  cambios  realizarías  en  el  proyecto para cubrir  esta  necesidad? 

- Implementacion del SDK (Pods, SPM, SDK)
- Ampliar DependecyContainer para inyectar los datos del servicio
- En viewModel generar lista de itemes personaje/anuncio
- Actualizar tabla / celda para soportar anuncios y su aplicaciones


- Se decide crear una segunda aplicación o Widget que comparta la misma fuente de datos local de personajes ya creada. ¿Qué  cambios  ejecutarías en el proyecto?

- Crear el nuevo proyecto / Widget
- La app base debe ser host
- Si es widget podriamos usar widgetKit
- Para "Unir" los proyectos debemos tener un appGroup
- Una vez conectadas la vista se podrian compartir data dependiendo el alcance pensado
