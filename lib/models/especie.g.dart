// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'especie.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EspecieAdapter extends TypeAdapter<Especie> {
  @override
  final int typeId = 0;

  @override
  Especie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Especie(
      id: fields[0] as String,
      tipo: fields[1] as String,
      nombreComun: fields[2] as String,
      nombreCientifico: fields[3] as String,
      infoGeneral: fields[4] as String,
      disclaimer: fields[5] as String,
      imagePath: fields[6] as String,
      especificos: (fields[7] as Map).cast<String, dynamic>(),
      alertas: (fields[8] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Especie obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tipo)
      ..writeByte(2)
      ..write(obj.nombreComun)
      ..writeByte(3)
      ..write(obj.nombreCientifico)
      ..writeByte(4)
      ..write(obj.infoGeneral)
      ..writeByte(5)
      ..write(obj.disclaimer)
      ..writeByte(6)
      ..write(obj.imagePath)
      ..writeByte(7)
      ..write(obj.especificos)
      ..writeByte(8)
      ..write(obj.alertas);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EspecieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
