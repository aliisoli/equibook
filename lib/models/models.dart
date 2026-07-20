import 'enums.dart';

export 'enums.dart';

class AppUser {
  AppUser({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.role,
    this.phone = '',
    this.photoPath,
  });

  final String id;
  final String email;
  final String password;
  final String name;
  final UserRole role;
  final String phone;
  final String? photoPath;

  AppUser copyWith({
    String? name,
    String? phone,
    String? photoPath,
  }) {
    return AppUser(
      id: id,
      email: email,
      password: password,
      name: name ?? this.name,
      role: role,
      phone: phone ?? this.phone,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'password': password,
    'name': name,
    'role': role.name,
    'phone': phone,
    'photoPath': photoPath,
  };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
    name: json['name'] as String,
    role: UserRole.values.byName(json['role'] as String),
    phone: (json['phone'] as String?) ?? '',
    photoPath: json['photoPath'] as String?,
  );
}

class Horse {
  Horse({
    required this.id,
    required this.ownerId,
    required this.name,
    this.breed = '',
    this.notes = '',
    this.photoPath,
    this.ownershipDocPath,
    this.ownershipDocName,
  });

  final String id;
  final String ownerId;
  final String name;
  final String breed;
  final String notes;
  final String? photoPath;
  final String? ownershipDocPath;
  final String? ownershipDocName;

  Horse copyWith({
    String? name,
    String? breed,
    String? notes,
    String? photoPath,
    String? ownershipDocPath,
    String? ownershipDocName,
  }) {
    return Horse(
      id: id,
      ownerId: ownerId,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      notes: notes ?? this.notes,
      photoPath: photoPath ?? this.photoPath,
      ownershipDocPath: ownershipDocPath ?? this.ownershipDocPath,
      ownershipDocName: ownershipDocName ?? this.ownershipDocName,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ownerId': ownerId,
    'name': name,
    'breed': breed,
    'notes': notes,
    'photoPath': photoPath,
    'ownershipDocPath': ownershipDocPath,
    'ownershipDocName': ownershipDocName,
  };

  factory Horse.fromJson(Map<String, dynamic> json) => Horse(
    id: json['id'] as String,
    ownerId: json['ownerId'] as String,
    name: json['name'] as String,
    breed: (json['breed'] as String?) ?? '',
    notes: (json['notes'] as String?) ?? '',
    photoPath: json['photoPath'] as String?,
    ownershipDocPath: json['ownershipDocPath'] as String?,
    ownershipDocName: json['ownershipDocName'] as String?,
  );
}

class VetProfile {
  VetProfile({
    required this.userId,
    this.bio = '',
    this.serviceArea = '',
    this.credentials = '',
    this.category = ServiceCategory.veterinary,
  });

  final String userId;
  final String bio;
  final String serviceArea;
  final String credentials;
  final ServiceCategory category;

  VetProfile copyWith({
    String? bio,
    String? serviceArea,
    String? credentials,
    ServiceCategory? category,
  }) {
    return VetProfile(
      userId: userId,
      bio: bio ?? this.bio,
      serviceArea: serviceArea ?? this.serviceArea,
      credentials: credentials ?? this.credentials,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'bio': bio,
    'serviceArea': serviceArea,
    'credentials': credentials,
    'category': category.name,
  };

  factory VetProfile.fromJson(Map<String, dynamic> json) => VetProfile(
    userId: json['userId'] as String,
    bio: (json['bio'] as String?) ?? '',
    serviceArea: (json['serviceArea'] as String?) ?? '',
    credentials: (json['credentials'] as String?) ?? '',
    category: _categoryFrom(json['category'] as String?),
  );
}

class ServiceOffering {
  ServiceOffering({
    required this.id,
    required this.vetId,
    required this.title,
    required this.rate,
    this.description = '',
    this.durationMinutes = 60,
    this.category = ServiceCategory.veterinary,
  });

  final String id;
  final String vetId;
  final String title;
  final String description;
  final double rate;
  final int durationMinutes;
  final ServiceCategory category;

  ServiceOffering copyWith({
    String? title,
    String? description,
    double? rate,
    int? durationMinutes,
    ServiceCategory? category,
  }) {
    return ServiceOffering(
      id: id,
      vetId: vetId,
      title: title ?? this.title,
      description: description ?? this.description,
      rate: rate ?? this.rate,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'vetId': vetId,
    'title': title,
    'description': description,
    'rate': rate,
    'durationMinutes': durationMinutes,
    'category': category.name,
  };

  factory ServiceOffering.fromJson(Map<String, dynamic> json) =>
      ServiceOffering(
        id: json['id'] as String,
        vetId: json['vetId'] as String,
        title: json['title'] as String,
        description: (json['description'] as String?) ?? '',
        rate: (json['rate'] as num).toDouble(),
        durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 60,
        category: _categoryFrom(json['category'] as String?),
      );
}

ServiceCategory _categoryFrom(String? name) {
  if (name == null) return ServiceCategory.veterinary;
  return ServiceCategory.values.firstWhere(
    (c) => c.name == name,
    orElse: () => ServiceCategory.veterinary,
  );
}

class AvailabilitySlot {
  AvailabilitySlot({
    required this.id,
    required this.vetId,
    required this.start,
    required this.end,
  });

