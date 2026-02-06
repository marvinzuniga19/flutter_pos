# POS Nicaragua 🇳🇮

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

Un Sistema de Punto de Venta (POS) moderno y multiplataforma diseñado específicamente para el mercado nicaragüense, con cumplimiento fiscal del DGI.

## 🌟 Características Principales

### 🛍️ Funcionalidades del POS

- **Gestión de Productos**: Catálogo completo con imágenes, categorías y control de stock
- **Gestión de Categorías**: Sistema dinámico para crear, editar y eliminar categorías de productos
- **Procesamiento de Ventas**: Carrito de compras inteligente con cálculo automático
- **Cálculo Automático de IVA**: 15% con categorías exentas configurables
- **Gestión de Clientes**: Base de datos completa con créditos y historial
- **Reportes y Análisis**: Estadísticas de ventas y reportes fiscales
- **Configuración del Sistema**: Ajustes personalizables por empresa

### 🇳🇮 Características para Nicaragua

- **Moneda Local**: Córdoba Nicaragüense (C$) con formato correcto
- **Cumplimiento Fiscal**: Integración con DGI (Dirección General de Ingresos)
- **IVA Automático**: Cálculo del 15% con exenciones (medicinas, alimentos básicos)
- **Localización**: Soporte completo en español (es-NI)
- **Facturación Electrónica**: Numeración secuencial y campos requeridos

### 📱 Multiplataforma

- **Móvil**: Android & iOS
- **Escritorio**: Windows, macOS, Linux
- **Web**: Navegadores modernos
- **Impresión Bluetooth**: Tickets en impresoras térmicas

## 🎨 Características de UI/UX

### Diseño Premium

- **Material 3**: Sistema de diseño moderno y consistente
- **Tipografía Google Fonts**: Outfit para una apariencia profesional
- **Modo Claro/Oscuro**: Tematización completa
- **Diseño Responsivo**: Adaptado para móvil y escritorio
- **Animaciones Fluidas**: Transiciones suaves y micro-interacciones

### Gestión de Productos

- **Selector de Imágenes**: Integración con galería del dispositivo
- **Vista en Cuadrícula**: Visualización atractiva de productos
- **Indicadores de Stock**: Colores visuales para disponibilidad
- **Edición Rápida**: Long-press para acciones de edición/eliminación
- **Búsqueda y Filtros**: Encuentra productos rápidamente

### Gestión de Categorías

- **CRUD Completo**: Crear, editar y eliminar categorías
- **Validación de Duplicados**: Previene nombres repetidos
- **Advertencias Inteligentes**: Notifica cuando categorías están en uso
- **Acceso Rápido**: Botón integrado en formulario de productos

## 🛠️ Stack Tecnológico

### Core Framework

- **Flutter 3.10.7+** - Framework multiplataforma
- **Material 3** - Sistema de diseño moderno
- **Dart 3.0+** - Lenguaje de programación

### Arquitectura y Estado

- **Riverpod 2.x** - Gestión de estado reactiva con code generation
- **riverpod_annotation** - Generación automática de providers
- **flutter_riverpod** - Integración con Flutter

### Base de Datos

- **Drift (SQLite)** - Base de datos local robusta
- **drift_flutter** - Integración Flutter

### Navegación

- **GoRouter** - Navegación declarativa
- **Rutas tipadas** - Type-safe routing

### Modelos y Serialización

- **Freezed** - Modelos inmutables
- **json_serializable** - Serialización JSON

### UI/UX

- **Google Fonts** - Tipografía profesional (Outfit)
- **fl_chart** - Gráficos y visualización de datos
- **image_picker** - Selección de imágenes

### Integraciones

- **blue_thermal_printer** - Impresión Bluetooth
- **pdf** - Generación de PDFs
- **mobile_scanner** - Escaneo de códigos QR/barras
- **firebase_core** - Sincronización en la nube

### Desarrollo

- **build_runner** - Generación de código
- **riverpod_generator** - Generación de providers
- **drift_dev** - Generación de código de base de datos

