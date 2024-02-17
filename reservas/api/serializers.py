from rest_framework import serializers
from .models import Categoria, Usuario, Sitio
from .models import SitioVisitado, Habitacion, Imagen
from .models import Servicio, Seguridad, Regla
from .models import Comentario, Favorito, Reserva
from .models import PagoAnfitrion, Pago, Multa, Devolucion

# Serializer Categoría


class CategoriaSerializers(serializers.ModelSerializer):
    class Meta:
        model = Categoria
        fields = '__all__'

# Serializer Usuario


class UsuarioSerializers(serializers.ModelSerializer):
    class Meta:
        model = Usuario
        fields = '__all__'

# Serializer Sitio


class SitioSerializers(serializers.ModelSerializer):
    class Meta:
        model = Sitio
        fields = '__all__'

    def to_representation(self, instance):
        # Verificar el método de la solicitud
        if self.context['request'].method == 'GET':
            # Agregar campos adicionales para la solicitud GET
            representation = super().to_representation(instance)
            representation['categoria'] = CategoriaSerializers(
                instance.categoria).data
            return representation
        else:
            # En otros casos, utilizar la representación predeterminada
            return super().to_representation(instance)

# Serializer Sitio Visitado


class SitioVisitadoSerializers(serializers.ModelSerializer):
    class Meta:
        model = SitioVisitado
        fields = '__all__'

# Serializer Habitación


class HabitacionSerializers(serializers.ModelSerializer):
    class Meta:
        model = Habitacion
        fields = '__all__'

# Serializer Imagen


class ImagenSerializers(serializers.ModelSerializer):
    class Meta:
        model = Imagen
        fields = '__all__'

# Serializer Servicio


class ServicioSerializers(serializers.ModelSerializer):
    class Meta:
        model = Servicio
        fields = '__all__'

# Serializer Seguridad


class SeguridadSerializers(serializers.ModelSerializer):
    class Meta:
        model = Seguridad
        fields = '__all__'

# Serializer Regla


class ReglaSerializers(serializers.ModelSerializer):
    class Meta:
        model = Regla
        fields = '__all__'

# Serializer Comentario


class ComentarioSerializers(serializers.ModelSerializer):
    class Meta:
        model = Comentario
        fields = '__all__'

    def to_representation(self, instance):
        # Verificar si 'request' está presente en el contexto
        if 'request' in self.context:
            # Agregar campos adicionales para la solicitud GET
            representation = super().to_representation(instance)
            representation['sitio'] = SitioSerializers(
                instance.sitio, context=self.context).data
            return representation
        else:
            # En caso de que 'request' no esté en el contexto, utiliza representación predeterminada
            return super().to_representation(instance)

# Serializer Favorito


class FavoritoSerializers(serializers.ModelSerializer):
    class Meta:
        model = Favorito
        fields = '__all__'

# Serializer Reserva


class ReservaSerializers(serializers.ModelSerializer):
    class Meta:
        model = Reserva
        fields = '__all__'

    def to_representation(self, instance):
        # Verificar si 'request' está presente en el contexto
        if 'request' in self.context:
            # Agregar campos adicionales para la solicitud GET
            representation = super().to_representation(instance)
            representation['sitio'] = SitioSerializers(
                instance.sitio, context=self.context).data
            return representation
        else:
            # En caso de que 'request' no esté en el contexto, utiliza representación predeterminada
            return super().to_representation(instance)

# Serializer Pago Anfitrión


class PagoAnfitrionSerializers(serializers.ModelSerializer):
    class Meta:
        model = PagoAnfitrion
        fields = '__all__'

    def to_representation(self, instance):
        # Verificar si 'request' está presente en el contexto
        if 'request' in self.context:
            # Agregar campos adicionales para la solicitud GET
            representation = super().to_representation(instance)
            representation['reserva'] = ReservaSerializers(
                instance.reserva, context=self.context).data
            return representation
        else:
            # En caso de que 'request' no esté en el contexto, utiliza representación predeterminada
            return super().to_representation(instance)

# Serializer Pago


class PagoSerializers(serializers.ModelSerializer):
    class Meta:
        model = Pago
        fields = '__all__'

    def to_representation(self, instance):
        # Verificar si 'request' está presente en el contexto
        if 'request' in self.context:
            # Agregar campos adicionales para la solicitud GET
            representation = super().to_representation(instance)
            representation['reserva'] = ReservaSerializers(
                instance.reserva, context=self.context).data
            return representation
        else:
            # En caso de que 'request' no esté en el contexto, utiliza representación predeterminada
            return super().to_representation(instance)

# Serializer Multa


class MultaSerializers(serializers.ModelSerializer):
    class Meta:
        model = Multa
        fields = '__all__'

    def to_representation(self, instance):
        # Verificar si 'request' está presente en el contexto
        if 'request' in self.context:
            # Agregar campos adicionales para la solicitud GET
            representation = super().to_representation(instance)
            representation['reserva'] = ReservaSerializers(
                instance.reserva, context=self.context).data
            return representation
        else:
            # En caso de que 'request' no esté en el contexto, utiliza representación predeterminada
            return super().to_representation(instance)

# Serializer Devolución


class DevolucionSerializers(serializers.ModelSerializer):
    class Meta:
        model = Devolucion
        fields = '__all__'

    def to_representation(self, instance):
        # Verificar si 'request' está presente en el contexto
        if 'request' in self.context:
            # Agregar campos adicionales para la solicitud GET
            representation = super().to_representation(instance)
            representation['reserva'] = ReservaSerializers(
                instance.reserva, context=self.context).data
            return representation
        else:
            # En caso de que 'request' no esté en el contexto, utiliza representación predeterminada
            return super().to_representation(instance)
