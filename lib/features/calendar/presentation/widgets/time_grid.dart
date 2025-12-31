import 'package:flutter/material.dart';
import '../../../calendar/domain/entities/event.dart';

class TimeGrid extends StatelessWidget {
  final DateTime day;
  final List<Event> events;
  final double hourHeight;
  final bool showTimeLabels;
  final Function(Event, DateTime)? onEventMoved;
  final Function(Event, DateTime)? onEventResized;
  final Function(Event)? onEventTap;

  const TimeGrid({
    super.key,
    required this.day,
    required this.events,
    this.hourHeight = 60.0,
    this.showTimeLabels = true,
    this.onEventMoved,
    this.onEventResized,
    this.onEventTap,
  });

  Color _getUserColor(String userId) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.brown,
      Colors.cyan,
    ];
    return colors[userId.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    // calculate layout
    final positionedEvents = _layoutEvents(events);

    return SingleChildScrollView(
      child: Stack(
        children: [
          // 1. Grid Lines
          Column(
            children: List.generate(24, (hour) {
              return SizedBox(
                height: hourHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showTimeLabels)
                      SizedBox(
                        width: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0, right: 8.0),
                          child: Text(
                            _formatHour(hour),
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),

          // Drag Target
          if (onEventMoved != null)
            Positioned.fill(
              left: showTimeLabels ? 60 : 0,
              child: DragTarget<Event>(
                builder: (context, candidates, rejects) =>
                    Container(color: Colors.transparent),
                onAcceptWithDetails: (details) => _handleDrop(context, details),
              ),
            ),

          // 2. Events
          ...positionedEvents.map((posEvent) {
            final event = posEvent.event;
            final top = _calculateTopOffset(event.startTime);
            final height = _calculateHeight(event.startTime, event.endTime);

            return Positioned(
              top: top,
              left: (showTimeLabels ? 60 : 0) + (posEvent.left * posEvent.availableWidth),
              width: posEvent.width * posEvent.availableWidth,
              height: height,
              child: _DraggableResizableEventTile(
                event: event,
                height: height,
                hourHeight: hourHeight,
                onEventMoved: onEventMoved,
                onEventResized: onEventResized,
                onEventTap: onEventTap,
                color: event.color != null
                    ? Color(event.color!)
                    : _getUserColor(event.createdBy),
              ),
            );
          }),

          // 3. Current Time Indicator
          if (_isToday(day))
            Positioned(
              top: _calculateTopOffset(DateTime.now()),
              left: showTimeLabels ? 50 : 0,
              right: 0,
              child: Row(
                children: [
                  if (showTimeLabels)
                    const CircleAvatar(radius: 4, backgroundColor: Colors.red),
                  Expanded(child: Container(height: 2, color: Colors.red)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Layout Logic
  List<_PositionedEventData> _layoutEvents(List<Event> events) {
    if (events.isEmpty) return [];

    // 1. Sort events by start time, then duration (longer first)
    final sortedEvents = List<Event>.from(events)..sort((a, b) {
      final startCompare = a.startTime.compareTo(b.startTime);
      if (startCompare != 0) return startCompare;
      return b.endTime.difference(b.startTime).compareTo(a.endTime.difference(a.startTime));
    });

    final List<_PositionedEventData> result = [];
    final List<List<Event>> clusters = [];

    // 2. Cluster events that overlap
    for (final event in sortedEvents) {
      bool placed = false;
      for (final cluster in clusters) {
        if (_eventsOverlapWithCluster(event, cluster)) {
          cluster.add(event);
          placed = true;
          break;
        }
      }
      if (!placed) {
        clusters.add([event]);
      }
    }

    // 3. Process each cluster
    for (final cluster in clusters) {
      // Column packing
      List<List<Event>> columns = [];
      for (final event in cluster) {
        bool placedInColumn = false;
        for (final column in columns) {
          if (!_eventOverlapsWithAnyInColumn(event, column)) {
            column.add(event);
            placedInColumn = true;
            break;
          }
        }
        if (!placedInColumn) {
          columns.add([event]);
        }
      }

      // Calculate width and left for each event in this cluster
      final numColumns = columns.length;
      
      for (int i = 0; i < numColumns; i++) {
        final column = columns[i];
        for (final event in column) {
            result.add(_PositionedEventData(
                event: event,
                left: i / numColumns,
                width: 1 / numColumns,
                availableWidth: 1.0, // Placeholder
            ));
        }
      }
    }
    return result;
  }

  bool _eventsOverlapWithCluster(Event event, List<Event> cluster) {
    for (final other in cluster) {
      if (event.startTime.isBefore(other.endTime) && other.startTime.isBefore(event.endTime)) {
        return true;
      }
    }
    return false;
  }

  bool _eventOverlapsWithAnyInColumn(Event event, List<Event> column) {
    for (final other in column) {
       if (event.startTime.isBefore(other.endTime) && other.startTime.isBefore(event.endTime)) {
        return true;
      }
    }
    return false;
  }

  void _handleDrop(BuildContext context, DragTargetDetails<Event> details) {
    if (onEventMoved == null) return;
    final renderBox = context.findRenderObject() as RenderBox;
    final localOffset = renderBox.globalToLocal(details.offset);
    final totalMinutes = (localOffset.dy / hourHeight) * 60;
    final snappedMinutes = (totalMinutes / 15).round() * 15;
    final newHour = (snappedMinutes / 60).floor();
    final newMinute = snappedMinutes % 60;

    if (newHour < 0 || newHour > 23) return;

    final newStartTime = DateTime(
      day.year,
      day.month,
      day.day,
      newHour,
      newMinute,
    );
    onEventMoved!(details.data, newStartTime);
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour == 12) return '12 PM';
    return hour > 12 ? '${hour - 12} PM' : '$hour AM';
  }

  double _calculateTopOffset(DateTime time) {
    return (time.hour * hourHeight) + ((time.minute / 60) * hourHeight);
  }

  double _calculateHeight(DateTime start, DateTime end) {
    final duration = end.difference(start).inMinutes;
    return (duration / 60) * hourHeight;
  }

  bool _isToday(DateTime day) {
    final now = DateTime.now();
    return day.year == now.year && day.month == now.month && day.day == now.day;
  }
}

class _PositionedEventData {
  final Event event;
  final double left; // Fraction 0.0 - 1.0
  final double width; // Fraction 0.0 - 1.0
  final double availableWidth; 

  _PositionedEventData({
    required this.event,
    required this.left,
    required this.width,
    required this.availableWidth,
  });
}

class _DraggableResizableEventTile extends StatefulWidget {
  final Event event;
  final double height;
  final double hourHeight;
  final Function(Event, DateTime)? onEventMoved;
  final Function(Event, DateTime)? onEventResized;
  final Function(Event)? onEventTap;
  final Color color;

  const _DraggableResizableEventTile({
    required this.event,
    required this.height,
    required this.hourHeight,
    this.onEventMoved,
    this.onEventResized,
    this.onEventTap,
    required this.color,
  });

  @override
  State<_DraggableResizableEventTile> createState() =>
      _DraggableResizableEventTileState();
}

class _DraggableResizableEventTileState
    extends State<_DraggableResizableEventTile> {
  late double _currentHeight;
  bool _isResizing = false;

  @override
  void initState() {
    super.initState();
    _currentHeight = widget.height;
  }

  @override
  void didUpdateWidget(covariant _DraggableResizableEventTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isResizing && oldWidget.height != widget.height) {
      _currentHeight = widget.height;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget tile = Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: widget.color.withValues(alpha: 0.2),
        border: Border(left: BorderSide(color: widget.color, width: 4)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (widget.event.recurrenceRule != null)
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(
                    Icons.repeat,
                    size: 12,
                    color: widget.color.withValues(alpha: 1.0),
                  ),
                ),
              Expanded(
                child: Text(
                  widget.event.title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: widget.color.withValues(alpha: 1.0),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (widget.event.description != null)
            Text(
              widget.event.description!,
              style: TextStyle(
                fontSize: 10,
                color: widget.color.withValues(alpha: 1.0),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          if (widget.event.creatorName != null)
            Text(
              widget.event.creatorName!,
              style: TextStyle(
                fontSize: 8,
                fontStyle: FontStyle.italic,
                color: widget.color.withValues(alpha: 0.8),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );

    if (widget.onEventTap != null) {
      tile = GestureDetector(
        onTap: () => widget.onEventTap!(widget.event),
        child: tile,
      );
    }

    // If we can't edit, just return the tile
    if (widget.onEventMoved == null && widget.onEventResized == null) {
      return tile;
    }

    final resizableTile = Stack(
      children: [
        // Body
        Positioned.fill(
          bottom: 10, // Leave room for handle
          child: tile,
        ),
        // Handle Visual
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 10,
          child: Container(
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
            alignment: Alignment.center,
            child: Container(
              width: 20,
              height: 4,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        // Resize Detector
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 20, // Larger hit area
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              setState(() {
                _isResizing = true;
                _currentHeight += details.delta.dy;
                // Minimum 15 mins (approx 15px if hour=60)
                if (_currentHeight < (widget.hourHeight / 4)) {
                  _currentHeight = widget.hourHeight / 4;
                }
              });
            },
            onVerticalDragEnd: (details) {
              setState(() {
                _isResizing = false;
              });

              if (widget.onEventResized != null) {
                // Calculate new duration
                final minutes = (_currentHeight / widget.hourHeight) * 60;
                // Snap to 15
                final snappedMinutes = (minutes / 15).round() * 15;

                final newEndTime = widget.event.startTime.add(
                  Duration(minutes: snappedMinutes),
                );

                widget.onEventResized!(widget.event, newEndTime);
              }
            },
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );

    // Apply height locally during resize
    final displayWidget = SizedBox(
      height: _isResizing ? _currentHeight : widget.height,
      child: resizableTile,
    );

    // If resizing, don't allow drag-move
    if (_isResizing) {
      return displayWidget;
    }

    return LongPressDraggable<Event>(
      data: widget.event,
      feedback: SizedBox(
        width: 200,
        height: widget.height,
        child: Opacity(opacity: 0.7, child: tile),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: tile),
      child: displayWidget,
    );
  }
}
