import '../models/enums.dart';
import '../settings/preferences.dart';

/// Bilingual UI copy. Dates are formatted separately via [AppDates].
class AppStrings {
  const AppStrings(this.language);

  final AppLanguage language;

  bool get _fa => language == AppLanguage.farsi;

  String get appName => 'EquiBook';
  String get tagline => _fa
      ? 'نوبت دامپزشک اسب مورد اعتمادتان را رزرو کنید — نرخ از قبل مشخص، پرداخت نقدی حضوری.'
      : 'Book trusted equine vets for your horses — rates upfront, cash offline.';

  String get createAccount => _fa ? 'ساخت حساب' : 'Create account';
  String get logIn => _fa ? 'ورود' : 'Log in';
  String get logOut => _fa ? 'خروج' : 'Log out';
  String get email => _fa ? 'ایمیل' : 'Email';
  String get password => _fa ? 'رمز عبور' : 'Password';
  String get fullName => _fa ? 'نام کامل' : 'Full name';
  String get phoneOptional => _fa ? 'تلفن (اختیاری)' : 'Phone (optional)';
  String get iAmA => _fa ? 'من هستم…' : 'I am a…';
  String get horseOwner => _fa ? 'صاحب اسب' : 'Horse owner';
  String get veterinarian => _fa ? 'دامپزشک' : 'Veterinarian';
  String get signUp => _fa ? 'ثبت‌نام' : 'Sign up';
  String get signingIn => _fa ? 'در حال ورود…' : 'Signing in…';
  String get creating => _fa ? 'در حال ایجاد…' : 'Creating…';

  String demoAccounts(String password) => _fa
      ? 'حساب‌های نمونه (رمز: $password)'
      : 'Demo accounts (password: $password)';
  String get tryAsOwner => _fa ? 'ورود به‌عنوان صاحب اسب' : 'Try as owner';
  String get tryAsVet => _fa ? 'ورود به‌عنوان دامپزشک' : 'Try as vet';

  String get horses => _fa ? 'اسب‌ها' : 'Horses';
  String get myHorses => _fa ? 'اسب‌های من' : 'My horses';
  String get findVets => _fa ? 'یافتن دامپزشک' : 'Find vets';
  String get bookings => _fa ? 'نوبت‌ها' : 'Bookings';
  String get myBookings => _fa ? 'نوبت‌های من' : 'My bookings';
  String get profile => _fa ? 'پروفایل' : 'Profile';
  String get settings => _fa ? 'تنظیمات' : 'Settings';
  String get languageLabel => _fa ? 'زبان' : 'Language';
  String get calendar => _fa ? 'تقویم' : 'Calendar';
  String get preferences => _fa ? 'ترجیحات' : 'Preferences';

  String get addHorse => _fa ? 'افزودن اسب' : 'Add horse';
  String get editHorse => _fa ? 'ویرایش اسب' : 'Edit horse';
  String get saveHorse => _fa ? 'ذخیره اسب' : 'Save horse';
  String get saving => _fa ? 'در حال ذخیره…' : 'Saving…';
  String get name => _fa ? 'نام' : 'Name';
  String get breedOptional => _fa ? 'نژاد (اختیاری)' : 'Breed (optional)';
  String get notesOptional => _fa ? 'یادداشت (اختیاری)' : 'Notes (optional)';
  String get ownershipDocument =>
      _fa ? 'مدرک مالکیت' : 'Ownership document';
  String get ownershipHint => _fa
      ? 'PDF یا تصویر مدارک مالکیت'
      : 'PDF or image of ownership papers';
  String get attached => _fa ? 'پیوست شد' : 'Attached';
  String get upload => _fa ? 'بارگذاری' : 'Upload';
  String get replace => _fa ? 'جایگزینی' : 'Replace';
  String get tapToAddPhoto => _fa ? 'برای افزودن عکس ضربه بزنید' : 'Tap to add photo';
  String get noHorsesYet => _fa ? 'هنوز اسبی ندارید' : 'No horses yet';
  String get noHorsesMessage => _fa
      ? 'اسبی با عکس و مدارک مالکیت اضافه کنید.'
      : 'Add a horse with a photo and ownership documents.';
  String get deleteHorse => _fa ? 'حذف اسب؟' : 'Delete horse?';
  String removeHorse(String name) =>
      _fa ? '$name از اصطبل شما حذف شود؟' : 'Remove $name from your stable?';
  String get cancel => _fa ? 'لغو' : 'Cancel';
  String get delete => _fa ? 'حذف' : 'Delete';
  String get horseNameRequired =>
      _fa ? 'نام اسب الزامی است.' : 'Horse name is required.';

