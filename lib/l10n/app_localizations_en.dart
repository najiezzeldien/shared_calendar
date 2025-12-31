// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Shared Calendar';

  @override
  String get dayView => 'Day View';

  @override
  String get weekView => 'Week View';

  @override
  String get monthView => 'Month View';

  @override
  String get myGroups => 'My Groups';

  @override
  String get logout => 'Logout';

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get register => 'Register';

  @override
  String get createGroup => 'Create Group';

  @override
  String get groupName => 'Group Name';

  @override
  String get joinGroup => 'Join Group';

  @override
  String get eventTitle => 'Event Title';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get repeats => 'Repeats';

  @override
  String get doesNotRepeat => 'Does not repeat';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get color => 'Color';

  @override
  String get description => 'Description';

  @override
  String get addEvent => 'Add Event';

  @override
  String welcome(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get noGroupsYet => 'No groups yet. Create or join one!';

  @override
  String get search => 'Search';

  @override
  String get allCalendars => 'All Calendars';

  @override
  String get lastUpdated => 'Last updated';

  @override
  String get nextEvent => 'Next event';

  @override
  String get unread => 'Unread';

  @override
  String get archived => 'Archived';

  @override
  String get addYourName => 'Add your name';

  @override
  String get calendarAccounts => 'Add your Calendar accounts';

  @override
  String get settings => 'Settings';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get contactUs => 'Contact us';

  @override
  String get userGuide => 'User guide';

  @override
  String get guidedTour => 'Guided Tour';

  @override
  String get account => 'Account';

  @override
  String get language => 'Language';

  @override
  String get firstDayOfWeek => 'First Day Of Week';

  @override
  String get defaultCalendar => 'Default calendar';

  @override
  String groupIdLabel(String id) {
    return 'Group ID: $id';
  }

  @override
  String get create => 'Create';

  @override
  String get join => 'Join';

  @override
  String get joiningGroup => 'Joining Group...';

  @override
  String failedToJoin(String error) {
    return 'Failed to join group: $error';
  }

  @override
  String get everyDay => 'Every day';

  @override
  String get everyWeek => 'Every week';

  @override
  String get everyMonth => 'Every month';

  @override
  String get cannotCreatePastEvent => 'Cannot create event in the past';

  @override
  String failedToSave(String error) {
    return 'Failed to save: $error';
  }

  @override
  String get deleteRecurringEvent => 'Delete Recurring Event';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get deleteEvent => 'Delete Event';

  @override
  String deleteConfirmation(String title) {
    return 'Delete \"$title\"?';
  }

  @override
  String get day => 'Day';

  @override
  String get week => 'Week';

  @override
  String get month => 'Month';

  @override
  String get delete => 'Delete';

  @override
  String get error => 'Error';

  @override
  String get groupCalendar => 'Group Calendar';

  @override
  String shareGroupMessage(String id, String link) {
    return 'Join my group on Shared Calendar!\n\nGroup ID: $id\nUse this ID to join via the app.\n\nLink: $link';
  }

  @override
  String get today => 'Today';

  @override
  String get enterValidEmail => 'Enter a valid email';

  @override
  String get passwordLengthError => 'Password must be 6+ chars';

  @override
  String get createAccount => 'Create an account';

  @override
  String get haveAccountLogin => 'Have an account? Login';

  @override
  String get signUp => 'Sign Up';

  @override
  String membersCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString members',
      one: '1 member',
      zero: 'No members',
    );
    return '$_temp0';
  }

  @override
  String get theme => 'Theme';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';
}
