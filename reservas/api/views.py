from django.shortcuts import render
from rest_framework import viewsets
from .models import Categoria, Usuario, Sitio
from .models import SitioVisitado, Habitacion, Imagen
from .models import Servicio, Seguridad, Regla
from .models import Comentario, Favorito, Reserva
from .models import PagoAnfitrion, Pago, Multa, Devolucion
from .serializers import CategoriaSerializers, UsuarioSerializers, SitioSerializers
from .serializers import SitioVisitadoSerializers, HabitacionSerializers, ImagenSerializers
from .serializers import ServicioSerializers, SeguridadSerializers, ReglaSerializers
from .serializers import ComentarioSerializers, FavoritoSerializers, ReservaSerializers
from .serializers import PagoAnfitrionSerializers, PagoSerializers, MultaSerializers, DevolucionSerializers

# Create your views here.

# Vista de categoría


class CategoriaViewSet(viewsets.ModelViewSet):
    queryset = Categoria.objects.all()
    serializer_class = CategoriaSerializers

# Vista de usuario


class UsuarioViewSet(viewsets.ModelViewSet):
    queryset = Usuario.objects.all()
    serializer_class = UsuarioSerializers

# Vista de sitio


class SitioViewSet(viewsets.ModelViewSet):
    queryset = Sitio.objects.all()
    serializer_class = SitioSerializers

# Vista de sitio visitado


class SitioVisitadoViewSet(viewsets.ModelViewSet):
    queryset = SitioVisitado.objects.all()
    serializer_class = SitioVisitadoSerializers

# Vista de habitación


class HabitacionViewSet(viewsets.ModelViewSet):
    queryset = Habitacion.objects.all()
    serializer_class = HabitacionSerializers

# Vista de imagen


class ImagenViewSet(viewsets.ModelViewSet):
    queryset = Imagen.objects.all()
    serializer_class = ImagenSerializers

# Vista de servicio


class ServicioViewSet(viewsets.ModelViewSet):
    queryset = Servicio.objects.all()
    serializer_class = ServicioSerializers

# Vista de seguridad


class SeguridadViewSet(viewsets.ModelViewSet):
    queryset = Seguridad.objects.all()
    serializer_class = SeguridadSerializers

# Vista de regla


class ReglaViewSet(viewsets.ModelViewSet):
    queryset = Regla.objects.all()
    serializer_class = ReglaSerializers

# Vista de comentario


class ComentarioViewSet(viewsets.ModelViewSet):
    queryset = Comentario.objects.all()
    serializer_class = ComentarioSerializers

# Vista de favorito


class FavoritoViewSet(viewsets.ModelViewSet):
    queryset = Favorito.objects.all()
    serializer_class = FavoritoSerializers

# Vista de reserva


class ReservaViewSet(viewsets.ModelViewSet):
    queryset = Reserva.objects.all()
    serializer_class = ReservaSerializers

# Vista de pago anfitrión


class PagoAnfitrionViewSet(viewsets.ModelViewSet):
    queryset = PagoAnfitrion.objects.all()
    serializer_class = PagoAnfitrionSerializers

# Vista de pago


class PagoViewSet(viewsets.ModelViewSet):
    queryset = Pago.objects.all()
    serializer_class = PagoSerializers

# Vista de multa


class MultaViewSet(viewsets.ModelViewSet):
    queryset = Multa.objects.all()
    serializer_class = MultaSerializers

# Vista de devolución


class DevolucionViewSet(viewsets.ModelViewSet):
    queryset = Devolucion.objects.all()
    serializer_class = DevolucionSerializers
