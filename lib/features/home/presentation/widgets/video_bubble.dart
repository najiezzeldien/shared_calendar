import 'package:flutter/material.dart';

class VideoBubble extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onExpand;

  const VideoBubble({super.key, required this.onClose, required this.onExpand});

  @override
  State<VideoBubble> createState() => _VideoBubbleState();
}

class _VideoBubbleState extends State<VideoBubble> {
  Offset position = const Offset(20, 100);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        feedback: _buildBubbleContent(),
        childWhenDragging: Container(),
        onDragEnd: (details) {
          setState(() {
            // Constrain within screen bounds (roughly)
            final size = MediaQuery.of(context).size;
            double dx = details.offset.dx.clamp(0.0, size.width - 120);
            double dy = details.offset.dy.clamp(0.0, size.height - 200);
            position = Offset(dx, dy);
          });
        },
        child: _buildBubbleContent(),
      ),
    );
  }

  Widget _buildBubbleContent() {
    return Material(
      color: Colors.transparent,
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 120,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
          image: const DecorationImage(
            image: NetworkImage(
              'https://placeholder.com/video-thumbnail',
            ), // Mock
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: Stack(
          children: [
            // Close Button
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
            // Play Icon (Center)
            Center(
              child: IconButton(
                icon: const Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: widget.onExpand,
              ),
            ),
            // Bottom Info
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: const Text(
                "Event Preview",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
