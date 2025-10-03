// lib/services/notification_service.dart

// Este archivo **reexporta** la implementación correcta
// según si estamos en web (dart.library.html) o no.
export 'notification_service_mobile.dart'
    if (dart.library.html) 'notification_service_web.dart';
