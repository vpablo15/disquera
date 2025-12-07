# Decisiones de Diseño del Proyecto

Este sección describe las decisiones de diseño tomadas para la realización del proyecto, dividido principalemnte en las secciones **Front-store** y **Administración**.

---

## 1. Sección Front-store

La problemática principal fue la estrategia de modelado de atributos de los productos. Se evaluó qué atributos requerían ser entidades extensibles (tablas separadas) y cuáles podían ser atributos estáticos (enumeraciones o `enums`).

| Atributo | Decisión | Justificación |
| :--- | :--- | :--- |
| **Artista** | Entidad (Tabla) | Se espera una extensión constante de valores y posible metadata asociada. |
| **Género** | Entidad (Tabla) | Similar a Artista, se considera un dato extensible y potencialmente relacional. |
| **Tipo de Producto** | Atributo Estático (`Enum`) | Dado que en los requerimientos está acotado se decidió hacerlo estático, sin embargo en un contexto real, sería más adecuado una entidad ya que es altamente probable que un negocio extienda los productos que vende |
| **Condición (Nuevo, Usado)** | Atributo Estático (`Enum`) | Valores estables y bien definidos. |

---

## 2. Sección de Administración

La sección de administración se enfoca en la gestión de los diferentos datos (recursos) del sistema, incluyendo productos, ventas y usuarios.

### 2.1. Gestión de Ventas

La cuestión principal fue el modelado de la información del cliente en el contexto de una venta.

| Aspecto | Decisión | Justificación |
| :--- | :--- | :--- |
| **Modelado de Clientes** | Captura de atributos únicos (DNI, datos de contacto) | Simplifica el proceso desarrollo y permite una futura migración a una entidad de cliente completa si es necesario  (gracias al atributo único DNI), de igual manera con el atributo DNI puede llevarse a cabo determinados análisis. |
| **Generación de PDFs** | Uso de la gema **prawn** | Implementación de una herramienta probada para la generación de documentos (facturas, comprobantes) durante el proceso de venta. |

### 2.2. Gestión de Usuarios y Roles

En este módulo, la principal cuestión se determinó por el modelado de los roles y permisos, respecto a realizar tablas para permitir extensibilidad o una implementación estática con enums y permisos definidos en un archivo. Dado que los requerimientos no requieren extensibilidad a nivel de roles y permisos, se optó por una solución estática, que proporciona practicidad y agilidad.

#### **Autenticación y Autorización**

| Componente | Decisión | Justificación |
| :--- | :--- | :--- |
| **Roles (Autorización)** | Roles Estáticos (`Enums` y permisos definidos en código) | El problema es de alcance pequeño y no requiere extensión dinámica de roles. Se prioriza la simplicidad y el rendimiento. |
| **Gestión de Sesiones** | Uso de la gema **devise** | Solución estándar para el manejo de usuarios y sesiones |
| **Manejo de Permisos** | Uso de la gema **cancancan** | Gema bastante reconocida y que permite una implementación robusta y ágil |
