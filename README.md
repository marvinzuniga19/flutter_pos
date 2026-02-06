# POS Nicaragua 🇳🇮

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

Un Sistema de Punto de Venta (POS) moderno y multiplataforma diseñado específicamente para el mercado nicaragüense, con cumplimiento fiscal del DGI.

## 🌟 Características Principales

### 🛍️ Funcionalidades del POS
- **Catálogo de Productos**: Gestión de inventario con cuadrícula visual
- **Procesamiento de Ventas**: Carrito de compras y proceso de checkout
- **Cálculo Automático de IVA**: 15% con categorías exentas
- **Gestión de Clientes**: Base de datos de clientes
- **Reportes y Análisis**: Estadísticas de ventas y reportes fiscales
- **Configuración del Sistema**: Ajustes personalizables

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

## 🎨 Vista Previa

> *Nota: Las capturas de pantalla se agregarán cuando las pantallas principales estén completas*

## 🛠️ Stack Tecnológico

### Core Framework
- **Flutter 3.10.7+** - Framework multiplataforma
- **Material 3** - Sistema de diseño moderno

### Arquitectura
- **Riverpod** - Gestión de estado reactiva
- **Drift (SQLite)** - Base de datos local robusta
- **GoRouter** - Navegación declarativa
- **Freezed** - Modelos inmutables

### UI/UX
- **Google Fonts** - Tipografía profesional (Outfit & Inter)
- **fl_chart** - Gráficos y visualización de datos
- **Tema Personalizado** - Modo claro/oscuro

### Integraciones
- **blue_thermal_printer** - Impresión Bluetooth
- **pdf** - Generación de PDFs
- **mobile_scanner** - Escaneo de códigos QR/barras
- **firebase_core** - Sincronización en la nube

## 🚀 Instalación

### Prerrequisitos
- Flutter SDK 3.10.7 o superior
- Dart SDK compatible
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

# Generar código (modelos, estado, etc.)
flutter packages pub run build_runner build

# Ejecutar en desarrollo
flutter run
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

- **Ventas**: Procesamiento de transacciones
- **Productos**: Gestión del catálogo
- **Clientes**: Base de datos de clientes
- **Inventario**: Control de stock
- **Reportes**: Estadísticas y análisis
- **Configuración**: Ajustes del sistema

### 2. Procesamiento de Ventas
1. Escanea o selecciona productos del catálogo
2. Revisa el carrito con cálculos automáticos de IVA
3. Selecciona método de pago
4. Imprime ticket de venta
5. Genera factura fiscal (si aplica)

### 3. Gestión de Productos
- Agregar nuevos productos con información fiscal
- Actualizar precios y existencias
- Categorizar productos para IVA
- Importar/exportar catálogo

## 🏗️ Estructura del Proyecto

```
lib/
├── core/
│   ├── constants/          # Constantes de la aplicación
│   │   ├── app_constants.dart
│   │   ├── currency_constants.dart
│   │   ├── fiscal_constants.dart
│   │   └── user_role_constants.dart
│   └── theme/             # Tematización de la app
│       └── app_theme.dart
├── presentation/          # Pantallas UI
│   ├── main_layout.dart   # Navegación principal
│   └── products_screen.dart # Catálogo de productos
└── shared/
    └── models/            # Modelos de datos
        └── product_model.dart
```

## 📊 Estado del Desarrollo

### ✅ Completado
- [x] Arquitectura y configuración del proyecto
- [x] Navegación principal con 6 módulos
- [x] Catálogo de productos con visualización en cuadrícula
- [x] Cálculo de IVA y formato de moneda
- [x] Sistema de permisos basado en roles
- [x] Tematización profesional con Material 3
- [x] Soporte multiplataforma

### 🚧 En Desarrollo
- [ ] Funcionalidad del carrito de compras
- [ ] Procesamiento completo de ventas
- [ ] Esquema de base de datos y servicios

### 📋 Planeado
- [ ] Gestión de clientes
- [ ] Control de inventario
- [ ] Reportes de ventas y análisis
- [ ] Impresión de tickets Bluetooth
- [ ] Sincronización con Firebase
- [ ] Autenticación de usuarios
- [ ] Exportación/importación de datos

## 👥 Roles de Usuario

### Administrador
- Acceso completo al sistema
- Configuración global
- Gestión de usuarios

### Gerente
- Ventas e inventario
- Reportes y análisis
- Gestión de clientes

### Cajero
- Procesamiento de ventas
- Gestión básica de clientes

### Inventario
- Gestión de productos
- Control de stock

## 🧾 Cumplimiento Fiscal

### Requisitos DGI Nicaragua
- **IVA**: 15% general con categorías exentas
- **Numeración**: Facturación secuencial obligatoria
- **Campos Requeridos**: NIT, nombre del cliente, detalles del producto
- **Respaldo**: Almacenamiento mínimo 5 años
- **Exenciones**: Medicinas, alimentos básicos, servicios educativos

### Categorías Exentas de IVA
- Medicamentos y productos farmacéuticos
- Alimentos básicos no procesados
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

## 🤝 Cómo Contribuir

1. **Fork** el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. **Push** a la rama (`git push origin feature/AmazingFeature`)
5. Abre un **Pull Request**

### Guías de Estilo
- Seguir las convenciones de Dart/Flutter
- Usar Riverpod para gestión de estado
- Documentar código nuevo
- Escribir pruebas unitarias cuando sea posible

## 📝 Licencia

Este proyecto está licenciado bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 📞 Contacto

- **Proyecto**: POS Nicaragua
- **Email**: [tu-email@ejemplo.com]
- **Issues**: [GitHub Issues](https://github.com/tu-usuario/pos/issues)

## 🙏 Agradecimientos

- Equipo de Flutter por el excelente framework
- Comunidad Dart/Riverpod por las herramientas increíbles
- DGI Nicaragua por las especificaciones fiscales

---

**POS Nicaragua** - El sistema de punto de venta moderno para tu negocio nicaragüense 🇳🇮

*Hecho con ❤️ en Nicaragua*
