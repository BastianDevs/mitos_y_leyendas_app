# Mitos y Leyendas App

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Riverpod](https://img.shields.io/badge/Riverpod-State%20Management-green)

Aplicación móvil desarrollada en Flutter para explorar cartas del juego
_Mitos y Leyendas_, del formato _Imperio_, permitiendo búsqueda, filtrado por edición y
visualización detallada de cada carta.

## ✨ Características

- 🔍 Búsqueda de cartas en tiempo real
- 🃏 Filtrado por edición
- 📄 Vista detallada de cada carta
- 🎞 Animaciones con Hero
- 🌙 Soporte para tema claro / oscuro

## 🛠 Tecnologías

- Flutter
- Riverpod
- Dio (HTTP client)
- Clean Architecture
- Material 3

## 🧱 Arquitectura

El proyecto sigue una arquitectura limpia, separando responsabilidades
en capas:

- **Presentation**: Widgets, UI y providers
- **Domain**: Entidades y repositorios abstractos
- **Infrastructure / Data**: Datasources, repositorios y servicios HTTP

El estado se gestiona exclusivamente con **Riverpod**.

## 🚀 Instalación

1. Clona el repositorio:

   ```bash
   git clone https://github.com/BastianDevs/mitos_y_leyendas_app.git

   ```

2. Instala dependencias:

flutter pub get

3. Ejecuta la app

flutter run

---

### 7️⃣ Capturas de pantalla (opcional pero MUY recomendable)

Esto hace que el proyecto se vea **10x más profesional**.

```md
## 📸 Capturas

![Home](screenshots/home.png)
![Search](screenshots/search.png)
![Detail](screenshots/detail.png)

## 🚧 Estado del proyecto

El proyecto se encuentra en desarrollo activo.
Nuevas funcionalidades y mejoras están en progreso.

✅ Versión funcional con mejoras planificadas

## 🗺 Roadmap

- [ ] Filtros avanzados
- [ ] Favoritos
- [ ] Cache local
- [ ] Tests unitarios

## 📄 Licencia

Este proyecto se distribuye bajo la licencia MIT.
```
