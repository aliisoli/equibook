import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';

class AppStore extends ChangeNotifier {
  AppStore();

  static const _uuid = Uuid();
  static const _storageKey = 'equibook_local_v1';
  static const _demoVetEmail = 'vet@equibook.demo';
  static const _demoFarrierEmail = 'farrier@equibook.demo';
  static const _demoOwnerEmail = 'owner@equibook.demo';
  static const _demoPassword = 'demo1234';

  bool ready = false;
  String? currentUserId;

  final List<AppUser> users = [];
  final List<Horse> horses = [];
  final List<VetProfile> vetProfiles = [];
  final List<ServiceOffering> services = [];
  final List<AvailabilitySlot> slots = [];
  final List<Booking> bookings = [];
  final List<HorseReminder> reminders = [];

  AppUser? get currentUser {
    if (currentUserId == null) return null;
    return users.cast<AppUser?>().firstWhere(
      (u) => u!.id == currentUserId,
      orElse: () => null,
    );
  }

  Future<void> init() async {
    await _load();
    if (users.isEmpty) {
      _seedDemo();
      await _save();
    } else {
      await _ensureExpandedDemo();
    }
    ready = true;
    notifyListeners();
  }

  void _hydrate(Map<String, dynamic> data) {
    users
      ..clear()
      ..addAll(
        (data['users'] as List? ?? []).map(
          (e) => AppUser.fromJson(e as Map<String, dynamic>),
        ),
      );
    horses
      ..clear()
      ..addAll(
        (data['horses'] as List? ?? []).map(
          (e) => Horse.fromJson(e as Map<String, dynamic>),
        ),
      );
    vetProfiles
      ..clear()
      ..addAll(
        (data['vetProfiles'] as List? ?? []).map(
          (e) => VetProfile.fromJson(e as Map<String, dynamic>),
        ),
      );
    services
      ..clear()
      ..addAll(
        (data['services'] as List? ?? []).map(
          (e) => ServiceOffering.fromJson(e as Map<String, dynamic>),
        ),
      );
    slots
      ..clear()
      ..addAll(
        (data['slots'] as List? ?? []).map(
          (e) => AvailabilitySlot.fromJson(e as Map<String, dynamic>),
        ),
      );
    bookings
      ..clear()
      ..addAll(
        (data['bookings'] as List? ?? []).map(
          (e) => Booking.fromJson(e as Map<String, dynamic>),
        ),
      );
    reminders
      ..clear()
      ..addAll(
        (data['reminders'] as List? ?? []).map(
          (e) => HorseReminder.fromJson(e as Map<String, dynamic>),
        ),
      );
    currentUserId = data['currentUserId'] as String?;
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw == null) return;
      _hydrate(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Corrupt local data — start fresh.
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = {
      'currentUserId': currentUserId,
      'users': users.map((e) => e.toJson()).toList(),
      'horses': horses.map((e) => e.toJson()).toList(),
      'vetProfiles': vetProfiles.map((e) => e.toJson()).toList(),
      'services': services.map((e) => e.toJson()).toList(),
      'slots': slots.map((e) => e.toJson()).toList(),
      'bookings': bookings.map((e) => e.toJson()).toList(),
      'reminders': reminders.map((e) => e.toJson()).toList(),
    };
    await prefs.setString(_storageKey, jsonEncode(payload));
  }

