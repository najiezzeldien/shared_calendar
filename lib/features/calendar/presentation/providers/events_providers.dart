import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_calendar/core/di/firebase_providers.dart';
import '../../domain/repositories/events_repository.dart';
import '../../data/repositories/events_repository_impl.dart';

part 'events_providers.g.dart';

@riverpod
EventsRepository eventsRepository(Ref ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return EventsRepositoryImpl(firestore);
}