  String get searchVetsHint =>
      _fa ? 'جستجو بر اساس نام یا منطقه' : 'Search by name or area';
  String get noVetsFound => _fa ? 'دامپزشکی یافت نشد' : 'No vets found';
  String get noVetsMessage => _fa
      ? 'جستجوی دیگری امتحان کنید یا از دامپزشک بخواهید ثبت‌نام کند.'
      : 'Try another search, or ask a vet to sign up.';
  String get serviceAreaNotSet =>
      _fa ? 'منطقه خدمت مشخص نشده' : 'Service area not set';
  String servicesAndSlots(int services, int slots) => _fa
      ? '$services خدمت · $slots نوبت آزاد'
      : '$services services · $slots open slots';
  String get equineVeterinarian =>
      _fa ? 'دامپزشک اسب' : 'Equine veterinarian';
  String get noBioYet => _fa ? 'هنوز بیوگرافی ثبت نشده.' : 'No bio yet.';
  String get servicesAndRates =>
      _fa ? 'خدمات و نرخ‌ها' : 'Services & rates';
  String get noServicesListed =>
      _fa ? 'این دامپزشک هنوز خدمتی ثبت نکرده است.' : 'This vet has not listed services yet.';
  String openTimes(int count) =>
      _fa ? 'زمان‌های آزاد ($count)' : 'Open times ($count)';
  String get noOpenSlots =>
      _fa ? 'در حال حاضر نوبت آزادی نیست.' : 'No open slots right now.';
  String get bookAVisit => _fa ? 'رزرو ویزیت' : 'Book a visit';
  String get cashOfflineHint => _fa
      ? 'پرداخت نقدی و حضوری است. قبل از ارسال درخواست، نرخ را تأیید می‌کنید.'
      : 'Payment is cash offline. You will confirm the rate before sending the request.';
  String untilTime(String time) => _fa ? 'تا $time' : 'Until $time';
  String minutesLabel(int minutes) => _fa ? '$minutes دقیقه' : '$minutes min';

  String get horse => _fa ? 'اسب' : 'Horse';
  String get service => _fa ? 'خدمت' : 'Service';
  String get timeSlot => _fa ? 'بازه زمانی' : 'Time slot';
  String get addHorseBeforeBooking =>
      _fa ? 'قبل از رزرو یک اسب اضافه کنید.' : 'Add a horse before booking.';
  String get notesForVet =>
      _fa ? 'یادداشت برای دامپزشک (اختیاری)' : 'Notes for the vet (optional)';
  String get rateToConfirm => _fa ? 'نرخ برای تأیید' : 'Rate to confirm';
  String get cashConfirmHint => _fa
      ? 'پرداخت نقدی و حضوری انجام می‌شود. تأیید کنید که این نرخ را می‌پذیرید.'
      : 'Payment is handled offline in cash. Confirm that you accept this rate.';
  String confirmRate(String amount) => _fa
      ? 'نرخ $amount را تأیید می‌کنم'
      : 'I confirm the rate of $amount';
  String get requestBooking => _fa ? 'درخواست نوبت' : 'Request booking';
  String get sending => _fa ? 'در حال ارسال…' : 'Sending…';
  String get bookingSent =>
      _fa ? 'درخواست نوبت برای دامپزشک ارسال شد.' : 'Booking request sent to the vet.';