  void _seedDemo() {
    final vetId = _uuid.v4();
    final farrierId = _uuid.v4();
    final ownerId = _uuid.v4();
    users.addAll([
      AppUser(
        id: vetId,
        email: _demoVetEmail,
        password: _demoPassword,
        name: 'Dr. Mohammadi',
        role: UserRole.vet,
        phone: '555-0100',
      ),
      AppUser(
        id: farrierId,
        email: _demoFarrierEmail,
        password: _demoPassword,
        name: 'Reza Farrier',
        role: UserRole.vet,
        phone: '555-0102',
      ),
      AppUser(
        id: ownerId,
        email: _demoOwnerEmail,
        password: _demoPassword,
        name: 'Faryouz',
        role: UserRole.owner,
        phone: '555-0101',
      ),
    ]);
    vetProfiles.addAll([
      VetProfile(
        userId: vetId,
        bio: 'Equine veterinarian specializing in farm calls and dental care.',
        serviceArea: 'Qazvin',
        credentials: 'DVM · Equine practice 12 years',
        category: ServiceCategory.veterinary,
      ),
      VetProfile(
        userId: farrierId,
        bio: 'Professional farrier for sport and leisure horses.',
        serviceArea: 'Qazvin',
        credentials: 'Certified farrier · 8 years',
        category: ServiceCategory.farriery,
      ),
    ]);

    final farmVisit = ServiceOffering(
      id: _uuid.v4(),
      vetId: vetId,
      title: 'Farm visit checkup',
      description: 'On-site wellness exam and consultation.',
      rate: 185,
      durationMinutes: 60,
      category: ServiceCategory.veterinary,
    );
    final dental = ServiceOffering(
      id: _uuid.v4(),
      vetId: vetId,
      title: 'Dental float',
      description: 'Routine dental floating and oral exam.',
      rate: 250,
      durationMinutes: 90,
      category: ServiceCategory.veterinary,
    );
    final shoeing = ServiceOffering(
      id: _uuid.v4(),
      vetId: farrierId,
      title: 'Full shoeing',
      description: 'Trim and shoe all four feet.',
      rate: 140,
      durationMinutes: 75,
      category: ServiceCategory.farriery,
    );
    services.addAll([farmVisit, dental, shoeing]);

    _addWeekdaySlots(vetId);
    _addWeekdaySlots(farrierId);

    final yadegar = Horse(
      id: _uuid.v4(),
      ownerId: ownerId,
      name: 'Yadegar',
      breed: 'Turkoman',
      notes: 'Calm under saddle.',
    );
    final delijan = Horse(
      id: _uuid.v4(),
      ownerId: ownerId,
      name: 'Delijan',
      breed: 'Arabian',
    );
    final mahtab = Horse(
      id: _uuid.v4(),
      ownerId: ownerId,
      name: 'Mahtab',
      breed: 'Thoroughbred',
    );
    horses.addAll([yadegar, delijan, mahtab]);

    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    reminders.addAll([
      HorseReminder(
        id: _uuid.v4(),
        ownerId: ownerId,
        horseId: delijan.id,
        title: 'Pregnancy test',
        dueDate: day.add(const Duration(days: 5)),
        kind: ReminderKind.pregnancyTest,
      ),
      HorseReminder(
        id: _uuid.v4(),
        ownerId: ownerId,
        horseId: mahtab.id,
        title: 'Deworming tablet',
        dueDate: day.add(const Duration(days: 3)),
        kind: ReminderKind.deworming,
      ),
      HorseReminder(
        id: _uuid.v4(),
        ownerId: ownerId,
        horseId: mahtab.id,
        title: 'Influenza vaccine',
        dueDate: day.add(const Duration(days: 2)),
        kind: ReminderKind.vaccine,
      ),
    ]);

    final vetSlot = openSlotsFor(vetId).isEmpty ? null : openSlotsFor(vetId).first;
    final farrierSlot =
        openSlotsFor(farrierId).isEmpty ? null : openSlotsFor(farrierId).first;
    if (vetSlot != null) {
      bookings.add(
        Booking(
          id: _uuid.v4(),
          ownerId: ownerId,
          vetId: vetId,
          horseId: yadegar.id,
          serviceId: farmVisit.id,
          slotId: vetSlot.id,
          start: vetSlot.start,
          end: vetSlot.end,
          quotedRate: farmVisit.rate,
          status: BookingStatus.confirmed,
          createdAt: now,
          rateConfirmedByOwner: true,
        ),
      );
    }
    if (farrierSlot != null) {
      bookings.add(
        Booking(
          id: _uuid.v4(),
          ownerId: ownerId,
          vetId: farrierId,
          horseId: delijan.id,
          serviceId: shoeing.id,
          slotId: farrierSlot.id,
          start: farrierSlot.start,
          end: farrierSlot.end,
          quotedRate: shoeing.rate,
          status: BookingStatus.pending,
          createdAt: now,
          rateConfirmedByOwner: true,
        ),
      );
    }
  }

