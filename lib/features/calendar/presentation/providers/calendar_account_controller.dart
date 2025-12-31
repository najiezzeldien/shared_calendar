import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_calendar/features/calendar/data/repositories/device_calendar_repository.dart';

part 'calendar_account_controller.g.dart';

@riverpod
class CalendarAccountController extends _$CalendarAccountController {
  @override
  FutureOr<void> build() {
    // Initial state is void, we just want to track operation status
  }

  Future<void> connectAccount(String accountType) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(deviceCalendarRepositoryProvider);
      final hasPermissions = await repository.requestPermissions();

      if (!hasPermissions) {
        throw Exception('Permissions denied');
      }

      // In a real app with direct API integrations, we would OAuth here based on accountType.
      // Since we rely on the OS's device calendar, requesting permissions is usually enough
      // to "connect" all accounts present on the device.

      // We could optionally filter calendars by account type if the plugin returns that metadata,
      // but for now, we assume success means we can see them.

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