## 🚀 Instalación

### Prerrequisitos

- Flutter SDK 3.10.7 o superior
- Dart SDK 3.0 o superior
- Android Studio / VS Code con extensiones Flutter
- Para móvil: Android SDK / Xcode
- Para escritorio: Herramientas de compilación específicas

### Configuración del Proyecto

```bash
# Clonar el repositorio
git clone <repository-url>
cd pos

# Instalar dependencias
flutter pub get

# Generar código (providers, modelos, base de datos)
dart run build_runner build --delete-conflicting-outputs

# Ejecutar en desarrollo
flutter run -d linux  # Para Linux
flutter run           # Para dispositivo conectado
```

### Compilación para Producción

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Windows
flutter build windows --release

# Linux
flutter build linux --release

# macOS
flutter build macos --release

# Web
flutter build web --release
```

## 📖 Uso

### 1. Pantalla Principal

Al iniciar, verás el menú principal con 6 módulos disponibles:

- **Ventas**: Procesamiento de transacciones con carrito inteligente
- **Productos**: Gestión completa del catálogo con imágenes
- **Clientes**: Base de datos de clientes con créditos
- **Inventario**: Control de stock y movimientos
- **Reportes**: Estadísticas y análisis de ventas
- **Configuración**: Ajustes del sistema y empresa

### 2. Gestión de Productos

1. **Crear Producto**:
   - Tap en botón "Nuevo Producto"
   - Selecciona imagen de galería
   - Completa información (nombre, precio, categoría, stock)
   - Configura IVA si aplica
   - Guarda el producto

2. **Editar Producto**:
   - Long-press en tarjeta de producto
   - Selecciona "Editar"
   - Modifica información
   - Guarda cambios

3. **Eliminar Producto**:
   - Long-press en tarjeta de producto
   - Selecciona "Eliminar"
   - Confirma eliminación

### 3. Gestión de Categorías

1. **Acceder a Categorías**:
   - Desde formulario de producto
   - Tap en ícono ⚙️ junto a dropdown de categorías

2. **Crear Categoría**:
   - Tap en "Nueva Categoría"
   - Ingresa nombre
   - Sistema valida duplicados automáticamente

3. **Editar/Eliminar**:
   - Usa íconos en cada categoría
   - Sistema advierte si categoría está en uso

### 4. Procesamiento de Ventas

1. Selecciona productos del catálogo (tap en producto)
2. Revisa carrito con cálculos automáticos de IVA
3. Selecciona/modifica cliente (opcional)
4. Procesa pago
5. Genera factura/ticket

## 🏗️ Estructura del Proyecto

```
lib/
├── core/
│   ├── constants/              # Constantes de la aplicación
│   │   ├── app_constants.dart
│   │   ├── cart_constants.dart
│   │   ├── currency_constants.dart
│   │   ├── fiscal_constants.dart
│   │   ├── product_constants.dart
│   │   └── user_role_constants.dart
│   └── theme/                  # Tematización
│       └── app_theme.dart      # Tema premium Material 3
├── presentation/               # Pantallas UI
│   ├── main_layout.dart        # Navegación principal
│   ├── sales_screen.dart       # Pantalla de ventas con carrito
│   ├── products_screen.dart    # Catálogo de productos
│   ├── product_form_screen.dart # Formulario de productos
│   ├── category_management_screen.dart # Gestión de categorías
│   ├── customer_detail_screen.dart # Detalle de cliente
│   └── widgets/                # Widgets reutilizables
│       ├── customer_selection_modal.dart
│       └── cart_item_card.dart
└── shared/
    ├── models/                 # Modelos de datos
    │   ├── product_model.dart
    │   ├── category_model.dart
    │   ├── customer_model.dart
    │   ├── cart_item_model.dart
    │   └── customer_credit_model.dart
    └── providers/              # Riverpod providers
        ├── product_provider.dart
        ├── category_provider.dart
        ├── cart_provider.dart
        ├── customer_provider.dart
        └── customer_credit_provider.dart
