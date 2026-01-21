# Mitos y Leyendas App

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Riverpod](https://img.shields.io/badge/Riverpod-State%20Management-green)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

Aplicación móvil desarrollada en **Flutter** para explorar cartas del juego  
**Mitos y Leyendas**, formato **Imperio**.

Permite búsqueda en tiempo real, filtrado por edición y visualización
detallada de cada carta con animaciones.

## 🎯 Objetivo del proyecto

Este proyecto tiene fines educativos y de portafolio, enfocado en:

- Aplicar Clean Architecture en Flutter
- Gestión de estado avanzada con Riverpod
- Buenas prácticas de UI y UX

---

## ✨ Características

- 🔍 Búsqueda de cartas en tiempo real
- 🃏 Filtrado por edición
- 📄 Vista detallada de cada carta
- 🎞 Animaciones con Hero
- ⚡ Estado reactivo con Riverpod

---

## 📸 Capturas

### Búsqueda de cartas

![Search](screenshots/search.jpeg)

### Detalle de carta

![Detail](screenshots/detail.jpeg)

---

## 🛠 Tecnologías

- Flutter
- Riverpod
- Dio (HTTP client)
- Clean Architecture
- Material 3

---

## 🧱 Arquitectura

El proyecto sigue **Clean Architecture**, separando responsabilidades
en capas bien definidas:

- **Presentation**  
  Widgets, UI y providers (Riverpod)

- **Domain**  
  Entidades y contratos de repositorio

- **Infrastructure / Data**  
  Datasources, implementaciones de repositorios y servicios HTTP

👉 El estado se gestiona **exclusivamente con Riverpod**.

---

## 🚀 Instalación

1. Clona el repositorio:

   ```bash
   git clone https://github.com/BastianDevs/mitos_y_leyendas_app.git
   ```

2. Instala dependencias:

   ```bash
   flutter pub get
   ```

3. Ejecuta la app

   ```bash
   flutter run
   ```

---

## 🚧 Estado del proyecto

El proyecto se encuentra en desarrollo activo.
Nuevas funcionalidades y mejoras están en progreso.

✅ Versión funcional con mejoras planificadas

## 🗺️ Roadmap

### ✅ Completado

- [x] Arquitectura limpia con Riverpod
- [x] Listado de cartas por edición
- [x] Búsqueda de cartas con SearchAnchor
- [x] Filtro reactivo mediante providers
- [x] Vista de detalle de carta con dialog animado

### 🚧 En progreso

- [ ] Optimización de carga de imágenes
- [ ] Manejo de estados de error y empty states
- [ ] Animaciones Hero mejoradas

### 🔜 Planificado

- [ ] Favoritos de cartas
- [ ] Filtros avanzados (tipo, coste, rareza)
- [ ] Cache local (offline)
- [ ] Tests unitarios de providers
- [ ] Modo oscuro completo

## 📄 Licencia

Este proyecto está bajo la licencia MIT.  
Consulta el archivo [LICENSE](LICENSE) para más detalles.
