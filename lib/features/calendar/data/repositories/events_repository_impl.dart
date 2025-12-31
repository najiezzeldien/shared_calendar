import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_calendar/features/calendar/data/models/event_model.dart';
import 'package:shared_calendar/features/calendar/domain/entities/event.dart';
import 'package:shared_calendar/features/calendar/domain/repositories/events_repository.dart';

import '../../../../core/errors/failures.dart';

class EventsRepositoryImpl implements EventsRepository {
  final FirebaseFirestore _firestore;

  EventsRepositoryImpl(this._firestore);

  @override
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
  }) async {
    try {
      final eventsCollection = _firestore
          .collection('groups')
          .doc(groupId)
          .collection('events');

      // Conflict Detection
      // Query events that end after the new start time
      final potentialConflicts = await eventsCollection
          .where('endTime', isGreaterThan: Timestamp.fromDate(startTime))
          .get();

      // Client-side filter for start time to find overlap
      // Overlap condition: ExistingStart < NewEnd
      final hasConflict = potentialConflicts.docs.any((doc) {
        final event = EventModel.fromJson(doc.data());
        return event.startTime.isBefore(endTime);
      });

      if (hasConflict) {
        return const Left(
          ServerFailure('Event conflicts with an existing event.'),
        );
      }

      final newEventDoc = eventsCollection.doc();
      final now = DateTime.now();

      final event = EventModel(
        id: newEventDoc.id,
        groupId: groupId,
        title: title,
        description: description,
        startTime: startTime,
        endTime: endTime,
        createdBy: userId,
        creatorName: creatorName,
        createdAt: now,
        recurrenceRule: recurrenceRule,
        color: color,
      );

      await newEventDoc.set(event.toJson());

      return Right(event.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent(String eventId) async {
    // Note: To delete a subcollection document, we technically need the groupId path.
    // If the interface only provides eventId, we either need to know the groupId or query for it.
    // Since we put events in /groups/{groupId}/events, checking for just eventId globally
    // requires a Collection Group Query or passing groupId.
    // For now, assuming we might need to change the interface or use Collection Group Query to find it.
    // Let's assume we can find it via Collection Group Query for 'events' where 'id' == eventId.
    try {
      final query = await _firestore
          .collectionGroup('events')
          .where('id', isEqualTo: eventId)
          .get();
      if (query.docs.isEmpty) {
        return const Left(ServerFailure('Event not found'));
      }
      await query.docs.first.reference.delete();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getGroupEvents(String groupId) async {
    try {
      final snapshot = await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('events')
          .orderBy('startTime')
          .get();

      final events = snapshot.docs
          .map((doc) => EventModel.fromJson(doc.data()).toEntity())
          .toList();

      return Right(events);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Event>> getEvent(String eventId) async {
    try {
      final query = await _firestore
          .collectionGroup('events')
          .where('id', isEqualTo: eventId)
          .get();

      if (query.docs.isEmpty) {
        return const Left(ServerFailure('Event not found'));
      }
      return Right(EventModel.fromJson(query.docs.first.data()).toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Event>> updateEvent(Event event) async {
    try {
      // Conflict Detection (excluding itself)
      final eventsCollection = _firestore
          .collection('groups')
          .doc(event.groupId)
          .collection('events');

      final potentialConflicts = await eventsCollection
          .where('endTime', isGreaterThan: Timestamp.fromDate(event.startTime))
          .get();

      final hasConflict = potentialConflicts.docs.any((doc) {
        if (doc.id == event.id) return false; // Exclude self
        final existingEvent = EventModel.fromJson(doc.data());
        return existingEvent.startTime.isBefore(event.endTime);
      });

      if (hasConflict) {
        return const Left(
          ServerFailure('Event conflicts with an existing event.'),
        );
      }

      final docRef = eventsCollection.doc(event.id);
      final eventModel = EventModel.fromEntity(event);
      await docRef.update(eventModel.toJson());

      return Right(event);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
