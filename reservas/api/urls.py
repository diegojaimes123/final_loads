from django.urls import path, include
from rest_framework import routers
from api import views

# Definición de routers para cada modelo en la API

# Router para el modelo 'Categoria'


routerCategoria = routers.DefaultRouter()
routerCategoria.register(r'Categorias', views.CategoriaViewSet)

# Router para el modelo 'Usuario'


routerUsuario = routers.DefaultRouter()
routerUsuario.register(r'Usuarios', views.UsuarioViewSet)

# Router para el modelo 'Sitio'


routerSitio = routers.DefaultRouter()
routerSitio.register(r'Sitios', views.SitioViewSet)

# Router para el modelo 'SitioVisitado'


routerSitioVisitado = routers.DefaultRouter()
routerSitioVisitado.register(r'SitioVisitado', views.SitioVisitadoViewSet)

# Router para el modelo 'Habitacion'


routerHabitacion = routers.DefaultRouter()
routerHabitacion.register(r'Habitacion', views.HabitacionViewSet)

# Router para el modelo 'Imagen'


routerImagen = routers.DefaultRouter()
routerImagen.register(r'Imagen', views.ImagenViewSet)

# Router para el modelo 'Servicio'


routerServicio = routers.DefaultRouter()
routerServicio.register(r'Servicios', views.ServicioViewSet)

# Router para el modelo 'Seguridad'


routerSeguridad = routers.DefaultRouter()
routerSeguridad.register(r'Seguridad', views.SeguridadViewSet)

# Router para el modelo 'Regla'


routerRegla = routers.DefaultRouter()
routerRegla.register(r'Reglas', views.ReglaViewSet)

# Router para el modelo 'Comentario'


routerComentario = routers.DefaultRouter()
routerComentario.register(r'Comentarios', views.ComentarioViewSet)

# Router para el modelo 'Favorito'


routerFavorito = routers.DefaultRouter()
routerFavorito.register(r'Favoritos', views.FavoritoViewSet)

# Router para el modelo 'Reserva'


routerReserva = routers.DefaultRouter()
routerReserva.register(r'Reservas', views.ReservaViewSet)

# Router para el modelo 'PagoAnfitrion'


routerPagoAnfitrion = routers.DefaultRouter()
routerPagoAnfitrion.register(r'PagoAnfitrion', views.PagoAnfitrionViewSet)

# Router para el modelo 'Pago'


routerPago = routers.DefaultRouter()
routerPago.register(r'Pagos', views.PagoViewSet)

# Router para el modelo 'Multa'


routerMulta = routers.DefaultRouter()
routerMulta.register(r'Multas', views.MultaViewSet)

# Router para el modelo 'Devolucion'


routerDevolucion = routers.DefaultRouter()
routerDevolucion.register(r'Devolucion', views.DevolucionViewSet)

# Definición de las URL de la API, incluyendo los routers de cada modelo

urlpatterns = [
    path('', include(routerCategoria.urls)),
    path('', include(routerUsuario.urls)),
    path('', include(routerSitio.urls)),
    path('', include(routerSitioVisitado.urls)),
    path('', include(routerHabitacion.urls)),
    path('', include(routerImagen.urls)),
    path('', include(routerServicio.urls)),
    path('', include(routerSeguridad.urls)),
    path('', include(routerRegla.urls)),
    path('', include(routerComentario.urls)),
    path('', include(routerFavorito.urls)),
    path('', include(routerReserva.urls)),
    path('', include(routerPagoAnfitrion.urls)),
    path('', include(routerPago.urls)),
    path('', include(routerMulta.urls)),
    path('', include(routerDevolucion.urls)),
]
