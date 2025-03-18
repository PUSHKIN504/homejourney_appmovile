import 'package:flutter/material.dart';

class AlertHelper {
  static void showAlert({
    required BuildContext context,
    required String title,
    required String message,
    required bool isSuccess,
    Duration duration = const Duration(seconds: 3),
  }) {
    _dismissCurrentAlert(context);
    
    final overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry;
    
    overlayEntry = OverlayEntry(
      builder: (context) => AlertOverlay(
        title: title,
        message: message,
        isSuccess: isSuccess,
        onDismiss: () {
          overlayEntry?.remove();
        },
      ),
    );
    
    overlayState.insert(overlayEntry);
    
    Future.delayed(duration, () {
      overlayEntry?.remove();
    });
  }
  
  static void _dismissCurrentAlert(BuildContext context) {
  }
}

class AlertOverlay extends StatefulWidget {
  final String title;
  final String message;
  final bool isSuccess;
  final VoidCallback onDismiss;
  
  const AlertOverlay({
    super.key,
    required this.title,
    required this.message,
    required this.isSuccess,
    required this.onDismiss,
  });

  @override
  State<AlertOverlay> createState() => _AlertOverlayState();
}

class _AlertOverlayState extends State<AlertOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDismiss,
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FadeTransition(
                opacity: _animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -1),
                    end: Offset.zero,
                  ).animate(_animation),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: widget.isSuccess 
                          ? Colors.green.shade800 
                          : Colors.red.shade800,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(
                              widget.isSuccess 
                                  ? Icons.check_circle 
                                  : Icons.error,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: widget.onDismiss,
                              child: const Icon(
                                Icons.close,
                                color: Colors.white70,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        if (widget.message.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.message,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

