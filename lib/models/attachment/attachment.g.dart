// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttachmentImpl _$$AttachmentImplFromJson(Map<String, dynamic> json) =>
    _$AttachmentImpl(
      originalName: json['originalName'] as String?,
      fileName: json['fileName'] as String?,
      location: json['location'] as String,
    );

Map<String, dynamic> _$$AttachmentImplToJson(_$AttachmentImpl instance) =>
    <String, dynamic>{
      'originalName': instance.originalName,
      'fileName': instance.fileName,
      'location': instance.location,
    };