  String get noBookingsYet => _fa ? 'هنوز نوبتی ندارید' : 'No bookings yet';
  String get noBookingsOwnerMessage => _fa
      ? 'دامپزشکی پیدا کنید و برای یکی از اسب‌هایتان ویزیت بگیرید.'
      : 'Find a vet and request a visit for one of your horses.';
  String get confirmedRateCash => _fa
      ? 'نرخ تأییدشده (نقدی حضوری)'
      : 'Confirmed rate (cash offline)';
  String quotedRate(String amount) =>
      _fa ? 'نرخ اعلام‌شده: $amount' : 'Quoted rate: $amount';
  String confirmedRateLine(String amount) => _fa
      ? 'نرخ تأییدشده: $amount (نقدی حضوری)'
      : 'Confirmed rate: $amount (cash offline)';
  String get visit => _fa ? 'ویزیت' : 'Visit';
  String get vet => _fa ? 'دامپزشک' : 'Vet';
  String horseLabel(String name) => _fa ? 'اسب: $name' : 'Horse: $name';
  String ownerLabel(String name) => _fa ? 'صاحب: $name' : 'Owner: $name';
  String notesLabel(String notes) => _fa ? 'یادداشت: $notes' : 'Notes: $notes';
  String get unknown => _fa ? 'نامشخص' : 'Unknown';

  String get bookingInbox => _fa ? 'صندوق نوبت‌ها' : 'Booking inbox';
  String get noBookingsVetMessage => _fa
      ? 'وقتی صاحبان اسب درخواست ویزیت دهند، اینجا برای پذیرش یا رد ظاهر می‌شوند.'
      : 'When owners request visits, they appear here for accept or decline.';
  String get accept => _fa ? 'پذیرش' : 'Accept';
  String get decline => _fa ? 'رد' : 'Decline';
  String get markCompleted => _fa ? 'علامت به‌عنوان انجام‌شده' : 'Mark completed';

  String get addService => _fa ? 'افزودن خدمت' : 'Add service';
  String get editService => _fa ? 'ویرایش خدمت' : 'Edit service';
  String get saveService => _fa ? 'ذخیره خدمت' : 'Save service';
  String get serviceTitle => _fa ? 'عنوان خدمت' : 'Service title';
  String get description => _fa ? 'توضیحات' : 'Description';
  String get cashRateUsd => _fa ? 'نرخ نقدی (دلار)' : 'Cash rate (USD)';
  String get durationMinutes =>
      _fa ? 'مدت (دقیقه)' : 'Duration (minutes)';
  String get noServicesMessage => _fa
      ? 'خدماتی با نرخ نقدی اضافه کنید تا صاحبان هنگام رزرو ببینند.'
      : 'Add services with cash rates owners will confirm when booking.';
  String get serviceValidation => _fa
      ? 'عنوان، نرخ مثبت و مدت را وارد کنید.'
      : 'Enter a title, positive rate, and duration.';

  String get availability => _fa ? 'زمان‌های آزاد' : 'Availability';
  String get addAvailability => _fa ? 'افزودن زمان آزاد' : 'Add availability';
  String get addSlot => _fa ? 'افزودن نوبت' : 'Add slot';
  String get add => _fa ? 'افزودن' : 'Add';
  String get date => _fa ? 'تاریخ' : 'Date';
  String get start => _fa ? 'شروع' : 'Start';
  String get end => _fa ? 'پایان' : 'End';
  String get noAvailability => _fa ? 'زمان آزادی نیست' : 'No availability';
  String get noAvailabilityMessage =>
      _fa ? 'بازه‌هایی اضافه کنید که صاحبان بتوانند رزرو کنند.' : 'Add time slots owners can book.';
  String get endAfterStart =>
      _fa ? 'زمان پایان باید بعد از شروع باشد.' : 'End time must be after start time.';
  String slotStatus(bool open) =>
      open ? (_fa ? 'آزاد' : 'Open') : (_fa ? 'رزرو شده / گذشته' : 'Booked / past');

