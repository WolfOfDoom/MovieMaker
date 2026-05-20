# 🎬 MovieMaker — Catálogo de Películas con Flutter y Firebase

¡Bienvenido a **MovieMaker**! Esta es una aplicación móvil moderna e intuitiva desarrollada en **Flutter** y **Dart** para la gestión y visualización de un catálogo completo de películas. El proyecto implementa una arquitectura limpia y se conecta de forma nativa a los servicios en la nube de **Google Firebase** para ofrecer sincronización en tiempo real y seguridad.

---

## 🚀 Características del Proyecto (Criterios de Evaluación)

La aplicación ha sido diseñada y construida cumpliendo estrictamente con los siguientes requerimientos técnicos y de experiencia de usuario:

* 🔐 **Pantalla de Inicio y Autenticación:** Interfaz de bienvenida interactiva que permite a nuevos cinéfilos registrarse o ingresar si ya poseen una cuenta activa, utilizando **Firebase Authentication** (Correo/Contraseña).
* 🍿 **Catálogo Dinámico:** Visualización del catálogo completo de películas en un formato de cuadrícula (*Grid*), mostrando de forma limpia el título y una imagen de portada de referencia.
* 🍔 **Menú de Selección Superior:** Incorporación de un menú desplegable (`Icons.menu`) en la parte superior izquierda de la barra de herramientas para seleccionar y validar la navegación del catálogo.
* 📖 **Descripción Detallada:** Pantalla optimizada para visualizar a detalle las 5 características esenciales del título seleccionado: *Título, Año de estreno, Director, Género y Sinopsis*.
* ⚙️ **Panel de Administración Completo:** Módulo exclusivo que permite dar de **Alta** (formulario con los 6 campos requeridos, incluyendo URL de la imagen) y **Baja** (eliminación asíncrona) de títulos en el catálogo.
* 🌐 **Solicitudes HTTP Activas:** Descarga y renderizado eficiente de imágenes de internet mediante solicitudes de red asíncronas `HTTP GET`.
* ☁️ **Base de Datos en la Nube:** Vinculación directa con **Cloud Firestore** (Base de datos NoSQL). Todos los cambios efectuados (altas y bajas) persisten de forma inmediata en los servidores de Google y se actualizan en la app sin recargar.
* 🛠️ **Tecnología Oficial y Actualizada:** El desarrollo hace uso de los entornos, SDKs y herramientas oficiales más recientes provistos por las comunidades de Flutter, Dart y Firebase.

---

## 🛠️ Stack Tecnológico

* **Framework:** [Flutter](https://flutter.dev/) (Última versión estable)
* **Lenguaje:** [Dart](https://dart.dev/)
* **Base de Datos NoSQL:** [Cloud Firestore](https://firebase.google.com/docs/firestore)
* **Autenticación de Usuarios:** [Firebase Authentication](https://firebase.google.com/docs/auth)
* **Gestor de Dependencias:** Pub.dev

---

## 📂 Estructura del Proyecto (`lib/`)

El código fuente está organizado bajo buenas prácticas de separación de responsabilidades:

```text
lib/
├── main.dart                  # Punto de entrada de la aplicación e inicialización de Firebase
├── firebase_options.dart      # Credenciales de conexión autogeneradas por FlutterFire CLI
├── models/
│   └── movie_model.dart       # Modelo de datos 'Movie' y mapeo de documentos de Firestore
└── screens/
    ├── auth_screen.dart       # Pantalla de Bienvenida, Ingreso y Registro de usuarios
    ├── catalog_screen.dart    # Cuadrícula del catálogo con menú superior y StreamBuilder en tiempo real
    ├── detail_screen.dart     # Pantalla de visualización detallada de la película seleccionada
    └── admin_screen.dart      # Formulario de Alta y lista de eliminación (Baja) de títulos
