import 'package:flutter/material.dart';
import 'package:edex_365_getx/core/config/app_colors.dart';

class CustomDropdown<T> extends FormField<T> {
  CustomDropdown({
    Key? key,
    required String labelText,
    required List<CustomDropdownItem<T>> items,
    required void Function(T value) onChanged,
    String? selectedText,
    bool isLoading = false,
    bool enabled = true,
    String? hintText,
    double borderRadius = 12.0,
    EdgeInsetsGeometry? padding,
    String? Function(T?)? validator,
  }) : super(
          key: key,
          validator: validator,
          builder: (FormFieldState<T> state) {
            final theme = Theme.of(state.context);
            final isError = state.hasError;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (labelText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: RichText(
                      text: TextSpan(
                        text: labelText,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                        ),
                        children: [
                          if (validator != null)
                            const TextSpan(
                              text: ' *',
                              style: TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                    ),
                  ),
                _CustomDropdownInner<T>(
                  labelText: labelText,
                  items: items,
                  selectedText: selectedText,
                  isLoading: isLoading,
                  enabled: enabled,
                  hintText: hintText,
                  borderRadius: borderRadius,
                  padding: padding,
                  isError: isError,
                  onChanged: (value) {
                    state.didChange(value);
                    onChanged(value);
                  },
                ),
                if (isError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      state.errorText ?? '',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
}

class _CustomDropdownInner<T> extends StatefulWidget {
  final String labelText;
  final String? selectedText;
  final List<CustomDropdownItem<T>> items;
  final bool isLoading;
  final bool enabled;
  final String? hintText;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isError;
  final void Function(T value) onChanged;

  const _CustomDropdownInner({
    Key? key,
    required this.labelText,
    required this.items,
    required this.onChanged,
    this.selectedText,
    this.isLoading = false,
    this.enabled = true,
    this.hintText,
    this.borderRadius = 12.0,
    this.padding,
    this.isError = false,
  }) : super(key: key);

  @override
  State<_CustomDropdownInner<T>> createState() =>
      _CustomDropdownInnerState<T>();
}

class _CustomDropdownInnerState<T> extends State<_CustomDropdownInner<T>> {
  bool _isFocused = false;
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isTapped = true),
      onTapUp: (_) => setState(() => _isTapped = false),
      onTapCancel: () => setState(() => _isTapped = false),
      onTap: widget.isLoading || !widget.enabled
          ? null
          : () {
              setState(() {
                _isFocused = true;
              });
              _showPicker(context);
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isTapped ? 0.99 : 1.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: (isDark
                              ? AppColors.darkPrimary
                              : AppColors.primary)
                          .withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: InputDecorator(
            decoration: InputDecoration(
              contentPadding: widget.padding ??
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              filled: true,
              fillColor: theme.colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(
                  color: theme.dividerColor,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(
                  color: isDark
                      ? AppColors.darkPrimary
                      : AppColors.primary,
                  width: 2.0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(
                  color: theme.colorScheme.error,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(
                  color: theme.colorScheme.error,
                  width: 1.5,
                ),
              ),
              errorText: widget.isError ? '' : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.isLoading
                        ? 'Loading...'
                        : widget.selectedText ??
                            widget.hintText ??
                            'Select ${widget.labelText}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: widget.selectedText == null
                          ? theme.hintColor
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                Icon(
                  _isFocused ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select ${widget.labelText}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    return ListTile(
                      title: Text(item.label),
                      onTap: () {
                        widget.onChanged(item.value);
                        Navigator.pop(context);
                        setState(() => _isFocused = false);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        _isFocused = false;
        _isTapped = false;
      });
    });
  }
}

class CustomDropdownItem<T> {
  final String label;
  final T value;

  CustomDropdownItem({required this.label, required this.value});
}