  String get vetProfile => _fa ? 'پروفایل دامپزشک' : 'Vet profile';
  String get credentials => _fa ? 'مدارک تخصصی' : 'Credentials';
  String get credentialsHint =>
      _fa ? 'دامپزشک · تخصص' : 'DVM · specialty';
  String get serviceArea => _fa ? 'منطقه خدمت' : 'Service area';
  String get serviceAreaHint =>
      _fa ? 'شهر / شعاع' : 'City / radius';
  String get bio => _fa ? 'بیوگرافی' : 'Bio';
  String get saveProfile => _fa ? 'ذخیره پروفایل' : 'Save profile';
  String get profileSaved => _fa ? 'پروفایل ذخیره شد' : 'Profile saved';

  String get roleOwner => _fa ? 'صاحب اسب' : 'Horse owner';
  String get roleVet => _fa ? 'دامپزشک' : 'Veterinarian';

  String get statusPending => _fa ? 'در انتظار' : 'Pending';
  String get statusConfirmed => _fa ? 'تأیید شده' : 'Confirmed';
  String get statusDeclined => _fa ? 'رد شده' : 'Declined';
  String get statusCompleted => _fa ? 'انجام شده' : 'Completed';
  String get statusCancelled => _fa ? 'لغو شده' : 'Cancelled';

  String get vetNotFound => _fa ? 'دامپزشک یافت نشد' : 'Vet not found';
  String get providerNotFound =>
      _fa ? 'ارائه‌دهنده یافت نشد' : 'Provider not found';

  String get home => _fa ? 'خانه' : 'Home';
  String get bookServices => _fa ? 'رزرو خدمات' : 'Book services';
  String get messages => _fa ? 'پیام‌ها' : 'Messages';
  String get taglineShort =>
      _fa ? 'همه چیز برای اسب شما، در یک جا' : 'Everything for your horse, in one place';
  String helloName(String name) => _fa ? 'سلام $name' : 'Hello $name';
  String get welcomeHome => _fa
      ? 'خوش آمدید، امیدواریم روز خوبی با اسب‌های خود داشته باشید.'
      : 'Welcome — hope you have a great day with your horses.';
  String get upcomingAppointments =>
      _fa ? 'نوبت‌های پیش رو' : 'Upcoming appointments';
  String get reminders => _fa ? 'یادآوری‌ها' : 'Reminders';
  String get viewAll => _fa ? 'مشاهده همه' : 'View all';
  String get noUpcoming =>
      _fa ? 'نوبت نزدیکی ندارید.' : 'No upcoming appointments.';
  String get noReminders =>
      _fa ? 'یادآوری‌ای ثبت نشده است.' : 'No reminders yet.';
  String get addReminder => _fa ? 'افزودن یادآوری' : 'Add reminder';
  String get editReminder => _fa ? 'ویرایش یادآوری' : 'Edit reminder';
  String get saveReminder => _fa ? 'ذخیره یادآوری' : 'Save reminder';
  String get reminderTitle => _fa ? 'عنوان' : 'Title';
  String get dueDate => _fa ? 'موعد' : 'Due date';
  String get reminderKind => _fa ? 'نوع' : 'Type';
  String get markDone => _fa ? 'انجام شد' : 'Mark done';
  String daysLeft(int days) {
    if (days < 0) return _fa ? 'گذشته' : 'Overdue';
    if (days == 0) return _fa ? 'امروز' : 'Today';
    if (days == 1) return _fa ? '۱ روز دیگر' : 'In 1 day';
    return _fa ? '$days روز دیگر' : 'In $days days';
  }