  final String id;
  final String vetId;
  final DateTime start;
  final DateTime end;

  Map<String, dynamic> toJson() => {
    'id': id,
    'vetId': vetId,
    'start': start.toIso8601String(),
    'end': end.toIso8601String(),
  };

  factory AvailabilitySlot.fromJson(Map<String, dynamic> json) =>
      AvailabilitySlot(
        id: json['id'] as String,
        vetId: json['vetId'] as String,
        start: DateTime.parse(json['start'] as String),
        end: DateTime.parse(json['end'] as String),
      );
}

class Booking {
  Booking({
    required this.id,
    required this.ownerId,
    required this.vetId,
    required this.horseId,
    required this.serviceId,
    required this.slotId,
    required this.start,
    required this.end,
    required this.quotedRate,
    required this.status,
    required this.createdAt,
    this.notes = '',
    this.rateConfirmedByOwner = false,
  });

  final String id;
  final String ownerId;
  final String vetId;
  final String horseId;
  final String serviceId;
  final String slotId;
  final DateTime start;
  final DateTime end;
  final double quotedRate;
  final BookingStatus status;
  final DateTime createdAt;
  final String notes;
  final bool rateConfirmedByOwner;

  Booking copyWith({
    BookingStatus? status,
    String? notes,
    bool? rateConfirmedByOwner,
  }) {
    return Booking(
      id: id,
      ownerId: ownerId,
      vetId: vetId,
      horseId: horseId,
      serviceId: serviceId,
      slotId: slotId,
      start: start,
      end: end,
      quotedRate: quotedRate,
      status: status ?? this.status,
      createdAt: createdAt,
      notes: notes ?? this.notes,
      rateConfirmedByOwner: rateConfirmedByOwner ?? this.rateConfirmedByOwner,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ownerId': ownerId,
    'vetId': vetId,
    'horseId': horseId,
    'serviceId': serviceId,
    'slotId': slotId,
    'start': start.toIso8601String(),
    'end': end.toIso8601String(),
    'quotedRate': quotedRate,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'notes': notes,
    'rateConfirmedByOwner': rateConfirmedByOwner,
  };

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'] as String,
    ownerId: json['ownerId'] as String,
    vetId: json['vetId'] as String,
    horseId: json['horseId'] as String,
    serviceId: json['serviceId'] as String,
    slotId: json['slotId'] as String,
    start: DateTime.parse(json['start'] as String),
    end: DateTime.parse(json['end'] as String),
    quotedRate: (json['quotedRate'] as num).toDouble(),
    status: BookingStatus.values.byName(json['status'] as String),
    createdAt: DateTime.parse(json['createdAt'] as String),
    notes: (json['notes'] as String?) ?? '',
    rateConfirmedByOwner: (json['rateConfirmedByOwner'] as bool?) ?? false,
  );
}

class HorseReminder {
  HorseReminder({
    required this.id,
    required this.ownerId,
    required this.horseId,
    required this.title,
    required this.dueDate,
    this.kind = ReminderKind.other,
    this.done = false,
  });

  final String id;
  final String ownerId;
  final String horseId;
  final String title;
  final DateTime dueDate;
  final ReminderKind kind;
  final bool done;

  HorseReminder copyWith({
    String? title,
    DateTime? dueDate,
    ReminderKind? kind,
    bool? done,
  }) {
    return HorseReminder(
      id: id,
      ownerId: ownerId,
      horseId: horseId,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      kind: kind ?? this.kind,
      done: done ?? this.done,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ownerId': ownerId,
    'horseId': horseId,
    'title': title,
    'dueDate': dueDate.toIso8601String(),
    'kind': kind.name,
    'done': done,
  };

  factory HorseReminder.fromJson(Map<String, dynamic> json) => HorseReminder(
    id: json['id'] as String,
    ownerId: json['ownerId'] as String,
    horseId: json['horseId'] as String,
    title: json['title'] as String,
    dueDate: DateTime.parse(json['dueDate'] as String),
    kind: ReminderKind.values.firstWhere(
      (k) => k.name == json['kind'],
      orElse: () => ReminderKind.other,
    ),
    done: (json['done'] as bool?) ?? false,
  );
}