  void _addWeekdaySlots(String providerId) {
    final now = DateTime.now();
    for (var day = 1; day <= 10; day++) {
      final date = DateTime(now.year, now.month, now.day).add(Duration(days: day));
      if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
        continue;
      }
      slots.add(
        AvailabilitySlot(
          id: _uuid.v4(),
          vetId: providerId,
          start: DateTime(date.year, date.month, date.day, 9),
          end: DateTime(date.year, date.month, date.day, 10),
        ),
      );
      slots.add(
        AvailabilitySlot(
          id: _uuid.v4(),
          vetId: providerId,
          start: DateTime(date.year, date.month, date.day, 14),
          end: DateTime(date.year, date.month, date.day, 15, 30),
        ),
      );
    }
  }

  Future<void> _ensureExpandedDemo() async {
    var changed = false;
    if (!users.any((u) => u.email == _demoFarrierEmail)) {
      final farrierId = _uuid.v4();
      users.add(
        AppUser(
          id: farrierId,
          email: _demoFarrierEmail,
          password: _demoPassword,
          name: 'Reza Farrier',
          role: UserRole.vet,
          phone: '555-0102',
        ),
      );
      vetProfiles.add(
        VetProfile(
          userId: farrierId,
          bio: 'Professional farrier for sport and leisure horses.',
          serviceArea: 'Qazvin',
          credentials: 'Certified farrier · 8 years',
          category: ServiceCategory.farriery,
        ),
      );
      services.add(
        ServiceOffering(
          id: _uuid.v4(),
          vetId: farrierId,
          title: 'Full shoeing',
          description: 'Trim and shoe all four feet.',
          rate: 140,
          durationMinutes: 75,
          category: ServiceCategory.farriery,
        ),
      );
      _addWeekdaySlots(farrierId);
      changed = true;
    }
    final owner = users.cast<AppUser?>().firstWhere(
      (u) => u!.email == _demoOwnerEmail,
      orElse: () => null,
    );
    if (owner != null && reminders.where((r) => r.ownerId == owner.id).isEmpty) {
      final ownerHorses = horsesFor(owner.id);
      if (ownerHorses.isNotEmpty) {
        final day = DateTime.now();
        final base = DateTime(day.year, day.month, day.day);
        reminders.add(
          HorseReminder(
            id: _uuid.v4(),
            ownerId: owner.id,
            horseId: ownerHorses.first.id,
            title: 'Influenza vaccine',
            dueDate: base.add(const Duration(days: 2)),
            kind: ReminderKind.vaccine,
          ),
        );
        changed = true;
      }
    }
    if (changed) await _save();
  }

  String? validateSignup({
    required String email,
    required String password,
    required String name,
  }) {
    if (name.trim().isEmpty) return 'Name is required.';
    if (!email.contains('@')) return 'Enter a valid email.';
    if (password.length < 6) return 'Password must be at least 6 characters.';
    if (users.any((u) => u.email.toLowerCase() == email.toLowerCase())) {
      return 'An account with that email already exists.';
    }
    return null;
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String phone = '',
    ServiceCategory providerCategory = ServiceCategory.veterinary,
  }) async {
    final error = validateSignup(email: email, password: password, name: name);
    if (error != null) return error;
    final user = AppUser(
      id: _uuid.v4(),
      email: email.trim().toLowerCase(),
      password: password,
      name: name.trim(),
      role: role,
      phone: phone.trim(),
    );
    users.add(user);
    if (role == UserRole.vet) {
      final category = providerCategory.isBookable
          ? providerCategory
          : ServiceCategory.veterinary;
      vetProfiles.add(VetProfile(userId: user.id, category: category));
    }
    currentUserId = user.id;
    await _save();
    notifyListeners();
    return null;
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final user = users.cast<AppUser?>().firstWhere(
      (u) =>
          u!.email.toLowerCase() == email.trim().toLowerCase() &&
          u.password == password,
      orElse: () => null,
    );
    if (user == null) return 'Invalid email or password.';
    currentUserId = user.id;
    await _save();
    notifyListeners();
    return null;
  }

  Future<void> logout() async {
    currentUserId = null;
    await _save();
    notifyListeners();
  }

  List<Horse> horsesFor(String ownerId) =>
      horses.where((h) => h.ownerId == ownerId).toList();

  Future<void> upsertHorse(Horse horse) async {
    final index = horses.indexWhere((h) => h.id == horse.id);
    if (index >= 0) {
      horses[index] = horse;
    } else {
      horses.add(horse);
    }
    await _save();
    notifyListeners();
  }

  Future<void> deleteHorse(String horseId) async {
    horses.removeWhere((h) => h.id == horseId);
    await _save();
    notifyListeners();
  }

  Horse newHorseDraft(String ownerId) => Horse(
    id: _uuid.v4(),
    ownerId: ownerId,
    name: '',
  );

  VetProfile profileFor(String vetId) => vetProfiles.firstWhere(
    (p) => p.userId == vetId,
    orElse: () => VetProfile(userId: vetId),
  );

  Future<void> updateVetProfile(VetProfile profile) async {
    final index = vetProfiles.indexWhere((p) => p.userId == profile.userId);
    if (index >= 0) {
      vetProfiles[index] = profile;
    } else {
      vetProfiles.add(profile);
    }
    await _save();
    notifyListeners();
  }

  List<ServiceOffering> servicesFor(String vetId) =>
      services.where((s) => s.vetId == vetId).toList();

  Future<void> upsertService(ServiceOffering service) async {
    final index = services.indexWhere((s) => s.id == service.id);
    if (index >= 0) {
      services[index] = service;
    } else {
      services.add(service);
    }
    await _save();
    notifyListeners();
  }

  Future<void> deleteService(String serviceId) async {
    services.removeWhere((s) => s.id == serviceId);
    await _save();
    notifyListeners();
  }

  ServiceOffering newServiceDraft(String vetId) {
    final category = profileFor(vetId).category;
    return ServiceOffering(
      id: _uuid.v4(),
      vetId: vetId,
      title: '',
      rate: 0,
      category: category,
    );
  }

  List<AvailabilitySlot> openSlotsFor(String vetId) {
    final bookedSlotIds = bookings
        .where(
          (b) =>
              b.vetId == vetId &&
              (b.status == BookingStatus.pending ||
                  b.status == BookingStatus.confirmed),
        )
        .map((b) => b.slotId)
        .toSet();
    final now = DateTime.now();
    return slots
        .where(
          (s) =>
              s.vetId == vetId &&
              s.start.isAfter(now) &&
              !bookedSlotIds.contains(s.id),
        )
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));
  }

  List<AvailabilitySlot> allSlotsFor(String vetId) =>
      slots.where((s) => s.vetId == vetId).toList()
        ..sort((a, b) => a.start.compareTo(b.start));

  Future<void> addSlot({
    required String vetId,
    required DateTime start,
    required DateTime end,
  }) async {
    slots.add(
      AvailabilitySlot(
        id: _uuid.v4(),
        vetId: vetId,
        start: start,
        end: end,
      ),
    );
    await _save();
    notifyListeners();
  }

  Future<void> deleteSlot(String slotId) async {
    slots.removeWhere((s) => s.id == slotId);
    await _save();
    notifyListeners();
  }

  List<AppUser> get vets => users.where((u) => u.role == UserRole.vet).toList();

  List<AppUser> providersFor(ServiceCategory category) => vets
      .where((u) => profileFor(u.id).category == category)
      .toList();

  List<Booking> upcomingBookingsForOwner(String ownerId) {
    final now = DateTime.now();
    return bookings
        .where(
          (b) =>
              b.ownerId == ownerId &&
              b.start.isAfter(now.subtract(const Duration(hours: 1))) &&
              (b.status == BookingStatus.pending ||
                  b.status == BookingStatus.confirmed),
        )
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));
  }

  List<HorseReminder> remindersForOwner(String ownerId, {bool includeDone = false}) =>
      reminders
          .where((r) => r.ownerId == ownerId && (includeDone || !r.done))
          .toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

  HorseReminder newReminderDraft(String ownerId, String horseId) => HorseReminder(
    id: _uuid.v4(),
    ownerId: ownerId,
    horseId: horseId,
    title: '',
    dueDate: DateTime.now().add(const Duration(days: 3)),
  );

  Future<void> upsertReminder(HorseReminder reminder) async {
    final index = reminders.indexWhere((r) => r.id == reminder.id);
    if (index >= 0) {
      reminders[index] = reminder;
    } else {
      reminders.add(reminder);
    }
    await _save();
    notifyListeners();
  }

  Future<void> deleteReminder(String reminderId) async {
    reminders.removeWhere((r) => r.id == reminderId);
    await _save();
    notifyListeners();
  }

  AppUser? userById(String id) => users.cast<AppUser?>().firstWhere(
    (u) => u!.id == id,
    orElse: () => null,
  );

  Horse? horseById(String id) => horses.cast<Horse?>().firstWhere(
    (h) => h!.id == id,
    orElse: () => null,
  );

  ServiceOffering? serviceById(String id) =>
      services.cast<ServiceOffering?>().firstWhere(
        (s) => s!.id == id,
        orElse: () => null,
      );

  Future<String?> createBooking({
    required String ownerId,
    required String vetId,
    required String horseId,
    required String serviceId,
    required String slotId,
    required bool rateConfirmedByOwner,
    String notes = '',
  }) async {
    if (!rateConfirmedByOwner) {
      return 'Please confirm the rate before booking.';
    }
    final service = serviceById(serviceId);
    final slot = slots.cast<AvailabilitySlot?>().firstWhere(
      (s) => s!.id == slotId,
      orElse: () => null,
    );
    if (service == null || slot == null) return 'Service or time slot missing.';
    final taken = bookings.any(
      (b) =>
          b.slotId == slotId &&
          (b.status == BookingStatus.pending ||
              b.status == BookingStatus.confirmed),
    );
    if (taken) return 'That time slot was just taken.';

    bookings.add(
      Booking(
        id: _uuid.v4(),
        ownerId: ownerId,
        vetId: vetId,
        horseId: horseId,
        serviceId: serviceId,
        slotId: slotId,
        start: slot.start,
        end: slot.end,
        quotedRate: service.rate,
        status: BookingStatus.pending,
        createdAt: DateTime.now(),
        notes: notes,
        rateConfirmedByOwner: true,
      ),
    );
    await _save();
    notifyListeners();
    return null;
  }

  List<Booking> bookingsForOwner(String ownerId) =>
      bookings.where((b) => b.ownerId == ownerId).toList()
        ..sort((a, b) => b.start.compareTo(a.start));

  List<Booking> bookingsForVet(String vetId) =>
      bookings.where((b) => b.vetId == vetId).toList()
        ..sort((a, b) => b.start.compareTo(a.start));

  Future<void> updateBookingStatus(String bookingId, BookingStatus status) async {
    final index = bookings.indexWhere((b) => b.id == bookingId);
    if (index < 0) return;
    bookings[index] = bookings[index].copyWith(status: status);
    await _save();
    notifyListeners();
  }

  Future<void> updateCurrentUser({
    String? name,
    String? phone,
  }) async {
    final user = currentUser;
    if (user == null) return;
    final index = users.indexWhere((u) => u.id == user.id);
    users[index] = user.copyWith(name: name, phone: phone);
    await _save();
    notifyListeners();
  }

  static String get demoVetEmail => _demoVetEmail;
  static String get demoFarrierEmail => _demoFarrierEmail;
  static String get demoOwnerEmail => _demoOwnerEmail;
  static String get demoPassword => _demoPassword;
}