```

## 📊 Estado del Desarrollo

### ✅ Completado

- [x] Arquitectura y configuración del proyecto
- [x] Navegación principal con 6 módulos
- [x] Sistema de tematización premium con Material 3
- [x] Gestión completa de productos con imágenes
- [x] Gestión dinámica de categorías (CRUD)
- [x] Carrito de compras con cálculo de IVA
- [x] Selección de clientes en ventas
- [x] Gestión de clientes con créditos
- [x] Providers con Riverpod y code generation
- [x] Formato de moneda nicaragüense (C$)
- [x] Sistema de permisos basado en roles
- [x] Soporte multiplataforma (Linux, Android, iOS, etc.)

### 🚧 En Desarrollo

- [ ] Procesamiento completo de pagos
- [ ] Impresión de tickets/facturas
- [ ] Esquema completo de base de datos con Drift

### 📋 Planeado

- [ ] Control de inventario con movimientos
- [ ] Reportes de ventas y análisis con gráficos
- [ ] Impresión Bluetooth en impresoras térmicas
- [ ] Sincronización con Firebase
- [ ] Autenticación de usuarios
- [ ] Exportación/importación de datos
- [ ] Modo offline completo
- [ ] Backup automático

## 👥 Roles de Usuario

### Administrador

- Acceso completo al sistema
- Configuración global
- Gestión de usuarios
- Reportes avanzados

### Gerente

- Ventas e inventario
- Reportes y análisis
- Gestión de clientes
- Configuración de productos

### Cajero

- Procesamiento de ventas
- Gestión básica de clientes
- Consulta de productos

### Inventario

- Gestión de productos y categorías
- Control de stock
- Movimientos de inventario

## 🧾 Cumplimiento Fiscal

### Requisitos DGI Nicaragua

- **IVA**: 15% general con categorías exentas
- **Numeración**: Facturación secuencial obligatoria
- **Campos Requeridos**: NIT, nombre del cliente, detalles del producto
- **Respaldo**: Almacenamiento mínimo 5 años
- **Exenciones**: Medicinas, alimentos básicos, servicios educativos

### Categorías Exentas de IVA

- Medicamentos y productos farmacéuticos
- Alimentos básicos no procesados (leche, huevos, etc.)
- Libros y material educativo
- Servicios médicos y de salud

## 🔧 Configuración

### Configuración Regional

```dart
// Moneda: Córdoba Nicaragüense (C$)
// Locale: es_NI
// Formato de número: 1,234.56
// Símbolo: C$ antes del monto
```

### Configuración Fiscal

```dart
// IVA General: 15%
// Factura inicial: 0010010001
// Formato de fecha: DD/MM/YYYY
// Campos obligatorios: NIT, Nombre, Dirección
```

### Generación de Código

```bash
# Generar providers y modelos
dart run build_runner build --delete-conflicting-outputs

# Watch mode para desarrollo
dart run build_runner watch --delete-conflicting-outputs
```

## 🤝 Cómo Contribuir

1. **Fork** el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. **Push** a la rama (`git push origin feature/AmazingFeature`)
5. Abre un **Pull Request**

### Guías de Estilo

- Seguir las convenciones de Dart/Flutter
- Usar Riverpod con code generation para gestión de estado
- Documentar código nuevo con comentarios claros
- Escribir pruebas unitarias cuando sea posible
- Mantener consistencia con el tema Material 3

## 📝 Licencia

Este proyecto está licenciado bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 📞 Contacto

- **Proyecto**: POS Nicaragua
- **Email**: [tu-email@ejemplo.com]
- **Issues**: [GitHub Issues](https://github.com/tu-usuario/pos/issues)

## 🙏 Agradecimientos

- Equipo de Flutter por el excelente framework
- Comunidad Dart/Riverpod por las herramientas increíbles
- Remi Rousselet por Riverpod
- DGI Nicaragua por las especificaciones fiscales

---

**POS Nicaragua** - El sistema de punto de venta moderno para tu negocio nicaragüense 🇳🇮

_Hecho con ❤️ en Nicaragua_
