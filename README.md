## Índice

1. [Lanzamiento del Proyecto](#1-lanzamiento-del-proyecto)
   - [1.1. Especificaciones Técnicas](#11-especificaciones-técnicas)
   - [1.2. Base de Datos](#12-base-de-datos)
   - [1.3. Instalación y Configuración](#13-instalación-y-configuración)

2. [Decisiones de Diseño del Proyecto](#2-decisiones-de-diseño-del-proyecto)
   - [2.1. Sección Front-store](#21-sección-front-store)
   - [2.2. Sección de Administración](#22-sección-de-administración)


3. [URL de Admin y Front](#3-url-admin-y-front)


## 1. Lanzamiento del Proyecto

Esta sección detalla los requisitos técnicos e instrucciones paso a paso para configurar, construir y ejecutar el proyecto localmente.

### 1.1 Especificaciones Técnicas

El proyecto está desarrollado utilizando las siguientes versiones, definidas en sus respectivos archivos de configuración (`Gemfile` y `package.json`):

* **Lenguaje:** Ruby **3.4.7**
* **Framework:** Rails **8.1.1**
* **Node.js:** **20.19.5**
* **Gestor de Dependencias de Ruby:** Bundler
* **Gestor de Dependencias de JavaScript:** npm

### 1.2 Base de Datos

El proyecto utiliza **SQLite3**, la base de datos predeterminada que viene incluida con Ruby on Rails.
* **Base de Datos en Uso:** Se utiliza la base de datos de entorno de desarrollo (`development`).
* **Instanciación:** No se requiere una instalación o configuración manual de un servicio de base de datos. SQLite3 maneja el archivo de base de datos directamente, instanciándose al ejecutar los comandos de setup.

### 1.3 Instalación y Configuración

Sigue estos pasos para dejar el proyecto operativo:

#### 1.3.1 Obtener el Repositorio

Clona el proyecto y navega al directorio raíz:

```bash
git clone https://github.com/vpablo15/disquera.git
cd disquera
```

#### 1.3.2 Instalar Dependencias de Ruby

Instala todas las gemas especificadas en el Gemfile utilizando Bundler:

```bash
bundle install
```

#### 1.3.3 Instalar Dependencias de JavaScript y Construir Assets

Instala las dependencias del frontend y compila los archivos JavaScript necesarios para el asset pipeline:

```bash
npm install
npm run build
```

#### 1.3.4 Configurar la Base de Datos y Correr Semillas

Crea la base de datos y ejecuta las migraciones para estructurar las tablas. Para cargar datos iniciales (semillas), se recomienda el comando `db:reset`:

```bash
rails db:reset
```

Si solo quieres ejecutar migraciones y crear el esquema (sin borrar datos):

```bash
rails db:migrate
```
Si solo quieres ejecutar las semillas:
```bash
rails db:seed
```

#### 1.3.5 Iniciar el Servidor de Rails

Una vez completados los pasos anteriores, puedes iniciar el servidor web para acceder a la aplicación:

```bash
rails server
```

El proyecto estará accesible en tu navegador, usualmente en `http://localhost:3000`.


# 2 Decisiones de Diseño del Proyecto

Esta sección describe las decisiones de diseño tomadas para la realización del proyecto, dividido principalmente en dos partes **Front-store** y **Administración**.

---

## 2.1 Sección Front-store

La problemática principal fue la estrategia de modelado de atributos de los productos. Se evaluó qué atributos requerían ser extensibles (modelar una entidad) y cuáles podían ser atributos estáticos (utilizar enums).

| Atributo | Decisión | Justificación |
| :--- | :--- | :--- |
| **Artista** | Entidad (Tabla) | Constantemente surgen nuevos artistas y es necesario hacerlo extensible. |
| **Género** | Entidad (Tabla) | Similar a Artista, se considera es un dato que necesita ser extensible. |
| **Tipo de Producto** | Atributo Estático (`Enum`) | Dado que en los requerimientos está acotado se decidió hacerlo estático, sin embargo en un contexto real, sería más adecuado una entidad ya que es altamente probable que un negocio extienda los productos que vende |
| **Condición (Nuevo, Usado)** | Atributo Estático (`Enum`) | Valores que no esperan que cambien. |

---

## 2.2. Sección de Administración

La sección de administración se enfoca en la gestión de los diferentos datos (recursos) del sistema, incluyendo productos, ventas y usuarios.

### 2.2.1. Gestión de Ventas

La cuestión principal fue el modelado de la información del cliente en el contexto de una venta.

| Aspecto | Decisión | Justificación |
| :--- | :--- | :--- |
| **Modelado de Clientes** | Modelado a traves de atributos (DNI, datos de contacto) | Simplifica el proceso desarrollo y permite una futura migración a una entidad de cliente completa si es necesario  (soportado por el atributo único DNI), de igual manera con el atributo DNI puede llevarse a cabo determinados análisis en caso de ser necesario. |
| **Generación de PDFs** | Uso de la gema **prawn** | Presenta utilidades que simplifican el proceso de desarrollo. |

### 2.2.2. Gestión de Usuarios y Roles

En este módulo, la principal cuestión se determinó por el modelado de los roles y permisos, respecto a realizar tablas para permitir extensibilidad o una implementación estática con enums y permisos definidos en un archivo. Dado que los requerimientos no requieren extensibilidad a nivel de roles y permisos, se optó por una solución estática, que proporciona practicidad y agilidad.

#### **Autenticación y Autorización**

| Componente | Decisión | Justificación |
| :--- | :--- | :--- |
| **Roles (Autorización)** | Roles Estáticos (`Enums` y permisos definidos en código) | El problema es de alcance pequeño y no requiere extensión dinámica de roles. Se prioriza la simplicidad y practicidad |
| **Gestión de Sesiones** | Uso de la gema **devise** | Solución estándar para el manejo de usuarios y sesiones |
| **Manejo de Permisos** | Uso de la gema **cancancan** | Gema bastante reconocida y que permite una implementación robusta y ágil |

---

# 3 URL Admin y front
El proyecto estará accesible en el navegador, usualmente en `http://localhost:3000`.
* **Admin**: http://localhost:3000/admin
* **Front**: http://localhost:3000
