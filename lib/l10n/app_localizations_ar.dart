// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'التقويم المشترك';

  @override
  String get dayView => 'عرض اليوم';

  @override
  String get weekView => 'عرض الأسبوع';

  @override
  String get monthView => 'عرض الشهر';

  @override
  String get myGroups => 'مجموعاتي';

  @override
  String get logout => 'تسجيل خروج';

  @override
  String get login => 'تسجيل دخول';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get register => 'إنشاء حساب';

  @override
  String get createGroup => 'إنشاء مجموعة';

  @override
  String get groupName => 'اسم المجموعة';

  @override
  String get joinGroup => 'انضمام لمجموعة';

  @override
  String get eventTitle => 'عنوان الحدث';

  @override
  String get startTime => 'وقت البدء';

  @override
  String get endTime => 'وقت الانتهاء';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get repeats => 'تكرار';

  @override
  String get doesNotRepeat => 'لا يتكرر';

  @override
  String get daily => 'يومياً';

  @override
  String get weekly => 'أسبوعياً';

  @override
  String get monthly => 'شهرياً';

  @override
  String get color => 'لون';

  @override
  String get description => 'وصف';

  @override
  String get addEvent => 'إضافة حدث';

  @override
  String welcome(String name) {
    return 'مرحباً، $name!';
  }

  @override
  String get noGroupsYet => 'لا توجد مجموعات بعد. أنشئ أو انضم لواحدة!';

  @override
  String get search => 'بحث';

  @override
  String get allCalendars => 'كل التقويمات';

  @override
  String get lastUpdated => 'آخر تحديث';

  @override
  String get nextEvent => 'الحدث التالي';

  @override
  String get unread => 'غير مقروء';

  @override
  String get archived => 'الأرشيف';

  @override
  String get addYourName => 'أضف اسمك';

  @override
  String get calendarAccounts => 'أضف حسابات التقويم';

  @override
  String get settings => 'الإعدادات';

  @override
  String get helpCenter => 'مركز المساعدة';

  @override
  String get contactUs => 'تواصل معنا';

  @override
  String get userGuide => 'دليل المستخدم';

  @override
  String get guidedTour => 'جولة تعريفية';

  @override
  String get account => 'الحساب';

  @override
  String get language => 'اللغة';

  @override
  String get firstDayOfWeek => 'بداية الأسبوع';

  @override
  String get defaultCalendar => 'التقويم الافتراضي';

  @override
  String groupIdLabel(String id) {
    return 'معرف المجموعة: $id';
  }

  @override
  String get create => 'إنشاء';

  @override
  String get join => 'انضمام';

  @override
  String get joiningGroup => 'جارٍ الانضمام...';

  @override
  String failedToJoin(String error) {
    return 'فشل الانضمام: $error';
  }

  @override
  String get everyDay => 'كل يوم';

  @override
  String get everyWeek => 'كل أسبوع';

  @override
  String get everyMonth => 'كل شهر';

  @override
  String get cannotCreatePastEvent => 'لا يمكن إنشاء حدث في الماضي';

  @override
  String failedToSave(String error) {
    return 'فشل الحفظ: $error';
  }

  @override
  String get deleteRecurringEvent => 'حذف حدث متكرر';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String get deleteEvent => 'حذف الحدث';

  @override
  String deleteConfirmation(String title) {
    return 'حذف \"$title\"؟';
  }

  @override
  String get day => 'يوم';

  @override
  String get week => 'أسبوع';

  @override
  String get month => 'شهر';

  @override
  String get delete => 'حذف';

  @override
  String get error => 'خطأ';

  @override
  String get groupCalendar => 'تقويم المجموعة';

  @override
  String shareGroupMessage(String id, String link) {
    return 'انضم إلى مجموعتي في التقويم المشترك!\n\nمعرف المجموعة: $id\nاستخدم هذا المعرف للانضمام عبر التطبيق.\n\nالرابط: $link';
  }

  @override
  String get today => 'اليوم';

  @override
  String get enterValidEmail => 'أدخل بريداً إلكترونياً صالحاً';

  @override
  String get passwordLengthError => 'كلمة المرور يجب أن تكون 6 أحرف أو أكثر';

  @override
  String get createAccount => 'إنشاء حساب جديد';

  @override
  String get haveAccountLogin => 'لديك حساب؟ تسجيل دخول';

  @override
  String get signUp => 'تسجيل جديد';

  @override
  String membersCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString عضو',
      many: '$countString عضواً',
      few: '$countString أعضاء',
      two: 'عضوان',
      one: 'عضو واحد',
      zero: 'لا يوجد أعضاء',
    );
    return '$_temp0';
  }

  @override
  String get theme => 'المظهر';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get darkMode => 'الوضع الداكن';
}