  String get categoryVet => _fa ? 'ویزیت دامپزشک' : 'Vet visit';
  String get categoryFarrier => _fa ? 'نعلبندی' : 'Farriery';
  String get categoryRiding => _fa ? 'کلاس سوارکاری' : 'Riding class';
  String get categoryClub => _fa ? 'مدیریت باشگاه' : 'Club management';
  String get categoryShop => _fa ? 'فروشگاه' : 'Shop';
  String get bookAppointment => _fa ? 'رزرو نوبت' : 'Book appointment';
  String get bookClass => _fa ? 'رزرو کلاس' : 'Book class';
  String get clubServices => _fa ? 'خدمات باشگاه' : 'Club services';
  String get horseEquipment => _fa ? 'تجهیزات اسب' : 'Horse equipment';
  String get comingSoon => _fa ? 'به‌زودی' : 'Coming soon';
  String get comingSoonMessage => _fa
      ? 'این بخش به‌زودی فعال می‌شود.'
      : 'This section will be available soon.';
  String get findProviders => _fa ? 'یافتن متخصص' : 'Find providers';
  String get messagesComingSoon => _fa
      ? 'پیام‌رسانی هنوز فعال نیست.'
      : 'Messaging is not available yet.';
  String get chooseCity => _fa ? 'انتخاب شهر' : 'Choose city';
  String get notifications => _fa ? 'اعلان‌ها' : 'Notifications';
  String get noNotifications =>
      _fa ? 'اعلان جدیدی ندارید.' : 'No new notifications.';
  String get providerType => _fa ? 'نوع تخصص' : 'Specialty';
  String get farrier => _fa ? 'نعلبند' : 'Farrier';
  String get statusPendingConfirm =>
      _fa ? 'در انتظار تأیید' : 'Pending confirmation';

  String kindLabel(ReminderKind kind) => switch (kind) {
    ReminderKind.vaccine => _fa ? 'واکسن' : 'Vaccine',
    ReminderKind.deworming => _fa ? 'ضد ضد انگل' : 'Deworming',
    ReminderKind.pregnancyTest => _fa ? 'آزمایش بارداری' : 'Pregnancy test',
    ReminderKind.other => _fa ? 'سایر' : 'Other',
  };

  String categoryTitle(ServiceCategory category) => switch (category) {
    ServiceCategory.veterinary => categoryVet,
    ServiceCategory.farriery => categoryFarrier,
    ServiceCategory.ridingClass => categoryRiding,
    ServiceCategory.clubManagement => categoryClub,
    ServiceCategory.shop => categoryShop,
  };

  String categorySubtitle(ServiceCategory category) => switch (category) {
    ServiceCategory.veterinary => bookAppointment,
    ServiceCategory.farriery => bookAppointment,
    ServiceCategory.ridingClass => bookClass,
    ServiceCategory.clubManagement => clubServices,
    ServiceCategory.shop => horseEquipment,
  };

  String cityLabel(String city) {
    if (!_fa) return city;
    return switch (city) {
      'Qazvin' => 'قزوین',
      'Tehran' => 'تهران',
      'Karaj' => 'کرج',
      'Isfahan' => 'اصفهان',
      'Shiraz' => 'شیراز',
      'Tabriz' => 'تبریز',
      _ => city,
    };
  }

  /// Demo/content titles stored in English; show Farsi when locale is fa.
  String localizedContentTitle(String title) {
    if (!_fa) return title;
    return switch (title) {
      'Farm visit checkup' => 'ویزیت مزرعه‌ای',
      'Dental float' => 'رسوب‌زدایی دندان',
      'Full shoeing' => 'نعل‌بندی کامل',
      'Pregnancy test' => 'آزمایش بارداری',
      'Deworming tablet' => 'قرص ضد انگل',
      'Influenza vaccine' => 'واکسن آنفلوآنزا',
      _ => title,
    };
  }
}
