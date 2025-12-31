import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/event.dart';

abstract interface class EventsRepository {
  Future<Either<Failure, Event>> createEvent({
    required String groupId,
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    required String userId,
    String? creatorName,
    String? recurrenceRule,
    int? color,
  });

  Future<Either<Failure, List<Event>>> getGroupEvents(String groupId);

  Future<Either<Failure, void>> deleteEvent(String eventId);

  Future<Either<Failure, Event>> getEvent(String eventId);

  Future<Either<Failure, Event>> updateEvent(Event event);
}
