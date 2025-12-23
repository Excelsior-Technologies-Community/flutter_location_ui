import 'package:flutter/material.dart';

class LocationInfoCard extends StatelessWidget {
  final String address;
  final bool loading;
  final VoidCallback onConfirm;

  const LocationInfoCard({
    super.key,
    required this.address,
    required this.loading,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Selected Location",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              loading
                  ? const CircularProgressIndicator(strokeWidth: 2)
                  : Text(address),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onConfirm,
                  child: const Text("Confirm Location"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
