import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Reusable quantity input field with +/- buttons
class QuantityInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final int min;
  final int? max;
  final ValueChanged<int>? onChanged;

  const QuantityInputField({
    super.key,
    required this.controller,
    this.label,
    this.min = 1,
    this.max,
    this.onChanged,
  });

  int get _currentValue => int.tryParse(controller.text) ?? min;

  void _increment() {
    final newValue = _currentValue + 1;
    if (max == null || newValue <= max!) {
      controller.text = newValue.toString();
      onChanged?.call(newValue);
    }
  }

  void _decrement() {
    final newValue = _currentValue - 1;
    if (newValue >= min) {
      controller.text = newValue.toString();
      onChanged?.call(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(label!, style: Theme.of(context).textTheme.bodySmall),
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _RoundButton(icon: Icons.remove, onPressed: _decrement),
            const SizedBox(width: 8),
            SizedBox(
              width: 64,
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  final parsed = int.tryParse(value);
                  if (parsed != null) onChanged?.call(parsed);
                },
              ),
            ),
            const SizedBox(width: 8),
            _RoundButton(icon: Icons.add, onPressed: _increment),
          ],
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _RoundButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: IconButton.filled(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
