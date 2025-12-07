# Decisiones de Diseño del Proyecto

Esta sección describe las decisiones de diseño tomadas para la realización del proyecto, dividido principalmente en dos partes **Front-store** y **Administración**.

---

## 1. Sección Front-store

La problemática principal fue la estrategia de modelado de atributos de los productos. Se evaluó qué atributos requerían ser extensibles (modelar una entidad) y cuáles podían ser atributos estáticos (utilizar enums).

| Atributo | Decisión | Justificación |
| :--- | :--- | :--- |
| **Artista** | Entidad (Tabla) | Constantemente surgen nuevos artistas y es necesario hacerlo extensible. |
| **Género** | Entidad (Tabla) | Similar a Artista, se considera es un dato que necesita ser extensible. |
| **Tipo de Producto** | Atributo Estático (`Enum`) | Dado que en los requerimientos está acotado se decidió hacerlo estático, sin embargo en un contexto real, sería más adecuado una entidad ya que es altamente probable que un negocio extienda los productos que vende |
| **Condición (Nuevo, Usado)** | Atributo Estático (`Enum`) | Valores que no esperan que cambien. |

---

## 2. Sección de Administración

La sección de administración se enfoca en la gestión de los diferentos datos (recursos) del sistema, incluyendo productos, ventas y usuarios.

### 2.1. Gestión de Ventas

La cuestión principal fue el modelado de la información del cliente en el contexto de una venta.

| Aspecto | Decisión | Justificación |
| :--- | :--- | :--- |
| **Modelado de Clientes** | Modelado a traves de atributos (DNI, datos de contacto) | Simplifica el proceso desarrollo y permite una futura migración a una entidad de cliente completa si es necesario  (soportado por el atributo único DNI), de igual manera con el atributo DNI puede llevarse a cabo determinados análisis en caso de ser necesario. |
| **Generación de PDFs** | Uso de la gema **prawn** | Presenta utilidades que simplifican el proceso de desarrollo. |

### 2.2. Gestión de Usuarios y Roles

En este módulo, la principal cuestión se determinó por el modelado de los roles y permisos, respecto a realizar tablas para permitir extensibilidad o una implementación estática con enums y permisos definidos en un archivo. Dado que los requerimientos no requieren extensibilidad a nivel de roles y permisos, se optó por una solución estática, que proporciona practicidad y agilidad.

#### **Autenticación y Autorización**

| Componente | Decisión | Justificación |
| :--- | :--- | :--- |
| **Roles (Autorización)** | Roles Estáticos (`Enums` y permisos definidos en código) | El problema es de alcance pequeño y no requiere extensión dinámica de roles. Se prioriza la simplicidad y practicidad |
| **Gestión de Sesiones** | Uso de la gema **devise** | Solución estándar para el manejo de usuarios y sesiones |
| **Manejo de Permisos** | Uso de la gema **cancancan** | Gema bastante reconocida y que permite una implementación robusta y ágil |
