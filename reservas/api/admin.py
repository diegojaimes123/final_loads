from django.contrib import admin
from .models import Categoria, Usuario, Sitio
from .models import SitioVisitado, Habitacion, Imagen
from .models import Servicio, Seguridad, Regla
from .models import Comentario, Favorito, Reserva
from .models import PagoAnfitrion, Pago, Multa, Devolucion

# Registro de modelos en el panel de administración de Django

# Register your models here.
# Registro del modelo 'Categoria'
admin.site.register(Categoria)
# Registro del modelo 'Usuario'
admin.site.register(Usuario)
# Registro del modelo 'Sitio'
admin.site.register(Sitio)
# Registro del modelo 'SitioVisitado'
admin.site.register(SitioVisitado)
# Registro del modelo 'Habitacion'
admin.site.register(Habitacion)
# Registro del modelo 'Imagen'
admin.site.register(Imagen)
# Registro del modelo 'Servicio'
admin.site.register(Servicio)
# Registro del modelo 'Seguridad'
admin.site.register(Seguridad)
# Registro del modelo 'Regla'
admin.site.register(Regla)
# Registro del modelo 'Comentario'
admin.site.register(Comentario)
# Registro del modelo 'Favorito'
admin.site.register(Favorito)
# Registro del modelo 'Reserva'
admin.site.register(Reserva)
# Registro del modelo 'PagoAnfitrion'
admin.site.register(PagoAnfitrion)
# Registro del modelo 'Pago'
admin.site.register(Pago)
# Registro del modelo 'Multa'
admin.site.register(Multa)
# Registro del modelo 'Devolucion'
admin.site.register(Devolucion)
