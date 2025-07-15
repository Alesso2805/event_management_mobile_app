import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ConnectionStatus extends StatelessWidget {
  final bool isConnected;
  final String message;
  final VoidCallback? onRetry;

  const ConnectionStatus({
    super.key,
    required this.isConnected,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isConnected ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isConnected ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isConnected ? Icons.check_circle : Icons.error,
            color: isConnected ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isConnected ? Colors.green[700] : Colors.red[700],
                fontSize: 14,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
          ),
          if (!isConnected && onRetry != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onRetry,
              child: const Text('Reintentar'),
            ),
          ],
        ],
      ),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final String message;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.message,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
